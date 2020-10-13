 ##+##########################################################################
 #
 # package: myGUI   ->  model_XY.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/08/22
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
 #    namespace:  myGUI::model_XY
 # ---------------------------------------------------------------------------
 #
 #

    namespace eval myGUI::model::model_XY {
            #
        variable    Dictionary              ;  array set Dictionary             {}
            #
        variable    Rendering               ;  array set Rendering              {}
        variable    Reference               ;  array set Reference              {}
            #
        variable    BottomBracket           ;  array set BottomBracket          {}
        variable    ChainStay               ;  array set ChainStay              {}
        variable    DownTube                ;  array set DownTube               {}
        variable    DerailleurMount_Front   ;  array set DerailleurMount_Front  {}
        variable    Fork                    ;  array set Fork                   {}
        variable    FrameJig                ;  array set FrameJig               {}
        variable    FrontBrake              ;  array set FrontBrake             {}
        variable    FrontWheel              ;  array set FrontWheel             {}
        variable    HandleBar               ;  array set HandleBar              {}
        variable    HeadSet                 ;  array set HeadSet                {}
        variable    HeadTube                ;  array set HeadTube               {}
        variable    LegClearance            ;  array set LegClearance           {}
        variable    RearBrake               ;  array set RearBrake              {}
        variable    RearDerailleur          ;  array set RearDerailleur         {}
        variable    RearDrop                ;  array set RearDrop               {}
        variable    RearWheel               ;  array set RearWheel              {}
        variable    Saddle                  ;  array set Saddle                 {}
        variable    SaddleNose              ;  array set SaddleNose             {}
        variable    SeatPost                ;  array set SeatPost               {}
        variable    SeatStay                ;  array set SeatStay               {}
        variable    SeatTube                ;  array set SeatTube               {}
        variable    Steerer                 ;  array set Steerer                {}
        variable    Stem                    ;  array set Stem                   {}
        variable    TopTube                 ;  array set TopTube                {}
            #
        variable    CenterLine              ;  array set CenterLine             {}
        variable    Config                  ;  array set Config                 {}
        variable    Direction               ;  array set Direction              {}
        variable    Polygon                 ;  array set Polygon                {}
        variable    Profile                 ;  array set Profile                {}
        variable    Position                ;  array set Position               {}
        variable    Length                  ;  array set Length                 {}
        variable    ListValue               ;  array set ListValue              {}
        variable    Vector                  ;  array set Vector                 {}
        variable    BoundingBox             ;  array set BoundingBox            {}
            #
        variable    Component               ;  array set Component              {}
        variable    ComponentNode           ;  array set ComponentNode          {}
            #
    }
        #
        #
    proc myGUI::model::model_XY::setDictionary {key value} {
            #
        variable    Dictionary
        array set   Dictionary   [list $key $value]
            #
    }
    proc myGUI::model::model_XY::getDictionary {key} {
            #
        variable    Dictionary
        set keyValue [array get Dictionary $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
        #
    proc myGUI::model::model_XY::setBoundingBox {key value} {
            #
        variable    BoundingBox
        array set   BoundingBox  [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setCenterLine {key value} {
            #
        variable    CenterLine
        array set   CenterLine  [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setConfig {key value} {
            #
        variable    Config
        array set   Config      [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setComponent {key value} {
        variable    Component
        array set   Component       [list $key $value]
    }
        #
    proc myGUI::model::model_XY::setComponentNode {key value} {
        variable    ComponentNode
        array set   ComponentNode [list $key $value]
    }
        #
    proc myGUI::model::model_XY::setDirection {key value} {
            #
        variable    Direction
        array set   Direction   [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setLength {key value} {
            #
        variable    Length
        array set   Length      [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setListValue {key value} {
            #
        variable    ListValue
        array set   ListValue   [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setPosition {key value} {
            #
        variable    Position
        array set   Position    [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setPolygon {key value} {
            #
        variable    Polygon
        array set   Polygon     [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setProfile {key value} {
            #
        variable    Profile
        array set   Profile     [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setScalar {object key value} {
            #
        variable    BottleCage      
        variable    BottomBracket   
        variable    ChainStay       
        variable    CrankSet        
        variable    DownTube        
        variable    Fork            
        variable    FrontWheel      
        variable    Geometry        
        variable    HandleBar       
        variable    HeadSet         
        variable    HeadTube        
        variable    Lugs            
        variable    RearBrake
        variable    RearDerailleur  
        variable    RearDropout     
        variable    RearFender
        variable    RearMockup      
        variable    RearWheel       
        variable    Saddle          
        variable    SeatStay        
        variable    SeatTube        
        variable    Spacer          
        variable    Steerer          
        variable    Stem          
        variable    TopTube
            #
        array set   $object   [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::setVector {key value} {
            #
        variable    Vector
        array set   Vector  [list $key $value]
            #
    }
        #
        #
        #
        #
    proc myGUI::model::model_XY::getBoundingBox {key} {
            #
        variable    BoundingBox
        set keyValue [array get BoundingBox $key]
        foreach {key value} $keyValue break
            # puts "  -> $value"
            # parray $object
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getCenterLine {key} {
            #
        variable    CenterLine
        set keyValue [array get CenterLine $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getConfig {key} {
            #
        variable    Config
        set keyValue [array get Config $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getComponent {key} {
            #
        variable    Component
        variable    ComponentNode
        switch -exact $key {
            CrankSet -
            RearFender_XY -
            RearHub -
            RearHub_Disc -
            _any_ {
                # puts " --"
                # parray ComponentNode
                set keyValue [array get ComponentNode $key]
                foreach {key value} $keyValue break
                return $value
            }
            default {
                set keyValue [array get Component $key]
                foreach {key value} $keyValue break
                return $value
            }    
        }
            #
    }
        #
    proc myGUI::model::model_XY::getDirection {key {type {polar}}} {
            #
        variable    Direction
        set keyValue [array get Direction $key]
        foreach {key value} $keyValue break
            #
        switch -exact $type {
            degree  {   return [vectormath::localVector_2_Degree $value] }
            rad    -
            polar  -
            default {   return $value}
        }
    }
        #
    proc myGUI::model::model_XY::getLength {key} {
            #
        variable    Length
        set keyValue [array get Length $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getListValue {key} {
            #
        variable    ListValue
        set keyValue [array get ListValue $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getPosition  {key {position {0 0}}} {
        variable    Position
        set keyValue [array get Position $key]
        foreach {key value} $keyValue break
        return [vectormath::addVectorCoordList  $position  $value]
    }
        #
    proc myGUI::model::model_XY::getPolygon {key {position {0 0}}} {
            #
        variable Polygon
            #
            # parray Polygon    
            #
        set keyValue [array get Polygon $key]
        foreach {key value} $keyValue break
            #
            # puts "$object $key $position"
            # puts "$value"
        return [vectormath::addVectorCoordList  $position  $value]
            #   
    }
        #
    proc myGUI::model::model_XY::getProfile {key {position {0 0}}} {
            #
        variable Profile
            #
            # parray Polygon    
            #
        set keyValue [array get Profile $key]
        foreach {key value} $keyValue break
            #
            # puts "$object $key $position"
            # puts "$value"
        return [vectormath::addVectorCoordList  $position  $value]
            #   
    }
        #
    proc myGUI::model::model_XY::getScalar {object key} {
            #
        variable    BottleCage      
        variable    BottomBracket   
        variable    ChainStay       
        variable    CrankSet        
        variable    DownTube        
        variable    Fork            
        variable    FrontWheel      
        variable    Geometry        
        variable    HandleBar       
        variable    HeadSet         
        variable    HeadTube        
        variable    Lugs            
        variable    RearBrake  
        variable    RearDerailleur  
        variable    RearDropout     
        variable    RearFender      
        variable    RearMockup      
        variable    RearWheel       
        variable    Saddle          
        variable    SeatStay        
        variable    SeatTube        
        variable    Spacer          
        variable    Steerer
        variable    Stem          
        variable    TopTube
            #
        # puts "   \$object $object"
        # puts "   \$key    $key"
        # parray $object    
            #
        set keyValue [array get $object $key]
        foreach {key value} $keyValue break
            # parray $object
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getVector {key {position {0 0}}} {
            #
        variable    Vector
        set keyValue [array get Vector $key]
        foreach {key value} $keyValue break
            # puts "  -> $value"
            # parray $object
        return [vectormath::addVectorPointList  $position  $value]    
            #
    }
        #
        #
        #
        #
    proc myGUI::model::model_XY::add_Component {key svgNode} {
            #
        variable    ComponentCache
            #
    }
        #
    proc myGUI::model::model_XY::setComponentCache {key value} {
            #
        variable    ComponentCache
            #
        array set ComponentCache [list $key $value]
            #
    }
        #
        #
        #
        #
    proc myGUI::model::model_XY::coords_xy_index {coordlist index} {
            switch $index {
                {end} {
                      set index_y [expr [llength $coordlist] -1]
                      set index_x [expr [llength $coordlist] -2]
                    } 
                {end-1} {
                      set index_y [expr [llength $coordlist] -3]
                      set index_x [expr [llength $coordlist] -4]
                    }
                default {
                      set index_x [ expr 2 * $index ]
                      set index_y [ expr $index_x + 1 ]
                      if {$index_y > [llength $coordlist]} { return {0 0} }
                    }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }
        #
        #
        #
        #
    proc myGUI::model::model_XY::reportModel {} {
            #
        variable    Rendering    
        variable    Reference    
            #
        variable    BottomBracket
        variable    ChainStay
        variable    DownTube     
        variable    Fork         
        variable    FrameJig     
        variable    FrontBrake   
        variable    FrontWheel   
        variable    HandleBar    
        variable    HeadSet
        variable    HeadTube     
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
        variable    Config
        variable    Position     
        variable    Length       
        variable    Vector
            #
        puts "\n"
        puts " -- myGUI::model::model_XY::reportModel --"
        puts ""
        foreach arrayName {BottomBracket ChainStay Config DownTube Fork FrameJig FrontBrake FrontWheel HandleBar HeadTube LegClearance Length Position RearBrake RearDrop RearWheel Reference Rendering Saddle SaddleNose SeatPost SeatStay SeatTube Steerer Stem TopTube Vector}  {
            puts " -- $arrayName ---"
            parray $arrayName
            puts "\n"
        }  
            
            #
    }
        #
    proc myGUI::model::model_XY::compareModel {BB_Position} {
            #
        variable    Rendering    
        variable    Reference    
            #
        variable    BottomBracket
        variable    ChainStay
        variable    DownTube     
        variable    Fork         
        variable    FrameJig     
        variable    FrontBrake   
        variable    FrontWheel   
        variable    HandleBar    
        variable    HeadSet
        variable    HeadTube     
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
        variable    Config
        variable    Position     
        variable    Length       
        variable    Vector

        
            #
        puts "\n"
        puts " -- myGUI::model::model_XY::compareModel -- $BB_Position --"
        myGUI::cvCustom::updateCanvasParameter_org {} $BB_Position   
       
        
        puts "\n"
        puts " -- myGUI::model::model_XY::compareModel -- $BB_Position --"
        puts ""
        
        
            # set SeatTube(OffsetBB)     [myGUI::model::model_XY::getPosition $SeatTube(OffsetBB)           $BB_Position]
            # set DownTube(OffsetBB)     [myGUI::model::model_XY::getPosition $DownTube(OffsetBB)           $BB_Position]
        set DownTube(BBracket)           [myGUI::model::model_XY::getPosition $DownTube(BBracket)           $BB_Position]
        set DownTube(Steerer)            [myGUI::model::model_XY::getPosition $DownTube(Steerer)            $BB_Position]
        set DownTube(polygon)            [myGUI::model::model_XY::getPosition $DownTube(polygon)            $BB_Position]
        set FrontBrake(Definition)       [myGUI::model::model_XY::getPosition $FrontBrake(Definition)       $BB_Position]
        set FrontBrake(Help)             [myGUI::model::model_XY::getPosition $FrontBrake(Help)             $BB_Position]
        set FrontBrake(Mount)            [myGUI::model::model_XY::getPosition $FrontBrake(Mount)            $BB_Position]
        set FrontBrake(Shoe)             [myGUI::model::model_XY::getPosition $FrontBrake(Shoe)             $BB_Position]
        set FrontWheel(Ground)           [myGUI::model::model_XY::getPosition $FrontWheel(Ground)           $BB_Position]
        set FrontWheel(Position)         [myGUI::model::model_XY::getPosition $FrontWheel(Position)         $BB_Position]
        set HandleBar(Position)          [myGUI::model::model_XY::getPosition $HandleBar(Position)          $BB_Position]
        set HeadTube(Fork)               [myGUI::model::model_XY::getPosition $HeadTube(Fork)               $BB_Position]
        set HeadTube(Stem)               [myGUI::model::model_XY::getPosition $HeadTube(Stem)               $BB_Position]
        set HeadTube(polygon)            [myGUI::model::model_XY::getPosition $HeadTube(polygon)            $BB_Position]
        set HeadTube(vct_Bottom)         [myGUI::model::model_XY::getPosition $HeadTube(vct_Bottom)         $BB_Position]
        set HeadTube(vct_Top)            [myGUI::model::model_XY::getPosition $HeadTube(vct_Top)            $BB_Position]
        set LegClearance(Position)       [myGUI::model::model_XY::getPosition $LegClearance(Position)       $BB_Position]
        set Position(BaseCenter)         [myGUI::model::model_XY::getPosition $Position(BaseCenter)         $BB_Position]
        set Position(IS_ChainSt_SeatSt)  [myGUI::model::model_XY::getPosition $Position(IS_ChainSt_SeatSt)  $BB_Position]
        set Position(help_91)            [myGUI::model::model_XY::getPosition $Position(help_91)            $BB_Position]
        set Position(help_92)            [myGUI::model::model_XY::getPosition $Position(help_92)            $BB_Position]
        set Position(help_93)            [myGUI::model::model_XY::getPosition $Position(help_93)            $BB_Position]
        set RearBrake(Definition)        [myGUI::model::model_XY::getPosition $RearBrake(Definition)        $BB_Position]
        set RearBrake(Help)              [myGUI::model::model_XY::getPosition $RearBrake(Help)              $BB_Position]
        set RearBrake(Mount)             [myGUI::model::model_XY::getPosition $RearBrake(Mount)             $BB_Position]
        set RearBrake(Shoe)              [myGUI::model::model_XY::getPosition $RearBrake(Shoe)              $BB_Position]
        set RearWheel(Ground)            [myGUI::model::model_XY::getPosition $RearWheel(Ground)            $BB_Position]
        set RearWheel(Position)          [myGUI::model::model_XY::getPosition $RearWheel(Position)          $BB_Position]
        set Reference(HandleBar)         [myGUI::model::model_XY::getPosition $Reference(HandleBar)         $BB_Position]
        set Reference(SaddleNose)        [myGUI::model::model_XY::getPosition $Reference(SaddleNose)        $BB_Position]
        set Saddle(Position)             [myGUI::model::model_XY::getPosition $Saddle(Position)             $BB_Position]
        set Saddle(Proposal)             [myGUI::model::model_XY::getPosition $Saddle(Proposal)             $BB_Position]
        set SaddleNose(Position)         [myGUI::model::model_XY::getPosition $SaddleNose(Position)         $BB_Position]
        set SeatPost(Saddle)             [myGUI::model::model_XY::getPosition $SeatPost(Saddle)             $BB_Position]
        set SeatPost(SeatTube)           [myGUI::model::model_XY::getPosition $SeatPost(SeatTube)           $BB_Position]
        set SeatStay(End)                [myGUI::model::model_XY::getPosition $SeatStay(End)                $BB_Position]
        set SeatStay(SeatTube)           [myGUI::model::model_XY::getPosition $SeatStay(SeatTube)           $BB_Position]
        set SeatTube(BBracket)           [myGUI::model::model_XY::getPosition $SeatTube(BBracket)           $BB_Position]
        set SeatTube(Ground)             [myGUI::model::model_XY::getPosition $SeatTube(Ground)             $BB_Position]
        set SeatTube(Saddle)             [myGUI::model::model_XY::getPosition $SeatTube(Saddle)             $BB_Position]
        set SeatTube(TopTube)            [myGUI::model::model_XY::getPosition $SeatTube(TopTube)            $BB_Position]
        set SeatTube(polygon)            [myGUI::model::model_XY::getPosition $SeatTube(polygon)            $BB_Position]
        set SeatTube(vct_Top)            [myGUI::model::model_XY::getPosition $SeatTube(vct_Top)            $BB_Position]
        set Steerer(End)                 [myGUI::model::model_XY::getPosition $Steerer(End)                 $BB_Position]
        set Steerer(Fork)                [myGUI::model::model_XY::getPosition $Steerer(Fork)                $BB_Position]
        set Steerer(Ground)              [myGUI::model::model_XY::getPosition $Steerer(Ground)              $BB_Position]
        set Steerer(Start)               [myGUI::model::model_XY::getPosition $Steerer(Start)               $BB_Position]
        set Steerer(Stem)                [myGUI::model::model_XY::getPosition $Steerer(Stem)                $BB_Position]
        set Steerer(vct_Bottom)          [myGUI::model::model_XY::getPosition $Steerer(vct_Bottom)          $BB_Position]
        set TopTube(SeatClassic)         [myGUI::model::model_XY::getPosition $TopTube(SeatClassic)         $BB_Position]
        set TopTube(SeatTube)            [myGUI::model::model_XY::getPosition $TopTube(SeatTube)            $BB_Position]
        set TopTube(SeatVirtual)         [myGUI::model::model_XY::getPosition $TopTube(SeatVirtual)         $BB_Position]
        set TopTube(Steerer)             [myGUI::model::model_XY::getPosition $TopTube(Steerer)             $BB_Position]
        set TopTube(polygon)             [myGUI::model::model_XY::getPosition $TopTube(polygon)             $BB_Position]
        
        set compareStatus 1
        
        foreach arrayName {BottomBracket Config ChainStay DownTube Fork FrameJig FrontBrake FrontWheel HandleBar HeadTube LegClearance Length Position RearBrake RearDrop RearWheel Reference Rendering Saddle SaddleNose SeatPost SeatStay SeatTube Steerer Stem TopTube Vector}  {
            puts " -- $arrayName ---"
            set lsort [array names $arrayName]
            foreach key [lsort [array names $arrayName]] {
                foreach {_key _value} [array get $arrayName $key] break
                puts [format {         model: %-25s ... %s} $_key $_value]
                foreach {__key __value} [array get myGUI::cvCustom::$arrayName $key] break
                if {$_value ne $__value} {
                    puts [format {       --- org: %-25s ... %s} $__key $__value]
                    puts [format {       --> %s(%s)} $arrayName $_key]
                    set compareStatus 0
                } else {
                    puts [format {           org: %-25s ... %s} $__key $__value]
                }
                
            }
            puts "\n"
        }

        if $compareStatus {
            puts "\n    ... not OK!\n"
        }
        # exit
    }
    
        #
    proc myGUI::model::model_XY::unset_Position {} {
          # removes all position settings of any canvas 
	    variable  Position
        array unset Position
    }
        #
        #
        #
        #
    proc myGUI::model::model_XY::getPosition_old {object key position} {
        return [getPolygon_org $object $key $position]
    }
    proc myGUI::model::model_XY::getPolygon_org {object key position} {
            #
        set geoObject [getValue $object $key]
            #
            # puts "    -> \$geoObject $geoObject"
        set p_list $geoObject
            # puts "   <D> -- $p_list"
        set listType {point}
        if {[llength $p_list] > 1} {
            if {[llength [lindex $p_list 0]] == 1} {
                # set p_list [list $p_list]
                set listType {flat}
            }
        }
            # puts "   <D> -- $listType -- $p_list "
            #
        set geoObject $p_list
        
        if {$listType eq {point}} {
            return [ vectormath::addVectorPointList  $position  $geoObject]
        } else {
            return [ vectormath::addVectorCoordList  $position  $geoObject]
        }
    
    }
        #
        #
    proc myGUI::model::model_XY::getPolygon_keep {object key position} {
            #           
        set geoObject [getValue $object $key]
            #
            # puts "    -> \$geoObject $geoObject"
        set p_list $geoObject
            # puts "   <D> -- $p_list"
        set listType {point}
        if {[llength $p_list] > 1} {
            if {[llength [lindex $p_list 0]] == 1} {
                # set p_list [list $p_list]
                set listType {flat}
            }
        }
            # puts "   <D> -- $listType -- $p_list "
            #
        set geoObject $p_list
        
        if {$listType eq {point}} {
            return [ vectormath::addVectorPointList  $position  $geoObject]
        } else {
            return [ vectormath::addVectorCoordList  $position  $geoObject]
        }
    
    }
        #
    proc myGUI::model::model_XY::setValue_ {object key value} {
            #
        variable    BottomBracket
        variable    CrankSet
        variable    ChainStay
        variable    Config
        variable    DerailleurMount_Front
        variable    DownTube
        variable    Fork
        variable    FrontBrake
        variable    FrontWheel
        variable    HandleBar
        variable    HeadSet
        variable    HeadTube
        variable    LegClearance
        variable    Length
        variable    Position
        variable    RearBrake
        variable    RearDerailleur
        variable    RearDrop
        variable    RearWheel
        variable    Reference
        variable    Saddle
        variable    SaddleNose
        variable    SeatPost
        variable    SeatStay
        variable    SeatTube
        variable    Steerer
        variable    Stem
        variable    TopTube
            #
            # variable    Angle
            # variable    DraftingColor        
            # variable    FrameJig
            # variable    Rendering
            # variable    Vector
            #
        array set   $object   [list $key $value]
            #
    }
        #
    proc myGUI::model::model_XY::getValue_ {object key} {
            #
        variable    Rendering    
        variable    Reference    
            #
        variable    BottomBracket
        variable    ChainStay
        variable    Component
        variable    CrankSet
        variable    DerailleurMount_Front     
        variable    DownTube     
        variable    Fork         
        variable    FrameJig     
        variable    FrontBrake   
        variable    FrontWheel   
        variable    HandleBar    
        variable    HeadSet
        variable    HeadTube     
        variable    LegClearance 
        variable    RearBrake    
        variable    RearDerailleur
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
        variable    Config
        variable    Position     
        variable    Length       
        variable    Vector
            #
            #
        set keyValue [array get $object $key]
        foreach {key value} $keyValue break
            # parray $object
        return $value
            #
    }
        #
    proc myGUI::model::model_XY::getPosition_2  {key {position {0 0}}} {
        set geoObject [getValue Position $key]
        return [vectormath::addVectorCoordList  $position  $geoObject]
    }
   
    