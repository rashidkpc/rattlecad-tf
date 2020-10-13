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
  
  lappend auto_path "$APPL_Package_Dir/canvasCAD"
  lappend auto_path "$APPL_Package_Dir/bikeGeometry"
  lappend auto_path "$APPL_Package_Dir/vectormath"
  lappend auto_path "$APPL_Package_Dir/appUtil"
  
  lappend auto_path "$APPL_Package_Dir/lib-canvasCAD"
  lappend auto_path "$APPL_Package_Dir/lib-bikeGeometry"
  lappend auto_path "$APPL_Package_Dir/lib-vectormath"
  lappend auto_path "$APPL_Package_Dir/lib-appUtil"
  
  package require   Tk
  package require   tubeMiter
  package require   canvasCAD
  package require   bikeGeometry
  package require   vectormath
  package require   appUtil

  
     
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
                [list ToolTube_Direction      90 \
                      Tube_Direction         180 \
                      Tube_Offset             60 \
                ]
        dict append dict_TubeMiter toolTube \
                [list Diameter_Base           56 \
                      Diameter_Top            46 \
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
        variable stageCanvas
        variable stageNamespace
        variable reportText         {}
    }
    namespace eval control {
                
        variable geometry/ToolTube_Direction      90 
        variable geometry/Tube_Direction         180 
        variable geometry/Tube_Offset             60 
        variable toolTube/Diameter_Base           56 
        variable toolTube/Diameter_Top            46 
        variable toolTube/Length                 100 
        variable toolTube/Length_BaseCylinder     10 
        variable toolTube/Length_Cone             70 
        variable tube/Diameter_Miter              38
        variable tube/Length                      90
        variable result/Base_Position             {}
        variable result/Miter_Angle               {}
        variable result/Profile_Tool              {}
        variable result/Profile_Tube              {}
        variable result/Shape_Tool                {}
        variable result/Shape_Tube                {}
        
        
        variable miterView                        right;# 0 ... cone / 1 ... cylinder
        variable toolType                         0    ;# 0 ... cone / 1 ... cylinder
        variable tubeOffset                       0    ;# 0 ... cone / 1 ... cylinder
        variable viewOffset                       0
        
        # trace add variable geometry/ToolTube_Direction  write updateModel
        # trace add variable geometry/Tube_Direction      write updateModel
        # trace add variable geometry/Tube_Offset         write updateModel
        # trace add variable toolTube/Diameter_Base       write updateModel
        # trace add variable toolTube/Diameter_Top        write updateModel
        # trace add variable toolTube/Length              write updateModel
        # trace add variable toolTube/Length_BaseCylinder write updateModel
        # trace add variable toolTube/Length_Cone         write updateModel
        # trace add variable tube/Diameter_Miter          write updateModel
        # trace add variable tube/Length                  write updateModel
        
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
        variable demo_type          dimension
        variable drw_scale           1.0
        variable cv_scale            1
        variable debugMode          off
    
        variable headTube_Angle     72
        
        
        variable arcPrecission       5
        #variable unbentShape
        #variable profileDef {}
        #     set profileDef {{0 7} {10 7} {190 9} {80 9} {70 12}}
        #     set profileDef {{0 9} {10 7} {190 16} {80 16} {70 24}}
        #     set profileDef {{0 7} {10 7} {190 16} {80 16} {70 24}}

    }    

        #
        # -- MODEL --
        #
    proc model::setValue {_dictPath value} {
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
    proc model::getValue {dictPath} {
            #
        variable dict_TubeMiter
            #
        set value [appUtil::get_dictValue $dict_TubeMiter $dictPath] 
            #
        return $value
            #
    }
    proc model::update_MiterSettings {} {
            #
        variable dict_TubeMiter
            #
        set tubeAngle       [appUtil::get_dictValue $dict_TubeMiter /geometry/Tube_Direction]
        set toolAngle       [appUtil::get_dictValue $dict_TubeMiter  /geometry/ToolTube_Direction]
        set miterAngle      [expr 180 - [appUtil::get_dictValue $dict_TubeMiter /geometry/Tube_Direction] + [appUtil::get_dictValue $dict_TubeMiter  /geometry/ToolTube_Direction] ] 
        
        puts "   -> \$toolAngle $toolAngle"
        puts "   -> \$tubeAngle $tubeAngle"
        
        set miterAngle      [expr $tubeAngle - $toolAngle ]
        puts "   -> \$miterAngle $miterAngle"
        
        dict set dict_TubeMiter  result Miter_Angle $miterAngle
            #
            #
        set basePosition   [vectormath::rotateLine  {0 0} [appUtil::get_dictValue $dict_TubeMiter /geometry/Tube_Offset] [appUtil::get_dictValue $dict_TubeMiter  /geometry/ToolTube_Direction]]
        set basePosition   [vectormath::rotatePoint {0 0} $basePosition 180 ]
        dict set dict_TubeMiter  result Base_Position $basePosition
            #
            #
        set frustumHeight   [getValue /toolTube/Length_Cone]
        set baseRadius      [expr 0.5 * [getValue /toolTube/Diameter_Base]]
        set topRadius       [expr 0.5 * [getValue /toolTube/Diameter_Top]]
        set tubeOffset      [getValue /geometry/Tube_Offset]
        set baseHeight      [getValue /toolTube/Length_BaseCylinder]
        set offsetIntersect [expr 1.0 * $tubeOffset - $baseHeight]
        set toolRatioCone   [expr ($topRadius - $baseRadius) / $frustumHeight]
        set toolRadiusCone  [expr $baseRadius - $toolRatioCone * $offsetIntersect]
        # dict set dict_TubeMiter  result Cone_Radius $toolRadiusCone
            #
            #
        return
            #
    }
    
    
    proc model::create_ToolGeometry {{type {0}}} {
            #
        variable dict_TubeMiter
            #
        puts "\n"   
        puts "  --< model::create_ToolGeometry >-- $type --"   
        puts "\n"   
            #
        set toolProfile {}
        set toolShape   {}
            #
        set x00 [expr -1.0 * [appUtil::get_dictValue $dict_TubeMiter /toolTube/Length_BaseCylinder]]
        set y00 [expr 0.5 * [appUtil::get_dictValue $dict_TubeMiter /toolTube/Diameter_Base] ]
        set x01 0
        set y01 $y00
        set x02 [appUtil::get_dictValue $dict_TubeMiter /toolTube/Length_Cone]
        set y02 [expr 0.5 * [appUtil::get_dictValue $dict_TubeMiter /toolTube/Diameter_Top] ]
        set x03 [expr $x00 + [appUtil::get_dictValue $dict_TubeMiter /toolTube/Length]]
        set y03 $y02
            #
        if {$type == 0} {
                # ... cone
            set p00 [list   $x00 $y00]
            set p01 [list   $x01 $y01]
            set p02 [list   $x02 $y02]
            set p03 [list   $x03 $y03]
                #
                #
        } else {
                # ... cylinder
            set p00 [list   $x00 $y00]
            set p01 [list   $x01 $y00]
            set p02 [list   $x02 $y00]
            set p03 [list   $x03 $y00]
                #
        }
        set toolProfile [list $p00 $p01 $p02 $p03]
            #
            #
        set toolDirection   [appUtil::get_dictValue $dict_TubeMiter /geometry/ToolTube_Direction]
        set basePosition    [appUtil::get_dictValue $dict_TubeMiter /result/Base_Position]
        set toolShape       $toolProfile
        set reverseList     [lreverse $toolProfile]
        foreach pos $reverseList {
            foreach {x y} $pos break
                set y [expr -1 * $y]
                lappend toolShape [list $x $y]
        }
            #
        #set toolShape [vectormath::flatten_nestedList $toolShape]
        set toolShape [vectormath::rotatePointList {0 0} $toolShape $toolDirection]
        set toolShape [vectormath::addVectorPointList $basePosition $toolShape]
            #
            #
        # puts "   \$toolShape $toolShape"
            #
        set sh01 [lrange [join $toolShape " "] 2  5]
        set sh02 [lrange [join $toolShape " "] 10 13]
        set toolShapeCone [vectormath::flatten_nestedList $sh01 $sh02]
            #
            #
            #
        dict set dict_TubeMiter  result Profile_Tool    $toolProfile
        dict set dict_TubeMiter  result Shape_Tool      $toolShape
        dict set dict_TubeMiter  result ShapeCone_Tool  $toolShapeCone
            #
        return
            #
    }
    proc model::create_TubeGeometry {} {
            #
        variable dict_TubeMiter
            #
        set tubeProfile {}
        set tubeShape   {}
            #
        set x00 0
        set y00 [expr 0.5 * [appUtil::get_dictValue $dict_TubeMiter /tube/Diameter_Miter] ]
        set x01 [appUtil::get_dictValue $dict_TubeMiter /tube/Length]
        set y01 $y00
            #
        set p00 [list   $x00 $y00]
        set p01 [list   $x01 $y01]
            #
        set tubeProfile [list $p00 $p01]
            #
            #
        # appUtil::pdict $model::dict_TubeMiter
            #
            # puts "    <D> \$tubeProfile $tubeProfile"
            #
        set tubeDirection   [appUtil::get_dictValue $dict_TubeMiter /geometry/Tube_Direction]
        set tubeShape       $tubeProfile
        set reverseList     [lreverse $tubeProfile]
        foreach pos $reverseList {
            foreach {x y} $pos break
                set y [expr -1 * $y]
                lappend tubeShape [list $x $y]
        }
        set tubeShape [vectormath::flatten_nestedList    $tubeShape]
        set tubeShape [vectormath::rotateCoordList {0 0} $tubeShape $tubeDirection]
            #
            # 
        dict set dict_TubeMiter  result Profile_Tube    $tubeProfile
        dict set dict_TubeMiter  result Shape_Tube      $tubeShape
            #
    }
    proc model::miter_Cone {} {
            #
        set tubeDiameter    [getValue /tube/Diameter_Miter]
        set tubeDirection   [getValue /geometry/Tube_Direction]
        set toolDirection   [getValue /geometry/ToolTube_Direction]
        set tubeOffset      [getValue /geometry/Tube_Offset]
        set baseHeight      [getValue /toolTube/Length_BaseCylinder]
        set baseDiameter    [getValue /toolTube/Diameter_Base]
        set topDiameter     [getValue /toolTube/Diameter_Top]
        set miterAngle      [getValue /result/Miter_Angle]       
        set precision       [getValue /settings/precision]
            #
        set tubePerimeter   [expr $tubeDiameter * $vectormath::CONST_PI]
        set tubeRadius      [expr 0.5 * $tubeDiameter]
        set toolRadiusBase  [expr 0.5 * $baseDiameter]
        set toolRadiusTop   [expr 0.5 * $topDiameter]
            #
        set offset_ConeIS        [expr 1.0 * $tubeOffset - $baseHeight]
        set offset_tubePerimeter [expr 1.0 * $tubePerimeter / $precision]
        set offset_tubeAngle     [expr 1.0 * 360 / $precision]
            #
        set frustumHeight   [getValue /toolTube/Length_Cone]
        set tubeOffset      [getValue /geometry/Tube_Offset]
        set baseHeight      [getValue /toolTube/Length_BaseCylinder]
        set offsetIntersect [expr 1.0 * $tubeOffset - $baseHeight]
        set toolConeRatio   [expr ($toolRadiusTop - $toolRadiusBase) / $frustumHeight]
        set toolConeLength  [expr $toolRadiusBase / $toolConeRatio]
        set toolConeRadius  [expr $toolRadiusBase - $toolConeRatio * $offsetIntersect]
            #
            #
        set miterAngleCompl [expr 180.0 - $miterAngle]
                
        puts "\n"    
        puts " --< model::miter_Cone > --"    
        puts "        -> \$tubeRadius            $tubeRadius \[mm\]"
        puts "        -> \$miterAngle            $miterAngle \[\°\]"
        puts "        -> \$toolRadiusBase        $toolRadiusBase  \[mm\]"
        puts "        -> \$toolRadiusTop         $toolRadiusTop   \[mm\]"
        puts "        -> \$frustumHeight         $frustumHeight   \[mm\]"
        puts "        -> \$precision             $precision \[\]"
        puts "        -> \$tubePerimeter         $tubePerimeter \[mm\]"
        puts "        -> \$offset_tubePerimeter  $offset_tubePerimeter \[mm\]"
        puts "        -> \$offset_tubeAngle      $offset_tubeAngle \[\°\]"
        puts "        -> \$toolConeRatio         $toolConeRatio \[\]"
        puts "        -> \$toolConeLength        $toolConeLength \[mm\]"
        puts "        -> \$toolConeRadius        $toolConeRadius \[mm\]"
        puts "        -> \$offsetIntersect       $offsetIntersect \[mm\]"
        puts " --< model::miter_Cone > --"    
        puts "\n"  
            #
        if {$miterAngle == 180} {
            puts "\n"  
            puts "    <E> ... can not cut tube"  
            puts "\n"  
            return
        }
        
            # exit
            #
            #       
            #           x  ^            
            #              | /  z
            #              |/
            #              /
            #             /|
            #            / |       
            #           /  |      
            #          /   |       
            #         +----+ y(r)         
            #         |\ r |      
            #    x(r) | \  |      
            #         |  \ |      
            #         |   \|      
            #      ---+----+----------> y  tubeAngle = 0
            #              |   
            #              |
            #     -180° tubeAngle => 180° 
            #
            #
        set i_Angle -180
        set i_Perimeter [expr -0.5 * $tubePerimeter]
        while {$i_Angle <= 180} {
                #
            set radiusTube_x        [expr $tubeRadius * sin([vectormath::rad $i_Angle])]
            set radiusTube_y        [expr $tubeRadius * cos([vectormath::rad $i_Angle])]
                #
                # -- create projection of tube on plane of tool             -> list_Projection_ToolPlane
                #
            set offSetTube_z        [expr $radiusTube_y / sin([vectormath::rad $miterAngleCompl])]
                #
                # -- create cut with plane of tool                          -> list_Miter_ToolPlane
                #
            set offSetToolPlane     [expr $radiusTube_y / tan([vectormath::rad $miterAngleCompl])]
                #
                # -- create miter with base- and top diameter of conic tool -> list_Miter_BaseCylinder
                #                                                           -> list_Miter_TopCylinder
                #
            set radiusTool_Base_y   [expr {sqrt($toolRadiusBase * $toolRadiusBase - $radiusTube_x * $radiusTube_x )}]
            set offSetBaseDiameter  [expr -1.0 * $radiusTool_Base_y / sin([vectormath::rad $miterAngleCompl]) + $radiusTube_y / tan([vectormath::rad $miterAngleCompl])]
                #
            set powerValue          [expr ($toolRadiusTop  * $toolRadiusTop  - $radiusTube_x * $radiusTube_x)]
            if {$powerValue > 0} {
                set radiusTool_Top_y    [expr sqrt($powerValue)]
            } else {
                set radiusTool_Top_y    0
            }
            set offSetTopDiameter   [expr -1.0 * $radiusTool_Top_y  / sin([vectormath::rad $miterAngleCompl]) + $radiusTube_y / tan([vectormath::rad $miterAngleCompl])]
                #
            # puts "   -> \$i_Angle .......... $i_Angle "    
            # puts "   -> \$radiusTool_Base_y ..... $radiusTool_Base_y ($radiusTube_x / $radiusTube_y) "    
            # puts "   -> \$offSetBaseDiameter  ... $offSetBaseDiameter  "   
                #
            if {[expr abs($radiusTube_x)] < 0.00001} {set radiusTube_x 0}
            if {[expr abs($radiusTube_y)] < 0.00001} {set radiusTube_y 0}
            if {[expr abs($offSetTube_z)] < 0.00001} {set offSetTube_z 0}
                #
            if {[expr abs($offSetToolPlane)]     < 0.00001} {set offSetToolPlane     0}
            if {[expr abs($offSetBaseDiameter)]  < 0.00001} {set offSetBaseDiameter  0}
            if {[expr abs($offSetTopDiameter)]   < 0.00001} {set offSetTopDiameter  0}
                #
            lappend list_TubePerimeter          $i_Perimeter    
            lappend list_Tube_x                 $radiusTube_x    
            lappend list_Tube_y                 $radiusTube_y    
            lappend list_Miter_ToolPlane        $offSetToolPlane     
            lappend list_Miter_BaseCylinder     $offSetBaseDiameter 
            lappend list_Miter_TopCylinder      $offSetTopDiameter 
                #
            lappend list_Projection_ToolPlane   $offSetTube_z    
                #
            set i_Angle     [expr {$i_Angle + $offset_tubeAngle}]
            set i_Perimeter [expr {$i_Perimeter + $offset_tubePerimeter}]
        }
            #
            #
            #
        set listLength [llength $list_TubePerimeter]
            #
            
            #
            #
            # -- miter_ToolPlaneView
            #  ... contains a projection of tube to a plane in direction of tool
            # puts "\n\n\n\n == [llength $list_Projection_ToolPlane] =================================================="    
        set i 0
        set miter_ToolPlaneView {}
        foreach key $list_Tube_x  {
            set value [lindex $list_Projection_ToolPlane $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_ToolPlaneView $key $value
            incr i
        }
            #
            # - create miter with conic tool
            #
                #
                # set coneMiter [coneMiter $R_Frustum_Base $R_Frustum_Top $H_Frustum $R_Tube $alpha $hks]
                #
                #   R_Frustum_Base ... Radius des Kegelstumpf unten
                #   R_Frustum_Top .... Radius des Kegelstumpf oben
                #   H_Frustum ........ Höhe des Kegelstumpf    
                #
                #   R_Tube ........... Radius Zylinder in mm
                #   alpha ............ Schnittwinkel in grad (FrustumTop -> Joint <- Tube)
                #   hks .............. Höhe von Kegelfuß bis Achsenschnittpunkt
            #
            #
        puts "<I> tubeMiter::coneMiter -> $toolRadiusBase $toolRadiusTop $frustumHeight $tubeRadius $miterAngle $tubeOffset"
            #
        set list_Miter [tubeMiter::coneMiter $toolRadiusBase $toolRadiusTop $frustumHeight $tubeRadius $miterAngle $tubeOffset]    
            # set list_Miter [tubeMiter::coneMiter $toolRadiusBase $toolRadiusTop $frustumHeight $tubeRadius $miterAngle $offsetIntersect]    
        set miter_Tool          [lindex $list_Miter 0]   
        set miter_SideViewTool  [lindex $list_Miter 1]   
        set miter_SideViewCone  [lindex $list_Miter 2]   
            #
        # control::cleanReport
        control::writeReport "  \$miter_SideViewTool\n $miter_SideViewTool"            
        control::writeReport "  \$miter_SideViewCone\n $miter_SideViewCone"            
            #
            #
        set listLength [llength $list_TubePerimeter]
            #
            #
            # -- miter perimeter
            #
            # puts "\n\n\n\n == [llength $list_TubePerimeter] =================================================="    
        set i 0
        set miter_ToolPlane {}
        foreach key $list_TubePerimeter {
            set value [lindex $list_Miter_ToolPlane $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_ToolPlane $key $value 
            incr i
        }
            # puts "\n\n\n\n == [llength $list_TubePerimeter] =================================================="    
        set i 0
        set miter_BaseDiameter {}
        foreach key $list_TubePerimeter {
            set value [lindex $list_Miter_BaseCylinder $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_BaseDiameter $key $value 
            incr i
        }
            # puts "\n\n\n\n == [llength $list_TubePerimeter] =================================================="    
        set i 0
        set miter_TopDiameter {}
        foreach key $list_TubePerimeter {
            set value [lindex $list_Miter_TopCylinder $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_TopDiameter $key $value 
            incr i
        }
            #
            # -- side view
            #
            # puts "\n\n\n\n == [llength $list_Miter_ToolPlane] =================================================="    
        set i 0
        set miter_SideViewToolPlane {}
        foreach key $list_Miter_ToolPlane {
            if {$i > [expr 0.5 * $listLength -1 ]} {
                set value [lindex $list_Tube_y $i]
                # puts "      -> $i  - $key -> $value"
                lappend miter_SideViewToolPlane $key $value
            }
            incr i
        }
            # puts "\n\n\n\n == [llength $list_Miter_BaseCylinder] =================================================="    
        set i 0
        set miter_SideViewBaseDiameter {}
        foreach key $list_Miter_BaseCylinder {
            if {$i > [expr 0.5 * $listLength -1 ]} {
                set value [lindex $list_Tube_y $i]
                # puts "      -> $i  - $key -> $value"
                lappend miter_SideViewBaseDiameter $key $value
            }
            incr i
        }
            # puts "\n\n\n\n == [llength $list_Miter_BaseCylinder] =================================================="    
        set i 0
        set miter_SideViewTopDiameter {}
        foreach key $list_Miter_TopCylinder {
            if {$i > [expr 0.5 * $listLength -1 ]} {
                set value [lindex $list_Tube_y $i]
                # puts "      -> $i  - $key -> $value"
                lappend miter_SideViewTopDiameter $key $value
            }
            incr i
        }
            #
            #
        set shape_DebugView         $miter_ToolPlaneView
        
        set shape_ToolPlaneView     [vectormath::rotateCoordList {0 0} $miter_ToolPlaneView [expr $toolDirection + 90]]
            #
        foreach {key value} $miter_ToolPlaneView {
            # puts "       -<debug>- $key $value"
        }
            #
            # puts "    -> \$miter_SideView  <[llength $miter_SideView]>  $miter_SideView" 
        set miter_SideViewToolPlane     [vectormath::rotateCoordList  {0 0} $miter_SideViewToolPlane    [expr   0 + $tubeDirection]]     
        set miter_SideViewBaseDiameter  [vectormath::rotateCoordList  {0 0} $miter_SideViewBaseDiameter [expr 180 + $tubeDirection]]     
        set miter_SideViewTopDiameter   [vectormath::rotateCoordList  {0 0} $miter_SideViewTopDiameter  [expr 180 + $tubeDirection]]     
        set miter_SideViewTool          [vectormath::rotateCoordList  {0 0} $miter_SideViewTool         [expr 180 + $tubeDirection]]     
        set miter_SideViewCone          [vectormath::rotateCoordList  {0 0} $miter_SideViewCone         [expr 180 + $tubeDirection]]     
            #
        setValue /result/Miter_ToolPlane        ${miter_ToolPlane}
        setValue /result/Miter_BaseDiameter     ${miter_BaseDiameter}
        setValue /result/Miter_TopDiameter      ${miter_TopDiameter}
        setValue /result/Miter_Cone             ${miter_Tool}
        setValue /result/MiterView_Plane        ${miter_SideViewToolPlane}
        setValue /result/MiterView_BaseDiameter ${miter_SideViewBaseDiameter}
        setValue /result/MiterView_TopDiameter  ${miter_SideViewTopDiameter}
        setValue /result/MiterView_Tool         ${miter_SideViewTool}
        setValue /result/MiterView_Cone         ${miter_SideViewCone}
        setValue /result/Shape_ToolPlane        ${shape_ToolPlaneView}
        setValue /result/Shape_Debug            ${shape_DebugView}
            #
        foreach {x y} [getValue /result/MiterView_Plane] {
            # puts "        -> $x $y"
        }
            #
        # puts "\n"    
        puts " --< model::miter_Cone > --"
        # puts "\n"    
            #
        return    
            #
    }
    proc model::miter_Cylinder {} {
            #
        set tubeDiameter    [getValue /tube/Diameter_Miter]
        set tubeDirection   [getValue /geometry/Tube_Direction]
        set toolDirection   [getValue /geometry/ToolTube_Direction]
        set tubeOffset      [getValue /geometry/Tube_Offset]
        set baseHeight      [getValue /toolTube/Length_BaseCylinder]
        set baseDiameter    [getValue /toolTube/Diameter_Base]
        set topDiameter     [getValue /toolTube/Diameter_Top]
        set miterAngle      [getValue /result/Miter_Angle]       
        set precision       [getValue /settings/precision]
            #
        set tubePerimeter   [expr $tubeDiameter * $vectormath::CONST_PI]
        set tubeRadius      [expr 0.5 * $tubeDiameter]
        set toolRadiusBase  [expr 0.5 * $baseDiameter]
        set toolRadiusTop   [expr 0.5 * $topDiameter]
            #
        set offset_ConeIS        [expr 1.0 * $tubeOffset - $baseHeight]
        set offset_tubePerimeter [expr 1.0 * $tubePerimeter / $precision]
        set offset_tubeAngle     [expr 1.0 * 360 / $precision]
            #
        set frustumHeight   [getValue /toolTube/Length_Cone]
        set tubeOffset      [getValue /geometry/Tube_Offset]
        set baseHeight      [getValue /toolTube/Length_BaseCylinder]
        set offsetIntersect [expr 1.0 * $tubeOffset - $baseHeight]
        set toolConeRatio   [expr ($toolRadiusTop - $toolRadiusBase) / $frustumHeight]
        set toolConeLength  [expr $toolRadiusBase / $toolConeRatio]
        set toolConeRadius  [expr $toolRadiusBase - $toolConeRatio * $offsetIntersect]
            #
            #
        set miterAngleCompl [expr 180.0 - $miterAngle]
                
        puts "\n"    
        puts " --< model::miter_Cylinder > --"    
        puts "        -> \$tubeRadius            $tubeRadius \[mm\]"
        puts "        -> \$miterAngle            $miterAngle \[\°\]"
        puts "        -> \$toolRadiusBase        $toolRadiusBase  \[mm\]"
        puts "        -> \$toolRadiusTop         $toolRadiusTop   \[mm\]"
        puts "        -> \$frustumHeight         $frustumHeight   \[mm\]"
        puts "        -> \$precision             $precision \[\]"
        puts "        -> \$tubePerimeter         $tubePerimeter \[mm\]"
        puts "        -> \$offset_tubePerimeter  $offset_tubePerimeter \[mm\]"
        puts "        -> \$offset_tubeAngle      $offset_tubeAngle \[\°\]"
        puts "        -> \$toolConeRatio         $toolConeRatio \[\]"
        puts "        -> \$toolConeLength        $toolConeLength \[mm\]"
        puts "        -> \$toolConeRadius        $toolConeRadius \[mm\]"
        puts "        -> \$offsetIntersect       $offsetIntersect \[mm\]"
        puts " --< model::miter_Cylinder > --"    
        puts "\n"  
            #
        if {$miterAngle == 180} {
            puts "\n"  
            puts "    <E> ... can not cut tube"  
            puts "\n"  
            return
        }
        
            # exit
            #
            #       
            #           x  ^            
            #              | /  z
            #              |/
            #              /
            #             /|
            #            / |       
            #           /  |      
            #          /   |       
            #         +----+ y(r)         
            #         |\ r |      
            #    x(r) | \  |      
            #         |  \ |      
            #         |   \|      
            #      ---+----+----------> y  tubeAngle = 0
            #              |   
            #              |
            #     -180° tubeAngle => 180° 
            #
            #
        set i_Angle -180
        set i_Perimeter [expr -0.5 * $tubePerimeter]
        while {$i_Angle <= 180} {
                #
            set radiusTube_x        [expr $tubeRadius * sin([vectormath::rad $i_Angle])]
            set radiusTube_y        [expr $tubeRadius * cos([vectormath::rad $i_Angle])]
                #
                # -- create projection of tube on plane of tool             -> list_Projection_ToolPlane
                #
            set offSetTube_z        [expr $radiusTube_y / sin([vectormath::rad $miterAngleCompl])]
                #
                # -- create cut with plane of tool                          -> list_Miter_ToolPlane
                #
            set offSetToolPlane     [expr $radiusTube_y / tan([vectormath::rad $miterAngleCompl])]
                #
                # -- create miter with base- and top diameter of conic tool -> list_Miter_BaseCylinder
                #                                                           -> list_Miter_TopCylinder
                #
            set radiusTool_Base_y   [expr {sqrt($toolRadiusBase * $toolRadiusBase - $radiusTube_x * $radiusTube_x )}]
            set offSetBaseDiameter  [expr -1.0 * $radiusTool_Base_y / sin([vectormath::rad $miterAngleCompl]) + $radiusTube_y / tan([vectormath::rad $miterAngleCompl])]
            set radiusTool_Top_y    [expr {sqrt($toolRadiusTop  * $toolRadiusTop  - $radiusTube_x * $radiusTube_x )}]
                #
            # puts "   -> \$i_Angle .......... $i_Angle "    
            # puts "   -> \$radiusTool_Base_y ..... $radiusTool_Base_y ($radiusTube_x / $radiusTube_y) "    
            # puts "   -> \$offSetBaseDiameter  ... $offSetBaseDiameter  "   
                #
            if {[expr abs($radiusTube_x)] < 0.00001} {set radiusTube_x 0}
            if {[expr abs($radiusTube_y)] < 0.00001} {set radiusTube_y 0}
            if {[expr abs($offSetTube_z)] < 0.00001} {set offSetTube_z 0}
                #
            if {[expr abs($offSetToolPlane)]     < 0.00001} {set offSetToolPlane     0}
            if {[expr abs($offSetBaseDiameter)]  < 0.00001} {set offSetBaseDiameter  0}
                #
            lappend list_TubePerimeter          $i_Perimeter    
            lappend list_Tube_x                 $radiusTube_x    
            lappend list_Tube_y                 $radiusTube_y    
            lappend list_Miter_ToolPlane        $offSetToolPlane     
            lappend list_Miter_BaseCylinder     $offSetBaseDiameter 
                #
            lappend list_Projection_ToolPlane   $offSetTube_z    
                #
            set i_Angle     [expr {$i_Angle + $offset_tubeAngle}]
            set i_Perimeter [expr {$i_Perimeter + $offset_tubePerimeter}]
        }
            #
            #
            #
        set listLength [llength $list_TubePerimeter]
            #
            
            #
            #
            # -- miter_ToolPlaneView
            #  ... contains a projection of tube to a plane in direction of tool
            # puts "\n\n\n\n == [llength $list_Projection_ToolPlane] =================================================="    
        set i 0
        set miter_ToolPlaneView {}
        foreach key $list_Tube_x  {
            set value [lindex $list_Projection_ToolPlane $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_ToolPlaneView $key $value
            incr i
        }
            #
            # - create miter with conic tool
            #
                #
                # set coneMiter [coneMiter $R_Frustum_Base $R_Frustum_Top $H_Frustum $R_Tube $alpha $hks]
                #
                #   R_Frustum_Base ... Radius des Kegelstumpf unten
                #   R_Frustum_Top .... Radius des Kegelstumpf oben
                #   H_Frustum ........ Höhe des Kegelstumpf    
                #
                #   R_Tube ........... Radius Zylinder in mm
                #   alpha ............ Schnittwinkel in grad (FrustumTop -> Joint <- Tube)
                #   hks .............. Höhe von Kegelfuß bis Achsenschnittpunkt
            #
            #
        set diameter          $tubeDiameter
        set direction         [vectormath::rotateLine {0 0} 1 $tubeDirection]
        set diameter_isect    $baseDiameter
        set direction_isect    [vectormath::rotateLine {0 0} 1 $toolDirection]
        set isectionPoint     {0 0}
        
        puts "        -> \$tubeDiameter          $tubeDiameter         \[mm\]"
        puts "        -> \$tubeDirection         $tubeDirection        \[\°\]"
        puts "        -> \$diameter_isect        $diameter_isect       \[mm\]"
        puts "        -> \$direction_isect       $direction_isect      \[\°\]"
        puts ""    
        puts "        -> \$diameter              $diameter         \[mm\]"
        puts "        -> \$direction             $direction        \[\°\]"
        puts "        -> \$diameter_isect        $diameter_isect   \[mm\]"
        puts "        -> \$direction_isect       $direction_isect  \[mm\]"
        puts "        -> \$isectionPoint         $isectionPoint    \[mm\]"
            #
        puts "        -> \$tubeRadius            $tubeRadius \[mm\]"
        puts "        -> \$miterAngle            $miterAngle \[\°\]"
        puts "        -> \$toolRadiusBase        $toolRadiusBase  \[mm\]"
        puts "        -> \$toolRadiusTop         $toolRadiusTop   \[mm\]"
        
        set tubeSide    $control::miterView
        set tubeOffset  $control::tubeOffset
        
        puts "        -> \$tubeSide     $tubeSide   \[\]"
        puts "        -> \$tubeOffset   $tubeOffset \[mm\]"
        
        
        set miterAngle [vectormath::angle $direction {0 0} $direction_isect]
        puts $miterAngle
            #
        puts "<I> tubeMiter::cylinderMiter  -> $toolRadiusBase $tubeRadius $miterAngle $tubeSide $tubeOffset "
            #
            #
        set list_Miter [tubeMiter::cylinderMiter $toolRadiusBase $tubeRadius $miterAngle $tubeSide $tubeOffset]
        
        puts $list_Miter
        #exit
        
        set miter_Tool          [lindex $list_Miter 0]   
        set miter_SideViewTool  [lindex $list_Miter 1]   
        set miter_SideViewCone  [lindex $list_Miter 2]   
            #
            #
            #
        set listLength [llength $list_TubePerimeter]
            #
            #
            # -- miter perimeter
            #
            # puts "\n\n\n\n == [llength $list_TubePerimeter] =================================================="    
        set i 0
        set miter_ToolPlane {}
        foreach key $list_TubePerimeter {
            set value [lindex $list_Miter_ToolPlane $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_ToolPlane $key $value 
            incr i
        }
            # puts "\n\n\n\n == [llength $list_TubePerimeter] =================================================="    
        set i 0
        set miter_BaseDiameter {}
        foreach key $list_TubePerimeter {
            set value [lindex $list_Miter_BaseCylinder $i]
            # puts "      -> $i  - $key -> $value"
            lappend miter_BaseDiameter $key $value 
            incr i
        }
            # puts "\n\n\n\n == [llength $list_TubePerimeter] =================================================="    
        set i 0
        set miter_TopDiameter {}
            #
            # -- side view
            #
            # puts "\n\n\n\n == [llength $list_Miter_ToolPlane] =================================================="    
        set i 0
        set miter_SideViewToolPlane {}
        foreach key $list_Miter_ToolPlane {
            if {$i > [expr 0.5 * $listLength -1 ]} {
                set value [lindex $list_Tube_y $i]
                # puts "      -> $i  - $key -> $value"
                lappend miter_SideViewToolPlane $key $value
            }
            incr i
        }
            # puts "\n\n\n\n == [llength $list_Miter_BaseCylinder] =================================================="    
        set i 0
        set miter_SideViewBaseDiameter {}
        foreach key $list_Miter_BaseCylinder {
            if {$i > [expr 0.5 * $listLength -1 ]} {
                set value [lindex $list_Tube_y $i]
                # puts "      -> $i  - $key -> $value"
                lappend miter_SideViewBaseDiameter $key $value
            }
            incr i
        }
            # puts "\n\n\n\n == [llength $list_Miter_BaseCylinder] =================================================="    
        set i 0
        set miter_SideViewTopDiameter {}
            #
            #
        set shape_DebugView         $miter_ToolPlaneView
        
        set shape_ToolPlaneView     [vectormath::rotateCoordList {0 0} $miter_ToolPlaneView [expr $toolDirection + 90]]
            #
        foreach {key value} $miter_ToolPlaneView {
            # puts "       -<debug>- $key $value"
        }
            #
            # puts "    -> \$miter_SideView  <[llength $miter_SideView]>  $miter_SideView" 
        set miter_SideViewToolPlane     [vectormath::rotateCoordList  {0 0} $miter_SideViewToolPlane    [expr   0 + $tubeDirection]]     
        set miter_SideViewBaseDiameter  [vectormath::rotateCoordList  {0 0} $miter_SideViewBaseDiameter [expr 180 + $tubeDirection]]     
        set miter_SideViewTopDiameter   [vectormath::rotateCoordList  {0 0} $miter_SideViewTopDiameter  [expr 180 + $tubeDirection]]     
        set miter_SideViewTool          [vectormath::rotateCoordList  {0 0} $miter_SideViewTool         [expr 180 + $tubeDirection]]     
        set miter_SideViewCone          [vectormath::rotateCoordList  {0 0} $miter_SideViewCone         [expr 180 + $tubeDirection]]     
            #
        setValue /result/Miter_ToolPlane        ${miter_ToolPlane}
        setValue /result/Miter_BaseDiameter     ${miter_BaseDiameter}
        setValue /result/Miter_TopDiameter      ${miter_TopDiameter}
        setValue /result/Miter_Cone             ${miter_Tool}
        setValue /result/MiterView_Plane        ${miter_SideViewToolPlane}
        setValue /result/MiterView_BaseDiameter ${miter_SideViewBaseDiameter}
        setValue /result/MiterView_TopDiameter  ${miter_SideViewTopDiameter}
        setValue /result/MiterView_Tool         ${miter_SideViewTool}
        setValue /result/MiterView_Cone         ${miter_SideViewCone}
        setValue /result/Shape_ToolPlane        ${shape_ToolPlaneView}
        setValue /result/Shape_Debug            ${shape_DebugView}
            #
        foreach {x y} [getValue /result/MiterView_Plane] {
            # puts "        -> $x $y"
        }
            #
        # puts "\n"    
        puts " --< model::miter_Cylinder > --"
        # puts "\n"    
            #
        return    
            #
    }

        #
        # -- CONTROL --
        #
    proc control::change_View {} {
            #
        variable miterView
            #
        if {$miterView eq "left"} {
            set miterView "right"
        } else {
            set miterView "left"
        }
            #
        control::update control::toolType _any_   
            #
    }
    proc control::change_toolType {} {
            #
        variable toolType
            #
        if {$toolType == 1} {
            set toolType 0
        } else {
            set toolType 1
        }
            #
        control::update control::toolType _any_   
            #
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
    proc control::cleanReport {} {
        # puts " -> control::cleanReport: $::view::reportText"
        catch {$::view::reportText   delete  1.0 end}
    }
    proc control::writeReport {text} {
        # puts " -> control::writeReport: $::view::reportText"
        catch {$::view::reportText   insert  end "$text\n"}
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
    proc control::dimensionMessage { x y id} {
            tk_messageBox -message "giveMessage: $x $y $id"  
        }        
    proc control::serializeValues {} {
            #
        foreach key {   geometry/ToolTube_Direction  \
                        geometry/Tube_Direction      \
                        geometry/Tube_Offset         \
                        toolTube/Diameter_Base       \
                        toolTube/Diameter_Top        \
                        toolTube/Length              \
                        toolTube/Length_BaseCylinder \
                        toolTube/Length_Cone         \
                        tube/Diameter_Miter          \
                        tube/Length                  \
                        settings/viewOffset          \
                        result/Base_Position         \
                        result/Miter_Angle           \
                        result/Profile_Tool          \
                        result/Profile_Tube          \
                        result/Shape_Tool            \
                        result/Shape_Tube }          \
        {
                 #
            set ::model::$key [model::getValue $key]    
        }
    }
    

    proc control::update {key value} {
        puts "\n\n--< control::update >--"
        puts "      \$key:     $key"
        set dictPath    [lindex [split $key ::] 2]
        set parseKey    [lindex [split $dictPath /] 0]
            # puts "      \$keyPrefix:   $keyPrefix"
            # puts "      \$keyPrefix:   [split $keyPrefix ::]"
            # puts "      \$keyPrefix:   $keyPrefix"
        puts "      \$value:   $value"
        switch -exact $parseKey {
            toolTube -
            tube - 
            geometry -
            settings {
                model::setValue $dictPath $value
                model::update_MiterSettings 
                model::create_ToolGeometry $control::toolType
                model::create_TubeGeometry 
                if {$control::toolType == 0} {
                    model::miter_Cone
                } else {
                    model::miter_Cylinder
                }
                # model::miterConePeter
            }
            default {}
        }
        switch -exact $key {
            control::tubeSide -
            control::tubeOffset -
            control::toolType {
                model::update_MiterSettings 
                model::create_ToolGeometry $control::toolType
                model::create_TubeGeometry 
                if {$control::toolType == 0} {
                    model::miter_Cone
                } else {
                    model::miter_Cylinder
                }
                #appUtil::pdict $model:.dict_TubeMiter
            }
        }
        puts "--< control::update >--\n\n"
            #
        control::serializeValues
            #
        updateStage
            #
        if {[catch {updateStage} eID]} {
            puts "\n\n"
            puts "    <E> control::update "
            puts "        -> control::updateStage "
            puts "$eID"
            puts "    <E> control::update "
            puts "\n\n"
        }
            #
        # appUtil::pdict $model::dict_TubeMiter     
            #
        return
    }
    proc control::updateStage {{value {0}}} {
            #
        variable  drw_scale
        variable  dim_size
        variable  dim_font_select
        variable  dim_size
        variable  dim_dist 
        variable  dim_offset
        variable  font_colour
            #
            #
        array set pos {}    
            #
            #
        set myCanvas $::view::stageNamespace
            #
        $myCanvas clean_StageContent
            #
        cleanReport
            # $::view::reportText delete 1.0  end
            #
        $myCanvas setNodeAttr Stage    scale        $drw_scale
        $myCanvas setNodeAttr Style    fontstyle    $dim_font_select
        $myCanvas setNodeAttr Style    fontsize     $dim_size
            #
            #
            #
        set positionView  {120 160}
        set positionMiter {300 160}
        set positionDebug {210 160}
            #
            #
        set debugShape          [model::getValue /result/Shape_Debug]   
        set debugShape          [vectormath::addVectorCoordList $positionDebug $debugShape]
            #
        set shape_ToolPlane     [model::getValue /result/Shape_ToolPlane]   
        set shape_ToolPlane     [vectormath::addVectorCoordList $positionView $shape_ToolPlane]
            #
        set miterShape_Plane    [model::getValue /result/Miter_ToolPlane]   
        set miterShape_Plane    [vectormath::addVectorCoordList $positionMiter $miterShape_Plane]
            #
        set miterShape_Base     [model::getValue /result/Miter_BaseDiameter]   
        set miterShape_Base     [vectormath::addVectorCoordList $positionMiter $miterShape_Base]    
            #
        set miterShape_Top      [model::getValue /result/Miter_TopDiameter]   
        set miterShape_Top      [vectormath::addVectorCoordList $positionMiter $miterShape_Top]    
            #
        set miterShape_Cone     [model::getValue /result/Miter_Cone] 
        set miterShape_Cone     [vectormath::addVectorCoordList $positionMiter $miterShape_Cone]    
            #
        set miterView_Plane     [model::getValue /result/MiterView_Plane]   
        set miterView_Plane     [vectormath::addVectorCoordList $positionView $miterView_Plane]    
            #
        set MiterView_BaseDiam  [model::getValue /result/MiterView_BaseDiameter]   
        set MiterView_BaseDiam  [vectormath::addVectorCoordList $positionView $MiterView_BaseDiam]    
            #
        set MiterView_TopDiam   [model::getValue /result/MiterView_TopDiameter]   
        set MiterView_TopDiam   [vectormath::addVectorCoordList $positionView $MiterView_TopDiam]    
            #
        set MiterView_Tool      [model::getValue /result/MiterView_Tool]   
        set MiterView_Tool      [vectormath::addVectorCoordList $positionView $MiterView_Tool]    
            #
        set MiterView_Cone      [model::getValue /result/MiterView_Cone]   
        set MiterView_Cone      [vectormath::addVectorCoordList $positionView $MiterView_Cone]    
            #
        set toolPolygon         [model::getValue /result/Shape_Tool]   
        set toolPolygon         [vectormath::addVectorPointList $positionView $toolPolygon]
            #
        set toolPolygonCone     [model::getValue /result/ShapeCone_Tool]   
        set toolPolygonCone     [vectormath::addVectorCoordList $positionView $toolPolygonCone]
            #
        set edgeLine_01 [list [lindex $toolPolygonCone 0] [lindex $toolPolygonCone 1] [lindex $toolPolygonCone 6] [lindex $toolPolygonCone 7]]
        set edgeLine_02 [list [lindex $toolPolygonCone 2] [lindex $toolPolygonCone 3] [lindex $toolPolygonCone 4] [lindex $toolPolygonCone 5]]
            #
        set tubePolygon [model::getValue /result/Shape_Tube]   
        set tubePolygon [vectormath::addVectorCoordList $positionView $tubePolygon]   
            #
        puts "    -> $toolPolygon"
            #
        set pos(tubeJoint)  $positionView
        set pos(toolBase)   [vectormath::center [lrange $edgeLine_01  0 1]  [lrange $edgeLine_01  2 3] ]
        set pos(toolTop)    [vectormath::center [lrange $edgeLine_02  0 1]  [lrange $edgeLine_02  2 3] ]
        set pos(tool_01)    [lindex $toolPolygon   0]
        set pos(tool_02)    [lindex $toolPolygon   1]
        set pos(tool_03)    [lindex $toolPolygon   2]
        set pos(tool_04)    [lindex $toolPolygon   3]
        set pos(tool_05)    [lindex $toolPolygon   4]
        set pos(tool_06)    [lindex $toolPolygon   5]
        set pos(tool_07)    [lindex $toolPolygon   6]
        set pos(tool_08)    [lindex $toolPolygon   7]
        puts " ---> \$pos(tool_01) $pos(tool_01) \$pos(tool_08) $pos(tool_08) "
        set pos(tool_00)    [vectormath::center $pos(tool_01) $pos(tool_08)]
        set pos(tool_10)    [vectormath::center $pos(tool_04) $pos(tool_05)]
            #
        set pos(tube_01)    [lrange $tubePolygon   0  1]
        set pos(tube_02)    [lrange $tubePolygon   2  3]
        set pos(tube_03)    [lrange $tubePolygon   4  5]
        set pos(tube_04)    [lrange $tubePolygon   6  7]
        set pos(tube_10)    [vectormath::center $pos(tube_02) $pos(tube_03)]
            #
        catch {
            set pos(is_base)    [vectormath::intersectPoint $pos(tube_01) $pos(tube_02) $pos(tool_02) $pos(tool_03) ]    
            set pos(is_top)     [vectormath::intersectPoint $pos(tube_03) $pos(tube_04) $pos(tool_02) $pos(tool_03) ]
        } else {
            set pos(is_base)    $pos(tool_01)  
            set pos(is_top)     $pos(tool_02) 
        }
            #
        set pos(is_coneTop) [lrange $MiterView_Cone end-1 end]   
        set pos(is_coneBot) [lrange $MiterView_Cone 0 1]   
            #
        set pos(cl_x01)     [vectormath::addVector $positionMiter {-70 0} ]
        set pos(cl_x02)     [vectormath::addVector $positionMiter {+70 0} ]
        set pos(cl_y01)     [vectormath::addVector $positionMiter {0 -70} ]
        set pos(cl_y02)     [vectormath::addVector $positionMiter {0 +50} ]
            #
            #
            # redefine tube representation with miterprofile of Cone
        set tubePolygon {}        
        lappend tubePolygon $pos(tube_02)     
        lappend tubePolygon $MiterView_Tool
        lappend tubePolygon $pos(tube_03)     
            #
        # puts "     -> \$pos(tubeJoint) ...... $pos(tubeJoint)"
        # puts "     -> \$pos(toolTop) ........ $pos(toolTop)"
        # puts "     -> \$pos(toolBase) ....... $pos(toolBase)"
        # puts "     -> \$pos(tool_01) ........ $pos(tool_01)"
        # puts "     -> \$pos(tool_02) ........ $pos(tool_02)"
        # puts "     -> \$pos(tool_03) ........ $pos(tool_03)"
        # puts "     -> \$pos(tool_04) ........ $pos(tool_04)"
        # puts "     -> \$pos(tool_05) ........ $pos(tool_05)"
        # puts "     -> \$pos(tool_06) ........ $pos(tool_06)"
        # puts "     -> \$pos(tool_07) ........ $pos(tool_07)"
        # puts "     -> \$pos(tool_08) ........ $pos(tool_08)"
            #
            #
            #
        $myCanvas  create line          $miterShape_Plane   -tags {miterPlane}  -fill red       -width 1.0 
        $myCanvas  create line          $miterShape_Base    -tags {miterBase}   -fill darkblue  -width 1.0 
        catch {$myCanvas  create line          $miterShape_Top     -tags {miterTop}    -fill blue      -width 1.0 }
        catch {$myCanvas  create line          $miterShape_Cone    -tags {miterTop}    -fill red       -width 2.0}
            #
        $myCanvas  create centerline    [list $pos(cl_x01) $pos(cl_x02)]         -fill orange    -width 0.35     -tags __CenterLine__
        $myCanvas  create centerline    [list $pos(cl_y01) $pos(cl_y02)]         -fill orange    -width 0.35     -tags __CenterLine__
            #
        $myCanvas  create polygon       $toolPolygon        -tags {toolShape}  -outline black  -fill gray80 -width 1.0 
        $myCanvas  create line          $edgeLine_01        -tags {edge_01} -fill red -width 1.0
        $myCanvas  create line          $edgeLine_02        -tags {edge_02} -fill red -width 1.0
        $myCanvas  create polygon       $tubePolygon        -tags {tubeShape}  -outline red    -fill gray80 -width 1.0 
            #
        #$myCanvas  create line          $miterView_Plane    -tags {miterViewPlane}  -fill red       -width 2.0 
        $myCanvas  create line          $MiterView_BaseDiam -tags {miterViewBase}   -fill darkblue  -width 1.0 
        catch {$myCanvas  create line          $MiterView_TopDiam  -tags {miterViewTop}    -fill blue      -width 1.0}
            #
        $myCanvas  create circle        $pos(tubeJoint)     -radius  1              -outline red    -width 0.35     -tags __CenterLine__
        $myCanvas  create circle        $pos(is_base)       -radius  1              -outline red    -width 0.35     -tags __CenterLine__
        $myCanvas  create circle        $pos(is_top)        -radius  1              -outline red    -width 0.35     -tags __CenterLine__
        puts "  -> \$MiterView_Cone  $MiterView_Cone"
            puts "  -> \$pos(is_coneTop) $pos(is_coneTop)"
            puts "  -> \$pos(is_coneBot) $pos(is_coneBot)"
        catch {$myCanvas  create line          $MiterView_Cone     -tags {miterViewCone}   -fill orange    -width 2.0 }
        catch {$myCanvas  create circle    $pos(is_coneTop) -radius  1              -outline blue   -width 0.35     -tags __CenterLine__ }
        catch {$myCanvas  create circle    $pos(is_coneBot) -radius  1              -outline blue   -width 0.35     -tags __CenterLine__ }

        $myCanvas  create centerline    [list $pos(tubeJoint) $pos(tube_10)]    -fill orange    -width 0.35     -tags __CenterLine__
        $myCanvas  create centerline    [list $pos(tool_00) $pos(tool_10)]      -fill orange    -width 0.35     -tags __CenterLine__
            #
        #$myCanvas  create line          $shape_ToolPlane    -tags {debugShape}  -fill red -width 1.0 
        $myCanvas  create line          $debugShape         -tags {debugShape}  -fill red -width 1.0 
            #
            #
            #
        set dim_offset [expr $drw_scale * $dim_offset]    
            #
        set tagDimension [ $myCanvas dimension  length   [list $pos(tool_01)  $pos(tool_08)] \
                    {aligned}       [expr $drw_scale * 12]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $pos(tool_05)  $pos(tool_04)] \
                    {aligned}       [expr $drw_scale * 12]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $pos(tool_08)  $pos(tool_07)] \
                    {aligned}       [expr $drw_scale * 12]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $pos(tool_02)  $pos(tool_07)  $pos(tubeJoint)] \
                    {perpendicular} [expr $drw_scale * 12]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $pos(tool_02)  $pos(tool_07)  $pos(tool_06)] \
                    {perpendicular} [expr $drw_scale * 20]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
        set tagDimension [ $myCanvas dimension  length   [list $pos(tool_01)  $pos(tool_08)  $pos(tool_05)] \
                    {perpendicular} [expr $drw_scale * 28]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
            #
        set tagDimension [ $myCanvas dimension  length   [list $pos(tube_03)  $pos(tube_02)] \
                    {aligned}       [expr $drw_scale * 12]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
            #
        set tagDimension [ $myCanvas dimension  angle   [list $pos(tubeJoint)  $pos(tool_10) $pos(tube_10)] \
                                    [expr $drw_scale * 80]   $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
            #
        set tagDimension [ $myCanvas dimension  length   [list [lrange $miterShape_Plane 0 1]  [lrange $miterShape_Plane end-1 end]] \
                    {aligned}       [expr $drw_scale * -50]  $dim_offset  $font_colour ] 
            lappend __Dimension__ $tagDimension
            #
            #
                    
            
        return
    }
        
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
    proc view::createStage {cv_path cv_width cv_height st_width st_height unit st_scale args} {
        variable stageCanvas
        variable stageNamespace
        variable cv_scale
            #
        set parentPath [file rootname $cv_path]
        set cvName     [file tail $cv_path]
            #
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
            

            #
            ### -- G U I - canvas demo
                
            set f_settings  [labelframe .f0.f_config.f_settings  -text "Test - Settings" ]
                
            labelframe  $f_settings.geometry        -text "Geometry"
            labelframe  $f_settings.tooltube        -text "Tool - Tube"
            labelframe  $f_settings.tube            -text "Tube"
            labelframe  $f_settings.view            -text "View"
            labelframe  $f_settings.precission      -text precission
            labelframe  $f_settings.font            -text font
            labelframe  $f_settings.demo            -text demo
            labelframe  $f_settings.tooltype        -text "ToolType:"
            labelframe  $f_settings.scale           -text scale

            pack    $f_settings.geometry    \
                    $f_settings.tooltube    \
                    $f_settings.tube        \
                    $f_settings.view        \
                    $f_settings.precission  \
                    $f_settings.font        \
                    $f_settings.demo        \
                    $f_settings.tooltype    \
                    $f_settings.scale   -fill x -side top
                        
            # pack    $f_settings.tooltube    \
                    $f_settings.tube        \
                    $f_settings.geometry    \
                    $f_settings.orientation \
                        $f_settings.centerline  \
                        $f_settings.tubeprofile \
                        $f_settings.precission  \
                        $f_settings.font        \
                        $f_settings.demo        \
                        $f_settings.scale   -fill x -side top 
            
            view::create_config_line $f_settings.geometry.d_tt      "Direction ToolTube:  "     control::geometry/ToolTube_Direction      70   190   ;#   0
            view::create_config_line $f_settings.geometry.d_t       "Direction Tube:      "     control::geometry/Tube_Direction          90   270   ;#   0
            view::create_config_line $f_settings.geometry.o_t       "OffsetTube:          "     control::geometry/Tube_Offset             30    90   ;#   0
            
            view::create_config_line $f_settings.tooltube.l_cone    "Length Cone:         "     control::toolTube/Length_Cone             10   120   ;#   0
            view::create_config_line $f_settings.tooltube.l_base    "Length BaseCylinder: "     control::toolTube/Length_BaseCylinder      0    30   ;#   0
            view::create_config_line $f_settings.tooltube.d_top     "Diameter Top   :     "     control::toolTube/Diameter_Top            20    60   ;#   0
            view::create_config_line $f_settings.tooltube.d_bse     "Diameter Base  :     "     control::toolTube/Diameter_Base           30    70   ;#   0
            view::create_config_line $f_settings.tooltube.l         "Length:              "     control::toolTube/Length                  90   250   ;#   0
            
            view::create_config_line $f_settings.tube.l             "Diameter:            "     control::tube/Diameter_Miter              20    60   ;#   0
            view::create_config_line $f_settings.tube.d             "Length:              "     control::tube/Length                      60   120   ;#   0
            view::create_config_line $f_settings.tube.offset        "Offset:              "     control::tubeOffset                      -15    15   ;#  24
            
            view::create_config_line $f_settings.view.miteroffset   "Offset-Miter         "     control::settings/viewOffset             -90    90   ;#   0
            
            button  $f_settings.tooltype.type   -width 30  -text    "cone/cylinder" -command control::change_toolType
            button  $f_settings.tooltype.view   -width 30  -text    "right/left"    -command control::change_View
            pack    $f_settings.tooltype.type \
                    $f_settings.tooltype.view \
                -side top  -fill x
            
            
            view::create_config_line $f_settings.precission.prec    " precission:  "  control::arcPrecission      1  15   ;#  24

            view::create_config_line $f_settings.scale.drw_scale    " Drawing scale "  control::drw_scale       0.2  2  
            view::create_config_line $f_settings.scale.cv_scale     " Canvas scale  "  control::cv_scale        0.2  5.0  
                               $f_settings.scale.drw_scale.scl      configure       -resolution 0.1
                               $f_settings.scale.cv_scale.scl       configure       -resolution 0.1  -command "control::scale_board"
            button             $f_settings.scale.recenter   -text   "recenter"      -command {control::recenter_board}
            button             $f_settings.scale.refit      -text   "refit"         -command {control::refit_board}

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
            #set f_print  [labelframe .f0.f_config.f_print  -text "Print" ]
            #    button  $f_print.bt_print   -text "print"  -command {$view::stageCanvas print "E:/manfred/_devlp/_svn_sourceforge.net/canvasCAD/trunk/_print"} 
            #pack  $f_print  -side top     -expand yes -fill x
            #    pack $f_print.bt_print     -expand yes -fill x
            
            
                #
                ### -- G U I - canvas demo
                #   
            set f_demo  [labelframe .f0.f_config.f_demo  -text "Demo" ]
                button  $f_demo.bt_clear   -text "clear"    -command {$::view::stageNamespace clean_StageContent} 
                button  $f_demo.bt_update  -text "update"   -command {control::updateStage}
             
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

            puts "  <D> $reportText"
            puts "  <D> $view::reportText"
            control::cleanReport
            control::writeReport "aha"
            # exit
            
            
            ####+### E N D
            
            update
            
            wm minsize . [winfo width  .]   [winfo height  .]
            wm title   . $windowTitle
            
            return . $stageCanvas
  
    }


        #
        # -- update model
        #
    model::update_MiterSettings
    model::create_ToolGeometry $control::toolType
    if {$control::toolType == 0} {
        model::miter_Cone
    } else {
        model::miter_Cylinder
    }
    model::create_TubeGeometry
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
    # control::updateStage
 
 