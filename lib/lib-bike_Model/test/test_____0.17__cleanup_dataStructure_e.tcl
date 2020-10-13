  
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
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   tdom
    package require   bikeModel
    # package require   vectormath
    # package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
    # bikeModel::init
        # bikeModel::report_Namespace
    
    
        #
    puts "\n -- dataCleanup -- start --\n"
        #
    variable dataRoot
        #
    set xmlFile [file join $BASE_Dir etc dataModel.xml]
    puts "   \$xmlFile ......... $xmlFile"
        set fp              [open $xmlFile]
        fconfigure          $fp -encoding utf-8
        set xmlContent      [read $fp]
        close               $fp
            #
        set dataDoc         [dom parse $xmlContent]
        set dataRoot        [$dataDoc documentElement]         
        #
    puts [$dataRoot asXML] 

        #
    puts "\n -- bikeFrame -- mapping --\n"
        #
    proc cleanup_dataModel {} {
            #
        variable dataRoot    
            #
        set currentDict {
            BottomBracket/Position/Origin         BottomBracket/Position/Origin
            BottomBracket/Scalar/DiameterInside   BottomBracket/Scalar/DiameterInside
            BottomBracket/Scalar/DiameterOutside  BottomBracket/Scalar/DiameterOutside
            BottomBracket/Scalar/OffsetCS_TopView BottomBracket/Scalar/OffsetCS_TopView
            BottomBracket/Scalar/Width            BottomBracket/Scalar/Width
            ChainStay/Config/Type                 ChainStay/Config/Type
            ChainStay/Scalar/DiameterSS           ChainStay/Scalar/DiameterSS
            ChainStay/Scalar/Height               ChainStay/Scalar/Height
            ChainStay/Scalar/HeightBB             ChainStay/Scalar/HeightBB
            ChainStay/Scalar/LengthTaper          ChainStay/Scalar/TaperLength
            ChainStay/Scalar/OffsetDO             RearDropout/Scalar/OffsetCS
            ChainStay/Scalar/OffsetDOPerp         RearDropout/Scalar/OffsetCSPerp
            ChainStay/Scalar/OffsetDOTopView      RearDropout/Scalar/OffsetCS_TopView
            ChainStay/Scalar/WidthBB              ChainStay/Scalar/WidthBB
            ChainStay/Scalar/completeLength       ChainStay/Scalar/completeLength
            ChainStay/Scalar/cuttingLeft          ChainStay/Scalar/cuttingLeft
            ChainStay/Scalar/cuttingLength        ChainStay/Scalar/Length
            ChainStay/Scalar/profile_x01          ChainStay/Scalar/profile_x01
            ChainStay/Scalar/profile_x02          ChainStay/Scalar/profile_x02
            ChainStay/Scalar/profile_x03          ChainStay/Scalar/profile_x03
            ChainStay/Scalar/profile_y00          ChainStay/Scalar/profile_y00
            ChainStay/Scalar/profile_y01          ChainStay/Scalar/profile_y01
            ChainStay/Scalar/profile_y02          ChainStay/Scalar/profile_y02
            ChainStay/Scalar/segmentAngle_01      ChainStay/Scalar/segmentAngle_01
            ChainStay/Scalar/segmentAngle_02      ChainStay/Scalar/segmentAngle_02
            ChainStay/Scalar/segmentAngle_03      ChainStay/Scalar/segmentAngle_03
            ChainStay/Scalar/segmentAngle_04      ChainStay/Scalar/segmentAngle_04
            ChainStay/Scalar/segmentLength_01     ChainStay/Scalar/segmentLength_01
            ChainStay/Scalar/segmentLength_02     ChainStay/Scalar/segmentLength_02
            ChainStay/Scalar/segmentLength_03     ChainStay/Scalar/segmentLength_03
            ChainStay/Scalar/segmentLength_04     ChainStay/Scalar/segmentLength_04
            ChainStay/Scalar/segmentRadius_01     ChainStay/Scalar/segmentRadius_01
            ChainStay/Scalar/segmentRadius_02     ChainStay/Scalar/segmentRadius_02
            ChainStay/Scalar/segmentRadius_03     ChainStay/Scalar/segmentRadius_03
            ChainStay/Scalar/segmentRadius_04     ChainStay/Scalar/segmentRadius_04
            DownTube/Direction/XZ                 DownTube/Direction/XZ
            DownTube/Polygon/MiterEnd             DownTube/Polygon/MiterEnd
            DownTube/Polygon/MiterEndBBInside     DownTube/Polygon/MiterEndBBInside
            DownTube/Polygon/MiterEndBBOutside    DownTube/Polygon/MiterEndBBOutside
            DownTube/Polygon/MiterOrigin          DownTube/Polygon/MiterOrigin
            DownTube/Polygon/Shape_XZ             DownTube/Polygon/Shape_XZ
            DownTube/Polyline/CenterLine_XZ       DownTube/Polyline/CenterLine_XZ
            DownTube/Position/Edge_HeadTube_DT    DownTube/Position/Edge_HeadTube_DT
            DownTube/Position/End                 DownTube/Position/End
            DownTube/Position/Origin              DownTube/Position/Origin
            DownTube/Profile/XY                   DownTube/Profile/XY
            DownTube/Profile/XZ                   DownTube/Profile/XZ
            DownTube/Scalar/DiameterBB            DownTube/Scalar/DiameterEnd
            DownTube/Scalar/DiameterHT            DownTube/Scalar/DiameterOrigin
            DownTube/Scalar/LengthTaper           DownTube/Scalar/TaperLength
            DownTube/Scalar/OffsetBB              DownTube/Scalar/OffsetBB
            DownTube/Scalar/OffsetHT              Geometry/Scalar/DownTube_OffsetHT
            HeadTube/Config/Type                  HeadTube/Config/Type
            HeadTube/Direction/XZ                 HeadTube/Direction/XZ
            HeadTube/Polygon/Shape_XZ             HeadTube/Polygon/Shape_XZ
            HeadTube/Polyline/CenterLine_XZ       HeadTube/Polyline/CenterLine_XZ
            HeadTube/Position/Edge_Back_Bottom    HeadTube/Position/Edge_Back_Bottom
            HeadTube/Position/Edge_Back_Top       HeadTube/Position/Edge_Back_Top
            HeadTube/Position/Edge_Front_Bottom   HeadTube/Position/Edge_Front_Bottom
            HeadTube/Position/Edge_Front_Top      HeadTube/Position/Edge_Front_Top
            HeadTube/Position/End                 HeadTube/Position/End
            HeadTube/Position/Origin              HeadTube/Position/Origin
            HeadTube/Position/VirtualTopTube      HeadTube/Position/VirtualTopTube
            HeadTube/Profile/XY                   HeadTube/Profile/XY
            HeadTube/Profile/XZ                   HeadTube/Profile/XZ
            HeadTube/Scalar/Angle                 Geometry/Scalar/HeadTube_Angle
            HeadTube/Scalar/Diameter              HeadTube/Scalar/Diameter
            HeadTube/Scalar/DiameterTaperedBase   HeadTube/Scalar/DiameterTaperedBase
            HeadTube/Scalar/DiameterTaperedTop    HeadTube/Scalar/DiameterTaperedTop
            HeadTube/Scalar/HeightTaperedBase     HeadTube/Scalar/HeightTaperedBase
            HeadTube/Scalar/Length                HeadTube/Scalar/Length
            HeadTube/Scalar/LengthTaper           HeadTube/Scalar/LengthTapered
            RearDropout/Config/File               RearDropout/Config/ComponentKey
            RearDropout/Config/Orientation        RearDropout/Config/Orient
            RearDropout/Direction/XZ              RearDropout/Direction/XZ
            RearDropout/Position/Origin           RearDropout/Position/Origin
            RearDropout/Scalar/Angle              RearDropout/Scalar/Angle
            RearDropout/Scalar/Angle_Tolerance    RearDropout/Scalar/Angle_Tolerance
            RearDropout/Scalar/Derailleur_x       RearDropout/Scalar/Derailleur_X
            RearDropout/Scalar/Derailleur_y       RearDropout/Scalar/Derailleur_Y
            RearDropout/Scalar/RotationOffset     RearDropout/Scalar/RotationOffset
            SeatStay/Direction/XZ                 SeatStay/Direction/XZ
            SeatStay/Polygon/MiterEnd             SeatStay/Polygon/MiterEnd
            SeatStay/Polygon/Shape_XZ             SeatStay/Polygon/Shape_XZ
            SeatStay/Polyline/CenterLine_XZ       SeatStay/Polyline/CenterLine_XZ
            SeatStay/Position/End                 SeatStay/Position/End
            SeatStay/Position/IS_ChainStay        SeatStay/Position/IS_ChainStay
            SeatStay/Position/Origin              SeatStay/Position/Origin
            SeatStay/Profile/XY                   SeatStay/Profile/XY
            SeatStay/Profile/XZ                   SeatStay/Profile/XZ
            SeatStay/Scalar/DiameterCS            SeatStay/Scalar/DiameterOrigin
            SeatStay/Scalar/DiameterST            SeatStay/Scalar/DiameterEnd
            SeatStay/Scalar/LengthTaper           SeatStay/Scalar/TaperLength
            SeatStay/Scalar/OffsetDO              SeatStay/Scalar/MiterOffsetOrigin
            SeatStay/Scalar/OffsetDOPerp          RearDropout/Scalar/OffsetSSPerp
            SeatStay/Scalar/OffsetTT              SeatStay/Scalar/OffsetTT
            SeatTube/Direction/XZ                 SeatTube/Direction/XZ
            SeatTube/Polygon/MiterEnd             SeatTube/Polygon/MiterEnd
            SeatTube/Polygon/MiterEndBBInside     SeatTube/Polygon/MiterEndBBInside
            SeatTube/Polygon/MiterEndBBOutside    SeatTube/Polygon/MiterEndBBOutside
            SeatTube/Polygon/Shape_XZ             SeatTube/Polygon/Shape_XZ
            SeatTube/Polyline/CenterLine_XZ       SeatTube/Polyline/CenterLine_XZ
            SeatTube/Position/ClassicTopTube      SeatTube/Position/ClassicTopTube
            SeatTube/Position/Edge_Top_Front      SeatTube/Position/Edge_Top_Front
            SeatTube/Position/End                 SeatTube/Position/End
            SeatTube/Position/Ground              SeatTube/Position/Ground
            SeatTube/Position/Origin              SeatTube/Position/Origin
            SeatTube/Position/Saddle              SeatTube/Position/Saddle
            SeatTube/Position/SeatPost            SeatPost/Position/SeatTube
            SeatTube/Position/VirtualTopTube      SeatTube/Position/VirtualTopTube
            SeatTube/Profile/XY                   SeatTube/Profile/XY
            SeatTube/Profile/XZ                   SeatTube/Profile/XZ
            SeatTube/Scalar/DiameterBB            SeatTube/Scalar/DiameterEnd
            SeatTube/Scalar/DiameterTT            SeatTube/Scalar/DiameterOrigin
            SeatTube/Scalar/LengthExtension       SeatTube/Scalar/Extension
            SeatTube/Scalar/LengthTaper           SeatTube/Scalar/TaperLength
            SeatTube/Scalar/MiterAngelEnd         SeatTube/Scalar/MiterAngelEnd
            SeatTube/Scalar/OffsetBB              SeatTube/Scalar/OffsetBB
            TopTube/Direction/XZ                  TopTube/Direction/XZ
            TopTube/Polygon/MiterEnd              TopTube/Polygon/MiterEnd
            TopTube/Polygon/MiterOrigin           TopTube/Polygon/MiterOrigin
            TopTube/Polygon/Shape_XZ              TopTube/Polygon/Shape_XZ
            TopTube/Polyline/CenterLine_XZ        TopTube/Polyline/CenterLine_XZ
            TopTube/Position/Edge_HeadTube_TT     TopTube/Position/Edge_HeadTube_TT
            TopTube/Position/Edge_SeatTube_ST     TopTube/Position/Edge_SeatTube_ST
            TopTube/Position/Edge_TaperTop_HT     TopTube/Position/Edge_TaperTop_HT
            TopTube/Position/Edge_TaperTop_ST     TopTube/Position/Edge_TaperTop_ST
            TopTube/Position/End                  TopTube/Position/End
            TopTube/Position/Origin               TopTube/Position/Origin
            TopTube/Profile/XY                    TopTube/Profile/XY
            TopTube/Profile/XZ                    TopTube/Profile/XZ
            TopTube/Scalar/Angle                  Geometry/Scalar/SeatTube_Angle
            TopTube/Scalar/DiameterHT             TopTube/Scalar/DiameterOrigin
            TopTube/Scalar/DiameterST             TopTube/Scalar/DiameterEnd
            TopTube/Scalar/LengthTaper            TopTube/Scalar/TaperLength
            TopTube/Scalar/MiterAngleEnd          TopTube/Scalar/MiterAngleEnd
            TopTube/Scalar/MiterAngleOrigin       TopTube/Scalar/MiterAngleOrigin
            TopTube/Scalar/OffsetHT               Geometry/Scalar/TopTube_OffsetHT    
        }
            #
        set myObject        [[::bikeFrame::FrameFactory new] create]
            #
        set targetKeyList   [$myObject getInitKeys]
            #
        foreach targetKey $targetKeyList {
            puts "      -> $targetKey"
        }
            #
        puts [lsearch -exact $targetKeyList BottomBracket/Position/Origin]
        puts [lsearch -exact $targetKeyList DownTube/Polygon/MiterEndBBOutside]
            # exit    
            #
        dict for {targetKey sourceKey} $currentDict {
                #
            # puts "   -> $targetKey" 
            # puts "            -> $sourceKey"
                #
            set listIndex   [lsearch -exact $targetKeyList $targetKey]
                # puts "             -> $listIndex"
                #
            if {$listIndex < 0} {
                puts "           ... not found: $listIndex -> $targetKey"
                foreach {obj type key} $targetKey break
                set myNode [$dataRoot selectNodes /root/$targetKey]
                # puts "  -> [$myNode asXML]"
                $myNode setAttribute frameKey {}
            } else {
                # puts "           ... found:  $sourceKey -> $targetKey"
            }
        }
            #
        puts [$dataRoot asXML] 
            #
        exit
            #
    }
        
    cleanup_dataModel  

        #
    puts [$dataRoot asXML] 




exit


    
        #
        # return
        #
    puts "\n\n  ----- attributes -----------------   \n\n"
        #
    set nodeList [$dataRoot selectNodes */*/*]
    set nodeDict {}
        #
    foreach modelNode $nodeList {
        # set dataXPath  [$modelNode toXPath]
        # set dataPath   [string map {/root/ {}} $dataXPath]
        # puts "    <I> $dataPath [$modelNode asXML]"
        foreach attrName [$modelNode attributes] {
            set attrValue [$modelNode getAttribute $attrName]
            # puts "          ->  $attrName -> $attrValue"
            dict set nodeDict $attrName $attrValue
            # $modelNode removeAttribute $attrName
        }
            #
            # appUtil::pdict $nodeDict
            #
        set value_init          [dict get $nodeDict init]
        set value_projectXML    [dict get $nodeDict projectXML]
        set value_geometryKey   [dict get $nodeDict geometryKey]
            #
        # puts "    -> \$value_init $value_init"    
        # puts "    -> \$value_projectXML $value_projectXML"    
        # puts "    -> \$value_geometryKey $value_geometryKey"    
            #
        if {$value_projectXML ne {}} {
            puts [format {    <%d> <%-30s> <%-30s>} $value_init $value_projectXML $value_geometryKey]
        }
            
    }    
        
    return    
   
    puts "\n\n  ----- content -----------------   \n\n"
    
    puts [$dataRoot asXML]
    
    
    exit
    
    
    
    
    
    
    
    
    
    
    
    
    if 0 {
 
        foreach attrName {init projectXML geometryKey componentKey frameKey} {
            set attrValue [dict get $nodeDict $attrName]
            puts "          ->  $attrName -> $attrValue"
            $modelNode setAttribute $attrName $attrValue
        } 
        foreach attrName [$modelNode attributes] {
            puts "          ->  $attrName"
            switch -exact $attrName {
                init -
                guiKey -
                guiDictKey -
                persistKey -
                _any_ {}
                default { 
                        # puts "          ->  $attrName     <- $attrValue"
                        $modelNode removeAttribute $attrName
                    }
            }
        }
        
    }