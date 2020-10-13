 ##+##########################################################################te
 #
 # package: bikeComponent   ->  class_Fork.tcl
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
 #  namespace:  bikeComponent::class_Fork      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::classFork {

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
        variable nodeSVG

        constructor {} {
                #
            set   objectName    "Fork"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #

            variable Config             ; array set Config {
                                            }
            variable Scalar             ; array set Scalar {
                                                Height               365.00
                                                Rake                  45.00
                                            } 
        }


        #-------------------------------------------------------------------------
            #  create custom Fender
            #
        method update {} {
        }
            #
        method update_Steerer_XZ {} {
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
            set radiusSteerer   [expr {0.5 * $Scalar(SteererDiameter)}]
                #
            set polygon         {}
                #
            lappend polygon     "[expr {-1.0 * $radiusSteerer}] 0.00"
            lappend polygon     "[expr {-1.0 * $radiusSteerer}] $Scalar(SteererLength)"
            lappend polygon     "$radiusSteerer $Scalar(SteererLength)"
            lappend polygon     "$radiusSteerer 0.00"
                #
            
                #
                # -- update ComponentNode
                #
            set compDoc         [$ComponentNode(XZ_Steerer) ownerDocument ]
            set compNode        [$ComponentNode(XZ_Steerer) find id customComponent]
                
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
            set Polygon(Steerer)                [appUtil::flatten_nestedList $polygon]
            set Polyline(CenterLine_Steerer)    [list 0 0 0 $Scalar(SteererLength)]
            set Position(Steerer_End)           [list 0 $Scalar(SteererLength)]
                #
            return
                #
        }
            #            
    }    