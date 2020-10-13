 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_gui.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
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
 #    namespace:  myGUI::lib_gui
 # ---------------------------------------------------------------------------
 #
 # 
 
 #
 #
 # procedures are referenced by 
 #     myGUI::gui::bind_dimensionEvent_2    $canvasIF    $dimObject  $procName [no full qualified namespace]
 #     myGUI::gui::bind_objectEvent_2       $canvasIF    $tag        $procName [no full qualified namespace]
 #
 
     
        #
        # -- Page - Options -------------------------------
        #
    proc myGUI::view::edit::page_FormatDIN  {x y cvObject} { 
        set cvEdit  [myGUI::view::edit::create_Edit_2   $x $y $cvObject  {} {DIN-Format}]
        myGUI::gui::add_ConfigFormat                    $cvEdit {noHeader}
        myGUI::view::edit::fit_EditContainer            $cvObject
    }
    proc myGUI::view::edit::page_PageScale  {x y cvObject} { 
        set cvEdit  [myGUI::view::edit::create_Edit_2   $x $y $cvObject  {} {Page-Scale}]
        myGUI::gui::add_ConfigScale                     $cvEdit {noHeader}
        myGUI::view::edit::fit_EditContainer            $cvObject
    }  
        #[format {myGUI::gui::notebook_ButtonEvent %s %s} $cv $cv_ButtonContent ]    
        #
        # -- Rendering - Options --------------------------
        #
    proc myGUI::view::edit::option_ForkType {x y canvasIF} { 
        switch -exact [myGUI::model::model_XZ::getConfig Fork] {
            Supplier {group_ForkSupplier_Parameter      $x $y $canvasIF}
            default  {myGUI::view::edit::create_Edit_2    $x $y $canvasIF   list://Config:Fork@SELECT_ForkType  }
        }
    }
    proc myGUI::view::edit::option_ForkType_orphan                  {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:Fork@SELECT_ForkType                           }   ;#  list://Config(Fork@SELECT_ForkType)                             }
    proc myGUI::view::edit::option_ChainStay                        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:ChainStay@SELECT_ChainStay                     }   ;#  list://Rendering(ChainStay@SELECT_ChainStay)                    }
    proc myGUI::view::edit::option_FrontFenderBinary                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:FrontFender@SELECT_Binary_OnOff                }   ;#  list://Rendering(Fender/Front@SELECT_Binary_OnOff)              }    
    proc myGUI::view::edit::option_RearFenderBinary                 {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:RearFender@SELECT_Binary_OnOff                 }   ;#  list://Rendering(Fender/Rear@SELECT_Binary_OnOff)               }     
    proc myGUI::view::edit::option_DownTubeUpperCage                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:BottleCage_DownTube@SELECT_BottleCage          }   ;#  list://Rendering(BottleCage/DownTube@SELECT_BottleCage)         }
    proc myGUI::view::edit::option_DownTubeLowerCage                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:BottleCage_DownTube_Lower@SELECT_BottleCage    }   ;#  list://Rendering(BottleCage/DownTube_Lower@SELECT_BottleCage)   }
    proc myGUI::view::edit::option_RearBrakeType                    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:RearBrake@SELECT_BrakeType                     }  
    proc myGUI::view::edit::option_SeatTubCage                      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:BottleCage_SeatTube@SELECT_BottleCage          }   ;#  list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)         }
    proc myGUI::view::edit::option_Stem                             {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:Stem@SELECT_StemType                           }   ;#  list://Rendering(BottleCage/SeatTube@SELECT_BottleCage)         }                
    
        
        #
        # -- Result - Values --------------------------
        #
    proc myGUI::view::edit::single_Result_BottomBracket_Height      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/BottomBracket_Height    }   ;# Result(Length/BottomBracket/Height)       
    proc myGUI::view::edit::single_Result_HeadTube_DownTubeCenter   {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadTube_CenterDownTube }
    proc myGUI::view::edit::single_Result_HeadTube_TopTubeCenter    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadTube_CenterTopTube  }
    proc myGUI::view::edit::single_Result_FrontWheel_diagonal       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/FrontWheel_xy           }   ;# Result(Length/FrontWheel/diagonal)        
    proc myGUI::view::edit::single_Result_FrontWheel_horizontal     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/FrontWheel_x            }   ;# Result(Length/FrontWheel/horizontal)      
    proc myGUI::view::edit::single_Result_HeadTube_ReachLength      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Reach_Length            }   ;# Result(Length/HeadTube/ReachLength)       
    proc myGUI::view::edit::single_Result_SeatTube_Angle            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/SeatTube_Angle          }   ;# Result(Angle/SeatTube/Direction)          
    proc myGUI::view::edit::single_Result_HeadTube_TopTubeAngle     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadLug_Angle_Top       }   ;# Scalar:Result/Angle_HeadTubeTopTube)      
    proc myGUI::view::edit::single_Result_HeadTube_VirtualLength    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadTube_Virtual        }   ;# Scalar:Result/Angle_HeadTubeTopTube)      
    proc myGUI::view::edit::single_Result_RearWheel_horizontal      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/RearWheel_x             }   ;# Result(Length/RearWheel/horizontal)       
    proc myGUI::view::edit::single_Result_SaddleNose_HB             {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/SaddleNose_HB           }   ;# Result(Length/Personal/SaddleNose_HB)     
    proc myGUI::view::edit::single_Result_Saddle_Offset_BB_Nose     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/SaddleNose_BB_x         }   ;# Result(Length/Saddle/Offset_BB_Nose)      
    proc myGUI::view::edit::single_Result_Saddle_Offset_BB_ST       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Saddle_Offset_BB_ST     }   ;# Result(Length/Saddle/Offset_BB_ST)        
    proc myGUI::view::edit::single_Result_Saddle_Offset_HB_X        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Saddle_HB_x             }   ;# Result(Length/Saddle/Offset_HB)           
    proc myGUI::view::edit::single_Result_Saddle_Offset_HB_Y        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Saddle_HB_y             }   ;# Result(Length/Saddle/Offset_HB)           
    proc myGUI::view::edit::single_Result_Saddle_SeatTube_BB        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Saddle_BB               }   ;# Result(Length/Saddle/SeatTube_BB)         
    proc myGUI::view::edit::single_Result_SeatTube_ClassicLength    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/SeatTube_LengthClassic  }   ;# Result(Length/SeatTube/VirtualLength)     
    proc myGUI::view::edit::single_Result_SeatTube_VirtualLength    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/SeatTube_LengthVirtual  }   ;# Result(Length/SeatTube/VirtualLength)     
    proc myGUI::view::edit::single_Result_StackHeight               {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Stack_Height            }   ;# Result(Length/HeadTube/StackHeight)       
    proc myGUI::view::edit::single_Result_TopTube_ClassicLength     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/TopTube_LengthClassic   }         
    proc myGUI::view::edit::single_Result_TopTube_VirtualLength     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/TopTube_LengthVirtual   }   ;# Result(Length/TopTube/VirtualLength)      
        #
    proc myGUI::view::edit::single_Result_HeadTube_Length           {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadTube_Summary        }   ;# Result(Length/TopTube/VirtualLength)
        #
    proc myGUI::view::edit::single_Result_Reference_Heigth_SN_HB    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Reference/SaddleNose_HB_y        }   ;# Result(Length/Reference/Heigth_SN_HB)     
    proc myGUI::view::edit::single_Result_Reference_SaddleNose_HB   {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Reference/SaddleNose_HB          }   ;# Result(Length/Reference/SaddleNose_HB)    
    proc myGUI::view::edit::single_Result_RearWheelTyreShoulder     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearWheel/TyreShoulder           }   ;# Result(Length/RearWheel/TyreShoulder)     
        #
    proc myGUI::view::edit::single_LugDetermination_HeadLug         {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadLug_Angle_Bottom           }
    proc myGUI::view::edit::single_LugDetermination_ChainStay       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/BottomBracket_Angle_ChainStay  }
    proc myGUI::view::edit::single_LugDetermination_DownTube        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/BottomBracket_Angle_DownTube   }


        #
        # -- others -----------------------------------
        #
    proc myGUI::view::edit::single_BottomBracket_CS_Offset_TopView  {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottomBracket/OffsetCS_TopView        }   ;# Lugs(BottomBracket/ChainStay/Offset_TopView)
    proc myGUI::view::edit::single_BottomBracket_Depth              {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/BottomBracket_Depth          }   ;# Custom(BottomBracket/Depth)                   
    proc myGUI::view::edit::single_BottomBracket_Excenter           {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/BottomBracket_Offset_Excenter}   ;# Custom(BottomBracket/Depth)                   
    proc myGUI::view::edit::single_BottomBracket_InsideDiameter     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottomBracket/InsideDiameter          }   ;# Lugs(BottomBracket/Diameter/inside)           
    proc myGUI::view::edit::single_BottomBracket_OutsideDiameter    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottomBracket/OutsideDiameter         }   ;# Lugs(BottomBracket/Diameter/outside)          
    proc myGUI::view::edit::single_BottomBracket_Width              {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottomBracket/Width                   }   ;# Lugs(BottomBracket/Width)                     
    proc myGUI::view::edit::single_ChainStay_DropoutOffset          {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearDropout/OffsetCSPerp              }   ;# Lugs(RearDropOut/ChainStay/OffsetCSPerp)      
    proc myGUI::view::edit::single_ChainStay_CenterlineLength_01    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/segmentLength_01            }   ;# FrameTubes(ChainStay/CenterLine/length_01)    
    proc myGUI::view::edit::single_ChainStay_CenterlineLength_02    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/segmentLength_02            }   ;# FrameTubes(ChainStay/CenterLine/length_02)    
    proc myGUI::view::edit::single_ChainStay_CenterlineLength_03    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/segmentLength_03            }   ;# FrameTubes(ChainStay/CenterLine/length_03)    
    proc myGUI::view::edit::single_ChainStay_CenterlineLength_04    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/segmentLength_04            }   ;# FrameTubes(ChainStay/CenterLine/length_04)    
    proc myGUI::view::edit::single_ChainStay_ProfileLengthComplete  {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/completeLength              }   ;# FrameTubes(ChainStay/Profile/completeLength)  
    proc myGUI::view::edit::single_ChainStay_ProfileLengthCut       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/cuttingLength               }   ;# FrameTubes(ChainStay/Profile/cuttingLength)   
    proc myGUI::view::edit::single_ChainStay_ProfileLength_01       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/profile_x01                 }   ;# FrameTubes(ChainStay/Profile/length_01)       
    proc myGUI::view::edit::single_ChainStay_ProfileLength_02       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/profile_x02                 }   ;# FrameTubes(ChainStay/Profile/length_02)       
    proc myGUI::view::edit::single_ChainStay_ProfileLength_03       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/profile_x03                 }   ;# FrameTubes(ChainStay/Profile/length_03)       
    proc myGUI::view::edit::single_ChainStay_ProfileWidth_00        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/profile_y00                 }   ;# FrameTubes(ChainStay/Profile/width_00)        
    proc myGUI::view::edit::single_ChainStay_ProfileWidth_01        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/profile_y01                 }   ;# FrameTubes(ChainStay/Profile/width_01)        
    proc myGUI::view::edit::single_ChainStay_ProfileWidth_02        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/profile_y02                 }   ;# FrameTubes(ChainStay/Profile/width_02)        
    proc myGUI::view::edit::single_ChainStay_ProfileWidth_03        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:ChainStay/WidthBB                     }   ;# FrameTubes(ChainStay/WidthBB)                 
    proc myGUI::view::edit::single_CrankSet_ArmWidth                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:CrankSet/ArmWidth                     }   ;# Component(CrankSet/ArmWidth)                  
    proc myGUI::view::edit::single_CrankSet_ChainLine               {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:CrankSet/ChainLine                    }   ;# Component(CrankSet/ChainLine)                 
    proc myGUI::view::edit::single_CrankSet_ChainRingOffset         {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:CrankSet/ChainRingOffset              }   ;# Component(CrankSet/ChainRingOffset)                 
    proc myGUI::view::edit::single_CrankSet_Length                  {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:CrankSet/Length                       }   ;# Component(CrankSet/Length)                    
    proc myGUI::view::edit::single_CrankSet_PedalEye                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:CrankSet/PedalEye                     }   ;# Component(CrankSet/PedalEye)                  
    proc myGUI::view::edit::single_CrankSet_QFactor                 {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:CrankSet/Q-Factor                     }   ;# Component(CrankSet/Q-Factor)                  
    proc myGUI::view::edit::single_DownTube_BottomBracketOffset     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:DownTube/OffsetBB                     }   ;# Custom(DownTube/OffsetBB)                     
    proc myGUI::view::edit::single_DownTube_CageOffsetBB            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottleCage/DownTube                   }   ;# Component(BottleCage/DownTube/OffsetBB)       
    proc myGUI::view::edit::single_DownTube_HeadTubeOffset          {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:DownTube/OffsetHT                     }   ;# Custom(DownTube/OffsetHT)                     
    proc myGUI::view::edit::single_DownTube_LowerCageOffsetBB       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottleCage/DownTube_Lower             }   ;# Component(BottleCage/DownTube_Lower/OffsetBB) 
    proc myGUI::view::edit::single_Fork_Height                      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Fork_Height                  }   ;# Component(Fork/Height)                        
    proc myGUI::view::edit::single_Fork_Rake                        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Fork_Rake                    }   ;# Component(Fork/Rake)                          
    proc myGUI::view::edit::single_FrontBrake_LeverLength           {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:FrontBrake/LeverLength                }   ;# Component(Brake/Front/LeverLength)            
    proc myGUI::view::edit::single_FrontBrake_Offset                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:FrontBrake/BladeOffset                }   ;# Component(Brake/Front/Offset)                 
    proc myGUI::view::edit::single_FrontWheel_RimHeight             {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:FrontWheel/RimHeight                  }   ;# Component(Wheel/Front/RimHeight)              
    proc myGUI::view::edit::single_HeadSet_BottomDiameter           {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:HeadSet/Diameter_Bottom               }
    proc myGUI::view::edit::single_HeadSet_BottomHeight             {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:HeadSet/Height_Bottom                 }   ;# Component(HeadSet/Height/Bottom)              
    proc myGUI::view::edit::single_HeadSet_TopHeight                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:HeadSet/Height_Top                    }   ;# Component(HeadSet/Height/Top)                 
    proc myGUI::view::edit::single_HeadTube_Angle                   {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HeadTube_Angle               }   ;# Custom(HeadTube/Angle)                        
    proc myGUI::view::edit::single_HeadTube_Diameter                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:HeadTube/Diameter                     }   ;# FrameTubes(HeadTube/Diameter)                 
    proc myGUI::view::edit::single_HeadTube_Length                  {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:HeadTube/Length                       }   ;# FrameTubes(HeadTube/Length)                   
    proc myGUI::view::edit::single_Personal_HandleBarDistance       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HandleBar_Distance           }   ;# Personal(HandleBar_Distance)                  
    proc myGUI::view::edit::single_Personal_HandleBarHeight         {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/HandleBar_Height             }   ;# Personal(HandleBar_Height)                    
    proc myGUI::view::edit::single_Personal_InnerLegLength          {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Inseam_Length                }   ;# Personal(InnerLeg_Length)                     
    proc myGUI::view::edit::single_Personal_SaddleDistance          {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Saddle_Distance              }   ;# Personal(Saddle_Distance)                     
    proc myGUI::view::edit::single_Personal_SaddleHeight            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Saddle_Height                }   ;# Personal(Saddle_Height)                       
    proc myGUI::view::edit::single_RearBrake_LeverLength            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearBrake/LeverLength                 }   ;# Component(Brake/Rear/LeverLength)             
    proc myGUI::view::edit::single_RearBrake_Offset                 {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearBrake/Offset                      }   ;# Component(Brake/Rear/Offset)                  
    proc myGUI::view::edit::single_RearDropOut_CS_Offset            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearDropout/OffsetCS                  }   ;# Lugs(RearDropOut/ChainStay/Offset)            
    proc myGUI::view::edit::single_RearDropOut_CS_OffsetTopView     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearDropout/OffsetCS_TopView          }   ;# Lugs(RearDropOut/ChainStay/Offset_TopView)    
    proc myGUI::view::edit::single_RearHub_DiscDiameter             {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearBrake/DiscDiameter                }   ;# Rendering(RearMockup/DiscDiameter)              
    proc myGUI::view::edit::single_RearHub_DiscOffset               {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearBrake/DiscOffset                  }   ;# Rendering(RearMockup/DiscOffset)              
    proc myGUI::view::edit::single_RearHub_FirstSprocket            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearWheel/FirstSprocket               }   ;# text://Component(Wheel/Rear/FirstSprocket)    
    proc myGUI::view::edit::single_RearHub_Width                    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearWheel/HubWidth                    }   ;# Component(Wheel/Rear/HubWidth)                
    proc myGUI::view::edit::single_RearWheel_Distance               {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/ChainStay_Length             }   ;# Scalar:Geometry/ChainStay_Length)             
    proc myGUI::view::edit::single_RearWheel_RimHeight              {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearWheel/RimHeight                   }   ;# Component(Wheel/Rear/RimHeight)               
    proc myGUI::view::edit::single_RearWheel_TyreWidth              {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearWheel/TyreWidth                   }   ;# Component(Wheel/Rear/TyreWidth)               
    proc myGUI::view::edit::single_RearWheel_TyreWidthRadius        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:RearWheel/TyreWidthRadius             }   ;# Component(Wheel/Rear/TyreWidthRadius)         
    proc myGUI::view::edit::single_Reference_HandleBarDistance      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Reference/HandleBar_Distance          }   ;# Reference(HandleBar_Distance)                 
    proc myGUI::view::edit::single_Reference_HandleBarHeight        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Reference/HandleBar_Height            }   ;# Reference(HandleBar_Height)                   
    proc myGUI::view::edit::single_Reference_SaddleNoseDistance     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Reference/SaddleNose_Distance         }   ;# Reference(SaddleNose_Distance)                
    proc myGUI::view::edit::single_Reference_SaddleNoseHeight       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Reference/SaddleNose_Height           }   ;# Reference(SaddleNose_Height)                  
    proc myGUI::view::edit::single_SaddleHeightComponent            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Saddle/Height                         }   ;# Component(Saddle/Height)                      
    proc myGUI::view::edit::single_SeatPost_Diameter                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:SeatPost/Diameter                     }   ;# Component(SeatPost/Diameter)                  
    proc myGUI::view::edit::single_SeatPost_PivotOffset             {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:SeatPost/PivotOffset                  }   ;# Component(SeatPost/PivotOffset)               
    proc myGUI::view::edit::single_SeatPost_Setback                 {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:SeatPost/Setback                      }   ;# Component(SeatPost/Setback)                   
    proc myGUI::view::edit::single_SeatStay_OffsetTT                {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:SeatStay/OffsetTT                     }   ;# Custom(SeatStay/OffsetTT)                     
    proc myGUI::view::edit::single_SeatTube_BottomBracketOffset     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:SeatTube/OffsetBB                     }   ;# Custom(SeatTube/OffsetBB)                     
    proc myGUI::view::edit::single_SeatTube_CageOffsetBB            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:BottleCage/SeatTube                   }   ;# Component(BottleCage/SeatTube/OffsetBB)       
    proc myGUI::view::edit::single_SeatTube_Extension               {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:SeatTube/Extension                    }   ;# Custom(SeatTube/Extension)                    
    proc myGUI::view::edit::single_Stem_Angle                       {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Stem_Angle                   }   ;# Component(Stem/Angle)                         
    proc myGUI::view::edit::single_Stem_Length                      {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/Stem_Length                  }   ;# Component(Stem/Length)                        
    proc myGUI::view::edit::single_TopTube_Angle                    {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:Geometry/TopTube_Angle                }   ;# Custom(TopTube/Angle)                         
    proc myGUI::view::edit::single_TopTube_HeadTubeOffset           {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:TopTube/OffsetHT                      }   ;# Custom(TopTube/OffsetHT)                      
    proc myGUI::view::edit::single_TopTube_PivotPosition            {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   Scalar:TopTube/PivotPosition                 }   ;# Custom(TopTube/PivotPosition)                 
    
    proc myGUI::view::edit::single_LabelFile                        {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   file://Component:Label                       }
    proc myGUI::view::edit::single_CrankSetFile                     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   file://Component:CrankSet                    }
    proc myGUI::view::edit::single_RearDerailleurFile               {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   file://Component:RearDerailleur              }
    proc myGUI::view::edit::single_SeatTube_BottleCageFile          {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:BottleCage_SeatTube@SELECT_BottleCage      }
    proc myGUI::view::edit::single_DownTube_BottleCageFile          {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:BottleCage_DownTube@SELECT_BottleCage      }
    proc myGUI::view::edit::single_DownTube_BottleCageFileLower     {x y canvasIF}  {myGUI::view::edit::create_Edit_2   $x $y $canvasIF   list://Config:BottleCage_DownTube_Lower@SELECT_BottleCage}



    proc myGUI::view::edit::group_HandleBar_Parameter               {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:HandleBar 
                Scalar:HandleBar/PivotAngle 
            }  "HandleBar Parameter - 001" 
    }
    proc myGUI::view::edit::group_DerailleurFront_Parameter_17      {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:FrontDerailleur 
                Scalar:FrontDerailleur/Distance 
                Scalar:FrontDerailleur/Offset 
            }  "DerailleurFront Parameter - 002" 
    } 
    proc myGUI::view::edit::group_Crankset_Parameter_16             {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:CrankSet 
                Scalar:CrankSet/Length 
                Scalar:CrankSet/PedalEye 
                text://ListValue:CrankSetChainRings
                Config:CrankSet_SpyderArmCount 
            }  "Crankset:  Parameter - 003" 
    } 
    proc myGUI::view::edit::group_Chain_Parameter_15                {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                text://ListValue:CrankSetChainRings 
                Scalar:RearDerailleur/Pulley_x 
                Scalar:RearDerailleur/Pulley_y 
                Scalar:RearDerailleur/Pulley_teeth 
            }  "Chain Parameter - 004"
    } 
    proc myGUI::view::edit::group_RearBrake_Parameter_14            {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                list://Config:RearBrake@SELECT_BrakeType 
                file://Component:RearBrake 
                Scalar:RearBrake/LeverLength 
                Scalar:RearBrake/Offset 
            }  "RearBrake Parameter - 005" 
    } 
    proc myGUI::view::edit::group_FrontBrake_Parameter_13           {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                list://Config:FrontBrake@SELECT_BrakeType 
                file://Component:FrontBrake 
                Scalar:Fork/CrownAngleBrake
                Scalar:FrontBrake/BladeOffset                        
            }  "FrontBrake Parameter - 006" 
    } 
    proc myGUI::view::edit::group_ForkCrown_Parameter               {x y canvasIF} {
        myGUI::view::edit::create_Edit_2 $x $y $canvasIF  {
                list://Config:Fork@SELECT_ForkType
                file://Component:ForkCrown
                Scalar:Fork/CrownAngleBrake
                Scalar:Fork/CrownOffsetBrake
                Scalar:Fork/BladeOffsetCrown
                Scalar:Fork/BladeOffsetCrownPerp
            }  "ForkCrown Parameter - 025"     
    }
    
    
    
    
    proc myGUI::view::edit::group_Saddle_Parameter_12               {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:Saddle 
                Scalar:Saddle/NoseLength 
                Scalar:Saddle/Offset_x 
                Scalar:Geometry/SaddleNose_BB_x 
            }  "Saddle Parameter - 007" 
    } 
    proc myGUI::view::edit::group_HeadSet_Parameter_10              {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:HeadSet/Height_Top 
                Scalar:HeadSet/Diameter_Top 
            }  "HeadSet Parameter - 008" 
    } 
    proc myGUI::view::edit::group_HeadSet_Parameter_09              {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:HeadSet/Height_Bottom 
                Scalar:HeadSet/Diameter_Bottom
            }  "HeadSet Parameter - 009" 
    }
    proc myGUI::view::edit::group_RearFender_Parameter_00           {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
            list://Config:RearFender@SELECT_Binary_OnOff 
                Scalar:RearFender/Radius 
                Scalar:RearFender/Height 
                Scalar:RearFender/OffsetAngle 
            }  "RearFender Parameter - 010" 
    }
    proc myGUI::view::edit::group_RearFender_Parameter_01           {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
            list://Config:RearFender@SELECT_Binary_OnOff 
                Scalar:RearFender/Radius 
                Scalar:RearFender/Height 
                Scalar:RearFender/Width 
            }  "RearFender Parameter - 010a" 
    }
    proc myGUI::view::edit::group_FrontFender_Parameter_00          {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                list://Config:FrontFender@SELECT_Binary_OnOff 
                Scalar:FrontFender/Radius 
                Scalar:FrontFender/Height 
                Scalar:FrontFender/OffsetAngleFront 
                Scalar:FrontFender/OffsetAngle 
            }  "FrontFender Parameter - 011" 
    } 
    proc myGUI::view::edit::group_CarrierFront_Parameter_07         {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:FrontCarrier 
                Scalar:FrontCarrier/x 
                Scalar:FrontCarrier/y 
            }  "FrontCarrier Parameter - 012" 
    } 
    proc myGUI::view::edit::group_CarrierRear_Parameter_11          {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:RearCarrier 
                Scalar:RearCarrier/x 
                Scalar:RearCarrier/y 
            }  "RearCarrier Parameter - 013" 
    } 
    proc myGUI::view::edit::group_DownTube_Parameter_06             {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:DownTube/DiameterHT 
                Scalar:DownTube/DiameterBB 
                Scalar:DownTube/TaperLength 
            }  "DownTube Parameter - 014" 
    } 
    proc myGUI::view::edit::group_SeatTube_Parameter_05             {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:SeatStay/SeatTubeMiterDiameter 
                Scalar:SeatTube/DiameterTT 
                Scalar:SeatTube/DiameterBB 
                Scalar:SeatTube/TaperLength 
            }  "SeatTube Parameter - 015" 
    } 
    proc myGUI::view::edit::group_TopTube_Parameter_04              {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {                
                Scalar:TopTube/DiameterHT 
                Scalar:TopTube/DiameterST 
                Scalar:TopTube/TaperLength 
                Scalar:Geometry/TopTube_Angle 
            }  "TopTube Parameter - 016" 
    } 
    proc myGUI::view::edit::group_ChainStay_Parameter_01            {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:ChainStay/DiameterSS 
                Scalar:ChainStay/Height 
                Scalar:ChainStay/HeightBB 
                Scalar:ChainStay/TaperLength 
                Scalar:RearDropout/OffsetCSPerp 
                Scalar:RearDropout/OffsetCS 
            }  "ChainStay Parameter - 017" 
    } 
    proc myGUI::view::edit::group_ChainStay_Parameter_02            {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:ChainStay/DiameterSS 
                Scalar:ChainStay/Height 
                Scalar:ChainStay/HeightBB 
                Scalar:ChainStay/TaperLength 
                Scalar:RearDropout/OffsetCSPerp 
                Scalar:RearDropout/OffsetCS 
                Scalar:ChainStay/cuttingAngle 
            }  "ChainStay Parameter - 017 - a" 
    } 
    proc myGUI::view::edit::group_SeatStay_Parameter_01             {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:SeatStay/SeatTubeMiterDiameter 
                Scalar:SeatStay/DiameterST 
                Scalar:SeatStay/DiameterCS 
                Scalar:SeatStay/TaperLength 
                Scalar:SeatStay/OffsetTT 
                Scalar:RearDropout/OffsetSSPerp 
                Scalar:RearDropout/OffsetSS 
            }  "SeatStay Parameter - 018" 
    } 
    proc myGUI::view::edit::group_RearDropout_Parameter_01          {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:RearDropout 
                list://Config:RearDropoutOrient@SELECT_DropOutDirection 
                list://Config:RearDropout@SELECT_DropOutPosition 
                Scalar:RearDropout/RotationOffset 
                Scalar:RearDropout/Derailleur_x 
                Scalar:RearDropout/Derailleur_y 
                Scalar:RearDropout/OffsetSSPerp 
                Scalar:RearDropout/OffsetSS 
                Scalar:RearDropout/OffsetCSPerp 
                Scalar:RearDropout/OffsetCS 
            }  "RearDropout Parameter - 019" 
    } 
    proc myGUI::view::edit::group_RearDropout_Parameter_02          {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                file://Component:RearDropout 
                list://Config:RearDropoutOrient@SELECT_DropOutDirection 
                list://Config:RearDropout@SELECT_DropOutPosition 
                Scalar:RearDropout/RotationOffset 
                Scalar:RearDropout/Derailleur_x 
                Scalar:RearDropout/Derailleur_y 
                Scalar:RearDropout/OffsetSSPerp 
                Scalar:RearDropout/OffsetSS 
                Scalar:RearDropout/OffsetCSPerp 
                Scalar:RearDropout/OffsetCS 
                Scalar:ChainStay/cuttingAngle 
            }  "RearDropout Parameter - 019 - a" 
    } 
    proc myGUI::view::edit::group_BottomBracket_Diameter_01         {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:BottomBracket/OutsideDiameter 
                Scalar:BottomBracket/InsideDiameter 
            }  "BottomBracket Diameter - 020" 
    } 
    proc myGUI::view::edit::group_HeadTube_Parameter_01             {x y canvasIF} {
          myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:HeadTube/Length 
                Scalar:HeadSet/Height_Bottom 
            }  "Head Tube Parameter - 021" 
    } 
    proc myGUI::view::edit::group_HeadTube_Parameter_02             {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:HeadTube/Length                         
                Scalar:HeadSet/Height_Bottom 
            }  "Head Tube Parameter - 022" 
    } 
    proc myGUI::view::edit::group_HeadTube_Parameter_03             {x y canvasIF} {
        if {[myGUI::model::model_XZ::getConfig HeadTube] == {cylindric}} {
            myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:HeadTube/Length  
                Scalar:HeadSet/Height_Bottom 
                list://Config:HeadTube@SELECT_HeadTubeType 
                Scalar:HeadTube/Diameter    
            }  "Head Tube Parameter - 023 - a" 
        } else {
            myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                Scalar:HeadTube/Length  
                Scalar:HeadSet/Height_Bottom 
                list://Config:HeadTube@SELECT_HeadTubeType 
                Scalar:HeadTube/DiameterTaperedBase    
                Scalar:HeadTube/DiameterTaperedTop 
                Scalar:HeadTube/LengthTapered                         
                Scalar:HeadTube/HeightTaperedBase                
            }  "Head Tube Parameter - 023 - b" 
        }
    } 
    proc myGUI::view::edit::group_Saddle_Parameter_01               {x y canvasIF} {
          myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                        Scalar:Geometry/SaddleNose_BB_x 
                        Scalar:Saddle/NoseLength 
                        Scalar:Saddle/Offset_x 
              } "Saddle Parameter - 022" 
    } 
    proc myGUI::view::edit::group_FrontWheel_Parameter_01           {x y canvasIF} {
          myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                list://Scalar:Geometry/FrontRim_Diameter@SELECT_Rim 
                Scalar:Geometry/FrontTyre_Height 
              } "Front Wheel Parameter - 023" 
    } 
    proc myGUI::view::edit::group_FrontWheel_Parameter_02           {x y canvasIF} {
        myGUI::view::edit::create_Edit_2  $x $y $canvasIF  { \            
                list://Scalar:Geometry/FrontRim_Diameter@SELECT_Rim
                Scalar:Geometry/FrontWheel_Radius
            }  "Front Wheel Parameter - 024" 
    } 
              
              
              
        #     
        # -- Fork - Settings ------------------------------                            
        #     
    proc myGUI::view::edit::group_ForkCrown_Parameter               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF  {
                list://Config:Fork@SELECT_ForkType
                file://Component:ForkCrown
                Scalar:Fork/CrownAngleBrake
                Scalar:Fork/CrownOffsetBrake
                Scalar:Fork/BladeOffsetCrown
                Scalar:Fork/BladeOffsetCrownPerp
            }  "ForkCrown Parameter - 025" 
    } 
    proc myGUI::view::edit::group_ForkBlade_Parameter               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF  {
                Scalar:Fork/BladeWidth 
                Scalar:Fork/BladeDiameterDO
                Scalar:Fork/BladeTaperLength
                Scalar:Fork/BladeBendRadius
                Scalar:Fork/BladeEndLength
            }  "ForkBlade Parameter - 026"
    } 
    proc myGUI::view::edit::group_ForkBlade_Parameter_orphan               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF  {
                list://Config:ForkBlade@SELECT_ForkBladeType 
                Scalar:Fork/BladeWidth 
                Scalar:Fork/BladeDiameterDO
                Scalar:Fork/BladeTaperLength
                Scalar:Fork/BladeBendRadius
                Scalar:Fork/BladeEndLength
            }  "ForkBlade Parameter - 026"
    } 
    proc myGUI::view::edit::group_ForkDropout_Parameter             {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                file://Component:ForkDropout 
                list://Config:ForkDropout@SELECT_DropOutPosition 
                Scalar:Fork/BladeOffsetDO
                Scalar:Fork/BladeOffsetDOPerp
            }  "ForkDropout Parameter - 027"
    } 
    proc myGUI::view::edit::group_ForkSupplier_Parameter            {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                list://Config:Fork@SELECT_ForkType
                file://Component:ForkSupplier
                Scalar:Fork/CrownOffsetBrake
            }  "ForkSupplier Parameter - 028"
    } 
              
        #     
        # -- Lug - Settings -------------------------------                            
        #     
        #     
        # -- Frame Details -- Lug Specification -----------                            
        #     
    proc myGUI::view::edit::lugSpec_RearDropout                     {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/RearDropOut_Angle
                       Scalar:Lugs/RearDropOut_Tolerance
                } {nLug Specification:  RearDropout - 028}                            
    } 
    proc myGUI::view::edit::lugSpec_SeatTube_DownTube               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/BottomBracket_DownTube_Angle 
                       Scalar:Lugs/BottomBracket_DownTube_Tolerance 
                } "Lug Specification:  SeatTube/DownTube  - 029"                      
    } 
    proc myGUI::view::edit::lugSpec_SeatTube_ChainStay              {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/BottomBracket_ChainStay_Angle 
                       Scalar:Lugs/BottomBracket_ChainStay_Tolerance 
                } "Lug Specification:  SeatTube/ChainStay - 030"      
    } 
    proc myGUI::view::edit::lugSpec_SeatTube_TopTube                {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/SeatLug_TopTube_Angle 
                       Scalar:Lugs/SeatLug_TopTube_Tolerance 
                } "Lug Specification:  SeatTube/TopTube - 031"                       
    } 
    proc myGUI::view::edit::lugSpec_SeatTube_SeatStay               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/SeatLug_SeatStay_Angle 
                       Scalar:Lugs/SeatLug_SeatStay_Tolerance 
                       Scalar:SeatStay/SeatTubeMiterDiameter 
                } "Lug Specification:  SeatTube/SeatStay - 032"                      
    } 
    proc myGUI::view::edit::lugSpec_HeadTube_TopTube                {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/HeadLug_Top_Angle 
                       Scalar:Lugs/HeadLug_Top_Tolerance 
                } "Lug Specification:  HeadTube/TopTube - 033"                       
    } 
    proc myGUI::view::edit::lugSpec_HeadTube_DownTube               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Lugs/HeadLug_Bottom_Angle 
                       Scalar:Lugs/HeadLug_Bottom_Tolerance 
                } "Lug Specification:  HeadTube/DownTube - 034"                      
    } 
              
              
        #     
        # -- Base Concept ---------------------------------                            
        #     
    proc myGUI::view::edit::group_RearWheel_Parameter               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                list://Scalar:Geometry/RearRim_Diameter@SELECT_Rim 
                       Scalar:Geometry/RearTyre_Height 
                } "Rear Wheel Parameter - 035"                        
    } 
    proc myGUI::view::edit::group_FrontGeometry                     {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Geometry/Stem_Angle 
                       Scalar:Geometry/Stem_Length 
                       Scalar:Geometry/Fork_Height 
                       Scalar:Geometry/Fork_Rake 
                } "Steerer/Fork:  Settings - 036"                     
    } 
    proc myGUI::view::edit::group_BottomBracket_DepthHeight         {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:Geometry/BottomBracket_Depth 
                       Scalar:Geometry/BottomBracket_Height 
                       Scalar:Geometry/BottomBracket_Offset_Excenter 
                } "BottomBracket:  Settings - 037"                    
    } 
              
              
        #     
        # -- TopTube --------------------------------------                            
        #     
        #     
        # -- SeatTube -------------------------------------                            
        #     
        #     
        # -- DownTube -------------------------------------                            
        #     
        #     
        # -- SeatStay -------------------------------------                            
        #     
              
              
        #     
        # -- Rear Frame -----------------------------------                            
        #     
    proc myGUI::view::edit::group_RearDerailleur_Mount              {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                file://Component:RearDropout 
                list://Config:RearDropoutOrient@SELECT_DropOutDirection 
                list://Config:RearDropout@SELECT_DropOutPosition 
                       Scalar:RearDropout/RotationOffset 
                       Scalar:RearDropout/Derailleur_x 
                       Scalar:RearDropout/Derailleur_y 
                } "Rear Derailleur Mount - 038"                       
    } 
              
              
        #     
        # -- Rear Mockup ----------------------------------                            
        #     
    proc myGUI::view::edit::group_RearDiscBrake                     {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:RearBrake/DiscDiameter 
                       Scalar:RearBrake/DiscWidth 
                       Scalar:RearMockup/DiscClearance 
                } "DiscBrake Details - 039"                           
    } 
    proc myGUI::view::edit::group_RearTyre_Parameter                {x y canvasIF} {
            # title { Rear Tyre Parameter} #                            
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:RearWheel/TyreWidthRadius 
                       Scalar:RearWheel/TyreWidth 
                       Scalar:RearMockup/TyreClearance 
                } " Rear Tyre Parameter - 040"                        
    } 
        #     
        #     
    proc myGUI::view::edit::group_ChainStay_Centerline_Bent01       {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:ChainStay/segmentAngle_01 
                       Scalar:ChainStay/segmentRadius_01 
                       Scalar:ChainStay/segmentLength_01 
                       Scalar:ChainStay/segmentLength_02 
                } "ChainStay:  Bent 01 - 041"                         
    } 
    proc myGUI::view::edit::group_ChainStay_Centerline_Bent02       {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:ChainStay/segmentAngle_02 
                       Scalar:ChainStay/segmentRadius_02 
                       Scalar:ChainStay/segmentLength_02 
                       Scalar:ChainStay/segmentLength_03 
                } "ChainStay:  Bent 02 - 042"                         
    } 
    proc myGUI::view::edit::group_ChainStay_Centerline_Bent03       {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:ChainStay/segmentAngle_03 
                       Scalar:ChainStay/segmentRadius_03 
                       Scalar:ChainStay/segmentLength_03 
                       Scalar:ChainStay/segmentLength_04 
                } "ChainStay:  Bent 03 - 043"                         
    } 
    proc myGUI::view::edit::group_ChainStay_Centerline_Bent04       {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:ChainStay/segmentAngle_04 
                       Scalar:ChainStay/segmentRadius_04 
                       Scalar:ChainStay/segmentLength_04 
                } "ChainStay:  Bent 04 - 044"                         
    } 
    proc myGUI::view::edit::group_RearHub_Parameter                 {x y canvasIF} {
                # Line 491:                                             
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:RearWheel/HubWidth 
                text://Scalar:RearWheel/FirstSprocket
                } "RearHub:  Parameter - 045"                         
    } 
    proc myGUI::view::edit::group_Crankset_Parameter                {x y canvasIF} {
                # Line 623:                                             
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                       Scalar:CrankSet/ChainLine
                       Scalar:CrankSet/ChainRingOffset
                       Scalar:CrankSet/Q-Factor
                text://ListValue:CrankSetChainRings 
                } "Crankset:  Parameter - 046"                        
    } 
    proc myGUI::view::edit::group_ChainStay_Area                    {x y canvasIF} {
                # Line 782:                                             
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF {
                list://Config:ChainStay@SELECT_ChainStay 
                list://Config:RearFender@SELECT_Binary_OnOff 
                       Scalar:RearMockup/TyreClearance 
                       Scalar:RearMockup/ChainWheelClearance 
                       Scalar:RearMockup/CrankClearance 
                       Scalar:RearMockup/CassetteClearance 
                } "ChainStay:  Area - 047"
    }
    proc myGUI::view::edit::group_RearDropout_Parameter_10          {x y canvasIF} {
          myGUI::view::edit::create_Edit_2  $x $y $canvasIF  {
                list://Config:RearDropoutOrient@SELECT_DropOutDirection 
                       Scalar:RearDropout/RotationOffset 
                       Scalar:RearDropout/OffsetCSPerp 
                       Scalar:RearDropout/OffsetCS 
              } "RearDropout Parameter - 048" 
    }
    proc myGUI::view::edit::group_Rendering_Parameter               {x y canvasIF} {
            myGUI::view::edit::create_Edit_2 $x $y $canvasIF  {
                list://Config:Fork@SELECT_ForkType 
                list://Config:FrontBrake@SELECT_BrakeType 
                list://Config:RearBrake@SELECT_BrakeType 
                list://Config:BottleCage_SeatTube@SELECT_BottleCage 
                list://Config:BottleCage_DownTube@SELECT_BottleCage 
                list://Config:BottleCage_DownTube_Lower@SELECT_BottleCage 
                list://Config:FrontFender@SELECT_Binary_OnOff 
                list://Config:RearFender@SELECT_Binary_OnOff 
                file://Component:FrontCarrier 
                file://Component:RearCarrier 
               } "Rendering: - 099"
    } 


