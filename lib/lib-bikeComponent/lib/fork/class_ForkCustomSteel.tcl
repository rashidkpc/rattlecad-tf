 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_ForkCustomSteel.tcl
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
 #  namespace:  bikeComponent::ForkCustomSteel      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::compForkCustomSteel {

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


        superclass bikeComponent::classFork
        
            #
        variable packageHomeDir
        variable array_CompBaseDir
            #
        variable nodeSVG

        constructor {} {
                #
            next    
                #
            puts "              -> class compForkCustomSteel"
                #
            variable objectCrown        ; set objectCrown           [bikeComponent::ComponentBare   new ForkCustom_Crown]
            variable objectBlade        ; set objectBlade           [bikeComponent::ForkBlade       new straight]
            variable objectDropout      ; set objectDropout         [bikeComponent::ComponentBare   new ForkCustom_Dropout]
                #
                #
            variable Config             ; array set Config {
                                                ComponentKey_Crown      etc:fork/crown/longshen_17.svg
                                                ComponentKey_Dropout    etc:fork/dropout/LE_17.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                SteererLength            195.00                                            
                                                Height                   365.00
                                                Rake                      45.00
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
                                                DropoutAngle               0.00
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XZ_Crown                {}
                                                XZ_Blade                {}
                                                XZ_Dropout              {}
                                            }                                
            variable Direction          ; array set Direction {
                                                Origin                     0.00
                                                Blade                      0.00
                                                Dropout                    0.00
                                            }                                
            variable Polyline           ; array set Polyline {
                                                CenterLine                 {}
                                            }                                
            variable Polygon            ; array set Polygon {
                                                Blade                      {}
                                            }                                
            variable Position           ; array set Position {
                                                Origin                  {0 0}
                                                Blade                   {0 0}
                                                BladeEnd                {0 0}
                                                Dropout                 {0 0}
                                            }                                
            variable Vector             ; array set Vector {
                                                BladeDefinition         {0 0 50 50}
                                            }                                
                #
            variable lastKey_Crown          {}
            variable lastKey_Dropout        {}
                #
            variable componentPath_Crown    {}
            variable componentPath_Dropout  {}
                #
            set ComponentNode(XZ_Crown)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Blade)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Dropout)   [my readSVGFile [file join $packageHomeDir components default_template.svg]]            
                #
            variable nodeSVG_Empty          [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
        }


            #-------------------------------------------------------------------------
                #  create custom RearFender
                #
        method update {} {
                #
            variable objectCrown
            variable objectBlade
            variable objectDropout
                #
            variable componentPath_Crown
            variable componentPath_Dropout
                #
            variable angleDropout
                #
            variable Config
            variable Scalar
            variable ComponentNode
            variable Direction
            variable Polyline
            variable Polygon
            variable Position
            variable Vector
                #
            $objectCrown    setValue Config ComponentKey    $Config(ComponentKey_Crown)
            $objectDropout  setValue Config ComponentKey    $Config(ComponentKey_Dropout)
                #
                # $objectBlade    setValue Config Type            $Config(BladeStyle)
                #
            $objectCrown    update
            $objectBlade    update
            $objectDropout  update
                #
            set Position(Dropout)           [list $Scalar(Rake) [expr {-1.0 * $Scalar(Height)}]]
            set Position(Blade)             [vectormath::addVector $Position(Dropout) [$objectBlade   getValue Position   Origin]]
            set Position(BladeEnd)          [vectormath::addVector $Position(Dropout) [$objectBlade   getValue Position   End]]
            
                # puts " <II> ... \$Position(Dropout) $Position(Dropout)"
                # puts " <II> ... \$Position(Blade) $Position(Blade)"
                # puts " <II> ... \$Position(BladeEnd) $Position(BladeEnd)"
                #
            set Direction(Blade)            [$objectBlade   getValue Direction  Origin]
            set Direction(Dropout)          $Direction(Blade)
            set Polyline(CenterLine)        [$objectBlade   getValue Polyline   CenterLine]
            set Polygon(Blade)              [$objectBlade   getValue Polygon    Blade]
                #
            set componentPath_Crown         [$objectCrown   get_CompPath]
            set componentPath_DropOut       [$objectDropout get_CompPath]
                #
            set ComponentNode(XZ_Crown)     [$objectCrown   getValue ComponentNode XZ]
            set ComponentNode(XZ_Blade)     [$objectBlade   getValue ComponentNode XZ]
            set ComponentNode(XZ_Dropout)   [$objectDropout getValue ComponentNode XZ]
                #
            set Vector(BladeDefinition)     [vectormath::addVectorCoordList $Position(Blade) [$objectBlade   getValue Vector     BladeDefinition]]
                #
            return
                #
        }    
            #
        method setValue {arrayName keyName value} {
                #
            variable objectCrown
            variable objectBlade
            variable objectDropout
                #
            variable Config
            variable Scalar            
                #
            next $arrayName $keyName $value
                #
            set keyString "$arrayName/$keyName"
                # puts "    setValue -> \$keyString $keyString"
            switch -exact $keyString {
                Scalar/Height -   
                Scalar/CrownBladeOffset       { set _height [expr {$Scalar(Height) - $Scalar(CrownBladeOffset)}]
                                                $objectBlade setValue Scalar Height             $_height                        }
                Scalar/Rake -   
                Scalar/CrownBladeOffsetPerp   { set _rake   [expr {$Scalar(Rake) - $Scalar(CrownBladeOffsetPerp)}]
                                                $objectBlade setValue Scalar Rake               $_rake                          }
                Scalar/DropoutBladeOffset     { $objectBlade setValue Scalar DropoutOffset      $Scalar(DropoutBladeOffset)     }
                Scalar/DropoutBladeOffsetPerp { $objectBlade setValue Scalar DropoutOffsetPerp  $Scalar(DropoutBladeOffsetPerp) }
                Scalar/BladeDropoutWidth      { $objectBlade setValue Scalar StartWidth         $Scalar(BladeDropoutWidth)      }
                Scalar/BladeStartLength       { $objectBlade setValue Scalar StartLength        $Scalar(BladeStartLength)       }
                Scalar/BladeBendRadius        { $objectBlade setValue Scalar BendRadius         $Scalar(BladeBendRadius)        }
                Scalar/BladeTaperLength       { $objectBlade setValue Scalar TaperLength        $Scalar(BladeTaperLength)       }
                Scalar/BladeWidth             { $objectBlade setValue Scalar EndWidth           $Scalar(BladeWidth)             }
                
                default {
                            # puts "-> not implemented now: $keyString"
                        }
            }
                #
            ### my update
                #
        }
            #
        method get_CompPath {key} {
            variable componentPath_Crown
            variable componentPath_Dropout
            switch -exact $key {
                crown   {   return  $componentPath_Crown}
                dropout {   return  $componentPath_Dropout}
                default {   return  {}}
            }
        }
            #
    }
