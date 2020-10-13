 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas     ->    cadCanvas_utility.tcl
 #
 # ----------------------------------------------------------------------
 #  namespace:  cadCanvas
 # ----------------------------------------------------------------------
 #
 #  2017/11/26
 #      extracted from the rattleCAD-project (Version 3.4.05)
 #          http://rattlecad.sourceforge.net/
 #          https://sourceforge.net/projects/rattlecad/
 #
 #


proc cad4tcl::_convertBottomLeft {scale args} {
        # flip y-coordinate and add $Unit to each value
        # http://wiki.tcl.tk/440
    set flatList [join $args] 
    set CoordList {}            
    foreach {x y} $flatList {
        set y [expr {0 - $y}]
        lappend CoordList $x
        lappend CoordList $y            
    }
    set CoordListUnit {}            
    foreach value $CoordList {
        set value [expr {$scale * $value}]
        if {$value != 0} {
            lappend CoordListUnit $value
        } else {
            lappend CoordListUnit $value
        }
    }
    return $CoordListUnit
}

proc cad4tcl::_flattenCoordList {args} {
    set argList $args
    set argList [string map {\{ { } \} { }} $argList]
    return [_flattenNestedList $argList]
}
    #
proc cad4tcl::_flattenNestedList {args} {
    if {[llength $args] == 0 } { return ""}
    set flatList {}
    foreach e [eval concat $args] {
        foreach ee $e { lappend flatList $ee }
    }
    return $flatList
}

proc cad4tcl::_getFontSize {{formatKey A4} {size f1}} {
    if {$formatKey eq  {noFormat}} {
        set formatKey A4
    }
    set fontSize    [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey $size]
    return $fontSize           
}

proc cad4tcl::_getBBoxInfo {bbox {type size}} {
    lassign $bbox  x0 y0 x1 y1
        # foreach {x0 y0 x1 y1} $bbox  break
    switch $type {
       size         { return  [list [expr {$x1 - $x0}]  [expr {$y1 - $y0}]] }
       center       { return  [list [expr {($x1 - $x0) * 0.5 + $x0}]  [expr {($y1 - $y0 ) * 0.5 + $y0}]] }
       width        { return  [expr {$x1 - $x0}] }
       height       { return  [expr {$y1 - $y0}] }
       origin       { return  [list $x0 $y0]   }
       originBottom { return  [list $x0 $y1]   }
       default      { return }
    }
}    

proc cad4tcl::_getBottomLeft {w} {
    set StageCoords [$w coords {__Stage__}] 
    lassign $StageCoords  x1 y1 x2 y2
        # foreach {x1 y1 x2 y2} $StageCoords break
    set bottomLeft [list $x1 $y2]
    return $bottomLeft
        # foreach {x y} $bottomLeft break
        # return [list $x $y]
}

proc cad4tcl::_getFormatSize {formatKey} {
    set stageWidth  [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey width ]
    set stageHeight [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey height]
    set stageUnit   [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey unit ]
    return [ list $stageWidth $stageHeight $stageUnit ]            
}

proc cad4tcl::_getUnitRefScale {stageUnit} {
    variable canvasUnitScale
    switch $stageUnit {
        m -
        c -
        i -
        p {
            return [getNodeAttributeRoot /root/_package_/UnitScale $stageUnit]
        }
        default {     return 1 }
    }
}

proc cad4tcl::_getTagList {argList} {
    set i 1
    set _tagValues {}
    foreach value $argList {
        if {$value == {-tags}} {
            set tagList [lindex $argList $i]
            return $tagList
        }
        incr i 1
    }
}

proc cad4tcl::_____getFormatSize {{formatKey A4}} {
    set stageWidth  [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey width ]
    set stageHeight [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey height]
    set stageUnit   [getNodeAttributeRoot /root/_package_/DIN_Format/$formatKey unit ]
    return [list $stageWidth $stageHeight $stageUnit]            
}


