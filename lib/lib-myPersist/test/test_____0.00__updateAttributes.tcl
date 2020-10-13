  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"

    
        # -- Libraries  ---------------
    lappend auto_path   "$APPL_ROOT_Dir"
    lappend auto_path   [file join $APPL_ROOT_Dir lib]

        # -- Packages  ---------------
    package require   tdom
    # package require   bikeModel
    # package require   vectormath
    # package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        #
    puts " -- dataCleanup --"
    
    puts "\n -- dataCleanup -- start --\n"
        #
    set xmlFile [file join $BASE_Dir etc mapping_bikeModel.xml]
    puts "   \$xmlFile ......... $xmlFile"
        set fp              [open $xmlFile]
        fconfigure          $fp -encoding utf-8
        set xmlContent      [read $fp]
        close               $fp
            #
        set dataDoc         [dom parse $xmlContent]
        set dataRoot        [$dataDoc documentElement]         
        #
    # puts [$dataRoot asXML]
        #

        #
    set nodeList [$dataRoot selectNodes */*/*]
    set nodeDict {}
    foreach modelNode $nodeList {
        # set dataXPath  [$modelNode toXPath]
        # set dataPath   [string map {/root/ {}} $dataXPath]
        puts "    <I> [$modelNode nodeName]"
        set nodeDict {}
        foreach attrName [$modelNode attributes] {
            set attrValue [$modelNode getAttribute $attrName]
            puts "          ->  $attrName     <- $attrValue"
            dict append nodeDict $attrName $attrValue
            $modelNode removeAttribute $attrName
            # $modelNode setAttribute $attr $attrValue
        }
        foreach keyName [dict keys $nodeDict] {
            # puts $keyName
        }
            #
        # set dataXPath   [$modelNode toXPath]
        # set dataPath    [string map {/root/ {}} $dataXPath]
        # foreach {a dataType b} [split $dataPath /] break 
        # set modelName [$modelNode nodeName]
        # puts "    --> $dataType"
        # continue
        # puts "          ---"
        # init projectXML guiModelKey guiKey geometryKey componentKey frameKey persistKey
        # init projectXML geometryKey componentKey frameKey 
        foreach attrName {init persistKey} {
            set attrValue [dict get $nodeDict $attrName]
            puts "          --> $attrName     <- $attrValue"
            $modelNode setAttribute $attrName $attrValue
        }
        puts "        --------------"
    }

    
    puts "\n\n\n\n"
    
    puts [$dataRoot asXML]