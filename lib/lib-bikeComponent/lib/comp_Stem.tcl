 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_Stem.tcl
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
 #  namespace:  bikeComponent::ComponentBasic      
 # ---------------------------------------------------------------------------
 #
 #

oo::class create bikeComponent::Stem {

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
        puts "              -> class Stem"
            #
        variable Config             ; array set Config {
                                            Type                Ahead
                                        }
        variable Scalar             ; array set Scalar {
                                            Angle               -6.00
                                            Length             110.00
                                            Length_Shaft        45.00
                                            Spacer_Height        7.00
                                        }
        variable Direction          ; array set Direction {
                                            Origin              0.00
                                        }    

        variable Polygon            ; array set Polygon {
                                            XZ                  {}
                                            XZ_Cap              {}
                                            XZ_Spacer           {}
                                        }
        variable Position           ; array set Position {
                                            Origin_Cap              {0 0}
                                            End_Cap                 {0 0}
                                            Origin_Spacer           {0 0}
                                            End_Spacer              {0 0}
                                            Steerer                 {0 0}
                                            Edge_SpacerBack_Bottom  {0 0}
                                            Edge_SpacerBack_Top     {0 0}
                                        }
            #
        variable ComponentNode                    
        variable Direction                
        variable Position               
            #
            #
            #
        variable myComponent        ; set myComponent [bikeComponent::bareStem new]
            #
        ### my update
            #                            
    }

    method update {} {
            #
        variable myComponent
            #
        variable Config
        variable Direction
        variable Scalar
        variable ComponentNode
        variable Polygon
        variable Position
            #
            #
        $myComponent update
            #
        set ComponentNode(XZ)               [$myComponent getValue ComponentNode    XZ]
            #
        set Polygon(XZ)                     [$myComponent getValue Polygon          XZ]   
        set Polygon(XZ_Cap)                 [$myComponent getValue Polygon          XZ_Cap]   
        set Polygon(XZ_Spacer)              [$myComponent getValue Polygon          XZ_Spacer]   
            #       
        set Scalar(Spacer_Height)           [$myComponent getValue Scalar           Spacer_Height]   
            #
        set Position(Origin_Cap)            [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    Origin_Cap            ] $Direction(Origin)]]
        set Position(End_Cap)               [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    End_Cap               ] $Direction(Origin)]]
        set Position(Origin_Spacer)         [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    Origin_Spacer         ] $Direction(Origin)]]
        set Position(End_Spacer)            [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    End_Spacer            ] $Direction(Origin)]]
        set Position(Steerer)               [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    Steerer               ] $Direction(Origin)]]
        set Position(Edge_SpacerBack_Bottom) [vectormath::addVector $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    Edge_SpacerBack_Bottom] $Direction(Origin)]]
        set Position(Edge_SpacerBack_Top)   [vectormath::addVector  $Position(Origin) [vectormath::rotatePoint {0 0} [$myComponent getValue Position    Edge_SpacerBack_Top   ] $Direction(Origin)]]
            #
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
}
