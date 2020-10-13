 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2017/11/26
 #
 #


set WINDOW_Title      "cad4tcl, an extension for canvas"


set BASE_Dir  [file normalize [file dirname [file normalize $::argv0]]]

set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
 
lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir/vectormath"
lappend auto_path "$APPL_Package_Dir/tkpath0.3.3"
lappend auto_path "$APPL_Package_Dir/__ext_Libraries"

lappend auto_path "$APPL_Package_Dir/lib-vectormath"
lappend auto_path "$APPL_Package_Dir/lib-pdf4tcl"
lappend auto_path "$APPL_Package_Dir/tkpath0.3.3"

package require   cad4tcl

set cad4tcl::canvasType  10

set w_textReport            {}


	
    ##+######################
 
proc create_config_line {w lb_text entry_var start end  } {		
        frame   $w
        pack    $w
        global $entry_var
        label   $w.lb	-text $lb_text            -width 20  -bd 1  -anchor w 
        entry   $w.cfg	-textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
        scale   $w.scl	-width        12 \
                        -length       120 \
                        -bd           1  \
                        -sliderlength 15 \
                        -showvalue    0  \
                        -orient       horizontal \
                        -command      "::updateValue $entry_var" \
                        -variable     $entry_var \
                        -from         $start \
                        -to           $end                            
        pack      $w.lb  $w.cfg $w.scl    -side left  -fill x
        bind      $w.cfg <Leave>  "::updateValue $entry_var"
        bind      $w.cfg <Return> "::updateValue $entry_var"
}
proc create_status_line {w lb_text entry_var} {	     
    frame   $w
    pack    $w
    global $entry_var
    label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
    entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
    pack      $w.lb  $w.cfg    -side left  -fill x		    
}
proc updateValue {varName args} {
    puts "   ... updateValue:  $varName $args"
    switch -exact $varName {
        sketchboard::teethCount {
                update 
                # puts "   -> $varName $value"
                set value $sketchboard::teethCount
                set $varName $value
                return
            }
        default {
            # puts "   default -> $varName $value"
        }
    }
}
proc exportSVG {} {
    variable w_textReport
    set xmlContent [$w_textReport get 1.0  end]
    puts "$xmlContent"
    
    set types {
            {{SVG}       {.svg}  }
        }
    set initialFile "ChainWheel_Profile_$sketchboard::teethCount"
    set initialDir  $::env(USERPROFILE)  
    
    set fileName    [tk_getSaveFile -initialdir $initialDir -initialfile $initialFile -filetypes $types]  
    if {$fileName == {}} return
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

namespace eval sketchboard {
    
    variable cvObject
    
        # defaults
    variable start_angle        20
    variable start_length       80
    variable teethCount         53
    variable end_length         65
    variable dim_size            5
    variable dim_dist           30
    variable dim_offset          0
    variable dim_type_select    aligned
    variable dim_font_select    vector
    variable std_fnt_scl         1
    variable font_colour		black
    variable demo_type			dimension
    variable drw_scale		     0.8
    variable cv_scale		     1
    variable view_scale		     1
    
    variable projectType        1
            
    proc createStage {cv_path cv_width cv_height dinFormat scale args} {
        variable cvObject
        variable cv_scale
        set cvObject    [cad4tcl::new  $cv_path  $cv_width  $cv_height  $dinFormat  $scale  20]
            #
        set cv_scale    [$cvObject configure Canvas Scale]
        set view_scale  [$cvObject configure Stage Scale]
            #
        return $cvObject
    }
    proc update_board {{value {0}} args} {
        variable  cvObject
        $cvObject deleteContent
        createDraftingFrame
        set myConfigContainer   [$cvObject createConfigCorner [list $cvObject createConfigContainer {myCorner}]]
        set myDragObject        [$cvObject create rectangle { 50 60 90 90} -fill red]
        $cvObject registerDragObject $myDragObject [list [namespace current]::reportDragObject]
        set myPosCircle         [createPositionCircle]
    }
    proc reportDragObject {args} {
        puts "    -> reportDragObject: $args"
        set w $::w_textReport
        $w delete 1.0  end 
        $w insert end "-> reportDragObject:\n      $args\n"
    }
    proc createDraftingFrame {{value {0}} args} {
            #
        variable  cvObject
        variable  projectType 
            #
        puts "  $::APPL_Package_Dir"
        puts "  $::APPL_ROOT_Dir"            
            #
            #
        set labelFile   [file join $::APPL_ROOT_Dir etc rattleCAD.svg]
            #
        set project     "Drafting Frame"
            #
        set systemTime  [clock seconds]
        set timeString  [clock format $systemTime -format {%Y.%d.%m %H:%M:%S}]
            #
        set description [package versions cad4tcl]    
            #
        puts "\n"
        puts " company:     $labelFile"
        puts " project:     $project"
        puts " time:        $timeString"
        puts " description: $description"
        puts "\n"
            #
        if $projectType {
            $cvObject create draftFrame {} [list \
                                                -label $labelFile \
                                                -title "Drafting Frame" \
                                                -date  $timeString \
                                                -descr $description ]
        } else {
            $cvObject create draftFrame {} [list \
                                                -label "cad4tcl" \
                                                -title "Drafting Frame" \
                                                -date  $timeString \
                                                -descr $description ]
        }
            #
    }
    proc createPositionCircle {{x 140} {y 90} {r 5}} {
        variable cvObject
            #
        puts "    -> create_Position   -> $x $y"
            #
        $cvObject  create   circle  [list $x $y]  -radius $r  -tags {__Pos__}  -fill lightblue  -outline blue  -width 0.25
            #
        set cv      [$cvObject getCanvas]
            #
        set cvXY    [$cvObject getPositionCanvas $x $y]
            #
        foreach {cv_x cv_y} $cvXY break
            #
        set cv_r    [expr  0.5 * [$cvObject getLengthCanvas $r]]
        set ovalBox [list [expr $cv_x - $cv_r] [expr $cv_y + $cv_r] [expr $cv_x + $cv_r] [expr $cv_y - $cv_r]]
            #
        $cv create oval $ovalBox  -fill yellow  -outline green  -width 0.25  -tags __Content__
            #
    }
    proc create_divObject {} {
        variable cvObject
            #
        set x 40
        set y 90
        set title "my DivObject"
        set frameContent [$cvObject createDivContainer $title $x $y]
            #
        puts "    -> \$frameContent $frameContent"
            #
        set button_1 [button $frameContent.bt_1 -text "  ---- first Button ---- "]
        set button_2 [button $frameContent.bt_2 -text "  ---- second Button ---- "]
        pack $button_1 -fill x
        pack $button_2 -fill x
    }
    proc moveto_StageCenter {item} {
        variable cvObject
        set stage 		[$cvObject getCanvas]
        set stageCenter [$cvObject getCenter]
        set bottomLeft  [$cvObject getBottomLeft]
        foreach {cx cy} $stageCenter break
        foreach {lx ly} $bottomLeft  break
        $stage move $item [expr $cx - $lx] [expr $cy -$ly]
    }
    proc demo_cad4tcl {} {
        variable  cvObject
            #
        $cvObject  create   line  		{0 0 20 0 20 20 0 20 0 0} 		-tags {Line_01}  -fill blue   -width 2 
        $cvObject  create   line  		{30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
        $cvObject  create   line  		{0 0 30 30 } 		-tags {Line_01}  -fill blue   -width 2 
            #
        $cvObject  create   rectangle  	{180 120 280 180 } 	-tags {Line_01}  -fill violet   -width 2 
        $cvObject  create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 
            #
        $cvObject  create   oval  		{30 160 155 230 } 	-tags {Line_01}  -fill red   -width 2 		
        $cvObject  create   circle  	{160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
        $cvObject  create   arc  		{270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
            #
        $cvObject  create   text		{140 90}  -text "text a"
        $cvObject  create   vectortext	{120 70}  -text "vectorText ab"
        $cvObject  create   vectortext	{100 50}  -text "vectorText abc"  -size 10
        $cvObject  create   text		{145 95}  -text "text abcd" -size 10
    }
    
    proc recenter_board {} {
        variable  cvObject
        variable  cv_scale 
        variable  drw_scale 
        puts "\n  -> recenter_board:   $cvObject "
        puts "\n\n============================="
        puts "   -> cv_scale:          	$cv_scale"
        puts "   -> drw_scale:          $drw_scale"
        puts "\n============================="
        puts "\n\n"
        set cv_scale [$cvObject center $cv_scale]
    }
    proc refit_board {} {
        variable  cvObject
        variable  cv_scale 
        variable  drw_scale 
        puts "\n  -> recenter_board:   $cvObject "
        puts "\n\n============================="
        puts "   -> cv_scale:          	$cv_scale"
        puts "   -> drw_scale:          $drw_scale"
        puts "\n============================="
        puts "\n\n"
        set cv_scale [$cvObject fit]
    }
    proc scale {{value {1}}} {
        variable  cvObject
        variable  cv_scale 
        variable  drw_scale 
        puts "\n  -> scale_board:   $cvObject"
        puts "\n\n============================="
        puts "   -> cv_scale:          	$cv_scale"
        puts "   -> drw_scale:          $drw_scale"
        puts "\n============================="
        set cv_scale [expr $cv_scale * $value]
        puts "\n\n============================="
        puts "   -> cv_scale:          	$cv_scale"
        puts "   -> drw_scale:          $drw_scale"
        puts "\n============================="
        puts "\n\n"
        $cvObject center $cv_scale
    }
    proc scale_board {{value {1}}} {
        variable  cvObject
        variable  cv_scale 
        variable  drw_scale 
        puts "\n  -> scale_board:   $cvObject"
        puts "\n\n============================="
        puts "   -> cv_scale:          	$cv_scale"
        puts "   -> drw_scale:          $drw_scale"
        puts "\n============================="
        puts "\n\n"
        $cvObject center $cv_scale
    }
    proc scale_view {{value {1}}} {
        variable  cvObject
        variable  view_scale 
        variable  cv_scale 
        puts "\n  -> scale_view:   $cvObject"
        puts "\n\n============================="
        puts "   -> cv_scale:          	$cv_scale"
        puts "   -> view_scale:         $view_scale"
        puts "\n============================="
        puts "\n\n"
        $cvObject configure Stage Scale $view_scale
        update_board
    }
    proc switch_projectType {} {
        variable projectType
        if $projectType {
            set projectType 0
        } else {
            set projectType 1
        }
        update_board
    }
    
    
    proc dimensionMessage { x y id} {
        tk_messageBox -message "giveMessage: $x $y $id"
    }		
}

	
	
    #
    ### -- G U I

  
frame .f0 
set f_canvas  [labelframe .f0.f_canvas   -text "board"  ]
set f_config  [frame      .f0.f_config   ]

pack  .f0      -expand yes -fill both
pack  $f_canvas  $f_config    -side left -expand yes -fill both
pack  configure  $f_config    -fill y


	#
	### -- G U I - canvas 
    # cv_path cv_width cv_height dinFormat
sketchboard::createStage    $f_canvas   1000 810  A4  1.0 -bd 2  -bg white  -relief sunken
    

	#
	### -- G U I - canvas demo
		
set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]

labelframe  $f_settings.settings  	-text settings
labelframe  $f_settings.angle   	-text angle
labelframe  $f_settings.radius  	-text radius
labelframe  $f_settings.length  	-text length
labelframe  $f_settings.font    	-text font
labelframe  $f_settings.demo    	-text demo
labelframe  $f_settings.scale   	-text scale

pack        $f_settings.settings	\
            $f_settings.angle		\
            $f_settings.radius		\
            $f_settings.length		\
            $f_settings.font		\
            $f_settings.demo		\
            $f_settings.scale   -fill x -side top 

create_config_line $f_settings.settings.teeth     "any variable:"	sketchboard::teethCount     2  99

radiobutton $f_settings.length.aligned \
            -text      "aligned   " \
            -variable  "sketchboard::dim_type_select" \
            -value     "aligned" \
            -command   "sketchboard::update_board"
                                                                        

create_config_line $f_settings.scale.cv_scale	" Canvas scale  "  sketchboard::cv_scale	 0.2  5.0  
                   $f_settings.scale.cv_scale.scl   configure      -resolution 0.1  -command "sketchboard::scale_board"
create_config_line $f_settings.scale.view_scale " View scale  "    sketchboard::view_scale	 0.2  5.0  
                   $f_settings.scale.view_scale.scl configure      -resolution 0.1  -command "sketchboard::scale_view"
button  		   $f_settings.scale.scaleplus  -text "scale +"    -command {sketchboard::scale 2.0}
button  		   $f_settings.scale.scaleminus -text "scale -"    -command {sketchboard::scale 0.5}
button  		   $f_settings.scale.refit		-text "refit"      -command {sketchboard::refit_board}
button  		   $f_settings.scale.recenter   -text "recenter"   -command {sketchboard::recenter_board}

pack  	    $f_settings.settings.teeth \
            $f_settings.length.aligned \
            $f_settings.scale.cv_scale \
            $f_settings.scale.view_scale \
            $f_settings.scale.scaleplus \
            $f_settings.scale.scaleminus \
            $f_settings.scale.refit \
            $f_settings.scale.recenter \
            -side top  -fill x		
					 
pack  $f_settings  -side top -expand yes -fill both
	 
	#
	### -- G U I - canvas print
			
	#
	### -- G U I - canvas demo
		
set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
button  $f_demo.bt_clear    -text "clear"       -command {$sketchboard::cvObject deleteContent} 
button  $f_demo.bt_drafting -text "frame"       -command {sketchboard::createDraftingFrame}
button  $f_demo.bt_project  -text "project"     -command {sketchboard::switch_projectType}
button  $f_demo.bt_update   -text "update"      -command {sketchboard::update_board}
button  $f_demo.bt_div      -text "divObject"   -command {sketchboard::create_divObject}

pack  $f_demo  -side top 	-expand yes -fill x
pack $f_demo.bt_clear 	    -expand yes -fill x
pack $f_demo.bt_drafting    -expand yes -fill x
pack $f_demo.bt_project  	-expand yes -fill x
pack $f_demo.bt_update  	-expand yes -fill x
pack $f_demo.bt_div      	-expand yes -fill x
	
	
	#
	### -- G U I - canvas status
		
	#
	### -- G U I - canvas report
		
set f_report  [labelframe .f0.f_config.f_report  -text "report" ]

text        $f_report.text -width 50
scrollbar   $f_report.sby -orient vert -command "$f_report.text yview"
            $f_report.text conf -yscrollcommand "$f_report.sby set"
            
pack $f_report  -side top 	-expand yes -fill both
pack $f_report.sby $f_report.text -expand yes -fill both -side right   

set w_textReport $f_report.text  

set f_export  [labelframe .f0.f_config.f_export  -text "export" ]
button             $f_export.bt_export  -text "export SVG"   -command {exportSVG}
pack $f_export  -side top   -expand yes -fill both
pack $f_export.bt_export -expand yes -fill both -side bottom        
    
	
	
	####+### E N D
trace add variable    ::sketchboard::teethCount   write "sketchboard::update_board update"
set sketchboard::teethCount 53

update

 
    # $sketchboard::cvObject reportXMLRoot
  
wm minsize . [winfo width  .]   [winfo height  .]
  
  
   
 
 

 