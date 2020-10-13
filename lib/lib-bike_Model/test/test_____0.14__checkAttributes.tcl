  
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
    set myObject [::bikeFacade::get__Object Steerer]
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
    
        #
    puts " -- dataCleanup --"
    set initRoot [bikeFacade::get_initDataStructure]
    set dataDoc  $bikeFacade::dataStructureDoc 
    set dataRoot [$dataDoc documentElement]
        #
    set nodeList [$dataRoot selectNodes */*/*]
    set nodeDict {}
    foreach modelNode $nodeList {
        set dataXPath  [$modelNode toXPath]
        set dataPath   [string map {/root/ {}} $dataXPath]
        # puts "    <I> $dataPath [$modelNode asXML]"
        set nodeDict {}
        foreach attrName [$modelNode attributes] {
            set attrValue [$modelNode getAttribute $attrName]
            # puts "          ->  $attrName     <- $attrValue"
            $modelNode removeAttribute $attrName
            dict append nodeDict $attrName $attrValue
            # $modelNode setAttribute $attr $attrValue
        }
        foreach keyName [dict keys $nodeDict] {
            # puts $keyName
        }
            #
        set dataXPath   [$modelNode toXPath]
        set dataPath    [string map {/root/ {}} $dataXPath]
        foreach {a dataType b} [split $dataPath /] break 
        #set modelName [$modelNode nodeName]
        # puts "    --> $dataType"
            #
        switch -exact $dataType {
            Scalar -
            Config -
            ListValue {
                    set attrValue [dict get $nodeDict geometryKey]
                    dict append nodeDict guiKey $attrValue
                }
            default {
                    dict append nodeDict guiKey ""
            }
        }
            #
        set initValue       [dict get $nodeDict init]
        set guiDictKeyValue [dict get $nodeDict guiDictKey]
        set guiKeyValue     [dict get $nodeDict guiKey]
            #
        set doUpdate 0
        set newValue {}
        
        if $initValue {
            set newValue $guiDictKeyValue
            if {$guiKeyValue eq {}} {
                set newValue $guiDictKeyValue
                set doUpdate 1
            }
        }        
        
        set listLength [llength [split $guiKeyValue /]]
        if {$listLength > 3} {
            #puts "      -> $listLength"
            set stringLength [string length $guiKeyValue]
            #puts "      -> $stringLength"
            set newValue [string range $guiKeyValue 0 [expr ($stringLength / 2) - 1]]
            #puts "            $newValue"
            set doUpdate 1
        }
        if $doUpdate {
            puts "  $dataPath -> $guiKeyValue"
            puts "            ----> $newValue"
        }
        continue
        
        if $doUpdate {
            dict set nodeDict guiKey $newValue
        }

        foreach attrName {init projectXML guiDictKey guiKey geometryKey componentKey frameKey persistKey} {
            set attrValue [dict get $nodeDict $attrName]
            puts "          --> $attrName     <- $attrValue"
            if {$attrName eq {projectXMLKey}} {
                set attrName {geometryKey}
            }
            $modelNode setAttribute $attrName $attrValue
        }
        puts "        --------------"
        
        
    }

    
    
    
    
    
    exit
    
    puts "\n\n\n\n"
    
    puts [$dataRoot asXML]