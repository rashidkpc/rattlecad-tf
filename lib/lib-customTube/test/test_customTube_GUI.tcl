 ##+##########################################################################
 #
 # test_customTube_GUI.tcl
 #
 #   customTube is software of Manfred ROSENBERGER
 #       based on tclTk and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2018/01/04
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
 # ---------------------------------------------------------------------------
 #    namespace:  customTube
 # ---------------------------------------------------------------------------
 #
 #

 


set WINDOW_Title      "test customTube, based on cad4tcl"


set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir _ext__Libraries]

package require   Tk
package require   appUtil
package require   cad4tcl
package require   vectormath
package require   customTube

set cad4tcl::canvasType 1
 
    ##+######################

namespace eval model {
        #
    variable Config              
    variable Scalar              
    variable View              
    variable tubeDictionary
        #
    set tubeDictionary  [dict create]
        #
    array set Config {}
    array set Scalar {}
    array set View {
        ZX {}
        ZY {}
    }
        #
}
namespace eval view {
    variable cvObject
    variable stageCanvas
    variable stageNamespace
    variable reportText
}
namespace eval control {
        #
        # defaults
        #
    variable contrSeg_l00         50    ;#     5     100
    variable contrSeg_r01         30    ;#    20     100
    variable contrSeg_a01         25    ;#   -90      90
    variable contrSeg_l02         60    ;#    20     150
    variable contrSeg_r03         40    ;#    20     100
    variable contrSeg_a03        -20    ;#   -90      90
    variable contrSeg_l04         70    ;#    20     150
    variable contrSeg_r05         40    ;#    20     100
    variable contrSeg_a05        -30    ;#   -90      90
    variable contrSeg_l06         70    ;#    20     150
        #
    variable guideDef            {}         
           # guideDef          {i 50 a {30 60} l 100 a {40 -20} l 50 a {20 -40} l 60} 
           # guideDef          {l 50 a {30 60}} 
        #
    variable profileDef           {}
        #
    variable profile_x01          10    
    variable profile_x02          30    
    variable profile_x03         130    
    variable profile_x04          90    
    variable profile_y01          10    
    variable profile_y02          15    
    variable profile_y03          20    
    variable profile_y04          15
        #
        #
    variable centerLine           {-1  0}
        #
    variable start_angle          20
    variable start_length         80
    variable end_length           65
    variable dim_size              5
    variable dim_dist             30
    variable dim_offset            0
    variable dim_type_select      aligned
    variable dim_font_select      vector
    variable std_fnt_scl           1
    variable font_colour          black
    variable demo_type            dimension
    variable drw_scale             1.0
    variable cv_scale              1
    variable debugMode             off
        #
    variable arcPrecision         1
        #
        #
    variable tubeKey              2   
        #
    variable objTube         [customTube::Tube new]
        #
        #
        #variable unbentShape
        #variable profileDef {}
        #     set profileDef {{0 7} {10 7} {190 9} {80 9} {70 12}}
        #     set profileDef {{0 9} {10 7} {190 16} {80 16} {70 24}}
        #     set profileDef {{0 7} {10 7} {190 16} {80 16} {70 24}}
        #
}    
    #
    # -- MODEL --
    #
proc model::init {} {
        #
    variable tubeDictionary
        #
    updateTube
        #
    return
        #
}
    #
proc model::updateTube {{key {}}} {
        #
    variable tubeDictionary
        #
    variable Scalar
    variable View
        #
    if 0 {
            #
        getDictionary   topTube_MAX
            #
            # setDictionary   $key
            #
            # appUtil::pdict $tubeDictionary    
            #
        set profile(round)  [_getDictValue   Tube/profile_round]
        set profile(x)      [_getDictValue   Tube/profile_x]
        set profile(x)      [_getDictValue   Tube/profile_x]
        set profile(y)      [_getDictValue   Tube/profile_y]
        set length          [_getDictValue   Tube/length]
            #
        puts "-- updateTubeGeometry --"
        puts "        -> \$profile(round)   $profile(round)"
        puts "        -> \$profile(x)       $profile(x)"
        puts "        -> \$profile(y)       $profile(y)"
        puts "        -> \$length           $length    "
            #
            # --- View ZX --- 
            #
        set View(ZX)       {}
        if {$profile(x) ne {}} {
                #
            set length_z        0
            set radius(X_0)     [lindex [lindex $profile(x) 0] 1]
            set lastX           $radius(X_0)
            foreach {z x} $profile(x) {
                puts "     -> $z $x"
                set length_z    [expr $length_z + $z]
                if {$length_z > $length} {
                    set length_z $length
                }
                lappend View(ZX) $length_z $x
            }
            set radius(X_end)   [lindex [lindex $View(ZX) end] 1]
                #
            foreach {x z} [lreverse $View(ZX)] {
                lappend View(ZX) $z [expr -1 * $x]
            }   
                #
        }
            #
            # --- View ZY --- 
            #
        set View(ZY)       {}
        if {$profile(y) ne {}} {
                #
            set length_z        0
            set radius(Y_0)     [lindex [lindex $profile(y) 0] 1]
            set lastY           $radius(Y_0)
            foreach {z y} $profile(y) {
                puts "     -> $z $y"
                set length_z    [expr $length_z + $z]
                if {$length_z > $length} {
                    set length_z $length
                }
                lappend View(ZY)   $length_z $y
            }
            set radius(Y_end)   [lindex [lindex $View(ZY) end] 1]
                #
            foreach {y z} [lreverse $View(ZY)] {
                lappend View(ZY) $z [expr -1 * $y]
            }   
                #
        }    
            #
        if {$profile(x) eq {} && $profile(y) ne {}} {
            set View(ZX)  $View(ZY) 
        }
        if {$profile(y) eq {} && $profile(z) ne {}} {
            set View(ZY)  $View(ZX) 
        }
        parray Scalar
        parray View
    }    
        #
    return
        #
}
    #
proc model::getDictionary {{key {}}} {
        #
    variable tubeDictionary
        #
    switch -exact -- $key {
        chainStay_MAX {
            set tubeDictionary  [getDictionary_ChainStay_MAXL14OV]
        }
        downTube_MAX {
            set tubeDictionary  [getDictionary_DownTube_MAXL12650]
        }
        topTube_MAX {
            set tubeDictionary  [getDictionary_TopTube_MAXL11600]
        }
        debug_01 {
            set tubeDictionary  [getDictionary_Debug_01]
        }
        debug_02 {
            set tubeDictionary  [getDictionary_Debug_02]
        }
        {} -
        default {
            set tubeDictionary  [getDictionary_Default]
        }
    }
        #
    return $tubeDictionary
        #
} 
    #
proc model::getDictionary_Default {} {
        #
    set myDictionary    [dict create]
        #
    dict set myDictionary  MetaData {
                Name            {any default}
            }
    dict set myDictionary  Tube {
                length          432.22
                profile_round   {{0 15.90  100 15.90  300 17.95  150 17.95}}
                profile_x       {}
                profile_y       {}
                centerLine      {}
            }
    dict set myDictionary  MiterOrigin {
                toolAngle       80
                toolRotation    0
                toolType        frustum
                toolProfile     {{0 28  15 28  70 23  165 23}}
                toolOffset {
                    x           0
                    y           55
                }
                tubePrecision   45
            }
    dict set myDictionary  MiterEnd {
                toolAngle       110
                toolRotation    0
                toolType        cylinder
                toolProfile     {{0 16.5}}
                toolOffset {
                    x           0
                    y           50
                }
                tubePrecision   45
            }
        #
    return $myDictionary
        #
} 
    #
proc model::getDictionary_ChainStay_MAXL14OV {{key {}}} {
        #
    set myDictionary    [dict create]
        #
    dict set tubeDictionary  MetaData {
                Name            {Columbus MAXL14OV}
            }
    dict set myDictionary  Tube {
                length          385.23
                profile_round   {{0 7  230 14  180 14}}
                profile_x       {{0 7  230 9.25  180 9.25}}
                profile_y       {{0 7  230 18  180 18}}
                centerLine      {}
            }
    dict set myDictionary  MiterOrigin {
                toolAngle       90
                toolRotation    0
                toolType        {plane}
                tubePrecision   45
            }
    dict set myDictionary  MiterEnd {
                toolAngle       90
                toolRotation    0
                toolType        {plane}
                tubePrecision   45
            }
        #
    return $myDictionary
        #
} 
    #
proc model::getDictionary_DownTube_MAXL12650 {{key {}}} {
        #
    set myDictionary    [dict create]
        #
    dict set myDictionary  MetaData {
                Name            {Columbus MAXL12650}
            }
    dict set myDictionary  Tube {
                length          592.22
                profile_round   {{0 17.50  650 17.50}}
                profile_x       {{0 15  100 15  450 20.15  100 20.15}}
                profile_y       {{0 20.15  100 20.15  450 15  100 15}}
                centerLine      {}
            }
    dict set myDictionary  MiterOrigin {
                toolAngle       110
                toolRotation    0
                toolType        frustum
                toolProfile     {{0 28  15 28  70 23  165 23}}
                toolOffset {
                    x           0
                    y           55
                }
                tubePrecision   45
            }
    dict set myDictionary  MiterEnd {
                toolAngle       60
                toolRotation    0
                toolType        cylinder
                toolProfile     {{0 16.5}}
                toolOffset {
                    x           0
                    y           50
                }
                tubePrecision   45
            }
        #
    return $myDictionary
        #
} 
    #
proc model::getDictionary_TopTube_MAXL11600 {{key {}}} {
        #
    set myDictionary    [dict create]
        #
    dict set myDictionary  MetaData {
                Name            {Columbus MAXL12650}
            }
    dict set myDictionary  Tube {
                length          562.33
                profile_round   {{0 15.85  600 15.85}}
                profile_x       {{0 13.05  80 13.05  450 18.85  100 18.85}}
                profile_y       {{0 18.85  80 18.85  450 13.05  100 13.05}}
                centerLine      {}
            }
    dict set myDictionary  MiterOrigin {
                toolAngle       65
                toolRotation    0
                toolType        frustum
                toolProfile     {{0 28  15 28  70 23  165 23}}
                toolOffset {
                    x           0
                    y           55
                }
                tubePrecision   45
            }
    dict set myDictionary  MiterEnd {
                toolAngle       115
                toolRotation    0
                toolType        cylinder
                toolProfile     {{0 16.5}}
                toolOffset {
                    x           0
                    y           50
                }
                tubePrecision   45
            }
        #
    return $myDictionary
        #
} 
    #
    #
proc model::getDictionary_Debug_01 {{key {}}} {    
        #
    set myDictionary    [dict create]
        #
    dict set myDictionary  MetaData {
                Name {Debug}
            }
    dict set myDictionary  Tube {
                centerLine      {}
                length          458.80425224869646
                profile_round   {{0 5.5 300.00 8.0 10 8.0}}
            }
    dict set myDictionary  MiterOrigin {
                toolAngle       90
                toolRotation    0
                toolType        plane
                tubePrecision   1
            }
    dict set myDictionary  MiterEnd {
                toolAngle       131.641317639144
                toolOffset {
                    x           -6.3
                }
                toolProfile     {{0 14.3}}
                toolRotation    180 
                toolType        cylinder 
                tubePrecision   45 
            }
        #
    return $myDictionary
        #
}
    #
proc model::getDictionary_Debug_02 {{key {}}} {    
        #
    set myDictionary    [dict create]
        #
    dict set myDictionary  MetaData {
                Name {Debug}
            }
    dict set myDictionary  Tube {
                centerLine      {}
                length          458.80425224869646
                profile_round   {{0 5.0  20 5.0  20.00 15.0  20.00 15.0  20 5.0  20 5.0}}
            }
    dict set myDictionary  MiterOrigin {
                toolAngle       90
                toolRotation    0
                toolType        plane
                tubePrecision   1
            }
    dict set myDictionary  MiterEnd {
                toolAngle       131.641317639144
                toolOffset {
                    x           -6.3
                }
                toolProfile     {{0 14.3}}
                toolRotation    180 
                toolType        cylinder 
                tubePrecision   45 
            }
        #
    return $myDictionary
        #
}
    #
    #
proc model::_getDictValue {dictPath} {
        #
    variable tubeDictionary
        #
    set dictPath [string map {"/" " "} $dictPath]
        #
    if {[catch {set value [dict get $tubeDictionary {*}$dictPath]} eID]} {
        return {}
    } else {
        return [join $value]
    }
        #
}    
    #
proc model::getView {key} {
        #
    variable View
        #
    switch -exact $key {
        zx -
        ZX -
        xz -
        XZ {
            return $View(ZX)
        }
        zy -
        ZY -
        yz -
        YZ -
        default {
            return $View(ZY)
        }
    }    
        #
}    
    #
    #
    # -- CONTROL --
    #
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
    puts "============================="
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
    puts "============================="
    puts "\n\n"
    set cv_scale [ $cvObject fit]
}
proc control::scale_board {{value {1}}} {   
    variable  cv_scale 
    variable  drw_scale 
    set cvObject $::view::cvObject
    puts "\n  -> scale_board:   $cvObject"
    puts "\n\n============================="
    puts "   -> cv_scale:           $cv_scale"
    puts "   -> drw_scale:          $drw_scale"
    puts "============================="
    puts "\n\n"   
    # $cvObject configure Canvas Scale $cv_scale
    $cvObject configure Stage Scale  $drw_scale
    control::update
}
proc control::cleanReport {} {
    $view::reportText   delete  1.0 end
}
proc control::writeReport {text} {
    $view::reportText   insert  end "$text\n"
}
    #
proc control::update {{value 1}} {
        #
    variable objTube
    variable tubeKey
        #
    switch -exact $tubeKey {
        1 {
            set modelKey    {}
        }
        2 {
            set modelKey    {downTube_MAX}
        }
        3 {
            set modelKey    {topTube_MAX}
        }
        4 {
            set modelKey    {chainStay_MAX}
        }
        5 {
            set modelKey    {debug_01}
        }
        6 {
            set modelKey    {debug_02}
        }
        default {
            set modelKey    {downTube_MAX}
        } 
    }
        #
    set tubeDict    [model::getDictionary $modelKey]
        # chainStay_MAX
        # topTube_MAX
        # {}
    $objTube setDictionary $tubeDict
        #
    $objTube update
        #
        #
    updateStage  
        #
    return
        #
}
proc control::updateStage {} {
        #
    variable dim_size
    variable dim_font_select
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
    $cvObject configure Style    Fontstyle    $dim_font_select
    $cvObject configure Style    Fontsize     $dim_size
        #
        #
    # writeReport "    \$guideDef"
    # writeReport "           -> $guideDef"
    # writeReport "    \$profileDef"
    # writeReport "           -> $profileDef"
        #
        #
    createTube      {-250 0}  
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
proc control::createTube {position} {
        #
    variable objTube
        #
        #
    set cvObject $::view::cvObject
        #
        #
    set pos_XY          [vectormath::addVector $position {0 -150}]
    set pos_XZ          [vectormath::addVector $position {0  -70}]
    set pos_YZ          [vectormath::addVector $position {0   70}]
        #
        #
    set myPositon       [vectormath::addVector          $pos_XZ {0 0}]
    $cvObject  create circle    $myPositon  [list -radius 5     -outline blue                   -width 0.01     -tags __ToolShape__]
        #
        #
        #
        # -- View ZY --
        #
    set shape_zy    [$objTube getView ZY]
    set myPolygon       [vectormath::addVectorCoordList     $pos_YZ     $shape_zy]
    $cvObject  create polygon   $myPolygon  [list               -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
    set shape_zy    [$objTube getView Debug_ZY]
    set myPolygon       [vectormath::addVectorCoordList     $pos_YZ     $shape_zy]
    set myPolygon       [vectormath::addVectorCoordList     {0 50}     $myPolygon]
    $cvObject  create polygon   $myPolygon  [list               -outline red    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
        #
        #
    set pos_00      [$objTube getPosition Origin]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_00]
    $cvObject  create circle    $myPositon  [list -radius 2     -outline red                     -width 0.01     -tags __ToolShape__]
        #
    set pos_01      [$objTube getPosition RefOriginLeft]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_01]
    $cvObject  create circle    $myPositon  [list -radius 1     -outline red                     -width 0.01     -tags __ToolShape__]
        #
    set pos_02      [$objTube getPosition EdgeOriginLeft]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_02]
    $cvObject  create circle    $myPositon  [list -radius 2     -outline red                     -width 0.01     -tags __ToolShape__]
        #
    set pos_03      [$objTube getPosition EdgeOriginRight]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_03]
    $cvObject  create circle    $myPositon  [list -radius 3     -outline red                     -width 0.01     -tags __ToolShape__]
        #
    set pos_04      [$objTube getPosition RefOriginRight]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_04]
    $cvObject  create circle    $myPositon  [list -radius 4     -outline red                     -width 0.01     -tags __ToolShape__]
        #
        #
    set pos_05      [$objTube getPosition RefEndLeft]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_05]
    $cvObject  create circle    $myPositon  [list -radius 1     -outline blue                    -width 0.01     -tags __ToolShape__]
        #
    set pos_06      [$objTube getPosition EdgeEndLeft]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_06]
    $cvObject  create circle    $myPositon  [list -radius 2     -outline blue                    -width 0.01     -tags __ToolShape__]
        #
    set pos_07      [$objTube getPosition EdgeEndRight]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_07]
    $cvObject  create circle    $myPositon  [list -radius 3     -outline blue                    -width 0.01     -tags __ToolShape__]
        #
    set pos_08      [$objTube getPosition RefEndRight]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_08]
    $cvObject  create circle    $myPositon  [list -radius 4     -outline blue                    -width 0.01     -tags __ToolShape__]
        #
    set pos_09      [$objTube getPosition End]    
    set myPositon       [vectormath::addVector              $pos_YZ $pos_09]
    $cvObject  create circle    $myPositon  [list -radius 2     -outline blue                    -width 0.01     -tags __ToolShape__]
        #
        
        
        #
        #
        # -- View ZX --
        #
    set shape_zx    [$objTube getView ZX]
    set myPolygon       [vectormath::addVectorCoordList     $pos_XZ     $shape_zx]
    $cvObject  create polygon   $myPolygon  [list               -outline blue   -fill gray80    -width 0.1      -tags __ToolShape__]
        #
    set shape_zx    [$objTube getView Debug_ZX]
    set myPolygon       [vectormath::addVectorCoordList     $pos_XZ     $shape_zx]
    set myPolygon       [vectormath::addVectorCoordList     {0 50}     $myPolygon]
    $cvObject  create polygon   $myPolygon  [list               -outline blue    -fill gray80    -width 0.1      -tags __ToolShape__]
        #
        #
        
    return
        #
        #
        #
    if 0 {    
            #
        set tubeDictionary  [model::getDictionary]    
            #
            # appUtil::pdict $tubeDictionary
            #
            #
        array set pos {}
        set pos(TubeOrigin) $position
            # set pos(TubeEnd)    [vectormath::addVector      $pos(TubeOrigin) {0 1} [expr -1.0 * $lengthTube]]
            #
            #
        return    
            
            
        if {$viewMiter eq {right}} {
            set angleToolView   $angleTool
            set dir_Tool        [vectormath::dirCarthesian [expr 270 - $angleTool]]
        } else {
            set angleToolView   [expr 0 - $angleTool]
            set dir_Tool        [vectormath::dirCarthesian [expr 270 + $angleTool]]
        }
            #
        set pos(ToolOrigin) [vectormath::addVector      $pos(TubeOrigin) $dir_Tool [expr -1.0 * $lengthOffset_z]]  
        set pos(ToolEnd)    [vectormath::addVector      $pos(ToolOrigin) $dir_Tool $lengthTool]  
            #
            #
        set shape_Tool      [control::getToolShape]
        set shape_Origin    [vectormath::addVectorCoordList $pos(TubeOrigin) $shape_Tool]
        set shape_Origin    [vectormath::rotateCoordList    $pos(TubeOrigin) $shape_Origin  [expr 180 - $angleToolView]]
        set shape_End       [vectormath::addVectorCoordList $pos(TubeEnd)    $shape_Tool]
        set shape_End       [vectormath::rotateCoordList    $pos(TubeEnd)    $shape_End                 $angleToolView ]
            #
        set dir_Tube        [vectormath::dirCarthesian [expr 90 + $angleTool]]
            #
            #
        set profile_Origin  [$miterObject getProfile  Origin  right   $viewMiter]
        set profile_Origin  [vectormath::rotateCoordList    {0 0} $profile_Origin 90]
        set profile_Origin  [vectormath::addVectorCoordList $pos(TubeOrigin) $profile_Origin]
            #
        set profile_End     [$miterObject getProfile  End     right   $viewMiter]
        set profile_End     [vectormath::rotateCoordList    {0 0} $profile_End    90]
        set profile_End     [vectormath::addVectorCoordList $pos(TubeEnd) $profile_End]
            #
        set shapeTube       [join "$profile_Origin $profile_End" " "]
            #
            #
            #
        $cvObject  create polygon       $shape_Origin       [list -tags __ToolShape__  -outline red    -fill gray80 -width 0.1]
        $cvObject  create polygon       $shape_End          [list -tags __ToolShape__  -outline red    -fill gray80 -width 0.1]
            #
            #
        if {$profile_Origin eq {}} {
            puts "   -> \$profile_Origin  $profile_Origin  ... leer"
            puts "   -> \$profile_End     $profile_End  ... leer"
            return
        }    
            #
        $cvObject  create polygon       $shapeTube          [list -tags __TubeShape__  -outline blue    -fill gray80 -width 0.1]
            # $cvObject  create polygon $profile_Origin     -tags __TubeShape__  -outline blue    -fill gray80 -width 0.1
            # $cvObject  create polygon $profile_End        -tags __TubeShape__  -outline blue    -fill gray80 -width 0.1
            #
            #
        $cvObject  create centerline    [list $pos(TubeOrigin) $pos(TubeEnd)]   [list -fill orange    -width 0.035     -tags __CenterLine__]
        $cvObject  create circle        $pos(TubeEnd)       [list -radius  1       -outline orange    -width 0.035     -tags __CenterLine__]
        $cvObject  create circle        $pos(TubeOrigin)    [list -radius  1       -outline orange    -width 0.035     -tags __CenterLine__]
            #
        $cvObject  create centerline    [list $pos(ToolOrigin) $pos(ToolEnd)]   [list -fill orange    -width 0.035     -tags __CenterLine__]
        $cvObject  create circle        $pos(ToolEnd)       [list -radius  1       -outline orange    -width 0.035     -tags __CenterLine__]
        $cvObject  create circle        $pos(ToolOrigin)    [list -radius  1       -outline orange    -width 0.035     -tags __CenterLine__]
            #
            #
        return    
            #
    }
        #
}
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
     
        scale   $w.scl    -width        12 \
                        -length       120 \
                        -bd           1  \
                        -sliderlength 15 \
                        -showvalue    0  \
                        -orient       horizontal \
                        -command      "control::update" \
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
    set cvObject    [cad4tcl::new  $f_board  800 600  A1  1.0  25]
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

        #
        ### -- G U I - canvas demo
    # set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings"]
        #
    # pack  $f_settings  -side top -expand yes -fill both
    
        #
    labelframe  $f_config.f_tubeDef       -text tubeDefinition
    labelframe  $f_config.f_guideDef      -text guideDef
    labelframe  $f_config.f_pathLeft      -text pathLeft
    labelframe  $f_config.f_view          -text view
    labelframe  $f_config.precision       -text precision
    labelframe  $f_config.scale           -text scale

        # labelframe  $f_config.centerline      -text centerline
        # labelframe  $f_config.font            -text font
        # labelframe  $f_config.demo            -text demo
        #
    pack    $f_config.f_tubeDef  \
            $f_config.f_guideDef \
            $f_config.f_pathLeft \
            $f_config.f_view     \
            -fill x -side top 

        #
    radiobutton     $f_config.f_tubeDef.tube_01       -text "default             "  -variable  "control::tubeKey"     -value  "1"       -command   "control::update"
    radiobutton     $f_config.f_tubeDef.tube_02       -text "DownTube - MAXL12650"  -variable  "control::tubeKey"     -value  "2"       -command   "control::update"
    radiobutton     $f_config.f_tubeDef.tube_03       -text "TopTube - MAXL11600"   -variable  "control::tubeKey"     -value  "3"       -command   "control::update"
    radiobutton     $f_config.f_tubeDef.tube_04       -text "ChainStay - MAXL14OV"  -variable  "control::tubeKey"     -value  "4"       -command   "control::update"
    radiobutton     $f_config.f_tubeDef.tube_05       -text "debug - 01"            -variable  "control::tubeKey"     -value  "5"       -command   "control::update"
    radiobutton     $f_config.f_tubeDef.tube_06       -text "debug - 02"            -variable  "control::tubeKey"     -value  "6"       -command   "control::update"

    pack      \
            $f_config.f_tubeDef.tube_01 \
            $f_config.f_tubeDef.tube_02 \
            $f_config.f_tubeDef.tube_03 \
            $f_config.f_tubeDef.tube_04 \
            $f_config.f_tubeDef.tube_05 \
            $f_config.f_tubeDef.tube_06 \
            -side top
        
        
        #
        # view::create_config_line $f_config.f_guideDef.i_00  "init (i) length:  "    control::contrSeg_l00      5 100    ;#   0
        # view::create_config_line $f_config.f_guideDef.l_02  "line (l) length:  "    control::contrSeg_l02     20 150    ;#   0
        # view::create_config_line $f_config.f_guideDef.l_04  "line (l) length:  "    control::contrSeg_l04     20 150    ;#   0
        # view::create_config_line $f_config.f_guideDef.l_06  "line (l) length:  "    control::contrSeg_l06     20 150    ;#   0
        # view::create_config_line $f_config.f_guideDef.a_01  "arc (a) angle  :  "    control::contrSeg_a01    -90  90    ;#   0
        # view::create_config_line $f_config.f_guideDef.a_03  "arc (a) angle  :  "    control::contrSeg_a03    -90  90    ;#   0
        # view::create_config_line $f_config.f_guideDef.a_05  "arc (a) angle  :  "    control::contrSeg_a05    -90  90    ;#   0
        # view::create_config_line $f_config.f_guideDef.r_01  "arc (a) radius :  "    control::contrSeg_r01    -20 100    ;#   0
        # view::create_config_line $f_config.f_guideDef.r_03  "arc (a) radius :  "    control::contrSeg_r03    -20 100    ;#   0
        # view::create_config_line $f_config.f_guideDef.r_05  "arc (a) radius :  "    control::contrSeg_r05    -20 100    ;#   0
        #
        # view::create_config_line $f_config.f_pathLeft.x_01  "left (x01):       "    control::profile_x01       0 150    ;#  10    
        # view::create_config_line $f_config.f_pathLeft.x_02  "left (x02):       "    control::profile_x02       0 150    ;#  30    
        # view::create_config_line $f_config.f_pathLeft.x_03  "left (x03):       "    control::profile_x03       0 150    ;# 130    
        # view::create_config_line $f_config.f_pathLeft.x_04  "left (x04):       "    control::profile_x04       0 150    ;#  90    
        # view::create_config_line $f_config.f_pathLeft.y_01  "left (y01):       "    control::profile_y01       0  40    ;#  10    
        # view::create_config_line $f_config.f_pathLeft.y_02  "left (y02):       "    control::profile_y02       0  40    ;#  15    
        # view::create_config_line $f_config.f_pathLeft.y_03  "left (y03):       "    control::profile_y03       0  40    ;#  20    
        # view::create_config_line $f_config.f_pathLeft.y_04  "left (y04):       "    control::profile_y04       0  40    ;#  15                 
        #  
        #
                
        #
        ### -- G U I - canvas demo
        #   
    frame  $f_config.f_view.f_debug
    label           $f_config.f_view.f_debug.debug_label    -text "debug:   "
    radiobutton     $f_config.f_view.f_debug.debug_on       -text "on     "  -variable  "control::debugMode"     -value  "on"        -command   "control::update"
    radiobutton     $f_config.f_view.f_debug.debug_off      -text "off    "  -variable  "control::debugMode"     -value  "off"       -command   "control::update"

    pack      \
            $f_config.f_view.f_debug.debug_label \
            $f_config.f_view.f_debug.debug_on \
            $f_config.f_view.f_debug.debug_off \
            -side left
            
            
    button  $f_config.f_view.bt_clear   -text "clear"    -command {$::view::cvObject deleteContent} 
    button  $f_config.f_view.bt_update  -text "update"   -command {control::update}
     
    view::create_config_line $f_config.f_view.prec    " precision:      "    control::arcPrecision  1.0  10.0   ;#  24
                        $f_config.f_view.prec.scl     configure   -resolution 1.0

    view::create_config_line $f_config.f_view.drw_scale    " Drawing scale    "   control::drw_scale       0.2   2.0  
    view::create_config_line $f_config.f_view.cv_scale     " Canvas scale     "   control::cv_scale        0.2   5.0  
                        $f_config.f_view.drw_scale.scl     configure   -resolution 0.1     -command {control::scale_board}
                        $f_config.f_view.cv_scale.scl      configure   -resolution 0.1     -command {control::scale_board}
    button              $f_config.f_view.refit             -text "refit"                   -command {control::refit_board}

        # button        $f_config.scale.recenter          -text "recenter"                -command {control::recenter_board}
    
    
    pack      \
            $f_config.f_view.f_debug   \
            $f_config.f_view.bt_clear  \
            $f_config.f_view.bt_update \
            $f_config.f_view.prec      \
            $f_config.f_view.drw_scale \
            $f_config.f_view.cv_scale  \
            $f_config.f_view.refit     \
         -side top  -expand yes  -fill x                                                          
                     
     
        #
        ### -- G U I - canvas print
        #    
        # set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
        #      button  $f_print.bt_print   -text "print"  -command {$view::stageCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
         
        # pack $f_print   -side top   -expand yes -fill x
        # pack $f_print.bt_print      -expand yes -fill x
    

    
        ####+### F I N A L I Z E
    
    update
    
    wm minsize . [winfo width  .]   [winfo height  .]
    wm title   . $windowTitle
    
        ####+### E N D
    
    return . $stageCanvas

}
    #
    #
    # -- INIT --
    #
model::init
    #
set returnValues [view::create $WINDOW_Title]
    #
control::refit_board
    #
control::update
    # 
$view::cvObject fit
    #
    #

# $::view::stageNamespace reportXMLRoot
        
            
   
 
 

 