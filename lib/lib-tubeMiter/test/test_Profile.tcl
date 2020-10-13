##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


set WINDOW_Title      "tcl tubeMiter, based on canvasCAD@rattleCAD"


set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir __ext_Libraries]

# lappend auto_path "$APPL_Package_Dir/canvasCAD"
# lappend auto_path "$APPL_Package_Dir/bikeGeometry"
# lappend auto_path "$APPL_Package_Dir/vectormath"
# lappend auto_path "$APPL_Package_Dir/appUtil"

# lappend auto_path "$APPL_Package_Dir/lib-canvasCAD"
# lappend auto_path "$APPL_Package_Dir/lib-bikeGeometry"
# lappend auto_path "$APPL_Package_Dir/lib-vectormath"
# lappend auto_path "$APPL_Package_Dir/lib-appUtil"


package require   tcltest

package require   Tk
package require   tubeMiter
package require   cad4tcl
package require   bikeGeometry
package require   vectormath
package require   appUtil

set cad4tcl::canvasType 1

 
##+######################



##+######################

namespace eval model {
        #
    variable dict_TubeMiter
        #
    dict create dict_TubeMiter {}
    dict append dict_TubeMiter settings \
            [list precision               48 \
                  viewOffset               0 \
            ]
    dict append dict_TubeMiter geometry \
            [list angleTool               90 \
                  angleTube              180 \
                  lengthOffset_z          60 \
            ]
    dict append dict_TubeMiter toolTube \
            [list Diameter_Base           56 \
                  Diameter_Top            28 \
                  Length                 160 \
                  Length_BaseCylinder     10 \
                  Length_Cone             70 \
            ]
    dict append dict_TubeMiter tube \
            [list Diameter_Miter          30 \
                  Length                 100 \
            ]
    dict append dict_TubeMiter result \
            [list Base_Position           {} \
                  Miter_Angle             {} \
                  Profile_Tool            {} \
                  Profile_Tube            {} \
                  Shape_Tool              {} \
                  Shape_Tube              {} \
                  ShapeCone_Tool          {} \
                  Miter_ToolPlane         {} \
                  Miter_BaseDiameter      {} \
                  Miter_TopDiameter       {} \
                  miter_Tool              {} \
                  MiterView_Plane         {} \
                  MiterView_BaseDiameter  {} \
                  MiterView_TopDiameter   {} \
                  MiterView_Tool          {} \
                  MiterView_Cone          {} \
                  Shape_ToolPlane         {} \
                  Shape_Debug             {} \
            ]  
}
namespace eval view {
    variable cvObject
    variable stageCanvas
    variable reportText         {}
}
namespace eval control {
        #
    variable angleTube                 0
    variable precision                 3
        #
    variable angleTool                90 
    variable lengthOffset_z           50 
    variable lengthOffset_x            0 
    variable diameterToolBase         56 
    variable diameterToolTop          28 
    variable lengthTool              100 
    variable lengthToolBase           30 
    variable lengthToolCone           50 
    variable diameterTube             38
    variable diameterTube_x           38
    variable diameterTube_y           20
    variable lengthTube               50
    variable rotationTube              0
    variable angleToolPlane            0    ;# clockwise
        #
    variable switchProfile          round        
        #
    variable result/Base_Position     {}
    variable result/Miter_Angle       {}
    variable result/Profile_Tool      {}
    variable result/Profile_Tube      {}
    variable result/Shape_Tool        {}
    variable result/Shape_Tube        {}
        #
    if 1 {
        variable diameterTube             38
        variable diameterTube_x           38
        variable diameterTube_y           20
        variable lengthTube               50
        variable rotationTube             50
        variable precision                 6
    }
        #
    variable dim_size            5
    variable dim_font_select    vector
    variable drw_scale           1.0
        #
        #
    variable roundProfile       [tubeMiter::RoundProfile new]
    variable ovalProfile        [tubeMiter::OvalProfile  new]
    variable testProfile        [tubeMiter::RoundProfile new]
        #
}    

    #
    # -- MODEL --
    #
proc model::xxx {value} {
        #
    # puts "\n\n--< model::setValue >--"
    # puts "      \$dictPath: $_dictPath"
    # puts "      \$value:    $value"
        #
    variable dict_TubeMiter
        #
    set dictPath [string map {"/" " "} $_dictPath]
    dict set dict_TubeMiter {*}$dictPath $value
        #
    # appUtil::pdict $dict_TubeMiter 
        #
    # puts "--< model::setValue >--\n\n"
}

    #
    # -- CONTROL --
    #
proc control::changeView {} {
        #
    variable viewMiter
        #
    if {$viewMiter eq "left"} {
        set viewMiter "right"
    } else {
        set viewMiter "left"
    }
        #
    control::update   
        #
}
proc control::moveto_StageCenter {item} {
    set cvObject $::view::cvObject
    set stage       [$cvObject getCanvas]
    set stageCenter [$cvObject getCenter]
    set bottomLeft  [$cvObject getBottomLeft]
    foreach {cx cy} $stageCenter break
    foreach {lx ly} $bottomLeft  break
    $cvObject move $item [expr $cx - $lx] [expr $cy -$ly]
}
proc control::recenter_board {} {
    variable  cv_scale 
    variable  drw_scale 
    set cvObject $::view::cvObject
    puts "\n  -> recenter_board:   $cvObject "
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"
    moveto_StageCenter __cvElement__
    set cv_scale [$cvObject configure Canvas Scale]    
}
proc control::refit_board {} {
    variable  cv_scale 
    variable  drw_scale
    set cvObject $::view::cvObject
    puts "\n  -> recenter_board:   $::view::cvObject "
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"
    set cv_scale [$cvObject fit]
}
proc control::scale_board {{value {1}}} {
    variable  cv_scale 
    variable  drw_scale 
    set cvObject $::view::cvObject
    puts "\n  -> scale_board:   $cvObject"
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "\n============================="
    puts "\n\n"        
    $cvObject center $cv_scale
}
proc control::cleanReport {} {
    # puts " -> control::cleanReport: $::view::reportText"
    catch {$::view::reportText   delete  1.0 end}
}
proc control::writeReport {text} {
    # puts " -> control::writeReport: $::view::reportText"
    catch {$::view::reportText   insert  end "$text\n"}
}
proc control::draw_centerLineEdge {} {
    
    set cvObject $::view::cvObject
    $::view::stageCanvas addtag {__CenterLine__} withtag  [$cvObject  create   circle {0 0}     -radius 2  -outline red        -fill white]
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
    $::view::stageCanvas addtag {__CenterLine__} withtag  {*}[$cvObject  create   line $polyLineDef -tags dimension  -fill green ]
}
    #
proc control::update {{key _anyKey_} {value {}}} {
        #
    puts "\n\n--< control::update >--"
    puts "      \$key:     $key"
    puts "      \$value:   $value"
        #
    variable roundProfile
    variable ovalProfile
    variable testProfile
        #
    variable precision
        #
    variable rotationTube     
    variable diameterTube         
    variable diameterTube_x         
    variable diameterTube_y         
    variable lengthTube
        #
    variable switchProfile
        #
    puts ""    
    puts "    --------------------------------------------------"    
    puts ""    
    puts "          -> \$rotationTube       $rotationTube"    
    puts "          -> \$diameterTube       $diameterTube"    
    puts "          -> \$diameterTube_x     $diameterTube_x"    
    puts "          -> \$diameterTube_y     $diameterTube_y"    
    puts "          -> \$lengthTube         $lengthTube"        
    puts ""        
    puts "          -> \$switchProfile      $switchProfile"        
    puts ""        
    puts "    --------------------------------------------------"    
    puts ""    
        #
        #
    if [info exists $key] {
        puts "    -> set $key $value"
        set $key $value
    } else {
        puts "    -> can not set $key $value"
    }
        #
    $roundProfile   setScalar   Precision       $precision
    $ovalProfile    setScalar   Precision       $precision
    $testProfile    setScalar   Precision       $precision
        #
    set precision   [$roundProfile getScalar   Precision]
        #
        #
        # -- roundProfile
        #
    $roundProfile   setScalar   Rotation    $rotationTube
    $roundProfile   setScalar   Diameter    $diameterTube
    $roundProfile   setScalar   Length      $lengthTube
        #
    $roundProfile   update   
        #
        #
        # -- ovalProfile
        #
    $ovalProfile    setScalar   Rotation    $rotationTube
    $ovalProfile    setScalar   Diameter_X  $diameterTube_x
    $ovalProfile    setScalar   Diameter_Y  $diameterTube_y
    $ovalProfile    setScalar   Length      $lengthTube
        #
    $ovalProfile    update
        #
        #
        # -- testProfile
        #
    switch -exact $switchProfile {
        round {
            $testProfile    setProfileType  round
            $testProfile    setScalar       Rotation    $rotationTube
            $testProfile    setScalar       Diameter    $diameterTube
            $testProfile    update
        }
        oval {
            $testProfile    setProfileType  oval
            $testProfile    setScalar       Rotation    $rotationTube
            $testProfile    setScalar       Diameter_X  $diameterTube_x
            $testProfile    setScalar       Diameter_Y  $diameterTube_y
            $testProfile    setScalar       Length      $lengthTube
            $testProfile    update
        }
        config_03 {
            $testProfile    setProfileDef   [list -type oval  -diameter_x $diameterTube_x  -diameter_y $diameterTube_y  -rotation 0  -precision 1]
        }
        config_04 {
            $testProfile    setProfileDef   [list -type oval  -diameter_x 45  -diameter_y 35  -rotation $rotationTube  -precision 3]
        }
        config_05 {
            $testProfile    setProfileDef   [list -type round  -diameter 45   -rotation $rotationTube  -precision 5]
        }
        default {}
    }
        #
        #
        #
    control::updateStage
        #
    set dictProfile     [$testProfile   getDictionary]
        #
    appUtil::pdict2text $::view::reportText $dictProfile
        #
        #
        # -- do a unit test on profile Objects
        #
    control::testProfileObjects
        #
        #
    return
        #
}
proc control::updateStage {{value {0}}} {
        #
    variable drw_scale
    variable dim_font_select
    variable dim_size
        #
    variable typeTool
        #
        #
    set cvObject $::view::cvObject
        #
    $cvObject deleteContent
        #
    cleanReport
        #
        # $cvObject configure Stage    Scale        $drw_scale
    $cvObject configure Style    Fontstyle    $dim_font_select
    $cvObject configure Style    Fontsize     $dim_size
        #
    createRound      {-120 -20}    
    createOval       {  90 -20}    
    createTest       {  90  70}
        #
        #
    control::moveto_StageCenter __CenterLine__ 
    control::moveto_StageCenter __ToolShape__
    control::moveto_StageCenter __TubeShape__
    control::moveto_StageCenter __DebugShape__
        #
        #
    return    
        #
}
    #
    #
proc control::testProfileObjects {} {
        #
    variable angleTube     
    variable diameterTube         
    variable diameterTube_x         
    variable diameterTube_y         
    variable lengthTube                             
        #
    puts "     -> control::testProfileObjects -- start <-"
        #
    set testObjRound    [tubeMiter::RoundProfile new]    
    set testObjOval     [tubeMiter::OvalProfile new]
        
        #
        #
    puts "     -> control::testProfileObjects -- end <---"
    return    
        #
}
    #
proc control::createRound {position} {
        #
    variable angleTube     
    variable diameterTube         
    variable lengthTube                             
        #
        #
    variable miterObjectOrigin
    variable miterObjectEnd
        #
    variable roundProfile
        #
        #
    set cvObject $::view::cvObject
        #
        #
    set radiusTube      [expr 0.5 * $diameterTube]    
        #
    set pos_XY          [vectormath::addVector $position {0   30}]
    set pos_XZ          [vectormath::addVector $position {0  -50}]
    set pos_YZ          [vectormath::addVector $position {75 -50}]
        #
        #
    set myPositon       [vectormath::addVector              $pos_XZ {0 0}]
    $cvObject  create circle    $myPositon  [list -radius 1                 -outline blue     -width 0.035    -tags __CenterLine__]
        #
        #
        # -- XY -----
        #
    set myPositon       [vectormath::addVector              $pos_XY {0 0}]
    $cvObject  create circle    $myPositon  [list -radius $radiusTube   -outline blue     -width 0.035    -tags __CenterLine__]
        #
    set profile_XY      [$roundProfile getProfile XY]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XY $profile_XY]
    $cvObject  create line      $myPolyline [list                           -fill red         -width 0.01     -tags __ToolShape__]
        #
    set pos_Rotation    [lrange $profile_XY 0 1]          
    set myPositon       [vectormath::addVector              $pos_XY $pos_Rotation]
    $cvObject  create circle    $myPositon  [list -radius 2                 -outline red      -width 0.035    -tags __CenterLine__]
        #
        #
        # -- XZ -----
        #
        # -- Debug -----
        #
    set profile_Surface [$roundProfile getProfile Debug_0]
    set profile_surface    {}
    foreach {x z} $profile_Surface {
        lappend profile_surface 0 $x
    }
    set myPolyline      [join "$profile_Surface [lreverse $profile_surface]" " "]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $myPolyline]
    $cvObject  create polygon   $myPolyline [list             -outline gray   -fill gray90    -width 0.1      -tags __ToolShape__]
        #
    set profile_X      [$roundProfile getProfile Debug_X]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $profile_X]
    $cvObject  create line      $myPolyline [list             -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
    set profile_Y      [$roundProfile getProfile Debug_Y]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $profile_Y]
    $cvObject  create line      $myPolyline [list             -outline blue   -fill gray80    -width 0.1      -tags __ToolShape__]
        #
        # -- XZ -----
        #
    set profile_XZ      [$roundProfile getProfile XZ]
    set profile_xz      {}
    foreach {x z} $profile_XZ {
        lappend profile_xz 0 $x
    }
    set myPolyline      [join "$profile_XZ [lreverse $profile_xz]" " "]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $myPolyline]
    $cvObject  create polygon   $myPolyline [list             -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
        #
        # -- YZ -----
        #
    set profile_YZ      [$roundProfile getProfile YZ]
    set profile_yz      {}
    foreach {y z} $profile_YZ {
        lappend profile_yz 0 $y
    }
    set myPolyline      [join "$profile_YZ [lreverse $profile_yz]" " "]
    set myPolyline      [vectormath::addVectorCoordList     $pos_YZ $myPolyline]
    $cvObject  create polygon   $myPolyline [list             -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
    return    
        #
}
    #
proc control::createOval {position} {
        #
    variable angleTube     
    variable diameterTube_x         
    variable diameterTube_y         
    variable lengthTube                             
        #
        #
    variable miterObjectOrigin
    variable miterObjectEnd
        #
    variable ovalProfile
        #
        #
    set cvObject $::view::cvObject
        #
        #
    set radiusTube_x [expr 0.5 * $diameterTube_x]
    set radiusTube_y [expr 0.5 * $diameterTube_y]
        #
        #
    set pos_XY          [vectormath::addVector $position {0   30}]
    set pos_XZ          [vectormath::addVector $position {0  -50}]
    set pos_YZ          [vectormath::addVector $position {75 -50}]
        #
        #
    set myPositon       [vectormath::addVector  $pos_XZ {0 0}]
    $cvObject  create circle    $myPositon  [list -radius 1    -outline blue     -width 0.035    -tags __CenterLine__]
        #
        #
        # -- XY -----
        #
    set myPositon       [vectormath::addVector              $pos_XY {0 0}]
    $cvObject  create circle    $myPositon  [list -radius $radiusTube_x     -outline blue     -width 0.035    -tags __CenterLine__]
    $cvObject  create circle    $myPositon  [list -radius $radiusTube_y     -outline blue     -width 0.035    -tags __CenterLine__]
        #
    set myCoords        [list 0 0 $diameterTube_x $diameterTube_y]
    set myCoords        [vectormath::addVectorCoordList  [list $radiusTube_x $radiusTube_y] $myCoords -1]
    set myCoords        [vectormath::addVectorCoordList     $pos_XY $myCoords]
    $cvObject create  oval      $myCoords   [list -outline blue     -width 0.035    -tags __CenterLine__]
        #
    set profile_XY      [$ovalProfile getProfile XY]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XY $profile_XY]
    $cvObject  create line      $myPolyline [list                           -fill red         -width 0.01     -tags __ToolShape__]
        #
    set pos_Rotation    [lrange $profile_XY 0 1]          
    set myPositon       [vectormath::addVector              $pos_XY $pos_Rotation]
    $cvObject  create circle    $myPositon  [list -radius 2                 -outline red      -width 0.035    -tags __CenterLine__]
        #
        #
        # -- XZ -----
        #
        # -- Debug -----
        #
    set profile_Surface [$ovalProfile getProfile Debug_0]
    set profile_surface    {}
    foreach {x z} $profile_Surface {
        lappend profile_surface 0 $x
    }
    set myPolyline      [join "$profile_Surface [lreverse $profile_surface]" " "]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $myPolyline]
    $cvObject  create polygon   $myPolyline [list             -outline gray   -fill gray90    -width 0.1      -tags __ToolShape__]
        #
    set profile_X      [$ovalProfile getProfile Debug_X]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $profile_X]
    $cvObject  create line      $myPolyline [list             -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
    set profile_Y      [$ovalProfile getProfile Debug_Y]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $profile_Y]
    $cvObject  create line      $myPolyline [list             -outline blue   -fill gray80    -width 0.1      -tags __ToolShape__]
        #
        # -- XZ -----
        #
    set profile_XZ      [$ovalProfile getProfile XZ]
    set profile_xz      {}
    foreach {x z} $profile_XZ {
        lappend profile_xz 0 $x
    }
    set myPolyline      [join "$profile_XZ [lreverse $profile_xz]" " "]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XZ $myPolyline]
    $cvObject  create polygon   $myPolyline [list             -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
        #
        # -- YZ -----
        #
    set profile_YZ      [$ovalProfile getProfile YZ]
    set profile_yz      {}
    foreach {y z} $profile_YZ {
        lappend profile_yz 0 $y
    }
    set myPolyline      [join "$profile_YZ [lreverse $profile_yz]" " "]
    set myPolyline      [vectormath::addVectorCoordList     $pos_YZ $myPolyline]
    $cvObject  create polygon   $myPolyline [list             -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
    return    
        #
}
    
    
    
    #
proc control::createTest {position} {
        #
    variable angleTube     
    variable diameterTube_x         
    variable diameterTube_y         
    variable lengthTube                             
        #
        #
    variable miterObjectOrigin
    variable miterObjectEnd
        #
    variable testProfile
        #
        #
    set cvObject $::view::cvObject
        #
        #
    set radiusTube_x [expr 0.5 * $diameterTube_x]
    set radiusTube_y [expr 0.5 * $diameterTube_y]
        #
        #
    set pos_XY          [vectormath::addVector $position {0   30}]
    set pos_XZ          [vectormath::addVector $position {0  -50}]
    set pos_YZ          [vectormath::addVector $position {75 -50}]
        #
        #
    set myPositon       [vectormath::addVector  $pos_XZ {0 0}]
    $cvObject  create circle    $myPositon  [list -radius 1    -outline blue     -width 0.035    -tags __CenterLine__]
        #
        #
        # -- XY -----
        #
    set myPositon       [vectormath::addVector              $pos_XY {0 0}]
    $cvObject  create circle    $myPositon  [list -radius $radiusTube_x     -outline blue     -width 0.035    -tags __CenterLine__]
    $cvObject  create circle    $myPositon  [list -radius $radiusTube_y     -outline blue     -width 0.035    -tags __CenterLine__]
        #
        # set myCoords        [list 0 0 $diameterTube_x $diameterTube_y]
        # set myCoords        [vectormath::addVectorCoordList  [list $radiusTube_x $radiusTube_y] $myCoords -1]
        # set myCoords        [vectormath::addVectorCoordList  $pos_XY $myCoords]
        # $cvObject create  oval      $myCoords   [list -outline blue     -width 0.035    -tags __CenterLine__]
        #
    set profile_XY      [$testProfile getProfile XY]
    set myPolyline      [vectormath::addVectorCoordList     $pos_XY $profile_XY]
    $cvObject  create line      $myPolyline [list                           -fill red         -width 0.01     -tags __ToolShape__]
        #
        #
    set pos_Rotation    [lrange $profile_XY 0 1]          
    set myPositon       [vectormath::addVector              $pos_XY $pos_Rotation]
    $cvObject  create circle    $myPositon  [list -radius 2                 -outline red      -width 0.035    -tags __CenterLine__]
        #
        #
    set pos_Check       [vectormath::rotateLine {0 0} 60 [expr double(90 - $control::rotationTube)]]
    set myLine          [join "0 0 $pos_Check" " "]
    set myLine          [vectormath::addVectorCoordList     $pos_XY $myLine]
    $cvObject  create line      $myLine     [list                           -fill red         -width 0.01     -tags __ToolShape__]
        #
    return    
        #
}
    
    
    
    #
    #
    
    #
    # -- VIEW --
    #
proc view::create_config_line {w lb_text entry_var start end  } {        
        frame   $w
        pack    $w
 
        global $entry_var

        label   $w.lb    -text $lb_text            -width 20  -bd 1  -anchor w 
        entry   $w.cfg    -textvariable $entry_var  -width 10  -bd 1  -justify right -bg white 
     
        scale   $w.scl  -width        12 \
                        -length       120 \
                        -bd           1  \
                        -sliderlength 15 \
                        -showvalue    0  \
                        -orient       horizontal \
                        -command      "control::update $entry_var" \
                        -variable     $entry_var \
                        -from         $start \
                        -to           $end 
                            # -resolution   $resolution
                            # -command      "control::updateStage" \

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
proc view::create {windowTitle} {
        #
    variable reportText
    variable stageCanvas
        #
    variable cvObject
    variable cv_scale
    variable drw_scale
        #
    frame .f0 
    set f_view      [labelframe .f0.f_view          -text "view"]
    set f_config    [labelframe .f0.f_config        -text "config"]

    pack  .f0      -expand yes -fill both
    pack  $f_view  $f_config    -side left -expand yes -fill both
    pack  configure  $f_config    -fill y
    
    
    set f_board     [labelframe $f_view.f_board     -text "board"]
    set f_report    [labelframe $f_view.f_report    -text "report"]
    pack  $f_board  $f_report    -side top -expand yes -fill both
   
  
        #
        ### -- G U I - canvas 
    set cvObject    [cad4tcl::new  $f_board  800 600  A3  1.0  25]
    set stageCanvas [$cvObject getCanvas]
    set cv_scale    [$cvObject configure Canvas Scale]
    set drw_scale   [$cvObject configure Stage Scale]
    
        #
        ### -- G U I - canvas report
        #
    set reportText  [text       $f_report.text  -width 50  -height 7]
    set reportScb_x [scrollbar  $f_report.sbx   -orient hori  -command "$reportText xview"]
    set reportScb_y [scrollbar  $f_report.sby   -orient vert  -command "$reportText yview"]
    $reportText     conf -xscrollcommand "$reportScb_x set"
    $reportText     conf -yscrollcommand "$reportScb_y set"
        grid $reportText $reportScb_y   -sticky news
        grid             $reportScb_x   -sticky news
        grid rowconfig    $f_report  0  -weight 1
        grid columnconfig $f_report  0  -weight 1

    if 0 {

            frame .f0 
        set f_canvas  [labelframe .f0.f_canvas   -text "board"  ]
        set f_config  [frame      .f0.f_config   ]

        pack  .f0      -expand yes -fill both
        pack  $f_canvas  $f_config    -side left -expand yes -fill both
        pack  configure  $f_config    -fill y
           
            #
            ### -- G U I - canvas 
        set cvObject    [cad4tcl::new  $f_canvas  800 600  A4  0.5  25]
        set stageCanvas [$cvObject getCanvas]
        set cv_scale    [$cvObject configure Canvas Scale]
        set drw_scale   [$cvObject configure Stage Scale]

            
            #set stageCanvas    [view::createStage    $f_canvas.cv   1000 800  250 250 m  0.5 -bd 2  -bg white  -relief sunken]
    }    

        #
        ### -- G U I - canvas demo
            
    set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
        
    labelframe  $f_config.tube            -text "Tube"
    labelframe  $f_config.round           -text "Round Tube"
    labelframe  $f_config.oval            -text "Oval Tube"
    labelframe  $f_config.config          -text "Config"
    labelframe  $f_config.demo            -text demo
    labelframe  $f_config.tooltype        -text "ToolType:"
    labelframe  $f_config.miterView       -text "MiterView:"
    labelframe  $f_config.scale           -text scale

    pack    $f_config.round     \
            $f_config.oval      \
            $f_config.tube      \
            $f_config.config    \
            $f_config.demo        \
            $f_config.tooltype    \
            $f_config.miterView   \
            $f_config.scale       \
        -fill x -side top
        
    view::create_config_line $f_config.round.d            "Diameter:            "     control::diameterTube        20    60   ;#   0
    view::create_config_line $f_config.oval.dx            "Diameter - X:        "     control::diameterTube_x      30    80   ;#   0
    view::create_config_line $f_config.oval.dy            "Diameter - Y:        "     control::diameterTube_y       5    90   ;#   0
    
    view::create_config_line $f_config.tube.r             "Rotation:            "     control::rotationTube      -180   180   ;#   0
    
    view::create_config_line $f_config.config.l           "Length:              "     control::lengthTube          30    80   ;#   0
    view::create_config_line $f_config.config.prec        "Precision:           "     control::precision            0   180   ;#  10

    radiobutton  $f_config.tooltype.switchOne       -text "Round"           -variable control::switchProfile   -command control::update    -value round    
    radiobutton  $f_config.tooltype.switchTwo       -text "Oval"            -variable control::switchProfile   -command control::update    -value oval     
        
    radiobutton  $f_config.tooltype.config_03       -text "Config_03"       -variable control::switchProfile   -command control::update    -value config_03    
    radiobutton  $f_config.tooltype.config_04       -text "Config_04"       -variable control::switchProfile   -command control::update    -value config_04     
    radiobutton  $f_config.tooltype.config_05       -text "Config_05"       -variable control::switchProfile   -command control::update    -value config_05     
        
    pack    $f_config.tooltype.switchOne    \
            $f_config.tooltype.switchTwo     \
            $f_config.tooltype.config_03     \
            $f_config.tooltype.config_04     \
            $f_config.tooltype.config_05     \
        -side top  -fill x
        
        # view::create_config_line $f_config.tool.l_cone        "Length Cone:         "     control::lengthToolCone      10   120   ;#   0
        # view::create_config_line $f_config.tool.l_base        "Length BaseCylinder: "     control::lengthToolBase       0    30   ;#   0
        # view::create_config_line $f_config.tool.d_top         "Diameter Top   :     "     control::diameterToolTop      5    60   ;#   0
        # view::create_config_line $f_config.tool.d_bse         "Diameter Base  :     "     control::diameterToolBase    30    70   ;#   0
        # view::create_config_line $f_config.tool.l             "Length:              "     control::lengthTool          90   250   ;#   0
        
        # view::create_config_line $f_config.geometry.d_tt      "Angle Tool:          "     control::angleTool           20   160   ;#   0
        # view::create_config_line $f_config.geometry.o_t_z     "Offset Tool z:       "     control::lengthOffset_z     -20   120   ;#   0
        # view::create_config_line $f_config.geometry.o_t_y     "Offset Tool x:       "     control::lengthOffset_x     -20    50   ;#  24
        # view::create_config_line $f_config.geometry.t_a       "Angle Tool-Plane     "     control::angleToolPlane     -90    90   ;#   0
                
        # radiobutton  $f_config.miterView.viewRight      -text "right"           -variable control::viewMiter  -command control::update    -value right    
        # radiobutton  $f_config.miterView.viewLeft       -text "left"            -variable control::viewMiter  -command control::update    -value left
        
        # radiobutton  $f_config.tooltype.typeCylinder    -text "Cylinder"        -variable control::typeTool   -command control::update    -value cylinder 
        # radiobutton  $f_config.tooltype.typeCombined    -text "Frustum"         -variable control::typeTool   -command control::update    -value frustum 
        
        # pack  $f_config.miterView.viewRight \
                $f_config.miterView.viewLeft \
                -side top  -fill x
    
    
        # view::create_config_line $f_config.scale.drw_scale    " Drawing scale "           control::drw_scale  0.2  2  
        #   $f_config.scale.drw_scale.scl      configure       -resolution 0.1
        # button             $f_config.scale.recenter   -text   "recenter"      -command {control::recenter_board}
        
    view::create_config_line $f_config.scale.cv_scale     " Canvas scale  "           control::cv_scale   0.2  5.0  
                       $f_config.scale.cv_scale.scl       configure       -resolution 0.1  -command "control::scale_board"
    button             $f_config.scale.refit      -text   "refit"         -command {control::refit_board}

    pack      \
            $f_config.scale.cv_scale \
            $f_config.scale.refit \
        -side top  -fill x                                                          
                     
    pack  $f_config  -side top -expand yes -fill both
         
            #
            ### -- G U I - canvas print
            #    
        #set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
        #    button  $f_print.bt_print   -text "print"  -command {$view::stageCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
        #pack  $f_print  -side top     -expand yes -fill x
        #    pack $f_print.bt_print     -expand yes -fill x
        
        
        #
        ### -- G U I - canvas demo
        #   
    set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
        button  $f_demo.bt_clear   -text "clear"    -command {$::view::cvObject deleteContent} 
        button  $f_demo.bt_update  -text "update"   -command {control::updateStage}
     
    pack  $f_demo  -side top    -expand yes -fill x
        pack $f_demo.bt_clear   -expand yes -fill x
        pack $f_demo.bt_update  -expand yes -fill x
    
    
        #
        ### -- F I N A L I Z E
        #

    control::cleanReport
    control::writeReport "aha"
        # exit
        
        
        ####+### E N D
        
    update
    
    wm minsize . [winfo width  .]   [winfo height  .]
    wm title   . $windowTitle
    
    $cvObject fit

    return . $stageCanvas

}
    #
    # -- update view
    #
set returnValues [view::create $WINDOW_Title]
# set control::myCanvas [lindex $returnValues 1]
    #
    
control::refit_board
    #
# $::view::stageCanvas reportXMLRoot
        
    #
# appUtil::pdict $::model::dict_TubeMiter 
    #
control::update

