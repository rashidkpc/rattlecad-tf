#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # tubeMiter.tcl
 #
 #   tubeMiter is software of Manfred ROSENBERGER
 #       based on tclTk and its own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2016/01/01
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 
 #
 # 0.01 2016-01-04   new: coneMiter, many thanks to Peter Dalhoff
 # 0.04 2017-05-01   new: coneMiter, many thanks to Peter Dalhoff
 # 0.10 2018-01-02   refactor: complete change of library
 #
 #
 
 
  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################
  

package provide tubeMiter 0.12

package require vectormath 1.00

namespace eval tubeMiter {
        #
    variable CONST_PI [expr {acos(-1.0)}]
        #
        # ---- createMiter
    variable packageHomeDir [file dirname [file normalize [info script]]]
        #
        # puts "       tubeMiter -> \$packageHomeDir $packageHomeDir"
    lappend auto_path [file join $packageHomeDir app createMiter]
    package require tubeMiter_createMiter    
        #
}
    #
    #
    # -- the tclOO implementation of TubeMiter
    #
proc tubeMiter::createMiter {{miterType {}}} {
        #
    switch -exact $miterType {
        cone {      return [tubeMiter::ConeMiter     new]}
        cylinder {  return [tubeMiter::CylinderMiter new]}
        frustum {   return [tubeMiter::FrustumMiter  new]}
        plane -     
        default {   return [tubeMiter::PlaneMiter    new]}
    }
        #
}    
    #
    #
    # -- the old implementation of TubeMiter
    #
#-------------------------------------------------------------------------
    #  create coneMiter
    #
    #                              
    #                                |<-->|  frustum_TopRadius [mm]
    #                                |    | 
    #                           + -- +----+ 
    #                           |    |    | 
    #                           |    |    | 
    #                           +----+----+  -------------------------
    #          miterAngle [°]  /     |     \                        ^
    #                         /      |      \                       |
    #         -----   +------+       |       \                      |
    #          ^     /\       +      |        \                     |
    #          |     \/        +     |         \                    | 
    #          |   - / - - - - + - - o -        \  -----------      |
    #          |     |        +      |           \          ^       | frustum_Height [mm]
    #          V     \      +        |            \         |       |
    #         -----   +-+ °          |             \        | hks   |   
    #    tubeRadius    /             |              \       |       |
    #       [mm]      /              |               \      V       V
    #                +---------------+----------------+  -------------
    #                |               |                |
    #                |               |                |
    #                +---------------+----------------+
    #                                |                |
    #                                |<-------------->|  frustum_BaseRadius [mm]
    #                              
    #
    # ... with many thanks to 
    #                      Peter Dalhoff
    #
    #
proc tubeMiter::coneMiter {frustum_BaseRadius frustum_TopRadius frustum_Height tubeRadius miterAngle hks} {
        #
        # coneMiter $frustum_BaseRadius $frustum_TopRadius $frustum_Height $tubeRadius $miterAngle $hks
        #     ... previous   {R_Frustum_Base R_Frustum_Top H_Frustum R_Tube alpha hks}
        #
        #   frustum_BaseRadius ... Radius des Kegelstumpf unten
        #   frustum_TopRadius .... Radius des Kegelstumpf oben
        #   frustum_Height ....... Höhe des Kegelstumpf    
        #
        #   tubeRadius ........... Radius Zylinder in mm
        #   miterAngle ................ Schnittwinkel in grad (FrustumTop -> Joint <- Tube)
        #   hks .................. Höhe von Kegelfuß bis Achsenschnittpunkt
        #
        #
        # puts "tubeMiter::coneMiter: \$frustum_BaseRadius    $frustum_BaseRadius"
        # puts "tubeMiter::coneMiter: \$frustum_TopRadius     $frustum_TopRadius"
        # puts "tubeMiter::coneMiter: \$frustum_Height        $frustum_Height"
        # puts "tubeMiter::coneMiter: \$tubeRadius            $tubeRadius"
        # puts "tubeMiter::coneMiter: \$miterAngle            $miterAngle"
        # puts "tubeMiter::coneMiter: \$hks                   $hks"   
        #
        #
    set PI [expr {4*atan(1)}]
        #
        # input - data
        #
    set frustum_BaseRadius  [expr {1.0 * $frustum_BaseRadius}]
    set frustum_TopRadius   [expr {1.0 * $frustum_TopRadius}]
    set frustum_Height      [expr {1.0 * $frustum_Height}]
        #
    set tubeRadius          [expr {1.0 * $tubeRadius}]        ;# Radius Zylinder in mm
        #
    set alpha               [expr {$miterAngle * $PI / 180}]  ;# Schnittwinkel in rad
    set hks                 [expr {1.0 * $hks}]               ;# Höhe von Kegelfuß bis Achsenschnittpunkt
        #
        # - exception
        #
    set switchException  0
        #
        # puts "   -> \$miterAngle $miterAngle"
    if {$miterAngle == 0 || $miterAngle == 180} {
        set switchException  1
    }   
        # puts "   -> \$switchException $switchException"
        #
        #
        # Kegelhöhe
    set coneHeight [expr {$frustum_BaseRadius * $frustum_Height / ($frustum_BaseRadius - $frustum_TopRadius)}]
        #
        # puts "tubeRadius:         [format {%3.8f} $tubeRadius]"
        # puts "alpha:              [format {%3.8f} $alpha]"
        # puts "hks:                [format {%3.8f} $hks]"
        # puts "frustum_BaseRadius: [format {%3.8f} $frustum_BaseRadius]"
        # puts "frustum_TopRadius:  [format {%3.8f} $frustum_TopRadius]"
        # puts "frustum_Height:     [format {%3.8f} $frustum_Height]"
        # puts "coneHeight:         [format {%3.8f} $coneHeight]"
        # puts "\n"
        #
    set borderTop       [expr {$frustum_Height - $hks}]    
    set borderBottom    [expr {0 - $hks}]    
        #
        #
    set seg01_dictionary    [__cylinderMiter $frustum_TopRadius              $tubeRadius $miterAngle]
    set seg02_dictionary    [__coneMiter     $frustum_BaseRadius $coneHeight $tubeRadius $miterAngle $hks]
    set seg03_dictionary    [__cylinderMiter $frustum_BaseRadius             $tubeRadius $miterAngle]
        #
        # -- tubeMiter - xy view (side View)
        #
        # puts "\n -- \$seg01_dictionary"
        # appUtil::pdict $seg01_dictionary    
        # puts "\n -- \$seg02_dictionary"
        # appUtil::pdict $seg02_dictionary    
        # puts "\n -- \$seg03_dictionary"
        # appUtil::pdict $seg03_dictionary    

        #
    set i 0
    set seg01_profile   {}
    set seg01_miterLeft  {}
    set seg01_miterRight {}
    foreach key [dict keys $seg01_dictionary] {
        incr i
        set keyDict [dict get $seg01_dictionary $key]
        set a [dict get $keyDict phi_grd]   ;# miter-rotation angle
        set p [dict get $keyDict perimeter] ;# perimeter
        set x [dict get $keyDict x]         ;# radius projection
        set y [dict get $keyDict z]         ;# miter offset
        set z [dict get $keyDict zTool]     ;# z of Cone-Tool
            #
        if {$borderTop <= $z} {
            if {$a >= 0} {
                # puts "   -> 1 -- [format {%03d} $i] --> [format {%3.3f} $a] --- ?? -- $borderTop <= $z ---"
                lappend seg01_profile       [list $x $y]
                lappend seg01_miterRight    [list $p $y]
            } else {
                lappend seg01_miterLeft     [list $p $y]
            }
        }
    }
        #
    set i 0
    set seg02_profile       {}
    set seg02_miterLeft     {}
    set seg02_miterRight    {}
    set seg02_fullProfile   {}
    foreach key [dict keys $seg02_dictionary] {
        incr i
        set keyDict [dict get $seg02_dictionary $key]
        set a [dict get $keyDict phi_grd]   ;# miter-rotation angle
        set p [dict get $keyDict perimeter] ;# perimeter
        set x [dict get $keyDict x]         ;# radius projection
        set y [dict get $keyDict z]         ;# miter offset
        set z [dict get $keyDict zTool]     ;# z of Cone-Tool
            #
        if {$borderBottom <= $z && $z <= $borderTop} {
            if {$a >= 0} {
                # puts "   -> 2 -- [format {%03d} $i] --> [format {%3.3f} $a] --- ?? -- $borderBottom <= $z <= $borderTop ---"
                lappend seg02_profile       [list $x $y]
                lappend seg02_miterRight    [list $p $y]
            } else {
                lappend seg02_miterLeft     [list $p $y]
            }
        }
        if {$a >= 0} {
                lappend seg02_fullProfile   [list $x $y]
        }
    }
        #
    set i 0
    set seg03_profile    {}
    set seg03_miterLeft  {}
    set seg03_miterRight {}
    foreach key [dict keys $seg03_dictionary] {
        incr i
        set keyDict [dict get $seg03_dictionary $key]
        set a [dict get $keyDict phi_grd]   ;# miter-rotation angle
        set p [dict get $keyDict perimeter] ;# perimeter
        set x [dict get $keyDict x]         ;# radius projection
        set y [dict get $keyDict z]         ;# miter offset
        set z [dict get $keyDict zTool]     ;# z of Cone-Tool
            #
        if {$z <= $borderBottom} {
            if {$a >= 0} {
                # puts "   -> 3 -- [format {%03d} $i] --> [format {%3.3f} $a] --- ?? -- $z <= $borderBottom ---"
                lappend seg03_profile       [list $x $y]
                lappend seg03_miterRight    [list $p $y]
            } else {
                lappend seg03_miterLeft     [list $p $y]
            }
        }
    }
        #
        # puts "  -> \$seg01_profile      $seg01_profile"    
        # puts "  -> \$seg02_profile      $seg02_profile"    
        # puts "  -> \$seg03_profile      $seg03_profile"
        #
    set seg02_fullProfile   [vectormath::rotateCoordList {0 0} [join "$seg02_fullProfile" " "] 270]
        #
        #
        # -- merge tubeProfile
    set tubeProfile         [join "[lreverse $seg03_profile] [lreverse $seg02_profile] [lreverse $seg01_profile]" " "]
    set tubeProfile         [vectormath::rotateCoordList {0 0} $tubeProfile 270]
        #
        #
        # -- merge tubeMiter
        #
    set tubeMiter       [join "$seg03_miterLeft $seg02_miterLeft $seg01_miterLeft $seg01_miterRight $seg02_miterRight $seg03_miterRight" " "]
        #
        #
        # puts "  -> \$seg01_profile      [llength $seg01_profile]"    
        # puts "  -> \$seg02_profile      [llength $seg02_profile]"    
        # puts "  -> \$seg03_profile      [llength $seg03_profile]"
        # puts "  -> \$tubeProfile        [llength $tubeProfile]  - $tubeProfile"
        # puts "  -> \$seg02_tubeMiter    $seg02_tubeMiter"    
        # puts "  -> \$seg02_tubeProfile  $seg02_tubeProfile"    
        # puts "  -> \$tubeProfile        $tubeProfile"    
        # puts "  -> \$tubeMiter          $tubeMiter"    
        #
        #
    return [list $tubeMiter $tubeProfile $seg02_fullProfile]    
        # return [list $seg02_tubeMiter $tubeProfile $seg02_tubeProfile]    
        # return [list $seg02_tubeMiter $seg02_tubeProfile $tubeProfile]    
        #
}
    #
    #
#-------------------------------------------------------------------------
    #  create coneMiter
    #
    #                              
    #                                A  ------------------------------
    #                               /|\                             A
    #                              / | \                            |
    #                             /  |  \                           |
    #                            /   |   \                          |
    #                           /    |    \                         |
    #          miterAngle [°]  /     |     \                        |
    #                         /      |      \                       |
    #         -----   +------+       |       \                      | coneHeight [mm]
    #          A     /\       +      |        \                     |
    #          |     \/        +     |         \                    | 
    #          |   - / - - - - + - - o -        \  -----------      |
    #          |     |        +      |           \          A       | 
    #          V     \      +        |            \         |       |
    #         -----   +-+ °          |             \        | hks   |   
    #    tubeRadius    /             |              \       |       |
    #       [mm]      /              |               \      V       V
    #                +---------------+----------------+  -------------
    #                                |                |
    #                                |<-------------->|  baseRadius [mm]
    #                              
    #
    # ... with many thanks to 
    #                      Peter Dalhoff
    #
    #
proc tubeMiter::__coneMiter {baseRadius coneHeight tubeRadius miterAngle hks} {
        #
        # __coneMiter $baseRadius $coneHeight $tubeRadius $miterAngle $hks
        #
        #   baseRadius .... Radius des Kegelstumpf unten
        #   coneHeight .... Höhe des Kegelstumpf    
        #
        #   tubeRadius ....Radius Zylinder in mm
        #   miterAngle ....Schnittwinkel in grad (FrustumTop -> Joint <- Tube)
        #   hks ...........Höhe von Kegelfuß bis Achsenschnittpunkt
        #
        #
        # puts "tubeMiter::coneMiter: \$baseRadius    $baseRadius"
        # puts "tubeMiter::coneMiter: \$coneHeight        $coneHeight"
        # puts "tubeMiter::coneMiter: \$tubeRadius            $tubeRadius"
        # puts "tubeMiter::coneMiter: \$miterAngle            $miterAngle"
        # puts "tubeMiter::coneMiter: \$hks                   $hks"   
        #
        #
    set PI [expr {4*atan(1)}]
        #
        # input - data
        #
    set baseRadius  [expr {1.0 * $baseRadius}]
    set coneHeight  [expr {1.0 * $coneHeight}]
        #
    set tubeRadius  [expr {1.0 * $tubeRadius}]        ;# Radius Zylinder in mm
        #
    set alpha       [expr {$miterAngle * $PI / 180}]  ;# Schnittwinkel in rad
    set hks         [expr {1.0 * $hks}]               ;# Höhe von Kegelfuß bis Achsenschnittpunkt
        #
        # - exception
        #
    set switchException  0
        #
        # puts "   -> \$miterAngle $miterAngle"
    if {$miterAngle == 0 || $miterAngle == 180} {
        set switchException  1
    }   
        # puts "   -> \$switchException $switchException"
        #
        #
        # Dies wird umgerechnet in eine Funktion Kegelradius in Abhängigkeit der Koordinate z2. 
        # Zunächst Geradengleichung bestimmen
    set a2 [expr {$baseRadius + (0 - $baseRadius) * $hks / $coneHeight}]
    set b2 [expr {(0 - $baseRadius) / $coneHeight}]
        # puts "a2:                 [format {%3.8f} $a2]"
        # puts "b2:                 [format {%3.8f} $b2]"
        #
        # Wertebereich für Z2 ermitteln. 
        # Z2 läuft entlang der Kegelachse vom Achsenschnittpunkt aus positiv nach oben
        # Z1 läuft entlang der Zylinderachse. Vom Achsenschnittpunkt aus von links nach 
        # rechts ist positiv. Daher werden im Ergebnis negative Werte ausgespuckt, denn 
        # die Schnittkurve liegt ja links vom Achsenschnittpunkt. 
        # Oberer Sattelpunkt
        #
        # set Z2_top [expr (0 + $tubeRadius / sin($alpha)) + (0  / tan($alpha))]
    set Z2_top [expr {(   $tubeRadius+$a2*cos($alpha))/(-1*$b2*cos($alpha)+sin($alpha))}]
        # unterer Sattelpunkt
    set Z2_bot [expr {(-1*$tubeRadius+$a2*cos($alpha))/(-1*$b2*cos($alpha)+sin($alpha))}]
        #
        #
    set radius2_top     [expr {$baseRadius + ($hks + $Z2_top) * $b2}]
    set radius2_base    [expr {$baseRadius + ($hks + $Z2_bot) * $b2}]
        #
    # puts ""
    # puts "PI              [format {%3.8f} $PI]"
    # puts ""
    # puts "tubeRadius:   [format {%3.8f} $tubeRadius]"
    # puts "alpha:        [format {%3.8f} $alpha]"
    # puts "hks:          [format {%3.8f} $hks]"
    # puts "baseRadius:   [format {%3.8f} $baseRadius]"
    # puts "coneHeight:   [format {%3.8f} $coneHeight]"
    # puts "a2:           [format {%3.8f} $a2]"
    # puts "b2:           [format {%3.8f} $b2]"
    # puts ""
        #
        #
        # Durchführung der Berechnungen mit Hilfsebenen, die senkrecht zur Kegelachse verlaufen. 
        # Vom oberen Sattel bis zum unteren sind es nz2max+1 Hilfsebenen. 
        # Der Laufparameter dafür ist nz2 und zu jedem nz2 wird die entsprechende z2-Koordinate ermittelt, 
        #    also in welchem Abstand sich die Hilfsebene zum Achsenschnittpunkt befindet. 
        # Dabei wandert der Winkel PHI1 für den Zylinder zwischen 0 und PI. 
        # Später wird das Ganze gespiegelt, um den Bereich zwischen PI und 2*PI abzudecken. 
        # PHI1s ist eine Berechnung von PHI1, allerdings fehlt dort die korrekte Berücksichtigung des Quadranten, 
        #    da die Arkusfunktion dies nicht kann. 
        # In einem weiteren Schritt wird dann der Quadrant festgestellt, um auch Werte > PI/2 erhalten zu können.
        # PHI2 ist der Umlaufwinkel am Kegel, siehe auch Skizze in der theoretischen Herleitung. 
        #
    set nz2max 400
    set nz2max  80
    set nz2max  40
        # puts "\n"
        # puts "          \$nz2max .... $nz2max"
        # puts "          \$nz2 ....... $nz2"
        #
    array set Z1    {}
    array set Z2    {}
    array set PHI2  {}
    array set PHI1s {}
        #
        #
        #
    if $switchException {
                #
    } else {
            # puts "    -> build \$indexDictionary do ... $miterAngle"
        set indexDictionary [dict create]
            #
        set nz2 1
        while {$nz2 <= ($nz2max + 1)} {
                #
            set key [format "key_%06d" [expr {$nz2max + 2 - $nz2}]]
                #
                # Z2(nz2)=Z2_top-(nz2-1)/nz2max*(Z2_top-Z2_bot);
            set Z2($nz2)        [expr {$Z2_top - (1.0*$nz2-1) / $nz2max * ($Z2_top - $Z2_bot)}]
                #
            set Z2_Radius   [expr {0 + ($Z2($nz2)-$a2)*$b2}]
            set Z1_Power    [expr {pow(($a2+$b2*$Z2($nz2)),2) + pow($Z2($nz2),2)- pow($tubeRadius,2)}]
                #
                # -- handle negagtive Value of Z1_Power if tube is not cut completely by cone
            if {$Z1_Power < 0} {
                set switchException 1
                # puts "\n"
                # puts "          <E> switchException: $Z1_Power < 0"
                # puts "\n"
                break
            }
                #
                # Z1(nz2)=-sqrt((a2+b2*Z2(nz2))^2+Z2(nz2)^2-tubeRadius^2);
            set Z1($nz2)        [expr {-1 * sqrt($Z1_Power)}]
                # PHI2(nz2)=acos((-Z2(nz2)*cos(alpha)-Z1(nz2))/((a2+b2*Z2(nz2))*sin(alpha)));
            set value           [expr {(-1 * $Z2($nz2) * cos($alpha) - $Z1($nz2)) / (($a2 + $b2 * $Z2($nz2)) * sin($alpha))}]
            if {$value < -1 || $value > 1} {
                set roundedValue [format {%3.8f} $value]
                if {abs($roundedValue) > 1.0} {
                    # puts "\n"
                    # puts "          <E> tcl expr error: $value"
                    # puts "\n"
                    set switchException 1
                    break
                } else {
                    #puts "          <I> tcl expr error: $value"
                    set value $roundedValue
                }
            }
                # puts "   <D> $value"
            set PHI2($nz2)      [expr {acos($value)}]
                #
            set zTool           [expr {1.0 * $Z2($nz2)}]    
                #
            dict set indexDictionary $key tool  radius  $Z2_Radius
            dict set indexDictionary $key tool  phi_rad $PHI2($nz2)
            dict set indexDictionary $key tool  z       $zTool
                # dict set indexDictionary $key tool  z       [expr $hks + $Z2($nz2)]
                #
                # PHI1s(nz2)=asin((a2+b2*Z2(nz2))*sin(PHI2(nz2))/tubeRadius);
                # PHI1s(nz2)=asin($argument/tubeRadius);    # 20170531
            set argument        [expr {($a2 + $b2 * $Z2($nz2)) * sin($PHI2($nz2))}]
                # set PHI1s($nz2)     [expr asin(($a2 + $b2 * $Z2($nz2)) * sin($PHI2($nz2)) / $tubeRadius)]
                # error handling on exactness of calculation of $argument
            if {$argument > $tubeRadius} {
                set argument $tubeRadius
            }
            set PHI1s($nz2)     [expr {asin($argument / $tubeRadius)}]
                #
            if {$nz2 > 2} {
                set nz2_1 [expr {$nz2 - 1}]
                set nz2_2 [expr {$nz2 - 2}]
            
                if {(2 * $PHI1($nz2_1) - $PHI1($nz2_2)) < $PI/2} {
                    set PHI1($nz2) $PHI1s($nz2)
                    # puts "[format {       -> %2d -> if: ..... %-3.12f} $nz2 $PHI1s($nz2)]"
                } else {
                    set PHI1($nz2) [expr {$PI - $PHI1s($nz2)}]
                    # puts "[format {       -> %2d -> else: ... %-3.12f  <- %-3.12f} $nz2 $PHI1s($nz2) $PHI1($nz2)]"
                }
            } else  {
                    set PHI1($nz2) $PHI1s($nz2)
                    # puts "[format {       -> %2d -> init: ... %-3.12f} $nz2 $PHI1s($nz2)]"
            }
                #

                #
                # - left
            dict set indexDictionary $key i             $nz2
            dict set indexDictionary $key z             $Z1($nz2)
            dict set indexDictionary $key phi_rad       $PHI1($nz2)
                #
                # end loop and incr nz2
            incr nz2
                #
        }
    }
        #
        # -- handle exception
        #
    if $switchException {
                #
                # puts "    -> build \$indexDictionary except $miterAngle"
                #
            set indexDictionary [dict create]
                #
            set z       [expr $tubeRadius / tan($alpha)]    
            set zTool   [expr $tubeRadius / sin($alpha)]    
                #
            set key [format "key_%06d" 0]
            dict set indexDictionary $key tool  radius  0
            dict set indexDictionary $key tool  phi     0
            dict set indexDictionary $key tool  z       [expr {-1.0 * $zTool}]
            dict set indexDictionary $key i             0
            dict set indexDictionary $key z             $z
            dict set indexDictionary $key phi_rad       [expr {-1.0 * $PI}]
            dict set indexDictionary $key phi_grd      -180
                #
            set key [format "key_%06d" 1]
            dict set indexDictionary $key tool  radius  0
            dict set indexDictionary $key tool  phi     0
            dict set indexDictionary $key tool  z       $zTool
            dict set indexDictionary $key i             1
            dict set indexDictionary $key z             [expr {-1.0 * $z}]
            dict set indexDictionary $key phi_rad       0
            dict set indexDictionary $key phi_grd       0
                #
                # appUtil::pdict $indexDictionary 2 "    "    
                #
    } 
        #
        #              
        #
    set miterDictionary [dict create]
        #   x ...   perpendicular to tube axis, in plane of tube- and cone axis
        #   y ...   perpendicular to tube x and y axis
        #   z ...   direction of tube axis
        #
    set i_key 0       
        #
        # -- miterDictionary [-PI - 0], left
        #
    foreach key [lsort [dict keys $indexDictionary]] {
            # 
        set phi_rad     [dict get $indexDictionary $key phi_rad]
        set z           [dict get $indexDictionary $key z]
        set zTool       [dict get $indexDictionary $key tool z]
            #
        set x           [expr {-1.0 * cos($phi_rad) * $tubeRadius}]
        set y           [expr {-1.0 * sin($phi_rad) * $tubeRadius}]
        set i_phi_rad   [expr {-1.0 * $phi_rad}]
        set i_phi_grd   [vectormath::grad $i_phi_rad]
        set i_perimeter [expr {$i_phi_rad * $tubeRadius}]
        if {abs($y) < 0.000000001} {set y 0}
            # puts "   -> $key -> $phi"
            # puts "                 - $z"
        dict set miterDictionary    [format "key_%06d" $i_key] \
                                        [list   x           $x \
                                                y           $y \
                                                z           $z \
                                                zTool       $zTool \
                                                phi_grd     $i_phi_grd \
                                                phi_rad     $i_phi_rad \
                                                perimeter   $i_perimeter]
        incr i_key
            #
    }
        #
        # appUtil::pdict $miterDictionary 2 "    "
        # puts "  -> \$miterDictionary - first"
        #
        # -- miterDictionary [0 - PI], left
        #
    foreach key [lreverse [dict keys $miterDictionary]] {
        set x           [dict get $miterDictionary $key x]
        set y           [dict get $miterDictionary $key y]
        set z           [dict get $miterDictionary $key z]
        set zTool       [dict get $miterDictionary $key zTool]
        set phi_rad     [dict get $miterDictionary $key phi_rad]
        set perimeter   [dict get $miterDictionary $key perimeter]
            #
        set i_y         [expr {-1.0 * $y}]
        set i_phi_rad   [expr {-1.0 * $phi_rad}]
        set i_phi_grd   [vectormath::grad $i_phi_rad]
        set i_perimeter [expr {$i_phi_rad * $tubeRadius}]
            #
        dict set miterDictionary    [format "key_%06d" $i_key] \
                                        [list   x           $x \
                                                y           $y \
                                                z           $z \
                                                zTool       $zTool \
                                                phi_grd     $i_phi_grd \
                                                phi_rad     $i_phi_rad \
                                                perimeter   $i_perimeter]
        incr i_key
    }
        # 
        # appUtil::pdict $miterDictionary 2 "    "
        # puts "  -> \$miterDictionary "
        # exit    
    return $miterDictionary    
        #    
}
    #
    #
#-------------------------------------------------------------------------
    #  create cylinderMiter
    #
    #                              
    #                           +--------+--------+
    #        miterAngle [°]     |        |        |
    #                           |        |        |
    #         ----    +---------+        |        |
    #          ^     /\          \       |        |
    #          |     \/           |      |        |
    #          |   - / - - - - - -+- - - o        |
    #          |     |            |      |        |
    #          V     \           /       |        |
    #         ----    +---------+        |        |
    #                           |        |        |
    #    tubeRadius [mm]        |        |        |
    #                           +--------+--------+
    #             right                  |        |
    #                                    |<------>|    toolRadius [mm]
    #                                       
    #
    #
    # from bikeGeometry::tube_intersection
    #
proc tubeMiter::__cylinderMiter { toolRadius tubeRadius miterAngle} {
    set retValue [tubeMiter::cylinderMiter $toolRadius $tubeRadius $miterAngle]
    return [lindex $retValue 3]
}
proc tubeMiter::cylinderMiter { toolRadius tubeRadius miterAngle {side {right}} {offset {0}}  {startAngle {0}}  {opposite {no}}} {
        #
        # side: 
        #       ... right: top view of tube, on the right end of the tube
        #       ... left:                 ... on the left end of the tube
        #
        #
    # puts " --< tubeMiter::cylinderMiter >--"
    # puts "             $toolRadius $tubeRadius $miterAngle $side $offset $startAngle $opposite"
        #
    if {$opposite != {no} } {
        set miterAngle    [expr {180 - $miterAngle}]
            # puts "       -> intersection_angle $miterAngle"
    }
        #
    set pi [expr {4*atan(1)}]
    set PI [expr {4*atan(1)}]
        #
    set indexDictionary [dict create]
    set miterDictionary [dict create]
        #
    set loops           144
    set angleIncr       [expr {360 / $loops}]
        #
    set angle           -180
    set toolMiter       {}
        #
    set zToolComplete  [expr {2 * $tubeRadius / cos([vectormath::rad $miterAngle])}]    
    set zTool          $zToolComplete    
        # b
    set i_key 0       
    while {$angle <= 180} {
                #
            set key [format "key_%06d" $i_key]
                #
                # puts "  -> \$angle $angle"
                #
            set rad_Angle   [vectormath::rad $angle]
            set i_perimeter [expr {2*$tubeRadius*$PI*$angle/360}]            ;# -- position on perimeter
                #
            set h           [expr {$offset + $tubeRadius*sin($rad_Angle)}]   ;# -- y-value perpendicular to plane of axis
            set x           [expr {-1.0 * $tubeRadius*cos($rad_Angle)}]      ;# -- x-value on circle in axis of tube and tool
                #
            if {[expr abs($toolRadius)] >= [expr abs($h)]} {
                set z  [expr {-1.0 * sqrt(pow($toolRadius,2) - pow($h,2))}]  ;# -- point on miter-curve based on perimeter position
            } else {
                set z  0                                                    ;# -- undefined for situations where point on circle does not cut sectioning tube
            }
                #
            set b 0    
                #
            if {[expr {abs($miterAngle)}] != 90.0} {
                set v1 [expr {$x / tan([vectormath::rad $miterAngle])}]       ;# -- tube - component of offset
                set v2 [expr {$z / sin([vectormath::rad $miterAngle])}]       ;# -- intersecting tube component of offset
                set z  [expr {$v1 + $v2}]                       
            }
                #
            set zTool [expr {-1.0 * [lindex [vectormath::rotatePoint {0 0} [list $x $z] $miterAngle] 1]}]
                # set zTool   [expr -1.0 * ($x / sin($PI - [vectormath::rad $miterAngle])) - ($z / cos($PI - [vectormath::rad $miterAngle]))]
                # set zTool   [expr (0 - $tubeRadius) * cos($rad_Angle)]
                # set zTool   [expr $x / cos([vectormath::rad $miterAngle])]
                # set zTool   [expr ($x - $tubeRadius) / cos([vectormath::rad $miterAngle])] 
                #
            dict set indexDictionary $key i             $i_key
            dict set indexDictionary $key x             $x      
            dict set indexDictionary $key y             [expr {$tubeRadius*sin($rad_Angle)}]
            dict set indexDictionary $key z             $z
            dict set indexDictionary $key zTool         $zTool
            dict set indexDictionary $key phi_grd       $angle
            dict set indexDictionary $key phi_rad       [vectormath::rad $angle]
            dict set indexDictionary $key perimeter     $i_perimeter
                #
                # dict set indexDictionary $key y             $h
                #
            set angle       [expr {$angle + $angleIncr}]
                #
            incr i_key
                #
    }
        #
        #
        # -- update dictionary depending to startAngle
        #
    set extendDict  0
    if {$startAngle !=  0} { set extendDict 1}
    if {$side  ne {right}} { set extendDict 1}
        #
    if $extendDict {
            # appUtil::pdict $indexDictionary
        set lastKey         [lindex [lsort [dict keys $indexDictionary]] end]
        set lastIndex       [dict get $indexDictionary $lastKey i]
            # puts "   -> \$lastIndex         $lastIndex"
        set offsetIndex     [expr {$lastIndex + 1}]
            # puts "   -> \$offsetIndex       $offsetIndex"
        foreach key [lsort [dict keys $indexDictionary]] {
                #
            set keyDict     [dict get $indexDictionary $key]
            set i           [dict get $keyDict i]
            set phi_grd     [dict get $keyDict phi_grd]
                # set y           [dict get $keyDict y]
                # set z           [dict get $keyDict z]
                # set perimeter   [dict get $keyDict perimeter]
                #
            set phi_new     [expr {$phi_grd + 360}]
            set i_new       [expr {$i + $offsetIndex}]
            set newKey      [format "key_%06d" $i_new]
                #
                # puts "   -> $key/ $newKey: \$phi_grd $phi_grd  -> $phi_new"
            dict set indexDictionary $newKey $keyDict
            dict set indexDictionary $newKey i          $i_new
            dict set indexDictionary $newKey phi_grd    $phi_new
            dict set indexDictionary $newKey phi_rad    [vectormath::rad $phi_new]
                #set perimt_new  [expr $perimeter + $offsetPerimeter]
                #dict set indexDictionary $newKey perimeter  $perimt_new
                #dict set indexDictionary $newKey y          $y_1
                #dict set indexDictionary $newKey z          $z_1
                #
        }
            # appUtil::pdict $indexDictionary
    }
        
        #
        #
        # -- tool Miter - cylinder
        #
    set ___toolMiter       {}
        #
    if {$startAngle >= 0} {
        set borderLeft  [expr {-180 + $startAngle}]
        set borderRight [expr {$borderLeft  + 360}]
    } else {
        set borderLeft  [expr { 180 + $startAngle}]
        set borderRight [expr {$borderLeft  + 360}]
    }
        #
        # puts "  ___toolMiter -> $borderLeft $borderRight"
        #
    if {$opposite != {no}} {
        #set borderLeft  [expr $borderLeft  + 180]
        #set borderRight [expr $borderRight + 180]
        if {$borderLeft >= 180} {
            #set borderLeft  [expr $borderLeft  -360]
            #set borderRight [expr $borderRight -360]
        }
    }
        #
    set tubePerimeter   [expr {2.0 * $tubeRadius * $PI}]
    set offsetPerimeter [expr {$startAngle * $tubePerimeter / 360}]
        # puts "   -> \$offsetPerimeter   $offsetPerimeter"
        #
    foreach key [lsort [dict keys $indexDictionary]] {
        set phi_grd     [dict get $indexDictionary $key phi_grd]
            #
            # puts "   -> $borderLeft <= $phi_grd <= $borderRight"
        if {$borderLeft <= $phi_grd && $phi_grd <= $borderRight} {
            set z           [dict get $indexDictionary $key z]
            set perimeter   [dict get $indexDictionary $key perimeter]
            set i_perimeter [expr {$perimeter - $offsetPerimeter}]
            if {$i_perimeter >  0.5 * $tubePerimeter} { set i_perimeter [expr {$i_perimeter - $tubePerimeter}] }
            if {$i_perimeter < -0.5 * $tubePerimeter} { set i_perimeter [expr {$i_perimeter + $tubePerimeter}] }
            set xy [list $i_perimeter $z]
                #
            if {$side != {right}}  {
                lappend toolMiter $i_perimeter                  $z
            } else {
                lappend toolMiter [expr {-1.0 * $i_perimeter}]    $z
            }
        }
    }
    foreach key [lsort -real [dict keys $toolMiter]] {
        set z [dict get $toolMiter $key]
        lappend ___toolMiter $key $z
    }
        # puts "   \$___toolMiter $___toolMiter"
        #
    
        
        #
        #
        # -- tubeMiter - xz view (side View)
        #
    set coordList {}
    set tmpList {}
        #
    if {$startAngle == 0} {
            #
        foreach key [lsort [dict keys $indexDictionary]] {
            set phi_grd [dict get $indexDictionary $key phi_grd]
            set x       [dict get $indexDictionary $key x]
            set z       [dict get $indexDictionary $key z]
                # puts "   -> \$phi_grd $phi_grd"
            if {$phi_grd <= 0} {
                lappend coordList [format {%3.8f} $x] [format {%3.8f} $z]
            }
        }
            #
        if {$side ne {right}}  {
            set _tmpList {}
            foreach {z x} [lreverse $coordList] {
                set x [expr {-1.0 * $x}]
                lappend _tmpList $x $z
            }
            set coordList $_tmpList
        }
            #
        set tmpList $coordList
            #
    } else {
            #
        if {$startAngle >= 0} {
            set borderLeft  [expr {-180 + $startAngle}]
            set borderRight [expr {$borderLeft  + 180}]
        } else {
            set borderLeft  [expr {   0 + $startAngle}]
            set borderRight [expr {$borderLeft  + 180}]
        }
            #
        if {$side ne {right}} {
            set borderLeft  [expr {$borderLeft  + 180}]
            set borderRight [expr {$borderRight + 180}]
        }
            #
        foreach key [lsort [dict keys $indexDictionary]] {
                # 
            set phi_grd [dict get $indexDictionary $key phi_grd]
            set x       [dict get $indexDictionary $key x]
            set y       [dict get $indexDictionary $key y]
            set z       [dict get $indexDictionary $key z]
                # puts "   -> $borderLeft <= $phi_grd <= $borderRight"
            if {$borderLeft <= $phi_grd && $phi_grd <= $borderRight} {
                set xy      [list $x $y]
                set xy_1    [vectormath::rotatePoint {0 0} $xy [expr {1.0 * $startAngle}]]
                lassign $xy_1  x_1 y_1
                    # foreach {x_1 y_1} $xy_1 break
                    # puts "            -> $x     [vectormath::length {0 0} $xy] <-> [vectormath::length {0 0} $xy_1]"
                lappend coordList [format {%3.8f} $x_1] [format {%3.8f} $z]
                lappend tmpList   [format {%3.8f} $x_1] [format {%3.8f} $z]
            }
        }
    }
    set ___miterProfile_Right    [vectormath::rotateCoordList {0 0} $coordList 270]
    set ___cylinderProfile_Right [vectormath::rotateCoordList {0 0} $tmpList   270]
        #
        # appUtil::pdict $indexDictionary 2 "    "
        # puts "\n"
        # exit
        #
        # puts "   -> \$coordList       $coordList" 
        #
        # exit
    return [list $___toolMiter $___miterProfile_Right $___cylinderProfile_Right $indexDictionary]
        #
}

