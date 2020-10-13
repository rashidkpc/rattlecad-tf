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

lappend auto_path "$APPL_Package_Dir/lib-vectormath"

package require 	Tk
package require   vectormath
package require   cad4tcl

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
                            # -command      "sketchboard::update_board"
                            # -resolution   $resolution
                            
        pack      $w.lb  $w.cfg $w.scl    -side left  -fill x
        #bind      $w.cfg <Leave>  "sketchboard::update_board {*}$entry_var"
        #bind      $w.cfg <Return> "sketchboard::update_board {*}$entry_var"
        bind      $w.cfg <Leave>  "::updateValue $entry_var"
        bind      $w.cfg <Return> "::updateValue $entry_var"
        # trace add variable    $entry_var   write [list puts ""  -> update"]
                
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
}
    ##+######################

namespace eval sketchboard {
        #
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
        #
    proc createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
        variable cvObject
        variable cv_scale
        set cvObject    [cad4tcl::new  $cv_path  $cv_width  $cv_height  A3  0.5  40]
        set w           [$cvObject getCanvas]    
        set cv_scale    [$cvObject configure Canvas Scale]
        update_board
        return $cvObject
    }
    proc reportDragObject {args} {
        puts "-> reportDragObject:\n      $args"
        set w $::w_textReport
        $w delete 1.0  end 
        $w insert end "-> reportDragObject:\n      $args\n"
    }
    proc update_board {{value {0}} args} {
        variable  cvObject
        $cvObject deleteContent
        set dragObj_1   [$cvObject create   circle  	{160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2]
        $cvObject registerDragObject $dragObj_1 [list [namespace current]::reportDragObject]
    }
    proc demo_cad4tcl {} {
        variable  cvObject
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
    
    
    
    
    
    proc dragMessage { x y id} {
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
sketchboard::createStage    $f_canvas   1000 810  250 250 m  0.5 -bd 2  -bg white  -relief sunken

    #
    ### -- G U I - canvas demo
set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
    
            labelframe  $f_settings.settings  -text settings
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

            create_config_line $f_settings.settings.teeth     "teeth (count):"	sketchboard::teethCount     2  99
            
            radiobutton        $f_settings.length.aligned \
                                        -text      "aligned   " \
                                        -variable  "sketchboard::dim_type_select" \
                                        -value     "aligned" \
                                        -command   "sketchboard::update_board"
                                                                                    
            
            create_config_line $f_settings.scale.cv_scale	" Canvas scale  "  sketchboard::cv_scale	 0.2  5.0  
                               $f_settings.scale.cv_scale.scl   configure       -resolution 0.1  -command "sketchboard::scale_board"
            button  		   $f_settings.scale.recenter   -text "recenter"    -command {sketchboard::recenter_board}
            button  		   $f_settings.scale.refit		-text "refit"       -command {sketchboard::refit_board}
            
            pack  	$f_settings.settings.teeth \
                    $f_settings.length.aligned \
                    $f_settings.scale.cv_scale \
                    $f_settings.scale.recenter \
                    $f_settings.scale.refit \
                 -side top  -fill x		
                 
pack  $f_settings  -side top -expand yes -fill both
    #
    ### -- G U I - canvas demo
set f_demo  [labelframe .f0.f_config.f_demo     -text "Demo" ]
    button  $f_demo.bt_clear   -text "clear"    -command {$sketchboard::cvObject deleteContent} 
    button  $f_demo.bt_update  -text "update"   -command {sketchboard::update_board}
pack  $f_demo  -side top 	-expand yes -fill x
    pack $f_demo.bt_clear 	-expand yes -fill x
    pack $f_demo.bt_update 	-expand yes -fill x
    
    #
    ### -- G U I - canvas status

    #
    ### -- G U I - canvas report
set f_report  [labelframe .f0.f_config.f_report  -text "report" ]

            text  		   	   $f_report.text -width 50
            scrollbar 		   $f_report.sby -orient vert -command "$f_report.text yview"
                               $f_report.text conf -yscrollcommand "$f_report.sby set"
            
pack $f_report  -side top 	-expand yes -fill both
pack $f_report.sby $f_report.text -expand yes -fill both -side right   

set w_textReport $f_report.text  

set f_export  [labelframe .f0.f_config.f_export  -text "export" ]
pack $f_export  -side top   -expand yes -fill both    

    ####+### E N D
set sketchboard::teethCount 53
trace add variable    ::sketchboard::teethCount   write "sketchboard::update_board update"
    #
update
    #
wm minsize . [winfo width  .]   [winfo height  .]






