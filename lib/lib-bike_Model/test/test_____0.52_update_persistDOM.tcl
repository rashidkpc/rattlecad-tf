  
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
        # bikeModel::report_Namespacez
        
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
    set mappingDict [bikeModel::get_MappingDict persist]   
    set projectFile [file join $SAMPLE_Dir ____3.4.03.15.xml]
            #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set projectDoc      [dom parse $projetXML]
        set projectRoot     [$projectDoc documentElement]    
            #
        #
        # -- update structure of projectFile to internal Structure via mappingDict (persist)
        #
    bikeModel::read_projectDoc $projectDoc  
        
    if 0 {
        #
        foreach modelKey [dict keys $mappingDict] {
            set projectKey [dict get $mappingDict $modelKey]
            set projectValue [$projectRoot selectNodes /root/$projectKey/text()]
            if {$projectValue != {}} {
                set value [$projectValue asXML]
                puts "    -> $modelKey   -> $projectKey   .... $value"
            } else {
                puts "         -> $modelKey   -> $projectKey  .... empty"
            }
            set targetNode [$targetRoot selectNodes /root/$modelKey]
            puts "          \$targetNode >$targetNode<"
            if {$targetNode == {}} {
                error "\n<E> targetNode not found for  /root/$modelKey, check init != 1, in \$projectRoot\n\n\n[$projectRoot asXML]"
            }
            set textNode   [$targetDoc  createTextNode $value]
            puts "                -> $targetNode [$targetNode asXML]"
            $targetNode appendChild $textNode
                #
            puts "\n --- bikeModel::init_Project $targetRoot ---"
            bikeModel::update_Project $targetRoot
                #
       }
    }
        #

        #
         #

        #
    puts "\n --- bikeModel::report_Namespace ---"
    bikeModel::report_Namespace
        #

        
    puts "\n\n\n"
    puts "\n ====================== get_projectDoc ==="
    set projectDoc    [bikeModel::get_projectDoc]
    puts [$projectDoc asXML]
        
        
        
    exit    
        
        
        
        
        
        
        
        
        #
    puts "\n\n\n"
    puts "\n === appUtil::pdict === get_modelDictionary ==="
    set dataDict    [bikeModel::get_modelDictionary]
    appUtil::pdict $dataDict 0 "    "
        
        
        
    puts "\n\n\n"
    puts "\n ====================== get_namespaceXML ==="
    set modelRoot    [bikeModel::get_namespaceXML]
    puts [$modelRoot asXML]
        #
    
    puts "\n\n\n"
    puts "\n ====================== get_projectTemplateDOM ==="
    set projectDoc [bikeModel::get_projectTemplateDOM]
    puts [$projectDoc asXML]
    
    proc removeTextNode {domNode} {
            # puts "    -> $domNode [$domNode nodeName]"
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
    foreach childNode [$projectDoc childNodes] {
            removeTextNode $childNode
    }
    puts [$projectDoc asXML]

    # exit    
    
    set mappingDict [bikeModel::get_MappingDict persist inverse]   
    foreach projectKey [dict keys $mappingDict] {
        set modelKey [dict get $mappingDict $projectKey]
        set modelValue [$modelRoot selectNodes /root/$modelKey/text()]
        puts "      $projectKey -> $modelKey [$modelValue asXML]"
        if {$modelValue != {}} {
            set value [$modelValue asXML]
            set textNode    [$projectDoc createTextNode $value]
            set projectNode [$projectDoc selectNodes /root/$projectKey]
            puts "                -> $projectNode [$textNode asXML]"
            if {$projectNode ne {}} {
                $projectNode appendChild $textNode
            } else {
                puts "<E> ... projectNode ... not found for ... /root/$projectKey"
                exit
            }
        }
     }
    
    puts "\n ====================== projectDOM ==="
    puts [$projectDoc asXML]
   
    
    
exit    
        
        
        
        if {$projectValue != {}} {
            set value [$projectValue asXML]
            puts "    -> $modelKey   -> $projectKey   .... $value"
        } else {
            puts "         -> $modelKey   -> $projectKey  .... empty"
        }
        set targetNode [$targetRoot selectNodes /root/$modelKey]
        puts "          \$targetNode >$targetNode<"
        if {$targetNode == {}} {
            error "\n<E> targetNode not found for  /root/$modelKey, check init != 1, in \$projectRoot\n\n\n[$projectRoot asXML]"
        }
        set textNode   [$targetDoc  createTextNode $value]
        puts "                -> $targetNode [$targetNode asXML]"
        $targetNode appendChild $textNode
    }

 