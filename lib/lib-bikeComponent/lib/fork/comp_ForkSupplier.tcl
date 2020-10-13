 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_ForkSupplier.tcl
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
 #  namespace:  bikeComponent::ForkSupplier      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkSupplier {

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
            puts "              -> class ForkSupplier"
                #
            variable compObject         ; set compObject            [bikeComponent::ComponentBare   new ForkSupplier_Component]
                #       
            variable Config             ; array set Config {
                                                ComponentKey_Crown  etc:fork/supplier/columbus_Tusk_Straight_2015.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                CrownBrakeAngle        0.00
                                                CrownBrakeOffset      25.00
                                                DropoutAngle           0.00
                                            }
                #       
            variable ComponentNode      ; array set ComponentNode {
                                                XZ_Crown                {}
                                                XZ_Blade                {}
                                                XZ_Dropout              {}
                                            }
            variable Direction          ; array set Direction {
                                                Origin                 0.00
                                                Dropout                0.00
                                                Blade                  0.00
                                            }                                
            variable Polyline           ; array set Polyline {
                                                CenterLine              {0 0 50 0 50 50}
                                            }                                
            variable Polygon            ; array set Polygon {
                                                Blade               {}
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
            variable lastKey                {}
            variable componentPath          {}
                #
            variable nodeSVG_Empty          [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Crown)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Blade)     $nodeSVG_Empty
            set ComponentNode(XZ_Dropout)   $nodeSVG_Empty
                #
            variable list_ValueException; set list_ValueException {
                                                Config/ComponentKey_Dropout \
                                                Polygon/Blade   \
                                                Scalar/DropoutBladeOffset   \
                                                Scalar/DropoutBladeOffsetPerp   \
                                                Scalar/BladeDropoutWidth    \
                                                Scalar/BladeStartLength \
                                                Scalar/BladeBendRadius  \
                                                Scalar/BladeTaperLength \
                                                Scalar/BladeWidth   \
                                                Scalar/CrownBladeOffsetPerp \
                                                Scalar/CrownBladeOffset \
                                            }    
                #
        }


            #-------------------------------------------------------------------------
                #  create custom RearFender
                #
        method update {} {
                #
            variable compObject
            variable Config
            variable Scalar
            variable Polyline
            variable Position
            variable Vector
                #
            variable ComponentNode
            variable componentPath
                #
            $compObject setValue Config ComponentKey $Config(ComponentKey_Crown)
            $compObject update
                #
            set componentPath           [$compObject get_CompPath]
            set ComponentNode(XZ_Crown) [$compObject getValue ComponentNode XZ]
                #
                
                #
                # -- CenterLine
                #
            set Polyline(CenterLine) [list 0 0 $Scalar(Rake) [expr {-1 * $Scalar(Height)}]]
                #

                #
                # -- BladeDefinition
                #
            set Vector(BladeDefinition) [list 26 -50 [vectormath::rotateLine {26 -50} 50 -84]]
            set Vector(BladeDefinition) [appUtil::flatten_nestedList $Vector(BladeDefinition)]
                #
            set Position(Dropout)       [list $Scalar(Rake) [expr {-1.0 * $Scalar(Height)}]]
                #
            return
                #
        }    
            #
        method setValue {arrayName keyName value} {
                #
            variable list_ValueException
                #
            set keyString "$arrayName/$keyName"
            if {[lsearch -exact $list_ValueException $keyString] >= 0} {
                return {}
            }
                #
            next $arrayName $keyName $value    
            ### my update
                #
        }
            #
        method getValue {arrayName keyName} {
               #
            variable list_ValueException
                #
            set keyString "$arrayName/$keyName"
            if {[lsearch -exact $list_ValueException $keyString] >= 0} {
                return {}
            }
                #
            set retValue [next $arrayName $keyName]
            return $retValue
                #
        }    
            #
        method get_CompPath {} {
            variable componentPath
            return $componentPath
        }
            #
    }
