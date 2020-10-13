 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_ForkStrategy.tcl
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
 #  namespace:  bikeComponent::ForkStrategy
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::ForkStrategy {

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


        superclass bikeComponent::classFork
        
            #
        variable packageHomeDir
            #

        constructor {{name {}}} {
                #
            next    
                #
            puts "              -> class ForkStrategy"
                #
            variable ForkCustomMAX      ; set ForkCustomMAX         [bikeComponent::ForkCustomSteelMAX      new]
            variable ForkCustomBent     ; set ForkCustomBent        [bikeComponent::ForkCustomSteelBent     new]
            variable ForkCustomStraight ; set ForkCustomStraight    [bikeComponent::ForkCustomSteelStraight new]
            variable ForkComposite      ; set ForkComposite         [bikeComponent::ForkComposite           new]
            variable ForkSuspension     ; set ForkSuspension        [bikeComponent::ForkSuspension          new]            
            variable ForkSupplier       ; set ForkSupplier          [bikeComponent::ForkSupplier            new]
                #
            variable strategyObject     ; set strategyObject        $ForkCustomBent 
            variable strategyName       ; set strategyName          ForkCustomBent 
                #
            variable steererObject      ; set steererObject         [bikeComponent::ForkSteerer             new]
                #
            variable Scalar             ; array set Scalar {
                                                BladeBrakeOffset          20.00
                                                RimDiameter              622.00
                                                SteererDiameter           25.40
                                                SteererLength            120.00
                                            } 
            variable ComponentNode      ; array set ComponentNode {
                                                XZ_Steerer                 {}
                                            }
            variable Polygon            ; array set Polygon {
                                                Steerer              {0.00  0.00}
                                            } 
            variable Polyline           ; array set Polyline {
                                                CenterLine_Steerer   {0.00  0.00}
                                            } 
            variable Position           ; array set Position {
                                                Brake                {0.00  0.00}
                                                Wheel                {1.00 -1.00}
                                                Steerer_End          {0.00  1.00}
                                            } 
            variable Vector             ; array set Vector {
                                                BladeDefinition      {0.00 0.00 1.00 0.00}
                                                BrakeDefinition      {0.00 0.00 1.00 0.00}
                                            } 
                # variable Config             ; array set Config {
                #                                     BladeStyle          bent
                #                                 }                                            
                # variable Scalar             ; array set Scalar {
                #                                     Height               365.00
                #                                     Rake                  45.00
                #                                     BladeBendRadius      350.00
                #                                     BladeDiameterDO       13.00
                #                                     BladeEndLength        10.00
                #                                     BladeOffsetCrown      35.00
                #                                     BladeOffsetCrownPerp   0.00
                #                                     BladeOffsetDO         20.00
                #                                     BladeOffsetDOPerp      0.00
                #                                     BladeTaperLength     250.00
                #                                     BladeWidth            28.60
                #                                     BrakeAngle             0.00
                #                                     CrownAngleBrake        0.00
                #                                     CrownOffsetBrake      20.00
                #                                     SteererLength        195.00
                #                                 }

                
                                            
            if {$name ne {}} {
                my setStrategy $name
            }
                #
            variable nodeSVG            [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            variable nodeSVG_Empty      [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            ### my update
                #
        }


            #-------------------------------------------------------------------------
                #  update Fork
                #
        method update {} {
                #
            variable Scalar
            variable ComponentNode
            variable Polygon
            variable Polyline
            variable Position
                #
            variable steererObject
            variable strategyObject
            variable strategyName
                #
                # puts " <D> bikeComponent::ForkStrategy -- update -- "    
                #
            $strategyObject update
            $steererObject  update
                #
            set Position(Wheel)                 [list $Scalar(Rake) [expr {-1.0 * $Scalar(Height)}]]
                #
            set Scalar(SteererDiameter)         [$steererObject getValue Scalar Diameter]
            set Scalar(SteererLength)           [$steererObject getValue Scalar Length]
                #
            set ComponentNode(XZ_Steerer)       [$steererObject getValue ComponentNode XZ]
                #
            set Polygon(Steerer)                [$steererObject getValue Polygon  XZ]
            set Polyline(CenterLine_Steerer)    [$steererObject getValue Polyline CenterLine]
            set Position(Steerer_End)           [$steererObject getValue Position End]
                #
            # my update_BrakePosition    
                # puts "\nFork - CenterLine: [$strategyObject getValue Polyline CenterLine]\n"
                # tk_messageBox -message "Fork - CenterLine"
                #
            return
                #
        }    
            #
        method setStrategy {name} {
                #
            variable strategyObject
            variable strategyName
                #
            variable ForkComposite      
            variable ForkComposite45      
            variable ForkComposite56      
            variable ForkCustomBent     
            variable ForkCustomStraight     
            variable ForkCustomMAX      
            variable ForkSupplier       
            variable ForkSuspension     
                #
            # puts "\n              -> setStrategy: $strategyName\n"
                #
            if {$name eq $strategyName} {
                return
            }
                #
            set forkHeight  [$strategyObject getValue Scalar Height]
            set forkRake    [$strategyObject getValue Scalar Rake]
                #
            switch -exact $name {
                CompositeTUSK       -
                Composite           {   set strategyObject $ForkComposite;      set strategyName Composite_45}
                Composite_45        {   set strategyObject $ForkComposite;      set strategyName Composite_45}
                Composite_56        {   set strategyObject $ForkComposite;      set strategyName Composite_56}
                SteelCustom         -
                SteelCustomBent     {   set strategyObject $ForkCustomBent;     set strategyName SteelCustomBent}
                SteelCustomStraight {   set strategyObject $ForkCustomStraight; set strategyName SteelCustomStraight}
                SteelLuggedMAX      {   set strategyObject $ForkCustomMAX;      set strategyName SteelLuggedMAX}
                Supplier            {   set strategyObject $ForkSupplier;       set strategyName Supplier}
                Suspension          {   set strategyObject $ForkSuspension;     set strategyName Suspension_26}
                Suspension_20       {   set strategyObject $ForkSuspension;     set strategyName Suspension_20}
                Suspension_24       {   set strategyObject $ForkSuspension;     set strategyName Suspension_24}
                Suspension_26       {   set strategyObject $ForkSuspension;     set strategyName Suspension_26}
                Suspension_27       {   set strategyObject $ForkSuspension;     set strategyName Suspension_27}
                Suspension_29       {   set strategyObject $ForkSuspension;     set strategyName Suspension_29}
                default             {
                                        puts "              -> keep $strategyName for ForkStrategy"
                                        return
                                    }
            }
                #
            $strategyObject setValue Scalar Height  $forkHeight    
            $strategyObject setValue Scalar Rake    $forkRake    
                #
            switch -exact $strategyName {
                Composite       {   $strategyObject setValue Config CrownType default}
                Composite_45    {   $strategyObject setValue Config CrownType Crown45}
                Composite_56    {   $strategyObject setValue Config CrownType Crown56}
                Suspension_20   -
                Suspension_24   -
                Suspension_26   -
                Suspension_27   -
                Suspension_29   {   $strategyObject setValue Config BridgeKey $strategyName}
                default         {}
            }
                #
            my  update 
                #
            # puts "\n  -> setStrategy: $strategyName\n"
                #
            return $strategyName
                #
        }
            #
        method getStrategy {} {
                #
            variable strategyName
            variable strategyObject
                #
            $strategyObject update
                #
            return $strategyName
                #
        }
            #
        method setValue {arrayName keyName value} {
                #
            variable Config
            variable Scalar
                #
            variable steererObject
            variable strategyObject
            variable strategyName
                #
            set keyString "$arrayName/$keyName"
                # puts "--- setValue -> \$keyString $keyString"
            switch -exact $keyString {
                Config/Type {   
                        set retValue [my setStrategy $value]
                        return $retValue
                    }
                Scalar/BladeBrakeOffset -
                Scalar/RimDiameter  {
                        array set $arrayName [list $keyName $value]
                    }
                Scalar/SteererDiameter {
                        $steererObject setValue Scalar Diameter $value
                    }
                Scalar/SteererLength {
                        $steererObject setValue Scalar Length $value
                    }
                default {
                        set retValue [$strategyObject setValue $arrayName   $keyName    $value]
                        return $retValue
                    }
            }
        }
            #
        method getValue {arrayName keyName} {
                #
            variable Config
            variable Scalar
            variable ComponentNode
            variable Polygon
            variable Polyline
            variable Position
            variable Vector
                #
            variable steererObject
            variable strategyObject
            variable strategyName
                #
            # my  update    
                #
            set keyString "$arrayName/$keyName"
                # puts "--- ForkStartegy getValue -> \$keyString $keyString"
            switch -exact $keyString {
                Config/Type {      
                        set retValue $strategyName 
                        # puts "  --> $retValue"
                        return $retValue
                    }
                Scalar/BladeBrakeOffset -
                Scalar/RimDiameter -
                Scalar/SteererDiameter -
                Scalar/SteererLength -
                ComponentNode/XZ_Steerer -
                Polygon/Steerer -              
                Polyline/CenterLine_Steerer -  
                Position/Steerer_End -         
                Position/Brake -
                Position/Wheel -
                Vector/BrakeDefinition {
                            # parray $arrayName
                        set retValue [lindex [array get $arrayName $keyName] 1]
                            # puts "   --> $retValue"
                        return $retValue
                    }    
                default {
                        set retValue [$strategyObject getValue $arrayName $keyName]
                            # puts "  --> $retValue"
                        return $retValue
                    }
            }
                #
        }
            #
        method update_BrakePosition {} {
                #
            variable Scalar
            variable Position
            variable Polyline
            variable Vector
            variable strategyObject
                #
                # puts "  \$Scalar(BladeBrakeOffset) $Scalar(BladeBrakeOffset)"
                # puts "  \$Scalar(RimDiameter) $Scalar(RimDiameter)"
                # puts "  \$Polyline(CenterLine) [$strategyObject getValue Polyline CenterLine]"
                #
            set height                  [$strategyObject getValue Scalar Height]
            set rake                    [$strategyObject getValue Scalar Rake]
            set radius                  [expr {0.5 * $Scalar(RimDiameter)}]
                #
            set vector_ForkBlade        [$strategyObject getValue Vector BladeDefinition]
                #
            set p_01                    [lrange $vector_ForkBlade 0 1]
            set p_02                    [lrange $vector_ForkBlade 2 3]
                #
            set vector_BrakeDef         [vectormath::parallel $p_01 $p_02 $Scalar(BladeBrakeOffset) left]
            lassign                     $vector_BrakeDef  p_11 p_12 
                # foreach {p_11 p_12}   $vector_BrakeDef break
                #
            set p_14                    [vectormath::intersectPerp $p_11 $p_12 $Position(Wheel)]
                #
            set dist_Perp               [vectormath::distancePerp $p_11 $p_12 $Position(Wheel)]
            set dist_Wheel              [expr {sqrt(pow($radius,2) - pow($dist_Perp,2))}]
                #
            set dir_Definition          [vectormath::unifyVector $p_11 $p_12]
                #
            set dist_Orientation        [vectormath::offsetOrientation $p_11 $p_12 $Position(Wheel)]
                #
            set Position(Brake)         [vectormath::addVector $p_14 [vectormath::unifyVector $p_12 $p_11] $dist_Wheel]
                #
            set vector_Repos            [list $Scalar(Rake) 0]
                # set vector_Repos            [list $Scalar(Rake) $Scalar(Height)]
                #                
            puts "      strategy: 011 -> \$p_11 $p_11"
            puts "      strategy: 012 -> \$p_12 $p_12"
            puts "      strategy: 014 -> \$p_14 $p_14"
            puts "      strategy: -----> orientation  $dist_Orientation"
            puts "      strategy: -----> \$dist_Perp  $dist_Perp"
            puts "      strategy: -----> \$dist_Wheel $dist_Wheel"
                #

            set Vector(BrakeDefinition) [vectormath::addVectorCoordList $vector_Repos [appUtil::flatten_nestedList $vector_BrakeDef]]
            set Vector(BrakeDefinition) [appUtil::flatten_nestedList $vector_BrakeDef]
                #
            return
                #
        }
            #
    }
