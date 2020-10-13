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
 


  set WINDOW_Title      "test bikeComponent - ForkBlade, based on canvasCAD@rattleCAD"
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
        variable drw_scale             0.8
        variable cv_scale             1
        variable debugMode           off
        
        variable summary_Y        345
        variable summary_X         45
        variable bladeHeight      325
        variable bladeRake         45
        variable dropOutOffset     20
        variable dropOutPerp        0
        variable startLength       10
        variable endWidth          28
        variable startWidth        12
        variable bendRadius       550
        variable max_Offset         6
        variable bladeType        max
        
        
        variable  profile_x00   0
        variable  profile_y00  12.5
        variable  profile_x01 250
        variable  profile_y01  28
        variable  profile_x02 150
        variable  profile_y02  28
        variable  profile_x03  75
        variable  profile_y03  28
        
        
        variable arcPrecission   5
        
        
        variable bladeBent      [::bikeComponent::ForkBlade new bent]
        variable bladeStraight  [::bikeComponent::ForkBlade new straight]
        variable bladeMAX       [::bikeComponent::ForkBlade new max]
        
        variable bladeStrategy  $bladeMAX
        
        $bladeBent      update
        $bladeStraight  update
        $bladeMAX       update
        
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

    proc control::reset_BladeScalar {} {
            #
        variable bladeStrategy
            #
        variable summary_Y      345
        variable summary_X       45
        variable dropOutOffset   20
        variable dropOutPerp      0
        variable startLength      5
        variable startWidth      12
        variable endWidth        28.6
        variable bendRadius     550
        variable taperLength    250
            #
        $bladeStrategy setValue Scalar Height               $summary_Y
        $bladeStrategy setValue Scalar Rake                 $summary_X
        $bladeStrategy setValue Scalar StartLength          $startLength
        $bladeStrategy setValue Scalar EndWidth             $endWidth
        $bladeStrategy setValue Scalar StartWidth           $startWidth
        $bladeStrategy setValue Scalar TaperLength          $taperLength
        $bladeStrategy setValue Scalar BendRadius           $bendRadius
        $bladeStrategy setValue Scalar DropoutOffset        $dropOutOffset
        $bladeStrategy setValue Scalar DropoutOffsetPerp    $dropOutPerp 
            #
        $bladeStrategy update
            #
        update_board
            #
    }


    proc control::setBladeScalar {entryVar args} {
        variable bladeStrategy

        puts "  -> $entryVar"
        set entryValue  [set $entryVar]
        puts "  -> $entryValue"
        set entryKey    [lindex [split $entryVar :] 2]
        puts "  -> $entryKey"
            #
            
            # variable summary_Y      345
            # variable summary_X       45
            # variable dropOutOffset   20
            # variable dropOutPerp      0
            # variable startLength      5
            # variable startWidth      12
            # variable endWidth        28.6
            # variable bendRadius     550
            # variable taperLength    250           

            
        switch -exact $entryKey {
            summary_Y       {   $bladeStrategy setValue Scalar Height               $entryValue }          
            summary_X       {   $bladeStrategy setValue Scalar Rake                 $entryValue }       
            startLength     {   $bladeStrategy setValue Scalar StartLength          $entryValue }         
            endWidth        {   $bladeStrategy setValue Scalar EndWidth             $entryValue }
            taperLength     {   $bladeStrategy setValue Scalar TaperLength          $entryValue }         
            bendRadius      {   $bladeStrategy setValue Scalar BendRadius           $entryValue }         
            startWidth      {   $bladeStrategy setValue Scalar StartWidth           $entryValue }
            dropOutOffset   {   $bladeStrategy setValue Scalar DropoutOffset        $entryValue }         
            dropOutPerp     {   $bladeStrategy setValue Scalar DropoutOffsetPerp    $entryValue }         
            default         {}
        }
            #
        $bladeStrategy update
            #
        update_board
            #
    }
        #
    proc control::setBladeType {} {
        variable bladeStrategy
        variable bladeType
        
        variable bladeBent    
        variable bladeStraight
        variable bladeMAX     
        
        puts "\n ... control::setBladeType $bladeType\n"
        puts "    -> $bladeStrategy"
        
        switch -exact $bladeType {
            "bent"      {set bladeStrategy $bladeBent}
            "straight"  {set bladeStrategy $bladeStraight}
            "max"       {set bladeStrategy $bladeMAX}
            default     {
                    puts "\n ... control::setBladeType $bladeType\n"
                }
        }
            #
        puts "        -> $bladeStrategy"
            #
        $bladeStrategy update
            #
        update_board
            #
    }
        #
    proc control::update_board {{value {0}}} {
            
        # variable  myCanvas
        set myCanvas $::view::stageNamespace
        
        variable bladeStrategy
        
        variable unbentShape
        variable profileDef
        
        variable debugMode
        
        variable summary_Y
        variable summary_X   
        variable dropOutOffset
        variable dropOutPerp
        variable startLength
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
        
        variable  bladeBent      
        variable  bladeStraight  
        variable  bladeMAX       
        
        set headTube_Angle  0
        
        set bladeHeight $summary_Y
        set bladeRake   $summary_X
        
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
                
        
            # draw orientation of bent tube
        set orient_01 [list 0 0]
        set orient_05 [list $summary_Y $summary_X]
        
            # ------------------------------------
                        # update $myCanvas ->

        puts "   \$bladeType $bladeType"
        
        
        set outLine         [$bladeStrategy     getValue Polygon    Blade]     
        set centerLine      [$bladeStrategy     getValue Polyline   CenterLine]  
        set dropOutAngle    [$bladeStrategy     getValue Direction  Origin]
        set bladePosition   [$bladeStrategy     getValue Position   Origin]
        set bladeEnd        [$bladeStrategy     getValue Position   End]
        set bladeLine       [$bladeStrategy     getValue Vector     BladeDefinition]
            #
        set svgNode_Blade   [$bladeStrategy     getValue ComponentNode XZ]
            #
        
        set dropOutPos  {250 50}
        
        puts "   \$outLine   $outLine"
        set outLine_1       [vectormath::rotateCoordList    {0 0} $outLine $dropOutAngle]
        set outLine_2       [vectormath::addVectorCoordList $dropOutPos [vectormath::addVectorCoordList $bladePosition $outLine_1]]
        set centerLine_2    [vectormath::addVectorCoordList $dropOutPos [vectormath::addVectorCoordList $bladePosition $centerLine]]
        set bladeLine_2     [vectormath::addVectorCoordList $dropOutPos [vectormath::addVectorCoordList $bladePosition $bladeLine]]
        
        
        puts "   \$dropOutAngle   $dropOutAngle"
        set dropOutAngle    [expr $dropOutAngle - $headTube_Angle]
        puts "     \$dropOutAngle $dropOutAngle"
            # puts "   \$brakeDefLine $brakeDefLine"        
        
        set p_99  [vectormath::rotateLine $dropOutPos $dropOutOffset [expr 90 + $dropOutAngle]]
        set p_98  [vectormath::rotateLine $p_99       $dropOutPerp   [expr 90 + (90 + $dropOutAngle)]]  ;# Blade
        set p_60  [vectormath::rotateLine $dropOutPos $summary_X     [expr 90 +  90]]
        set p_00  [vectormath::rotateLine $p_60       $summary_Y     [expr 90 +   0]]
        
        $myCanvas  readSVGNode $svgNode_Blade   $p_98 $dropOutAngle

        $myCanvas  create   circle      {0 0}         -radius 5  -tags {__CenterLine__}  -fill white -outline darkred  -width 2 
        $myCanvas  create   circle      $dropOutPos   -radius 2  -tags {__CenterLine__}  -fill white -outline blue  -width 1 
        $myCanvas  create   circle      $p_00         -radius 2  -tags {__CenterLine__}  -fill white -outline blue  -width 1 
        $myCanvas  create   circle      $p_98         -radius 1  -tags {__CenterLine__}  -fill white -outline red  -width 1 
        $myCanvas  create   circle      $bladeEnd     -radius 20 -tags {__CenterLine__}              -outline darkorange  -width 1 
            #
        $myCanvas addtag {__OutLine__}     withtag  {*}[$myCanvas  create   polygon $outLine_2    -tags dimension  -fill lightgray -outline darkblue]
            #
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $centerLine_2 -tags dimension  -width 1 -fill darkorange]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $bladeLine_2  -tags dimension  -width 2 -fill darkred]
            #
        $myCanvas  create   circle  [lrange $bladeLine_2 0 1]   -radius 5   -tags {__CenterLine__}   -outline darkred   -width 2
            #
        
        set lineDef [canvasCAD::flatten_nestedList $dropOutPos $p_99 $p_98 $dropOutPos]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $lineDef  -tags dimension  -fill blue ]
        
        set lineDef [canvasCAD::flatten_nestedList $dropOutPos $p_60 $p_00]
        $myCanvas addtag {__CenterLine__}  withtag  {*}[$myCanvas  create   line    $lineDef  -tags dimension  -fill darkred ]

        
        
        set tagDimension [ $myCanvas dimension  length   [list $dropOutPos {0 0}] {vertical}    $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list {0 0} $dropOutPos] {horizontal}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
       
        set tagDimension [ $myCanvas dimension  length   [list $p_00 $p_60]       {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $p_60 $dropOutPos] {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
       
        # set tagDimension [ $myCanvas dimension  length   [list $p_10 $p_00]       {aligned}  20  $dim_offset  $font_colour ] 
        #       lappend __Dimension__ $tagDimension
        # set tagDimension [ $myCanvas dimension  length   [list $p_20 $p_10]       {aligned}  20  $dim_offset  $font_colour ] 
        #       lappend __Dimension__ $tagDimension

        set tagDimension [ $myCanvas dimension  length   [list $dropOutPos $p_99] {aligned}  20  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $p_99 $p_98]       {aligned}  20  20  $font_colour ] 
              lappend __Dimension__ $tagDimension
              
        


        
        # $myCanvas fit2Stage {__CenterLine__ __Dimension__ __profileLine__ __OutLine__}
        
        return            
                
            set tagDimension [ $myCanvas dimension  length   [list $p_03 $p_02]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
            set tagDimension [ $myCanvas dimension  length   [list $p_05 $p_03]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension
            set tagDimension [ $myCanvas dimension  length   [list $p_03 $p_04]  {aligned}  $dim_dist  $dim_offset  $font_colour ] 
              lappend __Dimension__ $tagDimension


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

            label   $w.lb    -text $lb_text            -width 20  -bd 1  -anchor w 
            entry   $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
         
            scale   $w.scl    -width        12 \
                            -length       120 \
                            -bd           1  \
                            -sliderlength 15 \
                            -showvalue    0  \
                            -orient       horizontal \
                            -command      [list control::setBladeScalar $entry_var] \
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
            labelframe  $f_settings.tubeprofile     -text tubeprofile
            labelframe  $f_settings.precission      -text precission
            labelframe  $f_settings.font            -text font
            labelframe  $f_settings.demo            -text demo
            labelframe  $f_settings.scale           -text scale

            pack  $f_settings.orientation       \
                        $f_settings.centerline  \
                        $f_settings.tubeprofile \
                        $f_settings.precission  \
                        $f_settings.font        \
                        $f_settings.demo        \
                        $f_settings.scale   -fill x -side top 

            view::create_config_line $f_settings.orientation.x_00   "        Height:  "  control::summary_Y         250  550   ;#   0
            view::create_config_line $f_settings.orientation.y_00   "          Rake:  "  control::summary_X         -60   60   ;#   0
            view::create_config_line $f_settings.orientation.l_00   " dropOutOffset:  "  control::dropOutOffset       0   30   ;#   0
            view::create_config_line $f_settings.orientation.o_00   "   dropOutPerp:  "  control::dropOutPerp       -20   30   ;#   0
            view::create_config_line $f_settings.orientation.l_01   "   startLength:  "  control::startLength         0  300   ;#   0
            view::create_config_line $f_settings.orientation.l_02   "    startWidth:  "  control::startWidth          0   40   ;#   0
            view::create_config_line $f_settings.orientation.l_03   "      endWidth:  "  control::endWidth            0   40   ;#   0
            view::create_config_line $f_settings.orientation.r_00   "    bendRadius:  "  control::bendRadius          0  700   ;#   0

            button                   $f_settings.orientation.reset    -text "reset"      -width 20  -command {control::reset_BladeScalar}

            
                # view::create_config_line $f_settings.orientation.d_00   "headTube_Angle:  "  control::headTube_Angle    60   100   ;#   0
                # view::create_config_line $f_settings.orientation.x_01   "   crownOffset:  "  control::crownOffset        -5   50   ;#   0
                # view::create_config_line $f_settings.orientation.y_01   "     crownPerp:  "  control::crownPerp         -10   30   ;#   0
                # view::create_config_line $f_settings.orientation.x_00   "bladeHeight:  "  control::bladeHeight    250  550   ;#   0
                # view::create_config_line $f_settings.orientation.y_00   "bladeRake:  "  control::bladeRake    -60   60   ;#   0
                # view::create_config_line $f_settings.orientation.m_00   "    max_Offset:  "  control::max_Offset          0  100   ;#   0
                        
            # radiobutton        $f_settings.type.supplier          -text "Supplier     "   -variable  "control::forkType"   -value   "supplier"       -command   "control::setForkType"
            radiobutton        $f_settings.orientation.left       -text "straight   "  -variable  "control::bladeType"  -value     "straight"   -command   "control::setBladeType"
            radiobutton        $f_settings.orientation.center     -text "bent       "  -variable  "control::bladeType"  -value     "bent"       -command   "control::setBladeType"
            radiobutton        $f_settings.orientation.right      -text "MAX        "  -variable  "control::bladeType"  -value     "max"        -command   "control::setBladeType"
                    
            # radiobutton        $f_settings.orientation.debug_on   -text "on         "  -variable  "control::debugMode"  -value     "on"  -command   "control::update_board"
            # radiobutton        $f_settings.orientation.debug_off  -text "off        "  -variable  "control::debugMode"  -value    "off"  -command   "control::update_board"

          
            view::create_config_line $f_settings.tubeprofile.y_00     "        y00:  "  control::profile_y00       10  40   ;#  12.50
            view::create_config_line $f_settings.tubeprofile.x_01     "        x01:  "  control::profile_x01        5 320   ;# 150 
            view::create_config_line $f_settings.tubeprofile.y_01     "        y01:  "  control::profile_y01       10  40   ;#  18
            view::create_config_line $f_settings.tubeprofile.x_02     "        x02:  "  control::profile_x02      100 350   ;# 150
            view::create_config_line $f_settings.tubeprofile.y_02     "        y02:  "  control::profile_y02       15  40   ;#  18
            view::create_config_line $f_settings.tubeprofile.x_03     "        x03:  "  control::profile_x03       50 100   ;#  75
            view::create_config_line $f_settings.tubeprofile.y_03     "        y03:  "  control::profile_y03       15  40   ;#  24

            view::create_config_line $f_settings.precission.prec      " precission:  "  control::arcPrecission      1  15   ;#  24

            view::create_config_line $f_settings.scale.drw_scale      " Drawing scale "  control::drw_scale       0.2  2  
            view::create_config_line $f_settings.scale.cv_scale       " Canvas scale  "  control::cv_scale        0.2  5.0  
                               $f_settings.scale.drw_scale.scl        configure   -resolution 0.1
                               $f_settings.scale.cv_scale.scl         configure   -resolution 0.1  -command "control::scale_board"
            button             $f_settings.scale.recenter      -text  "recenter"   -command {control::recenter_board}
            button             $f_settings.scale.refit         -text  "refit"      -command {control::refit_board}
            
            pack      \
                    $f_settings.orientation.reset \
                    $f_settings.orientation.left \
                    $f_settings.orientation.center \
                    $f_settings.orientation.right \
                    -side left
            #pack      \
                    $f_settings.orientation.debug_on \
                    $f_settings.orientation.debug_off \
                    -side left
            pack      \
                    $f_settings.scale.drw_scale \
                    $f_settings.scale.cv_scale \
                    $f_settings.scale.recenter \
                    $f_settings.scale.refit \
                 -side top  -fill x                                                          
                             
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


        #
        # -- GUI --
        #
    set returnValues [view::create $WINDOW_Title]
    # set control::myCanvas [lindex $returnValues 1]
        #
    control::refit_board
        #
    control::reset_BladeScalar
        #
    # $::view::stageNamespace reportXMLRoot
            
            
   
 
 

 