 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classItemIF_PathCanvas.tcl
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


    #
namespace eval cad4tcl {oo::class create ItemInterface_PathCanvas}
    #
oo::define cad4tcl::ItemInterface_PathCanvas {
        #
    superclass cad4tcl::ItemInterface__Super    
        #
    constructor {cvObj} { 
            #
        puts "              -> class ItemInterface_PathCanvas"
        puts "                  -> $cvObj"
            #
        next $cvObj
            #
        variable canvasObject   $cvObj
            #
        variable canvasPath     [$canvasObject getCanvas]
            #
        variable DXF            [cad4tcl::Extension_DXF_PathCanvas    new $canvasObject]     
        variable SVG            [cad4tcl::Extension_SVG_PathCanvas    new $canvasObject [self]]
            #
        vectorfont::setCanvas   [$cvObj getCanvas] 1
            #
        return
            #                     
    }
        #
    destructor {
        puts "            -> [self] ... destroy ItemInterface_PathCanvas"
    }
        #
    method unknown {target_method args} {
        puts "<E> ... cad4tcl::ItemInterface_PathCanvas $target_method $args  ... unknown"
    }
        #
        #
    method update {} {
            #
        variable canvasObject    
            #
        return
            #
    }   
        #
    method create {type args} {
            #
            # routes args to the default implementation of canvas create ...
            #
        variable canvasObject
            #
        variable DimensionFactory  
        variable DXF
        variable SVG  
            #
        variable canvasPath
        variable stageFormat
        variable stageUnitScale
        variable styleLinewidth
        
            #
            #
            # puts "    -> cad4tcl::ItemInterface  create $type $args"
            #
        set moveVector  [$canvasObject getOrigin]
            #
        set coordList   [lindex $args 0]
        set argList     [lindex $args 1]
            
            # ------ check for linewidth ----
        if ![dict exists $argList -width] {
            switch -exact -- $type {
                arc -
                circle -
                line -
                oval -
                ovalarc -
                ovalarc2 -
                polygon -
                rectangle {
                    lappend argList -width $styleLinewidth
                }
            }
        }
            #
        switch -exact -- $type {
            line {              set myItem [my createLine       $coordList  $argList]}
            centerline {        set myItem [my createCenterLine $coordList  $argList]}
            polygon {           set myItem [my createPolygon    $coordList  $argList]}
            rectangle {         set myItem [my createRectangle  $coordList  $argList]}
            oval {              set myItem [my createOval       $coordList  $argList]}       
            ovalarc {           set myItem [my createOvalArc    $coordList  $argList]}       
            ovalarc2 {          set myItem [my createOvalArc2   $coordList  $argList]}       
            arc {               set myItem [my createArc        $coordList  $argList]}
            circle {            set myItem [my createCircle     $coordList  $argList]}
            text {              set myItem [my createText       $coordList  $argList]}
            vectorText {        set myItem [my createVectorText $coordList  $argList]}
            
            dimensionAngle {    set myItem [$DimensionFactory create  angle     $coordList $argList]}
            dimensionLength {   set myItem [$DimensionFactory create  length    $coordList $argList]}
            dimensionRadius {   set myItem [$DimensionFactory create  radius    $coordList $argList]}            
            
            draftFrame {        set myItem [my createDraftFrame             $argList]}
            draftLabel {        set myItem [my createDraftLabel $coordList  $argList]}
            draftLine {         set myItem [my createDraftLine  $coordList  $argList]}
            draftText {         set myItem [my createDraftText  $coordList  $argList]}
            
            draftRaster {       set myItem [my createDraftRaster            $argList]}
            
            svg {               set myItem [my createSVG        $coordList  $argList]}
            
            default {
                            puts "  <E> ... cad4tcl::ItemInterface__Super -> $type ... not defined"
                            return {}
            }
        }
            #
        if {![info exists myItem]} {
            return
        }    
            #
        set w           $canvasPath            
            #
        switch -exact -- $type {
            draftFrame -
            draftLabel -
            draftLine -
            draftText -
            draftRaster -
            svg {}
            default {
                $canvasObject scale $myItem  0 0  [expr {1.0/$stageUnitScale}] [expr {1.0/$stageUnitScale}]
                $canvasObject move  $myItem [lindex $moveVector 0] [lindex $moveVector 1]
                $canvasObject addtag {__Content__} withtag $myItem
            }
        }    
            #
            # $w addtag {__StageItem__} withtag $myItem
            #
            #
            # $canvasObject raise {__Stage__ScaleReference__}    all    
            #
            # puts "     -> create \$myItem $myItem"
        return $myItem
            #
    }
        #
    method itemconfigure {itemTag argList} {
            #
        variable canvasObject
        variable canvasPath
            #
            # puts "\n      [self] itemconfigure $itemTag $argList"
        set type [$canvasPath type $itemTag ]
            # puts "             -> \$type $type"    
            # puts "             -> \$argList $argList"    
            #
        set argList [my UpdateItemAttributes $type $argList noSize]
            # puts "             -> \$args $args"    
            # puts "      $canvasPath itemconfigure $itemTag [join $args]"
        eval $canvasPath itemconfigure $itemTag $argList
            #
    }
        #
    method itemcget {itemTag option} {
            #
        variable canvasPath
        variable stageFormat   
            #
            # puts "\n      [self] itemconfigure $itemTag $argList"
        set type    [$canvasPath type $itemTag ]
            # puts "             -> \$type $type"    
            # puts "             -> \$argList $argList"    
            #
            puts "             -> ItemInterface_PathCanvas"    
            puts "             -> \$type    $type"    
            puts "             -> \$option $option"    
        set argList [my UpdateItemAttributes $type [list $option {1}] noSize]
            puts "             -> \$option $argList"
        set option  [lindex $argList 0]            
            puts "             -> \$option $option"    
            # puts "      $canvasPath itemconfigure $itemTag [join $args]"
        return [eval $canvasPath itemcget $itemTag $option]
            #
    }
        #
    method delete {item} {
            #
        variable canvasPath
            #
        foreach _item $item {
            switch -exact -- $_item {
                __Stage__ {}
                __StageShadow__ {}
                default {
                    $canvasPath delete $item
                }
            }
        }
            #
        # puts "        ... <delete $item> not implemented yet!"
            #
    }    
        #
        #
    method getLineWidth {lineWidth} {
            #
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
        set newWidth [expr {$lineWidth * ($canvasScale / $stageUnitScale)}]
            # set newWidth [expr $lineWidth * ($canvasScale * $stageScale / $stageUnitScale)]
            #
        return $newWidth
            #
    }
        #
        #
    method UpdateItemAttributes {type argDict formatSize} {
            #
            # -- <A0  width="1189"   height="841"  unit="m"	f1="10.0"  f2="7.5"  f3="5.0" />
            #    formatSize: [f1, f2, f3]   ... belongs to fontSize
            #                     lineWidth ... $fontSize / 10
            #
        variable stageFormat
            #
        variable canvasScale
        variable stageScale
        variable stageUnitScale
        variable unitScale_p
            #
            #
        # set formatSize {noSize}
            #
            #
            # puts "   UpdateItemAttributes -> \$type $type"
            # puts "             -> \$argDict $argDict"
            #
        switch -exact -- $type {
            circle {
                set mapDict {-radius -r -outline -stroke -width -strokewidth}
            }
            ellipse -
            path -
            ppolygon -
            prect {
                set mapDict {-outline -stroke -width -strokewidth}
            }
            pline -
            polyline {
                set mapDict {-fill -stroke -outline -stroke -width -strokewidth}
            }
            group -
            ptext -
            pimage -
            default {
                set mapDict {}
            }
        }
            #
            # puts "   -> \$mapDict $mapDict"    
            #
            # --- map argumentNames
            #
        if {$mapDict ne {}} {
            dict for {key newKey} $mapDict {
                    # puts "         ... $key -> $newKey"
                if [dict exist $argDict $key] {
                    set value [dict get $argDict $key]
                    dict set argDict $newKey $value
                    dict unset argDict $key
                } else {
                    # puts "             -> $key ... not existing"
                }
            }
        }
            #
            # puts " -> \$argDict:   $argDict  <-"    
            #
            # --- cleanup dict
            #
        dict for {key value} $argDict {
                # puts "         ... $key -> $value"
            switch -exact -- $key {
                -fill -
                -stroke {
                    if {$value eq {}} {
                        # dict set argDict $key "none"
                        # puts $argDict
                    }
                }
            }
        }
            #
            # -- exception for rectangle
            #
        switch -exact -- $type {
            prect {
                dict for {key value} $argDict {
                    switch -exact -- $key {
                        -fill -
                        -stroke {
                            if {$value eq {none}} {
                                dict set argDict $key {}
                            }
                        }
                        default {}
                    }
                }
            }
        }
            #
            # --- handle lineWidth, dashArray, ...
            #
        if {$formatSize ne {noSize}} {
                #
            if {[dict exist $argDict -strokewidth]} {
                set lineWidth   [dict get $argDict -strokewidth]
                set lineWidth   [expr {$lineWidth * $canvasScale / $stageUnitScale}]
                dict set argDict -strokewidth $lineWidth
            } else {
                if {$formatSize eq {}} {
                    set formatSize f1
                }
                if {$stageFormat eq {passive}} {
                    set stageFormat A4
                }
                set fontSize    [cad4tcl::_getFontSize $stageFormat $formatSize]
                set lineWidth   [expr {0.1 * $fontSize  * $canvasScale / $stageUnitScale}]
                dict set argDict -strokewidth $lineWidth
            }
            
            if {[dict exist $argDict -strokedasharray]} {
                set dashArray   [dict get $argDict -strokedasharray]
                set newArray    {}
                foreach dashLength $dashArray {
                    lappend newArray [expr {$dashLength * $canvasScale / ($lineWidth * $unitScale_p)}]
                }
                dict set argDict -strokedasharray $newArray
            }
                #
        } else {
            if {[dict exist $argDict -strokewidth]} {
                set lineWidth   [dict get $argDict -strokewidth]
                set lineWidth   [expr {$lineWidth * $canvasScale / $stageUnitScale}]
                dict set argDict -strokewidth $lineWidth
            }
            
            if 0 {
                if {[dict exist $argDict -strokedasharray]} {
                    set dashArray   [dict get $argDict -strokedasharray]
                    set newArray    {}
                    foreach dashLength $dashArray {
                        lappend newArray [expr {$dashLength * $canvasScale / $stageUnitScale}]
                    }
                    # dict set argDict -strokedasharray $newArray
                }
            }
        }
            #
            # puts "     \$argDict: $argDict"
            #
        return $argDict
            #
    }
        #
        #
    method createArc {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath
            #
        set posCenter   $coordList
            #
        set argList     [my UpdateItemAttributes  path       $argList  f1]
            #
        set radius      [dict get $argList -radius]
        set startAngle  [dict get $argList -start]
        set extendAngle [dict get $argList -extent]
            #
        if [dict exists $argList -style] {
            set style   [dict get $argList -style]
        } else {
            set style   pieslice
        }
            #
        dict unset argList -radius
        dict unset argList -start
        dict unset argList -extent
        dict unset argList -style
            #
        set posStart    [vectormath::rotateLine  $posCenter $radius   [expr {1.0 * $startAngle}]]
        set posEnd      [vectormath::rotatePoint $posCenter $posStart $extendAngle]
            #
            #
        set radius      [expr {1.0 * $radius * $canvasScale * $stageScale}]
            #
        if {[expr {abs($extendAngle)}] > 180} {
            set largeArcFlag 1
        } else {
            set largeArcFlag 0
        }
            #
        if {$extendAngle > 0} {
            set sweepFlag 0
        } else {
            set sweepFlag 1
        }
            #
        lassign [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posCenter]]  centx centy
        lassign [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posStart]]   startx starty
        lassign [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posEnd]]     endx endy   
            # foreach {centx centy}   [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posCenter]]  break
            # foreach {startx starty} [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posStart]]   break
            # foreach {endx endy}     [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posEnd]]     break
            # puts "    \$args $args"
            # puts "        ... \$radius          $radius"
            # puts "        ... \$posStart        $posStart"
            # puts "        ... \$posEnd          $posEnd"
            # puts "        ... \$largeArcFlag    $largeArcFlag"
            # puts "        ... \$sweepFlag       $sweepFlag"
            #
        switch -exact -- $style {
            arc {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s}             $startx $starty $radius $radius $largeArcFlag $sweepFlag $endx $endy]
                dict unset argList -fill
            }
            chord {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s z}           $startx $starty $radius $radius $largeArcFlag $sweepFlag $endx $endy]
            }
            pieslice -
            default {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s L %s %s z}   $startx $starty $radius $radius $largeArcFlag $sweepFlag $endx $endy $centx $centy]
            }
        }
            # puts "        ... \$pathString $pathString"
            #
            # set argList     [my UpdateArgDict_LineWidth $argList]
            #
            # puts "\n --- path  \"$pathString\" $argList"
        set myItem      [eval $w create path    \"$pathString\"  $argList]
            #
        return $myItem
            #
    }
    method createCenterLine {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
        set w           $canvasPath
            #
        set coordList   [join [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $coordList]]]
            #
            # puts "  -> $argList"
            #
        set lLong       [expr {12.0 * ($canvasScale * $stageScale / $stageUnitScale)}]
        set lShort      [expr { 1.0 * ($canvasScale * $stageScale / $stageUnitScale)}]
            #
        set lLong       [expr {12.0 * ($canvasScale * $stageScale)}]
        set lShort      [expr { 1.0 * ($canvasScale * $stageScale)}]
            #
        set lLong       12.0
        set lShort       1.0
            #
        dict set argList    -strokedasharray [list $lLong $lShort $lShort $lShort]
            #
        set argList     [my UpdateItemAttributes  polyline  $argList  f3]
            #
            # puts "\n --- createCenterLine - polyline $coordList $args"
            #
        set myItem      [eval $w create polyline    $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createCircle {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
        set w           $canvasPath
            #
        set coordList   [join [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $coordList]]]
            #
        lassign $coordList  cx cy
            # foreach {cx cy} $coordList break
            #
            # puts "  createCircle -> $argList"
            # puts "---000---"
        set argList     [my UpdateItemAttributes  circle     $argList  f1]
            #
            # puts "---001---"
        set radius      [dict get $argList -r]
        dict set argList    -r [expr {$radius * $canvasScale * $stageScale}]
            # puts "---002---"
            #
            # puts "\n --- createCircle - circle $cx $cy $args"
        set myItem      [eval $w create circle $cx $cy $argList]
            #
        return          $myItem
            #
    }
    method createLine {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
        set w           $canvasPath
            #
        set coordList   [join [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $coordList]]]
            #
        set argList     [my UpdateItemAttributes  polyline   $argList  f1]
            #
            # puts "\n --- createLine - polyline $coordList $args"
        set myItem      [eval $w create polyline    $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createOval {coordList argList} {
            #
        variable canvasObject
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
        set w           $canvasPath
            #
        set coordList   [join [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $coordList]]]
            #
        lassign [cad4tcl::_getBBoxInfo  $coordList   center]  cx cy 
        lassign [cad4tcl::_getBBoxInfo  $coordList   size]    dx dy 
            # foreach {cx cy} [cad4tcl::_getBBoxInfo  $coordList   center] break
            # foreach {dx dy} [cad4tcl::_getBBoxInfo  $coordList   size]   break
        set rx          [expr {abs(0.5 * $dx)}]
        set ry          [expr {abs(0.5 * $dy)}]
            #
        set argList     [my UpdateItemAttributes  ellipse    $argList  f1]
            #
            # puts "\n --- createOval - ellipse $cx $cy -rx $rx -ry $ry $args]"
        set myItem      [eval $w create ellipse  $cx $cy  -rx $rx  -ry $ry  $argList]
            #
        return          $myItem
            #
    }
    method createOvalArc {coordList argList} {
            #
        variable canvasObject
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath
            #
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            # 
        set argList     [my UpdateItemAttributes  path       $argList  f1]
            #
        lassign $coordList  x0 y0 x1 y1
            # foreach {x0 y0 x1 y1} $coordList break
        set radius1     [expr 0.5 * abs($x1 - $x0)]
        set radius2     [expr 0.5 * abs($y1 - $y0)]
            #
        set posCenter   [cad4tcl::_getBBoxInfo $coordList center]    
            #
        set startAngle  [dict get $argList -start]
        set extendAngle [dict get $argList -extent]
            #
        if {[dict exists $argList -style]} {
            set style   [dict get $argList -style]
        } else {
            set style   pieslice
        }
            #
        dict unset argList -start
        dict unset argList -extent
        dict unset argList -style
            #
        set posStart    [my getPointOnEllipse $radius1 $radius2 $startAngle]
        set posEnd      [my getPointOnEllipse $radius1 $radius2 [expr $startAngle + $extendAngle]]
            #
        set posStart    [vectormath::addVector $posCenter $posStart]
        set posEnd      [vectormath::addVector $posCenter $posEnd]
            # posStart  [::math::geometry::+ $posCenter $posStart]
            # posEnd    [::math::geometry::+ $posCenter $posEnd]
            #
        if {[expr abs($extendAngle)] > 180} {
            set largeArcFlag 1
        } else {
            set largeArcFlag 0
        }
            #
        if {$extendAngle > 0} {
            set sweepFlag 0
        } else {
            set sweepFlag 1
        }
            #
        lassign [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $posCenter]]  centx centy   
        lassign [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $posStart]]   startx starty 
        lassign [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $posEnd]]     endx endy     
            # foreach {centx centy}   [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $posCenter]]  break
            # foreach {startx starty} [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $posStart]]   break
            # foreach {endx endy}     [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $posEnd]]     break
            #
        set radius1     [expr 1.0 * $radius1 * $canvasScale * $stageScale]
        set radius2     [expr 1.0 * $radius2 * $canvasScale * $stageScale]
            #
        switch -exact -- $style {
            arc {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s}             $startx $starty $radius1 $radius2 $largeArcFlag $sweepFlag $endx $endy]
                dict unset argList -fill
            }
            chord {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s z}           $startx $starty $radius1 $radius2 $largeArcFlag $sweepFlag $endx $endy]
            }
            pieslice -
            default {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s L %s %s z}   $startx $starty $radius1 $radius2 $largeArcFlag $sweepFlag $endx $endy $centx $centy]
            }
        }
            #
        set myItem      [eval $w create path    \"$pathString\"  $argList]
            #
        return $myItem
            #
    }
    method createOvalArc2 {coordList argList} {
            #
        variable canvasObject
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath
            #
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            # 
        set argList     [my UpdateItemAttributes  path       $argList  f1]
            #
        lassign $coordList  x0 y0 x1 y1
            # foreach {x0 y0 x1 y1} $coordList break
        set radius1     [expr {0.5 * abs($x1 - $x0)}]
        set radius2     [expr {0.5 * abs($y1 - $y0)}]
            #
        set posCenter   [cad4tcl::_getBBoxInfo $coordList center]    
            #
            # my create circle [list $posCenter] [list -radius 25 -outline darkred]
            #
        set startAngle  [dict get $argList -start]
        set extendAngle [dict get $argList -extent]
            #
        if {[dict exists $argList -style]} {
            set style   [dict get $argList -style]
        } else {
            set style   pieslice
        }
            #
        dict unset argList -start
        dict unset argList -extent
        dict unset argList -style
            #
        set posStart    [my getPointOnEllipse2 $radius1 $radius2 $startAngle]
        set posEnd      [my getPointOnEllipse2 $radius1 $radius2 [expr {$startAngle + $extendAngle}]]
            #
        set  posStart   [vectormath::addVector $posCenter $posStart]
        set  posEnd     [vectormath::addVector $posCenter $posEnd]
            # posStart    [::math::geometry::+ $posCenter $posStart]
            # posEnd      [::math::geometry::+ $posCenter $posEnd]
            #
            # my create circle [list $posStart] [list -radius 2 -outline red]
            # my create circle [list $posEnd]   [list -radius 2 -outline blue]
            #
        if {[expr {abs($extendAngle)}] > 180} {
            set largeArcFlag 1
        } else {
            set largeArcFlag 0
        }
            #
        if {$extendAngle > 0} {
            set sweepFlag 0
        } else {
            set sweepFlag 1
        }
            #
        lassign [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posCenter]]  centx centy 
        lassign [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posStart]]   startx starty
        lassign [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posEnd]]     endx endy     
            # foreach {centx centy}   [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posCenter]]  break
            # foreach {startx starty} [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posStart]]   break
            # foreach {endx endy}     [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $posEnd]]     break
            #
            # puts "    \$args $args"
            # puts "        ... \$radius1         $radius1"
            # puts "        ... \$radius2         $radius2"
            # puts "        ... \$posStart        $posStart"
            # puts "        ... \$posEnd          $posEnd"
            # puts "        ... \$largeArcFlag    $largeArcFlag"
            # puts "        ... \$sweepFlag       $sweepFlag"
        set radius1     [expr {1.0 * $radius1 * $canvasScale * $stageScale}]
        set radius2     [expr {1.0 * $radius2 * $canvasScale * $stageScale}]
        #
        switch -exact -- $style {
            arc {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s}             $startx $starty $radius1 $radius2 $largeArcFlag $sweepFlag $endx $endy]
                dict unset argList -fill
            }
            chord {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s z}           $startx $starty $radius1 $radius2 $largeArcFlag $sweepFlag $endx $endy]
            }
            pieslice -
            default {
                set pathString  [format {M %s %s A %s %s 0 %i %i %s %s L %s %s z}   $startx $starty $radius1 $radius2 $largeArcFlag $sweepFlag $endx $endy $centx $centy]
            }
        }
            # puts "        ... \$pathString $pathString"
            #
            # puts "\n --- path  \"$pathString\"  [join $args]"
        set myItem      [eval $w create path    \"$pathString\"  $argList]
            #
        return $myItem
            #
    }
    method createPolygon {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
        set w           $canvasPath
            #
        set coordList   [join [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $coordList]]]
            #
        set argList     [my UpdateItemAttributes  ppolygon   $argList  f1]
            #
            # puts "\n --- createPolygon - ppolygon $coordList  $args"
        set myItem      [eval $w create ppolygon    $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createRectangle {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$canvasScale * $stageScale}] [join $coordList]]
            #
        set argDict     [my UpdateItemAttributes  prect      $argList  f1]
            #
        set myItem      [eval $w create prect   $coordList  $argDict]
            # set myItem      [eval $w create rectangle   $coordList  [cad4tcl::_flattenNestedList $args]]
            #
        return          $myItem
            #
    }
        #
        #
    method createVectorText {coordList argList} {
            #
            # -- using vectorfont
            #
        variable canvasObject
        variable canvasPath
        variable canvasScale
        variable stageFormat
        variable stageScale
        variable stageUnit
        variable stageUnitScale
            #
        set unitScale_p [cad4tcl::_getUnitRefScale    p]
        set refScale    [expr {$stageUnitScale / $unitScale_p}]
            #
        vectorfont::setalign    "sw"    ;# standard text alignment
        vectorfont::setangle    0       ;# standard orientation
        vectorfont::setcolor    black   ;# standard colour
        vectorfont::setline     1       ;# standard line width
        vectorfont::setscale    1       ;# standard font size
            #
        set argDict     {}    
        set tagList     {}
        set fontSize    3.5
        set lineWidth   0.35
            #
        set argList     [my UpdateItemAttributes  polyline   $argList  noSize]
            #
        foreach key {-text -anchor -angle -stroke -fill -strokewidth -width -size -tags} {
            if [dict exist $argList $key] {
                switch -exact -- $key {
                    -text { 
                        set myText              [dict get $argList $key]
                    }
                    -anchor { 
                        vectorfont::setalign    [dict get $argList $key]
                    }
                    -angle {
                        vectorfont::setangle    [dict get $argList $key]
                    }
                    -stroke -
                    -fill { 
                        vectorfont::setcolor    [dict get $argList $key]
                    }
                    -width -
                    -strokewidth { 
                        set lineWidth           [dict get $argList $key]
                    }
                    -size { 
                        set fontSize            [dict get $argList $key]
                    }
                    -tags { 
                        set tagList             [dict get $argList $key]
                    }
                    default { 
                        set value               [dict get $argList $key]
                        dict set argDict $key   $value
                    }
                }
             }
        }
            #
        vectorfont::setscale    [expr {1.0 * $fontSize * $stageScale * $canvasScale * $refScale}]
            #
        vectorfont::setline     $lineWidth
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$canvasScale*$stageScale}] $coordList]
            # vectorfont does not support canvas Units m, c, i, p 
            #
        lassign $coordList pos_x pos_y
            # set pos_x [expr [lindex $coordList 0]]
            # set pos_y [expr [lindex $coordList 1]]                                
        vectorfont::setposition  $pos_x $pos_y
            #
        set myItem     [vectorfont::drawtext $canvasPath $myText]
            #
        foreach tag $tagList {
            $canvasObject addtag $tag withtag $myItem
        }        
            #
        return          $myItem
            #
    }
        #
        #
    method createDraftText {coordList argList} {
            #
        variable canvasObject
        variable canvasScale
        variable stageScale
        variable stageUnitScale
            #
            # puts "------> createDraftText $coordList $argList"
            # puts "      -> \$canvasScale    $canvasScale"
            # puts "      -> \$stageScale     $stageScale"
            # puts "      -> \$stageUnitScale $stageUnitScale"
            # puts "    -> \$refScale    $refScale"
            #
        set scaleSize   [expr {double(1/$stageScale)}]
            #
        if [dict exist $argList -size] {
            set value       [dict get $argList -size]
            dict set argList -size [expr {$value / $stageScale}]
        } else {
            dict set argList -size [expr {5 / $stageScale}]
        }
            #
        set textSize    [dict get $argList -size]
        set lineWidth   [expr {0.1 * $textSize * $stageScale}]    
            #
        dict set argList -width $lineWidth
            #
        set coordList   [vectormath::scaleCoordList {0 0} $coordList    $scaleSize]
            #
        set myItem      [my createVectorText $coordList $argList]
            # 
        set moveVector  [$canvasObject getOrigin]
        $canvasObject scale $myItem  0 0  [expr {1.0/$stageUnitScale}] [expr {1.0/$stageUnitScale}]
        $canvasObject move  $myItem [lindex $moveVector 0] [lindex $moveVector 1]
            #
        $canvasObject addtag {__Content__} withtag $myItem
            #
        return $myItem
            #
    }
        #
        #
}

