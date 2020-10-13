  
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
    package require   bikeFacade
    # package require   vectormath
    # package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
    bikeFacade::init
        # bikeFacade::report_Namespace
    
    puts "  -> ::bikeFacade::obj_Steerer"
    set myObject [::bikeFacade::get__Object init Steerer]
    puts "    -> $myObject"
    set newValue [$myObject  setValue   Scalar Diameter 35]
    puts "      -> $newValue"    
    set newValue [$myObject  setValue   Scalar Diameter 35.2]
    puts "      -> $newValue"
            #
    puts "\n -- Diameter 35,2 \n"
    set newValue [$myObject  setValue   Scalar Diameter 35,2]
    puts "      -> $newValue"    
    
        # bikeFacade::report_Namespace
    
    if 0 {
        puts "\n -- Diameter_2 35\n"
        if {[catch {set newValue [$myObject  setValue   Scalar Diameter_2 35]} eID]} {
            puts "          Fail: $eID"
        } else {
            puts "          ... well done"
        }
    }
    
    if 0 {
            #
        puts " -- dataCleanup --"
        set initRoot [bikeFacade::get_DataStructure]
        set dataDoc  $bikeFacade::dataStructureDoc 
        set dataRoot [$dataDoc documentElement]
            #
        set nodeList [$dataRoot selectNodes */*/*]
        foreach modelNode $nodeList {
            set dataXPath  [$modelNode toXPath]
            set dataPath   [string map {/root/ {}} $dataXPath]
            set initNode  [$initRoot selectNodes $dataPath]
            puts "    <I> $dataPath [$modelNode asXML]"
            if {$initNode != {}} {
                puts "       -> 1"
                $modelNode setAttribute init 1
            } else {
                puts "       -> 0"
                $modelNode setAttribute init 0
            }
            foreach attr [$modelNode attributes] {
                if {$attr == {init}} continue
                set attrValue [$modelNode getAttribute $attr]
                puts "          -> $attr     <- $attrValue"
                $modelNode removeAttribute $attr
                $modelNode setAttribute $attr $attrValue
            }
            
        }
    }
    
        #
    if 0 {
        set dataDoc  $bikeFacade::dataStructureDoc 
        set dataRoot [$dataDoc documentElement]
        puts [$dataRoot asXML]
        puts " -- dataCleanup --"
        set myDoc  [dom parse [$dataRoot asXML]]
        set myRoot [$myDoc documentElement]
            #
        set nodeList [$myRoot selectNodes */*/*]
        foreach myNode $nodeList {
            set myXPath  [$myNode toXPath]
            set myInit [$myNode getAttribute init]
            if $myInit {
                puts "      $myInit $myXPath"
                foreach attr [$myNode attributes] {
                    $myNode removeAttribute $attr
                }
                foreach textNode [$myNode childNodes] {
                    # puts "   ... [$textNode nodeValue]"
                    #$myNode removeChild $textNode
                    #$textNode delete
                }            
            } else {
                puts "      $myInit -- $myXPath "
                set parentNode [$myNode parentNode]
                $parentNode removeChild $myNode
                $myNode delete
                set siblingList [$parentNode childNodes] 
                if {[llength $siblingList] == 0} {
                    set parentParentNode [$parentNode parentNode]
                    $parentParentNode removeChild $parentNode
                    $parentNode delete
                }
            }
        }
        set removeNode [$myRoot selectNodes _Result]
        if {$removeNode != {}} {
            puts "  $removeNode [$removeNode asXML]"
            set parentNode [$removeNode parent]
            $parentNode removeChild $removeNode
            $removeNode delete
        }
        # exit
        puts " -- dataCleanup --"
        puts [$myRoot asXML]
    }
    
    
        #
    if 0 {
        set dataDoc  $bikeFacade::dataStructureDoc 
        set dataRoot [$dataDoc documentElement]
            #
        set nodeList [$dataRoot selectNodes */*/*]
        foreach modelNode $nodeList {
            set dataXPath  [$modelNode toXPath]
            set dataPath   [string map {/root/ {}} $dataXPath]
            puts "    <I> $dataPath [$modelNode asXML]"
            set geometryXMLValue [$modelNode getAttribute geometryXMLKey]
            $modelNode setAttribute geometryModelKey $geometryXMLValue
        }
        
        puts [$dataRoot asXML]
    }
        #
    if 0 {

        set modelMapping {
                BottleCage_DownTube/ComponentKey/XZ                 Component/BottleCage_DownTube           
                BottleCage_DownTube/Config/Type                     Config/BottleCage_DownTube              
                BottleCage_DownTube/Position/End                    Position/DownTube_BottleCageOffset      
                BottleCage_DownTube/Position/Origin                 Position/DownTube_BottleCageBase        
                BottleCage_DownTube/Scalar/OffsetBB                 Scalar/BottleCage/DownTube              
                BottleCage_DownTube_Lower/ComponentKey/XZ           Component/BottleCage_DownTube_Lower     
                BottleCage_DownTube_Lower/Config/Type               Config/BottleCage_DownTube_Lower        
                BottleCage_DownTube_Lower/Position/End              Position/DownTube_Lower_BottleCageOffset
                BottleCage_DownTube_Lower/Position/Origin           Position/DownTube_Lower_BottleCageBase  
                BottleCage_DownTube_Lower/Scalar/OffsetBB           Scalar/BottleCage/DownTube_Lower        
                BottleCage_SeatTube/ComponentKey/XZ                 Component/BottleCage_SeatTube           
                BottleCage_SeatTube/Config/Type                     Config/BottleCage_SeatTube              
                BottleCage_SeatTube/Position/End                    Position/SeatTube_BottleCageOffset      
                BottleCage_SeatTube/Position/Origin                 Position/SeatTube_BottleCageBase        
                BottleCage_SeatTube/Scalar/OffsetBB                 Scalar/BottleCage/SeatTube              
                BottomBracket/Position/Ground                       Position/BottomBracket_Ground           
                BottomBracket/Position/Origin                       Position/BottomBracket                  
                BottomBracket/Scalar/InsideDiameter                 Scalar/BottomBracket/InsideDiameter     
                BottomBracket/Scalar/OffsetCS_TopView               Scalar/BottomBracket/OffsetCS_TopView   
                BottomBracket/Scalar/OutsideDiameter                Scalar/BottomBracket/OutsideDiameter    
                BottomBracket/Scalar/Width                          Scalar/BottomBracket/Width              
                ChainStay/Config/Type                               Config/ChainStay                        
                ChainStay/Polygon/ChainStay                         Polygon/ChainStay                       
                ChainStay/Polygon/ChainStay_RearMockup              Polygon/ChainStay_RearMockup            
                ChainStay/Polygon/ChainStay_XY                      {}                                      
                ChainStay/Position/Origin                           Position/ChainStay_RearWheel            
                ChainStay/Position/Origin_XY                        Position/ChainStay_RearMockup           
                ChainStay/Profile/XY                                Polygon/ChainStay_xy                    
                ChainStay/Profile/XZ                                Polygon/ChainStay_xz                    
                ChainStay/Scalar/DiameterSS                         Scalar/ChainStay/DiameterSS             
                ChainStay/Scalar/Height                             Scalar/ChainStay/Height                 
                ChainStay/Scalar/HeightBB                           Scalar/ChainStay/HeightBB               
                ChainStay/Scalar/Length                             Scalar/Geometry/ChainStay_Length        
                ChainStay/Scalar/TaperLength                        Scalar/ChainStay/TaperLength            
                ChainStay/Scalar/WidthBB                            Scalar/ChainStay/WidthBB                
                ChainStay/Scalar/completeLength                     Scalar/ChainStay/completeLength         
                ChainStay/Scalar/cuttingLeft                        Scalar/ChainStay/cuttingLeft            
                ChainStay/Scalar/cuttingLength                      Scalar/ChainStay/cuttingLength          
                ChainStay/Scalar/profile_x01                        Scalar/ChainStay/profile_x01            
                ChainStay/Scalar/profile_x02                        Scalar/ChainStay/profile_x02            
                ChainStay/Scalar/profile_x03                        Scalar/ChainStay/profile_x03            
                ChainStay/Scalar/profile_y00                        Scalar/ChainStay/profile_y00            
                ChainStay/Scalar/profile_y01                        Scalar/ChainStay/profile_y01            
                ChainStay/Scalar/profile_y02                        Scalar/ChainStay/profile_y02            
                ChainStay/Scalar/profile_y03                        {}                                      
                ChainStay/Scalar/segmentAngle_01                    Scalar/ChainStay/segmentAngle_01        
                ChainStay/Scalar/segmentAngle_02                    Scalar/ChainStay/segmentAngle_02        
                ChainStay/Scalar/segmentAngle_03                    Scalar/ChainStay/segmentAngle_03        
                ChainStay/Scalar/segmentAngle_04                    Scalar/ChainStay/segmentAngle_04        
                ChainStay/Scalar/segmentLength_01                   Scalar/ChainStay/segmentLength_01       
                ChainStay/Scalar/segmentLength_02                   Scalar/ChainStay/segmentLength_02       
                ChainStay/Scalar/segmentLength_03                   Scalar/ChainStay/segmentLength_03       
                ChainStay/Scalar/segmentLength_04                   Scalar/ChainStay/segmentLength_04       
                ChainStay/Scalar/segmentRadius_01                   Scalar/ChainStay/segmentRadius_01       
                ChainStay/Scalar/segmentRadius_02                   Scalar/ChainStay/segmentRadius_02       
                ChainStay/Scalar/segmentRadius_03                   Scalar/ChainStay/segmentRadius_03       
                ChainStay/Scalar/segmentRadius_04                   Scalar/ChainStay/segmentRadius_04       
                CrankSet/ComponentKey/XY_Custom                     {}                                      
                CrankSet/ComponentKey/XZ                            Component/CrankSet                      
                CrankSet/ComponentKey/XZ_Custom                     {}                                      
                CrankSet/ComponentNode/XY_Custom                    {}                                      
                CrankSet/ComponentNode/XZ                           {}                                      
                CrankSet/ComponentNode/XZ_Custom                    {}                                      
                CrankSet/Config/SpyderArmCount                      Config/CrankSet_SpyderArmCount          
                CrankSet/ListValue/ChainRings                       ListValue/CrankSetChainRings            
                CrankSet/Polygon/CrankArm_XY                        {}                                      
                CrankSet/Scalar/ArmWidth                            Scalar/CrankSet/ArmWidth                
                CrankSet/Scalar/ChainLine                           Scalar/CrankSet/ChainLine               
                CrankSet/Scalar/ChainRingOffset                     Scalar/CrankSet/ChainRingOffset         
                CrankSet/Scalar/Length                              Scalar/CrankSet/Length                  
                CrankSet/Scalar/PedalEye                            Scalar/CrankSet/PedalEye                
                CrankSet/Scalar/Q-Factor                            Scalar/CrankSet/Q-Factor                
                DownTube/Direction/XZ                               {}                                      
                DownTube/Polygon/Shape_XZ                           Polygon/DownTube                        
                DownTube/Position/Edge_HeadTube_DT                  {}                                      
                DownTube/Position/End                               Position/DownTube_End                   
                DownTube/Position/Origin                            Position/DownTube_Start                 
                DownTube/Scalar/DiameterBB                          Scalar/DownTube/DiameterBB              
                DownTube/Scalar/DiameterHT                          Scalar/DownTube/DiameterHT              
                DownTube/Scalar/OffsetBB                            Scalar/DownTube/OffsetBB                
                DownTube/Scalar/OffsetHT                            Scalar/DownTube/OffsetHT                
                DownTube/Scalar/TaperLength                         Scalar/DownTube/TaperLength             
                Fork/Config/ForkDropout                             Config/ForkDropout                      
                Fork/Config/Type                                    Config/Fork                             
                Fork/Scalar/BladeBrakeOffset                        Scalar/Fork/BladeBrakeOffset            
                Fork/Scalar/BladeOffsetCrown                        Scalar/Fork/BladeOffsetCrown            
                Fork/Scalar/BladeOffsetCrownPerp                    Scalar/Fork/BladeOffsetCrownPerp        
                Fork/Scalar/BladeOffsetDO                           Scalar/Fork/BladeOffsetDO               
                Fork/Scalar/BladeOffsetDOPerp                       Scalar/Fork/BladeOffsetDOPerp           
                Fork/Scalar/CrownAngleBrake                         Scalar/Fork/CrownAngleBrake             
                Fork/Scalar/CrownOffsetBrake                        Scalar/Fork/CrownOffsetBrake            
                Fork/Scalar/Height                                  Scalar/Geometry/Fork_Height             
                Fork/Scalar/Rake                                    Scalar/Geometry/Fork_Rake               
                ForkBlade/Config/Type                               Config/ForkBlade                        
                ForkBlade/Polygon/Shape_XZ                          Polygon/ForkBlade                       
                ForkBlade/Position/End                              Position/ForkBlade_End                  
                ForkBlade/Position/Origin                           Position/ForkBlade_Start                
                ForkBlade/Scalar/BendRadius                         Scalar/Fork/BladeBendRadius             
                ForkBlade/Scalar/DiameterDO                         Scalar/Fork/BladeDiameterDO             
                ForkBlade/Scalar/EndLength                          Scalar/Fork/BladeEndLength              
                ForkBlade/Scalar/TaperLength                        Scalar/Fork/BladeTaperLength            
                ForkBlade/Scalar/Width                              Scalar/Fork/BladeWidth                  
        }  
            #
        set dataDoc  $bikeFacade::dataStructureDoc 
        set dataRoot [$dataDoc documentElement]
            #
        set nodeList [$dataRoot selectNodes */*/*]
        foreach modelNode $nodeList {
            $modelNode setAttribute geometryModelKey ""
        }
        
        foreach modelKey [dict keys $modelMapping] {
            puts "\n   ----> $modelKey"
            # continue
            set geometryKey [dict get $modelMapping $modelKey]
            #puts "            --> $mapValue"
            #foreach {modelKey geometryKey} $keyValue break
            puts "           -> $geometryKey"
            set modelNode [$dataRoot selectNodes $modelKey]
            if {$modelNode != {}} {
                if {$geometryKey != {}} {
                    $modelNode setAttribute geometryModelKey $geometryKey
                } else {
                    $modelNode setAttribute geometryModelKey ""
                }
                puts "              -> [$modelNode asXML]"
            } else {
            
            }
        }   
       
        puts "\n\n\n\n"
        
        puts [$dataRoot asXML]

    }
        #
    if 0 {

            #
        set dataDoc  $bikeFacade::dataStructureDoc 
        set dataRoot [$dataDoc documentElement]
            #
        set nodeList [$dataRoot selectNodes */*/*]
        foreach modelNode $nodeList {
            set parentNode [$modelNode parentNode]
            set parentName [$parentNode nodeName]
            if {$parentName == {Scalar}} {
                set geometryXMLKeyValue     [$modelNode getAttribute geometryXMLKey]
                if {$geometryXMLKeyValue != {}} {
                    set geometryModelKeyValue   [$modelNode getAttribute geometryModelKey]
                    if {$geometryModelKeyValue == {}} {
                        set newValue [format {Scalar/%s} $geometryXMLKeyValue]
                        $modelNode setAttribute geometryModelKey $newValue
                    }
                }
            }
        }
    }
        #
    if 1 {

            #
        set dataDoc  $bikeFacade::dataStructureDoc 
        set dataRoot [$dataDoc documentElement]
            #
        set nodeList [$dataRoot selectNodes */*/*]
        foreach modelNode $nodeList {
            set parentNode [$modelNode parentNode]
            set parentName [$parentNode nodeName]
            set dataXPath  [$modelNode toXPath]
            set dataPath   [string map {/root/ {}} $dataXPath]
            puts "    <I> $dataPath [$modelNode asXML]"
            set sourceValue [$modelNode getAttribute geometryModelKey]
            if {$sourceValue == {}} continue
            $modelNode setAttribute guiKey $sourceValue
        }
        
        puts "\n\n\n\n"
        
        puts [$dataRoot asXML]

    }
        #
    
    
    
    exit
    
    
 