  
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
    package require   myPersist
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        #
    set myFrame [bikeFrame::DiamondFrame  new]
        #
        
        #
        #
    bikeModel::add_ComponentDir user [file normalize "C:\\Users\\manfred\\Documents\\rattleCAD\\components"]
        #
    bikeModel::init
        #
        #
        #
    puts "  -- 00 ---------------------------------------------"   
        #
        # ... source model mapping
    #source [file join $BASE_Dir test myPersist_ModelMapping.tcl]
        #
        #
        #
    puts "  -- 10 ---------------------------------------------"   
        #
        # ... define a projectFile
    set projectFile [file join $SAMPLE_Dir template_road_3.5.xml]
        #set projectFile [file join $SAMPLE_Dir template_offroad_3.5.xml]
        #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set sourceDoc       [dom parse $projetXML]
        #
        #
        #
    puts "  -- 20 ---------------------------------------------"
        #
        # ... init the mappingObject
        #
    set mappingObject      [myPersist::ModelMapping new]        
        #
        #
        #
    puts "  -- 30 ---------------------------------------------"   
        #
        # ... get bikeModelDoc from a template
        #
    set bikeModelDoc [bikeModel::get_inputModelDocument]
        # puts [$bikeModelDoc asXML]
        #
        #
        #
    puts "  -- 40 ---------------------------------------------"   
        #
        # ... update bikeModelDoc
        #
    $mappingObject update_bikeModel_InputDoc $sourceDoc $bikeModelDoc
        # ... print the updated bikeModelDoc
    puts [$bikeModelDoc asXML]
        #
        #
        #
    puts "  -- 50 ---------------------------------------------"  
        #
        # ... read $bikeModelDoc, which was updated by the $mappingObject
        #
    bikeModel::read_inputModelDocument $bikeModelDoc
        #
        #
        #
    puts "  -- 90 ---------------------------------------------"     
        #
        # ... do some stuff
        #
        # ... create compareable artifacts
        #
    set targetDoc  [$mappingObject get_PersistDoc $bikeModelDoc]
        #
    set modelDict  [bikeModel::get_resultModelDictionary]
    set miterDict  [bikeModel::get_resultMiterDictionary]
        # appUtil::pdict $myDict 2 "  "
        #
        #
        #
    puts "  -- 99 ---------------------------------------------" 
        #
        # --- write reports
        #
    set sourceFile  [file join $BASE_Dir test ____3.4.05.00_source_xx.xml]
        set fp              [open $sourceFile w]
        fconfigure          $fp -encoding utf-8
        puts                $fp [$sourceDoc asXML]
        close               $fp

    set targetFile  [file join $BASE_Dir test ____3.4.05.00_target_xx.xml]
        set fp              [open $targetFile w]
        fconfigure          $fp -encoding utf-8
        puts                $fp [$targetDoc asXML]
        close               $fp

        
        
        
        
        
        
    set modelFile  [file join $BASE_Dir test ____3.4.05.00_model_xx.dict]    
        set fp              [open $modelFile w]
        fconfigure          $fp -encoding utf-8
        appUtil::pdict2file $fp $modelDict 1 "    "
        close               $fp
        
    set miterFile  [file join $BASE_Dir test ____3.4.05.00_miter_xx.dict]    
        set fp              [open $miterFile w]
        fconfigure          $fp -encoding utf-8
        appUtil::pdict2file $fp $miterDict 1 "    "
        close               $fp
        
    puts "---------------------------"
    puts " -> see: $sourceFile"    
    puts " -> see: $targetFile"    
    puts "---------------------------"
    puts " -> see: $modelFile"    
    puts " -> see: $miterFile"    
    puts "---------------------------"
    puts ""    
        
      
        