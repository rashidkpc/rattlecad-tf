  
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
    
    puts " ---- init ---- geometryModelKey ---- geometryXMLKey ----"
    
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

        set initValue           [dict get $nodeDict init]
        set geometryModelValue  [dict get $nodeDict geometryModelKey]
        set geometryValue       [dict get $nodeDict geometryKey]
        set reportString {}
        
        # if {$geometryValue ne {} || $geometryModelValue ne {}} {}
        if {$geometryModelValue ne {}} {
            puts "           $initValue - $dataPath"
            switch -glob $geometryValue {
                Scalar/* -
                Component/* -
                Config/* {
                        puts "           $initValue - $dataPath"
                        puts "                          geometryKey ........ $geometryValue"
                        puts "                          geometryModelKey ... $geometryModelValue"
                    }
                default {}
            }
        }
        continue
        
        if {$geometryModelValue ne {}} {
            puts "           $initValue - $dataPath"
            if {$geometryValue eq $geometryModelValue} {
                puts "                          .... geometryKey ........ $geometryValue"
                puts "                               geometryModelKey ... $geometryModelValue"
            } else {
                puts "                    differ ... geometryKey ........ $geometryValue"
                puts "                               geometryModelKey ... $geometryModelValue"
            }
        }
        continue
        
        
        switch -glob $dataPath {
            */Position/*    {set doReport 0}
            */Config/*      {set doReport 1}
            default         {set doReport 0}
        }
        
        if $doReport {
            puts "           $initValue - $dataPath"
            # puts "                    geometryXMLKey ..... $geometryXMLValue"
            puts "                    geometryModelKey ... $geometryModelValue"
        }
        
        
        
        continue
        
        
        append reportString " -> $initValue <- "
        append reportString " -> $dataXPath <- "
        append reportString " -> $geometryModelValue <- "
        append reportString " -> $geometryXMLValue <- "
        
        if {$initValue} {
            # puts "        ------- $initValue ---"
            puts "           $reportString"
        } else {
        }
        
        if 0 {
            foreach attrName {geometryModelKey geometryXMLKey geometryKey} {
                set attrValue [dict get $nodeDict $attrName]
                puts "          --> $attrName     <- $attrValue"
                # append reportString " -> $attrValue <- "
                $modelNode setAttribute $attrName $attrValue
            }
        }


        # puts "        --------------"
    }
    
    # exit
    
    puts "\n\n\n\n"
    
    # puts [$dataRoot asXML]