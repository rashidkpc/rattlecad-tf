 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_RearBrake.tcl
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
 #  namespace:  bikeComponent::RearBrake      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::RearBrake {

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
            puts "              -> class RearBrake"
                #
            variable Config             ; array set Config {
                                                ComponentKey             etc:default_blank.svg
                                                Type                     Rim
                                            }
            variable Scalar             ; array set Scalar {
                                                BladeOffset               20.00
                                                LeverLength               45.00
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XZ                          {}
                                            }                     
            variable Direction          ; array set Direction {
                                                Axle                       0.00
                                                Origin                     0.00
                                            }
            variable Position           ; array set Position {
                                                Axle                 {0.00 1.00}
                                                Definition          {-1.00 0.00}
                                                Mount               {-1.00 1.00}
                                                Origin               {0.00 0.00}
                                            }
                #
            variable nodeSVG_Empty      ; set nodeSVG_Empty [my readSVGFile [file join $packageHomeDir .. components default_template.svg]]
                #
            variable myComponent        ; set myComponent   [bikeComponent::ComponentBasic  new RearBrake]
                #
            ### my update
                #                            
        }

        method update {} {
                #
            variable myComponent
                #
            variable Config
            variable Scalar
                #
            variable ComponentNode
            variable Direction
            variable Position
                #
            variable nodeSVG_Empty
                #
            $myComponent update
                #
            if {$Config(Type) eq "Rim"} {
                set ComponentNode(XZ)   [$myComponent getValue ComponentNode    XZ] 
            } else {
                set ComponentNode(XZ)   $nodeSVG_Empty
            }
                #
            # puts "  -> \$Position(Origin)       $Position(Origin)"    
            # puts "  -> \$Scalar(LeverLength)    $Scalar(LeverLength)"    
            # puts "  -> \$Direction(Origin)      $Direction(Origin)"    
                #
            set Position(Axle)          [vectormath::addVector  $Position(Origin)   [vectormath::rotateLine {0 0}   $Scalar(LeverLength)    [expr {$Direction(Origin) - 180}]]]
            set Position(Definition)    [vectormath::addVector  $Position(Origin)   [vectormath::rotateLine {0 0}   $Scalar(BladeOffset)    [expr {$Direction(Origin) +  90}]]]
            set Position(Mount)         [vectormath::addVector  $Position(Axle)     [vectormath::rotateLine {0 0}   $Scalar(BladeOffset)    [expr {$Direction(Origin) +  90}]]]
                #
            set Direction(Axle)         $Direction(Origin)
                #
        }
            #
        method setValue {arrayName keyName value} {
                #
            variable Config
            variable Scalar
                #
            variable myComponent
                #
            set keyString "$arrayName/$keyName" 
            if {[array names $arrayName -exact $keyName] != {}} {
                switch -exact $keyString {
                    Config/Type -
                    Scalar/BladeOffset -
                    Scalar/LeverLength {
                            array set $arrayName [list $keyName $value]
                            ### my update
                            return
                        }
                    default {}
                }
                switch -exact $arrayName {
                    Config -
                    Scalar -
                    _any_ {
                            $myComponent setValue $arrayName $keyName $value
                            $myComponent update
                            array set $arrayName [list $keyName [$myComponent getValue $arrayName $keyName]]
                                #
                            ### my update
                                #
                        }
                    default {}
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
            variable Position   
                #
            set keyValue [array get $arrayName $keyName]
                # puts "   -> $keyValue"
            if {$keyValue != ""} {
                    # set value [lindex $keyValue 1]
                    # puts "   -> $value"
                return [lindex $keyValue 1]
            } else {
                return -code error "[info object class [self object]]: getValue  ... $arrayName $keyName does not exist"
            }
                #
        }
            #
    }
