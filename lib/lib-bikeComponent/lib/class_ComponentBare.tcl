 ##+##########################################################################te
 #
 # package: bikeComponent   ->  class_ComponentBare.tcl
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
 #  namespace:  bikeComponent::ComponentBare       
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ComponentBare {

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


        superclass bikeComponent::AbstractComponent
        
            #
        variable packageHomeDir
            #
            
        constructor {compName} {
                #
            next    
                #
            puts "              -> class ComponentBare -> $compName"
                #

            variable Config             ; array set Config {
                                                ComponentKey        etc:default_blank.svg
                                            }
            variable Scalar             ; array set Scalar {
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XY                  {}
                                                XZ                  {}
                                            }                     
            variable Direction          ; array set Direction {
                                                Origin                     0.00
                                            }
            variable Polygon            ; array set Polygon {
                                                XY                   {0.00 0.00}
                                                XZ                   {0.00 0.00}
                                            }
            variable Position           ; array set Position {
                                                Origin               {0.00 0.00}
                                            }                                            
                #
            variable objectName         $compName
            variable lastKey            {}
            variable componentPath      {}
        }
            #
            #
        method update {} {
                #
            variable Config
            variable objectName
            variable lastKey
            variable componentPath
            variable ComponentNode
                #
                # puts "--------> update $objectName -> $Config(ComponentKey)"
            set lastKey             $Config(ComponentKey)
            set componentPath       [my getComponentPath $objectName $Config(ComponentKey)]
            set ComponentNode(XZ)   [my readSVGFile $componentPath]
                # puts "\n----------------------> $Config(ComponentKey)"
            return $ComponentNode(XZ)
                #
        }    
            #
        method get_CompPath {} {
            variable componentPath
            return $componentPath
        }
            #
    }    