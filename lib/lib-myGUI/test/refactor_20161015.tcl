  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"

    
        # -- Libraries  ---------------
    lappend auto_path   "$APPL_ROOT_Dir"
    lappend auto_path   [file join $APPL_ROOT_Dir lib]
    lappend auto_path   "$APPL_ROOT_Dir/../myPersist"
        # --eclipse reference
    lappend auto_path   "$APPL_ROOT_Dir/../lib-myPersist"
        #
    foreach pathDir $auto_path {
        puts "        -> $pathDir"
    }

        # -- Packages  ---------------
    package require   tdom
    package require   bikeGeometry
    # package require   bikeModel
    package require   myGUI
    # package require   bikeFacade
    # package require   vectormath
    # package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
    set ETC_Dir     [file join $BASE_Dir etc]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
    set projectFile [file join $ETC_Dir template_road_3.4.xml]
        #
    myGUI::modelAdapter::open_ProjectFile $projectFile
        #
        # -- update read projectDict, set model - Timestamp
    myGUI::modelAdapter::updateModel
        #
        # -- update model_Edit
    myGUI::modelAdapter::updateModel_Edit   ::myGUI::model::model_Edit   
        #
    namespace eval myGUI::modelAdapter {
            #
        namespace import ::bikeGeometry::get_Component
            #
        namespace import ::bikeGeometry::get_Config
        namespace import ::bikeGeometry::get_ListValue
        namespace import ::bikeGeometry::get_Scalar
            #
        namespace import ::bikeGeometry::get_Polygon
        namespace import ::bikeGeometry::get_Position
        namespace import ::bikeGeometry::get_Direction
        namespace import ::bikeGeometry::get_BoundingBox
        namespace import ::bikeGeometry::get_CenterLine
        namespace import ::bikeGeometry::get_TubeMiter
        # namespace import ::bikeGeometry::get_TubeMiterDICT
        # namespace import ::bikeGeometry::get_paramComponent        
            #
    }
    
        #
        # -- update model_XZ
    proc myGUI::modelAdapter::updateModel_XZ_checkSyntax {} {
        
        puts "\n\n    --- myGUI::modelAdapter::updateModel_XZ ---"
            #
        set _modelDict  [myGUI::modelAdapter::get_projectDICT]
            #
            # --- centerline settings ----------------------
            #
        puts " [myGUI::modelAdapter::get_CenterLine   RearMockup_CtrLines    ]"
        puts " [myGUI::modelAdapter::_pointList2coordList  [join [dict get $_modelDict CenterLine RearMockup_CtrLines] " "]]"
               
            # --- component settings ----------------------
            #
        puts " [myGUI::modelAdapter::get_Component BottleCage_DownTube         ]"
        puts " [dict get $_modelDict Component BottleCage_DownTube]"
       
        puts " [myGUI::modelAdapter::get_Config    ChainStay         ]"
        puts " [dict get $_modelDict Config    ChainStay]"
        
       
        puts " [myGUI::modelAdapter::get_Direction DownTube         ]"
        puts " [join [dict get $_modelDict Direction DownTube] " "]"
        
        puts "[split [myGUI::modelAdapter::get_ListValue CrankSetChainRings] -]"
        puts "[split [dict get $_modelDict ListValue CrankSetChainRings] -]"
        
        puts " [myGUI::modelAdapter::get_Polygon    ChainStay]"
        puts " [join [dict get $_modelDict Polygon    ChainStay] " "]"
        
        puts " [myGUI::modelAdapter::get_Position  BottomBracket_Ground        ]"
        puts " [join [dict get $_modelDict Position    BottomBracket_Ground] " "]"
        
        puts " [myGUI::modelAdapter::get_BoundingBox  Summary_Size        ] ... not available?"
        puts " [join [dict get $_modelDict BoundingBox  Summary] " "]"
        
        appUtil::pdict $_modelDict

            
        return
        
        
            # --- component settings ----------------------
            #
        ${targetNamespace}::setComponent    BottleCage_DownTube         [myGUI::modelAdapter::get_Component BottleCage_DownTube         ]
        ${targetNamespace}::setComponent    BottleCage_DownTube_Lower   [myGUI::modelAdapter::get_Component BottleCage_DownTube_Lower   ]
        ${targetNamespace}::setComponent    BottleCage_SeatTube         [myGUI::modelAdapter::get_Component BottleCage_SeatTube         ]
        ${targetNamespace}::setComponent    CrankSet                    [myGUI::modelAdapter::get_Component CrankSet                    ]
        ${targetNamespace}::setComponent    ForkCrown                   [myGUI::modelAdapter::get_Component ForkCrown                   ]
        ${targetNamespace}::setComponent    ForkDropout                 [myGUI::modelAdapter::get_Component ForkDropout                 ]
        ${targetNamespace}::setComponent    ForkSupplier                [myGUI::modelAdapter::get_Component ForkSupplier                ]
        ${targetNamespace}::setComponent    FrontBrake                  [myGUI::modelAdapter::get_Component FrontBrake                  ]
        ${targetNamespace}::setComponent    FrontCarrier                [myGUI::modelAdapter::get_Component FrontCarrier                ]
        ${targetNamespace}::setComponent    FrontDerailleur             [myGUI::modelAdapter::get_Component FrontDerailleur             ]
        ${targetNamespace}::setComponent    HandleBar                   [myGUI::modelAdapter::get_Component HandleBar                   ]
        ${targetNamespace}::setComponent    Label                       [myGUI::modelAdapter::get_Component Label                       ]
        ${targetNamespace}::setComponent    RearBrake                   [myGUI::modelAdapter::get_Component RearBrake                   ]
        ${targetNamespace}::setComponent    RearCarrier                 [myGUI::modelAdapter::get_Component RearCarrier                 ]
        ${targetNamespace}::setComponent    RearDerailleur              [myGUI::modelAdapter::get_Component RearDerailleur              ]
        ${targetNamespace}::setComponent    RearDropout                 [myGUI::modelAdapter::get_Component RearDropout                 ]
        ${targetNamespace}::setComponent    RearHub                     [myGUI::modelAdapter::get_Component RearHub                     ]
        ${targetNamespace}::setComponent    Saddle                      [myGUI::modelAdapter::get_Component Saddle                      ]
            
            # --- get config Values -----------------------
            #
        ${targetNamespace}::setConfig       ChainStay                   [myGUI::modelAdapter::get_Config    ChainStay]
        ${targetNamespace}::setConfig       FrontBrake                  [myGUI::modelAdapter::get_Config    FrontBrake]
        ${targetNamespace}::setConfig       RearBrake                   [myGUI::modelAdapter::get_Config    RearBrake]
        ${targetNamespace}::setConfig       FrontFender                 [myGUI::modelAdapter::get_Config    FrontFender]
        ${targetNamespace}::setConfig       RearFender                  [myGUI::modelAdapter::get_Config    RearFender]
        ${targetNamespace}::setConfig       BottleCage_SeatTube         [myGUI::modelAdapter::get_Config    BottleCage_SeatTube]
        ${targetNamespace}::setConfig       BottleCage_DownTube         [myGUI::modelAdapter::get_Config    BottleCage_DownTube]
        ${targetNamespace}::setConfig       BottleCage_DownTube_Lower   [myGUI::modelAdapter::get_Config    BottleCage_DownTube_Lower]
        ${targetNamespace}::setConfig       Fork                        [myGUI::modelAdapter::get_Config    Fork]
        ${targetNamespace}::setConfig       ForkBlade                   [myGUI::modelAdapter::get_Config    ForkBlade]
        ${targetNamespace}::setConfig       ForkDropout                 [myGUI::modelAdapter::get_Config    ForkDropout]
        ${targetNamespace}::setConfig       HeadTube                    [myGUI::modelAdapter::get_Config    HeadTube]
        ${targetNamespace}::setConfig       RearDropout                 [myGUI::modelAdapter::get_Config    RearDropout]
        ${targetNamespace}::setConfig       RearDropoutOrient           [myGUI::modelAdapter::get_Config    RearDropoutOrient]
                    
            # --- set direction values --------------------
            #
        ${targetNamespace}::setDirection    DownTube                    [myGUI::modelAdapter::get_Direction DownTube]
        ${targetNamespace}::setDirection    ForkCrown                   [myGUI::modelAdapter::get_Direction ForkCrown]
        ${targetNamespace}::setDirection    ForkDropout                 [myGUI::modelAdapter::get_Direction ForkDropout]
        ${targetNamespace}::setDirection    HeadTube                    [myGUI::modelAdapter::get_Direction HeadTube]
        ${targetNamespace}::setDirection    RearDropout                 [myGUI::modelAdapter::get_Direction RearDropout]
        ${targetNamespace}::setDirection    SeatStay                    [myGUI::modelAdapter::get_Direction SeatStay]                    
        ${targetNamespace}::setDirection    SeatTube                    [myGUI::modelAdapter::get_Direction SeatTube]                    
        
            # --- list values -----------------------------
            #
        ${targetNamespace}::setListValue    CrankSetChainRings          [split [myGUI::modelAdapter::get_ListValue CrankSetChainRings] -]
            
            # --- polygon value ---------------------------
            #
        ${targetNamespace}::setPolygon      ChainStay                   [get_Polygon    ChainStay               ]
        ${targetNamespace}::setPolygon      ChainStay_RearMockup        [get_Polygon    ChainStay_RearMockup    ]
        ${targetNamespace}::setPolygon      ChainStay_XY                [get_Polygon    ChainStay_xy            ]
        ${targetNamespace}::setPolygon      CrankArm_XY                 [get_Polygon    CrankArm_xy             ]
        ${targetNamespace}::setPolygon      DownTube                    [get_Polygon    DownTube                ]
        ${targetNamespace}::setPolygon      ForkBlade                   [get_Polygon    ForkBlade               ]
        ${targetNamespace}::setPolygon      FrontFender                 [get_Polygon    FrontFender             ]
        ${targetNamespace}::setPolygon      HeadSet                     [get_Polygon    HeadSetTop              ]
        ${targetNamespace}::setPolygon      HeadSetBottom               [get_Polygon    HeadSetBottom           ]
        ${targetNamespace}::setPolygon      HeadSetCap                  [get_Polygon    HeadSetCap              ]
        ${targetNamespace}::setPolygon      HeadSetTop                  [get_Polygon    HeadSetTop              ]
        ${targetNamespace}::setPolygon      HeadTube                    [get_Polygon    HeadTube                ]
        ${targetNamespace}::setPolygon      RearFender                  [get_Polygon    RearFender              ]
        ${targetNamespace}::setPolygon      SeatPost                    [get_Polygon    SeatPost                ]
        ${targetNamespace}::setPolygon      SeatStay                    [get_Polygon    SeatStay                ]
        ${targetNamespace}::setPolygon      SeatTube                    [get_Polygon    SeatTube                ]
        ${targetNamespace}::setPolygon      Spacer                      [get_Polygon    Spacer                  ]
        ${targetNamespace}::setPolygon      Steerer                     [get_Polygon    Steerer                 ]
        ${targetNamespace}::setPolygon      Stem                        [get_Polygon    Stem                    ]
        ${targetNamespace}::setPolygon      TopTube                     [get_Polygon    TopTube                 ]
        
            # --- get defining Point coords ---------------
            #
        ${targetNamespace}::setPosition BottomBracket                   {0 0}
        ${targetNamespace}::setPosition BottomBracket_Ground            [myGUI::modelAdapter::get_Position  BottomBracket_Ground        ]
        ${targetNamespace}::setPosition CarrierMount_Front              [myGUI::modelAdapter::get_Position  CarrierMount_Front          ]
        ${targetNamespace}::setPosition CarrierMount_Rear               [myGUI::modelAdapter::get_Position  CarrierMount_Rear           ]
        ${targetNamespace}::setPosition ChainStay_RearWheel             [myGUI::modelAdapter::get_Position  ChainStay_RearWheel         ]
        ${targetNamespace}::setPosition IS_ChainSt_SeatSt               [myGUI::modelAdapter::get_Position  ChainStay_SeatStay_IS       ]
        ${targetNamespace}::setPosition DerailleurMount_Front           [myGUI::modelAdapter::get_Position  DerailleurMount_Front       ]
        ${targetNamespace}::setPosition DownTube_BottleCageBase         [myGUI::modelAdapter::get_Position  DownTube_BottleCageBase     ]
        ${targetNamespace}::setPosition DownTube_BottleCageOffset       [myGUI::modelAdapter::get_Position  DownTube_BottleCageOffset   ]
        ${targetNamespace}::setPosition DownTube_End                    [myGUI::modelAdapter::get_Position  DownTube_End                ]
        ${targetNamespace}::setPosition DownTube_Start                  [myGUI::modelAdapter::get_Position  DownTube_Start              ]
        ${targetNamespace}::setPosition ForkCrown                       [myGUI::modelAdapter::get_Position  ForkCrown                   ]
        ${targetNamespace}::setPosition FrontDropout_MockUp             [myGUI::modelAdapter::get_Position  FrontDropout_MockUp         ]
        ${targetNamespace}::setPosition FrontBrake_Definition           [myGUI::modelAdapter::get_Position  FrontBrake_Definition       ]
        ${targetNamespace}::setPosition FrontBrake_Help                 [myGUI::modelAdapter::get_Position  FrontBrake_Help             ]
        ${targetNamespace}::setPosition FrontBrake_Mount                [myGUI::modelAdapter::get_Position  FrontBrake_Mount            ]
        ${targetNamespace}::setPosition FrontBrake_Shoe                 [myGUI::modelAdapter::get_Position  FrontBrake_Shoe             ]
        ${targetNamespace}::setPosition FrontWheel                      [myGUI::modelAdapter::get_Position  FrontWheel                  ]
        ${targetNamespace}::setPosition HandleBar                       [myGUI::modelAdapter::get_Position  HandleBar                   ]
        ${targetNamespace}::setPosition HeadTube_End                    [myGUI::modelAdapter::get_Position  HeadTube_End                ]
        ${targetNamespace}::setPosition HeadTube_Start                  [myGUI::modelAdapter::get_Position  HeadTube_Start              ]
        ${targetNamespace}::setPosition HeadTube_VirtualTopTube         [myGUI::modelAdapter::get_Position  HeadTube_VirtualTopTube     ]
        ${targetNamespace}::setPosition LegClearance                    [myGUI::modelAdapter::get_Position  LegClearance                ]
        ${targetNamespace}::setPosition RearBrake_Definition            [myGUI::modelAdapter::get_Position  RearBrake_Definition        ]
        ${targetNamespace}::setPosition RearBrake_Help                  [myGUI::modelAdapter::get_Position  RearBrake_Help              ]
        ${targetNamespace}::setPosition RearBrake_Mount                 [myGUI::modelAdapter::get_Position  RearBrake_Mount             ]
        ${targetNamespace}::setPosition RearBrake_Shoe                  [myGUI::modelAdapter::get_Position  RearBrake_Shoe              ]
        ${targetNamespace}::setPosition RearDerailleur                  [myGUI::modelAdapter::get_Position  RearDerailleur              ]
        ${targetNamespace}::setPosition RearWheel                       [myGUI::modelAdapter::get_Position  RearWheel                   ]
        ${targetNamespace}::setPosition Reference_HB                    [myGUI::modelAdapter::get_Position  Reference_HB                ]
        ${targetNamespace}::setPosition Reference_SN                    [myGUI::modelAdapter::get_Position  Reference_SN                ]
        ${targetNamespace}::setPosition Saddle                          [myGUI::modelAdapter::get_Position  Saddle                      ]
        ${targetNamespace}::setPosition SaddleNose                      [myGUI::modelAdapter::get_Position  SaddleNose                  ]
        ${targetNamespace}::setPosition SaddleProposal                  [myGUI::modelAdapter::get_Position  SaddleProposal              ]
        ${targetNamespace}::setPosition Saddle_Mount                    [myGUI::modelAdapter::get_Position  Saddle_Mount                ]
        ${targetNamespace}::setPosition SeatPost_Pivot                  [myGUI::modelAdapter::get_Position  SeatPost_Pivot              ]
        ${targetNamespace}::setPosition SeatPost_SeatTube               [myGUI::modelAdapter::get_Position  SeatPost_SeatTube           ]
        ${targetNamespace}::setPosition SeatStay_End                    [myGUI::modelAdapter::get_Position  SeatStay_End                ]
        ${targetNamespace}::setPosition SeatStay_Start                  [myGUI::modelAdapter::get_Position  SeatStay_Start              ]
        ${targetNamespace}::setPosition SeatTube_BottleCageBase         [myGUI::modelAdapter::get_Position  SeatTube_BottleCageBase     ]
        ${targetNamespace}::setPosition SeatTube_BottleCageOffset       [myGUI::modelAdapter::get_Position  SeatTube_BottleCageOffset     ]
        ${targetNamespace}::setPosition SeatTube_ClassicTopTube         [myGUI::modelAdapter::get_Position  SeatTube_ClassicTopTube     ]
        ${targetNamespace}::setPosition SeatTube_End                    [myGUI::modelAdapter::get_Position  SeatTube_End                ]
        ${targetNamespace}::setPosition SeatTube_Ground                 [myGUI::modelAdapter::get_Position  SeatTube_Ground             ]
        ${targetNamespace}::setPosition SeatTube_Saddle                 [myGUI::modelAdapter::get_Position  SeatTube_Saddle             ]
        ${targetNamespace}::setPosition SeatTube_Start                  [myGUI::modelAdapter::get_Position  SeatTube_Start              ]
        ${targetNamespace}::setPosition SeatTube_VirtualTopTube         [myGUI::modelAdapter::get_Position  SeatTube_VirtualTopTube     ]
        ${targetNamespace}::setPosition Steerer_End                     [myGUI::modelAdapter::get_Position  Steerer_End                 ]
        ${targetNamespace}::setPosition Steerer_Ground                  [myGUI::modelAdapter::get_Position  Steerer_Ground              ]
        ${targetNamespace}::setPosition Steerer_Start                   [myGUI::modelAdapter::get_Position  Steerer_Start               ]
        ${targetNamespace}::setPosition TopTube_End                     [myGUI::modelAdapter::get_Position  TopTube_End                 ]
        ${targetNamespace}::setPosition TopTube_Start                   [myGUI::modelAdapter::get_Position  TopTube_Start               ]
            #
        ${targetNamespace}::setPosition _Edge_DownTubeHeadTube_DT       [myGUI::modelAdapter::get_Position  _Edge_DownTubeHeadTube_DT   ]
        ${targetNamespace}::setPosition _Edge_HeadSetTopFront_Bottom    [myGUI::modelAdapter::get_Position  _Edge_HeadSetTopFront_Bottom]
        ${targetNamespace}::setPosition _Edge_HeadSetTopFront_Top       [myGUI::modelAdapter::get_Position  _Edge_HeadSetTopFront_Top   ]
        ${targetNamespace}::setPosition _Edge_HeadTubeBack_Bottom       [myGUI::modelAdapter::get_Position  _Edge_HeadTubeBack_Bottom   ]
        ${targetNamespace}::setPosition _Edge_HeadTubeBack_Top          [myGUI::modelAdapter::get_Position  _Edge_HeadTubeBack_Top      ]
        ${targetNamespace}::setPosition _Edge_HeadTubeFront_Bottom      [myGUI::modelAdapter::get_Position  _Edge_HeadTubeFront_Bottom  ]
        ${targetNamespace}::setPosition _Edge_HeadTubeFront_Top         [myGUI::modelAdapter::get_Position  _Edge_HeadTubeFront_Top     ]
        ${targetNamespace}::setPosition _Edge_SeatTubeTop_Front         [myGUI::modelAdapter::get_Position  _Edge_SeatTubeTop_Front     ]
        ${targetNamespace}::setPosition _Edge_TopTubeHeadTube_TT        [myGUI::modelAdapter::get_Position  _Edge_TopTubeHeadTube_TT    ]
        ${targetNamespace}::setPosition _Edge_TopTubeSeatTube_ST        [myGUI::modelAdapter::get_Position  _Edge_TopTubeSeatTube_ST    ]
        ${targetNamespace}::setPosition _Edge_TopTubeTaperTop_HT        [myGUI::modelAdapter::get_Position  _Edge_TopTubeTaperTop_HT    ]
        ${targetNamespace}::setPosition _Edge_TopTubeTaperTop_ST        [myGUI::modelAdapter::get_Position  _Edge_TopTubeTaperTop_ST    ]  
            #
        ${targetNamespace}::setPosition ChainStay_RearMockup            [myGUI::modelAdapter::get_Position  ChainStay_RearMockup    ]  

            # --- scalar settings --------------------------
            #
        ${targetNamespace}::setScalar       Steerer         Diameter                            30.0 
            #
        ${targetNamespace}::setScalar       BottleCage      DownTube                            [myGUI::modelAdapter::get_Scalar    BottleCage DownTube                    ]
        ${targetNamespace}::setScalar       BottleCage      DownTube_Lower                      [myGUI::modelAdapter::get_Scalar    BottleCage DownTube_Lower              ]
        ${targetNamespace}::setScalar       BottleCage      SeatTube                            [myGUI::modelAdapter::get_Scalar    BottleCage SeatTube                    ]
        ${targetNamespace}::setScalar       BottomBracket   Depth                               [myGUI::modelAdapter::get_Scalar    Geometry BottomBracket_Depth           ]
        ${targetNamespace}::setScalar       BottomBracket   InsideDiameter                      [myGUI::modelAdapter::get_Scalar    BottomBracket InsideDiameter           ]
        ${targetNamespace}::setScalar       BottomBracket   OffsetCS_TopView                    [myGUI::modelAdapter::get_Scalar    BottomBracket OffsetCS_TopView         ]
        ${targetNamespace}::setScalar       BottomBracket   OutsideDiameter                     [myGUI::modelAdapter::get_Scalar    BottomBracket OutsideDiameter          ]
        ${targetNamespace}::setScalar       BottomBracket   Width                               [myGUI::modelAdapter::get_Scalar    BottomBracket Width                    ]
        ${targetNamespace}::setScalar       ChainStay       WidthBB                             [myGUI::modelAdapter::get_Scalar    ChainStay WidthBB                      ]
        ${targetNamespace}::setScalar       ChainStay       completeLength                      [myGUI::modelAdapter::get_Scalar    ChainStay completeLength               ]
        ${targetNamespace}::setScalar       ChainStay       cuttingLeft                         [myGUI::modelAdapter::get_Scalar    ChainStay cuttingLeft                  ]
        ${targetNamespace}::setScalar       ChainStay       cuttingLength                       [myGUI::modelAdapter::get_Scalar    ChainStay cuttingLength                ]
        ${targetNamespace}::setScalar       ChainStay       profile_x01                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_x01                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_x02                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_x02                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_x03                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_x03                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y00                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_y00                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y01                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_y01                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y02                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_y02                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y03                         [myGUI::modelAdapter::get_Scalar    ChainStay profile_y03                  ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_01                     [myGUI::modelAdapter::get_Scalar    ChainStay segmentAngle_01              ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_02                     [myGUI::modelAdapter::get_Scalar    ChainStay segmentAngle_02              ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_03                     [myGUI::modelAdapter::get_Scalar    ChainStay segmentAngle_03              ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_04                     [myGUI::modelAdapter::get_Scalar    ChainStay segmentAngle_04              ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_01                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentLength_01             ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_02                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentLength_02             ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_03                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentLength_03             ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_04                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentLength_04             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_01                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentRadius_01             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_02                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentRadius_02             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_03                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentRadius_03             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_04                    [myGUI::modelAdapter::get_Scalar    ChainStay segmentRadius_04             ]
        ${targetNamespace}::setScalar       CrankSet        ArmWidth                            [myGUI::modelAdapter::get_Scalar    CrankSet ArmWidth                      ]
        ${targetNamespace}::setScalar       CrankSet        ChainLine                           [myGUI::modelAdapter::get_Scalar    CrankSet ChainLine                     ]
        ${targetNamespace}::setScalar       CrankSet        ChainRingOffset                     [myGUI::modelAdapter::get_Scalar    CrankSet ChainRingOffset               ]
        ${targetNamespace}::setScalar       CrankSet        Length                              [myGUI::modelAdapter::get_Scalar    CrankSet Length                        ]
        ${targetNamespace}::setScalar       CrankSet        PedalEye                            [myGUI::modelAdapter::get_Scalar    CrankSet PedalEye                      ]
        ${targetNamespace}::setScalar       CrankSet        Q-Factor                            [myGUI::modelAdapter::get_Scalar    CrankSet Q-Factor                      ]
        ${targetNamespace}::setScalar       DownTube        OffsetBB                            [myGUI::modelAdapter::get_Scalar    DownTube OffsetBB                      ]
        ${targetNamespace}::setScalar       DownTube        OffsetHT                            [myGUI::modelAdapter::get_Scalar    DownTube OffsetHT                      ]
        ${targetNamespace}::setScalar       Fork            CrownAngleBrake                     [myGUI::modelAdapter::get_Scalar    Fork CrownAngleBrake                   ]
        ${targetNamespace}::setScalar       Fork            Height                              [myGUI::modelAdapter::get_Scalar    Geometry Fork_Height                   ]
        ${targetNamespace}::setScalar       Fork            Rake                                [myGUI::modelAdapter::get_Scalar    Fork Rake                              ]
        ${targetNamespace}::setScalar       Fork            Rake                                [myGUI::modelAdapter::get_Scalar    Geometry Fork_Rake                     ]
        ${targetNamespace}::setScalar       FrontWheel      RimDiameter                         [myGUI::modelAdapter::get_Scalar    Geometry FrontRim_Diameter             ]
        ${targetNamespace}::setScalar       FrontWheel      RimHeight                           [myGUI::modelAdapter::get_Scalar    FrontWheel RimHeight                   ]
        ${targetNamespace}::setScalar       FrontWheel      TyreHeight                          [myGUI::modelAdapter::get_Scalar    Geometry FrontTyre_Height              ]
        ${targetNamespace}::setScalar       Geometry        BottomBracket_Depth                 [myGUI::modelAdapter::get_Scalar    Geometry BottomBracket_Depth           ]
        ${targetNamespace}::setScalar       Geometry        BottomBracket_Height                [myGUI::modelAdapter::get_Scalar    Geometry BottomBracket_Height          ]
        ${targetNamespace}::setScalar       Geometry        ChainStay_Length                    [myGUI::modelAdapter::get_Scalar    Geometry ChainStay_Length              ]
        ${targetNamespace}::setScalar       Geometry        Fork_Height                         [myGUI::modelAdapter::get_Scalar    Geometry Fork_Height                   ]
        ${targetNamespace}::setScalar       Geometry        Fork_Rake                           [myGUI::modelAdapter::get_Scalar    Geometry Fork_Rake                     ]
        ${targetNamespace}::setScalar       Geometry        FrontRim_Diameter                   [myGUI::modelAdapter::get_Scalar    Geometry FrontRim_Diameter             ]
        ${targetNamespace}::setScalar       Geometry        FrontTyre_Height                    [myGUI::modelAdapter::get_Scalar    Geometry FrontTyre_Height              ]
        ${targetNamespace}::setScalar       Geometry        HandleBar_Distance                  [myGUI::modelAdapter::get_Scalar    Geometry HandleBar_Distance            ]
        ${targetNamespace}::setScalar       Geometry        HandleBar_Height                    [myGUI::modelAdapter::get_Scalar    Geometry HandleBar_Height              ]
        ${targetNamespace}::setScalar       Geometry        HeadTube_Angle                      [myGUI::modelAdapter::get_Scalar    Geometry HeadTube_Angle                ]
        ${targetNamespace}::setScalar       Geometry        RearRim_Diameter                    [myGUI::modelAdapter::get_Scalar    Geometry RearRim_Diameter              ]
        ${targetNamespace}::setScalar       Geometry        RearTyre_Height                     [myGUI::modelAdapter::get_Scalar    Geometry RearTyre_Height               ]
        ${targetNamespace}::setScalar       Geometry        RearWheel_x                         [myGUI::modelAdapter::get_Scalar    Geometry RearWheel_x                   ]
        ${targetNamespace}::setScalar       Geometry        SaddleNose_BB_x                     [myGUI::modelAdapter::get_Scalar    Geometry SaddleNose_BB_x               ]
        ${targetNamespace}::setScalar       Geometry        Saddle_Distance                     [myGUI::modelAdapter::get_Scalar    Geometry Saddle_Distance               ]
        ${targetNamespace}::setScalar       Geometry        Saddle_Height                       [myGUI::modelAdapter::get_Scalar    Geometry Saddle_Height                 ]
        ${targetNamespace}::setScalar       Geometry        SeatTube_Angle                      [myGUI::modelAdapter::get_Scalar    Geometry SeatTube_Angle                ]
        ${targetNamespace}::setScalar       Geometry        SeatTube_LengthVirtual              [myGUI::modelAdapter::get_Scalar    Geometry SeatTube_LengthVirtual        ]
        ${targetNamespace}::setScalar       Geometry        Stem_Angle                          [myGUI::modelAdapter::get_Scalar    Geometry Stem_Angle                    ]
        ${targetNamespace}::setScalar       Geometry        Stem_Length                         [myGUI::modelAdapter::get_Scalar    Geometry Stem_Length                   ]
        ${targetNamespace}::setScalar       Geometry        TopTube_Angle                       [myGUI::modelAdapter::get_Scalar    Geometry TopTube_Angle                 ]
        ${targetNamespace}::setScalar       Geometry        TopTube_LengthVirtual               [myGUI::modelAdapter::get_Scalar    Geometry TopTube_LengthVirtual         ]
        ${targetNamespace}::setScalar       HandleBar       PivotAngle                          [myGUI::modelAdapter::get_Scalar    HandleBar PivotAngle                   ]
        ${targetNamespace}::setScalar       HeadSet         Diameter                            [myGUI::modelAdapter::get_Scalar    HeadSet Diameter                       ]
        ${targetNamespace}::setScalar       HeadSet         Height_Bottom                       [myGUI::modelAdapter::get_Scalar    HeadSet Height_Bottom                  ]
        ${targetNamespace}::setScalar       HeadTube        Diameter                            [myGUI::modelAdapter::get_Scalar    HeadTube Diameter                      ]
        ${targetNamespace}::setScalar       HeadTube        Length                              [myGUI::modelAdapter::get_Scalar    HeadTube Length                        ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_ChainStay_Angle       [myGUI::modelAdapter::get_Scalar    Lugs BottomBracket_ChainStay_Angle     ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_ChainStay_Tolerance   [myGUI::modelAdapter::get_Scalar    Lugs BottomBracket_ChainStay_Tolerance ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_DownTube_Angle        [myGUI::modelAdapter::get_Scalar    Lugs BottomBracket_DownTube_Angle      ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_DownTube_Tolerance    [myGUI::modelAdapter::get_Scalar    Lugs BottomBracket_DownTube_Tolerance  ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Bottom_Angle                [myGUI::modelAdapter::get_Scalar    Lugs HeadLug_Bottom_Angle              ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Bottom_Tolerance            [myGUI::modelAdapter::get_Scalar    Lugs HeadLug_Bottom_Tolerance          ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Top_Angle                   [myGUI::modelAdapter::get_Scalar    Lugs HeadLug_Top_Angle                 ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Top_Tolerance               [myGUI::modelAdapter::get_Scalar    Lugs HeadLug_Top_Tolerance             ]
        ${targetNamespace}::setScalar       Lugs            RearDropOut_Angle                   [myGUI::modelAdapter::get_Scalar    Lugs RearDropOut_Angle                 ]
        ${targetNamespace}::setScalar       Lugs            RearDropOut_Tolerance               [myGUI::modelAdapter::get_Scalar    Lugs RearDropOut_Tolerance             ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_SeatStay_Angle              [myGUI::modelAdapter::get_Scalar    Lugs SeatLug_SeatStay_Angle            ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_SeatStay_Tolerance          [myGUI::modelAdapter::get_Scalar    Lugs SeatLug_SeatStay_Tolerance        ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_TopTube_Angle               [myGUI::modelAdapter::get_Scalar    Lugs SeatLug_TopTube_Angle             ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_TopTube_Tolerance           [myGUI::modelAdapter::get_Scalar    Lugs SeatLug_TopTube_Tolerance         ]
        ${targetNamespace}::setScalar       RearDerailleur  Pulley_teeth                        [myGUI::modelAdapter::get_Scalar    RearDerailleur Pulley_teeth            ]
        ${targetNamespace}::setScalar       RearDerailleur  Pulley_x                            [myGUI::modelAdapter::get_Scalar    RearDerailleur Pulley_x                ]
        ${targetNamespace}::setScalar       RearDerailleur  Pulley_y                            [myGUI::modelAdapter::get_Scalar    RearDerailleur Pulley_y                ]
        ${targetNamespace}::setScalar       RearDropout     Derailleur_y                        [myGUI::modelAdapter::get_Scalar    RearDropout Derailleur_y               ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCS                            [myGUI::modelAdapter::get_Scalar    RearDropout OffsetCS                   ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCSPerp                        [myGUI::modelAdapter::get_Scalar    RearDropout OffsetCSPerp               ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCS_TopView                    [myGUI::modelAdapter::get_Scalar    RearDropout OffsetCS_TopView           ]
        ${targetNamespace}::setScalar       RearDropout     OffsetSSPerp                        [myGUI::modelAdapter::get_Scalar    RearDropout OffsetSSPerp               ]            
        ${targetNamespace}::setScalar       RearDropout     RotationOffset                      [myGUI::modelAdapter::get_Scalar    RearDropout RotationOffset             ]
        ${targetNamespace}::setScalar       RearMockup      CassetteClearance                   [myGUI::modelAdapter::get_Scalar    RearMockup CassetteClearance           ]
        ${targetNamespace}::setScalar       RearMockup      ChainWheelClearance                 [myGUI::modelAdapter::get_Scalar    RearMockup ChainWheelClearance         ]
        ${targetNamespace}::setScalar       RearMockup      CrankClearance                      [myGUI::modelAdapter::get_Scalar    RearMockup CrankClearance              ]
        ${targetNamespace}::setScalar       RearMockup      DiscClearance                       [myGUI::modelAdapter::get_Scalar    RearMockup DiscClearance               ]
        ${targetNamespace}::setScalar       RearMockup      DiscDiameter                        [myGUI::modelAdapter::get_Scalar    RearMockup DiscDiameter                ]
        ${targetNamespace}::setScalar       RearMockup      DiscOffset                          [myGUI::modelAdapter::get_Scalar    RearMockup DiscOffset                  ]
        ${targetNamespace}::setScalar       RearMockup      DiscWidth                           [myGUI::modelAdapter::get_Scalar    RearMockup DiscWidth                   ]
        ${targetNamespace}::setScalar       RearMockup      TyreClearance                       [myGUI::modelAdapter::get_Scalar    RearMockup TyreClearance               ]
        ${targetNamespace}::setScalar       RearWheel       FirstSprocket                       [myGUI::modelAdapter::get_Scalar    RearWheel FirstSprocket                ]
        ${targetNamespace}::setScalar       RearWheel       HubWidth                            [myGUI::modelAdapter::get_Scalar    RearWheel HubWidth                     ]
        ${targetNamespace}::setScalar       RearWheel       RimDiameter                         [myGUI::modelAdapter::get_Scalar    Geometry RearRim_Diameter              ]
        ${targetNamespace}::setScalar       RearWheel       RimHeight                           [myGUI::modelAdapter::get_Scalar    RearWheel RimHeight                    ]
        ${targetNamespace}::setScalar       RearWheel       TyreHeight                          [myGUI::modelAdapter::get_Scalar    Geometry RearTyre_Height               ]
        ${targetNamespace}::setScalar       RearWheel       TyreWidth                           [myGUI::modelAdapter::get_Scalar    RearWheel TyreWidth                    ]
        ${targetNamespace}::setScalar       RearWheel       TyreWidthRadius                     [myGUI::modelAdapter::get_Scalar    RearWheel TyreWidthRadius              ]
        ${targetNamespace}::setScalar       Saddle          Length                              [myGUI::modelAdapter::get_Scalar    Saddle Length                          ]
        ${targetNamespace}::setScalar       Saddle          NoseLength                          [myGUI::modelAdapter::get_Scalar    Saddle NoseLength                      ]
        ${targetNamespace}::setScalar       Saddle          Offset_x                            [myGUI::modelAdapter::get_Scalar    Saddle Offset_x                        ]
        ${targetNamespace}::setScalar       SeatStay        OffsetTT                            [myGUI::modelAdapter::get_Scalar    SeatStay OffsetTT                      ]
        ${targetNamespace}::setScalar       SeatTube        Diameter                            [myGUI::modelAdapter::get_Scalar    SeatTube DiameterTT                    ]
        ${targetNamespace}::setScalar       SeatTube        Extension                           [myGUI::modelAdapter::get_Scalar    SeatTube Extension                     ]
        ${targetNamespace}::setScalar       SeatTube        OffsetBB                            [myGUI::modelAdapter::get_Scalar    SeatTube OffsetBB                      ]
        ${targetNamespace}::setScalar       Spacer          Height                              [myGUI::modelAdapter::get_Scalar    Spacer Height                          ]
        ${targetNamespace}::setScalar       Stem            Angle                               [myGUI::modelAdapter::get_Scalar    Geometry Stem_Angle                    ]
        ${targetNamespace}::setScalar       Stem            Length                              [myGUI::modelAdapter::get_Scalar    Geometry Stem_Length                   ]        
        ${targetNamespace}::setScalar       TopTube         OffsetHT                            [myGUI::modelAdapter::get_Scalar    TopTube OffsetHT                       ]                        
            
            # --- local vars ------------------------------
            #
        set BottomBracket(Position)         [set ${targetNamespace}::Position(BottomBracket)        ]
        set FrontWheel(Position)            [set ${targetNamespace}::Position(FrontWheel)           ]
        set HeadTube(Stem)                  [set ${targetNamespace}::Position(HeadTube_End)         ]
        set Saddle(Position)                [set ${targetNamespace}::Position(Saddle)               ]
        set Position(BaseCenter)            [set ${targetNamespace}::Position(BottomBracket_Ground) ]
        set RearWheel(Position)             [set ${targetNamespace}::Position(RearWheel)            ]
        set HandleBar(Position)             [set ${targetNamespace}::Position(HandleBar)            ]
        set FrontWheel(RimDiameter)         [set ${targetNamespace}::FrontWheel(RimDiameter)        ]
        set FrontWheel(TyreHeight)          [set ${targetNamespace}::FrontWheel(TyreHeight)         ]
        set HeadSet(Diameter)               [set ${targetNamespace}::HeadSet(Diameter)              ]
        set HeadSet(polygon)                [set ${targetNamespace}::Polygon(HeadSet)               ]
        set HeadTube(polygon)               [set ${targetNamespace}::Polygon(HeadTube)              ]
        set Length(CrankSet)                [set ${targetNamespace}::CrankSet(Length)               ]
        set SeatTube(polygon)               [set ${targetNamespace}::Polygon(SeatTube)              ]
        set Steerer(Diameter)               [set ${targetNamespace}::Steerer(Diameter)              ]        
        set Steerer(Fork)                   [set ${targetNamespace}::Position(Steerer_Start)        ]        
        set Steerer(Ground)                 [set ${targetNamespace}::Position(Steerer_Ground)       ]        
            #
            
            
            # -- set Helping - Position -------------------
            #
            set vct_90  [vectormath::unifyVector                {0 0}    $FrontWheel(Position) ]
        ${targetNamespace}::setPosition     help_91             [vectormath::addVector  $BottomBracket(Position)    [vectormath::unifyVector {0 0} $vct_90 $Length(CrankSet)]]
        ${targetNamespace}::setPosition     help_92             [vectormath::addVector  $FrontWheel(Position)       [vectormath::unifyVector {0 0} $vct_90 [expr - ( 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)) ] ] ]
        ${targetNamespace}::setPosition     help_93             [vectormath::addVector  $BottomBracket(Position)    [vectormath::unifyVector $Saddle(Position) $BottomBracket(Position) $Length(CrankSet) ] ]
                
                
            # -- set Wheel - Ground - Positions -----------
            #
        ${targetNamespace}::setPosition     RearWheel_Ground    [list [lindex $RearWheel(Position)  0] [lindex $Steerer(Ground) 1] ]
        ${targetNamespace}::setPosition     FrontWheel_Ground   [list [lindex $FrontWheel(Position) 0] [lindex $Steerer(Ground) 1] ]


            # --- geometry for tubing dimension -----------
            #
            set pt_01               [coords_xy_index $HeadTube(polygon) 2 ]
            set pt_02               [coords_xy_index $HeadTube(polygon) 1 ]
            set pt_03               [coords_xy_index $HeadTube(polygon) 3 ]
            set pt_04               [coords_xy_index $HeadTube(polygon) 0 ]
        ${targetNamespace}::setVector       HeadTube_Top    [list $pt_01 $pt_02 ]
        ${targetNamespace}::setVector       HeadTube_Bottom [list $pt_03 $pt_04 ]

                #
            set pt_01               [coords_xy_index $SeatTube(polygon) 3 ]
            set pt_02               [coords_xy_index $SeatTube(polygon) 2 ]
        ${targetNamespace}::setVector       SeatTube_Top    [list $pt_01 $pt_02 ]
                #
            set   dir_01            [get_Direction  Steerer]
            set   dir_02            [vectormath::VRotate $dir_01 -90 grad ]
            set   pt_01             [vectormath::addVector        $Steerer(Fork)  $dir_02 [expr -0.5 * $Steerer(Diameter)] ]
            set   pt_02             [vectormath::addVector        $Steerer(Fork)  $dir_02 [expr  0.5 * $Steerer(Diameter)] ]
        ${targetNamespace}::setVector       Steerer_Bottom  [list $pt_01 $pt_02 ]
                #
            set   pt_01             [vectormath::addVector        $Steerer(Fork)  $dir_02 [expr -0.5 * $HeadSet(Diameter)] ]
            set   pt_02             [vectormath::addVector        $Steerer(Fork)  $dir_02 [expr  0.5 * $HeadSet(Diameter)] ]
        ${targetNamespace}::setVector       HeadSet_Bottom  [list $pt_01 $pt_02 ]
                #
            set   pt_01                 [coords_xy_index $HeadSet(polygon) 0 ]
            set   pt_02                 [coords_xy_index $HeadSet(polygon) 7 ]
        ${targetNamespace}::setVector       HeadSet_Top     [list $pt_01 $pt_02 ]
                #


            # --- additional wheel values -----------------
            #
        ${targetNamespace}::setScalar       RearWheel   Radius          [expr [lindex $RearWheel(Position)  1] - [lindex $Position(BaseCenter) 1] ]
        ${targetNamespace}::setScalar       FrontWheel  Radius          [expr [lindex $FrontWheel(Position) 1] - [lindex $Position(BaseCenter) 1] ]
            
            
            # --- set helping values ----------------------
            #
        ${targetNamespace}::setLength       Height_HB_Seat              [expr [lindex $Saddle(Position)     1] - [lindex $HandleBar(Position)  1] ]
        ${targetNamespace}::setLength       Height_HT_Seat              [expr [lindex $Saddle(Position)     1] - [lindex $HeadTube(Stem)       1] ]
        ${targetNamespace}::setLength       Length_BB_Seat              [expr [lindex $Saddle(Position)     0] - [lindex $Position(BaseCenter) 0] ]
                #
    }
    myGUI::modelAdapter::updateModel_XZ_checkSyntax
