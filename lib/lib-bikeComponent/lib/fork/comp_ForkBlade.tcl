 ##+##########################################################################te
 #
 # package: bikeComponent   ->  class_ForkBlade.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/12/09
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
 # ---------------------------------------------------------------------------
 #  namespace:  bikeComponent::ForkBlade      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkBlade {

            # <Fender>
            #     <Front>
            #         <Radius>346.00</Radius>
            #         <Height>15.00</Height>
            #         <OffsetAngleFront>20.00</OffsetAngleFront>
            #         <OffsetAngle>110.00</OffsetAngle>
            #     </Front>
            #     <Rear>
            #         <Radius>346.00</Radius>
            #         <Height>15.00</Height>
            #         <OffsetAngle>160.00</OffsetAngle>
            #     </Rear>
            # </Fender>


        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
        variable array_CompBaseDir
            #

        constructor {{type {}}} {
                #
            set   objectName    "ForkBlade"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName -> $type"
                #

            variable arcPrecission      ; set   arcPrecission         20
            variable bladeStyle         ; set   bladeStyle      straight
                #
            
                #
            variable Config             ; array set Config {
                                            }
            variable Scalar             ; array set Scalar {
                                                Height               330.00
                                                Rake                  45.00 
                                                DropoutOffset         20.00
                                                DropoutOffsetPerp      0.00
                                                
                                                StartWidth            13.00
                                                StartLength           10.00
                                                TaperLength          250.00
                                                BendRadius           550.00
                                                EndWidth              28.60
                                            }
                #
            variable ComponentNode     ; array set ComponentNode {
                                                XZ                      {}
                                            }
            variable Direction          ; array set Direction {
                                                Origin                 0.00
                                            }
            variable Position           ; array set Position {
                                                End                 {0 0}
                                                Origin              {0 0}
                                            }
            variable Polygon            ; array set Polygon {
                                                Blade                  {}
                                            }
            variable Polyline           ; array set Polyline {          
                                                CenterLine             {}
                                            }
            variable Vector             ; array set Vector {
                                                BladeDefinition         {0 0 50 50}
                                            }                                
                #
            variable polyline_CenterLineCut {}                                
            variable position_Blade         {}
                #
            set ComponentNode(XZ)           [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            my setBladeStyle $type
                #                 
        }


        #-------------------------------------------------------------------------
            #  create custom Fork
            #
        method update {} {
            my update_ForkBlade
            my update_SVGNode
        }
            #
        method setBladeStyle {style} {
            variable bladeStyle
            switch -exact $bladeStyle {
                bent -
                straight -
                max {
                        set bladeStyle $style
                    }
            }
        }
            #
        method update_ForkBlade {} {

                #
            variable bladeStyle
                #
            variable Config
            variable Scalar
            variable Direction
            variable Polyline
            variable Polygon
            variable Position
            variable Vector
                #
            variable polyline_CenterLineCut                                
            variable angle_DropOut                                         
            variable position_Blade                                        
                
                #
            set bladeHeight     $Scalar(Height)
            set bladeRake       $Scalar(Rake)
            set dropOutOffset   $Scalar(DropoutOffset)
            set dropOutPerp     $Scalar(DropoutOffsetPerp)
                #
            set endLength       $Scalar(StartLength)
            set bendRadius      $Scalar(BendRadius)
                #
            if {$Scalar(StartLength) <= 2.0} {
                set Scalar(StartLength) 2.0
                set endLength           $Scalar(StartLength)
            }
                #
                # puts " <I> .... \$bladeStyle $bladeStyle"
                #
            set profileDef {}
            switch -exact $bladeStyle {
                max {
                        set     taperLength     250.0
                        lappend profileDef      [list  0  14]
                        lappend profileDef      [list  5  14]
                        lappend profileDef      [list $taperLength 36]
                        lappend profileDef      [list $taperLength 36]
                        lappend profileDef      [list $taperLength 36]               
                    }
                default {
                            # EndWidth              28.00
                            # StartWidth            12.00
                            # TaperLength          250.00
                            # StartLength             15.00
                        set x_00    0
                        set x_01    $Scalar(StartLength)
                        set x_02    $Scalar(TaperLength)
                        set x_03    [expr {$Scalar(TaperLength) + 10}]
                            #
                        set y_00    $Scalar(StartWidth)
                        set y_01    $Scalar(StartWidth)
                        set y_02    $Scalar(EndWidth)
                        set y_03    $Scalar(EndWidth)
                            #
                        lappend profileDef [list $x_00 $y_00]
                        lappend profileDef [list $x_01 $y_01]
                        lappend profileDef [list $x_02 $y_02]
                        lappend profileDef [list $x_03 $y_03]
                   }
            }
                
                
                
                
                
            switch -exact $bladeStyle {
            
                bent {
                            #
                            # http://www.mathcentre.ac.uk/resources/workbooks/mathcentre/web-rcostheta-alphaetc.pdf
                            #puts "\n"
                            #puts "   --> \$height_bladeDO $height_bladeDO"
                            #puts "   --> \$dropOutPerp $dropOutPerp"
                            #puts "   ----> [expr $height_bladeDO + $dropOutPerp]"
                            #
                        set _a    [expr { 1.0*($bendRadius - $dropOutPerp)}]
                        set _b    [expr {-1.0*($dropOutOffset + $endLength)}]
                        set _R    [expr {hypot($_a,$_b)}]
                        set _atan [expr {atan($_b/$_a)}]
                            #
                        set _quot [expr ($bendRadius - $bladeRake)/$_R]
                        if {$_quot >  1} {set _quot  1}
                        if {$_quot < -1} {set _quot -1}
                            #
                        set _acos [expr {acos($_quot)}]
                            #
                        if 0 {
                            puts "   -> \$_a $_a"
                            puts "   -> \$_b $_b"
                            puts "   -> \$_R $_R"
                            puts "   -> \$_atan $_atan"
                            puts "   -> \$_acos $_acos"
                            puts "   ------------------"
                        }
                            #
                        set bendAngle   [expr {(-180/$vectormath::CONST_PI) * ($_acos + $_atan)}]
                        set bendRadiant [expr {$bendAngle*$vectormath::CONST_PI/180}]
                            #
                        set segLength   [expr {abs($bendRadius*$bendRadiant)}]
                        set chordLength [expr {abs(2.0 * $bendRadius * sin($bendRadiant))}]
                        set chordCos    [expr {abs($chordLength * cos((90 - 0.5 * $bendAngle)*$vectormath::CONST_PI/180))}]
                        set chordSin    [expr {abs($chordLength * sin((90 - 0.5 * $bendAngle)*$vectormath::CONST_PI/180))}]
                        set dirAngle    [expr {-1*$bendAngle}]
                            #
                        set l_t02       [expr {abs($bendRadius * tan((0.5*$bendAngle)*$vectormath::CONST_PI/180))}]
                            #
                        set p_02        {0 0}
                        set p_03        [vectormath::rotateLine $p_02 $endLength    0]
                        set p_04        [vectormath::rotateLine $p_03 $l_t02        0]
                        set p_05        [vectormath::rotateLine $p_04 $l_t02        $bendAngle]
                            #
                        set _doOffset_h [expr {$dropOutOffset * cos($bendRadiant)}]
                        set _doPerp_h   [expr {$dropOutPerp   * sin($bendRadiant)}]
                        set _endLength  [expr {$endLength     * cos($bendRadiant)}]
                        set _l_t02      [expr {$l_t02         * cos($bendRadiant)}]
                        set straightLength  [expr {$bladeHeight - ($_doOffset_h + $_doPerp_h + $_endLength + $_l_t02 + $l_t02)}]
                            #
                        set p_06        [vectormath::rotateLine $p_05 $straightLength $bendAngle]
                            #
                            #                         p_02/p_03    p_03/p_04
                        set centerLineLength    [expr {$endLength + $segLength + $straightLength}]
                            #
                        set dropoutAngle    $bendAngle
                            #
                            if 0 {
                                puts "   -> \$bladeHeight $bladeHeight"
                                puts "   -> \$bladeRake $bladeRake"
                                puts "   -> \$_a $_a"
                                puts "   -> \$_b $_b"
                                puts "   -> \$_R $_R"
                                puts "   -> \$_quot $_quot"
                                puts "   -> \$_atan $_atan"
                                puts "   -> \$_acos $_acos"
                                puts "   -> \$segLength $segLength"
                                puts "   -> \$bendAngle $bendAngle\n"
                                puts "   -> \$dirAngle $dirAngle\n"
                                #puts "       ->  \$p_01 $p_01"
                                puts "       ->  \$p_02 $p_02"
                                puts "       ->  \$p_03 $p_03"
                                puts "       ->  \$p_04 $p_04"
                                puts "       ->  \$p_05 $p_05"
                                puts "       ->  \$p_06 $p_06"
                                puts "       ->     \$l_t02 $l_t02"
                                puts "       ->     \$chordCos $chordCos"
                                puts "       ->     \$chordSin $chordSin"
                                
                                puts "       ->     \$_doOffset_h       $_doOffset_h      "
                                puts "       ->     \$_doPerp_h         $_doPerp_h        "
                                puts "       ->     \$_l_t02          $_l_t02         "
                                puts "       ->     \$straightLength  $straightLength "
                                
                                puts "   -> \$centerLineLength $centerLineLength\n"
                            }
                                #
                            set pt_06 [vectormath::rotatePoint {0 0} $p_06 [expr {-1 * $bendAngle}]]
                            set _doOffset_p [expr {-1 * $dropOutOffset * sin($bendRadiant)}]
                            set _doPerp_p   [expr {$dropOutPerp   * cos($bendRadiant)}]
                                # puts " ---- $_doOffset_p + $_doPerp_p"
                            set pt_06 [vectormath::addVector   $pt_06 [list [expr {$_doOffset_h + $_doPerp_h}] [expr {$_doOffset_p + $_doPerp_p}]]]
                                #
                            if 0 {
                                puts "       ->  \$pt_06 $pt_06"
                                puts "\n"
                            }
                                #
                        set S01_length [vectormath::length $p_02 $p_04]    
                        set S02_length [expr {[vectormath::length $p_04 $p_06] -30}]
                            #
                        set angleRotation   $dirAngle
                        set dropoutAngle    $dirAngle
                            # puts "   -> \$angleRotation $angleRotation\n"
                            #
                        #set S01_length  [expr $endLength + 0.5 * $segLength]
                        #set S02_length  [expr [lindex $p_04 0] + 0.5 * $segLength - 20] ;#[expr $bladeHeight - $S01_length - 20]
                        set S03_length  10 ;#[expr [lindex $p_04 0] - 20]                       
                        set S04_length  10                         
                        set S05_length  10                         
                        set P01_angle   $bendAngle
                        set P02_angle   0                       
                        set P03_angle   0                       
                        set P04_angle   0                       
                        set S01_radius  $bendRadius
                        set S02_radius  0
                        set S03_radius  0            
                        set S04_radius  0            
                            #
                            # -- set centerLine of bent tube
                        set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                                $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                                $S01_radius $S02_radius $S03_radius  $S04_radius \
                                                $centerLineLength]              
                            # -- tubeProfile
                        set tubeProfile [my init_tubeProfile $profileDef]              
                            # puts "   -> \$profileDef   $profileDef"
                            # puts "   -> \$tubeProfile  $tubeProfile"
                    }
                    
                straight {
                            #
                            # puts "\n ==== straight =========\n"  
                            #
                        set _dAngle   [expr {atan(1.0*$bladeRake/$bladeHeight)}]
                        set _hypot    [expr {hypot($bladeHeight,$bladeRake)}]
                        set _pAngle   [expr {asin($dropOutPerp/$_hypot)}]
                            #
                        set length    [expr {sqrt(pow($_hypot,2) - pow($dropOutPerp,2)) - $dropOutOffset}]
                            #
                        set dirAngle  [expr {(180/$vectormath::CONST_PI) * ($_dAngle - $_pAngle)}]
                            #
                            #puts "   --> \$_hypot $_hypot"
                            #puts "   --> \$_dAngle $_dAngle"
                            #puts "   --> \$_pAngle $_pAngle"
                            #puts "   --> \$length $length"
                            #
                        set angleRotation   $dirAngle
                        set dropoutAngle    $dirAngle
                        set dropoutAngle    $dirAngle
                            #puts "   -> \$angleRotation $angleRotation\n"
                            #
                            
                        set S01_length  [expr {0.20 * $length}]
                        set S02_length  [expr {0.20 * $length}]
                        set S03_length  [expr {0.20 * $length}]                       
                        set S04_length  [expr {0.20 * $length}]                         
                        set S05_length  [expr {0.20 * $length}]                         
                        set P01_angle   0
                        set P02_angle   0                       
                        set P03_angle   0                       
                        set P04_angle   0                       
                        set S01_radius  0
                        set S02_radius  0
                        set S03_radius  0
                        set S04_radius  0
                            #
                            # -- set centerLine of straight tube
                        set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                                $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                                $S01_radius $S02_radius $S03_radius  $S04_radius \
                                                $length] 
                                                
                            # -- set tubeProfile       
                        set tubeProfile [my init_tubeProfile $profileDef]
                        # set tubeProfile [bikeComponent::tube::init_tubeProfile $profileDef]
                            # puts "   -> \$profileDef   $profileDef"
                            # puts "   -> \$tubeProfile  $tubeProfile"
                    }
                    
                max {
                        
                        # puts "\n ==== MAX =========\n"  
                        
                        set endLength  260.0
                        set bendRadius  15.0
                        set max_Offset   6.0
            
                            # puts "   -> \$max_Offset       $max_Offset"  
                            # puts "   -> \$bendRadius   $bendRadius"                
                            # puts "   -> \$endLength    $endLength"
                        set bendAngle   [expr {atan(1.0*$max_Offset/$endLength)}]
                        set bendRadiant [expr {$bendAngle*$vectormath::CONST_PI/180}]
                            #
                        set segLength   [expr {abs($bendRadius*$bendRadiant)}]
                        set chordLength [expr {abs(2.0 * $bendRadius * sin($bendRadiant))}]
                        set chordCos    [expr {abs($chordLength * cos((90 - 0.5 * $bendAngle)*$vectormath::CONST_PI/180))}]
                        set chordSin    [expr {abs($chordLength * sin((90 - 0.5 * $bendAngle)*$vectormath::CONST_PI/180))}]
                        set dirAngle    [expr {-1*$bendAngle}]
                            #
                        set l_t02       [expr {abs($bendRadius * tan((0.5*$bendAngle)*$vectormath::CONST_PI/180))}]
                            #
                        set l_bend_DO   [expr {hypot(($endLength+$dropOutOffset),$dropOutPerp)}]
                            # puts "   -> \$l_bend_DO $l_bend_DO"  
                        set a_bend_DO   [expr {atan(1.0*$dropOutPerp/($endLength+$dropOutOffset))}]
                            # puts "   -> \$a_bend_DO $a_bend_DO"               
                        set a_gamma     [expr {$vectormath::CONST_PI-($bendAngle+$a_bend_DO)}]
                            # puts "   -> \$a_gamma   $a_gamma" 
                            #
                        set l_bend_DO_x [expr {$l_bend_DO * cos($bendAngle+$a_bend_DO)}]
                        set l_bend_DO_y [expr {$l_bend_DO * sin($bendAngle+$a_bend_DO)}]
                            # puts "   -> \$l_bend_DO_x   $l_bend_DO_x" 
                            # puts "   -> \$l_bend_DO_y   $l_bend_DO_y" 
                            #
                        set l_cc        [expr {hypot($bladeHeight,$bladeRake)}]
                        set l_base      [expr {sqrt(pow($l_cc,2) - pow($l_bend_DO_y,2)) - $l_bend_DO_x}]
                            # puts "   -> \$l_base   $l_base" 
                            #
                        set _a_2        [expr {pow($l_bend_DO,2)}]
                        set _b_2        [expr {pow($l_base,2)}]
                        set _c_2        [expr {pow($l_cc,2)}]
                        set _2ac        [expr {2*$l_bend_DO*$l_cc}]
                            #
                        set a_beta      [expr {acos(($_c_2-$_b_2+$_a_2)/$_2ac)}]
                        set a_alpha     [expr {$vectormath::CONST_PI - $a_beta - $a_gamma}]
                            # puts "   -> \$a_beta   $a_beta"               
                            # puts "   -> \$a_alpha  $a_alpha"     
                            #
                        set a_offset    [expr {atan(1.0*$bladeRake/$bladeHeight)}]
                            # puts "   -> \$a_offset   $a_offset"               
                        set dirAngle    [expr {$a_offset + $a_beta - $a_bend_DO}]
                            # puts "\n"
                            # puts "   -> \$dirAngle  $dirAngle"     
                                # puts "   -> \$dirAngle  $dirAngle"     
                                # puts "\n"
                                # puts "   -> \$max_Offset $max_Offset"  
                                
                        set _endLength  [expr {$endLength - $segLength}]
                            #
                        set clLength    [expr {hypot($bladeHeight,$bladeRake)}]
                            #
                         
                            #set bladeHeight 
                            #
                        set _doOffset_h [expr {$dropOutOffset * cos($bendRadiant)}]
                        set _doPerp_h   [expr {$dropOutPerp   * sin($bendRadiant)}]
                        set _endLength  [expr {$_endLength    * cos($bendRadiant)}]
                        set _l_t02      [expr {$l_t02         * cos($bendRadiant)}]
                            #
                        set _doOffset_p [expr {-1 * $dropOutOffset * sin($bendRadiant)}]
                        set _doPerp_p   [expr {$dropOutPerp   * cos($bendRadiant)}]
                        set _endLengt_p [expr {$_endLength    * sin($bendRadiant)}]
                        set _l_t02_p    [expr {$l_t02         * sin($bendRadiant)}]
                            
                            #
                        set clLength    [expr {hypot($bladeHeight,$bladeRake)}]
                        set clPerp      [expr {$_doOffset_p + $_doPerp_p + $_endLengt_p + $_l_t02_p}]
                        set _bladeHeight    [expr {sqrt(pow($clLength,2) + pow($clPerp,2))}]
                        
                        set straightLength  [expr {$_bladeHeight - ($_doOffset_h + $_doPerp_h + $_endLength + $_l_t02 + $l_t02)}]
                            #
                        set centerLineLength    [expr {$endLength + $segLength + $straightLength}]
                            #
                        set dirAngle    [vectormath::grad $dirAngle]
                            #
                        set p_01        [vectormath::rotateLine {0 0} $dropOutPerp    [expr {90 + $dirAngle}]]
                        # set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 0 + $dirAngle]]
                        # set p_04    [vectormath::rotateLine $p_02 $endLength  [expr 0 + $dirAngle]]
                        # set p_06    [list 0 0] 
                        # set p_06    [list $bladeHeight $bladeRake] 
                            #
                        set p_02        {0 0}
                        set p_03        [vectormath::rotateLine $p_02 $endLength    0]
                        set p_04        [vectormath::rotateLine $p_03 $l_t02        0]
                        set p_05        [vectormath::rotateLine $p_04 $l_t02        $bendAngle]
                            #
                        set p_06        [vectormath::rotateLine $p_05 $straightLength $bendAngle]
                            #
                        set _doOffset_h [expr {$dropOutOffset * cos($bendRadiant)}]
                        set _doPerp_h   [expr {$dropOutPerp   * sin($bendRadiant)}]
                        set _endLength  [expr {$endLength * cos($bendRadiant)}]
                        set _l_t02      [expr {$l_t02         * cos($bendRadiant)}]
                        set straightLength  [expr {$bladeHeight - ($_doOffset_h + $_doPerp_h + $_endLength + $_l_t02 + $l_t02)}]
                            #
                        set centerLineLength    [vectormath::length $p_02 $p_06]
                            #
                        set angleRotation   $dirAngle
                        set dropoutAngle    $dirAngle
                            # puts "   -> \$angleRotation $angleRotation\n"
                            #
                        if 0 {
                            puts "   -> \$bladeHeight $bladeHeight"
                            puts "   -> \$bladeRake $bladeRake"
                            puts "       ->  \$p_01 $p_01"
                            puts "       ->  \$p_02 $p_02"
                            puts "       ->  \$p_04 $p_04"
                            puts "       ->  \$p_06 $p_06"

                            puts "   -> \$centerLineLength $centerLineLength\n"
                            puts "\n"
                        }
                            #

                        set S01_length  [vectormath::length $p_02 $p_04]
                        set S02_length  [expr {[vectormath::length $p_04 $p_06] - 20}] ;#[expr $bladeHeight - $S01_length - 20]
                        set S03_length  10                
                        set S04_length  10                                          
                        set S05_length  10                                          
                        set P01_angle   [expr {-1.0 * $bendAngle * (180/$vectormath::CONST_PI)}]
                        set P02_angle   0                       
                        set P03_angle   0                       
                        set P04_angle   0                       
                        set S01_radius  $bendRadius
                        set S02_radius  0
                        set S03_radius  0  
                        set S04_radius  0  
                            # puts "   -> \$P01_angle $P01_angle\n"
            
                            # -- set centerLine of MAX tube
                        set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                                $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                                $S01_radius $S02_radius $S03_radius  $S04_radius \
                                                $centerLineLength] 
                                                
                            # -- set tubeProfile                 
                        set tubeProfile [my init_tubeProfile $profileDef]                 
                        # set tubeProfile [bikeComponent::tube::init_tubeProfile $profileDef]                 
                            #
                            # puts "   -> \$profileDef   $profileDef"
                            # puts "   -> \$tubeProfile  $tubeProfile"
                            #
                    }
                max_try {
                        
                        # puts "\n ==== MAX =========\n"  
                        
                        set endLength  250.0
                        set bendRadius  15.0
                        set max_Offset   6.0
                        
                        #set hlp_00		{0 0}                               ;# point where Taper begins
                        #set hlp_01        [list $endLength    $max_Offset]    ;# point where Taper ends
                        #                set vct_10         [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] ]
                        #                set vct_11         [ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] ]
                        #                set vct_12         [ vectormath::parallel $pt_12 $pt_13 [expr 0.5*$Fork(BladeWith)] left]
                        #                set vct_13         [ vectormath::parallel $pt_11 $pt_12 [expr 0.5*$Fork(BladeDiameterDO)] left ]
                        #        
                        #                #set polygon    [format "%s %s %s %s %s %s" \
                        #                                [lindex $vct_10 0]  [lindex $vct_11 0] [lindex $vct_11 1]  \
                        #                                [lindex $vct_12 1]  [lindex $vct_12 0] [lindex $vct_13 0] ]                    
                        #                set polygon    [format "%s %s %s %s %s %s" \
                        #                                [lindex $vct_11 1]  [lindex $vct_11 0] [lindex $vct_10 0]  \
                        #                                [lindex $vct_13 0]  [lindex $vct_12 0] [lindex $vct_12 1] ]                    
                        #                project::setValue Result(Tubes/ForkBlade)        polygon     $polygon
                        #                
                        #                set Fork(DropoutDirection)    [ vectormath::unifyVector $pt_12 $pt_11 ]                    
                        #                project::setValue Result(Lugs/Dropout/Front/Direction)    direction    $Fork(DropoutDirection)                


                        set bendAngle   [expr {atan(1.0*$max_Offset/$endLength)}]
                        set bendRadiant [expr {$bendAngle*$vectormath::CONST_PI/180}]
                            #
                            # puts "   -> \$max_Offset       $max_Offset"  
                            # puts "   -> \$bendRadius   $bendRadius"                
                            # puts "   -> \$endLength    $endLength"
                        set bendAngle   [expr {atan(1.0*$max_Offset/$endLength)}]
                        set bendRadiant [expr {$bendAngle*$vectormath::CONST_PI/180}]
                            #
                        set segLength   [expr {abs($bendRadius*$bendRadiant)}]
                        set chordLength [expr {abs(2.0 * $bendRadius * sin($bendRadiant))}]
                        set chordCos    [expr {abs($chordLength * cos((90 - 0.5 * $bendAngle)*$vectormath::CONST_PI/180))}]
                        set chordSin    [expr {abs($chordLength * sin((90 - 0.5 * $bendAngle)*$vectormath::CONST_PI/180))}]
                        set dirAngle    [expr {-1*$bendAngle}]
                            #
                        set l_t02       [expr {abs($bendRadius * tan((0.5*$bendAngle)*$vectormath::CONST_PI/180))}]
                            #
                        set l_bend_DO   [expr {hypot(($endLength+$dropOutOffset),$dropOutPerp)}]
                            # puts "   -> \$l_bend_DO $l_bend_DO"  
                        set a_bend_DO   [expr {atan(1.0*$dropOutPerp/($endLength+$dropOutOffset))}]
                            # puts "   -> \$a_bend_DO $a_bend_DO"               
                        set a_gamma     [expr {$vectormath::CONST_PI-($bendAngle+$a_bend_DO)}]
                            # puts "   -> \$a_gamma   $a_gamma" 
                            #
                        set l_bend_DO_x [expr {$l_bend_DO * cos($bendAngle+$a_bend_DO)}]
                        set l_bend_DO_y [expr {$l_bend_DO * sin($bendAngle+$a_bend_DO)}]
                            # puts "   -> \$l_bend_DO_x   $l_bend_DO_x" 
                            # puts "   -> \$l_bend_DO_y   $l_bend_DO_y" 
                            #
                        set l_cc        [expr {hypot($bladeHeight,$bladeRake)}]
                        set l_base      [expr {sqrt(pow($l_cc,2) - pow($l_bend_DO_y,2)) - $l_bend_DO_x}]
                            # puts "   -> \$l_base   $l_base" 
                            #
                        set _a_2        [expr {pow($l_bend_DO,2)}]
                        set _b_2        [expr {pow($l_base,2)}]
                        set _c_2        [expr {pow($l_cc,2)}]
                        set _2ac        [expr {2*$l_bend_DO*$l_cc}]
                            #
                        set a_beta      [expr {acos(($_c_2-$_b_2+$_a_2)/$_2ac)}]
                        set a_alpha     [expr {$vectormath::CONST_PI - $a_beta - $a_gamma}]
                            # puts "   -> \$a_beta   $a_beta"               
                            # puts "   -> \$a_alpha  $a_alpha"     
                            #
                        set a_offset    [expr {atan(1.0*$bladeRake/$bladeHeight)}]
                            # puts "   -> \$a_offset   $a_offset"               
                        set dirAngle    [expr {$a_offset + $a_beta - $a_bend_DO}]
                            # puts "\n"
                            # puts "   -> \$dirAngle  $dirAngle"     
                                # puts "   -> \$dirAngle  $dirAngle"     
                                # puts "\n"
                                # puts "   -> \$max_Offset $max_Offset"  
                                
                        set _endLength  [expr {$endLength - $segLength}]
                            #
                        set clLength    [expr {hypot($bladeHeight,$bladeRake)}]
                            #
                         
                            #set bladeHeight 
                            #
                        set _doOffset_h [expr {$dropOutOffset * cos($bendRadiant)}]
                        set _doPerp_h   [expr {$dropOutPerp   * sin($bendRadiant)}]
                        set _endLength  [expr {$_endLength    * cos($bendRadiant)}]
                        set _l_t02      [expr {$l_t02         * cos($bendRadiant)}]
                            #
                        set _doOffset_p [expr {-1 * $dropOutOffset * sin($bendRadiant)}]
                        set _doPerp_p   [expr {$dropOutPerp   * cos($bendRadiant)}]
                        set _endLengt_p [expr {$_endLength    * sin($bendRadiant)}]
                        set _l_t02_p    [expr {$l_t02         * sin($bendRadiant)}]
                            
                            #
                        set clLength    [expr {hypot($bladeHeight,$bladeRake)}]
                        set clPerp      [expr {$_doOffset_p + $_doPerp_p + $_endLengt_p + $_l_t02_p}]
                        set _bladeHeight    [expr {sqrt(pow($clLength,2) + pow($clPerp,2))}]
                        
                        set straightLength  [expr {$_bladeHeight - ($_doOffset_h + $_doPerp_h + $_endLength + $_l_t02 + $l_t02)}]
                            #
                        set centerLineLength    [expr {$endLength + $segLength + $straightLength}]
                            #
                        set dirAngle    [vectormath::grad $dirAngle]
                            #
                        set p_01        [vectormath::rotateLine {0 0} $dropOutPerp    [expr {90 + $dirAngle}]]
                        # set p_02    [vectormath::rotateLine $p_01 $dropOutOffset  [expr 0 + $dirAngle]]
                        # set p_04    [vectormath::rotateLine $p_02 $endLength  [expr 0 + $dirAngle]]
                        # set p_06    [list 0 0] 
                        # set p_06    [list $bladeHeight $bladeRake] 
                            #
                        set p_02        {0 0}
                        set p_03        [vectormath::rotateLine $p_02 $endLength    0]
                        set p_04        [vectormath::rotateLine $p_03 $l_t02        0]
                        set p_05        [vectormath::rotateLine $p_04 $l_t02        $bendAngle]
                            #
                        set p_06        [vectormath::rotateLine $p_05 $straightLength $bendAngle]
                            #
                        set _doOffset_h [expr {$dropOutOffset * cos($bendRadiant)}]
                        set _doPerp_h   [expr {$dropOutPerp   * sin($bendRadiant)}]
                        set _endLength  [expr {$endLength     * cos($bendRadiant)}]
                        set _l_t02      [expr {$l_t02         * cos($bendRadiant)}]
                        set straightLength  [expr {$bladeHeight - ($_doOffset_h + $_doPerp_h + $_endLength + $_l_t02 + $l_t02)}]
                            #
                        set centerLineLength    [vectormath::length $p_02 $p_06]
                            #
                        set angleRotation   $dirAngle
                        set dropoutAngle    $dirAngle
                            # puts "   -> \$angleRotation $angleRotation\n"
                            #
                        puts "   -> \$bladeHeight $bladeHeight"
                        puts "   -> \$bladeRake $bladeRake"
                        puts "       ->  \$p_01 $p_01"
                        puts "       ->  \$p_02 $p_02"
                        puts "       ->  \$p_04 $p_04"
                        puts "       ->  \$p_06 $p_06"

                        puts "   -> \$centerLineLength $centerLineLength\n"
                        puts "\n"
                            #

                            
                        set S01_length  [vectormath::length $p_02 $p_04]
                        set S02_length  [expr [vectormath::length $p_04 $p_06] - 20] ;#[expr $bladeHeight - $S01_length - 20]
                        set S03_length  10                
                        set S04_length  10                                          
                        set S05_length  10                                          
                        set P01_angle   [expr {-1.0 * $bendAngle * (180/$vectormath::CONST_PI)}]
                        set P02_angle   0                       
                        set P03_angle   0                       
                        set P04_angle   0                       
                        set S01_radius  $bendRadius
                        set S02_radius  0
                        set S03_radius  0  
                        set S04_radius  0  
                            # puts "   -> \$P01_angle $P01_angle\n"
            
            
                        set p_20        [vectormath::intersectPoint $p_02 $p_04 $p_04 $p_06]
                        set p_02_l      [vectormath::perpendicular  $p_02 $p_04  7 left ]
                        set p_02_r      [vectormath::perpendicular  $p_02 $p_04  7 right]
                        set p_20_l      [vectormath::perpendicular  $p_04 $p_02 18 right ]
                        set p_20_r      [vectormath::perpendicular  $p_04 $p_02 18 left]
                        set p_05_l      [vectormath::perpendicular  $p_04 $p_06 18 left ]
                        set p_05_r      [vectormath::perpendicular  $p_04 $p_06 18 right]
                        set p_06_l      [vectormath::perpendicular  $p_06 $p_04 18 right ]
                        set p_06_r      [vectormath::perpendicular  $p_06 $p_04 18 left]
                        
                        set shapeMAX    [list   $p_02_l $p_20_l $p_05_l $p_06_l \
                                                $p_06_r $p_05_r $p_20_r $p_02_r]
                        
                        
            
            
            
            
                            # -- set centerLine of MAX tube
                        set centerLineDef [list $S01_length $S02_length $S03_length  $S04_length  $S05_length \
                                                $P01_angle  $P02_angle  $P03_angle   $P04_angle \
                                                $S01_radius $S02_radius $S03_radius  $S04_radius \
                                                $centerLineLength] 
                                                
                            # -- set tubeProfile                 
                        set tubeProfile [my init_tubeProfile $profileDef]                 
                        # set tubeProfile [bikeComponent::tube::init_tubeProfile $profileDef]                 
                            #
                            # puts "   -> \$profileDef   $profileDef"
                            # puts "   -> \$tubeProfile  $tubeProfile"
                            #
                    }
                default {
                        puts "\n    <E>   -> could not calculate ForkBlade for $bladeStyle\n"
                        return
                    }
            }
                #
                # ------------------------------------
                # update $myCanvas ->
                # set dropOutPos    {0 0}
                # set dropoutAngle    $angleRotation
            set angleRotation   [expr {90 + $angleRotation}]
                                    
                # -- get smooth centerLine
                # puts " -> $S01_length [list $bendAngle $S02_length $bendRadius]"
                # set retValues       [bikeComponent::tube::init_centerLineNew $S01_length [list $bendAngle $S02_length $bendRadius]] 
                # exit
            
            set retValues       [my init_centerLine $centerLineDef]
            set centerLine      [lindex $retValues 0]
            set ctrLines        [lindex $retValues 1]
            set centerLineCut   [lindex $retValues 2]
            
                # -- draw shape of tube
            set outLineLeft     [my create_tubeShape $centerLineCut $tubeProfile left  ]
            set outLineRight    [my create_tubeShape $centerLineCut $tubeProfile right ]
            set outLine         [appUtil::flatten_nestedList    $outLineLeft $outLineRight]
            
                #
            set addVector [list $dropOutOffset $dropOutPerp]
            set offsetDO  [vectormath::rotatePoint {0 0}           $addVector $angleRotation]
                # set addVector [vectormath::addVector $dropOutPos [list $dropOutOffset $dropOutPerp]]
                # puts "  ->    \$dropOutPos $dropOutPos"     
                # puts "     ->    $dropOutOffset $dropOutPerp"     
                # puts "     ->    \$addVector $addVector" 
                # exit            # get startPosition of ForkBlade
                # set offsetDO  [vectormath::rotatePoint {0 0}           $addVector $dropoutAngle]
                # puts "     ->    \$offsetDO $offsetDO" 

                # -- get oriented tube
            set outLine [vectormath::rotateCoordList               {0 0} $outLine 90]


                # -- get oriented centerLine
            set centerLineCut [appUtil::flatten_nestedList $centerLineCut]
            set centerLineCut [vectormath::rotateCoordList         {0 0} $centerLineCut 90]
            set centerLineCut [vectormath::addVectorCoordList      {0 0} $centerLineCut]
                # puts "\$centerLineCut $centerLineCut"    

                # -- get oriented brakeDefLine
            set brakeDefLine [lrange $outLineRight 0 1]
                # set brakeDefLine [vectormath::addVectorCoordList       $addVector [appUtil::flatten_nestedList $brakeDefLine]]
            set brakeDefLine [appUtil::flatten_nestedList $brakeDefLine]
            set brakeDefLine [vectormath::rotateCoordList          {0 0} $brakeDefLine 90]
                # set brakeDefLine [vectormath::addVectorCoordList       {0 0} $brakeDefLine]
                # puts "\$brakeDefLine  $brakeDefLine"
            set p_001   [lrange $brakeDefLine 0 1]
            set p_002   [lrange $brakeDefLine 2 3]
                # set p_002   [lrange $brakeDefLine 2 3]2
            set brakeDefLine [list $p_001 [vectormath::addVector $p_001 [vectormath::unifyVector $p_001 $p_002 50]]]
            set brakeDefLine [appUtil::flatten_nestedList $brakeDefLine]
                # puts "\$brakeDefLine  $brakeDefLine"
            
                #
                # puts "  <D1> \$centerLineCut $centerLineCut"
                #
                #
            set outLine         $outLine           
            set brakeDefLine    $brakeDefLine
            set centerLine      $centerLineCut
                #
            if 0 {
                switch -exact $bladeStyle {
                    ma_x {
                            set _pos_startleft  [lindex $outLineLeft  0]
                            set _pos_endleft    [lindex $outLineLeft  end]
                            set _pos_startRight [lindex $outLineRight end]
                            set _pos_endRight   [lindex $outLineRight 0]
                            puts "<DDD>        \$_pos_endleft    $_pos_endleft"
                            puts "<DDD>        \$_pos_endRight   $_pos_endRight"
                            puts "<DDD>        \$_pos_startleft  $_pos_startleft"
                            puts "<DDD>        \$_pos_startRight $_pos_startRight"
                            set _pos_Start      [vectormath::center $_pos_startleft $_pos_startRight]
                            set _pos_End        [vectormath::center $_pos_endleft $_pos_endRight]
                            puts "<DDD>  $_pos_Start -> $_pos_End"
                            set centerLineCut   [appUtil::flatten_nestedList    $_pos_Start $_pos_End]
                            set centerLineCut   [vectormath::rotateCoordList  {0 0} $centerLineCut 90]
                            set centerLine      $centerLineCut
                            
                    }
                    ma_x {      set centerLine [vectormath::addVectorCoordList  [list $bladeRake $bladeHeight]  $centerLineCut]}
                    ma_x {      set centerLine [vectormath::rotateCoordList     {0 0} $centerLineCut 180]}
                    default {   set centerLine  $centerLineCut}
                }
            }
                #
            if 0 {
                set outLine         [vectormath::addVectorCoordList [vectormath::rotatePoint {0 0} $offsetDO [expr {-1 * $dropoutAngle}]] $outLine]           
                set centerLine      [vectormath::addVectorCoordList [vectormath::rotatePoint {0 0} $offsetDO [expr {-1 * $dropoutAngle}]] $centerLineCut]           
                set brakeDefLine    [vectormath::addVectorCoordList [vectormath::rotatePoint {0 0} $offsetDO [expr {-1 * $dropoutAngle}]] $brakeDefLine]
                # set posVector       [vectormath::rotatePoint {0 0} [list $Scalar(Rake) $Scalar(Height)] 180]
                # set centerLine      [vectormath::addVectorCoordList $posVector $centerLine]          
            }
            
                # puts " <I> .. \$outLine $outLine"
                # puts " <I> ... \$centerLine $centerLine"
            if 1 {
                set pos_Origin  $offsetDO
                set pos_End     [lrange $centerLine end-1 end]
                set pos_End     [vectormath::addVector $offsetDO [vectormath::rotatePoint {0 0} [lrange $centerLine end-1 end] $dropoutAngle]]
                # set pos_End     [vectormath::addVector $offsetDO [lrange $centerLine end-1 end]]
            } else {
                set pos_Origin  [vectormath::rotatePoint {0 0} $offsetDO [expr {-1 * $dropoutAngle}]]
                set pos_End     [vectormath::rotatePoint {0 0} [vectormath::addVector $offsetDO [lrange $centerLine end-1 end]] [expr {-1 * $dropoutAngle}]]
            }    
                #
            set Polygon(Blade)              $outLine                           
            set Direction(Origin)           $dropoutAngle                           
            set Position(End)               $pos_End                           
            set Position(Origin)            $pos_Origin                           
            set Polyline(CenterLine)        [vectormath::rotateCoordList {0 0} $centerLine      $dropoutAngle]                          
            set Vector(BladeDefinition)     [vectormath::rotateCoordList {0 0} $brakeDefLine    $dropoutAngle]
                # set Position(Origin)            {0 0}                           
                #
            # puts " <I> ... \$Position(Origin)       $Position(Origin)"
            # puts " <I> ... \$Position(End)          $Position(End)"
            # puts " <I> ... \$Polyline(CenterLine)   $Polyline(CenterLine)"
            # puts " <I> ... \$offsetDO               $offsetDO"
            # puts " <I> ... \$Direction(Origin)      $Direction(Origin)"
            # puts " -- "
                
            # puts " <II> ... \$bladeStyle $bladeStyle"
                #
            return [list $Polygon(Blade) $Polyline(CenterLine) $Vector(BladeDefinition) $Direction(Origin) $offsetDO]
                #
            # return [list $outLine $centerLineCut $brakeDefLine $dropoutAngle $offsetDO]
                # return [list $outLine $centerLine $brakeDefLine $dropoutAngle $offsetDO]

        }
            #
        method init_tubeProfile {profileDef args} {

            variable unbentShape
            
            array unset _tubeProfileArray
            set tubeProfile [dict create]
            
            set x 0
            set y 0
            set k 0
            set i 0
            set profLength [llength $profileDef]
            while {$i < $profLength} {
                set xy [lindex $profileDef $i]
                lassign $xy  x0 y0
                    # foreach {x0 y0} $xy break
                set x     [expr {$x + $x0}]
                set y0    [expr {0.5 * $y0}]
                    #
                set j [expr $i + 1]
                if {$j < $profLength} {
                    set xy  [lindex $profileDef $j]
                    lassign $xy  x1 y1
                        # foreach {x1 y1} $xy break
                    set y1  [expr {0.5 * $y1}]
                    set k   [expr {1.0 * ($y1 - $y0) / $x1}]
                } else {
                    set x1  10
                    set y1  $y0
                    set k   0
                }
                set _tubeProfileArray($x) [list  $y0 $k]
                incr i
            }
            set _tubeProfileArray([expr {$x + 1}]) [list  $y0 0]
            
            foreach index [lsort -real [array names _tubeProfileArray]] {
                dict append tubeProfile $index $_tubeProfileArray($index)
                # lappend profileIndex $index
                # puts "   -> $index"
            }
           
            return $tubeProfile       
        }

        method init_centerLine {centerLineDef} {
                #
            variable arcPrecission
            variable centerLineDirAngle;  array set centerLineDirAngle  {} 
            variable centerLineRadius;    array set centerLineRadius    {} 
            variable centerLineSegement;  array set centerLineAngle     {} 
            variable centerLineDefLength; array set centerLineDefLength {} 
            variable centerLinePosition;  array set centerLinePosition  {} 
            variable centerLineEnd
                # puts "  -> $arcPrecission"
            
                #
            # set centerLineDef [init_checkCenterLine $centerLineDef]
                #
          
                # --
                # puts "   ->[llength $centerLineDef] < 14"
            if {[llength $centerLineDef] < 14} {
                lassign $centerLineDef \
                    S01_length S02_length S03_length S04_length S05_length \
                    P01_angle  P02_angle  P03_angle  P04_angle \
                    S01_radius S02_radius S03_radius S04_radius
                    # foreach {S01_length S02_length S03_length S04_length S05_length \
                         P01_angle  P02_angle  P03_angle  P04_angle \
                         S01_radius S02_radius S03_radius S04_radius \
                        } $centerLineDef break
                set cuttingLength_x [expr $S01_length + $S02_length + $S03_length + $S04_length + $S05_length]
            } else {
                lassign $centerLineDef \
                    S01_length S02_length S03_length S04_length S05_length \
                    P01_angle  P02_angle  P03_angle  P04_angle \
                    S01_radius S02_radius S03_radius S04_radius \
                    cuttingLength_x
                    # foreach {S01_length S02_length S03_length S04_length S05_length \
                         P01_angle  P02_angle  P03_angle  P04_angle \
                         S01_radius S02_radius S03_radius S04_radius \
                         cuttingLength_x \
                        } $centerLineDef break
            }
                     
                  # puts "   <D> ---- \$centerLineDef ----------"
                  # puts $centerLineDef
                  # puts "   <D> --------------"

            set centerLineDefLength(1) $S01_length
            set centerLineDefLength(2) $S02_length
            set centerLineDefLength(3) $S03_length
            set centerLineDefLength(4) $S04_length
            set centerLineDefLength(5) $S05_length
            
            set centerLineAngle(0)     0
            set centerLineAngle(1)     $P01_angle
            set centerLineAngle(2)     $P02_angle
            set centerLineAngle(3)     $P03_angle
            set centerLineAngle(4)     $P04_angle
            set centerLineAngle(5)     0
            
            set centerLineDirection(0) 0
            set centerLineDirection(1) [expr {$centerLineDirection(0) + $P01_angle}]
            set centerLineDirection(2) [expr {$centerLineDirection(1) + $P02_angle}]
            set centerLineDirection(3) [expr {$centerLineDirection(2) + $P03_angle}]
            set centerLineDirection(4) [expr {$centerLineDirection(3) + $P04_angle}]
            set centerLineDirection(5) $centerLineDirection(4)
            
            set centerLineRadius(0)    0
            set centerLineRadius(1)    $S01_radius
            set centerLineRadius(2)    $S02_radius
            set centerLineRadius(3)    $S03_radius
            set centerLineRadius(4)    $S04_radius
            set centerLineRadius(5)    0
            
            set centerLineUncut        [list {0 0}]
            set ctrlPoints             {}
            
            
                #
                # puts " -> centerLineDefLength [array size centerLineDefLength]"
                #
            set i 0
            while {$i <= [array size centerLineDefLength]-1} {
                    # puts "\n"
                    # puts " == <$i> ==========================="
                set lastId $i
                set nextId [expr {$i+1}]
                set retValue    [my init_centerLineNextPosition   \
                                                        $centerLineUncut $ctrlPoints\
                                                        $centerLineRadius($lastId)  $centerLineAngle($lastId)  $centerLineDirection($lastId) \
                                                        $centerLineDefLength($nextId) \
                                                        $centerLineRadius($nextId)  $centerLineAngle($nextId)  $centerLineDirection($nextId)]
                set centerLineUncut     [lindex $retValue 0]
                set ctrlPoints          [lindex $retValue 1] 
                    # puts "  -> $ctrlPoints"
                    #if {$i == 20} { exit }
                
                incr i
            }
                #
            set controlPoints [list {0 0}]
            set i 0
            foreach {start end} $ctrlPoints {
                lappend controlPoints $start $end
            }
                #
                # puts "  -> $cuttingLength_x"
            set retValue [my cut_centerLine_inside $centerLineUncut $cuttingLength_x]
            set centerLineCut [lindex $retValue 0]
            set cuttingLength [lindex $retValue 1]
                # puts "  -> $centerLine"
                # puts "  -> $centerLineCut"
                #
            return [list $centerLineUncut $controlPoints $centerLineCut $cuttingLength]
                # return [list $centerLine $controlPoints]
                #
        }
            #
        method init_centerLineNextPosition {polyLine ctrlPoints lastRadius lastAngle lastDir distance nextRadius nextAngle nextDir} {
              #
            variable arcPrecission
              #
            set lastPos     [lindex $polyLine end]
              #
              # puts "\n -- <D> ---------------------------"
              # puts "   -> \$lastPos    $lastPos"
              # puts "   -> \$lastRadius $lastRadius"
              # puts "   -> \$lastAngle  $lastAngle"
              # puts "   -> \$lastDir    $lastDir"
              # puts "   -> \$distance   $distance"
              # puts "   -> \$nextRadius $nextRadius"
              # puts "   -> \$nextAngle  $nextAngle"
              # puts "   -> \$nextDir    $nextDir"

              #
            set lastSegment [expr {abs($lastRadius * [vectormath::rad $lastAngle])}]
            set nextSegment [expr {abs($nextRadius * [vectormath::rad $nextAngle])}]
              #
            set lastArc     [expr {0.5 * $lastSegment}]  ;# length of previous arc
            set nextArc     [expr {0.5 * $nextSegment}]  ;# length of next arc
              #        
            
              # -- get sure to have a smooth shape
            set offset      [expr {$distance - ($lastArc + $nextArc)}]
            if {$offset < 0} {
                set offset 0.5
            }
              #
              
              # puts "      -> \$offset $offset"
            set arcStart    [vectormath::addVector $lastPos  [vectormath::rotateLine {0 0} ${offset}  ${lastDir}]]  
            set ctrlEnd     [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} ${nextArc} ${lastDir}]] 
              #
            lappend polyLine   $arcStart
              #
                  # puts "    <1>  \$lastPos                              \$arcStart"
                  # puts "    <1>  {69.45050226731068 -2.385231474777072} {179.76990416419986 -15.896650836506808}"
                  # puts "    <1>   $lastPos  $arcStart"
                  # puts "    <1>         \$offset  ${offset}"
                  # puts "    <1>         \$lastDir ${lastDir}"
                  # puts "    <1>     ---------------------------"
                  # puts "    <D>       distance: $distance"
                  # puts "    <D>        lastArc: $lastArc"
                  # puts "    <D>        nextArc: $nextArc"
                  # puts "    <D>       -----------------------"
                  # puts "    <D>                 [expr $distance - $lastArc - $nextArc]"
                  # puts "    <D>       length: \$lastPos  <-> \$arcStart  [vectormath::length $lastPos  $arcStart]"
                  # puts "    <1>     ---------------------------\n"

              #
            if {$nextAngle == 0} {   
                lappend ctrlPoints $arcStart
                lappend ctrlPoints $arcStart
                  #
                return [list $polyLine $ctrlPoints]
            } else {
                if {$nextAngle < 0} {
                    set arcCenter [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} $nextRadius [expr {-1.0 * (90 - $lastDir)}]]]
                } else {  
                    set arcCenter [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} $nextRadius [expr {90 + $lastDir}]]]
                }
            }
            
              #
            set nrSegments  [expr {abs(round($nextSegment/$arcPrecission))}]
            if {$nrSegments < 1} {
                  # puts "    -> nrSegments: $nrSegments"
                set nrSegments 1
            }
              #
            set deltaAngle  [expr {1.0*$nextAngle/$nrSegments}]
              # puts "  ->  Segments/Angle: $nrSegments $deltaAngle"
            set arcEnd  $arcStart
            set i 0
            while {$i < $nrSegments} {
                  set arcEnd  [vectormath::rotatePoint $arcCenter $arcEnd $deltaAngle]
                  lappend polyLine $arcEnd
                    # puts "  -> i/p_End:  $i  $p_End"
                    # set pStart $p_End
                  incr i
            }
            set ctrlStart [vectormath::addVector $arcEnd  [vectormath::rotateLine {0 0} ${nextArc}  [expr {180 + ${nextDir}}]]] 
              #
            lappend ctrlPoints $ctrlEnd
            lappend ctrlPoints $ctrlStart
              #
            return [list $polyLine $ctrlPoints]
        }
            #
        method cut_centerLine_inside {centerLine length_x} {
            set centerLineCut {}
              # puts "\n ------"
              # puts "   -> \$centerLine $centerLine"
              # puts "   -> \$length_x   $length_x"
              # puts " ------\n"
            set newLength     0
            set lastLength    0
            set lastXY       {0 0}
            set i 0
            foreach {xy} $centerLine {
                incr i
                    # puts "     $i -> $xy"
                lassign $xy  x y
                    # foreach {x y} $xy break
                set offset      [vectormath::length $lastXY $xy]
                    # puts "               -> $offset  <- $lastXY"
                set newLength   [expr {$newLength + $offset}]
                    #
                if {$x < $length_x} {
                    set lastLength  $newLength
                    set lastXY      $xy
                    lappend centerLineCut $xy
                        # puts "   -> $x  <- $length_x"
                } else {
                        # puts "   -> $x  <- $length_x ... exception"
                    lassign $lastXY  last_x last_y
                        # foreach {last_x last_y} $lastXY break
                    set seg_x       [expr {$length_x - $last_x}]
                    set segVct      [vectormath::unifyVector $lastXY $xy]
                    set dx          [expr {$seg_x * [lindex $segVct 0]}]
                    set dy          [expr {$seg_x * [lindex $segVct 1]}]
                    set segEnd      [vectormath::addVector $lastXY [list $dx $dy]]
                    
                    #set deltaOffset  [expr $length - $lastLength]
                    #set lastPosVct   [vectormath::unifyVector $lastXY $xy $deltaOffset]
                    lappend centerLineCut $segEnd
                        #
                    set cuttingLength [expr {$lastLength + [vectormath::length {0 0} [list $dx $dy]]}]
                        #
                        # puts "   -> [lindex $segEnd 0]  <- $length_x"
                        #
                    return [list $centerLineCut $cuttingLength]
                }

            }
                #
                #
                #
                # ... in case of centerLine definition does not reach length_x
                #
                # puts "\n\n\n\n   <E> cut_centerLine exception \n\n\n\n "
                # puts "\n ------"
                # puts "   -> $x  ... did not reach $length_x"
                # puts "   ... \$length_x   $length_x"
                # puts "   ... \$lastLength $lastLength"
                # puts "   ... \$lastXY     $lastXY"
                #
            # just give it a try ( a copy from cut_centerLine) ... not analyzed    
                #
            set prevXY  [lindex $centerLineCut end-1]
                # puts "   ... \$prevXY     $prevXY"
            set delta_X [expr {$length_x - [lindex $lastXY 0]}]
                # puts "   ... \$delta_X     $delta_X"
                # puts "   ... [expr $length_x / $lastLength]"
            if {[expr {$length_x / $lastLength}] < 1.001} {
                return [list $centerLineCut $lastLength]
            }
                #
            set dirVct  [vectormath::unifyVector $prevXY $lastXY]
            set delta_L [expr {[lindex $dirVct 0] / $delta_X}]
                #
            set cuttingLength [expr {$lastLength + $delta_L}]
                #puts "   ... \$cuttingLength     $cuttingLength"
                #
            set vctExt  [vectormath::unifyVector $prevXY $lastXY $delta_L]
                #
            lappend centerLineCut [vectormath::addVector $lastXY $vctExt]
                #
                # puts "\n ------"
                #
            return [list $centerLineCut $cuttingLength]
                #
                # -- exception if length is longer than the profile
            # return  $centerLineCut
        }
            #
        method create_tubeShape {centerLine tubeProfile side} {
          
            variable arcPrecission
            
            set linePosition 0
                # set bentProfile {}
              
            set lineOffset  [my get_tubeProfileOffset $tubeProfile $linePosition]

                # puts "        ---> $bentProfile"
            set xPrev {}
            set yPrev {}
                #
            set p_last      [lindex $centerLine end]
            set p_last_1    [lindex $centerLine end-1]
                # removed by 1.49
                # set vct_last    [vectormath::unifyVector $p_last_1 $p_last 0.5]
                # set p_apnd      [vectormath::addVector $p_last $vct_last]
                # lappend centerLine $p_apnd
                #
                # puts "\n\n --- bikeComponent::tube::create_tubeShape -- "
                # puts "   $centerLine"

            
            set xy1     [lindex $centerLine 0]
            set xyEnd   [lindex $centerLine end]
            set xyEnd_1 [lindex $centerLine end-1]
                #
            set dirEnd  [vectormath::unifyVector $xyEnd_1 $xyEnd 10]
                #
            lappend centerLine [vectormath::addVector $xyEnd $dirEnd]
                #
            foreach xy2 [lrange $centerLine 1 end] {
                    #
                lassign $xy1  x1 y1 
                lassign $xy2  x2 y2 
                    # foreach {x1 y1} $xy1 break 
                    # foreach {x2 y2} $xy2 break 
                    # puts "   $xy1"
                    # puts "   $xy2"
                    #
                set angle       [vectormath::dirAngle $xy1 $xy2]
                set segLength   [vectormath::length   $xy1 $xy2]
                    #
                if {$side == {left}} {
                    set offsetAngle [expr {$angle + 90}]
                } else {
                    set offsetAngle [expr {$angle - 90}]
                }
                    #
                set nrSegments  [expr {abs(round($segLength/$arcPrecission))}]
                if {$nrSegments < 1} {
                      # puts "    -> nrSegments: $nrSegments"
                    set nrSegments 1
                }
                set segLength   [expr {$segLength/$nrSegments}]            
                    #
                set p_Start    $xy1
                set lastOffset {}
                set j 0
                while {$j < $nrSegments} {
                    set linePosition  [expr {$linePosition + $segLength}]
                    set lineOffset    [my get_tubeProfileOffset $tubeProfile $linePosition]
                    set p_Offset      [vectormath::rotateLine $p_Start $lineOffset  $offsetAngle]
                    set p_Next        [vectormath::rotateLine $p_Start $segLength   $angle]
                      # -- add to bentProfile
                    if {$lineOffset != $lastOffset} {
                        lappend bentProfile $p_Offset
                        # puts "           -> $p_Offset"
                        set lastAppend 1
                    } else  {
                        set lastAppend 0
                    }
                        # puts "        ---> [lindex $bentProfile end]"
                        # puts "         ->  + $segLength = $linePosition / $lineOffset  |  $offsetAngle"
                        # -- prepare next loop
                    set p_Start    $p_Next
                    set lastOffset $lineOffset
                    incr j
                } 
                    #
                set xy1 $xy2
                    #
            }
                #
                #
                # puts "\nbikeComponent::tube::create_tubeShape   -> $xy2\n"
                #
            if {$side == {left}} {
                return $bentProfile
            } else {
                return [lreverse $bentProfile]
            }
                #
        } 
            #
        method get_tubeProfileOffset {profile position} {
            
            variable unbentShape

            #set profileIndex {}
              # puts "dict: $profile"
              # puts "keys: [dict keys $profile]"
            foreach offset [lsort -real [dict keys $profile]] {
                lappend profileIndex $offset
                # puts "   -> $offset"
            } 
                # puts "\$profileIndex  $profileIndex"

            foreach index $profileIndex {
                #puts "      <D10>  $index $position"        
                if {$position >= [expr {1.0 * $index}]} {
                    set k {}
                    set value [dict get $profile $index]
                        # set value $tubeProfile($index)
                    set d_profile $index
                    lassign $value  d k
                        # foreach {d k}  $value break
                }
            }
            set dx [expr {$position - $d_profile}]
            set offset [expr {$d + $dx*$k}]
              # puts ">$offset"
            
            return $offset
              # return [list $position $offset]
        }
            #
        method get_ResultValue {key} {
                #
            variable Scalar                                       
            variable Polygon                                       
            variable Direction                                       
            variable Polyline                                
            variable Position
                #
            switch -exact $key {
                outLine         {return $Polygon(Blade)}
                centerLine      {return $Polyline(CenterLine)}
                brakeDef        {return $Vector(BladeDefinition)}
                angleDropout    {return $Direction(Origin)}
                position        {return $Position(Origin)}
                default {}
            }
                #
        }    
            #
        method update_SVGNode {} {
                #
            variable ComponentNode
            variable Polygon
                #
                #
            set compDoc         [$ComponentNode(XZ) ownerDocument ]
            set compNode        [$ComponentNode(XZ) find id customComponent]
                
                #
                # -- cleanup
                #
            foreach childNode   [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }

                #
                # -- ForkBlade
                #
                # puts "     -> [llength $Polygon(Blade)] - $Polygon(Blade)"
            set polygon         {}
            foreach {x y} $Polygon(Blade) {
                lappend polygon $x 
                lappend polygon [expr {-1.0 * $y}]
            }
            set polygon         [my format_PointList $polygon]
                #
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      BladeShape
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  $polygon
                #
   

                #
                # -- cleanup attribure: xlmns from first layer
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }

                #
            return
                #
        }    
            #
    }    

