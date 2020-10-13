 ##+##########################################################################
 #
 # package: bikeGeometry    ->    bikeGeometry.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
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
 #    namespace:  bikeGeometry
 # ---------------------------------------------------------------------------
 #
 #

    #-------------------------------------------------------------------------
        #  get current projectDOM as Dictionary
    proc bikeGeometry::initValues_1.x {} {
    
        #-------------------------------------------------------------------------
            #  definitions of template Documents
        variable packageHomeDir 
        variable initRoot 
        variable projectDOM        
        
        #-------------------------------------------------------------------------
            #  fill initRoot
            #    ... these are default settings for the application
            #               
        set fp [open [file join $packageHomeDir .. etc initTemplate.xml] ]
        fconfigure      $fp -encoding utf-8
        set initXML     [read $fp]
        close           $fp          
        set initDoc     [dom parse $initXML]
        set initRoot     [$initDoc documentElement]
        
        
        #-------------------------------------------------------------------------
            #  fill projectDOM
            #    ... these is a default project
            #  
        set fp [open [file join $packageHomeDir .. etc projectTemplate.xml] ]
        fconfigure      $fp -encoding utf-8
        set projXML     [read $fp]
        close           $fp          
        set projDoc     [dom parse $projXML]
        set projectDOM  [$projDoc documentElement]  
            
        #-------------------------------------------------------------------------
            #  set initValues
            #
        bikeGeometry::set_newProject $projectDOM
            
    }
    
    proc bikeGeometry::initValues {} {
    
        #-------------------------------------------------------------------------
            #  definitions of template Documents
        variable packageHomeDir 
        variable initRoot 
        variable projectDOM        
        
        #-------------------------------------------------------------------------
            #  fill initRoot
            #    ... these are default settings for the application
            #               
        set fp [open [file join $packageHomeDir .. etc initTemplate.xml] ]
        fconfigure      $fp -encoding utf-8
        set initXML     [read $fp]
        close           $fp          
        set initDoc     [dom parse $initXML]
        set initRoot     [$initDoc documentElement]
        
        
        #-------------------------------------------------------------------------
            #  init Values
            #    ... these is a default project
            #  
            #
        set ::bikeGeometry::Component(CrankSet)                    "etc:crankset/shimano_FC-M770.svg"
        set ::bikeGeometry::Component(ForkCrown)                   "etc:fork/_suspension/fork_crown.svg"
        set ::bikeGeometry::Component(ForkDropout)                 "etc:fork/_suspension/suspension_bridge_26.svg"
        set ::bikeGeometry::Component(ForkSupplier)                "etc:fork/supplier/rattleCAD_Carbon_Oversize_370_45.svg"  
        set ::bikeGeometry::Component(FrontBrake)                  "etc:brake/front/v_frontbrake.svg"
        set ::bikeGeometry::Component(FrontCarrier)                "etc:carrier/front/__blank__.svg"
        set ::bikeGeometry::Component(FrontDerailleur)             "etc:derailleur/front/campagnolo_qs.svg"
        set ::bikeGeometry::Component(HandleBar)                   "etc:handlebar/flatbar_sti.svg"
        set ::bikeGeometry::Component(Label)                       "etc:label/rattleCAD_22.svg"
        set ::bikeGeometry::Component(RearBrake)                   "etc:brake/rear/v_rearbrake.svg"
        set ::bikeGeometry::Component(RearCarrier)                 "etc:carrier/rear/__blank__.svg"
        set ::bikeGeometry::Component(RearDerailleur)              "etc:derailleur/rear/shimano_RD-M773.svg"
        set ::bikeGeometry::Component(RearDropout)                 "etc:dropout/dropout_02.svg"
        set ::bikeGeometry::Component(RearHub)                     "hub/rattleCAD_rear.svg"
        set ::bikeGeometry::Component(Saddle)                      "etc:saddle/saddle_d.svg"
        set ::bikeGeometry::Component(BottleCage_DownTube)         "etc:bottleCage/right/bottleCage.svg"
        set ::bikeGeometry::Component(BottleCage_DownTube_Lower)   "etc:bottleCage/left/bottleCage.svg"
        set ::bikeGeometry::Component(BottleCage_SeatTube)         "etc:bottleCage/left/bottleCage.svg"
            #
        set ::bikeGeometry::Config(BottleCage_DownTube)            "Cage"
        set ::bikeGeometry::Config(BottleCage_DownTube_Lower)      "off"
        set ::bikeGeometry::Config(BottleCage_SeatTube)            "Cage"
        set ::bikeGeometry::Config(ChainStay)                      "bent"
        set ::bikeGeometry::Config(CrankSet_SpyderArmCount)        5          
        set ::bikeGeometry::Config(Fork)                           "Suspension_26"
        set ::bikeGeometry::Config(ForkBlade)                      "bent"
        set ::bikeGeometry::Config(ForkDropout)                    "front"
        set ::bikeGeometry::Config(FrontBrake)                     "Rim"
        set ::bikeGeometry::Config(FrontFender)                    "off"
        set ::bikeGeometry::Config(HeadTube)                       "cylindric"
        set ::bikeGeometry::Config(RearBrake)                      "Rim"
        set ::bikeGeometry::Config(RearDropout)                    "behind"
        set ::bikeGeometry::Config(RearDropoutOrient)              "ChainStay"
        set ::bikeGeometry::Config(RearFender)                     "off"
        set ::bikeGeometry::Config(Color_FrameTubes)               #edc778                 
        set ::bikeGeometry::Config(Color_Fork)                     #edc778                       
        set ::bikeGeometry::Config(Color_Label)                    "white"                      
            #
        set ::bikeGeometry::ListValue(CrankSetChainRings)          22-32-44            
            #
        set ::bikeGeometry::BottleCage(DownTube)                   210.00                     
        set ::bikeGeometry::BottleCage(DownTube_Lower)             140.00               
        set ::bikeGeometry::BottleCage(SeatTube)                   130.00                     
        set ::bikeGeometry::BottomBracket(InsideDiameter)          36.00            
        set ::bikeGeometry::BottomBracket(OffsetCS_TopView)        5.00          
        set ::bikeGeometry::BottomBracket(OutsideDiameter)         40.00           
        set ::bikeGeometry::BottomBracket(Width)                   68.00                     
            #
        set ::bikeGeometry::ChainStay(DiameterSS)                  13.00                    
        set ::bikeGeometry::ChainStay(Height)                      29.00                        
        set ::bikeGeometry::ChainStay(HeightBB)                    29.00                      
        set ::bikeGeometry::ChainStay(TaperLength)                 280.00                   
        set ::bikeGeometry::ChainStay(WidthBB)                     18.00                       
        set ::bikeGeometry::ChainStay(completeLength)              410.00                
        set ::bikeGeometry::ChainStay(cuttingLeft)                 0.00                   
        set ::bikeGeometry::ChainStay(cuttingLength)               391.69918059222357                 
        set ::bikeGeometry::ChainStay(profile_x01)                 150.00                   
        set ::bikeGeometry::ChainStay(profile_x02)                 150.00                   
        set ::bikeGeometry::ChainStay(profile_x03)                 75.00                   
        set ::bikeGeometry::ChainStay(profile_y00)                 12.50                   
        set ::bikeGeometry::ChainStay(profile_y01)                 18.00                   
        set ::bikeGeometry::ChainStay(profile_y02)                 18.00                   
        set ::bikeGeometry::ChainStay(segmentAngle_01)             9.00               
        set ::bikeGeometry::ChainStay(segmentAngle_02)             -9.00               
        set ::bikeGeometry::ChainStay(segmentAngle_03)             0.00               
        set ::bikeGeometry::ChainStay(segmentAngle_04)             0.00               
        set ::bikeGeometry::ChainStay(segmentLength_01)            150.00              
        set ::bikeGeometry::ChainStay(segmentLength_02)            140.00              
        set ::bikeGeometry::ChainStay(segmentLength_03)            78.00              
        set ::bikeGeometry::ChainStay(segmentLength_04)            10.00              
        set ::bikeGeometry::ChainStay(segmentRadius_01)            320.00              
        set ::bikeGeometry::ChainStay(segmentRadius_02)            320.00              
        set ::bikeGeometry::ChainStay(segmentRadius_03)            320.00              
        set ::bikeGeometry::ChainStay(segmentRadius_04)            320.00              
            #
        set ::bikeGeometry::CrankSet(ArmWidth)                     13.75                       
        set ::bikeGeometry::CrankSet(ChainLine)                    43.50                      
        set ::bikeGeometry::CrankSet(ChainRingOffset)              7                
        set ::bikeGeometry::CrankSet(Length)                       175                         
        set ::bikeGeometry::CrankSet(PedalEye)                     17.50                       
        set ::bikeGeometry::CrankSet(Q-Factor)                     160.000                       
            #
        set ::bikeGeometry::DownTube(DiameterBB)                   33.000                         
        set ::bikeGeometry::DownTube(DiameterHT)                   39.000                         
        set ::bikeGeometry::DownTube(OffsetBB)                     0.00                           
        set ::bikeGeometry::DownTube(OffsetHT)                     8.50                           
        set ::bikeGeometry::DownTube(TaperLength)                  300.00                        
            #
        set ::bikeGeometry::Fork(BladeBendRadius)                  350.00                        
        set ::bikeGeometry::Fork(BladeDiameterDO)                  13.00                        
        set ::bikeGeometry::Fork(BladeEndLength)                   10.00                         
        set ::bikeGeometry::Fork(BladeOffsetCrown)                 35.00                       
        set ::bikeGeometry::Fork(BladeOffsetCrownPerp)             0.00                   
        set ::bikeGeometry::Fork(BladeOffsetDO)                    20.00                          
        set ::bikeGeometry::Fork(BladeOffsetDOPerp)                0.00                      
        set ::bikeGeometry::Fork(BladeTaperLength)                 250.00                       
        set ::bikeGeometry::Fork(BladeWidth)                       28.60                             
        set ::bikeGeometry::Fork(CrownAngleBrake)                  0.00                        
        set ::bikeGeometry::Fork(CrownOffsetBrake)                 30.0                       
        set ::bikeGeometry::Fork(BladeBrakeOffset)                 32.00                       
        set ::bikeGeometry::Fork(Rake)                             40.00                                       
            #
        set ::bikeGeometry::FrontBrake(LeverLength)                45.00                      
        set ::bikeGeometry::FrontBrake(Offset)                     20.00                           
        set ::bikeGeometry::FrontCarrier(x)                        30.000                              
        set ::bikeGeometry::FrontCarrier(y)                        5.00                              
        set ::bikeGeometry::FrontDerailleur(Distance)              128.00                    
        set ::bikeGeometry::FrontDerailleur(Offset)                9.20                      
        set ::bikeGeometry::FrontFender(Height)                    15.00                          
        set ::bikeGeometry::FrontFender(OffsetAngle)               90.00                     
        set ::bikeGeometry::FrontFender(OffsetAngleFront)          20.00                
        set ::bikeGeometry::FrontFender(Radius)                    331.5                          
        set ::bikeGeometry::FrontWheel(RimHeight)                  45.000                        
            #
        set ::bikeGeometry::Geometry(BottomBracket_Depth)          10.0                
        set ::bikeGeometry::Geometry(BottomBracket_Height)         316.500               
        set ::bikeGeometry::Geometry(ChainStay_Length)             420.00                   
        set ::bikeGeometry::Geometry(FrontRim_Diameter)            559                  
        set ::bikeGeometry::Geometry(FrontTyre_Height)             47                   
        set ::bikeGeometry::Geometry(FrontWheel_Radius)            326.5                  
        set ::bikeGeometry::Geometry(FrontWheel_x)                 571.498                       
        set ::bikeGeometry::Geometry(FrontWheel_xy)                571.586                      
        set ::bikeGeometry::Geometry(HandleBar_Distance)           474.00                 
        set ::bikeGeometry::Geometry(HandleBar_Height)             642.00                   
        set ::bikeGeometry::Geometry(HeadTube_Angle)               75.000                     
        set ::bikeGeometry::Geometry(Inseam_Length)                850.00                      
        set ::bikeGeometry::Geometry(Reach_Length)                 381.840                       
        set ::bikeGeometry::Geometry(RearRim_Diameter)             559                   
        set ::bikeGeometry::Geometry(RearTyre_Height)              47.00                    
        set ::bikeGeometry::Geometry(RearWheel_Radius)             326.5                   
        set ::bikeGeometry::Geometry(RearWheel_x)                  419.881                        
        set ::bikeGeometry::Geometry(SaddleNose_BB_x)              -103.000                    
        set ::bikeGeometry::Geometry(SaddleNose_HB)                371.000                      
        set ::bikeGeometry::Geometry(Saddle_BB)                    714.098                          
        set ::bikeGeometry::Geometry(Saddle_Distance)              55.000                    
        set ::bikeGeometry::Geometry(Saddle_HB_x)                  529.000                        
        set ::bikeGeometry::Geometry(Saddle_HB_y)                  71.300                        
        set ::bikeGeometry::Geometry(Saddle_Height)                713.30                      
        set ::bikeGeometry::Geometry(Saddle_Offset_BB_ST)          33.758                
        set ::bikeGeometry::Geometry(SeatTube_LengthClassic)       540.272             
        set ::bikeGeometry::Geometry(SeatTube_LengthVirtual)       563.895             
        set ::bikeGeometry::Geometry(Stack_Height)                 563.265                       
        set ::bikeGeometry::Geometry(Stem_Angle)                   -6.00                         
        set ::bikeGeometry::Geometry(Stem_Length)                  110.00                        
        set ::bikeGeometry::Geometry(TopTube_LengthClassic)        413.704              
        set ::bikeGeometry::Geometry(TopTube_LengthVirtual)        408.498              
        set ::bikeGeometry::Geometry(TopTube_Angle)                10.0                      
        set ::bikeGeometry::Geometry(SeatTube_Angle)               87.290                     
        set ::bikeGeometry::Geometry(Fork_Height)                  465.0                        
        set ::bikeGeometry::Geometry(Fork_Rake)                    40.0                          
        set ::bikeGeometry::Geometry(HeadTube_Length)              105.0                    
        set ::bikeGeometry::Geometry(HeadTube_Summary)             118.5                   
        set ::bikeGeometry::Geometry(HeadSet_Bottom)               13.50                     
            #
        set ::bikeGeometry::Geometry(BottomBracket_Angle_ChainStay)        86.0741      
        set ::bikeGeometry::Geometry(BottomBracket_Angle_DownTube)         40.7899       
        set ::bikeGeometry::Geometry(HeadLug_Angle_Bottom)                 53.0803               
            #
        set ::bikeGeometry::Geometry(HeadLug_Angle_Top)            85.0000                  
        set ::bikeGeometry::Geometry(HeadTube_Virtual)             118.500                   
        set ::bikeGeometry::Geometry(HeadTube_CenterTopTube)       24.429             
        set ::bikeGeometry::Geometry(HeadTube_CenterDownTube)      46.415            
            #
        set ::bikeGeometry::HandleBar(PivotAngle)                  0.00                        
        set ::bikeGeometry::HeadSet(Diameter)                      45.00                            
        set ::bikeGeometry::HeadSet(Height_Bottom)                 13.50                       
        set ::bikeGeometry::HeadSet(Height_Top)                    15.50                          
            #
        set ::bikeGeometry::HeadTube(Diameter)                     36.00                           
        set ::bikeGeometry::HeadTube(Length)                       105.0                             
        set ::bikeGeometry::HeadTube(DiameterTaperedTop)           46.0                 
        set ::bikeGeometry::HeadTube(DiameterTaperedBase)          56.0                
        set ::bikeGeometry::HeadTube(HeightTaperedBase)            15.0                  
        set ::bikeGeometry::HeadTube(LengthTapered)                70.0                      
            #
        set ::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        70.00              
        set ::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    1.00          
        set ::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         69.00               
        set ::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     1.00           
        set ::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 60.00                       
        set ::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             1.00                   
        set ::bikeGeometry::Lugs(HeadLug_Top_Angle)                    80.00                          
        set ::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                1.00                      
        set ::bikeGeometry::Lugs(RearDropOut_Angle)                    55.00                          
        set ::bikeGeometry::Lugs(RearDropOut_Tolerance)                1.00                      
        set ::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               55.00                     
        set ::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           1.00                 
        set ::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                81.00                      
        set ::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            1.00                  
            #
        set ::bikeGeometry::RearBrake(LeverLength)                     45.00                           
        set ::bikeGeometry::RearBrake(Offset)                          20.00                                
        set ::bikeGeometry::RearCarrier(x)                             15.00                                   
        set ::bikeGeometry::RearCarrier(y)                             30.00                                   
        set ::bikeGeometry::RearDerailleur(Pulley_teeth)               11                     
        set ::bikeGeometry::RearDerailleur(Pulley_x)                   -8.00                         
        set ::bikeGeometry::RearDerailleur(Pulley_y)                   -79.00                         
            #
        set ::bikeGeometry::RearDropout(Derailleur_x)                  6.00                        
        set ::bikeGeometry::RearDropout(Derailleur_y)                  25.00                        
        set ::bikeGeometry::RearDropout(OffsetCS)                      33.00                            
        set ::bikeGeometry::RearDropout(OffsetCSPerp)                  1                        
        set ::bikeGeometry::RearDropout(OffsetCS_TopView)              5.00                    
        set ::bikeGeometry::RearDropout(OffsetSS)                      35.00                            
        set ::bikeGeometry::RearDropout(OffsetSSPerp)                  -7.10                        
        set ::bikeGeometry::RearDropout(RotationOffset)                0.00                      
            #
        set ::bikeGeometry::RearFender(Height)                         15.00                               
        set ::bikeGeometry::RearFender(OffsetAngle)                    150.00                          
        set ::bikeGeometry::RearFender(Radius)                         331.5                               
        set ::bikeGeometry::RearMockup(CassetteClearance)              3.00                    
        set ::bikeGeometry::RearMockup(ChainWheelClearance)            5.00                  
        set ::bikeGeometry::RearMockup(CrankClearance)                 5.00                       
        set ::bikeGeometry::RearMockup(DiscClearance)                  5.00                        
        set ::bikeGeometry::RearMockup(DiscDiameter)                   160.00                         
        set ::bikeGeometry::RearMockup(DiscOffset)                     15.30                           
        set ::bikeGeometry::RearMockup(DiscWidth)                      2.00                            
        set ::bikeGeometry::RearMockup(TyreClearance)                  5.00                        
            #
        set ::bikeGeometry::RearWheel(FirstSprocket)                   15                         
        set ::bikeGeometry::RearWheel(HubWidth)                        135.00                              
        set ::bikeGeometry::RearWheel(RimHeight)                       25.00                             
        set ::bikeGeometry::RearWheel(TyreShoulder)                    16.5                          
        set ::bikeGeometry::RearWheel(TyreWidth)                       45.00                             
        set ::bikeGeometry::RearWheel(TyreWidthRadius)                 310.00                       
            #
        set ::bikeGeometry::Reference(HandleBar_Distance)              543.69                    
        set ::bikeGeometry::Reference(HandleBar_Height)                905.00                      
        set ::bikeGeometry::Reference(SaddleNose_Distance)             62.69                   
        set ::bikeGeometry::Reference(SaddleNose_HB)                   547.5617007242198                         
        set ::bikeGeometry::Reference(SaddleNose_HB_y)                 65.0                       
        set ::bikeGeometry::Reference(SaddleNose_Height)               970.00                     
            #
        set ::bikeGeometry::Saddle(Height)                             40.00                                   
        set ::bikeGeometry::Saddle(NoseLength)                         153.00                               
        set ::bikeGeometry::Saddle(Offset_x)                           5.00                                 
            #
        set ::bikeGeometry::SeatPost(Diameter)                         27.20                               
        set ::bikeGeometry::SeatPost(PivotOffset)                      40.00                            
        set ::bikeGeometry::SeatPost(Setback)                          25.00                                
        set ::bikeGeometry::SeatStay(DiameterCS)                       11.00                             
        set ::bikeGeometry::SeatStay(DiameterST)                       16.00                             
        set ::bikeGeometry::SeatStay(OffsetTT)                         -30                               
        set ::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            28.60                  
        set ::bikeGeometry::SeatStay(TaperLength)                      300.00                            
            #
        set ::bikeGeometry::SeatTube(DiameterBB)                       31.80                             
        set ::bikeGeometry::SeatTube(DiameterTT)                       28.60                             
        set ::bikeGeometry::SeatTube(Extension)                        20.00                              
        set ::bikeGeometry::SeatTube(OffsetBB)                         0.00                               
        set ::bikeGeometry::SeatTube(TaperLength)                      300.00                            
            #
        set ::bikeGeometry::TopTube(DiameterHT)                        28.60                              
        set ::bikeGeometry::TopTube(DiameterST)                        28.60                              
        set ::bikeGeometry::TopTube(OffsetHT)                          8.50                                
        set ::bikeGeometry::TopTube(PivotPosition)                     80.00                           
        set ::bikeGeometry::TopTube(TaperLength)                       300.00                             
            #

            
    }

    proc bikeGeometry::reportInitValues {} {
        
        set projDict [bikeGeometry::get_projectDICT]
        puts $projDict
        
        puts "\n"
        
        project::pdict $projDict  4
        
        return
        
        
        
        
        puts "    #"
        puts "    #"
        puts "    #"
        puts "set ::bikeGeometry::Component(CrankSet)                    $::bikeGeometry::Component(CrankSet)                     "      
        puts "set ::bikeGeometry::Component(ForkCrown)                   $::bikeGeometry::Component(ForkCrown)                    "      
        puts "set ::bikeGeometry::Component(ForkDropout)                 $::bikeGeometry::Component(ForkDropout)                  "      
        puts "set ::bikeGeometry::Component(ForkSupplier)                $::bikeGeometry::Component(ForkSupplier)                 "      
        puts "set ::bikeGeometry::Component(FrontBrake)                  $::bikeGeometry::Component(FrontBrake)                   "      
        puts "set ::bikeGeometry::Component(FrontCarrier)                $::bikeGeometry::Component(FrontCarrier)                 "      
        puts "set ::bikeGeometry::Component(FrontDerailleur)             $::bikeGeometry::Component(FrontDerailleur)              "      
        puts "set ::bikeGeometry::Component(HandleBar)                   $::bikeGeometry::Component(HandleBar)                    "      
        puts "set ::bikeGeometry::Component(Label)                       $::bikeGeometry::Component(Label)                        "      
        puts "set ::bikeGeometry::Component(RearBrake)                   $::bikeGeometry::Component(RearBrake)                    "      
        puts "set ::bikeGeometry::Component(RearCarrier)                 $::bikeGeometry::Component(RearCarrier)                  "      
        puts "set ::bikeGeometry::Component(RearDerailleur)              $::bikeGeometry::Component(RearDerailleur)               "      
        puts "set ::bikeGeometry::Component(RearDropout)                 $::bikeGeometry::Component(RearDropout)                  "      
        puts "set ::bikeGeometry::Component(RearHub)                     $::bikeGeometry::Component(RearHub)                      "
        puts "set ::bikeGeometry::Component(Saddle)                      $::bikeGeometry::Component(Saddle)                       "      
        puts "set ::bikeGeometry::Component(BottleCage_DownTube)         $::bikeGeometry::Component(BottleCage_DownTube)          "      
        puts "set ::bikeGeometry::Component(BottleCage_DownTube_Lower)   $::bikeGeometry::Component(BottleCage_DownTube_Lower)    "      
        puts "set ::bikeGeometry::Component(BottleCage_SeatTube)         $::bikeGeometry::Component(BottleCage_SeatTube)          "      
        puts "    #"
        puts "set ::bikeGeometry::Config(BottleCage_DownTube)            $::bikeGeometry::Config(BottleCage_DownTube)              "     
        puts "set ::bikeGeometry::Config(BottleCage_DownTube_Lower)      $::bikeGeometry::Config(BottleCage_DownTube_Lower)        "     
        puts "set ::bikeGeometry::Config(BottleCage_SeatTube)            $::bikeGeometry::Config(BottleCage_SeatTube)              "     
        puts "set ::bikeGeometry::Config(ChainStay)                      $::bikeGeometry::Config(ChainStay)                        "     
        puts "set ::bikeGeometry::Config(CrankSet_SpyderArmCount)        $::bikeGeometry::Config(CrankSet_SpyderArmCount)          "
        puts "set ::bikeGeometry::Config(Fork)                           $::bikeGeometry::Config(Fork)                             "     
        puts "set ::bikeGeometry::Config(ForkBlade)                      $::bikeGeometry::Config(ForkBlade)                        "     
        puts "set ::bikeGeometry::Config(ForkDropout)                    $::bikeGeometry::Config(ForkDropout)                      "     
        puts "set ::bikeGeometry::Config(FrontBrake)                     $::bikeGeometry::Config(FrontBrake)                       "     
        puts "set ::bikeGeometry::Config(FrontFender)                    $::bikeGeometry::Config(FrontFender)                      "     
        puts "set ::bikeGeometry::Config(HeadTube)                       $::bikeGeometry::Config(HeadTube)                         "
        puts "set ::bikeGeometry::Config(RearBrake)                      $::bikeGeometry::Config(RearBrake)                        "     
        puts "set ::bikeGeometry::Config(RearDropout)                    $::bikeGeometry::Config(RearDropout)                      "     
        puts "set ::bikeGeometry::Config(RearDropoutOrient)              $::bikeGeometry::Config(RearDropoutOrient)                "     
        puts "set ::bikeGeometry::Config(RearFender)                     $::bikeGeometry::Config(RearFender)                       "     
        puts "set ::bikeGeometry::Config(Color_FrameTubes)               $::bikeGeometry::Config(Color_FrameTubes)                 "
        puts "set ::bikeGeometry::Config(Color_Fork)                     $::bikeGeometry::Config(Color_Fork)                       "
        puts "set ::bikeGeometry::Config(Color_Label)                    $::bikeGeometry::Config(Color_Label)                      "
        puts "    #"
        puts "set ::bikeGeometry::ListValue(CrankSetChainRings)          $::bikeGeometry::ListValue(CrankSetChainRings)            "     
        puts "    #"
        puts "set ::bikeGeometry::BottleCage(DownTube)                   $::bikeGeometry::BottleCage(DownTube)                     "     
        puts "set ::bikeGeometry::BottleCage(DownTube_Lower)             $::bikeGeometry::BottleCage(DownTube_Lower)               "     
        puts "set ::bikeGeometry::BottleCage(SeatTube)                   $::bikeGeometry::BottleCage(SeatTube)                     "     
        puts "set ::bikeGeometry::BottomBracket(InsideDiameter)          $::bikeGeometry::BottomBracket(InsideDiameter)            "     
        puts "set ::bikeGeometry::BottomBracket(OffsetCS_TopView)        $::bikeGeometry::BottomBracket(OffsetCS_TopView)          "     
        puts "set ::bikeGeometry::BottomBracket(OutsideDiameter)         $::bikeGeometry::BottomBracket(OutsideDiameter)           "     
        puts "set ::bikeGeometry::BottomBracket(Width)                   $::bikeGeometry::BottomBracket(Width)                     "     
        puts "    #"
        puts "set ::bikeGeometry::ChainStay(DiameterSS)                  $::bikeGeometry::ChainStay(DiameterSS)                    "     
        puts "set ::bikeGeometry::ChainStay(Height)                      $::bikeGeometry::ChainStay(Height)                        "     
        puts "set ::bikeGeometry::ChainStay(HeightBB)                    $::bikeGeometry::ChainStay(HeightBB)                      "     
        puts "set ::bikeGeometry::ChainStay(TaperLength)                 $::bikeGeometry::ChainStay(TaperLength)                   "     
        puts "set ::bikeGeometry::ChainStay(WidthBB)                     $::bikeGeometry::ChainStay(WidthBB)                       "     
        puts "set ::bikeGeometry::ChainStay(completeLength)              $::bikeGeometry::ChainStay(completeLength)                "     
        puts "set ::bikeGeometry::ChainStay(cuttingLeft)                 $::bikeGeometry::ChainStay(cuttingLeft)                   "     
        puts "set ::bikeGeometry::ChainStay(cuttingLength)               $::bikeGeometry::ChainStay(cuttingLength)                 "     
        puts "set ::bikeGeometry::ChainStay(profile_x01)                 $::bikeGeometry::ChainStay(profile_x01)                   "     
        puts "set ::bikeGeometry::ChainStay(profile_x02)                 $::bikeGeometry::ChainStay(profile_x02)                   "     
        puts "set ::bikeGeometry::ChainStay(profile_x03)                 $::bikeGeometry::ChainStay(profile_x03)                   "     
        puts "set ::bikeGeometry::ChainStay(profile_y00)                 $::bikeGeometry::ChainStay(profile_y00)                   "     
        puts "set ::bikeGeometry::ChainStay(profile_y01)                 $::bikeGeometry::ChainStay(profile_y01)                   "     
        puts "set ::bikeGeometry::ChainStay(profile_y02)                 $::bikeGeometry::ChainStay(profile_y02)                   "     
        puts "set ::bikeGeometry::ChainStay(segmentAngle_01)             $::bikeGeometry::ChainStay(segmentAngle_01)               "     
        puts "set ::bikeGeometry::ChainStay(segmentAngle_02)             $::bikeGeometry::ChainStay(segmentAngle_02)               "     
        puts "set ::bikeGeometry::ChainStay(segmentAngle_03)             $::bikeGeometry::ChainStay(segmentAngle_03)               "     
        puts "set ::bikeGeometry::ChainStay(segmentAngle_04)             $::bikeGeometry::ChainStay(segmentAngle_04)               "     
        puts "set ::bikeGeometry::ChainStay(segmentLength_01)            $::bikeGeometry::ChainStay(segmentLength_01)              "     
        puts "set ::bikeGeometry::ChainStay(segmentLength_02)            $::bikeGeometry::ChainStay(segmentLength_02)              "     
        puts "set ::bikeGeometry::ChainStay(segmentLength_03)            $::bikeGeometry::ChainStay(segmentLength_03)              "     
        puts "set ::bikeGeometry::ChainStay(segmentLength_04)            $::bikeGeometry::ChainStay(segmentLength_04)              "     
        puts "set ::bikeGeometry::ChainStay(segmentRadius_01)            $::bikeGeometry::ChainStay(segmentRadius_01)              "     
        puts "set ::bikeGeometry::ChainStay(segmentRadius_02)            $::bikeGeometry::ChainStay(segmentRadius_02)              "     
        puts "set ::bikeGeometry::ChainStay(segmentRadius_03)            $::bikeGeometry::ChainStay(segmentRadius_03)              "     
        puts "set ::bikeGeometry::ChainStay(segmentRadius_04)            $::bikeGeometry::ChainStay(segmentRadius_04)              "     
        puts "    #"
        puts "set ::bikeGeometry::CrankSet(ArmWidth)                     $::bikeGeometry::CrankSet(ArmWidth)                       "     
        puts "set ::bikeGeometry::CrankSet(ChainLine)                    $::bikeGeometry::CrankSet(ChainLine)                      "     
        puts "set ::bikeGeometry::CrankSet(ChainRingOffset)              $::bikeGeometry::CrankSet(ChainRingOffset)                "     
        puts "set ::bikeGeometry::CrankSet(Length)                       $::bikeGeometry::CrankSet(Length)                         "     
        puts "set ::bikeGeometry::CrankSet(PedalEye)                     $::bikeGeometry::CrankSet(PedalEye)                       "     
        puts "set ::bikeGeometry::CrankSet(Q-Factor)                     $::bikeGeometry::CrankSet(Q-Factor)                       "     
        puts "    #"
        puts "set ::bikeGeometry::DownTube(DiameterBB)                   $::bikeGeometry::DownTube(DiameterBB)                         " 
        puts "set ::bikeGeometry::DownTube(DiameterHT)                   $::bikeGeometry::DownTube(DiameterHT)                         " 
        puts "set ::bikeGeometry::DownTube(OffsetBB)                     $::bikeGeometry::DownTube(OffsetBB)                           " 
        puts "set ::bikeGeometry::DownTube(OffsetHT)                     $::bikeGeometry::DownTube(OffsetHT)                           " 
        puts "set ::bikeGeometry::DownTube(TaperLength)                  $::bikeGeometry::DownTube(TaperLength)                        " 
        puts "    #"
        puts "set ::bikeGeometry::Fork(BladeBendRadius)                  $::bikeGeometry::Fork(BladeBendRadius)                        " 
        puts "set ::bikeGeometry::Fork(BladeDiameterDO)                  $::bikeGeometry::Fork(BladeDiameterDO)                        " 
        puts "set ::bikeGeometry::Fork(BladeEndLength)                   $::bikeGeometry::Fork(BladeEndLength)                         " 
        puts "set ::bikeGeometry::Fork(BladeOffsetCrown)                 $::bikeGeometry::Fork(BladeOffsetCrown)                       " 
        puts "set ::bikeGeometry::Fork(BladeOffsetCrownPerp)             $::bikeGeometry::Fork(BladeOffsetCrownPerp)                   " 
        puts "set ::bikeGeometry::Fork(BladeOffsetDO)                    $::bikeGeometry::Fork(BladeOffsetDO)                          " 
        puts "set ::bikeGeometry::Fork(BladeOffsetDOPerp)                $::bikeGeometry::Fork(BladeOffsetDOPerp)                      " 
        puts "set ::bikeGeometry::Fork(BladeTaperLength)                 $::bikeGeometry::Fork(BladeTaperLength)                       " 
        puts "set ::bikeGeometry::Fork(BladeWidth)                       $::bikeGeometry::Fork(BladeWidth)                             " 
        puts "set ::bikeGeometry::Fork(CrownAngleBrake)                  $::bikeGeometry::Fork(CrownAngleBrake)                        " 
        puts "set ::bikeGeometry::Fork(CrownOffsetBrake)                 $::bikeGeometry::Fork(CrownOffsetBrake)                       " 
        puts "set ::bikeGeometry::Fork(BladeBrakeOffset)                 $::bikeGeometry::Fork(BladeBrakeOffset)                       " 
        puts "set ::bikeGeometry::Fork(Rake)                             $::bikeGeometry::Fork(Rake)                                       "
        puts "    #"
        puts "set ::bikeGeometry::FrontBrake(LeverLength)                $::bikeGeometry::FrontBrake(LeverLength)                      " 
        puts "set ::bikeGeometry::FrontBrake(Offset)                     $::bikeGeometry::FrontBrake(Offset)                           " 
        puts "set ::bikeGeometry::FrontCarrier(x)                        $::bikeGeometry::FrontCarrier(x)                              " 
        puts "set ::bikeGeometry::FrontCarrier(y)                        $::bikeGeometry::FrontCarrier(y)                              " 
        puts "set ::bikeGeometry::FrontDerailleur(Distance)              $::bikeGeometry::FrontDerailleur(Distance)                    " 
        puts "set ::bikeGeometry::FrontDerailleur(Offset)                $::bikeGeometry::FrontDerailleur(Offset)                      " 
        puts "set ::bikeGeometry::FrontFender(Height)                    $::bikeGeometry::FrontFender(Height)                          " 
        puts "set ::bikeGeometry::FrontFender(OffsetAngle)               $::bikeGeometry::FrontFender(OffsetAngle)                     " 
        puts "set ::bikeGeometry::FrontFender(OffsetAngleFront)          $::bikeGeometry::FrontFender(OffsetAngleFront)                " 
        puts "set ::bikeGeometry::FrontFender(Radius)                    $::bikeGeometry::FrontFender(Radius)                          " 
        puts "set ::bikeGeometry::FrontWheel(RimHeight)                  $::bikeGeometry::FrontWheel(RimHeight)                        " 
        puts "    #"
        puts "set ::bikeGeometry::Geometry(BottomBracket_Depth)          $::bikeGeometry::Geometry(BottomBracket_Depth)                " 
        puts "set ::bikeGeometry::Geometry(BottomBracket_Height)         $::bikeGeometry::Geometry(BottomBracket_Height)               " 
        puts "set ::bikeGeometry::Geometry(ChainStay_Length)             $::bikeGeometry::Geometry(ChainStay_Length)                   " 
        puts "set ::bikeGeometry::Geometry(FrontRim_Diameter)            $::bikeGeometry::Geometry(FrontRim_Diameter)                  " 
        puts "set ::bikeGeometry::Geometry(FrontTyre_Height)             $::bikeGeometry::Geometry(FrontTyre_Height)                   " 
        puts "set ::bikeGeometry::Geometry(FrontWheel_Radius)            $::bikeGeometry::Geometry(FrontWheel_Radius)                  " 
        puts "set ::bikeGeometry::Geometry(FrontWheel_x)                 $::bikeGeometry::Geometry(FrontWheel_x)                       " 
        puts "set ::bikeGeometry::Geometry(FrontWheel_xy)                $::bikeGeometry::Geometry(FrontWheel_xy)                      " 
        puts "set ::bikeGeometry::Geometry(HandleBar_Distance)           $::bikeGeometry::Geometry(HandleBar_Distance)                 " 
        puts "set ::bikeGeometry::Geometry(HandleBar_Height)             $::bikeGeometry::Geometry(HandleBar_Height)                   " 
        puts "set ::bikeGeometry::Geometry(HeadTube_Angle)               $::bikeGeometry::Geometry(HeadTube_Angle)                     " 
        puts "set ::bikeGeometry::Geometry(Inseam_Length)                $::bikeGeometry::Geometry(Inseam_Length)                      " 
        puts "set ::bikeGeometry::Geometry(Reach_Length)                 $::bikeGeometry::Geometry(Reach_Length)                       " 
        puts "set ::bikeGeometry::Geometry(RearRim_Diameter)             $::bikeGeometry::Geometry(RearRim_Diameter)                   " 
        puts "set ::bikeGeometry::Geometry(RearTyre_Height)              $::bikeGeometry::Geometry(RearTyre_Height)                    " 
        puts "set ::bikeGeometry::Geometry(RearWheel_Radius)             $::bikeGeometry::Geometry(RearWheel_Radius)                   " 
        puts "set ::bikeGeometry::Geometry(RearWheel_x)                  $::bikeGeometry::Geometry(RearWheel_x)                        " 
        puts "set ::bikeGeometry::Geometry(SaddleNose_BB_x)              $::bikeGeometry::Geometry(SaddleNose_BB_x)                    " 
        puts "set ::bikeGeometry::Geometry(SaddleNose_HB)                $::bikeGeometry::Geometry(SaddleNose_HB)                      " 
        puts "set ::bikeGeometry::Geometry(Saddle_BB)                    $::bikeGeometry::Geometry(Saddle_BB)                          " 
        puts "set ::bikeGeometry::Geometry(Saddle_Distance)              $::bikeGeometry::Geometry(Saddle_Distance)                    " 
        puts "set ::bikeGeometry::Geometry(Saddle_HB_x)                  $::bikeGeometry::Geometry(Saddle_HB_x)                        " 
        puts "set ::bikeGeometry::Geometry(Saddle_HB_y)                  $::bikeGeometry::Geometry(Saddle_HB_y)                        " 
        puts "set ::bikeGeometry::Geometry(Saddle_Height)                $::bikeGeometry::Geometry(Saddle_Height)                      " 
        puts "set ::bikeGeometry::Geometry(Saddle_Offset_BB_ST)          $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)                " 
        puts "set ::bikeGeometry::Geometry(SeatTube_LengthClassic)       $::bikeGeometry::Geometry(SeatTube_LengthClassic)             " 
        puts "set ::bikeGeometry::Geometry(SeatTube_LengthVirtual)       $::bikeGeometry::Geometry(SeatTube_LengthVirtual)             " 
        puts "set ::bikeGeometry::Geometry(Stack_Height)                 $::bikeGeometry::Geometry(Stack_Height)                       " 
        puts "set ::bikeGeometry::Geometry(Stem_Angle)                   $::bikeGeometry::Geometry(Stem_Angle)                         " 
        puts "set ::bikeGeometry::Geometry(Stem_Length)                  $::bikeGeometry::Geometry(Stem_Length)                        " 
        puts "set ::bikeGeometry::Geometry(TopTube_LengthClassic)        $::bikeGeometry::Geometry(TopTube_LengthClassic)              "
        puts "set ::bikeGeometry::Geometry(TopTube_LengthVirtual)        $::bikeGeometry::Geometry(TopTube_LengthVirtual)              " 
        puts "set ::bikeGeometry::Geometry(TopTube_Angle)                $::bikeGeometry::Geometry(TopTube_Angle)                      " 
        puts "set ::bikeGeometry::Geometry(SeatTube_Angle)               $::bikeGeometry::Geometry(SeatTube_Angle)                     " 
        puts "set ::bikeGeometry::Geometry(Fork_Height)                  $::bikeGeometry::Geometry(Fork_Height)                        " 
        puts "set ::bikeGeometry::Geometry(Fork_Rake)                    $::bikeGeometry::Geometry(Fork_Rake)                          " 
        puts "set ::bikeGeometry::Geometry(HeadTube_Length)              $::bikeGeometry::Geometry(HeadTube_Length)                    " 
        puts "set ::bikeGeometry::Geometry(HeadTube_Summary)             $::bikeGeometry::Geometry(HeadTube_Summary)                   " 
        puts "set ::bikeGeometry::Geometry(HeadSet_Bottom)               $::bikeGeometry::Geometry(HeadSet_Bottom)                     "
        puts "    #"
        puts "set ::bikeGeometry::Geometry(BottomBracket_Angle_ChainStay)        $::bikeGeometry::Geometry(BottomBracket_Angle_ChainStay)      " 
        puts "set ::bikeGeometry::Geometry(BottomBracket_Angle_DownTube)         $::bikeGeometry::Geometry(BottomBracket_Angle_DownTube)       " 
        puts "set ::bikeGeometry::Geometry(HeadLug_Angle_Bottom)                 $::bikeGeometry::Geometry(HeadLug_Angle_Bottom)               " 
        puts "    #"
        puts "set ::bikeGeometry::Geometry(HeadLug_Angle_Top)            $::bikeGeometry::Geometry(HeadLug_Angle_Top)                  " 
        puts "set ::bikeGeometry::Geometry(HeadTube_Virtual)             $::bikeGeometry::Geometry(HeadTube_Virtual)                   " 
        puts "set ::bikeGeometry::Geometry(HeadTube_CenterTopTube)       $::bikeGeometry::Geometry(HeadTube_CenterTopTube)             " 
        puts "set ::bikeGeometry::Geometry(HeadTube_CenterDownTube)      $::bikeGeometry::Geometry(HeadTube_CenterDownTube)            " 
        puts "    #"
        puts "set ::bikeGeometry::HandleBar(PivotAngle)                  $::bikeGeometry::HandleBar(PivotAngle)                        " 
        puts "set ::bikeGeometry::HeadSet(Diameter)                      $::bikeGeometry::HeadSet(Diameter)                            " 
        puts "set ::bikeGeometry::HeadSet(Height_Bottom)                 $::bikeGeometry::HeadSet(Height_Bottom)                       " 
        puts "set ::bikeGeometry::HeadSet(Height_Top)                    $::bikeGeometry::HeadSet(Height_Top)                          " 
        puts "    #"
        puts "set ::bikeGeometry::HeadTube(Diameter)                     $::bikeGeometry::HeadTube(Diameter)                           " 
        puts "set ::bikeGeometry::HeadTube(Length)                       $::bikeGeometry::HeadTube(Length)                             " 
        puts "set ::bikeGeometry::HeadTube(DiameterTaperedTop)           $::bikeGeometry::HeadTube(DiameterTaperedTop)                 "
        puts "set ::bikeGeometry::HeadTube(DiameterTaperedBase)          $::bikeGeometry::HeadTube(DiameterTaperedBase)                "
        puts "set ::bikeGeometry::HeadTube(HeightTaperedBase)            $::bikeGeometry::HeadTube(HeightTaperedBase)                  "
        puts "set ::bikeGeometry::HeadTube(LengthTapered)                $::bikeGeometry::HeadTube(LengthTapered)                      "
        
        puts "    #"
        puts "set ::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)              "
        puts "set ::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)          "
        puts "set ::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)               "
        puts "set ::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)           "
        puts "set ::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                       "
        puts "set ::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)                   "
        puts "set ::bikeGeometry::Lugs(HeadLug_Top_Angle)                    $::bikeGeometry::Lugs(HeadLug_Top_Angle)                          "
        puts "set ::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                      "
        puts "set ::bikeGeometry::Lugs(RearDropOut_Angle)                    $::bikeGeometry::Lugs(RearDropOut_Angle)                          "
        puts "set ::bikeGeometry::Lugs(RearDropOut_Tolerance)                $::bikeGeometry::Lugs(RearDropOut_Tolerance)                      "
        puts "set ::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)                     "
        puts "set ::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)                 "
        puts "set ::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                      "
        puts "set ::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)                  "
        puts "    #"
        puts "set ::bikeGeometry::RearBrake(LeverLength)                     $::bikeGeometry::RearBrake(LeverLength)                           "
        puts "set ::bikeGeometry::RearBrake(Offset)                          $::bikeGeometry::RearBrake(Offset)                                "
        puts "set ::bikeGeometry::RearCarrier(x)                             $::bikeGeometry::RearCarrier(x)                                   "
        puts "set ::bikeGeometry::RearCarrier(y)                             $::bikeGeometry::RearCarrier(y)                                   "
        puts "set ::bikeGeometry::RearDerailleur(Pulley_teeth)               $::bikeGeometry::RearDerailleur(Pulley_teeth)                     "
        puts "set ::bikeGeometry::RearDerailleur(Pulley_x)                   $::bikeGeometry::RearDerailleur(Pulley_x)                         "
        puts "set ::bikeGeometry::RearDerailleur(Pulley_y)                   $::bikeGeometry::RearDerailleur(Pulley_y)                         "
        puts "    #"
        puts "set ::bikeGeometry::RearDropout(Derailleur_x)                  $::bikeGeometry::RearDropout(Derailleur_x)                        "
        puts "set ::bikeGeometry::RearDropout(Derailleur_y)                  $::bikeGeometry::RearDropout(Derailleur_y)                        "
        puts "set ::bikeGeometry::RearDropout(OffsetCS)                      $::bikeGeometry::RearDropout(OffsetCS)                            "
        puts "set ::bikeGeometry::RearDropout(OffsetCSPerp)                  $::bikeGeometry::RearDropout(OffsetCSPerp)                        "
        puts "set ::bikeGeometry::RearDropout(OffsetCS_TopView)              $::bikeGeometry::RearDropout(OffsetCS_TopView)                    "
        puts "set ::bikeGeometry::RearDropout(OffsetSS)                      $::bikeGeometry::RearDropout(OffsetSS)                            "
        puts "set ::bikeGeometry::RearDropout(OffsetSSPerp)                  $::bikeGeometry::RearDropout(OffsetSSPerp)                        "
        puts "set ::bikeGeometry::RearDropout(RotationOffset)                $::bikeGeometry::RearDropout(RotationOffset)                      "
        puts "    #"
        puts "set ::bikeGeometry::RearFender(Height)                         $::bikeGeometry::RearFender(Height)                               "
        puts "set ::bikeGeometry::RearFender(OffsetAngle)                    $::bikeGeometry::RearFender(OffsetAngle)                          "
        puts "set ::bikeGeometry::RearFender(Radius)                         $::bikeGeometry::RearFender(Radius)                               "
        puts "set ::bikeGeometry::RearMockup(CassetteClearance)              $::bikeGeometry::RearMockup(CassetteClearance)                    "
        puts "set ::bikeGeometry::RearMockup(ChainWheelClearance)            $::bikeGeometry::RearMockup(ChainWheelClearance)                  "
        puts "set ::bikeGeometry::RearMockup(CrankClearance)                 $::bikeGeometry::RearMockup(CrankClearance)                       "
        puts "set ::bikeGeometry::RearMockup(DiscClearance)                  $::bikeGeometry::RearMockup(DiscClearance)                        "
        puts "set ::bikeGeometry::RearMockup(DiscDiameter)                   $::bikeGeometry::RearMockup(DiscDiameter)                         "
        puts "set ::bikeGeometry::RearMockup(DiscOffset)                     $::bikeGeometry::RearMockup(DiscOffset)                           "
        puts "set ::bikeGeometry::RearMockup(DiscWidth)                      $::bikeGeometry::RearMockup(DiscWidth)                            "
        puts "set ::bikeGeometry::RearMockup(TyreClearance)                  $::bikeGeometry::RearMockup(TyreClearance)                        "
        puts "    #"
        puts "set ::bikeGeometry::RearWheel(FirstSprocket)                   $::bikeGeometry::RearWheel(FirstSprocket)                         "
        puts "set ::bikeGeometry::RearWheel(HubWidth)                        $::bikeGeometry::RearWheel(HubWidth)                              "
        puts "set ::bikeGeometry::RearWheel(RimHeight)                       $::bikeGeometry::RearWheel(RimHeight)                             "
        puts "set ::bikeGeometry::RearWheel(TyreShoulder)                    $::bikeGeometry::RearWheel(TyreShoulder)                          "
        puts "set ::bikeGeometry::RearWheel(TyreWidth)                       $::bikeGeometry::RearWheel(TyreWidth)                             "
        puts "set ::bikeGeometry::RearWheel(TyreWidthRadius)                 $::bikeGeometry::RearWheel(TyreWidthRadius)                       "
        puts "    #"
        puts "set ::bikeGeometry::Reference(HandleBar_Distance)              $::bikeGeometry::Reference(HandleBar_Distance)                    "
        puts "set ::bikeGeometry::Reference(HandleBar_Height)                $::bikeGeometry::Reference(HandleBar_Height)                      "
        puts "set ::bikeGeometry::Reference(SaddleNose_Distance)             $::bikeGeometry::Reference(SaddleNose_Distance)                   "
        puts "set ::bikeGeometry::Reference(SaddleNose_HB)                   $::bikeGeometry::Reference(SaddleNose_HB)                         "
        puts "set ::bikeGeometry::Reference(SaddleNose_HB_y)                 $::bikeGeometry::Reference(SaddleNose_HB_y)                       "
        puts "set ::bikeGeometry::Reference(SaddleNose_Height)               $::bikeGeometry::Reference(SaddleNose_Height)                     "
        puts "    #"
        puts "set ::bikeGeometry::Saddle(Height)                             $::bikeGeometry::Saddle(Height)                                   "
        puts "set ::bikeGeometry::Saddle(NoseLength)                         $::bikeGeometry::Saddle(NoseLength)                               "
        puts "set ::bikeGeometry::Saddle(Offset_x)                           $::bikeGeometry::Saddle(Offset_x)                                 "
        puts "    #"
        puts "set ::bikeGeometry::SeatPost(Diameter)                         $::bikeGeometry::SeatPost(Diameter)                               "
        puts "set ::bikeGeometry::SeatPost(PivotOffset)                      $::bikeGeometry::SeatPost(PivotOffset)                            "
        puts "set ::bikeGeometry::SeatPost(Setback)                          $::bikeGeometry::SeatPost(Setback)                                "
        puts "set ::bikeGeometry::SeatStay(DiameterCS)                       $::bikeGeometry::SeatStay(DiameterCS)                             "
        puts "set ::bikeGeometry::SeatStay(DiameterST)                       $::bikeGeometry::SeatStay(DiameterST)                             "
        puts "set ::bikeGeometry::SeatStay(OffsetTT)                         $::bikeGeometry::SeatStay(OffsetTT)                               "
        puts "set ::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)                  "
        puts "set ::bikeGeometry::SeatStay(TaperLength)                      $::bikeGeometry::SeatStay(TaperLength)                            "
        puts "    #"
        puts "set ::bikeGeometry::SeatTube(DiameterBB)                       $::bikeGeometry::SeatTube(DiameterBB)                             "
        puts "set ::bikeGeometry::SeatTube(DiameterTT)                       $::bikeGeometry::SeatTube(DiameterTT)                             "
        puts "set ::bikeGeometry::SeatTube(Extension)                        $::bikeGeometry::SeatTube(Extension)                              "
        puts "set ::bikeGeometry::SeatTube(OffsetBB)                         $::bikeGeometry::SeatTube(OffsetBB)                               "
        puts "set ::bikeGeometry::SeatTube(TaperLength)                      $::bikeGeometry::SeatTube(TaperLength)                            "
        puts "    #"
        puts "set ::bikeGeometry::TopTube(DiameterHT)                        $::bikeGeometry::TopTube(DiameterHT)                              "
        puts "set ::bikeGeometry::TopTube(DiameterST)                        $::bikeGeometry::TopTube(DiameterST)                              "
        puts "set ::bikeGeometry::TopTube(OffsetHT)                          $::bikeGeometry::TopTube(OffsetHT)                                "
        puts "set ::bikeGeometry::TopTube(PivotPosition)                     $::bikeGeometry::TopTube(PivotPosition)                           "
        puts "set ::bikeGeometry::TopTube(TaperLength)                       $::bikeGeometry::TopTube(TaperLength)                             "
        puts "    #"

        
    }

