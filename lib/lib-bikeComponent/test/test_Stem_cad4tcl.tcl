##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2016/01/01
#
#   canvasCAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 

    #
    #
set WINDOW_Title      "test bikeComponent - Stem, based on cad4tcl@rattleCAD"
    #
    #
variable APPL_ROOT_Dir

set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir __ext_Libraries]
    
package require     Tk
package require     extSummary
package require     vectormath
package require     cad4tcl
package require     bikeComponent
    #
foreach dir $auto_path {
    puts "    -> $dir"
}
    #


 
 ##+######################



 ##+######################

namespace eval model {}
namespace eval view {
    variable cvObject
    variable stageCanvas
    variable stageNamespace
    variable reportText
}
namespace eval control {
    
    # variable myCanvas
    
        # defaults
    variable dim_size            5
    variable dim_dist           30
    variable dim_offset          0
    variable dim_type_select    aligned
    variable dim_font_select    vector
    variable std_fnt_scl         1
    variable font_colour        black
    variable demo_type            dimension
    variable drw_scale           0.8
    variable cv_scale            1
    variable debugMode           off

    variable headTube_Angle     72
           
    variable arcPrecission   5
    
    
    set myObject            [bikeComponent::Stem    new]

    variable stemAngle      [$myObject getValue Scalar Angle]       
    variable stemLength     [$myObject getValue Scalar Length]             
    variable shaftLength    [$myObject getValue Scalar Length_Shaft]


}    


proc control::clean_StageContent {} {
    $view::cvObject deleteContent    
}
proc control::moveto_StageCenter {itemList} {
        #
    set w           [$view::cvObject getCanvas]
        #
    set stageCenter [$view::cvObject getCenter]
    set bottomLeft  [$view::cvObject getBottomLeft]
        #
    foreach {cx cy} $stageCenter break
    foreach {lx ly} $bottomLeft  break
        #
    foreach item $itemList {
        # puts "  -> move $item"
        $w move $item [expr $cx - $lx] [expr $cy -$ly]
    }
        #
}
   
    
    
proc control::recenter_board {} {
    
        set cvObject $::view::cvObject
        
        variable  cv_scale 
        variable  drw_scale 
        
        puts "\n  -> recenter_board:   $cvObject "
        
        puts "\n\n============================="
        puts "   -> cv_scale:           $cv_scale"
        puts "   -> drw_scale:          $drw_scale"
        puts "\n============================="
        puts "\n\n"
        
        set cv_scale [$cvObject fit]
}
proc control::refit_board {} {
    variable cv_scale
    
    $view::cvObject fit
    update_board
    
    set cv_scale [$view::cvObject configure Canvas Scale]
}
proc control::scale_board {{value {1}}} {
    
    variable  cv_scale 
    variable  drw_scale 
    
    set cvObject $::view::cvObject
    
    puts "\n  -> scale_board:   $cvObject"
            
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "\n============================="
    puts "\n\n"
    
    $cvObject center $cv_scale
    
}
proc control::scale_drawing {{value {1}}} {

    variable  drw_scale 
    
    set cvObject $::view::cvObject
    
    puts "\n  -> scale_drawing:   $cvObject"
            
    puts "\n\n============================="
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"
    
    $cvObject configure Stage Scale $drw_scale
    
    update_board
    
}
    #
proc control::draw_centerLineEdge {} {
    
    set myCanvas $::view::stageNamespace
    
    $::view::stageCanvas addtag {__CenterLine__} withtag  [$myCanvas  create   circle {0 0}     -radius 2  -outline red        -fill white]
    set basePoints {}
    set p00 {0 0}
    set angle_00 0 
    set p01 [vectormath::addVector $p00 [vectormath::rotateLine {0 0} $control::S01_length $angle_00]]
    set angle_01 [expr $angle_00 + $control::S01_angle]
    set p02 [vectormath::addVector $p01 [vectormath::rotateLine {0 0} $control::S02_length $angle_01]]
    set angle_02 [expr $angle_01 + $control::S02_angle]
    set p03 [vectormath::addVector $p02 [vectormath::rotateLine {0 0} $control::S03_length $angle_02]]
    
    $::view::stageCanvas addtag {__CenterLine__} withtag  [$::view::stageCanvas  create   circle $p01       -radius 5  -outline green        -fill white]
    $::view::stageCanvas addtag {__CenterLine__} withtag  [$::view::stageCanvas  create   circle $p02       -radius 5  -outline green        -fill white]
    $::view::stageCanvas addtag {__CenterLine__} withtag  [$::view::stageCanvas  create   circle $p03       -radius 5  -outline green        -fill white]

    lappend basePoints $p00
    lappend basePoints $p01
    lappend basePoints $p02
    lappend basePoints $p03

    append polyLineDef [canvasCAD::flatten_nestedList $basePoints]
      # puts "  -> $polyLineDef"
    $::view::stageCanvas addtag {__CenterLine__} withtag  {*}[$myCanvas  create   line $polyLineDef -tags dimension  -fill green ]
}
    #
proc control::update_board {{value {0}}} {
        
        #
    set cvObject $view::cvObject
    set myCanvas $::view::stageNamespace
    
    variable myObject
    
    variable unbentShape
    variable profileDef
    
    variable debugMode
    variable headTube_Angle
            
        variable  start_angle 
        variable  start_length
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
        variable  cv_scale 
    
    variable  profile_x00
    variable  profile_y00
    variable  profile_x01
    variable  profile_y01
    variable  profile_x02
    variable  profile_y02
    variable  profile_x03
    variable  profile_y03
    
    variable  bladeBent      
    variable  bladeStraight  
    variable  bladeMAX       
    
    
    set pos_Offset  {250 160}
    set pos_Offset  {60   10}
    
                 
        #
        # $myCanvas clean_StageContent
    $cvObject deleteContent
        #
    set board [$cvObject getCanvas]

    if {$font_colour == {default}} { 
        set font_colour [ $myCanvas getNodeAttr Style  fontcolour ]
    }
            
      #puts "\n\n============================="
      #puts "   -> drw_scale:          $drw_scale"
      #puts "   -> font_colour:           $font_colour"
      #puts "   -> dim_size:           $dim_size"
      #puts "   -> dim_font_select:       $dim_font_select"
      #puts "\n============================="
      #puts "   -> Drawing:               [[$myCanvas getNode Stage] asXML]"
      #puts "\n============================="
      #puts "   -> Style:                   [[$myCanvas getNode Style] asXML]"
      #puts "\n============================="
      ##$myCanvas reportMyDictionary
      #puts "\n============================="
      #puts "\n\n"
    
      # -- clear text field
    $::view::reportText delete 1.0  end


    
    if {$demo_type != {dimension} } {
        view::demo_canvasCAD 
        return
    }
            
    
        # draw orientation of bent tube
    # set orient_01 [list 0 0]
    # set orient_02 [list $crownOffset 0]
    # set orient_03 [list $crownOffset $crownPerp]
    # set orient_04 [list $forkHeight $crownPerp]
    # set orient_05 [list $forkHeight $forkRake]
    
        # ------------------------------------
                    # update $myCanvas ->
    # set dropout_Angle    [expr 0 - $headTube_Angle]
    # set dropOutAngle    [expr $dropOutAngle - $headTube_Angle]
    # puts "     \$dropout_Angle $dropout_Angle"
    
    $myObject       update    
        #
    set svgNode_Stem   [$myObject getValue ComponentNode XZ]
        #
    set pos_Origin     [$myObject getValue Position      Origin]
    set pos_Steerer    [$myObject getValue Position      Steerer]
    set pos_Spacer     [$myObject getValue Position      Origin_Spacer]
    set pos_SpacerEnd  [$myObject getValue Position      End_Spacer]
        #
    puts "    -> \$pos_Origin       $pos_Origin"    
    puts "    -> \$pos_Steerer      $pos_Steerer"    
    puts "    -> \$pos_Spacer       $pos_Spacer"    
    puts "    -> \$pos_SpacerEnd    $pos_SpacerEnd"    
        #
    set pos_Origin     [vectormath::addVector $pos_Offset   $pos_Origin]      
    set pos_Steerer    [vectormath::addVector $pos_Offset   $pos_Steerer]     
    set pos_Spacer     [vectormath::addVector $pos_Offset   $pos_Spacer]      
    set pos_SpacerEnd  [vectormath::addVector $pos_Offset   $pos_SpacerEnd]   
        
        
        
        
        # $myCanvas readSVGNode $svgNode_Stem    $pos_Offset 
    set myComponent [$cvObject create svg $pos_Offset [list -svgNode $svgNode_Stem  -tags __Component__]]
        #
        # [namespace current]::moveto_StageCenter $myComponent
        #
	set myItem_01   [$cvObject create centerline [join "$pos_Origin $pos_Steerer" " "]  -tags __CenterLine__  -outline red]
    set myItem_02   [$cvObject create centerline [join "$pos_Steerer $pos_Spacer" " "]  -tags __CenterLine__  -outline red]
        #
    set myItem_03   [$cvObject create circle $pos_Origin     -radius 2  -outline blue  -tags __CenterLine__]
    set myItem_04   [$cvObject create circle $pos_Steerer    -radius 2  -outline blue  -tags __CenterLine__]
    set myItem_05   [$cvObject create circle $pos_Spacer     -radius 2  -outline blue  -tags __CenterLine__]
    set myItem_06   [$cvObject create circle $pos_SpacerEnd  -radius 2  -outline blue  -tags __CenterLine__]
        #
    set myDim_01    [$cvObject create dimensionLength \
                                            [appUtil::flatten_nestedList   $pos_Steerer $pos_Origin] \
                                            [list \
                                                horizontal \
                                                [expr   -50 * $drw_scale]   [expr   0 * $drw_scale]  \
                                                gray50]]                                                                                                              
    set myDim_02    [$cvObject create dimensionLength \
                                            [appUtil::flatten_nestedList   $pos_Steerer $pos_Origin] \
                                            [list \
                                                aligned \
                                                [expr   -45 * $drw_scale]   [expr   -5 * $drw_scale]  \
                                                gray50]]                                                                                                              
    set myDim_03    [$cvObject create dimensionLength \
                                            [appUtil::flatten_nestedList   $pos_Steerer $pos_Spacer] \
                                            [list \
                                                vertical \
                                                [expr    45 * $drw_scale]   [expr    0 * $drw_scale]  \
                                                gray50]]                                                                                                              
    
    [namespace current]::moveto_StageCenter [list \
                                                $myComponent \
                                                $myItem_01 $myItem_02 $myItem_03 $myItem_04 $myItem_05 $myItem_06 \
                                                [$myDim_01 get_dimensionTag] \
                                                [$myDim_02 get_dimensionTag] \
                                                [$myDim_03 get_dimensionTag] \
                                            ]
    
    return            
}
    #
proc control::setStemType {} {
    variable myObject
    variable stemType
    
    switch -exact $stemType {
        "Ahead" {$myObject setValue Config Type Ahead}
        "Quill" {$myObject setValue Config Type Quill}
    }
        #
    $myObject update
        #
    update_board
}
    #
proc control::setComponentScalar {entryVar args} {
    variable myObject
    variable stemType
    
    puts "  -> $entryVar"
    set entryValue  [set $entryVar]
    puts "  -> $entryValue"
    set entryKey    [lindex [split $entryVar :] 2]
    puts "  -> $entryKey"
        #
    switch -exact $entryKey {
        stemAngle       {   $myObject setValue Scalar Angle         $entryValue }          
        stemLength      {   $myObject setValue Scalar Length        $entryValue }       
        shaftLength     {   $myObject setValue Scalar Length_Shaft  $entryValue }             
        default         {}
    }
        #
    $myObject update
        #
    update_board
}
    #
proc control::dimensionMessage { x y id} {
        tk_messageBox -message "giveMessage: $x $y $id"
        
    }        
    #



 #
 ### -- G U I
proc view::create_config_line {w lb_text entry_var start end  } {        
        frame   $w
        pack    $w
 
        global $entry_var
        puts "  -> \$entry_var $entry_var"

        label   $w.lb    -text $lb_text            -width 20  -bd 1  -anchor w 
        entry   $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
     
        scale   $w.scl  -width        12 \
                        -length       120 \
                        -bd           1  \
                        -sliderlength 15 \
                        -showvalue    0  \
                        -orient       horizontal \
                        -command      [list control::setComponentScalar $entry_var] \
                        -variable     $entry_var \
                        -from         $start \
                        -to           $end 
                            # -resolution   $resolution

        pack      $w.lb  $w.cfg $w.scl    -side left  -fill x            
}
proc view::create_status_line {w lb_text entry_var} {         
        frame   $w
        pack    $w
 
        global $entry_var

        label     $w.lb     -text $lb_text            -width 20  -bd 1  -anchor w 
        entry     $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
        pack      $w.lb  $w.cfg    -side left  -fill x            
}
proc view::demo_canvasCAD {} {
          
      variable  stageCanvas
      
      $stageCanvas  create   line           {0 0 20 0 20 20 0 20 0 0}       -tags {Line_01}  -fill blue   -width 2 
      $stageCanvas  create   line           {30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
      $stageCanvas  create   line           {0 0 30 30 }                    -tags {Line_01}  -fill blue   -width 2 
      
      $stageCanvas  create   rectangle      {180 120 280 180 }              -tags {Line_01}  -fill violet   -width 2 
      $stageCanvas  create   polygon        {40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 

      $stageCanvas  create   oval           {30 160 155 230 }               -tags {Line_01}  -fill red   -width 2         
      $stageCanvas  create   circle         {160 60}            -radius 50  -tags {Line_01}  -fill blue   -width 2 
      $stageCanvas  create   arc            {270 160}           -radius 50  -start 30       -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
      
      $stageCanvas  create   text           {140 90}  -text "text a"
      $stageCanvas  create   vectortext     {120 70}  -text "vectorText ab"
      $stageCanvas  create   vectortext     {100 50}  -text "vectorText abc"  -size 10
      $stageCanvas  create   text           {145 95}  -text "text abcd" -size 10
}
proc view::createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
    variable cvObject
    variable stageCanvas
    variable stageNamespace
    variable cv_scale
        #
    set parentPath [file rootname $cv_path]
    set cvName     [file tail $cv_path]
        #
        # puts "   \$parentPath   $parentPath"
        # puts "   \$cvName       $cvName"
        # 
        #exit
        #
        # puts "   \$cv_path   $cv_path"    
        # puts "   \$cv_width  $cv_width"    
        # puts "   \$cv_height $cv_height"    
        # puts "   \$st_width  $st_width"    
        # puts "   \$st_height $st_height"  
        # flush stdout       
        #
        #                  eval canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args
        # set stageCanvas [eval canvasCAD::newCanvas $varname  $notebook.$varname \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args]
        # set stageCanvas [canvasCAD::newCanvas cv01  $cv_path     "stageCanvas"  $cv_width $cv_height     A3 0.5 40 $args]
        #
    # set retValue [eval canvasCAD::newCanvas $cvName  $parentPath     "stageCanvas"  $cv_width $cv_height     A3 0.5 40 $args]
    # foreach {stageCanvas stageNamespace} $retValue break
    
    set cad4tcl::canvasType   1
    
    set cvObject        [cad4tcl::new  $parentPath   $cv_width $cv_height     A4  1.0  40]
    set stageCanvas     [$cvObject getCanvas]
    set stageNamespace  [$cvObject getNamespace]
    
    
    
        # puts "  -> $retValue"
        # set stageCanvas   $cv
    # set cv_scale [$stageNamespace getNodeAttr Canvas scale]
    set cv_scale [$cvObject configure Canvas Scale]
    return $stageCanvas
}
proc view::create {windowTitle} {
            #
        variable reportText
        variable stageCanvas
        #
        frame .f0 
        set f_canvas  [labelframe .f0.f_canvas   -text "board"  ]
        set f_config  [frame      .f0.f_config   ]

        pack  .f0      -expand yes -fill both
        pack  $f_canvas  $f_config    -side left -expand yes -fill both
        pack  configure  $f_config    -fill y
       
      
        #
        ### -- G U I - canvas 
        set stageCanvas    [view::createStage    $f_canvas.cv   1000 810  250 250 m  0.5 -bd 2  -bg white  -relief sunken]
        # set stageCanvas    [view::createStage    $f_canvas.cv   1000 810  250 250 m  0.5 -bd 2  -bg white  -relief sunken]
        

        #
        ### -- G U I - canvas demo
            
        set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
            
        labelframe  $f_settings.centerline      -text centerline
        labelframe  $f_settings.orientation     -text orientation
        labelframe  $f_settings.type            -text "Component - Style"
        labelframe  $f_settings.compParameter   -text "Component - Parameter"
        labelframe  $f_settings.precission      -text precission
        labelframe  $f_settings.font            -text font
        labelframe  $f_settings.demo            -text demo
        labelframe  $f_settings.scale           -text scale

        pack        $f_settings.orientation \
                    $f_settings.type \
                    $f_settings.centerline  \
                    $f_settings.compParameter \
                    $f_settings.precission  \
                    $f_settings.font        \
                    $f_settings.demo        \
                    $f_settings.scale   -fill x -side top 

        radiobutton        $f_settings.type.ahead          -text "Ahead     "   -variable  "control::stemType"   -value   "Ahead"    -command   "control::setStemType"
        radiobutton        $f_settings.type.quill          -text "Quill     "   -variable  "control::stemType"   -value   "Quill"    -command   "control::setStemType"
      
        view::create_config_line $f_settings.compParameter.w_01   "   stemAngle:    "  control::stemAngle       -40    40   ;#   0
        view::create_config_line $f_settings.compParameter.w_02   "   stemLength:   "  control::stemLength       50   160   ;#   0
        view::create_config_line $f_settings.compParameter.l_01   "   shaftLength:  "  control::shaftLength      15    90   ;#   0

        # view::create_config_line $f_settings.precission.prec      " precission:  "  control::arcPrecission      1  15   ;#  24
        # button                 $f_settings.scale.recenter -text "recenter"   -command {control::recenter_board}
        
        # pack      \
                $f_settings.orientation.left \
                $f_settings.orientation.center \
                $f_settings.orientation.right \
                -side left

              # $f_settings.scale.recenter
              
        pack    $f_settings.type.ahead \
                $f_settings.type.quill  \
                -side top 
                                               
                         
        pack  $f_settings  -side top -expand yes -fill both
         
         
            #
            ### -- G U I - canvas print
            #    
        if 0 { 
            set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
                button  $f_print.bt_print   -text "print"  -command {$view::stageCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
             
            pack  $f_print  -side top     -expand yes -fill x
                pack $f_print.bt_print     -expand yes -fill x
        }
        
            #
            ### -- G U I - canvas config
            #   
        set f_demo  [labelframe .f0.f_config.f_demo  -text "Canvas" ]
            button  $f_demo.bt_refit   -text "refit"    -command {control::refit_board}
            button  $f_demo.bt_clear   -text "clear"    -command {control::clean_StageContent} 
            button  $f_demo.bt_update  -text "update"   -command {control::update_board}

            view::create_config_line    $f_demo.drw_scale       " Drawing scale "  control::drw_scale       0.2  2  
            view::create_config_line    $f_demo.cv_scale        " Canvas scale  "  control::cv_scale        0.2  5.0 
                                        $f_demo.drw_scale.scl   configure   -resolution 0.1  -command "control::scale_drawing"
                                        $f_demo.cv_scale.scl    configure   -resolution 0.1  -command "control::scale_board"

                                 
        pack  $f_demo  -side top    -expand yes -fill x
            pack $f_demo.bt_refit   -expand yes -fill x
            pack $f_demo.bt_clear   -expand yes -fill x
            pack $f_demo.bt_update  -expand yes -fill x
        
                                 
        pack \
                 $f_demo.drw_scale \
                 $f_demo.cv_scale   -side top   -fill x                                                          
                         
        
            #
            ### -- G U I - canvas status
            #
        if 0 { 
            set f_status  [labelframe .f0.f_config.f_status  -text "status" ]

            view::create_status_line  $f_status.cv_width   "canvas width:"   canvas_width 
            view::create_status_line  $f_status.cv_heigth  "canvas heigth:"  canvas_heigth 
         
            pack  $f_status  -side top -expand yes -fill x
        }


            #
            ### -- G U I - canvas report
            #
        set f_report    [labelframe .f0.f_config.f_report  -text "report" ]

        set reportText  [text       $f_report.text -width 50 -height 7]
        scrollbar       $f_report.sby -orient vert -command "$reportText yview"
                                       $f_report.text conf -yscrollcommand "$f_report.sby set"
        pack $f_report  -side top     -expand yes -fill both
        pack $f_report.sby $reportText -expand yes -fill both -side right        
        
        
        
        ####+### E N D
        
        update
        
        wm minsize . [winfo width  .]   [winfo height  .]
        wm title   . $windowTitle
        
        return . $stageCanvas

}


    #
    # -- GUI --
    #
set returnValues [view::create $WINDOW_Title]
 # set control::myCanvas [lindex $returnValues 1]
    #
control::update_board    
    #
control::refit_board
    #
# $::view::stageNamespace reportXMLRoot
        
        




