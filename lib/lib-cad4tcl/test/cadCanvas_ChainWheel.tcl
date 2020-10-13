 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2010/02/06
 #
 #
 


set WINDOW_Title      "cad4tcl, an extension for canvas"


set BASE_Dir  [file normalize [file dirname [file normalize $::argv0]]]

set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]
puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
 
lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path "$APPL_Package_Dir/__ext_Libraries"

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
    
            
    proc createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
        variable cvObject
        variable cv_scale
        set cvObject    [cad4tcl::new  $cv_path  $cv_width  $cv_height  A3  0.5  40]
        set cv_scale    [$cvObject configure Canvas Scale]
        return $cvObject
    }
    
    proc update_board {{value {0}} args} {
        
            variable  cvObject
            
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
            
            #set value $teethCount
            puts "   -> $value "
            if {$value == {update}} {
                # --- values on bind are: sketchboard::teethCount {} write 
                set value $teethCount
                puts "   --> $value "
            }

            
            $cvObject deleteContent
                # set board [$cvObject getCanvas]
        
            if {$font_colour == {default}} { set font_colour [ $cvObject getNodeAttr Style  fontcolour ]}
            
            puts "\n\n============================="
            puts "   -> drw_scale:          $drw_scale"
            puts "   -> font_colour:        $font_colour"
            puts "   -> dim_size:           $dim_size"
            puts "   -> dim_font_select:    $dim_font_select"
            puts "\n============================="
                # puts "   -> Drawing:            [[$cvObject configure Stage] asXML]"
                # puts "   -> Drawing:            [[$cvObject getNode Stage] asXML]"
            #puts "\n============================="
            #puts "   -> Style:              [[$cvObject getNode Style] asXML]"
            #puts "\n============================="
            #$cvObject reportMyDictionary
            puts "\n============================="
            puts "\n\n"

            $cvObject configure Stage Scale       $drw_scale
            $cvObject configure Style Fontstyle   $dim_font_select
            $cvObject configure Style Fontsize    $dim_size
                # $cvObject setNodeAttr Stage scale       $drw_scale
                # $cvObject setNodeAttr Style fontstyle   $dim_font_select
                # $cvObject setNodeAttr Style fontsize    $dim_size
            
            
            if {$demo_type != {dimension} } {
                sketchboard::demo_cad4tcl 
                return
            }
            
            # ------------------------------------
                    # update $cvObject ->
            
            set p_end   [vectormath::rotateLine  {0 0}  $end_length    $teethCount]
         
            $cvObject addtag {__ChainWheel__} withtag  [$cvObject  create   circle {0 0}    -radius 2  -outline red     -fill white]

            $cvObject addtag {__ChainWheel__} withtag  [$cvObject  create   line [list  0 0  [lindex $p_end 0]  [lindex $p_end 1] ] -tags dimension  -fill blue ]
            
            # ------ create circle as chain-representation
            set toothWith           12.7
            set toothWithAngle      [expr 2*$vectormath::CONST_PI/$teethCount]
            set chainWheelRadius    [expr 0.5*$toothWith/sin([expr 0.5*$toothWithAngle])]
                    # =0,5*H6/SIN(D13)
            set index 0
            set toothProfileList {}
            while { $index < $teethCount } {
                set currentAngle [expr $index * [vectormath::grad $toothWithAngle]]
                set pos [vectormath::rotateLine {0 0} $chainWheelRadius $currentAngle ]
                $cvObject addtag {__ChainWheel__} withtag  [$cvObject  create   circle  $pos -radius 3.8]  
                
                set pt_00 {2 5}                                 ; foreach {x0 y0} $pt_00 break
                set pt_01 [vectormath::rotateLine {0 0} 3.8 100]    ; foreach {x1 y1} $pt_01 break
                set pt_02 [vectormath::rotateLine {0 0} 3.8 125]    ; foreach {x2 y2} $pt_02 break
                set pt_03 [vectormath::rotateLine {0 0} 3.8 150]    ; foreach {x3 y3} $pt_03 break
                set pt_04 [vectormath::rotateLine {0 0} 3.8 170]    ; foreach {x4 y4} $pt_04 break
                set tmpList_00 [list $x0 -$y0    $x1 -$y1    $x2 -$y2    $x3 -$y3    $x4 -$y4    $x4 $y4    $x3 $y3    $x2 $y2    $x1 $y1    $x0 $y0]
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
            set toothProfileList [cad4tcl::_flattenNestedList $toothProfileList]
            set chainWheelProfile [$cvObject  create polygon $toothProfileList -fill white -outline black]
            $cvObject addtag {__ChainWheel__} withtag  $chainWheelProfile           
                
            $::f_report.text delete 1.0  end 
            $::f_report.text insert end "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
            
            $::f_report.text insert end "<svg xmlns=\"http://www.w3.org/2000/svg\"\n"
            $::f_report.text insert end "width=\"500mm\" height=\"500mm\"\n" 
            $::f_report.text insert end "viewBox=\"-250 -250 500 500\"\n"
            $::f_report.text insert end "version=\"1.1\">\n"
            
            $::f_report.text insert end "<g>\n"
            $::f_report.text insert end "   <polygon points=\""
            foreach {x y} $toothProfileList {
                $::f_report.text insert end "$x,$y  "
            }
            $::f_report.text insert end "\"  />"
            $::f_report.text insert end "\n"
            $::f_report.text insert end "   <circle  cx=\"00\" cy=\"00\" r=\"4.5\" id=\"center_00\"/>\n"
            $::f_report.text insert end "</g>\n"
            $::f_report.text insert end "</svg>\n"
            
            sketchboard::moveto_StageCenter {__ChainWheel__}

    }
    


    proc moveto_StageCenter {item} {
        variable cvObject
        set stage 		[$cvObject getCanvas]
        set stageCenter [$cvObject getCenter]
            # set stageCenter [ cad4tcl::get_StageCenter $stage ]
        set bottomLeft  [$cvObject getBottomLeft]
            # set bottomLeft  [ cad4tcl::_getBottomLeft  $stage ]
        foreach {cx cy} $stageCenter break
        foreach {lx ly} $bottomLeft  break
        $stage move $item [expr $cx - $lx] [expr $cy -$ly]
    }
    
    proc demo_cad4tcl {} {
                    
            variable  cvObject
            
            $cvObject  create   line  		{0 0 20 0 20 20 0 20 0 0} 		-tags {Line_01}  -fill blue   -width 2 
            $cvObject  create   line  		{30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
            $cvObject  create   line  		{0 0 30 30 } 		-tags {Line_01}  -fill blue   -width 2 
            
            $cvObject  create   rectangle  	{180 120 280 180 } 	-tags {Line_01}  -fill violet   -width 2 
            $cvObject  create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

            $cvObject  create   oval  		{30 160 155 230 } 	-tags {Line_01}  -fill red   -width 2 		
            $cvObject  create   circle  	{160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
            $cvObject  create   arc  		{270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
            
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
            
            set cv_scale [ $cvObject repositionToCanvasCenter ]
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
            
            # set cv_scale [ $cvObject refitToCanvas ]
            set cv_scale [ $cvObject refitStage]
    }
    proc scale_board {{value {1}}} {
        
            variable  cvObject
            
            variable  cv_scale 
            variable  drw_scale 
            
            puts "\n  -> scale_board:   $cvObject"
            
            #$cvObject clean_StageContent
            #set board [ $cvObject dict_getValue Canvas  path]
        
            
            puts "\n\n============================="
            puts "   -> cv_scale:          	$cv_scale"
            puts "   -> drw_scale:          $drw_scale"
            puts "\n============================="
            puts "\n\n"
            
            $cvObject scaleToCenter $cv_scale
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
sketchboard::createStage    $f_canvas   1000 810  250 250 m  0.5 -bd 2  -bg white  -relief sunken
    

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

create_config_line $f_settings.settings.teeth     "teeth (count):"	sketchboard::teethCount     2  99

radiobutton $f_settings.length.aligned \
            -text      "aligned   " \
            -variable  "sketchboard::dim_type_select" \
            -value     "aligned" \
            -command   "sketchboard::update_board"
                                                                        

create_config_line $f_settings.scale.cv_scale	        " Canvas scale  "   sketchboard::cv_scale	 0.2  5.0  
                   $f_settings.scale.cv_scale.scl      	configure   -resolution 0.1  -command "sketchboard::scale_board"
button  		   $f_settings.scale.recenter   -text   "recenter"  -command {sketchboard::recenter_board}
button  		   $f_settings.scale.refit		-text   "refit"     -command {sketchboard::refit_board}

pack  	    $f_settings.settings.teeth \
            $f_settings.length.aligned \
            $f_settings.scale.cv_scale \
            $f_settings.scale.recenter \
            $f_settings.scale.refit \
            -side top  -fill x		
					 
pack  $f_settings  -side top -expand yes -fill both
	 
	#
	### -- G U I - canvas print
			
	#
	### -- G U I - canvas demo
		
set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
button  $f_demo.bt_clear   -text "clear"  -command {$sketchboard::cvObject clean_StageContent} 
button  $f_demo.bt_update  -text "update"   -command {sketchboard::update_board}

pack  $f_demo  -side top 	-expand yes -fill x
pack $f_demo.bt_clear 	-expand yes -fill x
pack $f_demo.bt_update 	-expand yes -fill x
	
	
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
  
  
   
 
 

 