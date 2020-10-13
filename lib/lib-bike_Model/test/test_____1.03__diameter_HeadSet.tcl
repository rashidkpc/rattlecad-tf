  
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
    set projectFile [file join $SAMPLE_Dir ____3.4.05.14.xml]
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
    # puts [$bikeModelDoc asXML]
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
    puts "  -- 50 ---------------------------------------------"  
        #
        # ... do some stuff
        #
        # bikeModel::set__ObjectValue {objectName objType objKey value}
    #puts "[bikeModel::get__ObjectValue RearDropout Position Derailleur]"
    
    puts "[bikeModel::get__ObjectValue HeadSet Scalar DiameterTop]"
    puts "[bikeModel::get__ObjectValue HeadSet Scalar DiameterBottom]"
    bikeModel::set_Value HeadSet/Scalar/DiameterTop 55
    bikeModel::set_Value HeadSet/Scalar/DiameterBottom 56
    puts "[bikeModel::get__ObjectValue HeadSet Scalar DiameterTop]"
    puts "[bikeModel::get__ObjectValue HeadSet Scalar DiameterBottom]"
    exit
        #
