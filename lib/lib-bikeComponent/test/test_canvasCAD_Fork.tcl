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
 


    set WINDOW_Title      "test bikeComponent - Fork, based on canvasCAD@rattleCAD"
        #
        #
    set APPL_ROOT_Dir [file dirname [lindex $argv0]]
    puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
        #
    set APPL_Package_Dir [file normalize [file dirname [file dirname $APPL_ROOT_Dir]]]
    puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
        #
    lappend auto_path [file normalize $APPL_Package_Dir]
    lappend auto_path [file normalize $APPL_Package_Dir/../..]
        #
    foreach dir $auto_path {
        puts "    -> $dir"
    }
        #
    package require   Tk
    package require   canvasCAD
    package require   bikeComponent
    package require   vectormath
  
  
     
  ##+######################
 

  
##+######################

    namespace eval model {}
    namespace eval view {
        variable stageCanvas
        variable stageNamespace
        variable reportText
    }
    namespace eval control {
        
        # variable myCanvas
        
            # defaults
        variable start_angle        20
        variable start_length       80
        variable end_length         65
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
    
        # variable headTube_Angle     72
        
        variable S01_length   150
        variable S02_length   160
        variable S03_length   120
        variable S04_length   100
        variable S01_angle     -9
        variable S02_angle      8
        variable S03_angle     -8
        variable S01_radius   320
        variable S02_radius   320
        variable S02_radius   310
        
        variable steererLength    165
        variable forkHeight       365
        variable forkRake          45
        variable bladeHeight      325
        variable bladeRake         45
        variable crownOffset       35
        variable crownPerp          0
        
        variable bladeWidth        28.0
        variable bladeDoWidth      12.0
        variable taperLength      250.0
        variable endLength         10
        variable bendRadius       550
        
        variable dropOutOffset     20
        variable dropOutPerp        0
        variable max_Offset         6
        variable bladeType        max
        variable forkType    supplier
        
        variable rimDiameter     622
        variable brakeOffset      20
        
        variable  profile_x00   0
        variable  profile_y00  12.5
        variable  profile_x01 250
        variable  profile_y01  28
        variable  profile_x02 150
        variable  profile_y02  28
        variable  profile_x03  75
        variable  profile_y03  28
        
        
        variable arcPrecission   5
        
            # variable bladeBent      [::bikeComponent::compForkBlade new bent]
            # variable bladeStraight  [::bikeComponent::compForkBlade new straight]
            # variable bladeMAX       [::bikeComponent::compForkBlade new MAX]
            # 
            # $bladeBent      update
            # $bladeStraight  update
            # $bladeMAX       update
            # 
            # # ::bikeComponent::init
        
        bikeComponent::init
        
        set forkStrategy        [bikeComponent::ForkStrategy    new ForkSupplier]
        
        variable Position   ;   array set Position {
                                        Wheel {0 0}
                                    }
        variable Vector     ;   array set Position {
                                        BrakeDefinition {1 0 1 1}
                                    }                                    
                                    
        
        #variable unbentShape
        #variable profileDef {}
        #     set profileDef {{0 7} {10 7} {190 9} {80 9} {70 12}}
        #     set profileDef {{0 9} {10 7} {190 16} {80 16} {70 24}}
        #     set profileDef {{0 7} {10 7} {190 16} {80 16} {70 24}}

    }    

        
    proc control::moveto_StageCenter {item} {
            set myCanvas $::view::stageNamespace
        
            set stage       [ $myCanvas getNodeAttr Canvas path ]
            set stageCenter [ canvasCAD::get_StageCenter $stage ]
            set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]
            foreach {cx cy} $stageCenter break
            foreach {lx ly} $bottomLeft  break
            $stage move $item [expr $cx - $lx] [expr $cy -$ly]
    }
        
        
    proc control::recenter_board {} {
        
            set myCanvas $::view::stageNamespace
        
            variable  cv_scale 
            variable  drw_scale 
            
            puts "\n  -> recenter_board:   $myCanvas "
            
            puts "\n\n============================="
            puts "   -> cv_scale:           $cv_scale"
            puts "   -> drw_scale:          $drw_scale"
            puts "\n============================="
            puts "\n\n"
            
            set cv_scale [ $myCanvas repositionToCanvasCenter ]
    }
    proc control::refit_board {} {
        
            set myCanvas $::view::stageNamespace
            
            variable  cv_scale 
            variable  drw_scale 
            
            puts "\n  -> recenter_board:   $::view::stageCanvas "
            
            puts "\n\n============================="
            puts "   -> cv_scale:           $cv_scale"
            puts "   -> drw_scale:          $drw_scale"
            puts "\n============================="
            puts "\n\n"
            
            # set cv_scale [ $myCanvas refitToCanvas ]
            set cv_scale [ $myCanvas refitStage]
    }
    proc control::scale_board {{value {1}}} {
        
            set myCanvas $::view::stageNamespace
        
            variable  cv_scale 
            variable  drw_scale 
            
            puts "\n  -> scale_board:   $myCanvas"
            
            #$myCanvas clean_StageContent
            #set board [ $myCanvas dict_getValue Canvas  path]
        
            
            puts "\n\n============================="
            puts "   -> cv_scale:           $cv_scale"
            puts "   -> drw_scale:          $drw_scale"
            puts "\n============================="
            puts "\n\n"
            
            $myCanvas scaleToCenter $cv_scale
    }

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


    proc control::reset_ForkScalar {} {
        
        variable forkStrategy

        $forkStrategy setValue Scalar SteererLength             125
        $forkStrategy setValue Scalar Height                    365
        $forkStrategy setValue Scalar Rake                       45
        $forkStrategy setValue Scalar CrownBladeOffset           35
        $forkStrategy setValue Scalar CrownBladeOffsetPerp        0
        $forkStrategy setValue Scalar BladeStartLength           28
        $forkStrategy setValue Scalar BladeDropoutWidth          12
        $forkStrategy setValue Scalar BladeTaperLength          250
        $forkStrategy setValue Scalar BladeBendRadius           550
        $forkStrategy setValue Scalar BladeWidth                 28
        $forkStrategy setValue Scalar DropoutBladeOffset         20
        $forkStrategy setValue Scalar DropoutBladeOffsetPerp      0 

        
        # setForkScalar   forkHeight       365
        # setForkScalar   forkRake          45
        # setForkScalar   crownOffset       35
        # setForkScalar   crownPerp          0
        #     #
        # setForkScalar   bladeWidth        28.0
        # setForkScalar   bladeDoWidth      12.0
        # setForkScalar   taperLength      250.0
        # setForkScalar   endLength         10
        # setForkScalar   bendRadius       550
        #     #
        # setForkScalar   dropOutOffset     20 
        # setForkScalar   dropOutPerp        0 
            #
        $forkStrategy update
            #
        update_board
            #
    }

    proc control::setForkScalar {entryVar args} {
        variable forkStrategy
        variable forkType
        
        puts "  -> $entryVar"
        set entryValue  [set $entryVar]
        puts "  -> $entryValue"
        set entryKey    [lindex [split $entryVar :] 2]
        puts "  -> $entryKey"
            #
        switch -exact $entryKey {
            steererLength   {   $forkStrategy setValue Scalar SteererLength             $entryValue }          
            forkHeight      {   $forkStrategy setValue Scalar Height                    $entryValue }          
            forkRake        {   $forkStrategy setValue Scalar Rake                      $entryValue }       
            crownOffset     {   $forkStrategy setValue Scalar CrownBladeOffset          $entryValue }       
            crownPerp       {   $forkStrategy setValue Scalar CrownBladeOffsetPerp      $entryValue }
            endLength       {   $forkStrategy setValue Scalar BladeStartLength          $entryValue }         
            bladeDoWidth    {   $forkStrategy setValue Scalar BladeDropoutWidth         $entryValue }
            taperLength     {   $forkStrategy setValue Scalar BladeTaperLength          $entryValue }         
            bendRadius      {   $forkStrategy setValue Scalar BladeBendRadius           $entryValue }         
            bladeWidth      {   $forkStrategy setValue Scalar BladeWidth                $entryValue }
            dropOutOffset   {   $forkStrategy setValue Scalar DropoutBladeOffset        $entryValue }         
            dropOutPerp     {   $forkStrategy setValue Scalar DropoutBladeOffsetPerp    $entryValue }         
            default         {}
        }
            #
        $forkStrategy update
            #
        update_board
            #
    }
        #
    proc control::setForkType {} {
        variable forkStrategy
        variable forkType
        
        switch -exact $forkType {
            "supplier"          {$forkStrategy setStrategy Supplier}
            "suspension_20"     {$forkStrategy setStrategy Suspension_20}
            "suspension_24"     {$forkStrategy setStrategy Suspension_24}
            "suspension_26"     {$forkStrategy setStrategy Suspension_26}
            "composite"         {$forkStrategy setStrategy Composite}
            "composite_45"      {$forkStrategy setStrategy Composite_45}
            "composite_56"      {$forkStrategy setStrategy Composite_56}
            "composite"         {$forkStrategy setStrategy Composite}
            "customBent"        {$forkStrategy setStrategy SteelCustomBent}  
            "customStraight"    {$forkStrategy setStrategy SteelCustomStraight}  
            "customMax"         {$forkStrategy setStrategy SteelLuggedMAX}   
        }
            #
        $forkStrategy update
            #
        update_board
    }
        #
    proc control::setBladeType {} {
        variable forkStrategy
        variable bladeType
            #
        $forkStrategy setValue Config BladeStyle $bladeType
            #
        $forkStrategy update
            #
        update_board
    }

    
    
    
    proc control::dimensionMessage { x y id} {
            tk_messageBox -message "giveMessage: $x $y $id"
            
        }        



    
  ### -- G U I  -  procedures
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
                            -command      [list control::setForkScalar $entry_var] \
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
        set retValue [eval canvasCAD::newCanvas $cvName  $parentPath     "stageCanvas"  $cv_width $cv_height     A3 0.5 40 $args]
        foreach {stageCanvas stageNamespace} $retValue break
        # puts "  -> $retValue"
        # set stageCanvas   $cv
        set cv_scale [$stageNamespace getNodeAttr Canvas scale]
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
            labelframe  $f_settings.type            -text type
            labelframe  $f_settings.tubeprofile     -text tubeprofile
            labelframe  $f_settings.brakePosition   -text brakePosition
            labelframe  $f_settings.precission      -text precission
            labelframe  $f_settings.font            -text font
            labelframe  $f_settings.demo            -text demo
            labelframe  $f_settings.scale           -text scale

            pack        $f_settings.orientation \
                        $f_settings.brakePosition  \
                        $f_settings.type \
                        $f_settings.centerline  \
                        $f_settings.tubeprofile \
                        $f_settings.precission  \
                        $f_settings.font        \
                        $f_settings.demo        \
                        $f_settings.scale   -fill x -side top 

            view::create_config_line $f_settings.orientation.x_02   " steererLength:  "  control::steererLength     120  350   ;#   0
            view::create_config_line $f_settings.orientation.x_00   "    forkHeight:  "  control::forkHeight        250  550   ;#   0
            view::create_config_line $f_settings.orientation.y_00   "      forkRake:  "  control::forkRake          -60   60   ;#   0
            view::create_config_line $f_settings.orientation.x_01   "   crownOffset:  "  control::crownOffset        -5   50   ;#   0
            view::create_config_line $f_settings.orientation.y_01   "     crownPerp:  "  control::crownPerp         -10   30   ;#   0
            
            view::create_config_line $f_settings.orientation.l_00   " dropOutOffset:  "  control::dropOutOffset       0   30   ;#   0
            view::create_config_line $f_settings.orientation.o_00   "   dropOutPerp:  "  control::dropOutPerp       -20   30   ;#   0
            
            view::create_config_line $f_settings.brakePosition.a01   "  brakeOffset:  "  control::brakeOffset         10   40   ;#   0
            view::create_config_line $f_settings.brakePosition.a03   "  rimDiameter:  "  control::rimDiameter        400  700   ;#   0
                #
            button                   $f_settings.orientation.reset    -text "reset"      -width 20  -command {control::reset_ForkScalar}

                    
                # view::create_config_line $f_settings.orientation.x_00   "bladeHeight:  "  control::bladeHeight    250  550   ;#   0
                # view::create_config_line $f_settings.orientation.y_00   "bladeRake:  "  control::bladeRake    -60   60   ;#   0
                # view::create_config_line $f_settings.orientation.m_00   "    max_Offset:  "  control::max_Offset          0  100   ;#   0
                        
                # radiobutton        $f_settings.orientation.left       -text "straight   "  -variable  "control::bladeType"  -value     "straight"       -command   "control::setBladeType"
                # radiobutton        $f_settings.orientation.center     -text "bent       "  -variable  "control::bladeType"  -value     "bent"           -command   "control::setBladeType"
                # radiobutton        $f_settings.orientation.right      -text "MAX        "  -variable  "control::bladeType"  -value     "max"            -command   "control::setBladeType"
                    
            radiobutton        $f_settings.orientation.debug_on   -text "on         "  -variable  "control::debugMode"  -value     "on"             -command   "control::update_board"
            radiobutton        $f_settings.orientation.debug_off  -text "off        "  -variable  "control::debugMode"  -value     "off"            -command   "control::update_board"
            
            radiobutton        $f_settings.type.supplier          -text "Supplier     "   -variable  "control::forkType"   -value   "supplier"       -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_20           -text "Suspension 20"   -variable  "control::forkType"   -value   "suspension_20"  -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_24           -text "Suspension 24"   -variable  "control::forkType"   -value   "suspension_24"  -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_26           -text "Suspension 26"   -variable  "control::forkType"   -value   "suspension_26"  -command   "control::setForkType"
            radiobutton        $f_settings.type.composite         -text "Composite    "   -variable  "control::forkType"   -value   "composite"      -command   "control::setForkType"
            radiobutton        $f_settings.type.composite45       -text "Composite 45 "   -variable  "control::forkType"   -value   "composite_45"    -command   "control::setForkType"
            radiobutton        $f_settings.type.composite56       -text "Composite 56 "   -variable  "control::forkType"   -value   "composite_56"    -command   "control::setForkType"
            radiobutton        $f_settings.type.customBnt         -text "CustomBent   "   -variable  "control::forkType"   -value   "customBent"     -command   "control::setForkType"
            radiobutton        $f_settings.type.customStr         -text "CustomStraight"  -variable  "control::forkType"   -value   "customStraight" -command   "control::setForkType"
            radiobutton        $f_settings.type.customMax         -text "CustomMAX    "   -variable  "control::forkType"   -value   "customMax"      -command   "control::setForkType"

          
            view::create_config_line $f_settings.tubeprofile.w_01   "    bladeWidth:  "  control::bladeWidth         15   60   ;#   0
            view::create_config_line $f_settings.tubeprofile.w_02   "  bladeDoWidth:  "  control::bladeDoWidth       10   40   ;#   0
            view::create_config_line $f_settings.tubeprofile.l_01   "   taperLength:  "  control::taperLength        20  300   ;#   0
            view::create_config_line $f_settings.tubeprofile.l_02   "     endLength:  "  control::endLength           0  300   ;#   0
            view::create_config_line $f_settings.tubeprofile.r_00   "    bendRadius:  "  control::bendRadius          0  700   ;#   0
                #
            view::create_config_line $f_settings.precission.prec     "   precission:  "  control::arcPrecission      1  15   ;#  24

            view::create_config_line $f_settings.scale.drw_scale     "  Drawing scale "  control::drw_scale       0.2  2  
            view::create_config_line $f_settings.scale.cv_scale      "  Canvas scale  "  control::cv_scale        0.2  5.0 
                                     $f_settings.scale.drw_scale.scl        configure   -resolution 0.1
                                     $f_settings.scale.cv_scale.scl         configure   -resolution 0.1  -command "control::scale_board"
                                     
            button                   $f_settings.scale.recenter -text "recenter"   -command {control::recenter_board}
            button                   $f_settings.scale.refit    -text "refit"      -command {control::refit_board}
            
            # pack      \
                    $f_settings.orientation.left \
                    $f_settings.orientation.center \
                    $f_settings.orientation.right \
                    -side left
                    
            pack      \
                    $f_settings.orientation.reset \
                    $f_settings.orientation.debug_on \
                    $f_settings.orientation.debug_off \
                    -side left
            pack      \
                    $f_settings.scale.drw_scale \
                    $f_settings.scale.cv_scale \
                    $f_settings.scale.recenter \
                    $f_settings.scale.refit \
                    -side top  -fill x                                                          
                             
            pack    $f_settings.type.supplier \
                    $f_settings.type.susp_20  \
                    $f_settings.type.susp_24  \
                    $f_settings.type.susp_26  \
                    $f_settings.type.composite \
                    $f_settings.type.composite45 \
                    $f_settings.type.composite56 \
                    $f_settings.type.customBnt \
                    $f_settings.type.customStr \
                    $f_settings.type.customMax \
                    -side top 
                                                   
                             
            pack  $f_settings  -side top -expand yes -fill both
             
                #
                ### -- G U I - canvas print
                #    
            set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
                button  $f_print.bt_print   -text "print"  -command {$view::stageCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
             
            pack  $f_print  -side top     -expand yes -fill x
                pack $f_print.bt_print     -expand yes -fill x
            
            
                #
                ### -- G U I - canvas demo
                #   
            set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
                button  $f_demo.bt_clear   -text "clear"    -command {$view::stageNamespace clean_StageContent} 
                button  $f_demo.bt_update  -text "update"   -command {control::update_board}
             
            pack  $f_demo  -side top    -expand yes -fill x
                pack $f_demo.bt_clear   -expand yes -fill x
                pack $f_demo.bt_update  -expand yes -fill x
            
            
                #
                ### -- G U I - canvas status
                #
            set f_status  [labelframe .f0.f_config.f_status  -text "status" ]

            view::create_status_line  $f_status.cv_width   "canvas width:"   canvas_width 
            view::create_status_line  $f_status.cv_heigth  "canvas heigth:"  canvas_heigth 
         
            
            pack  $f_status  -side top -expand yes -fill x


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


  ### -- M O C K U P  - prodecures
    proc control::update_BrakePosition {} {
            #
        variable forkStrategy
        variable brakeOffset
        variable rimDiameter
            #
        variable Position    
        variable Vector    
            #
        
        # variable Scalar
        # variable Position
        # variable Polyline
        # variable Vector
        # variable strategyObject
            #
            # puts "  \$Scalar(BladeBrakeOffset) $Scalar(BladeBrakeOffset)"
            # puts "  \$Scalar(RimDiameter) $Scalar(RimDiameter)"
            # puts "  \$Polyline(CenterLine) [$strategyObject getValue Polyline CenterLine]"
            #
        set height                  [$forkStrategy getValue Scalar Height]
        set rake                    [$forkStrategy getValue Scalar Rake]
        set radius                  [expr 0.5 * $rimDiameter]
            #
        set pos_Blade               [$forkStrategy getValue Position Blade]
        set pos_Dropout             [$forkStrategy getValue Position Dropout]
        set vector_ForkBlade        [$forkStrategy getValue Vector BladeDefinition]
            # set vector_ForkBlade        [vectormath::addVectorCoordList $pos_Dropout [$forkStrategy getValue Vector BladeDefinition]]
            #
        set p_01                    [lrange $vector_ForkBlade 0 1]
        set p_02                    [lrange $vector_ForkBlade 2 3]
            #
        set vector_BrakeDef         [vectormath::parallel $p_01 $p_02 $brakeOffset left]
        foreach {p_11 p_12}         $vector_BrakeDef break
            #
        set p_14                    [vectormath::intersectPerp $p_11 $p_12 $Position(Wheel)]
            #
        set dist_Perp               [vectormath::distancePerp $p_11 $p_12 $Position(Wheel)]
        set dist_Wheel              [expr sqrt(pow($radius,2) - pow($dist_Perp,2))]
            #
        set dir_Definition          [vectormath::unifyVector $p_11 $p_12]
            #
        set dist_Orientation        [vectormath::offsetOrientation $p_11 $p_12 $Position(Wheel)]
            #
        set Position(Brake)         [vectormath::addVector $p_14 [vectormath::unifyVector $p_12 $p_11] $dist_Wheel]
            #
        set vector_Repos            [list $rake 0]
            # set vector_Repos            [list $Scalar(Rake) $Scalar(Height)]
            #
        set Position(p_01)          $p_01
        set Position(p_02)          $p_02
        set Position(p_11)          $p_11
        set Position(p_12)          $p_12
        set Position(p_14)          $p_14
            #
        puts "      strategy: 011 -> \$p_11 $p_11"
        puts "      strategy: 012 -> \$p_12 $p_12"
        puts "      strategy: 014 -> \$p_14 $p_14"
        puts "      strategy: -----> orientation  $dist_Orientation"
        puts "      strategy: -----> \$dist_Perp  $dist_Perp"
        puts "      strategy: -----> \$dist_Wheel $dist_Wheel"
            #

        set Vector(BrakeDefinition) [vectormath::addVectorCoordList $vector_Repos [appUtil::flatten_nestedList $vector_BrakeDef]]
        set Vector(BrakeDefinition) [appUtil::flatten_nestedList $vector_BrakeDef]
            #
        return
            #
    }
        #
    proc control::update_board {{value {0}}} {
            
        # variable  myCanvas
        set myCanvas $::view::stageNamespace
        
        variable forkStrategy
        variable forkType
        
        variable Position
        variable Vector
        variable rimDiameter
        
        variable unbentShape
        variable profileDef
        
        variable debugMode
        # variable headTube_Angle
        
        variable forkHeight
        variable forkRake   
        variable bladeHeight
        variable bladeRake
        variable crownOffset   
        variable crownPerp     
        variable dropOutOffset
        variable dropOutPerp
        variable endLength
        variable bendRadius
        variable max_Offset
        variable bladeType
                
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
        
            # variable  profile_x00
            # variable  profile_y00
            # variable  profile_x01
            # variable  profile_y01
            # variable  profile_x02
            # variable  profile_y02
            # variable  profile_x03
            # variable  profile_y03
        
        variable  bladeBent      
        variable  bladeStraight  
        variable  bladeMAX       
        
        
            #
        $myCanvas clean_StageContent
            #
        set board [ $myCanvas getNodeAttr Canvas  path ]
    
        if {$font_colour == {default}} { set font_colour [ $myCanvas getNodeAttr Style  fontcolour ]}
                
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

            #
        $myCanvas setNodeAttr Stage    scale        $drw_scale
        $myCanvas setNodeAttr Style    fontstyle    $dim_font_select
        $myCanvas setNodeAttr Style    fontsize     $dim_size
        
            #
        if {$demo_type != {dimension} } {
            view::demo_canvasCAD 
            return
        }
        
            # ------------------------------------
        set svgNode_Steerer [$forkStrategy getValue ComponentNode XZ_Steerer]
        set svgNode_Crown   [$forkStrategy getValue ComponentNode XZ_Crown]
        set svgNode_Blade   [$forkStrategy getValue ComponentNode XZ_Blade]
        set svgNode_Dropout [$forkStrategy getValue ComponentNode XZ_Dropout]
            #
        set blade_Outline   [$forkStrategy getValue Polygon Blade]   
            #
            
        set angle_Dropout   [$forkStrategy getValue Direction Dropout]
        set centerLineBlade [$forkStrategy getValue Polyline  CenterLine]
        set vectorBladeDef  [$forkStrategy getValue Vector    BladeDefinition]
            #

        set pos_Crown       {150 350}
        set pos_Wheel       [vectormath::addVector $pos_Crown [list $forkRake [expr -1.0 * $forkHeight]]]
            #
        set pos_SteererEnd  [vectormath::addVector $pos_Crown [$forkStrategy getValue Position Steerer_End]]
        set pos_Dropout     [vectormath::addVector $pos_Crown [$forkStrategy getValue Position Dropout]]
        set pos_Blade       [vectormath::addVector $pos_Crown [$forkStrategy getValue Position Blade]]
        set pos_BladeEnd    [vectormath::addVector $pos_Crown [$forkStrategy getValue Position BladeEnd]]
        set pos_Brake       [vectormath::addVector $pos_Crown [$forkStrategy getValue Position Brake]]
            #
        puts "  -> \$pos_Crown          $pos_Crown"
        puts "  -> \$pos_Dropout        $pos_Dropout"
        puts "  -> \$pos_Blade          $pos_Blade"
        puts "  -> \$pos_BladeEnd       $pos_BladeEnd"
        puts "  -> \$angle_Dropout      $angle_Dropout"
            
            #
        set Position(Wheel) [list $forkRake [expr -1.0 * $forkHeight]]
            #
        update_BrakePosition            
            #
        set pos_Brake       [vectormath::addVector $pos_Crown $Position(Brake)]
        puts "  -> \$pos_Brake          $pos_Brake"
            
            
            
            # set pos_Dropout  $pos_Wheel
            #
        set p_99  [vectormath::rotateLine $pos_Dropout  $dropOutOffset [expr 90 + $angle_Dropout]]
        set p_98  [vectormath::rotateLine $p_99         $dropOutPerp   [expr 90 + (90 + $angle_Dropout)]] ;# BladePosition
        set p_60  [vectormath::rotateLine $pos_Dropout  $forkRake      [expr 90 +  90]]
        set p_00  [vectormath::rotateLine $p_60         $forkHeight    [expr 90 +   0]]                   ;# ForkCrown Position
        set p_10  [vectormath::rotateLine $p_00         $crownOffset   [expr 90 + 180]]
        set p_20  [vectormath::rotateLine $p_10         $crownPerp     [expr 90 + 270]]                   ;# ForkBlade End
            #
            # set pos_Crown $p_00
        
        $myCanvas  create   circle      {0 0}           -radius 5  -tags {__CenterLine__}  -fill white -outline darkred  -width 2 
            #
        $myCanvas  create   circle      $pos_Wheel      -radius 20 -tags {__CenterLine__}              -outline darkred -width 2 
        $myCanvas  create   circle      $p_00           -radius 4  -tags {__CenterLine__}  -fill white -outline blue  -width 1  ;# Crown
        $myCanvas  create   circle      $pos_Dropout    -radius 4  -tags {__CenterLine__}  -fill white -outline blue  -width 1  ;# Dropout
        switch -exact $forkType {
            "customBent"        - 
            "customStraight"    - 
            "customMax"         {
                    $myCanvas  create   circle  $p_20   -radius 4  -tags {__CenterLine__}  -fill white -outline red   -width 1  ;# Blade End  
                    $myCanvas  create   circle  $p_98   -radius 4  -tags {__CenterLine__}  -fill white -outline red   -width 1  ;# Blade
                }   
        }
        
        
            #
        $myCanvas  readSVGNode $svgNode_Steerer  $pos_Crown
        $myCanvas  readSVGNode $svgNode_Blade    $pos_Blade     $angle_Dropout
        $myCanvas  readSVGNode $svgNode_Crown    $pos_Crown       
        $myCanvas  readSVGNode $svgNode_Dropout  $pos_Dropout   $angle_Dropout
            #
        set lineCoords  [vectormath::addVectorCoordList $pos_Blade $centerLineBlade]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $lineCoords    -tags dimension  -fill darkorange ]
            #
        $myCanvas  create   circle      $pos_Crown      -radius 2  -tags {__CenterLine__}              -outline blue  -width 1 
        $myCanvas  create   circle      $pos_BladeEnd   -radius 2  -tags {__CenterLine__}              -outline red   -width 1        
        $myCanvas  create   circle      $pos_Blade      -radius 2  -tags {__CenterLine__}              -outline blue  -width 1 
        $myCanvas  create   circle      $pos_Dropout    -radius 3  -tags {__CenterLine__}              -outline red   -width 1 
        $myCanvas  create   circle      $pos_SteererEnd -radius 2  -tags {__CenterLine__}              -outline red   -width 1 
            #
            
            #
            # set lineDef_01      [$forkStrategy getValue Vector      BladeDefinition]
            # set lineDef_02      [$forkStrategy getValue Vector      BrakeDefinition]
            #
        set lineDef_01      [$forkStrategy getValue Vector      BladeDefinition]
        set bladeDefinition [vectormath::addVectorCoordList     $pos_Crown $lineDef_01]
            #
        set lineDef_02      $Vector(BrakeDefinition)
        set brakeDefinition [vectormath::addVectorCoordList     $pos_Crown $lineDef_02]
            #
        set rimRadius       [expr 0.5 * $rimDiameter]
        
            # puts "\$centerLine  $centerLine"    
            # puts "\$bladeDefinition  $bladeDefinition"    
        puts "  -> \$brakeDefinition    $brakeDefinition"    
            #
        $myCanvas  addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $bladeDefinition    -tags dimension  -fill darkred  -width 3 ]    
        $myCanvas  create   circle  [lrange $bladeDefinition 0 1]    -radius  3 -tags {__CenterLine__}  -outline darkblue -width 2 
            #
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $brakeDefinition    -tags dimension  -fill orange  -width 3 ]
        $myCanvas  create   circle  [lrange $brakeDefinition 0 1]    -radius  3 -tags {__CenterLine__}  -outline orange -width 2
            #
            # set pos_Wheel $pos_Dropout
        $myCanvas  create   arc     $pos_Wheel  -radius $rimRadius -start 75  -extent 60 -style arc -outline gray40  -tags __Decoration__]
        $myCanvas  create   circle  $pos_Wheel  -radius 2 -tags {__CenterLine__}              -outline darkred -width 2 
        $myCanvas  create   circle  $pos_Brake  -radius 5 -tags {__CenterLine__}              -outline orange  -width 3 
            #
            
        puts "      -> \$Position(p_11)     $Position(p_11)"
        puts "      -> \$Position(p_12)     $Position(p_12)"
        puts "      -> \$Position(p_14)     $Position(p_14)"
            #
        set p_01     [vectormath::addVector          $pos_Crown $Position(p_01)]
        set p_02     [vectormath::addVector          $pos_Crown $Position(p_02)]
        set p_11     [vectormath::addVector          $pos_Crown $Position(p_11)]
        set p_12     [vectormath::addVector          $pos_Crown $Position(p_12)]
        set p_14     [vectormath::addVector          $pos_Crown $Position(p_14)]
            #
        set polygon  [appUtil::flatten_nestedList $p_02 $p_01 $p_11 $p_12 $p_14]
            #
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $polygon -tags dimension  -width 1 -fill darkorange]
            
        $myCanvas  create   circle  $p_01  -radius 10 -tags {__CenterLine__}  -outline darkred   -width 2 
        $myCanvas  create   circle  $p_02  -radius 10 -tags {__CenterLine__}  -outline darkred   -width 2 
        $myCanvas  create   circle  $p_11  -radius  3 -tags {__CenterLine__}  -outline darkblue  -width 2 
        $myCanvas  create   circle  $p_12  -radius  3 -tags {__CenterLine__}  -outline darkblue  -width 2 
        $myCanvas  create   circle  $p_14  -radius  3 -tags {__CenterLine__}  -outline darkblue  -width 2 
           
            
    }
    
        #
        
        
        #
  ### -- G U I
        # -- GUI --
        #
    set returnValues [view::create $WINDOW_Title]
    # set control::myCanvas [lindex $returnValues 1]
        #
    control::refit_board
        #
    $::view::stageNamespace reportXMLRoot
            
            
   
 
 

 