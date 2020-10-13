  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir        [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir   [file dirname $BASE_Dir]
    set TEST_Dir        [file join [file dirname [file normalize $::argv0]]]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
    puts "   \$TEST_Dir ........ $TEST_Dir"
        #
    set RESULT_Dir      [file join $TEST_Dir _debug]
    set SAMPLE_Dir      [file join $TEST_Dir sample]
    set ETC_Dir         [file join $BASE_Dir etc]
        #
    puts "   \$RESULT_Dir ...... $RESULT_Dir"
    puts "   \$SAMPLE_Dir ...... $SAMPLE_Dir"
    puts "   \$ETC_Dir ......... $ETC_Dir"
        
        #
        
        # -- Libraries  ---------------
    lappend auto_path   "$APPL_ROOT_Dir"
    lappend auto_path   [file join $APPL_ROOT_Dir lib]
    lappend auto_path   "$APPL_ROOT_Dir/../myPersist"
        # --eclipse reference
    lappend auto_path   "$APPL_ROOT_Dir/../lib-myPersist"
        #
    foreach pathDir $auto_path {
        puts "        -> $pathDir"
    }

        # -- Packages  ---------------
    package require   tdom
    package require   bikeGeometry
    # package require   bikeModel
    package require   myGUI
    # package require   bikeFacade
    # package require   vectormath
    # package require   appUtil
    
        #
    proc myGUI::modelAdapter::open_ProjectFile {projectFile} {
            #
        variable persistenceDOM
            # variable bikeObject
            #
        variable persistenceObject 
        variable modelContext 
        variable model_BikeGeometry ;# set in _init.tcl
        variable model_BikeFacade   ;# set in _init.tcl
            #
        puts "\n"
		puts "   -------------------------------"
		puts "    myGUI::modelAdapter::open_ProjectFile"
		
            #
		set persistenceDOM [$persistenceObject readFile_rattleCAD $projectFile]
            #
        puts [$persistenceDOM asXML]    
        

            #
        if 1 {
                #
                # -- bikeGeometry -------------------------------------
                #
            puts "  -> \$model_BikeGeometry $model_BikeGeometry"
            $modelContext setModelStrategy $model_BikeGeometry
            puts "  -> \$modelContext $modelContext"
                #
            $modelContext initDomainParameters
            $modelContext updateProjectValues $persistenceDOM
                #
            $modelContext set_Component  RearDerailleur etc:derailleur/rear/sram_red_2012.svg   
                #
            set modelDICT   [$modelContext getModelDictionary]
                #
                #
            set targetFile  [file join $::RESULT_Dir bikeGeometry.txt]
            set fp          [open $targetFile w+]
            puts -nonewline $fp "\n  ------ bikeGeometry ------ \n\n"
            appUtil::pdict2file $fp $modelDICT
            close $fp
                # exit
                #
        }
            #
            #
            # -- bikeFacade -------------------------------------
            #
        puts "  -> \$model_BikeFacade $model_BikeFacade"
        $modelContext setModelStrategy $model_BikeFacade
        puts "  -> \$modelContext $modelContext"
            #
        $modelContext initDomainParameters
        $modelContext updateProjectValues $persistenceDOM
            #
        $modelContext set_Component  RearDerailleur etc:derailleur/rear/sram_red_2012.svg   
            #
        puts "    ... ::bikeGeometry::Component(RearDerailleur) $::bikeGeometry::Component(RearDerailleur)"
            
        #exit    
            #
        set modelDICT   [$modelContext getModelDictionary]
            #
            #
        set targetFile  [file join $::RESULT_Dir bikeFacade.txt]
        set fp          [open $targetFile w+]
        puts -nonewline $fp "\n  ------ bikeFacade ------ \n\n"
        appUtil::pdict2file $fp $modelDICT
        close $fp
            #  
            # --
        return
            #
    }

        #
        #
    set projectFile [file join $ETC_Dir template_road_3.4.xml]
    set projectFile [file join $SAMPLE_Dir simplon_phasic_56_campagnolo.xml]
        #
    puts "\n"    
    puts "           ... SAMPLE_Dir:  $SAMPLE_Dir"    
    puts "           ... projectFile: $projectFile"    
    puts "\n"
        #
    myGUI::modelAdapter::open_ProjectFile $projectFile
        #
