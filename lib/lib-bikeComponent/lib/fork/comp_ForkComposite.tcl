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
 #  namespace:  bikeComponent::ForkComposite      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkComposite {

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
            puts "              -> class ForkComposite"
                #
            variable objectCrown        ; set objectCrown           [bikeComponent::ComponentBare   new ForkSuspension_Crown]
            variable objectDropout      ; set objectDropout         [bikeComponent::ComponentBare   new ForkSuspension_Dropout]
                #
                #
            variable Config             ; array set Config {
                                                ComponentKey_Crown      etc:fork/_composite/fork_crown.svg
                                                ComponentKey_Dropout    etc:fork/_composite/dropout.svg
                                                CrownType               Composite_45
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
            variable lastKey_Dropout        {}
                #
            variable componentPath_Crown    {}
            variable componentPath_Dropout  {}
                #
            set ComponentNode(XZ_Crown)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Blade)     [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Dropout)   [my readSVGFile [file join $packageHomeDir components fork _composite dropout.svg]]
                #
            variable nodeSVG_Empty          [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
                #
            variable list_ValueException; set list_ValueException {
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
            variable objectDropout
            variable componentPath_Crown
            variable componentPath_Dropout
            variable nodeSVG_Crown
            variable nodeSVG_Dropout
                #
            variable Scalar
            variable Config
            variable ComponentNode
            variable Direction
            variable Position
                #
            my update_Shape
                #
            set Position(Dropout)       [list $Scalar(Rake) [expr {-1.0 * $Scalar(Height)}]]
            set Position(Blade)         {0 0}
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
        method update_Shape {} {
                #
            variable Config
            variable Scalar
            variable Direction
            variable ComponentNode
            variable Polyline
            variable Vector
                #
            variable packageHomeDir    
                #
                # puts "   -> \$Config(CrownType) $Config(CrownType)"            
            switch -exact $Config(CrownType) {
                Crown45 {   set crownSVG    [my readSVGFile [file join $packageHomeDir components fork _composite fork_crown_45.svg]]    }
                Crown56 {   set crownSVG    [my readSVGFile [file join $packageHomeDir components fork _composite fork_crown_56.svg]]    }
                default {   set crownSVG    [my readSVGFile [file join $packageHomeDir components fork _composite fork_crown.svg]]       }
            }    
                #
                # puts [$crownSVG asXML]
                #
            set outlineNode     [$crownSVG find id outline]
                #   
                # puts [$outlineNode asXML]
                #
            set polylinePoints [$outlineNode getAttribute points]
                #
            set center_00 {0 0}
                #
            set polyline {}
            foreach xy $polylinePoints {
                lassign [split $xy ,]  x y
                    # foreach {x y} [split $xy ,] break
                set _xy [vectormath::subVector [list $x $y] $center_00]
                # puts "    -> $_xy"
                lappend polyline $_xy
            }
                # puts "$polyline"
                #
            set pos_CrownStart      [lindex $polyline 0]
            set pos_CrownEnd        [lindex $polyline end]
            set pos_Dropout         [list $Scalar(Rake) $Scalar(Height)]
                #
            set pos_ctCrown         [vectormath::center $pos_CrownStart $pos_CrownEnd]
                #
            set vector_CL           [vectormath::unifyVector $pos_ctCrown $pos_Dropout ]
            set dir_CL              [vectormath::dirAngle {0 0} $vector_CL]
            set dropoutAngle        [expr {90 - $dir_CL}]
                # puts "   -> \$vector_CL $vector_CL"
                # puts "   -> \$dir_CL    $dir_CL"
                #
            set pos_BladeEnd        [vectormath::addVector $pos_Dropout $vector_CL  -13]
                #
            set width_Dropout   20
                #
            set pos_DropoutRight    [vectormath::perpendicular $pos_BladeEnd $pos_ctCrown [expr {0.5 * $width_Dropout}] right]
            set pos_DropoutLeft     [vectormath::perpendicular $pos_BladeEnd $pos_ctCrown [expr {0.5 * $width_Dropout}] left]
                #
            lappend polyline $pos_DropoutRight
            lappend polyline $pos_DropoutLeft
                #
            set pointList   [appUtil::flatten_nestedList $polyline]
            set pointList   [my format_PointList $pointList]
                # puts "$pointList"
                # puts "-----------------"
                #
            set Direction(Dropout)  $dropoutAngle   
                #
                #
            set compDoc         [$ComponentNode(XZ_Crown) ownerDocument ]
            set compNode        [$ComponentNode(XZ_Crown) find id customComponent]
                #
               
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }

                #
                # -- Fork Composite
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      Fork_Composite
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  $pointList
                #
            set inlineNode  [$crownSVG find id inline]
            $compNode   appendXML   [$inlineNode asXML]          
                
                #
                # -- cleanup attribure: xlmns from first layer
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }
                
                #
                # -- CenterLine
                #
            set Polyline(CenterLine) [list 0 0 $Scalar(Rake) [expr {-1 * $Scalar(Height)}]]
                #
                
                #
                # -- BladeDefinition
                #
            set _vector [vectormath::unifyVector $pos_CrownStart $pos_DropoutLeft 50]
            set Vector(BladeDefinition) [list $pos_CrownStart [vectormath::addVector $pos_CrownStart $_vector]]
            set Vector(BladeDefinition) [vectormath::mirrorPointList $Vector(BladeDefinition) x]
            set Vector(BladeDefinition) [appUtil::flatten_nestedList $Vector(BladeDefinition)]
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

