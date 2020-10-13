 ##+##########################################################################te
 #
 # package: bikeComponent   ->  RearHub.tcl
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
 #  namespace:  bikeComponent::RearHub      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::bareRearHub {

            # <HeadSet>
            #     <Height>
            #         <Bottom>13.50</Bottom>
            #         <Top>15.50</Top>
            #     </Height>
            #     <Diameter>45.00</Diameter>
            # </HeadSet>

        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
            #

        constructor {} {
                #
            set   objectName    "RearHub"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #

            variable Config             ; array set Config {
                                                Type                Ahead
                                            }
            variable Scalar             ; array set Scalar {
                                                HubWidth             130.00
                                            }
                #
            variable ComponentNode
                #
            set ComponentNode(XY)       [my readSVGFile [file join $packageHomeDir components hub rattleCAD_rear.svg]]
            set ComponentNode(XY_Disc)  [my readSVGFile [file join $packageHomeDir components hub rattleCAD_rear_disc.svg]]
            variable nodeSVG_Empty      [my readSVGFile [file join $packageHomeDir components default_template.svg]]

        }

        #-------------------------------------------------------------------------
            #  create custom RearHub
            #
        method update {} {
                #
            my update_XY
            my update_XY disc
                #  
        }
            #
        method update_XY__ {} {
                #
            variable Config
            variable Scalar
                #
            variable ComponentNode      
                #
           
                #
            set compDoc         [$ComponentNode(XY) ownerDocument ]
            set compNode        [$ComponentNode(XY) find id customComponent]
                #
            set centerNode      [$ComponentNode(XY) find id center_00]
                # puts [$centerNode asXML]
            set cx              [$centerNode getAttribute cx]
            set cy              [$centerNode getAttribute cy]
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
            foreach childNode [$compNode childNodes] {
                set idString [$childNode getAttribute id]
                switch -exact $idString {
                    HubBody {}
                    default {
                            $compNode   removeChild $childNode
                            $childNode  delete
                        }
                }
            }
                
                #
                # -- Axle
                #
            set polygonAxle      [my get_polygon_Axle $cx $cy]
                    #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      Axle
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  $polygonAxle                           
                #
      
                #
                # -- organize layers
                #
            set bodyNode    [$compNode find id HubBody] 
            $compNode removeChild $bodyNode
            $compNode appendChild $bodyNode

      
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
        method update_XY {{type {}}} {
                #
            variable Config
            variable Scalar
                #
            variable ComponentNode      
                #
           
                #
            if {$type eq {}} {
                    #
                set compDoc         [$ComponentNode(XY) ownerDocument ]
                set compNode        [$ComponentNode(XY) find id customComponent]
                set centerNode      [$ComponentNode(XY) find id center_00]
                    #
            } else {
                    #
                set compDoc         [$ComponentNode(XY_Disc) ownerDocument ]
                set compNode        [$ComponentNode(XY_Disc) find id customComponent]
                set centerNode      [$ComponentNode(XY_Disc) find id center_00]
                    #
            }    
                #
                
                # puts [$centerNode asXML]
            set cx              [$centerNode getAttribute cx]
            set cy              [$centerNode getAttribute cy]
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
            foreach childNode [$compNode childNodes] {
                set idString [$childNode getAttribute id]
                switch -exact $idString {
                    HubBody {}
                    default {
                            $compNode   removeChild $childNode
                            $childNode  delete
                        }
                }
            }
                
                #
                # -- Axle
                #
            set polygonAxle      [my get_polygon_Axle $cx $cy]
                    #
            set newNode [$compDoc createElement polygon]
                $compNode   appendChild     $newNode
                $newNode    setAttribute    id      Axle
                $newNode    setAttribute    style   "stroke:black;fill:#f2f2f2;stroke-width:0.2"
                $newNode    setAttribute    points  $polygonAxle                           
                #
      
                #
                # -- organize layers
                #
            set bodyNode    [$compNode find id HubBody] 
            $compNode removeChild $bodyNode
            $compNode appendChild $bodyNode

      
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
        method get_polygon_Axle {x y} {
                #
            variable Config
            variable Scalar
                #
                
                
            set diameter_Axle   20.0
            set radius_Axle     [expr {0.5 * $diameter_Axle}]
                #
                # -- Axle
                #
            set pt_00   [list $x $y]
            set pt_01   [vectormath::addVector $pt_00 {0 1} [expr { 0.5 * $Scalar(HubWidth)}]]
            set pt_02   [vectormath::addVector $pt_00 {0 1} [expr {-0.5 * $Scalar(HubWidth)}]]
                #
            set vct_10  [vectormath::parallel  $pt_01 $pt_02 $radius_Axle ]
            set vct_20  [vectormath::parallel  $pt_02 $pt_01 $radius_Axle ]
                #
            set polygon [list $vct_10 $vct_20]
            set polygon [appUtil::flatten_nestedList [appUtil::flatten_nestedList $polygon]]
            set polygon [my format_PointList $polygon]
                #
            return $polygon
               #
         }    
            #
    }