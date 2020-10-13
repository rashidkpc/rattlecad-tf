 ##+##########################################################################te
 #
 # package: bikeComponent   ->  lib_Stem.tcl
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
 #  namespace:  bikeComponent::Stem      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::bareStem {

            # <Stem>
                 #<Angle>-6.00</Angle>
                 #<Length>110.00</Length>
            # </Stem>            
            
        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
            #
        
        constructor {} {
                #
            set   objectName    "Stem"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #

            variable Config             ; array set Config {
                                                Type                    Ahead
                                            }
            variable Scalar             ; array set Scalar {
                                                Angle                   -6.00
                                                Length                 110.00
                                                Length_Shaft            45.00
                                                Spacer_Height            9.00
                                            }
                #
            variable Polygon            ; array set Polygon {
                                                XZ                      {}
                                                XZ_Cap                  {}
                                                XZ_Spacer               {}
                                            }
                #
            variable Position           ; array set Position {
                                                Origin_Cap              {}
                                                End_Cap                 {}
                                                Origin_Spacer           {}
                                                End_Spacer              {}
                                                Steerer                 {}
                                                Edge_SpacerBack_Bottom  {}
                                                Edge_SpacerBack_Top     {}
                                            }
                #
            variable ComponentNode
                #
                
                #
            variable lengthEffective        10.00
                #
            variable diameter_AheadStem     34.00
            variable diameter_AheadSpacer   36.00
                #
            set ComponentNode(XZ)       [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            variable nodeSVG_Empty      [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
        }

        #-------------------------------------------------------------------------
            #  create custom Stem
            #
        method update {} {
            variable Config
            switch -exact $Config(Type) {
                Quill {
                        my update_componentNode_QuillStem
                    }
                Ahead -
                default {
                        my update_polygon_AheadStem
                        my update_polygon_AheadCap
                        my update_polygon_AheadSpacer
                        my update_componentNode_XZ
                    }
            } 
        }
            #
        method setValue {arrayName keyName value} {
                #
            variable Config
            variable Scalar
                #
            variable myComponent
                #
            set keyString "$arrayName/$keyName" 
            if {[array names $arrayName -exact $keyName] != {}} {
                switch -exact $keyString {     
                    Scalar/Spacer_Height {
                            return
                        }
                    default {}
                }
            }
                #
            next $arrayName $keyName $value    
                #
        }
            #
        method update_componentNode_XZ {} {
                #
            variable Config
            variable Scalar
                #
            variable Polygon
            variable Position
            variable ComponentNode      
                #
            
                #
            set compDoc         [$ComponentNode(XZ)    ownerDocument ]
            set compNode        [$ComponentNode(XZ)    find id customComponent]
                #
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
            foreach childNode   [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      Stem
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $Polygon(XZ)]
                #
                
                #
            set myShape     $Polygon(XZ_Cap)
            set myShapeLeft [vectormath::mirrorPointList [lreverse $myShape] y]    
            set myPolygon   "$myShape $myShapeLeft"
            set myPolygon   [join $myPolygon]
            set myPolygon   [vectormath::addVectorCoordList $Position(Origin_Cap) $myPolygon]
            set myPolygon   [vectormath::mirrorCoordList $myPolygon x]
                #
            set pos_01      [lrange $myPolygon 2 3]
            set pos_02      [lrange $myPolygon end-3 end-2]
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      AheadCap
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $myPolygon]
                #
            set newNode [$compDoc createElement line ]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      AheadCap_line
                $newNode    setAttribute    style   "stroke:black;stroke-width:0.2"
                $newNode    setAttribute    x1      [lindex $pos_01 0]
                $newNode    setAttribute    y1      [lindex $pos_01 1]
                $newNode    setAttribute    x2      [lindex $pos_02 0]
                $newNode    setAttribute    y2      [lindex $pos_02 1]
                #
                
                #
            set myShape     $Polygon(XZ_Spacer)
            set myShapeLeft [vectormath::mirrorPointList [lreverse $myShape] y]    
            set myPolygon   "$myShape $myShapeLeft"
            set myPolygon   [join $myPolygon]
            set myPolygon   [vectormath::addVectorCoordList $Position(Origin_Spacer) $myPolygon]
            set myPolygon   [vectormath::mirrorCoordList $myPolygon x]    
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      Spacer
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $myPolygon]
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
        method update_polygon_AheadStem {} {
                #
            variable Config
            variable Polygon
            variable Position
            variable Scalar
                #
            variable diameter_AheadStem
            variable lengthEffective
                #
                
                #
                # stem arm horizontal ... polygon and positions will be rotated at the end
                #
            set pt_00   {0 0}
            set pt_01   [vectormath::unifyVector    $pt_00 {-1 0} $Scalar(Length)]
            set pt_02   [vectormath::rotateLine     $pt_01 50 [expr {-90 + $Scalar(Angle)}]]
                # set pt_00   $Position(HandleBar)
                # set pt_01   $Position(Steerer_End)
                # set pt_02   $HeadSet(Stem)
                #
            set dir_HeadTube    [vectormath::unifyVector $pt_02 $pt_01]
            set diameter_Stem   $diameter_AheadStem
                #
            set clamp_SVGPolygon    "-20.2619,-17 -16.6918,-17.4561 -13.8908,-19.1945 -11.3044,-21.7874 -10.0644,-24.1389 -9.7316,-24.4732 -9.8958,-23.3099 -10.3089,-21.9026 -11.1479,-19.9125 -12.0719,-17.777 -15.3406,-11.3784 -16.1873,-10.0012 -17.4384,-9.0427 -18.8336,-8.3572 -17.4384,-9.0427 -16.1873,-10.0012 -15.3406,-11.3784 -12.0719,-17.777 -11.1479,-19.9125 -10.3089,-21.9026 -9.8958,-23.3099 -9.7316,-24.4732 -9.4316,-24.7774 -8.6838,-24.9999 -0.8,-24.9999 -0.8,-15.8802 0.8,-15.8802 0.8,-24.9998 5.6669,-24.9998 6.3699,-24.8858 6.9818,-24.5172 7.4284,-24.07 13.0499,-18.7437 13.049,-23.6727 12.6125,-24.0796 12.5936,-20.4963 12.6125,-24.0796 7.4284,-24.07 13.2207,-18.5818 15.8552,-15.7422 17.8482,-13.2995 19.8206,-9.913 20.8437,-7.292 21.5329,-4.4455 21.8005,-2.0944 21.9,0.0001 21.8005,2.0946 21.5329,4.4457 20.8437,7.2922 19.8206,9.9132 17.8482,13.2997 15.8552,15.7424 13.2207,18.582 7.4284,24.0702 12.6125,24.0798 12.5936,20.4965 12.6125,24.0798 13.049,23.6729 13.0499,18.7439 7.4284,24.0702 6.9818,24.5174 6.3699,24.886 5.6669,25 0.8,25 0.8,15.8804 4.18,15.3448 7.4163,14.0676 10.1772,12.2159 12.523,9.7973 14.299,6.9605 15.506,3.5323 15.9,0.0001 15.506,-3.5321 14.299,-6.9603 12.523,-9.7971 10.1772,-12.2157 7.4163,-14.0674 4.18,-15.3446 0.8,-15.8802 -0.8,-15.8802 -3.4694,-15.544 -6.2265,-14.634 -9.2433,-12.9378 -11.6453,-10.8246 -13.5388,-8.3403 -14.8801,-5.6139 -15.6719,-2.6977 -15.9,0.0001 -15.6719,2.6979 -14.8801,5.6141 -13.5388,8.3405 -11.6453,10.8248 -9.2433,12.938 -6.2265,14.6342 -3.4694,15.5442 -0.8,15.8804 0.8,15.8804 -0.8,15.8804 -0.8,25.0001 -8.6838,25.0001 -9.3776,24.6754 -9.7467,23.9553 -9.8958,23.3101 -10.3089,21.9028 -11.1479,19.9127 -12.0719,17.7772 -15.3406,11.3786 -16.1873,10.0014 -17.4384,9.0429 -18.8336,8.3574 -17.4384,9.0429 -16.1873,10.0014 -15.3406,11.3786 -12.0719,17.7772 -11.1479,19.9127 -10.3089,21.9028 -9.8958,23.3101 -9.7467,23.9553 -11.1307,22.117 -13.8952,19.3455 -16.8889,17.4875 -20.7048,17 "
                #
            set polygon         [string map {"," " "}  $clamp_SVGPolygon]
            set polygon         [my coords_flip_y $polygon]
                #set polygon         [ vectormath::addVectorCoordList [list $Geometry(HandleBar_Distance) $Geometry(HandleBar_Height)] $polygon]
                #set polygon         [ vectormath::rotateCoordList $Position(HandleBar) $polygon $angle ]

            set polygonLength   [ llength $polygon  ]
            set pt_099          [ list  [lindex $polygon 0] [lindex $polygon 1]]
            set pt_000          [ list  [lindex $polygon $polygonLength-2]  [lindex $polygon $polygonLength-1]]
            set stemWidth       [ vectormath::length            $pt_099 $pt_000 ]
                #
                #
            set vct_099         [ vectormath::parallel          $pt_01  $pt_00 [expr {0.5 * $stemWidth        }] left]          ;# stem arm - vct top
            set vct_000         [ vectormath::parallel          $pt_01  $pt_00 [expr {0.5 * $stemWidth        }]]               ;# stem arm - vct bottom
            set vct_010         [ vectormath::parallel          $pt_02  $pt_01 [expr {0.5 * $diameter_Stem + 4}]]               ;# stem mount - right 
                # pt_51 - bottom position of stem clamp
            set pt_095          [ vectormath::intersectPoint    [lindex $vct_099 0] [lindex $vct_099 1]  [lindex $vct_010 0] [lindex $vct_010 1]]   ; 
            set pt_50           [ vectormath::intersectPerp     $pt_01  $pt_02  $pt_095 ]                                       ;# 
            set pt_51           [ vectormath::addVector         $pt_50  [vectormath::unifyVector    {0 0}   $dir_HeadTube  2]]  ;# point in front of stem clamp, where stem ataches spacer
            set heightBottom    [ vectormath::length            $pt_01  $pt_51]
                # pt_11 - top position of stem clamp
            set pt_005          [ vectormath::intersectPoint    [lindex $vct_000 0] [lindex $vct_000 1]  [lindex $vct_010 0] [lindex $vct_010 1]]   
            set pt_12           [ vectormath::intersectPerp     $pt_01  $pt_02  $pt_005]                                        
            set pt_11           [ vectormath::addVector         $pt_12  [vectormath::unifyVector    {0 0}   $dir_HeadTube -2]]  ;# point, where stem ataches cap , steerer axis: $pt_01  $pt_02
            set heightTop       [ vectormath::length            $pt_01  $pt_11]
                #
            set vct_020         [ vectormath::parallel          $pt_11  $pt_51  [expr {0.5 * $diameter_Stem}]]
            set vct_021         [ vectormath::parallel          $pt_11  $pt_51  [expr {0.5 * $diameter_Stem}] left]
                #
            set polygon         [ lappend polygon   $pt_005 \
                                                    [lindex  $vct_020 0]  [lindex  $vct_021 0] \
                                                    [lindex  $vct_021 1]  [lindex  $vct_020 1] \
                                                    $pt_095 ]
                #
                #
            set polygon         [appUtil::flatten_nestedList $polygon]
            set polygon         [vectormath::rotateCoordList {0 0} $polygon [expr {-1.0 * $Scalar(Angle)}]]                                       
                #
                #
            set Position(Steerer)       [vectormath::mirrorCoordList [vectormath::rotateCoordList {0 0} $pt_01      [expr {-1.0 * $Scalar(Angle)}]] x]
            set Position(End_Spacer)    [vectormath::rotateCoordList {0 0} [vectormath::mirrorCoordList $pt_51 x]   $Scalar(Angle)]
            set Position(Origin_Cap)    [vectormath::rotateCoordList {0 0} [vectormath::mirrorCoordList $pt_11 x]   $Scalar(Angle)]
                #
            set Polygon(XZ)     $polygon
                #
        }
            #
        method update_polygon_AheadCap {} {
                #
            variable Position
            variable Polygon
                #
            variable diameter_AheadStem
                #
            set height_Cap       3
            set diameter_CapTop 10
                #
            set radius_CapTop   [expr {0.5 * $diameter_CapTop}]
            set radius_Bottom   [expr {0.5 * $diameter_AheadStem}]
                #    
            set pt_11           {0 0}    
            set pt_21           [vectormath::addVector $pt_11   [list 0  [expr {0.4 * $height_Cap}]]]
            set pt_31           [vectormath::addVector $pt_11   [list 0  [expr {1.0 * $height_Cap}]]]
                #
            set pt_10           [vectormath::addVector $pt_11   [list [expr {-1.0 * $radius_Bottom}]  0]]
            set pt_20           [vectormath::addVector $pt_21   [list [expr {-1.0 * $radius_Bottom}]  0]]
            set pt_30           [vectormath::addVector $pt_31   [list [expr {-1.0 * $radius_CapTop}]  0]]
                #
                
                #
            set Polygon(XZ_Cap)     [list   $pt_10  $pt_20  $pt_30 ]
                #
            set Position(End_Cap)   [vectormath::addVector $Position(Origin_Cap) [list 0 $height_Cap]]
                #
        }
            #
        method update_polygon_AheadSpacer {} {
                #
            variable Scalar
                #
            variable Polygon
            variable Position
                #
            variable diameter_AheadStem
            variable diameter_AheadSpacer
                #
            set lengthEffective [lindex $Position(End_Spacer) 0] 
                #
            set heightSpacer    [expr {$Scalar(Length_Shaft) - [vectormath::length $Position(Steerer) $Position(End_Spacer)]}]
                #
                
                #
            set radius_Top      [expr {0.5 * $diameter_AheadStem}]    
            set radius_Bottom   [expr {0.5 * $diameter_AheadSpacer}]    
                #
            set pt_11           {0 0}
            set pt_31           [list 0 $heightSpacer]
                #
            set pt_30           [vectormath::addVector $pt_31   [list [expr {-1.0 * $radius_Top}]     0]] ;# top back
                #                                                                                    
            if {$heightSpacer < 5} {
                set pt_10       [vectormath::addVector $pt_11   [list [expr {-1.0 * $radius_Top}]     0]] ;# bottom back
            } else {
                set pt_10       [vectormath::addVector $pt_11   [list [expr {-1.0 * $radius_Bottom}]  0]] ;# bottom back
            }
                #
            set Polygon(XZ_Spacer)                  [list $pt_10  $pt_30]
            set Scalar(Spacer_Height)               $heightSpacer
                #
            set Position(Origin_Spacer)             [vectormath::subVector $Position(End_Spacer)    $pt_31]
            set Position(Edge_SpacerBack_Bottom)    [vectormath::addVector $Position(Origin_Spacer) $pt_10]
            set Position(Edge_SpacerBack_Top)       [vectormath::addVector $Position(Origin_Spacer) $pt_30]
                #
            return
                #
        }
            #
            #
        method update_componentNode_QuillStem {} {
                #
            variable Config
            variable Polygon
            variable Scalar
                #
            variable ComponentNode      
                #
            set Polygon(XZ)         {}
            set Polygon(XZ_Cap)     {}
            set Polygon(XZ_Spacer)  {}
                #
            set compDoc         [$ComponentNode(XZ)    ownerDocument ]
            set compNode        [$ComponentNode(XZ)    find id customComponent]
                #
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
            foreach childNode   [$compNode childNodes] {
                $compNode   removeChild $childNode
                $childNode  delete
            }
                
            set pt_00   {0 0}
            set pt_01   [vectormath::unifyVector    $pt_00 {-1 0} $Scalar(Length)]
            set pt_02   [vectormath::rotateLine     $pt_01 $Scalar(Length_Shaft) [expr {90 + $Scalar(Angle)}]]
                #
            set vct_a   [vectormath::parallel       $pt_00 $pt_01   12.7]    
            set vct_b   [vectormath::parallel       $pt_00 $pt_01   12.7 left]
                #
            set vct_c   [vectormath::parallel       $pt_01 $pt_02   11.0]    
            set vct_d   [vectormath::parallel       $pt_01 $pt_02   11.0 left]
                #
                # puts "$vct_a"
                # {7.776507174585692e-16 12.7} {-110.0 12.700000000000003}
            lassign $vct_a  pt_00a pt_01a   
            lassign $vct_b  pt_00b pt_01b
                #   
            lassign $vct_c  pt_01c pt_02c   
            lassign $vct_d  pt_01d pt_02d
                #
                # foreach {pt_00a pt_01a} $vct_a break   
                # foreach {pt_00b pt_01b} $vct_b break
                # foreach {pt_01c pt_02c} $vct_c break   
                # foreach {pt_01d pt_02d} $vct_d break
                #
                # -- intersection bottom-right
            set pt_11a  [vectormath::intersectPoint $pt_00a $pt_01a $pt_01c $pt_02c]
                #
            set pt_11a1 [vectormath::addVector      $pt_11a [vectormath::unifyVector $pt_00a $pt_01a  -6]]
            set pt_11a2 [vectormath::addVector      $pt_11a [vectormath::unifyVector $pt_01c $pt_02c   6]]
                #
                # -- intersection top-left
            set pt_11b  [vectormath::intersectPoint $pt_00b $pt_01b $pt_01d $pt_02d]
                #
            set pt_11b1 [vectormath::addVector      $pt_11b [vectormath::unifyVector $pt_00b $pt_01b -16]]
            set pt_11b2 [vectormath::addVector      $pt_11b [vectormath::unifyVector $pt_01d $pt_02d   6]]
                #
                # -- tangente to HandleBar-Eye - top
            set pt_00c [vectormath::rotatePoint    $pt_00 [list 0 17.5] 20]
            set pt_00d [vectormath::perpendicular  $pt_00c $pt_00 1]
            set pt_10a [vectormath::intersectPoint $pt_00a $pt_01a $pt_00c $pt_00d]
                # -- tangente to HandleBar-Eye - bottom
            set pt_10b [vectormath::mirrorPointList [list $pt_10a] x]
            set pt_00z [vectormath::mirrorPointList [list $pt_00c] x]
                #
                #
                # set polygon [join "$pt_00 $pt_00c $pt_10a $pt_11a $pt_02c $pt_02d $pt_11b $pt_00b" " "]
                # set polygon [join "$pt_00 $pt_00c $pt_10a $pt_11a $pt_02c $pt_02d $pt_11b $pt_10b $pt_00z" " "]
                # set polygon [join "$pt_00 $pt_00c $pt_10a $pt_11a $pt_02c $pt_02d $pt_11b2 $pt_11b1 $pt_10b $pt_00z" " "]
            set polygon [join "$pt_00 $pt_00c $pt_10a $pt_11a1 $pt_11a2 $pt_02c $pt_02d $pt_11b2 $pt_11b1 $pt_10b $pt_00z" " "]
                #
                
            set pt_91   [vectormath::rotatePoint    $pt_00 $pt_01   [expr {-1.0 * $Scalar(Angle)}]]    
            set pt_92   [vectormath::rotatePoint    $pt_00 $pt_02   [expr {-1.0 * $Scalar(Angle)}]]    
            set pt_91a  [vectormath::rotatePoint    $pt_00 $pt_11a  [expr {-1.0 * $Scalar(Angle)}]]    
            set pt_91b  [vectormath::rotatePoint    $pt_00 $pt_11b  [expr {-1.0 * $Scalar(Angle)}]]    
                #
            set polygon [vectormath::rotateCoordList {0 0} $polygon [expr {-1.0 * $Scalar(Angle)}]]
                #
                #
            set Polygon(XZ) $polygon
                #
                #
                # -- polygon
                #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      Stem
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  [my format_PointList $Polygon(XZ)]
                #
                #
                # -- reference Points
                #
            set newNode [$compDoc createElement circle]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      HandleBar_Eye
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    cx      [lindex $pt_00 0]
                $newNode    setAttribute    cy      [lindex $pt_00 1]
                $newNode    setAttribute    r       17.5
                #
            set newNode [$compDoc createElement circle]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      HandleBar_Eye
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    cx      [lindex $pt_00 0]
                $newNode    setAttribute    cy      [lindex $pt_00 1]
                $newNode    setAttribute    r       15.4
                #
                #
                # -- cleanup attribure: xlmns from first layer
                #
            foreach childNode [$compNode childNodes] {
                # puts "  -> $childNode"
                catch {$childNode removeAttribute xmlns}
            }            
                #
        }
            #
    }
        
        