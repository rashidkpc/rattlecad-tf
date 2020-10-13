 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_ForkCustomSteelStraight.tcl
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
 #  namespace:  bikeComponent::fork::... 
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkCustomSteelStraight {

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


        superclass bikeComponent::compForkCustomSteel
        
            #
        variable packageHomeDir
        variable array_CompBaseDir
            #
        variable nodeSVG

        constructor {} {
                #
            variable objectBlade    
                #
            next
                #
            $objectBlade    setBladeStyle   straight 
                #
            puts "              -> class ForkCustomSteelStraight"
                #
            variable Config             ; array set Config {
                                                ComponentKey_Crown      etc:fork/crown/longshen_34.svg
                                                ComponentKey_Dropout    etc:fork/dropout/LE_17.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                SteererLength            195.00                                            
                                                Height                   365.00
                                                Rake                      45.00
                                                CrownBladeOffset          35.00
                                                CrownBladeOffsetPerp       1.50
                                                CrownBrakeAngle            0.00
                                                CrownBrakeOffset          20.00
                                                BladeDropoutWidth         13.00
                                                BladeStartLength          10.00
                                                BladeTaperLength         250.00
                                                BladeBendRadius          350.00
                                                BladeWidth                28.60
                                                DropoutBladeOffset        20.00
                                                DropoutBladeOffsetPerp     0.00
                                                DropoutAngle               0.00
                                            }
                #
        }


        #-------------------------------------------------------------------------
            #  create custom Fender
            #
        method update {} {
            next               
        }    
            #
    }    