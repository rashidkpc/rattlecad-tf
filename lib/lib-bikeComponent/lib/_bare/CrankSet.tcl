 ##+##########################################################################te
 #
 # package: bikeComponent   ->  lib_CrankSet.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/09/12
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
 #  namespace:  bikeComponent::CrankSet      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::bareCrankSet {

            # <CrankSet>
            #     <File>etc:crankset/custom.svg</File>
            #     <Length>172.50</Length>
            #     <PedalEye>17.50</PedalEye>
            #     <Q-Factor>145.50</Q-Factor>
            #     <ArmWidth>13.75</ArmWidth>
            #     <ChainLine>43.50</ChainLine>
            #     <ChainRings>39-53</ChainRings>
            #     <ChainRingOffset>5</ChainRingOffset>
            #     <SpyderArmCount>5</SpyderArmCount>
            # </CrankSet>

        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
            #

        constructor {} {
                #
            set   objectName    "CrankSet"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #
            variable Config             ; array set Config {
                                                SpyderArmCount           5
                                                ComponentKey           etc:crankset/campagnolo_ultra_torque.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                Length                 172.50
                                                PedalEye                17.50
                                                Q-Factor               145.50
                                                ArmWidth                13.75
                                                ChainLine               43.50
                                                ChainRingOffset          5
                                                BottomBracket_Width     68.00
                                            } 
            variable ListValue          ; array set ListValue {
                                                ChainRings          {25-39-53}
                                                ChainWheelDef     {75-110-135}
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XY_Custom                   {}
                                                XZ_Custom                   {}
                                                XZ                          {}
                                            }                     
            variable Direction          ; array set Direction {
                                                Origin                     0.00
                                            }
            variable Polygon            ; array set Polygon {
                                                XY_ChainWheels              {}
                                                XY_CrankArm                 {}
                                                XZ_ChainWheels              {}
                                                XZ_CrankArm                 {}
                                                XZ_SpyderArm                {}
                                            }
            variable Position           ; array set Position {
                                                Bolts                {1.00 0.00}
                                                Origin               {0.00 0.00}
                                            }
                                            
            variable anglePrecStep                 2.5 ;# offset Angle of representing polygon of arc
            variable toothWith                    12.7
            variable crankWidth_BB                42
            variable crankWidth_Pedal             32
            variable bcDiameter                  110
            variable componentPath                {}

            set ComponentNode(XY_Custom)        [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Custom)        [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ)               [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                    
            variable nodeSVG_Empty              [my readSVGFile [file join $packageHomeDir components default_template.svg]]

        }

        #-------------------------------------------------------------------------
            #  create custom crankset
            #
        method update {} {
            my update_polygon_CrankArm
            my update_polygon_CrankArm_XY
            my update_CustomXY
            my update_CustomXZ
            my update_XZ
        }
            #
        method update_CustomXZ {} {
                #
            variable Config
            variable Scalar
            variable ListValue
                #
            variable ComponentNode
            variable Polygon
            variable Position
                #
                
                #
            set compDoc         [$ComponentNode(XZ_Custom) ownerDocument ]
            set compNode        [$ComponentNode(XZ_Custom) find id customComponent]
                
                # puts ""
                # puts "   -------------------------------"
                # puts "   createCrank_Custom"
                # puts "       crankLength:    $crankLength"
                # puts "       teethCountList: $teethCountList"
                # puts "       teethCountMax:  $teethCountMax"
                # puts "       bcDiameter:     $bcDiameter"
            
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                
                #
                # -- ChainWheel
                #
            set ListValue(ChainWheelDef) {}
            set ListValue(ChainWheelDef) [my _get_ChainWheelDefinition $ListValue(ChainRings)]
                #
            set Polygon(XZ_ChainWheels)  [dict create]
                #
            foreach {teethCount bcDiameter} $ListValue(ChainWheelDef) {
                    #
                # puts " ------------------------------------- "    
                # puts "          -> \$teethCount $teethCount"    
                # puts "          -> \$visMode    $visMode"    
                # puts "          -> \$bcDiameter $bcDiameter"    
                    #
                    # puts "  ...  get_myParameter   ChainWheel  $teethCount  $BB_Position  $visMode  __default__ $bcDiameter"
                    #
                set visMode         polygon
                    #
                set polygonChainWheel [my _get_polygon_ChainWheel $teethCount $visMode $Config(SpyderArmCount) $bcDiameter ]
                    #
                dict append Polygon(XZ_ChainWheels) $teethCount \
                                                        [list \
                                                                outerProfile [string map {, " "} [lindex $polygonChainWheel 1]] \
                                                                innerProfile [string map {, " "} [lindex $polygonChainWheel 5]] \
                                                            ]
                                                    
                    #
                    
                    #
                set visMode         polyline
                    #
                set polygonChainWheel [my _get_polygon_ChainWheel $teethCount $visMode $Config(SpyderArmCount) $bcDiameter ]
                    #
                set groupNode   [$compDoc createElement g]
                    $compNode   appendChild     $groupNode
                    $groupNode  setAttribute    id  $teethCount    
                    #
                foreach {key value} $polygonChainWheel {
                        #
                    set pointList $value 
                    switch -exact $key {
                        closed {
                            set newNode [$compDoc createElement polygon]
                                $groupNode  appendChild     $newNode
                                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                                $newNode    setAttribute    points   $pointList
                        }
                        opened {
                            set newNode [$compDoc createElement polyline]
                                $groupNode  appendChild     $newNode
                                $newNode    setAttribute    style   "stroke:black;fill:none;stroke-width:0.2"
                                $newNode    setAttribute    points   $pointList
                        }
                        default {
                            tk_messageBox -message " $key \n $value "
                        }
                    }
                }
            }

                    
                #
                # -- SpyderArms
                #
            set diameterBC                      [lindex $ListValue(ChainWheelDef) end]    
                #
            set Polygon(XZ_SpyderArm)           [my _get_polygon_CrankSpyder $diameterBC $Config(SpyderArmCount)]
                #
            set newNode [$compDoc createElement polygon]
                    $compNode   appendChild     $newNode
                    $newNode    setAttribute    id      SpyderArm
                    $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                    $newNode    setAttribute    points  [my format_PointList $Polygon(XZ_SpyderArm)]
                #

                
                #
                # -- ChaineWheelBolts
                #
            set Position(Bolts)     [my _get_position_ChainWheelBolts $diameterBC $Config(SpyderArmCount)]
                #
            set groupNode           [$compDoc createElement g]
                    $compNode   appendChild     $groupNode
                    $groupNode  setAttribute    id  ChainWheelBolts
            foreach {x y} $Position(Bolts) {
                set newNode [$compDoc createElement circle]
                    $groupNode  appendChild     $newNode
                    $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                    $newNode    setAttribute    cx $x   cy $y   r 6.0
                set newNode [$compDoc createElement circle]
                    $groupNode  appendChild     $newNode
                    $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                    $newNode    setAttribute    cx $x   cy $y   r 2.5
            }           
                
                
                #
                # -- CrankArm
                #
            set polygonCrankArm             $Polygon(XZ_CrankArm)
                #
            set groupNode   [$compDoc createElement g]
                $compNode   appendChild     $groupNode
                $groupNode  setAttribute    id  CrankArm
                #
            set newNode     [$compDoc createElement polygon]
                $groupNode  appendChild     $newNode
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $polygonCrankArm]
                #
            set newNode [$compDoc createElement circle]
                $groupNode  appendChild     $newNode
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    cx 0                cy 0   r 10
                #
            set newNode [$compDoc createElement circle]
                $groupNode  appendChild     $newNode
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    cx $Scalar(Length)  cy 0   r  6
                #
                
                
                #
                # -- organize layers
                #
            set maxTeeth    [lindex [lsort [split $ListValue(ChainRings) -]] end]
            set ringNode    [$compNode find id $maxTeeth] 
                $compNode   removeChild $ringNode
                $compNode   appendChild $ringNode
                #
            set boltNode    [$compNode find id ChainWheelBolts] 
                $compNode   removeChild $boltNode
                $compNode   appendChild $boltNode
                #
            set crankNode   [$compNode find id CrankArm] 
                $compNode   removeChild $crankNode
                $compNode   appendChild $crankNode
                
                #
                # -- cleanup attribure: xlmns from first layer
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }
                #
                
                #
            return                
                #
        }
            #
        method update_CustomXY {} {
                #
            variable Config
            variable Scalar
            variable ListValue
                #
            variable Polygon
            variable ComponentNode
                #
            set compDoc         [$ComponentNode(XY_Custom) ownerDocument ]
            set compNode        [$ComponentNode(XY_Custom) find id customComponent]
                #
                
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
            
                #
                # -- CrankArm
                #
            set polygonCrankArm     $Polygon(XY_CrankArm)    
                #
            set newNode     [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $polygonCrankArm]
                #
        
                #
                # -- ChainWheel
                #
            set chainLine           $Scalar(ChainLine)
            set chainWheelDistance  $Scalar(ChainRingOffset)
            set chainWheelWidth     2
            set list_ChainRings     [lreverse [lsort [split $ListValue(ChainRings) -]]]
            set count_ChainWheel    [llength $list_ChainRings]       
                #
            switch $count_ChainWheel {
                3   {   set chainWheelPos   [list 0 [expr {$chainLine +       $chainWheelDistance}]]}
                2   {   set chainWheelPos   [list 0 [expr {$chainLine + 0.5 * $chainWheelDistance}]]}
                1   {   set chainWheelPos   [list 0 $chainLine]}
                default {
                        set chainWheelPos   [list 0 $chainLine]
                        set list_ChainRings {}
                        tk_messageBox -message "max ChainWheel amount: 3\n      given Arguments: $list_ChainRings"
                    }
            }
                #
                
                #
            set groupNode   [$compDoc createElement g]
                $compNode   appendChild     $groupNode
                $groupNode  setAttribute    id  ChainWheel    
                #
            set cw_Clearance    {}
            set cw_index        0
                #
            set Polygon(XY_ChainWheels) [dict create]
                #
            foreach teethCount $list_ChainRings {
                    set cw_object       [my _get_polygon_ChainWheel_XY $teethCount  $chainWheelWidth  $chainWheelPos ]
                        # set cw_object       [ get_ChainWheel $teethCount  $chainWheelWidth  $chainWheelPos ]
                    set cw_clearance    [ lindex $cw_object 0 ]
                    set cw_polygon      [ lindex $cw_object 1 ]
                        #
                    dict append Polygon(XY_ChainWheels) $teethCount $cw_polygon   
                        # lappend Polygon(XY_ChainWheels) [list $teethCount $cw_polygon]   
                        #
                        # puts " -> $cw_polygon"
                    set newNode [$compDoc createElement polygon]
                        $groupNode  appendChild     $newNode
                        $newNode    setAttribute    id      $teethCount
                        $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                        $newNode    setAttribute    points  [my format_PointList $cw_polygon]
                    
                        # $ext_cvName create polygon     $cw_polygon     -fill gray -outline black  -tags {__Component__ __CrankArm__} 
                        #
                    lappend ext_Center(list_ChainRing) $chainWheelPos
                        # -- position of next chainwheel
                    set chainWheelPos   [ vectormath::addVector $chainWheelPos {0 -1} $chainWheelDistance ]
                        
                        # -- add position to ext_ClearChainWheel
                    incr cw_index
                    set ext_ClearChainWheel($cw_index)    $cw_clearance
            }

                #
                # -- cleanup group layers
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }
                #

                #
            return    
                #
        }
            #
        method update_XZ {} {
            variable Config
            variable ComponentNode
            variable componentPath
                #
            set fileName [file tail $Config(ComponentKey)]
            switch -exact $fileName {
                custom.svg -
                custom {return}
                default {
                    set componentPath       [my getComponentPath CrankSet $Config(ComponentKey)]
                    set ComponentNode(XZ)   [my readSVGFile $componentPath]
                    # puts "\n----------------------> $Config(ComponentKey)"
                    return $ComponentNode(XZ)                
                }
            }
        }    
            #
        method __updateValues {} {
                #
            variable Config
            variable Scalar
            variable crankWidth_BB
            variable crankWidth_Pedal
            variable crankSpyderArm_Count
                #
                
                #
            set crankWidth_Pedal        [expr { 2 * $Scalar(PedalEye)}]
            set crankWidth_BB           [expr {10 + $crankWidth_Pedal}]
            set crankSpyderArm_Count    $Config(SpyderArmCount)
                #
            if {$crankSpyderArm_Count < 1} {
                set crankSpyderArm_Count 4
            }   
                #
            if {$crankSpyderArm_Count > 8} {
                set crankSpyderArm_Count 4
            }
            return  
                #
        }
            #
        method __get_BCDiameter {teethCount {option diameter}} {
                    #
                my __updateValues    
                    #
                if     {$teethCount >= 39} {    set innerDiameter 130 } \
                elseif {$teethCount >= 34} {    set innerDiameter 110 } \
                elseif {$teethCount >= 30} {    set innerDiameter 100 } \
                elseif {$teethCount >= 25} {    set innerDiameter  74 } \
                else                       {    set innerDiameter  60 }
                    #
                if {$option == {radius}} {
                    return [expr {0.5 * $innerDiameter}]
                } else {
                    return $innerDiameter
                }
        }
            #
        method _get_ChainWheelDefinition {crankSetChainRings} {
                    #
                variable ListValue    
                    #
                my __updateValues    
                    #
                set diameterBCList  {}    
                    #
                set teethCountList  [lreverse [lsort [split $crankSetChainRings -]]]
                set chainWheelCount [llength $teethCountList]
                    # 
                    # puts "   ... $teethCountList  ->  $chainWheelCount"
                    #
                set _chainWheelDef   {}
                set bcDiameter_Min  [my __get_BCDiameter   [lindex $teethCountList 0] diameter]
                    #
                if {$chainWheelCount == 1} {
                    set teethCount $teethCountList
                        # puts $teethCount
                    set _bcDiameter [my __get_BCDiameter   $teethCount diameter]
                    set _chainWheelDef [list $teethCount $_bcDiameter]
                } elseif {$chainWheelCount >= 2} {
                    foreach teethCount [lrange $teethCountList 0 1] {
                            # puts "    ... \$teethCount $teethCount"
                        set _bcDiameter [my __get_BCDiameter   $teethCount diameter]
                        if {$_bcDiameter < $bcDiameter_Min} {
                            set bcDiameter_Min $_bcDiameter
                        }
                            # puts "    ... \$teethCount     $teethCount"
                            # puts "    ... \$bcDiameter_Min $bcDiameter_Min"
                    }
                    foreach teethCount [lrange $teethCountList 0 1] {
                        lappend _chainWheelDef $teethCount $bcDiameter_Min
                    }
                    
                }
                if {$chainWheelCount == 3} {
                    set teethCount [lindex $teethCountList 2]
                    set bcDiameter [my __get_BCDiameter   $teethCount diameter]
                    lappend _chainWheelDef $teethCount $bcDiameter
                }   
                    # puts "   -> $_chainWheelDef"
                set  chainWheelDef {}
                foreach {bcd teeth} [lreverse $_chainWheelDef] {
                    lappend chainWheelDef   $teeth $bcd
                    lappend diameterBCList  $bcd
                }
                    # puts "   -> $chainWheelDef"
                    #
                set ListValue(DiameterBC)  $diameterBCList
                    #
                return $chainWheelDef
                    #
        }
            #
        method _get_polygon_ChainWheel {teethCount visMode armCount bcDiameter} {
                    #
                    # visMode:
                    #   opened ... is used in Tk::canvas to show objects behind
                    #   closed ... is used to hide objects in lower layers 
                    #
                variable anglePrecStep
                variable toothWith
                variable crankSpyderArm_Count
                    #
                if {$teethCount < 21} {
                    return {}
                }
                    #
                if {$armCount == {__default__}} {
                    set armCount    $crankSpyderArm_Count
                }
                    #
                set spyderArmAngle  [expr {360 / $armCount}]
                my __updateValues
                    #
                    #
                    # puts " <D>... \$bcDiameter $bcDiameter"
                if {$bcDiameter == {__default__}} {
                    set radiusBC    [my __get_BCDiameter $teethCount]
                } else {
                    set radiusBC    [expr {0.5 * $bcDiameter}]
                }
                    #
                    # puts " ------------------------------------------"    
                    # puts "          \$teethCount  $teethCount   "
                    # puts "          \$position    $position     "
                    # puts "          \$armCount    $armCount     "
                    # puts "          \$bcDiameter  $bcDiameter   "
                    # puts "          \$visMode     $visMode      "    
                    # puts " ------------------------------------------"    
                    #
                    # -----------------------------
                    #   initValues
                    # set toothWith           12.7
                set toothWithAngle      [expr {2*$vectormath::CONST_PI/$teethCount}]
                set chainWheelRadius    [expr {0.5*$toothWith/sin(0.5*$toothWithAngle)}]
                set toothBaseRadius     [expr {$chainWheelRadius - 8}]
                    #
                

                    # -----------------------------
                    #   toothProfile
                    set rollRadius 4.2
                        #
                    set pt_00 {1.2 5.5}                                         ; lassign $pt_00  x0 y0 ; # foreach {x0 y0} $pt_00 break
                    set pt_01 [vectormath::rotateLine {0 0} $rollRadius 110]    ; lassign $pt_01  x1 y1 ; # foreach {x1 y1} $pt_01 break
                    set pt_02 [vectormath::rotateLine {0 0} $rollRadius 120]    ; lassign $pt_02  x2 y2 ; # foreach {x2 y2} $pt_02 break
                    set pt_03 [vectormath::rotateLine {0 0} $rollRadius 130]    ; lassign $pt_03  x3 y3 ; # foreach {x3 y3} $pt_03 break
                    set pt_04 [vectormath::rotateLine {0 0} $rollRadius 140]    ; lassign $pt_04  x4 y4 ; # foreach {x4 y4} $pt_04 break
                    set pt_05 [vectormath::rotateLine {0 0} $rollRadius 150]    ; lassign $pt_05  x5 y5 ; # foreach {x5 y5} $pt_05 break
                    set pt_06 [vectormath::rotateLine {0 0} $rollRadius 160]    ; lassign $pt_06  x6 y6 ; # foreach {x6 y6} $pt_06 break
                    set pt_07 [vectormath::rotateLine {0 0} $rollRadius 170]    ; lassign $pt_07  x7 y7 ; # foreach {x7 y7} $pt_07 break
                set toothProfile [list  $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x5 -$y5    $x6 -$y6    $x7 -$y7    \
                                        $x7  $y7    $x6  $y6    $x5  $y5    $x4  $y4    $x3  $y3    $x2  $y2    $x1  $y1    $x0  $y0]
                        #
                        #    set pt_00 {2 5}                                     ; foreach {x0 y0} $pt_00 break
                        #    set pt_01 [vectormath::rotateLine {0 0} 3.8 100]    ; foreach {x1 y1} $pt_01 break
                        #    set pt_02 [vectormath::rotateLine {0 0} 3.8 125]    ; foreach {x2 y2} $pt_02 break
                        #    set pt_03 [vectormath::rotateLine {0 0} 3.8 150]    ; foreach {x3 y3} $pt_03 break
                        #    set pt_04 [vectormath::rotateLine {0 0} 3.8 170]    ; foreach {x4 y4} $pt_04 break
                        #set toothProfile [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]

                    
                    # -----------------------------
                    #    chainwheel profile outside
                set index 0 ;# start her for symetriy purpose
                set outerProfile {}
                while { $index < $teethCount } {
                    set currentAngle [expr {$index * [vectormath::grad $toothWithAngle]}]
                    set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]
                        #
                    foreach {x y} $toothProfile {
                        # puts "   -> $x $y"
                        set pt_xy [list $x $y]
                        set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
                        set pt_xy [vectormath::addVector $pos $pt_xy]
                        foreach {x1 y1} $pt_xy {
                            # puts "   ---- $x1 $y1"
                            append outerProfile "$x1,$y1 "
                        }
                        #append outerProfile [appUtil::flatten_nestedList $pt_xy] " "
                    }
                    incr index
                }
                

                    # -----------------------------
                    #    tooth-base-ring
                set toothBaseProfile    { }
                    #
                set currentAngle        0.0
                while {$currentAngle < 360} {
                    set currentAngle [expr {$currentAngle + $anglePrecStep}]
                    set pos [vectormath::rotateLine {0 0} $toothBaseRadius $currentAngle ]
                    append toothBaseProfile $pos " "
                }
                set toothBaseProfile    [my format_PointList $toothBaseProfile]  
                    
                    
                    
                    # -----------------------------
                    #    inner profile
                set innerRadius     [expr {$radiusBC -7.5}]
                set ringWidth       [expr {8 - ($teethCount - 30)/20}]
                if {$ringWidth < 7} {set ringWidth 7}
                set ringRadius      [expr {$toothBaseRadius - $ringWidth}]
                    #
                
                set eyeProfile          [list -8.5 7.5]
                set spyderArmAngle      [expr {360 / $armCount}]
                set radiusInnerProfile  $innerRadius
                        #
                    set eyeProfile      [vectormath::addVectorCoordList [list $radiusBC 0] $eyeProfile]
                        #
                    set rotAngle        [expr {$armCount * $spyderArmAngle}]
                        # puts "   ... \$rotAngle  $rotAngle"
                    set shapeProfile_left  {}
                    set shapeProfile_right {}
                    
                    set radius01        [expr {$radiusInnerProfile + 0.20 * ($ringRadius - $radiusInnerProfile)}]
                    set radius02        [expr {$radiusInnerProfile + 0.45 * ($ringRadius - $radiusInnerProfile)}]
                    set radius05        [expr {$radiusInnerProfile + 0.65 * ($ringRadius - $radiusInnerProfile)}]
                    set radius06        [expr {$radiusInnerProfile + 0.80 * ($ringRadius - $radiusInnerProfile)}]
                    set radius08        [expr {$radiusInnerProfile + 0.95 * ($ringRadius - $radiusInnerProfile)}]
                        #
                        #
                    set pos01           [vectormath::unifyVector    {0 0} [lrange $eyeProfile 0 1]  $radius01]
                    set pos02           [vectormath::rotateLine     {0 0} $radius02                 [expr {0.14 * $spyderArmAngle}]]
                    set pos05           [vectormath::rotateLine     {0 0} $radius05                 [expr {0.18 * $spyderArmAngle}]]
                    set pos06           [vectormath::rotateLine     {0 0} $radius06                 [expr {0.23 * $spyderArmAngle}]]
                    set pos08           [vectormath::rotateLine     {0 0} $radius08                 [expr {0.30 * $spyderArmAngle}]]
                    set pos20           [vectormath::rotateLine     {0 0} $ringRadius               [expr {0.35 * $spyderArmAngle}]]
                    set pos21           [vectormath::rotateLine     {0 0} $ringRadius               [expr {0.50 * $spyderArmAngle}]]
                        #
                        #
                    set diffAngle       [expr {[vectormath::dirAngle {0 0} $pos20] - [vectormath::dirAngle {0 0} $pos21]}]  
                    set rotAngle 0
                    while {$rotAngle > $diffAngle} {
                        set pos         [vectormath::rotatePoint    {0 0} $pos21 $rotAngle]
                        append shapeProfile_left $pos " "
                        set rotAngle    [expr {$rotAngle -0.5 * $anglePrecStep}]
                    }
                        #
                        #
                    if {$teethCount > 33} {
                        append shapeProfile_left $pos20 " "
                        append shapeProfile_left $pos08 " "
                        append shapeProfile_left $pos06 " "
                        append shapeProfile_left $pos05 " "
                        append shapeProfile_left $pos02 " "
                        append shapeProfile_left $pos01 " "
                    } elseif {$teethCount > 27} {
                        append shapeProfile_left $pos20 " "
                        append shapeProfile_left $pos08 " "
                        append shapeProfile_left $pos06 " "
                    } else {
                        append shapeProfile_left $pos20 " "
                        append shapeProfile_left $pos08 " "
                    }
                        #
                        #
                    append shapeProfile_left [join $eyeProfile " "]
                        #
                        #
                    foreach {x y} $shapeProfile_left {
                        set shapeProfile_right "$x [expr {-1 * $y}] $shapeProfile_right"
                    }
                    # set shapeProfile_right [lrange $shapeProfile_right 0 end-2]
                        #
                        #
                    set shapeProfile "$shapeProfile_left $shapeProfile_right "
                        #
                    set innerProfile   { }
                    set i $armCount            
                    while {$i > 0} {
                        set rotAngle    [expr {($i - 0.5) * $spyderArmAngle}]
                        set myProfile   [vectormath::rotateCoordList    {0 0} $shapeProfile $rotAngle]
                        append innerProfile [join $myProfile " "] " "
                        incr i -1
                    }
                    set innerProfile    [my format_PointList $innerProfile]
                    #                                       
                    # -----------------------------
                    #    return Values    
                    #       visMode: polyline ... is used in Tk::canvas to show objects behind
                    #       visMode: polygon .... is used to hide objects in lower layers 
                    #
                    #       return: closed ...... get complete shape by polyline
                    #       return: opened ...... get complete shape by polygon
                    #
                #puts "<debug A - A>"
                #puts "<debug A> \${chainWheelProfile} \n ${chainWheelProfile}"
                #puts "<debug B> \${chainWheelProfile} \n [string trim ${chainWheelProfile}]"
                        #
                if {$visMode == {polyline}} {
                    set chainWheelProfile   [format {%s %s} $outerProfile   [lindex $outerProfile 0]]
                    set innerRingProfile    [format {%s %s} $innerProfile   [lindex $innerProfile 0]]      
                    set chainWheelProfile   [format {%s %s} $chainWheelProfile $innerRingProfile]
                    set retValue            [list   closed  ${chainWheelProfile} \
                                                    opened  ${toothBaseProfile} ]
                } else {
                    set retValue            [list   closed  ${outerProfile}  \
                                                    closed  ${toothBaseProfile} \
                                                    closed  ${innerProfile} ]
                }
                    #
                return $retValue
                    #
        }
            #
        method _get_polygon_ChainWheel_XY {z w position} {                    
                    #
                set cw_Diameter_TK  [ expr {12.7 / sin ($vectormath::CONST_PI/$z)}]
                set cw_Diameter     [ expr {$cw_Diameter_TK + 4}]
                set cw_Width        $w
                    #
                    # puts "   \$cw_Diameter_TK  $cw_Diameter_TK"
                    #
                set pt_01           [ list [ expr {-0.5 * $cw_Diameter    }] [expr { 0.5 * ($cw_Width - 0.5)}] ]
                set pt_02           [ list [ expr {-0.5 * $cw_Diameter_TK }] [expr { 0.5 * $cw_Width}] ]
                set pt_03           [ list [ expr { 0.5 * $cw_Diameter_TK }] [expr { 0.5 * $cw_Width}] ]
                set pt_04           [ list [ expr { 0.5 * $cw_Diameter    }] [expr { 0.5 * ($cw_Width - 0.5)}] ]
                    #
                set pt_05           [ list [ expr { 0.5 * $cw_Diameter    }] [expr {-0.5 * ($cw_Width - 0.5)}] ]
                set pt_06           [ list [ expr { 0.5 * $cw_Diameter_TK }] [expr {-0.5 * $cw_Width}] ]
                set pt_07           [ list [ expr {-0.5 * $cw_Diameter_TK }] [expr {-0.5 * $cw_Width}] ]
                set pt_08           [ list [ expr {-0.5 * $cw_Diameter    }] [expr {-0.5 * ($cw_Width - 0.5)}] ]
                    #
                    # set position        [ list [lindex $position 0] [expr -1 * [lindex $position 1]] ]
                set pt_Clearance_l  [ vectormath::addVector [ list [ expr {-0.5 * $cw_Diameter}] 0]  $position  ]
                set pt_Clearance_r  [ vectormath::addVector [ list [ expr { 0.5 * $cw_Diameter}] 0]  $position  ]
                
                set polygon         [list   $pt_01  $pt_02  $pt_03  $pt_04  \
                                            $pt_05  $pt_06  $pt_07  $pt_08 ]
                set polygon         [vectormath::addVectorPointList $position $polygon]                                                            
                set polygon         [appUtil::flatten_nestedList    $polygon]                                                            
                    #
                return [list $pt_Clearance_l $polygon $pt_Clearance_r]
                    #
        }
            #
        method update_polygon_CrankArm {} {
                    #
                variable Scalar
                    #
                variable Polygon
                    #
                variable anglePrecStep
                variable crankWidth_BB
                variable crankWidth_Pedal
                    #
                my __updateValues    
                    #
                    
                    #
                set crankLength $Scalar(Length)
                    #
                    
                    # -----------------------------
                    #   initValues
                set index 0
                set crankArmProfile [list [list 10 [expr {-0.5 * $crankWidth_BB}]] [list 0 [expr {-0.5 * $crankWidth_BB}]]]
                    # -----------------------------
                set point [lindex $crankArmProfile 1]
                set angle 270.0
                    # -----------------------------
                while {$angle > 90} {
                    set angle [expr {$angle - $anglePrecStep}]
                    set point [vectormath::rotatePoint {0 0} $point [expr {-1.0 * $anglePrecStep}]]
                    lappend crankArmProfile $point
                }
                    # -----------------------------
                lappend crankArmProfile [list 10 [expr {0.5 * $crankWidth_BB}]]
                lappend crankArmProfile [list [expr {$crankLength -80}] [expr {0.5 * $crankWidth_Pedal}]] [list $crankLength [expr {0.5 * $crankWidth_Pedal}]]
                    # -----------------------------
                set point [lindex $crankArmProfile end]
                set angle 90.0
                while {$angle > -90} {
                    set angle [expr {$angle - $anglePrecStep}]
                    set point [vectormath::rotatePoint [list $crankLength 0] $point [expr {-1.0 * $anglePrecStep}]]
                        # puts "         -> \$angle $angle  -- \$point $point"
                    lappend crankArmProfile $point
                }
                    # -----------------------------
                lappend crankArmProfile [list [expr {$crankLength -80}] [expr {-0.5 * $crankWidth_Pedal}]]
                    #
                set crankArmProfile [appUtil::flatten_nestedList $crankArmProfile]
                    #
                set Polygon(XZ_CrankArm)    $crankArmProfile
                    #
                return $Polygon(XZ_CrankArm)
                    #
        }
            #
        method update_polygon_CrankArm_XY {} {
                #
            variable Config
            variable Scalar
            variable ListValue
                #
            variable ComponentNode
            variable Polygon
                #
            set compDoc         [$ComponentNode(XY_Custom) ownerDocument ]
            set compNode        [$ComponentNode(XY_Custom) find id customComponent]
                #
                #
            set CrankSet(Q-Factor)              $Scalar(Q-Factor)
            set BottomBracket(Width)            $Scalar(BottomBracket_Width)
            set CrankSet(ArmWidth)              $Scalar(ArmWidth)
            set CrankSet(PedalEye)              $Scalar(PedalEye)
            set CrankSet(Length)                $Scalar(Length)
                
                #
            set length_PedalMount   [expr {0.5 * $CrankSet(Q-Factor)}]
            set length_BB           [expr {0.5 * $BottomBracket(Width)}]
                #
                
                # -- help points
            set pt_00       [ list [expr {-1.0 * $CrankSet(Length)}] [expr {-1.0 *  $length_PedalMount + $CrankSet(ArmWidth) + 10}] ]
            set pt_02       [ list [expr {-1.0 * $CrankSet(Length)}] [expr {-1.0 *  $length_PedalMount}] ]
            set pt_01       [ list [expr {-1.0 * $CrankSet(Length)}] [expr {-1.0 *  $length_PedalMount + $CrankSet(ArmWidth)}] ]
            set pt_03       [ list [expr {-1.0 * $CrankSet(Length)}] [expr {-1.0 * ($length_PedalMount + 10)}] ]
                    
                # -- polygon points: pedal mount
            set pt_10       [ vectormath::addVector $pt_01 { 30.0 0} ]
            set pt_11       [ vectormath::addVector $pt_01 [list [expr {-1.0 * $CrankSet(PedalEye)}] 0] ]
            set pt_12       [ vectormath::addVector $pt_02 [list [expr {-1.0 * $CrankSet(PedalEye)}] 0] ]
            set pt_13       [ vectormath::addVector $pt_02 { 35.0 0} ]
            
                # -- polygon points: BottomBracket mount
                # set pt_25       [ list -35 [expr -1.0 * ($length_BB + 15) ] ]
                # set pt_24       [ list -23 [expr -1.0 * ($length_BB + 10) ] ]
                # set pt_23       [ list -23 [expr -1.0 * ($length_BB +  5) ] ]
                # set pt_22       [ list  23 [expr -1.0 * ($length_BB +  5) ] ]
                # set pt_21       [ list  21 [expr -1.0 * ($length_BB + 30) ] ]
                # set pt_20       [ list -30 [expr -1.0 * ($length_BB + 30) ] ]
                     #
                # set polygon         [ appUtil::flatten_nestedList   $pt_10  $pt_11  $pt_12  $pt_13 \
                                                         #$pt_20  $pt_21  $pt_22  $pt_23  $pt_24  $pt_25] 
                #
            set pt_26       [ list -65 [expr {-1.0 * ($length_BB + 17)}] ]
            set pt_25       [ list -33 [expr {-1.0 * ($length_BB + 13)}] ]
            set pt_22       [ list  22 [expr {-1.0 * ($length_BB + 13)}] ]
            set pt_21       [ list  21 [expr {-1.0 * ($length_BB + 30)}] ]
            set pt_20       [ list -30 [expr {-1.0 * ($length_BB + 30)}] ]
                #
            set polygon     [appUtil::flatten_nestedList \
                                            $pt_10  $pt_11  $pt_12  $pt_13 \
                                            $pt_20  $pt_21  $pt_22  $pt_25 ] 
                #
            set polygon     [list   $pt_10  $pt_11  $pt_12  $pt_13 \
                                    $pt_20  $pt_21  $pt_22  $pt_25 ] 
            set polygon     [vectormath::mirrorPointList $polygon x]
            set polygon     [appUtil::flatten_nestedList $polygon]
                #
            set Polygon(XY_CrankArm)    $polygon
                #
            return 
                #
        }
            #
        method _get_polygon_CrankSpyder {bcDiameter armCount} {
                    #
                variable anglePrecStep
                variable crankWidth_BB
                variable crankSpyderArm_Count
                    #
                set crankSpyderArm_Count $armCount
                my __updateValues    
                    #
                set armCount $crankSpyderArm_Count
                set spyderArmAngle  [expr {360 / $armCount}]
                    #
                set radiusBC [expr {0.5 * $bcDiameter}]    
                    
                    # -----------------------------
                    #    base Values    
                set spyderEyeProfile     [list -10.5 -7.5  7.5 -7.5  7.5 7.5  -10.5 7.5]
                set radiusInnerProfile   [expr {7 + 0.5 * $crankWidth_BB}]
                    #        
                set spyderEyeProfile     [vectormath::addVectorCoordList [list $radiusBC 0] $spyderEyeProfile]
                    #
                set radius00             [vectormath::length {0 0} [lrange $spyderEyeProfile 0 1]]
                    #
                    
                    
                    # -----------------------------
                    #    get Spyder    
                set spyderProfile       {}
                set i 0            
                while {$i < $armCount} {
                    set rotAngle    [expr {($i + 0.5) * $spyderArmAngle}]
                        #
                    set myProfile   [vectormath::rotateCoordList    {0 0} $spyderEyeProfile $rotAngle ]
                    append spyderProfile [appUtil::flatten_nestedList $myProfile] " "
                        #
                        # puts "   \$radiusBC: $radiusBC   - $radiusInnerProfile < $radius00 "
                    if {$radiusInnerProfile < $radius00} {
                        set radius01    [expr {$radiusInnerProfile + 2}]
                        set radius02    $radiusInnerProfile
                            #
                            # puts "   $radius00\n   $radius01\n   $radius02\n "
                            #
                        set pos01       [vectormath::rotateLine         {0 0} $radius01 [expr {$rotAngle + 0.3 * $spyderArmAngle}]]
                        set pos02       [vectormath::rotateLine         {0 0} $radius02 [expr {$rotAngle + 0.4 * $spyderArmAngle}]]
                        set pos03       [vectormath::rotateLine         {0 0} $radius02 [expr {$rotAngle + 0.6 * $spyderArmAngle}]]
                        set pos04       [vectormath::rotateLine         {0 0} $radius01 [expr {$rotAngle + 0.7 * $spyderArmAngle}]]
                            #
                        append spyderProfile [appUtil::flatten_nestedList "$pos01 $pos02 $pos03 $pos04"] " "
                    }   
                     #
                    incr i
                }  
                    #   
                set spyderProfile       $spyderProfile
                    #
                    
                    # -----------------------------
                    #    return Values
                return $spyderProfile
                    #
                 
        }
            #
        method _get_position_ChainWheelBolts {bcDiameter armCount} {
                    #
                variable Scalar    
                    #
                variable anglePrecStep
                variable crankWidth_BB
                variable crankSpyderArm_Count
                    #
                set crankSpyderArm_Count $armCount
                my __updateValues    
                    #
                set armCount $crankSpyderArm_Count
                set spyderArmAngle  [expr {360 / $armCount}]
                    #
                set radiusBC        [expr {0.5 * $bcDiameter}]    
                    #
                        
                    # -----------------------------
                    #    get position    
                set boltPositonList       {}
                set i 0            
                while {$i < $armCount} {
                    set rotAngle    [expr {($i + 0.5) * $spyderArmAngle}]
                        #
                    set pos         [vectormath::rotateLine    {0 0} $radiusBC $rotAngle ]
                    lappend boltPositonList $pos
                    incr i
                }
                set boltPositonList [appUtil::flatten_nestedList $boltPositonList]
                    #
                    #
                    
                    # -----------------------------
                    #    return Values
                return $boltPositonList
                    #
                 
        }
            #
        method get_CompPath {} {
            variable componentPath
            return $componentPath
        }
            #
            
            
    }