 ##+##########################################################################
 #
 # test_bikeFrame.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2017/05/01
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
 #    namespace:  bikeFrame
 # ---------------------------------------------------------------------------
 #
 #
 

set WINDOW_Title      "test bikeFrame, based on cad4tcl@rattleCAD"


set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir _ext__Libraries]
 
package require   Tk
package require   appUtil
package require   cad4tcl
package require   vectormath
package require   bikeFrame

set cad4tcl::canvasType 1

 
     
 ##+######################

namespace eval model {
    variable tubeDictionary         {}
    variable profileDictionary      {}
    variable segmentDictionary      {}
    variable shapeDictionary        {}
    variable debugDictionary        {}
    variable arcPrecission          0.5
    variable bikeFrame              {}
}
namespace eval view {
    variable cvObject
    variable cvObject
    variable reportText
}
namespace eval control {
        #
        # defaults
        #
    variable angle_HeadTube     72.50 ;#    65   80
    variable angle_TopTube       2.50 ;#    10  -10   
    variable length_HeadTube   150    ;#    90  190
    variable extend_SeatTube    20    ;#     0  120
    variable offset_SeatTube     0    ;#    -5   20
    variable offset_DownTube     0    ;#    -5   20
    variable x_HeadTube        436    ;#    410 500     436.1480445902127 
    variable x_RearDropout     404    ;#    350 450    -404.6529377132952 
    variable x_SeatPost        180    ;#    100 200    -180.00
    variable y_HeadTube        413    ;#    380 480     413.4501048805116
    variable y_RearDropout      66    ;#    -10  90      66.00 
    variable y_SeatPost        630    ;#    500 700     630.00
        #
    variable type_HeadTube    tapered ;#    tapered / cylindric
    
    # 
    # myPosition(BottomBracket)        = 0 0                                  
    # myPosition(BottomBracket_Ground) = 0 -270.0                             
    # myPosition(Fork)                 = 440.20757288352036 400.57492604541056
    # myPosition(FrontDropout)         = 592.8824524862503 66.0               
    # myPosition(FrontDropout_MockUp)  = 592.8824524862503 66.0               
    # myPosition(FrontWheel)           = 592.8824524862503 66.0               
    # myPosition(FrontWheel_Ground)    = 592.8824524862503 -204.0             
    # myPosition(HandleBar)            = 481.00 635.00                        
    # myPosition(HeadSet)              = 440.20757288352036 400.57492604541056
    # myPosition(HeadTube)             = 436.1480445902127 413.4501048805116  
    # myPosition(LegClearance)         = 80.00 580.0                          
    # myPosition(RearDropout)          = -404.6529377132952 66.00             
    # myPosition(RearWheel)            = -404.6529377132952 66.00             
    # myPosition(RearWheel_Ground)     = -404.6529377132952 -270.0            
    # myPosition(Saddle)               = -212.69 710.00                       
    # myPosition(SaddleProposal)       = 212.44531517788388 -717.1966174341383
    # myPosition(Saddle_Mount)         = -212.69 670.0                        
    # myPosition(Saddle_Nose)          = -62.69 695.0                         
    # myPosition(Saddle_Top)           = -210.31355992159308 710.0            
    # myPosition(SeatPostPivot)        = -212.69 630.0                        
    # myPosition(SeatPostSeatTube)     = -188.71952481837786 637.1004450259992
    # myPosition(SeatTube_Ground)      = 79.97839602653715 -270.0             
    # myPosition(Steerer_End)          = 373.2082824917083 613.0695272141098  
    # myPosition(Steerer_FrontWheel)   = 549.96518970258 52.46823902230771    
    # myPosition(Steerer_Ground)       = 651.6390349182477 -270.0             
    # myPosition(Steerer_HandleBar)    = 376.66583715467254 602.1035648161657 
    # myPosition(Steerer_Start)        = 440.20757288352036 400.57492604541056
    # 
    # ----- myScalar ------
    # myScalar(BottomBracket_Height) = 270.0
    # myScalar(FrontWheel_Distance)  = 596.5447195861436
    # myScalar(FrontWheel_Radius)    = 336.0
    # myScalar(FrontWheel_x)         = 592.8824524862503
    # myScalar(HeadSet_Bottom)       = 13.50
    # myScalar(HeadTube_Summary)     = 163.5
    # myScalar(RearWheel_Radius)     = 336.0
    # myScalar(SaddleNose_BB_x)      = -62.69
    # myScalar(Saddle_BB)            = 740.4942899758873
    # myScalar(SeatTube_Angle)       = 253.49985321772613
    # 
    # ----- direction -----
    # direction(SeatPost) = -0.2840178010399517 0.9588190072648907
    # direction(SeatTube) = 0.2840178010399517 -0.9588190072648907
    #
    
    
    


    #
    variable contrSeg_l00         50    ;#     5     100
    variable contrSeg_r01         30    ;#    20     100
    variable contrSeg_a01         25    ;#   -90      90
    variable contrSeg_l02         60    ;#    20     150
    variable contrSeg_r03         40    ;#    20     100
    variable contrSeg_a03        -20    ;#   -90      90
    variable contrSeg_l04         70    ;#    20     150
    variable contrSeg_r05         40    ;#    20     100
    variable contrSeg_a05        -30    ;#   -90      90
    variable contrSeg_l06         70    ;#    20     150
        #
    # variable guideDef            {}         
    #        # guideDef          {i 50 a {30 60} l 100 a {40 -20} l 50 a {20 -40} l 60} 
    #        # guideDef          {l 50 a {30 60}} 
    #     #
    # variable profile_x01          10    
    # variable profile_x02          30    
    # variable profile_x03         130    
    # variable profile_x04          90    
    # variable profile_y01          10    
    # variable profile_y02          15    
    # variable profile_y03          20    
    # variable profile_y04          15
    #     #
    # variable centerLine           {-1  0}
        #
    variable start_angle          20
    variable start_length         80
    variable end_length           65
    variable dim_size              5
    variable dim_dist             30
    variable dim_offset            0
    variable dim_type_select      aligned
    variable dim_font_select      vector
    
    variable std_fnt_scl           1
    variable font_colour          black
    variable demo_type            dimension
    variable drw_scale             0.35
    variable cv_scale              1
    variable debugMode             off
        #
    variable arcPrecission         1
        #
        #variable unbentShape
        #variable profileDef {}
        #     set profileDef {{0 7} {10 7} {190 9} {80 9} {70 12}}
        #     set profileDef {{0 9} {10 7} {190 16} {80 16} {70 24}}
        #     set profileDef {{0 7} {10 7} {190 16} {80 16} {70 24}}
        #
}    
    
    #
    # -- MODEL --

    #
    # -- CONTROL --
proc control::moveto_StageCenter {item} {
    set cvObject $::view::cvObject
    set stage       [$cvObject getCanvas]
    set stageCenter [$cvObject getCenter]
    set bottomLeft  [$cvObject getBottomLeft]
    foreach {cx cy} $stageCenter break
    foreach {lx ly} $bottomLeft  break
    $cvObject move $item [expr {$cx - $lx}] [expr {$cy -$ly}]
}
proc control::recenter_board {} {
    variable  cv_scale 
    variable  drw_scale 
    set cvObject $::view::cvObject
    puts "\n  -> recenter_board:   $cvObject "
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "============================="
    puts "\n\n"
    moveto_StageCenter __cvElement__
    set cv_scale [$cvObject configure Canvas Scale]    
}
proc control::refit_board {} {
    variable  cv_scale 
    variable  drw_scale
    set cvObject $::view::cvObject
    puts "\n  -> recenter_board:   $::view::cvObject "
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "============================="
    puts "\n\n"
    set cv_scale [$cvObject fit]
}
proc control::scale_board {{value {1}}} {
    variable  cv_scale 
    variable  drw_scale 
    set cvObject $::view::cvObject
    puts "\n  -> scale_board:   $cvObject"
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "============================="
    puts "\n\n"        
    $cvObject center $cv_scale
}
proc control::cleanReport {} {
    $::view::reportText     delete  1.0 end
}
proc control::writeReport {text} {
    $view::reportText       insert  end "$text\n"
}

proc control::create_Debug {cv pos tag} {
        #
    set tubeDictionary  [model::getDictionary]
        # set tubeDictionary  $model::tubeDictionary
        #
    set cvObject    $cv
    set myPosition  $pos
    set myTag       $tag
        #
        #
    $cvObject  create   circle      $myPosition -radius 5  -tags $myTag  -outline darkred  -width 1
        #
        # appUtil::pdict $tubeDictionary
        #
    set segment_Dictionary      [dict get $tubeDictionary segment]
        #
    foreach key [dict keys $segment_Dictionary] {
            #
        set keyDict [dict get $segment_Dictionary $key]
        set type    [dict get $keyDict type]
            #
        puts "\n ----- control::create_Debug --- $key -------------"
        appUtil::pdict $keyDict 1 "        "
            #
        switch -exact $type {
            arc {
                    set pos_StartLeft       [join [dict get $keyDict start  pos_Left]         " "]
                    set pos_StartRight      [join [dict get $keyDict start  pos_Right]        " "]
                    set pos_EndLeft         [join [dict get $keyDict end    pos_Left]         " "]
                    set pos_EndRight        [join [dict get $keyDict end    pos_Right]        " "]
                    set pos_TngtLeft        [join [dict get $keyDict inside pos_TangentLeft]  " "]
                    set pos_TngtRight       [join [dict get $keyDict inside pos_TangentRight] " "]
                    set pos_StartLeftCtrl   [join [dict get $keyDict start pos_LeftCtrl ] " "]
                    set pos_StartRightCtrl  [join [dict get $keyDict start pos_RightCtrl] " "]
                    set pos_EndLeftCtrl     [join [dict get $keyDict end   pos_LeftCtrl ] " "]
                    set pos_EndRightCtrl    [join [dict get $keyDict end   pos_RightCtrl] " "]
                        #
                    puts "          -> \$pos_StartLeft        $pos_StartLeft "            
                    puts "          -> \$pos_StartRight       $pos_StartRight"            
                    puts "          -> \$pos_EndLeft          $pos_EndLeft   "            
                    puts "          -> \$pos_EndRight         $pos_EndRight  "            
                    puts "          -> \$pos_TngtLeft         $pos_TngtLeft  "            
                    puts "          -> \$pos_TngtRight        $pos_TngtRight "
                    puts "          -> \$pos_StartLeftCtrl    $pos_StartLeftCtrl"
                    puts "          -> \$pos_StartRightCtrl   $pos_StartRightCtrl"
                    puts "          -> \$pos_EndLeftCtrl      $pos_EndLeftCtrl"
                    puts "          -> \$pos_EndRightCtrl     $pos_EndRightCtrl"
                        #
                    $cvObject  create   circle  $pos_TngtLeft       -radius 1.0  -tags $myTag  -outline darkblue    -width 1
                    $cvObject  create   circle  $pos_TngtRight      -radius 1.0  -tags $myTag  -outline darkblue    -width 1
                        #
                    $cvObject  create   circle  $pos_StartLeftCtrl  -radius 0.3  -tags $myTag  -outline darkorange  -width 1
                    $cvObject  create   circle  $pos_StartRightCtrl -radius 0.3  -tags $myTag  -outline darkorange  -width 1
                    $cvObject  create   circle  $pos_EndLeftCtrl    -radius 0.3  -tags $myTag  -outline darkorange  -width 1
                    $cvObject  create   circle  $pos_EndRightCtrl   -radius 0.3  -tags $myTag  -outline darkorange  -width 1
                        #
                    $cv create   line    [join "$pos_StartLeftCtrl  $pos_EndLeftCtrl"  " "]  -tags {__cvElement__}  -fill darkorange
                    $cv create   line    [join "$pos_StartRightCtrl $pos_EndRightCtrl" " "]  -tags {__cvElement__}  -fill darkorange
                        #
                    # $cv create   line    [join "$pos_StartLeft  $pos_TngtLeft  $pos_EndLeft"  " "]  -tags {__cvElement__}  -fill darkblue
                    # $cv create   line    [join "$pos_StartRight $pos_TngtRight $pos_EndRight" " "]  -tags {__cvElement__}  -fill darkblue
                        #
                        #
                    # set shapeLeft        [dict get $keyDict shape  left]
                    # set shapeRight       [dict get $keyDict shape  right]
                        #
                    # puts "   -> \$shapeLeft   $shapeLeft"    
                    # puts "   -> \$shapeRight  $shapeRight"    
                        #
                    # $cv create   line    $shapeLeft     -tags {__cvElement__}  -fill green
                    # $cv create   line    $shapeRight    -tags {__cvElement__}  -fill green
                        #
                }
            default {}
        }
    }
        #
    return
        #
}

proc control::change_HeadTubeType {} {
        #
    variable type_HeadTube
        #
    if {$type_HeadTube eq "tapered"} {
        set type_HeadTube "cylindric"
    } else {
        set type_HeadTube "tapered"
    }
        #
    control::update
        #
}

proc control::set_project {projectName} {
        #
    variable angle_HeadTube 
    variable angle_TopTube 
    variable length_HeadTube
    variable extend_SeatTube
    variable offset_SeatTube
    variable offset_DownTube
    variable x_HeadTube     
    variable x_RearDropout  
    variable x_SeatPost  
    variable y_HeadTube     
    variable y_RearDropout
    variable y_SeatPost
        #
    set project_01  {
                        DownTube {
                            Scalar { 
                                LengthTaper             300.00
                                OffsetHT                  8.50
                                OffsetBB                  0.00
                                DiameterHT               31.80
                                DiameterBB               34.90
                            }
                        }
                        HeadTube {
                            Config { 
                                Type                   tapered
                            } 
                            Scalar { 
                                Angle                    72.50
                                Diameter                 36.00
                                DiameterTaperedBase      56.00
                                DiameterTaperedTop       46.00
                                HeightTaperedBase        15.00
                                Length                  150.00
                                LengthTaper              70.00
                            }
                            Position { 
                                Origin                 {436.1480445902127 413.4501048805116}
                            } 
                        }
                        SeatStay {
                            Scalar { 
                                DiameterCS            11.00
                                DiameterST            16.00
                                DiameterToolST        28.60
                                LengthTaper          300.00
                                OffsetDO              35.00
                                OffsetDOPerp          -0.30
                                OffsetTT              20.00
                            }
                        }
                        SeatTube {
                            Scalar { 
                                DiameterBB               31.80
                                DiameterTT               28.60
                                LengthExtension          20.00
                                LengthTaper             300.00
                                OffsetBB                  0.00
                            }
                            Position { 
                                SeatPost               {-188.71952481837786 637.1004450259992}
                            } 
                        }
                        TopTube {
                            Scalar { 
                                Angle                     2.50
                                LengthTaper             300.00
                                DiameterST               28.60
                                OffsetHT                  8.50
                                DiameterHT               28.60
                            }
                        }
                        ChainStay {
                            Config { 
                                Type                    straight
                            } 
                            Scalar { 
                                OffsetDO                 33.00
                                OffsetDOPerp             -1.30
                                OffsetDOTopView           5.00
                                DiameterSS               13.00
                                Height                   29.00
                                HeightBB                 22.20
                                LengthTaper             280.00
                                WidthBB                  22.20
                                completeLength          410.00
                                cuttingLeft               0.00
                                cuttingLength           380.3453120994022
                                profile_x01             150.00
                                profile_x02             150.00
                                profile_x03              95.00
                                profile_y00              12.50
                                profile_y01              18.00
                                profile_y02              18.00
                                segmentAngle_01          -8.00
                                segmentAngle_02           5.00
                                segmentAngle_03           0.00
                                segmentAngle_04          -2.00
                                segmentLength_01         50.00
                                segmentLength_02        160.00
                                segmentLength_03         47.00
                                segmentLength_04         60.00
                                segmentRadius_01        320.00
                                segmentRadius_02        320.00
                                segmentRadius_03        320.00
                                segmentRadius_04        320.00
                            }
                        }
                        BottomBracket {
                            Scalar { 
                                Width                    68.00
                                DiameterOutside          40.00
                                OffsetCS_TopView          6.00
                                DiameterInside           36.00
                            }
                            Position { 
                                Origin                 {0.00 0.00}
                            } 
                        }
                        RearDropout {
                            Config { 
                                Orientation            Chainstay
                            }
                            Scalar {
                                RotationOffset            0.00
                            }
                            Position { 
                                Origin                 {-404.6529377132952 66.00}
                            }
                        }
                    }
        #
    set project_02  {
                        DownTube {
                            Scalar { 
                                LengthTaper             300.00
                                OffsetHT                  8.50
                                OffsetBB                  0.00
                                DiameterHT               37.80
                                DiameterBB               34.90
                            }
                        }
                        HeadTube {
                            Config { 
                                Type                cylindric
                            } 
                            Scalar { 
                                Angle                 73.50
                                Diameter              36.00
                                DiameterTaperedBase   56.00
                                DiameterTaperedTop    46.00
                                HeightTaperedBase     15.00
                                Length               120.00
                                LengthTaper           70.00
                            }
                            Position { 
                                Origin              {440.00 450.00}
                            } 
                        }
                        SeatStay {
                            Scalar { 
                                DiameterCS            11.00
                                DiameterST            16.00
                                DiameterToolST        30.60
                                LengthTaper          300.00
                                OffsetDO              35.00
                                OffsetDOPerp          -0.30
                                OffsetTT              20.00
                            }
                        }
                        SeatTube {
                            Scalar { 
                                DiameterBB            31.80
                                DiameterTT            28.60
                                LengthExtension       90.00
                                LengthTaper          300.00
                                OffsetBB               5.00
                            }
                            Position { 
                                SeatPost           {-170.0 620.0}
                            } 
                        }
                        TopTube {
                            Scalar { 
                                Angle                     5.50
                                DiameterST               28.60
                                LengthTaper             300.00
                                OffsetHT                  8.50
                                DiameterHT               28.60
                            }
                        }
                        ChainStay {
                            Config { 
                                Type                    bent
                            } 
                            Scalar { 
                                OffsetDO                 33.00
                                OffsetDOPerp             -1.30
                                OffsetDOTopView           5.00
                                DiameterSS               13.00
                                Height                   29.00
                                HeightBB                 22.20
                                LengthTaper             280.00
                                WidthBB                  22.20
                                completeLength          410.00
                                cuttingLeft               0.00
                                cuttingLength           380.3453120994022
                                profile_x01             150.00
                                profile_x02             150.00
                                profile_x03              95.00
                                profile_y00              12.50
                                profile_y01              18.00
                                profile_y02              18.00
                                segmentAngle_01          -8.00
                                segmentAngle_02           5.00
                                segmentAngle_03           0.00
                                segmentAngle_04          -2.00
                                segmentLength_01         50.00
                                segmentLength_02        160.00
                                segmentLength_03         47.00
                                segmentLength_04         60.00
                                segmentRadius_01        320.00
                                segmentRadius_02        320.00
                                segmentRadius_03        320.00
                                segmentRadius_04        320.00
                                cuttingAngle             65.00
                            }
                        }
                        BottomBracket {
                            Scalar { 
                                Width                    68.00
                                DiameterOutside          40.00
                                OffsetCS_TopView          6.00
                                DiameterInside           36.00
                            }
                            Position { 
                                Origin                 {0.00 0.00}
                            } 
                        }
                        RearDropout {
                            Config { 
                                Orientation            horizontal
                            }
                            Scalar {
                                RotationOffset            0.00
                            }
                            Position { 
                                Origin                 {-414.6529377132952 76.00}
                            }
                        }
                    }
        
        #
        #
    set myObject            $::model::bikeFrame     
        #
    set lug_RearDropout     [$myObject getLug   RearDropout]
    set lug_BottomBracket   [$myObject getLug   BottomBracket]
        #   
    set tube_HeadTube       [$myObject getTube  HeadTube]
    set tube_SeatTube       [$myObject getTube  SeatTube]
    set tube_TopTube        [$myObject getTube  TopTube]
    set tube_DownTube       [$myObject getTube  DownTube]
        #
        #
    set timeStart   [clock milliseconds]
        #
    switch -exact $projectName {
        project_01 {$myObject initProject_DICT $project_01}
        project_02 {$myObject initProject_DICT $project_02}
        default    {}
    }
        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001*($timeEnd - $timeStart)}]
        #
        #
    # $tube_HeadTube  reportValues
    $tube_SeatTube  reportValues
    # $lug_RearDropout    reportValues
        #
    set angle_HeadTube      [$tube_HeadTube getScalar   Angle]
    set angle_TopTube       [$tube_TopTube  getScalar   Angle]
    set length_HeadTube     [$tube_HeadTube getScalar   Length]
    set extend_SeatTube     [$tube_SeatTube getScalar   LengthExtension]
    set offset_SeatTube     [$tube_SeatTube getScalar   OffsetBB]
    set offset_DownTube     [$tube_DownTube getScalar   OffsetBB]
        #
    set pos_HeadTube        [$tube_HeadTube     getPosition Origin]
    set pos_SeatPost        [$tube_SeatTube     getPosition SeatPost]
    set pos_RearDropout     [$lug_RearDropout   getPosition Origin]
        #
    foreach {x_HeadTube y_HeadTube}         $pos_HeadTube break
    foreach {x__SeatPost y_SeatPost}        $pos_SeatPost break
    foreach {x__RearDropout y_RearDropout}  $pos_RearDropout break
        #
    puts "  -> \$pos_SeatPost    $pos_SeatPost "    
    puts "  -> \$pos_RearDropout $pos_RearDropout "    
        #
    set x_SeatPost      [expr {-1.0 * $x__SeatPost}]
    set x_RearDropout   [expr {-1.0 * $x__RearDropout}]
        #
    puts "  -> \$x_SeatPost    $x_SeatPost "    
    puts "  -> \$x_RearDropout $x_RearDropout "
        #
    control::updateStage
        #
        #
    writeReport "    -> \$timeUsed:  $timeUsed seconds"
        #
    set templateKeys [$myObject getInitKeys]
    foreach entry $templateKeys {
        puts "    -> $entry"
    }
        #
        # set testValue [dict get $emptyDict root BottomBracket Position Origin]
        # puts "  -> $testValue"
        #
        # set testValue [dict get $emptyDict root BottomBracket Position Fail_]; ... will give ERROR: key "Fail_" not known in dictionary
        # puts "  -> $testValue"
        #
    return
        #
}
proc control::set_parameterList {configName} {
    
    set chainStay_01 {   
            ChainStay {
                Config {
                    Type               bent
                }
                Scalar {
                    cuttingAngle         90.00
                    segmentAngle_01      -8.00
                    segmentAngle_02       5.00
                    segmentAngle_03       0.00
                    segmentAngle_04      -2.00
                    segmentLength_01     50.00
                    segmentLength_02    160.00
                    segmentLength_03     47.00
                    segmentLength_04     60.00
                    segmentRadius_01    320.00
                    segmentRadius_02    320.00
                    segmentRadius_03    320.00
                    segmentRadius_04    320.00
                }
            }
            HeadTube {
                Config {
                    Type               tapered
                }
            }
            TopTube {
                Scalar {
                    Angle                  5.00
                }
            }}
                
    set chainStay_02 {
            ChainStay {
                Config {
                    Type               bent
                }
                Scalar {
                    cuttingAngle        120.00
                    segmentAngle_01     -10.00
                    segmentAngle_02       7.00
                    segmentAngle_03       2.00
                    segmentAngle_04      -5.00
                    segmentLength_01     50.00
                    segmentLength_02    160.00
                    segmentLength_03     47.00
                    segmentLength_04     60.00
                    segmentRadius_01    320.00
                    segmentRadius_02    320.00
                    segmentRadius_03    320.00
                    segmentRadius_04    320.00
                }
            }
            HeadTube {
                Config {
                    Type               cylindric
                }
            }
            TopTube {
                Scalar {
                    Angle                 10.00
                }
            }}
        
    set chainStay_03 {
            ChainStay {
                Config {
                    Type               straight
                }
                Scalar {
                    cuttingAngle         60.00
                }
            }
            HeadTube {
                Config {
                    Type               tapered
                }
            }
            TopTube {
                Scalar {
                    Angle                 15.00
                }
            }}
        
    puts "\n --> set_configDict -- $configName \n"
    
    switch -exact -- $configName {
        chainStay_01 {
            set myDict $chainStay_01
        }
        chainStay_02 {
            set myDict $chainStay_02
        }
        chainStay_03 {
            set myDict $chainStay_03
        }
        default {
            puts "\n --> set_configDict -- $configName ... not defined"
            return
        }
    }
    
    appUtil::pdict $myDict 2
    
    $model::bikeFrame setSubset_DICT $myDict
    
    control::updateStage
    
}

proc control::update {args} {
        #
    variable demo_type    
        #
    if {$demo_type != {dimension} } {
        view::demo_cadCanvas 
        return
    }            
        #
    variable angle_HeadTube 
    variable angle_TopTube 
    variable length_HeadTube
    variable extend_SeatTube
    variable offset_SeatTube
    variable offset_DownTube
    variable x_HeadTube     
    variable x_RearDropout  
    variable x_SeatPost  
    variable y_HeadTube     
    variable y_RearDropout
    variable y_SeatPost  
        #
    variable type_HeadTube    
        #
    set myObject                $::model::bikeFrame     ;#  bikeFrame::DiamondFrame
        #
    set lug_RearDropout         [$myObject getLug   RearDropout]
    set lug_BottomBracket       [$myObject getLug   BottomBracket]
        #
    set tube_HeadTube           [$myObject getTube  HeadTube]
    set tube_SeatTube           [$myObject getTube  SeatTube]
    set tube_TopTube            [$myObject getTube  TopTube]
    set tube_DownTube           [$myObject getTube  DownTube]
        #
    writeReport "    \$myObject"
    writeReport "           -> $myObject"
    writeReport "           -> \$type_HeadTube $type_HeadTube"
        #
        #
        #
    $lug_RearDropout    setPosition Origin          [list [expr {-1.0 * $x_RearDropout}] $y_RearDropout]
            #
    $tube_HeadTube      setConfig   Type            $type_HeadTube
    $tube_HeadTube      setPosition Origin          [list $x_HeadTube $y_HeadTube]
    $tube_HeadTube      setScalar   Angle           $angle_HeadTube
    $tube_HeadTube      setScalar   Length          $length_HeadTube
            #
        set pos_BottomBracket   [$lug_BottomBracket getPosition Origin]
        set pos_SeatPost        [list [expr {-1.0 * $x_SeatPost}] $y_SeatPost]
        set pos_SeatTube        [vectormath::cathetusPoint $pos_SeatPost  $pos_BottomBracket [expr {-1.0 * $offset_SeatTube}] opposite]
        set dir_SeatTube        [vectormath::unifyVector $pos_SeatPost $pos_SeatTube]
        #
    $tube_SeatTube      setPosition SeatPost        $pos_SeatPost
    $tube_SeatTube      setScalar   LengthExtension $extend_SeatTube
    $tube_SeatTube      setScalar   OffsetBB        $offset_SeatTube
        #
    $tube_DownTube      setScalar   OffsetBB        $offset_DownTube
        #
    $tube_TopTube       setScalar   Angle           $angle_TopTube
        #
    set timeStart   [clock milliseconds]
        #
    $myObject updateGeometry
    $myObject updateShape
        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001*($timeEnd - $timeStart)}]
        #
    updateStage  
        #
    writeReport "    -> \$args:     $args"
    writeReport "    -> \$timeUsed:  $timeUsed seconds"
        #
    set timeStart   [clock milliseconds]
        #
    set resultDict  [$myObject  getDictionary]    
        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001*($timeEnd - $timeStart)}]
        #
    # appUtil::pdict $resultDict    
        #
    writeReport "    -> \$timeUsed:  $timeUsed seconds"
        #
    return
        #
}
proc control::updateStage {} {
        #
    set cvObject    $::view::cvObject
        #
    variable drw_scale
    variable dim_font_select
    variable dim_size
    variable font_colour
        #
    set procReport control::writeReport
        #
    set myTag   {__cvElement__}
        #
        # set board   [$cvObject getCanvas]

    if {$font_colour == {default}} { set font_colour [$cvObject getNodeAttr Style  fontcolour]}
            
      #puts "\n\n============================="
      #puts "   -> drw_scale:          $drw_scale"
      #puts "   -> font_colour:           $font_colour"
      #puts "   -> dim_size:           $dim_size"
      #puts "   -> dim_font_select:       $dim_font_select"
      #puts "\n============================="
      #puts "   -> Drawing:               [[$cvObject getNode Stage] asXML]"
      #puts "\n============================="
      #puts "   -> Style:                   [[$cvObject getNode Style] asXML]"
      #puts "\n============================="
      ##$cvObject reportMyDictionary
      #puts "\n============================="
      #puts "\n\n"
    
      # -- clear text field
    cleanReport
        #
        #
    $cvObject deleteContent
        #
    $cvObject configure Stage    Scale        $drw_scale
    $cvObject configure Style    Fontstyle    $dim_font_select
    $cvObject configure Style    Fontsize     $dim_size
        #
    createFrame  
    createDebug  
        #
    control::refit_board
        #
    #$cvObject centerContent {1550 1000} {__cvElement__}
        #
    return            
        #
    }
    #
proc control::createFrame {} {
        #
    variable drw_scale
    variable type_HeadTube
        #
    set cvObject    $::view::cvObject
        #
        # set board       [$cvObject getNodeAttr Canvas  path]
        #

        
    set myObject                        $::model::bikeFrame
    set myPosition                      {0 0}
    writeReport "    \$myObject"
    writeReport "           -> $myObject"
    writeReport "           -> \$type_HeadTube $type_HeadTube"
        #
        #
    set bottomCanvasBorder              20
    set updatePosition                  recenter
    set updatePosition                  {0 0}
        #
        #
    set cvObject                         $cvObject
    set xy {550 120}
        #
    set lug_BottomBracket               [$myObject getLug BottomBracket]  
    set lug_RearDropout                 [$myObject getLug RearDropout]  
        #
    set tube_ChainStay                  [$myObject getTube ChainStay]
    set tube_DownTube                   [$myObject getTube DownTube ]
    set tube_HeadTube                   [$myObject getTube HeadTube ]
    set tube_SeatStay                   [$myObject getTube SeatStay ]
    set tube_SeatTube                   [$myObject getTube SeatTube ]
    set tube_TopTube                    [$myObject getTube TopTube  ]
        
        #
        # $lug_BottomBracket reportValues    
        #
    set pos(BottomBracket)              [vectormath::addVector $xy [$lug_BottomBracket  getPosition Origin]]
    set pos(DownTube_Start)             [vectormath::addVector $xy [$tube_DownTube      getPosition Origin]]
    set pos(DownTube_End)               [vectormath::addVector $xy [$tube_DownTube      getPosition End]]
    set pos(HeadTube_Start)             [vectormath::addVector $xy [$tube_HeadTube      getPosition Origin]]
    set pos(HeadTube_End)               [vectormath::addVector $xy [$tube_HeadTube      getPosition End]]
    set pos(SeatTube_Start)             [vectormath::addVector $xy [$tube_SeatTube      getPosition Origin]]
    set pos(SeatTube_End)               [vectormath::addVector $xy [$tube_SeatTube      getPosition End]]
    set pos(TopTube_Start)              [vectormath::addVector $xy [$tube_TopTube       getPosition Origin]]
    set pos(TopTube_End)                [vectormath::addVector $xy [$tube_TopTube       getPosition End]]
    
    set pos(ChainStay_Start)            [vectormath::addVector $xy [$tube_ChainStay     getPosition Origin]]
    set pos(ChainStay_End)              [vectormath::addVector $xy [$tube_ChainStay     getPosition End]]
    set pos(SeatStay_Start)             [vectormath::addVector $xy [$tube_SeatStay      getPosition Origin]]
    set pos(SeatStay_End)               [vectormath::addVector $xy [$tube_SeatStay      getPosition End]]                
    
    set pos(RearDropout)                [vectormath::addVector $xy [$lug_RearDropout    getPosition Origin]]
    set pos(SeatPost)                   [vectormath::addVector $xy [$tube_SeatTube      getPosition SeatPost]]

    set pos(_Edge_HeadTubeBack_Bottom)  [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeOriginLeft]]
    set pos(_Edge_HeadTubeBack_Taper1)  [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeTaperStartLeft]]
    set pos(_Edge_HeadTubeBack_Taper2)  [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeTaperEndLeft]]
    set pos(_Edge_HeadTubeBack_Top)     [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeEndLeft]]
    set pos(_Edge_HeadTubeFront_Bottom) [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeOriginRight]]
    set pos(_Edge_HeadTubeFront_Taper1) [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeTaperStartRight]]
    set pos(_Edge_HeadTubeFront_Taper2) [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeTaperEndRight]]
    set pos(_Edge_HeadTubeFront_Top)    [vectormath::addVector $xy [$tube_HeadTube getPosition _EdgeEndRight]]
    
    # set pos(_Edge_SeatTubeBack_Bottom)  [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeTopLeft]]
    # set pos(_Edge_SeatTubeBack_Taper1)  [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeTaperStartLeft]]
    # set pos(_Edge_SeatTubeBack_Taper2)  [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeTaperEndLeft]]
    # set pos(_Edge_SeatTubeBack_Top)     [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeOriginLeft]]
    # set pos(_Edge_SeatTubeFront_Bottom) [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeEndRight]]
    # set pos(_Edge_SeatTubeFront_Taper1) [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeTaperStartRight]]
    # set pos(_Edge_SeatTubeFront_Taper2) [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeTaperEndRight]]
    set pos(_Edge_SeatTubeFront_Top)    [vectormath::addVector $xy [$tube_SeatTube getPosition _EdgeOriginLeft]]
    
    set pos(DownTube_ST_IS)             [vectormath::addVector $xy [$tube_DownTube getPosition _EdgeSeatTubeIS]]
    
    set pos(_Edge_TopTubeEnd_Top)       [vectormath::addVector $xy [$tube_TopTube getPosition _EdgeEndRight]]
    set pos(_Edge_TopTubeEnd_Bottom)    [vectormath::addVector $xy [$tube_TopTube getPosition _EdgeEndLeft]]
    set pos(_Edge_TopTubeOrigin_Bottom) [vectormath::addVector $xy [$tube_TopTube getPosition _EdgeOriginLeft]]
    set pos(_Edge_TopTubeOrigin_Top)    [vectormath::addVector $xy [$tube_TopTube getPosition _EdgeOriginRight]]
    
    # set pos(_Edge_SeatTubeTopTube_ST)   [vectormath::addVector $xy [$tube_SeatTube getPosition TopTubeTop]]
    # set pos(_Edge_TopTubeSeatTube_ST)   [vectormath::addVector $xy [$tube_TopTube  getPosition SeatTubeTop]]
    # set pos(_Edge_TopTubeHeadTube_TT)   [vectormath::addVector $xy [$tube_TopTube  getPosition HeadTubeTop]]
    
    set lng(BottomBracket_Radius)       [expr {0.5 * [$lug_BottomBracket getScalar DiameterOutside]}]

        #     
    set shp(HeadTube)                   [vectormath::addVectorCoordList $xy [$tube_HeadTube   getShape xz]]
    set shp(SeatTube)                   [vectormath::addVectorCoordList $xy [$tube_SeatTube   getShape xz]]
    set shp(DownTube)                   [vectormath::addVectorCoordList $xy [$tube_DownTube   getShape xz]]
    set shp(TopTube)                    [vectormath::addVectorCoordList $xy [$tube_TopTube    getShape xz]]
    set shp(ChainStay)                  [vectormath::addVectorCoordList $xy [$tube_ChainStay  getShape xz]]
    set shp(SeatStay)                   [vectormath::addVectorCoordList $xy [$tube_SeatStay   getShape xz]]
        #
    set ab                              [vectormath::addVector $pos(ChainStay_Start) {0 200}]
    set cln(RearMockup)                 [string map {, { }} [$tube_ChainStay  getCenterLine xy]]
    puts "   \$cln(RearMockup) $cln(RearMockup)"
    #exit
    set cln(RearMockup)                 [vectormath::addVectorCoordList $ab $cln(RearMockup)]
    set shp(RearMockup)                 [vectormath::addVectorCoordList $ab [$tube_ChainStay  getShape      xy]]
        #
        # puts "  \$shp(TopTube)   $shp(TopTube)"
        # puts "  \$shp(ChainStay) $shp(ChainStay)"
        # puts "  \$shp(SeatStay)  $shp(SeatStay)"
        # exit
    parray shp
        #
    $cvObject create polygon     $shp(HeadTube)      -fill lightgray -outline black
    $cvObject create polygon     $shp(DownTube)      -fill lightgray -outline black
    $cvObject create polygon     $shp(SeatTube)      -fill lightgray -outline black
    $cvObject create polygon     $shp(TopTube)       -fill lightgray -outline black
    $cvObject create polygon     $shp(ChainStay)     -fill lightgray -outline black
    $cvObject create polygon     $shp(SeatStay)      -fill lightgray -outline black
        #
    $cvObject create polygon     $shp(RearMockup)    -fill lightgray -outline black
    $cvObject create line        $cln(RearMockup)    -fill red
        
        #
    $cvObject create line        [appUtil::flatten_nestedList $pos(HeadTube_Start)       $pos(HeadTube_End)]     -fill red
    $cvObject create line        [appUtil::flatten_nestedList $pos(DownTube_Start)       $pos(DownTube_End)]     -fill red
    $cvObject create line        [appUtil::flatten_nestedList $pos(SeatTube_Start)       $pos(SeatTube_End)]     -fill red
    $cvObject create line        [appUtil::flatten_nestedList $pos(TopTube_Start)        $pos(TopTube_End) ]     -fill red
    $cvObject create line        [appUtil::flatten_nestedList $pos(SeatStay_Start)       $pos(SeatStay_End)]     -fill red
    $cvObject create line        [appUtil::flatten_nestedList $pos(ChainStay_Start)      $pos(ChainStay_End)]    -fill red
    
    $cvObject create line        [appUtil::flatten_nestedList $pos(ChainStay_Start)      $pos(RearDropout)]      -fill blue
    $cvObject create line        [appUtil::flatten_nestedList $pos(SeatStay_Start)       $pos(RearDropout)]      -fill blue            
    
    $cvObject create line        [appUtil::flatten_nestedList $pos(SeatPost)             $pos(SeatTube_Start)]   -fill green            
    
    $cvObject create circle      [appUtil::flatten_nestedList $pos(BottomBracket)]               -radius $lng(BottomBracket_Radius)
    
    $cvObject create circle      [appUtil::flatten_nestedList $pos(TopTube_Start)]               -radius 5   -outline red
    $cvObject create circle      [appUtil::flatten_nestedList $pos(SeatTube_Start)]              -radius 5   -outline red
    $cvObject create circle      [appUtil::flatten_nestedList $pos(DownTube_Start)]              -radius 5   -outline red
    $cvObject create circle      [appUtil::flatten_nestedList $pos(HeadTube_Start)]              -radius 5   -outline red
    $cvObject create circle      [appUtil::flatten_nestedList $pos(ChainStay_Start)]             -radius 5   -outline red
    $cvObject create circle      [appUtil::flatten_nestedList $pos(SeatStay_Start)]              -radius 5   -outline red
    $cvObject create circle      [appUtil::flatten_nestedList $pos(DownTube_ST_IS)]              -radius 5   -outline blue
    
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeBack_Bottom)]   -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeBack_Taper1)]   -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeBack_Taper2)]   -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeBack_Top)]      -radius 5
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeFront_Bottom)]  -radius 6
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeFront_Taper1)]  -radius 5
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeFront_Taper2)]  -radius 4
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_HeadTubeFront_Top)]     -radius 3

    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeBack_Bottom)]   -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeBack_Taper1)]   -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeBack_Taper2)]   -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeBack_Top)]      -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeFront_Bottom)]  -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeFront_Taper1)]  -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeFront_Taper2)]  -radius 5
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeFront_Top)]     -radius 5
    
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_TopTubeOrigin_Bottom)]  -radius 5
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_TopTubeEnd_Bottom)]     -radius 5
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_TopTubeEnd_Top)]        -radius 5
    $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_TopTubeOrigin_Top)]     -radius 5
    
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_SeatTubeTopTube_ST)]    -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_TopTubeSeatTube_ST)]    -radius 5
    # $cvObject create circle      [appUtil::flatten_nestedList $pos(_Edge_TopTubeHeadTube_TT)]    -radius 5

    $cvObject create circle      [appUtil::flatten_nestedList $pos(SeatPost)]            -radius 15
    
    
    
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(BottomBracket)     $pos(HeadTube_Start)] \
                [list horizontal        16   0    orange]
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(HeadTube_Start)    $pos(BottomBracket)] \
                [list vertical         -16   0    orange] 
    
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(BottomBracket)     $pos(RearDropout)] \
                [list horizontal       -16   0    orange]
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(RearDropout)       $pos(BottomBracket)] \
                [list vertical          16   0    orange]
    
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(SeatPost)          $pos(BottomBracket)] \
                [list horizontal       -16   0    orange]
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(BottomBracket)     $pos(SeatPost)] \
                [list vertical    [expr {-1.0 * ([lindex $pos(RearDropout) 0] + 24)}]  0   orange]
    
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(_Edge_HeadTubeBack_Top) $pos(_Edge_HeadTubeFront_Top) $pos(_Edge_HeadTubeFront_Bottom)] \
                [list perpendicular    -16   0    orange]
    $cvObject create dimensionLength      [appUtil::flatten_nestedList  $pos(SeatPost) $pos(SeatTube_End) $pos(BottomBracket)] \
                [list perpendicular     30   7    orange] 

    set posCenter  [vectormath::intersectPointVector $pos(BottomBracket) {1 0} $pos(HeadTube_Start) [vectormath::unifyVector $pos(HeadTube_End) $pos(HeadTube_Start)]]
    $cvObject create dimensionAngle       [appUtil::flatten_nestedList  $posCenter $pos(HeadTube_Start) $pos(BottomBracket)] \
                [list 200   0    orange]
    
    
    
    
        #
    return            
        #
    }
proc control::createDebug {} {
        #
    set cvObject    $::view::cvObject
        #
    set board   [$cvObject getCanvas]
        #
    return            
        #
    }
    #
    #
    # -- VIEW --
proc view::create_config_line {w lb_text entry_var start end  } {        
        frame   $w
        pack    $w
 
        global $entry_var

        label   $w.lb    -text $lb_text            -width 20  -bd 1  -anchor w 
        entry   $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
     
        scale   $w.scl    -width        12 \
                        -length       120 \
                        -bd           1  \
                        -sliderlength 15 \
                        -showvalue    0  \
                        -orient       horizontal \
                        -command      "control::update $entry_var" \
                        -variable     $entry_var \
                        -from         $start \
                        -to           $end 
                            # -resolution   $resolution

        pack      $w.lb  $w.cfg $w.scl    -side left  -fill x            
}
proc view::create_status_line {w lb_text entry_var} {         
        frame   $w
        pack    $w
 
        global $entry_var

        label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
        entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
        pack      $w.lb  $w.cfg    -side left  -fill x            
}
proc view::demo_cadCanvas {} {
          
      variable  cvObject
      
      $cvObject  create   line           {0 0 20 0 20 20 0 20 0 0}       -tags {Line_01}  -fill blue   -width 2 
      $cvObject  create   line           {30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
      $cvObject  create   line           {0 0 30 30 }                    -tags {Line_01}  -fill blue   -width 2 
      
      $cvObject  create   rectangle      {180 120 280 180 }              -tags {Line_01}  -fill violet   -width 2 
      $cvObject  create   polygon        {40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

      $cvObject  create   oval           {30 160 155 230 }               -tags {Line_01}  -fill red   -width 2         
      $cvObject  create   circle         {160 60}            -radius 50  -tags {Line_01}  -fill blue   -width 2 
      $cvObject  create   arc            {270 160}           -radius 50  -start 30       -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
      
      $cvObject  create   text           {140 90}  -text "text a"
      $cvObject  create   vectortext     {120 70}  -text "vectorText ab"
      $cvObject  create   vectortext     {100 50}  -text "vectorText abc"  -size 10
      $cvObject  create   text           {145 95}  -text "text abcd" -size 10
}
proc view::createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
    variable cvObject
    variable cvObject
    variable cv_scale
        #
    set parentPath [file rootname $cv_path]
    set cvName     [file tail $cv_path]
        #
        # puts "   \$parentPath   $parentPath"
        # puts "   \$cvName       $cvName"
        # 
        #exit
        #
        # puts "   \$cv_path   $cv_path"    
        # puts "   \$cv_width  $cv_width"    
        # puts "   \$cv_height $cv_height"    
        # puts "   \$st_width  $st_width"    
        # puts "   \$st_height $st_height"  
        # flush stdout       
        #
        #                  eval cadCanvas::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args
        # set stageCanvas [eval cadCanvas::newCanvas $varname  $notebook.$varname \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args]
        # set stageCanvas [cadCanvas::newCanvas cv01  $cv_path     "stageCanvas"  $cv_width $cv_height     A3 0.5 40 $args]
        #
        # set retValue [eval cadCanvas::newCanvas $cvName  $parentPath     "stageCanvas"  $cv_width $cv_height     A3 0.35 40 $args]
        # set cvObject [eval cadCanvas::newCanvas $cvName  $parentPath     "stageCanvas"  $cv_width $cv_height     A3 0.35 40 $args]
        #
        ### -- G U I - canvas 
    set cvObject    [cad4tcl::new  $parentPath  800 600  A3  1.0  25]
    set stageCanvas [$cvObject getCanvas]
    set cv_scale    [$cvObject configure Canvas Scale]
    set drw_scale   [$cvObject configure Stage Scale]
    
    
        # foreach {stageCanvas cvObject} $retValue break
    puts "  -> $cvObject"
        # set stageCanvas   $cv
        # set cv_scale [$cvObject getNodeAttr Canvas scale]
    set cv_scale [$cvObject configure Canvas Scale]
    return $cvObject
}
proc view::create {windowTitle} {
            #
    variable reportText
    variable stageCanvas
        #
    variable cvObject
    variable cv_scale
    variable drw_scale
        #
    frame .f0 
    set f_view      [labelframe .f0.f_view          -text "view"]
    set f_config    [labelframe .f0.f_config        -text "config"]

    pack  .f0      -expand yes -fill both
    pack  $f_view  $f_config    -side left -expand yes -fill both
    pack  configure  $f_config    -fill y
    
    
    set f_board     [labelframe $f_view.f_board     -text "board"]
    set f_report    [labelframe $f_view.f_report    -text "report"]
    pack  $f_board  $f_report    -side top -expand yes -fill both
   
  
        #
        ### -- G U I - canvas 
    set cvObject    [cad4tcl::new  $f_board  800 600  A3  1.0  25]
    set stageCanvas [$cvObject getCanvas]
    set cv_scale    [$cvObject configure Canvas Scale]
    set drw_scale   [$cvObject configure Stage Scale]
    
        #
        ### -- G U I - canvas report
        #
    set reportText  [text       $f_report.text  -width 50  -height 7]
    set reportScb_x [scrollbar  $f_report.sbx   -orient hori  -command "$reportText xview"]
    set reportScb_y [scrollbar  $f_report.sby   -orient vert  -command "$reportText yview"]
    $reportText     conf -xscrollcommand "$reportScb_x set"
    $reportText     conf -yscrollcommand "$reportScb_y set"
        grid $reportText $reportScb_y   -sticky news
        grid             $reportScb_x   -sticky news
        grid rowconfig    $f_report  0  -weight 1
        grid columnconfig $f_report  0  -weight 1

    #
    ### -- G U I - canvas demo
        
    set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
        #
    pack  $f_settings  -side top -expand yes -fill both
        #
    labelframe  $f_settings.debug           -text debug
    labelframe  $f_settings.geometry        -text geometry
    labelframe  $f_settings.config          -text config
    labelframe  $f_settings.project         -text project
    labelframe  $f_settings.pathLeft        -text pathLeft
    labelframe  $f_settings.precission      -text precission
    labelframe  $f_settings.font            -text font
    labelframe  $f_settings.demo            -text demo
    labelframe  $f_settings.scale           -text scale
        #
        #   variable contrSeg_l00     50  ;#   5     100
        #   variable contrSeg_r01     30  ;#  20     100
        #   variable contrSeg_a01     60  ;# -90      90
        #   variable contrSeg_l02    100  ;#  20     150
        #   variable contrSeg_r03     40  ;#  20     100
        #   variable contrSeg_a03    -20  ;# -90      90
        #   variable contrSeg_l04    100  ;#  20     150
        #   variable contrSeg_r05     20  ;#  20     100
        #   variable contrSeg_a05    -40  ;# -90      90
        #   variable contrSeg_l06    100  ;#  20     150

    view::create_config_line $f_settings.geometry.a_02     "HeadTube Angle: "    control::angle_HeadTube     65   80    ;#       72.5 
    view::create_config_line $f_settings.geometry.a_03     "TopTube Angle:  "    control::angle_TopTube      10  -10    ;#       2.5 
    view::create_config_line $f_settings.geometry.p_01     "SeatTube Offset:"    control::offset_SeatTube   -25   35    ;#        0 
    view::create_config_line $f_settings.geometry.p_02     "DownTube Offset:"    control::offset_DownTube   -25   35    ;#        0 
    view::create_config_line $f_settings.geometry.e_01     "SeatTube Extend:"    control::extend_SeatTube     0  120    ;#       20 
    view::create_config_line $f_settings.geometry.l_02     "HeadTube Length:"    control::length_HeadTube    90  190    ;#      150 
    view::create_config_line $f_settings.geometry.x_02     "HeadTube x:     "    control::x_HeadTube         410 500    ;#      436  436.1480445902127 
    view::create_config_line $f_settings.geometry.y_02     "HeadTube y:     "    control::y_HeadTube         380 480    ;#      413  413.4501048805116        
    view::create_config_line $f_settings.geometry.x_00     "RearDroput x:   "    control::x_RearDropout      350 450    ;#     -404 -404.6529377132952 
    view::create_config_line $f_settings.geometry.y_00     "RearDroput y:   "    control::y_RearDropout      -10  90    ;#       66   66.00        
    view::create_config_line $f_settings.geometry.x_01     "SeatPost x:     "    control::x_SeatPost         100 200    ;#      180 -180.00 
    view::create_config_line $f_settings.geometry.y_01     "SeatPost y:     "    control::y_SeatPost         500 700    ;#      630  630.00 

                             $f_settings.geometry.a_02.scl  configure   -resolution 0.1
                             $f_settings.geometry.a_03.scl  configure   -resolution 0.1
                             
        #
    button  $f_settings.config.type   -width 30  -text    "cone/cylinder" -command control::change_HeadTubeType
    pack $f_settings.config.type -side top  -fill x
        #  
        #
    button  $f_settings.project.bt_01   -text "project_01"    -command {::control::set_project project_01} 
    button  $f_settings.project.bt_02   -text "project_02"    -command {::control::set_project project_02} 
    button  $f_settings.project.bt_03   -text "config_01"     -command {::control::set_parameterList chainStay_01} 
    button  $f_settings.project.bt_04   -text "config_02"     -command {::control::set_parameterList chainStay_02} 
    button  $f_settings.project.bt_05   -text "config_03"     -command {::control::set_parameterList chainStay_03} 
    pack    $f_settings.project.bt_01 \
            $f_settings.project.bt_02 \
            $f_settings.project.bt_03 \
            $f_settings.project.bt_04 \
            $f_settings.project.bt_05   -side top   -expand yes -fill x
        #
        #
    pack    $f_settings.geometry        \
            $f_settings.config          \
            $f_settings.project         \
            $f_settings.debug           \
            $f_settings.pathLeft        \
            $f_settings.precission      \
            $f_settings.scale           \
            -fill x -side top 
                
    #view::create_config_line $f_settings.offsetLeft.y_00     "offset left:     "    control::offsetLeft        0 150    ;#   0
    #view::create_config_line $f_settings.offsetRight.y_00    "offset right:    "    control::offsetRight       0 150    ;#   0

        #
        ### -- G U I - canvas demo
        #   
    set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
        button  $f_demo.bt_clear   -text "clear"    -command {$::view::cvObject deleteContent} 
        button  $f_demo.bt_update  -text "update"   -command {control::updateStage}
     
    pack  $f_demo  -side top    -expand yes -fill x
        pack $f_demo.bt_clear   -expand yes -fill x
        pack $f_demo.bt_update  -expand yes -fill x
        
    radiobutton         $f_settings.debug.debug_on          -text "on          "  -variable  "control::debugMode"     -value  "on"        -command   "control::update"
    radiobutton         $f_settings.debug.debug_off         -text "off         "  -variable  "control::debugMode"     -value  "off"       -command   "control::update"

    view::create_config_line $f_settings.precission.prec    " precission:      "    control::arcPrecission  1.0  10.0   ;#  24
                        $f_settings.precission.prec.scl     configure   -resolution 1.0

    # view::create_config_line $f_settings.scale.drw_scale    " Drawing scale    "   control::drw_scale       0.2   2.0  
                        # $f_settings.scale.drw_scale.scl     configure   -resolution 0.1
    view::create_config_line $f_settings.scale.cv_scale     " Canvas scale     "   control::cv_scale        0.1   2.0  
                        $f_settings.scale.cv_scale.scl      configure   -resolution 0.1     -command {control::scale_board}
        # button        $f_settings.scale.recenter          -text "recenter"                -command {control::recenter_board}
    button              $f_settings.scale.refit             -text "refit"                   -command {control::refit_board}

    pack      \
            $f_settings.debug.debug_on \
            $f_settings.debug.debug_off \
            -side left
    pack      \
            $f_settings.precission.prec  \
            $f_settings.scale.cv_scale \
            $f_settings.scale.refit \
         -side top  -fill x                                                          
                     
     
        #
        ### -- G U I - canvas print
        #    
    set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
        button  $f_print.bt_print   -text "print"  -command {$view::cvObject print "E:/manfred/_devlp/_svn_sourceforge.net/cadCanvas/trunk/_print"} 
     
    pack $f_print   -side top   -expand yes -fill x
    pack $f_print.bt_print      -expand yes -fill x
    

    
    ####+### E N D
    
    update
    
    wm minsize . [winfo width  .]   [winfo height  .]
    wm title   . $windowTitle
    
    return . $cvObject

}
    #
    #
    #
variable model::bikeFrame  [[::bikeFrame::FrameFactory new] create]
    #
    
    
# exit    
    
    #
    # -- GUI --
    #
set returnValues [view::create $WINDOW_Title]
    # set control::cvObject [lindex $returnValues 1]
    #
control::refit_board
    #
    # $::view::cvObject reportXMLRoot
    #
control::set_project project_01
    #
    # set chainStay   [$model::bikeFrame getComponent ChainStay]
    #
    # $chainStay reportValues
    #
