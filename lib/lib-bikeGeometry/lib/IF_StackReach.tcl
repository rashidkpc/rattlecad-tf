    namespace eval bikeGeometry {
            #
        namespace ensemble create -command ::bikeGeometry::IF_StackReach \
                -map {
        
                        init                                init
                        
                        set_geometryIF                      set_geometryIF
                        
                        set_Component                       set_Component
                        set_Config                          set_Config
                        set_ListValue                       set_ListValue
                        set_Scalar                          set_Scalar_StackReach
                                                            
                        set_newProject                      set_newProject
                        
                        get_projectDOM                      get_projectDOM
                        get_projectStructure                get_projectStructure
                                                            
                        import_ProjectSubset                import_ProjectSubset
                                                            
                        get_Component                       get_Component
                        get_Config                          get_Config
                        get_ListValue                       get_ListValue
                        get_Scalar                          get_Scalar
                                                            
                        get_Polygon                         get_Polygon
                        get_Position                        get_Position
                        get_Profile                         get_Profile
                        get_Direction                       get_Direction
                        get_BoundingBox                     get_BoundingBox
                        get_CustomCrank                     get_CustomCrank
                        get_TubeMiter                       get_TubeMiter
                        get_CenterLine                      get_CenterLine
                                                            
                        get_NamespacePath                   get_NamespacePath
                        get_ArrayList                       get_ArrayList
                        get_PositionList                    get_PositionList
                        get_DirectionList                   get_DirectionList
                                    
                        get_ComponentDir                    get_ComponentDir 
                        get_ComponentDirectories            get_ComponentDirectories
                        get_ListBoxValues                   get_ListBoxValues 
                        
                        get_DebugGeometry                   get_DebugGeometry
                        get_domainParameters                get_domainParameters
                        
                        set_newProject                      set_newProject                        
                        
                        validate_ChainStayCenterLine        validate_ChainStayCenterLine
                                                             
                        coords_xy_index                     coords_xy_index
                                                            
                    }
                        #   get_paramComponent              get_paramComponent
    }

    proc bikeGeometry::set_Scalar_StackReach {object key value} {
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $value"
            #
            # -- check for existing parameter $object($key)
        if {[catch {array get [namespace current]::$object $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            #
            # -- check for values are mathematical values
        set newValue [bikeGeometry::check_mathValue $value] 
        if {$newValue == {}} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$value not accepted! ... $value"
            return {}
        }
            #
            # -- catch parameters that does not directly influence the model
        switch -exact $object {
            Geometry {
                    switch -exact $key {
                        {FrontWheel_Radius}             {   bikeGeometry::set_Default_FrontWheelRadius       $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_x}                  {   bikeGeometry::set_Default_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                        {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                        {HeadTube_CenterDownTube}       {   bikeGeometry::set_Default_HeadTubeCenterDownTube $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                        {Saddle_Offset_BB_ST}           {   bikeGeometry::set_Default_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Angle}                {   bikeGeometry::set_Default_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        
                        {BottomBracket_Depth}           {   bikeGeometry::set_StackReach_BottomBracketDepth  $newValue; return [get_Scalar $object $key] }
                        {BottomBracket_Height}          {   bikeGeometry::set_StackReach_BottomBracketHeight $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}                 {   bikeGeometry::set_StackReach_FrontWheeldiagonal  $newValue; return [get_Scalar $object $key] }
                        {HeadTube_Angle}                {   bikeGeometry::set_StackReach_HeadTubeDirection   $newValue; return [get_Scalar $object $key] }
                        {HeadTube_Length}               {   bikeGeometry::set_StackReach_HeadTubeLength      $newValue; return [get_Scalar $object $key] }
                        {HeadTube_Summary}              {   bikeGeometry::set_StackReach_HeadTubeSummary     $newValue; return [get_Scalar $object $key] }
                        {HeadSet_Bottom}                {   bikeGeometry::set_StackReach_HeadSetBottom       $newValue; return [get_Scalar $object $key] }
                        {Reach_Length}                  {   bikeGeometry::set_StackReach_HeadTubeReachLength $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}                   {   bikeGeometry::set_StackReach_SaddleOffset_HB_Y   $newValue; return [get_Scalar $object $key] }
                        {Stack_Height}                  {   bikeGeometry::set_StackReach_HeadTubeStackHeight $newValue; return [get_Scalar $object $key] }
                        {Stem_Length}                   {   bikeGeometry::set_StackReach_StemLength          $newValue; return [get_Scalar $object $key] }
                        {Fork_Height}                   {   bikeGeometry::set_StackReach_ForkHeight          $newValue; return [get_Scalar $object $key] }
                        
                        {SeatTube_LengthVirtual}        {   bikeGeometry::set_StackReach_SeatTubeLength      $newValue; return [get_Scalar $object $key] }
                        {TopTube_LengthVirtual}         {   bikeGeometry::set_StackReach_TopTubeLength       $newValue; return [get_Scalar $object $key] }
                        
                        
                        default {
                            puts "\n   -<W>- ::bikeGeometry::IF_StackReach: Geometry $key ... not registered\n"
                        }
                    }
                }
            RearWheel {
                    switch -exact $key {
                        {TyreShoulder}              {   bikeGeometry::set_Default_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                        
                        default {
                            puts "\n   -<W>- ::bikeGeometry::IF_StackReach: RearWheel $key ... not registered\n"
                        }
                    }
                }
            Reference {
                    switch -exact $key {
                        {SaddleNose_HB}             {   bikeGeometry::set_Default_ReferenceSaddleNose_HB $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB_y}           {   bikeGeometry::set_Default_ReferenceHeigth_SN_HB  $newValue; return [get_Scalar $object $key] }

                        default {
                            puts "\n   -<W>- ::bikeGeometry::IF_StackReach: Reference $key ... not registered\n"
                        }
                    }
                }
 
            default {
                puts "\n   -<W>- ::bikeGeometry::IF_StackReach: $object $key ... not registered\n"
            }
        }
            #
            # -- set value to parameter
        array set [namespace current]::$object [list $key $newValue]
        bikeGeometry::update_Geometry
            #
        set scalarValue [bikeGeometry::get_Scalar $object $key ]
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $scalarValue"
            #
        return $scalarValue
            #
    }
        #
        #
    proc bikeGeometry::set_StackReach_BottomBracketDepth       {value} {
                #
                # Length/HeadTube/StackHeight
                # Geometry(Stack_Height)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_StackReach_BottomBracketDepth   ... check $Geometry(BottomBracket_Depth)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(BottomBracket_Depth)}]
            set myStack                 $Geometry(Stack_Height)
            set myReach                 $Geometry(Reach_Length)

            set Geometry(BottomBracket_Depth)   $value   
            set Geometry(HandleBar_Height)      [expr {$Geometry(HandleBar_Height) + $delta}]
                #
                #
            bikeGeometry::update_Geometry
                #
            set_StackReach_HeadTubeReachLength  $myReach
            set_StackReach_HeadTubeStackHeight  $myStack
                #
            puts "    <2> set_StackReach_BottomBracketDepth   ... check $Geometry(BottomBracket_Depth)  ->  $value"
                #
            return $Geometry(BottomBracket_Depth)
                #
    }
    proc bikeGeometry::set_StackReach_BottomBracketHeight      {value} {
                #
                # Length/HeadTube/StackHeight
                # Geometry(Stack_Height)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_StackReach_BottomBracketHeight   ... check $Geometry(BottomBracket_Height)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(BottomBracket_Height)}]
            
            set myBottomBracket_Depth   [expr {$Geometry(BottomBracket_Depth) - $delta}]
                #
            set_StackReach_BottomBracketDepth $myBottomBracket_Depth    
                #
            puts "    <2> set_StackReach_BottomBracketHeight   ... check $Geometry(BottomBracket_Height)  ->  $value"
                #
            return $Geometry(BottomBracket_Height)
                #
    }
    
    proc bikeGeometry::set_StackReach_HeadTubeReachLength      {value} {
                #
                # Length/HeadTube/ReachLength
                # Geometry(Reach_Length)
                #
            variable Geometry
            variable HandleBar
                #
            puts "    <1> set_StackReach_HeadTubeReachLength   ... check $Geometry(Reach_Length) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(Reach_Length)}]
                #
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance)    + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadTubeReachLength   ... check $Geometry(Reach_Length) ->  $value"
                #
            return $Geometry(Reach_Length)
                #
    }
    proc bikeGeometry::set_StackReach_HeadTubeStackHeight      {value} {
                #
                # Length/HeadTube/StackHeight
                # Geometry(Stack_Height)
                #
            variable Geometry
            variable HeadTube
            variable HandleBar
                #
            puts "    <1> set_StackReach_HeadTubeStackHeight   ... check $Geometry(Stack_Height)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(Stack_Height)}]
  
            # set deltaHeadTube         [expr $delta / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180) ]
            set deltaHeadTube           [expr {$delta / sin([vectormath::rad $Geometry(HeadTube_Angle)])}]
            set deltaHeadTube_x         [expr {$delta / tan([vectormath::rad $Geometry(HeadTube_Angle)])}]
                #
            # set Geometry(HandleBar_Height)    [expr $Geometry(HandleBar_Height)    + $delta]
                #
            set HeadTube(Length)                [expr {$HeadTube(Length) + $deltaHeadTube}]
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance) + $deltaHeadTube_x}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadTubeStackHeight   ... check $Geometry(Stack_Height)  ->  $value"
                #
            return $Geometry(Stack_Height)
                #
    }
    proc bikeGeometry::set_StackReach_HeadTubeDirection        {value} {
                #
                # ... unused ?
                #
            variable Geometry
            variable Position
                #
            variable Fork
            variable FrontWheel
            variable HandleBar
            variable HeadTube
            variable Stem
                #
            puts "    <1> set_StackReach_HeadTubeDirection   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            set store_HeadTubeLength    $HeadTube(Length)
                #
            set store_ReachLength       $Geometry(Reach_Length)
            set store_StackHeight       $Geometry(Stack_Height)
            set store_HandleBarOffset   $Geometry(Saddle_HB_y)
                #
            set_Scalar Geometry  HeadTube_Angle $value
                #
            set_StackReach_HeadTubeStackHeight  $store_StackHeight 
            set_StackReach_HeadTubeReachLength  $store_ReachLength
                #
            set_StackReach_SaddleOffset_HB_Y    $store_HandleBarOffset
                #
            puts "    <2> set_StackReach_HeadTubeDirection   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
    }
    proc bikeGeometry::set_StackReach_HeadTubeLength           {value} {
                #
            variable Geometry
            variable HeadTube
            variable Fork
                #
            puts "    <1> set_StackReach_HeadTubeSummary   ... check $Geometry(HeadTube_Length) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(HeadTube_Length)}]
                #
            set HeadTube(Length)                [expr {$HeadTube(Length)      + $delta}]
            set Geometry(Fork_Height)           [expr {$Geometry(Fork_Height) - $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadTubeSummary   ... check $Geometry(HeadTube_Length) ->  $value"
                #
            return $Geometry(HeadTube_Length)
                #
    }
    proc bikeGeometry::set_StackReach_HeadTubeSummary          {value} {
                #
            variable Geometry
            variable HeadTube
            variable Fork
                #
            puts "    <1> set_StackReach_HeadTubeSummary   ... check $Geometry(HeadTube_Summary) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(HeadTube_Summary)}]
                #
            set HeadTube(Length)                [expr {$HeadTube(Length)      + $delta}]
            set Geometry(Fork_Height)           [expr {$Geometry(Fork_Height) - $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadTubeSummary   ... check $Geometry(HeadTube_Summary) ->  $value"
                #
            return $Geometry(HeadTube_Summary)
                #
    }
    proc bikeGeometry::set_StackReach_HeadSetBottom            {value} {
                #
            variable Geometry
            variable HeadSet
            variable HeadTube
            variable Fork
                #
            puts "    <1> set_StackReach_HeadSetBottom   ... check $Geometry(HeadSet_Bottom) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(HeadSet_Bottom)}]
                #
            set HeadTube(Length)                [expr {$HeadTube(Length)         - $delta}]
            set HeadSet(Height_Bottom)          [expr {$HeadSet(Height_Bottom)   + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_HeadSetBottom   ... check $Geometry(HeadSet_Bottom) ->  $value"
                #
            return $Geometry(HeadSet_Bottom)
                #
    }
    proc bikeGeometry::set_StackReach_FrontWheeldiagonal       {value} {
                #
                # ... unused ?
                #
            variable Geometry
            variable Position
                #
            variable Fork
            variable FrontWheel
            variable HandleBar
            variable HeadTube
            variable Stem
                #
            puts "    <1> set_StackReach_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            set store_HeadTubeLength    $HeadTube(Length)
                #
            set store_ReachLength       $Geometry(Reach_Length)
            set store_StackHeight       $Geometry(Stack_Height)
            set store_HandleBarOffset   $Geometry(Saddle_HB_y)
                #
            set dist_x      [expr {sqrt($value * $value - $Geometry(FrontWheel_y) * $Geometry(FrontWheel_y))}]
            set position    [list $dist_x $Geometry(FrontWheel_y)]
                #
            set p_ct        [vectormath::cathetusPoint   $Position(HeadTube_End)   $position   $Geometry(Fork_Rake) opposite]
            set p_01        $Position(HeadTube_End)
            set p_02        [list -100 [lindex $p_ct 1]]
                #
            set Geometry(HeadTube_Angle)    [vectormath::angle    $p_01 $p_ct $p_02 ]
                #
            bikeGeometry::update_Geometry
                #
            set_StackReach_HeadTubeStackHeight  $store_StackHeight 
            set_StackReach_HeadTubeReachLength  $store_ReachLength
                #
            set_StackReach_SaddleOffset_HB_Y    $store_HandleBarOffset
                #
            # set_Scalar     HeadTube Length      $store_HeadTubeLength    
                #
            puts "    <2> set_StackReach_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
    }
    proc bikeGeometry::set_StackReach_SaddleOffset_HB_Y        {value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
            variable HeadTube
                #
            puts "    <1> set_StackReach_SaddleOffset_HB_Y   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            set delta_y                     [expr {$Geometry(Saddle_HB_y) - $value}]
            set delta_x                     [expr {$delta_y / tan($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180)}]
                #
            set Geometry(HandleBar_Height)      [expr {$Geometry(HandleBar_Height)   + $delta_y}]
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance) - $delta_x}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_SaddleOffset_HB_Y   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }
    proc bikeGeometry::set_StackReach_StemLength               {value} {
                #
            variable Geometry
                #
            puts "    <1> set_StackReach_StemLength   ... check $Geometry(Stem_Length) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(Stem_Length)}]
                #
            set Geometry(Stem_Length)           $value
                #
            set stemAngle   [expr {90 - $Geometry(HeadTube_Angle) + $Geometry(Stem_Angle)}]
                #
            set delta_x1    [expr {$delta * cos([vectormath::rad $stemAngle])}]
            set delta_y1    [expr {$delta * sin([vectormath::rad $stemAngle])}]
            set delta_x2    [expr {$delta_y1 / tan([vectormath::rad $Geometry(HeadTube_Angle)])}]
                #
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance) + $delta_x1 + $delta_x2}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_StemLength   ... check $Geometry(Stem_Length) ->  $value"
                #
            return $Geometry(Stem_Length)
                #
    }
    
    proc bikeGeometry::set_StackReach_ForkHeight               {value} {
                #
            variable Geometry
            variable HeadTube
            variable Fork
                #
            puts "    <1> set_StackReach_ForkHeight   ... check $Geometry(Fork_Height) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(Fork_Height)}]
                #
            set HeadTube(Length)                [expr {$HeadTube(Length)      - $delta}]
            set Geometry(Fork_Height)           [expr {$Geometry(Fork_Height) + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_ForkHeight   ... check $Geometry(Fork_Height) ->  $value"
                #
            return $Geometry(HeadTube_Length)
                #
    }
    proc bikeGeometry::set_StackReach_SeatTubeLength           {value} {
                #
            variable Geometry
            variable Fork
            variable HeadTube
            variable SeatTube
                #
            puts "    <1> set_StackReach_SeatTubeLength   ... check $Geometry(SeatTube_LengthVirtual)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(SeatTube_LengthVirtual)}]
                #
            set headTubeLength          $HeadTube(Length)
                # puts "         ... \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle)"
            set offsetSeatTube_x        [expr {$delta * cos([vectormath::rad $Geometry(SeatTube_Angle)])}]
            set offsetSeatTube_y        [expr {$delta * sin([vectormath::rad $Geometry(SeatTube_Angle)])}]
                # puts "         ... \$offsetSeatTube_x $offsetSeatTube_x"
                # puts "         ... \$offsetSeatTube_y $offsetSeatTube_y"
                # puts "         ... \$Geometry(HeadTube_Angle) $Geometry(HeadTube_Angle)"
                #
            # set offsetHeadTube        [expr $offsetSeatTube_y / sin([vectormath::rad $Geometry(HeadTube_Angle)])]
            # set offsetHeadTube_x      [expr $offsetHeadTube   * cos([vectormath::rad $Geometry(HeadTube_Angle)])]
                #
            set reach_Length            [expr {$Geometry(Reach_Length) - $offsetSeatTube_x}]
            set stack_Height            [expr {$Geometry(Stack_Height) + $offsetSeatTube_y}]
                #
            set_StackReach_HeadTubeReachLength $reach_Length
            set_StackReach_HeadTubeStackHeight $stack_Height
                #
            # set HeadTube(Length)      [expr $headTubeLength - $offsetHeadTube]
                #
            # bikeGeometry::update_Geometry
                #
            set Geometry(SeatTube_LengthVirtual)      $value
                #
            puts "    <2> set_StackReach_SeatTubeLength   ... check $Geometry(SeatTube_LengthVirtual)  ->  $value"
                #
            return $Geometry(SeatTube_LengthVirtual)
                #
    }
    proc bikeGeometry::set_StackReach_TopTubeLength            {value} {
                #
            variable Geometry
                #
            puts "    <1> set_StackReach_TopTubeLength   ... check $Geometry(TopTube_LengthVirtual) ->  $value"
                #
            set delta                   [expr {$value - $Geometry(TopTube_LengthVirtual)}]
                #
            set stack_Reach             [expr {$Geometry(Reach_Length) + $delta}]
                #
            set_StackReach_HeadTubeReachLength $stack_Reach
                #
            puts "    <2> set_StackReach_TopTubeLength   ... check $Geometry(TopTube_LengthVirtual) ->  $value"
                #
            return $Geometry(TopTube_LengthVirtual)
                #
    }

    
    
    
    
    proc bikeGeometry::_set_StackReach_SeatTubeLength           {value} {
                #
            variable Geometry
            variable HeadTube
                #
            puts "    <1> set_StackReach_SeatTubeLength   ... check $Geometry(SeatTube_LengthVirtual)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(SeatTube_LengthVirtual)}]
                #
            set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $Geometry(SeatTube_Angle)]]
            set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                #
            set deltaHeadTube           [expr {[lindex $offsetSeatTube 1] / sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180)}]
            set offsetHeadTube_x        [expr {[lindex $offsetSeatTube 1] / tan($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180)}]
                #
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance)    + $offsetHeadTube_x + $offsetSeatTube_x}]
                #
            set Geometry(SeatTube_LengthVirtual)      $value
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_SeatTubeLength   ... check $Geometry(SeatTube_LengthVirtual)  ->  $value"
                #
            return $Geometry(SeatTube_LengthVirtual)
                #
    } 
    proc bikeGeometry::_set_StackReach_TopTubeLength            {value} {
                #
            variable Geometry
                #
            puts "    <1> set_StackReach_TopTubeLength   ... check $Geometry(TopTube_LengthVirtual) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(TopTube_LengthVirtual)}]
                #
            puts "  \$Geometry(HandleBar_Distance) $Geometry(HandleBar_Distance)"
                #
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance)    + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_StackReach_TopTubeLength   ... check $Geometry(TopTube_LengthVirtual) ->  $value"
                #
            return $Geometry(Stem_Length)
                #
    }
