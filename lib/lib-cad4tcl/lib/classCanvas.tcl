 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classCanvas.tcl
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
namespace eval cad4tcl {oo::class create CADCanvas}
    #
oo::define cad4tcl::CADCanvas {
        #
    superclass cad4tcl::Canvas__Base
        #
        #
    constructor {canvasPath cv_width cv_height stageFormat stageScale stageBorder args} { 
            #
        puts "              -> class CADCanvas"
            #
        next $canvasPath $cv_width $cv_height $stageFormat $stageScale $stageBorder
            #
        variable _classOld
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
        variable ItemInterface
            #
        variable packageHomeDir
            #
        variable IconArray
            #
        variable ReportDoc  [dom parse {<root/>}]
        variable ReportRoot [$ReportDoc documentElement]
            #
        variable MarkPosition 
        variable CanvasObject
        variable ClickObject
        variable DragObject
            #
        array set MarkPosition {
                    x0      0
                    y0      0
                    x1      0
                    y1      0
                }
            #
        array set CanvasObject {
                    current             {}
                    release             {}
                    DivContainer        {}
                    DivContainerPos     {}
                    ConfigContainer     {}
                    ConfigContainerPos  {}
                    ConfigCommand       {}
                    ConfigCorner        {}
                }
            #
        array set ClickObject {}
            #
        array set DragObject {}
            #
            #            
        set packageHomeDir              $::cad4tcl::packageHomeDir
            #
        set Canvas(InnerBorder)         $stageBorder
        set Stage(Format)               $stageFormat
        set Stage(Scale)                $stageScale
            #
        set Style(Linewidth)            "0.5" 
        set Style(Linecolour)           "black" 
        set Style(Fontstyle)            "vector" 
        set Style(Fontsize)             "3.5" 
        set Style(Fontdist)             "1" 
        set Style(Font)                 "Arial" 
        set Style(Fontcolour)           "black" 
        set Style(Precision)            "2" 
        set Style(Defaultprecision)     "2"
            #
         
                                            
            #
            # ------- Create the canvas and ItemInterface ------------------------
            #
            #
        if {$cad4tcl::canvasType == 1} {
            if {[catch {package require tkpath 0.3.3} eID]} {
                set myCanvasType 0
                #set myCanvasType 1
            } else {
                set myCanvasType 1
            }
        } else {
                set myCanvasType 0
        }
            #
        if $myCanvasType {
                # -- $cad4tcl::canvasType == 1
            set ::tkpath::antialias 1
                # set ::tkp::antialias  1
                # set ::tkp::depixelize 1
                #
            set  Canvas(Path)   [eval tkp::canvas $canvasPath   [cad4tcl::_flattenNestedList $args]  -width $cv_width -height $cv_height  -bg gray] 
            pack $Canvas(Path)  -expand yes  -fill both
                #
            set ItemInterface   [cad4tcl::ItemInterface_PathCanvas    new [self]]
                #
        } else {
                # -- $cad4tcl::canvasType == 0
            set  Canvas(Path)   [eval tk::canvas $canvasPath    [cad4tcl::_flattenNestedList $args]  -width $cv_width -height $cv_height  -bg gray] 
            pack $Canvas(Path)  -expand yes  -fill both
                #
            set ItemInterface   [cad4tcl::ItemInterface_Canvas        new [self]]
                #
        }
            #
            # ------- Store Class of Canvas -----------------------------------
        set Canvas(Type)        [winfo class $Canvas(Path)]
                
            #
        switch -glob $stageFormat {
            passive -
            noFormat {
                set stageFormat passive
                set DINFormat   A4
            }
            default {
                set DINFormat   $stageFormat
            }
        }
            #
            # puts "    ... \$DINFormat $DINFormat"    
            #
        lassign [cad4tcl::_getFormatSize $DINFormat]  stageWidth stageHeight stageUnit
            # foreach {stageWidth stageHeight stageUnit }     [cad4tcl::_getFormatSize $DINFormat] break
            #
        switch -glob $stageFormat {
            passive -
            noFormat {
                set stageWidth  [$Canvas(Path) cget -width]
                set stageHeight [$Canvas(Path) cget -height]
            }
        }
            # -- settings depending on stageFormat (DIN-Format)
        set Stage(Unit)         $stageUnit
        set Stage(Width)        $stageWidth
        set Stage(Height)       $stageHeight
            # -- exception for canvas that are not DIN Formats
        if {$stageFormat == {passive}} {
            set Stage(Width)    [$Canvas(Path) cget -width]
            set Stage(Height)   [$Canvas(Path) cget -height]
        }
            #
        update
            #
            #
        switch -glob $stageFormat {
            passive {
                    #
                my CreateStage  passive
                    #
                $Canvas(Path) configure -bg white
                    #
            }                    
            default {
                    #
                my CreateStage  sheet
                    #
                bind $Canvas(Path) <Motion>           [list [self] reportPointer    %x %y]
                    #
                bind $Canvas(Path) <Configure>        [list [self] resize]
                    #
                bind $Canvas(Path) <1>                [list [self] eventClick_B1    %x %y __Stage__]
                bind $Canvas(Path) <B1-Motion>        [list [self] eventMotion_B1   %x %y]
                bind $Canvas(Path) <ButtonRelease-1>  [list [self] eventRelease_B1  %x %y]
                bind $Canvas(Path) <3>                [list [self] eventClick_B3    %x %y __Stage__]
                bind $Canvas(Path) <B3-Motion>        [list [self] eventMotion_B3   %x %y]
                bind $Canvas(Path) <ButtonRelease-3>  [list [self] eventRelease_B3  %x %y]
                    #
            }
        }
            #
        set IconArray(iconClose) [image create photo cad4tcl::iconClose -file [file join $packageHomeDir image iconClose.gif]]
                    
            #
        my CreateReportDOM  
            #
        my UpdateItemInterface
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy cadCanvas"
            #
    }
        #
    method unknown {target_method args} {
        puts "<E> ... cad4tcl::CADCanvas $target_method $args  ... unknown"
    }
        #
        #
        #
    method configure {category key {value {__undefinedValue__}}} {
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
            # puts "    $category $key"
            #
        if {$value eq {__undefinedValue__}} {
            set retValue [array get $category $key]
            if {$retValue ne {}} {
                return [lindex $retValue 1]
            } else {
                error " [self] configure: $category $key ... key not found!" -1
            }
        } else {
                #
                # -- exceptions ...
                #
            switch -exact -- "$category/$key" {
                "Canvas/Cursor" {
                    set Canvas(Cursor)  $value
                    $Canvas(Path) configure -cursor $Canvas(Cursor)
                }
                "Canvas/InnerBorder" {
                    if {$value >= 0} {
                        set Canvas(InnerBorder)   $value
                    } else {
                        set Canvas(InnerBorder)   0
                    }
                    my fit
                }
                "Canvas/Scale" {
                    if {$value > 0} {
                        set Canvas(Scale)   $value
                    } else {
                        set Canvas(Scale)   0.1
                    }
                    my UpdateCanvas
                }
                "Stage/Format" {
                    set Stage(Format)       $value
                    my UpdateCanvas
                }
                "Stage/Scale" {
                    if {$value > 0} {
                        set Stage(Scale)    $value
                    } else {
                        set Stage(Scale)    0.1
                    }
                    my UpdateCanvas
                }
                default {
                        #
                    array set $category [list $key $value]
                        #
                }
            }
                #
                # -- default ...
                #
            return [lindex [array get $category $key] 1]
                #
        }
            #
    }   
        #
        #
        #
    method create {type coordList args} {
            #
        variable ItemInterface
            #
            # puts "    --> $coordList"
            # puts "    --> $args"
            #
        if {[llength $args] == 1} {
            set argList [join $args]
        } else {
            set argList $args
        }
            # puts "  -> \$argList $argList"
            #
            # -- create item  -------------------------
            #
        my UpdateItemInterface    
            #
        switch -exact -- $type {
            arc -
            centerline -
            circle -
            line -
            oval -
            ovalarc -
            ovalarc2 -
            polygon -
            rectangle -
            text -
            vectorText -
            
            dimensionAngle -
            dimensionLength -
            dimensionRadius -
            
            draftLine -
            draftText -
            draftFrame -
            draftLabel -
            
            draftRaster -
            
            svg -
            
            __ItemInterface__ {
                set myObject    [$ItemInterface create  $type   $coordList $argList] 
            }
            
            window {
                set myObject    [my CreateWindow $coordList $argList]
            }
            
            default {
                puts "\n"
                puts "   ------------------------------------------------------------"
                puts "       <E> ... cad4tcl::CADCanvas -> create ...  old "
                puts "                   \$type: $type"
                puts "\n"
            }
        }
            #
            # puts "   -> create: \$myObject >$myObject<"
        return $myObject
            #
    }
        #
    method createConfigCorner {eventCommand} {
            #
        variable packageHomeDir
        variable CanvasObject
            #
            #
            # puts " -> eventCommand"    
            #
        set CanvasObject(ConfigCommand) $eventCommand
            #
            # -- delete existing __ConfigCorner__
        my deleteConfigCorner
            #
            # -- get svg-template
        set svg_File [file join $packageHomeDir svg cfg_Corner.svg]
            #
        set fp [open $svg_File]
        fconfigure    $fp -encoding utf-8
        set xml [read $fp]
        close         $fp
            #
        set doc  [dom parse  $xml]
        set root [$doc documentElement]
            #
            
            # -- get style  
        set styleNode   [$root getElementsByTagName style]
        set styleText   [$styleNode text]
            #
            # -- file styleArray
        foreach {name styleset} $styleText {
            set name [string trim $name .]
            set styleArray($name) [string map {\; { } : { }} $styleset]
        }
            #
            # -- get polygons
        set w   [my getCanvas]
            #
        foreach polygon [$root getElementsByTagName polygon] {
                #
                # puts "   -> [$polygon asXML]"
            set points  [$polygon getAttribute points]
            set styles  [$polygon getAttribute class]
                #
                # puts "         -> $points"
            set pointList {}
            foreach {xy} $points {
                lassign [split $xy ,]  x y
                    # foreach {x y} [split $xy ,] break
                lappend pointList $x $y
            }
                # puts "          -> $pointList"
                #
            set cv_Item [$w create polygon $pointList \
                                -activefill {white}
                                ]
                #
            $w addtag __ConfigCorner__ withtag $cv_Item    
                #
            set CanvasObject(ConfigCorner) __ConfigCorner__
                #
                #
            foreach name $styles {
                    # puts "          -> $name"
                set styles [split [set styleArray($name)] \;]
                    # puts "              -> $styles"
                foreach style $styles {
                      # puts "              -> -> $style  -> [split $style :]"
                    lassign $style  styleName value
                        # foreach {styleName value} $style break
                        # puts "                  -> $styleName  - $value"
                    switch -exact $styleName {
                        stroke {       $w itemconfigure $cv_Item -outline      $value}
                        stroke-width { $w itemconfigure $cv_Item -width        $value}
                        fill {         $w itemconfigure $cv_Item -fill         $value}
                        activefill {   $w itemconfigure $cv_Item -activefill   $value}
                        default {}
                    }                    
                }
            }
        }
            #
            # -- bind cursor configurations
        set cursor {hand2}
            #
        $w bind __ConfigCorner__    <ButtonPress-1> [list [self] eventClick_B1  %X %Y   __ConfigCorner__ click]    
            #
        $w bind __ConfigCorner__    <Enter>         [list [self] configure Canvas Cursor $cursor]
        $w bind __ConfigCorner__    <Leave>         [list [self] configure Canvas Cursor {}]
            #
            # __ConfigCorner__    <ButtonPress-1>  ... done by SetMark
            #
    }
        #
    method createConfigContainer {{title {Config}}} {
            #
        variable CanvasObject
            #
        set x   4
        set y   4
            #
        puts ""
        puts "   -------------------------------"
        puts "    [self] createConfigContainer"
        puts "       x / y:           $x / $y"
        puts "       title:           $title"

            #
        my deleteConfigContainer
            #
        
            #
            # --- create Window ---
            #
        set nameBaseFrame   [my getCanvas].f_configContainer 
            #
        set cvFrame         [frame $nameBaseFrame -bd 2 -relief raised]
            #
        set cvContainer     [my create window [list $x $y]  -window $cvFrame  -anchor nw]
            #
        my  addtag  __ConfigContainer__ withtag $cvContainer
            #
        set CanvasObject(ConfigContainer)  $cvContainer
            #

            #
            # --- create ContentFrame ---
            #
        set cvTitleFrame    [frame $cvFrame.f_title      -bg gray60  ]
        set cvContentFrame  [frame $cvFrame.f_content    -bd 1 -relief sunken]
            #
        pack $cvTitleFrame $cvContentFrame -side top
        pack configure $cvTitleFrame    -fill x -padx 2 -pady 2
        pack configure $cvContentFrame  -fill both
            
            #
            # --- title definition ---
            #
        set cvTitle         [label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
            #
        pack $cvTitle -fill x
            #
        bind $cvTitle  <Button-1>    [list [self] deleteConfigContainer]
            #
            
            #
        return $cvContentFrame
            #
    }
        #
    method createDivContainer {title x y } {
            #
        variable CanvasObject
        variable IconArray
            #
        puts ""
        puts "   -------------------------------"
        puts "    [self] createDivContainer"
        puts "       x / y:           $x / $y"
        puts "       title:           $title"
        
            #
        my deleteDivContainer
            #
            
            #
        set x_offset 100
            #
            
            #
            # --- create Window ---
            #
        set nameBaseFrame   [my getCanvas].f_divContainer
            # set nameBaseFrame   .f_divContainer
            #
        set cvFrame         [frame $nameBaseFrame -bd 2 -relief raised]
            #
        set cvContainer     [my create window [list [expr {$x + $x_offset}] $y]  -window $cvFrame  -anchor w]
            #
        my  addtag  __DivContainer__ withtag $cvContainer
            #
        set CanvasObject(DivContainer)  $cvContainer  
            #

            #
            # --- create ContentFrame ---
            #
        set cvTitleFrame    [frame $cvFrame.f_title      -bg gray60  ]
        set cvContentFrame  [frame $cvFrame.f_content    -bd 1 -relief sunken]
            #
        pack $cvTitleFrame $cvContentFrame -side top
        pack configure $cvTitleFrame    -fill x -padx 2 -pady 2
        pack configure $cvContentFrame  -fill both
            #
            
            #
            # --- title definition ---
            #
        set cvTitle         [label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
        set cvClose         [button $cvTitleFrame.close -image $IconArray(iconClose) -command "[self] deleteDivContainer"]
            #
        pack $cvTitle -side left
        pack $cvClose -side right -pady 2
            #
            # set cursor {hand2}    
            #
            # bind $cvTitleFrame  <Enter>             [list [self] configure          Canvas Cursor $cursor]
            # bind $cvTitleFrame  <Leave>             [list [self] configure          Canvas Cursor {}]
            # bind $cvTitle       <Enter>             [list [self] configure          Canvas Cursor $cursor]
            # bind $cvTitle       <Leave>             [list [self] configure          Canvas Cursor {}]
            #
        bind $cvContentFrame    <ButtonPress-1>     [list [self] eventClick_B1      %X %Y   $cvContainer    move]
        bind $cvContentFrame    <B1-Motion>         [list [self] eventMotion_B1     %X %Y]
        bind $cvTitleFrame      <ButtonPress-1>     [list [self] eventClick_B1      %X %Y   $cvContainer    move]
        bind $cvTitleFrame      <B1-Motion>         [list [self] eventMotion_B1     %X %Y]
        bind $cvTitle           <ButtonPress-1>     [list [self] eventClick_B1      %X %Y   $cvContainer    move]
        bind $cvTitle           <B1-Motion>         [list [self] eventMotion_B1     %X %Y]
            #
        return $cvContentFrame
            #
    }
        #
    method __createDimension {type coordList args} {
            #
        set argList [join $args]    
            #
            # -- create dimension  --------------------
        switch -exact -- $type {
            angle {
                return [my create dimensionAngle    $coordList  $argList]
            }
            length {
                return [my create dimensionLength   $coordList  $argList]
            }
            radius {
                return [my create dimensionRadius   $coordList  $argList]
            }
            default {
                puts "  <E> cad4tcl::CADCanvas createDimension:  $type ... not defined"
                exit
            }
        
        }
            #
        return {}
            #
    }
        #
        #
        #
    method itemconfigure {itemTag args} {
            #
        variable ItemInterface    
        $ItemInterface itemconfigure $itemTag $args
            #
    }
        #
    method itemcget {itemTag option} {
            #
        variable ItemInterface
            #
            # puts "   itemcget -> $itemTag -> $option"
        return [$ItemInterface itemcget $itemTag $option]
            #
    }
        #
        #
        #
    method export {fileFormat fileName} {
        variable ItemInterface
        return [$ItemInterface export $fileFormat $fileName]
    }
        #
        #
        #
    method deleteContent {} {
            #
        variable ClickObject
        variable DragObject
            #
        my deleteDimension
            #
        catch [my delete {__Content__}]
            #
            # puts "   -> deleteContent"
            # puts "      -> ClickObject [array size ClickObject]"
            # puts "      -> DragObject  [array size DragObject]"
        array set ClickObject {}    
        array set DragObject  {}    
            #
    }
        #
    method deleteConfigCorner {} {
            #
        variable CanvasObject 
            #
        foreach cvItem $CanvasObject(ConfigCorner) {
                # puts "   -> delete $cvItem"
            my delete $cvItem
            destroy $cvItem
        }
            #
    }
        #
    method deleteConfigContainer {} {
            #
        variable CanvasObject 
            #
        if {$CanvasObject(ConfigContainer) eq {}} {
            return
        }
            #
        set parentWindow [my itemcget $CanvasObject(ConfigContainer) -window]
            #
        destroy $parentWindow
            #
        catch {set items [my find withtag __ConfigContainer__]}
            #
        foreach cvItem $items {
            my delete $cvItem
            destroy $cvItem
        }
            #
        return
            #
    }
        #
    method deleteDivContainer {} {
            #
        variable CanvasObject 
            #
        if {$CanvasObject(DivContainer) eq {}} {
            return
        }
            #
        set parentWindow [my itemcget $CanvasObject(DivContainer) -window]
            #
        destroy $parentWindow
            #
        catch {set items [my find withtag __DivContainer__]}
            #
        foreach cvItem $items {
                # puts "   -> delete $cvItem"
            my delete $cvItem
            destroy $cvItem
        }
            #
        return
            #
    }
        #
    method deleteDimension {} {
            #
        variable ItemInterface
        $ItemInterface deleteDimension    
            #
    }
        #
        #
        #
    method getBottomLeft {} {
            #
        variable Canvas
            #
        set StageCoords [$Canvas(Path) coords {__Stage__}] 
        lassign $StageCoords  x1 y1 x2 y2
            # foreach {x1 y1 x2 y2} $StageCoords break
        set bottomLeft [list $x1 $y2]
            # foreach {x y} $bottomLeft break
            # $w create oval  [expr $x-5] [expr $y-5] [expr $x+5] [expr $y+5] 
            # set myItem [eval $w create oval  -2m -2m 2m 2m -fill red]
            # $w move $myItem $x $y
        return $bottomLeft
            #
    }        
        #
    method getCenter {} {
            #
        variable Canvas
            #
        set StageCoords [$Canvas(Path) coords {__Stage__}] 
        lassign $StageCoords  x1 y1 x2 y2 
            # foreach {x1 y1 x2 y2} $StageCoords break
        set x [expr {($x1 + $x2) / 2}]
        set y [expr {($y1 + $y2) / 2}]
        return [list $x $y]
            #
    }
        #
    method getSize {} {
        variable Canvas
        return  [list  [winfo width  $Canvas(Path)]  [winfo height $Canvas(Path)] ]
    }        
        #
    method getLength {length} {
            #
            # -- returns unscaled length
        variable Canvas
        variable Stage        
            #
        set w   [my getCanvas]
            #
        set stageScale  $Stage(Scale)
        set stageFormat  $Stage(Format)
        set formatSize  [cad4tcl::_getFormatSize  $stageFormat ]
        set pageWidth   [lindex $formatSize 0]
            #
        set coords       [$w coords __Stage__]
        set stageSize    [cad4tcl::_getBBoxInfo  $coords  size]
        set stageWidth   [lindex $stageSize 0]
        set bboxScale    [expr {$pageWidth / $stageWidth}]
            #
        set realLength   [expr {$length * $bboxScale / $stageScale}]
            #
        return $realLength
            #
    }
        #
    method getLengthCanvas {args} {
            #
            # -- returns scaled length per each value in args
        variable Canvas
        variable Stage 
            #
        set stageScale  $Stage(Scale)
        set unitScale   $Stage(UnitScale)
        set canvasScale $Canvas(Scale)
                    #
        set retList      {}
        foreach length   $args {
            set cvLength    [expr {$length * $stageScale * $canvasScale / $unitScale}]
            lappend retList $cvLength
        }
            #
        return $retList
            #
    }
        #
    method getPositionCanvas {x y} {
            #
            # -- returns scaled position 
        variable Canvas
        variable Stage        
            #
        set posOrigin   [my getBottomLeft]  
            #
        set offsetXY    [my getLengthCanvas $x $y]
            #
        lassign $posOrigin  originX originY
        lassign $offsetXY   offsetX offsetY
            # foreach {originX originY} $posOrigin break
            # foreach {offsetX offsetY} $offsetXY  break
            #
        set posCanvas   [list [expr {$originX + $offsetX}] [expr {$originY - $offsetY}]]
            #
        return $posCanvas    
            #
    }
        #
    method getStageFormat {} {
            #
        variable Stage        
            #
        return $Stage(Format)     
            #
    }
        #
    method getStageSize {} {
            #
        variable Stage        
            #
        return [list $Stage(Width) $Stage(Height)]   
            #
    }
        #
        #
    method getDivContainer {} {
        variable CanvasObject
        parray CanvasObject
        return $CanvasObject(DivContainer)
    }
        #
        #
        #
    method reportPointer {x y} {
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
        set w           $Canvas(Path)            
        set wScale      $Canvas(Scale)            
        set stageScale  $Stage(Scale)            
        set stageUnit   $Stage(Unit)
        set unitScale   $Stage(UnitScale)
            #
            
            #
        set bottomLeft  [my getBottomLeft]
        lassign $bottomLeft   bL_x bL_y
            # foreach {bL_x bL_y} $bottomLeft break
            #           [format "%4.2f" [expr  ( [eval $w canvasx $x] - $bL_x ) /   $unitScale]] -> 20170909
            #           [format "%4.2f" [expr  ( [eval $w canvasy $y] - $bL_y ) /  -$unitScale]] -> 20170909
        set stage_x     [format "%4.2f" [expr {([eval $w canvasx $x] - $bL_x ) *   $unitScale}]]
        set stage_y     [format "%4.2f" [expr {([eval $w canvasy $y] - $bL_y ) *  -$unitScale}]]
        set fmtScale    [format "%4.4f" $stageScale]
        set fmtOrig_x   [format "%4.2f" [expr {$stage_x / ($stageScale*$wScale)}]]
        set fmtOrig_y   [format "%4.2f" [expr {$stage_y / ($stageScale*$wScale)}]]
            #
        $w delete __cadCanvas__ponterPosition__
        $w create text 0 0 \
                -anchor sw \
                -text "scale: $fmtScale / $wScale  \[$stageUnit\]  $fmtOrig_x / $fmtOrig_y " \
                -tags {__cadCanvas__ponterPosition__} 
                    # text "\[$stageUnit\]  scale: $fmtScale: $stage_x / $stage_y  -  \[$fmtOrig_x / $fmtOrig_y \]"
            #
        my repositionPointerReport
            #
    }
        #
    method repositionPointerReport {} {
            #
        variable Canvas
            #
        set w   $Canvas(Path)    
            #
        set repCoords       [$w coords {__cadCanvas__ponterPosition__}]
            #
        if { $repCoords == {} } return
            #
        lassign $repCoords  x y
            # foreach {x y} $repCoords break
        set move_x          [expr {0 - $x + 8}]
        set move_y          [expr {[winfo height $w] - $y - 4}]
            #
        my move {__cadCanvas__ponterPosition__} $move_x $move_y
            #
    }
        #
        #
        #
    method resize {} {
            #
        variable Canvas
            #
        set w           $Canvas(Path)
            #
        my repositionPointerReport
            #
        puts "    [self] resizeCanvas ... $w"    
            #
        set w_width     [winfo width  $w]
        set w_height    [winfo height $w]
        set center_x    [expr {$w_width  / 2}]
        set center_y    [expr {$w_height / 2}]
            #
        set centerCoords [$w coords {__Stage__}]
        lassign $centerCoords  x1 y1 x2 y2
            # foreach {x1 y1 x2 y2} $centerCoords break
        set cnt_st_x    [expr {$x1 + ($x2 - $x1) / 2}]    
        set cnt_st_y    [expr {$y1 + ($y2 - $y1) / 2}]
            #
        set move_x      [expr {$center_x  - $cnt_st_x}]
        set move_y      [expr {$center_y  - $cnt_st_y}]
            #
        $w move {__Stage__}         $move_x $move_y
        $w move {__StageShadow__}   $move_x $move_y
        $w move {__Content__}       $move_x $move_y    
            #
    }
        #
    method fit {} {
            #  refit content to Center
            #
        variable Canvas
        variable Stage
            #
        set w               $Canvas(Path)
        set wScale          $Canvas(Scale)
        set stageUnit       $Stage(Unit)
            #
            # -- debug
            # puts "     [self] -> fit:  $w"
            # puts "     [self] -> fit:  $wScale"
            # puts "     [self] -> fit:  $stageUnit"
        
            # -- size in points
            #
        set w_width  [winfo width  $w]
        set w_height [winfo height $w]
            #
            # -- get values from config variable
            #
        set x       $Stage(Width)
        set y       $Stage(Height)

            # -- generate stage reference
            #
        $w create rectangle   0  0  $x$stageUnit  $y$stageUnit    \
                              -tags    {__StageCheck__}  \
                              -fill    white    \
                              -outline white    \
                              -width   0
            #
        set checkCoords [$w coords  {__StageCheck__}]
        my  delete {__StageCheck__}
        lassign $checkCoords  x1 y1 x2 y2
            # foreach {x1 y1 x2 y2} $checkCoords break
        set checkLength [expr {$x2 -$x1}]
            #
        set stageCoords [$w coords  {__Stage__}]
        lassign $stageCoords  x1 y1 x2 y2
            # foreach {x1 y1 x2 y2} $stageCoords break
        set stageLength [expr {$x2 - $x1}]
        set refitScale  [expr {1.0 * $checkLength / $stageLength}]
            # puts "        checkLength  $checkLength"
            # puts "        stageLength  $stageLength"
            # puts "        refitScale   $refitScale"
        
            # -- compute Canvas Scale
            #
        lassign $checkCoords  x1 y1 x2 y2 
            # foreach {x1 y1 x2 y2} $checkCoords break
        set cvBorder    $Canvas(InnerBorder)
        set stage_x     [expr {$x2 - $x1}]
        set stage_y     [expr {$y2 - $y1}]
        set w_width_st  [expr {$w_width  - 2 * $cvBorder}]
        set w_height_st [expr {$w_height - 2 * $cvBorder}]
        set scale_x     [format "%.2f" [expr {$w_width_st  / $stage_x}]]
        set scale_y     [format "%.2f" [expr {$w_height_st / $stage_y}]]
        if {$scale_x < $scale_y} { 
            set cvScale $scale_x 
        } else {
            set cvScale $scale_y 
        }
        
            # puts "        $scale_x  - $scale_y :  $cvScale"
            # parray Stage
        
            # -- update object dictionary
            #
        my configure Canvas Scale $cvScale

            # -- scale stage by ($refitScale * $$cvScale)
            #
        set scale [expr {$cvScale * $refitScale}]
        my scale {__StageShadow__}  0 0 $scale $scale
        my scale {__Stage__}        0 0 $scale $scale
        my scale {__Content__}      0 0 $scale $scale
        

            # -- reposition to center
            #
        set stageCoords     [$w coords  {__Stage__}]
        set stageCenter     [cad4tcl::_getBBoxInfo $stageCoords center]
        set wCenter         [cad4tcl::_getBBoxInfo [list 0 0 $w_width $w_height]  center]
        set moveVector      [vectormath::subVector $wCenter $stageCenter]
            # moveVector    [::math::geometry::- $wCenter $stageCenter]
        my move  {__Stage__}    [lindex $moveVector 0] [lindex $moveVector 1]
        my move  {__Content__}  [lindex $moveVector 0] [lindex $moveVector 1]
        set stageCoords     [$w coords  {__Stage__} ]
        set shadowCoords    [$w coords  {__StageShadow__} ]
        
        set shadow_x        [expr [lindex $stageCoords 0] - [lindex $shadowCoords 0] + 6]
        set shadow_y        [expr [lindex $stageCoords 1] - [lindex $shadowCoords 1] + 5]


        my move  {__StageShadow__}  $shadow_x $shadow_y
        
        my UpdateDraft
            
        return $cvScale

    }        
        
        #
    method center {{scale 1.0}} {
            # scale content to center of stage 
        variable Canvas
        variable Stage
            #
        set w               $Canvas(Path)
        set wScale          $Canvas(Scale)
        set stageUnit       $Stage(Unit)
            #
            # -- ceck $w -------------
        if { $w == {} } {
            error "cad4tcl::scaleToCenter -> Error:  could not get \$w" 
        }
            #
        set newScale $scale
            #
        set myScale     [expr 1.0 * $newScale / $wScale]
            # puts "   ->    newScale:  $newScale"
            # puts "   ->    wScale:    $wScale"
            # puts "   ->  myScale:     $myScale"
        
            # -- scale content -------------
            # 
        set w_width  [winfo width  $w]
        set w_height [winfo height $w]
            #
        if {$myScale > 0} {
            my configure Canvas  Scale  $newScale
            
            $w  scale   {__Content__}   [expr $w_width/2]  [expr $w_height/2]  $myScale  $myScale
            $w  scale   {__Stage__}     [expr $w_width/2]  [expr $w_height/2]  $myScale  $myScale
            
                # -- handle shadow -------------
                #
            if {$Stage(Format) ne {passive}} {
                    #
                set stageCoords     [$w coords  {__Stage__}]
                $w  delete  {__StageShadow__}
                $w  create  rectangle   $stageCoords    \
                                      -tags    {__StageShadow__}  \
                                      -fill    gray40    \
                                      -outline gray40    \
                                      -width   0
                $w  move    {__StageShadow__}  6 5
                $w  lower   {__StageShadow__}  all
                    #
            }
    
                # -- handle pointer position -----
                #
            my reportPointer 0 0
                #
            update
            return $newScale
        }
        return $wScale
    }
        #
    method fitContent {tagList} {
            # refit content to stage 
        variable Canvas
        variable Stage
            #
        set w               $Canvas(Path)
        set wScale          $Canvas(Scale)
        set stageUnit       $Stage(Unit)
            #
        lassign [my bbox [lindex $tagList 0]]  cb_x1 cb_y1  cb_x2 cb_y2
            # foreach {cb_x1 cb_y1  cb_x2 cb_y2} [my bbox [lindex $tagList 0]] break
        if {![info exists cb_x1]} {
            puts "      -> no content!"
            return
        }
            # puts "  -> $cb_x1 $cb_y1  $cb_x2 $cb_y2"
                    
        
            # -- check BoundingBox
            #
        foreach tagID $tagList {
                # puts "  -> [$w bbox $tagID]"
                foreach {x1 y1 x2 y2} [my bbox $tagID] {
                        if {$x1 < $cb_x1} {set cb_x1 $x1}
                        if {$y1 < $cb_y1} {set cb_y1 $y1}
                        if {$x2 > $cb_x2} {set cb_x2 $x2}
                        if {$y2 > $cb_y2} {set cb_y2 $y2}
                }
        }
        set content_bb [list $cb_x1 $cb_y1  $cb_x2 $cb_y2]
            # puts "  -> $cb_x1 $cb_y1  $cb_x2 $cb_y2"
        set content_width   [expr {$cb_x2 - $cb_x1}]
        set content_height  [expr {$cb_y2 - $cb_y1}]
        
        lassign [my coords {__Stage__}]  sb_x1 sb_y1  sb_x2 sb_y2
            # foreach {sb_x1 sb_y1  sb_x2 sb_y2} [my coords {__Stage__}] break
        set stage_bb   [list $sb_x1 $sb_y1  $sb_x2 $sb_y2]
            # puts "  -> $sb_x1 $sb_y1  $sb_x2 $sb_y2"
        set stage_width     [expr {$sb_x2 - $sb_x1}]
        set stage_height    [expr {$sb_y2 - $sb_y1}]
        
        set scale_x         [expr {0.9 * $stage_width / $content_width}]
        set scale_y         [expr {0.9 * $stage_height / $content_height}]
        if {$scale_x < $scale_y} {
            set scale $scale_x
        } else {
            set scale $scale_y
        }

        foreach tagID $tagList {
            my scale $tagID 0 0 $scale $scale
        }
        
        my centerContent $tagList {0 0}
        
    }
        #
    method centerContent {tagList {vectorOffset {0 0}}} {
            #
        variable Canvas
            #
        set w       $Canvas(Path)
            #
        update
            #
            # -- check offset
            #
        set offSet          [list [lindex $vectorOffset 0] [expr {-1 * [lindex $vectorOffset 1]}]]
            #
            # -- centerStage
            #
        set coords          [$w coords {__Stage__} ]
            # puts "   - 010 - $coords"        
            # foreach {x1 y1 x2 y2}  $coords break
            # set centerStage     [list [expr $x1 + 0.5 * ($x2 - $x1)] [expr $y1 + 0.5 * ($y2 - $y1)]]
        set centerStage     [cad4tcl::_getBBoxInfo [$w coords {__Stage__}] center]
            # puts "   - 020 - centerStage: $centerStage"        
            #
            # -- centerContent
            #
        set bb_x1 999999999; set bb_x2 -999999999; set bb_y1 999999999; set bb_y2 -999999999
            #
        if 1 {
            foreach tagID $tagList {
                set coords      [$w bbox $tagID]
                foreach {x1 y1 x2 y2} $coords {
                        # puts "    ... $id   [$w gettags $id]"
                        # puts "              $x1 $y1 $x2 $y2"
                    if {$x1 < $bb_x1} {set bb_x1 $x1}
                    if {$x2 > $bb_x2} {set bb_x2 $x2}
                    if {$y1 < $bb_y1} {set bb_y1 $y1}
                    if {$y2 > $bb_y2} {set bb_y2 $y2}
                }
            }
        } else {
            set tagList_ {__Dimension__ __Frame__ __CenterLine__}
            set tagList_ {}
            foreach tagID $tagList {
                set contentIDs  [$w find withtag $tagID]
                foreach id $contentIDs {
                    foreach {x1 y1 x2 y2} [$w bbox $id] {
                        if {$x1 < $bb_x1} {set bb_x1 $x1}
                        if {$x2 > $bb_x2} {set bb_x2 $x2}
                        if {$y1 < $bb_y1} {set bb_y1 $y1}
                        if {$y2 > $bb_y2} {set bb_y2 $y2}
                    }
                }
            }
        }
            #
            # set centerContent   [list [expr $bb_x1 + 0.5 * ($bb_x2 - $bb_x1)] [expr $bb_y1 + 0.5 * ($bb_y2 - $bb_y1)]]
        set centerContent   [cad4tcl::_getBBoxInfo [list $bb_x1 $bb_y1 $bb_x2 $bb_y2] center]
            # puts "   - 020 - centerContent: $centerContent"        
            #
            # -- move Vector
            #
        set xy              [vectormath::subVector $centerStage $centerContent]
            # xy            [::math::geometry::-   $centerStage $centerContent]
            #
        foreach tagID $tagList {
            # puts "   -> $tagID - $xy - $offSet"
            my move $tagID  [lindex $xy 0]      [lindex $xy 1]
            my move $tagID  [lindex $offSet 0]  [lindex $offSet 1]
        }
            #
        return
            #
    }
        #
    method transformContent {tagID {transform {0 0}} {scale {0 0}} {orient {center}} args} {
            #
        variable Canvas
        variable Stage
        variable Style
            #
            # tk_messageBox -message "create:  \n    $w  $type \n    $cv_Config\n    $CoordList \n    $args "            
        set w            $Canvas(Path)            
        set wScale       $Canvas(Scale)            
        set stageScale   $Stage(Scale)            
        set stageUnit    $Stage(Unit)            
        set font         $Style(Font)
        set unitScale    $Stage(UnitScale) 
            #
        set moveVector   [cad4tcl::_getBottomLeft $w]
            #
            
            #
        set objCoords   [$w bbox $tagID]
        set objSize     [cad4tcl::_getBBoxInfo    $objCoords  size    ]
        set objCenter   [cad4tcl::_getBBoxInfo    $objCoords  center  ]
        set objWidth    [lindex $objSize 0]
        set objHeight   [lindex $objSize 1]
        set obj_x       [lindex $objCenter 0]
        set obj_y       [lindex $objCenter 1]
            #
            
            #
            # orient
        set _left  [expr {-0.5 * $objWidth}]
        set _down  [expr { 0.5 * $objHeight}]
        set _right [expr { 0.5 * $objWidth}]
        set _up    [expr {-0.5 * $objHeight}]
            #
        switch -exact $orient {
            n  {        set orient_x    0       ;   set orient_y    $_down}
            ne {        set orient_x    $_left  ;   set orient_y    $_down}
            e  {        set orient_x    $_left  ;   set orient_y    0}
            se {        set orient_x    $_left  ;   set orient_y    $_up}
            s  {        set orient_x    0       ;   set orient_y    $_up}
            sw {        set orient_x    $_right ;   set orient_y    $_up}
            w  {        set orient_x    $_right ;   set orient_y    0}
            nw {        set orient_x    $_right ;   set orient_y    $_down}
            center -
            default {   set orient_x    0       ;   set orient_y    0}
        }
            # puts "   ... move $orient_x / $orient_y"
        my move  $tagID  $orient_x      $orient_y
            #
            
            #
            # scale
        set scale_x         [expr {[lindex $scale 0] / $stageScale}]
        set scale_y         [expr {[lindex $scale 1] / $stageScale}]
        my scale $tagID  $obj_x $obj_y  $scale_x $scale_y
            #

            #
            # move
        set transform_x     [lindex $transform 0]    
        set transform_y     [expr {-1 * [lindex $transform 1]}]
            #               [expr $transform_x * $wScale * $unitScale] <- 20170909
            #               [expr $transform_y * $wScale * $unitScale] <- 20170909
        set resTransform_x  [expr {($transform_x * $wScale) / $unitScale}]
        set resTransform_y  [expr {($transform_y * $wScale) / $unitScale}]
        my move  $tagID  $resTransform_x $resTransform_y
            #
            
            #
        return $tagID
            #
    } 
        #
        #   define event for CanvasObject
        #
    method registerClickObject {objectID {command {}}} {
            #
        variable ClickObject
            #
        my bind $objectID   <Enter>         [list [self] configure Canvas Cursor  {hand2}]
        my bind $objectID   <Leave>         [list [self] configure Canvas Cursor  {}]
            #
            # my bind $objectID   <ButtonPress-1> [list [self] eventClick_B1  %X %Y   $objectID move]
            #
        set ClickObject($objectID) $command
            #
            # parray ClickObject
            #
    }
        #
    method registerDragObject {objectID {command {}}} {
            #
        variable DragObject
            #
        my bind $objectID   <Enter>         [list [self] configure Canvas Cursor  {hand2}]
        my bind $objectID   <Leave>         [list [self] configure Canvas Cursor  {}]
            #
        # my bind $objectID   <ButtonPress-1> [list [self] eventClick_B1  %X %Y   $objectID move]
            #
        set DragObject($objectID) $command
            #
    }
        #
        #   mouse-events Button-1
        #
    method eventClick_B1 {x y tagID {type {move}}} {       
            #
        variable CanvasObject  
        variable ClickObject
        variable DragObject  
        variable MarkPosition  
            #
            #
            puts "  ------> eventClick_B1 $x $y $tagID $type"
        set CanvasObject(release) {}
        if {$tagID eq {}} {
            return
        }
        switch -exact -- $tagID {
            __Stage__ {
                set CanvasObject(current) [my FindClosest $x $y]
            }
            default {
                set CanvasObject(current) $tagID
            }
        }
            puts "  ------> $CanvasObject(current)"
            #
            #
        if {[my find withtag __DivContainer__] ne {}} {
            set CanvasObject(DivContainerPos) [my coords __DivContainer__]
        }
        if {[my find withtag __ConfigContainer__] ne {}} {
            set CanvasObject(ConfigContainerPos) [my coords __ConfigContainer__]
        }
            #
        if [my CheckClickObject $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
        if [my CheckConfigCorner $CanvasObject(current)] {
                #
            if {$type eq {click}} {
                    #
                puts "   -> execute"
                puts "       ---> $type"
                puts "       ---> $CanvasObject(ConfigCommand)"
                    #
                eval $CanvasObject(ConfigCommand)
                    #
                    # reset Event-Condition
                set CanvasObject(current) {}
                return
                    #
            }
                #
        }    
            #
        if [my EventCheckCurrent $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
            #
        my configure Canvas Cursor hand2
            #
        my SetMark $x $y $type
            #
        return
            #
    }
    method eventMotion_B1 {x y} {
            #
        variable CanvasObject  
        variable DragObject  
            #
            #
        if {$CanvasObject(current) eq {}} {
            return
        }
            #
            #
        if [my EventCheckCurrent $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
            #
        if [my CheckDivContainer $CanvasObject(current)] {
                # drag now
                # puts "    ---> drag now"
            my DragContent $CanvasObject(current) $x $y
            return
                #
        }
            #
            #
        if [my CheckDragObject $CanvasObject(current)] {
                # drag now
                # puts "    ---> drag now"
            my DragContent $CanvasObject(current) $x $y
            return
                #
        }
            #
            # prepare for later move
        puts "    ---> later move"
        my SetRange $x $y
            #
            #
        return
            #
    }
    method eventRelease_B1 {x y} {
            #
        variable Canvas
        variable Stage
            #
        variable CanvasObject  
        variable DragObject  
        variable MarkPosition
            #
            #
            # puts "  ------> eventRelease_B1 $x $y"
        set CanvasObject(release) [my FindClosest $x $y]
            #
            # -- reset cursor
        my configure Canvas Cursor  {}
            #
            #
        if {$CanvasObject(current) eq {}} {
            return
        }
            #
        if [my EventCheckRelease $CanvasObject(release)] {
            return
        }
            #
        if [my EventCheckCurrent $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
        if [my CheckDragObject $CanvasObject(current)] {
                #
            set dragDefinition  [array get DragObject $CanvasObject(current)]
            lassign  $dragDefinition  dragID releaseCmd
                # foreach {dragID releaseCmd} $dragDefinition break
                #
            set dragScale       [expr {(1.0 * $Stage(UnitScale)) / ($Canvas(Scale) * $Stage(Scale))}] 
                #
                # Determine size of move
            set move_xlength    [expr {$x - $MarkPosition(x0)}]
            set move_ylength    [expr {$y - $MarkPosition(y0)}]
                #
            set vctMoveCanvas   [list $move_xlength $move_ylength]
            set vctMoveReal     [vectormath::scaleCoordList {0 0} $vctMoveCanvas $dragScale]
                #
            puts "   -> execute"
            puts "       ---> $releaseCmd"
                #
            eval $releaseCmd {$vctMoveReal}
                #
        } else {
                #
            set w   [my getCanvas] 
            set dx  [expr {[$w canvasx $x] - $MarkPosition(x0)}]    
            set dy  [expr {[$w canvasy $y] - $MarkPosition(y0)}]    
                #
            my MoveVector all $dx $dy
                #
        }
            # -- reset
        set CanvasObject(current)    {}
        foreach name [array names MarkPosition] {
            set MarkPosition($name) 0
        }
        my delete {__PointerBBox__}
            #
        return
            #
    }
        #
        #   mouse-events Button-3
        #
    method eventClick_B3 {x y tagID {type {zoom}}} {
            #
        variable CanvasObject  
        variable MarkPosition  
            #
            #
        set CanvasObject(release) {}
        if {$tagID eq {}} {
            set CanvasObject(current) [my FindClosest $x $y]
        } else {
            set CanvasObject(current) $tagID
        }
            #
            #
        if {[my find withtag __DivContainer__] ne {}} {
            set CanvasObject(DivContainerPos) [my coords __DivContainer__]
        }
        if {[my find withtag __ConfigContainer__] ne {}} {
            set CanvasObject(ConfigContainerPos) [my coords __ConfigContainer__]
        }
            #
            #
        if [my EventCheckCurrent $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
            #
        my configure Canvas Cursor  sizing
            #
        my SetMark $x $y $type
            #
    } 
    method eventMotion_B3 {x y} {
            #
        variable CanvasObject  
        variable MarkPosition  
            #
            #
        if {$CanvasObject(current) eq {}} {
            return
        }
            #
        if [my EventCheckCurrent $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
            #
        my SetRange $x $y
            #
        return
            #    
    } 
    method eventRelease_B3 {x y} {
            #
        variable CanvasObject  
        variable MarkPosition  
            #
            #
        set CanvasObject(release) [my FindClosest $x $y]
            #
            # -- reset cursor
        my configure Canvas Cursor  {}
            #          
            #
        if {$CanvasObject(current) eq {}} {
            return
        }
            #
        if [my EventCheckRelease $CanvasObject(release)] {
            # return
        }
            #
        if [my EventCheckCurrent $CanvasObject(current)] {
                # reset Event-Condition
            set CanvasObject(current) {}
            return
        }
            #
            #
        my ZoomArea  [my bbox __PointerBBox__]
            #
            #
            # -- reset
        set CanvasObject(current)    {}
        foreach name [array names MarkPosition] {
            set MarkPosition($name) 0
        }
        my delete {__PointerBBox__}
            #
        return
            #
    }
        #
    method EventCheckCurrent {tagID} {    
            #
        variable CanvasObject
        variable MarkPosition
            #
        set isException 0
            #
        puts "        -> EventCheckCurrent      -> $tagID"
            #
            #
        if [my CheckNoDrag $tagID] {    
            foreach name [array names MarkPosition] {
                set MarkPosition($name) 0
            }
            set isException 1
            puts "            -> CheckNoDrag            -> $isException"
        }            
            #
            #
        if [my CheckConfigCorner $tagID] {
            foreach name [array names MarkPosition] {
                set MarkPosition($name) 0
            }
            set isException 1
            puts "            -> CheckConfigCorner      -> $isException"
        }
            #
            #
        return $isException    
            #
    }
        
        #
    method EventCheckRelease {tagID} {    
            #
        variable MarkPosition
            #
        set isException 0
            #
        puts "        -> EventCheckRelease      -> $tagID"
            #
            #
        if [my CheckNoDrag $tagID] {    
            foreach name [array names MarkPosition] {
                set MarkPosition($name) 0
            }
            set isException 1
            puts "            -> CheckNoDrag            -> $isException"
        }            
            #
            #
        if [my CheckConfigContainer $tagID] {
            foreach name [array names MarkPosition] {
                set MarkPosition($name) 0
            }
            set isException 1
            puts "            -> CheckConfigContainer   -> $isException"
        }
            #
            #
        if [my CheckConfigCorner $tagID] {
            foreach name [array names MarkPosition] {
                set MarkPosition($name) 0
            }
            set isException 1
            puts "            -> CheckConfigCorner      -> $isException"
        }
            #
            #
        return $isException    
            #
    }
        
        #
        #
        #
    method SetMark {x y type} {
            #
            # mark the first (x,y) coordinate for moving/zooming
            #
        variable CanvasObject  
        variable MarkPosition  
            #
        set w   [my getCanvas]
            #
            # puts "\n\n\n"
            # puts "-------> SetMark"
            # puts "          -> $w   $x  $y  [winfo class $w]"
            # puts "          -> tagID   -> $CanvasObject(current)"
            # puts "          -> canvasx -> [$w canvasx $x]"
            # puts "          -> canvasy -> [$w canvasy $y]"
            #
            #
            
            
            # -- get MarkPosition
        set MarkPosition(x0)    [$w canvasx $x]
        set MarkPosition(y0)    [$w canvasy $y]
        set MarkPosition(x1)    [$w canvasx $x]
        set MarkPosition(y1)    [$w canvasy $y]
            #
            # -- create line or rectangle
        $w delete withtag __PointerBBox__
            #
        switch $type {
            move { 
                $w create line      $x $y $x $y -fill red       -tag {__PointerBBox__} 
            }
            zoom { 
                $w create rectangle $x $y $x $y -outline red    -tag {__PointerBBox__} 
            }
        }            
            #
        return
            #
    }
    method SetRange {x y} {
            #
            # setZoom; mark the second (x,y) coordinate for moving/zooming.
            #
        variable  MarkPosition
            #
        set w   [my getCanvas]
        set MarkPosition(x1)    [$w canvasx $x]
        set MarkPosition(y1)    [$w canvasy $y]
            # -- default  
        my coords {__PointerBBox__} $MarkPosition(x0) $MarkPosition(y0) [$w canvasx $x] [$w canvasy $y]
            #
    }
        #
        #
        #
    method CheckConfigCorner {tagID} {
            #
        set tagList [my gettags $tagID]
            #
        if {[lsearch $tagList {__ConfigCorner__}] >= 0} {
            puts "            ... is a __ConfigCorner__   - Object"
            return 1
        } else {
            puts "            ... not a  __ConfigCorner__ - Object"
            return 0
        }
            #
    }
        #
    method CheckConfigContainer {tagID} {
            #
        set tagList [my gettags $tagID]
            #
        if {[lsearch $tagList {__ConfigContainer__}] >= 0} {
            puts "            ... is a __ConfigContainer__   - Object"
            return 1
        } else {
            puts "            ... not a  __ConfigContainer__ - Object"
            return 0
        }
            #
    }
        #
    method CheckClickObject {tagID} {
            #
        variable  ClickObject
            #
        if {[lsearch -inline [array names ClickObject] $tagID] ne {}} {
            puts "            ... is registered in \$ClickObject"
            return 1
        } else {
            puts "            ... not registered in \$ClickObject"
            return 0
        }
            #
    }
        #
    method CheckDragObject {tagID} {
            #
        variable  DragObject
            #
        if {[lsearch -inline [array names DragObject] $tagID] ne {}} {
            puts "            ... is registered in \$DragObject"
            return 1
        } else {
            puts "            ... not registered in \$DragObject"
            return 0
        }
            #
    }
        #
    method CheckNoDrag {tagID} {
            #
        set tagList [my gettags $tagID]
            #
        if {[lsearch $tagList {__NoDrag__}] >= 0} {
            puts "            ... is a   __NoDrag__ - Object"
            return 1
        } else {
            puts "            ... not a  __NoDrag__ - Object"
            return 0
        }
            #
    }
        #
    method CheckDivContainer {tagID} {
            #
        set tagList [my gettags $tagID]
            #
        if {[lsearch $tagList {__DivContainer__}] >= 0} {
            puts "            ... is a   __DivContainer__ - Object"
            return 1
        } else {
            puts "            ... not a  __DivContainer__ - Object"
            return 0
        }
            #
    }
        #
        #
        #
    method MoveVector {tagID x y} {
            #
        variable Canvas
            #
        variable CanvasObject
            #
        set w               $Canvas(Path)
            #
            # puts " => proc [self] move $vctMove"
            #
            # foreach {x y} $vctMove break
            #
        if {($x == 0) && ($y == 0)} {
            #  Check for zero-size area
            return
        }
            #
        my move {__Stage__}             $x $y
        my move {__StageShadow__}       $x $y
        my move {__Content__}           $x $y
            #
        if [my CheckNoDrag $CanvasObject(current)] {
                # the selected item does have tag {__dragObject__}
            # my move $CanvasObject(current)    $x $y
                #
        } else {
                # the selected item does not have tag {__dragObject__}
            # my move {__Stage__}             $x $y
            # my move {__StageShadow__}       $x $y
            # my move {__Content__}           $x $y
                #
        }
            #
        my configure Style Cursor {}
            #
        my reportPointer 0 0    
            #
        return
            #
    }
        #
        #
        #
    method ZoomArea {bbox} {
            # zoom in canvas
        variable CanvasObject  
        variable MarkPosition  
            #
            #
        lassign $bbox  x0 y0 x1 y1
            # foreach {x0 y0 x1 y1} $bbox break

            #--------------------------------------------------------
            #  Check for zero-size area
        if {($x0 == $x1) || ($y0 == $y1)} {
            return
        }

            #--------------------------------------------------------
            #  Determine size and center of selected area
        set areaxlength [expr {(abs($x1 - $x0))}]
        set areaylength [expr {(abs($y1 - $y0))}]
        set xcenter     [expr {(($x0 + $x1)/2.0)}]
        set ycenter     [expr {(($y0 + $y1)/2.0)}]

            #--------------------------------------------------------
            #  Determine size of current window view
            #  Note that canvas scaling always changes the coordinates
            #  into pixel coordinates, so the size of the current
            #  viewport is always the canvas size in pixels.
            #  Since the canvas may have been resized, ask the
            #  window manager for the canvas dimensions.
        set w          [my getCanvas]    
        set winxlength [winfo width  $w]
        set winylength [winfo height $w]

            #--------------------------------------------------------
            #  Calculate scale factors, and choose smaller
        set xscale [expr {1.0 * $winxlength/$areaxlength}]
        set yscale [expr {1.0 * $winylength/$areaylength}]
            #
        if { $xscale > $yscale } {
            set factor $yscale
        } else {
            set factor $xscale
        }
            #
        my CenterBBox $bbox $factor
            #
        my UpdateCanvasItems $factor
            #
        my configure Canvas Cursor  {}
            #
        my reportPointer 0 0
            #
        my UpdateItemInterface    
            #
        return 
            #
    } 
        #
    method CenterBBox {bbox {scale 1.0}} {
            #
        variable Canvas    
            #
        set w               $Canvas(Path)
            #
        if {[llength $bbox] < 4 } { 
            return 
        }
            #
        set cvSize      [my getSize]
        set cvCenter    [cad4tcl::_getBBoxInfo    [list 0 0 [lindex $cvSize 0]  [lindex $cvSize 1]]  center ]
            #
        set cbCenter    [cad4tcl::_getBBoxInfo    $bbox  center ]
            #
        set cvMove      [vectormath::subVector      $cvCenter  $cbCenter] 
            #  cvMove      [::math::geometry::-      $cvCenter  $cbCenter] 
            #
            #
        my move  all    [lindex $cvMove   0]  [lindex $cvMove   1]    
        my scale all    [lindex $cvCenter 0]  [lindex $cvCenter 1]  $scale  $scale    
            #
            #
        return $cvMove
            #
    }
        #        
        #
    method DragContent {tagId x y} {
            #
        variable  Canvas 
        variable  DragObject 
        variable  MarkPosition 
            #
        set w   $Canvas(Path)    
            #
        set xDiff [expr {$x - $MarkPosition(x1)}]
        set yDiff [expr {$y - $MarkPosition(y1)}]
            #
        set MarkPosition(x1) $x
        set MarkPosition(y1) $y
            #
        set tagList [$w gettags $tagId]
            # -- drag -> x ----
        if {[lsearch $tagList {__dragObject_x__}] > 0} {
            my move $tagId $xDiff 0
            return 
        }
            # -- drag -> y ----
        if {[lsearch $tagList {__dragObject_y__}] > 0} {
            my move $tagId 0 $yDiff
            return 
        }
            # -- default
        my move $tagId $xDiff $yDiff
            #
        return
            #
    }        
        
        
        
        #
        #
        #
    method UpdateCanvasItems {{scaleFactor {}}} {          
            #
        variable Canvas
        variable CanvasObject
            #
        if {$scaleFactor == {}} {
            return $Canvas(Scale)
        }             
            # -- modify canvasScale parameter from extern
        set newScale    [eval format "%.4f" [expr {$Canvas(Scale) * $scaleFactor}]]
            #
        set wScale      [my configure   Canvas  Scale  $newScale]
            #
            # -- configCorner
        if {[my find withtag __ConfigCorner__] ne {}} {
                #
            set bboxConfig  [my bbox __ConfigCorner__]
            set origConfig  [cad4tcl::_getBBoxInfo $bboxConfig origin]
            lassign $origConfig  x y
                # foreach {x y} $origConfig break
            set x [expr {-1 * $x}]
            set y [expr {-1 * $y}]
            my move  __ConfigCorner__ $x $y
            my scale __ConfigCorner__ 0 0 [expr {1.0 / $scaleFactor}] [expr {1.0 / $scaleFactor}]
                #
        }
            # -- configContainer
        if {[my find withtag __ConfigContainer__] ne {}} {
                #
            puts "    -> $CanvasObject(ConfigContainerPos)"
            set posCurrent [my coords __ConfigContainer__]
            set posTarget  $CanvasObject(ConfigContainerPos)
            lassign $posCurrent  cx cy
            lassign $posTarget   tx ty
                # foreach {cx cy} $posCurrent break
                # foreach {tx ty} $posTarget  break
                #
            set dx [expr {$tx - $cx}]
            set dy [expr {$ty - $cy}]
                #
            my move  __ConfigContainer__ $dx $dy
                #
        }
            # -- divContainer
        if {[my find withtag __DivContainer__] ne {}} {
                #
            puts "    -> $CanvasObject(DivContainerPos)"
            set posCurrent [my coords __DivContainer__]
            set posTarget  $CanvasObject(DivContainerPos)
            lassign $posCurrent  cx cy
            lassign $posTarget   tx ty
                # foreach {cx cy} $posCurrent break
                # foreach {tx ty} $posTarget  break
                #
            set dx [expr {$tx - $cx}]
            set dy [expr {$ty - $cy}]
                #
            my move  __DivContainer__ $dx $dy
                #
        } 
            #
            #
        my UpdateItemInterface    
            #
        return $Canvas(Scale)
            #
    }        
        #
    method UpdateCanvas {} {
            #
        variable Canvas
        variable Stage
            #
        set w   $Canvas(Path)
            #
        set stageFormat $Stage(Format)
        set oldWidth    $Stage(Width)
        set oldHeight   $Stage(Height)
            #
            # puts "  \$Stage(Format) $Stage(Format)"    
            #
        switch -exact -- $Stage(Format) {
            noFormat -
            passive {
                return
            }
        }
        lassign [cad4tcl::_getFormatSize $stageFormat]  stageWidth stageHeight stageUnit
            # foreach {stageWidth stageHeight stageUnit}  [cad4tcl::_getFormatSize $stageFormat] break
            #
        my configure    Stage  Width    $stageWidth
        my configure    Stage  Height   $stageHeight
            #
        set fontSize    [cad4tcl::getNodeAttributeRoot /root/_package_/DIN_Format/$stageFormat f2]
            #
        my configure    Style  Linewidth    [expr {0.1 * $fontSize}]
        my configure    Style  Fontsize     $fontSize
            #
        set bboxStage   [$w coords {__Stage__}]
        set posBottom   [cad4tcl::_getBBoxInfo $bboxStage originBottom]
        lassign $posBottom  x y
            # foreach {x y}   $posBottom break
            #
        set scaleWidth  [expr {1.0 * $stageWidth  / $oldWidth}]
        set scaleHeight [expr {1.0 * $stageHeight / $oldHeight}]
            #
        $w  scale  {__Stage__}          $x $y $scaleWidth $scaleHeight
        $w  scale  {__StageShadow__}    $x $y $scaleWidth $scaleHeight
            #
        my UpdateItemInterface    
            #
        if {$scaleWidth ne 1.0} {
            my UpdateDraft
        }
            #
        return $w
            #
    }
        #
    method FindClosest {x y} {    
            #
        variable Canvas
        set w    [my getCanvas]    
            #
            #
        switch -exact $Canvas(Type) {
            PathCanvas {
                    # $w find closest x y ?halo? ?start?
                    # ... tkpath requires - ?start?
                set lastTag  [lindex [$w find overlapping 0 0 [winfo width $w] [winfo height $w]] end]
                    # puts "  -> \$lastTag $lastTag"
                set closestObject [$w find closest $x $y 0 $lastTag]
                    # puts " .... [$w find closest $x $y] "
                    # puts " .... [llength [$w find closest $x $y]]"
            }
            default {
                    # $w create line $x $y [expr $x+200] $y -fill green
                    # $w create line 0 0 [expr $x+200] 0 -fill blue
                set closestObject [$w find closest $x $y]
            }
        }
            #
        return $closestObject
            #
    }
        #
        #
        #
    method UpdateItemInterface {} {
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
        variable ItemInterface
            #
        $ItemInterface configure  canvasScale             $Canvas(Scale)
            #
        $ItemInterface configure  stageFormat             $Stage(Format)
        $ItemInterface configure  stagePointScale         $Stage(PointScale)
        $ItemInterface configure  stageUnit               $Stage(Unit)
        $ItemInterface configure  stageUnitScale          $Stage(UnitScale)
        $ItemInterface configure  stageScale              $Stage(Scale)
        $ItemInterface configure  stageWidth              $Stage(Width)
        $ItemInterface configure  stageHeight             $Stage(Height)
            #
        $ItemInterface configure  styleLinewidth          $Style(Linewidth)
        $ItemInterface configure  styleLinecolour         $Style(Linecolour)
        $ItemInterface configure  styleFontstyle          $Style(Fontstyle)
        $ItemInterface configure  styleFontsize           $Style(Fontsize)
        $ItemInterface configure  styleFontdist           $Style(Fontdist)
        $ItemInterface configure  styleFont               $Style(Font)
        $ItemInterface configure  styleFontcolour         $Style(Fontcolour)
        $ItemInterface configure  stylePrecision          $Style(Precision)
        $ItemInterface configure  styleDefaultprecision   $Style(Defaultprecision) 
            #
        $ItemInterface configure  unitScale_p             $UnitScale(p)
            #
    }    
        #
    method UpdateDraft {} {
            #
        variable ItemInterface
            #
        set itemList [my find withtag __DraftFrame__]
        if {[llength $itemList] > 0} {
            $ItemInterface updateDraftFrame
        }
            #
        set itemList [my find withtag __DraftRaster__]
        if {[llength $itemList] > 0} {
            my create draftRaster {} {}
        }
            #
        catch {$canvasObject lower {__DraftFrame__}  all}
        catch {$canvasObject lower {__DraftRaster__} all}
            #
    }
        #
        #
    method CreateReportDOM {} {
            #
        variable ReportDoc    
            #
        set ReportDoc   [dom parse "<instance/>"]
        set ReportRoot  [$ReportDoc documentElement]
            #
        set templateXML [cad4tcl::getNodeRoot /root/_package_/Object_Template]
            #
        foreach childNode [$templateXML childNodes] {
            set childXML    [$childNode asXML]
            $ReportRoot appendXML $childXML
        }
            #
        return $ReportDoc
            #
    }
        #
    method updateReportDOM {} {
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
        variable ReportDoc
        variable ReportRoot
            #
        set ReportRoot  [$ReportDoc documentElement]
            #
        cad4tcl::setNodeAttribute $ReportRoot Canvas iborder          $Canvas(InnerBorder)
        cad4tcl::setNodeAttribute $ReportRoot Canvas scale            $Canvas(Scale)
        cad4tcl::setNodeAttribute $ReportRoot Canvas path             $Canvas(Path)
        cad4tcl::setNodeAttribute $ReportRoot Canvas object           [self]
            #
        cad4tcl::setNodeAttribute $ReportRoot Stage format            $Stage(Format)
        cad4tcl::setNodeAttribute $ReportRoot Stage height            $Stage(Height)
        cad4tcl::setNodeAttribute $ReportRoot Stage scale             $Stage(Scale) 
        cad4tcl::setNodeAttribute $ReportRoot Stage unit              $Stage(Unit)  
        cad4tcl::setNodeAttribute $ReportRoot Stage width             $Stage(Width) 
        cad4tcl::setNodeAttribute $ReportRoot Stage title             $Stage(Title) 
        cad4tcl::setNodeAttribute $ReportRoot Stage format            $Stage(UnitScale)
            #
        cad4tcl::setNodeAttribute $ReportRoot Style defaultprecision  $Style(Defaultprecision)
        cad4tcl::setNodeAttribute $ReportRoot Style font              $Style(Font)            
        cad4tcl::setNodeAttribute $ReportRoot Style fontcolour        $Style(Fontcolour)      
        cad4tcl::setNodeAttribute $ReportRoot Style fontdist          $Style(Fontdist)        
        cad4tcl::setNodeAttribute $ReportRoot Style fontsize          $Style(Fontsize)        
        cad4tcl::setNodeAttribute $ReportRoot Style fontstyle         $Style(Fontstyle)       
        cad4tcl::setNodeAttribute $ReportRoot Style linecolour        $Style(Linecolour)      
        cad4tcl::setNodeAttribute $ReportRoot Style linewidth         $Style(Linewidth)       
        cad4tcl::setNodeAttribute $ReportRoot Style precision         $Style(Precision)       
            #
        return $ReportDoc
            #
    }
        #
        #
}

