 ##+##########################################################################te
 #
 # package: bikeComponent   ->  lib_Fender.tcl
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
 #  namespace:  bikeComponent::Fender      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::bareFender {

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
            #
        
        constructor {} {
                #
            set   objectName    "Fender"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #

            variable Config             ; array set Config {
                                                Style               bluemels
                                            }
            variable Scalar             ; array set Scalar {
                                                Angle_Start            0.00
                                                Angle_End            180.00
                                                Radius               346.00
                                                Height                15.00
                                                Width                 45.00
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
                #
            set ComponentNode(XY)       [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ)       [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            variable nodeSVG_Empty      [my readSVGFile [file join $packageHomeDir components default_template.svg]]
        }


        #-------------------------------------------------------------------------
            #  create custom Fender
            #
        method update {} {
            variable Config
            switch -exact $Config(Style) {
                bluemels -
                default {
                    my update_Shape_XY
                    my update_Shape_XZ
                }
            }
        }
            #
        method update_Shape_XY {} {
                #
            variable Scalar
                #
            variable ComponentNode
            variable Direction
            variable Polygon
            
                #
            set precision 3; # mm
                #
            set height      $Scalar(Height)
            set width       $Scalar(Width)
            set radius      $Scalar(Radius)
                #
                #
            set compDoc         [$ComponentNode(XY) ownerDocument ]
            set compNode        [$ComponentNode(XY) find id customComponent]
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                #
   
                #
            set y1  [expr {0.5 * $Scalar(Width)}]
            set y2  [expr {0.3 * $Scalar(Width)}]
            set x1  $Scalar(Height)
                #
            set coordList   [list \
                                [expr {-1.0 * $x1}] $y1 \
                                0 $y2 \
                                0 [expr {-1.0 * $y2}] \
                                [expr {-1.0 * $x1}] [expr {-1.0 * $y1}] \
                            ]
                #
            set polygon     [vectormath::addVectorCoordList [list $Scalar(Radius) 0] $coordList]                
                #
            
            if 0 {    
                    # set angleEnd    [expr $angleStart + $angleLength]
                set arcLength   [expr {$angleLength * 2 * $radius * $vectormath::CONST_PI / 360}]
                set nr_Elements [expr {round ($arcLength / $precision)}]
                set incrAngle   [expr {$angleLength / $nr_Elements}]
                
                set pointList    {}
                for {set angle $angleStart} {$angle <= $angleEnd} {set angle [expr {$angle + $incrAngle}]} {
                    lappend pointList [vectormath::rotateLine {0 0} $radius $angle]
                }
                    #
                set angleEnd    [expr {$angleEnd   - 2}]
                set angleStart  [expr {$angleStart + 2}]
                set innerRadius [expr {$radius - $height}]
                    #
                for {set angle $angleEnd} {$angle >= $angleStart} {} {
                    lappend pointList [vectormath::rotateLine {0 0} $innerRadius $angle]
                    set angle [expr {$angle - $incrAngle}]
                }
                    #
                    # puts "   ----> $pointList"    
                    #
                set polygon         [vectormath::mirrorPointList $pointList x]
                set polygon         [appUtil::flatten_nestedList $polygon]
                    #
            }
                #
                #
                
                #
            # set polygon         {}
                #
                
                #
            set Polygon(XY) $polygon
                #
            set newNode [$compDoc createElement polyline]
            $compNode   appendChild     $newNode
            $newNode    setAttribute    id      Fender
            $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
            $newNode    setAttribute    points  [my format_PointList $Polygon(XY)]
                #
                
                #
                # -- cleanup attribure: xlmns from first layer
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }
                #
            return    
                #
        }
            #
        method update_Shape_XZ {} {
                #
            variable Scalar
                #
            variable ComponentNode
            variable Direction
            variable Polygon
            
                #
            set precision 3; # mm
                #
            set angleStart  $Scalar(Angle_Start)
            set angleEnd    $Scalar(Angle_End)
            set height      $Scalar(Height)
            set radius      $Scalar(Radius)
                #
            set angleLength [expr {$angleStart + $angleEnd}]
                #
                # puts "  -> \$radius       $radius"
                # puts "  -> \$angleStart   $angleStart"
                # puts "  -> \$angleLength  $angleLength"
                # puts "  -> \$height       $height"
                #
            set Direction(Start)    [expr {-1.0 * $angleStart}]
            set Direction(End)      $angleEnd
                #
            set compDoc         [$ComponentNode(XZ) ownerDocument ]
            set compNode        [$ComponentNode(XZ) find id customComponent]
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                #
                
                # set angleEnd    [expr $angleStart + $angleLength]
            set arcLength   [expr {$angleLength * 2 * $radius * $vectormath::CONST_PI / 360}]
            set nr_Elements [expr {round ($arcLength / $precision)}]
            set incrAngle   [expr {$angleLength / $nr_Elements}]
            
            set pointList    {}
            for {set angle $angleStart} {$angle <= $angleEnd} {set angle [expr {$angle + $incrAngle}]} {
                lappend pointList [vectormath::rotateLine {0 0} $radius $angle]
            }
                #
            set angleEnd    [expr {$angleEnd   - 2}]
            set angleStart  [expr {$angleStart + 2}]
            set innerRadius [expr {$radius - $height}]
                #
            for {set angle $angleEnd} {$angle >= $angleStart} {} {
                lappend pointList [vectormath::rotateLine {0 0} $innerRadius $angle]
                set angle [expr {$angle - $incrAngle}]
            }
                #
                # puts "   ----> $pointList"    
                #
            set polygon         [vectormath::mirrorPointList $pointList x]
            set polygon         [appUtil::flatten_nestedList $polygon]
                #
                
                #
            set Polygon(XZ) $polygon
                #
            set newNode [$compDoc createElement polygon]
            $compNode   appendChild     $newNode
            $newNode    setAttribute    id      Fender
            $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
            $newNode    setAttribute    points  [my format_PointList $Polygon(XZ)]
                #
                
                #
                # -- cleanup attribure: xlmns from first layer
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }
                #
            return    
                #
        }
            #
    }    