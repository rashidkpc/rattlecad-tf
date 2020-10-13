 ##+##########################################################################
 #
 # OvalProfile.tcl
 #
 #   tubeMiter is software of Manfred ROSENBERGER
 #       based on tclTk and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2018/01/01
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
oo::class create tubeMiter::OvalProfile {
        #
        #
    superclass tubeMiter::AbstractProfile
        #
    constructor {} {
            #
        puts "              -> class OvalProfile"    
            #
        next
            #
        variable Scalar
        variable Result
            #
        array unset Scalar *
        array set   Scalar {
                        Rotation           0.00
                        Diameter_X        25.21
                        Diameter_Y        39.65
                        Length           100.00
                        Precision         90
                    }
        array unset Result *
        array set   Result {
                        Perimeter          0.00
                    }
            #
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        next $target_method $args
    }
        #
    method getKeys_Scalar {} {
        return {Diameter_X Diameter_Y Length Precision Rotation}
    }
        #
    method setMyProfileDef {argDict} {
            #
            # puts "   --> [info object class [self]] -> setMyProfileDef --> $argDict"    
            #
        variable Scalar
            #
        set argDict [join $argDict]
        set argList [dict keys $argDict]
            #
            # puts "----> OvalProfile -> setMyProfileDef"
            # appUtil::pdict $argDict
            #
        foreach key {-diameter_x -diameter_y -rotation -precision} {
                # puts " -> \$key $key"
            if [dict exist $argDict $key] {
                set keyValue [dict get $argDict $key]
                switch -exact $key {
                    -diameter_x {
                        my setScalar Diameter_X $keyValue
                    }
                    -diameter_y {
                        my setScalar Diameter_Y $keyValue
                    }
                    -rotation {
                        my setScalar Rotation   $keyValue
                    }
                    -precision {
                        my setScalar Precision  $keyValue
                    }
                    default {}
                }
            }
        }
            #
            # parray Scalar
            # puts "----> OvalProfile -> setMyProfileDef"
            #
        my update    
            #
    
    }
        #
    method update {} {
            #
        variable Scalar
        variable Result
            #
        set phi                 [vectormath::rad    $Scalar(Rotation)]
            #
        set angleOffset         [vectormath::grad   [my effectivePhiEllipse]]
            # set angleOffset         [vectormath::grad $angleOffset]        
            #
        # puts "OvalProfile -> update"
        # parray Scalar
        # puts "         ---> update"        
            #
        my createAngleDict      $angleOffset
        my createPerimeterDict
            #
        my createBaseDict
            #
        my updateProfile
            #
    }
        #
    method createBaseDict {} {
            #
            #
        variable Scalar
            #
        variable dictAngle
        variable dictPerimeter
        variable dictBase
            #
            # puts " ---- createBaseDict ----"
            #
        set rx              [expr {  0.5  * $Scalar(Diameter_X)}]
        set ry              [expr {- 0.5  * $Scalar(Diameter_Y)}]  ;# ... y is negativ in [-180 0] and positiv in [0 180]
            #
        set incrZ           [expr {  0.25 * $Scalar(Length) / $Scalar(Precision)}]  
            #

            # set r               [expr 0.5 * $Scalar(Diameter)]
            # set rx              $r
            # set ry              [expr -1.0 * $r]   ;# ... y is negativ in [-180 0] and positiv in [0 180]
            #
            # my createAngleDict
            #
            # set i_angle         -360.0
            # set i_key              0
            #
            # set incrAngle       [expr 90.0 / $Scalar(Precision)]
            # set incrZ           [expr 0.25 * $Scalar(Length) / $Scalar(Precision)]  
            
            #
        set i               0
        set dictBase        {}    
            #
        dict for {key keyDict} $dictAngle {
                #
            set phi_grd     [dict get $keyDict  phi_grd]
            set phi_rad     [dict get $keyDict  phi_rad]
            set rho_grd     [dict get $keyDict  rho_grd]
            set rho_rad     [dict get $keyDict  rho_rad]
                #
                # puts "        -> $i  --> $key  ---> $phi_grd"
                #
            set x           [expr {$rx * sin($phi_rad)}]  ;# ... side view, perpendicular to tube axis, in plane of tube- and tool axis
            set y           [expr {$ry * cos($phi_rad)}]  ;# .... top view, offset of surface line perpendicular to tube(z) axis
                #
            set z           [expr {$rx * $Scalar(Length) * sin([vectormath::rad $phi_rad])}]  ;# ... a little bit obscure
                #
            set x1          [expr {$rx * sin($rho_rad)}]  ;# ... side view, perpendicular to tube axis, in plane of tube- and tool axis
            set y1          [expr {$ry * cos($rho_rad)}]  ;# .... top view, offset of surface line perpendicular to tube(z) axis
                #
                # set z           [expr ($i - 2 * $Scalar(Precision)) * $incrZ]
                # set z           [expr $rx * sin($phi_rad)]
                #
            set perimeter   [dict get $dictPerimeter $key perimeter]
                # set perimeter   [expr $rx * $phi_rad]
                #
            dict set dictBase   $key   i           $i
            dict set dictBase   $key   x           $x      
            dict set dictBase   $key   y           $y
            dict set dictBase   $key   z           $z
            dict set dictBase   $key   x1          $x1      
            dict set dictBase   $key   y1          $y1
            dict set dictBase   $key   phi_grd     $phi_grd
            dict set dictBase   $key   phi_rad     $phi_rad
            dict set dictBase   $key   perimeter   $perimeter
                #
                # puts "        -> $i  --> $key  ---> $phi_grd <--- $perimeter"
                #
            incr            i    
                #
        }
            #
            # appUtil::pdict $dictBase   
            #
    }
        #
    method createPerimeterDict {} {
            #
        variable Scalar
        variable Result
            #
        variable dictAngle
        variable dictPerimeter
            #
        set rx              [expr { 0.5 * $Scalar(Diameter_X)}]
        set ry              [expr {-0.5 * $Scalar(Diameter_Y)}]
            #
        set i               0
        set perimeter       0
        set posLast         [list 0 $ry]   
        set dictPerimeter   {}
            #
        dict for {key keyDict} $dictAngle {
                #
            set phi_grd     [dict get $keyDict  phi_grd]
            set phi_rad     [dict get $keyDict  phi_rad]
            set rho_grd     [dict get $keyDict  rho_grd]
            set rho_rad     [dict get $keyDict  rho_rad]
                #
            set phi         $phi_rad
                # set phi         [vectormath::rad $i_angle]
                #
            set x           [expr {$rx * sin($phi)}]  ;# ... side view, perpendicular to tube axis, in plane of tube- and tool axis
            set y           [expr {$ry * cos($phi)}]  ;# .... top view, offset of surface line perpendicular to tube(z) axis
                #
            set posNow      [list $x $y]
                # puts "                -> $posLast $posNow"
            set d_prmtr     [vectormath::length $posLast $posNow]
                #
            set perimeter   [expr {$perimeter + $d_prmtr}]
                #
                # puts "             -> $key $phi_grd"    
                # puts "             -> [format {%s  - %0.6f -  ( %0.6f  %0.6f ) -->  %0.6f  <-- %f}  $key $phi_grd $x $y $perimeter $d_prmtr]"    
                #
            dict set dictPerimeter  $key   i            $i
            dict set dictPerimeter  $key   x            $x
            dict set dictPerimeter  $key   y            $y
            dict set dictPerimeter  $key   phi_grd      $phi_grd
            dict set dictPerimeter  $key   perimeter    $perimeter
                #
            set posLast     $posNow
                # set  i_angle    [format {%0.6f} [expr $i_angle + $incrAngle]]
            incr            i  
        }
            #
        set perimeterOval   [expr {0.5 * [dict get $dictPerimeter $key perimeter]}]   
            #
            # puts "             -> \$perimeterOval $perimeterOval"    
            #
        set Result(Perimeter)   $perimeterOval    
            #
        dict for {key keyDict} $dictPerimeter {
                #
            set perimeter   [dict get $keyDict perimeter]
                #
            dict set dictPerimeter  $key   perimeter    [expr {$perimeter - $perimeterOval}]
                #
        }
            #
        return
            #        
            # return $dictPerimeter
            #
    }
        #
    method effectivePhiEllipse {} {
            #
            # ... get the point on ellipse cut by line with angle phi through center
            #
        variable Scalar    
            #
            # ... https://www.hackerboard.de/science-and-fiction/39279-geometrie-punkt-auf-ellipse.html
            #       (x / y) = (a * cos(a) / b * sin(a))
            #        x = r1 * cos(phi) 
            #        y = r2 * sin(phi))
            #
            # ... http://www.chemieonline.de/forum/showthread.php?t=108424
            #        tan(alpha) = (h / b) * tan/phi)
            #
            # puts "   -> effectivePhiEllipse"
            # parray Scalar
            #
        set PI      [expr {4 * atan(1)}]    
            #
        set phi     [vectormath::rad $Scalar(Rotation)]
            #
        set x       [expr {double($Scalar(Diameter_X))}]
        set y       [expr {double($Scalar(Diameter_Y))}]
            #
        set rho     [expr {atan(double($x/$y) * tan($phi))}]    
            #
            # puts "    - effectivePhiEllipse -->  [vectormath::grad $phi] -> [vectormath::grad $rho]" 
            #
        if {($phi > ($PI/2)) && ($phi <= $PI)} {
            set rho [expr {$rho + $PI}]
        }    
        if {($phi >= (-1*$PI)) && ($phi < $PI/-2)} {
            set rho [expr {$rho - $PI}]
        }    
            #
            # puts "    - effectivePhiEllipse -->  [vectormath::grad $phi] -> [vectormath::grad $rho]"    
            #
        return $rho 
            #
    }
        #
}