 ##+##########################################################################
 #
 # test_customTube_OO.tcl
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
    variable tubeDictionary             {}
    variable profileRoundDictionary     {}
    variable profileSqueezeDictionary   {}
    variable segmentPathDictionary      {}
    variable shapeRoundDictionary       {}
    variable debugDictionary            {}
    variable arcPrecision              0.5
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
        #variable unbentShape
        #variable profileDef {}
        #     set profileDef {{0 7} {10 7} {190 9} {80 9} {70 12}}
        #     set profileDef {{0 9} {10 7} {190 16} {80 16} {70 24}}
        #     set profileDef {{0 7} {10 7} {190 16} {80 16} {70 24}}
        #
}    
    


    #
    # -- MODEL --
proc model::init {} {
        #
    variable tubeDictionary
        #
    variable segmentPathDictionary
    variable profileRoundDictionary
    variable profileSqueezeDictionary
    variable shapeRoundDictionary
    variable anyDictionary
        #
    variable debugDictionary    
        #
    set tubeDictionary              [dict create]
        #
        #
    create_SegmentDictionary        [list  l 50  a {30 40}  l 100  a {40 60}  l 100  a {20 -40}  l 100]
        #
    create_ProfileRoundDictionary   [list  0 10  10 10  30 15  130 20  90 15  10 15]
        #
    create_ProfileSqueezeDictionary [list  0 5  50 10  100 10]
        #
    Update
        #
    return
        #
}
    #
proc model::Update {} {
        #
    variable tubeDictionary
        #
    variable segmentPathDictionary
    variable profileRoundDictionary
    variable profileSqueezeDictionary
    variable shapeRoundDictionary
    variable anyDictionary
        #
    variable debugDictionary    
        #
    set tubeDictionary          [dict create]
        #
        #
    update_InsideLengths
        #
    update_SegmentOutline
        #
    update_ShapeRoundDictionary
        #
    create_AnyDictionary
        #      
        #
    dict append tubeDictionary profileRound     $profileRoundDictionary
    dict append tubeDictionary profileSqueeze   $profileSqueezeDictionary
    dict append tubeDictionary segmentPath      $segmentPathDictionary
    dict append tubeDictionary shapeRound       $shapeRoundDictionary
    # dict append tubeDictionary shapeSqueeze $shapeSqueezeDictionary
    dict append tubeDictionary any              $anyDictionary       
        #
    return $tubeDictionary
        #
}
    #
proc model::setCenterLine {lineDef} {
        #
    create_SegmentDictionary    $lineDef
        #
    Update
        #
    return 
        #
}
proc model::setProfileRound {profileDef} {
        #
    create_ProfileRoundDictionary    $profileDef
        #
    Update
        #
    return 
        #
}
proc model::setProfileSqueeze {profileDef} {
        #
    create_ProfileSqueezeDictionary $profileDef
        #
    Update
        #
    return 
        #
}
proc model::setArcPrecission {value} {
    #
variable arcPrecision
set arcPrecision $value
    #
}
    #
proc model::getProfileProperty {length} {
        #
    # puts "\n    control::getProfileProperty $length"
        #
    variable profileRoundDictionary
        #
    # appUtil::pdict $profileRoundDictionary 1 "        "
        #
    set indexList       [lsort -real [dict keys $profileRoundDictionary]]
    set x_Start         [lindex $indexList 0]
    set x_End           [lindex $indexList end]
    set indexList       [lrange $indexList 1 end]
        #
    set dictSegement    [dict get $profileRoundDictionary $x_End]
    set off_End         [dict get $dictSegement      off_End]
    set k_End           0
        #
    foreach x_End $indexList {
            # puts "      search: $x_Start <= $length < $x_End"
        if {$x_Start <= $length && $length < $x_End} {
            # puts "      found: $x_Start <= $length < $x_End"
            set dictSegement    [dict get $profileRoundDictionary $x_Start]
            set k   [dict get $dictSegement k]
            set d   [dict get $dictSegement d]
            set offset [expr $length * $k + $d]
            # puts "             -> got: $offset"
            # puts "    <D> getProfileProperty $length: $offset $k"
            return [list $offset $k]
        }
        set x_Start $x_End
    }
        #
    return [list $off_End $k_End]
        #
}
proc model::getDictionary {} {
        #
    variable tubeDictionary
    return $tubeDictionary
        #
}
    #
proc model::create__lineDict {pos direction length lengthSummary} {
        #
    # puts "\n    model::create__lineDict $direction $length $lengthSummary"
        #
    set myDict      [dict create]
        #
    # ===============================================
        #
    set pos_Start   $pos
        #
    set vct_Dir     $direction
        #
    set lng_End     [expr $lengthSummary + $length]
        #
    set pos_End     [vectormath::addVector $pos_Start $direction $length]
        #
    foreach {dir_x dir_y} $direction break
        set x   [expr -1.0 * $dir_y]
        set y   $dir_x
    set vct_Perp    [list $x $y]
        #
    # ===============================================
        #
        # -- type ----------
    dict set myDict type    line
        #
        # -- pos_Start -----
    dict set myDict start   position    [list $pos_Start]
        #
        # -- lng_Start -----
    dict set myDict start   length      $lengthSummary
        #
        # -- vct_Dir -------
    dict set myDict start   vct_Dir     [list $vct_Dir]
        #
        # -- vct_Perp ------
    dict set myDict start   vct_Perp    [list $vct_Perp]
        #
        # -- lng_Segment -------
    dict set myDict inside  lengths     $length
        #
        # -- lng_End -------
    dict set myDict end     length      $lng_End
        #
        # -- pos_End -------
    dict set myDict end     position    [list $pos_End]
        #
        # -- vct_Dir -------
    dict set myDict end     vector      [list $vct_Dir]
        #
        # -- vct_Perp ------
    dict set myDict end     vector_Perp [list $vct_Perp]
        #
        # -- return to continue at this position
    return [list $myDict $lng_End $pos_End $vct_Dir]
        #
}
proc model::create__arcDict {pos direction radius angle lengthSummary} {
        #
    # puts "\n    model::create__arcDict $direction $radius $angle $lengthSummary"
        #
        #
    set myDict  [dict create]
        #
    # ===============================================
        #
    set pos_Start   $pos
        #
    set radius      [expr abs($radius)]
        #
    set vct_Perp    [vectormath::perpendicular_local $direction 1]
        #
    set radius      [expr abs($radius)]
        #
    if {$angle < 0} {
        set pos_Center  [vectormath::addVector $pos_Start $vct_Perp [expr -1.0 * $radius]]
    } else {
        set pos_Center  [vectormath::addVector $pos_Start $vct_Perp [expr  1.0 * $radius]]
    }
        #
    set lng_Arc     [expr abs($radius * $angle) * $vectormath::CONST_PI / 180.0]
        #
    set lng_End     [expr $lengthSummary + $lng_Arc]
        #
    set dir_Start   [vectormath::localVector_2_Degree $direction]
        #
    set pos_End     [vectormath::rotatePoint $pos_Center $pos_Start $angle]
        #
    set vct_End     [vectormath::rotatePoint {0 0} $direction $angle]
        #
    set dir_End     [vectormath::localVector_2_Degree $vct_End]
        #
    # ===============================================
        #
        # -- type ----------
    dict set myDict type    arc
        #
        # -- radius --------
    dict set myDict def     radius      $radius
        #
        # -- angle ---------
    dict set myDict def     angle       $angle
        #
        # -- pos_Start -----
    dict set myDict start   position    [list $pos_Start]
        #
        # -- vct_Start -----
    dict set myDict start   vector      [list $direction]
        #
        # -- dir_Start -----
    dict set myDict start   angle       $dir_Start
        #
        # -- lng_Start -----
    dict set myDict start   length      $lengthSummary
        #
        # -- lng_Arc -------
    dict set myDict inside  length_Arc  $lng_Arc
        #
        # -- pos_Center ----
    dict set myDict inside  pos_Center  [list $pos_Center]
        #
        # -- lng_End -------
    dict set myDict end     length      $lng_End
        #
        # -- pos_End -------
    dict set myDict end     position    [list $pos_End]
        #
        # -- vct_End -------
    dict set myDict end     vector      [list $vct_End]
        #
        # -- dir_End -------
    dict set myDict end     angle       $dir_End
        #
        # -- return to continue at this position
    return [list $myDict $lng_End $pos_End $vct_End]
        #
}
proc model::create__profileSegmentDict {length offset_01 lengthOffset offset_02} {
        #
    # puts "\n    model::create__profileSegmentDict $length $offset_01 $lengthOffset $offset_02"
        #
    set myDict      [dict create]
        #
        #
        # -- lng_Start -----
    dict append     myDict  lng_Start   $length
        #
        #
        # -- lengthOffset --
    dict append     myDict  lng_Offset  $lengthOffset
        #
        #
        # -- lng_End -------
    set lng_End     [expr $length + $lengthOffset]
    dict append     myDict  lng_End     $lng_End
        #
        #
        # -- off_Start -----
    dict append     myDict  off_Start   $offset_01
        #
        #
        # -- off_End -------
    dict append     myDict  off_End     $offset_02
        #
        #
        # -- k -------------
    set k           [expr 1.0 * ($offset_02 - $offset_01) / $lengthOffset]
    dict append     myDict  k           $k
        #
        #
        # -- d -------------
    set d           [expr 1.0 * ($offset_01 - $k * $length)]
    dict append     myDict  d           $d
        #
        #
        # -- debug ---------
        # appUtil::pdict  $myDict 2 "      "
        #
        #
        # -- return to continue at this position
    return [list $myDict $lng_End $offset_02]
        #    
}
proc model::create__bezierCurve {pos_Center pos_Start post_Tangent posEnd}  {
        #
        # http://stackoverflow.com/questions/1734745/how-to-create-circle-with-b%C3%A9zier-curves
        # for Bezier curve with n segments the optimal distance to the control points, 
        # in the sense that the middle of the curve lies on the circle itself, 
        # is (4/3)*tan(pi/(2n)).
}
proc model::create_SegmentDictionary {lineDef} {
        #
    # puts "\n    model::create_SegmentDictionary $lineDef"
        #
    variable segmentPathDictionary
    set segmentPathDictionary    [dict create]
        #
    set myLength               0
    set myPosition          {0 0}
    set myDirVector         {1 0}
        #
    set i   0    
        #
    foreach {type value} $lineDef {
        switch -exact $type {
            l {     # puts    "       line: $value"
                    # writeReport    "       line: $value"
                    #  puts "model::create_SegmentDictionary l-1: xy: $myPosition  /  xy: $myDirVector  /  x: $value  /  $myLength "
                set retVal [model::create__lineDict $myPosition $myDirVector $value $myLength]
                foreach {lineDict myLength myPosition myDirVector} $retVal break
                dict append segmentPathDictionary $i $lineDict
                incr i
                    #  puts "model::create_SegmentDictionary l-2: x: $myLength  -  xy: $myPosition  -  xy: $myDirVector"
            }
            a {     # puts    "       arc:  $value"
                    # writeReport    "       arc:  $value"
                    #  puts "model::create_SegmentDictionary a-1: xy: $myPosition  /  xy: $myDirVector  /  xy: $value  /  $myLength "
                foreach {radius angle} $value break
                set retVal [model::create__arcDict  $myPosition $myDirVector $radius $angle $myLength]
                foreach {arcDict  myLength myPosition myDirVector} $retVal break
                dict append segmentPathDictionary $i $arcDict
                incr i
                    #  puts "model::create_SegmentDictionary a-2: x: $myLength  -  xy: $myPosition  -  xy: $myDirVector"
            }
            default {
                    # puts    "       <E>: $type not defined "
                    # writeReport    "       <E>: $type not defined "
            }
        }
    }
        #
    # puts "\n    -> \$segmentPathDictionary"
    # appUtil::pdict $segmentPathDictionary 1 "        "    
        #
    return
        #
}
proc model::create_ProfileRoundDictionary {profileDef} {
        #
    # puts "\n    model::create_ProfileRoundDictionary $profileDef"
        #
    variable profileRoundDictionary
        #
    set profileRoundDictionary       [dict create]
            #
    set profileDefinition       [lrange $profileDef 2 end]
        #
        # puts "\n-> \$profileDef $profileDef"
    set x_last 0
    foreach {x y} $profileDef {
        set x_last [expr $x_last + $x]
        # puts "    ----> $x $y   <- $x_last"
    }
        #
    foreach {x_last y_last}   [lrange $profileDef 0 1] break
    set myLength                $x_last
        #
    foreach {x_extend y} $profileDefinition {
            # puts "\n"
            # puts "       -> $x_last $y_last "
            # puts "       ----> $x_extend"
        set x           [expr $x_last + $x_extend]
            # puts "       -> $x   $y  -> [expr $x - $x_last]"
        set retValue    [create__profileSegmentDict $x_last $y_last $x_extend $y]
        foreach {profileDict x_last y_last} $retValue break
            # puts "       ----> $x_last   $y_last"
        dict append profileRoundDictionary $myLength $profileDict
        set myLength    $x_last
    }
        # 
    # puts "\n    -> \$profileRoundDictionary"
    # appUtil::pdict $profileRoundDictionary 1 "        "    
        #
    return
        #
}
proc model::create_ProfileSqueezeDictionary {profileDef} {
        #
    # puts "\n    model::create_ProfileSqueezeDictionary $profileDef"
        #
    variable profileSqueezeDictionary
        #
    set profileSqueezeDictionary    [dict create]
            #
    set profileDefinition           [lrange $profileDef 2 end]
        #
    set x_last 0
    foreach {x y} $profileDef {
        set x_last  [expr $x_last + $x]
    }
        #
    foreach {x_last y_last}     [lrange $profileDef 0 1] break
    set myLength                $x_last
        #
    foreach {x_extend y} $profileDefinition {
        set x           [expr $x_last + $x_extend]
        set retValue    [create__profileSegmentDict $x_last $y_last $x_extend $y]
        foreach {profileDict x_last y_last} $retValue break
        dict append profileSqueezeDictionary $myLength $profileDict
        set myLength    $x_last
    }
        #
    return $profileSqueezeDictionary
        #
}
proc model::create_AnyDictionary {} {
        #
    # puts "\n    model::create_ProfileRoundDictionary $profileDef"
        #
    variable segmentPathDictionary    
    variable profileRoundDictionary
        #
    variable anyDictionary    
    set anyDictionary       [dict create]
        #
    return
        #
}
proc model::create_DebugDictionary {} {
        #
    # puts "\n    model::create_DebugDictionary"
        #
    variable segmentPathDictionary
    variable profileRoundDictionary
    variable debugDictionary
        #
    variable arcPrecision
        #
    set debugDictionary         [dict create]
        #
    set dict_centerLine $segmentPathDictionary
    set dict_profile    $profileRoundDictionary
        # set dict_centerLine [dict get $tubeDictionary   centerLine]
        # set dict_profile    [dict get $tubeDictionary   profile]
        #
    # puts "\n -- <D> -- segmentPathDictionary\n"
    # appUtil::pdict $segmentPathDictionary
    # puts "\n -- <D> -- profileRoundDictionary\n"
    # appUtil::pdict $profileRoundDictionary
    # puts "\n -- <D> --\n"           
        #
        #
    set shapeLeft   {}
    set shapeRight  {}
    set kLeft       {}
    set kRight      {}
        #
        #
    foreach key [dict keys $segmentPathDictionary] {
        set keyDict     [dict get $segmentPathDictionary $key]
        set def_Type    [dict get $keyDict type]
            # puts "---> $def_Type"
        set myLeft  {}
        set myRight {}
        switch -exact $def_Type {
            line {      # puts "       line: ($key)"
                        # appUtil::pdict $keyDict 1 "        "
                    set lng_Start   [dict get $keyDict start    length]
                    set lng_End     [dict get $keyDict end      length]
                    set lng_Inside  [dict get $keyDict inside   lengths]
                        #
                    set pos_Start   [join [dict get $keyDict start  position]   " "]
                    set pos_End     [join [dict get $keyDict end    position]   " "]
                        #
                    set vct_Dir     [join [dict get $keyDict end    vct_Dir]    " "]
                    set vct_Perp    [join [dict get $keyDict end    vct_Perp]   " "]
                        #
                        # ---- start -----
                    set profileOffset       [lindex [getProfileProperty $lng_Start] 0]
                    set pnt_ShapeLeft       [vectormath::addVector $pos_Start $vct_Perp $profileOffset]
                    set pnt_ShapeRight      [vectormath::addVector $pos_Start $vct_Perp [expr -1.0 * $profileOffset]]
                        # puts "             -> $lng_Start -> $profileOffset  -->  $pnt_ShapeLeft / $pnt_ShapeRight"
                    lappend shapeLeft       $pnt_ShapeLeft
                    lappend shapeRight      $pnt_ShapeRight
                        #
                        # ---- inside ----
                    foreach lng [join $lng_Inside " "] {
                            puts "            ------> lng: $lng"
                        set profileOffset   [lindex [getProfileProperty $lng] 0]
                        set lng_Extend      [expr $lng - $lng_Start]
                        set pos             [vectormath::addVector $pos_Start $vct_Dir  $lng_Extend]
                        set pnt_ShapeLeft   [vectormath::addVector $pos       $vct_Perp $profileOffset]
                        set pnt_ShapeRight  [vectormath::addVector $pos       $vct_Perp [expr -1.0 * $profileOffset]]
                            # puts "             -> $lng -> $profileOffset  -->  $pnt_ShapeLeft / $pnt_ShapeRight"
                        lappend shapeLeft   $pnt_ShapeLeft
                        lappend shapeRight  $pnt_ShapeRight
                    }
                        #
                        # ---- end ------
                    set profileOffset       [lindex [getProfileProperty $lng_End] 0]   
                    set pnt_ShapeLeft       [vectormath::addVector $pos_End   $vct_Perp $profileOffset]
                    set pnt_ShapeRight      [vectormath::addVector $pos_End   $vct_Perp [expr -1.0 * $profileOffset]]
                        # puts "             -> $lng_End -> $profileOffset  -->  $pnt_ShapeLeft / $pnt_ShapeRight"
                    lappend shapeLeft       $pnt_ShapeLeft
                    lappend shapeRight      $pnt_ShapeRight
                        #
                }
            arc {       # puts "       arc: ($key)"
                        # appUtil::pdict $keyDict 1 "        "
                    set angle       [dict get $keyDict def  angle]
                        #
                    set lng_Start   [dict get $keyDict start    lenght]
                    set lng_End     [dict get $keyDict end      lenght]
                    set lng_Arc     [dict get $keyDict inside   lenght_Arc]
                        #
                    set pos_Start   [join [dict get $keyDict start  position]  " "]
                    set pos_Center  [join [dict get $keyDict inside position] " "]
                    set pos_End     [join [dict get $keyDict end    position]    " "]
                        #
                    set segCount    [expr round($lng_Arc * $arcPrecision)]
                    if {$segCount < 1} {set segCount 1} 
                        #
                    set segAngle    [expr 1.0 * $angle/$segCount]
                    set segLength   [expr 1.0 * $lng_Arc/$segCount]
                        #
                        # ---- angle -----
                    if {$angle < 0} {
                        set orient -1
                    } else {
                        set orient  1
                    }
                        # puts "             ---> \$angle ->     $angle"
                        # puts "             ---> \$segCount ->  $segCount"
                        # puts "             ---> \$segAngle ->  $segAngle"
                        # puts "             ---> \$segLength -> $segLength"
                        # puts "             ---> \$orient ->    $orient"
                        #
                        # ---- start -----
                    set vct_Center          [vectormath::unifyVector $pos_Start $pos_Center $orient]
                    set profileOffset       [lindex [getProfileProperty $lng_Start] 0]
                        #
                    set pnt_ShapeLeft       [vectormath::addVector $pos_Start $vct_Center $profileOffset]
                    set pnt_ShapeRight      [vectormath::addVector $pos_Start $vct_Center $profileOffset]
                    lappend shapeLeft       $pnt_ShapeLeft
                    lappend shapeRight      $pnt_ShapeRight
                        # puts "             -> $lng_Start -> $profileOffset  -->  $pnt_ShapeLeft / $pnt_ShapeRight"
                        #
                    set vct_Pos             [vectormath::unifyVector $pos_Start [vectormath::rotatePoint $pos_Start $pos_Center -90]]    
                    set k_ShapeLeft         [get_profileK $lng_Start]
                    set k_ShapeRight        [expr $k_ShapeLeft * -1.0]
                        #set 
                    lappend kLeft           [list $pnt_ShapeLeft  $vct_Pos $k_ShapeLeft]
                    lappend kRight          [list $pnt_ShapeRight $vct_Pos $k_ShapeRight]
                            #
                        # ---- inside ----
                    set lng         [expr $lng_Start + $segLength]
                    set pos_Last    $pos_Start
                    set i           1
                    while {$i < $segCount} {
                        set pos             [vectormath::rotatePoint $pos_Center $pos_Last $segAngle]
                            #
                        set vct_Center      [vectormath::unifyVector $pos $pos_Center $orient]
                        set profileOffset   [lindex [getProfileProperty $lng] 0]
                            #
                        set pnt_ShapeLeft   [vectormath::addVector $pos       $vct_Center [expr $profileOffset * $orient]]
                        set pnt_ShapeRight  [vectormath::addVector $pos       $vct_Center [expr $profileOffset * $orient * -1.0]]
                        lappend shapeLeft   $pnt_ShapeLeft
                        lappend shapeRight  $pnt_ShapeRight
                            #
                        set vct_Pos         [vectormath::unifyVector $pos [vectormath::rotatePoint $pos $pos_Center -90]]    
                        set k_ShapeLeft     [get_profileK $lng]
                        set k_ShapeRight    [expr $k_ShapeLeft * -1.0]
                        lappend kLeft       [list $pnt_ShapeLeft  $vct_Pos $k_ShapeLeft]
                        lappend kRight      [list $pnt_ShapeRight $vct_Pos $k_ShapeRight]
                            #
                        set lng             [expr $lng + $segLength]
                        set pos_Last  $pos
                        incr i
                    }
                }
            default {
                    # puts "--> $def_Type <--"
            }
        }
    }    
        #
        #
    set 001 [dict create shapeLeft [list $shapeLeft] shapeRight [list $shapeRight] kLeft [list $kLeft] kRight [list $kRight]]
        #
    dict append debugDictionary 001 $001
        #            #
    puts "\n    -> \$debugDictionary"
    appUtil::pdict $debugDictionary 1 "        "
        #
    #exit
        #
    return
        #
}
proc model::update_InsideLengths {} {
        #
    # puts "\n    model::update_InsideLengths"
        #
    variable segmentPathDictionary
    variable profileRoundDictionary
        #
    # puts "\n -- <D> --\n"
    # appUtil::pdict $segmentPathDictionary  
    # puts "\n -- <D> --\n"
    # appUtil::pdict $profileRoundDictionary
    # puts "\n -- <D> --\n"
        #
        # -- get all centerline points (x) where shape changes, except belonging to arcs
        #
    set list_profile_x  [dict keys $profileRoundDictionary]
        #
        # puts "\n    -> \$list_profile_x:    $list_profile_x"
        #
    foreach key [dict keys $segmentPathDictionary] {
        set keyDict     [dict get $segmentPathDictionary $key]
        set def_Type    [dict get $keyDict type]
            # puts "      -> $key - $def_Type - $keyDict"
            # appUtil::pdict $keyDict
        if {$def_Type eq {line}} {
            set lng_Start   [dict get $keyDict start    length]
            set lng_End     [dict get $keyDict end      length]
            set lng_Inside  {}
            foreach value $list_profile_x {
                if {$lng_Start < $value && $value < $lng_End} {
                        # puts "      ---> $lng_Start < $value < $lng_End"
                    lappend lng_Inside $value 
                }
            }
            set lng_Inside  [lsort -unique -real $lng_Inside]
                #
            dict set    segmentPathDictionary $key inside   lengths [list $lng_Inside]
                #
        }
            # appUtil::pdict  $keyDict
    }
        #
    # puts "\n -- <D> --\n"
    # appUtil::pdict $segmentPathDictionary    
    # puts "\n -- <D> --\n"
        #
    return
        #
}
proc model::update_SegmentOutline {} {
        #
    # puts "\n    model::update_SegmentOutline"
        #
    variable segmentPathDictionary
        #
        #
        # -- get all centerline points (x) where shape changes, except belonging to arcs
        #
        # puts "\n    -> \$list_profile_x:    $list_profile_x"
        #
    foreach key [dict keys $segmentPathDictionary] {
        set keyDict     [dict get $segmentPathDictionary $key]
        set def_Type    [dict get $keyDict type]
            # puts "      -> $key - $def_Type - $keyDict"
            # appUtil::pdict $keyDict
        switch -exact $def_Type {
            line {
                set lng_Start         [dict get $keyDict start  length]
                set lng_End           [dict get $keyDict end    length]
                set lng_Inside        [dict get $keyDict inside lengths]
                    #
                set pos_Start   [join [dict get $keyDict start  position]       " "]
                set pos_End     [join [dict get $keyDict end    position]       " "]
                    #
                set vct_Dir     [join [dict get $keyDict end    vector]         " "]
                set vct_Perp    [join [dict get $keyDict end    vector_Perp]    " "]
                    #
                    # --------
                set crv_Left  {}
                set crv_Right {}
                set lengths "$lng_Start [join $lng_Inside " "] $lng_End"
                    #
                    # puts "    -> \$lng_Inside $lng_Inside"
                    # puts "    -> \$lengths $lengths"
                    #
                foreach lng $lengths {
                        # puts "            ------> lng: $lng"
                    set profileOffset   [lindex [getProfileProperty $lng] 0]
                    set lng_Extend      [expr $lng - $lng_Start]
                    set pos             [vectormath::addVector $pos_Start $vct_Dir  $lng_Extend]
                    set pnt_ShapeLeft   [vectormath::addVector $pos       $vct_Perp $profileOffset]
                    set pnt_ShapeRight  [vectormath::addVector $pos       $vct_Perp [expr -1.0 * $profileOffset]]
                        # puts "             -> $lng -> $profileOffset  -->  $pnt_ShapeLeft / $pnt_ShapeRight"
                    lappend crv_Left   $pnt_ShapeLeft
                    lappend crv_Right  $pnt_ShapeRight
                }
                    # puts "  -> \$crv_Left $crv_Left"
                    #
                dict set segmentPathDictionary $key shape left  [list [join $crv_Left  " "]]
                dict set segmentPathDictionary $key shape right [list [join $crv_Right " "]]
                    #
            }
            arc {
                    #
                set angle             [dict get $keyDict def    angle]
                set radius            [dict get $keyDict def    radius]
                set pos_Center  [join [dict get $keyDict inside pos_Center] " "]
                    # puts "\n"
                    # puts "      ----> \$angle       $angle"  
                    # puts "      ----> \$radius      $radius"  
                    # puts "      ----> \$pos_Center  $pos_Center"  
                    # puts ""
                if {$angle <= 0} {
                    set orient -1
                } else {
                    set orient  1
                }
                    #
                set lng_Start       [dict get $keyDict start    length]
                set pos_Start [join [dict get $keyDict start    position] " "]
                set vct_Start [join [dict get $keyDict start    vector]   " "]
                set dir_Start       [dict get $keyDict start    angle]
                set ret_Value       [getProfileProperty $lng_Start]
                foreach {off_Start k} $ret_Value break
                set vct_Perp        [vectormath::perpendicular_local $vct_Start 1]
                    # set vct_Perp        [vectormath::unifyVector $pos_Start $pos_Center $orient]
                set pos_StartLeft   [vectormath::addVector $pos_Start $vct_Perp $off_Start]
                set pos_StartRight  [vectormath::addVector $pos_Start $vct_Perp [expr $off_Start * -1.0]]
                    #
                set pos__StartLeft  [vectormath::addVector $pos_StartLeft  [vectormath::rotatePoint {0 0} [list 1 [expr  1.0 * $k]] $dir_Start]] 
                set pos__StartRight [vectormath::addVector $pos_StartRight [vectormath::rotatePoint {0 0} [list 1 [expr -1.0 * $k]] $dir_Start]] 
                    #
                    #
                    # puts "         -> \$lng_Start   $lng_Start  <- $ret_Value"  
                    # puts "                  \$pos_Start $pos_Start"
                    # puts "                  \$dir_Start $dir_Start"
                    # puts "                  \$off_Start $off_Start"
                    # puts "                  \$k         $k"
                    # puts "               ------------------------------------"
                    # puts "                  \$pos_StartLeft     $pos_StartLeft"
                    # puts "                  \$pos_StartRight    $pos_StartRight"
                    #
                dict set segmentPathDictionary $key start offset    $off_Start
                dict set segmentPathDictionary $key start k         $k
                dict set segmentPathDictionary $key start pos_Left  [list $pos_StartLeft]
                dict set segmentPathDictionary $key start pos_Right [list $pos_StartRight]
                    #
                    #
                    # puts "\n"
                    #
                set lng_End         [dict get $keyDict end      length]
                set pos_End   [join [dict get $keyDict end      position] " "]
                set vct_End   [join [dict get $keyDict end      vector]   " "]
                set dir_End         [dict get $keyDict end      angle]
                set ret_Value       [getProfileProperty $lng_End]
                foreach {off_End k} $ret_Value break
                set vct_Perp        [vectormath::perpendicular_local $vct_End 1]
                    # set vct_Perp      [vectormath::unifyVector $pos_End   $pos_Center $orient]
                set pos_EndLeft     [vectormath::addVector   $pos_End   $vct_Perp $off_End]
                set pos_EndRight    [vectormath::addVector   $pos_End   $vct_Perp [expr $off_End * -1.0]]
                    #
                set pos__EndLeft    [vectormath::addVector $pos_EndLeft    [vectormath::rotatePoint {0 0} [list 1 [expr  1.0 * $k]] $dir_End]] 
                set pos__EndRight   [vectormath::addVector $pos_EndRight   [vectormath::rotatePoint {0 0} [list 1 [expr -1.0 * $k]] $dir_End]]
                    #
                # puts "         -> \$lng_End     $lng_End  <- $ret_Value"
                # puts "                  \$pos_End   $pos_End"
                # puts "                  \$dir_End   $dir_End"
                # puts "                  \$off_End   $off_End"
                # puts "                  \$k         $k"
                # puts "               ------------------------------------"
                # puts "                  \$pos_EndLeft       $pos_EndLeft"
                # puts "                  \$pos_EndRight      $pos_EndRight"
                    #
                dict set segmentPathDictionary $key end   offset    $off_End
                dict set segmentPathDictionary $key end   k         $k
                dict set segmentPathDictionary $key end   pos_Left  [list $pos_EndLeft]
                dict set segmentPathDictionary $key end   pos_Right [list $pos_EndRight]
                    #
                    #
                set pos_TngtLeft    [vectormath::intersectPoint $pos_StartLeft  $pos__StartLeft  $pos_EndLeft  $pos__EndLeft    center]
                set pos_TngtRight   [vectormath::intersectPoint $pos_StartRight $pos__StartRight $pos_EndRight $pos__EndRight   center]
                    #
                    # puts ""
                    # puts "               ------------------------------------"
                    # puts "                  \$pos_TngtLeft    $pos_StartLeft -> $pos_TngtLeft <- $pos__EndLeft"
                    # puts "                  \$pos_TngtRight   $pos_StartRight -> $pos_TngtRight <- $pos__EndRight"
                    # puts ""
                    #
                dict set segmentPathDictionary $key inside pos_TangentLeft  [list $pos_TngtLeft]
                dict set segmentPathDictionary $key inside pos_TangentRight [list $pos_TngtRight]
                    #
                    #
                    # http://stackoverflow.com/questions/1734745/how-to-create-circle-with-b%C3%A9zier-curves
                    # for Bezier curve with n segments the optimal distance to the control points, 
                    # in the sense that the middle of the curve lies on the circle itself, 
                    # is (4/3)*tan(pi/(2n)).
                set n           [expr abs(360.0 / $angle)]
                set f_control   [expr (4.0/3) * tan($vectormath::CONST_PI/(2 * $n))]
                    # puts "    -> \$angle     $angle <- $vectormath::CONST_PI"
                    # puts "    -> \$n         $n"
                    # puts "    -> \$f_control $f_control   <- 0.552284749831"
                    #
                    # -- Start
                set l_control   [expr ($radius - $off_Start * $orient) * $f_control ]
                set pos_StartLeftControl    [vectormath::addVector $pos_StartLeft   [vectormath::unifyVector $pos_StartLeft  $pos_TngtLeft  $l_control]]
                set l_control   [expr ($radius + $off_Start * $orient) * $f_control ]
                 set pos_StartRightControl   [vectormath::addVector $pos_StartRight  [vectormath::unifyVector $pos_StartRight $pos_TngtRight $l_control]]
                    # puts "   \$l_control $l_control"
                    #
                dict set segmentPathDictionary $key start ctr_Factor        $f_control
                dict set segmentPathDictionary $key start pos_LeftCtrl      $pos_StartLeftControl
                dict set segmentPathDictionary $key start pos_RightCtrl     $pos_StartRightControl
                    #
                    # -- End
                set l_control   [expr ($radius - $off_End   * $orient) * $f_control ]
                set pos_EndLeftControl      [vectormath::addVector $pos_EndLeft     [vectormath::unifyVector $pos_EndLeft  $pos_TngtLeft  $l_control]]
                set l_control   [expr ($radius + $off_End   * $orient) * $f_control ]
                set pos_EndRightControl     [vectormath::addVector $pos_EndRight    [vectormath::unifyVector $pos_EndRight $pos_TngtRight $l_control]]
                    #
                dict set segmentPathDictionary $key end   ctr_Factor        $f_control
                dict set segmentPathDictionary $key end   pos_LeftCtrl      $pos_EndLeftControl
                dict set segmentPathDictionary $key end   pos_RightCtrl     $pos_EndRightControl
                    #
                    #
                set crv_Left    [model::bezier::create [join "$pos_StartLeft  $pos_StartLeftControl  $pos_EndLeftControl  $pos_EndLeft"  " "]]
                set crv_Right   [model::bezier::create [join "$pos_StartRight $pos_StartRightControl $pos_EndRightControl $pos_EndRight" " "]]
                    #
                dict set segmentPathDictionary $key shape left  [list $crv_Left]
                dict set segmentPathDictionary $key shape right [list $crv_Right]
                    #
            }
            default {}
        }
            # appUtil::pdict  $keyDict
    }
        #
    return
        #
}
proc model::update_ShapeRoundDictionary {} {
        #
    # puts "\n    model::update_ShapeRoundDictionary"
        #
    variable segmentPathDictionary
    variable shapeRoundDictionary
        #
    variable arcPrecision
        #
    # puts "\n -- <D> -- segmentPathDictionary\n"
    # appUtil::pdict $segmentPathDictionary
    # puts "\n -- <D> -- profileRoundDictionary\n"
    # appUtil::pdict $profileRoundDictionary
    # puts "\n -- <D> --\n"           
        #
        #
    set shapeLeft   {}
    set shapeRight  {}
        #
        #
    set init 1    
        #
    foreach key [dict keys $segmentPathDictionary] {
        set keyDict     [dict get $segmentPathDictionary $key]
        set def_Type    [dict get $keyDict type]
        set crv_Left    [dict get $keyDict shape left]
        set crv_Right   [dict get $keyDict shape right]
            #
        switch -exact $def_Type {
            line {  # puts "       line: ($key)"
                if $init {
                    lappend shapeLeft  [lrange [join $crv_Left  " "] 0 end-2]
                    lappend shapeRight [lrange [join $crv_Right " "] 0 end-2]
                    set init 0
                } else {
                    lappend shapeLeft  [lrange [join $crv_Left  " "] 2 end-2]
                    lappend shapeRight [lrange [join $crv_Right " "] 2 end-2]
                }
                    # used in next branch (arc)
                set pos_LeftLast    [lrange [join $crv_Left  " "] end-3 end-2]
                set pos_RightLast   [lrange [join $crv_Right " "] end-3 end-2]
            }
            arc {   # puts "       line: ($key)"
                set pos_StartLeft       [join [dict get $keyDict start  pos_Left]           " "]
                set pos_StartRight      [join [dict get $keyDict start  pos_Right]          " "]
                set pos_TangentLeft     [join [dict get $keyDict inside pos_TangentLeft]    " "]
                set pos_TangentRight    [join [dict get $keyDict inside pos_TangentRight]   " "]
                    #
                    # -- exception left
                if {[vectormath::length $pos_LeftLast  $pos_StartLeft]  < [vectormath::length $pos_LeftLast  $pos_TangentLeft]} {
                    lappend shapeLeft   [join $crv_Left         " "]
                } else {
                    lappend shapeLeft   [join $pos_TangentLeft  " "]
                }
                    #
                    # -- exception right
                if {[vectormath::length $pos_RightLast $pos_StartRight] < [vectormath::length $pos_RightLast $pos_TangentRight]} {
                    lappend shapeRight  [join $crv_Right        " "]
                } else {
                    lappend shapeRight  [join $pos_TangentRight " "]
                }
            }
            default {}
        }
    }
        #
        # use the last shape-points of the last segment, which is a line-segment
    lappend shapeLeft   [lrange [join $crv_Left  " "] end-1 end]
    lappend shapeRight  [lrange [join $crv_Right " "] end-1 end]
        #
        # reverse elements in shapeRight
    set _shapeRight $shapeRight
    set shapeRight {}
    foreach {x y} $_shapeRight {
        lappend shapeRight $x $y
    }
        # puts "   -> \$shapeLeft $shapeLeft"
        # puts "   -> \$shapeRight $shapeRight"
        #
    set shapeRoundDictionary [dict create shapeLeft [list $shapeLeft] shapeRight [list $shapeRight]]
        #
        # puts "\n    -> \$shapeRoundDictionary"
        # appUtil::pdict $shapeRoundDictionary 1 "        "
        #
    return
        #
}
    #
    # -- MODEL::bezier --
namespace eval \
     model::bezier {}
proc model::bezier::create {xy} {
        # puts "           -> $xy"
    # set PRECISION 8
    set np [expr {[llength $xy] / 2}]
    if {$np < 4} return
        #
    set idx 0
    foreach {x y} $xy {
        set X($idx) $x
        set Y($idx) $y
        incr idx
    }
        #
    set xy {}
        #
    set idx 0
    while {[expr {$idx+4}] <= $np} {
        set a [list $X($idx) $Y($idx)]; incr idx
        set b [list $X($idx) $Y($idx)]; incr idx
        set c [list $X($idx) $Y($idx)]; incr idx
        set d [list $X($idx) $Y($idx)];# incr idx   ;# use last pt as 1st pt of next segment
            #
        set est_Length [expr int([vectormath::length $a $b] + [vectormath::length $b $c] + [vectormath::length $c $d])]
            # puts "   -> \$PRECISION $PRECISION"
        if {$est_Length < 1} {
            set PRECISION 1
        } else {
            set PRECISION $est_Length
        }
            # puts "   -> \$PRECISION $PRECISION"
            #
        for {set j 0} {$j <= $PRECISION} {incr j} {
            set mu [expr {double($j) / double($PRECISION)}]
            set pt [_Spline $a $b $c $d $mu]
            lappend xy [lindex $pt 0] [lindex $pt 1]
        }
    }
        # puts "             -> $xy"
    return $xy
}
proc model::bezier::_Spline {a b c d mu} {
    # --------------------------------------------------------
    # http://www.cubic.org/~submissive/sourcerer/bezier.htm
    # evaluate a point on a bezier-curve. mu goes from 0 to 1.0
    # --------------------------------------------------------

    set  ab   [_Lerp $a    $b    $mu]
    set  bc   [_Lerp $b    $c    $mu]
    set  cd   [_Lerp $c    $d    $mu]
    set  abbc [_Lerp $ab   $bc   $mu]
    set  bccd [_Lerp $bc   $cd   $mu]
    return    [_Lerp $abbc $bccd $mu]
}
proc model::bezier::_Lerp {a b mu} {
    # -------------------------------------------------
    # http://www.cubic.org/~submissive/sourcerer/bezier.htm
    # simple linear interpolation between two points
    # -------------------------------------------------
    set ax [lindex $a 0]
    set ay [lindex $a 1]
    set bx [lindex $b 0]
    set by [lindex $b 1]
    return [list [expr {$ax + ($bx-$ax)*$mu}] [expr {$ay + ($by-$ay)*$mu}] ]
}
 

    #
    # -- CONTROL --
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
    puts "\n============================="
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
proc control::create_dictPath {cvObject pos pathDef tag} {
        #
    variable debugMode    
        #
    set myPosition      $pos
    set myTag           $tag
    set dict_centerLine $pathDef
        #
        #
    $cvObject  create   circle  $myPosition     [list -radius 5  -tags $myTag  -outline darkred  -width 0.1]
        #
        #
    set line_pointList      {}
    set center_pointList    {}
        #
    foreach key [lsort -integer [dict keys $dict_centerLine]] {
            # puts "\n    -> $key"
        set keyDict [dict get $dict_centerLine $key]
            # appUtil::pdict $keyDict
            #
        set pos_Start   [dict get $keyDict  start   position]
        set pos_End     [dict get $keyDict  end     position]
            #
        set type        [dict get $keyDict  type]
        if {$type eq {arc}} {
            set pos_Center  [dict get $keyDict  inside  pos_Center]
            lappend center_pointList [join $pos_Center  " "]
        }
            #
        if {$line_pointList eq {}} {
            lappend line_pointList   [join $pos_Start   " "]
        }
            #
        lappend     line_pointList   [join $pos_End     " "]
            #
    }
        #
        # puts "\n    -> $line_pointList\n"
        #
    set line_pointList [vectormath::addVectorPointList $pos $line_pointList]    
        #
        # puts "\n    -> $line_pointList\n"
        #
    $cvObject create   line    [join $line_pointList " "]  [list -tags {__cvElement__}  -fill darkgreen]
        #
        #
        # puts "\n    -> $center_pointList\n"
        #
    set center_pointList [vectormath::addVectorPointList $pos $center_pointList]    
        #
        # puts "\n    -> $center_pointList\n"
        #
    if {$debugMode eq {on}} {
        foreach pos_Center $center_pointList {
            $cvObject  create   circle      $pos_Center [list -radius 2  -tags $myTag  -outline darkred  -width 0.1]
        }
    }
    return    
        #
}
proc control::create_dictShape {cvObject pos shapeDef tag color} {
        #
    variable debugMode    
        #
    set tubeDictionary  [model::getDictionary]
        # set tubeDictionary  $model::tubeDictionary
        #
    set myPosition  $pos
    set myTag       $tag
        #
    set shapeLeft           [join [dict get $shapeDef shapeLeft]  " "]
    set shapeRight          [join [dict get $shapeDef shapeRight] " "]
        #
        #
    $cvObject  create   circle      $myPosition [list -radius 5  -tags $myTag  -outline darkred  -width 0.1]
        #
    set line_pointList      {}
    set center_pointList    {}
        #
        # puts "-->    control::create_dictShape"
        #
        #
        # puts $shapeLeft
        #
    set line_pointList [vectormath::addVectorPointList $pos $shapeLeft]    
        #
        # puts "\n    -> $line_pointList\n"
        #
    $cvObject create   line    [join $line_pointList " "]  [list -tags {__cvElement__}  -fill $color]
        #
    if {$debugMode eq {on}} {
        foreach xy $line_pointList {
            $cvObject  create   circle  $xy [list -radius 0.5  -tags $myTag  -outline darkred  -width 0.1]
        }
    }
        #
        #
        # puts $shapeRight
        #
    set line_pointList [vectormath::addVectorPointList $pos $shapeRight]    
        #
        # puts "\n    -> $line_pointList\n"
        #
    $cvObject create   line    [join $line_pointList " "]  [list -tags {__cvElement__}  -fill red]
        #
    if {$debugMode eq {on}} {
        foreach xy $line_pointList {
            $cvObject  create   circle  $xy [list  -radius 0.5  -tags $myTag  -outline darkred  -width 0.1]
        }
    }
        #
    return   
        #
}
proc control::create_Debug {cvObject pos tag} {
        #
    set tubeDictionary  [model::getDictionary]
        # set tubeDictionary  $model::tubeDictionary
        #
    set myPosition  $pos
    set myTag       $tag
        #
        #
    $cvObject  create   circle      $myPosition [list -radius 5  -tags $myTag  -outline darkred  -width 0.1]
        #
        # appUtil::pdict $tubeDictionary
        #
    set segment_Dictionary      [dict get $tubeDictionary segment]
        #
    foreach key [dict keys $segment_Dictionary] {
            #
        set keyDict [dict get $segment_Dictionary $key]
        set type    [dict get $keyDict type]
            #
        puts "\n ----- control::create_Debug --- $key -------------"
        appUtil::pdict $keyDict 1 "        "
            #
        switch -exact $type {
            arc {
                set pos_StartLeft       [join [dict get $keyDict start  pos_Left]         " "]
                set pos_StartRight      [join [dict get $keyDict start  pos_Right]        " "]
                set pos_EndLeft         [join [dict get $keyDict end    pos_Left]         " "]
                set pos_EndRight        [join [dict get $keyDict end    pos_Right]        " "]
                set pos_TngtLeft        [join [dict get $keyDict inside pos_TangentLeft]  " "]
                set pos_TngtRight       [join [dict get $keyDict inside pos_TangentRight] " "]
                set pos_StartLeftCtrl   [join [dict get $keyDict start pos_LeftCtrl ] " "]
                set pos_StartRightCtrl  [join [dict get $keyDict start pos_RightCtrl] " "]
                set pos_EndLeftCtrl     [join [dict get $keyDict end   pos_LeftCtrl ] " "]
                set pos_EndRightCtrl    [join [dict get $keyDict end   pos_RightCtrl] " "]
                    #
                puts "          -> \$pos_StartLeft        $pos_StartLeft "            
                puts "          -> \$pos_StartRight       $pos_StartRight"            
                puts "          -> \$pos_EndLeft          $pos_EndLeft   "            
                puts "          -> \$pos_EndRight         $pos_EndRight  "            
                puts "          -> \$pos_TngtLeft         $pos_TngtLeft  "            
                puts "          -> \$pos_TngtRight        $pos_TngtRight "
                puts "          -> \$pos_StartLeftCtrl    $pos_StartLeftCtrl"
                puts "          -> \$pos_StartRightCtrl   $pos_StartRightCtrl"
                puts "          -> \$pos_EndLeftCtrl      $pos_EndLeftCtrl"
                puts "          -> \$pos_EndRightCtrl     $pos_EndRightCtrl"
                    #
                $cvObject  create   circle  $pos_TngtLeft       [list -radius 1.0  -tags $myTag  -outline darkblue    -width 0.1]
                $cvObject  create   circle  $pos_TngtRight      [list -radius 1.0  -tags $myTag  -outline darkblue    -width 0.1]
                    #
                $cvObject  create   circle  $pos_StartLeftCtrl  [list -radius 0.3  -tags $myTag  -outline darkorange  -width 0.1]
                $cvObject  create   circle  $pos_StartRightCtrl [list -radius 0.3  -tags $myTag  -outline darkorange  -width 0.1]
                $cvObject  create   circle  $pos_EndLeftCtrl    [list -radius 0.3  -tags $myTag  -outline darkorange  -width 0.1]
                $cvObject  create   circle  $pos_EndRightCtrl   [list -radius 0.3  -tags $myTag  -outline darkorange  -width 0.1]
                    #
                $cvObject create   line    [join "$pos_StartLeftCtrl  $pos_EndLeftCtrl"  " "]  [list -tags {__cvElement__}  -fill darkorange]
                $cvObject create   line    [join "$pos_StartRightCtrl $pos_EndRightCtrl" " "]  [list -tags {__cvElement__}  -fill darkorange]
                    #
                # $cv create   line    [join "$pos_StartLeft  $pos_TngtLeft  $pos_EndLeft"  " "]  -tags {__cvElement__}  -fill darkblue
                # $cv create   line    [join "$pos_StartRight $pos_TngtRight $pos_EndRight" " "]  -tags {__cvElement__}  -fill darkblue
                    #
                    #
                # set shapeLeft        [dict get $keyDict shape  left]
                # set shapeRight       [dict get $keyDict shape  right]
                    #
                # puts "   -> \$shapeLeft   $shapeLeft"    
                # puts "   -> \$shapeRight  $shapeRight"    
                    #
                # $cv create   line    $shapeLeft     -tags {__cvElement__}  -fill green
                # $cv create   line    $shapeRight    -tags {__cvElement__}  -fill green
                    #
            }
            default {}
        }
    }
        #
    return
        #
}
proc control::create_refLineSegment {pos direction length {tag {}}} {
        #
    variable debugMode
    variable centerLine
        #
    set cvObject $::view::cvObject
        #
    # puts "\n    control::create_refLineSegment $direction $length"
        #
    foreach {dir_x dir_y} $direction break
    set x       [expr -1.0 * $dir_y]
    set y       $dir_x
    set vctPerp [list $x $y]
        #
    set p_start $pos
    set p_end   [vectormath::addVector $pos $direction $length]
        #
    set centerLine          [lrange $centerLine     0 end-1]
    lappend centerLine      $p_start 
    lappend centerLine      $p_end
        #
    set lineDef [join "$p_start $p_end" " "]
        # puts "      -> $lineDef"
        #
    if {$tag eq {}} {
        set myTag {__cvElement__}
    } else {
        set myTag $tag
    }
        #
    if {$debugMode eq {on}} {
        $cvObject  create   circle  $p_start    [list -radius 3  -tags $myTag  -outline green     -width 0.1]
        $cvObject  create   circle  $p_end      [list -radius 2  -tags $myTag  -outline darkgreen -width 0.1]
            #
        $cvObject  create   line    $lineDef    [list -tags $myTag  -fill darkorange]
    }
        #
    return [list $p_end $direction]
}
proc control::create_refArcSegment {pos direction radius angle {tag {}}} {
        #
    variable debugMode
        #
    variable offsetLeft
    variable offsetRight
        #
    variable centerLine
        #
    set cvObject $::view::cvObject
        #
    # puts "\n    control::create_refArcSegment $direction $radius $angle"
        #
        # -- handle exceptions
    if {$angle  == 0} {
        return [list $pos $direction]
    }
        #
    if {$tag eq {}} {
        set myTag {__cvElement__}
    } else {
        set myTag $tag
    }
        # 
        #
    set p_start     $pos
    set dirStart    $direction
    foreach {dir_x dir_y} $dirStart break
    set x           [expr -1.0 * $dir_y]
    set y           $dir_x
    set perpStart   [list $x $y]
        #
    set arcRadius   [expr abs($radius)]    
        #
    if {$angle < 0} { 
        set p_center    [vectormath::addVector $pos $perpStart [expr -1.0 * $arcRadius]]
    } else {
        set p_center    [vectormath::addVector $pos $perpStart [expr  1.0 * $arcRadius]]
    }
        #
    set arcStart    [vectormath::dirAngle $p_center $p_start]
        #
    set p_end       [vectormath::rotatePoint $p_center $p_start $angle]
        #
    set dirEnd      [vectormath::rotatePoint {0 0} $direction $angle]
        #
    foreach {dir_x dir_y} $dirEnd break
    set x           [expr -1.0 * $dir_y]
    set y           $dir_x
    set perpEnd     [list $x $y]
        #
        # puts "             -> \$p_start     $p_start"
        # puts "             -> \$p_center    $p_center"
        # puts "             -> \$p_end       $p_end"
        #
        #
    set centerLine          [lrange $centerLine 0 end-1]
    lappend centerLine      $p_start 
    lappend centerLine      $p_end
        #
    if {$debugMode eq {on}} {
        $cvObject  create   circle  $p_start    [list -radius 3  -tags $myTag  -outline green     -width 0.1]
        $cvObject  create   circle  $p_end      [list -radius 2  -tags $myTag  -outline darkgreen -width 0.1]
        $cvObject  create   circle  $p_center   [list -radius 2  -tags $myTag  -outline red       -width 0.1]
    }
        #
    $cvObject  create   arc         $p_center   [list   -radius $arcRadius  \
                                                        -start $arcStart \
                                                        -extent $angle \
                                                        -tags $myTag \
                                                        -style arc \
                                                        -outline blue]
    # $cv_Name create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start  90  -extent  80 -style arc -outline gray60  -tags __Decoration__  -width 0.35
        #
    return [list $p_end $dirEnd]
        #
}
proc control::create_refPath {cvObject pos direction guideDef tag} {
        #
    set myPosition  $pos
    set myDirection $direction
    set myTag       $tag
        #
    $cvObject  create   circle      $myPosition  [list -radius 2  -tags $myTag  -fill white -outline blue  -width 0.1]
        #
    foreach {type value} $guideDef {
        switch -exact $type {
            l { 
                writeReport    "       line: $value"
                set retVal [create_refLineSegment $myPosition $myDirection $value $myTag]
                foreach {myPosition myDirection} $retVal break
            }
            a { 
                writeReport    "       arc:  $value"
                foreach {radius angle} $value break
                set retVal [create_refArcSegment $myPosition $myDirection $radius $angle $myTag]
                foreach {myPosition myDirection} $retVal break
            }
            default {
                writeReport    "       <E>: $type not defined "
            }
        }
    }
}
proc control::create_refProfile {cvObject pos shapeDef tag} {
        #
    set myPosition  $pos
    set myTag       $tag
        #
        #set profileRoundDictionary   $model::profileRoundDictionary
    set profileRoundDictionary   $shapeDef
        #
        # appUtil::pdict $profileRoundDictionary
        #
    set indexList   [lsort -real [dict keys $profileRoundDictionary]]
        # puts "    -> \$indexList $indexList"
        #
        #
        # -- centerLine
        #
    set pointList   {}
    foreach key $indexList {
        lappend pointList [list $key 0]
    }
    set line_pointList [vectormath::addVectorPointList $pos $pointList]    
    foreach xy $line_pointList {
        $cvObject  create   circle      $xy [list -radius 2  -tags $myTag  -fill white -outline blue  -width 0.1]
    }
    $cvObject create   line    [join $line_pointList " "]  [list -tags {__cvElement__}  -fill darkgreen]
        #
        #
        # -- profile
        #
    set pointList   {}
        #
    set startDict           [dict get $profileRoundDictionary [lindex $indexList 0]]
    set lng_Start           [dict get $startDict lng_Start]
    set off_Start           [dict get $startDict off_Start]
    lappend pointList       [list $lng_Start $off_Start]
        #
    foreach key $indexList {
            #
        set keyDict         [dict get $profileRoundDictionary $key]
            #
            # puts " --- $key ---"
            # appUtil::pdict $keyDict
        set lng_End         [dict get $keyDict lng_End]
        set off_End         [dict get $keyDict off_End]
        lappend pointList   [list $lng_End $off_End]
    }
        #
    set line_pointList [vectormath::addVectorPointList $pos $pointList]    
    foreach xy $line_pointList {
        $cvObject  create   circle      $xy [list -radius 2  -tags $myTag  -fill white -outline blue  -width 0.1]
    }
    $cvObject create   line    [join $line_pointList " "]  [list -tags {__cvElement__}  -fill red]
        #
    return 
        #
}
proc control::create_Bezier {cvObject pos tag} {
        #
    set myPosition  $pos
    set myTag       $tag
        #
    set ang_Start   0
        #
    variable contrSeg_l00     ;#  50    ;#     5     100
    variable contrSeg_r01     ;#  30    ;#    20     100
    variable contrSeg_a01     ;#  25    ;#   -90      90
    variable contrSeg_l02     ;#  60    ;#    20     150
    variable contrSeg_r03     ;#  40    ;#    20     100
    variable contrSeg_a03     ;# -20    ;#   -90      90
    variable contrSeg_l04     ;#  70    ;#    20     150
    variable contrSeg_r05     ;#  40    ;#    20     100
    variable contrSeg_a05     ;# -30    ;#   -90      90
    variable contrSeg_l06     ;#  70    ;#    20     150
        #
    variable profile_x01      ;#  10    
    variable profile_x02      ;#  30    
    variable profile_x03      ;# 130    
    variable profile_x04      ;#  90    
    variable profile_y01      ;#  10    
    variable profile_y02      ;#  15    
    variable profile_y03      ;#  20    
    variable profile_y04      ;#  15
        #
    set xy  {0 0}
        #
    $cvObject  create   circle      $myPosition -radius $profile_y02  [list -tags $myTag  -outline blue  -width 0.1]
    $cvObject  create   circle      $myPosition -radius $profile_y03  [list -tags $myTag  -outline blue  -width 0.1]
        #
    set pos_03_0    [list [expr  1.0 * $profile_y02] 0]     ;#  3'
    set pos_06_0    [list 0 [expr -1.0 * $profile_y03]]     ;#  6'
    set pos_09_0    [list [expr -1.0 * $profile_y02] 0]     ;#  9'
    set pos_12_0    [list 0 [expr  1.0 * $profile_y03]]     ;# 12'
        #
        # (4/3)*tan(pi/(2n))    
    set angle       90
    set n           [expr 360.0 / $angle]
    puts "    -> \$n         $n <- $vectormath::CONST_PI"
    set l_control   [expr (4.0/3) * tan($vectormath::CONST_PI/(2 * $n))]
    puts "    -> \$l_control $l_control   <- 0.552284749831" 

    set pos_03_l   [vectormath::addVector $pos_03_0 [list 0 [expr  1.0 * $l_control * $profile_y03]]]
    set pos_03_r   [vectormath::addVector $pos_03_0 [list 0 [expr -1.0 * $l_control * $profile_y03]]]

    set pos_06_l   [vectormath::addVector $pos_06_0 [list [expr  1.0 * $l_control * $profile_y02] 0]]
    set pos_06_r   [vectormath::addVector $pos_06_0 [list [expr -1.0 * $l_control * $profile_y02] 0]]

    set pos_09_l   [vectormath::addVector $pos_09_0 [list 0 [expr -1.0 * $l_control * $profile_y03]]]
    set pos_09_r   [vectormath::addVector $pos_09_0 [list 0 [expr  1.0 * $l_control * $profile_y03]]]

    set pos_12_l   [vectormath::addVector $pos_12_0 [list [expr -1.0 * $l_control * $profile_y02] 0]]
    set pos_12_r   [vectormath::addVector $pos_12_0 [list [expr  1.0 * $l_control * $profile_y02] 0]]

    
    # exit    
        
        #
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_03_l] [list -radius 1  -tags $myTag  -outline green -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_03_0] [list -radius 1  -tags $myTag  -outline blue  -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_03_r] [list -radius 1  -tags $myTag  -outline red   -width 0.1]
        #
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_06_l] [list -radius 1  -tags $myTag  -outline green -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_06_0] [list -radius 1  -tags $myTag  -outline blue  -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_06_r] [list -radius 1  -tags $myTag  -outline red   -width 0.1]
        #
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_09_l] [list -radius 1  -tags $myTag  -outline green -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_09_0] [list -radius 1  -tags $myTag  -outline blue  -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_09_r] [list -radius 1  -tags $myTag  -outline red   -width 0.1]
        #
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_12_l] [list -radius 1  -tags $myTag  -outline green -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_12_0] [list -radius 1  -tags $myTag  -outline blue  -width 0.1]
    $cvObject  create   circle      [vectormath::addVector $myPosition $pos_12_r] [list -radius 1  -tags $myTag  -outline red   -width 0.1]
        #
    set defList     [list           $pos_03_0 $pos_03_r $pos_06_l \
                                    $pos_06_0 $pos_06_r $pos_09_l \
                                    $pos_09_0 $pos_09_r $pos_12_l \
                                    $pos_12_0 $pos_12_r $pos_03_l \
                                    $pos_03_0]
                            
    set pointList   [model::bezier::create [join $defList " "]]
        #
    puts "   -> $pointList"
    set pointList   [vectormath::addVectorCoordList $myPosition $pointList]
    puts "   -> $pointList"
    # exit
    $cvObject create   line   $pointList -tags {__cvElement__}  -fill darkgreen
        #
    # exit    
        
        
    # set pointList   [vectormath::addVectorCoordList
    
    # set pos_01  [vectormath::rotatePoint $xy ang_Start    
        
        
    # $cv create   line    [join $line_pointList " "]  -tags {__cvElement__}  -fill darkgreen
        #
        #
    return 
        #
}
    #
proc control::update {{value 1}} {
        #
    variable demo_type    
        #
    if {$demo_type != {dimension} } {
        view::demo_canvasCAD 
        return
    }            
        #
        #
    variable arcPrecision
        #
    variable guideDef          {}
    variable profileDef        {}
        #
    variable contrSeg_l00       ;#  50  ;#     5     100
    variable contrSeg_r01       ;#  30  ;#    20     100
    variable contrSeg_a01       ;#  60  ;#   -90      90
    variable contrSeg_l02       ;# 100  ;#    20     150
    variable contrSeg_r03       ;#  40  ;#    20     100
    variable contrSeg_a03       ;#  60  ;#   -90      90
    variable contrSeg_l04       ;# 100  ;#    20     150
    variable contrSeg_r05       ;#  20  ;#    20     100
    variable contrSeg_a05       ;# -40  ;#   -90      90
    variable contrSeg_l06       ;# 100  ;#    20     150
        # {i 50 a {30 60} l 100 a {40 -20} l 50 a {20 -40} l 60}
        #
        #
    variable profile_x01        ;#  10    
    variable profile_x02        ;#  30    
    variable profile_x03        ;# 130    
    variable profile_x04        ;#  90    
    variable profile_y01        ;#  10    
    variable profile_y02        ;#  15    
    variable profile_y03        ;#  20    
    variable profile_y04        ;#  15
        #
        #
    lappend guideDef   l [list $contrSeg_l00]
    lappend guideDef   a [list $contrSeg_r01 $contrSeg_a01]
    lappend guideDef   l [list $contrSeg_l02]
    lappend guideDef   a [list $contrSeg_r03 $contrSeg_a03]
    lappend guideDef   l [list $contrSeg_l04]
    lappend guideDef   a [list $contrSeg_r05 $contrSeg_a05]
    lappend guideDef   l [list $contrSeg_l06]
        #
        #
    foreach {type value} [lrange $guideDef 0 1] break
    if {$type ne "l"} {
        writeReport    "       <D>: first parameter is not \"i\" ... initLength"
        return
    }
        #
        #
    if {$profile_x01 > 0} {
        set x00     0
        set profileDef  [list   0               $profile_y01 \
                                $profile_x01    $profile_y01 \
                                $profile_x02    $profile_y02 \
                                $profile_x03    $profile_y03 \
                                $profile_x04    $profile_y04 \
                                10              $profile_y04 \
                            ]
    } else {
        set profileDef  [list   $profile_x01    $profile_y01 \
                                $profile_x02    $profile_y02 \
                                $profile_x03    $profile_y03 \
                                $profile_x04    $profile_y04 \
                                10              $profile_y04 \
                            ]
    }
        #
    model::setArcPrecission [expr 1.0 / $arcPrecision]
        #
    model::setCenterLine    $guideDef
        #
    model::setProfileRound  $profileDef
        #
    #model::init $guideDef $profileDef
    #model::init $guideDef $profileDef
        #
        #
    update_board  
        #
    # set tubeDictionary  [model::getDictionary]
    # appUtil::pdict $tubeDictionary 2 "    "    
        #
    return
        #
}
proc control::update_board {} {
        #
    set cvObject        $::view::cvObject
        #
    set tubeDictionary  $::model::tubeDictionary
        #
    variable centerLine         {{-1  0}}
        #
    variable guideDef
    variable profileDef
        #
    variable drw_scale
    variable dim_font_select
    variable dim_size
    variable font_colour
        #
    set myTag   {__cvElement__}
        #
    set board   [$cvObject getCanvas]

    if {$font_colour == {default}} { set font_colour [$cvObject  configure  Style  Fontcolour]}
            
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
    cleanReport
        #
        #
    $cvObject deleteContent
        #
        # $cvObject configure Stage    Scale        $drw_scale
    $cvObject configure Style    Fontstyle    $dim_font_select
    $cvObject configure Style    Fontsize     $dim_size
        #
    writeReport "    \$guideDef"
    writeReport "           -> $guideDef"
    writeReport "    \$profileDef"
    writeReport "           -> $profileDef"
        #
        #
        #
    set myPosition      {30 200}
    set myDirection     {1 0}
    create_refPath      $cvObject $myPosition $myDirection $guideDef $myTag 
        #
    set myPosition      {30 140}
    set shapeDef1       [dict get $tubeDictionary profileRound]
    create_refProfile   $cvObject $myPosition $shapeDef1 $myTag
        #
    set myPosition      {30 100}
    set shapeDef2       [dict get $tubeDictionary profileSqueeze]
    create_refProfile   $cvObject $myPosition $shapeDef2 $myTag
        #
        #
    set myPosition      {30 200}
    set pathDef         [dict get $tubeDictionary segmentPath]
    create_dictPath     $cvObject $myPosition $pathDef $myTag
    set shapeDef        [dict get $tubeDictionary shapeRound]
    create_dictShape    $cvObject $myPosition $shapeDef $myTag red
        # create_Debug        $cvObject $myPosition $myTag
        #
    set myPosition      {50 100}
        # create_Bezier       $cvObject $myPosition $myTag
        #
        #
    return            
        #
    }

    #
    # -- VIEW --
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
    set cvObject    [cad4tcl::new  $parentPath 	$cv_width $cv_height 	A3  $st_scale 40]
        #
        # set cvObject    [cad4tcl::new  $cv_path 	$cv_width $cv_height 	A4 $st_scale 40]
        # set retValue [eval canvasCAD::newCanvas $cvName  $parentPath     "stageCanvas"  $cv_width $cv_height     A3 0.5 40 $args]
        #
        # foreach {stageCanvas stageNamespace} $retValue break
        # puts "  -> $retValue"
    set stageCanvas [$cvObject getCanvas]
        # set stageCanvas   $cv
    set cv_scale    [$cvObject configure Canvas Scale]  
        # set cv_scale [$stageNamespace getNodeAttr Canvas scale]
    return $stageCanvas
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

        #
        ### -- G U I - canvas demo
    # set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings"]
        #
    # pack  $f_settings  -side top -expand yes -fill both
    
        #
    labelframe  $f_config.f_guideDef      -text guideDef
    labelframe  $f_config.f_pathLeft      -text pathLeft
    labelframe  $f_config.f_view          -text view
    labelframe  $f_config.precision       -text precision
    labelframe  $f_config.scale           -text scale

        # labelframe  $f_config.centerline      -text centerline
        # labelframe  $f_config.font            -text font
        # labelframe  $f_config.demo            -text demo
        #
    pack    $f_config.f_guideDef \
            $f_config.f_pathLeft \
            $f_config.f_view     \
            -fill x -side top 

        #
    view::create_config_line $f_config.f_guideDef.i_00  "init (i) length:  "    control::contrSeg_l00      5 100    ;#   0
    view::create_config_line $f_config.f_guideDef.l_02  "line (l) length:  "    control::contrSeg_l02     20 150    ;#   0
    view::create_config_line $f_config.f_guideDef.l_04  "line (l) length:  "    control::contrSeg_l04     20 150    ;#   0
    view::create_config_line $f_config.f_guideDef.l_06  "line (l) length:  "    control::contrSeg_l06     20 150    ;#   0
    view::create_config_line $f_config.f_guideDef.a_01  "arc (a) angle  :  "    control::contrSeg_a01    -90  90    ;#   0
    view::create_config_line $f_config.f_guideDef.a_03  "arc (a) angle  :  "    control::contrSeg_a03    -90  90    ;#   0
    view::create_config_line $f_config.f_guideDef.a_05  "arc (a) angle  :  "    control::contrSeg_a05    -90  90    ;#   0
    view::create_config_line $f_config.f_guideDef.r_01  "arc (a) radius :  "    control::contrSeg_r01    -20 100    ;#   0
    view::create_config_line $f_config.f_guideDef.r_03  "arc (a) radius :  "    control::contrSeg_r03    -20 100    ;#   0
    view::create_config_line $f_config.f_guideDef.r_05  "arc (a) radius :  "    control::contrSeg_r05    -20 100    ;#   0
        #
    view::create_config_line $f_config.f_pathLeft.x_01  "left (x01):       "    control::profile_x01       0 150    ;#  10    
    view::create_config_line $f_config.f_pathLeft.x_02  "left (x02):       "    control::profile_x02       0 150    ;#  30    
    view::create_config_line $f_config.f_pathLeft.x_03  "left (x03):       "    control::profile_x03       0 150    ;# 130    
    view::create_config_line $f_config.f_pathLeft.x_04  "left (x04):       "    control::profile_x04       0 150    ;#  90    
    view::create_config_line $f_config.f_pathLeft.y_01  "left (y01):       "    control::profile_y01       0  40    ;#  10    
    view::create_config_line $f_config.f_pathLeft.y_02  "left (y02):       "    control::profile_y02       0  40    ;#  15    
    view::create_config_line $f_config.f_pathLeft.y_03  "left (y03):       "    control::profile_y03       0  40    ;#  20    
    view::create_config_line $f_config.f_pathLeft.y_04  "left (y04):       "    control::profile_y04       0  40    ;#  15                 
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
    # -- GUI --
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
        
            
   
 
 

 