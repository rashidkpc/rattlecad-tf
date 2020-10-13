 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_ForkCustomSteelStraight.tcl
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
 #  namespace:  bikeComponent::fork::... 
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkCustomSteelMAX {

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


        superclass bikeComponent::compForkCustomSteel
        
            #
        variable packageHomeDir
            #

        constructor {} {
                #
            variable objectCrown  
            variable objectBlade  
            variable objectDropout
                #
            next
                #
            puts "              -> class ForkCustomSteelMAX"
                #
            variable Config             ; array set Config {
                                                ComponentKey_Crown      etc:fork/crown/longshen_max_36_5.svg
                                                ComponentKey_Dropout    etc:fork/dropout/dropout_14.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                SteererLength            195.00                                            
                                                Height                   365.00
                                                Rake                      45.00
                                                CrownBladeOffset          35.00
                                                CrownBladeOffsetPerp       3.50
                                                CrownBrakeOffset          20.00
                                                CrownBrakeAngle            0.00
                                            }
                #
            variable ComponentNode
                #
            $objectCrown    setValue Config ComponentKey    $Config(ComponentKey_Crown)
            $objectDropout  setValue Config ComponentKey    $Config(ComponentKey_Dropout)
                #
                #
            $objectBlade setBladeStyle                          max
                #
            $objectBlade setValue   Scalar DropoutOffset        23.00
            $objectBlade setValue   Scalar DropoutOffsetPerp     0.00
                #
            $objectCrown    update
            $objectBlade    update
            $objectDropout  update
                #
            variable componentPath_Crown     [$objectCrown   get_CompPath]
            variable componentPath_DropOut   [$objectDropout get_CompPath]
                #
            set ComponentNode(XZ_Crown)      [$objectCrown   getValue ComponentNode XZ]
            set ComponentNode(XZ_Blade)      [$objectBlade   getValue ComponentNode XZ]
            set ComponentNode(XZ_Dropout)    [$objectDropout getValue ComponentNode XZ]
                #
        }


        #-------------------------------------------------------------------------
            #  create custom Fender
            #
        method update {} {
                #
            variable objectBlade
                #
            variable Scalar
                #
            variable Direction
            variable Polyline
            variable Polygon
            variable Position
            variable Vector
                #
            $objectBlade    update
                #
            set Position(Dropout)           [list $Scalar(Rake) [expr {-1.0 * $Scalar(Height)}]]
            set Position(Blade)             [vectormath::addVector $Position(Dropout) [$objectBlade   getValue Position   Origin]]
            set Position(BladeEnd)          [vectormath::addVector $Position(Dropout) [$objectBlade   getValue Position   End]]
                #
                # puts " <II> ... \$Position(Dropout) $Position(Dropout)"
                # puts " <II> ... \$Position(Blade) $Position(Blade)"
                # puts " <II> ... \$Position(BladeEnd) $Position(BladeEnd)"
                #
            set Direction(Blade)            [$objectBlade   getValue Direction  Origin]
            set Direction(Dropout)          $Direction(Blade)
            set Polyline(CenterLine)        [$objectBlade   getValue Polyline   CenterLine]
            set Polygon(Blade)              [$objectBlade   getValue Polygon    Blade]
                #
                # set Vector(BladeDefinition)     [$objectBlade   getValue Vector     BladeDefinition]
            set Vector(BladeDefinition)     [vectormath::addVectorCoordList $Position(Blade) [$objectBlade   getValue Vector     BladeDefinition]]
                #
                # puts " <II> ... \$Position(BladeEnd) [lrange $Polyline(CenterLine) end-1 end]"
                #
            return
                #
        }    
            #
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
                #
            set keyString "$arrayName/$keyName"
                # puts "    setValue -> \$keyString $keyString"
            switch -exact $keyString {
                Scalar/Height   {   set Scalar(Height)  $value
                                    set _height [expr {$Scalar(Height) - $Scalar(CrownBladeOffset)}]
                                    $objectBlade setValue Scalar Height             $_height    
                                }
                Scalar/Rake     {   set Scalar(Rake)  $value
                                    set _rake   [expr {$Scalar(Rake)   - $Scalar(CrownBladeOffsetPerp)}]
                                    $objectBlade setValue Scalar Rake               $_rake                          
                                }
                Scalar/DropoutBladeOffset     -
                Scalar/DropoutBladeOffsetPerp -
                Scalar/BladeDropoutWidth      -
                Scalar/BladeStartLength       -
                Scalar/BladeBendRadius        -
                Scalar/BladeTaperLength       -
                Scalar/BladeWidth             -
                Scalar/CrownBladeOffsetPerp   -
                Scalar/CrownBladeOffset       -
                Scalar/CrownBrakeOffset       -
                _any_ {
                            # puts "\n\n\n <E> ForkCustomSteelMAX setValue  $keyString \n\n\n"
                    }
                default {
                            # puts "-> not implemented now: $keyString"
                        }
            }
                #
            ### my update
                #
        }
            #
    }    