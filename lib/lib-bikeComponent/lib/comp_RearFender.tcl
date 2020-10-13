 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_RearFender.tcl
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
 #  namespace:  bikeComponent::RearFender      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::RearFender {

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
            puts "              -> class FrontFender"
                #
            variable Config             ; array set Config {
                                                Style               bluemels
                                            }
            variable Scalar             ; array set Scalar {
                                                Radius               346.00
                                                Height                15.00
                                                Width                 45.00
                                                Angle_Start            2.00
                                                Angle_End            160.00
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XY                     {}
                                                XZ                     {}
                                            }             
            variable Direction          ; array set Direction {
                                                Origin                 0.00
                                                End                  180.00
                                                Start                  0.00
                                            }    
            variable Polygon                 
            variable Position               
                #
                #
                #
            variable myComponent        ; set myComponent [bikeComponent::bareFender new]
                #
            ### my update
                #                            
        }

        method update {} {
                #
            variable myComponent
                #
            variable Config
            variable ComponentNode
            variable Direction
            variable Polygon
            variable Position
                #
            # puts "   RearFender -> \$Position(Origin)  $Position(Origin)"
            # puts "   RearFender -> \$Direction(Origin) $Direction(Origin)"
            # puts "   RearFender -> \$Direction(End)    $Direction(End)"
                #
            $myComponent update
                #
            set ComponentNode(XY)               [$myComponent getValue ComponentNode    XY]     
            set Polygon(XY)                     [$myComponent getValue Polygon          XY]
                #
            set ComponentNode(XZ)               [$myComponent getValue ComponentNode    XZ]     
            set Polygon(XZ)                     [$myComponent getValue Polygon          XZ]
                #
            set Direction(Start)                [expr {$Direction(Origin) + [$myComponent getValue Direction Start]}]  
            set Direction(End)                  [expr {$Direction(Origin) + [$myComponent getValue Direction End]}]  
                #       
                # puts "   RearFender -> \$Position(Origin)  $Position(Origin)"
                # puts "   RearFender -> \$Direction(Origin) $Direction(Origin)"
                # puts "   RearFender -> \$Direction(End)    $Direction(End)"
        }
            #
    }
