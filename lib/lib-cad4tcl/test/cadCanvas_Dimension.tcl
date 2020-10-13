 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2010/02/06
 #
 #

set WINDOW_Title      "cad4tcl, an extension for canvas"


set BASE_Dir            [file normalize [file dirname [file normalize $::argv0]]] 

set TEST_ROOT_Dir       [file normalize [file dirname [lindex $argv0]]]
set TEST_Library_Dir    [file dirname [file dirname $TEST_ROOT_Dir]]
set TEST_Sample_Dir     [file join $TEST_ROOT_Dir _sample]
set TEST_Export_Dir     [file join $TEST_ROOT_Dir _export]
    #
puts "   \$TEST_ROOT_Dir ... $TEST_ROOT_Dir"
puts "    -> \$TEST_Library_Dir ... $TEST_Library_Dir"
puts "    -> \$TEST_Sample_Dir .... $TEST_Sample_Dir"
puts "    -> \$TEST_Export_Dir .... $TEST_Export_Dir"
    #
    #
foreach dir $tcl_library {
    puts "   -> tcl_library $dir"
}
    #
set tcl_pkgPath $TEST_Library_Dir
foreach dir $tcl_pkgPath {
    puts "   -> tcl_pkgPath $dir"
}

lappend auto_path [file dirname $TEST_ROOT_Dir]
lappend auto_path "$TEST_Library_Dir/__ext_Libraries"
lappend auto_path "$TEST_Library_Dir"

package require cad4tcl   0.01
package require appUtil     

set cad4tcl::canvasType  1

set cvFactory       [cad4tcl::CanvasFactory new]

proc scaleContent {cvObject scale} {
        #
    set curScale    [$cvObject configure Canvas Scale]
    set newScale    [format "%.4f" [ expr $scale * $curScale * 1.0 ] ]
    $cvObject scaleCenter $newScale
        #
}
 	
  
proc exportSVG {cvObject} {
    variable TEST_Export_Dir
    set exportFile [file join $TEST_Export_Dir _test_dimension_a.svg]
    $cvObject export SVG $exportFile
}     
  
  
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
                    -command      "sketchboard::update_board" \
                    -variable     $entry_var \
                    -from         $start \
                    -to           $end 
                        # -resolution   $resolution

    pack      $w.lb  $w.cfg $w.scl    -side left  -fill x		    
}
proc create_status_line {w lb_text entry_var} {
    frame   $w
    pack    $w

    global $entry_var

    label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
    entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
    pack      $w.lb  $w.cfg    -side left  -fill x		    
}

  
##+######################

namespace eval sketchboard {
    
    variable cvObject
    
        # defaults
    variable start_angle        20
    variable start_length       80
    variable end_angle         130
    variable end_length         65
    variable dim_size            5
    variable dim_dist           30
    variable dim_offset          0
    variable dim_type_select    horizontal
    variable dim_font_select    vector
    variable dim_sensitive      1
    variable std_fnt_scl        1
    variable font_colour		black
    variable demo_type			dimension
    variable drwScale		    1.0
    variable cvScale            1
    variable precision          1
    
    variable stateRaster      0
                                    
    proc createStage {cv_path cv_width cv_height st_scale} {
        variable cvObject
        variable drwScale
        variable cvScale
        set cvObject    [cad4tcl::new  $cv_path 	$cv_width $cv_height 	A4 $st_scale 40]
        set cvScale     [$cvObject configure Canvas Scale 1.0]
        set drwScale    [$cvObject configure Stage  Scale]
        return $cvObject
    }
    
    
    proc moveto_StageCenter {item} {
        variable cvObject
        set stage       [$cvObject getCanvas]
        set stageCenter [$cvObject getCenter]
        set bottomLeft  [$cvObject getBottomLeft]
        foreach {cx cy} $stageCenter break
        foreach {lx ly} $bottomLeft  break
        $stage move $item [expr $cx - $lx] [expr $cy -$ly]
    }
    
    proc demo_cad4tcl {} {
                    
        variable  cvObject
        
        $cvObject  create   line        {0 0 20 0 20 20 0 20 0 0}       [list  -tags {Line_01}  -fill blue  -width 2]
        $cvObject  create   line        {30 30 90 30 90 90 30 90 30 30} [list  -tags {Line_01}  -fill blue  -width 2]
        $cvObject  create   line        {0 0 30 30 }                    [list  -tags {Line_01}  -fill blue  -width 2]
        
        $cvObject  create   rectangle   {180 120 280 180 }  [list  -tags {Line_01}  -fill violet  -width 2]
        $cvObject  create   polygon     {40 60  80 50  120 90  180 130  90 150  50 90 35 95}  [list  -tags {Line_01}  -outline red  -fill yellow  -width 2]
        
        $cvObject  create   oval        {30 160 155 230 }   [list  -tags {Line_01}  -fill red  -width 2 ]
        $cvObject  create   circle      {160 60}            [list  -radius 50  -tags {Line_01}  -fill blue  -width 2 ]
        $cvObject  create   arc         {270 160}           [list  -radius 50  -start 30  -extent 170  -tags {Line_01}  -outline gray  -width 2  -style arc]
        
        $cvObject  create   text        {140 90}            [list  -text "text a"]
        $cvObject  create   vectorText  {120 70}            [list  -text "vectorText ab"]
        $cvObject  create   vectorText  {100 50}            [list  -text "vectorText abc"  -size 10]
        $cvObject  create   text        {145 95}            [list  -text "text abcd"  -size 10]
        
    }
    
    proc recenter_board {} {
        
        variable  cvObject
        
        variable  cvScale 
        variable  drwScale 
        
        puts "\n  -> recenter_board:   $cvObject "
        
        puts "\n============================="
        puts "   -> cvScale:            $cvScale"
        puts "   -> drwScale:           $drwScale"
        puts "============================="
        puts "\n"
        
        $cvObject center
        
        set cvScale    [$cvObject configure Canvas Scale]
        
    }

    proc refit_board {} {
        
        variable  cvObject
        
        variable  cvScale 
        variable  drwScale 
        
        puts "\n  -> recenter_board:   $cvObject "
        
        puts "\n============================="
        puts "   -> cvScale:          	$cvScale"
        puts "   -> drwScale:           $drwScale"
        puts "============================="
        puts "\n"
        
        $cvObject fit
        
        set cvScale [$cvObject configure Canvas Scale]
            
    }

    proc switchRaster {} {
            #
        variable stateRaster
            #
        if $stateRaster {
            set stateRaster 0
        } else {
            set stateRaster 1
        }
            #
        refit_board
            #
        update_board
            #
    }
    
    proc scaleBoard {scale} {
            #
        variable cvObject
        variable cvScale
        # set curScale    [$cvObject configure Canvas Scale]
        # set cvScale     [format "%.4f" [ expr $scale * $curScale * 1.0 ] ]
        set cvScale     [$cvObject center [format "%.4f" $scale]]
            #
        update_board
            #
    }    
    
    
    proc setPrecision {{precValue {1}}} {
            #
        variable  cvObject
        variable  precision 
            #
        puts "\n  -> setPrecision:   $cvObject"
            #
        puts "\n============================="
        puts "   -> precision:           $precValue"
        puts "============================="
        puts "\n"
            #
        set precValue [$cvObject configure Style Precision $precValue ]
        puts "   -> precision:           $precValue"
            #
        set sketchboard::precision $precValue
            #
        update_board
            #
    }
    
    proc update_board {{value {0}}} {
            #
        variable  cvObject
        
        variable  stateRaster
        
        variable  start_angle 
        variable  start_length
        variable  end_angle
        variable  end_length
        variable  dim_size
        variable  dim_dist
        variable  dim_offset
        variable  dim_sensitive
        variable  dim_font_select
        variable  dim_type_select
        variable  std_fnt_scl
        variable  font_colour
        variable  demo_type
        
        variable  cvScale 
        variable  drwScale 
        
        puts "\n  -> update_board:   $cvObject"
        
        $cvObject deleteContent

        #set cvScale     [$cvObject center [format "%.4f" 1.0]]
        #set drwScale    1
        
        if $stateRaster {
            $cvObject create draftRaster {} {}
        }
        
        if {$font_colour == {default}} { 
            set font_colour [$cvObject configure Style Fontcolour]
        }
        
        puts "\n============================="
        puts "   -> drwScale:          $drwScale"
        puts "   -> font_colour:        $font_colour"
        puts "   -> dim_size:           $dim_size"
        puts "   -> dim_sensitive:      $dim_sensitive"
        puts "   -> dim_font_select:    $dim_font_select"
        puts "============================="
        # puts "   -> Drawing:            [[$cvObject getDomNode] asXML]"
        # puts "\n============================="
        # puts "   -> Style:              [[$cvObject getDomNode] asXML]"
        # puts "\n============================="
        puts "\n"
            #
            # set cvScale     [$cvObject configure Canvas Scale    $cvScale]
        set drwScale    [$cvObject configure Stage Scale     $drwScale]
            #
        $cvObject configure Style Fontstyle $dim_font_select
        $cvObject configure Style Fontsize  $dim_size
        
        
        if {$demo_type != {dimension} } {
            # sketchboard::demo_cad4tcl 
            # return
        }
        
        # ------------------------------------
                # update $cvObject ->
        
        set p_start [vectormath::rotateLine  {0 0}  $start_length  $start_angle]
        set p_end   [vectormath::rotateLine  {0 0}  $end_length    $end_angle]
     
        $cvObject addtag {__testDimension__} withtag  [$cvObject  create   circle   {0 0}                                                   [list -radius 2  -outline red    	-fill white  -width 0.5]]
        $cvObject addtag {__testDimension__} withtag  [$cvObject  create   circle   {0 0}                                                   [list -radius 1  -outline blue  	-fill white  -width 0.5]]

        $cvObject addtag {__testDimension__} withtag  [$cvObject  create   line     [list  0 0  [lindex $p_start 0]  [lindex $p_start 1]]   [list -tags dimension  -fill red   -width 0.5]]
        $cvObject addtag {__testDimension__} withtag  [$cvObject  create   line     [list  0 0  [lindex $p_end   0]  [lindex $p_end   1]]   [list -tags dimension  -fill blue  -width 0.5]]
        
        switch $dim_type_select {
            angle { 	
                foreach {sx sy} $p_start break
                foreach {ex ey} $p_end   break
                set dimObject [ $cvObject create dimensionAngle \
                                        [list {0 0} $p_start $p_end] \
                                        [list \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
            radius { 	
                foreach {sx sy} $p_start break
                foreach {ex ey} $p_end   break
                set dimObject [ $cvObject create dimensionRadius \
                                        [list $p_start $p_end] \
                                        [list \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
            aligned { 
                foreach {sx sy} $p_start break
                foreach {ex ey} $p_end   break
                set dimObject [ $cvObject create dimensionLength \
                                        [list $p_start $p_end] \
                                        [list \
                                            aligned \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
            horizontal { 
                foreach {sx sy} $p_start break
                foreach {ex ey} $p_end   break
                set dimObject [ $cvObject create dimensionLength \
                                        [list $p_start $p_end] \
                                        [list \
                                            horizontal \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
            vertical { 
                foreach {sx sy} $p_start break
                foreach {ex ey} $p_end   break
                set dimObject [ $cvObject create dimensionLength \
                                        [list $p_start $p_end] \
                                        [list \
                                            vertical \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
            perpendicular_red { 
                foreach {sx sy} $p_start break
                foreach {ex ey} $p_end   break
                set dimObject [ $cvObject create dimensionLength \
                                        [list {0 0} $p_start $p_end ] \
                                        [list \
                                            perpendicular \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
            perpendicular_blue { 
                foreach {sx sy} $p_end   break
                foreach {ex ey} $p_start break
                set dimObject [ $cvObject create dimensionLength \
                                        [list {0 0} $p_end $p_start ] \
                                        [list \
                                            perpendicular \
                                            $dim_dist \
                                            $dim_offset \
                                            $font_colour]]
            }
        }
            #
        $cvObject addtag {__testDimension__} withtag  $dimObject							
            #
            # set coordList [list  [lindex $p_start 0]  [lindex $p_start 1] [lindex $p_end 0]  [lindex $p_end 1]]
            # set aItem     [$cvObject  create   line $coordList -tags dimension  -fill orange]
            # $cvObject addtag {__testDimension__} withtag  $aItem
            # puts "      <I> ... coordList: $coordList"
            # puts "      <I> ... [$cvObject gettags $aItem]"
                #
        if {$dim_sensitive} {
            add_sensitive $dimObject
        
            # puts ""
            # puts "      <I> ... add sensitive Area with tagID: ... ?"
            # puts ""
            # set textObject  [$dimObject get_textTag]
            # set mySensitive [$dimObject createSensitiveArea]
            #     # puts "   -> $mySensitive $tagDimension"
            # $cvObject bind  $mySensitive    <ButtonPress-1>         [list sketchboard::dimensionMessage %x %y $mySensitive]
                #
        }
            #
        set tagDimension   [$dimObject get_dimensionTag]
        $cvObject addtag {__testDimension__} withtag  $tagDimension
            #
            #
            # $cvObject reportSettings
            #
        # dim_size    
        # $cvObject create rectangle [list 0 0 10 $dim_size] 	-tags {__Reference_01__}  -outline violet 
        # sketchboard::moveto_StageCenter {__Reference_01__}
            #
        sketchboard::moveto_StageCenter {__testDimension__}
            #
    }
    
    
    proc add_sensitive {dimObject} {
            #
        variable  cvObject
            #
        puts ""
        puts "      <I> ... add sensitive Area with tagID: ... ?"
        puts ""
        set textObject  [$dimObject get_textTag]
        set mySensitive [$dimObject createSensitiveArea]
            # puts "   -> $mySensitive $tagDimension"
        $cvObject bind  $mySensitive    <ButtonPress-1>         [list sketchboard::dimensionMessage %x %y $mySensitive]
            #
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
set cvObject [sketchboard::createStage    $f_canvas   1200 800  1.0]


    #
    ### -- G U I - canvas demo
    
set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
    
labelframe  $f_settings.settings    -text settings
labelframe  $f_settings.angle       -text angle
labelframe  $f_settings.radius      -text radius
labelframe  $f_settings.length      -text length
labelframe  $f_settings.sensitive   -text sensitive
labelframe  $f_settings.font        -text font
# labelframe  $f_settings.demo      -text demo
labelframe  $f_settings.canvas      -text canvas
labelframe  $f_settings.export      -text export

pack        $f_settings.settings	\
            $f_settings.sensitive   \
            $f_settings.angle		\
            $f_settings.radius		\
            $f_settings.length		\
            $f_settings.font		\
            $f_settings.canvas      \
            $f_settings.export  -fill x -side top 

create_config_line $f_settings.settings.end_angle     "end angle    (blue):"	sketchboard::end_angle     -40  400
create_config_line $f_settings.settings.end_length    "end length   (blue):"	sketchboard::end_length	    50   90
create_config_line $f_settings.settings.start_angle   "start angle  (red): "	sketchboard::start_angle   -20  420
create_config_line $f_settings.settings.start_length  "start length (red): "	sketchboard::start_length   50  190
                   $f_settings.settings.start_angle.scl      configure   -resolution 0.1

create_config_line $f_settings.settings.dim_size      "dimension size:     "	sketchboard::dim_size        0   10
create_config_line $f_settings.settings.dim_dist      "dimension distance: "	sketchboard::dim_dist      -50  130
create_config_line $f_settings.settings.dim_offset    "dimension offset:   "	sketchboard::dim_offset   -250  250


radiobutton        $f_settings.length.aligned \
                            -text      "aligned   " \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "aligned" \
                            -command   "sketchboard::update_board"
                            
radiobutton        $f_settings.length.horizontal \
                            -text      "horizontal" \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "horizontal" \
                            -command   "sketchboard::update_board"
                            
radiobutton        $f_settings.length.vertical \
                            -text      "vertical  " \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "vertical" \
                            -command   "sketchboard::update_board"
                            
radiobutton        $f_settings.length.perp_red \
                            -text      "perp. to red line " \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "perpendicular_red" \
                            -command   "sketchboard::update_board"
                            
radiobutton        $f_settings.length.perp_blue \
                            -text      "perp. to blue line  " \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "perpendicular_blue" \
                            -command   "sketchboard::update_board"
                            

radiobutton        $f_settings.angle.angle  \
                            -text      "angle" \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "angle" \
                            -command   "sketchboard::update_board" \
                            -justify   left
  

radiobutton        $f_settings.radius.radius  \
                            -text      "radius" \
                            -variable  "sketchboard::dim_type_select" \
                            -value     "radius" \
                            -command   "sketchboard::update_board" \
                            -justify   left
  

radiobutton        $f_settings.sensitive.on  \
                            -text      "sensitive - on" \
                            -variable  "sketchboard::dim_sensitive" \
                            -value     "1" \
                            -command   "sketchboard::update_board" \
                            -justify   left
  
radiobutton        $f_settings.sensitive.off  \
                            -text      "sensitive - off" \
                            -variable  "sketchboard::dim_sensitive" \
                            -value     "0" \
                            -command   "sketchboard::update_board" \
                            -justify   left
  
radiobutton        $f_settings.font.vector  \
                            -text      "vector" \
                            -variable  "sketchboard::dim_font_select" \
                            -value     "vector" \
                            -command   "sketchboard::update_board" \
                            -justify   left
  
radiobutton        $f_settings.font.standard  \
                            -text      "standard" \
                            -variable  "sketchboard::dim_font_select" \
                            -value     "standard" \
                            -command   "sketchboard::update_board" \
                            -justify   left


# radiobutton       $f_settings.demo.dimension  \
                            -text      "dimension" \
                            -variable  "sketchboard::demo_type" \
                            -value     "dimension" \
                            -command   "sketchboard::update_board" \
                            -justify   left
                            
# radiobutton       $f_settings.demo.graphic  \
                            -text      "graphic" \
                            -variable  "sketchboard::demo_type" \
                            -value     "graphic" \
                            -command   "sketchboard::update_board" \
                            -justify   left
                            

create_config_line $f_settings.canvas.drw_scale	" Drawing scale "       sketchboard::drwScale   0.2  2  
                   $f_settings.canvas.drw_scale.scl      configure   -resolution 0.1
create_config_line $f_settings.canvas.cv_scale	" Canvas scale  "       sketchboard::cvScale    0.2  3.0  
                   $f_settings.canvas.cv_scale.scl      	configure   -resolution 0.1  -command "sketchboard::scaleBoard"
create_config_line $f_settings.canvas.precision  "Dimension precision"  sketchboard::precision  0    5  
                   $f_settings.canvas.precision.scl      configure   -resolution 1.0  -command "sketchboard::setPrecision"

button             $f_settings.canvas.reset     -text "reset Precision" -command {sketchboard::setPrecision reset}
button             $f_settings.canvas.recenter  -text "recenter"        -command {sketchboard::recenter_board}
button  		   $f_settings.canvas.refit		-text "refit"           -command {sketchboard::refit_board}
button             $f_settings.canvas.exportSVG -text "export SVG"      -command [list exportSVG $cvObject]
                               
button             $f_settings.canvas.clear     -text "clear"           -command {$cvObject deleteContent} 
button             $f_settings.canvas.update    -text "update"          -command {sketchboard::update_board}
button             $f_settings.canvas.raster    -text "raster on/off"   -command {sketchboard::switchRaster}


    # -- select font-colour ---
    #   --- handle ListboxSelect:
    #          return last not current selected value ????
set colourList [ frame $f_settings.settings.f ]
pack        $colourList
listbox     $colourList.colourList -height 4
            #listbox .lb -selectmode multiple -height 4
scrollbar   $colourList.sb -command [list $colourList.colourList yview]
            $colourList.colourList configure -yscrollcommand [list $colourList.sb set]
            $colourList.colourList insert 0 red yellow green blue default
pack 	    $colourList.colourList \
            $colourList.sb -side left -expand 1 -fill both
bind        $colourList.colourList <<ListboxSelect>>  [list eval_listbox   %W]
                    
proc eval_listbox {w} {
    # puts " -> eval_listbox [$w get active]"
    # puts " -> eval_listbox [$w curselection]"
    # puts " -> eval_listbox [$w get [$w curselection]]"
    set sketchboard::font_colour [$w get [$w curselection]]
    sketchboard::update_board
}



                               
pack  	$f_settings.settings.end_angle \
        $f_settings.settings.end_length \
        $f_settings.settings.start_angle \
        $f_settings.settings.start_length \
        $f_settings.settings.dim_dist \
        $f_settings.settings.dim_offset \
        $colourList \
        $f_settings.length.aligned \
        $f_settings.length.horizontal \
        $f_settings.length.vertical \
        $f_settings.length.perp_red \
        $f_settings.length.perp_blue \
        $f_settings.angle.angle \
        $f_settings.radius.radius \
        $f_settings.sensitive.on \
        $f_settings.sensitive.off \
        $f_settings.font.vector \
        $f_settings.font.standard \
        $f_settings.canvas.drw_scale \
        $f_settings.canvas.cv_scale \
        $f_settings.canvas.reset\
        $f_settings.canvas.recenter \
        $f_settings.canvas.refit \
        $f_settings.canvas.clear \
        $f_settings.canvas.update \
        $f_settings.canvas.raster \
        $f_settings.canvas.exportSVG \
    -side top  -fill x
    
        # $f_settings.demo.dimension \
        # $f_settings.demo.graphic \


pack  $f_settings  -side top -expand yes -fill both
 
    #
    ### -- G U I - canvas status
    
# set f_status  [labelframe .f0.f_config.f_status  -text "status" ]
#     create_status_line  $f_status.cv_width   "canvas width:"   canvas_width 
#     create_status_line  $f_status.cv_heigth  "canvas heigth:"  canvas_heigth 
# 
# pack  $f_status  -side top -expand yes -fill x

    # set sketchboard::precision [$sketchboard::cvObject setPrecision 2 default]

    ####+### E N D
    
update

sketchboard::update_board

    # $sketchboard::cvObject reportXMLRoot

wm minsize . [winfo width  .]   [winfo height  .]
  
  
   
 
 

 