  
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
        #

        #
    puts "\n --- bikeModel::report_Namespace ---"
    bikeModel::report_Namespace
        #

    
    puts "\n\n\n"
    puts "\n ====================== get_projectDoc ==="
    set resultDoc       [bikeModel::get_projectDoc]
    puts [$resultDoc asXML]
        
        #
        # -- cleanup ---
        #
    set dataDoc  [dom parse [$bikeModel::dataStructureDoc asXML]]
    set dataRoot [$dataDoc documentElement]
        #
    set nodeList [$dataDoc selectNodes */*/*]
    foreach modelNode $nodeList {
        # set model  [$modelNode toXPath]
        # set modelPath   [string map {/root/ {}} $modelXPath]
        # puts "    <I> $dataPath [$modelNode asXML]"
        # continue
        # puts "       ... $modelPath"
        foreach childNode [$modelNode childNodes] {
            set initAttr [$childNode getAttribute init]
            if !$initAttr {
                set parentNode [$modelNode parentNode]
                $modelNode removeChild $childNode
                $childNode delete
            } else {
                set childXPath  [$childNode toXPath]
                set childPath   [string map {/root/ {}} $childXPath]
                set persistPath [$childNode getAttribute persistKey]
                foreach attrName [$childNode attributes] {
                    set attrValue [$childNode getAttribute $attrName ]
                    # puts "          ->  $attrName     <- $attrValue"
                    switch -exact $attrName {
                        init -
                        persistKey -
                        projectXML -
                        default {
                            $childNode removeAttribute $attrName
                        }
                    }
                        #
                }
                $childNode setAttribute modelKey    "$childPath"   
                $childNode setAttribute persistKey  "$persistPath"   
                    #
            }
        }
            #
        if ![$modelNode hasChildNodes] {
            set parentNode [$modelNode parentNode]
            $parentNode removeChild $modelNode
            $modelNode delete
        }
        
        continue
        
            if [$modelNode hasChildNodes] {
                if 0 {
                    foreach childNode [$modelNode childNodes] {
                        puts "     -> $dataPath ---> [$childNode nodeValue]"
                        $modelNode removeChild $childNode 
                        $childNode delete
                    }
                }
            }
            foreach attrName [$modelNode attributes] {
                set attrValue [$modelNode getAttribute $attrName]
                # puts "          ->  $attrName     <- $attrValue"
                if {$attrName eq {persistKey}} {
                    #$modelNode removeAttribute $attrName
                }
            }
        
        
    }
        #
    puts [$dataRoot asXML]
        #
    exit    
        
        
