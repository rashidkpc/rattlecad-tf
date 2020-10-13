 ##+##########################################################################te
 #
 # package: bikeComponent   ->  lib_HeadSet.tcl
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
 #  namespace:  bikeComponent::HeadSet      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::bareHeadSet {

            # <HeadSet>
            #     <Bottom>
            #         <Height>13.50</Height>
            #         <Diameter>46.00</Diameter>
            #     </Bottom>
            #     <Top>
            #         <Height>15.50</Height>
            #         <Diameter>45.00</Diameter>
            #     </Top>
            #     <!--
            #         <Height>
            #             <Bottom>13.50</Bottom>
            #             <Top>15.50</Top>
            #         </Height>
            #         <Diameter>45.00</Diameter>
            #     -->
            # </HeadSet>
            
        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
        variable array_CompBaseDir
            #

        constructor {} {
                #
            set   objectName    "HeadSet"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #
            variable Config             ; array set Config {
                                                Type                Ahead
                                                Style_HeadTube      cylindric
                                            }
            variable Scalar             ; array set Scalar {
                                                Diameter_HeadTube     36.00
                                                Diameter_HeadTubeBase 52.00
                                                Diameter_Shim         36.00
                                                Diameter_Bottom       46.50
                                                Diameter_Top          45.50
                                                Height_Bottom         13.50
                                                Height_Top            15.50
                                                Length_HeadTube      105.00
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XZ_Bottom                       {}
                                                XZ_Top                          {}
                                            }    
                #
            variable Polygon            ; array set Polygon {
                                                XZ_Bottom                       {}
                                                XZ_Top                          {}
                                            }
            variable Position           ; array set Position {
                                                Edge_HeadSetBottomFront_Bottom  {}
                                                Edge_HeadSetBottomFront_Top     {}
                                                Edge_HeadSetTopBack_Bottom      {}
                                                Edge_HeadSetTopBack_Top         {}
                                                Edge_HeadSetTopFront_Bottom     {}
                                                Edge_HeadSetTopFront_Top        {}
                                                End_Top                         {}
                                            }
                #
            set ComponentNode(XZ_Top)       [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set ComponentNode(XZ_Bottom)    [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            variable nodeSVG_Empty          [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
        }

        method update {} {
            my update_Bottom
            my update_Top
            
            variable Position
            # puts "bareHeadSet"
            # puts "  \$Position(Edge_HeadSetBottomFront_Bottom)  $Position(Edge_HeadSetBottomFront_Bottom)"
            # puts "  \$Position(Edge_HeadSetBottomFront_Top)     $Position(Edge_HeadSetBottomFront_Top)"
            # puts "  \$Position(Edge_HeadSetTopFront_Bottom)     $Position(Edge_HeadSetTopFront_Bottom)"
            # puts "  \$Position(Edge_HeadSetTopFront_Top)        $Position(Edge_HeadSetTopFront_Top)"
        }
            #
        method update_Bottom {} {
                #
            variable Config
            variable Scalar
            variable Polygon
                #
            variable ComponentNode      
                #
           
                #
            set compDoc         [$ComponentNode(XZ_Bottom) ownerDocument ]
            set compNode        [$ComponentNode(XZ_Bottom) find id customComponent]
                
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }

                #
                # -- HeadSet Bottom
                #
            set myShape     [my get_ShapeBottom]
                #
            set Polygon(XZ_Bottom) [join $myShape]
                #
            set myShapeLeft [vectormath::mirrorPointList [lreverse $myShape] y]
                #
            set myPolygon   "$myShape $myShapeLeft"
            set myPolygon   [join $myPolygon]
                #
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      HeadSet_Bottom
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $myPolygon]
                #
            foreach xy [lrange $myShape 1 end-1] {
                lassign $xy  x y
                    # foreach {x y} $xy break
                set pointString [format {%s,%s %s,%s} $x $y [expr {-1.0 * $x}] $y]
                set newNode [$compDoc createElement polyline ]
                    $compNode   appendChild     $newNode
                    $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                    $newNode    setAttribute    points  $pointString
            }    

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
        method update_Top {} {
                #
            variable Config
            variable Scalar
            variable Polygon
            variable Position
                #
            variable ComponentNode      
                #
           
                #
            set compDoc         [$ComponentNode(XZ_Top) ownerDocument ]
            set compNode        [$ComponentNode(XZ_Top) find id customComponent]
                
                # puts ""
                # puts "   -------------------------------"
                # puts "   createCrank_Custom"
                # puts "       crankLength:    $crankLength"
                # puts "       teethCountList: $teethCountList"
                # puts "       teethCountMax:  $teethCountMax"
                # puts "       bcDiameter:     $bcDiameter"
            
                #
                # -- cleanup
                #
            foreach childNode [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                
                #
                # -- HeadSet Top
                #
            set myShape     [my get_ShapeTop]
                #
            set Polygon(XZ_Top) [join $myShape]
                #
            set myShapeLeft [vectormath::mirrorPointList [lreverse $myShape] y]
                #
            set myPolygon   "$myShape $myShapeLeft"
            set myPolygon   [join $myPolygon]
                #
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $myPolygon]
                #
            foreach xy [lrange $myShape 1 end-1] {
                lassign $xy  x y
                    # foreach {x y} $xy break
                set pointString [format {%s,%s %s,%s} $x $y [expr {-1.0 * $x}] $y]
                set newNode [$compDoc createElement polyline ]
                    $compNode   appendChild     $newNode
                    $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                    $newNode    setAttribute    points  $pointString
            }    

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
        method get_ShapeBottom {} {
                #
            variable Config
            variable Scalar
            variable Polygon
            variable Position
                #
            
                #
                # -- HeadSet Bottom
                #
            if {$Scalar(Diameter_Bottom) < $Scalar(Diameter_HeadTubeBase)} {
                set minorDM     $Scalar(Diameter_HeadTubeBase)
                set majorDM     $Scalar(Diameter_HeadTubeBase)
            } else {
                set minorDM     $Scalar(Diameter_HeadTubeBase)
                set majorDM     $Scalar(Diameter_Bottom)
            }
            
                #
            set minorRadius [expr {0.5 * $minorDM}]    
            set majorRadius [expr {0.5 * $majorDM}]    
            set finalRadius [expr {$majorRadius - 2.0}]    
                #
            set height_00   0
            set height_01   [expr {0.4 * $Scalar(Height_Bottom)}]
            set height_09   [expr {$Scalar(Height_Bottom) - 1.0}]
            set height_10   [expr {1.0 * $Scalar(Height_Bottom)}]
                #
            set myShape {}    
                #
            if {$Scalar(Height_Bottom) > 8} {
                lappend myShape [list $minorRadius $height_00]
                lappend myShape [list $majorRadius $height_01]
                lappend myShape [list $majorRadius $height_09]
                lappend myShape [list $finalRadius $height_10]
            } else {
                if {$Scalar(Height_Bottom) < 0.1} {
                    set myShape      {}
                } else {
                       # believe that there is no integrated or external Headset with this size
                       #  so create a cylindrical represenation
                    lappend myShape [list $minorRadius $height_00]
                    lappend myShape [list $minorRadius $height_10]
                }
            }
                #
            set Position(Edge_HeadSetBottomFront_Top)    [list [expr {0.5 * $minorDM}] 0]
            set Position(Edge_HeadSetBottomFront_Bottom) [list [expr {0.5 * $majorDM}] [expr {-1.0 * $Scalar(Height_Bottom)}]]  
                #
            return $myShape
                #
        }    
            #
        method get_ShapeTop {} {
                #
            variable Config
            variable Scalar
            variable Polygon
            variable Position
                #
            
                #
                # -- HeadSet Top
                #
            if {$Scalar(Height_Top) < 3} {    
                set Scalar(Height_Top) 3
            } 
                
                #
            set Position(End_Top)   [list 0 $Scalar(Height_Top)]
                #

                #
            if {$Scalar(Diameter_Top) < $Scalar(Diameter_HeadTube)} {
                set majorDM     $Scalar(Diameter_HeadTube)
            } else {
                set majorDM     $Scalar(Diameter_Top)
            }
            set minorDM         $Scalar(Diameter_Shim)
                
                #
            set minorRadius [expr {0.5 * $minorDM}]    
            set majorRadius [expr {0.5 * $majorDM}]    
            set finalRadius [expr {$majorRadius - 0.25}]    
                #
            set height_00   $Scalar(Height_Top)
            set height_01   [expr {$Scalar(Height_Top) -0.25}]
            set height_10   0
                #
            if {$Scalar(Height_Top) <= 12.0} {
                set height_09   2.0
            } else {
                set height_09   [expr {0.6 * $Scalar(Height_Top)}]
                if {$height_09 < 6.0} {
                    set height_09 6.0
                }
                if {$height_09 > 9.0} {
                    set height_09 9.0
                }
            }
            set height_09 [expr {$Scalar(Height_Top) - $height_09}]
                # set height_09   [expr $Scalar(Height_Top) -1.0 * (1 + $Scalar(Height_Top) * 0.55)]
                #
            set myShape {}    
                #
            lappend myShape [list $finalRadius $height_00]
            lappend myShape [list $majorRadius $height_01]
            lappend myShape [list $majorRadius $height_09]
            lappend myShape [list $minorRadius $height_10]
                #
                # puts "  get_ShapeTop -> \$myShape $myShape"    
                #
            set Position(Edge_HeadSetTopBack_Top)     [list [expr {-0.5 * $minorDM}] $Scalar(Height_Top)]
            set Position(Edge_HeadSetTopBack_Bottom)  [list [expr {-0.5 * $majorDM}] 0]  
            set Position(Edge_HeadSetTopFront_Top)    [list [expr { 0.5 * $minorDM}] $Scalar(Height_Top)]
            set Position(Edge_HeadSetTopFront_Bottom) [list [expr { 0.5 * $majorDM}] 0]  
                #
            return $myShape
                #
        }    
            #
    }
