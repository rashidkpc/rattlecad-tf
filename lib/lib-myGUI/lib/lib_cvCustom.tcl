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

namespace eval myGUI::cvCustom {

    variable    bottomCanvasBorder  30
    variable    stageScale          1.0
    variable    stageRefit          yes

    variable    baseLine        ;  array set baseLine       {}

    variable    Rendering       ;  array set Rendering      {}
    variable    Reference       ;  array set Reference      {}
    
    variable    BottomBracket   ;  array set BottomBracket  {}
    variable    CrankSet        ;  array set CrankSet       {}
    variable    DownTube        ;  array set DownTube       {}
    variable    Fork            ;  array set Fork           {}
    variable    FrameJig        ;  array set FrameJig       {}
    variable    FrontBrake      ;  array set FrontBrake     {}
    variable    FrontWheel      ;  array set FrontWheel     {}
    variable    HandleBar       ;  array set HandleBar      {}
    variable    HeadTube        ;  array set HeadTube       {}
    variable    LegClearance    ;  array set LegClearance   {}
    variable    RearBrake       ;  array set RearBrake      {}
    variable    RearDrop        ;  array set RearDrop       {}
    variable    RearWheel       ;  array set RearWheel      {}
    variable    Saddle          ;  array set Saddle         {}
    variable    SaddleNose      ;  array set SaddleNose     {}
    variable    SeatPost        ;  array set SeatPost       {}
    variable    SeatStay        ;  array set SeatStay       {}
    variable    SeatTube        ;  array set SeatTube       {}
    variable    Steerer         ;  array set Steerer        {}
    variable    Stem            ;  array set Stem           {}
    variable    TopTube         ;  array set TopTube        {}

    variable    Position        ;  array set Position       {}
    variable    Length          ;  array set Length         {}
    variable    Vector          ;  array set Vector         {}
    
    variable    DraftingColor   ;  array set DraftingColor {
                                        personal   darkorange
                                        personal_2 goldenrod
                                        primary    darkred
                                        secondary  darkmagenta
                                        result     darkblue
                                        background gray50
                                    }
}

proc myGUI::cvCustom::unsetPosition {} { 
      # removes all position settings of any canvas 
    variable  Position
    array unset Position
}

proc myGUI::cvCustom::getFormatFactor {stageFormat} {
    puts ""
    puts "         -------------------------------"
    puts "          myGUI::gui::getFormatFactor"
    puts "             stageFormat:     $stageFormat"
    switch -regexp $stageFormat {
        ^A[0-9] {    set factorInt    [expr 1.0 * [string index $stageFormat end] ]
                    return            [expr pow(sqrt(2), $factorInt)]
                }
        default    {return 1.0}
    }
}

proc myGUI::cvCustom::updateCanvasParameter {cvObject BB_Position} {

    variable    stageScale

    variable    Config
    variable    Rendering
    variable    Reference

    
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
    
    variable    Position
    variable    Length
    variable    Angle
    variable    Vector

    variable    DraftingColor

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
    
        # --- get stageScale
    if {$cvObject ne {}} {
        set Stage(scale_curr)   [$cvObject  configure   Stage  Scale]
    } else {
        set stageScale          0.123456
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
    set Saddle(Position)            [myGUI::model::model_XZ::getPosition    Saddle                          $BB_Position]
    set Saddle(Proposal)            [myGUI::model::model_XZ::getPosition    SaddleProposal                  $BB_Position]
    set SaddleNose(Position)        [myGUI::model::model_XZ::getPosition    SaddleNose                      $BB_Position]
    set SeatPost(PivotPosition)     [myGUI::model::model_XZ::getPosition    SeatPost_Pivot                  $BB_Position]
    set SeatPost(Saddle)            [myGUI::model::model_XZ::getPosition    Saddle_Mount                    $BB_Position]
    set SeatPost(SeatTube)          [myGUI::model::model_XZ::getPosition    SeatPost_SeatTube               $BB_Position]
    set SeatStay(End)               [myGUI::model::model_XZ::getPosition    SeatStay_End                    $BB_Position]
    set SeatStay(SeatTube)          [myGUI::model::model_XZ::getPosition    SeatStay_End                    $BB_Position]
    set SeatTube(BBracket)          [myGUI::model::model_XZ::getPosition    SeatTube_End                    $BB_Position]
    set SeatTube(Ground)            [myGUI::model::model_XZ::getPosition    SeatTube_Ground                 $BB_Position]
    set SeatTube(Saddle)            [myGUI::model::model_XZ::getPosition    SeatTube_Saddle                 $BB_Position]
    set SeatTube(TopTube)           [myGUI::model::model_XZ::getPosition    SeatTube_Start                  $BB_Position]
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
    set Config(RearFender)          [myGUI::model::model_XZ::getConfig      RearFender                  ]
    

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

    set HeadSet(vct_Bottom)         [myGUI::model::model_XZ::getVector      HeadSet_Bottom          $BB_Position]
    set HeadSet(vct_Top)            [myGUI::model::model_XZ::getVector      HeadSet_Top             $BB_Position]
    set HeadTube(vct_Bottom)        [myGUI::model::model_XZ::getVector      HeadTube_Bottom         $BB_Position]
    set HeadTube(vct_Top)           [myGUI::model::model_XZ::getVector      HeadTube_Top            $BB_Position]
    set SeatTube(vct_Top)           [myGUI::model::model_XZ::getVector      SeatTube_Top            $BB_Position]
    set Steerer(vct_Bottom)         [myGUI::model::model_XZ::getVector      Steerer_Bottom          $BB_Position] 
    
}

    #-------------------------------------------------------------------------
    #  return BottomBracket coords
    #
proc myGUI::cvCustom::getBottomBracketPosition {cvObject bottomCanvasBorder {updatePosition {recenter}} {option {bicycle}} {stageScale {}}} {

    variable  Position
    
    array set Stage          {}
    array set FrontWheel     {}
    array set RearWheel      {}
    array set BottomBracket  {}
    
      #
    set FrontWheel(Position)      [myGUI::model::model_XZ::getPosition  FrontWheel]
    set FrontWheel(RimDiameter)   [myGUI::model::model_XZ::getScalar    Geometry FrontRim_Diameter]
    set FrontWheel(TyreHeight)    [myGUI::model::model_XZ::getScalar    Geometry FrontTyre_Height]
    set FrontWheel(Radius)        [expr 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)] 
                
    set RearWheel(Position)       [myGUI::model::model_XZ::getPosition  RearWheel]
    set RearWheel(RimDiameter)    [myGUI::model::model_XZ::getScalar    Geometry RearRim_Diameter]
    set RearWheel(TyreHeight)     [myGUI::model::model_XZ::getScalar    Geometry RearTyre_Height]
    set RearWheel(Radius)         [expr 0.5 * $RearWheel(RimDiameter) + $RearWheel(TyreHeight)] 
    set RearWheel(Distance_x)     [myGUI::model::model_XZ::getScalar    Geometry RearWheel_x]
    
    set BottomBracketDepth        [myGUI::model::model_XZ::getScalar    Geometry BottomBracket_Depth]
    set BottomBracketHeight       [myGUI::model::model_XZ::getScalar    Geometry BottomBracket_Height]
    
    set FrameSize                 [myGUI::model::model_XZ::getBoundingBox  Summary]
    
        # -- Summary width to display inside the canvas-Format
    switch -exact -- $option {
        bicycle {
            set SummaryLength   [expr [lindex $FrameSize 0] + $RearWheel(Radius) + $FrontWheel(Radius)]
        }
        frame -
        default {
            set SummaryLength   [lindex $FrameSize 0]
        }
    }

        #
        # --- get cadCanvas-Stage information
    set stageWidth          [$cvObject  configure   Stage  Width]
    set stageScaleCurrent   [$cvObject  configure   Stage  Scale]
        #
        # --- reset cadCanvas - scale to fit the content
    if {$stageScale == {}} {
        set stageScale      [expr 0.75 * $stageWidth / $SummaryLength]
    }
    $cvObject   configure   Stage   Scale   $stageScale
        #

        #
        # ---  get unscaled width of Stage
        # set Stage(unscaled)     [expr ($stageWidth)/$stageScaleFormat]
    set stageWidthCanvas    [expr ($stageWidth)/$stageScale]
        # puts "        \$stageWidthCanvas       $stageWidthCanvas"

        #
        # ---  get border outside content to Stage
    set borderCanvasX       [expr 0.5 * ($stageWidthCanvas - $SummaryLength)]
        # puts "        \$borderCanvasX                $borderCanvasX "

        #
        # ---  get left/right/bottom border outside content to Stage
    set borderCanvasY       [expr $bottomCanvasBorder / $stageScale]
        # puts "        \$borderCanvasY              $borderCanvasY"

        #
        # ---  get baseLine Coordinates
    if {$option == {bicycle}} {
        set BtmBracket_x    [expr $borderCanvasX + $RearWheel(Distance_x) + $RearWheel(Radius)]
        set BtmBracket_y    [expr $borderCanvasY + $BottomBracketHeight]
    } else {
        set BtmBracket_x    [expr $borderCanvasX + $RearWheel(Distance_x)]
        set BtmBracket_y    $borderCanvasY
    }
        #
    # puts "       <I> ........ newPosition:  \$borderCanvasY $borderCanvasY"
        #
        #
    set newPosition         [list $BtmBracket_x $BtmBracket_y]
        #
        # puts "       <I> ........ newPosition:  $newPosition"
        #
        # puts "     ... \$FrontWheel(Position)     $FrontWheel(Position)"
        # puts "     ... \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
        # puts "     ... \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
        # puts "     ... \$FrontWheel(Radius)       $FrontWheel(Radius)"
        # puts ""
        # puts "     ... \$RearWheel(Position)      $RearWheel(Position)"
        # puts "     ... \$RearWheel(RimDiameter)   $RearWheel(RimDiameter)"
        # puts "     ... \$RearWheel(TyreHeight)    $RearWheel(TyreHeight)"
        # puts "     ... \$RearWheel(Radius)        $RearWheel(Radius)"
        # puts "     ... \$RearWheel(Distance_X)    $RearWheel(Distance_X)"
        # puts ""
        # puts "     ... \$BottomBracketDepth       $BottomBracketDepth"
        # puts "     ... \$FrameSize                $FrameSize"
        # puts ""
        # puts "     ... \$newPosition:  $newPosition"
        #
        # --- debug
        # puts "----------------------------------------"
        # puts "   getBottomBracketPosition:"
        # puts "        \$bottomCanvasBorder    $bottomCanvasBorder "
        # puts "        \$option                $option"
        # puts "        \$stageScale            $stageScale"
    
        # puts "  -> \$updatePosition $updatePosition"
    return $newPosition
        #
}

proc myGUI::cvCustom::getBottomBracketPosition_01 {cvObject bottomCanvasBorder {updatePosition {recenter}} {option {bicycle}} {stageScale {}}} {

    variable  Position
    
    array set Stage          {}
    array set FrontWheel     {}
    array set RearWheel      {}
    array set BottomBracket  {}
    
      #
    set FrontWheel(Position)      [myGUI::model::model_XZ::getPosition  FrontWheel]
    set FrontWheel(RimDiameter)   [myGUI::model::model_XZ::getScalar    Geometry FrontRim_Diameter]
    set FrontWheel(TyreHeight)    [myGUI::model::model_XZ::getScalar    Geometry FrontTyre_Height]
    set FrontWheel(Radius)        [expr 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)] 
                
    set RearWheel(Position)       [myGUI::model::model_XZ::getPosition  RearWheel]
    set RearWheel(RimDiameter)    [myGUI::model::model_XZ::getScalar    Geometry RearRim_Diameter]
    set RearWheel(TyreHeight)     [myGUI::model::model_XZ::getScalar    Geometry RearTyre_Height]
    set RearWheel(Radius)         [expr 0.5 * $RearWheel(RimDiameter) + $RearWheel(TyreHeight)] 
    set RearWheel(Distance_x)     [myGUI::model::model_XZ::getScalar    Geometry RearWheel_x]
    
    set BottomBracketDepth        [myGUI::model::model_XZ::getScalar    Geometry BottomBracket_Depth]
    set BottomBracketHeight       [myGUI::model::model_XZ::getScalar    Geometry BottomBracket_Height]
    
    set FrameSize                 [myGUI::model::model_XZ::getBoundingBox  Summary]
    
        # -- Summary width to display inside the canvas-Format
    switch -exact -- $option {
        bicycle {
            set SummaryLength   [expr [lindex $FrameSize 0] + $RearWheel(Radius) + $FrontWheel(Radius)]
        }
        frame -
        default {
            set SummaryLength   [lindex $FrameSize 0]
        }
    }

        # --- debug
        # puts "----------------------------------------"
        # puts "   getBottomBracketPosition_2:"
        # puts "        \$bottomCanvasBorder    $bottomCanvasBorder "
        # puts "        \$option                $option"
        # puts "        \$stageScale            $stageScale"
    
        # puts "  -> \$updatePosition $updatePosition"
    if 1 {
            #
            # --- get cadCanvas-Stage information
        set stageWidth          [$cvObject  configure   Stage  Width]
        set stageScaleCurrent   [$cvObject  configure   Stage  Scale]
            #
        if {$stageScale != {}} {
            set Stage(scale)    $stageScale
        } else {
            set stageScale    [expr 0.75 * $stageWidth / $SummaryLength]
        }
        set stageScaleFormat    [format "%.4f" $stageScale]
            # puts ""
            # puts "        \$SummaryLength         $SummaryLength"
            # puts "        \$stageScaleFormat      $stageScaleFormat"


            #
            # --- reset cadCanvas - scale to fit the content
        $cvObject   configure   Stage   Scale   $stageScaleFormat
            #

            #
            # ---  get unscaled width of Stage
            # set Stage(unscaled)     [expr ($stageWidth)/$stageScaleFormat]
        set Stage(unscaled)     [expr ($stageWidth)/$stageScale]
            # puts "        \$Stage(unscaled)       $Stage(unscaled)"

            #
            # ---  get border outside content to Stage
        set border              [expr  0.5 *($Stage(unscaled) - $SummaryLength)]
            # puts "        \$border                $border"

            #
            # ---  get left/right/bottom border outside content to Stage
        set cvBorder            [expr $bottomCanvasBorder/$stageScaleFormat]
            # puts "        \$cvBorder              $cvBorder"

            #
            # ---  get baseLine Coordinates
        if {$option == {bicycle}} {
            set BtmBracket_x    [expr $border + $RearWheel(Distance_x) + $RearWheel(Radius)]
            set BtmBracket_y    [expr $cvBorder + $BottomBracketHeight]
        } else {
            # puts "        \$option                $option"
            set BtmBracket_x    [expr $border + $RearWheel(Distance_x)]
            set BtmBracket_y    $cvBorder
                # puts "\n -> getBottomBracketPosition:  $cvBorder "
                # puts "\n -> getBottomBracketPosition:  $BtmBracket_x $BtmBracket_y \n"
        }

            # puts "       $BtmBracket_x $BtmBracket_y"
        set Position($cvObject)  [list $BtmBracket_x $BtmBracket_y $BottomBracketHeight]
            #
        set newPosition         [lrange $Position($cvObject) 0 1]
            # puts "       <I> ........ newPosition:  $newPosition"
    }
        #
        # puts "     ... \$FrontWheel(Position)     $FrontWheel(Position)"
        # puts "     ... \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
        # puts "     ... \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
        # puts "     ... \$FrontWheel(Radius)       $FrontWheel(Radius)"
        # puts ""
        # puts "     ... \$RearWheel(Position)      $RearWheel(Position)"
        # puts "     ... \$RearWheel(RimDiameter)   $RearWheel(RimDiameter)"
        # puts "     ... \$RearWheel(TyreHeight)    $RearWheel(TyreHeight)"
        # puts "     ... \$RearWheel(Radius)        $RearWheel(Radius)"
        # puts "     ... \$RearWheel(Distance_X)    $RearWheel(Distance_X)"
        # puts ""
        # puts "     ... \$BottomBracketDepth       $BottomBracketDepth"
        # puts "     ... \$FrameSize                $FrameSize"
        # puts ""
        # puts "     ... \$newPosition:  $newPosition"
        #
    return $newPosition
        #
}

proc myGUI::cvCustom::getBottomBracketPosition_00 {cvObject bottomCanvasBorder {updatePosition {recenter}} {option {bicycle}} {stageScale {}}} {

    variable  Position
    
    array set Stage          {}
    array set FrontWheel     {}
    array set RearWheel      {}
    array set BottomBracket  {}
    
      # puts "  -> \$FrontWheel(Position)  $FrontWheel(Position)"
      
      #
    set FrontWheel(Position)      [myGUI::model::model_XZ::getPosition  FrontWheel]
    set FrontWheel(RimDiameter)   [myGUI::model::model_XZ::getScalar    Geometry FrontRim_Diameter]
    set FrontWheel(TyreHeight)    [myGUI::model::model_XZ::getScalar    Geometry FrontTyre_Height]
    set FrontWheel(Radius)        [expr 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)] 
                
    set RearWheel(Position)       [myGUI::model::model_XZ::getPosition  RearWheel]
    set RearWheel(RimDiameter)    [myGUI::model::model_XZ::getScalar    Geometry RearRim_Diameter]
    set RearWheel(TyreHeight)     [myGUI::model::model_XZ::getScalar    Geometry RearTyre_Height]
    set RearWheel(Radius)         [expr 0.5 * $RearWheel(RimDiameter) + $RearWheel(TyreHeight)] 
    set RearWheel(Distance_x)     [myGUI::model::model_XZ::getScalar    Geometry RearWheel_x]
    
    set BottomBracketDepth        [myGUI::model::model_XZ::getScalar    Geometry BottomBracket_Depth]
    set BottomBracketHeight       [myGUI::model::model_XZ::getScalar    Geometry BottomBracket_Height]
    set FrameSize                 [myGUI::model::model_XZ::getBoundingBox  Summary]
    
        # -- Summary width to display inside the canvas-Format
    if {$option == {bicycle}} {
        set SummaryLength   [expr [lindex $FrameSize 0 ] + $RearWheel(Radius) + $FrontWheel(Radius)]
    } else {
        set SummaryLength   [lindex $FrameSize 0 ]
    }

    
      # puts "  -> \$updatePosition $updatePosition"
    if {![info exists Position($cvObject)]} {
            #
       set updatePosition {recenter}
            #
    } else {
            # puts "       <I> ... "
            # puts "       <I> ...    $bottomCanvasBorder"
        set stageScaleCurrent   [$cvObject  configure   Stage  Scale]   ;# Stage(scale_curr)
            #
        set lastPos_x           [lindex $Position($cvObject) 0]
        set lastPos_y           [lindex $Position($cvObject) 1]
        set lastPosition        [list   $lastPos_x $lastPos_y ]
        
        set lastHeight          [lindex $Position($cvObject) 2]
            # puts "       <I> .......... lastHeight: $lastHeight"
        set newHeight           [expr $RearWheel(Radius) - $BottomBracketDepth ]
            # puts "       <I> ........... newHeight:  $newHeight"
        set diffHeight          [expr $lastHeight - $newHeight] 
            # $cvObject    
            # puts "       <I> .......... diffHeight: $diffHeight"
                 
        set newPosition         [list $lastPos_x [expr $lastPos_y - $diffHeight] ]
            # puts "       <I> ........ newPosition:  $newPosition"
        return $newPosition
            #
    }

        
        # puts "     ... \$FrontWheel(Position)     $FrontWheel(Position)"
        # puts "     ... \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
        # puts "     ... \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
        # puts "     ... \$FrontWheel(Radius)       $FrontWheel(Radius)"
        # puts ""
        # puts "     ... \$RearWheel(Position)      $RearWheel(Position)"
        # puts "     ... \$RearWheel(RimDiameter)   $RearWheel(RimDiameter)"
        # puts "     ... \$RearWheel(TyreHeight)    $RearWheel(TyreHeight)"
        # puts "     ... \$RearWheel(Radius)        $RearWheel(Radius)"
        # puts "     ... \$RearWheel(Distance_X)    $RearWheel(Distance_X)"
        # puts ""
        # puts "     ... \$BottomBracketDepth       $BottomBracketDepth"
        # puts "     ... \$FrameSize                $FrameSize"

        #
        # --- debug
        # puts "----------------------------------------"
        # puts "   getBottomBracketPosition:"
        # puts "        \$bottomCanvasBorder    $bottomCanvasBorder "
        # puts "        \$option                $option"
        # puts "        \$stageScale            $stageScale"


        #
        # --- get cadCanvas-Stage information
    set Stage(width)        [$cvObject  configure   Stage  Width]
    set stageScaleCurrent   [$cvObject  configure   Stage  Scale]
        #
    if {$stageScale != {}} {
        set Stage(scale)    $stageScale
    } else {
        set Stage(scale)    [expr 0.75 * $Stage(width) / $SummaryLength]
    }
    set Stage(scale_fmt)    [format "%.4f" $Stage(scale)]
        # puts ""
        # puts "        \$SummaryLength         $SummaryLength"
        # puts "        \$Stage(scale_fmt)      $Stage(scale_fmt)"


        #
        # --- reset cadCanvas - scale to fit the content
    $cvObject   configure   Stage   Scale   $Stage(scale_fmt)
        #

        #
        # ---  get unscaled width of Stage
    set Stage(unscaled)     [expr ($Stage(width))/$Stage(scale_fmt)]
        # puts "        \$Stage(unscaled)       $Stage(unscaled)"

        #
        # ---  get border outside content to Stage
    set border              [expr  0.5 *($Stage(unscaled) - $SummaryLength)]
        # puts "        \$border                $border"

        #
        # ---  get left/right/bottom border outside content to Stage
    set cvBorder            [expr $bottomCanvasBorder/$Stage(scale_fmt)]
        # puts "        \$cvBorder              $cvBorder"

        #
        # ---  get baseLine Coordinates
    if {$option == {bicycle}} {
        set BtmBracket_x    [expr $border + $RearWheel(Distance_x) + $RearWheel(Radius)]
        set BtmBracket_y    [expr $cvBorder + $BottomBracketHeight]
    } else {
        # puts "        \$option                $option"
        set BtmBracket_x    [expr $border + $RearWheel(Distance_x)]
        set BtmBracket_y    $cvBorder
            # puts "\n -> getBottomBracketPosition:  $cvBorder "
            # puts "\n -> getBottomBracketPosition:  $BtmBracket_x $BtmBracket_y \n"
    }

        # puts "       $BtmBracket_x $BtmBracket_y"
    set Position($cvObject)  [list $BtmBracket_x $BtmBracket_y $BottomBracketHeight]
        #
    set newPosition         [lrange $Position($cvObject) 0 1]
        # puts "       <I> ........ newPosition:  $newPosition"
    return $newPosition
        #
}

proc myGUI::cvCustom::createAngleRep {cvObject position point_1 point_2 radius lugPath} {
        #
    set stagesScale [$cvObject  configure   Stage   Scale]
        # 
    set tagListName [format "checkAngle_%s" [llength [$cvObject find withtag all]] ]

        # puts "          stagesScale $stagesScale"

    set angle_p1    [vectormath::dirAngle $position $point_1 ]
    set angle_p2    [vectormath::dirAngle $position $point_2 ]
    set angle_ext   [expr $angle_p2 - $angle_p1]
        # puts "     angle_p1  -> $angle_p1"
        # puts "     angle_p2  -> $angle_p2"
        # puts "     angle_ext -> $angle_ext"
    if {$angle_ext < 0 } {set angle_ext [expr $angle_ext +360]}

        # Lugs/BottomBracket/ChainStay/Angle/plus_minus       value                           get_Scalar          {Lugs BottomBracket_ChainStay_Tolerance}
    puts "          -> $lugPath"
    switch -exact $lugPath {
            BottomBracket_ChainStay { 
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs BottomBracket_ChainStay_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs BottomBracket_ChainStay_Tolerance]
                    }                            
            BottomBracket_DownTube {
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs BottomBracket_DownTube_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs BottomBracket_DownTube_Tolerance]
                    }           
            RearDropOut  {
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs RearDropOut_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs RearDropOut_Tolerance]
                    }           
            SeatLug_TopTube {
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs SeatLug_TopTube_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs SeatLug_TopTube_Tolerance]
                    }            
            SeatLug_SeatStay {
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs SeatLug_SeatStay_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs SeatLug_SeatStay_Tolerance]
                    }            
            HeadLug_Top {
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs HeadLug_Top_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs HeadLug_Top_Tolerance]
                    }           
            HeadLug_Bottom {
                        set lugAngle        [myGUI::model::model_XZ::getScalar  Lugs HeadLug_Bottom_Angle] 
                        set lugTolerance    [myGUI::model::model_XZ::getScalar  Lugs HeadLug_Bottom_Tolerance]
                    }           
    }
        # return
    puts "            -> $lugAngle"    
    puts "            -> $lugTolerance"    
    
      # puts "   -> \$lugAngle      $lugAngle                  [string map {( /  ) /} $lugPath]"
      # puts "   -> \$lugTolerance  $lugTolerance"
    
    set color           [getColor   $angle_ext $lugAngle $lugTolerance]
    set item            [$cvObject create   arc  $position    -radius $radius  -start $angle_p1  -extent $angle_ext -tags {ArcRep_01}  -fill $color   -outline $color   -style pieslice]
    $cvObject   addtag  $tagListName withtag  $item

    set textPosition    [vectormath::addVector $position [vectormath::rotatePoint {0 0} [list [expr $radius + 10] 0] [expr $angle_p1 + 0.5*$angle_ext]]]
    set item            [$cvObject create text $textPosition -text [format "%.1f" $lugAngle] -anchor center -size [expr 5/$stagesScale]]
    $cvObject   addtag  $tagListName withtag  $item

    return $tagListName
}

proc myGUI::cvCustom::getColor {currentAngle lugAngle lugTolerance} {
        # puts "    --------"
        # puts "          currentAngle  $currentAngle"
        # puts "          lugAngle      $lugAngle"
        # puts "          lugTolerance  $lugTolerance"
    set difference [format "%.1f" [expr abs($currentAngle - $lugAngle)]]
        # puts "          difference    $difference"
        # puts "          lugTolerance  $lugTolerance"
        # puts "          lugTolerance  [expr 0.5*$lugTolerance]"

    if {$difference <= [expr 0.5*$lugTolerance] } {
            set configColor {lightgrey}
                # puts "          configColor  $configColor"
            return $configColor
    }
    if {$difference <= $lugTolerance } {
            set range [expr 0.5 * $lugTolerance ]
            set value [expr $difference -$range ]
            if {$range > 0 } {
                set quote [expr 100 * (1 - ($value / $range)) ]
            } else {
                set quote 100
            }

                # puts "      ----->  100 * (1 - ($value / $range)) = $quote"
            set quote [expr round($quote)]

                # puts "      ----->  100 * (1 - ($value / $range)) = $quote"
                # set yellow [format %x [expr 90 + $quote]]
                # puts "      ----->  $yellow"
            set configColor [format "#ff%x00" [expr 120 + $quote]]

                # puts "          configColor  $configColor"
            return $configColor
    }

    set configColor {darkred}
        # set configColor {orange}
        puts "          configColor  $configColor"
    return $configColor
}

proc myGUI::cvCustom::createLugRepresentation {cvObject BB_Position {type {all}}} {
        #
    puts ""
    puts "   -------------------------------"
    puts "     createLugRepresentation"
    puts "       BB_Position:     $BB_Position"
    puts "       checkAngles:     $myGUI::gui::checkAngles"

    if {$myGUI::gui::checkAngles != {on}} {
        puts "       ... currently switched off"
        return
    }

        # --- get defining Point coords ----------
    set BottomBracket(Position) $BB_Position
    set SeatStay(SeatTube)      [myGUI::model::model_XZ::getPosition  SeatStay_End          $BB_Position]
    set TopTube(SeatTube)       [myGUI::model::model_XZ::getPosition  TopTube_End           $BB_Position]
    set TopTube(Steerer)        [myGUI::model::model_XZ::getPosition  TopTube_Start         $BB_Position]
    set SeatTube(Saddle)        [myGUI::model::model_XZ::getPosition  SeatTube_Start        $BB_Position]
    set SeatTube(End)           [myGUI::model::model_XZ::getPosition  SeatTube_Ground       $BB_Position]
    set Steerer(Stem)           [myGUI::model::model_XZ::getPosition  Steerer_Stem          $BB_Position]
    set Steerer(Fork)           [myGUI::model::model_XZ::getPosition  Steerer_Start         $BB_Position]
    set DownTube(BBracket)      [myGUI::model::model_XZ::getPosition  DownTube_End          $BB_Position]
    set DownTube(Steerer)       [myGUI::model::model_XZ::getPosition  DownTube_Start        $BB_Position]
    set ChainSt_SeatSt_IS       [myGUI::model::model_XZ::getPosition  IS_ChainSt_SeatSt     $BB_Position]
        #
    set represent_DO            [myGUI::cvCustom::createAngleRep $cvObject $ChainSt_SeatSt_IS         $BottomBracket(Position)    $SeatStay(SeatTube)         70  RearDropOut             ]
    set represent_BB_01         [myGUI::cvCustom::createAngleRep $cvObject $BottomBracket(Position)   $DownTube(Steerer)          $SeatTube(Saddle)           90  BottomBracket_DownTube  ]
    set represent_BB_02         [myGUI::cvCustom::createAngleRep $cvObject $BottomBracket(Position)   $SeatTube(Saddle)           $ChainSt_SeatSt_IS          90  BottomBracket_ChainStay ]
    set represent_SL_01         [myGUI::cvCustom::createAngleRep $cvObject $TopTube(SeatTube)         $SeatTube(End)              $TopTube(Steerer)           80  SeatLug_TopTube         ]
    set represent_SL_02         [myGUI::cvCustom::createAngleRep $cvObject $SeatStay(SeatTube)        $ChainSt_SeatSt_IS          $BottomBracket(Position)    90  SeatLug_SeatStay        ]
    set represent_HL_TT         [myGUI::cvCustom::createAngleRep $cvObject $TopTube(Steerer)          $Steerer(Stem)              $TopTube(SeatTube)          80  HeadLug_Top             ]
    set represent_HL_DT         [myGUI::cvCustom::createAngleRep $cvObject $DownTube(Steerer)         $BottomBracket(Position)    $Steerer(Fork)              90  HeadLug_Bottom          ]
        #
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_DO       lugSpec_RearDropout
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_BB_01    lugSpec_SeatTube_DownTube
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_BB_02    lugSpec_SeatTube_ChainStay
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_SL_01    lugSpec_SeatTube_TopTube
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_SL_02    lugSpec_SeatTube_SeatStay
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_HL_TT    lugSpec_HeadTube_TopTube
    myGUI::gui::bind_objectEvent_2  $cvObject   $represent_HL_DT    lugSpec_HeadTube_DownTube
        #
    return
        #
}

proc myGUI::cvCustom::createDraftingFrame {cvObject {labelFile {}} {title {}} {description {}} } {
        #
    puts ""
    puts "   -------------------------------"
    puts "    myGUI::cvCustom::createDraftingFrame"
    puts "       cvObject:      $cvObject"
    puts "       title:         $title"
        #
    if {$labelFile eq {}} {
        set labelFile   [file join $::APPL_Config(CONFIG_Dir) label rattleCAD.svg]
    }
    if {$title eq {}} {
        set title       [file tail [myGUI::control::getSession  projectName]]
    }
    if {$description eq {}} {
        set description [format "V%s.%s" $::APPL_Config(RELEASE_Version) $::APPL_Config(RELEASE_Revision)]
    }
        #
    set date            [myGUI::control::getSession dateModified]
        #
        #               [list pageScale ... pageFormat ...]
        # set retDict         [$cvObject createDraftingFrame $company $title $date $desciption]
    set retDict         [$cvObject create draftFrame {} [list \
                                                    -label $labelFile \
                                                    -title $title \
                                                    -date  $date \
                                                    -descr $description ]]
        #
    set w_pageScale     [dict get $retDict pageScale]
    set w_pageFormat    [dict get $retDict pageFormat]
        #
    myGUI::gui::bind_objectEvent_2  $cvObject    $w_pageScale   page_PageScale
    myGUI::gui::bind_objectEvent_2  $cvObject    $w_pageFormat  page_FormatDIN
        #
    return
        #
}

proc myGUI::cvCustom::createWaterMark {cvObject projectFile date} {
        #
    set stageFormat         [$cvObject configure  Stage Format]
        #
    set textPos             {7 5}
        #
    set textText            [format "%s  /  %s  / \[DIN %s\] /  rattleCAD  V%s.%s " $projectFile $date $stageFormat $::APPL_Config(RELEASE_Version) $::APPL_Config(RELEASE_Revision) ]
        #
    set WaterMark(object)   [$cvObject create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray20 -tags __WaterMark__]
        #
}

proc myGUI::cvCustom::createWaterMark_Label {cvObject {coords {_default_}} {orient e} {labelFile {_default_}}  {tagList {}}  {scale {1.0}} {position {}}} {
        #
    if {$labelFile eq {_default_}} {
        set svgFile [file join $::APPL_Config(CONFIG_Dir) label rattleCAD.svg]    
    } else {
        set svgFile $labelFile
    }
        #
    set fp          [open $svgFile]
        #
    fconfigure      $fp -encoding utf-8
    set xml         [read $fp]
    close           $fp
        #
    set doc         [dom parse  $xml]
    set svgNode     [$doc documentElement]
        #
    set stageWidth  [$cvObject configure  Stage Width]
        # 
    if {$coords eq {_default_}} {
            #
        set refx_00     [expr $stageWidth - 100]
        set refx_01     [expr $stageWidth -  10]
        set refy_00     5
        set refy_01     12
            #
        set myCoords    [list $refx_00 $refy_00 $refx_01 $refy_01]
            #
    } else {
            #
        set myCoords    $coords
            #
    }
        #
    set labelObject [$cvObject create draftLabel  $myCoords  [list -svgNode $svgNode  -anchor $orient  -tags __Watermark_Label__]]
        #
    return $labelObject
        #
}

proc myGUI::cvCustom::updateRenderingCanvas {cvObject {frameTubeColor {}} {forkColor {}} {labelColor {}} {decoColor {}} {compColor {}} {tyreColor {}}  } {
        #
    if {$frameTubeColor == {}} {set frameTubeColor $myGUI::view::edit::colorSet(frameTubeColor)};    # {#edc778}
    if {$forkColor      == {}} {set forkColor      $myGUI::view::edit::colorSet(forkColor)};         # {#gray20}
    if {$labelColor     == {}} {set labelColor     $myGUI::view::edit::colorSet(labelColor)};        # {gray10}
    if {$decoColor      == {}} {set decoColor      $myGUI::view::edit::colorSet(decoColor)};         # {gray98}
    if {$compColor      == {}} {set compColor      $myGUI::view::edit::colorSet(compColor)};         # {gray98}
    if {$tyreColor      == {}} {set tyreColor      $myGUI::view::edit::colorSet(tyreColor)};         # {gray95}
        #
        # if {$decoColor == {}} {set decoColor {gray98}}
        # if {$compColor == {}} {set compColor {gray98}}
        # if {$tyreColor == {}} {set tyreColor {gray95}}
        # if {$logoColour == {}} {set logoColour {gray10}}
        #
        # puts "    -> \$frameTubeColor $frameTubeColor"
        # puts "    -> \$forkColor      $forkColor     "
        # puts "    -> \$labelColor     $labelColor    "
        # puts "    -> \$decoColor      $decoColor     "
        # puts "    -> \$compColor      $compColor     "
        # puts "    -> \$tyreColor      $tyreColor     "
        #
        # puts "\n <I> \$frameTubeColor  $frameTubeColor \n"    
        # puts "\n <I> \$forkColor       $forkColor \n"    
        #
    foreach cv_Item [$cvObject find withtag __Frame__] {
        set cv_Type     [$cvObject type $cv_Item]
        switch -exact -- $cv_Type {
            polygon -
            ppolygon {
                $cvObject itemconfigure  $cv_Item -fill $frameTubeColor
            }
        }
    }
    foreach cv_Item [$cvObject find withtag __Fork__] {
        set cv_Type     [$cvObject type $cv_Item]
        switch -exact -- $cv_Type {
            polygon -
            ppolygon {
                $cvObject itemconfigure  $cv_Item -fill $forkColor
            }
        }
    }
        #
    foreach cv_Item [$cvObject find withtag __Decoration__] {
        set cv_Type     [$cvObject type $cv_Item]
        switch -exact -- $cv_Type {
            polygon -
            ppolygon {
                $cvObject itemconfigure  $cv_Item -fill $decoColor
            }
        }
    }
        #
    foreach cv_Item [$cvObject find withtag {__Decoration__ && __HandleBar__}] {
        set cv_Type     [$cvObject type $cv_Item]
        switch -exact -- $cv_Type {
            polygon -
            ppolygon {
                $cvObject itemconfigure  $cv_Item -fill $compColor
            }
        }
    }
    foreach cv_Item [$cvObject find withtag {__Decoration__ && __Saddle__}] {
        set cv_Type     [$cvObject type $cv_Item]
        switch -exact -- $cv_Type {
            polygon -
            ppolygon {
                $cvObject itemconfigure  $cv_Item -fill $compColor
            }
        }
    }
        #
    foreach cv_Item [$cvObject find withtag {__Decoration__ && __Tyre__}] {
            $cvObject itemconfigure  $cv_Item -fill $tyreColor
    }
    foreach cv_Item [$cvObject find withtag {__Decoration__ && __Rim_02__}] {
            $cvObject itemconfigure  $cv_Item -fill $compColor
    }
    foreach cv_Item [$cvObject find withtag {__Decoration__ && (__FrontFender__ || __RearFender__}] {
            $cvObject itemconfigure  $cv_Item -fill $compColor
    }
    foreach cv_Item [$cvObject find withtag {__Label__}] {
        set cv_Type     [$cvObject type $cv_Item]
        switch -exact -- $cv_Type {
            ppolygon -
            polygon {
                $cvObject itemconfigure  $cv_Item -fill $labelColor -outline {}
            }
        }
    }
        #
}

proc myGUI::cvCustom::updateRenderingCenterline {cvObject {lineWidth_00 {0.7}} {lineWidth_01 {0.7}}} {
        #
    foreach cv_Item [$cvObject find withtag "__CenterLine__  && baseLine"] { 
        itemconfigureLineWidth  $cvObject  $cv_Item  $lineWidth_00
    }
}

proc myGUI::cvCustom::scaleToStage  {ptList factor} {
    return [vectormath::scaleCoordList {0 0} $ptList $factor ]
}

proc myGUI::cvCustom::createJigParameterTable {cvObject key} {
        #
    puts "   -> myGUI::cvCustom::createJigParameterTable"   
        #
    set FrameJig(Angles) $::myGUI::dimension::FrameJig(Angles)
        #
    set stageScale $::myGUI::dimension::stageScale
        #
        # set textPosition    [list [expr 5/$stageScale] [expr 5/$stageScale]]
    set textPosition    [list 5 5]
    set lineDistance    6
        # 
    switch -exact $key {
        FrameJig {    
                #
            set index 0
                #
            foreach angle $FrameJig(Angles) {
                    #
                set angleText   [expr double(round(100*$angle))/100]
                set degreeText  [ expr int(floor($angleText)) ]
                set   minute    [ expr ($angleText - $degreeText) * 60.0 ]
                set minuteText  [ format "%02s" [ expr int(floor($minute)) ] ]
                    # -- supplement Angles
                set angleText_sup   [ expr 180 - $angleText]
                set degreeText_sup  [ expr int(floor($angleText_sup)) ]
                if {$minuteText > 0} {
                    set minuteText_sup [ format "%02s" [ expr int(floor(60 - 1.0*$minute))] ]
                } else {
                    set minuteText_sup "00"
                } 
                    #
                set textPosition_0  [vectormath::addVector $textPosition     [list   2  [expr (2 + $index * $lineDistance)]]]
                set textPosition_1  [vectormath::addVector $textPosition_0   [list  30  0]] 
                set textPosition_2  [vectormath::addVector $textPosition_1   [list  25  0]] 
                set textPosition_3  [vectormath::addVector $textPosition_2   [list  30  0]] 
                set textPosition_4  [vectormath::addVector $textPosition_3   [list  25  0]] 
                    # set textPosition_0  [ vectormath::addVector $textPosition     [list [expr  2/$stageScale] [expr (2 + $index * $lineDistance)/$stageScale]]  ] 
                    # set textPosition_1  [ vectormath::addVector $textPosition_0   [list [expr 28/$stageScale] 0] ] 
                    # set textPosition_2  [ vectormath::addVector $textPosition_1   [list [expr 22/$stageScale] 0] ] 
                    # set textPosition_3  [ vectormath::addVector $textPosition_2   [list [expr 28/$stageScale] 0] ] 
                    # set textPosition_4  [ vectormath::addVector $textPosition_3   [list [expr 22/$stageScale] 0] ] 
                $cvObject create draftText $textPosition_0    -text "Angle:"                                  -anchor sw -size 3.5
                $cvObject create draftText $textPosition_1    -text "$angleText°:"                           -anchor se -size 3.5
                $cvObject create draftText $textPosition_2    -text "$degreeText° $minuteText\'"              -anchor se -size 3.5
                $cvObject create draftText $textPosition_3    -text "( $degreeText_sup° $minuteText_sup\' )"  -anchor se -size 3.5
                    #
                incr index
            }
        }
        default {return}
    }        
}

proc myGUI::cvCustom::itemconfigureLineWidth {cvObject tagId width} {
        #
        # ... should find a place in cadCanvas anytime
        #
    foreach item [$cvObject find withtag $tagId] {
        switch -exact [$cvObject type $item] {
        
            ________Canvas_Objects__ -
            
            line  {
                $cvObject itemconfigure  $item  -width $width
            }
            arc -
            oval -
            polygon -
            rect {
                $cvObject itemconfigure  $item  -width $width
            }
            
            ________PathCanvas_Objects__ -
            
            circle -
            ellipse -
            pline -
            polyline - 
            prect {
                $cvObject itemconfigure  $item  -strokewidth $width
            }
        }
    }
}
