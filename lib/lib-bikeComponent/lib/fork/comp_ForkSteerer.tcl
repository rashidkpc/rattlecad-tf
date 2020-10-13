 ##+##########################################################################te
 #
 # package: bikeComponent   ->  class_ForkSteerer.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/12/09
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
 #  namespace:  bikeComponent::ForkSteerer      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkSteerer {

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


        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
        variable array_CompBaseDir
            #

        constructor {{type {}}} {
                #
            set   objectName    "ForkSteerer"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #

                #
            variable Config             ; array set Config {
                                            }
            variable Scalar             ; array set Scalar {
                                                Diameter              28.60
                                                Length                45.00 
                                            }
                #
            variable ComponentNode     ; array set ComponentNode {
                                                XZ                     {}
                                            }
            variable Direction          ; array set Direction {
                                                Origin                 0.00
                                            }
            variable Position           ; array set Position {
                                                End                 {0 0}
                                                Origin              {0 0}
                                            }
            variable Polygon            ; array set Polygon {
                                                XZ                  {}
                                            }
            variable Polyline           ; array set Polyline {          
                                                CenterLine             {}
                                            }                             
                #
            set ComponentNode(XZ)       [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            ### my update    
                #
        }


        #-------------------------------------------------------------------------
            #  create custom Fork
            #
        method update {} {
            my update_Steerer
        }
            #
        method update_Steerer {} {
                #
            variable Config
            variable Scalar
                #
            variable ComponentNode
            variable Polygon
            variable Polyline
            variable Position
                #
                #
                
                #
            set radiusSteerer   [expr {0.5 * $Scalar(Diameter)}]
                #
            set polygon         {}
                #
            lappend polygon     "[expr {-1.0 * $radiusSteerer}] 0.00"
            lappend polygon     "[expr {-1.0 * $radiusSteerer}] $Scalar(Length)"
            lappend polygon     "$radiusSteerer $Scalar(Length)"
            lappend polygon     "$radiusSteerer 0.00"
                #
            
                #
                # -- update ComponentNode
                #
            set compDoc         [$ComponentNode(XZ) ownerDocument ]
            set compNode        [$ComponentNode(XZ) find id customComponent]
                
                #
                # -- cleanup, fill, cleanup agaon
                #
            foreach childNode   [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                #
            set polygonSVG      [vectormath::mirrorPointList $polygon x]
            set polygonSVG      [appUtil::flatten_nestedList $polygonSVG]
            set polygonSVG      [my format_PointList $polygonSVG]
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      BladeShape
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  $polygonSVG
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }
                #
            
                #
            set Polygon(XZ)             [appUtil::flatten_nestedList $polygon]
            set Polyline(CenterLine)    [list 0 0 0 $Scalar(Length)]
            set Position(End)           [list 0 $Scalar(Length)]
                #
                # puts "  -> update"
                # puts "  -> [$ComponentNode(XZ) asXML]"
                #
            return
                #
        }            
            #
    }    

