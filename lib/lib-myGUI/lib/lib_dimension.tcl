 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_dimension.tcl
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
 #    namespace:  myGUI::dimension
 # ---------------------------------------------------------------------------
 #
 #

namespace eval myGUI::dimension {
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
    variable    cvObject    {}    
    variable    cvFilterKey {}
        #
    variable    hideRegistry    [dict create \
                                    Geometry        {} \
                                    Frame           {} \
                                    ChainStay       {} \
                                    Summary         {{D01076 D01077 D01078 D01079 D01082}} \
                                    FrameDrafting   {{D01109 D01123}} \
                                    undefined       {} ]
        #                        
        #   Summary {D01066 D01076 D01077}
        #   Summary {{D01066 D01076 D01077 D01078 D01079 D01082}} \
        #
}
    #
    #
proc myGUI::dimension::create {cvObj BB_Position type filterKey {active {off}} args} {
        #
    variable    cvObject    $cvObj
    variable    cvFilterKey $filterKey
        #
        # puts "     \$cvObj $cvObj"
        # puts "     \$BB_Position $BB_Position"
        # puts "     \$type $type"
        # puts "     \$filterKey $filterKey"
        #
    switch -exact -- $type {
        
        frameTubing_bg              { createDimension_FrameTubing_BG                $BB_Position $type }
            
        summary_bg                  { createDimension_Summary_BG                    $BB_Position $type }
        summary_fg                  { createDimension_Summary_FG                    $BB_Position $type }
            
        frameDrafting_bg            { createDimension_FrameDrafting_BG              $BB_Position $type }
            
        frameJig                    { createDimension_Jig                           $BB_Position $type $active $args}
            
        reference_bg                { createDimension_Reference_BG                  $BB_Position $type }
        reference_fg                { createDimension_Reference_FG                  $BB_Position $type }
            
        HeadTube_Length             { createDimension_HeadTubeLength                $BB_Position $type $active }
        HeadTube_OffsetTT           { createDimension_HeadTubeOffsetTT              $BB_Position $type $active }
        HeadTube_OffsetDT           { createDimension_HeadTubeOffsetDT              $BB_Position $type $active }
        HeadTube_CenterDT           { createDimension_HeadTubeCenterDT              $BB_Position $type $active }
        SeatTube_Extension          { createDimension_SeatTubeExtension             $BB_Position $type $active }
        SeatStay_Offset             { createDimension_SeatStayOffset                $BB_Position $type $active }
        DownTube_Offset             { createDimension_DownTubeOffset                $BB_Position $type $active }
        SeatTube_Offset             { createDimension_SeatTubeOffset                $BB_Position $type $active }
        TopTube_Angle               { createDimension_TopTubeAngle                  $BB_Position $type $active }
        TopHeadTube_Angle           { createDimension_TopHeadTubeAngle              $BB_Position $type $active }
        ForkHeight                  { createDimension_ForkHeight                    $BB_Position $type $active }
        HeadSet_Top                 { createDimension_HeadSetTop                    $BB_Position $type $active }
        HeadSet_Bottom              { createDimension_HeadSetBottom                 $BB_Position $type $active }
        Brake_Rear                  { createDimension_BrakeRear                     $BB_Position $type $active }
        Brake_Front                 { createDimension_BrakeFront                    $BB_Position $type $active }
        BottleCage                  { createDimension_BottleCage                    $BB_Position $type $active }
        DerailleurMount             { createDimension_DerailleurMount               $BB_Position $type $active }
        RearWheel_Clearance         { createDimension_RearWheelClearance            $BB_Position $type }
        LegClearance                { createDimension_LegClearance                  $BB_Position $type }
        
        base_classic_personal       { createDimension_Geometry_classic_personal     $BB_Position $active }
        base_classic_primary        { createDimension_Geometry_classic_primary      $BB_Position $active }
        base_classic_result         { createDimension_Geometry_classic_result       $BB_Position $active }
        base_classic_secondary      { createDimension_Geometry_classic_secondary    $BB_Position $active }
        base_classic_summary        { createDimension_Geometry_classic_summary      $BB_Position }
        base_hybrid_personal        { createDimension_Geometry_hybrid_personal      $BB_Position $active }
        base_hybrid_primary         { createDimension_Geometry_hybrid_primary       $BB_Position $active }
        base_hybrid_result          { createDimension_Geometry_hybrid_result        $BB_Position $active }
        base_hybrid_secondary       { createDimension_Geometry_hybrid_secondary     $BB_Position $active }
        base_hybrid_summary         { createDimension_Geometry_hybrid_summary       $BB_Position }
        base_lugs_personal          { createDimension_Geometry_lugs_personal        $BB_Position $active }
        base_lugs_primary           { createDimension_Geometry_lugs_primary         $BB_Position $active }
        base_lugs_result            { createDimension_Geometry_lugs_result          $BB_Position $active }
        base_lugs_secondary         { createDimension_Geometry_lugs_secondary       $BB_Position $active }
        base_lugs_summary           { createDimension_Geometry_lugs_summary         $BB_Position }
        base_stackreach_personal    { createDimension_Geometry_stackreach_personal  $BB_Position $active }
        base_stackreach_primary     { createDimension_Geometry_stackreach_primary   $BB_Position $active }
        base_stackreach_result      { createDimension_Geometry_stackreach_result    $BB_Position $active }
        base_stackreach_secondary   { createDimension_Geometry_stackreach_secondary $BB_Position $active }
        base_stackreach_summary     { createDimension_Geometry_stackreach_summary   $BB_Position }

        _geometry_bg                { createDimension_Geometry_BG                   $BB_Position $type }
        _geometry_bg_free           { createDimension_Geometry_BG_Free              $BB_Position $type }
        _geometry_fg_free           { createDimension_Geometry_FG_Free              $BB_Position $type $active}
        _geometry_bg_lug            { createDimension_Geometry_BG_Lug               $BB_Position $type }
        _geometry_fg_lug            { createDimension_Geometry_FG_Lug               $BB_Position $type $active}
           
        default                     { error " myGUI::dimension::create -> $BB_Position $type" -1}
    }
        #
    return    
        #
}
    #
proc myGUI::dimension::updateParameter {cvObject BB_Position} {
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
        # colourtable: http://www.ironspider.ca/format_text/fontcolor.htm
        # set colour(primary)       red
        # set colour(secondary)     darkorange
        # set colour(third)         darkblue
        # set colour(result)        darkred
        # set colour(primary)       darkorange
        # set colour(primary)       darkorchid
        # set colour(primary)       red
        # set colour(primary)       blue
        # set colour(secondary)     darkred
        # set colour(secondary)     darkorange
        # set colour(third)         firebrick
        # set colour(result)        firebrick
        # set colour(result)        darkorange
        # set colour(result)        blue
        #
        # --- get stageScale
    if {$cvObject ne {}} {
        set stageScale              [$cvObject  configure   Stage   Scale ]
    } else {
        set stageScale              0.123456
    }
        #
    set ChainStay(Dropout)          [myGUI::model::model_XZ::getPosition    ChainStay_RearWheel             $BB_Position]
    set DownTube(BBracket)          [myGUI::model::model_XZ::getPosition    DownTube_End                    $BB_Position]
    set DownTube(Steerer)           [myGUI::model::model_XZ::getPosition    DownTube_Start                  $BB_Position]
    set DownTube(SeatTubeIS)        [myGUI::model::model_XZ::getPosition    _Edge_DownTubeSeatTube_Miter    $BB_Position]
    set Position(IS_ChainSt_SeatSt) [myGUI::model::model_XZ::getPosition    IS_ChainSt_SeatSt               $BB_Position]
    set BottomBracket(Position)     [myGUI::model::model_XZ::getPosition    BottomBracket                   $BB_Position]
    set CrankSet(Position)          [myGUI::model::model_XZ::getPosition    CrankSet                        $BB_Position]
    set FrontBrake(Definition)      [myGUI::model::model_XZ::getPosition    FrontBrake_Definition           $BB_Position]
    set FrontBrake(Help)            [myGUI::model::model_XZ::getPosition    FrontBrake_Help                 $BB_Position]
    set FrontBrake(Mount)           [myGUI::model::model_XZ::getPosition    FrontBrake_Mount                $BB_Position]
    set FrontBrake(Shoe)            [myGUI::model::model_XZ::getPosition    FrontBrake_Shoe                 $BB_Position]
    set FrontWheel(Ground)          [myGUI::model::model_XZ::getPosition    FrontWheel_Ground               $BB_Position]
    set FrontWheel(Position)        [myGUI::model::model_XZ::getPosition    FrontWheel                      $BB_Position]
    set HandleBar(Position)         [myGUI::model::model_XZ::getPosition    HandleBar                       $BB_Position]
    set HeadTube(Fork)              [myGUI::model::model_XZ::getPosition    HeadTube_Start                  $BB_Position]
    set HeadTube(Stem)              [myGUI::model::model_XZ::getPosition    HeadTube_End                    $BB_Position]
    set HeadSet(Top)                [myGUI::model::model_XZ::getPosition    HeadSet_Top                     $BB_Position]
    set LegClearance(Position)      [myGUI::model::model_XZ::getPosition    LegClearance                    $BB_Position]
    set Position(BaseCenter)        [myGUI::model::model_XZ::getPosition    BottomBracket_Ground            $BB_Position]
    set Position(help_91)           [myGUI::model::model_XZ::getPosition    help_91                         $BB_Position]
    set Position(help_92)           [myGUI::model::model_XZ::getPosition    help_92                         $BB_Position]
    set Position(help_93)           [myGUI::model::model_XZ::getPosition    help_93                         $BB_Position]
    set RearBrake(Definition)       [myGUI::model::model_XZ::getPosition    RearBrake_Definition            $BB_Position]
    set RearBrake(Help)             [myGUI::model::model_XZ::getPosition    RearBrake_Help                  $BB_Position]
    set RearBrake(Mount)            [myGUI::model::model_XZ::getPosition    RearBrake_Mount                 $BB_Position]
    set RearBrake(Shoe)             [myGUI::model::model_XZ::getPosition    RearBrake_Shoe                  $BB_Position]
    set RearWheel(Ground)           [myGUI::model::model_XZ::getPosition    RearWheel_Ground                $BB_Position]
    set RearWheel(Position)         [myGUI::model::model_XZ::getPosition    RearWheel                       $BB_Position]
    set Reference(HandleBar)        [myGUI::model::model_XZ::getPosition    Reference_HB                    $BB_Position]
    set Reference(SaddleNose)       [myGUI::model::model_XZ::getPosition    Reference_SN                    $BB_Position]
    set Saddle(Mount)               [myGUI::model::model_XZ::getPosition    Saddle_Mount                    $BB_Position]
    set Saddle(Position)            [myGUI::model::model_XZ::getPosition    Saddle                          $BB_Position]
    set Saddle(Proposal)            [myGUI::model::model_XZ::getPosition    SaddleProposal                  $BB_Position]
    set SaddleNose(Position)        [myGUI::model::model_XZ::getPosition    SaddleNose                      $BB_Position]
    set SeatPost(Position)          [myGUI::model::model_XZ::getPosition    SeatPost                        $BB_Position]
    set SeatPost(PivotPosition)     [myGUI::model::model_XZ::getPosition    SeatPost_Pivot                  $BB_Position]
    set SeatPost(Saddle)            [myGUI::model::model_XZ::getPosition    Saddle_Mount                    $BB_Position]
    set SeatPost(SeatTube)          [myGUI::model::model_XZ::getPosition    SeatPost_SeatTube               $BB_Position]
    set SeatStay(End)               [myGUI::model::model_XZ::getPosition    SeatStay_End                    $BB_Position]
    set SeatStay(SeatTube)          [myGUI::model::model_XZ::getPosition    SeatStay_End                    $BB_Position]
    set SeatTube(BBracket)          [myGUI::model::model_XZ::getPosition    SeatTube_End                    $BB_Position]
    set SeatTube(Ground)            [myGUI::model::model_XZ::getPosition    SeatTube_Ground                 $BB_Position]
    set SeatTube(Saddle)            [myGUI::model::model_XZ::getPosition    SeatTube_Saddle                 $BB_Position]
    set SeatTube(TopTube)           [myGUI::model::model_XZ::getPosition    SeatTube_Start                  $BB_Position]
    
    set SeatTube(TopTube_Back)      [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTop_Back          $BB_Position]
    
    set Steerer(End)                [myGUI::model::model_XZ::getPosition    Steerer_Stem                    $BB_Position]
    set Steerer(Fork)               [myGUI::model::model_XZ::getPosition    Steerer_Start                   $BB_Position]
    set Steerer(Ground)             [myGUI::model::model_XZ::getPosition    Steerer_Ground                  $BB_Position]
    set Steerer(Start)              [myGUI::model::model_XZ::getPosition    Steerer_Start                   $BB_Position]
    set Steerer(Stem)               [myGUI::model::model_XZ::getPosition    Steerer_Stem                    $BB_Position]
    set TopTube(SeatClassic)        [myGUI::model::model_XZ::getPosition    SeatTube_ClassicTopTube         $BB_Position]
    set TopTube(SeatTube)           [myGUI::model::model_XZ::getPosition    TopTube_End                     $BB_Position]
    set TopTube(SeatVirtual)        [myGUI::model::model_XZ::getPosition    SeatTube_VirtualTopTube         $BB_Position]
    set TopTube(Steerer)            [myGUI::model::model_XZ::getPosition    TopTube_Start                   $BB_Position]
    
    set Config(BottleCage_DT)       [myGUI::model::model_XZ::getConfig      BottleCage_DownTube         ]
    set Config(BottleCage_DT_L)     [myGUI::model::model_XZ::getConfig      BottleCage_DownTube_Lower   ]
    set Config(BottleCage_ST)       [myGUI::model::model_XZ::getConfig      BottleCage_SeatTube         ]
    set Config(BrakeFront)          [myGUI::model::model_XZ::getConfig      FrontBrake                  ]
    set Config(BrakeRear)           [myGUI::model::model_XZ::getConfig      RearBrake                   ]

    set DownTube(polygon)           [myGUI::model::model_XZ::getPolygon     DownTube                        $BB_Position]
    set HeadTube(polygon)           [myGUI::model::model_XZ::getPolygon     HeadTube                        $BB_Position]
    set SeatTube(polygon)           [myGUI::model::model_XZ::getPolygon     SeatTube                        $BB_Position]
    set TopTube(polygon)            [myGUI::model::model_XZ::getPolygon     TopTube                         $BB_Position] 
    
    set Length(Height_HB_Seat)      [myGUI::model::model_XZ::getLength      Height_HB_Seat  ]
    set Length(Height_HT_Seat)      [myGUI::model::model_XZ::getLength      Height_HT_Seat  ]
    set Length(Length_BB_Seat)      [myGUI::model::model_XZ::getLength      Length_BB_Seat  ]
    
    set BottomBracket(Depth)        [myGUI::model::model_XZ::getScalar      BottomBracket   Depth           ]
    set BottomBracket(Excenter)     [myGUI::model::model_XZ::getScalar      BottomBracket   ExcenterOffset  ]
    set DownTube(OffsetBB)          [myGUI::model::model_XZ::getScalar      DownTube        OffsetBB        ]
    set Fork(Height)                [myGUI::model::model_XZ::getScalar      Fork            Height          ]
    set Fork(Rake)                  [myGUI::model::model_XZ::getScalar      Fork            Rake            ]
    set FrontWheel(Radius)          [myGUI::model::model_XZ::getScalar      FrontWheel      Radius          ]
    set FrontWheel(RimDiameter)     [myGUI::model::model_XZ::getScalar      FrontWheel      RimDiameter     ]
    set FrontWheel(TyreHeight)      [myGUI::model::model_XZ::getScalar      FrontWheel      TyreHeight      ]
    set HeadSet(Diameter)           [myGUI::model::model_XZ::getScalar      HeadSet         Diameter_Top    ]
    set HeadTube(Diameter)          [myGUI::model::model_XZ::getScalar      HeadTube        Diameter        ]
    set CrankSet(Length)            [myGUI::model::model_XZ::getScalar      CrankSet        Length          ]
    set RearDrop(OffsetCSPerp)      [myGUI::model::model_XZ::getScalar      RearDropout     OffsetCSPerp    ]
    set RearDrop(OffsetSSPerp)      [myGUI::model::model_XZ::getScalar      RearDropout     OffsetSSPerp    ]
    set RearWheel(Radius)           [myGUI::model::model_XZ::getScalar      RearWheel       Radius          ]
    set RearWheel(RimDiameter)      [myGUI::model::model_XZ::getScalar      RearWheel       RimDiameter     ]
    set RearWheel(TyreHeight)       [myGUI::model::model_XZ::getScalar      RearWheel       TyreHeight      ]
    set SeatTube(Diameter)          [myGUI::model::model_XZ::getScalar      SeatTube        Diameter        ]
    set SeatTube(OffsetBB)          [myGUI::model::model_XZ::getScalar      SeatTube        OffsetBB        ]
    set Steerer(Diameter)           [myGUI::model::model_XZ::getScalar      Steerer         Diameter        ]
    set Stem(Angle)                 [myGUI::model::model_XZ::getScalar      Stem            Angle           ]
    set Stem(Length)                [myGUI::model::model_XZ::getScalar      Stem            Length          ]
    set TopTube(Angle)              [myGUI::model::model_XZ::getScalar      Geometry        TopTube_Angle   ]

    set HeadSet(vct_Bottom)         [myGUI::model::model_XZ::getVector      HeadSet_Bottom          $BB_Position]
    set HeadSet(vct_Top)            [myGUI::model::model_XZ::getVector      HeadSet_Top             $BB_Position]
    set HeadTube(vct_Bottom)        [myGUI::model::model_XZ::getVector      HeadTube_Bottom         $BB_Position]
    set HeadTube(vct_Top)           [myGUI::model::model_XZ::getVector      HeadTube_Top            $BB_Position]
    set SeatTube(vct_Top)           [myGUI::model::model_XZ::getVector      SeatTube_Top            $BB_Position]
    set Steerer(vct_Bottom)         [myGUI::model::model_XZ::getVector      Steerer_Bottom          $BB_Position] 
    
    
    set FrameJig(SeatTube)          [vectormath::intersectPerp      $SeatPost(SeatTube)   $BottomBracket(Position)  $RearWheel(Position) ]
    set FrameJig(HeadTube)          [vectormath::intersectPoint     $RearWheel(Position)  $FrameJig(SeatTube)   $Steerer(Stem)  $Steerer(Fork) ]
    set FrameJig(SeatTube)          [vectormath::intersectPerp      $SeatPost(SeatTube)   $BottomBracket(Position)  $RearWheel(Position) ]
    
    switch -exact -- $::APPL_Config(FrameJigType) {    
        vienna -
        selberbruzzler {                          
            set FrameJig(SeatTube)  [vectormath::intersectPerp      $SeatPost(SeatTube)   $BottomBracket(Position)  $RearWheel(Position) ]
            set FrameJig(HeadTube)  [vectormath::intersectPoint     $RearWheel(Position)  $FrameJig(SeatTube)   $Steerer(Stem)  $Steerer(Fork) ]
                #
            set angle_SeatTube      [vectormath::angle              $RearWheel(Position) $FrameJig(SeatTube) $BottomBracket(Position)]                        
            set angle_HeadTube      [vectormath::angle              $RearWheel(Position) $FrameJig(HeadTube) $Steerer(Stem)]                        
            set FrameJig(Angles)    [list $angle_SeatTube $angle_HeadTube]
        }
        nuremberg -
        vogeltanz {                          
            set FrameJig(HeadTube)  [vectormath::intersectPerp      $Steerer(Stem)  $Steerer(Fork)  $RearWheel(Position) ]
            set FrameJig(SeatTube)  [vectormath::intersectPoint     $RearWheel(Position)  $FrameJig(HeadTube)   $SeatPost(SeatTube)   $BottomBracket(Position) ]
                #
            set help_bb             [list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
            set help_fk             [vectormath::intersectPoint     $Steerer(Fork)  $Steerer(Stem)   $help_bb $BottomBracket(Position) ]
                #
            set hlp_01              [vectormath::addVector          $BottomBracket(Position) {-100 0} ] 
            set angle_SeatTube      [vectormath::angle              $help_bb $BottomBracket(Position) $SeatPost(SeatTube)]                        
            set angle_SeatChain     [vectormath::angle              $RearWheel(Position) $BottomBracket(Position) $SeatPost(SeatTube)]                        
            set angle_HeadTube      [vectormath::angle              $BottomBracket(Position) $help_fk $Steerer(Stem)]                        
            set FrameJig(Angles)    [list $angle_SeatTube $angle_SeatChain $angle_HeadTube]
        }
        geldersheim {                          
            set FrameJig(HeadTube)  [vectormath::intersectPerp      $Steerer(Stem)  $Steerer(Fork)  $BottomBracket(Position) ]
            set FrameJig(SeatTube)  $BottomBracket(Position)
                #
            set help_bb             [vectormath::intersectPerp      $FrameJig(HeadTube)    $FrameJig(SeatTube)  $RearWheel(Position) ]
            set help_fk             $FrameJig(HeadTube) 
            set hlp_01              [vectormath::addVector          $BottomBracket(Position) {-100 0} ] 
                #
            set angle_SeatTube      [vectormath::angle $SeatPost(SeatTube) $BottomBracket(Position) $help_bb]                        
            set angle_SeatChain     [vectormath::angle $RearWheel(Position) $BottomBracket(Position) $help_bb]                        
            set angle_HeadTube      [vectormath::angle $BottomBracket(Position) $help_fk $Steerer(Stem)]                        
            set FrameJig(Angles)    [list $angle_SeatTube $angle_SeatChain $angle_HeadTube]
        }
        MeisterJIG {
            set FrameJig(BB_RearWheel)  [list [lindex $BottomBracket(Position) 0] [lindex $RearWheel(Position) 1] ]
            set FrameJig(BB_HeadTube)   [list [lindex $BottomBracket(Position) 0] [lindex $HeadTube(Fork)      1] ]
                #
            set help_rw                 [vectormath::addVector $RearWheel(Position) {-100 0} ] 
                #
            set FrameJig(RW_SeatStay)   [vectormath::intersectPoint $BottomBracket(Position) $SeatPost(SeatTube) $RearWheel(Position) $help_rw]
                #
            set angle_SeatTube      [vectormath::angle $SeatPost(SeatTube)    $FrameJig(RW_SeatStay)    $help_rw]                        
            set angle_HeadTube      [vectormath::angle $FrameJig(BB_HeadTube) $HeadTube(Fork)           $Steerer(Stem)]                        
            set FrameJig(Angles)    [list $angle_SeatTube $angle_HeadTube]
        }
        ilz -
        graz -
        rattleCAD -
        default {                          
            set FrameJig(HeadTube)  [vectormath::intersectPerp       $Steerer(Stem)  $Steerer(Fork)  $RearWheel(Position) ]
            set FrameJig(SeatTube)  [vectormath::intersectPoint      $RearWheel(Position)  $FrameJig(HeadTube)   $SeatPost(SeatTube)   $BottomBracket(Position) ]
                #
            set angle_SeatTube      [vectormath::angle $RearWheel(Position) $FrameJig(SeatTube) $BottomBracket(Position)]                        
            set angle_HeadTube      [vectormath::angle $RearWheel(Position) $FrameJig(HeadTube) $Steerer(Stem)]                        
            set FrameJig(Angles)    [list $angle_SeatTube $angle_HeadTube]
        }
    }
        #
    return
        #
}
    #
proc myGUI::dimension::getDenyList {filterKey} {
        #
    variable    hideRegistry
        #
        # puts "    -> \$filterKey $filterKey"
    if {[dict exists $hideRegistry $filterKey]} {
        set denyList    [join [dict get $hideRegistry $filterKey]]
        return $denyList
    } else {
        return {}
    }
        #
}
    #
proc myGUI::dimension::createDimension {id type coords args} {
        #
    variable    hideRegistry
    variable    cvObject
    variable    cvFilterKey
        #
        # puts "  -> myGUI::dimension::createDimension"
        # puts "      -> \$id     $id"
        # puts "      -> \$type   $type"
        # puts "      -> \$coords $coords"
        # puts "      -> \$args   $args"
        #
    if {$id eq {A00000}} {
            # puts "      ... do the shortcut -> A00000"
        switch -exact $type {
            angle {
                set dimension   [$cvObject create dimensionAngle    [list $coords] [join $args]]
            }
            length {
                set dimension   [$cvObject create dimensionLength   [list $coords] [join $args]]
            }
            radius {
                set dimension   [$cvObject create dimensionRadius   [list $coords] [join $args]]
            }
            default {
                puts "  <E> myGUI::dimension::createDimension:  $type ... not defined"
            }
        }
            # set dimension   [eval $cvObject createDimension $type [list $coords] $args]
        return $dimension
    }
        #
        # puts "   \$cvFilterKey $cvFilterKey"
    set denyList    [getDenyList $cvFilterKey]
        # puts "          -> \$denyList -> $target: $denyList"
        #
    if {[lsearch -exact -ascii $denyList $id] < 0} { 
            # ... $id not found in $denyList
        switch -exact $type {
            angle {
                set dimension   [$cvObject create dimensionAngle    [list $coords] [join $args]]
            }
            length {
                set dimension   [$cvObject create dimensionLength   [list $coords] [join $args]]
            }
            radius {
                set dimension   [$cvObject create dimensionRadius   [list $coords] [join $args]]
            }
            default {
                puts "  <E> myGUI::dimension::createDimension:  $type ... not defined"
            }
        }
            # set dimension   [eval $cvObject createDimension $type [list $coords] $args]
        $dimension add_UID $id
            #
    } else {
            # ... $id found in $denyList                
        set dimension   {}
            #
    }  
        #
    return $dimension
        #
}
    #
proc myGUI::dimension::createDimension_FrameTubing_BG       {BB_Position type} {

    variable    cvObject
       
    variable    stageScale

    variable    Rendering
    variable    Reference
    
    variable    BottomBracket
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

    variable    Position
    variable    Length
    variable    Angle
    variable    Vector  

    
        # -- debug ------------------------
        #
    
    foreach {a b} $Steerer(vct_Bottom) break
    set myDirection [vectormath::dirAngle $a $b]
    set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetTopFront_Top       {0 0}]
    set pt_04 $HeadTube(Stem)
    set pt_05 [vectormath::addVector $pt_04 [vectormath::rotatePoint  {0 0} $pt_01  $myDirection]]
    set pt_05 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetTopFront_Top       $BottomBracket(Position) ]
    
    
    
    
    
        # -- Dimensions ------------------------
        #
    set _dim_ST_Length_01       [createDimension    D01001  length \
                                        [list $SeatTube(vct_Top) $SeatTube(BBracket)] \
                                        perpendicular   [expr  -100 * $stageScale]  0 \
                                        gray50 ]
    set _dim_ST_Length_02       [createDimension    D01002  length \
                                        [list $SeatTube(BBracket) $TopTube(SeatTube)] \
                                        aligned         [expr   75 * $stageScale]   [expr  -100 * $stageScale] \
                                        gray50 ]
    set _dim_HT_Reach_X         [createDimension    D01003  length \
                                        [list $HeadTube(Stem) $CrankSet(Position)] \
                                        horizontal      [expr -110 * $stageScale]   0 \
                                        gray50 ]
    set _dim_HT_Stack_Y         [createDimension    D01004  length \
                                        [list $HeadTube(Stem) $CrankSet(Position)] \
                                        vertical        [expr  110 * $stageScale]   [expr  120 * $stageScale]  \
                                        gray50 ]
    set _dim_BB_Excenter        [createDimension    D01005  length \
                                        [list $BottomBracket(Position) $CrankSet(Position)] \
                                        vertical        [expr -200 * $stageScale]   [expr   30 * $stageScale]  \
                                        gray50 ]

    set _dim_HS_Stem            [createDimension    D01006  length \
                                        [list $HeadSet(Top) $pt_05 $Steerer(Stem)] \
                                        perpendicular   [expr   50 * $stageScale]   [expr -70 * $stageScale] \
                                        gray50 ]                                               
                                        # $HeadSet(Diameter)
    set _dim_RearBrake          [createDimension    D01007  length \
                                        [list $RearWheel(Position)  $RearBrake(Mount)] \
                                        aligned         [expr  -85 * $stageScale]   0  \
                                        gray50 ]
    set _dim_Head_Down_Angle    [createDimension    D01008  angle \
                                        [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] \
                                        180   0 \
                                        gray50 ]
    set _dim_Seat_Top_Angle     [createDimension    D01009  angle \
                                        [list $TopTube(SeatTube) $SeatTube(BBracket) $TopTube(Steerer)] \
                                        110  10 \
                                        gray50 ]
        set pt_base             [vectormath::intersectPoint        $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
    set _dim_Down_Seat_Angle    [createDimension    D01010  angle \
                                        [list $pt_base  $DownTube(Steerer) $TopTube(SeatTube)] \
                                        110   0 \
                                        gray50 ]
    set _dim_Seat_SS_Angle      [createDimension    D01011  angle \
                                        [list $SeatStay(SeatTube) $Position(IS_ChainSt_SeatSt) $SeatTube(BBracket)] \
                                        110   0 \
                                        gray50 ]
        set pt_base             [vectormath::intersectPoint        $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $Position(IS_ChainSt_SeatSt) ]
    set _dim_ST_CS_Angle        [createDimension    D01012  angle \
                                        [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] \
                                        110   0 \
                                        gray50 ]
    set _dim_Dropout_Angle      [createDimension    D01013  angle \
                                        [list $Position(IS_ChainSt_SeatSt) $BottomBracket(Position) $SeatStay(SeatTube)] \
                                        110   0 \
                                        gray50 ]

        set pt_01               [vectormath::addVector             $BottomBracket(Position) {-180 0} ]
        set pt_base             [vectormath::intersectPoint        $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $pt_01 ]
    set _centerLine             [$cvObject create centerline [list $BottomBracket(Position)  $pt_01] -fill gray60 -tags __CenterLine__]
    set _dim_SeatTube_Angle     [createDimension    D01014  angle \
                                        [list $pt_base $SeatTube(TopTube) $pt_01] \
                                        150   0 \
                                        gray50 ]

        set pt_01               [vectormath::intersectPoint        $Steerer(Stem)  $Steerer(Fork)        $FrontWheel(Position) [vectormath::addVector    $FrontWheel(Position) {-10 0}] ]
        set pt_02               [vectormath::addVector             $pt_01 {-1 0} 120 ]
    set _centerLine             [$cvObject create centerline [list $FrontWheel(Position) $pt_02] -fill gray60 -tags __CenterLine__]
    set _dim_HeadTube_Angle     [createDimension    D01015  angle \
                                        [list $pt_01 $Steerer(Stem) $pt_02] \
                                        110   0 \
                                        gray50 ]

        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top     $BB_Position]
        set pt_03               [myGUI::model::model_XZ::getPosition    HeadTube_End                $BB_Position]
    set _dim_TT_Offset          [createDimension    D01016  length \
                                        [list $pt_03 $pt_01  $TopTube(Steerer)  ] \
                                        perpendicular   [expr    (-70 + 0.5 * $HeadTube(Diameter)) * $stageScale]   [expr  -25 * $stageScale] \
                                        gray50 ]

    #    set pt_01   [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom  $BB_Position]
    #    set pt_03   [myGUI::model::model_XZ::getPosition    HeadTube_Start              $BB_Position]
    # set _dim_DT_Offset        [createDimension    D01017  length \
                                        [appUtil::flatten_nestedList   $pt_03 $pt_01  $DownTube(Steerer) ] \
                                        perpendicular               [expr    (70 - 0.5 * $HeadTube(Diameter))* $stageScale]     [expr  -20 * $stageScale] \
                                        gray50 ]

        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Bottom   $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom  $BB_Position]
    set _dim_HT_Dia_Bottom      [createDimension    D01018  length \
                                        [list $pt_02 $pt_01] \
                                        aligned         [expr    -70 * $stageScale]     [expr -40 * $stageScale] \
                                        gray50 ]
    if {[myGUI::model::model_XZ::getConfig HeadTube] != {cylindric}} {
                set pt_01       [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Top      $BB_Position]
                set pt_02       [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top     $BB_Position]
            set _dim_HT_Dia_Top [createDimension    D01019  length \
                                        [list $pt_01 $pt_02] \
                                        aligned         [expr   -130 * $stageScale]     [expr   0 * $stageScale] \
                                        gray50 ]                             
    }
        #
    set _dim_BB_Depth           [createDimension    D01020  length \
                                        [list       $RearWheel(Position)  $BottomBracket(Position)] \
                                        vertical    [expr -160 * $stageScale] [expr 80 * $stageScale] \
                                        gray50 ]
    set _dim_CS_Length          [createDimension    D01021  length \
                                        [list       $RearWheel(Position)  $BottomBracket(Position)] \
                                        aligned     [expr 80 * $stageScale] 0\
                                        gray50 ]
    set _dim_FW_Distance        [createDimension    D01022  length \
                                        [list       $BottomBracket(Position)  $FrontWheel(Position)] \
                                        aligned     [expr 80 * $stageScale] 0 \
                                        gray50 ]
        #                                
    return
        #
}
proc myGUI::dimension::createDimension_Summary_BG           {BB_Position type} {
        #
    variable    cvObject
    
    variable    stageScale

    variable    Rendering
    variable    Reference

    variable    BottomBracket
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

    variable    Position  
        #

    set help_01                 [list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]

    set _dim_SD_Height          [createDimension    D01030  length \
                                        [list       $Position(BaseCenter)    $Saddle(Position)] \
                                        vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                        gray50]
    set _dim_HB_Height          [createDimension    D01032  length \
                                        [list       $HandleBar(Position)     $Position(BaseCenter)] \
                                        vertical    [expr -350 * $stageScale]  [expr  230 * $stageScale]  \
                                        gray50]
    set _dim_SD_HB_Height       [createDimension    D01033  length \
                                        [list       $HandleBar(Position)     $Saddle(Position) ] \
                                        vertical    [expr  350 * $stageScale]  [expr -100 * $stageScale]  \
                                        gray50]
        #
    return                               
        #
}    
proc myGUI::dimension::createDimension_Summary_FG           {BB_Position type} {

    variable    cvObject 
    
    variable    stageScale

    variable    Config
    variable    Rendering
    variable    Reference

    variable    BottomBracket
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

    variable    Position
    variable    Length
    variable    Angle
    variable    Vector  


    set help_00                 [vectormath::addVector  $SeatTube(Ground) {-200 0} ]
    set help_rw                 [vectormath::rotateLine $RearWheel(Position)        $RearWheel(Radius)        230 ]
    set help_fw                 [vectormath::rotateLine $FrontWheel(Position)       $FrontWheel(Radius)       -50 ]
    set help_fk                 [vectormath::addVector  $Steerer(Fork) [vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
    set distY_SN_LC             [expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
    
     

    set _dim_ST_Length          [createDimension    D01051  length \
                                        [list $CrankSet(Position)       $SeatTube(Saddle) ] \
                                        aligned     [expr -150 * $stageScale]   [expr -210 * $stageScale]  \
                                        darkblue ]

    set _dim_BB_Depth           [createDimension    D01052  length \
                                        [list $RearWheel(Position)      $BottomBracket(Position) ] \
                                        vertical    [expr  100 * $stageScale]   [expr   80 * $stageScale] \
                                        gray50 ]
                                        
    set _dim_Crank_Height       [createDimension    D01053  length \
                                        [list $CrankSet(Position)       $Position(BaseCenter)] \
                                        vertical    [expr  200 * $stageScale]   [expr   30 * $stageScale]  \
                                        darkred ]

    if {$BottomBracket(Excenter) != 0} {
    
        set _dim_BB_Excenter    [createDimension    D01054  length \
                                        [list       $BottomBracket(Position) $CrankSet(Position)] \
                                        aligned     [expr  200 * $stageScale]   [expr   40 * $stageScale]  \
                                        darkred ]
            #
        set _dim_BB_Height      [createDimension    D01055  length \
                                        [list       $BottomBracket(Position)  $Position(BaseCenter)] \
                                        vertical    [expr  250 * $stageScale]   [expr   30 * $stageScale] \
                                        gray50 ]
    }
                                        


    set _dim_RW_Radius          [createDimension    D01056  radius \
                                        [list       $RearWheel(Position)     $help_rw] \
                                        0           [expr  30 * $stageScale] \
                                        gray50 ]
    set _dim_FW_Radius          [createDimension    D01057  radius \
                                        [list       $FrontWheel(Position)    $help_fw] \
                                        0          [expr  30 * $stageScale] \
                                        gray50 ]
                                        
    set _dim_Fork_Rake          [createDimension    D01058  length \
                                        [list       $Steerer(Stem)           $help_fk $FrontWheel(Position) ] \
                                        perpendicular [expr 30 * $stageScale]   [expr   80 * $stageScale] \
                                        gray50 ]
    set _dim_CS_LengthX         [createDimension    D01059  length \
                                        [list       $RearWheel(Ground)       $Position(BaseCenter) ] \
                                        horizontal  [expr   70 * $stageScale]   0 \
                                        gray50 ]
    set _dim_FW_DistanceX       [createDimension    D01060  length \
                                        [list       $Position(BaseCenter)    $FrontWheel(Ground) ] \
                                        horizontal  [expr   70 * $stageScale]   0 \
                                        gray50 ]
    set _dim_FW_Distance        [createDimension    D01061  length \
                                        [list       $CrankSet(Position)      $FrontWheel(Position)] \
                                        aligned     [expr  150 * $stageScale]   [expr  -90 * $stageScale] \
                                        gray50 ]
    set _dim_Wh_Distance        [createDimension    D01062  length \
                                        [list       $RearWheel(Ground)      $FrontWheel(Ground) ] \
                                        horizontal  [expr  130 * $stageScale]   0 \
                                        gray50 ]
    set _dim_FW_Lag             [createDimension    D01063  length \
                                        [list       $FrontWheel(Ground)     $Steerer(Ground) ] \
                                        horizontal  [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                                        gray50 ]
    set _dim_CS_Length          [createDimension    D01064  length \
                                        [list       $RearWheel(Position)    $BottomBracket(Position)] \
                                        aligned     [expr  180 * $stageScale]   [expr   80 * $stageScale] \
                                        gray50 ]
                                        
                                        
    set _dim_SN_HandleBar       [createDimension    D01065  length \
                                        [list       $SaddleNose(Position)   $HandleBar(Position)] \
                                        horizontal  [expr -120 * $stageScale]   0 \
                                        gray50 ]
    set _dim_HandleBar          [createDimension    D01066  length \
                                        [list       $SaddleNose(Position)     $HandleBar(Position) ] \
                                        aligned     [expr -110 * $stageScale]   [expr -100 * $stageScale]  \
                                        gray50] ;   # ... check variable: hideRegistry
                                

    set _dim_HT_Angle           [createDimension    D01067  angle \
                                        [list       $Steerer(Ground)        $Steerer(Fork)  $Position(BaseCenter) ] \
                                        120   0  \
                                        darkred ]
    set _dim_ST_Angle           [createDimension    D01068  angle \
                                        [list       $SeatTube(Ground)       $SeatTube(Saddle) $help_00 ] \
                                        120   0  \
                                        darkred ]

    set _dim_ST_XPosition       [createDimension    D01069  length \
                                        [list       $SeatTube(Saddle)       $BottomBracket(Position) ] \
                                        horizontal  [expr -120 * $stageScale]    0 \
                                        darkblue ]

    set _dim_SD_XPosition       [createDimension    D01070  length \
                                        [list       $Saddle(Position)       $BottomBracket(Position) ] \
                                        horizontal  [expr  -180 * $stageScale]  0 \
                                        darkred ]
    set _dim_SD_YPosition       [createDimension    D01071  length \
                                        [list       $CrankSet(Position)     $Saddle(Position) ] \
                                        vertical    [expr -580 * $stageScale]   [expr -130 * $stageScale]  \
                                        darkred ]
    
    set _dim_HB_XPosition       [createDimension    D01072  length \
                                        [list       $HandleBar(Position)    $CrankSet(Position) ] \
                                        horizontal  [expr (180 + $Length(Height_HB_Seat)) * $stageScale]   0 \
                                        darkred ]
    set _dim_HB_YPosition       [createDimension    D01073  length \
                                        [list       $HandleBar(Position)    $CrankSet(Position) ] \
                                        vertical    [expr -270 * $stageScale]   [expr  180 * $stageScale]  \
                                        darkred ]
                                        
    set _dim_HT_Stack           [createDimension    D01074  length \
                                        [list       $HeadTube(Stem)         $CrankSet(Position)] \
                                        vertical    [expr -280 * $stageScale]   [expr  170 * $stageScale]  \
                                        darkblue ]
    set _dim_HT_Reach           [createDimension    D01075  length \
                                        [list       $HeadTube(Stem)         $BottomBracket(Position)] \
                                        horizontal  [expr  (120 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                                        darkblue ]
    

    if {$TopTube(Angle) != 0} {
        set _dim_TT_Effective   [createDimension    D01076  length \
                                        [list       $TopTube(Steerer)       $TopTube(SeatVirtual)] \
                                        horizontal  [expr  130 * $stageScale]  [expr  120 * $stageScale]  \
                                        gray50]
    }
    set _dim_SeatPost           [createDimension    D01077  length \
                                        [list $SeatTube(TopTube) $SeatTube(TopTube_Back) $Saddle(Mount)] \
                                        perpendicular   [expr  -80 * $stageScale]  0 \
                                        gray50]


        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeHeadTube_TT    $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Top      $BB_Position]
        set pt_03               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top     $BB_Position]
        set pt_04               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom  $BB_Position]
        set pt_05               [myGUI::model::model_XZ::getPosition    HeadTube_End                $BB_Position]
        set pt_06               [myGUI::model::model_XZ::getPosition    HeadTube_Start              $BB_Position]
            #
    set _dim_HeadTube_OffsetTT  [createDimension    D01078  length \
                                        [list       $pt_05 $pt_02 $pt_01] \
                                        perpendicular [expr  100 * $stageScale] [expr 30 * $stageScale] \
                                        gray50]
    set _dim_HeadTube           [createDimension    D01079  length \
                                        [list       $pt_06 $pt_04 $pt_03 ] \
                                        perpendicular [expr  100 * $stageScale] 0 \
                                        gray50]


    set _dim_LC_Position_x      [createDimension    D01080  length \
                                        [list       $LegClearance(Position)     $CrankSet(Position)] \
                                        horizontal  [expr   $distY_SN_LC * $stageScale]   0  \
                                        darkblue ]
    set _dim_LC_Position_y      [createDimension    D01081  length \
                                        [list       $LegClearance(Position)     $Position(BaseCenter)] \
                                        vertical    [expr -130 * $stageScale]   [expr 250 * $stageScale]  \
                                        darkblue ]
                                        
        
        set pt_11               [myGUI::model::model_XZ::getPosition    HeadTube_End                $BB_Position]
        set pt_12               [myGUI::model::model_XZ::getPosition    _Edge_HeadSetTopBack_Bottom $BB_Position]
        set pt_13               [myGUI::model::model_XZ::getPosition    _Edge_HeadSetTopBack_Top    $BB_Position]
        set pt_14               [myGUI::model::model_XZ::getPosition    _Edge_SpacerBack_Bottom     $BB_Position]
        set pt_15               [myGUI::model::model_XZ::getPosition    _Edge_SpacerBack_Top        $BB_Position]
            #
    set _dim_SpacerStack        [createDimension    D01082  length \
                                        [list       $pt_11 $pt_12 $pt_15] \
                                        perpendicular [expr   -50 * $stageScale] [expr -30 * $stageScale] \
                                        gray50]
        
        
        #
        # -- the only editable dimensions here
        #
    set _dim_SD_Nose_Dist       [createDimension    D01091  length \
                                        [list       $SaddleNose(Position)       $BottomBracket(Position)] \
                                        horizontal  [expr   $distY_SN_LC * $stageScale]   0  \
                                        darkmagenta ]
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_SD_Nose_Dist       single_Result_Saddle_Offset_BB_Nose


        #                                
        # -- dim_LegClearance
        #
    set pt_01                   [myGUI::model::model_XZ::getPosition    LegClearance    $BottomBracket(Position)  ]
    set pt_09                   [myGUI::model::model_XZ::getPosition    _Edge_TopTubeTaperTop_HT    $BottomBracket(Position)]
    set pt_10                   [myGUI::model::model_XZ::getPosition    _Edge_TopTubeTaperTop_ST    $BottomBracket(Position)]
    set pt_is                   [vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
        #
    set dimension               [createDimension    D01092  length \
                                        [list $pt_01 $pt_is] \
                                        aligned    [expr -60 * $stageScale]  [expr 50 * $stageScale] \
                                        darkred]


        #                                
        # -- dim_RearWheel_Clearance
        #
    set pt_03                   [myGUI::model::model_XZ::getPosition    RearWheel   $BottomBracket(Position)]
    set pt_06                   [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeBottom_Back   $BottomBracket(Position)]
    set pt_07                   [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTaperEnd_Back $BottomBracket(Position)]
    set pt_is                   [vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
    set pt_rw                   [vectormath::addVector $pt_03 [vectormath::unifyVector  $pt_03  $pt_is  $RearWheel(Radius) ] ]
        #
    set dimension               [createDimension    D01093  length \
                                        [list $pt_rw $pt_is] \
                                        aligned    [expr -70 * $stageScale]  [expr 115 * $stageScale] \
                                        gray50 ]
                                        

        #
    return
        #
}    
proc myGUI::dimension::createDimension_FrameDrafting_BG     {BB_Position type} {
        # myGUI::gui::cv_Custom40 setPrecision 2

    variable    cvObject
    
    variable    stageScale

    variable    Rendering
    variable    Reference

    variable    BottomBracket
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

    variable    Position
    variable    Length
    variable    Angle
    variable    Vector    
    
        # 
    set Config(BottleCage_DT)    [myGUI::model::model_XZ::getConfig BottleCage_DownTube]
    set Config(BottleCage_DT_L)  [myGUI::model::model_XZ::getConfig BottleCage_DownTube_Lower]
    set Config(BottleCage_ST)    [myGUI::model::model_XZ::getConfig BottleCage_SeatTube]
    set Config(BrakeFront)       [myGUI::model::model_XZ::getConfig FrontBrake]
    set Config(BrakeRear)        [myGUI::model::model_XZ::getConfig RearBrake]
        #
    

    set DownTube(polygon)   [myGUI::model::model_XZ::getPolygon     DownTube        $BB_Position  ]

    set help_fk             [vectormath::addVector         $Steerer(Fork)                  [vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
    set help_rw_rim         [vectormath::rotateLine        $RearWheel(Position)            [expr 0.5 * $RearWheel(RimDiameter) ] 70 ]
    set help_tt_c1          [vectormath::rotateLine        $RearWheel(Position)            [expr 0.5 * $RearWheel(RimDiameter) ] 70 ]
    
        # -- Dimensions ------------------------
        #
    set _dim_CS_Length          [createDimension    D01210  length \
                                        [list       $RearWheel(Position)  $BottomBracket(Position)] \
                                        aligned     [expr 70 * $stageScale] [expr   80 * $stageScale] \
                                        darkblue ]
    set _dim_CS_LengthX         [createDimension    D01102  length \
                                        [list       $BottomBracket(Position)  $RearWheel(Position) ] \
                                        horizontal  [expr -110 * $stageScale]   0 \
                                        gray30 ]
    set _dim_FW_Distance        [createDimension    D01103  length \
                                        [list       $BottomBracket(Position)  $FrontWheel(Position)] \
                                        aligned     [expr 70 * $stageScale] [expr  -90 * $stageScale] \
                                        gray30 ]
    set _dim_FW_DistanceX       [createDimension    D01104  length \
                                        [list       $BottomBracket(Position)  $FrontWheel(Position) ] \
                                        horizontal  [expr 110 * $stageScale] 0 \
                                        gray30 ]
    set _dim_Wh_Distance        [createDimension    D01105  length \
                                        [list       $RearWheel(Position)  $FrontWheel(Position) ] \
                                        horizontal  [expr (150 + $BottomBracket(Depth)) * $stageScale]    0 \
                                        gray30 ]
    set _dim_ST_Length_01       [createDimension    D01106  length \
                                        [list [lindex $SeatTube(vct_Top) 1]  [lindex $SeatTube(vct_Top) 0]  $SeatTube(BBracket) ] \
                                        perpendicular [expr 145 * $stageScale] 0 \
                                        darkblue ]
    set _dim_ST_Length_02       [createDimension    D01107  length \
                                        [list       $SeatTube(BBracket)  $TopTube(SeatTube) ] \
                                        aligned     [expr -120 * $stageScale] 0 \
                                        gray30 ]
    set _dim_TT_Length          [createDimension    D01108  length \
                                        [list       $TopTube(Steerer)   $TopTube(SeatTube)] \
                                        aligned     [expr  140 * $stageScale] 0 \
                                        darkblue ]
    if {$TopTube(Angle) != 0} {
        set _dim_TT_Effective   [createDimension    D01109  length \
                                        [list       $TopTube(Steerer)   $TopTube(SeatClassic)] \
                                        horizontal  [expr  170 * $stageScale] 0  \
                                        gray50]
    }                                    
    set _dim_DT_Length          [createDimension    D01110  length \
                                        [list       $BottomBracket(Position)  $DownTube(Steerer) ] \
                                        aligned     [expr  120 * $stageScale] 0 \
                                        darkblue ]
    set _dim_SS_Length          [createDimension    D01111  length \
                                        [list       $RearWheel(Position)  $SeatStay(SeatTube) ] \
                                        aligned     [expr -160 * $stageScale] 0 \
                                        darkblue ]
    set _dim_SS_ST_Offset       [createDimension    D01112  length \
                                        [list       [lindex $SeatTube(vct_Top) 1]  [lindex $SeatTube(vct_Top) 0]  $SeatStay(SeatTube) ] \
                                        perpendicular [expr 45 * $stageScale] [expr   65 * $stageScale] \
                                        darkblue ]
    set _dim_BB_Depth           [createDimension    D01113  length \
                                        [list       $RearWheel(Position)  $BottomBracket(Position)] \
                                        vertical    [expr -160 * $stageScale] [expr 80 * $stageScale] \
                                        gray30 ]
    
    if { $BottomBracket(Excenter) != 0 } {
            set _dim_BB_Excenter    \
                                [createDimension    D01114  length \
                                        [list       $BottomBracket(Position) $CrankSet(Position) ] \
                                        vertical    [expr  200 * $stageScale] [expr 40 * $stageScale] \
                                        gray30 ]        
        }
    
        #
        # -- perpendicular offset of SeatStay (D01115)
    if { $RearDrop(OffsetSSPerp) != 0 } {
            if { $RearDrop(OffsetSSPerp) > 0 } {
                set distance   -10
                set offset      35
            } else {
                set distance    10
                set offset     -35
            }
            set _hlp_01 [vectormath::addVector $Position(IS_ChainSt_SeatSt) [vectormath::unifyVector $Position(IS_ChainSt_SeatSt) $SeatStay(SeatTube) 60]]
            set _dim_SS_DO_Offset   \
                                [createDimension    D01115  length \
                                        [list      $SeatStay(SeatTube) $_hlp_01 $RearWheel(Position)] \
                                        perpendicular [expr  $distance * $stageScale] [expr $offset * $stageScale] \
                                        gray30 ]
        }
        #
        # -- perpendicular offset of ChainStay (D01116)
    if { $RearDrop(OffsetCSPerp) != 0 } {
            if { $RearDrop(OffsetCSPerp) > 0 } {
                set distance   -10
                set offset      35
            } else {
                set distance    10
                set offset     -35
            }                   
            set _hlp_02 [vectormath::addVector $Position(IS_ChainSt_SeatSt) [vectormath::unifyVector $Position(IS_ChainSt_SeatSt) $BottomBracket(Position) 115]]
            set _dim_CS_DO_Offset    \
                                [createDimension    D01116  length \
                                        [list      $BottomBracket(Position) $_hlp_02 $RearWheel(Position)] \
                                        perpendicular [expr $distance * $stageScale] [expr $offset * $stageScale] \
                                        gray30 ]
        }
        
        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top     $BB_Position]
        set pt_03               [myGUI::model::model_XZ::getPosition    HeadTube_End                $BB_Position]
    set _dim_TT_Offset          [createDimension    D01117  length \
                                        [list       $pt_03 $pt_01 $TopTube(Steerer)] \
                                        perpendicular   [expr (-70 + 0.5 * $HeadTube(Diameter)) * $stageScale] [expr  -35 * $stageScale] \
                                        darkblue ]            
        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom  $BB_Position]
        set pt_03               [myGUI::model::model_XZ::getPosition    HeadTube_Start              $BB_Position]
    set _dim_DT_Offset          [createDimension    D01118  length \
                                        [list       $pt_03 $pt_01 $DownTube(Steerer)] \
                                        perpendicular   [expr (70 - 0.5 * $HeadTube(Diameter))* $stageScale] [expr 0 * $stageScale] \
                                        darkblue ]
    

        # -- HT Stack & Reach ------------------
        #
    set _dim_HT_Reach_X         [createDimension    D01119  length \
                                        [list       $HeadTube(Stem) $BottomBracket(Position) ] \
                                        horizontal  [expr  -90 * $stageScale] 0 \
                                        gray50 ]
    set _dim_HT_Stack_Y         [createDimension    D01120  length \
                                        [list       $HeadTube(Stem) $BottomBracket(Position) ] \
                                        vertical    [expr  110 * $stageScale] [expr  120 * $stageScale]  \
                                        gray50 ]

        # -- Fork Details ----------------------
        #
    set _dim_Fork_Rake          [createDimension    D01121  length \
                                        [list       $Steerer(Stem)  $help_fk $FrontWheel(Position)] \
                                        perpendicular [expr    50 * $stageScale]    [expr  -80 * $stageScale] \
                                        gray30]
    set _dim_Fork_Height        [createDimension    D01122  length \
                                        [list       $Steerer(vct_Bottom)    $FrontWheel(Position)] \
                                        perpendicular [expr  (-150 + 0.5 * $Steerer(Diameter)) * $stageScale] [expr  80 * $stageScale] \
                                        gray30]
    set _dim_Fork_Length        [createDimension    D01123  length \
                                        [list       $FrontWheel(Position)   $Steerer(Fork)] \
                                        aligned     [expr       80 * $stageScale]  [expr -50 * $stageScale] \
                                        gray30]


        # -- Steerer Details ----------------------
        set pt_01               [myGUI::model::model_XZ::getPosition   Steerer_Start    $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition   Steerer_Stem     $BB_Position]
            # puts "       -> _dim_STR_Length"
    set _dim_STR_Length         [createDimension    D01124  length \
                                        [list       $Steerer(vct_Bottom)  $Steerer(End)] \
                                        perpendicular [expr (190 - 0.5 * $Steerer(Diameter)) * $stageScale]    [expr   5 * $stageScale] \
                                        gray30 ]


        # -- Centerline Angles -----------------
        #
    set _dim_Head_Top_Angle     [createDimension    D01125  angle \
                                        [list       $TopTube(Steerer) $Steerer(Stem) $TopTube(SeatTube)] \
                                        130   0 \
                                        darkred ]
    set _dim_Head_Down_Angle    [createDimension    D01126  angle \
                                        [list       $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] \
                                        170 -10 \
                                        darkred ]
    set _dim_Seat_Top_Angle     [createDimension    D01127  angle \
                                        [list       $TopTube(SeatTube) $SeatTube(BBracket) $TopTube(Steerer)] \
                                        150   0 \
                                        darkred ]
    
    
        set pt_base             [vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
    set _dim_Down_Seat_Angle    [createDimension    D01128  angle \
                                        [list       $pt_base $DownTube(Steerer) $TopTube(SeatTube) ] \
                                         90   0 \
                                        darkred ]
                                                                                                                                       
                                                                
        set pt_base             [vectormath::intersectPoint  $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $Position(IS_ChainSt_SeatSt) ]
    set _dim_ST_CS_Angle        [createDimension    D01129  angle \
                                        [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] \
                                         90   0 \
                                        darkred ]
    set _dim_SS_CS_Angle        [createDimension    D01130  angle \
                                        [list       $Position(IS_ChainSt_SeatSt) $BottomBracket(Position) $SeatStay(SeatTube)] \
                                         90   0 \
                                        darkred ]
        set pt_01               [vectormath::addVector    $BottomBracket(Position) {-1000 0} ]
        set pt_base             [vectormath::intersectPoint  $SeatTube(BBracket) $TopTube(SeatTube)  $BottomBracket(Position) $pt_01 ]
    set _dim_SeatTube_Angle     [createDimension    D01131  angle \
                                        [list       $pt_base $SeatTube(TopTube) $pt_01] \
                                        130   0 \
                                        darkred ]
        set pt_01               [vectormath::intersectPoint    $Steerer(Stem)  $Steerer(Fork)        $FrontWheel(Position) [vectormath::addVector    $FrontWheel(Position) {-10 0}] ]
        set pt_02               [vectormath::addVector    $pt_01 {-1 0} 100 ]
    set _centerLine             [$cvObject create centerline [list $FrontWheel(Position) $pt_02] -fill gray60 -tags __CenterLine__]
    set _dim_HeadTube_Angle     [createDimension    D0111  angle \
                                        [list       $pt_01 $Steerer(Stem) $pt_02] \
                                         90   0 \
                                        darkred ]


        
        # -- Rear Brake Mount ------------------
    if {$Config(BrakeRear) != {off}} {
        switch $Config(BrakeRear) {
            Rim {
                set pt_03       [myGUI::model::model_XZ::getPosition    RearBrake_Shoe          $BB_Position ]
                set pt_04       [myGUI::model::model_XZ::getPosition    RearBrake_Help          $BB_Position ]
                set pt_05       [myGUI::model::model_XZ::getPosition    RearBrake_Definition    $BB_Position ]
                set pt_06       [myGUI::model::model_XZ::getPosition    RearBrake_Mount         $BB_Position ]

                set _dim_Brake_Offset_01 [createDimension   D01141  length \
                                        [list       $pt_06 $pt_04 ] \
                                        aligned     [expr   40 * $stageScale]    [expr  35 * $stageScale] \
                                        gray30]
                set _dim_Brake_Offset_02 [createDimension   D01142  length \
                                        [list       $pt_03  $pt_04 ] \
                                        aligned     [expr   -50 * $stageScale]    [expr   65 * $stageScale] \
                                        gray30]
                set _dim_Brake_Distance [createDimension    D01143  length \
                                        [list       $RearWheel(Position)  $RearBrake(Mount)] \
                                        aligned     [expr  -120 * $stageScale] 0 \
                                        gray30]
            }
        }
    }



        # -- Bottle Cage Mount ------------------
    if {$Config(BottleCage_ST) != {off}} {
                set st_direction    [myGUI::model::model_XZ::getDirection   SeatTube ]
                set pt_01       [myGUI::model::model_XZ::getPosition    BottleCage_ST_Offset    $BB_Position]
                set pt_02       [myGUI::model::model_XZ::getPosition    BottleCage_ST_Base      $BB_Position]
                set pt_03       [vectormath::addVector      $pt_02  $st_direction   [myGUI::model::model_XZ::getScalar  BottleCage  SeatTube ]]
                set pt_04       [vectormath::intersectPerp  $pt_01  $pt_02  $BB_Position ]

                set dimension   [createDimension    D01151  length \
                                        [list       $pt_01  $pt_02 ] \
                                        aligned     [expr  90 * $stageScale]    [expr    0 * $stageScale] \
                                        gray50 ]
                set dimension   [createDimension    D01152  length \
                                        [list       $pt_02  $pt_03 ] \
                                        aligned     [expr  90 * $stageScale]    [expr -115 * $stageScale] \
                                        gray50 ]
                set dimension   [createDimension    D01153  length \
                                        [list       $DownTube(SeatTubeIS)        $pt_02 ] \
                                        aligned     [expr  35 * $stageScale]    [expr -105 * $stageScale] \
                                        gray50 ]
                set dimension   [createDimension    D01154  length \
                                        [list       $pt_04    $DownTube(SeatTubeIS) ] \
                                        aligned     [expr  35 * $stageScale]    [expr   50 * $stageScale] \
                                        gray50 ]
    } else {
                set pt_04       [myGUI::model::coords_xy_index $SeatTube(polygon)  0 ]
                set dimension   [createDimension    D01155  length \
                                        [list       $pt_04  $DownTube(BBracket) $DownTube(SeatTubeIS) ] \
                                        perpendicular   [expr  50 * $stageScale]    [expr   50 * $stageScale] \
                                        gray50 ]
    }

    if {$Config(BottleCage_DT) != {off}} {
                set dt_direction    [myGUI::model::model_XZ::getDirection   DownTube ]
                set pt_01       [myGUI::model::model_XZ::getPosition    BottleCage_DT_TopOffset     $BB_Position ]
                set pt_02       [myGUI::model::model_XZ::getPosition    BottleCage_DT_Top           $BB_Position ]
                set pt_03       [vectormath::addVector      $pt_02  $dt_direction   [myGUI::model::model_XZ::getScalar  BottleCage  DownTube]]
                set pt_04h      [vectormath::intersectPerp  $DownTube(BBracket) $DownTube(Steerer) $DownTube(SeatTubeIS) ]
                set vct_04h     [vectormath::subVector      $DownTube(SeatTubeIS) $pt_04h ]
                set pt_04       [vectormath::addVector      $DownTube(BBracket)   $vct_04h ]

                if { $Config(BottleCage_DT_L) != {off}} { set addDist 40 } else { set addDist 0}

                set dimension   [createDimension    D01161  length \
                                        [list       $pt_01  $pt_02 ] \
                                        aligned     [expr -1.0 * (180 + $addDist) * $stageScale]    0 \
                                        gray50 ]
                set dimension   [createDimension    D01162  length \
                                        [list       $pt_02  $pt_03 ] \
                                        aligned     [expr -1.0 * (180 + $addDist) * $stageScale] [expr   15 * $stageScale] \
                                        gray50 ]
                set dimension   [createDimension    D01163  length \
                                        [list       $DownTube(SeatTubeIS)   $pt_02 ] \
                                        aligned     [expr -1.0 * (35 + $addDist) * $stageScale]  [expr -115 * $stageScale] \
                                        gray50 ]
                set dimension   [createDimension    D01164  length \
                                        [list $pt_04   $DownTube(SeatTubeIS) ] \
                                        aligned        [expr -1.0 * (35 + $addDist) * $stageScale]  [expr   50 * $stageScale] \
                                        gray50 ]
    } else {
                set pt_04h      [vectormath::intersectPerp     $DownTube(BBracket) $DownTube(Steerer) $DownTube(SeatTubeIS) ]
                set vct_04h     [vectormath::subVector         $DownTube(SeatTubeIS) $pt_04h ]
                set pt_04       [vectormath::addVector         $DownTube(BBracket) $vct_04h ]

                if { $Config(BottleCage_DT_L) != {off}} { 
                    set addDist 40 
                } else { 
                    set addDist 0
                }

                set dimension   [createDimension    D01165  length \
                                        [list       $pt_04  $DownTube(BBracket) $DownTube(SeatTubeIS) ] \
                                        perpendicular   [expr -1.0 * (50 + $addDist) * $stageScale]    [expr   50 * $stageScale] \
                                        gray50 ]
    }

    if {$Config(BottleCage_DT_L) != {off}} {
                set dt_direction    [myGUI::model::model_XZ::getDirection   DownTube ]
                set pt_01       [myGUI::model::model_XZ::getPosition    BottleCage_DT_BottomOffset  $BB_Position]
                set pt_02       [myGUI::model::model_XZ::getPosition    BottleCage_DT_Bottom        $BB_Position]
                set pt_03       [vectormath::addVector  $pt_02  $dt_direction   [myGUI::model::model_XZ::getScalar  BottleCage  DownTube_Lower]]
                    # puts "   -> \$pt_01 $pt_01  <- DownTube_Lower_BottleCageOffset"
                    # puts "   -> \$pt_02 $pt_02  <- DownTube_Lower_BottleCageBase"
                    # puts "   -> \$pt_03 $pt_03"
                set dimension   [createDimension    D01171  length \
                                        [list       $pt_01  $pt_02 ] \
                                        aligned        [expr -145 * $stageScale]    0 \
                                        gray50 ]
                    #
                set dimension   [createDimension    D01172  length \
                                        [list       $pt_02  $pt_03 ] \
                                        aligned     [expr -145 * $stageScale]    [expr  15 * $stageScale] \
                                        darkblue ]
    }



        # -- Cutting Length --------------------
        #

        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeHeadTube_TT    $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeSeatTube_ST    $BB_Position]
        set pt_04               [myGUI::model::model_XZ::getPosition    _Edge_DownTubeHeadTube_DT   $BB_Position]
        set pt_05               [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTop_Front   $BB_Position]
    set _dim_TopTube_CutLength  [createDimension    D01181  length \
                                        [list       $pt_01 $pt_02] \
                                        aligned    [expr  90 * $stageScale] [expr 10 * $stageScale] \
                                        darkviolet ]
    set _dim_DownTube_CutLength [createDimension    D01182  length \
                                        [list       $BB_Position $pt_04] \
                                        aligned    [expr  70 * $stageScale] [expr 10 * $stageScale] \
                                        darkviolet ]
    set _dim_SeatTube_CutLength [createDimension    D01183  length \
                                        [list       $DownTube(SeatTubeIS) $pt_05] \
                                        aligned    [expr   90 * $stageScale] [expr 10 * $stageScale] \
                                        darkviolet ]
                                        
                                                                 
        # -- Tubing Details --------------------
        #
        set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top       $BB_Position]
        set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom    $BB_Position]
        set pt_03 [myGUI::model::model_XZ::getPosition    HeadTube_End                  $BB_Position]
    set _dim_HeadTube_Length    [createDimension    D01184  length \
                                        [list       $pt_03 $pt_01 $pt_02] \
                                        perpendicular [expr -90 * $stageScale]   0 \
                                        darkblue ]

        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Top    $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeHeadTube_TT  $BB_Position]
        set pt_03               [myGUI::model::model_XZ::getPosition    HeadTube_End              $BB_Position]
    set _dim_HeadTube_OffsetTT  [createDimension    D01185  length \
                                        [list       $pt_03 $pt_01 $pt_02] \
                                        perpendicular [expr 50 * $stageScale] [expr 50 * $stageScale] \
                                        gray30 ]

        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Bottom  $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition    _Edge_DownTubeHeadTube_DT  $BB_Position]
        set pt_03               [myGUI::model::model_XZ::getPosition    HeadTube_Start            $BB_Position]
    set _dim_HeadTube_OffsetDT  [createDimension    D01186  length \
                                        [list       $pt_03 $pt_01 $pt_02] \
                                        perpendicular [expr -50 * $stageScale] [expr 50 * $stageScale] \
                                        gray30 ]

        set pt_01               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeSeatTube_ST  $BB_Position]
        set pt_02               [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTop_Front   $BB_Position]               
    set _dim_SeatTube_Extension [createDimension    D01187  length \
                                        [list       $pt_01 $pt_02] \
                                        aligned     [expr 65 * $stageScale] [expr -50 * $stageScale] \
                                        gray30 ]

        set pt_01               [myGUI::model::model_XZ::getPosition    TopTube_End     $BB_Position  ]
        set pt_02               [myGUI::model::model_XZ::getPosition    SeatStay_End    $BB_Position  ]
        if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
            set dim_coords  [list $pt_01 $pt_02]
        } else {
            set dim_coords  [list $pt_02 $pt_01]
        }
    set _dim_SeatStay_Offset    [createDimension    D01188  length \
                                        $dim_coords  \
                                        aligned    [expr -60 * $stageScale]   [expr -50 * $stageScale] \
                                        gray30 ]

    if { $DownTube(OffsetBB) != 0 } {
            set pt_01           [myGUI::model::model_XZ::getPosition    DownTube_End    $BB_Position  ]
            set pt_02           [myGUI::model::model_XZ::getPosition    DownTube_Start  $BB_Position  ]
            set pt_03           $BB_Position
            if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
                set dim_distance    [expr -70 * $stageScale]
                set dim_offset      [expr -50 * $stageScale]
            } else {
                set dim_distance    [expr  70 * $stageScale]
                set dim_offset      [expr  50 * $stageScale]
            }
        set _dim_DownTube_Offset [createDimension   D01191  length \
                                        [list       $pt_01 $pt_02 $pt_03] \
                                        perpendicular $dim_distance $dim_offset \
                                        darkred ]
    }
   
    if { $SeatTube(OffsetBB) != 0 } {
            set pt_01           [myGUI::model::model_XZ::getPosition    SeatTube_Start  $BB_Position  ]
            set pt_02           [myGUI::model::model_XZ::getPosition    SeatTube_End    $BB_Position  ]
            set pt_03           $BB_Position
            if { [lindex $pt_02 1] >= [lindex $pt_03 1] } {
                set dim_distance    [expr -70 * $stageScale]
                set dim_offset      [expr -50 * $stageScale]
            } else {
                set dim_distance    [expr  70 * $stageScale]
                set dim_offset      [expr  50 * $stageScale]
            }
        set _dim_SeatTube_Offset [createDimension   D01192  length \
                                        [list       $pt_01 $pt_02 $pt_03] \
                                        perpendicular $dim_distance $dim_offset \
                                        darkred ]
    }

        set pt_01               [myGUI::model::model_XZ::getPosition    TopTube_Start   $BB_Position  ]
        set pt_hlp              [myGUI::model::model_XZ::getPosition    TopTube_End     $BB_Position  ]
        set pt_cnt              [vectormath::center        $pt_01  $pt_hlp]
        set pt_02               [list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]
    set _dim_TopTube_Angle      [createDimension    D01201  angle \
                                        [list $pt_cnt $pt_02 $pt_01] \
                                        100   -30 \
                                        darkred ]

        set pt_01               [myGUI::model::model_XZ::getPosition    HeadTube_Start  $BB_Position  ]
        set pt_02               [myGUI::model::model_XZ::getPosition    Steerer_Start   $BB_Position  ]
            # puts "       -> _dim_HeadSet_Bottom"
    set _dim_HeadSet_Bottom     [createDimension    D01202  length \
                                        [list $Steerer(vct_Bottom) [lindex $HeadTube(vct_Bottom) 1] ] \
                                        perpendicular    [expr (150 - 0.5 * $Steerer(Diameter)) * $stageScale]   [expr -50 * $stageScale] \
                                        gray30 ]

        set RimDiameter         [myGUI::model::model_XZ::getScalar Geometry RearRim_Diameter]
        set TyreHeight          [myGUI::model::model_XZ::getScalar Geometry RearTyre_Height]
        set WheelRadius         [expr 0.5 * $RimDiameter + $TyreHeight ]
        set pt_03               [myGUI::model::model_XZ::getPosition    RearWheel       $BB_Position  ]
        set SeatTube(polygon)   [myGUI::model::model_XZ::getPolygon     SeatTube        $BB_Position  ]
        set pt_06               [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeBottom_Back   $BB_Position]
        set pt_07               [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTaperEnd_Back $BB_Position]
        set pt_is               [vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
        set pt_rw               [vectormath::addVector $pt_03 [vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]
    set _dim_RearWheel_Clear    [createDimension    D01203  length \
                                        [list       $pt_rw $pt_is] \
                                        aligned     [expr -100 * $stageScale]  [expr -80 * $stageScale] \
                                        gray50 ]


        set pt_01               [myGUI::model::model_XZ::getPosition    LegClearance    $BB_Position  ]
        set pt_09               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeTaperTop_HT      $BB_Position]
        set pt_10               [myGUI::model::model_XZ::getPosition    _Edge_TopTubeTaperTop_ST      $BB_Position]
        set pt_is               [vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
    set _dim_LegClearance       [createDimension    D01204  length \
                                        [list       $pt_01 $pt_is] \
                                        aligned     [expr -30 * $stageScale]  [expr 30 * $stageScale] \
                                        gray50 ]
        #
    return
        #

}
proc myGUI::dimension::createDimension_Reference_BG         {BB_Position type} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Reference
        #
    variable    BottomBracket
    variable    FrontWheel
    variable    HandleBar
    variable    HeadSet
    variable    RearWheel  
    variable    SaddleNose
    variable    SeatTube
        #
    variable    Position 
        #
        #
    set help_00                 [vectormath::addVector   $SeatTube(Ground) {-200 0} ]
    set length_00               [expr [lindex $Reference(SaddleNose) 1] - [lindex $Reference(HandleBar) 1]]
        #              
        # -- Dimensions ------------------------
        #  
    set _dim_BB_Depth           [createDimension    D01210  length \
                                        [list       $RearWheel(Position)   $BottomBracket(Position) ] \
                                        vertical    [expr -100 * $stageScale]  [expr 80 * $stageScale] \
                                        gray50 ]

    set _dim_HB_XPosition       [createDimension    D01211  length \
                                        [list       $Reference(HandleBar)  $BottomBracket(Position) ] \
                                        horizontal  [expr (80 + $length_00) * $stageScale ]    0 \
                                        gray50 ]

    
    set _dim_HB_FW              [createDimension    D01212  length \
                                        [list       $FrontWheel(Position)    $Reference(HandleBar) ] \
                                        aligned     [expr  100 * $stageScale]  [expr  -90 * $stageScale]  \
                                        gray50 ] 
    set _dim_HB_BB              [createDimension    D01213  length \
                                        [list       $Reference(HandleBar) $BottomBracket(Position) ] \
                                        aligned     [expr  100 * $stageScale]  [expr    0 * $stageScale]  \
                                        gray50 ] 
    set _dim_SD_BB              [createDimension    D01214  length \
                                        [list       $Reference(SaddleNose)    $BottomBracket(Position) ] \
                                        aligned     [expr -100 * $stageScale]  [expr 200 * $stageScale]  \
                                        gray50 ] 
        
    
    
    set _dim_Wh_Distance        [createDimension    D01215  length \
                                        [list       $RearWheel(Ground)  $FrontWheel(Ground) ] \
                                        horizontal  [expr  130 * $stageScale]    0 \
                                        gray50 ]           
    set _dim_FW_DistanceX       [createDimension    D01216  length \
                                        [list       $Position(BaseCenter)  $FrontWheel(Ground) ] \
                                        horizontal  [expr   70 * $stageScale]   0 \
                                        gray50 ]
    set _dim_RW_DistanceX       [createDimension    D01217  length \
                                        [list       $RearWheel(Ground)  $Position(BaseCenter)  ] \
                                        horizontal  [expr   70 * $stageScale]   0 \
                                        gray50 ]

    set _dim_SD_03              [createDimension    D01218  length \
                                        [list       $Reference(SaddleNose)    $RearWheel(Position) ] \
                                        aligned     [expr   70 * $stageScale]  [expr  130 * $stageScale]  \
                                        gray50 ]                                                                        
    set _dim_HB_03              [createDimension    D01219  length \
                                        [list       $RearWheel(Position) $Reference(HandleBar) ] \
                                        aligned     [expr   70 * $stageScale]  [expr -230 * $stageScale]  \
                                        gray50 ]                                                                        
        #
    return    
        #                                   
}    
    #
    #
proc myGUI::dimension::createDimension_Reference_FG         {BB_Position type} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Reference
        #
    variable    BottomBracket
    variable    DownTube
    variable    FrontWheel
    variable    HandleBar
    variable    RearWheel
    variable    SaddleNose
        #
    variable    Position
        #
    
    set _dim_BB_Height          [createDimension    D01231  length \
                                        [list       $BottomBracket(Position)    $Position(BaseCenter)] \
                                        vertical    [expr -150 * $stageScale]  [expr  -80 * $stageScale]  \
                                        orange ]
    set _dim_FW_Radius          [createDimension    D01232  length \
                                        [list       $FrontWheel(Position)  $FrontWheel(Ground) ] \
                                        vertical    [expr -150 * $stageScale]  [expr   30 * $stageScale] \
                                        orange ]
    set _dim_RW_Radius          [createDimension    D01233  length \
                                        [list       $RearWheel(Position)   $RearWheel(Ground)  ] \
                                        vertical    [expr 150 * $stageScale]   [expr   30 * $stageScale] \
                                        orange ]
                                        
    set _dim_Rear_Length        [createDimension    D01234  length \
                                        [list       $RearWheel(Position) $BottomBracket(Position) ] \
                                        aligned     [expr  180 * $stageScale]  [expr   80 * $stageScale]  \
                                        orange ]                                                                        
    set _dim_Front_Length       [createDimension    D01235  length \
                                        [list       $BottomBracket(Position) $FrontWheel(Position) ] \
                                        aligned     [expr  150 * $stageScale]  [expr -150 * $stageScale]  \
                                        orange ] 
    
    
    set _dim_SD_HB              [createDimension    D01236  length \
                                        [list       $Reference(SaddleNose)    $Reference(HandleBar) ] \
                                        aligned     [expr -250 * $stageScale]  [expr    0 * $stageScale]  \
                                        darkblue ] 
    set _dim_SD_HB_Height       [createDimension    D01237  length \
                                        [list       $Reference(HandleBar) $Reference(SaddleNose) ] \
                                        vertical    [expr  380 * $stageScale]  [expr -100 * $stageScale]  \
                                        darkblue ]
                                        
                                        
    set _dim_SD_Distance        [createDimension    D01238  length \
                                        [list       $Reference(SaddleNose) $BottomBracket(Position) ] \
                                        horizontal  [expr -80 * $stageScale] [expr  80 * $stageScale] \
                                        darkorange ]
    set _dim_SD_HB_Length       [createDimension    D01239  length \
                                        [list       $Reference(SaddleNose) $Reference(HandleBar) ] \
                                        horizontal  [expr -150 * $stageScale ]    0 \
                                        darkorange ]
    set _dim_SD_Height          [createDimension    D01240  length \
                                        [list       $Position(BaseCenter)  $Reference(SaddleNose) ] \
                                        vertical    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                                        darkorange ]
    set _dim_HB_Height          [createDimension    D01241  length \
                                        [list       $Reference(HandleBar) $Position(BaseCenter) ] \
                                        vertical    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                                        darkorange ]
                                                                                                                                                                          
        #
    myGUI::gui::object_CursorRendering  $cvObject   $_dim_RW_Radius
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_BB_Height         single_Result_BottomBracket_Height
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_RW_Radius         group_RearWheel_Parameter         
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_FW_Radius         group_FrontWheel_Parameter_02
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Rear_Length       single_RearWheel_Distance
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_Front_Length      single_Result_FrontWheel_diagonal
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_SD_HB             single_Result_Reference_SaddleNose_HB
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_SD_HB_Height      single_Result_Reference_Heigth_SN_HB
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_SD_Distance       single_Reference_SaddleNoseDistance
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_SD_HB_Length      single_Reference_HandleBarDistance
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_SD_Height         single_Reference_SaddleNoseHeight
    myGUI::gui::bind_dimensionEvent_2   $cvObject   $_dim_HB_Height         single_Reference_HandleBarHeight
        #
    return    
        #                                   
}
    #
    #
proc myGUI::dimension::createDimension_HeadTubeLength       {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    HeadTube
        #
    set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top       $BB_Position]
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom    $BB_Position]
    set pt_03 [myGUI::model::model_XZ::getPosition    HeadTube_End                  $BB_Position]
    set pt_04 [myGUI::model::model_XZ::getPosition    HeadTube_Start                $BB_Position]
        #
    set dimension                   [createDimension    D01250  length \
                                            [list       $pt_03 $pt_01 $pt_02 ] \
                                            perpendicular [expr  (-110 + 0.5 * $HeadTube(Diameter)) * $stageScale]   0 \
                                            darkred ]
    if {$active == {active}} {
            myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_HeadTube_Length
    }
        #
}
proc myGUI::dimension::createDimension_HeadTubeOffsetTT     {BB_Position type active} {
    #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    HeadTube
    variable    TopTube
        #                            
    set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Top      $BB_Position]
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_TopTubeHeadTube_TT    $BB_Position]
    set dimension               [createDimension    D01255  length \
                                        [list       $pt_01 $pt_02] \
                                        aligned     [expr 70 * $stageScale] [expr 50 * $stageScale] \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_TopTube_HeadTubeOffset
    }
}
proc myGUI::dimension::createDimension_HeadTubeOffsetDT     {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    DownTube
    variable    HeadTube
        #
    set pt_01 [myGUI::model::model_XZ::getPosition    HeadTube_Start               $BB_Position]
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Bottom    $BB_Position]
    set pt_04 [myGUI::model::model_XZ::getPosition    _Edge_DownTubeHeadTube_DT    $BB_Position]
    set dimension               [createDimension    D01260  length \
                                        [list       $pt_01  $pt_02  $pt_04] \
                                        perpendicular [expr -70 * $stageScale] [expr 50 * $stageScale] \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_DownTube_HeadTubeOffset
    }
}
proc myGUI::dimension::createDimension_HeadTubeCenterDT     {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    DownTube
    variable    HeadTube
        #
    set pt_01 [myGUI::model::model_XZ::getPosition    HeadTube_Start                $BB_Position]
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom    $BB_Position]
    set pt_03 [myGUI::model::model_XZ::getPosition    DownTube_Start                $BB_Position]
    set dimension               [createDimension    D01265  length \
                                        [list       $pt_01  $pt_02  $pt_03] \
                                        perpendicular [expr (70 - 0.5 * $HeadTube(Diameter)) * $stageScale] [expr -20 * $stageScale] \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_Result_HeadTube_DownTubeCenter
    }
}
proc myGUI::dimension::createDimension_SeatTubeExtension    {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    TopTube
    variable    SeatTube
        #                            
    set pt_01       [myGUI::model::model_XZ::getPosition    _Edge_TopTubeSeatTube_ST       $BB_Position]
    set pt_02       [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTop_Front         $BB_Position]
    
    set dimension               [createDimension    D01270  length \
                                        [list       $pt_01 $pt_02] \
                                        aligned     [expr 50 * $stageScale] [expr -50 * $stageScale] \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_SeatTube_Extension
    }
}
proc myGUI::dimension::createDimension_SeatStayOffset       {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    TopTube
    variable    SeatStay
        #                            
    set pt_01           $TopTube(SeatTube)
    set pt_02           $SeatStay(End)
    if { [lindex $pt_02 1] < [lindex $pt_01 1] } {
        set dim_coords  [list $pt_01 $pt_02]
    } else {
        set dim_coords  [list $pt_02 $pt_01]
    }
        #
    set dimension               [createDimension    D01275  length \
                                        $dim_coords  \
                                        aligned     [expr 70 * $stageScale]   [expr 50 * $stageScale] \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_SeatStay_OffsetTT
    }
}
proc myGUI::dimension::createDimension_DownTubeOffset       {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    DownTube
        #                            
    set pt_01           $DownTube(BBracket)
    set pt_02           $DownTube(Steerer)
    set pt_03           $BB_Position
    if { $DownTube(OffsetBB) >= 0 } {
        set dim_distance    [expr  70 * $stageScale]
        set dim_offset      [expr  35 * $stageScale]
    } else {
        set dim_distance    [expr -70 * $stageScale]
        set dim_offset      [expr -35 * $stageScale]
    }
    set dimension               [createDimension    D01280  length \
                                        [list       $pt_02 $pt_01 $pt_03] \
                                        perpendicular $dim_distance $dim_offset \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_DownTube_BottomBracketOffset
    }
}
proc myGUI::dimension::createDimension_SeatTubeOffset       {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    SeatTube
    variable    TopTube
        #                            
    set pt_01           $SeatTube(BBracket)
    set pt_02           $TopTube(SeatTube)
    set pt_03           $BB_Position
    if { $SeatTube(OffsetBB) > 0 } {
        set dim_distance    [expr -70 * $stageScale]
        set dim_offset      [expr  35 * $stageScale]
    } else {
        set dim_distance    [expr  70 * $stageScale]
        set dim_offset      [expr -35 * $stageScale]
    }
    set dimension               [createDimension    D01285  length \
                                        [list       $pt_02 $pt_01 $pt_03] \
                                        perpendicular $dim_distance $dim_offset \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_SeatTube_BottomBracketOffset
    }
}
proc myGUI::dimension::createDimension_TopTubeAngle         {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    TopTube
        #                            
    set pt_01           $TopTube(Steerer)
    set pt_hlp          $TopTube(SeatTube)
    set pt_cnt          [vectormath::center        $pt_01  $pt_hlp]
    set pt_02           [list [expr [lindex $pt_cnt 0] + 2] [lindex $pt_cnt 1]  ]

    if {[lindex $pt_01 1] > [lindex $pt_hlp 1]} {
        set dimension           [createDimension    D01290  angle \
                                        [list       $pt_cnt $pt_02 $pt_01] \
                                        100   -30 \
                                        darkred ]
    } else {
        set dimension           [createDimension    D01291  angle \
                                        [list $pt_cnt $pt_01 $pt_02] \
                                        100   -30 \
                                        darkred ]
    }
    if {$active == {active}} {
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_TopTube_Angle
    }
}
proc myGUI::dimension::createDimension_TopHeadTubeAngle     {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Steerer
    variable    TopTube
        #                            
    set dimension               [createDimension    D01295  angle \
                                        [list $TopTube(Steerer) $Steerer(Stem) $TopTube(SeatTube)] \
                                        150   0 \
                                        darkblue ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_Result_HeadTube_TopTubeAngle
    }
}
proc myGUI::dimension::createDimension_ForkHeight           {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    FrontWheel
    variable    HeadTube
    variable    Steerer
        #
    foreach {a b} $Steerer(vct_Bottom) break
    set myDirection [vectormath::dirAngle $a $b]
        # puts $myDirection
        #
    set pt_00 [myGUI::model::model_XZ::getPosition    HeadTube_Start                     $BB_Position]
        #
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetBottomFront_Bottom    $BB_Position]
        # puts " \$pt_00 $pt_00 "
        # puts " \$pt_01 $pt_01 "
        # puts " \$pt_02 $pt_02 "
    set pt_12 [vectormath::addVector $pt_00 [vectormath::rotatePoint  {0 0} $pt_02  $myDirection]]
        #
    set dimension               [createDimension    D01300  length \
                                        [list       $Steerer(Start) $pt_02 $FrontWheel(Position)] \
                                        perpendicular [expr  (-150 + 0.5 * $HeadTube(Diameter)) * $stageScale] [expr  -80 * $stageScale] \
                                        darkred ]
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_Fork_Height
    }
}
proc myGUI::dimension::createDimension_HeadSetTop           {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    HeadSet
    variable    HeadTube
    variable    Steerer
        #
        #
    foreach {a b} $Steerer(vct_Bottom) break
    set myDirection [vectormath::dirAngle $a $b]
        # puts $myDirection
        #
    set pt_04 [myGUI::model::model_XZ::getPosition    HeadTube_End                    $BB_Position]
        #
        #
    set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetTopFront_Top       $BB_Position]
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetTopFront_Bottom    $BB_Position]
        #
        #
    set dimension               [createDimension    D01310  length \
                                        [list       $pt_04 $pt_02 $pt_01 ] \
                                        perpendicular [expr  (150 - 0.5 * $HeadTube(Diameter)) * $stageScale]   [expr -30 * $stageScale] \
                                        darkred]
        #
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_HeadSet_TopHeight
    }
}
proc myGUI::dimension::createDimension_HeadSetBottom        {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    HeadSet
    variable    HeadTube
    variable    Steerer
        #
        #
    foreach {a b} $Steerer(vct_Bottom) break
    set myDirection [vectormath::dirAngle $a $b]
        # puts "   \$myDirection $myDirection"
        #
    set pt_00 [myGUI::model::model_XZ::getPosition    HeadTube_Start                     $BB_Position]
    set pt_04 [myGUI::model::model_XZ::getPosition    Steerer_Start                      $BB_Position]
        #
    set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetBottomFront_Top       $BB_Position]
    set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadSetBottomFront_Bottom    $BB_Position]
        #
    set dimension               [createDimension    D01315  length \
                                        [list       $pt_04 $pt_02 $pt_01] \
                                        perpendicular    [expr  (150 - 0.5 * $HeadTube(Diameter)) * $stageScale]   [expr -30 * $stageScale] \
                                        darkred ]
        #
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension      single_HeadSet_BottomHeight
    }
}
proc myGUI::dimension::createDimension_BrakeRear            {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    set Config(BrakeRear)        [myGUI::model::model_XZ::getConfig RearBrake]
        #
    if {$Config(BrakeRear) != {off}} {
        switch $Config(BrakeRear) {
            Rim {
                set pt_03       [myGUI::model::model_XZ::getPosition    RearBrake_Shoe          $BB_Position ]
                set pt_04       [myGUI::model::model_XZ::getPosition    RearBrake_Help          $BB_Position ]
                set pt_05       [myGUI::model::model_XZ::getPosition    RearBrake_Definition    $BB_Position ]
                set pt_06       [myGUI::model::model_XZ::getPosition    RearBrake_Mount         $BB_Position ]
                set dimension_01 [createDimension   D01320  length \
                                        [list       $pt_04  $pt_06] \
                                        aligned     [expr   -40 * $stageScale]    [expr  40 * $stageScale] \
                                        darkred ]    ;# Component(Brake/Rear/Offset)
                set dimension_02 [createDimension   D01321  length \
                                        [list       $pt_05  $pt_06 ] \
                                        aligned     [expr    60 * $stageScale]    [expr -50 * $stageScale] \
                                        darkred ]    ;# Component(Brake/Rear/LeverLength)
                if {$active == {active}} { 
                    myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension_01   single_RearBrake_Offset
                    myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension_02   single_RearBrake_LeverLength
                }
            }
            default {}
        }
    }
}
proc myGUI::dimension::createDimension_BrakeFront           {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    HeadSet
        #
    set Config(BrakeFront)       [myGUI::model::model_XZ::getConfig FrontBrake]
        #
    if {$Config(BrakeFront) != {off}} {
        switch $Config(BrakeFront) {
            Rim {
                set pt_03       [myGUI::model::model_XZ::getPosition    FrontBrake_Shoe         $BB_Position ]
                set pt_04       [myGUI::model::model_XZ::getPosition    FrontBrake_Help         $BB_Position ]
                set pt_05       [myGUI::model::model_XZ::getPosition    FrontBrake_Definition   $BB_Position ]
                set pt_06       [myGUI::model::model_XZ::getPosition    FrontBrake_Mount        $BB_Position ]
                    #
                # puts "   -> FrontBrake_Shoe       $pt_03"    
                # puts "   -> FrontBrake_Help       $pt_04"    
                # puts "   -> FrontBrake_Definition $pt_05"    
                # puts "   -> FrontBrake_Mount      $pt_06"
                    #
                set dimension_00 [createDimension   D01330  length \
                                        [list       $HeadSet(vct_Bottom) $pt_06] \
                                        perpendicular [expr -80 * $stageScale]  [expr  -40 * $stageScale] \
                                        gray50 ]        ;# distance Brake Mount Hole
                set dimension_01 [createDimension   D01331  length \
                                        [list       $pt_03  $pt_05] \
                                        aligned     [expr  -50 * $stageScale]    [expr  -70 * $stageScale] \
                                        darkred ]    ;# Component(Brake/Rear/Offset)
                set dimension_02 [createDimension   D01332  length \
                                        [list       $pt_03  $pt_04] \
                                        aligned     [expr   20 * $stageScale]    [expr   40 * $stageScale] \
                                        darkred ]    ;# Component(Brake/Rear/LeverLength)

                if {$active == {active}} { 
                    myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension_01   single_FrontBrake_Offset
                    myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension_02   single_FrontBrake_LeverLength
                }
            }
            default {}
        }
    }
}
proc myGUI::dimension::createDimension_BottleCage           {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
        # variable    Config   
        # variable    Rendering   
        #
    set Config(BottleCage_DT)    [myGUI::model::model_XZ::getConfig BottleCage_DownTube]
    set Config(BottleCage_DT_L)  [myGUI::model::model_XZ::getConfig BottleCage_DownTube_Lower]
    set Config(BottleCage_ST)    [myGUI::model::model_XZ::getConfig BottleCage_SeatTube]
    set Config(BrakeFront)       [myGUI::model::model_XZ::getConfig FrontBrake]
    set Config(BrakeRear)        [myGUI::model::model_XZ::getConfig RearBrake]
        #
        #    
        set dt_direction        [myGUI::model::model_XZ::getDirection DownTube]
        set st_direction        [myGUI::model::model_XZ::getDirection SeatTube]
        #
    if {$Config(BottleCage_ST) != {off}} {
            set pt_01           [myGUI::model::model_XZ::getPosition    BottleCage_ST_Offset   $BB_Position]
            set pt_02           [myGUI::model::model_XZ::getPosition    BottleCage_ST_Base     $BB_Position]
            set pt_03           [vectormath::addVector  $pt_02  $st_direction   [myGUI::model::model_XZ::getScalar     BottleCage  SeatTube]]
                #
            set dimension       [createDimension    D01340  length \
                                        [list          $pt_01  $pt_02 ] \
                                        aligned        [expr  70 * $stageScale]    [expr    0 * $stageScale] \
                                        gray50 ]
            set dimension       [createDimension    D01341  length \
                                        [list          $pt_02  $pt_03 ] \
                                        aligned        [expr  70 * $stageScale]    [expr  -15 * $stageScale] \
                                        darkblue ]
            if {$active == {active}} { 
                myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension  single_SeatTube_CageOffsetBB
            }
    }

    if {$Config(BottleCage_DT) != {off}} {
            set pt_01           [myGUI::model::model_XZ::getPosition    BottleCage_DT_TopOffset     $BB_Position]
            set pt_02           [myGUI::model::model_XZ::getPosition    BottleCage_DT_Top           $BB_Position]
            set pt_03           [vectormath::addVector  $pt_02  $dt_direction   [myGUI::model::model_XZ::getScalar     BottleCage  DownTube]]
                #
            if { $Config(BottleCage_DT_L) != {off}} { set addDist 50 } else { set addDist 0}

            set dimension       [createDimension    D01345  length \
                                        [list       $pt_01  $pt_02 ] \
                                        aligned     [expr -1.0 * (90 + $addDist) * $stageScale]    0 \
                                        gray50]
            set dimension       [createDimension    D01346  length \
                                        [list       $pt_02  $pt_03 ] \
                                        aligned     [expr -1.0 * (90 + $addDist) * $stageScale]    [expr  15 * $stageScale] \
                                        darkblue]
            if {$active == {active}} {    
                myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension   single_DownTube_CageOffsetBB
            }
    }
    if {$Config(BottleCage_DT_L) != {off}} {
                # tk_messageBox -message "   ... <I> \$Config(BottleCage_DT_L) $Config(BottleCage_DT_L)"
            set pt_01           [myGUI::model::model_XZ::getPosition    BottleCage_DT_BottomOffset  $BB_Position]
            set pt_02           [myGUI::model::model_XZ::getPosition    BottleCage_DT_Bottom        $BB_Position]
            set pt_03           [vectormath::addVector  $pt_02  $dt_direction   [myGUI::model::model_XZ::getScalar     BottleCage  DownTube_Lower]]
                #
            set dimension       [createDimension    D01350  length \
                                        [list       $pt_01  $pt_02 ] \
                                        aligned     [expr -60 * $stageScale]    0 \
                                        gray50]
            set dimension       [createDimension    D01351  length \
                                        [list       $pt_02  $pt_03 ] \
                                        aligned     [expr -60 * $stageScale]    [expr  15 * $stageScale] \
                                        darkblue]
            if {$active == {active}} {    
                myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension   single_DownTube_LowerCageOffsetBB
            }
    }
}
proc myGUI::dimension::createDimension_DerailleurMount      {BB_Position type active} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    set pt_01           [myGUI::model::model_XZ::getPosition    RearDropout         $BB_Position ]
    set pt_02           [myGUI::model::model_XZ::getPosition    RearDerailleur      $BB_Position ]
    set pt_03           [vectormath::rotatePoint    $pt_01  $BB_Position  90]
        #
    set do_dir          [myGUI::model::model_XZ::getDirection   RearDropout]
        #
    set offset_y        [myGUI::model::model_XZ::getScalar      RearDropout Derailleur_y]
        #
    set pt_04           [vectormath::addVector      $pt_01      [vectormath::rotatePoint  {0 0} $do_dir -90] $offset_y]
        #	
    set radius          [vectormath::length         $pt_01  $pt_02]
        #
    set arc_Derailleur  [$cvObject create arc    $pt_01  -radius $radius -start -135  -extent 70 -style arc -outline gray60  -tags __CenterLine__]
        #
    set dimension_01            [createDimension    D01360  length \
                                        [list       $pt_04 $pt_01 $pt_02] \
                                        perpendicular [expr  -80 * $stageScale]    [expr  -30 * $stageScale] \
                                        gray50 ] 	
    set dimension_02            [createDimension    D01361  length \
                                        [list       $pt_04 $pt_02 $pt_01] \
                                        perpendicular [expr  -60 * $stageScale]    [expr   40 * $stageScale] \
                                        gray50 ]
    set dimension_03            [createDimension    D01362  length \
                                        [list       $pt_01   $pt_02] \
                                        aligned     [expr   40 * $stageScale]    [expr   50 * $stageScale] \
                                        gray50 ]
        #
    set direction       [myGUI::model::model_XZ::getConfig RearDropoutOrient]
        #
    if { $direction == {horizontal}} {
        set dimension_04        [createDimension    D01363  length \
                                        [list       $pt_03 $pt_01 $pt_02] \
                                        perpendicular [expr -110 * $stageScale]    [expr   30 * $stageScale] \
                                        gray50 ]
    }
        #																								
    if {$active == {active}} { 
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension_01   group_RearDerailleur_Mount
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dimension_02   group_RearDerailleur_Mount
    }
}
proc myGUI::dimension::createDimension_RearWheelClearance   {BB_Position type} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    set RimDiameter [myGUI::model::model_XZ::getScalar       Geometry RearRim_Diameter]
    set TyreHeight  [myGUI::model::model_XZ::getScalar       Geometry RearTyre_Height]
    set WheelRadius [expr 0.5 * $RimDiameter + $TyreHeight ]
    set pt_03       [myGUI::model::model_XZ::getPosition    RearWheel   $BB_Position  ]
    set pt_06       [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeBottom_Back   $BB_Position]
    set pt_07       [myGUI::model::model_XZ::getPosition    _Edge_SeatTubeTaperEnd_Back $BB_Position]
    set pt_is       [vectormath::intersectPerp $pt_06 $pt_07 $pt_03 ]
    set pt_rw       [vectormath::addVector $pt_03  [vectormath::unifyVector  $pt_03  $pt_is  $WheelRadius ] ]
        #
    set dimension               [createDimension    D01370  length \
                                        [list       $pt_rw $pt_is] \
                                        aligned     [expr -90 * $stageScale]  [expr 50 * $stageScale] \
                                        gray50 ]
        #
    return
        #
}
proc myGUI::dimension::createDimension_LegClearance         {BB_Position type} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    LegClearance
    variable    TopTube   
        #
    set pt_01       [myGUI::model::model_XZ::getPosition       LegClearance        $BB_Position ]
    set pt_09       [myGUI::model::model_XZ::getPosition    _Edge_TopTubeTaperTop_HT      $BB_Position]
    set pt_10       [myGUI::model::model_XZ::getPosition    _Edge_TopTubeTaperTop_ST      $BB_Position]
        #
    set pt_is       [vectormath::intersectPerp $pt_09 $pt_10 $pt_01 ]
        #
    set dimension               [createDimension    D01375  length \
                                        [list       $pt_01 $pt_is] \
                                        aligned     [expr -30 * $stageScale]  [expr 50 * $stageScale] \
                                        gray50 ]
        #
    return
        #
}
    #
    #
proc myGUI::dimension::createDimension_Geometry_hybrid_personal         {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Rendering
    variable    Reference
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    LegClearance
    variable    Saddle
    variable    SaddleNose
        #
    variable    Position
    variable    Length
        #
    if {$active ne "inactive"} {
        set dimColor    $myGUI::cvCustom::DraftingColor(personal)  
        set dimColor_2  $myGUI::cvCustom::DraftingColor(personal_2)
    } else {
        set dimColor    gray20
        set dimColor_2  gray70
    }
        #
    set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
        #
        # ---
        #
    set dim__single_Personal_HandleBarDistance \
                                [createDimension    A00000  length \
                                        [list       $HandleBar(Position) $CrankSet(Position)] \
                                        horizontal \
                                        [expr (150 + $Length(Height_HB_Seat)) * $stageScale] 0 \
                                        $dimColor ]
                #
    set dim__single_Personal_HandleBarHeight    \
                                [createDimension    A00000  length \
                                        [list       $HandleBar(Position) $CrankSet(Position)] \
                                        vertical    \
                                        [expr -310 * $stageScale] [expr  180 * $stageScale] \
                                        $dimColor ]
                #
    set dim__single_Personal_SaddleDistance     \
                                [createDimension    A00000  length \
                                        [list       $Saddle(Position) $BottomBracket(Position) ] \
                                        horizontal    [expr -150 * $stageScale] 0 \
                                        $dimColor ]
                #
    set dim__single_Personal_SaddleHeight   \
                                [createDimension    A00000  length \
                                        [list $CrankSet(Position)      $Saddle(Position)] \
                                        vertical \
                                        [expr -580 * $stageScale] [expr -130 * $stageScale]  \
                                        $dimColor ]
                #
    set dim__single_TopTube_PivotPosition   \
                                [createDimension    A00000  length \
                                        [list $LegClearance(Position)  $CrankSet(Position)] \
                                        horizontal  \
                                        [expr  $distY_SN_LC * $stageScale]   0  \
                                        $dimColor_2 ]
                #
    set dim__single_Personal_InnerLegLength \
                                [createDimension    A00000  length \
                                        [list       $LegClearance(Position)  $Position(BaseCenter) ] \
                                        vertical \
                                        [expr  -50 * $stageScale] [expr   160 * $stageScale]  \
                                        $dimColor_2 ]
                #
                #
    if {$active ne "inactive"} {
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Personal_HandleBarDistance     single_Personal_HandleBarDistance
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Personal_HandleBarHeight       single_Personal_HandleBarHeight
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Personal_SaddleDistance        single_Personal_SaddleDistance
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Personal_SaddleHeight          single_Personal_SaddleHeight
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_TopTube_PivotPosition          single_TopTube_PivotPosition
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Personal_InnerLegLength        single_Personal_InnerLegLength
    }
        #   
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_hybrid_primary          {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Rendering
    variable    Reference
        #
    variable    BottomBracket
    variable    CrankSet
    variable    Fork
    variable    FrontWheel
    variable    HandleBar
    variable    RearWheel
    variable    Saddle
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
    variable    Stem
        #
    variable    Position
    variable    Length
        #
        #
    if {$active ne "inactive"} {
        set dimColor    $myGUI::cvCustom::DraftingColor(primary)
    } else {
        set dimColor    gray30
    }
        #
    set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
    set help_02            [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
    set help_03            [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
    set help_fk            [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
        #
        # --- primary - dimensions
        #               
        
    set dim__group_RearWheel_Parameter      \
                [createDimension    A00000    length      \
                        [list $RearWheel(Position)      $RearWheel(Ground) ] \
                        vertical    \
                        [expr   130 * $stageScale]    0 \
                        $dimColor ]
                #
    set dim__single_SaddleHeightComponent   \
                [createDimension    A00000    length      \
                        [list $SeatPost(Saddle) $Saddle(Position)  ] \
                        aligned     \
                        [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                        $dimColor ]
                #
    set dim__single_SeatPost_Setback        \
                [createDimension    A00000    length      \
                        [list $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                        perpendicular   \
                        [expr  -80 * $stageScale]  [expr -35 * $stageScale]  \
                        $dimColor ]
                #
    set dim__single_SeatPost_PivotOffset    \
                [createDimension    A00000    length      \
                        [list  $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                        perpendicular   \
                        [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                        $dimColor ]
                #
    set dim__single_BottomBracket_Depth     \
                [createDimension    A00000    length      \
                        [list $BottomBracket(Position)  $RearWheel(Position) ] \
                        vertical    \
                        [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                        $dimColor ]
                #
    set dim__single_BottomBracket_Excenter     \
                [createDimension    A00000    length      \
                        [list $BottomBracket(Position)  $CrankSet(Position) ] \
                        vertical    \
                        [expr   100 * $stageScale]   [expr  90 * $stageScale]  \
                        $dimColor ]
                #
    set dim__single_RearWheel_Distance      \
                [createDimension    A00000    length      \
                        [list $RearWheel(Position)      $BottomBracket(Position)] \
                        aligned     \
                        [expr   100 * $stageScale]   0 \
                        $dimColor ]
                #
    set dim__single_HeadTube_Angle          \
                [createDimension    A00000    angle       \
                        [list $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                        150   0  \
                        $dimColor ]
                #
    set dim__single_Stem_Length             \
                [createDimension    A00000   length      \
                        [list $HandleBar(Position)      $Steerer(Stem) ] \
                        aligned \
                        [expr    80 * $stageScale]  0 \
                        $dimColor ]
                #
    set dim__group_FrontWheel_Parameter_01  \
                [createDimension    A00000    length      \
                        [list $FrontWheel(Position)     $FrontWheel(Ground) ] \
                        vertical    \
                        [expr  -150 * $stageScale]    0 \
                        $dimColor ]
                #
    set dim__single_Fork_Rake               \
                [createDimension    A00000    length      \
                        [list $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                        perpendicular   \
                        [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                        $dimColor ]
                #
                #
    if {$Stem(Angle) > 0} {
        set coordList [list $Steerer(Stem)  $help_02 $HandleBar(Position) ]
    } else {
        set coordList [list $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
    }
    set dim__single_Stem_Angle              \
                [createDimension    A00000  angle \
                        $coordList \
                        [expr $Stem(Length) +  80]   0  \
                        $dimColor ]
                #
                #
    if {$Fork(Rake) != 0} {
        set coordList   [list  $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
    } else {
        set coordList   [list  $FrontWheel(Position) $Steerer(Fork)  ]
    }
    set dim__single_Fork_Height    \
                [createDimension    A00000  length    \
                        $coordList \
                        perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                        $dimColor ]
               #
               #                       
    if {$SeatTube(OffsetBB) > 0} {
        set dim_distance    [expr  90 * $stageScale]
        set dim_offset      [expr  50 * $stageScale]
    } else {
        set dim_distance    [expr -90 * $stageScale]
        set dim_offset      [expr -50 * $stageScale]
    }
    set dim__single_SeatTube_BottomBracketOffset    \
                [createDimension    A00000  length    \
                        [list $SeatPost(SeatTube) $SeatTube(BBracket) $BB_Position] \
                        perpendicular   \
                        $dim_distance $dim_offset \
                        $dimColor ]
                #
                #
    if {$active ne "inactive"} {
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__group_RearWheel_Parameter             group_RearWheel_Parameter
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_SaddleHeightComponent          single_SaddleHeightComponent
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_SeatPost_Setback               single_SeatPost_Setback
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_SeatPost_PivotOffset           single_SeatPost_PivotOffset
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_BottomBracket_Depth            single_BottomBracket_Depth
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_BottomBracket_Excenter         single_BottomBracket_Excenter
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_RearWheel_Distance             single_RearWheel_Distance
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_HeadTube_Angle                 single_HeadTube_Angle
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Stem_Length                    single_Stem_Length
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__group_FrontWheel_Parameter_01         group_FrontWheel_Parameter_01
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Fork_Rake                      single_Fork_Rake
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Stem_Angle                     single_Stem_Angle
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Fork_Height                    single_Fork_Height
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_SeatTube_BottomBracketOffset   single_SeatTube_BottomBracketOffset
    }

        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_hybrid_secondary        {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    HeadTube
    variable    LegClearance
    variable    SaddleNose                
    variable    Steerer                
        #
    variable    Position
        #
        #
    if {$active ne "inactive"} {
        set dimColor    $myGUI::cvCustom::DraftingColor(secondary)  
    } else {
        set dimColor    gray40
    }
        #            
        #
        # --- 
        #
    set distY_SN_LC         [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
        #
        # ---
        #
        
    set dim__group_Saddle_Parameter_01    \
                [createDimension    A00000    length  \
                        [list $SaddleNose(Position)    $BottomBracket(Position) ] \
                        horizontal  \
                        [expr  $distY_SN_LC * $stageScale]   0  \
                        $dimColor ]
                #
    set dim__single_CrankSet_Length    \
                [createDimension    A00000    radius  \
                        [list $CrankSet(Position)      $Position(help_91)] \
                        -20 [expr  130 * $stageScale] \
                        $dimColor ]
                #
                #
    if {$active ne "inactive"} {
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__group_Saddle_Parameter_01     group_Saddle_Parameter_01
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_CrankSet_Length        single_CrankSet_Length
    }
        #
    return
        #    
}
proc myGUI::dimension::createDimension_Geometry_hybrid_result           {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
    variable    TopTube
        #
    variable    Position
        #
        #
    if {$active ne "inactive"} {
        set dimColor    $myGUI::cvCustom::DraftingColor(result)
    } else {
        set dimColor    gray40
    } 
        #
    set help_00            [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
    set help_01            [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
        #
        #
        # --- result - level - dimensions
        #
                #
    set dim__single_Result_Saddle_Offset_HB_X    \
                [createDimension    A00000  length    \
                        [list $Saddle(Position)      $HandleBar(Position) ] \
                        horizontal  \
                        [expr  -210 * $stageScale]    0 \
                        $dimColor ]
                #
   set dim__single_Result_Saddle_Offset_HB_Y    \
                [createDimension    A00000  length    \
                        [list $HandleBar(Position)     $Saddle(Position) ] \
                        vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                        $dimColor ]
                #
    set dim__single_Result_FrontWheel_diagonal    \
                [createDimension    A00000  length    \
                        [list $CrankSet(Position)      $FrontWheel(Position)] \
                        aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                        $dimColor ]
                #
    set dim__single_Result_FrontWheel_horizontal    \
                [createDimension    A00000  length    \
                        [list $Position(BaseCenter)    $FrontWheel(Ground) ] \
                        horizontal  [expr   70 * $stageScale]   0 \
                        $dimColor ]
                #
   set dim__single_Result_BottomBracket_Height        \
                [createDimension    A00000  length    \
                        [list $BottomBracket(Position) $Position(BaseCenter)] \
                        vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                        $dimColor ]
                #
    set dim__single_Result_SeatTube_Angle        \
                [createDimension    A00000  angle \
                        [list $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                        150   0  \
                        $dimColor ]
                #
    set dim__single_Result_RearWheel_horizontal    \
                [createDimension    A00000  length    \
                        [list $RearWheel(Ground)       $Position(BaseCenter) ] \
                        horizontal  [expr   70 * $stageScale]   0 \
                        $dimColor ]
                #
    set dim__single_Result_SaddleNose_HB    \
                [createDimension    A00000  length    \
                        [list $SaddleNose(Position)    $HandleBar(Position)] \
                        horizontal      [expr  -80 * $stageScale]    0 \
                        $dimColor ]
                #
                #
    if {$active ne "inactive"} {
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_Saddle_Offset_HB_X      single_Result_Saddle_Offset_HB_X
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_Saddle_Offset_HB_Y      single_Result_Saddle_Offset_HB_Y
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_FrontWheel_diagonal     single_Result_FrontWheel_diagonal
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_FrontWheel_horizontal   single_Result_FrontWheel_horizontal
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_BottomBracket_Height    single_Result_BottomBracket_Height
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_SeatTube_Angle          single_Result_SeatTube_Angle
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_RearWheel_horizontal    single_Result_RearWheel_horizontal
        myGUI::gui::bind_dimensionEvent_2   $cvObject   $dim__single_Result_SaddleNose_HB           single_Result_SaddleNose_HB
    }
        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_hybrid_summary          {BB_Position} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    FrontWheel
    variable    HandleBar
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
        #
    variable    Position
    variable    Length
        #
        #
    set dimColor   $myGUI::cvCustom::DraftingColor(background)  
        #
        # ----
        #
    set _dim_SD_Height \
            [createDimension    A00000  length \
                    [list $Position(BaseCenter)  $Saddle(Position) ] \
                    vertical    \
                    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_HB_Height \
            [createDimension    A00000  length \
                    [list $HandleBar(Position)   $Position(BaseCenter) ] \
                    vertical    \
                    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                    $dimColor ]
                    
    # set _dim_SD_HB_Length   \
            [createDimension    A00000  length    \
                    [list $Saddle(Position)      $HandleBar(Position) ] \
                    horizontal  \
                    [expr  -210 * $stageScale]    0 \
                    $dimColour ]

    set _dim_Wh_Distance \
            [createDimension    A00000  length \
                    [list $RearWheel(Ground)     $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr  130 * $stageScale]    0 \
                    $dimColor ]
    set _dim_FW_Lang \
            [createDimension    A00000  length \
                    [list $FrontWheel(Ground)    $Steerer(Ground) ] \
                    horizontal  \
                    [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                    $dimColor ]

    set _dim_BT_Clearance \
            [createDimension    A00000  length \
                    [list $Position(help_91)     $Position(help_92) ] \
                    aligned \
                    0   [expr -150 * $stageScale]  \
                    $dimColor ]

    set _dim_ST_Length \
            [createDimension    A00000  length \
                    [list $Position(help_93)     $Saddle(Position) ] \
                    aligned \
                    [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SN_HandleBar  \
            [createDimension     A00000  length \
                    [list $SaddleNose(Position)     $HandleBar(Position) ] \
                    aligned     \
                    [expr -150 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]

        parray SeatPost             
        parray SeatTube
        parray Saddle
        
    set _dim_SP_Offset  \
            [createDimension     A00000  length \
                    [list $SeatTube(Ground) $SeatPost(SeatTube) $Saddle(Mount)] \
                    perpendicular     \
                    [expr  -40 * $stageScale]   [expr  30 * $stageScale]  \
                    $dimColor]
        
        
        
        
    # set _dim_SP_Height    \
            [createDimension    A00000  length    \
                    [list $SeatPost(Saddle)      $BottomBracket(Position)  ] \
                    vertical    \
                    [expr (500 + $Length(Length_BB_Seat)) * $stageScale ]    [expr  150 * $stageScale] \
                    $dimColour ]

        #
    return
        #
}
    #
proc myGUI::dimension::createDimension_Geometry_stackreach_personal     {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    LegClearance
    variable    Saddle
    variable    SaddleNose
    variable    SeatTube
    variable    Steerer
        #
    variable    Position 
        #
        #
    set dimColor     $myGUI::cvCustom::DraftingColor(personal)  
    set dimColor_2   $myGUI::cvCustom::DraftingColor(personal_2)  
        #
        # ---
        #
    set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
        #
        # --- personal - dimensions
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $CrankSet(Position)      $SeatTube(Saddle) ] \
                    aligned \
                    [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                    $dimColor ]    \
            single_Result_Saddle_SeatTube_BB
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $LegClearance(Position)  $BottomBracket(Position) ] \
                    horizontal  \
                    [expr  $distY_SN_LC * $stageScale]   0  \
                    $dimColor_2 ]  \
            single_TopTube_PivotPosition
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $LegClearance(Position)  $Position(BaseCenter) ] \
                    vertical    \
                    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                    $dimColor_2 ]  \
            single_Personal_InnerLegLength            
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $HandleBar(Position)     $Saddle(Position) ] \
                    vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]    \
            single_Result_Saddle_Offset_HB_Y
                #

        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_stackreach_primary      {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    Fork
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
    variable    Stem
    variable    TopTube
        #
    variable    Position
        #
        #
    set dimColor       $myGUI::cvCustom::DraftingColor(primary)  
        #
    set help_00         [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
    set help_01         [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
    set help_02         [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
    set help_fk         [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
        #
        # ---
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $HeadTube(Stem)          $CrankSet(Position) ] \
                    horizontal  \
                    [expr  -80 * $stageScale]    0 \
                    $dimColor ]    \
            single_Result_HeadTube_ReachLength
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length    \
                    [list $HeadTube(Stem)          $CrankSet(Position) ] \
                    vertical    \
                    [expr   80 * $stageScale]    [expr  120 * $stageScale]  \
                    $dimColor ]    \
            single_Result_StackHeight
                #                   
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $BottomBracket(Position)  $RearWheel(Position)] \
                    vertical \
                    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                    $dimColor ] \
            single_BottomBracket_Depth
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000    length \
                        [list $BottomBracket(Position)  $CrankSet(Position)] \
                        vertical \
                        [expr   100 * $stageScale]   [expr  90 * $stageScale]  \
                        $dimColor ] \
            single_BottomBracket_Excenter
                        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $RearWheel(Position)      $BottomBracket(Position)] \
                    aligned \
                    [expr   100 * $stageScale]   0 \
                    $dimColor ] \
            single_RearWheel_Distance
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $RearWheel(Position)      $RearWheel(Ground) ] \
                    vertical    \
                    [expr   130 * $stageScale]    0 \
                    $dimColor ]    \
            group_RearWheel_Parameter
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $FrontWheel(Position)     $FrontWheel(Ground) ] \
                    vertical    \
                    [expr  -150 * $stageScale]    0 \
                    $dimColor ]    \
            group_FrontWheel_Parameter_01
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    [list $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                    perpendicular   \
                    [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_Fork_Rake
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  angle \
                    [list $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                    150   0  \
                    $dimColor ]    \
            single_HeadTube_Angle
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  angle \
                    [list $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                    150   0  \
                    $dimColor ]    \
            single_Result_SeatTube_Angle
                #
                #
    if {$Fork(Rake) != 0} {
        set coordList   [list  $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
    } else {
        set coordList   [list  $FrontWheel(Position) $Steerer(Fork)  ]
    }
    myGUI::gui::bind_dimensionEvent_2   $cvObject   \
            [createDimension    A00000  length \
                    $coordList \
                    perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                    $dimColor ] \
            single_Fork_Height        
        
        
        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_stackreach_secondary    {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    HeadTube
    variable    LegClearance
    variable    Saddle
    variable    SaddleNose                
    variable    SeatPost
    variable    SeatTube
    variable    Stem                
    variable    Steerer                
        #
    variable    Position
    variable    Length
        #
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(secondary)  
        #            
        #
        # --- 
        #
    set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
    set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
    set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
    set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
        #
        # ---
        #
    
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length \
                    [list $SaddleNose(Position)    $CrankSet(Position) ] \
                    horizontal  \
                    [expr  $distY_SN_LC * $stageScale]   0  \
                    $dimColor ]    \
            group_Saddle_Parameter_01
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  radius \
                    [list $CrankSet(Position)      $Position(help_91)] \
                    -20            [expr  130 * $stageScale] \
                    $dimColor ]    \
            single_CrankSet_Length
                #      
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length \
                    [list $SeatPost(Saddle)        $Saddle(Position)  ] \
                    aligned \
                    [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_SaddleHeightComponent
                #            
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list  $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                    perpendicular   \
                    [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                    $dimColor ]    \
            single_SeatPost_PivotOffset
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length \
                    [list $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                    perpendicular   \
                    [expr  -80 * $stageScale]  [expr -35 * $stageScale]  \
                    $dimColor ]    \
            single_SeatPost_Setback
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length \
                    [list $HandleBar(Position)      $Steerer(Stem) ] \
                    aligned     [expr    80 * $stageScale]    0 \
                    $dimColor ]    \
            single_Stem_Length                            
                #
    if {$Stem(Angle) > 0} {
        set coordList [list $Steerer(Stem)  $help_02 $HandleBar(Position) ]
    } else {
        set coordList [list $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
    }
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    $coordList \
                    [expr $Stem(Length) +  80]   0  \
                    $dimColor ] \
            single_Stem_Angle
                #

        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_stackreach_result       {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    FrontWheel
    variable    HeadTube
    variable    Saddle
    variable    SeatTube
    variable    Steerer
        #
    variable    Position
        #
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(result)  
        #
        
        #
    set help_01     [ vectormath::addVector         $HeadTube(Stem)     {1 0} ]
    set help_02     [ vectormath::intersectPoint    $SeatTube(BBracket) $SeatTube(Saddle)   $HeadTube(Stem) $help_01]
        #
        
        #
        # --- result - level - dimensions
        #
        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $Position(BaseCenter)] \
                    vertical    \
                    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                    $dimColor ]    \
            single_Result_BottomBracket_Height
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $CrankSet(Position) $FrontWheel(Position)] \
                    aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                    $dimColor ]    \
            single_Result_FrontWheel_diagonal
        #
    $cvObject create circle      $help_02    -radius 4.0     -outline $dimColor     -width 0.5  -tags {__CenterLine__    seattube_classic}
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $help_02         $HeadTube(Stem) ] \
                    aligned  \
                    [expr  140 * $stageScale]   [expr -100 * $stageScale] \
                    $dimColor ]    \
            single_Result_TopTube_VirtualLength 
        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $help_02         $SeatTube(BBracket) ] \
                    aligned  \
                    [expr  -80 * $stageScale]   [expr  50 * $stageScale] \
                    $dimColor ]    \
            single_Result_SeatTube_VirtualLength 
        # 
    
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Fork)   $HeadTube(Stem) ] \
                    aligned \
                    [expr  100 * $stageScale]   0 \
                    $dimColor ]    \
            group_HeadTube_Parameter_02   
                #                
        
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_stackreach_summary      {BB_Position} {
        # geometry_bg
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
    variable    Fork
        #
    variable    Position
    variable    Length
        #
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(background)  
        #

        #
    set help_00             [ vectormath::addVector         $SeatTube(Ground)   {-200 0} ]
    set help_01             [ vectormath::addVector         $HeadTube(Stem)     {1 0} ]
    set help_02             [ vectormath::intersectPoint    $SeatTube(BBracket) $SeatTube(Saddle)   $HeadTube(Stem) $help_01]



    set help_fk             [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
        #
        # ---
        #
    $cvObject create centerline  [list  [lindex $help_02 0] [lindex $help_02 1] [lindex $HeadTube(Stem) 0] [ lindex $HeadTube(Stem) 1]]  -fill $dimColor -tags {__CenterLine__ toptube_classic}
        #
    
    createDimension     A00000  length    \
                    [list $Position(BaseCenter)    $Saddle(Position) ] \
                    vertical    \
                    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                    $dimColor
                    
    createDimension     A00000  length    \
                    [list $HandleBar(Position)     $Position(BaseCenter) ] \
                    vertical    \
                    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                    $dimColor
                    
    createDimension     A00000  length    \
                    [list $Saddle(Position)        $HandleBar(Position) ] \
                    horizontal  \
                    [expr  -210 * $stageScale]    0 \
                    $dimColor

    createDimension     A00000  length    \
                    [list $RearWheel(Ground)       $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr  130 * $stageScale]    0 \
                    $dimColor
                    
    createDimension     A00000  length    \
                    [list $FrontWheel(Ground)      $Steerer(Ground) ] \
                    horizontal  \
                    [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                    $dimColor

    createDimension     A00000  length    \
                    [list $Position(help_91)       $Position(help_92) ] \
                    aligned \
                    0   [expr -150 * $stageScale]  \
                    $dimColor 

    createDimension     A00000  length    \
                    [list $Position(help_93)       $Saddle(Position) ] \
                    aligned \
                    [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                    $dimColor 
                                                
    createDimension     A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    horizontal  \
                    [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                    $dimColor
                            
    createDimension     A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    vertical    \
                    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                    $dimColor
                            
    createDimension     A00000  length    \
                    [list $Saddle(Position)        $CrankSet(Position)  ] \
                    horizontal  \
                    [expr -150 * $stageScale]    0 \
                    $dimColor
                            
    createDimension     A00000  length    \
                    [list $CrankSet(Position)      $Saddle(Position) ] \
                    vertical    \
                    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                    $dimColor        

    createDimension     A00000  angle \
                    [list $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                    150   0  \
                    $dimColor
                    
    createDimension     A00000  angle \
                    [list $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                    150   0  \
                    $dimColor    
                                    
    createDimension     A00000  length    \
                    [list $BottomBracket(Position) $RearWheel(Position) ] \
                    vertical    \
                    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                    $dimColor
                                   
    createDimension     A00000  length    \
                    [list $RearWheel(Ground)       $Position(BaseCenter) ] \
                    horizontal  \
                    [expr    70 * $stageScale]   0 \
                    $dimColor
                    
    createDimension     A00000  length    \
                    [list $Position(BaseCenter)    $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr    70 * $stageScale]   0 \
                    $dimColor

    createDimension     A00000  length    \
                [list $SaddleNose(Position)        $HandleBar(Position)] \
                horizontal  \
                [expr  -80 * $stageScale]    0 \
                $dimColor

    createDimension     A00000  length    \
                [list $HandleBar(Position)         $Saddle(Position) ] \
                vertical    \
                [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                $dimColor            

    createDimension     A00000  length \
                [list $SaddleNose(Position)     $HandleBar(Position) ] \
                aligned     \
                [expr -150 * $stageScale]   [expr -100 * $stageScale]  \
                $dimColor ] 

    $cvObject create circle      $help_02    -radius 4.0     -outline $dimColor     -width 0.5  -tags {__CenterLine__    seattube_virtual}
                
    set _dim_SP_Offset  \
            [createDimension     A00000  length \
                    [list $SeatTube(Ground) $SeatPost(SeatTube) $Saddle(Mount)] \
                    perpendicular     \
                    [expr  -40 * $stageScale]   [expr  30 * $stageScale]  \
                    $dimColor]
                    
                    
    # createDimension     A00000  length    \
                [list $help_02         $HeadTube(Stem) ] \
                horizontal  \
                [expr  130 * $stageScale]   [expr  50 * $stageScale] \
                $dimColor

    if {$Fork(Rake) != 0} {
        set coordList   [list  $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
    } else {
        set coordList   [list  $FrontWheel(Position) $Steerer(Fork)  ]
    }
                #
    #createDimension     A00000  length  \
                $coordList  \
                perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                $dimColour 
                    

        #
    return
        #
}
    #
proc myGUI::dimension::createDimension_Geometry_classic_personal        {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Rendering
    variable    Reference
        #
    variable    BottomBracket
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
    set dimColor      $myGUI::cvCustom::DraftingColor(personal)  
    set dimColor_2    $myGUI::cvCustom::DraftingColor(personal_2)  
        #
        # ---
        #
    set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
        #
        # --- personal - dimensions
        #
        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $CrankSet(Position)      $SeatTube(Saddle) ] \
                    aligned \
                    [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                    $dimColor ]    \
            single_Result_Saddle_SeatTube_BB
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $LegClearance(Position)  $CrankSet(Position) ] \
                    horizontal  \
                    [expr  $distY_SN_LC * $stageScale]   0  \
                    $dimColor_2 ]  \
            single_TopTube_PivotPosition
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $LegClearance(Position)  $Position(BaseCenter) ] \
                    vertical    \
                    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                    $dimColor_2 ] \
            single_Personal_InnerLegLength
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $Saddle(Position) ] \
                    vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]    \
            single_Result_Saddle_Offset_HB_Y
                 
        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_classic_primary         {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    Fork
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
    variable    TopTube
        #
    variable    Position
        #
        #
    set dimColor       $myGUI::cvCustom::DraftingColor(primary)  
        #
    set help_00         [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
    set help_01         [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
    set help_fk         [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
        #
        # --- primary - dimensions
        #
        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HeadTube(Stem)  $TopTube(Steerer) ] \
                    aligned \
                    [expr   80 * $stageScale]   [expr   80 * $stageScale] \
                    $dimColor ]    \
            single_Result_HeadTube_TopTubeCenter
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $TopTube(SeatClassic)    $TopTube(Steerer)] \
                    aligned \
                    [expr   80 * $stageScale]   [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_Result_TopTube_ClassicLength
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $TopTube(SeatClassic) ] \
                    aligned \
                    [expr   80 * $stageScale]   [expr   90 * $stageScale] \
                    $dimColor ]    \
            single_Result_SeatTube_ClassicLength
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position)  $RearWheel(Position) ] \
                    vertical    \
                    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                    $dimColor ]    \
            single_BottomBracket_Depth
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000    length      \
                        [list $BottomBracket(Position)  $CrankSet(Position) ] \
                        vertical    \
                        [expr   100 * $stageScale]   [expr  90 * $stageScale]  \
                        $dimColor ]     \
            single_BottomBracket_Excenter
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $RearWheel(Position)      $BottomBracket(Position)] \
                    aligned \
                    [expr   100 * $stageScale]   0 \
                    $dimColor ]    \
            single_RearWheel_Distance
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $RearWheel(Position)      $RearWheel(Ground) ] \
                    vertical    \
                    [expr   130 * $stageScale]    0 \
                    $dimColor ]    \
            group_RearWheel_Parameter
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $FrontWheel(Position)     $FrontWheel(Ground) ] \
                    vertical    \
                    [expr  -150 * $stageScale]    0 \
                    $dimColor ]    \
            group_FrontWheel_Parameter_01
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                    perpendicular [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_Fork_Rake
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [list $Steerer(Ground)  $Steerer(Fork)  $Position(BaseCenter) ] \
                    150   0  \
                    $dimColor ]    \
            single_HeadTube_Angle
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [list $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                    150   0  \
                    $dimColor ]    \
            single_Result_SeatTube_Angle
                #  
                #                        
    if {$Fork(Rake) != 0} {
        set coordList   [list  $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
    } else {
        set coordList   [list  $FrontWheel(Position) $Steerer(Fork)  ]
    }
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    $coordList \
                    perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                    $dimColor ]    \
            single_Fork_Height

        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_classic_secondary       {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    HeadTube
    variable    LegClearance
    variable    Saddle
    variable    SaddleNose                
    variable    SeatPost
    variable    SeatTube
    variable    Stem                
    variable    Steerer                
        #
    variable    Position
    variable    Length
        #
        #
    set dimColor        $myGUI::cvCustom::DraftingColor(secondary)  
        #            
        #
        # --- 
        #
    set distY_SN_LC     [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
    set help_01         [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
    set help_02         [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
    set help_03         [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
        #
        # ---
        #
    
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SaddleNose(Position)    $BottomBracket(Position) ] \
                    horizontal  \
                    [expr  $distY_SN_LC * $stageScale]   0  \
                    $dimColor ]    \
            group_Saddle_Parameter_01
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  radius    \
                    [list $CrankSet(Position)      $Position(help_91)] \
                    -20            [expr  130 * $stageScale] \
                    $dimColor ]    \
            single_CrankSet_Length
                #      
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SeatPost(Saddle) $Saddle(Position)  ] \
                    aligned \
                    [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_SaddleHeightComponent
                #            
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list  $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                    perpendicular   \
                    [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                    $dimColor ]    \
            single_SeatPost_PivotOffset
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                    perpendicular   \
                    [expr  -80 * $stageScale]  [expr -35 * $stageScale]  \
                    $dimColor ]    \
            single_SeatPost_Setback
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)      $Steerer(Stem) ] \
                    aligned     [expr    80 * $stageScale]    0 \
                    $dimColor ]    \
            single_Stem_Length                            
                #
    # myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Fork)   $HeadTube(Stem) ] \
                    aligned \
                    [expr  100 * $stageScale]   0 \
                    $dimColor ]    \
            group_HeadTube_Parameter_02   
                #      
    if {$Stem(Angle) > 0} {
        set coordList [list $Steerer(Stem)  $help_02 $HandleBar(Position) ]
    } else {
        set coordList [list $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
    }
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    $coordList \
                    [expr $Stem(Length) +  80]   0  \
                    $dimColor ] \
            single_Stem_Angle
    
        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_classic_result          {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    RearWheel
    variable    Saddle
    variable    Steerer
    variable    TopTube
        #
    variable    Position
        #
        #
    set dimColor   $myGUI::cvCustom::DraftingColor(result)  
        #
        
        #
        # --- result - dimensions
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $Position(BaseCenter)] \
                    vertical    [expr  150 * $stageScale]   [expr   -20 * $stageScale]  \
                    $dimColor ]    \
            single_Result_BottomBracket_Height
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $RearWheel(Ground)       $Position(BaseCenter) ] \
                    horizontal  [expr   70 * $stageScale]   0 \
                    $dimColor ]    \
            single_Result_RearWheel_horizontal
                                        
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Fork)   $HeadTube(Stem) ] \
                    aligned \
                    [expr  100 * $stageScale]   0 \
                    $dimColor ]    \
            group_HeadTube_Parameter_02   
                #
    
    # myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Fork)  $TopTube(HeadVirtual) ] \
                    aligned \
                    [expr   100 * $stageScale]   0 \
                    $dimColor ]    \
            single_Result_HeadTube_VirtualLength
        #
    # myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Fork)  $HeadTube(Stem) ] \
                    aligned \
                    [expr   100 * $stageScale]   0 \
                    $dimColour ]    \
            group_HeadTube_Parameter_01
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $FrontWheel(Position)] \
                    aligned     [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                    $dimColor ]    \
            single_Result_FrontWheel_diagonal
        #
}
proc myGUI::dimension::createDimension_Geometry_classic_summary         {BB_Position} {
        # geometry_bg
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    Fork
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    LegClearance
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
        #
    variable    Position
    variable    Length
        #
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(background)  
        #

        #
    set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
    set help_01     [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
    set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
        #
        # ---
        #
    set _dim_SD_Height  \
            [createDimension    A00000  length    \
                    [list $Position(BaseCenter)    $Saddle(Position) ] \
                    vertical    \
                    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_HB_Height  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $Position(BaseCenter) ] \
                    vertical    \
                    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SD_HB_Length  \
            [createDimension    A00000  length    \
                    [list $Saddle(Position)        $HandleBar(Position) ] \
                    horizontal  \
                    [expr  -210 * $stageScale]    0 \
                    $dimColor ]

    set _dim_Wh_Distance  \
            [createDimension    A00000  length    \
                    [list $RearWheel(Ground)       $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr  130 * $stageScale]    0 \
                    $dimColor ]
                    
    set _dim_FW_Lag  \
            [createDimension    A00000  length    \
                    [list $FrontWheel(Ground)      $Steerer(Ground) ] \
                    horizontal  \
                    [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                    gray20 ]

    set _dim_BT_Clearance  \
            [createDimension    A00000  length    \
                    [list $Position(help_91)       $Position(help_92) ] \
                    aligned \
                    0   [expr -150 * $stageScale]  \
                    $dimColor ]

    set _dim_ST_Length  \
            [createDimension    A00000  length    \
                    [list $Position(help_93)       $Saddle(Position) ] \
                    aligned \
                    [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                    $dimColor ]

    set _dim_HB_XPosition  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    horizontal  \
                    [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                    $dimColor ]
                    
    set _dim_HB_YPosition  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    vertical    \
                    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SD_XPositionv  \
            [createDimension    A00000  length    \
                    [list $Saddle(Position)        $BottomBracket(Position)  ] \
                    horizontal  \
                    [expr -150 * $stageScale]    0 \
                    $dimColor ]
                    
    set _dim_SD_YPosition  \
            [createDimension    A00000  length    \
                    [list $CrankSet(Position)      $Saddle(Position) ] \
                    vertical    \
                    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                    $dimColor ]           
                                    
    # set _dim_FW_Distance  \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position)  $FrontWheel(Position)] \
                    aligned \
                    [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                    $dimColor ]
                                    
    set _dim_HT_Angle  \
            [createDimension    A00000  angle \
                    [list $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                    150   0  \
                    $dimColor ]
                    
    set _dim_ST_Angle  \
            [createDimension    A00000  angle \
                    [list $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                    150   0  \
                    $dimColor ]    
                                    
    set _dim_BB_Depth  \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $RearWheel(Position) ] \
                    vertical    \
                    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                    $dimColor ]
                                    

    set _dim_FW_LengthX  \
            [createDimension    A00000  length    \
                    [list $Position(BaseCenter)    $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr    70 * $stageScale]   0 \
                    $dimColor ]    
          
    set _dim_SN_HandleBar_horizontal  \
            [createDimension    A00000  length    \
                    [list $SaddleNose(Position)    $HandleBar(Position)] \
                    horizontal  \
                    [expr  -80 * $stageScale]    0 \
                    $dimColor ]
    
    set _dim_SN_HandleBar  \
            [createDimension     A00000  length \
                    [list $SaddleNose(Position)     $HandleBar(Position) ] \
                    aligned     \
                    [expr -150 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SP_Offset  \
            [createDimension     A00000  length \
                    [list $SeatTube(Ground) $SeatPost(SeatTube) $Saddle(Mount)] \
                    perpendicular     \
                    [expr  -40 * $stageScale]   [expr  30 * $stageScale]  \
                    $dimColor]      
                
    if {$Fork(Rake) != 0} {
        set coordList   [list  $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
    } else {
        set coordList   [list  $FrontWheel(Position) $Steerer(Fork)  ]
    }
        #
    # set _dim_ForkHeight \
            [createDimension    A00000  length    \
                    $coordList \
                    perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                    $dimColor ]                 
        #
    return
        #
    # set _dim_SD_HB_Height  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)   $Saddle(Position) ] \
                    vertical    \
                    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]
        #
    return
        #
} 
    #
proc myGUI::dimension::createDimension_Geometry_lugs_personal           {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Rendering
    variable    Reference
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HandleBar
    variable    LegClearance
    variable    Saddle
    variable    SaddleNose
    variable    SeatTube
        #
    variable    Position
    variable    Length
        #
        #
    set dimColor      $myGUI::cvCustom::DraftingColor(personal)  
    set dimColor_2    $myGUI::cvCustom::DraftingColor(personal_2)  
        #
        # ---
        #
    set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
        #
        # --- personal - dimensions
        #
        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    horizontal  [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                    $dimColor ]    \
            single_Personal_HandleBarDistance
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    vertical    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                    $dimColor ]    \
            single_Personal_HandleBarHeight
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $CrankSet(Position)      $SeatTube(Saddle) ] \
                    aligned        [expr  -80 * $stageScale]    [expr -170 * $stageScale]  \
                    $dimColor ]    \
            single_Result_Saddle_SeatTube_BB
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $LegClearance(Position)  $CrankSet(Position) ] \
                    horizontal  [expr  $distY_SN_LC * $stageScale]   0  \
                    $dimColor_2 ]  \
            single_TopTube_PivotPosition
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $LegClearance(Position)  $Position(BaseCenter) ] \
                    vertical    [expr  -50 * $stageScale]   [expr   160 * $stageScale]  \
                    $dimColor_2 ]  \
            single_Personal_InnerLegLength
                                        
        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_lugs_primary            {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    Rendering
    variable    Reference
        #
    variable    BottomBracket
    variable    CrankSet
    variable    DownTube
    variable    ChainStay
    variable    Fork
    variable    FrontWheel
    variable    HandleBar
    variable    RearWheel
    variable    SeatTube
    variable    Steerer
    variable    Stem
    variable    TopTube
        #
    variable    Position
        #
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(primary)  
        #
        # ---
        #
    set help_01     [ vectormath::rotatePoint $Steerer(Stem) $Steerer(Fork)  90 ]
    set help_02     [ vectormath::addVector   $Steerer(Stem) [ vectormath::unifyVector $Steerer(Stem) $help_01 [expr  50 * $stageScale] ] ]
    set help_fk     [ vectormath::addVector   $Steerer(Fork) [ vectormath::unifyVector $Steerer(Stem)  $Steerer(Fork)   $Fork(Height) ] ]
        #
    set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
        #
        # ---
        #
        
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [list [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                    250   0 \
                    $dimColor ]    \
            single_LugDetermination_HeadLug
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [list [list $pt_base  $DownTube(Steerer) $TopTube(SeatTube) ] ] \
                    250   0 \
                    $dimColor ]    \
            single_LugDetermination_DownTube
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [list [list $pt_base $TopTube(SeatTube) $Position(IS_ChainSt_SeatSt)] ] \
                    250   0 \
                    $dimColor ]    \
            single_LugDetermination_ChainStay
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000    length      \
                        [list $BottomBracket(Position)  $CrankSet(Position) ] \
                        vertical    \
                        [expr   100 * $stageScale]   [expr  90 * $stageScale]  \
                        $dimColor ]     \
            single_BottomBracket_Excenter
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $RearWheel(Position)      $BottomBracket(Position)] \
                    aligned \
                    [expr   100 * $stageScale]   0 \
                    $dimColor ]    \
            single_RearWheel_Distance
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $RearWheel(Position)      $RearWheel(Ground) ] \
                    vertical    \
                    [expr   130 * $stageScale]    0 \
                    $dimColor ]    \
            group_RearWheel_Parameter
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $FrontWheel(Position)     $FrontWheel(Ground) ] \
                    vertical    \
                    [expr  -150 * $stageScale]    0 \
                    $dimColor ] \
            group_FrontWheel_Parameter_01
                #      
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)      $Steerer(Stem) ] \
                    aligned     \
                    [expr    80 * $stageScale]    0 \
                    $dimColor ]    \
            single_Stem_Length
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Stem)  $help_fk $FrontWheel(Position) ] \
                    perpendicular   \
                    [expr  100 * $stageScale]    [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_Fork_Rake
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $RearWheel(Position) $ChainStay(Dropout)] \
                    perpendicular   \
                    [expr   80 * $stageScale]    [expr   60 * $stageScale] \
                    $dimColor ]    \
            group_RearDropout_Parameter_10
                #
                #  
    if {$Stem(Angle) > 0} {
        set coordList [list $Steerer(Stem)  $help_02 $HandleBar(Position) ]
    } else {
        set coordList [list $Steerer(Stem)  $HandleBar(Position)  $help_02 ]
    }
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    $coordList \
                    [expr $Stem(Length) +  80]   0  \
                    $dimColor ] \
            single_Stem_Angle
                #
                #
    if {$Fork(Rake) != 0} {
        set coordList   [list  $help_fk $FrontWheel(Position) $Steerer(Fork)  ]
    } else {
        set coordList   [list  $FrontWheel(Position) $Steerer(Fork)  ]
    }
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    $coordList \
                    perpendicular [expr  (100 - $Fork(Rake)) * $stageScale]    [expr  -10 * $stageScale] \
                    $dimColor ]    \
            single_Fork_Height
                #
                #
    if {$SeatTube(OffsetBB) > 0} {
        set dim_distance    [expr  90 * $stageScale]
        set dim_offset      [expr  50 * $stageScale]
    } else {
        set dim_distance    [expr -90 * $stageScale]
        set dim_offset      [expr -50 * $stageScale]
    }
    # set _dim_ST_Offset          [createDimension    A00000  length \
                                        [list$SeatPost(SeatTube) $SeatTube(BBracket) $BB_Position] \
                                        perpendicular    $dim_distance $dim_offset \
                                        $dimColour ]

        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_lugs_secondary          {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    HeadTube
    variable    LegClearance
    variable    Saddle
    variable    SaddleNose                
    variable    SeatPost
    variable    SeatTube
    variable    Stem                
    variable    Steerer                
        #
    variable    Position
    variable    Length
        #
    set dimColor     $myGUI::cvCustom::DraftingColor(secondary)  
        #            
        #
        # --- 
        #
    set distY_SN_LC [ expr 0.5 *([lindex $SaddleNose(Position) 1] - [lindex $LegClearance(Position) 1])]
    set help_03     [ vectormath::addVector   $SeatPost(PivotPosition) {-10 0} ]
        #
        # ---
        #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SaddleNose(Position)    $BottomBracket(Position) ] \
                    horizontal  \
                    [expr  $distY_SN_LC * $stageScale]   0  \
                    $dimColor ]    \
            group_Saddle_Parameter_01
                #
    # myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Steerer(Fork)  $HeadTube(Stem) ] \
                    aligned \
                    [expr   100 * $stageScale]   0 \
                    $dimColor ]    \
            group_HeadTube_Parameter_01
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  radius    \
                    [list $CrankSet(Position)      $Position(help_91)] \
                    -20            [expr  130 * $stageScale] \
                    $dimColor ]    \
            single_CrankSet_Length
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SeatPost(Saddle) $Saddle(Position)  ] \
                    aligned \
                    [expr  (-500 - $Length(Length_BB_Seat)) * $stageScale ]    [expr  -80 * $stageScale] \
                    $dimColor ]    \
            single_SaddleHeightComponent
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list  $help_03 $SeatPost(PivotPosition) $SeatPost(Saddle)  ] \
                    perpendicular   \
                    [expr  (-420 - $Length(Length_BB_Seat)) * $stageScale ]    [expr   0 * $stageScale]  \
                    $dimColor ]    \
            single_SeatPost_PivotOffset
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SeatTube(BBracket) $SeatPost(SeatTube) $SeatPost(PivotPosition) ] \
                    perpendicular   \
                    [expr  -80 * $stageScale]  [expr -35 * $stageScale]  \
                    $dimColor ]    \
            single_SeatPost_Setback
                                      
        #
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_lugs_result             {BB_Position {active inactive}} {
        #
    variable    cvObject
        #
    variable    stageScale
        #
    variable    DownTube
    variable    HandleBar
    variable    Saddle
    variable    SaddleNose
    variable    SeatTube
        #
    variable    Position
    variable    Length
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(result)  
        #            
    set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
        #
        # ---
        #
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $Saddle(Position)      $HandleBar(Position) ] \
                    horizontal  \
                    [expr  -210 * $stageScale]    0 \
                    $dimColor ]    \
            single_Result_Saddle_Offset_HB_X
                #                
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $Saddle(Position) ] \
                    vertical    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]    \
            single_Result_Saddle_Offset_HB_Y
                #
    myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  length    \
                    [list $SaddleNose(Position)    $HandleBar(Position)] \
                    horizontal      [expr  -80 * $stageScale]    0 \
                    $dimColor ]    \
            single_Result_SaddleNose_HB            
                #
    #myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [ appUtil::flatten_nestedList [list $pt_base $DownTube(Steerer) $Position(IS_ChainSt_SeatSt)] ] \
                    310   [expr 100 * $stageScale] \
                    $dimColour ]    \
            single_LugDetermination_ChainStay
                #
    #myGUI::gui::bind_dimensionEvent_2   $cvObject      \
            [createDimension    A00000  angle \
                    [ appUtil::flatten_nestedList [list $DownTube(Steerer) $DownTube(BBracket) $Steerer(Ground)] ] \
                    250   0 \
                    $dimColour ]    \
            single_LugDetermination_HeadLug
                #
        #      
    return
        #
}
proc myGUI::dimension::createDimension_Geometry_lugs_summary            {BB_Position} {
        # geometry_bg
        #
    variable    stageScale
        #
    variable    BottomBracket
    variable    CrankSet
    variable    DownTube
    variable    FrontWheel
    variable    HandleBar
    variable    HeadTube
    variable    LegClearance
    variable    RearWheel
    variable    Saddle
    variable    SaddleNose
    variable    SeatPost
    variable    SeatTube
    variable    Steerer
        #
    variable    Position
    variable    Length
        #
    set dimColor    $myGUI::cvCustom::DraftingColor(background)  
        #

        #
    set help_00     [ vectormath::addVector   $SeatTube(Ground) {-200 0} ]
    set help_01     [ list [lindex $BottomBracket(Position) 0] [lindex $LegClearance(Position) 1] ]
        #
    set pt_base     [ vectormath::intersectPoint  $DownTube(Steerer) $DownTube(BBracket) $SeatTube(BBracket) $SeatTube(TopTube) ]
        #
        # ---
        #
    set _dim_BB_Angle \
            [createDimension    A00000  angle \
                    [list [list $pt_base $DownTube(Steerer) $Position(IS_ChainSt_SeatSt)] ] \
                    310   [expr 100 * $stageScale] \
                    $dimColor ] 
            
    set _dim_SD_Height  \
            [createDimension    A00000  length    \
                    [list $Position(BaseCenter)    $Saddle(Position) ] \
                    vertical    \
                    [expr -660 * $stageScale]  [expr -190 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_HB_Height  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $Position(BaseCenter) ] \
                    vertical    \
                    [expr -380 * $stageScale]  [expr  230 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SD_HB_Length  \
            [createDimension    A00000  length    \
                    [list $Saddle(Position)        $HandleBar(Position) ] \
                    horizontal  \
                    [expr  -210 * $stageScale]    0 \
                    $dimColor ]

    set _dim_Wh_Distance  \
            [createDimension    A00000  length    \
                    [list $RearWheel(Ground)       $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr  130 * $stageScale]    0 \
                    $dimColor ]
                    
    set _dim_FW_Lag  \
            [createDimension    A00000  length    \
                    [list $FrontWheel(Ground)      $Steerer(Ground) ] \
                    horizontal  \
                    [expr   70 * $stageScale]   [expr  -70 * $stageScale] \
                    gray20 ]

    set _dim_BT_Clearance  \
            [createDimension    A00000  length    \
                    [list $Position(help_91)       $Position(help_92) ] \
                    aligned \
                    0   [expr -150 * $stageScale]  \
                    $dimColor ]

    set _dim_ST_Length  \
            [createDimension    A00000  length    \
                    [list $Position(help_93)       $Saddle(Position) ] \
                    aligned \
                    [expr -160 * $stageScale]    [expr -230 * $stageScale]  \
                    $dimColor ]

    set _dim_HB_XPosition  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    horizontal  \
                    [expr (150 + $Length(Height_HB_Seat)) * $stageScale ]    0 \
                    $dimColor ]
                    
    set _dim_HB_YPosition  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)     $CrankSet(Position) ] \
                    vertical    \
                    [expr -310 * $stageScale]    [expr  180 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SD_XPositionv  \
            [createDimension    A00000  length    \
                    [list $Saddle(Position)        $BottomBracket(Position)  ] \
                    horizontal  \
                    [expr -150 * $stageScale]    0 \
                    $dimColor ]
                    
    set _dim_SD_YPosition  \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $Saddle(Position) ] \
                    vertical    \
                    [expr -580 * $stageScale]  [expr -130 * $stageScale]  \
                    $dimColor ]           
                                    
    set _dim_FW_Distance  \
            [createDimension    A00000  length    \
                    [list $CrankSet(Position)      $FrontWheel(Position)] \
                    aligned \
                    [expr  100 * $stageScale]   [expr  -30 * $stageScale] \
                    $dimColor ]
                                    
    set _dim_HT_Angle  \
            [createDimension    A00000  angle \
                    [list $Steerer(Ground)         $Steerer(Fork)  $Position(BaseCenter) ] \
                    150   0  \
                    $dimColor ]
                    
    set _dim_ST_Angle  \
            [createDimension    A00000  angle \
                    [list $SeatTube(Ground)        $SeatPost(SeatTube) $help_00 ] \
                    150   0  \
                    $dimColor ]    
                                    
    set _dim_BB_Depth  \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $RearWheel(Position) ] \
                    vertical    \
                    [expr  -280 * $stageScale]   [expr -90 * $stageScale]  \
                    $dimColor ]
                                    
    set _dim_BB_Height  \
            [createDimension    A00000  length    \
                    [list $BottomBracket(Position) $Position(BaseCenter)] \
                    vertical    \
                    [expr   150 * $stageScale]   [expr   -20 * $stageScale]  \
                    $dimColor ]
          
    set _dim_CS_LengthX  \
            [createDimension    A00000  length    \
                    [list $RearWheel(Ground)       $Position(BaseCenter) ] \
                    horizontal  \
                    [expr    70 * $stageScale]   0 \
                    $dimColor ]    
    set _dim_FW_LengthX  \
            [createDimension    A00000  length    \
                    [list $Position(BaseCenter)    $FrontWheel(Ground) ] \
                    horizontal  \
                    [expr    70 * $stageScale]   0 \
                    $dimColor ]    
          
    set _dim_SN_HandleBar  \
            [createDimension     A00000  length \
                    [list $SaddleNose(Position)     $HandleBar(Position) ] \
                    aligned     \
                    [expr -150 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColor ]
                    
    set _dim_SP_Offset  \
            [createDimension     A00000  length \
                    [list $SeatTube(Ground) $SeatPost(SeatTube) $Saddle(Mount)] \
                    perpendicular     \
                    [expr  -40 * $stageScale]   [expr  30 * $stageScale]  \
                    $dimColor]
                    
    # set _dim_SN_HandleBar  \
            [createDimension    A00000  length    \
                    [list $SaddleNose(Position)    $HandleBar(Position)] \
                    horizontal  \
                    [expr  -80 * $stageScale]    0 \
                    $dimColour ]
    
    # set _dim_SD_HB_Height  \
            [createDimension    A00000  length    \
                    [list $HandleBar(Position)   $Saddle(Position) ] \
                    vertical    \
                    [expr  310 * $stageScale]   [expr -100 * $stageScale]  \
                    $dimColour ]
        #
    return
        #
}
    #
    #
proc myGUI::dimension::createDimension_Jig                              {BB_Position {active inactive} args} {

    variable    cvObject
    
    variable    stageScale

    variable    Rendering

    variable    BottomBracket
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

    variable    Position
    variable    Length
    variable    Angle
    variable    Vector
    
    
    switch -exact -- $::APPL_Config(FrameJigType) {
        nuremberg -
        vogeltanz {       
            set type     nuremberg 
        }
        vienna -
        selberbruzzler {  
            set type     selberbruzzler 
        }
        ilz -
        graz -
        rattleCAD {         
            set type     rattleCAD 
        }
        MeisterJIG {         
            set type     MeisterJIG 
        }
        geldersheim -
        default {         
            set type     geldersheim 
        }  
    }



        # --- create dimension -------------------
    switch $type {

            # -----------------------
        selberbruzzler -
        rattleCAD {
              # puts "   <D>    ... createJigDimension::bg_rattleCAD ($type)"
            
            set help_bb           [ list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1] ]
            set help_fk           [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)    $FrontWheel(Position) $RearWheel(Position) ]

              # -- CenterLine ------------------------
              #
            $cvObject create circle      $HeadTube(Fork)       -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrameJig(HeadTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrameJig(SeatTube)   -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $help_fk              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create centerline  [list $FrameJig(HeadTube) $RearWheel(Position)] \
                                                                    -fill darkred   -tags __CenterLine__
            $cvObject create centerline  [list $RearWheel(Position) $help_fk] \
                                                                    -fill darkred   -tags __CenterLine__
              
              # -- Dimensions ------------------------
              #
            set _dim_Jig_length     [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $FrameJig(HeadTube)] \
                                            aligned \
                                            [expr  -170 * $stageScale]   0 \
                                            darkblue ]

            set _dim_CS_Length      [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $BottomBracket(Position)] \
                                            aligned     [expr    80 * $stageScale]   0 \
                                            gray30 ]
            set _dim_CS_LengthHor   [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $RearWheel(Position)  ] \
                                            horizontal  [expr  -100 * $stageScale]   0 \
                                            gray30 ]
            set _dim_BB_Depth       [createDimension    A00000  length \
                                            [list  $RearWheel(Position)  $BottomBracket(Position) ] \
                                            vertical    [expr    80 * $stageScale]   [expr  70 * $stageScale]  \
                                            gray30 ]
            set _dim_HT_Dist_x      [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $HeadTube(Fork)] \
                                            horizontal  [expr   100 * $stageScale]   0 \
                                            gray30 ]
            set _dim_HT_Dist_y      [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $HeadTube(Fork)] \
                                            vertical    [expr   300 * $stageScale]   0 \
                                            gray30 ]
            set _dim_WH_Distance    [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $help_fk] \
                                            aligned     [expr   210 * $stageScale]   0 \
                                            gray30 ]
            
            set _dim_HT_Offset      [createDimension    A00000  length \
                                            [list  $FrameJig(HeadTube)         $HeadTube(Fork)] \
                                            aligned     [expr   100 * $stageScale]   [expr  -100 * $stageScale] \
                                            darkred ]
            set _dim_CS_LengthJig   [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $FrameJig(SeatTube)] \
                                            aligned     [expr  -120 * $stageScale]   0 \
                                            darkred ]
            set _dim_MN_LengthJig   [createDimension    A00000  length \
                                            [list  $FrameJig(SeatTube)     $FrameJig(HeadTube)] \
                                            aligned     [expr  -120 * $stageScale]   0 \
                                            darkred ]
            set _dim_BB_DepthJIg    [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $FrameJig(SeatTube)] \
                                            aligned     [expr    60 * $stageScale]   0 \
                                            darkred ]
            set _dim_ST_Angle       [createDimension    A00000  angle \
                                            [list $FrameJig(SeatTube)   $RearWheel(Position)   $BottomBracket(Position) ] \
                                            90   0  \
                                            darkred ]
            set _dim_HT_Angle       [createDimension    A00000  angle \
                                            [list $FrameJig(HeadTube)   $Steerer(Stem)   $RearWheel(Position) ] \
                                            90  10  \
                                            darkred ]
                # -- Fork Details ----------------------
                #
            set _dim_HT_Fork        [createDimension    A00000  length \
                                            [list $FrameJig(HeadTube)    $help_fk] \
                                            aligned     [expr  -100 * $stageScale]   0 \
                                            darkblue ]
            set _dim_Fork_Height    [createDimension    A00000  length \
                                            [list           $help_fk $HeadTube(Fork)  ] \
                                            aligned        [expr   150 * $stageScale]   0 \
                                            gray30 ]
            return
        }
            # -----------------------
        geldersheim {
              # puts "   <D>    ... createJigDimension::bg_rattleCAD ($type)"
            
            set help_bb             [ vectormath::intersectPerp      $FrameJig(HeadTube)    $FrameJig(SeatTube)  $RearWheel(Position) ]
            set help_fk             [ vectormath::intersectPerp      $Steerer(Stem)  $Steerer(Fork)  $BottomBracket(Position) ]
               
              # -- CenterLine ------------------------
              #
            $cvObject create circle      $HeadTube(Fork)       -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $help_fk              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create circle      $help_bb              -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrontWheel(Position) -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create centerline  [list $help_bb $help_fk] \
                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
            $cvObject create centerline  [list $help_bb $RearWheel(Position)] \
                                                                    -fill gray60   -width 0.25     -tags __CenterLine__

              # -- Dimensions ------------------------
              #
            set _dim_Jig_length     [createDimension    A00000  length \
                                            [list  $help_bb    $help_fk] \
                                            aligned     [expr  150 * $stageScale]   0 \
                                            darkblue ]
            set _dim_CS_LengthJig   [createDimension    A00000  length \
                                            [list  $help_bb    $BottomBracket(Position)] \
                                            aligned     [expr  100 * $stageScale]   0 \
                                            darkred ]
            set _dim_MN_LengthJig   [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)     $FrameJig(HeadTube)] \
                                            aligned     [expr  100 * $stageScale]   0 \
                                            darkred ]

            set _dim_CS_Length      [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $BottomBracket(Position)] \
                                            aligned     [expr -100 * $stageScale]   0 \
                                            gray30 ]
            set _dim_BB_Depth       [createDimension    A00000  length \
                                            [list  $RearWheel(Position)  $BottomBracket(Position) ] \
                                            vertical    [expr   80 * $stageScale]   [expr  70 * $stageScale]  \
                                            gray30 ]
            set _dim_HT_Dist        [createDimension    A00000  length \
                                            [list  $HeadTube(Fork)     $BottomBracket(Position)] \
                                            aligned     [expr  100 * $stageScale]   0 \
                                            gray30 ]
            set _dim_HT_Offset      [createDimension    A00000  length \
                                            [list  $FrameJig(HeadTube)         $HeadTube(Fork)] \
                                            aligned     [expr   100 * $stageScale]   [expr   10 * $stageScale] \
                                            darkred ]
            set _dim_BB_DepthJIg    [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $help_bb] \
                                            aligned     [expr   120 * $stageScale]   0 \
                                            darkred ]
            set _dim_ST_Angle       [createDimension    A00000  angle \
                                            [list $BottomBracket(Position)   $SeatTube(TopTube)    $help_bb ] \
                                            90   0  \
                                            darkred ]
            set _dim_ST_Angle_2     [createDimension    A00000  angle \
                                            [list $BottomBracket(Position)   $RearWheel(Position)  $help_bb ] \
                                            150  40  \
                                            darkred ]
            set _dim_HT_Angle       [createDimension    A00000  angle \
                                            [list $FrameJig(HeadTube)   $Steerer(Stem)   $BottomBracket(Position) ] \
                                            90  10  \
                                            darkred ]
              #
            return
              #
        }
            # -----------------------
        nuremberg {
              # puts "   <D>    ... createJigDimension::bg_vogeltanz ($type)"

            set help_bb             [list [lindex $RearWheel(Position) 0] [lindex $BottomBracket(Position) 1]]
            set help_fk             [vectormath::intersectPoint     $Steerer(Fork) $Steerer(Stem)    $help_bb $BottomBracket(Position)]
            set help_01             [vectormath::intersectPerp      $Steerer(Fork) $Steerer(Stem)    $FrontWheel(Position)]
                
              # -- CenterLine ------------------------
              #
            $cvObject create circle      $HeadTube(Fork)         -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $help_fk                -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create circle      $help_bb                -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrontWheel(Position)   -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create centerline  [list $help_bb $help_fk] \
                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
            $cvObject create centerline  [list $BottomBracket(Position) $RearWheel(Position)] \
                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
            $cvObject create centerline  [list $help_01 $help_fk] \
                                                                    -fill gray60    -width 0.25     -tags __CenterLine__
        
              # -- Dimensions ------------------------
              #
            set _dim_ST_Angle       [createDimension    A00000  angle \
                                            [list $BottomBracket(Position) $SeatPost(SeatTube) $help_bb ] \
                                            90   0  \
                                            darkred ]
            set _dim_ST_Angle2      [createDimension    A00000  angle \
                                            [list $BottomBracket(Position) $SeatPost(SeatTube) $RearWheel(Position) ] \
                                            150   0  \
                                            darkred ]
            set _dim_ST_Angle3      [createDimension    A00000  angle \
                                            [list $BottomBracket(Position) $RearWheel(Position) $help_bb ] \
                                            210  15  \
                                            darkred ]
            set _dim_HT_Angle       [createDimension    A00000  angle \
                                            [list $help_fk   $Steerer(Stem)   $BottomBracket(Position) ] \
                                            90   0  \
                                            darkred ]
            
            set _dim_CS_Length      [createDimension    A00000  length \
                                            [list  $RearWheel(Position)    $BottomBracket(Position)] \
                                            aligned     [expr    80 * $stageScale]   0 \
                                            darkred ]
            set _dim_FK_Distance    [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $help_fk] \
                                            aligned     [expr    80 * $stageScale]   0 \
                                            darkred ]
            set _dim_HT_Offset      [createDimension    A00000  length \
                                            [list  $help_fk         $HeadTube(Fork)] \
                                            aligned     [expr   140 * $stageScale]  [expr -50 * $stageScale] \
                                            darkred ]
            set _dim_WH_Distance    [createDimension    A00000  length \
                                            [list  $help_bb  $help_fk ] \
                                            aligned     [expr   130 * $stageScale]   0 \
                                            gray30 ]
            set _dim_BB_Depth       [createDimension    A00000  length \
                                            [list  $RearWheel(Position)  $help_bb ] \
                                            vertical    [expr    80 * $stageScale]  [expr  70 * $stageScale]  \
                                            gray30 ]
            set _dim_FK_Length     [createDimension    A00000  length \
                                            [list $help_01   $FrontWheel(Position)   $HeadTube(Fork) ] \
                                            perpendicular [expr  40 * $stageScale]  [expr  20 * $stageScale]  \
                                            gray30 ]
              #
            return
              #                            
        }
            # -----------------------
        MeisterJIG {
              # puts "   <D>    ... createJigDimension::bg_MeisterJIG ($type)"
            set help_fk             [ vectormath::intersectPoint    $Steerer(Fork)  $Steerer(Stem)    $FrontWheel(Position) $RearWheel(Position) ]
            set help_01             [ vectormath::intersectPerp      $Steerer(Fork) $Steerer(Stem)    $FrontWheel(Position) ]
            
              # -- CenterLine ------------------------
              #
            $cvObject create circle      $HeadTube(Fork)         -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrameJig(BB_RearWheel) -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrameJig(BB_HeadTube)  -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrameJig(RW_SeatStay)  -radius  7  -outline darkred   -width 0.35     -tags __CenterLine__
            $cvObject create circle      $help_fk                -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
            $cvObject create circle      $FrontWheel(Position)   -radius  4  -outline gray50    -width 0.35     -tags __CenterLine__
              #
            $cvObject create centerline  [list $FrameJig(BB_HeadTube)    $HeadTube(Fork)] \
                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
            $cvObject create centerline  [list $RearWheel(Position)      $FrameJig(BB_RearWheel)] \
                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
            $cvObject create centerline  [list $BottomBracket(Position)  $FrameJig(BB_HeadTube)] \
                                                                    -fill darkred   -width 0.25     -tags __CenterLine__
            
              # -- Dimensions ------------------------
              #
            set _dim_CS_LengthHor   [createDimension    A00000  length \
                                            [list  $RearWheel(Position)        $BottomBracket(Position)] \
                                            horizontal  [expr   -80 * $stageScale]   [expr  70 * $stageScale] \
                                            darkred ]
            set _dim_BB_Depth       [createDimension    A00000  length \
                                            [list  $FrameJig(BB_RearWheel)     $BottomBracket(Position) ] \
                                            vertical    [expr   120 * $stageScale]   [expr  70 * $stageScale]  \
                                            darkred ]
            set _dim_HT_Dist_x      [createDimension    A00000  length \
                                            [list  $FrameJig(BB_HeadTube)      $HeadTube(Fork)] \
                                            horizontal  [expr  -200 * $stageScale]   0 \
                                            darkred ]
            set _dim_HT_Dist_y      [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $HeadTube(Fork) ] \
                                            vertical    [expr   140 * $stageScale]   [expr -70 * $stageScale] \
                                            darkred ]
            # set _dim_HT_Dist_y   [createDimension    A00000  length \
                                            [list  $FrameJig(BB_RearWheel)     $HeadTube(Fork) ] \
                                            vertical    [expr   130 * $stageScale]   0 \
                                            darkred ]
            set _dim_HT_Dist_x      [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $help_fk] \
                                            horizontal  [expr    80 * $stageScale]   0 \
                                            gray30 ]
            set _dim_FW_Dist_x      [createDimension    A00000  length \
                                            [list  $BottomBracket(Position)    $FrontWheel(Position)] \
                                            horizontal  [expr   140 * $stageScale]   0 \
                                            gray30 ]
            set _dim_ForkRake       [createDimension    A00000  length \
                                            [list $HeadTube(Fork)   $help_01   $FrontWheel(Position)] \
                                            perpendicular [expr  80 * $stageScale]  [expr -55 * $stageScale]  \
                                            gray30 ]
            set _dim_HT_Fork        [createDimension    A00000  length \
                                            [list $HeadTube(Fork)              $help_fk] \
                                            aligned     [expr  -100 * $stageScale]   0 \
                                            gray30 ]
            set _dim_FK_Length      [createDimension    A00000  length \
                                            [list $help_01   $FrontWheel(Position)   $HeadTube(Fork) ] \
                                            perpendicular [expr 120 * $stageScale]  [expr  20 * $stageScale]  \
                                            gray30 ]
            
            set _dim_ST_Angle       [createDimension    A00000  angle \
                                            [list $FrameJig(RW_SeatStay)  $SeatPost(SeatTube)  $RearWheel(Position) ] \
                                            180   0  \
                                            darkred ]
            set _dim_HT_Angle       [createDimension    A00000  angle \
                                            [list $HeadTube(Fork)   $Steerer(Stem)   $FrameJig(BB_HeadTube) ] \
                                            180 -10  \
                                            darkred ]
              #
            return
              #                            
        }
            # -----------------------
        default {
                }
    }
}
    
 