 ##+##########################################################################
 #
 # chainWheel_SVG.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2010/02/06
 #
 #   canvas_CAD is licensed using the GNU General Public Licence,
 #        see http://www.gnu.org/copyleft/gpl.html
 # 
 


set WINDOW_Title      "chainWheel-SVG-Profile"


set APPL_ROOT_Dir [file dirname [file dirname [lindex $argv0]]]
puts $APPL_ROOT_Dir
lappend auto_path [file dirname $APPL_ROOT_Dir]
lappend auto_path "$APPL_ROOT_Dir/lib"



set w_textReport  {}

namespace eval sketchboard {
        
    variable cvNamespace
    
        # defaults
    variable start_angle        20
    variable start_length       80
    variable teethCount         53
    variable end_length         65
        #
    variable crankLength       170    
    variable crankRadiusPedal   15    
    variable crankRadiusAxle    20   
        #
    variable dim_size            5
    variable dim_dist           30
    variable dim_offset          0
    variable dim_type_select    aligned
    variable dim_font_select    vector
    variable std_fnt_scl         1
    variable font_colour        black
    variable demo_type          dimension
    variable drw_scale           0.8
    variable cv_scale            1
}
    
                
 
namespace eval chainWheel::gui {
    variable WINDOW_Title      "chainWheel-SVG-Profile"
    variable f_report
    variable w_textReport  {}
    
    variable cvNamespace
    variable cvObject
    variable cvNamespace
    
        # defaults
    variable start_angle        20
    variable start_length       80
    variable teethCount         53
    variable end_length         65
        #
    variable crankLength       170    
    variable crankRadiusPedal   15    
    variable crankRadiusAxle    20   
        #
    variable dim_size            5
    variable dim_dist           30
    variable dim_offset          0
    variable dim_type_select    aligned
    variable dim_font_select    vector
    variable std_fnt_scl         1
    variable font_colour        black
    variable demo_type          dimension
    variable drw_scale           0.8
    variable cv_scale            1  

    variable w_textReport
}

    ##+######################

proc chainWheel::gui::create_config_line {w lb_text entry_var start end  } {        
        frame   $w
        pack    $w
 
        global $entry_var

        label   $w.lb   -text $lb_text            -width 15  -bd 1  -anchor w 
        entry   $w.cfg  -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
     
        scale   $w.scl  -width        12 \
                        -length       120 \
                        -bd           1  \
                        -sliderlength 15 \
                        -showvalue    0  \
                        -orient       horizontal \
                        -command      [list [namespace current]::updateValue $entry_var] \
                        -variable     $entry_var \
                        -from         $start \
                        -to           $end 
                            # -resolution   $resolution
                            
        pack      $w.lb  $w.cfg $w.scl    -side left  -fill x
        bind      $w.cfg <Leave>  [list [namespace current]::updateValue $entry_var]
        bind      $w.cfg <Return> [list [namespace current]::updateValue $entry_var]
        # trace add variable    $entry_var   write [list puts ""  -> update"]
                
}
proc chainWheel::gui::create_status_line {w lb_text entry_var} {         
        frame   $w
        pack    $w
 
        global $entry_var

        label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
        entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
        pack      $w.lb  $w.cfg    -side left  -fill x            
}
proc chainWheel::gui::updateValue {varName args} {
    variable teethCount
    puts "   ... updateValue:  $varName $args"
    set varName [lindex [split $varName ::] end]
    switch -exact $varName {
        teethCount {
                update 
                # puts "   -> $varName $value"
                set value [lindex $args 0]
                if {$value eq {}} return
                set [namespace current]::$varName $value
                puts "       updateValue -> [set [namespace current]::$varName]"
                update_board $value
                # update_board $value
                return
            }
        default {
            # puts "   default -> $varName $value"
        }
    }
}
proc chainWheel::gui::exportSVG {} {
    variable w_textReport
    variable teethCount
        #
    if {[catch {set xmlContent [$w_textReport get 1.0  end]} eID]} {
        tk_messageBox -message "<E> could not get content of SVG"
    } else {
       puts "$xmlContent"
    }
    
    set types {
            {{SVG}       {.svg}  }
        }
    set initialFile [format {ChainWheel_Profile_%s.svg} $teethCount]
    set initialDir  [file normalize .]  
    
    set fileName    [tk_getSaveFile -initialdir $initialDir -initialfile $initialFile -filetypes $types]  
    if {$fileName == {}} return
        # -- $fileName has extension xml
            # puts " [file extension $fileName] "
    if {! [string equal [file extension $fileName] {.svg}]} {
        set fileName [format "%s.%s" $fileName svg]
        puts "           ... new $fileName"
    }  
    
    # -- open File for writing
    if {[file exist $fileName]} {
        if {[file writable $fileName]} {
            set fp [open $fileName w]
            puts $fp $xmlContent
            close $fp
            puts ""
            puts "         ------------------------"
            puts "           ... write:"   
            puts "                       $fileName"
            puts "                   ... done"
        } else {
        tk_messageBox -icon error -message "File: \n   $fileName\n  ... not writeable!"
        exportSVG
        }
    } else {
            set fp [open $fileName w]
            puts $fp $xmlContent
            close $fp
            puts ""
            puts "         ------------------------"
            puts "           ... write:"  
            puts "                       $fileName "
            puts "                   ... done"
    }
              
        
        
}

    ##+######################

proc chainWheel::gui::createStage {cv_path cv_width cv_height args} {
        variable cvObject
        variable cvNamespace
        variable cv_scale
            #
        puts "   \$args $args"    
            # 
        set cvObject    [eval cad4tcl::new  $cv_path  \
                            $cv_width $cv_height \
                            A4 \
                            0.5 40  $args]
            #
        set cvPath      [$cvObject getCanvas]
        set cvNamespace [$cvObject getNamespace]
            #
        puts " ... $cvNamespace"
        set cv_scale [$cvObject configure Canvas Scale]
            #
        return $cvNamespace
    }

proc chainWheel::gui::update_board {{value {0}} args} {
    
        variable  cvObject
        variable  cvNamespace
        variable  f_report
        variable  w_textReport
        
        variable  start_angle 
        variable  start_length
        variable  teethCount
        variable  end_length
        variable  dim_size
        variable  dim_dist
        variable  dim_offset
        variable  dim_font_select
        variable  dim_type_select
        variable  std_fnt_scl
        variable  font_colour
        variable  demo_type
        variable  drw_scale 
        variable  dim_type_select
        
        #set value $teethCount
        puts "update_board   -> $value $args "
        if {$value == {update}} {
            # --- values on bind are: sketchboard::teethCount {} write 
            set value $teethCount
            puts "   --> $value "
        }

        
        $cvObject deleteContent
    
        if {$font_colour == {default}} { 
            set font_colour [$cvObject configure Style Fontcolour ]
        }
        
        puts "\n\n============================="
        puts "   -> drw_scale:          $drw_scale"
        puts "   -> font_colour:        $font_colour"
        puts "   -> dim_size:           $dim_size"
        puts "   -> dim_font_select:    $dim_font_select"
        puts "\n============================="
        #puts "   -> Drawing:            [[$cvNamespace getNode Stage] asXML]"
        #puts "\n============================="
        #puts "   -> Style:              [[$cvNamespace getNode Style] asXML]"
        #puts "\n============================="
        #$cvNamespace reportMyDictionary
        #puts "\n============================="
        puts "\n\n"

        $cvObject configure Stage Scale       $drw_scale
        $cvObject configure Style Fontstyle   $dim_font_select
        $cvObject configure Style Fontsize    $dim_size
        
        
        if {$demo_type != {dimension} } {
            demo_canvasCAD 
            return
        }
        
        # ------------------------------------
            # update $cvNamespace ->
            #
        set toothWith           12.7
        set toothWithAngle      [expr 2*$vectormath::CONST_PI/$teethCount]
        set chainWheelRadius    [expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
                # =0,5*H6/SIN(D13)
        set chainWheelProfile   [getChainWheel $teethCount]
        set toothCenterList     [lindex $chainWheelProfile 0]
        set toothProfileList    [lindex $chainWheelProfile 1]
        
            # -- create circles as chain-representation
            #
        foreach {pos} $toothCenterList {
            puts "    <-0001-> $pos"
            $cvObject addtag {__ChainWheel__} withtag  [$cvObject  create   circle  $pos -radius 4.2  -width 0.01  -outline blue  -fill grey80]
        }
            
            # -- create teeth profile
            #
        set toothProfileList [cad4tcl::_flattenNestedList $toothProfileList]
        set chainWheelProfile [$cvObject  create polygon $toothProfileList -fill white  -width 0.01   -outline red  -fill grey70]
        $cvObject addtag {__ChainWheel__} withtag  $chainWheelProfile           
        
            # -- create base
            #
        set p_end   [vectormath::rotateLine  {0 0}  $end_length    $teethCount]
        $cvObject addtag {__ChainWheel__} withtag  [$cvObject  create   circle {0 0}    -radius 2  -outline red  -width 0.01   -fill white]
        $cvObject addtag {__ChainWheel__} withtag  [$cvObject  create   line [list  0 0  [lindex $p_end 0]  [lindex $p_end 1] ] -tags dimension  -width 0.01   -fill blue ]
        
            #
            #
        $w_textReport delete 1.0  end 
        $w_textReport  insert end "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
        
        
        $w_textReport  insert end "<svg xmlns=\"http://www.w3.org/2000/svg\"\n"
        $w_textReport  insert end "width=\"500mm\" height=\"500mm\"\n" 
        $w_textReport  insert end "viewBox=\"-250 -250 500 500\"\n"
        $w_textReport  insert end "version=\"1.1\">\n"
        
        $w_textReport  insert end "<g>\n"
        $w_textReport  insert end "   <polygon points=\""
        foreach {x y} $toothProfileList {
            $w_textReport  insert end "$x,$y  "
        }
        $w_textReport  insert end "\"  />"
        $w_textReport  insert end "\n"
        $w_textReport  insert end "   <circle  cx=\"00\" cy=\"00\" r=\"4.5\" id=\"center_00\"/>\n"
        $w_textReport  insert end "</g>\n"
        $w_textReport  insert end "</svg>\n"
        [namespace current]::moveto_StageCenter {__ChainWheel__}

}

proc chainWheel::gui::getChainWheel {teethCount} {
        set toothWith           12.7
        set toothWithAngle      [expr 2*$vectormath::CONST_PI/$teethCount]
        set chainWheelRadius    [expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
            # loop for every tooth
        set index 0
        set toothCenterList {}
        set toothProfileList {}
        while { $index < $teethCount } {
            set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
            set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]
            # $cvNamespace addtag {__ChainWheel__} withtag  [$myCanvas  create   circle  $pos -radius 3.8]
            lappend toothCenterList $pos
                #
            set rollRadius 4.2
                #
            set pt_00 {1.2 5.5}                                 ; foreach {x0 y0} $pt_00 break
            set pt_01 [vectormath::rotateLine {0 0} $rollRadius 110]    ; foreach {x1 y1} $pt_01 break
            set pt_02 [vectormath::rotateLine {0 0} $rollRadius 120]    ; foreach {x2 y2} $pt_02 break
            set pt_03 [vectormath::rotateLine {0 0} $rollRadius 130]    ; foreach {x3 y3} $pt_03 break
            set pt_04 [vectormath::rotateLine {0 0} $rollRadius 140]    ; foreach {x4 y4} $pt_04 break
            set pt_05 [vectormath::rotateLine {0 0} $rollRadius 150]    ; foreach {x5 y5} $pt_05 break
            set pt_06 [vectormath::rotateLine {0 0} $rollRadius 160]    ; foreach {x6 y6} $pt_06 break
            set pt_07 [vectormath::rotateLine {0 0} $rollRadius 170]    ; foreach {x7 y7} $pt_07 break
            set pt_08 [vectormath::rotateLine {0 0} $rollRadius 180]    ; foreach {x8 y8} $pt_08 break
            set tmpList_00 [list    $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x5 -$y5    $x6 -$y6    $x7 -$y7    $x8 -$y8    \
                                    $x7  $y7    $x6  $y6    $x5  $y5    $x4  $y4    $x3  $y3    $x2  $y2    $x1  $y1    $x0  $y0]
            set tmpList_01 {}
            foreach {x y} $tmpList_00 {
                set pt_xy [list $x $y]
                set pt_xy [vectormath::rotatePoint {0 0} $pt_xy $currentAngle]
                set pt_xy [vectormath::addVector $pos $pt_xy]
                set tmpList_01 [lappend tmpList_01 [cad4tcl::_flattenNestedList $pt_xy] ]
            }
            set toothProfileList [lappend toothProfileList [cad4tcl::_flattenNestedList $tmpList_01]]
            set index [expr $index + 1]
        }
            #
        return [list $toothCenterList $toothProfileList]
}

proc chainWheel::gui::moveto_StageCenter {item} {
    variable cvObject
    set stage         [$cvObject getCanvas]
    set stageCenter [$cvObject getCenter]
    set bottomLeft  [$cvObject getBottomLeft]
    foreach {cx cy} $stageCenter break
    foreach {lx ly} $bottomLeft  break
    $stage move $item [expr $cx - $lx] [expr $cy -$ly]
}

proc chainWheel::gui::demo_canvasCAD {} {
            
    variable  cvNamespace
    
    $cvNamespace  create   line         {0 0 20 0 20 20 0 20 0 0}         -tags {Line_01}  -fill blue   -width 2 
    $cvNamespace  create   line         {30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
    $cvNamespace  create   line         {0 0 30 30 }         -tags {Line_01}  -fill blue   -width 2 
    
    $cvNamespace  create   rectangle    {180 120 280 180 }     -tags {Line_01}  -fill violet   -width 2 
    $cvNamespace  create   polygon      {40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

    $cvNamespace  create   oval         {30 160 155 230 }     -tags {Line_01}  -fill red   -width 2         
    $cvNamespace  create   circle       {160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
    $cvNamespace  create   arc          {270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
    
    $cvNamespace  create   text         {140 90}  -text "text a"
    $cvNamespace  create   vectortext   {120 70}  -text "vectorText ab"
    $cvNamespace  create   vectortext   {100 50}  -text "vectorText abc"  -size 10
    $cvNamespace  create   text         {145 95}  -text "text abcd" -size 10
}

proc chainWheel::gui::recenter_board {} {

    variable  cvObject
    
    variable  cv_scale 
    variable  drw_scale 
    
    puts "\n  -> recenter_board:   $cvObject "
    
    puts "\n\n============================="
    puts "   -> cv_scale:              $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"
    
    set cv_scale [ $cvObject center ]
    
}
proc chainWheel::gui::refit_board {} {
    
    variable  cvObject
    
    variable  cv_scale 
    variable  drw_scale 
    
    puts "\n  -> recenter_board:   $cvObject "
    
    puts "\n\n============================="
    puts "   -> cv_scale:              $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"
    
    set cv_scale [ $cvObject fit]
        
}
proc chainWheel::gui::scale_board {{value {1}}} {
    
    variable  cvNamespace
    
    variable  cv_scale 
    variable  drw_scale 
    
    puts "\n  -> scale_board:   $cvNamespace"
            
    puts "\n\n============================="
    puts "   -> cv_scale:              $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"
    
    $cvNamespace scaleToCenter $cv_scale
}


proc chainWheel::gui::clean_board {} {
    variable  cvObject
    $cvObject deleteContent
}


proc chainWheel::gui::dimensionMessage { x y id} {
    tk_messageBox -message "giveMessage: $x $y $id"
    
}        


  #
  ### -- G U I

proc chainWheel::gui::build {w} {
    
    variable teethCount
    variable cv_scale
    variable dim_type_select
    variable cvNamespace
    variable f_report
    variable w_textReport
    
    if {$w == {.} || $w == {}} {
        set rootFrame [ frame .f -bg lightblue]
        pack $rootFrame
    } else {
        set rootFrame [ frame $w.f -bg lightblue]
    }        
        # frame .f0
    set f_top       [frame $rootFrame.f_top]
    set f_result    [frame $rootFrame.f_result]
        #
    pack  $rootFrame        -expand yes -fill both
    pack  $f_top $f_result  -side top -expand yes -fill both
   
  
        #
        ### -  G U I  -  T O P  ------ 
        #
    set f_canvas    [labelframe $f_top.f_canvas   -text "View"]
    set f_control   [     frame $f_top.f_control]
        #
    pack  $f_canvas $f_control      -side left -expand yes -fill both
    pack  configure $f_control      -fill y
    
    
        #
        ### -- G U I - canvas 
    createStage    $f_canvas   700 500  -bd 2  -bg white  -relief sunken
    

        #
        ### -- G U I - control
    labelframe  $f_control.f_model          -text "Config"
    pack        $f_control.f_model          -side top  -fill x
    
    create_config_line \
                $f_control.f_model.teeth    "TeethCount:"    [namespace current]::teethCount     2  99
    pack        $f_control.f_model.teeth    -side top  -fill x  -padx 15  -pady 30       

    
    labelframe  $f_control.f_gui            -text "GUI Control"
    pack        $f_control.f_gui            -side bottom  -fill x        
    
    button      $f_control.f_gui.bt_refit   -text "refit"   -command [namespace current]::refit_board
    pack        $f_control.f_gui.bt_refit   -side top  -fill x  -padx 15  -pady 5      
    
    button      $f_control.f_gui.bt_clear   -text "clear"   -command [namespace current]::clean_board
    pack        $f_control.f_gui.bt_clear   -side top  -fill x  -padx 15  -pady 5      
    
    button      $f_control.f_gui.bt_update  -text "update"  -command [namespace current]::update_board
    pack        $f_control.f_gui.bt_update  -side top  -fill x  -padx 15  -pady 5      


        #
        ### -- S V G - export
    labelframe  $f_control.f_xprt           -text "Export"
    pack        $f_control.f_xprt           -side bottom  -fill x
    
    button      $f_control.f_xprt.bt_export -text "export SVG"   -command [namespace current]::exportSVG
    pack        $f_control.f_xprt.bt_export -side top  -fill x  -padx 15  -pady 5 
    
    
        #
        ### --- reorder
    pack configure $f_control.f_xprt        -before $f_control.f_gui
    
        #
        ### -  G U I  -  B O T T O M  ------ 
        #        
    set f_report    [labelframe $f_result.f_report  -text "SVG - Result" ]
    pack            $f_report  -side top  -expand yes  -fill x
    
    set reportText  [text       $f_report.text  -width 40  -height 20]
    scrollbar       $f_report.sby   -orient vert  -command "$f_report.text yview"
    $reportText     conf  -yscrollcommand "$f_report.sby set"
    
    grid            $f_report.text $f_report.sby -sticky news
    grid columnconfig $f_report 0 -weight 1
    
    
    #    grid $sourceTreeFrame.t $sourceTreeFrame.y  -sticky news
    #    grid $sourceTreeFrame.x                     -sticky news
    #    grid rowconfig    $sourceTreeFrame 0 -weight 1
    #    grid columnconfig $sourceTreeFrame 0 -weight 1
    
    
                
    #pack            $f_report.text  -expand yes  -fill both  -side left   
    #pack            $f_report.sby   -expand yes  -fill y     -side right   
    
    set w_textReport $reportText  
    
    
    ####+### E N D
    set teethCount 53
        # set cv_scale   0.9
        # updateValue teethCount $teethCount
    
    update

    
        # $cvNamespace reportXMLRoot
    
    wm minsize . [winfo width  .]   [winfo height  .]
    
    
    return $rootFrame
}


 