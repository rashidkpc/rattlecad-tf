 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom_createReference.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 #
 # Copyright (2017) by Manfred ROSENBERGER  (manfred.rosenberger@gmx.net)
 #    
 # See the file "license.terms" for information on usage and redistribution
 # of this file, and for a DISCLAIMER OF ALL WARRANTIES. 
 #
 #
 # ---------------------------------------------------------------------------
 #    namespace:  myGUI::reference
 # ---------------------------------------------------------------------------
 #
 #

namespace eval myGUI::reference {
        #
    variable    stageScale
        #
    variable    Config
    variable    Rendering
    variable    Reference
        #
    variable    BottomBracket
    variable    ChainStay
    variable    CrankSet
    variable    DownTube
    variable    Fork
    variable    FrameJig
    variable    FrontBrake
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    HeadSet
    variable    LegClearance
    variable    RearBrake
    variable    RearDrop
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatStay
    variable    SeatTube
    variable    Steerer
    variable    Stem
    variable    TopTube
        #
    variable    Position
    variable    Length
    variable    Angle
    variable    Vector
        #
        #
    variable cvObject    
        #
        #
}

proc myGUI::reference::create {cvObj BB_Position type args} {
        #
    variable cvObject    $cvObj
        #
    switch -exact $type {
        point_center            { create_PointCenter        $BB_Position}
        point_personal          { create_PointPersonal      $BB_Position}
        point_bottombracket     { create_PointBottomBracket $BB_Position}
        point_contact           { create_PointContact       $BB_Position}
        point_crank             { create_PointCrank         $BB_Position}
        point_reference         { create_PointReference     $BB_Position}
        point_seat              { create_PointSeat          $BB_Position}
        point_frame             { create_PointFrame         $BB_Position}
        point_frame_dimension   { create_PointHTStem        $BB_Position}
        cline_effectiveTT       { create_ClineEffectiveTT   $BB_Position}
        cline_angle             { create_CLineAngle         $BB_Position}
        cline_brake             { create_CLineBrake         $BB_Position}
        cline_frame             { create_ClineFrame         $BB_Position $args}
        cline_framejig          { create_CLineFrameJig      $BB_Position}
        default                 { error " myGUI::reference::create -> $BB_Position $type" -1}
    }
        #
    return 
        #
}

proc myGUI::reference::create_PointCenter          {BB_Position} {
        #
    variable cvObject
        #
        #
    set Position(BaseCenter)    [myGUI::model::model_XZ::getPosition    BottomBracket_Ground    $BB_Position ]
        #
    $cvObject create circle        $Position(BaseCenter)     -radius 10  -outline gray50     -width 0.35    -tags __CenterLine__
        #
}

proc myGUI::reference::create_PointPersonal        {BB_Position} {
        #
    variable cvObject
        #
        #
    set dimColor                $myGUI::cvCustom::DraftingColor(personal)
        #
    set BottomBracket(Position) $BB_Position
    set CrankSet(Position)      [myGUI::model::model_XZ::getPosition    CrankSet                $BB_Position ]
    set HandleBar(Position)     [myGUI::model::model_XZ::getPosition    HandleBar               $BB_Position ]
    set Saddle(Position)        [myGUI::model::model_XZ::getPosition    Saddle                  $BB_Position ]
    set SeatTube(Saddle)        [myGUI::model::model_XZ::getPosition    SeatTube_Saddle         $BB_Position ]
    set SeatPost(PivotPosition) [myGUI::model::model_XZ::getPosition    SeatPost_Pivot          $BB_Position ]
        #
    $cvObject create circle      $CrankSet(Position)     -radius 10  -outline $dimColor  -width 0.70  -tags {__CenterLine__  __CenterPoint__  personalBB}
    $cvObject create circle      $HandleBar(Position)    -radius 12  -outline $dimColor  -width 1.00  -tags {__CenterLine__  __CenterPoint__  personalHB}
    $cvObject create circle      $Saddle(Position)       -radius 12  -outline $dimColor  -width 1.00  -tags {__CenterLine__  __CenterPoint__  personalSaddle}
        #
}

proc myGUI::reference::create_PointContact         {BB_Position} {
        #
    variable cvObject
        #
        #
    set dimColor                gray60
        #
    set BottomBracket(Position) $BB_Position
    set HandleBar(Position)     [myGUI::model::model_XZ::getPosition    HandleBar               $BB_Position ]
    set Saddle(Position)        [myGUI::model::model_XZ::getPosition    Saddle                  $BB_Position ]
        #
    $cvObject create circle      $HandleBar(Position)    -radius 5  -outline $dimColor  -tags {__CenterLine__  __CenterPoint__  personalHB}
    $cvObject create circle      $Saddle(Position)       -radius 5  -outline $dimColor  -tags {__CenterLine__  __CenterPoint__  personalSaddle}
        #
}

proc myGUI::reference::create_PointBottomBracket   {BB_Position} {
        #
    variable cvObject
        #
        #
        #
    set BottomBracket(Position) $BB_Position
    set Saddle(Position)        [myGUI::model::model_XZ::getPosition    Saddle          $BB_Position ]
    set FrontWheel(Position)    [myGUI::model::model_XZ::getPosition    FrontWheel      $BB_Position ]	
        #   
    set CrankSet(Length)        [myGUI::model::model_XZ::getScalar      CrankSet Length]
    set FrontWheel(RimDiameter) [myGUI::model::model_XZ::getScalar      Geometry FrontRim_Diameter ]
    set FrontWheel(TyreHeight)  [myGUI::model::model_XZ::getScalar      Geometry FrontTyre_Height ]
        #   
    set vct_90                  [vectormath::unifyVector   $BottomBracket(Position)    $FrontWheel(Position) ]
    set Position(help_91)       [vectormath::addVector     $BottomBracket(Position)    [vectormath::unifyVector {0 0} $vct_90 $CrankSet(Length) ] ]
    set Position(help_92)       [vectormath::addVector     $FrontWheel(Position)       [vectormath::unifyVector {0 0} $vct_90 [expr - ( 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)) ] ] ]
    set Position(help_93)       [vectormath::addVector     $BottomBracket(Position)    [vectormath::unifyVector $Saddle(Position) $BottomBracket(Position) $CrankSet(Length) ] ]
        #
    $cvObject create circle      $Position(help_91)        -radius  4  -outline gray50     -width 0.35  -tags __CenterLine__
    $cvObject create circle      $Position(help_93)        -radius  4  -outline gray50     -width 0.35  -tags __CenterLine__
        #
}

proc myGUI::reference::create_PointCrank           {BB_Position} {
        #
    variable cvObject
        #
        #
        #
    set CrankSet(Position)      [myGUI::model::model_XZ::getPosition    CrankSet        $BB_Position ]
    set Saddle(Position)        [myGUI::model::model_XZ::getPosition    Saddle          $BB_Position ]
    set FrontWheel(Position)    [myGUI::model::model_XZ::getPosition    FrontWheel      $BB_Position ]	
        #   
    set CrankSet(Length)        [myGUI::model::model_XZ::getScalar      CrankSet Length]
    set FrontWheel(RimDiameter) [myGUI::model::model_XZ::getScalar      Geometry FrontRim_Diameter ]
    set FrontWheel(TyreHeight)  [myGUI::model::model_XZ::getScalar      Geometry FrontTyre_Height ]
        #   
    set vct_90                  [vectormath::unifyVector   $CrankSet(Position)  $FrontWheel(Position) ]
    set Position(help_91)       [vectormath::addVector     $CrankSet(Position)  [vectormath::unifyVector $CrankSet(Position) $vct_90 $CrankSet(Length) ] ]
    set Position(help_92)       [vectormath::addVector     $CrankSet(Position)  [vectormath::unifyVector $CrankSet(Position) $vct_90 [expr - ( 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)) ] ] ]
    set Position(help_93)       [vectormath::addVector     $CrankSet(Position)  [vectormath::unifyVector $Saddle(Position) $CrankSet(Position) $CrankSet(Length) ] ]
        #
    $cvObject create circle      $Position(help_91)        -radius  4  -outline gray50     -width 0.35  -tags __CenterLine__
    $cvObject create circle      $Position(help_93)        -radius  4  -outline gray50     -width 0.35  -tags __CenterLine__
        #
}

proc myGUI::reference::create_PointReference       {BB_Position} {
        #
    variable cvObject
        #
        #
        # point_reference 
        #
    set Reference(HandleBar)    [myGUI::model::model_XZ::getPosition    Reference_HB    $BB_Position ]
    set Reference(SaddleNose)   [myGUI::model::model_XZ::getPosition    Reference_SN    $BB_Position ]
        #
    $cvObject create circle      $Reference(HandleBar)     -radius  2  -outline orange     -width 0.35  -tags __CenterLine__
    $cvObject create circle      $Reference(SaddleNose)    -radius  2  -outline orange     -width 0.35  -tags __CenterLine__
        #
}

proc myGUI::reference::create_PointSeat            {BB_Position} {
        #
    variable cvObject
        #
        #
        # point_seat 
        #
    set LegClearance(Position)  [myGUI::model::model_XZ::getPosition    LegClearance    $BB_Position ]
    set SaddleNose(Position)    [myGUI::model::model_XZ::getPosition    SaddleNose      $BB_Position ]
    set Saddle(Mount)           [myGUI::model::model_XZ::getPosition    Saddle_Mount    $BB_Position ]
    set Saddle(Proposal)        [myGUI::model::model_XZ::getPosition    SaddleProposal  $BB_Position ]
    set SeatPost(Pivot)         [myGUI::model::model_XZ::getPosition    SeatPost        $BB_Position ]
    set SeatTube(Saddle)        [myGUI::model::model_XZ::getPosition    SeatTube_Saddle $BB_Position ]
        #
    $cvObject create circle      $LegClearance(Position)   -radius  4  -outline darkred        -width 0.35  -tags __CenterLine__
    $cvObject create circle      $SaddleNose(Position)     -radius  8  -outline darkred        -width 0.35  -tags __CenterLine__
    $cvObject create circle      $Saddle(Proposal)         -radius  4  -outline darkmagenta    -width 0.70  -tags __CenterLine__
    $cvObject create circle      $SeatPost(Pivot)          -radius  2  -outline gray           -width 0.35  -tags __CenterLine__
    $cvObject create circle      $SeatTube(Saddle)         -radius  5  -outline gray           -width 0.35  -tags __CenterLine__
    $cvObject create circle      $Saddle(Mount)            -radius  2  -outline darkgray       -width 0.35  -tags __CenterLine__
        #
}

proc myGUI::reference::create_PointFrame           {BB_Position} {
        #
    variable cvObject
        #
        #
        # point_frame
        #
    set Steerer(Fork)           [myGUI::model::model_XZ::getPosition    Steerer_Start           $BB_Position ]
    set HeadTube(Stem)          [myGUI::model::model_XZ::getPosition    HeadTube_End            $BB_Position ]
    set TopTube(Steerer)        [myGUI::model::model_XZ::getPosition    TopTube_End             $BB_Position ]
    set TopTube(SeatClassic)    [myGUI::model::model_XZ::getPosition    SeatTube_ClassicTopTube $BB_Position ]
    set TopTube(SeatVirtual)    [myGUI::model::model_XZ::getPosition    SeatTube_VirtualTopTube $BB_Position ]
        #
    $cvObject create circle      $Steerer(Fork)            -radius 10  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  steererFork}
    $cvObject create circle      $HeadTube(Stem)           -radius 10  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  headtubeStem}
    $cvObject create circle      $TopTube(Steerer)         -radius  4  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  toptubeSteerer}
    $cvObject create circle      $TopTube(SeatClassic)     -radius  4  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  toptubeSeatVirtual}
    $cvObject create circle      $TopTube(SeatVirtual)     -radius  4  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  toptubeSeatVirtual}
        #
}

proc myGUI::reference::create_ClineEffectiveTT     {BB_Position} {
        #
    variable cvObject
        #
        #
        # point_frame
        #
    set TopTube(Steerer)        [myGUI::model::model_XZ::getPosition    TopTube_Start           $BB_Position ]
    set TopTube(SeatClassic)    [myGUI::model::model_XZ::getPosition    SeatTube_ClassicTopTube $BB_Position]
        #
    $cvObject create circle      $TopTube(Steerer)         -radius  4  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  toptubeSteerer}
    $cvObject create circle      $TopTube(SeatClassic)     -radius  4  -outline gray       -width 0.35  -tags {__CenterLine__  __CenterPoint__  toptubeSeatClassic}
        #
    $cvObject create centerline  [appUtil::flatten_nestedList    $TopTube(Steerer)   $TopTube(SeatClassic)] -fill gray -tags __CenterLine__
        #
}

proc myGUI::reference::create_PointHTStem          {BB_Position} {
        #
    variable cvObject
        #
        #
        # point_frame_dimension
        #
    set HeadTube(Stem)          [myGUI::model::model_XZ::getPosition    HeadTube_End            $BB_Position ]
        #
    $cvObject create circle      $HeadTube(Stem)           -radius  4  -outline gray       -width 0.35  -tags __CenterLine__
        #
}

proc myGUI::reference::create_CLineAngle           {BB_Position} {
        #
    variable cvObject
        #
        #
        # cline_angle 
        #
    set HandleBar(Position)     [myGUI::model::model_XZ::getPosition    HandleBar               $BB_Position]  
    set HeadTube(Stem)          [myGUI::model::model_XZ::getPosition    HeadTube_End            $BB_Position]
    set Saddle(Position)        [myGUI::model::model_XZ::getPosition    Saddle                  $BB_Position] 
    set SeatTube(Ground)        [myGUI::model::model_XZ::getPosition    SeatTube_Ground         $BB_Position]
    set SeatTube(Saddle)        [myGUI::model::model_XZ::getPosition    SeatTube_Saddle         $BB_Position]
    set Steerer(Ground)         [myGUI::model::model_XZ::getPosition    Steerer_Ground          $BB_Position]
    set Steerer(Stem)           [myGUI::model::model_XZ::getPosition    Steerer_Stem            $BB_Position]
        #
    $cvObject create circle      $HeadTube(Stem)         -radius  4  -outline blue       -width 0.35    -tags __CenterLine__
    $cvObject create circle      $HandleBar(Position)    -radius  4  -outline darkblue   -width 0.35    -tags __CenterLine__
    $cvObject create circle      $Saddle(Position)       -radius  4  -outline gray50     -width 0.35    -tags __CenterLine__
        #
    $cvObject create centerline  [appUtil::flatten_nestedList $Steerer(Stem) $Steerer(Ground) ] \
                                                            -fill gray50        -width 0.25     -tags __CenterLine__
    $cvObject create centerline  [appUtil::flatten_nestedList $SeatTube(Saddle) $SeatTube(Ground) ] \
                                                            -fill gray50        -width 0.25     -tags __CenterLine__
        #
}

proc myGUI::reference::create_CLineBrake           {BB_Position} {
        #
    variable cvObject
        #
        #
        # cline_brake 
        #
    set RearBrake(Help)         [myGUI::model::model_XZ::getPosition    RearBrake_Help          $BB_Position]
    set RearBrake(Shoe)         [myGUI::model::model_XZ::getPosition    RearBrake_Shoe          $BB_Position]
    set RearBrake(Mount)        [myGUI::model::model_XZ::getPosition    RearBrake_Mount         $BB_Position]
    set RearBrake(Definition)   [myGUI::model::model_XZ::getPosition    RearBrake_Definition    $BB_Position]
        #       
    set FrontBrake(Help)        [myGUI::model::model_XZ::getPosition    FrontBrake_Help         $BB_Position]
    set FrontBrake(Shoe)        [myGUI::model::model_XZ::getPosition    FrontBrake_Shoe         $BB_Position]
    set FrontBrake(Mount)       [myGUI::model::model_XZ::getPosition    FrontBrake_Mount        $BB_Position]
    set FrontBrake(Definition)  [myGUI::model::model_XZ::getPosition    FrontBrake_Definition   $BB_Position]
        #   
    set Config(BrakeFront)      [myGUI::model::model_XZ::getConfig      FrontBrake]
    set Config(BrakeRear)       [myGUI::model::model_XZ::getConfig      RearBrake]
        #
    if {$Config(BrakeRear) != {off}} {
        switch $Config(BrakeRear) {
            Rim {
                $cvObject create circle        $RearBrake(Shoe)    -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                $cvObject create circle        $RearBrake(Mount)   -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                $cvObject create centerline  [appUtil::flatten_nestedList $RearBrake(Definition) $RearBrake(Shoe) $RearBrake(Help) $RearBrake(Mount)] \
                                                            -fill gray50        -width 0.25     -tags __CenterLine__
            }
        }
    }
    if {$Config(BrakeFront) != {off}} {
        switch $Config(BrakeFront) {
            Rim {
                $cvObject create circle        $FrontBrake(Shoe)   -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                $cvObject create circle        $FrontBrake(Mount)  -radius  4  -outline gray50        -width 0.35        -tags __CenterLine__
                $cvObject create centerline  [appUtil::flatten_nestedList $FrontBrake(Definition) $FrontBrake(Shoe) $FrontBrake(Help) $FrontBrake(Mount)] \
                                                            -fill gray50        -width 0.25     -tags __CenterLine__
                }
        }
    }
        #
}

proc myGUI::reference::create_ClineFrame           {BB_Position args} {
        #
    variable cvObject
        #
        #
        #
    if {[llength [join $args]] > 0} {
        set extend_Saddle {extend}
    } else {
        set extend_Saddle {}
    }
        #
        # --- get defining Point coords ----------
    set BottomBracket(Position)     $BB_Position
    set FrontWheel(Position)        [myGUI::model::model_XZ::getPosition    FrontWheel          $BB_Position]
    set Saddle(Position)            [myGUI::model::model_XZ::getPosition    Saddle              $BB_Position]
    set SeatStay(SeatTube)          [myGUI::model::model_XZ::getPosition    SeatStay_End        $BB_Position]
    set SeatTube(Saddle)            [myGUI::model::model_XZ::getPosition    SeatTube_Saddle     $BB_Position]
    set SeatTube(TopTube)           [myGUI::model::model_XZ::getPosition    SeatTube_Start      $BB_Position]
    set SeatStay(RearWheel)         [myGUI::model::model_XZ::getPosition    SeatStay_End        $BB_Position]
    set TopTube(SeatTube)           [myGUI::model::model_XZ::getPosition    TopTube_Start       $BB_Position]
    set TopTube(Steerer)            [myGUI::model::model_XZ::getPosition    TopTube_End         $BB_Position]
    set Steerer(Stem)               [myGUI::model::model_XZ::getPosition    Steerer_Stem        $BB_Position]
    set Steerer(Fork)               [myGUI::model::model_XZ::getPosition    Steerer_Start       $BB_Position]
    set SeatTube(BBracket)          [myGUI::model::model_XZ::getPosition    SeatTube_End        $BB_Position]
    set HandleBar(Position)         [myGUI::model::model_XZ::getPosition    HandleBar           $BB_Position]
    set DownTube(Steerer)           [myGUI::model::model_XZ::getPosition    DownTube_Start      $BB_Position]
    set DownTube(BBracket)          [myGUI::model::model_XZ::getPosition    DownTube_End        $BB_Position]
    set Position(IS_ChainSt_SeatSt) [myGUI::model::model_XZ::getPosition    IS_ChainSt_SeatSt   $BB_Position]
        #
    set help_01                     [vectormath::intersectPerp              $Steerer(Stem) $Steerer(Fork) $FrontWheel(Position) ]
        #
    $cvObject create centerline      [appUtil::flatten_nestedList           $Steerer(Stem)          $HandleBar(Position)            ] -fill gray60 -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList           $Steerer(Stem)          $help_01                        ] -fill gray60 -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList           $FrontWheel(Position)   $help_01                        ] -fill gray60 -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList           $DownTube(BBracket)     $DownTube(Steerer)              ] -fill gray60 -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList           $TopTube(SeatTube)      $TopTube(Steerer)               ] -fill gray60 -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList           $SeatStay(SeatTube)     $Position(IS_ChainSt_SeatSt)    ] -fill gray60 -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList           $Position(IS_ChainSt_SeatSt)    $BottomBracket(Position)] -fill gray60 -tags __CenterLine__
        #
    if {$extend_Saddle eq {extend}} {
        $cvObject create centerline  [appUtil::flatten_nestedList           $SeatTube(BBracket)     $SeatTube(Saddle)               ] -fill gray60 -tags __CenterLine__
    } else {
        $cvObject create centerline  [appUtil::flatten_nestedList           $SeatTube(BBracket)     $SeatTube(TopTube)              ] -fill gray60 -tags __CenterLine__
    }

        # puts "\n =================\n"
        # puts "    $SeatStay(SeatTube)    $SeatStay(RearWheel) "
        # puts "\n =================\n"
        
        #
        #
}

proc myGUI::reference::create_CLineFrameJig        {BB_Position} {
        #
    variable cvObject
        #
        #
        # cline_framejig
        #
    set BottomBracket(Position)     $BB_Position
    set HeadTube(Fork)              [myGUI::model::model_XZ::getPosition    HeadTube_Start      $BB_Position]
    set RearWheel(Position)         [myGUI::model::model_XZ::getPosition    RearWheel           $BB_Position]
    set SeatPost(SeatTube)          [myGUI::model::model_XZ::getPosition    SeatPost_SeatTube   $BB_Position]
    set Steerer(Stem)               [myGUI::model::model_XZ::getPosition    Steerer_Stem        $BB_Position]
    set Steerer(Fork)               [myGUI::model::model_XZ::getPosition    Steerer_Start       $BB_Position]
    
    set FrameJig(SeatTube)          [vectormath::intersectPerp      $SeatPost(SeatTube)   $BottomBracket(Position)  $RearWheel(Position) ]
    set FrameJig(HeadTube)          [vectormath::intersectPoint     $RearWheel(Position)  $FrameJig(SeatTube)       $Steerer(Stem)  $Steerer(Fork) ]
        #
    set help_fk                     [vectormath::intersectPoint     $Steerer(Fork)  $Steerer(Stem)  $FrontWheel(Position) $RearWheel(Position)]
        #
    $cvObject create circle          $HeadTube(Fork)     -radius 7  -outline darkred  -width 0.35  -tags __CenterLine__
    $cvObject create circle          $FrameJig(HeadTube) -radius 7  -outline darkred  -width 0.35  -tags __CenterLine__
    $cvObject create circle          $FrameJig(SeatTube) -radius 7  -outline darkred  -width 0.35  -tags __CenterLine__
    $cvObject create circle          $help_fk            -radius 4  -outline gray50   -width 0.35  -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList $FrameJig(HeadTube) $RearWheel(Position)] \
                                                        -fill darkred  -width 0.25  -tags __CenterLine__
    $cvObject create centerline      [appUtil::flatten_nestedList $RearWheel(Position) $help_fk] \
                                                        -fill darkred   -width 0.25  -tags __CenterLine__
        #
}

proc myGUI::reference::create_CLineFrame_remove    {BB_Position} {
        #
    variable cvObject
        #
        #
        # cline_frame 
        #
    set HeadTube(Stem)          [myGUI::model::model_XZ::getPosition    HeadTube_End            $BB_Position ]
    set TopTube(SeatClassic)    [myGUI::model::model_XZ::getPosition    SeatTube_ClassicTopTube $BB_Position ]
    set TopTube(SeatVirtual)    [myGUI::model::model_XZ::getPosition    SeatTube_VirtualTopTube $BB_Position ]
    set SeatTube(BBracket)      [myGUI::model::model_XZ::getPosition    SeatTube_End            $BB_Position ]
        #
    $cvObject create line        [appUtil::flatten_nestedList $HeadTube(Stem) $TopTube(SeatClassic) $SeatTube(BBracket)] \
                                                            -fill red    -width 3.0  -tags __CenterLine__
        # $cvObject create line        [appUtil::flatten_nestedList $HeadTube(Stem) $TopTube(SeatVirtual) $SeatTube(BBracket)] \
                                                            -fill red    -width 3.0  -tags __CenterLine__
        # $cvObject create centerline  [appUtil::flatten_nestedList $HeadTube(Stem) $TopTube(SeatVirtual) ] \
                                                            -fill darkorange    -width 2.0  -tags __CenterLine__
        #
}



