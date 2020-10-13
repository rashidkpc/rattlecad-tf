    namespace eval bikeGeometry {
            #
        namespace ensemble create -command ::bikeGeometry::IF_Classic \
                -map {
                        
                        init                                init
                        
                        set_geometryIF                      set_geometryIF
                        
                        set_Component                       set_Component
                        set_Config                          set_Config
                        set_ListValue                       set_ListValue
                        set_Scalar                          set_Scalar_Classic
                                                            
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

    proc bikeGeometry::set_Scalar_Classic {object key value} {
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
                        {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                            
                        {Saddle_Offset_BB_ST}           {   return [get_Scalar $object $key] }  
                        {FrontWheel_x}                  {   return [get_Scalar $object $key] }  
                            
                        {Reach_Length}                  {   return [get_Scalar $object $key] }  
                        {Stack_Height}                  {   return [get_Scalar $object $key] }  
                            
                        {BottomBracket_Depth}           {   bikeGeometry::set_StackReach_BottomBracketDepth  $newValue; return [get_Scalar $object $key] }
                        {BottomBracket_Height}          {   bikeGeometry::set_StackReach_BottomBracketHeight $newValue; return [get_Scalar $object $key] }
                        {Stem_Length}                   {   bikeGeometry::set_StackReach_StemLength          $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}                   {   bikeGeometry::set_StackReach_SaddleOffset_HB_Y   $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}                 {   bikeGeometry::set_StackReach_FrontWheeldiagonal  $newValue; return [get_Scalar $object $key] }
                         
                        {SeatTube_Angle}                {   bikeGeometry::set_Classic_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        {SeatTube_LengthClassic}        {   bikeGeometry::set_Classic_SeatTubeLength         $newValue; return [get_Scalar $object $key] }
                        {TopTube_LengthClassic}         {   bikeGeometry::set_Classic_TopTubeLength          $newValue; return [get_Scalar $object $key] }
                        {HeadTube_CenterTopTube}        {   bikeGeometry::set_Classic_HeadTubeCenterTopTube  $newValue; return [get_Scalar $object $key] }
                        {HeadTube_CenterDownTube}       {   bikeGeometry::set_Default_HeadTubeCenterDownTube $newValue; return [get_Scalar $object $key] }
                        
                        {HeadTube_Length}               {   bikeGeometry::set_StackReach_HeadTubeLength      $newValue; return [get_Scalar $object $key] }
                        {HeadTube_Summary}              {   bikeGeometry::set_StackReach_HeadTubeSummary     $newValue; return [get_Scalar $object $key] }
                        {HeadSet_Bottom}                {   bikeGeometry::set_StackReach_HeadSetBottom       $newValue; return [get_Scalar $object $key] }
                        {Fork_Height}                   {   bikeGeometry::set_StackReach_ForkHeight          $newValue; return [get_Scalar $object $key] }
                        
                        {__SeatTube_Virtual}            {   bikeGeometry::set_Classic_SeatTubeVirtualLength  $newValue; return [get_Scalar $object $key] }
                        {__TopTube_Virtual}             {   bikeGeometry::set_Classic_TopTubeVirtualLength   $newValue; return [get_Scalar $object $key] }
                        {__HeadTube_Virtual}            {   bikeGeometry::set_Classic_HeadTubeVirtualLength  $newValue; return [get_Scalar $object $key] }
                        
                        
                        default {
                            puts "\n   -<W>- ::bikeGeometry::IF_Classic: Geometry $key ... not registered\n"
                        }
                    }
                }
            RearWheel {
                    switch -exact $key {
                        {TyreShoulder}              {   bikeGeometry::set_Default_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                        
                        default {
                            puts "\n   -<W>- ::bikeGeometry::IF_Classic: RearWheel $key ... not registered\n"
                        }
                    }
                }

            default {
                puts "\n   -<W>- ::bikeGeometry::IF_Classic: $object $key ... not registered\n"
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
    proc bikeGeometry::set_Classic_SeatTubeLength           {value} {
                #
            variable Geometry
            variable Fork
            variable HeadTube
            variable SeatTube
                #
            puts "    <1> set_Classic_SeatTubeLength   ... check $Geometry(SeatTube_LengthClassic)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(SeatTube_LengthClassic)}]
                #
            set forkHeight              $Geometry(Fork_Height)
                
                # puts "         ... \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle)"
            set offsetSeatTube_x        [expr {$delta * cos([vectormath::rad $Geometry(SeatTube_Angle)])}]
            set offsetSeatTube_y        [expr {$delta * sin([vectormath::rad $Geometry(SeatTube_Angle)])}]
                # puts "         ... \$offsetSeatTube_x $offsetSeatTube_x"
                # puts "         ... \$offsetSeatTube_y $offsetSeatTube_y"
                # puts "         ... \$Geometry(HeadTube_Angle) $Geometry(HeadTube_Angle)"
                #
            set offsetHeadTube          [expr {$offsetSeatTube_y / sin([vectormath::rad $Geometry(HeadTube_Angle)])}]
                #
            set reach_Length            [expr {$Geometry(Reach_Length) - $offsetSeatTube_x}]
            set stack_Height            [expr {$Geometry(Stack_Height) + $offsetSeatTube_y}]
                #
            set_StackReach_HeadTubeReachLength $reach_Length
            set_StackReach_HeadTubeStackHeight $stack_Height
                #
            bikeGeometry::update_Geometry
                #
            set Geometry(SeatTube_LengthClassic)      $value
                #
            puts "    <2> set_Classic_SeatTubeLength   ... check $Geometry(SeatTube_LengthClassic)  ->  $value"
                #
            return $Geometry(SeatTube_LengthClassic)
                #
    }
    proc bikeGeometry::set_Classic_TopTubeLength            {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_TopTubeLength   ... check $Geometry(TopTube_LengthClassic) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(TopTube_LengthClassic)}]
                #
                # puts "  \$Geometry(HandleBar_Distance) $Geometry(HandleBar_Distance)"
                #
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance)    + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Classic_TopTubeLength   ... check $Geometry(TopTube_LengthClassic) ->  $value"
                #
            return $Geometry(TopTube_LengthClassic)
                #
    }
    proc bikeGeometry::set_Classic_SeatTubeDirection        {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_SeatTubeDirection   ... check $Geometry(SeatTube_Angle) ->  $value"
                #
            set topTubeClassic                  $Geometry(TopTube_LengthClassic)
                #
            set_Default_SeatTubeDirection       $value
                #
            set_Classic_TopTubeLength           $topTubeClassic
                #
            puts "    <2> set_Classic_SeatTubeDirection   ... check $Geometry(SeatTube_Angle) ->  $value"
                #
            return $Geometry(SeatTube_Angle)
                #    
    }
    
    proc bikeGeometry::set_Classic_HeadTubeCenterTopTube    {value} {
                #
            variable Geometry
            variable HeadTube
            variable TopTube
                #
            puts "    <1> set_Classic_HeadTubeCenterTopTube   ... check $Geometry(HeadTube_CenterTopTube) ->  $value"
                #
            set delta                   [expr {$value - $Geometry(HeadTube_CenterTopTube)}]
                #
                # puts "         ... \$Geometry(HeadTube_Angle) $Geometry(HeadTube_Angle)"
            set offsetHeadTube_x        [expr {$delta   * cos([vectormath::rad $Geometry(HeadTube_Angle)])}]
            set offsetHeadTube_y        [expr {$delta   * sin([vectormath::rad $Geometry(HeadTube_Angle)])}]
                # puts "         ... \$offsetHeadTube_x $offsetHeadTube_x"
                # puts "         ... \$offsetHeadTube_y $offsetHeadTube_y"
                # puts "         ... \$Geometry(HeadTube_Angle) $Geometry(HeadTube_Angle)"
                #
            set HeadTube(Length)                [expr {$HeadTube(Length)                + $delta}]
            set TopTube(OffsetHT)               [expr {$TopTube(OffsetHT)               + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            set Geometry(HeadTube_CenterTopTube)    $value
                #
            puts "    <2> set_Classic_HeadTubeCenterTopTube   ... check $Geometry(HeadTube_CenterTopTube) ->  $value"
                #
            return $Geometry(HeadTube_CenterTopTube)
                #    
    }

    
    proc bikeGeometry::set_Classic_SeatTubeVirtualLength    {value} {
                #
            variable Geometry
            variable HeadTube
                #
            puts "    <1> set_Classic_SeatTubeVirtualLength   ... check $Geometry(SeatTube_LengthVirtual)  ->  $value"
                #
            set delta                   [expr {$value - $Geometry(SeatTube_LengthVirtual)}]
                #
            set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr {180 - $Geometry(SeatTube_Angle)}]]
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
            puts "    <2> set_Classic_SeatTubeVirtualLength   ... check $Geometry(SeatTube_LengthVirtual)  ->  $value"
                #
            return $Geometry(SeatTube_LengthVirtual)
                #
    } 
    proc bikeGeometry::set_Classic_TopTubeVirtualLength     {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_TopTubeVirtualLength   ... check $Geometry(TopTube_LengthVirtual) ->  $value"
                #
            set delta                           [expr {$value - $Geometry(TopTube_LengthVirtual)}]
                #
            puts "  \$Geometry(HandleBar_Distance) $Geometry(HandleBar_Distance)"
                #
            set Geometry(HandleBar_Distance)    [expr {$Geometry(HandleBar_Distance)    + $delta}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Classic_TopTubeVirtualLength   ... check $Geometry(TopTube_LengthVirtual) ->  $value"
                #
            return $Geometry(Stem_Length)
                #
    }
    proc bikeGeometry::set_Classic_HeadTubeVirtualLength    {value} {
                #
            variable Geometry
                #
            puts "    <1> set_Classic_HeadTubeVirtualLength   ... check $Geometry(HeadTube_Virtual) ->  $value"
                #
            set delta_ht                        [expr {$value - $Geometry(HeadTube_Virtual)}]
                #
            set delta_y                         [expr {$delta_ht * sin($Geometry(HeadTube_Angle) * $vectormath::CONST_PI / 180)}]
                #
            set delta_st                        [expr {$delta_y  / sin($Geometry(SeatTube_Angle) * $vectormath::CONST_PI / 180)}]
                #
            set Geometry(SeatTube_LengthVirtual)      [expr {$Geometry(SeatTube_LengthVirtual) + $delta_st}]
                #
            bikeGeometry::update_Geometry
                #
            puts "    <2> set_Classic_HeadTubeVirtualLength   ... check $Geometry(HeadTube_Virtual) ->  $value"
                #
            return $Geometry(HeadTube_Virtual)
                #    
    }
    
    
    