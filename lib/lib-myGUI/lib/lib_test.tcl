 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_test.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.  
 #
 # ---------------------------------------------------------------------------
 #  namespace:  myGUI::test
 # ---------------------------------------------------------------------------
 #
 #
namespace eval myGUI::test {
    variable runningStatus {off}
}

proc myGUI::test::runDemo {{testProcedure {}}} {
    variable runningStatus on
    
        #
    catch {destroy .intro}
        #
        
    if {$testProcedure == {}} {
        set testProcedure   integrationTest_00     
    }
        #
    set timeStart    [clock milliseconds]
    set messageValue "... runDemo started"
        #
    
    switch -exact $testProcedure {
        integrationTest_00 {
                  # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
                [namespace current]::integrationTest_00 
                set messageValue "... integrationTest 00"
                  # tk_messageBox -title "integration Test" -message "... integrationTest 00\n      ... done!"
            }
        integrationTest_loopNotebook {
                  # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
                [namespace current]::integrationTest_loopNotebook 
                set messageValue "... integrationTest_loopNotebook 00"
                  # tk_messageBox -title "integration Test" -message "... integrationTest 00\n      ... done!"
            }
        integrationTest_special {
                  # tk_messageBox -title "integration Test" -message "... start integrationTest 00"
                [namespace current]::testResultParameter
                set messageValue "... integrationTest special"
            }
        method_rattleCAD_HandleBarandSaddle {
                while {$runningStatus != {off}} {
                      # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                    [namespace current]::method_rattleCAD_HandleBarandSaddle
                    set messageValue "... rattleCAD Method: HandleBar and Saddle!"
                      # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                }
            } 
        method_classic_SeatandTopTube {
                while {$runningStatus != {off}} {
                      # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                    [namespace current]::method_classic_SeatandTopTube
                    set messageValue "... Classic Method: Seat- and TopTube !"
                      # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                }
            } 
        loopSamples {
                while {$runningStatus != {off}} {
                      # tk_messageBox -title "loop Samples" -message "... start loopSamples"
                    [namespace current]::loopSamples
                    set messageValue "... start loopSamples"        
                      # tk_messageBox -title "loop Samples" -message "... rattleCAD Samples!"
                }
            }    
        demo_01 {
                while {$runningStatus != {off}} {
                      # tk_messageBox -title "Demontsration" -message "... show rattleCAD Principle"
                    [namespace current]::demo_01
                    set messageValue "... rattleCAD Principle!"
                       # tk_messageBox -title "Demontsration" -message "... rattleCAD Principle!"
                }
            }    

        default {}       
    }
    
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr 0.001*($timeEnd - $timeStart)]
    tk_messageBox -title "Demonstration" -message "$messageValue\n       elapsed: $timeUsed seconds"      
}

proc myGUI::test::stopDemo {{mode {init}}} {
    variable runningStatus
    
    if {$mode == {init}} {
        if {$runningStatus != {off}} {
            set runningStatus off
            puts "\n"
            puts "   ... current [namespace current]::runDemo stopped"
            puts "\n"
            return
        }
    } else {
          # -- reset demoText
        set targetObject [myGUI::gui::getCanvasObject]
        createDemoText_2  $targetObject  ""
          #
        return
          #
    }
}

proc myGUI::test::keepRunning {} {
    variable runningStatus
    puts "\n  ... keepRunning $runningStatus\n"
    if {$runningStatus == {off}} {
        puts "\n  ... stop procedure $runningStatus\n"
        return 0; # if 0 ... failed
    } else {
        puts "\n  ... keep running $runningStatus\n"
        return 1; # if 1 ... OK
    }
}

 
    #-------------------------------------------------------------------------
    #  integrationTest_00
    #
proc myGUI::test::integrationTest_00 {args} {
      
    puts "\n\n ====== integrationComplete ================ \n\n"
    puts "    --- integrationTest_00 ---\n"
    
    set TEST_Dir         $::APPL_Config(TEST_Dir) 
    set SAMPLE_Dir       [file join ${TEST_Dir} sample]
    
    puts "        -> TEST_Dir:        $TEST_Dir"  
    puts "        -> SAMPLE_Dir:      $SAMPLE_Dir"  

    
    # -- keep on top --------------
    wm deiconify .
    
    # -- update display -----------
    myGUI::gui::notebook_refitCanvas	

    
    # -- integration test ---------
    puts "\n\n === open File  ===\n"  
    puts "          ... \n"
     
    set openFile         [file join  ${SAMPLE_Dir} __test_Integration_02.xml]
    puts "          ... $openFile\n"
    myGUI::control::open_ProjectFile   $openFile
    
    set openFile         [file join  ${SAMPLE_Dir} road_classic_1984_SuperRecord.xml]
    puts "          ... $openFile\n"
    myGUI::control::open_ProjectFile   $openFile
    
    
    puts "\n\n === export  pdf / html  ===\n"
    myGUI::export::export_Project      pdf
    wm deiconify .
    update
    myGUI::export::export_Project      html
    wm deiconify .        
    update
    
    
    puts "\n\n === export  svg / dxf /ps  ===\n"
    myGUI::export::notebook_exportSVG  $::APPL_Config(EXPORT_Dir) no
    myGUI::export::notebook_exportDXF  $::APPL_Config(EXPORT_Dir) no
    wm deiconify .
    update
    
    
    puts "\n\n === open file  ===\n"
    puts "   -> ${SAMPLE_Dir}: ${SAMPLE_Dir}\n"
    if {[catch {glob -directory ${SAMPLE_Dir} *.xml} errMsg]} {
        foreach sampleFile [lsort [glob -directory ${SAMPLE_Dir} *.xml]] {
           set openFile     [file join  ${SAMPLE_Dir} $thisFile]
           puts "          ... integrationTest_00 opened"
           puts "                 ... $openFile\n"
           myGUI::control::open_ProjectFile   $openFile 
           wm deiconify .
           #update          
        }
    }
            
    
    puts "\n\n === open config Panel  ===\n"           
    set cfgPanel [myGUI::view::configPanel::create]
    puts "    ... $cfgPanel"
    
    
    puts "\n\n === open not existing file  ===\n"  
    set openFile     [file join  ${SAMPLE_Dir}    this_file_does_not_exist.xml]
    puts "          ... $openFile\n"
    myGUI::control::open_ProjectFile   $openFile   
    
            
    puts "\n\n === create Information  ===\n"      
    myGUI::infoPanel::create  .v_info 0
    
    puts "\n\n === create Help  ===\n"
    myGUI::infoPanel::create  .v_info 1
    
    puts "\n\n === create Environment  ===\n"
    myGUI::infoPanel::create  .v_info 5
    
    puts "\n\n === create_intro  ===\n"        
    myGUI::create_intro .intro
    after  100 destroy .intro
   
    
    puts "\n\n === open Config gPanel ===\n"        
    puts "    ... $cfgPanel"
    
    
    puts "\n\n === load template road again  ===\n"  
    puts "          ... Template  Road\n"
    myGUI::control::open_TemplateFile  Road	

    
    puts "\n\n === demonstrate stack and reach  ===\n"  
     # stack_and_reach
    

    puts "\n\n === load template road again  ===\n"  
    puts "          ... Template  Road\n"
    myGUI::control::open_TemplateFile  Road	
    
    
    puts "\n\n === load template road again  ===\n"  
    puts "          ... Template  Road\n"
    myGUI::control::open_TemplateFile  Road	

    
    puts "\n\n === end ===\n"       
    puts "   -> TEST_Dir: $TEST_Dir\n"   
}   

proc myGUI::test::integrationTest_loopNotebook {args} {
      
    puts "\n\n ====== integrationTest_loopNotebook ================ \n\n"
    
    set TEST_Dir         $::APPL_Config(TEST_Dir) 
    set SAMPLE_Dir       [file join ${TEST_Dir} sample]
    
    puts "        -> TEST_Dir:        $TEST_Dir"  
    puts "        -> SAMPLE_Dir:      $SAMPLE_Dir"  

    
    # -- keep on top --------------
    wm deiconify .
    
    # -- update display -----------
    myGUI::gui::notebook_refitCanvas	

    
    # -- integration test ---------
    puts "\n\n === open File  ===\n"  
    puts "          ... \n"
    
    puts "\n\n === load __test_Integration_02.xml ===\n"  
    set openFile         [file join  ${SAMPLE_Dir} __test_Integration_02.xml]
    puts "          ... $openFile\n"
    myGUI::control::open_ProjectFile   $openFile
    myGUI::test::loopNotebook
    
    puts "\n\n === load road_classic_1984_SuperRecord.xml ===\n"  
    set openFile         [file join  ${SAMPLE_Dir} road_classic_1984_SuperRecord.xml]
    puts "          ... $openFile\n"
    myGUI::control::open_ProjectFile   $openFile
    myGUI::test::loopNotebook

    puts "\n\n === load template road ===\n"  
    puts "          ... Template  Road\n"
    myGUI::control::open_TemplateFile  Road	
    myGUI::test::loopNotebook
    
    puts "\n\n === load template road ===\n"  
    puts "          ... Template  Road\n"
    myGUI::control::open_TemplateFile  Road	
    myGUI::test::loopNotebook

    puts "\n\n === end ===\n"       
}   



    #-------------------------------------------------------------------------
    #  stack_and_reach
    #  
proc myGUI::test::method_rattleCAD_HandleBarandSaddle {} {
    set currentFile   [myGUI::control::getSession  projectFile]
    set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                   
    puts "\n\n  ====== R A T T L E C A D    M E T H O D :   H A N D L E B A R   A N D   S A D D L E ===========\n"                         
    puts "" 
    
        #

        
    if 0 {   
            # from seattubetoptube method
        set init_HB_Reach     [myGUI::model::model_XZ::getScalar     Geometry HandleBar_Distance]
        set init_HB_Stack     [myGUI::model::model_XZ::getScalar     Geometry HandleBar_Height]  
        set init_SD_Distance  [myGUI::model::model_XZ::getScalar     Geometry Saddle_Distance]   
        set init_SD_Height    [myGUI::model::model_XZ::getScalar     Geometry Saddle_Height]     
        set init_HT_Angle     [myGUI::model::model_XZ::getScalar     Geometry HeadTube_Angle]    
        set init_TT_Angle     [myGUI::model::model_XZ::getScalar     Geometry TopTube_Angle]     
        set init_HT_Length    [myGUI::model::model_XZ::getScalar     HeadTube Length]            
        set init_Stem_Length  [myGUI::model::model_XZ::getScalar     Geometry Stem_Length]       
        set init_Fork_Height  [myGUI::model::model_XZ::getScalar     Geometry Fork_Height]       
        set init_Fork_Rake    [myGUI::model::model_XZ::getScalar     Geometry Fork_Rake]         
        set init_ST_Length    [myGUI::model::model_XZ::getScalar     Geometry SeatTube_LengthVirtual]  
        set init_TT_Length    [myGUI::model::model_XZ::getScalar     Geometry TopTube_LengthVirtual]   
        set init_SD_Nose      [myGUI::model::model_XZ::getScalar     Geometry SaddleNose_BB_x]   
        set init_ST_Angle     [myGUI::model::model_XZ::getScalar     Geometry SeatTube_Angle]  
        set init_ST_Ext       [myGUI::model::model_XZ::getScalar     SeatTube Extension]
        set init_SS_Offset    [myGUI::model::model_XZ::getScalar     SeatStay OffsetTT]
            #
        puts "         -> \$init_HB_Reach     $init_HB_Reach   "
        puts "         -> \$init_HB_Stack     $init_HB_Stack   "
        puts "         -> \$init_HT_Angle     $init_HT_Angle   "
        puts "         -> \$init_TT_Angle     $init_TT_Angle   "
        puts "         -> \$init_HT_Length    $init_HT_Length  "
        puts "         -> \$init_Stem_Length  $init_Stem_Length"
        puts "         -> \$init_Fork_Height  $init_Fork_Height"
        puts "         -> \$init_Fork_Rake    $init_Fork_Rake  "
        puts "         -> \$init_ST_Ext       $init_ST_Ext  "
        puts "         -> \$init_SS_Offset    $init_SS_Offset  "
        puts "         -> \$init_ST_Angle     $init_ST_Angle   "
        puts "         -> \$init_ST_Length    $init_ST_Length  "
        puts "         -> \$init_TT_Length    $init_TT_Length  "
        puts "         -> \$init_SD_Nose      $init_SD_Nose    "
        puts ""
        puts "        ------------------------------------------------"                                               
        puts ""
            #
            
            # -- set demo
        set maxLoops          4
        set loopSteps         6
        set direction         1
        set step_Fork_Height  [expr  30.0  / $loopSteps]
        set step_Fork_Rake    [expr  20.0  / $loopSteps]
        set step_ST_Ext       [expr  25.0  / $loopSteps]
        set step_SS_Offset    [expr  25.0  / $loopSteps]
        set step_ST_Angle     [expr   3.0  / $loopSteps]
        set step_HT_Angle     [expr   4.0  / $loopSteps]    
        set step_HT_Length    [expr  30.0  / $loopSteps]
        set step_TT_Angle     [expr  15.0  / $loopSteps]
            #
    }
        #
        #
    set maxLoops          4
    set loopSteps         6
        #
        #
    myGUI::gui::selectNotebookTab   "cv_Custom00"
    myGUI::view::edit::updateView   force
        #
    set cvObject        [myGUI::gui::getCanvasObject]
    set targetCanvas    [$cvObject getNamespace]
        #
        # set targetTab    "cv_Custom00"
        # set targetCanvas "myGUI::gui::$targetTab"
        #
        # myGUI::gui::selectNotebookTab        $targetTab  
        # myGUI::view::edit::updateView       force
        #
    myGUI::control::open_TemplateFile   Road
    myGUI::view::edit::updateView       force
        #
        #
    set title       "rattleCAD - Method"
    createDemoText_2    $cvObject  "$title"
    after 1000
        #
        # -- Sceleton
        #
    method_rattleCAD___Saddle                   $cvObject $maxLoops $loopSteps
    method_rattleCAD___HandleBar                $cvObject $maxLoops $loopSteps
    method_rattleCAD___StemSteeringAngleFork    $cvObject $maxLoops $loopSteps
        #
        #
    after 1000
    myGUI::gui::selectNotebookTab   "cv_Custom10"
    myGUI::view::edit::updateView   force
    set cvObject        [myGUI::gui::getCanvasObject]
    set targetCanvas    [$cvObject getNamespace]
        # set targetTab    "cv_Custom10"
        # set targetCanvas "myGUI::gui::$targetTab"
        #
        # myGUI::gui::selectNotebookTab        $targetTab  
        # myGUI::view::edit::updateView       force
        #
        # -- FrameTubes
        #
    method_rattleCAD___FrameTubes               $cvObject $maxLoops $loopSteps
        #
        #
    after 1000
    createDemoText_2    $cvObject       {... thats it!}  
    after  500
    createDemoText_2    $cvObject       {}
        #
    myGUI::view::edit::updateView       force
        #
      
        #
    return  
        # 
}

    # -- change Saddle-Position
    #
proc myGUI::test::method_rattleCAD___Saddle {cvObject maxLoops loopSteps} {
        #
    set direction         1
        #
    set title       "... Saddle"
    createDemoText_2  $cvObject  "$title"
    after 500
        #
    set stepCount      $loopSteps
        #
    set init_SD_Distance  [myGUI::model::model_XZ::getScalar     Geometry Saddle_Distance]   
    set init_SD_Height    [myGUI::model::model_XZ::getScalar     Geometry Saddle_Height]  
        #
    set demo_SD_Distance  $init_SD_Distance
    set demo_SD_Height    $init_SD_Height
        #
    set step_SD_Distance  [expr  25.0  / $loopSteps]
    set step_SD_Height    [expr  35.0  / $loopSteps]
        #
    puts "         -> \$init_SD_Distance  $init_SD_Distance / $step_SD_Distance"
    puts "         -> \$init_SD_Height    $init_SD_Height / $step_SD_Height"
        #
        # ----------------------------
        #
    set loopCount   0
    while {$loopCount < [expr $loopSteps * $maxLoops]} {            
            # -- check \$runningStatus
        if   {![keepRunning]} {stopDemo cleanup; return}
          #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
            #
        set demo_SD_Distance [expr $demo_SD_Distance + $direction*$step_SD_Distance]
        set demo_SD_Height   [expr $demo_SD_Height   + $direction*$step_SD_Height  ]
            #
        set myList {}
        lappend myList Scalar/Geometry/Saddle_Distance  $demo_SD_Distance  
        lappend myList Scalar/Geometry/Saddle_Height    $demo_SD_Height
            #
        myGUI::control::setValue $myList           {update} skipHistory
            #
    }
        #
}
    # -- change HandleBar - Position
    #
proc myGUI::test::method_rattleCAD___HandleBar {cvObject maxLoops loopSteps} {
        #
    set direction   1
        #
    set title       "... HandleBar"
    createDemoText_2  $cvObject  "$title"
    after 500
        #
    set stepCount      $loopSteps
        #
    set init_HB_Reach       [myGUI::model::model_XZ::getScalar     Geometry HandleBar_Distance]
    set init_HB_Stack       [myGUI::model::model_XZ::getScalar     Geometry HandleBar_Height]  
    set init_Stem_Length    [myGUI::model::model_XZ::getScalar     Geometry Stem_Length]
        #
    set demo_HB_Reach       $init_HB_Reach   
    set demo_HB_Stack       $init_HB_Stack
    set demo_Stem_Length    $init_Stem_Length
        #
    set _headAngle          [myGUI::model::model_XZ::getScalar     Geometry HeadTube_Angle]
        #
    set step_HB_Reach       [expr  20.0  / $loopSteps]
    set step_HB_Stack       [expr  15.0  / $loopSteps]
        # 
    puts "         -> \$init_HB_Reach      $init_HB_Reach / $step_HB_Reach"
    puts "         -> \$init_HB_Stack      $init_HB_Stack / $step_HB_Stack"
    puts "         -> \$init_Stem_Length   $init_Stem_Length ..."
        #
        # ----------------------------
        #
    set loopCount   0
    while {$loopCount < [expr $loopSteps * $maxLoops]} {            
            # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
            #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
            #
        set demo_HB_Stack     [expr $demo_HB_Stack    + $direction*$step_HB_Stack   ]
        set demo_HB_Reach     [expr $demo_HB_Reach    + $direction*$step_HB_Reach   ]
            #               
            # set step_Stem_Stack   [expr ($demo_HB_Stack - $init_HB_Stack) * cos([vectormath::rad $_headAngle])]
            # set step_Stem_Reach   [expr ($demo_HB_Reach - $init_HB_Reach) / sin([vectormath::rad $_headAngle])]
            #
            # set demo_Stem_Length  [expr $init_Stem_Length + $step_Stem_Stack + $step_Stem_Reach]
            #
        set myList {}
        lappend myList Scalar/Geometry/HandleBar_Height     $demo_HB_Stack
        lappend myList Scalar/Geometry/HandleBar_Distance   $demo_HB_Reach   
            # lappend myList Scalar/Geometry/Stem_Length          $demo_Stem_Length
            #
        myGUI::control::setValue $myList           {update} skipHistory
            #
    }
        #
}  
    # -- change Front Geometry
    #
proc myGUI::test::method_rattleCAD___StemSteeringAngleFork {cvObject maxLoops loopSteps} {
        #
    set direction   1
        #
    set title       "... Stem, SteeringAngle and Fork"       
    createDemoText_2    $cvObject  "$title"
    after 1000
        #

    set stepCount      $loopSteps
        #
    set init_HT_Angle       [myGUI::model::model_XZ::getScalar     Geometry HeadTube_Angle]    
    set init_Stem_Angle     [myGUI::model::model_XZ::getScalar     Geometry Stem_Angle]       
    set init_Stem_Length    [myGUI::model::model_XZ::getScalar     Geometry Stem_Length]       
    set init_Fork_Height    [myGUI::model::model_XZ::getScalar     Geometry Fork_Height]       
    set init_Fork_Rake      [myGUI::model::model_XZ::getScalar     Geometry Fork_Rake]         
        #
    set demo_HT_Angle       $init_HT_Angle
    set demo_Stem_Angle     $init_Stem_Angle
    set demo_Stem_Length    $init_Stem_Length
    set demo_Fork_Rake      $init_Fork_Rake  
    set demo_Fork_Height    $init_Fork_Height
        #
    set step_HT_Angle       [expr   3.0  / $loopSteps]    
    set step_Stem_Angle     [expr  12.0  / $loopSteps]    
    set step_Stem_Length    [expr  20.0  / $loopSteps]    
    set step_Fork_Height    [expr  12.0  / $loopSteps]
    set step_Fork_Rake      [expr  15.0  / $loopSteps]
        #
        # ----------------------------
        #
    puts "         -> \$init_HT_Angle     $init_HT_Angle / $step_HT_Angle   "
    puts "         -> \$init_Stem_Angle   $init_Stem_Angle / $step_Stem_Angle"
    puts "         -> \$init_Stem_Length  $init_Stem_Length / $step_Stem_Length"
        # ----------------------------
    set loopCount   0
    while {$loopCount < [expr $loopSteps * $maxLoops]} {            
          # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
          #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
        
        set demo_HT_Angle    [expr $demo_HT_Angle    + $direction*$step_HT_Angle]
        set demo_Stem_Angle  [expr $demo_Stem_Angle  - $direction*$step_Stem_Angle]
        set demo_Stem_Length [expr $demo_Stem_Length - $direction*$step_Stem_Length]
          #
        set myList {}
        lappend myList Scalar/Geometry/HeadTube_Angle   $demo_HT_Angle
        lappend myList Scalar/Geometry/Stem_Angle       $demo_Stem_Angle
        lappend myList Scalar/Geometry/Stem_Length      $demo_Stem_Length
            #                 
        myGUI::control::setValue $myList           {update} skipHistory
            #
    }
        #
        # ----------------------------
        #
    puts "         -> \$init_Fork_Height  $init_Fork_Height / $step_Fork_Height"
    puts "         -> \$init_Fork_Rake    $init_Fork_Rake  / $step_Fork_Rake  "
        # ----------------------------
    set loopCount   0
    while {$loopCount < [expr $loopSteps * $maxLoops]} {            
          # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
          #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
        
        set demo_Fork_Rake   [expr $demo_Fork_Rake   - $direction*$step_Fork_Rake]
        set demo_Fork_Height [expr $demo_Fork_Height + $direction*$step_Fork_Height]
          #
        set myList {}
        lappend myList Scalar/Geometry/Fork_Height      $demo_Fork_Height 
        lappend myList Scalar/Geometry/Fork_Rake        $demo_Fork_Rake
            #                 
        myGUI::control::setValue $myList           {update} skipHistory
            #
    }
        #
}
    # -- change FrameTubes
    #
proc myGUI::test::method_rattleCAD___FrameTubes {cvObject maxLoops loopSteps} {
        #
    set direction   1
        #
    set title       "... FrameTubes"       
    createDemoText_2    $cvObject   "$title"
    after 1000
        #    
        #
    set stepCount      $loopSteps
        #
    set init_HT_Length      [myGUI::model::model_XZ::getScalar   HeadTube Length]            
    set init_TT_Offset      [myGUI::model::model_XZ::getScalar   TopTube  OffsetHT]     
    set init_DT_Offset      [myGUI::model::model_XZ::getScalar   DownTube OffsetHT]     
    set init_TT_Angle       [myGUI::model::model_XZ::getScalar   Geometry TopTube_Angle]     
    set init_ST_Ext         [myGUI::model::model_XZ::getScalar   SeatTube Extension]
    set init_SS_Offset      [myGUI::model::model_XZ::getScalar   SeatStay OffsetTT]
        #   
    set demo_TT_Offset      $init_TT_Offset
    set demo_DT_Offset      $init_DT_Offset
    set demo_HT_Length      $init_HT_Length
    set demo_TT_Angle       $init_TT_Angle
    set demo_ST_Ext         $init_ST_Ext
    set demo_SS_Offset      $init_SS_Offset
        #   
    set step_HT_Length      [expr  15.0  / $loopSteps]
    set step_ST_Ext         [expr  10.0  / $loopSteps]
    set step_SS_Offset      [expr  20.0  / $loopSteps]                    
    set step_TT_Angle       [expr   4.0  / $loopSteps]    
    set step_TT_Offset      [expr   6.0  / $loopSteps]    
    set step_DT_Offset      [expr   6.0  / $loopSteps]    
        #
        #
        # ----------------------------
        #
    puts "         -> \$init_HT_Length     $init_HT_Length / $step_HT_Length"
    puts "         -> \$init_TT_Offset     $init_TT_Offset / $step_TT_Offset"
    puts "         -> \$init_DT_Offset     $init_DT_Offset / $step_DT_Offset"
        # ----------------------------
    set loopCount   0
    while {$loopCount < [expr 2 * $loopSteps * $maxLoops]} {            
          # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
          #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
            #
        set demo_HT_Length  [expr $demo_HT_Length - $direction*$step_HT_Length]
        set demo_TT_Offset  [expr $demo_TT_Offset - $direction*$step_TT_Offset]
        set demo_DT_Offset  [expr $demo_DT_Offset - $direction*$step_DT_Offset]
            #
        set myList {}
        lappend myList Scalar/HeadTube/Length       $demo_HT_Length          
        lappend myList Scalar/TopTube/OffsetHT      $demo_TT_Offset          
        lappend myList Scalar/DownTube/OffsetHT     $demo_DT_Offset         
            #
        myGUI::control::setValue $myList           {update} skipHistory
            #
    }                     
        #
        #
        # ----------------------------
        #
    puts "         -> \$init_TT_Angle      $init_TT_Angle / $step_TT_Angle "
    puts "         -> \$init_ST_Ext        $init_ST_Ext / $step_ST_Ext   "
    puts "         -> \$init_SS_Offset     $init_SS_Offset / $step_SS_Offset"          
        # ----------------------------
    set loopCount   0
    while {$loopCount < [expr 2 * $loopSteps * $maxLoops]} {            
            # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
            #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
            #
        set demo_TT_Angle   [expr $demo_TT_Angle  + $direction*$step_TT_Angle]
        set demo_ST_Ext     [expr $demo_ST_Ext    - $direction*$step_ST_Ext]
        set demo_SS_Offset  [expr $demo_SS_Offset - $direction*$step_SS_Offset]
            #
        set myList {}
        lappend myList Scalar/Geometry/TopTube_Angle        $demo_TT_Angle      ;# Custom/TopTube/Angle            
        lappend myList Scalar/SeatTube/Extension            $demo_ST_Ext        ;# Custom/SeatTube/Extension       
        lappend myList Scalar/SeatStay/OffsetTT             $demo_SS_Offset     ;# Custom/SeatStay/OffsetTT        
            #
        myGUI::control::setValue $myList           {update} skipHistory
            #
    }
}


    #-------------------------------------------------------------------------
    #  classic Seat- and TopTube method
    #     
proc myGUI::test::method_classic_SeatandTopTube {} {

    set currentFile   [myGUI::control::getSession  projectFile]
    set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                   
    puts "\n\n  ======  T H E   C L AS S I C - M E T H O D:    U S I N G   C O N S T A N T   T O P - T U B E  ===========\n"                         
    puts "" 
    
        #
    myGUI::gui::selectNotebookTab   "cv_Custom00"
    myGUI::view::edit::updateView   force
        #
    set cvObject        [myGUI::gui::getCanvasObject]
    set targetCanvas    [$cvObject getNamespace]
        #
        
        # set targetTab    "cv_Custom00"
        # set targetCanvas "myGUI::gui::$targetTab"
             ##
        # myGUI::gui::selectNotebookTab  $targetTab  
        # myGUI::view::edit::updateView       force
             ##
    myGUI::control::open_TemplateFile   Road
    myGUI::view::edit::updateView       force
        #
      
        #
    set init_ST_Angle     [myGUI::model::model_XZ::getScalar     Geometry SeatTube_Angle]  
    set init_ST_Length    [myGUI::model::model_XZ::getScalar     Geometry SeatTube_LengthVirtual]  
    set init_TT_Length    [myGUI::model::model_XZ::getScalar     Geometry TopTube_LengthVirtual]   
    set init_SD_Nose      [myGUI::model::model_XZ::getScalar     Geometry SaddleNose_BB_x]   
        #

    puts ""
    puts "         -> \$init_ST_Angle     $init_ST_Angle   "
    puts "         -> \$init_ST_Length    $init_ST_Length  "
    puts "         -> \$init_TT_Length    $init_TT_Length  "
    puts "         -> \$init_SD_Nose      $init_SD_Nose    "
    puts ""
    puts "        ------------------------------------------------"                                               
    puts ""
        #
        
        # -- set demo
    set maxLoops          4
    set loopSteps         6
    set direction         1
    set step_ST_Angle     [expr 2.0 / $loopSteps]
        #
    
        # -- change Saddle- and HandleBarPosition
        #
    set title       "  ... the Classic-Method: "
    createDemoText_2 $cvObject  "$title"
    after 2000
    set title       "  ... keep constant Seat- and TopTube Length "
    createDemoText_2 $cvObject  "$title"
    
      
        #
    set loopCount      0
    set stepCount      $loopSteps
        #
    set demo_ST_Angle  $init_ST_Angle
        #
    while {$loopCount < [expr $loopSteps * $maxLoops]} {            
          # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
          #
        incr loopCount 
        if {$stepCount >= 2*$loopSteps} {
            set stepCount 1
            set direction [expr -1 * $direction]
            after 50
        } else {
            incr stepCount
        }
        
        set demo_ST_Angle [expr $demo_ST_Angle + $direction*$step_ST_Angle]
          #
        set myList {}
        lappend myList  Scalar/Geometry/SeatTube_Angle          $demo_ST_Angle 
        lappend myList  Scalar/Geometry/SeatTube_LengthVirtual        $init_ST_Length
        lappend myList  Scalar/Geometry/TopTube_LengthVirtual   $init_TT_Length
        lappend myList  Scalar/Geometry/SaddleNose_BB_x         $init_SD_Nose  
            #
        foreach {key value} $myList {
            puts "       ... \$keyValue: $key $value"
        }
            #
        myGUI::control::setValue $myList  {update}    {skipHistory}
            #
    }
        #
    createDemoText_2 $cvObject  {}  
    myGUI::view::edit::updateView       force    
        #
    return    
        #
}


    #-------------------------------------------------------------------------
    #  loopSamples
    #     
proc myGUI::test::loopSamples {args} {
    set currentFile [myGUI::control::getSession  projectFile]
    set SAMPLE_Dir  $::APPL_Config(SAMPLE_Dir)

    puts "\n\n  ====== l o o p   S A M P L E   F i l e s ========\n"                         
    puts "      currentFile  ... $currentFile"
    puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
    puts "" 

        #
        # myPersist::file::saveProject_xml saveAs    
        #
    myGUI::gui::selectNotebookTab   "cv_Custom30"
    myGUI::view::edit::updateView   force
        #
    set cvObject        [myGUI::gui::getCanvasObject]
    set targetCanvas    [$cvObject getNamespace]
        #
        # set targetTab    "cv_Custom30"
        # set targetCanvas "myGUI::gui::$targetTab"
        #
        # myGUI::gui::selectNotebookTab        $targetTab  
        #
    createDemoText_2 $cvObject  {... demo Samples}  
        #
    
        #
    foreach fileName [lsort [glob -directory [file normalize $SAMPLE_Dir] -type f *.xml]] {
            # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
            #
        puts "\n     open Sample File:"
        puts "          .... $fileName\n"
        myGUI::control::open_ProjectFile   $fileName
            #
        createDemoText_2 $cvObject  [format {... %s} [file tail $fileName]]
            #
        after 1500
            #
    }
      # -- open previous opened File   
    puts "\n      ... open previous opened file:"
    puts "\n            ... $currentFile"
    switch -exact $currentFile {
        {Template Road} {
            myGUI::control::open_TemplateFile  Road
        }        
        {Template MTB} {
            myGUI::control::open_TemplateFile  MTB
        }
        default {
            myGUI::control::open_ProjectFile   $currentFile    
        }
    }
    after 1500        
    createDemoText_2 $cvObject  {... done}  
    after  500
    createDemoText_2 $cvObject  {}  
    myGUI::view::edit::updateView       force
        
      # tk_messageBox -title "loop Samples" -message "... $SAMPLE_Dir!"   
}     


    #-------------------------------------------------------------------------
    #  loopNotebook
    #     
proc myGUI::test::loopNotebook {} {
        #
    set noteBook_top    $myGUI::gui::notebookObject
        #
    set cv_ID       [myGUI::gui::current_notebookTabID]            
        #
    foreach cadCanv [lsort [array names myGUI::gui::notebookObject]] {
        if {$cadCanv == {cv_Custom02}} {continue}
            # tk_messageBox -message "   -> $cadCanv"
            # puts "  <D> -> $cadCanv"
        myGUI::gui::selectNotebookTab   $cadCanv
        update
    }
        # puts "  myGUI::gui::selectNotebookTab $cv_ID "
    myGUI::gui::selectNotebookTab   $cv_ID 
        #
    return
        #
}    


    #-------------------------------------------------------------------------
    #  demo 01
    #     
proc myGUI::test::demo_01 {args} {
    set currentFile [myGUI::control::getSession  projectFile]
    set SAMPLE_Dir     $::APPL_Config(SAMPLE_Dir)
                   
    puts "\n\n  ====== D E M O N S T R A T I O N   0 1 ===========\n"                         
    puts "      currentFile  ... $currentFile"
    puts "      SAMPLE_Dir  .... $SAMPLE_Dir"
    puts "" 
 
    
    set values [[namespace current]::demoValues  30 -3  5  2]  
    puts " ... \$values .. $values" 
    set values [[namespace current]::demoValues  30  5 -3  2]  
    puts " ... \$values .. $values" 
    
        # proc setValue {arrayName type args}
        # proc getValue {arrayName type args}
        
        # myGUI::gui::selectNotebookTab   cv_Custom00
    
    # -- update display -----------
    myGUI::gui::notebook_refitCanvas
    myGUI::cvCustom::updateView [myGUI::gui::current_notebookTabID]
    
    
    # -- morphing -----------------
    updateGeometryValue     Scalar/Geometry/Saddle_Distance            25  -35   5 \
                            Scalar/Geometry/HandleBar_Distance        -25   35   5 \
                            Scalar/Geometry/Saddle_Height             -35   25   5 \
                            Scalar/Geometry/HandleBar_Height          -35   25   5 
                                    
    updateGeometryValue     Scalar/Geometry/HandleBar_Distance        -10    8   3 \
                            Scalar/Geometry/HandleBar_Height           25  -15   2 

    updateGeometryValue     Scalar/Geometry/BottomBracket_Depth       -20   15   3 \
    
    updateGeometryValue     Scalar/Geometry/RearWheel_Position         25  -10   5 
    
    updateGeometryValue     Scalar/Geometry/HeadTube_Angle             -1   2    1 

    updateGeometryValue     Scalar/Geometry/RearWheel_Radius           45  -45   0 \
                            Scalar/Geometry/FrontWheel_Radius          45  -45   0 

    updateGeometryValue     Scalar/Geometry/BottomBracket_Depth       -30   25  10 \
                            Scalar/FrameTubes/HeadTube_Length         -30   25  10
                                    
    updateGeometryValue     Scalar/Geometry/TopTube_Angle               3   -4   1 
                                    

    return

}   


    # -------------------------------------------------------------------------
    #  updateGeometryValue
    #    
proc myGUI::test::updateGeometryValue {args} {
    
    set _index 0
    array set myValues {}
    foreach {key left right end} $args {
          # -- check \$runningStatus
        if {![keepRunning]} {stopDemo cleanup; return}
            #                #
            # puts "   $key "    
            #
            # puts ""
        set currentValue  [lindex [array get myGUI::control::_currentValue $key] 1]   ;# 20141121 .. unchecked, 20141212 ... checked
            # puts "   \$currentValue $currentValue" 
            #
        set valueList [[namespace current]::demoValues $currentValue $left $right $end]
            #
        set myValues($_index) [appUtil::flatten_nestedList $key $valueList]
        incr _index
    }
    puts "   ..."
        # parray myValues
    set arraySize [array size myValues]
        # puts "    ... $arraySize"
     
     
    if {$arraySize > 0} {
        set listLength [llength $myValues(0)]
        puts "    ... $listLength"
    } else {
        return
    }
     
    set listIndex  1
    set arrayIndex 0
    while {$listIndex < $listLength} {
            #
        set paramValueList {}
        while {$arrayIndex < $arraySize} {
            set key       [lindex $myValues($arrayIndex) 0]
            set paramValue  [lindex $myValues($arrayIndex) $listIndex]
            puts "         ... $arrayIndex / $listIndex      -> $key : $paramValue"
            lappend paramValueList $key $paramValue 
            incr arrayIndex 
        }
        myGUI::control::setValue $paramValueList update skipHistory

        set  arrayIndex 0
        incr listIndex
    }
}  


    # -------------------------------------------------------------------------
    #  deliver demo Values
    #
proc myGUI::test::demoValues {base left right end} {
    
    set precission 3
    set valueList  {}
    
    
    set currentValue    $base
    
    set step [expr 1.0*$left/$precission]
    set i 0
    while {$i < $precission} {
        set currentValue [expr $currentValue + $step]
        lappend valueList $currentValue
        incr i
    }
    set i 0
    while {$i < $precission} {
        set currentValue [expr $currentValue - $step]
        lappend valueList $currentValue
        incr i
    }
    
    
    set step [expr 1.0*$right/$precission]
    set i 0
    while {$i < $precission} {
        set currentValue [expr $currentValue + $step]
        lappend valueList $currentValue
        incr i
    }
    set i 0
    while {$i < $precission} {
        set currentValue [expr $currentValue - $step]
        lappend valueList $currentValue
        incr i
    }
    
    
    set step [expr 1.0*$end/$precission]
    set i 0
    while {$i < $precission} {
        set currentValue [expr $currentValue + $step]
        lappend valueList $currentValue
        incr i
    }       
    
    return $valueList
    
}     

proc myGUI::test::createDemoText_2 {cvObject myText} {
        #
        # puts ""
        # puts "   -------------------------------"
        # puts "    myGUI::test::createDemoText"
        # puts "       cv_Name:         $cv_Name"
        #
    set cv_Name [$cvObject getNamespace]
        #
        #
    set stageCanvas     [$cvObject  configure   Canvas  Path]
    set canvasScale     [$cvObject  configure   Canvas  Scale]
    set stageScale      [$cvObject  configure   Stage  Scale]
    set stageFormat     [cad4tcl::_getFormatSize [$cvObject  configure   Stage Format]]
        #
    set formatWidth     [lindex $stageFormat 0]        
    set formatHeight    [lindex $stageFormat 1]        
        #
        # --- create Text:
    set myFont          "Helvetica"
    set myFontSize      [expr round(3.5 / ($stageScale * $canvasScale))]
    set myTextAnchor    nw
        #
        # --- remove existing text with tagID
    set removeItem [$cvObject find withtag {__Comment__ && ___demoText___}]
        # puts "      -> $removeItem $removeItem"
    catch {$cvObject delete $removeItem}
        #
        
        # --- return if only remove ___demoText___
    if {$myText == {}} {
        return
    }
    
        # --- create Text: DIN Format
        #
        # --- outer border
    set df_Border           2
        #
    set pos_x       [expr 0             + $df_Border ]
    set pos_y       [expr $formatHeight - $df_Border ]          
        #
    set textPos     [scaleToStage  [list $pos_x $pos_y]    [expr 1/$stageScale]]
        #
    # tk_messageBox -message "here I am"    
        #
    set commentText [$cvObject create text $textPos  [list -text $myText -font $myFont -size $myFontSize -anchor $myTextAnchor -tags {__Comment__}]]
        #
    $cvObject addtag {___demoText___} withtag $commentText 
    $cvObject dtag   $commentText {__Content__}
        #
    update
        #
    return
        #            
}

proc myGUI::test::testResultParameter {} {
        # tk_messageBox -message "testResultParameter"               
    set parameterList {                     
            Scalar/Geometry/HeadLug_Angle_Top
            Scalar/Geometry/SeatTube_Angle
            Scalar/Geometry/BottomBracket_Height
            Scalar/Geometry/FrontWheel_xy
            Scalar/Geometry/FrontWheel_x
            Scalar/Geometry/FrontWheel_Radius
            Scalar/Geometry/Reach_Length
            Scalar/Geometry/Stack_Height
            Scalar/Geometry/SaddleNose_HB
            Scalar/Geometry/RearWheel_x
            Scalar/Geometry/RearWheel_Radius
            Scalar/Geometry/SaddleNose_BB_x
            Scalar/Geometry/Saddle_Offset_BB_ST
            Scalar/Geometry/Saddle_HB_y
            Scalar/Geometry/Saddle_BB
            Scalar/Geometry/SeatTube_LengthVirtual
            Scalar/Geometry/TopTube_LengthVirtual }

            # Scalar/Reference/SaddleNose_HB_y
            # Scalar/Reference/SaddleNose_HB
            # Scalar/RearWheel/TyreShoulder
            
            # {Result/Angle/HeadTube/TopTube   }

    
    foreach resultKey $parameterList {
        # puts "    ... $resultKey"
        
        # puts "  ... $resultKey "
        set currentValue [lindex [array get myGUI::view::edit::_updateValue $resultKey] 1]
        # puts "      ... $currentValue"
        # continue
        # _updateValue
        puts "\n\n <I> -> testResultParameter \n <I>      ... $resultKey    ... $currentValue\n"
            #
        set newValue [expr $currentValue - 2.6]
        puts " <I>      ... $resultKey    ... $newValue\n"
        myGUI::control::setValue [list $resultKey  $newValue]
        set newValue [expr $currentValue + 2.6]
        puts " <I>      ... $resultKey    ... $newValue\n"
        myGUI::control::setValue [list $resultKey  $newValue]
            #
        puts " <I>      ... $resultKey    ... $currentValue\n"
        myGUI::control::setValue [list $resultKey  $currentValue]
            #
        # tk_messageBox -message "was resultKey: $resultKey" 
    }
    
    puts "\n\n"
    puts "      #"
    puts "      # ---- testResultParameter ---- done ------"
    puts "      #"
    puts "\n\n"
}

proc myGUI::test::scaleToStage     {ptList factor} {
    return [ vectormath::scaleCoordList {0 0} $ptList $factor ]
}
    #-------------------------------------------------------------------------
    #
    #  end  namespace eval rattleCAD_Test 
    #



