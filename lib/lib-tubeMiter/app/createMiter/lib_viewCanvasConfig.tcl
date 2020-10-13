 ########################################################################
 #
 # simplifySVG: lib_view.tcl
 #
 # Copyright (c) Manfred ROSENBERGER, 2017/11/26
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #

namespace eval tubeMiter::app::createMiter::view::CanvasConfig {
    variable miterObject   
    variable mvcModel   
    variable mvcControl   
    variable cvObject
    variable z_tube     -100
}

    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::CanvasConfig::build {w} {
        #
    variable cvObject    
        #
    set canvasFrame     [frame $w.cv]
    pack $canvasFrame   -expand yes     -fill both
        #
    set cad4tcl::canvasType 1
        # puts "   -> \$cad4tcl::canvasType $cad4tcl::canvasType   ... build"
        #
    set cvObject        [cad4tcl::new   $canvasFrame  700 520  A4  1.0  30  -bd 2  -bg white  -relief sunken]
        #
    $cvObject fit
        #
}
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::CanvasConfig::setMVC_Model {ns} {
    variable mvcModel
    set mvcModel $ns
}
proc tubeMiter::app::createMiter::view::CanvasConfig::setMVC_Control {ns} {
    variable mvcControl
    set mvcControl $ns
}
proc tubeMiter::app::createMiter::view::CanvasConfig::setMiterObject {obj} {
    variable miterObject
    set miterObject $obj
}
    #
proc tubeMiter::app::createMiter::view::CanvasConfig::updateContent {} {
        #
    variable miterObject   
    variable mvcModel
    variable mvcControl
        #
    variable cvObject    
        #
    $cvObject deleteContent    
        #
    set stageFormat     [$cvObject getStageFormat]
    set stageSize       [$cvObject getStageSize]
    set stageWidth      [lindex $stageSize 0]
    set stageHeight     [lindex $stageSize 1]
        # puts "  -> \$stageFormat    $stageFormat"    
        # puts "  -> \$stageSize      $stageSize"    
        # puts "  -> \$stageWidth     $stageWidth"
        # puts "  -> \$stageHeight    $stageHeight"
        #
    set tubePerimeter   [${mvcModel}::getTubePerimeter]
        # puts "  -> \$tubePerimeter  $tubePerimeter"   
        #
    set cvBorder_x      20
    set cvBorder_y      15
    set cvWidth         [expr $stageWidth  - 2 * $cvBorder_x]
    set cvHeight        [expr $stageHeight - 2 * $cvBorder_y]
        #
        #
    set center_x        [expr 0.5 * $stageWidth]
    set center_y        [expr 0.5 * $stageHeight]
    set offset_x_Left   [expr $center_x + 0.5 * $tubePerimeter + 10]
    set offset_x_Right  [expr $center_x - 0.5 * $tubePerimeter - 20]
    set offset_y        [expr $center_y + 30]
        #
    set offset_x_Left   [expr $center_x - 0.5 * $tubePerimeter - 30]
    set offset_x_Right  [expr $center_x + 0.5 * $tubePerimeter]
        #
    set offset_x_Left   [expr 0.5 * $center_x - 10]
    set offset_x_Right  [expr 1.3 * $center_x]
        #
        # -------
    set pos_Left        [list $offset_x_Left  $offset_y]
        # -------
        #
    set tubeShapeDict   [${mvcModel}::getDict_TubeShape]
    set miterShapeDict  [${mvcModel}::getDict_MiterShape]
    set toolShapeDict   [${mvcModel}::getDict_ToolShape]
        #
        #
        #
        #
        # ---- L E F T ---
        #
        #
    set toolShape       [dict get $toolShapeDict toolShape]
    if {$toolShape ne {}} {
        set myPolygon   [vectormath::addVectorCoordList  $pos_Left  $toolShape]
        # $cvObject  create polygon  $myPolygon   [list   -outline black  -fill white   -width 0.35  -tags __CenterLine__]
    }
        #
    set debugTube       [dict get $toolShapeDict debugTube]
    if {$debugTube ne {}} {
        set myPolygon   [vectormath::addVectorCoordList  $pos_Left  $debugTube]
        #$cvObject  create polygon  $myPolygon   [list   -outline black  -fill white   -width 0.35  -tags __CenterLine__]
    }
        #
    set debugTool       [dict get $toolShapeDict debugTool]
    if {$debugTool ne {}} {
        set myPolygon   [vectormath::addVectorCoordList  $pos_Left  $debugTool]
        #$cvObject  create polygon  $myPolygon   [list   -outline black  -fill gray90   -width 0.35  -tags __CenterLine__]
    }
        #
    set debugLine01     [dict get $toolShapeDict debugLine01]
    if {$debugLine01 ne {}} {
        set myLine      [vectormath::addVectorCoordList  $pos_Left  $debugLine01]
        #$cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red  -width 0.1]
    }
        #
        #
    set tube_Bottom     [dict get $tubeShapeDict left_Bottom]
    set myPolygon       [vectormath::addVectorCoordList  $pos_Left  $tube_Bottom]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill gray90  -width 0.35  -tags __CenterLine__]
        #
        #        
    set toolShape       [dict get $toolShapeDict toolShape]
    if {$toolShape ne {}} {
        set myPolygon   [vectormath::addVectorCoordList  $pos_Left  $toolShape]
        $cvObject  create polygon  $myPolygon   [list   -outline black  -fill white   -width 0.35  -tags __CenterLine__]
    }
        #
        #
    set tube_Top        [dict get $tubeShapeDict left_Top]
    set myPolygon       [vectormath::addVectorCoordList  $pos_Left  $tube_Top]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill white   -width 0.35  -tags __CenterLine__]
        #
    set centerLine      [dict get $toolShapeDict centerLine_xz]    
    if {$centerLine ne {}} {
        set myLine          [vectormath::addVectorCoordList  $pos_Left  $centerLine]
        $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline blue  -width 0.1]
    }
        #
    set centerLine      [dict get $miterShapeDict centerLine_x00]
    set myLine          [vectormath::addVectorCoordList  $pos_Left  $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red   -width 0.1]
        #
        #
        #
        #
        # ---- R I G H T ---
        #
    set pos_Right_left  [list [expr $offset_x_Right - 0.40 * $tubePerimeter] $offset_y]
    set pos_Right_top   [list $offset_x_Right $offset_y]
    set pos_Right_right [list [expr $offset_x_Right + 0.40 * $tubePerimeter] $offset_y]
        #
        #
        #
    set tube_Bottom     [dict get $tubeShapeDict left_Bottom]
        # sputs "   -> \$tube_Bottom   $tube_Bottom"
    set myPolygon       [vectormath::addVectorCoordList  $pos_Right_left    $tube_Bottom]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill gray90  -width 0.35  -tags __CenterLine__]
        #   
    set tube_Top        [dict get $tubeShapeDict left_Top]
        # puts "   -> \$tube_Top      $tube_Top"
    set myPolygon       [vectormath::addVectorCoordList  $pos_Right_left    $tube_Top]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill white   -width 0.35  -tags __CenterLine__]
        #
        #
        #
    set tube_Bottom     [dict get $tubeShapeDict top_Bottom]
        # puts "   -> \$tube_Bottom   $tube_Bottom"
    set myPolygon       [vectormath::addVectorCoordList  $pos_Right_top     $tube_Bottom]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill gray90  -width 0.35  -tags __CenterLine__]
        #   
    set tube_Top        [dict get $tubeShapeDict top_Top]
        # puts "   -> \$tube_Top      $tube_Top"
    set myPolygon       [vectormath::addVectorCoordList  $pos_Right_top     $tube_Top]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill white   -width 0.35  -tags __CenterLine__]
        #
        #
        #
    set tube_Bottom     [dict get $tubeShapeDict right_Bottom]
        # puts "   -> \$tube_Bottom   $tube_Bottom"
    set myPolygon       [vectormath::addVectorCoordList  $pos_Right_right   $tube_Bottom]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill gray90  -width 0.35  -tags __CenterLine__]
        #   
    set tube_Top        [dict get $tubeShapeDict right_Top]
        # puts "   -> \$tube_Top      $tube_Top"
    set myPolygon       [vectormath::addVectorCoordList  $pos_Right_right   $tube_Top]
    $cvObject  create polygon  $myPolygon   [list   -outline green  -fill white   -width 0.35  -tags __CenterLine__]
        #
        #
        #
    set centerLine      [dict get $miterShapeDict centerLine_z00]    
    set myLine          [vectormath::addVectorCoordList  $pos_Right_top $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline blue  -width 0.1]
        #
    set centerLine      [dict get $miterShapeDict centerLine_x00]
    set myLine          [vectormath::addVectorCoordList  $pos_Right_top $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red   -width 0.1]
        #
    set miterProfile    [dict get $miterShapeDict miterProfile]
    set myLine          [vectormath::addVectorCoordList  $pos_Right_top $miterProfile]
    $cvObject  create line      $myLine     [list  -tags __CenterLine__  -outline red  -width 0.1]
        #
        #
        #
        #
        # ---- P R O F I L E ---
        #
    set pos_Profile     [list $offset_x_Right [expr $offset_y + 30]]
        #
    set diameter_x      [dict get $tubeShapeDict diameter_x]    
    set diameter_y      [dict get $tubeShapeDict diameter_y]    
        #
    set coordOval       [dict get $tubeShapeDict coordOval]    
    set myOval          [vectormath::addVectorCoordList  $pos_Profile $coordOval]
    $cvObject create  oval       $myOval    [list -tags __CenterLine__  -outline red  -fill white]    
        #        
    set centerLine      [dict get $tubeShapeDict  centerLine_x]    
    set myLine          [vectormath::addVectorCoordList  $pos_Profile $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red  -width 0.1]
        #
    set centerLine      [dict get $tubeShapeDict  centerLine_y]
    set myLine          [vectormath::addVectorCoordList  $pos_Profile $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red   -width 0.1]
        #
    set centerLine      [dict get $toolShapeDict  centerLine_xy]
    if {$centerLine ne {}} {
        set myLine      [vectormath::addVectorCoordList  $pos_Profile $centerLine]
        $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline blue   -width 0.1]
    }
        #
        #
        #
        #
        # ---- W A T E R M A R K ---
        #
    set pos_Watermark   [list [expr $stageWidth - 10]  10]
        #
    foreach {x y} $pos_Watermark break
    set coordList [list [expr $x - 60] [expr $y + 1] [expr $x + 60] [expr $y + 9]]
        #
    set tagID [[namespace parent]::createWaterMark_Label  $cvObject  $coordList r]
        #
    $cvObject itemconfigure     $tagID -width 0.3
    $cvObject addtag            __tubeMiter__ withtag $tagID
        #
        #
    # moveto_StageCenter  {__CenterLine__ __MiterShape__}
        #
}
    #
proc tubeMiter::app::createMiter::view::CanvasConfig::moveto_StageCenter {item} {
    variable  cvObject
    set stage       [$cvObject getCanvas]
    set stageCenter [$cvObject getCenter]
    set bottomLeft  [$cvObject getBottomLeft]
    foreach {cx cy} $stageCenter break
    foreach {lx ly} $bottomLeft  break
    $cvObject move $item [expr $cx - $lx] [expr $cy -$ly]
}
    #
proc tubeMiter::app::createMiter::view::CanvasConfig::recenter_board {} {
    variable  cv_scale 
    variable  drw_scale 
    variable  cvObject
    puts "\n  -> recenter_board:   $cvObject "
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "============================="
    puts "\n\n"
    moveto_StageCenter __cvElement__
    set cv_scale [$cvObject configure Canvas Scale]    
}
    #
proc tubeMiter::app::createMiter::view::CanvasConfig::fitContent {} {
        #
    variable cvObject
        #
    puts "\n"
    puts "  =============================================="
    puts "   -- fitContent:   $cvObject"
    puts "  =============================================="
    puts "\n"
        #
    $cvObject fit
        # $cvObject fitContent __Content__
        #
    return
        #
}
    #

