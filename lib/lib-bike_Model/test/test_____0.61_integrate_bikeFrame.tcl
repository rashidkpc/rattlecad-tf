  
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
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        #
    set myFrame [bikeFrame::DiamondFrame  new]
        #
        #
    proc bikeModel::update_bikeFrame_ {} {
            #
        variable frameObject
        variable mappingDict_Frame
        variable mappingDict_Frame_inv
            #
        puts "   -> \$frameObject $frameObject"
            #
        set myObject    $frameObject        
        set mappingDict $mappingDict_Frame_inv        
            # set mappingDict $mappingDict_Frame        
            #
        appUtil::pdict $mappingDict
            #
            # 
            # exit
        # puts "[$geometryRoot asXML]"
            #
        set lug_BottomBracket               [$myObject getLug BottomBracket]  
        set lug_RearDropout                 [$myObject getLug RearDropout]  
            #
        set tube_ChainStay                  [$myObject getTube ChainStay]
        set tube_DownTube                   [$myObject getTube DownTube ]
        set tube_HeadTube                   [$myObject getTube HeadTube ]
        set tube_SeatStay                   [$myObject getTube SeatStay ]
        set tube_SeatTube                   [$myObject getTube SeatTube ]
        set tube_TopTube                    [$myObject getTube TopTube  ]
            #
        set targetKeyList                   [$myObject getInitKeys]
            #
        appUtil::pdict $mappingDict 2 "  "    
            #
        set initFrameDict   {}
            #
        foreach targetKey $targetKeyList {
                #
            # puts "    -> $targetKey"    
                #
            if {[catch {set sourcePath [dict get $mappingDict $targetKey]} eID]} {
                    #
                puts "         -> no reference for $targetKey"
                    #
            } else {
                    #
                puts "         -> $targetKey -> $sourcePath"
                    #
                foreach {sourceName sourceType sourceKey} [split $sourcePath /] break
                set sourceObject    [get__Object $sourceName]
                puts "                  -> $sourceObject"
                set sourceValue     [$sourceObject getValue $sourceType $sourceKey]
                puts "                        -> $sourceValue"
                    #
                foreach {targetName targetType targetKey} [split $sourcePath /] break
                dict set initFrameDict $targetName $targetType $targetKey $sourceValue
            }
        }    
            #
        puts "\n--- \$initFrameDict ---"
        appUtil::pdict $initFrameDict 2 "    "
            #
        $myObject   initProject_DICT    $initFrameDict
            #
        set resultFrameDict  [$myObject getDictionary]    
            #
        puts "\n--- \$resultFrameDict ---"
        appUtil::pdict $resultFrameDict 2 "    "
            #
            #
            #
        set sourceObject    [get__Object RearDropout]
        puts "                  -> $sourceObject" 
        $sourceObject reportValues
            #
        exit
    }   
        #        
        
        #
        #
    bikeModel::add_ComponentDir user [file normalize "C:\\Users\\manfred\\Documents\\rattleCAD\\components"]
        #
    bikeModel::init
        #
        #
    namespace eval myGUI {
        variable packageHomeDir [file join $::BASE_Dir test]
    }
    namespace eval myGUI::modelAdapter {
    }
        #
    source [file join $BASE_Dir test classBikeModel_Mapping.tcl]
        #
    set mappingObject      [myGUI::modelAdapter::BikeModelMapping new]        
        #
        #
        #
        # puts [$projectDoc asXML]
    set bikeModelDoc [bikeModel::get_inputModelDocument]
        # puts [$bikeModelDoc asXML]
        #
        #
        #
    set projectFile [file join $SAMPLE_Dir ____3.4.05.00.xml]
            #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set projectDoc      [dom parse $projetXML]
        #
    puts "  -- 90 --"     
    $mappingObject update_bikeModel_InputDoc $projectDoc $bikeModelDoc
        puts [$bikeModelDoc asXML]
        #
    puts "  -- 95 --"     
    bikeModel::read_inputModelDocument $bikeModelDoc
        #
        #
    puts "  -- 99 --"     
    bikeModel::update_resultModelDocument
    set resultFile  [file join $BASE_Dir test ____3.4.05.00_result_01.xml]    
        set fp              [open $resultFile w]
        fconfigure          $fp -encoding utf-8
        puts                $fp       [$bikeModel::resultModelDoc asXML]
        close               $fp
 
    puts " -> $resultFile"
 
 
    set lug_BottomBracket               [$myFrame getLug BottomBracket]  
    set lug_RearDropout                 [$myFrame getLug RearDropout]  
        #
    set tube_ChainStay                  [$myFrame getTube ChainStay]
    set tube_DownTube                   [$myFrame getTube DownTube ]
    set tube_HeadTube                   [$myFrame getTube HeadTube ]
    set tube_SeatStay                   [$myFrame getTube SeatStay ]
    set tube_SeatTube                   [$myFrame getTube SeatTube ]
    set tube_TopTube                    [$myFrame getTube TopTube  ]
        #
    $tube_DownTube reportValues
 