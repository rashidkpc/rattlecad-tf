 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom.tcl
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
 #    namespace:  myGUI::cvCustom
 # ---------------------------------------------------------------------------
 #
 # 

    #
variable  myGUI::cvCustom::ctrl_Points
array set myGUI::cvCustom::ctrl_Points {}
    #
variable  myGUI::cvCustom::sect_Points
array set myGUI::cvCustom::sect_Points {}
    #
      
proc myGUI::cvCustom::createRearMockup {cvObject} {
    
    puts ""
    puts "   -------------------------------"
    puts "     myGUI::cvCustom::createRearMockup"
    puts "       cvObject:      $cvObject"
     
    variable    stageScale

    variable    BottomBracket   
    variable    RearWheel
    variable    Config

    array set   ChainStay       {}
    array set   Length          {}
    array set   Center          {}
    array set   ClearChainWheel {}             
    array set   ClearCassette   {}             
    array set   CrankSet        {}             
    
    array set   Color          {}
          set   Color(primary)     darkred
          set   Color(secondary)   darkorange
          set   Color(third)       orange
          set   Color(result)      darkblue
          set   Color(static)      gray10
        
    set Length(ChainStay)           [myGUI::model::model_XY::getScalar Geometry ChainStay_Length]
    set Length(CrankSet)            [myGUI::model::model_XY::getScalar CrankSet Length]
    set Length(PedalMount)    [expr [myGUI::model::model_XY::getScalar CrankSet Q-Factor] * 0.5]
    set Length(PedalEye)            [myGUI::model::model_XY::getScalar CrankSet PedalEye]
    set Length(CrankSet_ArmWidth)   [myGUI::model::model_XY::getScalar CrankSet ArmWidth]
    set Length(ChainLine)           [myGUI::model::model_XY::getScalar CrankSet ChainLine]
    set Length(ChainRingOffset)     [myGUI::model::model_XY::getScalar CrankSet ChainRingOffset]

         #   puts "     BottomBracket(Position) -> $BottomBracket(Position)"
         #   puts "     RearWheel(Position)    -> $RearWheel(Position)"
         #   puts "       -> $Length(ChainStay)"
            
         #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/Diameter/outside]"
         #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/Diameter/inside]"
         #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/Width]"
         #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/ChainStay/Offset_TopView]"
            
         #   puts "     RimDiameter   -> [rattleCAD__model__getValue Component/Wheel/Rear/RimDiameter]"
         #   puts "     RimHeight     -> [rattleCAD__model__getValue Component/Wheel/Rear/RimHeight]"
         #   puts "     TyreHeight    -> [rattleCAD__model__getValue Component/Wheel/Rear/TyreHeight]"
            
         #   puts "     HubWidth      -> [rattleCAD__model__getValue Lugs/RearDropOut/HubWidth]"
            
         #   puts "     ChainStay     -> [rattleCAD__model__getValue Lugs/RearDropOut/ChainStay/Offset]" 
         #   puts "     ChainStay     -> [rattleCAD__model__getValue Lugs/RearDropOut/ChainStay/Offset_TopView]" 
         #   puts "     ChainStay     -> [rattleCAD__model__getValue FrameTubes/ChainStay/Width]" 
    
         #   puts "  -> profile_x04   [rattleCAD__model__getValue FrameTubes/ChainStay/Profile/length_04] profile_x04   [rattleCAD__model__getValue FrameTubes/ChainStay/Profile/length_04]"

    set Length(00)              [ expr 0.5 * [myGUI::model::model_XY::getScalar BottomBracket OutsideDiameter] ]
    set Length(01)              [ expr 0.5 * [myGUI::model::model_XY::getScalar BottomBracket InsideDiameter] ]
    set Length(02)              [ expr 0.5 * [myGUI::model::model_XY::getScalar BottomBracket Width] ]
    set Length(03)              [ expr $Length(02) - [myGUI::model::model_XY::getScalar BottomBracket OffsetCS_TopView] ]
    set Length(04)              [ expr 0.5 * [myGUI::model::model_XY::getScalar RearWheel HubWidth] ]
    set Length(05)              [ expr 0.5 * [myGUI::model::model_XY::getScalar RearWheel HubWidth] + [myGUI::model::model_XY::getScalar RearDropout OffsetCS_TopView]]
    set Length(06)              [ expr 0.5 * [myGUI::model::model_XY::getScalar Geometry RearRim_Diameter] + [myGUI::model::model_XY::getScalar Geometry RearTyre_Height] - [myGUI::model::model_XY::getScalar RearWheel TyreWidthRadius]]

    
    set Center(BottomBracket)   {0 0}
    set Center(Dim_BBWidth_01)  [ list $Length(00) [expr -1.0 * $Length(02)] ]
    set Center(Dim_BBWidth_02)  [ list $Length(00) $Length(02) ]
    set Center(Dim_BBDiameter)  [ list [expr -1.0 * $Length(00)] $Length(02) ]
    set Center(Dim_BBDiam_01)   [ list $Length(01) $Length(02) ]
    set Center(Dim_BBDiam_02)   [ list [expr -1.0 * $Length(01)] $Length(02) ]
    set Center(RearHub)         [ list [expr -1 * $Length(ChainStay)] 0 ]
    set Center(Dim_RearHub_01)  [ list [expr -1 * $Length(ChainStay)] $Length(04) ]
    set Center(Dim_RearHub_02)  [ list [expr -1 * $Length(ChainStay)] [expr -1.0 * $Length(04)] ]
    set Center(CL_BB_01)        [ list 0 [expr -1.0 * $Length(04) -15] ]
    set Center(CL_BB_02)        [ list 0 [expr $Length(04) + 15] ]    
    set Center(CL_RearHub_01)   [ list [expr -1 * $Length(ChainStay)] [expr -1.0 * $Length(04) -15] ]
    set Center(CL_RearHub_02)   [ list [expr -1 * $Length(ChainStay)] [expr $Length(04) + 15] ]    
    set Center(DropOut)         [ list [expr -1 * $Length(ChainStay)] $Length(04) ]
    set Center(Fender)          [ vectormath::addVector $Center(RearHub)    [ list [myGUI::model::model_XY::getScalar RearFender Radius] 0 ] ]
    set Center(Tyre)            [ vectormath::addVector $Center(RearHub)    [ list [expr 0.5 * ([myGUI::model::model_XY::getScalar Geometry RearRim_Diameter] + [myGUI::model::model_XY::getScalar Geometry RearTyre_Height])] 0 ] ]
    set Center(Rim)             [ vectormath::addVector $Center(RearHub)    [ list [expr 0.5 *  [myGUI::model::model_XY::getScalar Geometry RearRim_Diameter]] 0 ] ]
    set Center(TyreWidth)       [ vectormath::addVector $Center(RearHub)    [ list [myGUI::model::model_XY::getScalar RearWheel TyreWidthRadius] 0 ] ]
    set Center(Dim_WheelRadius) [ vectormath::addVector $Center(Tyre)       [ list [expr 0.5 * [myGUI::model::model_XY::getScalar Geometry RearTyre_Height]] 0 ] ]
    set Center(Dim_Tyre_01)     [ vectormath::addVector $Center(TyreWidth)  [ list 0 [expr  0.5 * [myGUI::model::model_XY::getScalar RearWheel TyreWidth]] ] ]
    set Center(Dim_Tyre_02)     [ vectormath::addVector $Center(TyreWidth)  [ list 0 [expr -0.5 * [myGUI::model::model_XY::getScalar RearWheel TyreWidth]] 0 ] ]
    
    
    set Center(ChainStay_DO)    [ vectormath::addVector $Center(RearHub) [ list [myGUI::model::model_XY::getScalar RearDropout OffsetCS]  [ expr $Length(04) + [myGUI::model::model_XY::getScalar RearDropout OffsetCS_TopView]] ] ]
    set ChainStay(00)           [ list [expr -1.0 * $Length(01)] $Length(03) ] 
    set Center(ChainStay_00)    [ vectormath::cathetusPoint $Center(ChainStay_DO) $ChainStay(00) [expr 0.5 * [myGUI::model::model_XY::getScalar ChainStay WidthBB]] opposite ]

        #   puts "   -> Center(Tyre)  $Center(Tyre)"
    
    set ChainStay(91)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(05)] ]   ;# dimension: ChainStay Center DO
    set ChainStay(92)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(04)] ]   ;# dimension: Center DO
    set ChainStay(93)           [ list [expr -1.0 * $Length(01)] [expr -1 * $Length(03)] ]          ;# dimension: ChainStay outside BB
    set ChainStay(94)           [ list $Length(00)               [expr -1 * $Length(02)] ]          ;# dimension: Corner BB
    set ChainStay(95)           [ list [expr -1.0 * ($Length(ChainStay) - [myGUI::model::model_XY::getScalar RearDropout OffsetCS])] [expr -1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
    set ChainStay(96)           [ list [expr -1.0 * ($Length(ChainStay) - [myGUI::model::model_XY::getScalar RearDropout OffsetCS])] [expr  1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
                                
    set ChainStay(segRadius_01) [myGUI::model::model_XY::getScalar ChainStay segmentRadius_01]
    set ChainStay(segRadius_02) [myGUI::model::model_XY::getScalar ChainStay segmentRadius_02]
    set ChainStay(segRadius_03) [myGUI::model::model_XY::getScalar ChainStay segmentRadius_03]
    set ChainStay(segRadius_04) [myGUI::model::model_XY::getScalar ChainStay segmentRadius_04]
                                
        # -- create RearHub & CrankArm (position CrankArm on top at the end of procedure
    create_RearHub      $cvObject
        
        # -- CrankArm
    create_CrankArm     $cvObject
    
        # -- ChainStay Area      
    create_ClearArea    $cvObject

        # -- create DropOuts
    create_DropOut      $cvObject
    
        # -- create Tyre
    create_Tyre         $cvObject
    
    

        # -- create Bottom Bracket - Outer Shell
    set retValues [get_BottomBracket]
    set  BB_OutSide [lindex $retValues 0]
    set  BB_InSide  [lindex $retValues 1]
    $cvObject create rectangle   $BB_OutSide    -outline    $myGUI::view::edit::colorSet(frameTube_OL) \
                                                -fill       $myGUI::view::edit::colorSet(chainStay_1)  \
                                                -width 0.35 -tags __Lug__
                                                             #  -fill lightgray 

        # -- ChainStay Type
    switch [myGUI::model::model_XY::getConfig ChainStay] {
           {straight}   -
           {bent}       -
           {off}        {}
           default      { puts "\n  <W> ... not defined in createRearMockup: [myGUI::model::model_XY::getConfig ChainStay]\n"
                          # return
                        }
    }
    
        # -- format Values
    proc format_XspaceY {xyList} {
        set spaceList {}
        foreach {xy} $xyList {
            foreach {x y} [split $xy ,] break
            lappend spaceList $x $y
        }
        return $spaceList
    }
    
    
    
        # -- ChainStay
    switch [myGUI::model::model_XY::getConfig ChainStay] {
        {straight}   -
        {bent}  { 
            set ChainStay(start)           [myGUI::model::model_XY::getPosition     ChainStay_XY]
            set ChainStay(polygon)         [myGUI::model::model_XY::getPolygon      ChainStay_XY {0 0}]
            set ChainStay(ctrLines)        [myGUI::model::model_XY::getCenterLine   RearMockup_CtrLines]
            set ChainStay(centerLine)      [myGUI::model::model_XY::getCenterLine   RearMockup]
            set ChainStay(centerLineUnCut) [myGUI::model::model_XY::getCenterLine   RearMockup_UnCut]
                # 
            set ChainStay(centerLine)      [vectormath::addVectorCoordList $ChainStay(start) $ChainStay(centerLine)]
            set ChainStay(centerLineUnCut) [vectormath::addVectorCoordList $ChainStay(start) $ChainStay(centerLineUnCut)]
            set ChainStay(polygon)         [vectormath::addVectorCoordList $ChainStay(start) $ChainStay(polygon)]
                # 
                # puts "\n --> \$ChainStay(ctrLines) $ChainStay(ctrLines)"
            set tube_CS_left    [ $cvObject create polygon  $ChainStay(polygon)      -fill $myGUI::view::edit::colorSet(chainStay) \
                                                                                    -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                                                    -tags __Tube__ ]
            set polygon_opposite {}
            foreach {x y}  $ChainStay(polygon) {
                lappend polygon_opposite $x [expr -1.0 * $y]
            }  
            set tube_CS_right   [ $cvObject create polygon     $polygon_opposite     -fill $myGUI::view::edit::colorSet(chainStay) \
                                                                                    -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                                                    -tags {__Tube__} ]
              
            myGUI::gui::bind_objectEvent_2  $cvObject   $tube_CS_left       option_ChainStay
            myGUI::gui::bind_objectEvent_2  $cvObject   $tube_CS_right      option_ChainStay
                #
        }
        default    { 
            set ChainStay(polygon)      {} 
            set ChainStay(centerLine)   {}
        }
    }

       
       
       # -- finisch Bottom Bracket  - Inner Shell
    $cvObject create rectangle   $BB_InSide -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                            -fill $myGUI::view::edit::colorSet(chainStay_2) \
                                            -width 0.35 -tags __Lug__

       
        # -- create RearFender
    if {$Config(RearFender) eq {on}} {
            #
        set rearFender  [create_Fender $cvObject]
            #
    }
    
    
        # -- CenterLine
    if {$ChainStay(centerLine) ne {}} {
            #
        set tube_CS_CLine   [ $cvObject create centerline   $ChainStay(centerLine)  \
                                    -fill $myGUI::view::edit::colorSet(chainStay_CL) \
                                    -tags __CenterLine__ ]
            #
        myGUI::gui::bind_objectEvent_2  $cvObject   $tube_CS_CLine      option_ChainStay
            #
    }

       
       # -- create BrakeDisc
    if {$Config(BrakeRear) eq {Disc}} {
            #
        set brakeDisc [create_BrakeDisc $cvObject]
        myGUI::gui::bind_objectEvent_2  $cvObject   $brakeDisc       group_RearDiscBrake
            #
    }


       # -- create control Curves
    create_ControlCurves            $cvObject



       # -- create tubeProfile Edit
       # -- create centerLine Edit    
    switch -exact [myGUI::model::model_XY::getConfig ChainStay] {
        {bent} { create_centerLine_Edit   $cvObject  $ChainStay(ctrLines) {0 85}
            create_tubeProfile_Edit  $cvObject  {0 140}
        }
        default {
            create_tubeProfile_Edit  $cvObject  {0  90}
        }
    }

        # -- centerlines
    $cvObject create centerline     [appUtil::flatten_nestedList $Center(CL_BB_01)         $Center(CL_BB_02) ] \
                                                                    -fill gray50       -width 0.25     -tags __CenterLine__
    $cvObject create centerline     [appUtil::flatten_nestedList $Center(CL_RearHub_01)    $Center(CL_RearHub_02) ] \
                                                                    -fill gray50       -width 0.25     -tags __CenterLine__         
    $cvObject create centerline     [appUtil::flatten_nestedList $Center(BottomBracket) $Center(RearHub)] \
                                                                    -fill gray50       -width 0.25     -tags __CenterLine__
   

        # -- mark positions of dimensions
    $cvObject create circle      $ChainStay(96)          -radius 2   -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle      $ChainStay(95)          -radius 2   -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle      $ChainStay(93)          -radius 2   -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle      $Center(Dim_RearHub_01) -radius 2   -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle      $Center(Dim_RearHub_02) -radius 2   -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle      $Center(ChainLine)      -radius 1   -outline red         -width 0.35       -tags __CenterLine__
    
    $cvObject create circle      $Center(BottomBracket)  -radius 3   -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle      $Center(RearHub)        -radius 3   -outline blue        -width 0.35       -tags __CenterLine__

        # -- dimensions
        #

        # -- Wheel radius
    set _dim_Wh_Radius          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(CL_RearHub_01) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr   45 * $stageScale]   [expr -80 * $stageScale]  \
                                                                gray50]]
    set _dim_Rim_Radius         [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Rim) $Center(CL_RearHub_01) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr   35 * $stageScale]   [expr   0 * $stageScale]  \
                                                                gray50]]
    set _dim_Tyre_Height        [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(Rim) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr   35 * $stageScale]   [expr   0 * $stageScale]  \
                                                                gray50]]                                                                                                              
    set _dim_Sprocket_CL        [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_RearHub_02) $Center(SprocketClearance) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr  -25 * $stageScale]   [expr  -5 * $stageScale]  \
                                                                gray50]]
    set _dim_Tyre_CL            [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Tyre) $Center(TyreClearance) ] \
                                                            [list \
                                                                vertical \
                                                                [expr   65 * $stageScale]   [expr  20 * $stageScale]  \
                                                                gray50]]
    set _dim_Tyre_CapHeight     [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(TyreWidth) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr   25 * $stageScale]   [expr  20 * $stageScale]  \
                                                                $Color(result)]]                                                                                                              
    set _dim_Tyre_Width         [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_Tyre_01) $Center(Dim_Tyre_02) ] \
                                                            [list \
                                                                vertical \
                                                                [expr   35 * $stageScale]   [expr   3 * $stageScale]  \
                                                                $Color(primary)]]  
    set _dim_Tyre_Radius        [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(TyreWidth) $Center(CL_RearHub_01) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr   25 * $stageScale]   [expr  50 * $stageScale]  \
                                                                $Color(primary)]]   
            
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Tyre_CapHeight    single_Result_RearWheelTyreShoulder
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Tyre_Width        single_RearWheel_TyreWidth
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Tyre_Radius       single_RearWheel_TyreWidthRadius
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

        # -- ChainStay length
    set _dim_CS_Length          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(CL_RearHub_01) $Center(CL_BB_01) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr  30 * $stageScale]   [expr 0 * $stageScale]  \
                                                                $Color(result)]]
            
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_CS_Length         single_RearWheel_Distance
            

        # -- BottomBracket
    set _dim_BB_Diam_inside     [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_BBDiam_01) $Center(Dim_BBDiam_02) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr  20 * $stageScale]    [expr  35 * $stageScale]  \
                                                                $Color(primary)]] 
    set _dim_BB_Diam_outside    [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_BBWidth_02) $Center(Dim_BBDiameter) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr  35 * $stageScale]    [expr  35 * $stageScale]  \
                                                                $Color(primary)]]
    set _dim_BB_Width           [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_BBWidth_01) $Center(Dim_BBWidth_02) ] \
                                                            [list \
                                                                vertical \
                                                                [expr  35 * $stageScale]    [expr -10 * $stageScale]  \
                                                                $Color(primary)]]
    set _dim_CS_BB_Offset       [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $ChainStay(93) $ChainStay(94) ] \
                                                            [list \
                                                                vertical \
                                                                [expr -60 * $stageScale]    [expr  15 * $stageScale]  \
                                                                $Color(primary)]]
    
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_BB_Diam_inside    single_BottomBracket_InsideDiameter       
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_BB_Diam_outside   single_BottomBracket_OutsideDiameter   
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_BB_Width          single_BottomBracket_Width  
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_CS_BB_Offset      single_BottomBracket_CS_Offset_TopView   
            

            
        # -- BrakeDisc
    if {$Config(BrakeRear) eq {Disc}} {
            #
        set _dim_BrakeDisc_Dist_Hub [$cvObject create dimensionLength \
                                            [appUtil::flatten_nestedList   $Center(p_brakeDisc_03) $Center(Dim_RearHub_01) ] \
                                            [list \
                                                vertical \
                                                [expr   2 * $stageScale]    [expr  20 * $stageScale]  \
                                                $Color(primary)]] 
        set _dim_BrakeDisc_Dist_DO  [$cvObject create dimensionLength \
                                            [appUtil::flatten_nestedList   $Center(p_brakeDisc_01) $Center(Dim_RearHub_01) ] \
                                            [list \
                                                vertical \
                                                [expr  15 * $stageScale]    [expr -20 * $stageScale]  \
                                                $Color(result)]]                                                           
        set _dim_BrakeDisc_Diameter [$cvObject create dimensionLength \
                                            [appUtil::flatten_nestedList   $Center(CL_RearHub_02)  $Center(p_brakeDisc_01) ] \
                                            [list \
                                                horizontal \
                                                [expr -10 * $stageScale]    0 \
                                                $Color(primary)]]
            #                                    
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_BrakeDisc_Dist_Hub    single_RearHub_DiscOffset      
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_BrakeDisc_Diameter    single_RearHub_DiscDiameter 
            #
    }



        # -- RearHub
    set _dim_Hub_Width          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_RearHub_01) $Center(Dim_RearHub_02) ] \
                                                            [list \
                                                                vertical \
                                                                [expr  40 * $stageScale]    [expr -10 * $stageScale]  \
                                                                $Color(primary)]] 
    set _dim_CS_DO_Distance     [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(CL_RearHub_01) $ChainStay(95) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr  20 * $stageScale]    0  \
                                                                $Color(primary)]] 
    set _dim_CS_DO_Offset       [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $ChainStay(92) $ChainStay(95) ] \
                                                            [list \
                                                                vertical \
                                                                [expr -45 * $stageScale]    [expr -18 * $stageScale]  \
                                                                $Color(primary)]] 
            
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Hub_Width         single_RearHub_Width      
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_CS_DO_Distance    single_RearDropOut_CS_Offset    
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_CS_DO_Offset      single_RearDropOut_CS_OffsetTopView       

    
        # -- CrankSet
    set _dim_Crank_Length       [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Q_Factor) $Center(CL_BB_01) ] \
                                                            [list \
                                                                horizontal      [expr   25 * $stageScale]    [expr -30 * $stageScale]  \
                                                            $Color(primary)]]
    set _dim_PedalEye           [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(PedalEye) $Center(Q_Factor) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr   25 * $stageScale]    [expr   0 * $stageScale]  \
                                                                $Color(primary)]]
    set _dim_Crank_Q_Factor     [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(Dim_Q_Factor) $Center(PedalEye) ] \
                                                            [list \
                                                                vertical \
                                                                [expr   45 * $stageScale]    [expr  25 * $stageScale]  \
                                                                $Color(primary)]]
    set _dim_CrankArmWidth      [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(CrankArm) $Center(PedalEye) ] \
                                                            [list \
                                                                vertical \
                                                                [expr   10 * $stageScale]    [expr -15 * $stageScale]  \
                                                                $Color(primary)]]
                                                            
    set _dim_ChainLine          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $Center(BottomBracket) $Center(ChainLine) ] \
                                                            [list \
                                                                vertical \
                                                                [expr  -90 * $stageScale]    [expr  0 * $stageScale]  \
                                                                $Color(primary)]]
                                                            
        # -- create chainring offset dimension 
    if {[llength $Center(list_ChainRing)] > 1} {
        set pos_0 [lindex $Center(list_ChainRing) end-1]
        set pos_1 [lindex $Center(list_ChainRing) end]
        set _dim_ChainRingOffset [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $pos_0 $pos_1] \
                                                            [list \
                                                                vertical \
                                                                [expr -100 * $stageScale]    [expr 10 * $stageScale]  \
                                                                $Color(primary)]]
        myGUI::gui::bind_dimensionEvent_2   $cvObject $_dim_ChainRingOffset  single_CrankSet_ChainRingOffset       
    }

    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Crank_Length      single_CrankSet_Length        
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_PedalEye          single_CrankSet_PedalEye    
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Crank_Q_Factor    single_CrankSet_QFactor        
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_CrankArmWidth     single_CrankSet_ArmWidth    
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_ChainLine         single_CrankSet_ChainLine


    if {$ChainStay(centerLine) != {}} {
            #
        set pt_end  [lrange $ChainStay(centerLine) end-1 end]
        set pt_prev [lrange $ChainStay(centerLine) end-3 end-2]
            #
        set pt_cnt  [vectormath::intersectPoint $pt_prev $pt_end {0 0} {0 1}]
            #
        set pt_rf   [vectormath::addVector $pt_cnt {0 1}]
            #
            # puts "  ... \$ChainStay(centerLine)   $ChainStay(centerLine)"
            # puts "  ... \$pt_prev   $pt_prev"
            # puts "  ... \$pt_cnt    $pt_cnt"
            # puts "  ... \$pt_rf     $pt_rf"
            # puts "  ... \$pt_end    $pt_end"
            #
        set _dim_CS_Angle           [$cvObject create dimensionAngle \
                                                            [appUtil::flatten_nestedList  $pt_cnt $pt_rf $pt_prev] \
                                                            [list \
                                                                [expr  35 * $stageScale]   -10  \
                                                                $Color(result)]]
            #
        $cvObject create circle      $pt_cnt  -radius 1   -outline $Color(result)   -width 0.35 -tags __CenterLine__
            #
    }

        # -- create CrankArm
    $cvObject raise {__CrankArm__}
        #
        
        #
    return           
        #
}

proc myGUI::cvCustom::create_Tyre {cvObject} {
        #
    upvar  1 Length         Length
    upvar  1 Center         Center
    upvar  1 ClearCassette  ClearCassette
        #
        # -- tyre Representation 
    set tyre_RadiusHeight $Length(06)
    set tyre_RadiusWidth  [expr 0.5 * [myGUI::model::model_XY::getScalar RearWheel TyreWidth]]
    set tyre_00     [vectormath::addVector $Center(TyreWidth) [list $tyre_RadiusHeight [expr -1.0*$tyre_RadiusWidth] ]]
    set tyre_01     [vectormath::addVector $Center(TyreWidth) [list [expr -1.0*$tyre_RadiusHeight] $tyre_RadiusWidth ]]
    set ovalMatrix      [appUtil::flatten_nestedList  $tyre_00 $tyre_01 ]                     
    
    set tyre_04     [vectormath::addVector  $Center(TyreWidth)   {0 -1} $tyre_RadiusWidth]
    set tyre_05     [vectormath::addVector  $Center(RearHub)     [list 30 [expr -1.0 * $tyre_RadiusWidth] ] ]
    set tyre_06     [vectormath::addVector  $Center(RearHub)     {1 0}  35 ]
    set tyre_07     [vectormath::addVector  $Center(RearHub)     [list -35 $tyre_RadiusWidth] ]
    set tyre_08     [vectormath::addVector  $Center(TyreWidth)   {0 1} $tyre_RadiusWidth]
    set polygonMatrix   [appUtil::flatten_nestedList  $tyre_04  $tyre_05 $tyre_06 $tyre_07 $tyre_08 ]
    
    
                   $cvObject create oval     $ovalMatrix      -fill gray  -outline {}  -tags {__Component__}
    set _tyreObj [ $cvObject create polygon  $polygonMatrix   -fill gray  -outline {}  -tags {__Component__}]
    
                   $cvObject create ovalarc  $ovalMatrix      -outline black  -width 0.35  -tags {__Component__} \
                                                                 -start 270     -extent 180       -style arc
                   $cvObject create line     $polygonMatrix   -fill black  -width 0.35  -tags {__Component__}
    
    myGUI::gui::bind_objectEvent_2  $cvObject   $_tyreObj   group_RearTyre_Parameter
                                                                                                                                                                                                                                                    
}    

proc myGUI::cvCustom::create_RearHub {cvObject} {
        #
    upvar  1 Length         Length
    upvar  1 Center         Center
    upvar  1 ClearCassette  ClearCassette

    variable    Config
    
        #
        set length03                [ expr 0.5 *  18]
        set pointList               [ vectormath::addVectorCoordList $Center(RearHub) [list [expr -1*$length03] [expr -1*$Length(04)] $length03 $Length(04)] ]
    set hubRep          [ $cvObject create rectangle   $pointList           -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                                            -width 0.35   -tags __CenterLine__ ]
             
    
       # -- rear hub representation
    set myAngle         0
    set myPosition      $Center(RearHub)
        #
    switch -exact -- $Config(BrakeRear) {
        Disc {
            set myNode  [myGUI::model::model_XY::getComponent RearHub_Disc]
        } 
        default {
            set myNode  [myGUI::model::model_XY::getComponent RearHub]
        }
    }
    set myObject        [$cvObject create svg  $myPosition [list -svgNode $myNode  -angle $myAngle  -tags __HubRear__]]
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    myGUI::gui::bind_objectEvent_2  $cvObject   $myObject      option_RearBrakeType    
        #
        
        # -- create first Sprocket of Cassete
    set sp_position     [ vectormath::addVector  $Center(RearHub) {0 1} [ expr -1 * ($Length(04) - 3) ] ]
    set sp_object       [ get_ChainWheel [myGUI::model::model_XY::getScalar RearWheel FirstSprocket] 2 $sp_position ]
    set sp_polygon      [ lindex $sp_object 1 ]
    set sp_clearance    [ lindex $sp_object 2 ]
    set sprocketRep     [ $cvObject create polygon     $sp_polygon     -fill gray -outline black  -tags __Component__ ]
    
    set ClearCassette(1)    $sp_clearance
    
    myGUI::gui::bind_objectEvent_2  $cvObject   $hubRep         group_RearHub_Parameter
    
    myGUI::gui::bind_objectEvent_2  $cvObject   $sprocketRep    single_RearHub_FirstSprocket
    
    return
}

proc myGUI::cvCustom::create_DropOut {cvObject} {   
        #
    upvar  1 Length     Length
    upvar  1 Center     Center
        #
    set offset_DropOut  [myGUI::model::model_XY::getScalar  RearDropout OffsetCS]
    
        set x1                  [ expr [lindex $Center(RearHub) 0] -10 ]
        set x2                  [ expr [lindex $Center(RearHub) 0] +10 ]
        set y1                  $Length(04)
        set y2                  [ expr $Length(04) + 6 ]
        
        set pointList           [ list $x1 $y1 $x2 $y2 ]
    $cvObject create rectangle   $pointList            -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                         -fill $myGUI::view::edit::colorSet(chainStay_1)  \
                                                         -width 0.35 -tags __Lug__
        set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
    $cvObject create rectangle   $pointList            -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                         -fill $myGUI::view::edit::colorSet(chainStay_1) \
                                                         -width 0.35 -tags __Lug__
    
        set x1                  [ expr [lindex $Center(RearHub) 0] -14 ]
        set x2                  [ expr [lindex $Center(RearHub) 0] + $offset_DropOut + 10 ]
        set y1                  [ expr $Length(04) + 1 ]
        set y2                  [ expr $Length(04) + 5 ]
        set pointList           [ list $x1 $y1 $x2 $y2 ]
    $cvObject create rectangle   $pointList            -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                         -fill $myGUI::view::edit::colorSet(chainStay) \
                                                         -width 0.35 -tags __Lug__
        set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
    $cvObject create rectangle   $pointList            -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                                                         -fill $myGUI::view::edit::colorSet(chainStay) \
                                                         -width 0.35 -tags __Lug__
}

proc myGUI::cvCustom::create_BrakeDisc {cvObject} {
        #
    upvar  1 Length     Length
    upvar  1 Center     Center
    upvar  1 ChainStay  ChainStay
        #
    set pos_00 [list [expr -1 * $Length(ChainStay)] $Length(04)]
        #
    set disc_Offset         [myGUI::model::model_XY::getScalar RearMockup DiscOffset]
    set disc_Width          [myGUI::model::model_XY::getScalar RearBrake  DiscWidth]
    set disc_DiameterDisc   [myGUI::model::model_XY::getScalar RearBrake  DiscDiameter]
    set clearanceRadius     [myGUI::model::model_XY::getScalar RearMockup DiscClearance]
        #
    set pos_02  [vectormath::rotateLine $pos_00 $disc_Offset -90]
    set pos_01  [vectormath::rotateLine $pos_02 $disc_Width   90]
        #
    set p_00    [vectormath::addVector $pos_01 {-37 0}]
    set p_01    [vectormath::addVector $pos_01 [list [expr 0.5 * $disc_DiameterDisc] 0]]
    set vct_00  [vectormath::parallel   $p_00 $p_01 $disc_Width]
        #
    foreach {p_03 p_02}  $vct_00 break
    set pointList [list $p_00 $p_02]
        #
    set p_04    [vectormath::addVector  $p_03 {7 0}]
    set p_05    [vectormath::addVector  $p_04 {0 0.7}]
        #
    set pointList [appUtil::flatten_nestedList $p_00 $p_01 $p_02 $p_04 $p_05]

        # -- draw brake disc
    set object [$cvObject create polygon   $pointList -outline black     -fill gray  -width 0.35 -tags __Component__]
        # -- draw clearance arc
    $cvObject create arc         $p_01      -radius $clearanceRadius -start 310  -extent 190 -style arc -outline red  -tags __CenterLine__
        #
    set Center(p_brakeDisc_01)  $p_01
    set Center(p_brakeDisc_02)  $p_02
    set Center(p_brakeDisc_03)  $p_04
        #
    return $object
        #
}

proc myGUI::cvCustom::create_CrankArm {cvObject} {
        #
    variable BottomBracket    
        #
        #
    upvar  1 stageScale         stageScale
    
    upvar  1 Length             Length
    upvar  1 Center             Center
    upvar  1 ClearChainWheel    ClearChainWheel
        #
        #
    set myNode      [myGUI::model::model_XY::getComponent   CrankSet]
    set myPosition  {0 0}
    set myAngle     0
    set myObject    [$cvObject create svg  $myPosition [list -svgNode $myNode  -angle $myAngle  -tags __CrankArm__]]
        #
    foreach cv_Item [$cvObject find withtag __CrankArm__] {
        set cv_Type     [$cvObject type $cv_Item]
        catch {$cvObject itemconfigure  $cv_Item -fill gray -outline black}
    }      
        #
    $cvObject addtag  __Component__ withtag $myObject
        #
    myGUI::gui::bind_objectEvent_2  $cvObject   $myObject     group_Crankset_Parameter                        
        #
        
        #                                
        # -- centerline of pedal axis
    set pt_00       [ list [expr -1.0 * $Length(CrankSet)] [expr -1.0 * $Length(PedalMount) + $Length(CrankSet_ArmWidth) + 10] ]
    set pt_01       [ list [expr -1.0 * $Length(CrankSet)] [expr -1.0 * $Length(PedalMount) + $Length(CrankSet_ArmWidth)] ]
    set pt_02       [ list [expr -1.0 * $Length(CrankSet)] [expr -1.0 * $Length(PedalMount)]]
    set pt_03       [ list [expr -1.0 * $Length(CrankSet)] [expr -1.0 * ($Length(PedalMount) + 10)] ]
    set pt_11       [ vectormath::addVector $pt_01 [list [expr -1.0 * $Length(PedalEye)] 0] ]
    set pt_12       [ vectormath::addVector $pt_02 [list [expr -1.0 * $Length(PedalEye)] 0] ]
        #
    $cvObject create centerline     [appUtil::flatten_nestedList $pt_00 $pt_03 ] \
                                                                     -fill gray50       -width 0.25     -tags {__CenterLine__ __CrankArm__}


        # -- global points
    set Center(Dim_Q_Factor)    [ list [expr -1.0 * $Length(CrankSet)] 0 ]
    set Center(Q_Factor)        $pt_02 
    set Center(CrankArm)        $pt_11 
    set Center(PedalEye)        $pt_12 
    set Center(ChainLine)       [ list 0 [expr -1.0 * $Length(ChainLine) ] ]
    set Center(list_ChainRing)  {}


        # -- create chainwheels
    set chainLine           [myGUI::model::model_XY::getScalar CrankSet ChainLine]
    set chainWheelDistance  [myGUI::model::model_XY::getScalar CrankSet ChainRingOffset]
    set chainWheelWidth     2
    set list_ChainRings     [lsort [myGUI::model::model_XY::getListValue CrankSetChainRings]]
        # puts "  <D> create_CrankArm: [llength $list_ChainRings]"

    switch [llength $list_ChainRings] {
        3   {   set chainWheelPos   [list 0 [expr -1 * ($chainLine -       $chainWheelDistance)]] }
        2   {   set chainWheelPos   [list 0 [expr -1 * ($chainLine - 0.5 * $chainWheelDistance)]] }
        1   {   set chainWheelPos   [list 0 [expr -1 * $chainLine]] }
        default {
                set chainWheelPos   [list 0 [expr -1 * $chainLine]]
                set list_ChainRings {}
                tk_messageBox -message "max ChainWheel amount: 3\n      given Arguments: $list_ChainRings"
            }
    }
    
    set cw_Clearance    {}
    set cw_index        0
    foreach teethCount $list_ChainRings {
            set cw_object       [ get_ChainWheel $teethCount  $chainWheelWidth  $chainWheelPos ]
            set cw_clearance    [ lindex $cw_object 0 ]
            set cw_polygon      [ lindex $cw_object 1 ]
                #
            lappend Center(list_ChainRing) $chainWheelPos
                # -- position of next chainwheel
            set chainWheelPos   [ vectormath::addVector $chainWheelPos {0 -1} $chainWheelDistance ]
                
                # -- add position to ClearChainWheel
            incr cw_index
            set ClearChainWheel($cw_index)    $cw_clearance
    }
   
    return
}

proc myGUI::cvCustom::create_Fender {cvObject} {
        #
    variable BottomBracket    
        #
        #
    upvar  1 stageScale         stageScale
    upvar  1 Color              Color
    
    upvar  1 Length             Length
    upvar  1 Center             Center
    upvar  1 ClearChainWheel    ClearChainWheel
        #
        #
    set myNode      [myGUI::model::model_XY::getComponent   RearFender_XY]
    set myPosition  $Center(RearHub)
    set myAngle     0
    set myObject    [$cvObject create svg  $myPosition [list -svgNode $myNode  -angle $myAngle  -tags __RearFender__]]
        #
    foreach cv_Item [$cvObject find withtag __RearFender__] {
        set cv_Type     [$cvObject type $cv_Item]
        catch {$cvObject itemconfigure  $cv_Item  -fill gray  -outline darkred  -width 1.0}
    }      
        #
    $cvObject addtag  __Component__ withtag $myObject
        #
    myGUI::gui::bind_objectEvent_2      $cvObject   $myObject   group_RearFender_Parameter_01
        #
        
        #
    set _dim_Offset     [$cvObject create dimensionLength \
                                                        [appUtil::flatten_nestedList   $Center(Fender)  $Center(Dim_WheelRadius)] \
                                                        [list \
                                                            horizontal \
                                                            [expr 45 * $stageScale]    [expr 10 * $stageScale]  \
                                                            $Color(result)]]
    myGUI::gui::bind_dimensionEvent_2   $cvObject $_dim_Offset  group_RearFender_Parameter_01       
        #
        
        #
    return
        #
}

proc myGUI::cvCustom::create_ClearArea {cvObject} {
        #
    upvar  1 stageScale stageScale
        #
    upvar  1 Length             Length
    upvar  1 Center             Center
    upvar  1 ChainStay          ChainStay
    upvar  1 ClearChainWheel    ClearChainWheel
    upvar  1 ClearCassette      ClearCassette
        #
        # -- define ClearArea Polygon
        #
    set polygon     {}
        #
        # -- Tyre clearance
    set tyreHeight  $Length(06)
    set clearRadius [ expr  $tyreHeight + [myGUI::model::model_XY::getScalar RearMockup TyreClearance] ]
    set clearWidth  [ expr  0.5 * [myGUI::model::model_XY::getScalar RearWheel TyreWidth]  + [myGUI::model::model_XY::getScalar RearMockup TyreClearance] ]
    set pt_99       [ vectormath::addVector  $Center(TyreWidth)  {0 -1} $clearRadius ]
    set pt_98       [ vectormath::addVector  $pt_99  {-70 0} ]
        #
    lappend polygon     $pt_98  $pt_99
        #
    set angle 0
    while {$angle <= 90} {
        set pt_tmp  [ vectormath::rotatePoint  $Center(TyreWidth) $pt_99 $angle]
          # puts "             -> $ext_Center(Tyre)  /  $ext_Center(TyreWidth)"
          # TyreWidth
        lappend polygon     $pt_tmp
        incr angle 10
    }
    # --- handling tyreWidth
    set ratio       [expr $clearWidth / $clearRadius]
    set newPolygon {}
    foreach xy $polygon {
        foreach {x y} $xy break
        set y [expr $ratio*$y]
        lappend newPolygon [list $x $y]
    }
        #
    set polygon $newPolygon
        #
        #
    set Center(TyreClearance)  [ vectormath::addVector  $Center(Tyre)  {0 -1} $clearWidth ]
    
        # -- BB clearance
            set pt_01       [ list   [lindex $ChainStay(00) 0] 0 ]
    lappend polygon     $pt_01
            set pt_02       [ vectormath::mirrorPoint {0 0} {1 0} $ChainStay(00) ] 
                #[ list   [lindex $ext_ChainStay(00) 0] [expr -1 * [lindex $ext_ChainStay(00) 1]] ]     
    lappend polygon     $pt_02
            
        # -- ChainWheel clearance
            set name        [ lindex [array names ClearChainWheel] 0 ]        
            set pt_cw1      $ClearChainWheel($name)
            set pt_03       [ vectormath::cathetusPoint  $pt_02  $pt_cw1  [myGUI::model::model_XY::getScalar RearMockup ChainWheelClearance] opposite ]
    lappend polygon     $pt_03
            
        # -- # -- second & third ChainWheel
            set pt_last $pt_cw1
            foreach name [lrange [array names ClearChainWheel] 1 end] {
                    set pt_tmp  $ClearChainWheel($name)
                    set vct_tmp [ vectormath::parallel $pt_last $pt_tmp [myGUI::model::model_XY::getScalar RearMockup ChainWheelClearance] ]
                    lappend polygon     [lindex $vct_tmp 0] [lindex $vct_tmp 1]
                    set pt_last $pt_tmp
            }
    
        # -- CrankArm clearance
            set delta       [ expr   [myGUI::model::model_XY::getScalar RearMockup CrankClearance] - [myGUI::model::model_XY::getScalar RearMockup ChainWheelClearance] ]
            set pt_ca       [ vectormath::cathetusPoint  $pt_last  $Center(CrankArm)  $delta opposite ]
            set vct_tmp     [ vectormath::parallel $pt_last $pt_ca  [myGUI::model::model_XY::getScalar RearMockup ChainWheelClearance] ]
    lappend polygon     [ lindex $vct_tmp 0 ] [ lindex $vct_tmp 1 ]
            set clearRadius [myGUI::model::model_XY::getScalar RearMockup CrankClearance]
            set pt_st       [ vectormath::addVector  $Center(CrankArm)  {0 1}  $clearRadius ]
            set dirAngle    [ expr [vectormath::dirAngle   [lindex $vct_tmp 0] [lindex $vct_tmp 1]] -180 ]
                # puts "     -> dirAngle $dirAngle"
            set angle       0
            while {$angle <= 90} {
                    if {$angle >= $dirAngle} {
                        set pt_tmp  [ vectormath::rotatePoint  $Center(CrankArm) $pt_st $angle]
                        lappend polygon     $pt_tmp
                    }
                    incr angle 10
            }
            set pt_04       [ vectormath::addVector [lindex $polygon end] {0 -15} ]
    lappend polygon     $pt_04                  
    
        # -- Casette clearance
            set pt_sp       [ vectormath::addVector  $ClearCassette(1)  {  1   0}  [myGUI::model::model_XY::getScalar RearMockup CassetteClearance] ]
            
            set pt_11       [ vectormath::addVector  $pt_sp                 {  0   2} ]
            set pt_12       [ vectormath::addVector  $pt_11                 { 45  25} ]
            
            set pt_08       [ vectormath::addVector  $pt_sp                 {  0  -2} ]
            set pt_07       [ list [lindex $Center(ChainStay_DO) 0]  [ lindex $pt_08 1] ]
            # set pt_07     [ vectormath::addVector  $pt_08                 {-20   0} ]
            set pt_06       [ vectormath::addVector  $pt_07                 {  0 -20} ]
            set pt_05       [ vectormath::addVector  $pt_06                 { 40   0} ]
    lappend polygon     $pt_05  $pt_06  $pt_07  $pt_08  $pt_11  $pt_12                     
            set Center(SprocketClearance)        $pt_sp 
    
    
        # -- create chainstay Area
        #
    set             polygon     [appUtil::flatten_nestedList    $polygon ]
    
    set chainstayArea   [ $cvObject create polygon     $polygon \
                                -fill $myGUI::view::edit::colorSet(chainStayArea) \
                                -outline black  \
                                -tags __CenterLine__ ]

    myGUI::gui::bind_objectEvent_2  $cvObject   $chainstayArea   group_ChainStay_Area
    return
}

proc myGUI::cvCustom::create_ControlCurves {cvObject} {
        #
    upvar  1 stageScale stageScale
        #
    upvar  1 Length             Length
    upvar  1 Center             Center
    upvar  1 ChainStay          ChainStay
    upvar  1 ClearChainWheel    ClearChainWheel
    upvar  1 ClearCassette      ClearCassette
        #

        #
        # -- Tyre Clearance
    set radius_y      [expr  0.5 * [myGUI::model::model_XY::getScalar RearWheel TyreWidth]  + [myGUI::model::model_XY::getScalar RearMockup TyreClearance] ]
    set radius_x      [expr  $Length(06)                                  + [myGUI::model::model_XY::getScalar RearMockup TyreClearance] ]
    set tyre_00       [vectormath::addVector $Center(TyreWidth) [list $radius_x [expr -1.0*$radius_y] ]]
    set tyre_01       [vectormath::addVector $Center(TyreWidth) [list [expr -1.0*$radius_x] $radius_y ]]                     
    set clearMatrix   [appUtil::flatten_nestedList  $tyre_00 $tyre_01 ]
    
    $cvObject create ovalarc  $clearMatrix       -start 250  -extent 220 -style arc -outline red  -tags __CenterLine__
    
        # -- ChainWheel Clearance
    set radius  [myGUI::model::model_XY::getScalar RearMockup ChainWheelClearance]
    foreach name [array names ClearChainWheel] {
            # puts "   --> $name  $ext_ClearChainWheel($name)"
        set position    $ClearChainWheel($name)
        $cvObject create arc      $position  -radius $radius -start 30  -extent 180 -style arc -outline red  -tags __CenterLine__
    }
    
        # -- CrankArm Clearance
    set radius  [myGUI::model::model_XY::getScalar RearMockup CrankClearance]
    set position    $Center(CrankArm)
    $cvObject create arc      $position  -radius $radius  -start 30  -extent 180  -style arc  -outline red  -tags __CenterLine__
    
        # -- Casette clearance
    set radius  [myGUI::model::model_XY::getScalar RearMockup CassetteClearance]
    set position    $ClearCassette(1)
    $cvObject create arc  $position  -radius $radius  -start 280  -extent 80  -style arc  -outline red  -tags __CenterLine__
    $cvObject create arc  $position  -radius $radius  -start   0  -extent 80  -style arc  -outline red  -tags __CenterLine__

    return
}

proc myGUI::cvCustom::create_tubeProfile_Edit {cvObject offset} {
        #
    variable sect_Points
        #
    upvar  1 stageScale stageScale
        #
    upvar  1 Length     Length
    upvar  1 Center     Center
    upvar  1 ChainStay  ChainStay
        #
    upvar  1 Color      Color
        #
        #
    set profile_y00   [myGUI::model::model_XY::getScalar ChainStay profile_y00]
    set profile_x01   [myGUI::model::model_XY::getScalar ChainStay profile_x01]
    set profile_y01   [myGUI::model::model_XY::getScalar ChainStay profile_y01]
    set profile_x02   [myGUI::model::model_XY::getScalar ChainStay profile_x02]
    set profile_y02   [myGUI::model::model_XY::getScalar ChainStay profile_y02]
    set profile_x03   [myGUI::model::model_XY::getScalar ChainStay profile_x03]
    set profile_y03   [myGUI::model::model_XY::getScalar ChainStay WidthBB]
        # set profile_y03   [myGUI::model::model_XY::getScalar ChainStay profile_y03]
    set profile_xcl   [myGUI::model::model_XY::getScalar ChainStay completeLength]
        #
        # puts "$profile_y00"
        # puts "$profile_x01"
        # puts "$profile_y01"
        # puts "$profile_x02"
        # puts "$profile_y02"
        # puts "$profile_x03"
        # puts "\$profile_y03 $profile_y03"
        #
        #
    set cuttingLeft   [myGUI::model::model_XY::getScalar ChainStay cuttingLeft]
    set cuttingLength [myGUI::model::model_XY::getScalar ChainStay cuttingLength]   
        #
        # set p00  [list [expr -1 * $ext_Length(ChainStay)] 0]
    set p0    [vectormath::addVector $Center(ChainStay_DO)  $offset]
    set p1    [vectormath::addVector  $p0  [list $profile_x01   0]]
    set p2    [vectormath::addVector  $p1  [list $profile_x02   0]]
    set p3    [vectormath::addVector  $p2  [list $profile_x03   0]]
    set p4    [vectormath::addVector  $p0  [list $profile_xcl   0]]
        # 
    set p_cutLeft  [vectormath::addVector  $p0         [list $cuttingLeft   0]]
    set p_cutRight [vectormath::addVector  $p_cutLeft  [list $cuttingLength 0]]
        #
        # puts " .. ChainStay - TubeProfile: [appUtil::flatten_nestedList $p0 $p1 $p2 $p3 $p4]"
    
    set p00 [vectormath::addVector $p0  [list 0 [expr  0.5 * $profile_y00]]]
        #
    set chainStayProfile_north [myGUI::model::model_XY::getProfile ChainStay_XY]
    set chainStayProfile_south {} 
    foreach {x y} $chainStayProfile_north {
        set y [expr -1 * $y]
        lappend chainStayProfile_south [list $x $y]
    }
        #
    set chainStayProfile $chainStayProfile_north
        #
    foreach {xy} [lreverse $chainStayProfile_south] {
        foreach {x y} $xy break
        lappend chainStayProfile $x $y
    }
        #
    set chainStayProfile [vectormath::addVectorCoordList $p0 $chainStayProfile]
        #
    $cvObject  create polygon \
                        $chainStayProfile    \
                        -fill $myGUI::view::edit::colorSet(chainStay) \
                        -outline $myGUI::view::edit::colorSet(frameTube_OL) \
                        -tags __CenterLine__
        #
    #$cvObject  create   centerline \
                        [appUtil::flatten_nestedList $p0 $p4] \
                        -fill $myGUI::view::edit::colorSet(chainStay_CL) \
                        -tags __CenterLine__   
        #
    set textPosition [vectormath::addVector $p0  [list -70 -2.5]]
    set item    [$cvObject create draftText $textPosition -text "ChainStay Profile" -size [expr 5*$stageScale]]
    $cvObject   addtag __CenterLine__ withtag  $item
        #
        #
    set p01 [vectormath::addVector $p1  [list 0 [expr  0.5 * $profile_y01]]]
    set p02 [vectormath::addVector $p2  [list 0 [expr  0.5 * $profile_y02]]]
    set p03 [vectormath::addVector $p3  [list 0 [expr  0.5 * $profile_y03]]]
    set p04 [vectormath::addVector $p4  [list 0 [expr  0.5 * $profile_y03]]]
        #
    set p14 [vectormath::addVector $p4  [list 0 [expr -0.5 * $profile_y03]]]
    set p13 [vectormath::addVector $p3  [list 0 [expr -0.5 * $profile_y03]]]
    set p12 [vectormath::addVector $p2  [list 0 [expr -0.5 * $profile_y02]]]
    set p11 [vectormath::addVector $p1  [list 0 [expr -0.5 * $profile_y01]]]
    set p10 [vectormath::addVector $p0  [list 0 [expr -0.5 * $profile_y00]]]
        #
        #
    $cvObject create circle     $p00       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p01       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p02       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p03       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p10       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p11       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p12       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
    $cvObject create circle     $p13       -radius 1  -outline red         -width 0.35       -tags __CenterLine__
        #
        # -- define display length
        # set sectArea_01 [myGUI::cvCustom::create_sectionField  $ext_cvName  $p_cutLeft   __dragObject__]                                    
        # set sectArea_02 [myGUI::cvCustom::create_sectionField  $ext_cvName  $p_cutRight  __dragObject__]                                    
        # set sectArea_01 [myGUI::cvCustom::create_sectionField  $ext_cvName  $p_cutLeft ]                                    
    set sectArea_02 [myGUI::cvCustom::create_sectionField  $cvObject  $p_cutRight]                                    
        #
    set sect_Points(0)   $p0
    set sect_Points(1)   $p_cutLeft
    set sect_Points(2)   $p_cutRight
        #

        # -- dimension
    set _dim_x0          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p0 $p4 ] \
                                                            [list \
                                                                horizontal \
                                                                [expr -38 * $stageScale]   0 \
                                                                $Color(result)]]
    set _dim_x1          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p0 $p1 ] \
                                                            [list \
                                                                horizontal \
                                                                [expr -25 * $stageScale]   0 \
                                                                $Color(result)]]
    set _dim_x2          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p1 $p2 ] \
                                                            [list \
                                                                horizontal \
                                                                [expr -25 * $stageScale]   0 \
                                                                $Color(result)]]
    set _dim_x3          [$cvObject create dimensionLength  \
                                                            [appUtil::flatten_nestedList   $p2 $p3 ] \
                                                            [list \
                                                                horizontal \
                                                                [expr -25 * $stageScale]   0 \
                                                                $Color(result)]]
      
        # -- cutting Length
        # set _dim_c1      [ $ext_cvName dimension  length      [appUtil::flatten_nestedList   $sect_Points(0) $sect_Points(1) ] \
                                                            horizontal    [expr -25 * $ext_stageScale]   0 \
                                                            $Color(result) ]
    set _dim_c2          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $sect_Points(1) $sect_Points(2) ] \
                                                            [list \
                                                                horizontal \
                                                                [expr  25 * $stageScale]   0 \
                                                                $Color(static)]]
      
        # --
    set _dim_w0          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p00 $p10 ] \
                                                            [list \
                                                                vertical \
                                                                [expr  15 * $stageScale]    0 \
                                                                $Color(result)]]
    set _dim_w1          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p01 $p11 ] \
                                                            [list \
                                                                vertical \
                                                                [expr  15 * $stageScale]    0 \
                                                                $Color(result)]]
    set _dim_w2          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p02 $p12 ] \
                                                            [list \
                                                                vertical \
                                                                [expr  15 * $stageScale]    0 \
                                                                $Color(result)]]
    set _dim_w3          [$cvObject create dimensionLength \
                                                            [appUtil::flatten_nestedList   $p03 $p13 ] \
                                                            [list \
                                                                vertical \
                                                                [expr -30 * $stageScale]    0 \
                                                                $Color(result)]]
        #
    $cvObject raise $sectArea_02
        #
      
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_x0     single_ChainStay_ProfileLengthComplete
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_x1     single_ChainStay_ProfileLength_01
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_x2     single_ChainStay_ProfileLength_02
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_x3     single_ChainStay_ProfileLength_03
        #                                                           
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_w0     single_ChainStay_ProfileWidth_00
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_w1     single_ChainStay_ProfileWidth_01
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_w2     single_ChainStay_ProfileWidth_02
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_w3     single_ChainStay_ProfileWidth_03
        #
    return
        #
}

proc myGUI::cvCustom::create_centerLine_Edit {cvObject ctrLines offset} {
        #
    variable ctrl_Points

    upvar  1 stageScale stageScale

    upvar  1 Length     Length
    upvar  1 Center     Center
    upvar  1 ChainStay  ChainStay

    upvar  1 Color      Color

        #
    set offset  [vectormath::addVector $Center(ChainStay_DO)  $offset]
        #
    set textPosition [vectormath::addVector $offset  [list -70 -2.5]]
    set item    [$cvObject create draftText $textPosition -text "ChainStay CenterLine" -size [expr 5*$stageScale]]
    $cvObject   addtag __CenterLine__ withtag  $item
        #

        # -- get control Line - Points
    set i 0
    foreach {x y} $ctrLines {
        set p$i [vectormath::addVector [list $x $y] $offset]
        incr i
        # puts "    -> $i"
    }
                                 
    set ctrl_p0 $p0
    set ctrl_p1 [vectormath::intersectPoint $p0 $p1  $p2 $p3 center]
    set ctrl_p2 [vectormath::intersectPoint $p2 $p3  $p4 $p5 center]
    set ctrl_p3 [vectormath::intersectPoint $p4 $p5  $p6 $p7 center]
    set ctrl_p4 [vectormath::intersectPoint $p6 $p7  $p8 $p9 center]
    set ctrl_p5 $p9
    
    set ctrl_Points(0)  $p0  
    set ctrl_Points(1)  [vectormath::intersectPoint $p0 $p1  $p2 $p3 center]  
    set ctrl_Points(2)  [vectormath::intersectPoint $p2 $p3  $p4 $p5 center]  
    set ctrl_Points(3)  [vectormath::intersectPoint $p4 $p5  $p6 $p7 center]  
    set ctrl_Points(4)  [vectormath::intersectPoint $p6 $p7  $p8 $p9 center] 
    set ctrl_Points(5)  $p9 
    set ctrl_Points(6)  [vectormath::addVector $p9 {20 0}]
    
    set offset_dropOut [expr [myGUI::model::model_XY::getScalar BottomBracket OffsetCS_TopView] + 0.5 * [myGUI::model::model_XY::getScalar RearWheel HubWidth] ]
    
    set base_p0 [list [lindex $ctrl_p0 0] [expr [lindex $ctrl_p0 1] - $offset_dropOut]]
        # set base_p5 [list [lindex $ctrl_p5 0] [lindex $base_p0 1]]
    set base_p5 [list 0 [lindex $base_p0 1]]
    set base_p0 [vectormath::addVector $base_p0 {150 0}]
    set base_p5 [vectormath::addVector $base_p5 { 40 0}]
    
        # -- draw base line
    set base_Line   [$cvObject create centerline [appUtil::flatten_nestedList $base_p0 $base_p5]   -tags __CenterLine__   -fill gray50]
 
        # -- draw drag areas
    set ctrlArea_01 [myGUI::cvCustom::create_controlField  $cvObject  $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2) __dragObject__]                                    
    set ctrlArea_02 [myGUI::cvCustom::create_controlField  $cvObject  $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3) __dragObject__]                                    
    set ctrlArea_03 [myGUI::cvCustom::create_controlField  $cvObject  $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4) __dragObject__]                                    
    set ctrlArea_04 [myGUI::cvCustom::create_controlField  $cvObject  $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5) __dragObject__]                                    

        # -- draw edit areas
    set ctrlArea_11 [myGUI::cvCustom::create_controlCircle  $cvObject  $ctrl_Points(1)  7.0  __none__]                                    
    set ctrlArea_12 [myGUI::cvCustom::create_controlCircle  $cvObject  $ctrl_Points(2)  7.0  __none__]                                    
    set ctrlArea_13 [myGUI::cvCustom::create_controlCircle  $cvObject  $ctrl_Points(3)  7.0  __none__]                                    
    set ctrlArea_14 [myGUI::cvCustom::create_controlCircle  $cvObject  $ctrl_Points(4)  7.0  __none__]                                    
    
        # -- draw control Lines
    set _obj_line_01  [$cvObject  create   line [appUtil::flatten_nestedList $p0 $p1]   -tags __CenterLine__   -fill orange]
    set _obj_line_02  [$cvObject  create   line [appUtil::flatten_nestedList $p2 $p3]   -tags __CenterLine__   -fill orange]
    set _obj_line_03  [$cvObject  create   line [appUtil::flatten_nestedList $p4 $p5]   -tags __CenterLine__   -fill orange]
    set _obj_line_04  [$cvObject  create   line [appUtil::flatten_nestedList $p6 $p7]   -tags __CenterLine__   -fill orange]
    set _obj_line_05  [$cvObject  create   line [appUtil::flatten_nestedList $p8 $p9]   -tags __CenterLine__   -fill orange]

        # -- create bent curve           
    set ctrlArea_21 [myGUI::cvCustom::create_segmentCurve  $cvObject  $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2) $ChainStay(segRadius_01)  __dragObject__]                                    
    set ctrlArea_22 [myGUI::cvCustom::create_segmentCurve  $cvObject  $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3) $ChainStay(segRadius_02)  __dragObject__]                                    
    set ctrlArea_23 [myGUI::cvCustom::create_segmentCurve  $cvObject  $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4) $ChainStay(segRadius_03)  __dragObject__]                                    
    set ctrlArea_24 [myGUI::cvCustom::create_segmentCurve  $cvObject  $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5) $ChainStay(segRadius_04)  __dragObject__]                                    
    
        # -- draw a circle on intersecting vectors
    $cvObject create circle     $ctrl_Points(1)    -radius 0.5   -outline orange    -fill lightgray   -width 0.35  -tags {__CenterLine__}
    $cvObject create circle     $ctrl_Points(2)    -radius 0.5   -outline orange    -fill lightgray   -width 0.35  -tags {__CenterLine__}
    $cvObject create circle     $ctrl_Points(3)    -radius 0.5   -outline orange    -fill lightgray   -width 0.35  -tags {__CenterLine__}
    $cvObject create circle     $ctrl_Points(4)    -radius 0.5   -outline orange    -fill lightgray   -width 0.35  -tags {__CenterLine__}
    $cvObject create circle     $ctrl_Points(5)    -radius 0.5   -outline orange    -fill lightgray   -width 0.35  -tags {__CenterLine__}
    
                                                                                                    
    
    set _dim_length_01          [$cvObject create dimensionLength \
                                        [appUtil::flatten_nestedList   $p0 $p1] \
                                        [list \
                                            aligned \
                                            [expr -15 * $stageScale]   0 \
                                            $Color(result)]]
    set _dim_length_02          [$cvObject create dimensionLength \
                                        [appUtil::flatten_nestedList   $p2 $p3] \
                                        [list \
                                            aligned \
                                            [expr -15 * $stageScale]   0 \
                                            $Color(result)]]
    set _dim_length_03          [$cvObject create dimensionLength \
                                        [appUtil::flatten_nestedList   $p4 $p5] \
                                        [list \
                                            aligned \
                                            [expr -15 * $stageScale]   0 \
                                            $Color(result)]]
    set _dim_length_04          [$cvObject create dimensionLength \
                                        [appUtil::flatten_nestedList   $p6 $p7] \
                                        [list \
                                            aligned \
                                            [expr -15 * $stageScale]   0 \
                                            $Color(result)]]
    # set _dim_length_05        [$cvObject create dimensionLength \
                                        [appUtil::flatten_nestedList   $p8 $p9] \
                                        [list \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Color(result)]]
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject       $_dim_length_01     single_ChainStay_CenterlineLength_01
    myGUI::gui::bind_dimensionEvent_2   $cvObject       $_dim_length_02     single_ChainStay_CenterlineLength_02
    myGUI::gui::bind_dimensionEvent_2   $cvObject       $_dim_length_03     single_ChainStay_CenterlineLength_03
    myGUI::gui::bind_dimensionEvent_2   $cvObject       $_dim_length_04     single_ChainStay_CenterlineLength_04
        #
    myGUI::gui::bind_objectEvent_2      $cvObject       $_obj_line_01       single_ChainStay_CenterlineLength_01
    myGUI::gui::bind_objectEvent_2      $cvObject       $_obj_line_02       single_ChainStay_CenterlineLength_02
    myGUI::gui::bind_objectEvent_2      $cvObject       $_obj_line_03       single_ChainStay_CenterlineLength_03
    myGUI::gui::bind_objectEvent_2      $cvObject       $_obj_line_04       single_ChainStay_CenterlineLength_04
        #
    myGUI::gui::bind_objectEvent_2      $cvObject       $ctrlArea_11        group_ChainStay_Centerline_Bent01    
    myGUI::gui::bind_objectEvent_2      $cvObject       $ctrlArea_12        group_ChainStay_Centerline_Bent02
    myGUI::gui::bind_objectEvent_2      $cvObject       $ctrlArea_13        group_ChainStay_Centerline_Bent03
    myGUI::gui::bind_objectEvent_2      $cvObject       $ctrlArea_14        group_ChainStay_Centerline_Bent04
        #
    $cvObject registerDragObject        $ctrlArea_01    [list [namespace current]::move_ctrlPoints  1]
    $cvObject registerDragObject        $ctrlArea_02    [list [namespace current]::move_ctrlPoints  2]
    $cvObject registerDragObject        $ctrlArea_03    [list [namespace current]::move_ctrlPoints  3]
    $cvObject registerDragObject        $ctrlArea_04    [list [namespace current]::move_ctrlPoints  4]
        #
    return 
        #          
}

proc myGUI::cvCustom::get_ChainWheel {z w position} {                    
    set cw_Diameter_TK  [ expr 12.7 / sin ($vectormath::CONST_PI/$z)  ]
    set cw_Diameter     [ expr $cw_Diameter_TK + 4 ]
    set cw_Width        $w
    
        # puts "   \$cw_Diameter_TK  $cw_Diameter_TK"
    
    set pt_01           [ list [ expr -0.5 * $cw_Diameter    ] [expr  0.5 * ($cw_Width - 0.5)] ]
    set pt_02           [ list [ expr -0.5 * $cw_Diameter_TK ] [expr  0.5 * $cw_Width] ]
    set pt_03           [ list [ expr  0.5 * $cw_Diameter_TK ] [expr  0.5 * $cw_Width] ]
    set pt_04           [ list [ expr  0.5 * $cw_Diameter    ] [expr  0.5 * ($cw_Width - 0.5)] ]
    
    set pt_05           [ list [ expr  0.5 * $cw_Diameter    ] [expr -0.5 * ($cw_Width - 0.5)] ]
    set pt_06           [ list [ expr  0.5 * $cw_Diameter_TK ] [expr -0.5 * $cw_Width] ]
    set pt_07           [ list [ expr -0.5 * $cw_Diameter_TK ] [expr -0.5 * $cw_Width] ]
    set pt_08           [ list [ expr -0.5 * $cw_Diameter    ] [expr -0.5 * ($cw_Width - 0.5)] ]
    
    # set position        [ list [lindex $position 0] [expr -1 * [lindex $position 1]] ]
    set pt_Clearance_l  [ vectormath::addVector [ list [ expr -0.5 * $cw_Diameter ] 0]  $position  ]
    set pt_Clearance_r  [ vectormath::addVector [ list [ expr  0.5 * $cw_Diameter ] 0]  $position  ]
    
    set polygon         [appUtil::flatten_nestedList       [ list  $pt_01  $pt_02  $pt_03  $pt_04  \
                                                                    $pt_05  $pt_06  $pt_07  $pt_08 ] ]
    set polygon         [ vectormath::addVectorCoordList    $position $polygon ]                                                            
    return [list $pt_Clearance_l $polygon $pt_Clearance_r]
}

proc myGUI::cvCustom::get_BottomBracket {} {   
    
    upvar  1 Length     Length
    upvar  1 Center     Center
    
    set length03            [ expr 0.5 * [myGUI::model::model_XY::getScalar BottomBracket OutsideDiameter] ]
    set length04            [ expr 0.5 * [myGUI::model::model_XY::getScalar BottomBracket Width] ]
    
    set pointList_OutSide   [ list [expr -1*$length03] [expr -1*$length04] $length03 $length04 ]
    set pointList_InSide    [ list [expr -1*$Length(01)] [expr -1*$Length(02)] $Length(01) $Length(02) ]
    
    return [list $pointList_OutSide $pointList_InSide]
}

proc myGUI::cvCustom::create_controlCircle {cvObject xy {radius 10.0} {tag {}}} {
            #
        set returnObj [$cvObject create circle   $xy  -radius $radius  -outline orange  -fill gray70  -width 0.35 -tags [list __CenterLine__ $tag]]  
            # -- return controlField
        return $returnObj
            #
}

proc myGUI::cvCustom::create_segmentCurve {cvObject xy1 xy xy2 radius {tag {}}} {
    
        # -- get orientation of controlField
    set baseAngle   [vectormath::dirAngle $xy1 $xy] 
    set baseOrient  [vectormath::offsetOrientation $xy1 $xy $xy2]
    if {$baseOrient == 0} {set baseOrient 1}
    set segAngle    [vectormath::angle    $xy1 $xy $xy2]
        # puts "      \$baseAngle    $baseAngle"
        # puts "      \$baseOrient   $baseOrient"
        # puts "      \$segAngle     $segAngle"
    set orientAngle [expr 180 + $baseAngle + 0.5*$baseOrient*$segAngle]
        #
        
        # -- get center of Circle
    set arcAngle    [expr 180 - $segAngle]
    set offsetCntr  [expr $radius / cos([vectormath::rad [expr 0.5*$arcAngle]])]
    set arcCenter   [vectormath::rotateLine $xy $offsetCntr $orientAngle]
        # puts "      \$segAngle     $segAngle"
        # puts "      \$arcAngle     $arcAngle"
        # puts "      \$offsetCntr   $offsetCntr\n"
        
        #
    set p_arc_00    [vectormath::addVector   $arcCenter [vectormath::unifyVector $arcCenter $xy $radius]]
    set p_00        [vectormath::rotatePoint $arcCenter $p_arc_00 [expr  -0.5 *$arcAngle]]
    set arcPoints   $p_00
    set p           $p_00      
    set segmeents   16
    set i 0
    while {$i < $segmeents} {
        set p [vectormath::rotatePoint $arcCenter $p [expr $arcAngle/$segmeents]]
        lappend arcPoints $p
        incr i
            # puts "    -> $i"
    }
    set p_99        $p
        #
    set coordList   $arcPoints
    set coordList   [appUtil::flatten_nestedList $coordList]
        #
    $cvObject     create line    $coordList  -width 1.0  -fill darkred           -tags {__CenterLine__}
        #                                   
    if {[lindex $p_00 0] < [lindex $p_99 0]} {
        $cvObject create circle  $p_00       -width 1.0  -outline darkorange     -radius 1.5   -tags {__CenterLine__}  
        $cvObject create circle  $p_99       -width 1.0  -outline red            -radius 1.5   -tags {__CenterLine__}
    } else {
        $cvObject create circle  $p_00       -width 1.0  -outline red            -radius 1.5   -tags {__CenterLine__}  
        $cvObject create circle  $p_99       -width 1.0  -outline darkorange     -radius 1.5   -tags {__CenterLine__}
    }    
        #
    return 
        #
}

proc myGUI::cvCustom::create_controlField {cvObject xy1 xy xy2 {tag {}}} {
        #
    set CONST_PI $vectormath::CONST_PI
    set h1  11
    set h2  9
    set b1  7
    set b2  14
    
        # -- get orientation of controlField
    set baseAngle   [vectormath::dirAngle $xy1 $xy] 
    set xy_orient   [vectormath::offsetOrientation $xy1 $xy $xy2]
    if {$xy_orient == 0} {set xy_orient 1}
    set xy_angle    [expr $xy_orient * (0 + [vectormath::angle    $xy1 $xy $xy2])]
        # puts "      \$baseAngle    $baseAngle"
        # puts "      \$xy_orient    $xy_orient"
        # puts "      \$xy_angle     $xy_angle"
    set orientAngle [expr 180 + $baseAngle + 0.5*$xy_angle]
    
        # -- get arrow-shape of controlField
    set x0   [expr  0.5 * $b1]
    set y0   [expr -0.5 * $b1]
    set x1   $h1
    set x2   [expr  $h1 + $h2]
    set y11  [expr -0.5 * $b1]
    set y12  [expr +0.5 * $b1]
    set y21  [expr -0.5 * $b2]
    set y22  [expr +0.5 * $b2]
    
        # -- get arc of controlField
    set coords_01    [appUtil::flatten_nestedList  [list $x0 $y0] [list $x1 $y11] [list $x1 $y21]  [list $x2 0]  [list $x1 $y22] [list $x1 $y12]]
    set coords_02    [vectormath::rotateCoordList {0 0} $coords_01  90]
    set coords_03    [vectormath::rotateCoordList {0 0} $coords_01 180]
    set coords_04    [vectormath::rotateCoordList {0 0} $coords_01 270]
    set coordList    [appUtil::flatten_nestedList $coords_01 $coords_02 $coords_03 $coords_04]
    
        # -- position of controlField
    #set coordList   $arcPoints
    #set coordList   [appUtil::flatten_nestedList $coordList $x2 $y22  $x2 $y21]

    set coordList   [vectormath::addVectorCoordList  $xy $coordList]
    set coordList   [vectormath::rotateCoordList     $xy $coordList $orientAngle]
    set ctrlPolygon [$cvObject create polygon     $coordList   \
                                    -outline red  \
                                    -fill lightgray \
                                    -width 0.35 \
                                    -tags [list __CenterLine__ $tag]]
    set returnObj   $ctrlPolygon
    
        # -- return controlField
    return $returnObj    
}

proc myGUI::cvCustom::move_ctrlPoints {id xy} {
    variable ctrl_Points
    puts "\n   -------------------------------"
    puts "    myGUI::cvCustom::move_ctrlPoints"
    puts "       id:              $id"
    puts "       xy:              $xy"
    puts "   -------------------------------"
    foreach key [lsort [array names ctrl_Points]] {
        puts "          $key           $ctrl_Points($key)"
    }                      
    puts "   -------------------------------"
    array set lastValues {}
        set lastValues(S01)     [vectormath::length   $ctrl_Points(0)  $ctrl_Points(1) ]
        set lastValues(S02)     [vectormath::length   $ctrl_Points(1)  $ctrl_Points(2) ]
        set lastValues(S03)     [vectormath::length   $ctrl_Points(2)  $ctrl_Points(3) ]
        set lastValues(S04)     [vectormath::length   $ctrl_Points(3)  $ctrl_Points(4) ]
        set lastValues(S05)     [vectormath::length   $ctrl_Points(4)  $ctrl_Points(5) ]
        
        set lastValues(A01)     [set ctrl_Points(1)]
        set lastValues(A02)     [set ctrl_Points(2)]
        set lastValues(A03)     [set ctrl_Points(3)]
        set lastValues(A04)     [set ctrl_Points(4)]
        
        set lastValues(P00)     [set ctrl_Points(0)]
        set lastValues(P01)     [set ctrl_Points(1)]
        set lastValues(P02)     [set ctrl_Points(2)]
        set lastValues(P03)     [set ctrl_Points(3)]
        set lastValues(P04)     [set ctrl_Points(4)]
        set lastValues(P05)     [set ctrl_Points(5)]


    foreach {x y} $xy break
        #
    set myPos          [vectormath::addVector $ctrl_Points($id) [list $x [expr -1.0*$y]]]    
        # parray ctrl_Points
        #
    set ctrl_Points($id) $myPos
        # puts " -> 002 ---"
        # parray ctrl_Points
        # puts " -> 003 ---"            
        #
        #
    set S01_length [vectormath::length   $ctrl_Points(0) $ctrl_Points(1) ]
    set S02_length [vectormath::length   $ctrl_Points(1) $ctrl_Points(2) ]
    set S03_length [vectormath::length   $ctrl_Points(2) $ctrl_Points(3) ]
    set S04_length [vectormath::length   $ctrl_Points(3) $ctrl_Points(4) ]
    set S05_length [vectormath::length   $ctrl_Points(4) $ctrl_Points(5) ]
        #            
    set S01_orient [vectormath::offsetOrientation $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)]
    set S02_orient [vectormath::offsetOrientation $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)]
    set S03_orient [vectormath::offsetOrientation $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)]
    set S04_orient [vectormath::offsetOrientation $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)]
        #
    set P01_angle  [expr $S01_orient * (-180 + [vectormath::angle    $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)])]
    set P02_angle  [expr $S02_orient * (-180 + [vectormath::angle    $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)])]
    set P03_angle  [expr $S03_orient * (-180 + [vectormath::angle    $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)])]
    set P04_angle  [expr $S04_orient * (-180 + [vectormath::angle    $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)])]
        #
    set S01_radius [myGUI::model::model_XY::getScalar ChainStay segmentRadius_01]
    set S02_radius [myGUI::model::model_XY::getScalar ChainStay segmentRadius_02]
    set S03_radius [myGUI::model::model_XY::getScalar ChainStay segmentRadius_03]
    set S04_radius [myGUI::model::model_XY::getScalar ChainStay segmentRadius_04]
        #
        #
        # -- check configuration of ChainStay CenterLine
    set dict_ChainStay [dict create \
                    segment_01  $S01_length \
                    segment_02  $S02_length \
                    segment_03  $S03_length \
                    segment_04  $S04_length \
                    segment_05  $S05_length \
                    angle_01    $P01_angle \
                    angle_02    $P02_angle \
                    angle_03    $P03_angle \
                    angle_04    $P04_angle \
                    radius_01   $S01_radius \
                    radius_02   $S02_radius \
                    radius_03   $S03_radius \
                    radius_04   $S04_radius \
    ]
        #
    if {! [myGUI::modelAdapter::validate_ChainStayCenterLine $dict_ChainStay]} {
            #
        #tk_messageBox -type ok -message "   ... this is not a valid configuration: check radius at bent!"
            #
            # -- current config does not fit to radius, segment length and angles
            #      set the previous values as current
        set S01_length [myGUI::model::model_XY::getScalar ChainStay segmentLength_01]
        set S02_length [myGUI::model::model_XY::getScalar ChainStay segmentLength_02]
        set S03_length [myGUI::model::model_XY::getScalar ChainStay segmentLength_03]
        set S04_length [myGUI::model::model_XY::getScalar ChainStay segmentLength_04]
            #
        set P01_angle  [myGUI::model::model_XY::getScalar ChainStay segmentAngle_01]
        set P02_angle  [myGUI::model::model_XY::getScalar ChainStay segmentAngle_02]
        set P03_angle  [myGUI::model::model_XY::getScalar ChainStay segmentAngle_03]
        set P04_angle  [myGUI::model::model_XY::getScalar ChainStay segmentAngle_04]
    }
        #
        #
    set keyValueList {}
        #
    lappend keyValueList Scalar/ChainStay/segmentLength_01      $S01_length
    lappend keyValueList Scalar/ChainStay/segmentLength_02      $S02_length
    lappend keyValueList Scalar/ChainStay/segmentLength_03      $S03_length
    lappend keyValueList Scalar/ChainStay/segmentLength_04      $S04_length
        #
    lappend keyValueList Scalar/ChainStay/segmentAngle_01       $P01_angle             
    lappend keyValueList Scalar/ChainStay/segmentAngle_02       $P02_angle
    lappend keyValueList Scalar/ChainStay/segmentAngle_03       $P03_angle
    lappend keyValueList Scalar/ChainStay/segmentAngle_04       $P04_angle           
         #
    update_ctrlPointValues $keyValueList
        #
    puts "\n   -------------------------------"
    puts "       -> S01_length     [myGUI::model::model_XY::getScalar ChainStay segmentLength_01]"
    puts "       -> S02_length     [myGUI::model::model_XY::getScalar ChainStay segmentLength_02]"
    puts "       -> S03_length     [myGUI::model::model_XY::getScalar ChainStay segmentLength_03]"
    puts "       -> S04_length     [myGUI::model::model_XY::getScalar ChainStay segmentLength_04]"
    puts "       -> P01_angle      [myGUI::model::model_XY::getScalar ChainStay segmentAngle_01]"
    puts "       -> P02_angle      [myGUI::model::model_XY::getScalar ChainStay segmentAngle_02]"
    puts "       -> P03_angle      [myGUI::model::model_XY::getScalar ChainStay segmentAngle_03]"
    puts "       -> P04_angle      [myGUI::model::model_XY::getScalar ChainStay segmentAngle_04]"
    puts "       -> P01_radius     [myGUI::model::model_XY::getScalar ChainStay segmentRadius_01]"
    puts "       -> P02_radius     [myGUI::model::model_XY::getScalar ChainStay segmentRadius_02]"
    puts "       -> P03_radius     [myGUI::model::model_XY::getScalar ChainStay segmentRadius_03]"
    puts "       -> P04_radius     [myGUI::model::model_XY::getScalar ChainStay segmentRadius_04]"
        #
    myGUI::cvCustom::updateView [myGUI::gui::current_notebookTabID]
        #
    return
        #
}

proc myGUI::cvCustom::update_ctrlPointValues {keyValueList} {
    set myList {}
    
    foreach {keyString value} $keyValueList { 
        puts "   -> $keyString $value"
            # Scalar/ChainStay/segmentLength_01 50.000
        foreach {any object key} [split $keyString /] break
            # puts [myGUI::model::model_XY::getScalar $object $key]
        set lastValue [myGUI::model::model_XY::getScalar $object $key]
            # set lastValue  $myGUI::view::edit::_updateValue($key)
            # set lastValue  $myGUI::view::edit::_updateValue($key)
        puts "     ->   $lastValue"
        puts "       ->   $value"
            #
        set diffValue  [expr abs($lastValue - $value)]
        if {$diffValue > 0.1} { 
            puts "            ... update:  $key  $lastValue -> $value" 
            lappend myList "Scalar:$object/$key" $value
        } else {
            puts "            ... ignore:  $key  $lastValue -> $value"
        }
    }
    myGUI::control::setValue $myList
}
    #


proc myGUI::cvCustom::create_sectionField {cvObject xy {tag {}}} {
        #
    set width   8
    set height 18
        #
    foreach {x y} $xy break
        #
    set x0 [expr $x]
    set x1 [expr $x - 0.5 * $width]
    set x2 [expr $x + 0.5 * $width]
    set y0 [expr $y]
    set y1 [expr $y - 0.7 * $height]
    set y2 [expr $y - 1.0 * $height]
        #
    set coordList [appUtil::flatten_nestedList $x1 $y1  $x0 $y0  $x2 $y1  $x0 $y2]
        #
    set width   5
    set height 30
        #
    set x0 [expr $x]
    set x1 [expr $x + $width]
    set x2 [expr $x]
    set y0 [expr $y]
    set y1 [expr $y - 0.7 * $height]
    set y2 [expr $y - 1.0 * $height]
        #    
    set coordList [appUtil::flatten_nestedList $x0 $y0  $x1 $y1  $x2 $y2]
        #
    set ctrlPolygon [$cvObject create polygon     $coordList   -outline red    -fill lightgray   -width 1.0   -tags [list __CenterLine__ $tag]]
    set returnObj   $ctrlPolygon
        #
        # -- return controlField
    return $returnObj    
        #
}

proc myGUI::cvCustom::move_sectPoints {id xy} {
    variable sect_Points
    variable ctrl_Points
    puts "\n   -------------------------------"
    puts "    myGUI::cvCustom::move_sectPoints"
    puts "       id:              $id"
    puts "       xy:              $xy"
    puts "   -------------------------------"
    foreach key [lsort [array names sect_Points]] {
        puts "          $key           $sect_Points($key)"
    }                      
    puts "   -------------------------------"
    
      #
    array set lastValues {}
        set lastValues(S01)     [vectormath::length   $sect_Points(0)  $sect_Points(1) ]
        set lastValues(S02)     [vectormath::length   $sect_Points(1)  $sect_Points(2) ]
        
        set lastValues(C00)     [set sect_Points(0)]
        set lastValues(C01)     [set sect_Points(1)]
        set lastValues(C02)     [set sect_Points(2)]
      # ---
          
      #    
    foreach {x y} $xy break
      #
    set myPos           [vectormath::addVector $sect_Points($id) [list $x [expr -1.0*$y]]]
    set sect_Points($id) $myPos            
      # ---
    set cuttingLeft     [vectormath::length  $sect_Points(0) $sect_Points(1) ]
    set cuttingLength   [vectormath::length  $sect_Points(1) $sect_Points(2) ]
      #
      
      #
    proc update_sectPointValues {keyValueList} {
        set myList {}
        foreach {key value} $keyValueList { 
            puts "<E> $key"
            set lastValue  $myGUI::view::edit::_updateValue($key)
            set diffValue  [expr abs($lastValue - $value)]
            if {$diffValue > 0.1} { 
                puts "            ... update:  $key  $lastValue -> $value" 
                lappend myList $key  $value
            } else {
                puts "            ... ignore:  $key  $lastValue -> $value"
            }
        }
        myGUI::control::setValue $myList
    }
        #
      
        #
    set keyValueList {}
        #
    lappend keyValueList Scalar/ChainStay/cuttingLeft       $cuttingLeft
    lappend keyValueList Scalar/ChainStay/cuttingLength     $cuttingLength
        #
    update_sectPointValues $keyValueList
        #
    puts "\n   -------------------------------"
    puts "       -> cuttingLeft    [myGUI::model::model_XY::getScalar ChainStay cuttingLeft]"
    puts "       -> cuttingLength  [myGUI::model::model_XY::getScalar ChainStay cuttingLength]"
        #
    myGUI::cvCustom::updateView [myGUI::gui::current_notebookTabID]
        #
    return
        #
}


proc myGUI::cvCustom::move_ctrlPoints_debug {id xy} {
    variable sect_Points
    variable ctrl_Points
    puts "   -> proc myGUI::cvCustom::move_ctrlPoints "
    puts "       -> $id $xy"
    return
}

