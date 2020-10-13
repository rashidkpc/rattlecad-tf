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
    #
namespace eval tubeMiter::app::createMiter::view {
        #
    variable configList 0    
        #
    variable mvcModel       {}    
    variable mvcControl     {}    
        #
    variable miterObject    {}    
        #
    namespace export    setValue \
                        getValue \
                        fitContent
        #
}
    #
    #
    # --- window ------------
    #
proc tubeMiter::app::createMiter::view::init {w} {
        #
    variable mvcControl
        #
        #
        # -- root Frame ----------------------
    if {$w == {.} || $w == {}} {
        set rootFrame   [frame .f -bg lightblue]
        #pack $rootFrame  -expand yes  -fill both
    } else {
        set rootFrame   [frame $w.f -bg lightblue]
    }
    pack $rootFrame     -expand yes  -fill both
        #
        #
        # -- Main Frame ----------------------
    set centerFrame     [frame $rootFrame.main  -relief sunken  -bd 2]
    pack $centerFrame   -expand yes  -fill both  -side top 
        #
        #
        # -- canvas Frame --------------------
    set canvasFrame     [frame $centerFrame.canvas  -relief flat]    
    pack $canvasFrame   -expand yes  -fill both     -side left 
    Canvas::build       $canvasFrame
        #
        #
        # -- config Frame ----------------------
    set configFrame     [frame $centerFrame.config  -relief flat]    
    pack $configFrame   -expand yes  -fill both  -side top
        #
    Config::setMVC_View     [namespace current]
    Config::build           $configFrame
        #
        #
    set buttonFrame     [frame $centerFrame.button  -relief flat] 
    pack $buttonFrame   -expand no  -fill x  -side top
        #
    ttk::button $buttonFrame.bt_update  -width 15   -text "   update   "    -command ${mvcControl}::update
    ttk::button $buttonFrame.bt_fit     -width 15   -text " fit Canvas "    -command [namespace current]::Canvas::updateGUI
    ttk::button $buttonFrame.bt_export  -width 15   -text " export PDF "    -command ${mvcControl}::exportMiter
        #
    pack $buttonFrame.bt_update  $buttonFrame.bt_fit  $buttonFrame.bt_export \
            -side top  -expand yes  -fill x  -padx 4  -pady 2
        #
        #
        # -- Bottom Frame ----------------------
    # set bottomBar       [frame $rootFrame.bb    -bd 2  -relief sunken]
    # pack $bottomBar     -fill x   -side bottom
        # createContent_ButtonBar $bottomBar
        #
        #
    ::update    
        #
        #
    [namespace current]::update    
        #
        #
    return $rootFrame
        #
}
    #
proc tubeMiter::app::createMiter::view::createContent_ButtonBar {w} {
        #
    ttk::button $w.bt_update    -width 15   -text " update "        -command [namespace parent]::control::update
        #
    label       $w.sp_00                    -text "      "
        #
        # pack        $w.bt_open  $w.bt_reopen 
    pack        $w.bt_update \
            -side right  -padx 2  -pady 2
        #
}
    #
    #
    # --- procedure ---------
    #
proc tubeMiter::app::createMiter::view::setMVC_Model {ns} {
    variable mvcModel
    set mvcModel $ns
    CanvasConfig::setMVC_Model      $ns
    CanvasMiter::setMVC_Model       $ns
}
proc tubeMiter::app::createMiter::view::setMVC_Control {ns} {
    variable mvcControl
    set mvcControl $ns
    Config::setMVC_Control          $ns
    CanvasConfig::setMVC_Control    $ns
    CanvasMiter::setMVC_Control     $ns
}
proc tubeMiter::app::createMiter::view::setMiterObject {obj} {
    variable miterObject
    set miterObject $obj
    CanvasConfig::setMiterObject    $obj
    CanvasMiter::setMiterObject     $obj
        #
}
    #
proc tubeMiter::app::createMiter::view::getConfigDict {} {
        #
        # puts "\n  --- updateDict ---\n"
        #
    set tubeDict    [ConfigTube::getDict]
        #
        # puts "    -> \$tubeDict ->  $tubeDict"
        #
    set toolDict    [ConfigTool::getDict]
        #
        # puts "    -> \$toolDict ->  $toolDict"
        #
    set miterDict   [ConfigMiter::getDict]
        #
        # puts "    -> \$miterDict -> $miterDict"
        #
        # ---
        #
    set returnDict  [dict create \
                            tube    $tubeDict \
                            tool    $toolDict \
                            miter   $miterDict \
                        ]
        #
    return $returnDict
        #
}   
    #
proc tubeMiter::app::createMiter::view::update {} {
        #
    puts "\n  --- update ---\n"
        #
    variable mvcControl    
        #
    set toolName    [tubeMiter::app::createMiter::view::ConfigTool::getToolName]    
        #
    puts "       -> \$toolName $toolName"
        #
    if {[catch {ConfigMiter::setMode $toolName} eID]} {
        puts "\n        <E> ... $toolName does not work at init"
        puts "                 -> $eID"
        puts ""
    }
        #
    ${mvcControl}::update    
        #
}   
    #
proc tubeMiter::app::createMiter::view::updateCanvas {} {
        #
    CanvasConfig::updateContent
    CanvasMiter::updateContent
        #
}   
    #
proc tubeMiter::app::createMiter::view::createWaterMark_Label {cvObject {coords {_default_}} {orient e} {labelFile {_default_}}  {tagList {}}  {scale {1.0}} {position {}}} {
        #
    variable mvcModel
        #
    if {$labelFile eq {_default_}} {
        set svgFile [${mvcModel}::getSVG_WaterMark]   
    } else {
        set svgFile $labelFile
    }
        #
    set fp          [open $svgFile]
        #
    fconfigure      $fp -encoding utf-8
    set xml         [read $fp]
    close           $fp
        #
    set doc         [dom parse  $xml]
    set svgNode     [$doc documentElement]
        #
    set stageWidth  [$cvObject configure  Stage Width]
        # 
    if {$coords eq {_default_}} {
            #
        set refx_00     [expr $stageWidth - 100]
        set refx_01     [expr $stageWidth -  10]
        set refy_00     5
        set refy_01     12
            #
        set myCoords    [list $refx_00 $refy_00 $refx_01 $refy_01]
            #
    } else {
            #
        set myCoords    $coords
            #
    }
        #
    set labelObject [$cvObject create draftLabel  $myCoords  [list -svgNode $svgNode  -anchor $orient  -tags __Watermark_Label__]]
        #
    return $labelObject
        #
}
    #
proc tubeMiter::app::createMiter::view::__fitContent {} {
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
    [namespace parent] fitContent $cvObject
        #
    return
        #
}
    #
    #
    #
proc tubeMiter::app::createMiter::view::__setValue {arrayName arrayKey value} {
    variable Scalar
    return $value
}
    #
proc tubeMiter::app::createMiter::view::__getValue {arrayName arrayKey} {
    variable $arrayName
    # parray Scalar
    # parray $arrayName
    set value   [lindex [array get $arrayName $arrayKey] 1]
    return $value
    # return 5.00
}
    #
