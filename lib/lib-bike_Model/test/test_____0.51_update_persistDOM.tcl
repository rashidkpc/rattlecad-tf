  
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
    
        #
    bikeModel::add_ComponentDir user [file normalize "C:\\Users\\manfred\\Documents\\rattleCAD\\components"]
        #
    bikeModel::init
        # bikeModel::report_Namespace
        
     set projectDOM  $bikeModel::projectTemplateDoc
    
        #
    puts "\n"    
        #
    puts [$projectDOM asXML]
        #
    puts "\n"    
        #
    proc removeTextNode {domNode} {
            puts "    -> $domNode [$domNode nodeName]"
            foreach childNode [$domNode childNodes] {
                if {[$childNode nodeType] ne {ELEMENT_NODE}} {
                    $domNode removeChild $childNode
                    $childNode delete
                } else {
                    removeTextNode $childNode
                }
            }
    }
            #
    foreach childNode [$projectDOM childNodes] {
            removeTextNode $childNode
    }
        #
    puts [$projectDOM asXML]
        #
    puts "\n"    
        #
        
        
    exit   
        
        
        
        
        
        
        
        
        
        
        
        
        
            #
    puts "\n --- bikeModel::update_Project \$projectDoc ---"
    set mappingDict [bikeModel::get_MappingDict persist]   
    set projectFile [file join $SAMPLE_Dir ____3.4.03.15.xml]
            #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set ProjectDoc      [dom parse $projetXML]
        set projectRoot     [$ProjectDoc documentElement]    
            #
        #
        # -- update structure of projectFile to internal Structure via mappingDict (persist)
        #
    foreach targetKey [dict keys $mappingDict] {
        set sourceKey [dict get $mappingDict $targetKey]
        set projectValue [$projectRoot selectNodes /root/$sourceKey/text()]
        if {$projectValue != {}} {
            set value [$projectValue asXML]
            puts "    -> $targetKey   -> $sourceKey   .... $value"
        } else {
            puts "         -> $targetKey   -> $sourceKey  .... empty"
        }
        set targetNode [$targetRoot selectNodes /root/$targetKey]
        puts "          \$targetNode >$targetNode<"
        if {$targetNode == {}} {
            error "\n<E> targetNode not found for  /root/$targetKey, check init != 1, in \$projectRoot\n\n\n[$projectRoot asXML]"
        }
        set textNode   [$targetDoc  createTextNode $value]
        puts "                -> $targetNode [$targetNode asXML]"
        $targetNode appendChild $textNode
    }
        #           
    bikeModel::update_Project $projectRoot
        #

        #
    puts "\n --- bikeModel::report_Namespace ---"
    bikeModel::report_Namespace
        #

        #
    puts "\n\n\n"
    puts "\n === appUtil::pdict === get_modelDictionary ==="
    set dataDict    [bikeModel::get_modelDictionary]
    appUtil::pdict $dataDict 0 "    "
        
        #  
        #  
        #  
        #
        
        
        
        
        
        
        
        
    exit   
        
        
    appUtil::pdict $mappingDict 
        #
    puts "\n"    
        #
       
        
        
        
        
        
        
        
        
        
        
    set dataDOM [bikeModel::get_namespaceXML]
    puts [$dataDOM asXML]
        #
    foreach dataKey [dict keys $mappingDict] {
        puts "   -> $dataKey [dict get $mappingDict $dataKey]"
        set dataNode [$dataDOM selectNodes $dataKey/text()]
        puts "   -> [$dataNode asXML]"
    }
    exit
                set sourceKey [dict get $mappingDict $targetKey]
                puts " -> $sourceKey /root/$sourceKey/"
                    #
                    puts "         ->   $targetKey"
                    puts "              -> [dict get $mappingDict $targetKey]"
                    #
                set persistKey  $targetKey
                set persistNode [$persistenceDOM selectNodes $persistKey/text()]
    

    
    
            #
    exit
        #
        
    puts "\n --- bikeModel::get_initDataStructure xmlStructure ---"
        # bikeModel::get_DataStructure arrayStructure report
    set targetRoot [bikeModel::get_initDataStructure]
    set targetDoc  [$targetRoot ownerDocument]
        #
        
        #
    puts "\n --- bikeModel::getMappingDict ---"
        # set mappingDict [getMappingDict]
        # appUtil::pdict $mappingDict
        #
        # set myMapping   [dict get $mappingDict mapping]   
    set mappingDict [bikeModel::get_MappingDict persist inverse]   
    set projectFile [file join $SAMPLE_Dir ____3.4.03.15.xml]
            #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set sourceDoc       [dom parse $projetXML]
        set sourceRoot      [$sourceDoc documentElement]    
            #
        #
        # -- update structure of projectFile to internal Structure via mappingDict (persist)
        #
    foreach targetKey [dict keys $mappingDict] {
        set sourceKey [dict get $mappingDict $targetKey]
        set projectValue [$sourceRoot selectNodes /root/$sourceKey/text()]
        if {$projectValue != {}} {
            set value [$projectValue asXML]
            puts "    -> $targetKey   -> $sourceKey   .... $value"
        } else {
            puts "         -> $targetKey   -> $sourceKey  .... empty"
        }
        set targetNode [$targetRoot selectNodes /root/$targetKey]
        puts "          \$targetNode >$targetNode<"
        if {$targetNode == {}} {
            error "\n<E> targetNode not found for  /root/$targetKey, check init != 1, in \$sourceRoot\n\n\n[$sourceRoot asXML]"
        }
        set textNode   [$targetDoc  createTextNode $value]
        puts "                -> $targetNode [$targetNode asXML]"
        $targetNode appendChild $textNode
    }
        #

        #
    puts "\n --- bikeModel::init_Project $targetRoot ---"
    bikeModel::update_Project $targetRoot
        #

        #
    puts "\n --- bikeModel::report_Namespace ---"
    bikeModel::report_Namespace
        #
    puts "\n\n\n"
    puts "\n --- appUtil::pdict --- get_guiDictionary ---"
    set guiDict     [bikeModel::get_guiDictionary]
    appUtil::pdict $guiDict
        #
        
        #
    puts "\n\n\n"
    puts "\n === appUtil::pdict === get_modelDictionary ==="
    set dataDict    [bikeModel::get_modelDictionary]
    appUtil::pdict $dataDict 0 "    "
        
        
        
        
        
        
        
        
        
