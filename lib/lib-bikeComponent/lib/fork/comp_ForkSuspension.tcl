 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_ForkSuspension.tcl
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
 #  namespace:  bikeComponent::ForkSuspension      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkSuspension {

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
            #

        constructor {} {
                #
            next    
                #
            puts "              -> class ForkSuspension"
                #
            variable objectCrown        ; set objectCrown           [bikeComponent::ComponentBare   new ForkSuspension_Crown]
            variable objectBridge       ; set objectBridge          [bikeComponent::ComponentBare   new ForkSuspension_Dropout]
                #
                #
            variable Config             ; array set Config {
                                                ComponentKey_Crown      etc:fork/_suspension/fork_crown.svg
                                                ComponentKey_Bridge     etc:fork/_suspension/suspension_bridge_24.svg
                                                BridgeKey               Suspension_24
                                            }
            variable Scalar             ; array set Scalar {
                                                CrownBrakeAngle        0.00
                                                CrownBrakeOffset      25.00
                                                Height               365.00
                                                Rake                  45.00
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
                                                Blade                   {}
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
            variable lastKey_Bridge         {}
                #
            variable componentPath_Crown    {}
            variable componentPath_Bridge   {}
                #
            set ComponentNode(XZ_Crown)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Blade)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Dropout)   [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            variable nodeSVG_Empty          [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
                #
            variable list_ValueException; set list_ValueException {
                                                Config/ComponentKey_Crown       \
                                                Config/ComponentKey_Dropout     \
                                                Scalar/DropoutBladeOffset       \
                                                Scalar/DropoutBladeOffsetPerp   \
                                                Scalar/BladeDropoutWidth        \
                                                Scalar/BladeStartLength         \
                                                Scalar/BladeBendRadius          \
                                                Scalar/BladeTaperLength         \
                                                Scalar/BladeWidth               \
                                                Scalar/CrownBladeOffsetPerp     \
                                                Scalar/CrownBladeOffset         \
                                            }    
                #
        }


            #-------------------------------------------------------------------------
                #  create custom RearFender
                #
        method update {} {
                #
            variable objectCrown
            variable objectBridge
            variable componentPath_Crown
            variable componentPath_Bridge
            variable nodeSVG_Crown
            variable nodeSVG_Bridge
                #
            variable Config
            variable Scalar
            variable ComponentNode
            variable Polyline
            variable Position
            variable Vector
                #
            $objectCrown    setValue Config ComponentKey    $Config(ComponentKey_Crown)
                #
            switch -exact $Config(BridgeKey) {
                Suspension_20 {    
                            set compKey     etc:fork/_suspension/suspension_bridge_20.svg
                            set rakeDiff    [expr {$Scalar(Rake) - 36}]
                            set bladeDiff   [expr {174 - $Scalar(Height)}]
                        }
                Suspension_24 {    
                            set compKey     etc:fork/_suspension/suspension_bridge_24.svg
                            set rakeDiff    [expr {$Scalar(Rake) - 38}]
                            set bladeDiff   [expr {224 - $Scalar(Height)}]
                        }
                Suspension_26 {    
                            set compKey     etc:fork/_suspension/suspension_bridge_26.svg
                            set rakeDiff    [expr {$Scalar(Rake) - 40}]
                            set bladeDiff   [expr {251 - $Scalar(Height)}]
                        }
                Suspension_29 {    
                            set compKey     etc:fork/_suspension/suspension_bridge_29.svg
                            set rakeDiff    [expr {$Scalar(Rake) - 44}]
                            set bladeDiff   [expr {282 - $Scalar(Height)}]
                        }
                Suspension_27 -
                default       {    
                            set compKey     etc:fork/_suspension/suspension_bridge_27.svg
                            set rakeDiff    [expr {$Scalar(Rake) - 42}]
                            set bladeDiff   [expr {263 - $Scalar(Height)}]
                        }
            }
                #
            $objectBridge   setValue Config ComponentKey    $compKey    
                #
            $objectCrown    update
            $objectBridge   update
                #
            set componentPath_Crown         [$objectCrown  get_CompPath]
            set componentPath_DropOut       [$objectBridge get_CompPath]
            set ComponentNode(XZ_Crown)     [$objectCrown  getValue ComponentNode XZ]
            set ComponentNode(XZ_Dropout)   [$objectBridge getValue ComponentNode XZ]

                #
            set Position(Dropout)           [list [expr {$Scalar(Rake) - $rakeDiff}] [expr {-1.0 * $Scalar(Height)}]]
            set Position(Blade)             {0 0}
                #
                
                
                #
                # -- CenterLine
                #
            set Polyline(CenterLine) [list 0 0 0 -22 12 -45 12 [expr {-1 * $Scalar(Height)}]  $Scalar(Rake) [expr {-1 * $Scalar(Height)}]]
                #
                
                #
                # -- BladeDefinition 
                #
            set _offset 30
            set Vector(BladeDefinition) [list $_offset $bladeDiff $_offset [expr {$bladeDiff - 50}]]
                #
                # puts "   \$Vector(BladeDefinition) $Vector(BladeDefinition)"
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
        method get_CompPath {key} {
            variable componentPath_Crown
            variable componentPath_Bridge
            switch -exact $key {
                crown   {   return  $componentPath_Crown}
                dropout {   return  $componentPath_Bridge}
                default {   return  {}}
            }
        }
            #
    }
