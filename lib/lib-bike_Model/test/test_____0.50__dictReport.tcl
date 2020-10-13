  
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
    foreach targetKey [dict keys $mappingDict] {
        set projectKey [dict get $mappingDict $targetKey]
        set projectValue [$projectRoot selectNodes /root/$projectKey/text()]
        if {$projectValue != {}} {
            set value [$projectValue asXML]
            puts "    -> $targetKey   -> $projectKey   .... $value"
        } else {
            puts "         -> $targetKey   -> $projectKey  .... empty"
        }
        set targetNode [$targetRoot selectNodes /root/$targetKey]
        puts "          \$targetNode >$targetNode<"
        if {$targetNode == {}} {
            error "\n<E> targetNode not found for  /root/$targetKey, check init != 1, in \$projectRoot\n\n\n[$projectRoot asXML]"
        }
        set textNode   [$targetDoc  createTextNode $value]
        puts "                -> $targetNode [$targetNode asXML]"
        $targetNode appendChild $textNode
    }
        #

        #
    puts "\n --- bikeModel::init_Project $targetRoot ---"
    bikeModel::update_Project $targetRoot
        #

        #
    puts "\n --- bikeModel::report_Namespace ---"
    bikeModel::report_Namespace
        #
    puts "\n\n\n"
    puts "\n --- appUtil::pdict --- get_guiDictionary ---"
    set guiDict     [bikeModel::get_guiDictionary]
    appUtil::pdict $guiDict
        #
        
        #
    puts "\n\n\n"
    puts "\n === appUtil::pdict === get_modelDictionary ==="
    set dataDict    [bikeModel::get_modelDictionary]
    appUtil::pdict $dataDict 0 "    "
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        #
    exit
        #
        #
        #
        
    puts "\n --- write dictionary to file ---"
    set resultFile [file join $BASE_Dir test _result result_3.4.04.05.txt]
    puts "       --> $resultFile"
        #
    set fp  [open $resultFile w]
        #
    set systemTime [clock seconds]
    puts $fp "\n[clock format $systemTime -format {Today is: %A, the %d of %B, %Y - %H:%M:%S}]\n"
        #
    appUtil::pdict2file $fp $guiDict
        #
    close   $fp
        #
    
    puts "\n -> done!\n"
    
    return
    
    
    
    package require Tk
    foreach type {Supplier SteelLuggedMAX SteelCustomBent SteelCustomStraight Composite Suspension_20 Suspension_24 Suspension_26 Suspension_27} {
        bikeModel::set_Value Config/Fork  $type 
        #set node_steerer [bikeModel::get__ObjectValue Steerer ComponentNode XZ]
        #puts "   -> $node_steerer"
        #set position_steerer [bikeModel::get__ObjectValue Steerer Position End]
        #puts "   -> $position_steerer"
        #set polyline_steerer [bikeModel::get__ObjectValue Steerer Polyline CenterLine_XZ]
        #puts "   -> $polyline_steerer"
        #set polygon_steerer  [bikeModel::get__ObjectValue Steerer Polygon XZ]
        #puts "   -> $polygon_steerer"
        #tk_messageBox -message "$tape : \nnode: $node_steerer\npos: $position_steerer\npln: $polyline_steerer\nplg: $polygon_steerer"
    }
   