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

namespace eval tubeMiter::app::createMiter::view::CanvasMiter {
    variable miterObject   
    variable mvcModel
    variable mvcControl
    variable cvObject
    variable z_tube     -100
}

    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::CanvasMiter::build {w} {
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
proc tubeMiter::app::createMiter::view::CanvasMiter::setMVC_Model {ns} {
    variable mvcModel
    set mvcModel $ns
}
proc tubeMiter::app::createMiter::view::CanvasMiter::setMVC_Control {ns} {
    variable mvcControl
    set mvcControl $ns
}
proc tubeMiter::app::createMiter::view::CanvasMiter::setMiterObject {obj} {
    variable miterObject
    set miterObject $obj
}
    #
proc tubeMiter::app::createMiter::view::CanvasMiter::updateContent {} {
        #
    variable miterObject   
    variable mvcModel
    variable mvcControl
        #
    variable cvObject    
        #
    $cvObject deleteContent    
        #
    set stageFormat    [$cvObject getStageFormat]
    set stageSize      [$cvObject getStageSize]
    set stageWidth     [lindex $stageSize 0]
    set stageHeight    [lindex $stageSize 1]
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
    set offset_y        [expr $center_y + 20]
        #
        #
        # -------
        #
    set miterShapeDict  [${mvcModel}::getDict_MiterShape]
    set pos_Center      [list $center_x [expr $center_y + 30]]
        #
        #
    set miterShape      [dict get $miterShapeDict miterShape]
    set myPolygon       [vectormath::addVectorCoordList  $pos_Center  $miterShape]  
    $cvObject  create polygon       $myPolygon  [list  -tags __MiterShape__  -outline black  -fill white  -width 0.35  ]
        #
    set centerLine      [dict get $miterShapeDict centerLine_x00]
    set myLine          [vectormath::addVectorCoordList  $pos_Center  $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red   -width 0.1]
        #
    set centerLine      [dict get $miterShapeDict centerLine_z00]
    set myLine          [vectormath::addVectorCoordList  $pos_Center  $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline blue  -width 0.1]
        #
    set centerLine      [dict get $miterShapeDict centerLine_z50]
    set myLine          [vectormath::addVectorCoordList  $pos_Center  $centerLine]
    $cvObject  create centerline    $myLine     [list  -tags __CenterLine__  -outline red   -width 0.1]
        #
        #
        #
        #
        # ---- W A T E R M A R K  - I -  ----
        #
    foreach {x y} $pos_Center break
    set y   [expr $y -50]
    set coordList [list [expr $x - 45] [expr $y + 2] [expr $x + 45] [expr $y + 12]]
        #
    set tagID [[namespace parent]::createWaterMark_Label  $cvObject  $coordList c]
        #
    $cvObject itemconfigure     $tagID -width 0.3
    $cvObject addtag            __tubeMiter__ withtag $tagID
        #
        #
        #
        #
        # ---- M I T E R - Config ---
        #
    set pos_Config  [vectormath::addVector $pos_Center [list 0 -60]]
        #
    set configDict  [${mvcModel}::getDict_Config]
        #
    dict set configDict result perimeter [${mvcModel}::getTubePerimeter]
        #
        #
        # appUtil::pdict $configDict 2 "  "
        #
    set pos_i       [vectormath::addVector $pos_Center [list 0 -50]]
        #
    set lastKey     {}
    dict for {key keyDict} $configDict {
            #
        if {$lastKey ne $key} {
            #set pos_i   [vectormath::addVector $pos_i [list   0 -4]]
            set posKey  [vectormath::addVector $pos_i [list -28 -4]]
            $cvObject create draftText $posKey  -text "${key} -"    -size 2.5  -anchor sw  -tags __ConfigText__
        }
            #
        dict for {index keyValue} $keyDict {    
                #
            set pos_i   [vectormath::addVector $pos_i [list   0 -4]]
            set pos_1   [vectormath::addVector $pos_i [list  -2  0]]
            set pos_2   [vectormath::addVector $pos_i [list   2  0]]
                #
            $cvObject create draftText $pos_1   -text $index        -size 2.5  -anchor se  -tags __ConfigText__
            $cvObject create draftText $pos_2   -text $keyValue     -size 2.5  -anchor sw  -tags __ConfigText__
                #
        }
            #
    }
        #
        #
        #
        #
        # ---- W A T E R M A R K  - II -  ---
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
}
    #
proc tubeMiter::app::createMiter::view::CanvasMiter::exportPDF {} {
        #
    variable cvObject
    variable mvcModel
        #
    $cvObject       fit    
        #
    set cvCanvas    [$cvObject getCanvas]
        #
        #
    set stageFormat [$cvObject getStageFormat]
    set stageSize   [$cvObject getStageSize]
    set stageWidth  [lindex $stageSize 0]
    set stageHeight [lindex $stageSize 1]
        #
        #
    set exportDir       [${mvcModel}::getExportDir]
    set dateModified    [clock format [clock seconds] -format {%Y.%m.%d_%H%M%S}]
        #
    set pdfFileName [format {tubeMiter__%s.pdf} $dateModified]
    set pdfFilePath [file join $exportDir $pdfFileName]
        #
        #
    catch {mypdf destroy}
    pdf4tcl::new mypdf -paper $stageFormat -landscape true  -unit mm
        #
        #
    set w               [$cvObject   getCanvas]            
    set stage_Unit      [$cvObject   configure   Stage  Unit  ]            
    set stage_Width     [$cvObject   configure   Stage  Width ]            
    set stage_Height    [$cvObject   configure   Stage  Height] 
        #
    $cvObject           fit         
        #
    puts "      ---- $cvObject --------------------------------------\n"
    puts "              \$w ................... $w"
    puts "              \$stageFormat ......... $stageFormat"
    puts "              \$stage_Unit .......... $stage_Unit"
    puts "              \$stage_Width ......... $stage_Width"
    puts "              \$stage_Height ........ $stage_Height"
        #
    if {$stage_Width > $stage_Height} {
        set stage_Landscape true
    } else {
        set stage_Landscape false
    }
    puts "              \$stage_Landscape ..... $stage_Landscape"
    puts "\n"
        #
    ::update
        #
    set stageCoords    [ $w coords  {__Stage__} ]
        #
        # pdf4tcl::new mypdf -paper $stage_Format -landscape $stage_Landscape
    mypdf startPage  -paper $stageFormat  -landscape $stage_Landscape
        #
        # puts "export_Project: [mypdf configure]"
    mypdf canvas $w     -x      [format "%smm" 0]  \
                        -y      [format "%smm" 0]  \
                        -width  [format "%smm" $stage_Width] \
                        -height [format "%smm" $stage_Height] \
                        -bbox   $stageCoords
        # mypdf canvas $w -bbox $stageCoords
        #
    mypdf endPage
            #
    if {[catch {mypdf write -file $pdfFilePath} eID]} {
            #
        puts "        <E> ... could not write file:"
        puts "        <E>          $pdfFilePath"
        puts "        <E>          ... $eID"
            #
        mypdf destroy
            #
        return {}
            #
    } else {
            #
        puts "        <I> ... file written:"
        puts "        <I>          $pdfFilePath"
            #
        mypdf destroy
            #
        return $pdfFilePath
    }
        #
        #
        #
    if {[catch {mypdf write -file $pdfFilePath} eID]} {
            #
        $noteBook_top select $currentTab
            #
        tk_messageBox \
                    -icon       error \
                    -title      "Export PDF" \
                    -message    "could not write file:\n   $pdfFilePath\n\n---<E>--------------\n$eID"
            #
        return {}
            #
    }
        #
    puts "\n"
    puts "    <I> file written:"
    puts "            $pdfFilePath"
    puts "\n\n"
        #
    set answer  [tk_messageBox \
                    -icon       question \
                    -title      "tubeMiter export" \
                    -message    "miter-pdf exported to: \n\n    $pdfFilePath" \
                    -type       yesno \
                    -detail     "Select \"Yes\" to open directory"]       
        #
    puts "        -> $answer"    
        #
    if {$answer eq {yes}} {
        exec {*}[auto_execok start] "" [file nativename [file dirname $pdfFilePath]]
    }    
        #
    return
        #
}
    #
proc tubeMiter::app::createMiter::view::CanvasMiter::moveto_StageCenter {item} {
    variable  cvObject
    set stage       [$cvObject getCanvas]
    set stageCenter [$cvObject getCenter]
    set bottomLeft  [$cvObject getBottomLeft]
    foreach {cx cy} $stageCenter break
    foreach {lx ly} $bottomLeft  break
    $cvObject move $item [expr $cx - $lx] [expr $cy -$ly]
}
    #
proc tubeMiter::app::createMiter::view::CanvasMiter::recenter_board {} {
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
proc tubeMiter::app::createMiter::view::CanvasMiter::fitContent {} {
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

