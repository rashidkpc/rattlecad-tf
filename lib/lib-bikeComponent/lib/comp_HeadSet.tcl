 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_HeadSet.tcl
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

oo::class create bikeComponent::HeadSet {

        # <HeadSet>
        #     <Height>
        #         <Bottom>13.50</Bottom>
        #         <Top>15.50</Top>
        #     </Height>
        #     <Diameter>45.00</Diameter>
        # </HeadSet>
        
    superclass bikeComponent::Component
    
        #
    variable packageHomeDir
    variable array_CompBaseDir
        #

    constructor {} {
            #
        next   
            #
        puts "              -> class HeadSet"
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
                                            XZ_Bottom                               {}
                                            XZ_Top                                  {}
                                        }    
            #
        variable ComponentNode                    
        variable Direction                
        variable Polygon            ; array set Polygon {
                                            XZ_Top                                  {}
                                            XZ_Bottom                               {}
                                        }
        variable Position           ; array set Position {
                                            Edge_HeadSetBottomFront_Bottom {0.00 0.00}
                                            Edge_HeadSetBottomFront_Top    {0.00 0.00}
                                            Edge_HeadSetTopBack_Bottom     {0.00 0.00}
                                            Edge_HeadSetTopBack_Top        {0.00 0.00}
                                            Edge_HeadSetTopFront_Bottom    {0.00 0.00}
                                            Edge_HeadSetTopFront_Top       {0.00 0.00}
                                            Origin                         {0.00 0.00}
                                            Origin_Top                     {0.00 0.00}
                                            End_Top                        {0.00 0.00}
                                        }
            #
            #
            #
        variable myComponent        ; set myComponent [bikeComponent::bareHeadSet new]
            #
        ### my update
            #                            
    }

    method update {} {
            #
        variable myComponent
            #
        variable Config
        variable Scalar
            #
        variable ComponentNode
        variable Direction
        variable Polygon
        variable Position
            #
            # parray Direction
            #
        $myComponent update
            #
        set ComponentNode(XZ_Bottom)        [$myComponent getValue ComponentNode    XZ_Bottom]     
        set ComponentNode(XZ_Top)           [$myComponent getValue ComponentNode    XZ_Top   ]     
        set Polygon(XZ_Bottom)              [$myComponent getValue Polygon          XZ_Bottom]   
        set Polygon(XZ_Top)                 [$myComponent getValue Polygon          XZ_Top   ]   
            #
            # puts "HeadSet"
            #
        set Position(Origin_Top)            [vectormath::addVector  $Position(Origin)       [vectormath::rotatePoint {0 0} [list 0 $Scalar(Length_HeadTube)]        $Direction(Origin)]]
        set Position(End_Top)               [vectormath::addVector  $Position(Origin_Top)   [vectormath::rotatePoint {0 0} [$myComponent getValue Position End_Top] $Direction(Origin)]]
            #
            # puts "  \$Position(Origin)      $Position(Origin)"
            # puts "  \$Position(Origin_Top)  $Position(Origin_Top)"
            #
        set Position(Edge_HeadSetBottomFront_Bottom)    [vectormath::addVector  $Position(Origin)       [vectormath::rotatePoint {0 0} [$myComponent getValue Position Edge_HeadSetBottomFront_Bottom]    $Direction(Origin)]] 
        set Position(Edge_HeadSetBottomFront_Top)       [vectormath::addVector  $Position(Origin)       [vectormath::rotatePoint {0 0} [$myComponent getValue Position Edge_HeadSetBottomFront_Top   ]    $Direction(Origin)]] 
        set Position(Edge_HeadSetTopBack_Bottom)        [vectormath::addVector  $Position(Origin_Top)   [vectormath::rotatePoint {0 0} [$myComponent getValue Position Edge_HeadSetTopBack_Bottom    ]    $Direction(Origin)]] 
        set Position(Edge_HeadSetTopBack_Top)           [vectormath::addVector  $Position(Origin_Top)   [vectormath::rotatePoint {0 0} [$myComponent getValue Position Edge_HeadSetTopBack_Top       ]    $Direction(Origin)]]
        set Position(Edge_HeadSetTopFront_Bottom)       [vectormath::addVector  $Position(Origin_Top)   [vectormath::rotatePoint {0 0} [$myComponent getValue Position Edge_HeadSetTopFront_Bottom   ]    $Direction(Origin)]] 
        set Position(Edge_HeadSetTopFront_Top)          [vectormath::addVector  $Position(Origin_Top)   [vectormath::rotatePoint {0 0} [$myComponent getValue Position Edge_HeadSetTopFront_Top      ]    $Direction(Origin)]]
            #
            # puts "  \$Position(Edge_HeadSetBottomFront_Bottom)  $Position(Edge_HeadSetBottomFront_Bottom)"
            # puts "  \$Position(Edge_HeadSetBottomFront_Top)     $Position(Edge_HeadSetBottomFront_Top)"
            # puts "  \$Position(Edge_HeadSetTopFront_Bottom)     $Position(Edge_HeadSetTopFront_Bottom)"
            # puts "  \$Position(Edge_HeadSetTopFront_Top)        $Position(Edge_HeadSetTopFront_Top)"
            #
    }
        #
    method setPlacement {pos angle distance} {
            #
            # position of ForkCrown
            #
        variable Scalar   
        variable Direction   
        variable Position
            #
        set Direction(Origin)       $angle
        set Position(Origin)        $pos
        set Scalar(Length_HeadTube) $distance
            #
            # puts "setPlacement"    
            # puts "   -> \$Direction(Origin) $Direction(Origin)"    
            # puts "   -> \$Position(Origin)  $Position(Origin)"    
            # puts "   -> \$Scalar(Length_HeadTube) $Scalar(Length_HeadTube)"  
            #
        ### my update
        my update
            #
        #exit
    }            
}
