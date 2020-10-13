 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_SeatPost.tcl
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
 #  namespace:  bikeComponent::SeatPost      
 # ---------------------------------------------------------------------------
 #
 #

oo::class create bikeComponent::SeatPost {

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
        #

    constructor {} {
            #
        next   
            #
        puts "              -> class SeatPost"
            #
        variable Config             ; array set Config {
                                            Style                Ritchey
                                        }
        variable Scalar             ; array set Scalar {
                                            Length                   250.00
                                            Diameter                  27.20
                                            PivotOffset               40.00
                                            Setback                   25.00
                                        }
        variable Position           ; array set Position {
                                            ShaftStart              {0 0}
                                            ShaftEnd                {0 0}
                                        }
            #
        variable ComponentNode                    
        variable Direction                
        variable Polygon                 
            #
            #
            #
        variable myComponent        ; set myComponent [bikeComponent::bareSeatPost new]
            #
        ### my update
            #                            
    }

    method update {} {
            #
        variable myComponent
            #
        variable ComponentNode
        variable Polygon
        variable Position
            #
            #
        $myComponent update
            #
        set ComponentNode(XZ)               [$myComponent getValue ComponentNode    XZ]     
        set Polygon(XZ)                     [$myComponent getValue Polygon          XZ]   
            #       
        set Position(ShaftStart)            [$myComponent getValue Position         ShaftStart]   
        set Position(ShaftEnd)              [$myComponent getValue Position         ShaftEnd]   
            #       
    }
        #
}
