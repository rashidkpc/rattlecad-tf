 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_Fork.tcl
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
 #  namespace:  bikeComponent::Fork      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::Fork {

            # <HeadSet>
            #     <Height>
            #         <Bottom>13.50</Bottom>
            #         <Top>15.50</Top>
            #     </Height>
            #     <Diameter>45.00</Diameter>
            # </HeadSet>
            
        superclass bikeComponent::Component
        
            #
        variable packageHomeDir
            #

        constructor {} {
                #
            next    
                #
            puts "              -> class Fork"
                #
            variable Config             ; array set Config {
                                                Type                    SteelCustomBent
                                                ComponentKey_Crown      etc:fork/crown/longshen_17.svg
                                                ComponentKey_Dropout    etc:fork/dropout/LE_17.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                Height                   365.00
                                                Rake                      45.00
                                                SteererDiameter           25.40                                            
                                                SteererLength            195.00                                            
                                                CrownBladeOffset          35.00
                                                CrownBladeOffsetPerp       0.30
                                                CrownBrakeAngle            0.00
                                                CrownBrakeOffset          20.00
                                                BladeDropoutWidth         13.00
                                                BladeStartLength          10.00
                                                BladeTaperLength         250.00
                                                BladeBendRadius          350.00
                                                BladeWidth                28.60
                                                DropoutBladeOffset        20.00
                                                DropoutBladeOffsetPerp     0.00
                                                BladeBrakeOffset          25.00
                                                RimDiameter              500.00
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XZ_Blade                    {}
                                                XZ_Crown                    {}
                                                XZ_Dropout                  {}
                                                XZ_Steerer                  {}
                                            }                     
            variable Direction          ; array set Direction {
                                                Origin                     0.00
                                                Blade                      0.00
                                                Dropout                    0.00
                                            }
            variable Polygon            ; array set Polygon {
                                                Blade                      {}
                                                Steerer                    {}
                                            }
            variable Polyline           ; array set Polyline {
                                                CenterLine                 {}
                                                CenterLine_Steerer         {}
                                            }
            variable Position           ; array set Position {
                                                Origin                {0.00    0.00}
                                                Blade                 {0.00 -100.00} 
                                                BladeEnd              {0.00 -190.00} 
                                                Dropout               {0.00 -150.00} 
                                                Brake                 {0.00 -200.00} 
                                                Steerer_End           {0.00 -200.00} 
                                                Wheel                 {0.00 -200.00} 
                                            }
            variable Vector             ; array set Vector {
                                                BladeDefinition         {0 0 50 50}
                                                BrakeDefinition         {0 0 50 50}
                                            }                                
                #
                #
                #
            variable myComponent        ; set myComponent [bikeComponent::ForkStrategy new ForkSupplier]
                #
            ### my update
                #                            
        }

        method update {} {
                #
            variable myComponent
                #
            variable Scalar
            variable Config
            variable ComponentNode
            variable Direction
            variable Polygon
            variable Polyline
            variable Position
            variable Vector
                #
                #
            $myComponent update
                #
            set Config(Type)                    [$myComponent getStrategy]
            set Config(ComponentKey_Crown)      [$myComponent getValue Config ComponentKey_Crown    ]   
            set Config(ComponentKey_Dropout)    [$myComponent getValue Config ComponentKey_Dropout  ]   
                #
            set Scalar(CrownBladeOffset)        [$myComponent getValue Scalar CrownBladeOffset      ]
            set Scalar(CrownBladeOffsetPerp)    [$myComponent getValue Scalar CrownBladeOffsetPerp  ]
            set Scalar(CrownBrakeAngle)         [$myComponent getValue Scalar CrownBrakeAngle       ]
            set Scalar(CrownBrakeOffset)        [$myComponent getValue Scalar CrownBrakeOffset      ]
            set Scalar(DropoutBladeOffset)      [$myComponent getValue Scalar DropoutBladeOffset    ]
            set Scalar(DropoutBladeOffsetPerp)  [$myComponent getValue Scalar DropoutBladeOffsetPerp]
            set Scalar(BladeDropoutWidth)       [$myComponent getValue Scalar BladeDropoutWidth     ]
            set Scalar(BladeStartLength)        [$myComponent getValue Scalar BladeStartLength      ]
            set Scalar(BladeBendRadius)         [$myComponent getValue Scalar BladeBendRadius       ]
            set Scalar(BladeTaperLength)        [$myComponent getValue Scalar BladeTaperLength      ]
            set Scalar(BladeWidth)              [$myComponent getValue Scalar BladeWidth            ]
            set Scalar(BladeBrakeOffset)        [$myComponent getValue Scalar BladeBrakeOffset      ]
            set Scalar(RimDiameter)             [$myComponent getValue Scalar RimDiameter           ]
                # 
            set ComponentNode(XZ_Blade)         [$myComponent getValue ComponentNode XZ_Blade]   
            set ComponentNode(XZ_Crown)         [$myComponent getValue ComponentNode XZ_Crown]      
            set ComponentNode(XZ_Dropout)       [$myComponent getValue ComponentNode XZ_Dropout]    
            set ComponentNode(XZ_Steerer)       [$myComponent getValue ComponentNode XZ_Steerer]    
                #       
            set Direction(Blade)                [expr {$Direction(Origin) + [$myComponent getValue Direction Blade]}]
            set Direction(Dropout)              [expr {$Direction(Origin) + [$myComponent getValue Direction Dropout]}]
                # 
            set Position(Blade)                 [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position Blade]         $Direction(Origin)]]
            set Position(BladeEnd)              [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position BladeEnd]      $Direction(Origin)]]
                #
            set Position(Dropout)               [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position Dropout]       $Direction(Origin)]]
            set Position(Wheel)                 [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position Wheel]         $Direction(Origin)]]
            set Position(Brake)                 [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position Brake]         $Direction(Origin)]]
            set Position(Steerer_End)           [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position Steerer_End]   $Direction(Origin)]]
                #       
            set Polyline(CenterLine)            [vectormath::rotateCoordList  {0 0} [$myComponent getValue Polyline CenterLine]          $Direction(Origin)]
            set Polyline(CenterLine_Steerer)    [vectormath::addVectorCoordList $Position(Origin)  [vectormath::rotateCoordList  {0 0} [$myComponent getValue Polyline CenterLine_Steerer]  $Direction(Origin)]]
                #
            set Polygon(Steerer)                [$myComponent getValue Polygon  Steerer]
                #
            set Vector(BladeDefinition)         [vectormath::addVectorCoordList $Position(Origin) [vectormath::rotateCoordList  {0 0} [$myComponent getValue Vector BladeDefinition]  $Direction(Origin)]]
            set Vector(BrakeDefinition)         [vectormath::addVectorCoordList $Position(Origin) [vectormath::rotateCoordList  {0 0} [$myComponent getValue Vector BrakeDefinition]  $Direction(Origin)]]
                #
            


            # CrownBladeOffset        [$myComponent getValue Scalar CrownBladeOffset]\n"   
            # CrownBladeOffsetPerp    [$myComponent getValue Scalar CrownBladeOffsetPerp]\n
            # DropoutBladeOffset      [$myComponent getValue Scalar DropoutBladeOffset]\n" 
            # DropoutBladeOffsetPerp  [$myComponent getValue Scalar DropoutBladeOffsetPerp]
            # BladeDropoutWidth       [$myComponent getValue Scalar BladeDropoutWidth]\n"  
            # BladeStartLength        [$myComponent getValue Scalar BladeStartLength]\n"   
            # BladeBendRadius         [$myComponent getValue Scalar BladeBendRadius]\n"    
            # BladeTaperLength        [$myComponent getValue Scalar BladeTaperLength]\n"   
            # BladeWidth              [$myComponent getValue Scalar BladeWidth]\n"        



            
                #
        }
            #
        method setValue {arrayName keyName value} {
                #
            variable Scalar
            variable Config
                #
            variable myComponent
                #
            switch -exact $arrayName {
                Scalar -
                Config {
                        if {[array names $arrayName -exact $keyName] != {}} {
                            $myComponent setValue $arrayName $keyName $value
                            $myComponent update
                            array set $arrayName [list $keyName [$myComponent getValue $arrayName $keyName]]
                                #
                            ### my update
                                #
                        }
                    }
                default {
                
                    }
            }
        }
            #
        method getValue {arrayName keyName} {
                #
            variable Config 
            variable Scalar
                #
            variable ComponentNode 
            variable Direction 
            variable Polygon   
            variable Polyline   
            variable Position   
            variable Vector              
                #
            set keyValue [array get $arrayName $keyName]
                # puts "   -> $keyValue"
            if {$keyValue != ""} {
                    # set value [lindex $keyValue 1]
                    # puts "   -> $value"
                return [lindex $keyValue 1]
            } else {
                    # puts "\nbikeComponent::Fork"
                    # parray $arrayName
                return -code error "[info object class [self object]]: getValue  ... $arrayName $keyName does not exist"
            }
                #
        }
            #
        method update_BrakePosition {} {
            variable myComponent
            $myComponent update_BrakePosition
        }
    }
