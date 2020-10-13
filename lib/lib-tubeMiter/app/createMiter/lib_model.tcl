 ########################################################################
 #
 # simplifySVG: lib_model.tcl
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
  
namespace eval tubeMiter::app::createMiter::model {
      
    # --------------------------------------------
        # Export as global command
    variable packageHomeDir [file normalize [file join [pwd] [file dirname [file dirname [info script]]]]]
    
    # --------------------------------------------
    #  create base config 
    #       -> registryDOM
        #
    variable miterObject
    variable configDict
    variable toolShapeDict
        #
    variable CONST_PI       [expr 4*atan(1)]        
        #
    variable exportDir      [file join $env(HOME) Documents]
    variable pdfViewer      {}
        #
    variable templateSVG \
           {<?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
            <svg width="297mm" height="210mm" viewBox="0 0 297 210">
            <defs>
            </defs>
            </svg>}
        #
}
    #
proc tubeMiter::app::createMiter::model::init {} {
    variable miterObject
    set miterObject     [tubeMiter::createMiter]
}
    #
proc tubeMiter::app::createMiter::model::getMiterObject {} {
    variable miterObject
    return $miterObject
}
    #
proc tubeMiter::app::createMiter::model::update {dict} {
        #
    puts "\n  --- updateModel ---\n"
        #
    variable miterObject
    variable configDict     $dict
        #
        # puts "     -> \$miterObject $miterObject"
        # puts "     -> \$configDict  $configDict"
        #
        #
        # puts " ---------- "
        # appUtil::pdict $configDict 2 "  "
        # puts " ---------- "
        #
        #
    set tubeType    [dict get $configDict tube type]
    set toolType    [dict get $configDict tool type]
        #
        # puts "    -> \$tubeType ->  $tubeType"
        # puts "    -> \$toolType ->  $toolType"
        #
    switch -exact $tubeType {
        oval {
            set tubeDict \
                [list   -type           oval \
                        -diameter_x     [dict get $configDict tube  diameter_x] \
                        -diameter_y     [dict get $configDict tube  diameter_y] \
                        -rotation       [dict get $configDict miter rotation] \
                        -precision      [dict get $configDict miter precision] \
                    ]    
        }
        round -
        default {
            set tubeDict \
                [list   -type           round \
                        -diameter       [dict get $configDict tube  diameter] \
                        -rotation       [dict get $configDict miter rotation] \
                        -precision      [dict get $configDict miter precision] \
                    ]
        }
    }    
        # puts " ---------- "
        # appUtil::pdict $tubeDict 2 "  "
        # puts " ---------- "
        #
        # puts "   -> \$miterObject $miterObject"
        #
    $miterObject setProfileDef $tubeDict  
        #
        #
    switch -exact $toolType {
        frustum {
            $miterObject setToolType                        frustum
            $miterObject setScalar      AngleTool           [dict get $configDict miter   angle]
            $miterObject setScalar      DiameterTool        [dict get $configDict tool    diameterBase]   
            $miterObject setScalar      DiameterTop         [dict get $configDict tool    diameterTop] 
            $miterObject setScalar      HeightToolCone      [dict get $configDict tool    length]    
            $miterObject setScalar      OffsetCenterLine    [dict get $configDict miter   offset_x]   
            $miterObject setScalar      OffsetToolBase      [dict get $configDict miter   offset_z] 
        }
        cone {
            $miterObject setToolType                        cone
            $miterObject setScalar      AngleTool           [dict get $configDict miter   angle]
            $miterObject setScalar      DiameterTool        [dict get $configDict tool    diameterBase]   
            $miterObject setScalar      HeightToolCone      [dict get $configDict tool    length]    
            $miterObject setScalar      OffsetCenterLine    [dict get $configDict miter   offset_x]   
        }
        cylinder {
            $miterObject setToolType                        cylinder
            $miterObject setScalar      AngleTool           [dict get $configDict miter   angle]
            $miterObject setScalar      DiameterTool        [dict get $configDict tool    diameter]   
            $miterObject setScalar      OffsetCenterLine    [dict get $configDict miter   offset_x]    
        }
        plane -
        default {
            $miterObject setToolType                        plane 
            $miterObject setScalar      AngleTool           [dict get $configDict miter   angle]
        }
    }
        #
    $miterObject updateMiter
        #
    update_ToolShape
        #
    return    
        #
}
    #
proc tubeMiter::app::createMiter::model::update_ToolShape {} {
        #
    variable configDict
    variable toolShapeDict
    variable CONST_PI    
        #
    set toolShapeDict   {}
        #
    set tubeType    [dict get $configDict tube type]
    set toolType    [dict get $configDict tool type]
        #
        # puts "    -> \$tubeType ->  $tubeType"
        # puts "    -> \$toolType ->  $toolType"
        #
    set miterAngle      [dict get $configDict miter   angle]
    set miterRotation   [dict get $configDict miter   rotation]
    set miterOffset_X   [dict get $configDict miter   offset_x]
        #
    switch -exact $tubeType {
        oval {
            set diameter_y  [dict get $configDict tube  diameter_y]
        }
        round -
        default {
            set diameter_y  [dict get $configDict tube  diameter]
        }
    }    
        #
    set cuttingLength   [expr $diameter_y / sin($miterAngle * $CONST_PI / 180)]
    set cuttingOffset   [expr 0.5 * $diameter_y / cos($miterAngle * $CONST_PI / 180)]
        #
    set length_00       [expr 0.5 * $cuttingLength]
    set pos_01          [vectormath::rotateLine  {0 0} [expr $length_00 + 5] [expr 90 - $miterAngle]]
    set pos_02          [vectormath::rotatePoint {0 0} $pos_01 180]
    set centerLine      [join "$pos_01 $pos_02" " "]
        #
    set borderLeft      [vectormath::parallel {0 40} {0  5} [expr  0.5 * $diameter_y +  5]]
    set borderRight     [vectormath::parallel {0  5} {0 40} [expr  0.5 * $diameter_y +  5]]
        #
    set borderLeft_2    [vectormath::parallel {0 40} {0  5} [expr  0.5 * $diameter_y + 10]]
    set borderRight_2   [vectormath::parallel {0  5} {0 40} [expr  0.5 * $diameter_y + 10]]
        #
    set debugTube       [join "$borderLeft $borderRight" " "]
        #
    set centerLine_xy   [list 0 [expr -0.5 * $diameter_y - 5] 0 [expr 0.5 * $diameter_y + 5]]   
    set centerLine_xz   {}   
        #
    set debugTool       {}
    set debugLine01     {}
        #
        # puts "   \$borderLeft  $borderLeft"
        # puts "   \$borderRight $borderRight"
        # puts "      $borderLeft   $borderRight"
        #
        #
    set toolShape       {}    
        #
    switch -exact $toolType {
        frustum {
            #
            set diameterTop     [dict get $configDict tool    diameterTop]
            set diameterBase    [dict get $configDict tool    diameterBase]
            set offset_z        [dict get $configDict miter   offset_z]
            set length_z        [dict get $configDict tool    length]
                #
            set lineToolTop     [vectormath::parallel $pos_02 $pos_01 [expr 0.5 * $diameterTop]]
            set lineToolBase    [vectormath::parallel $pos_02 $pos_01 [expr 0.5 * $diameterBase]]
            set debugTool       [join "[lindex $lineToolTop 0] [lindex $lineToolBase 1] $centerLine" " "]
                #
            set pos_11          [vectormath::rotateLine  {0 0}   $offset_z [expr  90 - $miterAngle]]
            set pos_12          [vectormath::rotateLine  $pos_11 $length_z [expr 270 - $miterAngle]]
                #
            set pos_21          [vectormath::perpendicular $pos_11 $pos_12 [expr 0.5 * $diameterBase] left]
            set pos_22          [vectormath::perpendicular $pos_12 $pos_11 [expr 0.5 * $diameterTop]]
            set pos_23          [vectormath::perpendicular $pos_12 $pos_11 [expr 0.5 * $diameterTop]  left]
            set pos_24          [vectormath::perpendicular $pos_11 $pos_12 [expr 0.5 * $diameterBase]]
                #
            set toolShape       [join [list $pos_21 $pos_22 $pos_23 $pos_24] " "]
                #
            set pos_31          [vectormath::addVector     $pos_11  [vectormath::unifyVector $pos_12 $pos_11 5]]
            set pos_32          [vectormath::addVector     $pos_12  [vectormath::unifyVector $pos_11 $pos_12 5]]
                #
            set centerLine_xz   [join "$pos_31 $pos_32" " "]    
                #
        }
        cone {
                #
            set diameterBase    [dict get $configDict tool    diameterBase]
            set length_z        [dict get $configDict tool    length]
                #
            set pos_11          {0 0}
            set pos_12          [vectormath::rotateLine  $pos_11 $length_z [expr 270 - $miterAngle]]
                #
            set pos_21          [vectormath::perpendicular $pos_11 $pos_12 [expr 0.5 * $diameterBase] left]
            set pos_24          [vectormath::perpendicular $pos_11 $pos_12 [expr 0.5 * $diameterBase]]
                #
            set toolShape       [join [list $pos_12 $pos_21 $pos_24] " "]
                #
            set pos_31          [vectormath::addVector     $pos_11  [vectormath::unifyVector $pos_12 $pos_11 5]]
            set pos_32          [vectormath::addVector     $pos_12  [vectormath::unifyVector $pos_11 $pos_12 5]]
                #
            set centerLine_xz   [join "$pos_31 $pos_32" " "]    
                #
        }
        cylinder {
                #
            set diameterTool    [dict get $configDict tool    diameter]
                #
            set lineToolTube    [vectormath::parallel $pos_02 $pos_01 [expr 0.5 * $diameterTool]]
            set debugTool       [join "$centerLine $lineToolTube" " "]
                #
            set pos_11          [vectormath::intersectPoint \
                                    [lindex $lineToolTube 0] [lindex $lineToolTube 1] \
                                    [lindex $borderLeft   0] [lindex $borderLeft   1] \
                ]   
            set pos_12          [vectormath::intersectPoint \
                                    [lindex $lineToolTube 0] [lindex $lineToolTube 1] \
                                    [lindex $borderRight  0] [lindex $borderRight  1] \
                ]   
                #
            set lineToolTube_00 [join "$pos_11 $pos_12" " "]
            set lineToolTube_01 [join [vectormath::parallel $pos_12 $pos_11 $diameterTool] " "]
                #
            set toolShape       [join "$lineToolTube_00 $lineToolTube_01" " "]
                #
            set pos_21          [vectormath::intersectPoint \
                                    [lindex $lineToolTube  0] [lindex $lineToolTube  1] \
                                    [lindex $borderLeft_2  0] [lindex $borderLeft_2  1] \
                ]   
            set pos_22          [vectormath::intersectPoint \
                                    [lindex $lineToolTube  0] [lindex $lineToolTube  1] \
                                    [lindex $borderRight_2 0] [lindex $borderRight_2 1] \
                ]   
                #
            set centerLine_xz   [join [vectormath::parallel $pos_21 $pos_22 [expr 0.5 * $diameterTool] left] " "]    
                #
        }
        plane -
        default {
            set toolShape   {}
        }
    }
        #
        #
        # --- tool shape depending on miterRotation
        #
    if {$miterRotation != 0} {
            #
            #
        set centerLine_New {}
        if {$centerLine_xz ne {}} {
            foreach {x y} $centerLine_xz {
                set x [expr $x * cos($miterRotation * $CONST_PI / 180)]
                lappend centerLine_New $x $y
            }
        }
        set centerLine_xz   $centerLine_New
            #
            #
        set centerLine_xy   [vectormath::rotateCoordList {0 0} $centerLine_xy [expr -1.0 * $miterRotation]]
        set centerLine_xy   [vectormath::addVectorCoordList [list $miterOffset_X 0] $centerLine_xy]
            # puts "        -> \$centerLine_xy    $centerLine_xy"
            #
            #
        set toolShape_New  {}
        if {$toolShape ne {}} {
            foreach {x y} $toolShape {
                set x [expr $x * cos($miterRotation * $CONST_PI / 180)]
                lappend toolShape_New $x $y
            }
        }
        set toolShape       $toolShape_New
            #
            #            
    } else {
        if {$miterOffset_X != 0} {
            set centerLine_xy   [join [vectormath::addVectorCoordList [list $miterOffset_X 0] $centerLine_xy] " "]
        } else {
            set centerLine_xy   {}
        }
    }
        #
    set toolShapeDict   [list \
        centerLine_xy       $centerLine_xy \
        centerLine_xz       $centerLine_xz \
        toolShape           $toolShape \
        debugTube           $debugTube \
        debugTool           $debugTool \
        debugLine01         $debugLine01 \
    ]
        #
        # puts "        -> \$diameter_y       $diameter_y"
        # puts "        -> \$cuttingOffset    $cuttingOffset"
        # puts "        -> \$miterAngle       $miterAngle"
        # puts "        -> \$cuttingLength    $cuttingLength"
        # puts "        -> \$centerLine       $centerLine"
        # puts "        -> \$centerLine_xy    $centerLine_xy"
        # puts "        -> \$centerLine_xz    $centerLine_xz"
        # puts "        -> \$toolShape        $toolShape"
        # puts "        -> \$debugTube        $debugTube"
        # puts "        -> \$debugTool        $debugTool"
        #
}
    #
proc tubeMiter::app::createMiter::model::getDict_MiterShape {} {
        #
    variable miterObject
        #
    set z_tube  -100
        #
    set miterProfile    [$miterObject getMiter]
    set tubePerimeter   [$miterObject getPerimeter]
        #
        # puts "  -> \$miterProfile $miterProfile"
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
        #
    set miterShape      [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # puts "    -> \$miterShape $miterShape"
        #
    return [list \
                    miterProfile    $miterProfile \
                    miterShape      $miterShape \
                    centerLine_z00  [list [expr -0.5 * $tubePerimeter - 5]   0  [expr 0.5 * $tubePerimeter + 5]   0]  \
                    centerLine_z50  [list [expr -0.5 * $tubePerimeter - 5] -50  [expr 0.5 * $tubePerimeter + 5] -50]  \
                    centerLine_x00  [list 0 -105  0 5] \
            ]
        #
}    
    #
proc tubeMiter::app::createMiter::model::getDict_TubeShape {} {
        #
    variable miterObject
    variable configDict
        #
        #
    set z_tube  -100
        #
        #
        # ===========================================================
        # ---- tube_left_Bottom ---------
        #
    set miterProfile        [$miterObject getProfile Origin right origin]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_left_Bottom    [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # ---- tube_left_Top ------------
        #
    set miterProfile        [$miterObject getProfile Origin left opposite]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_left_Top       [join "$pos_03 $miterProfile $pos_02" " "]
        #
        #
        # ===========================================================
        # ---- tube_top_Bottom ----------
        #
    set miterProfile        [$miterObject getProfile Origin bottom opposite]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_top_Bottom     [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # ---- tube_top_Top ---------
        #
    set miterProfile        [$miterObject getProfile Origin top    origin]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_top_Top        [join "$pos_03 $miterProfile $pos_02" " "]
        #
        #
        # ===========================================================
        # ---- tube_right_Bottom ------
        #
    set miterProfile        [$miterObject getProfile Origin left origin]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_right_Bottom   [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # -- tube_right_Top ---------
        #
    set miterProfile    [$miterObject getProfile Origin right opposite]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_right_Top      [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # ===========================================================
        #
        # puts "    -> \$miterShape $miterShape"
        #
        #
    set tubeType    [dict get $configDict tube type]
        #
    switch -exact $tubeType {
        oval {
            set diameter_x  [dict get $configDict tube  diameter_x]
            set diameter_y  [dict get $configDict tube  diameter_y]
        }
        round -
        default {
            set diameter_x  [dict get $configDict tube  diameter]
            set diameter_y  [dict get $configDict tube  diameter]
        }
    }           
        #
    set coordOval           [list \
                                [expr -0.5 * $diameter_x] \
                                [expr  0.5 * $diameter_y] \
                                [expr  0.5 * $diameter_x] \
                                [expr -0.5 * $diameter_y] \
        ]        
        #
    set centerLine_x        [list \
                                [expr -0.5 * $diameter_x - 5]   0 \
                                [expr  0.5 * $diameter_x + 5]   0 \
        ]        
        #
    set centerLine_y        [list \
                                0   [expr -0.5 * $diameter_y - 5] \
                                0   [expr  0.5 * $diameter_y + 5] \
        ]        
        #
    return [list \
                    diameter_x      $diameter_x \
                    diameter_y      $diameter_y \
                    coordOval       $coordOval \
                    centerLine_x    $centerLine_x \
                    centerLine_y    $centerLine_y \
                    left_Bottom     $tube_left_Bottom \
                    left_Top        $tube_left_Top \
                    top_Bottom      $tube_top_Bottom \
                    top_Top         $tube_top_Top \
                    right_Bottom    $tube_right_Bottom \
                    right_Top       $tube_right_Top \
                ]
        #
}    
    #
proc tubeMiter::app::createMiter::model::getDict_ToolShape {} {
    variable toolShapeDict
    return $toolShapeDict    
}
    #
proc tubeMiter::app::createMiter::model::getDict_Config {} {
    variable configDict
    return $configDict    
}
    #
proc tubeMiter::app::createMiter::model::getSVG_WaterMark {} {
        #
    variable packageHomeDir
        #
        # puts "  -> \$packageHomeDir $packageHomeDir"
        #
    set svgFile [file join $packageHomeDir etc label rattleCAD.svg]
        #
    return $svgFile
        #
}
    #
    #
proc tubeMiter::app::createMiter::model::setExportDir {dir} {
    variable exportDir
    if [file isdirectory [file normalize $dir]] {
        set exportDir  [file normalize $dir]
    }
    return $dir
}
    #
proc tubeMiter::app::createMiter::model::setPDFViewer {viewer} {
    variable pdfViewer
    set pdfViewer   $viewer
    return $pdfViewer
}
    #
proc tubeMiter::app::createMiter::model::getExportDir {} {
    variable exportDir
    return $exportDir
}
    #
proc tubeMiter::app::createMiter::model::getPDFViewer {} {
    variable pdfViewer
    return $pdfViewer
}
    #
proc tubeMiter::app::createMiter::model::getTubePerimeter {} {
    variable miterObject
    set tubePerimeter   [$miterObject getPerimeter]
    return $tubePerimeter
}
    #
    #
proc tubeMiter::app::createMiter::model::__xxx_getDict_ToolShape_xx_ {} {
        #
    variable miterObject
        #
        #
    set z_tube  -100
        #
        #
        # ===========================================================
        # ---- tube_left_Bottom ---------
        #
    set miterProfile        [$miterObject getProfile Origin right origin]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_left_Bottom    [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # ---- tube_left_Top ------------
        #
    set miterProfile        [$miterObject getProfile Origin left opposite]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_left_Top       [join "$pos_03 $miterProfile $pos_02" " "]
        #
        #
        # ===========================================================
        # ---- tube_top_Bottom ----------
        #
    set miterProfile        [$miterObject getProfile Origin bottom opposite]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_top_Bottom     [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # ---- tube_top_Top ---------
        #
    set miterProfile        [$miterObject getProfile Origin top    origin]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_top_Top        [join "$pos_03 $miterProfile $pos_02" " "]
        #
        #
        # ===========================================================
        # ---- tube_right_Bottom ------
        #
    set miterProfile        [$miterObject getProfile Origin left origin]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_right_Bottom   [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # -- tube_right_Top ---------
        #
    set miterProfile    [$miterObject getProfile Origin right opposite]
        #
    set pos_04  [lrange $miterProfile 0 1]
    set pos_03  [list [lindex $pos_04 0] $z_tube]
    set pos_01  [lrange $miterProfile end-1 end]
    set pos_02  [list [lindex $pos_01 0] $z_tube]
        #
    set tube_right_Top      [join "$pos_03 $miterProfile $pos_02" " "]
        #
        # ===========================================================
        #
        # puts "    -> \$miterShape $miterShape"
        #
    return [list \
                    left_Bottom     $tube_left_Bottom \
                    left_Top        $tube_left_Top \
                    top_Bottom      $tube_top_Bottom \
                    top_Top         $tube_top_Top \
                    right_Bottom    $tube_right_Bottom \
                    right_Top       $tube_right_Top \
                ]
        #
}    
    #
proc tubeMiter::app::createMiter::model::reportMiterValues {} {
    variable miterObject
    set tubePerimeter   [$miterObject reportValues]
    #return $tubePerimeter
}
    #