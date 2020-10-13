 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_RearHub.tcl
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
 #  namespace:  bikeComponent::RearDropout      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::RearDropout {

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
            puts "              -> class RearDropout"
                #
            variable Config             ; array set Config {
                                                Type                _any_
                                            }
            variable Scalar             ; array set Scalar {
                                                Derailleur_X          10.00
                                                Derailleur_Y          25.00
                                                RotationOffset         0.00
                                            }
                #
            variable Position             ; array set Position {
                                                Derailleur      {1.00 -1.00}
                                                Origin          {0.00  0.00}
                                            }
                #
            variable ComponentNode                    
            variable Direction
            variable Polygon                 
                #
                #
                #
            variable nodeSVG_Empty      [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            variable myComponent        ; set myComponent [bikeComponent::ComponentBasic new RearDropout]
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
                #
            $myComponent update
                #
            set ComponentNode(XZ)               [$myComponent getValue ComponentNode    XZ]     
                #
            set Position(Derailleur)            [vectormath::addVector  $Position(Origin)   [vectormath::rotatePoint {0 0}  [list $Scalar(Derailleur_X) $Scalar(Derailleur_Y)]  [expr {$Direction(Origin) - 180}]]]
                #       
        }
            #
            #
        method setValue {arrayName keyName value} {
                #
            variable Config
            variable Scalar
            variable Direction
                #
            variable myComponent
                #
            set keyString "$arrayName/$keyName" 
            if {[array names $arrayName -exact $keyName] != {}} {
                switch -exact $keyString {
                    Config/Type -
                    Scalar/Derailleur_X -
                    Scalar/Derailleur_Y -
                    Scalar/RotationOffset {
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
