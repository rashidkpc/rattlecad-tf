 ##+##########################################################################
 #
 # package: bikeFrame    ->    classChainStay.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/19
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
 #    namespace:  bikeFrame
 # ---------------------------------------------------------------------------
 #
 # http://www.magicsplat.com/articles/oo.html
 #
 #
 # 0.00 - 20160417
 #      ... new: rattleCAD - 3.4.03
 #
 #
 #


oo::class create bikeFrame::ChainStay {
        #
    superclass bikeFrame::AbstractTube
        #
    constructor {} {
            #
        puts "              -> class ChainStay"
            #
        next                ;# call constructor of superclass AbstractComponent
            #
        variable Config ; array set Config {
                                Type                {straight}
                            }
        variable Scalar ; array set Scalar {
                                BottomBracket_DiaInside   10.39
                                BottomBracket_Width      130.00
                                OffsetBBTopView            3.21
                                OffsetDO                  31.21
                                OffsetDOPerp              -3.21
                                OffsetDOTopView           35.21
                                RearHub_Width             49.21
                                Length_XZ                391.21
                                DiameterSS                11.21
                                Height                    28.21
                                HeightBB                  23.21
                                LengthTaper              279.21
                                WidthBB                   21.21
                                completeLength            {}
                                cuttingAngle              90.00
                                cuttingLeft              409.21
                                cuttingLength              0.21
                                profile_x01              149.21
                                profile_x02              151.21
                                profile_x03               96.21
                                profile_y00               11.21
                                profile_y01               19.21
                                profile_y02               17.21
                                segmentAngle_01           -8.21
                                segmentAngle_02            5.21
                                segmentAngle_03            0.21
                                segmentAngle_04           -2.21
                                segmentLength_01          51.21
                                segmentLength_02         161.21
                                segmentLength_03          48.21
                                segmentLength_04          61.21
                                segmentRadius_01         321.21
                                segmentRadius_02         321.21
                                segmentRadius_03         321.21
                                segmentRadius_04         321.21
                            }
        variable Position ; array set Position {
                                xy          {}
                                xz          {}
                            }
        variable Shape  ; array set Shape {
                                xy          {}
                                xz          {}
                            }
            #
            #
        variable arcPrecission  5;# number of segments per arc  
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
    method update {} {
            #
        variable Scalar
        variable Position
        variable Profile
        variable Shape 
            #
        #puts "\$Scalar(completeLength) $Scalar(completeLength)"
        #puts "\$Scalar(Length_XZ)      $Scalar(Length_XZ)"
        #set Scalar(Length_XZ)          [vectormath::length $Position(Origin) $Position(End)]
        #puts "\$Scalar(Length_XZ)      $Scalar(Length_XZ)"
            #
    }
        #
    method update_Shape {} {        
            #
        variable Profile
        variable Scalar
        variable Shape
                #
        variable tubeMiter_Start
        variable tubeMiter_End
            # 
        set diameter(p0)    $Scalar(DiameterSS)
        set diameter(p1)    $Scalar(Height)
        set diameter(p2)    $diameter(p1)
        set diameter(p3)    $Scalar(HeightBB)
        set diameter(p4)    $Scalar(HeightBB)
            #            
            # set length(p1)      $Scalar(LengthTaper)
        if { [expr {$Scalar(Length_XZ) - $Scalar(LengthTaper)}] < 60 } {
            # puts "            ... exception:  ChainStay LengthTaper ... $tube_length / $ChainStay(LengthTaper)"
            set length(p1)  [expr {$Scalar(Length_XZ) - 60}]
        } else {
            set length(p1)  $Scalar(LengthTaper)
        }
            #
        if 1 {
            set lengthEnd   [expr {$Scalar(Length_XZ) - $length(p1)}]
            set length(p2)  [expr {0.30 * $lengthEnd}]
            set length(p3)  [expr {0.40 * $lengthEnd}]
            set length(p4)  [expr {0.30 * $lengthEnd}]
        } else {
                # set length(p2)      40
            set length(p2)      [expr {$Scalar(profile_x01) + $Scalar(profile_x02) - $length(p1)}]
            if {[expr {$length(p1) + $length(p2)}] > $Scalar(Length_XZ)} {
                set length(p2)  [expr {$Scalar(Length_XZ) - $length(p1) - 10}]
            }                       
                # set length(p3)      50
            set length(p3)      $Scalar(profile_x03)
            if {[expr {$length(p1) + $length(p2) + $length(p3)}] > $Scalar(Length_XZ)} {
                set length(p3)  [expr {$Scalar(Length_XZ) - $length(p1) - $length(p2) -5}]
            }                       
                # set length(p4)      ...
            set length(p4)      [expr {$Scalar(Length_XZ) - $length(p1) - $length(p2) - $length(p3)}]
            if {$length(p4) < 5} {
                set length(p4)  5
            }
        }
            #          
            #
        set length(00)      0
        set length(01)      $length(p1)
        set length(02)      [expr {$length(01) + $length(p2)}]
        set length(03)      [expr {$length(02) + $length(p3)}]
        set length(04)      [expr {$length(03) + $length(p4)}]
            #
        set Profile(xz)     [list \
                                $length(00) [expr {0.5 *$diameter(p0)}] \
                                $length(01) [expr {0.5 *$diameter(p1)}] \
                                $length(02) [expr {0.5 *$diameter(p2)}] \
                                $length(03) [expr {0.5 *$diameter(p3)}] \
                                $length(p4) [expr {0.5 *$diameter(p4)}] \
                            ]
            #
            #
        $tubeMiter_Start    setConfig   Type            planeMiter    
        $tubeMiter_Start    setScalar   DiameterTube    $diameter(p0)
        $tubeMiter_End      setConfig   Type            planeMiter    
        $tubeMiter_End      setScalar   DiameterTube    $diameter(p4)
            #
        my _setShape5       $tubeMiter_Start \
                            $tubeMiter_End \
                            $diameter(p0) \
                            $length(p1) \
                            $diameter(p1) \
                            $length(p2) \
                            $diameter(p2) \
                            $length(p3) \
                            $diameter(p3) \
                            $length(p4) \
                            $diameter(p4)
            #
        my update_XY
            #
            # puts "\n ---------------"    
            # puts "    -> \$Scalar(cuttingAngle) $Scalar(cuttingAngle)"
            # puts "---------------\n"    
            #
        if {$Scalar(cuttingAngle) != 90} {
                #
            my CutShape_XZ_Start
                #
        }        
            #
        return
            #
    }
        #
    method update_XY {} {
            #
        variable Config            
        variable Scalar
            #
        variable Shape
            #
        variable Geometry
        variable Polygon
        variable Position
        variable Profile
        variable CenterLine
            #
        variable Result
            #
            #
        set position(ChainStay_DO)  [list [expr {0 - $Scalar(Length_XZ)}]   [expr {0.5 * $Scalar(RearHub_Width) + $Scalar(OffsetDOTopView)}]]
        set position(BB_Edge)       [list [expr {-0.5 * $Scalar(BottomBracket_DiaInside)}]  [expr {0.5 * $Scalar(BottomBracket_Width) - $Scalar(OffsetBBTopView)}]] 
        set position(ChainStay_BB)  [vectormath::cathetusPoint $position(ChainStay_DO) $position(BB_Edge) [expr {0.5 * $Scalar(WidthBB)}] opposite]
            #
        set ChainStay_Start_X       [expr {$Scalar(Length_XZ) + $Scalar(OffsetDO)}]
        set ChainStay_Start_X       $Scalar(Length_XZ)
            # puts "  -> \$Scalar(Length_XZ)  $Scalar(Length_XZ)"
            # puts "  -> \$Scalar(OffsetDO)   $Scalar(OffsetDO)"
            # puts "  -> \$ChainStay_Start_X  $ChainStay_Start_X"
            
            # -- define profile of tube shape
        set profileDef {}
            lappend profileDef [list 0                    $Scalar(profile_y00)]
            lappend profileDef [list $Scalar(profile_x01) $Scalar(profile_y01)]
            lappend profileDef [list $Scalar(profile_x02) $Scalar(profile_y02)]
            lappend profileDef [list $Scalar(profile_x03) $Scalar(WidthBB)]        
            # puts "  -> \$profileDef $profileDef"
        
            # -- set profile of straight, unbent tubeprofile
        set tubeProfile [my __init_tubeProfile $profileDef]               
            # puts "  -> \$tubeProfile $tubeProfile"
  
  
            # -- tube centerline
        set max_length     $Scalar(Length_XZ)
        set S01_length     $Scalar(segmentLength_01)       
        set S02_length     $Scalar(segmentLength_02)       
        set S03_length     $Scalar(segmentLength_03)       
        set S04_length     $Scalar(segmentLength_04)       
        set tmp_length     [expr {$S01_length + $S02_length + $S03_length + $S04_length}]
        set S05_length     [expr {$max_length - $tmp_length}]
            #
        switch -exact $Config(Type) {
          {straight} {
                set S01_angle        0
                set S02_angle        0
                set S03_angle        0
                set S04_angle        0
                set S01_radius     320
                set S02_radius     320
                set S03_radius     320
                set S04_radius     320
              }
          default {
                  # -- bent                                                
                set S01_angle      $Scalar(segmentAngle_01) 
                set S02_angle      $Scalar(segmentAngle_02) 
                set S03_angle      $Scalar(segmentAngle_03) 
                set S04_angle      $Scalar(segmentAngle_04) 
                set S01_radius     $Scalar(segmentRadius_01)
                set S02_radius     $Scalar(segmentRadius_02)
                set S03_radius     $Scalar(segmentRadius_03)
                set S04_radius     $Scalar(segmentRadius_04)
            }
        }
            # --- check angle: S04_angle
            # puts "\n --checkAngles--------"
            # puts "     -> \$S04_length $S04_length"
            # puts "     -> \$S04_angle  $S04_angle"
            # puts "     -> \$S05_length $S05_length"
            # puts " ----------"
            # -- check S04_angle / S05_length
        if {$S05_length < 0} {
            set my_S04_angle  0
            set my_S05_length 5
        } else {
            set my_S04_angle  $S04_angle
            set my_S05_length $S05_length
        }
            #
        set centerLineDef [list \
                    $S01_length $S02_length $S03_length $S04_length $my_S05_length \
                    $S01_angle  $S02_angle  $S03_angle  $my_S04_angle \
                    $S01_radius $S02_radius $S03_radius $S04_radius \
                    $ChainStay_Start_X]
                                
            # -- get smooth centerLine
        set retValues       [my __init_centerLine $centerLineDef] 
        set centerLineUnCut [lindex $retValues 0]
        set ctrLines        [lindex $retValues 1]
        set centerLine      [lindex $retValues 2]
            #
            
            # -- get outline
        set outLineOrient   [my __create_tubeShape  $centerLineUnCut  $tubeProfile left  ]
           
            # -- get orientation of tube
        set length          [vectormath::length   $position(ChainStay_DO) $position(BB_Edge)]
        set angle           [vectormath::dirAngle $position(ChainStay_DO) $position(BB_Edge)]
            # puts "  -> \$length $length"
            # puts "  -> \$angle $angle"
        set pointIS         [my __get_shapeInterSection $outLineOrient $length]       
        set angleIS         [vectormath::dirAngle {0 0} $pointIS]
        set angleRotation   [expr {$angle - $angleIS}]
            # puts "  -> \$point_IS $point_IS"
            # puts "  -> \$angleIS $angleIS"
            # puts "  -> \$angleRotation $angleRotation"
            
            # -- prepare $outLine for export 
        set outLineOriented [vectormath::rotateCoordList {0 0} [my __flatten_nestedList $outLineOrient]    $angleRotation]    
            
            # -- orient $centerLineUnCut
        set centerLineUnCut [vectormath::rotateCoordList {0 0} [my __flatten_nestedList $centerLineUnCut]  $angleRotation]    
            #puts " ---> \$centerLineUnCut $centerLineUnCut"
            
            # -- get centerLine & cutLength (center BB]
            #
        set retValue        [my __cut_centerLine $centerLineUnCut $ChainStay_Start_X]
        set centerLine      [lindex $retValue 0]
        set cuttingLength   [lindex $retValue 1]
            #
        set ChainStay(cuttingLength)    $cuttingLength
        set Scalar(cuttingLength)       $cuttingLength
            #
        set outLineLeft     [my __create_tubeShape     $centerLine     $tubeProfile left  ]
        set outLineRight    [my __create_tubeShape     $centerLine     $tubeProfile right ]
        set outLine         [my __flatten_nestedList   $outLineLeft    $outLineRight]
            #
        set Position(ChainStay_RearMockup)  $position(ChainStay_DO)
        set Position(xy)                    $position(ChainStay_DO)
        set Polygon(RearMockup)             $outLine
            #
            #
          
            # -- prepare $ctrLines for export 
        set ctrLines         [my __flatten_nestedList $ctrLines]
        set ctrLines         [vectormath::rotateCoordList {0 0} $ctrLines $angleRotation]    
            #
            #
            
            # -- prepare profiles for export
        set summLength  0
        set prev_xy     [list 0 [expr {0.5 * $Scalar(profile_y00)}]]
        set polygon     $prev_xy
            # puts "\n   ... -> \$ChainStay(completeLength) $ChainStay(completeLength)"
        foreach {segment_x segment_y} [list $Scalar(profile_x01)    $Scalar(profile_y01) \
                                            $Scalar(profile_x02)    $Scalar(profile_y02) \
                                            $Scalar(profile_x03)    $Scalar(WidthBB) \
                                            $Scalar(completeLength) $Scalar(WidthBB)] {
                # puts "    $segment_x $segment_y"
            lassign  $prev_xy  prev_x prev_y
                # foreach {prev_x prev_y} $prev_xy break
            set newLength [expr {$prev_x + $segment_x}]
            if {$newLength < $Scalar(completeLength)} {
                    # puts " $prev_x $prev_y"
                set newWidth    [expr {0.5 * $segment_y}]
                set this_xy     [list $newLength $newWidth]
                lappend polygon $newLength $newWidth
                    # puts "     ... $this_xy"
                set prev_xy $this_xy
            } else {
                set diffLength  [expr {$Scalar(completeLength) - $prev_x}]
                set newLength   [expr {$prev_x + $diffLength}]
                set segment_y   [expr {0.5 * $segment_y}]
                set newWidth    [expr {$prev_y + (($segment_y - $prev_y) / $segment_x) * $diffLength}]
                set this_xy [list $newLength $newWidth]
                lappend polygon $newLength $newWidth
                    # puts "     ... $this_xy"
                break
            }
        }
            #
        set Profile(xy)   $polygon    
            #
            
            #
            #
            # -- store Values
            # 
        set CenterLine(RearMockup_CtrLines) [my __format_XcommaY $ctrLines]
        set CenterLine(RearMockup)          [my __format_XcommaY [my __flatten_nestedList $centerLine]]
        set CenterLine(RearMockup_UnCut)    [my __format_XcommaY $centerLineUnCut]
            #
            # --- top Profile View
            # $ChainStay(completeLength)
            #                                
        set CenterLine(xy)          $CenterLine(RearMockup)    
        set CenterLine(xy_Control)  $CenterLine(RearMockup_CtrLines)    
        set CenterLine(xy_Full)     $CenterLine(RearMockup_UnCut)    
            #
            # set Profile(xy)             $tubeProfile
            #
        # puts ""
        # parray CenterLine
        # puts ""
        # parray Polygon
        # puts ""
            # exit
            #
            # --- return values
        set Shape(xy)   $Polygon(RearMockup)
            #
            #
        if 0 {
                puts " ---- ChainStay -class-end-"    
                parray Scalar
                parray Polygon
                parray position
                parray Position
                parray Shape
                #exit
        }
            #
        return
            # return $Polygon(RearMockup)
            # return $Polygon(ChainStay_xy)
            # 
    }
        #
    method CutShape_XZ_Start {} {
            #
        variable Scalar
        variable Shape
            #
        # parray Scalar    
            #
            # puts "010 -> CutShape_XZ_Start -> $Scalar(cuttingAngle)"
            #
        if {$Scalar(cuttingAngle) != 90} {
                #
                #
                # puts "\n ---------------"    
                # puts "    -> \$Shape(xz) $Shape(xz)"
                # puts "---------------\n"    
                #
                # -- cleanup $Shape(xz)
                #      ... minimize mitter points on x=0
                #
            set _shape_ $Shape(xz)
                #
            set shapeXZ {}
            set listX0  {}
            foreach {x y} $Shape(xz) {
                if {round($x) == 0} {
                    lappend listX0 $y
                } else {
                    lappend shapeXZ [format {%0.6f} $x] [format {%0.6f} $y]
                }
                set listX0 [lsort -real $listX0]    
            }
            if {$listX0 ne {}} {
                    # puts "  -> $listX0"
                set y00 [lindex $listX0 end]
                set y99 [lindex $listX0 0]
                set shapeXZ [join "0 $y00 $shapeXZ 0 $y99" " "]
            }
                #
            set Shape(xz) $shapeXZ 
                #
            set shape00 [lrange $Shape(xz) 2     end-2]    
                #
            set p_top01 [lrange $Shape(xz) 0     1]
            set p_top02 [lrange $Shape(xz) 2     3]
            set p_bot01 [lrange $Shape(xz) end-1 end]
            set p_bot02 [lrange $Shape(xz) end-3 end-2]
                #
                # puts "010 -> CutShape_XZ_Start"    
                # puts "    -> \$p_top01 $p_top01"    
                # puts "    -> \$p_top02 $p_top02"    
                # puts "    -> \$p_bot01 $p_bot01"    
                # puts "    -> \$p_bot02 $p_bot02"    
                #
            if {[expr {abs($Scalar(cuttingAngle))}] < 45} {
                if {$Scalar(cuttingAngle) > 0} {
                    set Scalar(cuttingAngle)  45.0
                } else {
                    set Scalar(cuttingAngle) -45.0
                }
            }    
                #
                #
            if {$Scalar(cuttingAngle) < 90} {
                    #
                    # puts "030 -> CutShape_XZ_Start: $Scalar(cuttingAngle) < 90"
                set p_top00 $p_top01
                    #
                set p_cut00 [vectormath::rotateLine $p_top00 1 [expr {0 - $Scalar(cuttingAngle)}]]
                set p_bot00 [vectormath::intersectPoint $p_bot01 $p_bot02 $p_top00 $p_cut00]
                    #
                    # puts "031 -> CutShape_XZ_Start: \$p_top00 $p_top00"
                    # puts "031 -> CutShape_XZ_Start: \$p_cut00 $p_cut00"
                    # puts "031 -> CutShape_XZ_Start: \$p_bot00 $p_bot00"
                    #
                    # puts "    -> \$_shape_ $_shape_"    
                    # puts "    -> \$shape00 $shape00"    
                set shape01 [join "$p_top00 $shape00" " "]    
                    # puts "    -> \$shape01 $shape01"    
                set shape02 [join "$shape01 $p_bot00" " "]    
                    # puts "    -> \$shape02 $shape02"    
                    #
                set Shape(xz) $shape02
                    #
            } else {
                    #
                    # puts "030 -> CutShape_XZ_Start: $Scalar(cuttingAngle) > 90"
                    #
                set p_bot00 $p_bot01
                    #
                set p_cut00 [vectormath::rotateLine $p_bot00 1 [expr {0 - $Scalar(cuttingAngle)}]]
                set p_top00 [vectormath::intersectPoint $p_top01 $p_top02 $p_bot00 $p_cut00]
                    #
                set shape01 [join "$p_top00 $shape00" " "]    
                    # puts "    -> \$shape01 $shape01"    
                set shape02 [join "$shape01 $p_bot00" " "]    
                    # puts "    -> \$shape02 $shape02"    
                    #
                set Shape(xz) $shape02
                    #
            }
                # puts "099 -> CutShape_XZ_Start :-> $_shape_"    
                # puts "099 -> CutShape_XZ_Start :-> $Shape(xz)"    
                # puts "\n ---------------"    
                # puts "    -> \$Shape(xz) $Shape(xz)"
                # puts "    -> \$Shape(xz) [llength $Shape(xz)]"
                # puts "---------------\n"
                #
        }        
            #
    }
        #
        #
    method setConfig {keyName value} {
        variable Config
        switch -exact $keyName {
            Type {
                    set Conifg$keyName) $value
                } 
            default {   
                    return
                }
        }
        return [my prototype_getConfig $keyName]
    }
        # 
    method setScalar {keyName value} {
        variable Scalar
        switch -exact $keyName {
            BottomBracket_DiaInside -
            BottomBracket_Width     -
            OffsetBBTopView         -
            OffsetDO                -
            OffsetDOPerp            -
            OffsetDOTopView         -
            RearHub_Width           -
            Length_XZ               -
            DiameterSS              -
            Height                  -
            HeightBB                -
            LengthTaper             -
            WidthBB                 -
            completeLength          -
            cuttingAngle            -
            cuttingLeft             -
            cuttingLength           -
            profile_x01             -
            profile_x02             -
            profile_x03             -
            profile_y00             -
            profile_y01             -
            profile_y02             -
            segmentAngle_01         -
            segmentAngle_02         -
            segmentAngle_03         -
            segmentAngle_04         -
            segmentLength_01        -
            segmentLength_02        -
            segmentLength_03        -
            segmentLength_04        -
            segmentRadius_01        -
            segmentRadius_02        -
            segmentRadius_03        -
            segmentRadius_04 {
                    set Scalar($keyName) $value
                } 
            default {   
                    return
                }
        }
        return [my prototype_getScalar $keyName]
    }
        #
    method setDictionary {keyDict} {
        variable Scalar
        
        # appUtil::pdict $dictValue
        
        return
    }
        #
        #
}