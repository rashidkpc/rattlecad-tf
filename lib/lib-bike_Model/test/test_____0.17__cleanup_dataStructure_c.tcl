  
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
    