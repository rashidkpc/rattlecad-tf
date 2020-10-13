  
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
    
        #
    puts "\n --- bikeFacade::report_Namespace ---"
    bikeFacade::report_Namespace
        #
    
        #
    puts "\n --- bikeFacade::get_DataStructure xmlStructure ---"
        # bikeFacade::get_DataStructure arrayStructure report
    set targetRoot [bikeFacade::get_DataStructure]
    set targetDoc  [$targetRoot ownerDocument]
        #
        
        #
    puts "\n --- getMappingDict ---"
        # set mappingDict [getMappingDict]
        # appUtil::pdict $mappingDict
        #
        # set myMapping   [dict get $mappingDict mapping]   
    set mappingDict [bikeFacade::get_MappingDict persist]   
        #
            
        #
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
    puts "\n --- bikeFacade::init_Project $targetRoot ---"
    bikeFacade::update_Project $targetRoot
        #
        
        #
    #puts "\n --- bikeFacade::report_Namespace ---"
    #bikeFacade::report_Namespace
        #

        #
    #puts "\n --- bikeFacade::update_bikeGeometry ---"
    #bikeFacade::update_bikeGeometry
        #
        
        #
    bikeFacade::report_Namespace
        #
        
        #
        #
    set compareDoc  [dom parse [$sourceDoc asXML]]  
    set compareRoot [$compareDoc documentElement]
        #
    set reportRoot  [bikeFacade::get_namespaceXML]    
        #
    proc removeTextNodes {domNode} {
        foreach node [$domNode childNodes] {
            if {[$node nodeType] == "TEXT_NODE"} {
                $domNode removeChild $node
                $node delete
            } else {
                removeTextNodes $node
            }
        }
    }
    removeTextNodes $compareRoot
        #
    proc addValues {domNode reportRoot} {
        foreach node [$domNode childNodes] {
            if [$node hasChildNodes] {
                addValues $node $reportRoot
            } else {
                set nodeXPath  [$node toXPath]            
                set nodePath   [string map {/root/ {}} $nodeXPath]            
                    # puts "    ... $nodePath"
                set sourceNodes [$reportRoot find persistKey $nodePath]
                set sourceLength [llength $sourceNodes]
                if {$sourceLength > 0} {
                    set sourceNode [lindex $sourceNodes 0]
                    # puts "         [$sourceNode asXML]"
                    set sourceValue [[$sourceNode selectNodes text()] asText]
                    # puts "             value: $sourceValue"
                    set reportDoc   [$reportRoot ownerDocument]
                    set textNode    [$reportDoc createTextNode $sourceValue]
                    $node appendChild $textNode
                }
                if {$sourceLength > 1} {
                    puts "   -> check this: $nodePath"
                }
            }
        }
    }
    addValues $compareRoot $reportRoot
    puts "[$compareRoot asXML]"
        
        
    set compareFile [file join $SAMPLE_Dir _____3.4.03.15_compare.xml]
            #
        set fp              [open $compareFile "w"]
        fconfigure          $fp -encoding utf-8
        puts -nonewline     $fp [$compareRoot asXML]
        close               $fp
            #
        #
        
        #
    set modelDict [bikeFacade::get_dictionaryGUIModel]
        #
    appUtil::pdict $modelDict 1 "    "
        #
        
        
    exit
    
    
 