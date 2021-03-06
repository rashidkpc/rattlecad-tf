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

  
  set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]
  
  puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
  set APPL_Package_Dir [file normalize [file dirname [file dirname [file dirname $APPL_ROOT_Dir]]]]
  puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
   
  lappend auto_path "$APPL_Package_Dir/canvasCAD"
  lappend auto_path "$APPL_Package_Dir/vectormath"
  lappend auto_path "$APPL_Package_Dir/tubeMiter"
  lappend auto_path "$APPL_Package_Dir/appUtil"
  lappend auto_path "$APPL_Package_Dir/myPersist"
  lappend auto_path "$APPL_Package_Dir/bike_Facade"
  lappend auto_path "$APPL_Package_Dir/bikeComponent"
  lappend auto_path "$APPL_Package_Dir/bikeGeometry"
  
  lappend auto_path "$APPL_Package_Dir/lib-canvasCAD"
  lappend auto_path "$APPL_Package_Dir/lib-vectormath"
  lappend auto_path "$APPL_Package_Dir/lib-tubeMiter"
  lappend auto_path "$APPL_Package_Dir/lib-appUtil"
  lappend auto_path "$APPL_Package_Dir/lib-myPersist"
  lappend auto_path "$APPL_Package_Dir/lib-bike_Facade"
  lappend auto_path "$APPL_Package_Dir/lib-bikeComponent"
  lappend auto_path "$APPL_Package_Dir/lib-bikeGeometry"
  
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
        variable dim_size              5
        variable dim_dist             30
        variable dim_offset            0
        variable dim_type_select aligned
        variable dim_font_select vector
        variable std_fnt_scl           1
        variable font_colour       black
        variable demo_type     dimension
        variable drw_scale             0.8
        variable cv_scale              1
        variable debugMode           off
    
        variable headTube_Angle       72
        
        variable forkHeight          365
        variable forkRake             45
        variable steererLength       120
        variable bladeHeight         325
        variable bladeRake            45
        variable crownOffset          35
        variable crownPerp             3.5
        
        variable bladeWidth           28.0
        variable bladeDoWidth         12.0
        variable taperLength         250.0
        variable endLength            10
        variable bendRadius          550
        
        variable dropOutOffset        20
        variable dropOutPerp           5
        variable max_Offset            6
        variable bladeType           max
        variable forkType       supplier
        variable brakeOffset          28
        variable rimDiameter         622
        
        variable position_x          180
        variable position_y          350
        variable position_angle       18
                
        set myComponent             [bikeComponent::Fork    new]
 
    }    

        
    proc control::moveto_StageCenter {item} {
            set myCanvas $::view::stageNamespace
        
            set stage       [ $myCanvas getNodeAttr Canvas path ]
            set stageCenter [ canvasCAD::get_StageCenter $stage ]
            set bottomLeft  [ canvasCAD::get_BottomLeft  $stage ]
            lassign $stageCenter  cx cy
            lassign $bottomLeft   lx ly
                # foreach {cx cy} $stageCenter break
                # foreach {lx ly} $bottomLeft  break
            $stage move $item [expr {$cx - $lx}] [expr {$cy -$ly}]
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
            
            puts "\n\n============================="
            puts "   -> cv_scale:           $cv_scale"
            puts "   -> drw_scale:          $drw_scale"
            puts "\n============================="
            puts "\n\n"
            
            $myCanvas scaleToCenter $cv_scale
    }

    proc control::setForkScalar {entryVar args} {
        variable myComponent
        variable forkType
        
        puts "  -> $entryVar"
        set entryValue  [set $entryVar]
        puts "  -> $entryValue"
        set entryKey    [lindex [split $entryVar :] 2]
        puts "  -> $entryKey"
            #
        switch -exact $entryKey {
            forkHeight      {   $myComponent setValue Scalar Height                    $entryValue }          
            forkRake        {   $myComponent setValue Scalar Rake                      $entryValue }       
            steererLength   {   $myComponent setValue Scalar SteererLength             $entryValue }       
            crownOffset     {   $myComponent setValue Scalar CrownBladeOffset          $entryValue }       
            crownPerp       {   $myComponent setValue Scalar CrownBladeOffsetPerp      $entryValue }
            endLength       {   $myComponent setValue Scalar BladeStartLength          $entryValue }         
            bladeDoWidth    {   $myComponent setValue Scalar BladeDropoutWidth         $entryValue }
            taperLength     {   $myComponent setValue Scalar BladeTaperLength          $entryValue }         
            bendRadius      {   $myComponent setValue Scalar BladeBendRadius           $entryValue }         
            bladeWidth      {   $myComponent setValue Scalar BladeWidth                $entryValue }
            dropOutOffset   {   $myComponent setValue Scalar DropoutBladeOffset        $entryValue }         
            dropOutPerp     {   $myComponent setValue Scalar DropoutBladeOffsetPerp    $entryValue }         
            brakeOffset     {   $myComponent setValue Scalar BladeBrakeOffset          $entryValue }         
            rimDiameter     {   $myComponent setValue Scalar RimDiameter               $entryValue }         
            default         {}
        }
            #
        $myComponent update
        $myComponent update_BrakePosition
            #
        update_board
    }
        #
    proc control::setForkType {} {
        variable myComponent
        variable forkType
        
        switch -exact $forkType {
            "supplier"          {$myComponent setValue Config Type Supplier}
            "suspension_20"     {$myComponent setValue Config Type Suspension_20}
            "suspension_24"     {$myComponent setValue Config Type Suspension_24}
            "suspension_26"     {$myComponent setValue Config Type Suspension_26}
            "suspension_27"     {$myComponent setValue Config Type Suspension_27}
            "suspension_29"     {$myComponent setValue Config Type Suspension_29}
            "composite"         {$myComponent setValue Config Type Composite}
            "composite_45"      {$myComponent setValue Config Type Composite_45}
            "composite_56"      {$myComponent setValue Config Type Composite_56}
            "customBent"        {$myComponent setValue Config Type SteelCustomBent}  
            "customStraight"    {$myComponent setValue Config Type SteelCustomStraight}  
            "customMax"         {$myComponent setValue Config Type SteelLuggedMAX}   
        }
            #
        $myComponent update
            #
        update_board
    }
        #
    proc control::setBladeType {} {
        variable myComponent
        variable bladeType
            #
        $myComponent setValue Config BladeStyle $bladeType
            #
        $myComponent update
            #
        update_board
    }
        #
    proc control::update_board {{value {0}}} {
            
        # variable  myCanvas
        set myCanvas $::view::stageNamespace
        
        variable myComponent
        
        variable unbentShape
        variable profileDef
        
        variable debugMode
        variable headTube_Angle
        
        variable forkType
        
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
                
        variable dim_size
        variable dim_dist
        variable dim_offset
        variable dim_font_select
        variable dim_type_select
        variable std_fnt_scl
        variable font_colour
        variable demo_type
        variable drw_scale 
        
        variable  bladeBent      
        variable  bladeStraight  
        variable  bladeMAX       
        
        
        variable position_x    
        variable position_y    
        variable position_angle

        set crownPos [list $position_x $position_y]
            #
        $myComponent setPlacement $crownPos $position_angle
        $myComponent update_BrakePosition
            #
        set bladeHeight [expr {$forkHeight - $crownOffset}]
        set bladeRake   [expr {$forkRake - $crownPerp}]
                     
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


        $myCanvas setNodeAttr Stage    scale        $drw_scale
        $myCanvas setNodeAttr Style    fontstyle    $dim_font_select
        $myCanvas setNodeAttr Style    fontsize     $dim_size
        
        
        if {$demo_type != {dimension} } {
            view::demo_canvasCAD 
            return
        }
                
            #
        $myComponent       update    
            #
            #
        set svgNode_Crown   [$myComponent getValue ComponentNode  XZ_Crown]
        set svgNode_Blade   [$myComponent getValue ComponentNode  XZ_Blade]
        set svgNode_Dropout [$myComponent getValue ComponentNode  XZ_Dropout]
        set svgNode_Steerer [$myComponent getValue ComponentNode  XZ_Steerer]
        
        puts "\$svgNode_Crown   $svgNode_Crown"    
        puts "\$svgNode_Blade   $svgNode_Blade"    
        puts "\$svgNode_Dropout $svgNode_Dropout"    
        puts "\$svgNode_Steerer $svgNode_Steerer"    
        puts "[$svgNode_Steerer asXML]"    
            #
        set angle_Crown     [$myComponent getValue Direction    Origin]
        set angle_Blade     [$myComponent getValue Direction    Blade]
        set angle_Dropout   [$myComponent getValue Direction    Dropout]
            #
        set pos_Crown       [$myComponent getValue Position     Origin]
        set pos_Blade       [$myComponent getValue Position     Blade]
        set pos_BladeEnd    [$myComponent getValue Position     BladeEnd]
        set pos_Dropout     [$myComponent getValue Position     Dropout]
        set pos_Wheel       [$myComponent getValue Position     Wheel]
        set pos_Brake       [$myComponent getValue Position     Brake]
        set pos_Steerer     [$myComponent getValue Position     Steerer_End]
        set polygon         [$myComponent getValue Polygon      Steerer]
        set polyline        [$myComponent getValue Polyline     CenterLine_Steerer]        
            #
        set lineDef_00      [$myComponent getValue Polyline     CenterLine]
        set centerLine      [vectormath::addVectorCoordList     $pos_Blade $lineDef_00]
            # puts "   -> \$lineDef_00 $lineDef_00"
            # puts "   -> \$centerLine $centerLine"
            #
        set lineDef_01      [$myComponent getValue Vector       BladeDefinition]
        set bladeDefinition $lineDef_01
            # set bladeDefinition [vectormath::addVectorCoordList     $pos_Crown $lineDef_01]
            #
        set lineDef_02      [$myComponent getValue Vector       BrakeDefinition]
        set brakeDefinition $lineDef_02
            # set brakeDefinition [vectormath::addVectorCoordList     $pos_Crown $lineDef_02]
            #
        set rimRadius       [expr {0.5 * [$myComponent getValue Scalar RimDiameter]}]
            #
            # puts "\$centerLine  $centerLine"    
            # puts "\$bladeDefinition  $bladeDefinition"    
            # puts "\$brakeDefinition  $brakeDefinition"    
            #
        $myCanvas  create   arc $pos_Wheel  -radius $rimRadius -start 75  -extent 60 -style arc -outline gray40  -tags __Decoration__]
            #
        $myCanvas readSVGNode $svgNode_Steerer  $pos_Crown      $angle_Crown
        $myCanvas readSVGNode $svgNode_Blade    $pos_Blade      $angle_Blade
        $myCanvas readSVGNode $svgNode_Crown    $pos_Crown      $angle_Crown 
        $myCanvas readSVGNode $svgNode_Dropout  $pos_Dropout    $angle_Dropout
            #
        $myCanvas  create   circle  {0 0}           -radius 10 -tags {__CenterLine__}  -fill white -outline darkred     -width 2 
        $myCanvas  create   circle  $pos_Blade      -radius  1 -tags {__CenterLine__}              -outline darkorange  -width 1 
        $myCanvas  create   circle  $pos_BladeEnd   -radius  5 -tags {__CenterLine__}              -outline darkorange  -width 3 
        $myCanvas  create   circle  $pos_Crown      -radius  3 -tags {__CenterLine__}  -fill white -outline darkred     -width 2 
        $myCanvas  create   circle  $pos_Dropout    -radius  3 -tags {__CenterLine__}  -fill white -outline darkblue    -width 2 
        $myCanvas  create   circle  $pos_Steerer    -radius  3 -tags {__CenterLine__}  -fill white -outline darkblue    -width 2 
            #
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $centerLine         -tags dimension  -fill darkorange ]    
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $bladeDefinition    -tags dimension  -fill darkred  -width 3 ]    
        $myCanvas  create   circle  [lrange $bladeDefinition 0 1]    -radius  3 -tags {__CenterLine__}  -outline darkblue -width 2 
            #
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $brakeDefinition    -tags dimension  -fill orange  -width 3 ]
        $myCanvas  create   circle  [lrange $brakeDefinition 0 1]    -radius  3 -tags {__CenterLine__}  -outline orange -width 2
        $myCanvas  create   circle  $pos_Brake  -radius 5 -tags {__CenterLine__}  -fill white -outline orange  -width 2 
                
            #
    }

    
    
    
    proc control::dimensionMessage { x y id} {
            tk_messageBox -message "giveMessage: $x $y $id"
            
        }        



    
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
        lassign $retValue  stageCanvas stageNamespace
            # foreach {stageCanvas stageNamespace} $retValue break
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
            labelframe  $f_settings.position        -text position
            labelframe  $f_settings.font            -text font
            labelframe  $f_settings.demo            -text demo
            labelframe  $f_settings.scale           -text scale

            pack        $f_settings.position    \
                        $f_settings.orientation \
                        $f_settings.type        \
                        $f_settings.centerline  \
                        $f_settings.tubeprofile \
                        $f_settings.font        \
                        $f_settings.demo        \
                        $f_settings.scale   -fill x -side top 

            view::create_config_line $f_settings.position.x         "   position: x   "  control::position_x         200  350   ;#  24
            view::create_config_line $f_settings.position.y         "   position: y   "  control::position_y         250  550   ;#  24
            view::create_config_line $f_settings.position.angle     " position: angle "  control::position_angle     -10   25   ;#  24
            
            view::create_config_line $f_settings.orientation.y_0a   " steererLength:  "  control::steererLength      50  250   ;#   0
            view::create_config_line $f_settings.orientation.x_00   "    forkHeight:  "  control::forkHeight        250  550   ;#   0
            view::create_config_line $f_settings.orientation.y_00   "      forkRake:  "  control::forkRake          -60   60   ;#   0
            view::create_config_line $f_settings.orientation.x_01   "   crownOffset:  "  control::crownOffset        -5   50   ;#   0
            view::create_config_line $f_settings.orientation.y_01   "     crownPerp:  "  control::crownPerp         -10   30   ;#   0
            
            view::create_config_line $f_settings.orientation.l_00   " dropOutOffset:  "  control::dropOutOffset       0   30   ;#   0
            view::create_config_line $f_settings.orientation.o_00   "   dropOutPerp:  "  control::dropOutPerp       -20   30   ;#   0
            
            view::create_config_line $f_settings.orientation.x_02   "   brakeOffset:  "  control::brakeOffset       -30   90   ;#   0
            view::create_config_line $f_settings.orientation.y_02   "   rimDiameter:  "  control::rimDiameter       500  600   ;#   0
                
                # radiobutton        $f_settings.orientation.debug_on   -text "on         "  -variable  "control::debugMode"  -value     "on"             -command   "control::update_board"
                # radiobutton        $f_settings.orientation.debug_off  -text "off        "  -variable  "control::debugMode"  -value     "off"            -command   "control::update_board"
            
            radiobutton        $f_settings.type.supplier          -text "Supplier     "   -variable  "control::forkType"   -value   "supplier"       -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_20           -text "Suspension 20"   -variable  "control::forkType"   -value   "suspension_20"  -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_24           -text "Suspension 24"   -variable  "control::forkType"   -value   "suspension_24"  -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_26           -text "Suspension 26"   -variable  "control::forkType"   -value   "suspension_26"  -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_27           -text "Suspension 27"   -variable  "control::forkType"   -value   "suspension_27"  -command   "control::setForkType"
            radiobutton        $f_settings.type.susp_29           -text "Suspension 29"   -variable  "control::forkType"   -value   "suspension_29"  -command   "control::setForkType"
            radiobutton        $f_settings.type.composite         -text "Composite    "   -variable  "control::forkType"   -value   "composite"      -command   "control::setForkType"
            radiobutton        $f_settings.type.composite_45      -text "Composite 45 "   -variable  "control::forkType"   -value   "composite_45"   -command   "control::setForkType"
            radiobutton        $f_settings.type.composite_56      -text "Composite 56 "   -variable  "control::forkType"   -value   "composite_56"   -command   "control::setForkType"
            radiobutton        $f_settings.type.customBnt         -text "CustomBent   "   -variable  "control::forkType"   -value   "customBent"     -command   "control::setForkType"
            radiobutton        $f_settings.type.customStr         -text "CustomStraight"  -variable  "control::forkType"   -value   "customStraight" -command   "control::setForkType"
            radiobutton        $f_settings.type.customMax         -text "CustomMAX    "   -variable  "control::forkType"   -value   "customMax"      -command   "control::setForkType"

          
            view::create_config_line $f_settings.tubeprofile.w_01   "    bladeWidth:  "  control::bladeWidth         15   60   ;#   0
            view::create_config_line $f_settings.tubeprofile.w_02   "  bladeDoWidth:  "  control::bladeDoWidth       10   40   ;#   0
            view::create_config_line $f_settings.tubeprofile.l_01   "   taperLength:  "  control::taperLength        20  300   ;#   0
            view::create_config_line $f_settings.tubeprofile.l_02   "     endLength:  "  control::endLength           0  300   ;#   0
            view::create_config_line $f_settings.tubeprofile.r_00   "    bendRadius:  "  control::bendRadius          0  700   ;#   0
            
            view::create_config_line $f_settings.scale.drw_scale      " Drawing scale "  control::drw_scale       0.2  2  
            view::create_config_line $f_settings.scale.cv_scale       " Canvas scale  "  control::cv_scale        0.2  5.0 
                                     $f_settings.scale.drw_scale.scl        configure   -resolution 0.1
                                     $f_settings.scale.cv_scale.scl         configure   -resolution 0.1  -command "control::scale_board"
                                     
            button                   $f_settings.scale.recenter -text "recenter"   -command {control::recenter_board}
            button                   $f_settings.scale.refit    -text "refit"      -command {control::refit_board}
            
            # pack      \
                    $f_settings.orientation.left \
                    $f_settings.orientation.center \
                    $f_settings.orientation.right \
                    -side left
                    
            # pack      \
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
                    $f_settings.type.susp_27  \
                    $f_settings.type.susp_29  \
                    $f_settings.type.composite \
                    $f_settings.type.composite_45 \
                    $f_settings.type.composite_56 \
                    $f_settings.type.customBnt \
                    $f_settings.type.customStr \
                    $f_settings.type.customMax \
                    -side top 
                                                   
                             
            pack  $f_settings  -side top -expand yes -fill both
             
                #
                ### -- G U I - canvas report
                #
            set f_report    [labelframe .f0.f_config.f_report  -text "report" ]

            set reportText  [text       $f_report.text -width 50 -height 7]
            scrollbar       $f_report.sby -orient vert -command "$reportText yview"
                                           $f_report.text conf -yscrollcommand "$f_report.sby set"
            pack $f_report  -side top     -expand yes -fill both
            pack $f_report.sby $reportText -expand yes -fill both -side right    
            
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
    control::refit_board
        #
    #$::view::stageNamespace reportXMLRoot
            
            
   
 
 

 