 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_CrankSet.tcl
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
 #  namespace:  bikeComponent::CrankSet      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::CrankSet {

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
            puts "              -> class CrankSet"
                #
            variable Config             ; array set Config {
                                                SpyderArmCount           5
                                                ComponentKey           etc:crankset/campagnolo_ultra_torque.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                Length                 172.50
                                                PedalEye                17.50
                                                Q-Factor               145.50
                                                ArmWidth                13.75
                                                ChainLine               43.50
                                                ChainRingOffset          5
                                                BottomBracket_Width     68.00
                                            } 
            variable ListValue          ; array set ListValue {
                                                ChainRings          {25-39-53}
                                                ChainWheelDef     {75-110-130}
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XY_Custom                   {}
                                                XZ_Custom                   {}
                                                XZ                          {}
                                            }                     
            variable Direction
            variable Polygon            ; array set Polygon {
                                                XY_ChainWheels              {}
                                                XY_CrankArm                 {}
                                                XZ_ChainWheels              {}
                                                XZ_CrankArm                 {}
                                                SpyderArm                   {}
                                            }
            variable Position           ; array set Position {
                                                Bolts                {1.00 0.00}
                                                Origin               {0.00 0.00}
                                            }

                #
            variable ComponentNode                    
            variable Direction                
            variable Position               
                #
                #
                #
            variable myComponent        ; set myComponent [bikeComponent::bareCrankSet new]
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
            variable ListValue
                #
            variable ComponentNode
            variable Polygon
            variable Position
                #
                #
            $myComponent update
                #
            set Config(SpyderArmCount)          [$myComponent getValue Config   SpyderArmCount]
            set Config(ComponentKey)            [$myComponent getValue Config   ComponentKey]
                #
            set Scalar(Length)                  [$myComponent getValue Scalar   Length]
            set Scalar(PedalEye)                [$myComponent getValue Scalar   PedalEye]
            set Scalar(Q-Factor)                [$myComponent getValue Scalar   Q-Factor]
            set Scalar(ArmWidth)                [$myComponent getValue Scalar   ArmWidth]
            set Scalar(ChainLine)               [$myComponent getValue Scalar   ChainLine]
            set Scalar(ChainRingOffset)         [$myComponent getValue Scalar   ChainRingOffset]
            set Scalar(BottomBracket_Width)     [$myComponent getValue Scalar   BottomBracket_Width]
                #
            set ListValue(ChainRings)           [$myComponent getValue ListValue    ChainRings]
            set ListValue(ChainWheelDef)        [$myComponent getValue ListValue    ChainWheelDef]
                #
            set ComponentNode(XY_Custom)        [$myComponent getValue ComponentNode    XY_Custom]
            set ComponentNode(XZ_Custom)        [$myComponent getValue ComponentNode    XZ_Custom]
            set ComponentNode(XZ)               [$myComponent getValue ComponentNode    XZ]
                #
            set Polygon(XY_ChainWheels)         [$myComponent getValue Polygon  XY_ChainWheels]
            set Polygon(XY_CrankArm)            [$myComponent getValue Polygon  XY_CrankArm]
            set Polygon(XZ_ChainWheels)         [$myComponent getValue Polygon  XZ_ChainWheels]
            set Polygon(XZ_CrankArm)            [$myComponent getValue Polygon  XZ_CrankArm]
            set Polygon(XZ_SpyderArm)           [$myComponent getValue Polygon  XZ_SpyderArm]
                #
            set Position(Bolts)                 [$myComponent getValue Position Bolts]
                #       
        }
            #
        method setValue {arrayName keyName value} {
                #
            variable list_ValueException
                #
            set keyString "$arrayName/$keyName"
            switch -exact $keyString {
                ListValue/ChainWheelDef {      
                        return
                    }
                default {}
            }
                #
            next $arrayName $keyName $value    
            ### my update
                #
        }
            # 
    }
