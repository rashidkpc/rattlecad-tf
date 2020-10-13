 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	ItemInterface__Super.tcl
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
namespace eval cad4tcl {oo::class create ItemInterface__Super}
    #
oo::define cad4tcl::ItemInterface__Super {
        #
    variable packageHomeDir         ;# base dir of package
        #
    constructor {cvObj} { 
            #
        puts "              -> class ItemInterface__Super"
        puts "                  -> $cvObj"
            #
        variable canvasObject           $cvObj
            #
        variable packageHomeDir
            #
        variable DimensionFactory  
        variable DXF
        variable SVG  
            #
            #
        variable canvasPath             [$canvasObject getCanvas]
            #
        variable canvasScale
            #
            # <Stage 	format="" unit="" scale="" width="" height="" title=""/>
        variable stageFormat   
        variable stageUnit      
        variable stageUnitScale
        variable stageScale    
        variable stageWidth    
        variable stageHeight   
            # <Style  linewidth="0.35" linecolour="black" fontstyle="vector" fontsize="3.5" fontdist="1" font="Arial" fontcolour="black" precision="2" defaultprecision="2"/>
        variable styleLinewidth       
        variable styleLinecolour      
        variable styleFontstyle        
        variable styleFontsize        
        variable styleFontdist        
        variable styleFont            
        variable styleFontcolour      
        variable stylePrecision       
        variable styleDefaultprecision
            #
        variable unitScale_p    
            #
        variable DraftFrame
        variable DraftRaster
            #
            #
        set packageHomeDir              $::cad4tcl::packageHomeDir
            #
            # ------- Create DimensionFactory ------------------------------
        set DimensionFactory            [cad4tcl::DimensionFactory        new $canvasObject [self]]     
            # ------- Create Format Extensions -----------------------------
            # set DXF                   [cad4tcl::Extension_DXF           new $canvasObject ]     
            # set SVG                   [cad4tcl::Extension_SVG_Canvas    new $canvasObject [self]]     
            #
            #
        set stageFormat                 "A4"
            #
        set styleFontsize                  2.5
            #
        set styleLinewidth              [expr {0.1 * $styleFontsize}]
        set styleLinecolour             "black" 
        set styleFontstyle              "vector" 
        set styleFontdist               [expr {0.1 * $styleFontsize}]
        set styleFont                   "Arial" 
        set styleFontcolour             "black" 
        set stylePrecision                 2 
        set styleDefaultprecision          2
            #
        array set DraftFrame {
                        label   {}    
                        title   {}    
                        date    {}    
                        descr   {}
                    }
        array set DraftRaster {
                        minorDistance      2    
                        minorColor      gray70    
                        majorDistance     10    
                        majorColor      gray20
                    }
            #
        vectorfont::setCanvas   [$cvObj getCanvas] 0
            #
                return
            #                     
    }
        #
    destructor {
        puts "            -> [self] ... destroy ItemInterface__Super"
    }
        #
    method unknown {target_method args} {
        puts "<E> ... cad4tcl::ItemInterface__Super $target_method $args  ... unknown"
    }
        #
        #
    method updateConfig {} {
            #
        variable canvasObject    
            #
            #
            #
        # my configure  canvasScale             [$canvasObject configure Canvas Scale          ]
            #
        # my configure  stageFormat             [$canvasObject configure Stage Format          ]
        # my configure  stagePointScale         [$canvasObject configure Stage PointScale      ]
        # my configure  stageUnit               [$canvasObject configure Stage Unit            ]
        # my configure  stageUnitScale          [$canvasObject configure Stage UnitScale       ]
        # my configure  stageScale              [$canvasObject configure Stage Scale           ]
        # my configure  stageWidth              [$canvasObject configure Stage Width           ]
        # my configure  stageHeight             [$canvasObject configure Stage Height          ]
            #
        # my configure  styleLinewidth          [$canvasObject configure Style Linewidth       ]
        # my configure  styleLinecolour         [$canvasObject configure Style Linecolour      ]
        # my configure  styleFontstyle          [$canvasObject configure Style Fontstyle       ]
        # my configure  styleFontsize           [$canvasObject configure Style Fontsize        ]
        # my configure  styleFontdist           [$canvasObject configure Style Fontdist        ]
        # my configure  styleFont               [$canvasObject configure Style Font            ]
        # my configure  styleFontcolour         [$canvasObject configure Style Fontcolour      ]
        # my configure  stylePrecision          [$canvasObject configure Style Precision       ]
        # my configure  styleDefaultprecision   [$canvasObject configure Style Defaultprecision] 
            #
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
        
            # puts "    $stageFormat - \$styleLinewidth $styleLinewidth  <- $type"
            # set styleLinewidth 0.35
            # puts "                   \$styleLinewidth $styleLinewidth"
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
                rectangle -
                vectorText {
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
        variable canvasPath
        set itemType    [$canvasPath type $itemTag]
        set argList     [my UpdateItemAttributes $itemType $argList]
        eval $canvasPath itemconfigure $itemTag $argList
            #
    }
        #
    method itemcget {itemTag option} {
            #
        variable canvasPath
        return [eval $canvasPath itemcget $itemTag $option]
            #
    }
        #
    method export {fileFormat fileName} {
        switch -exact -- $fileFormat {
            dxf -
            DXF {
                return [my exportDXF $fileName]
            }
            svg -
            SVG {
                return [my exportSVG $fileName]
            }
            default {
                puts "   -> export \$fileFormat $fileFormat ... not defined"
                return {}
            }
        }
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
    method configure {key {value __noValue__}} {
            #
        variable canvasPath
        variable canvasScale
        variable stageFormat
        variable stagePointScale
        variable stageUnit
        variable stageUnitScale
        variable stageScale
        variable stageWidth
        variable stageHeight
        variable styleLinewidth
        variable styleLinecolour
        variable styleFontstyle
        variable styleFontsize
        variable styleFontdist
        variable styleFont
        variable styleFontcolour
        variable stylePrecision
        variable styleDefaultprecision
        variable unitScale_p
            #
        switch -exact -- $key {
            canvasScale -
            stageFormat -
            stagePointScale -
            stageUnit -
            stageUnitScale -
            stageScale -
            stageWidth -
            stageHeight -
            styleLinewidth -
            styleLinecolour -
            styleFontstyle -
            styleFontsize -
            styleFontdist -
            styleFont -
            styleFontcolour -
            stylePrecision -
            styleDefaultprecision -
            unitScale_p {
                if {$value ne {__noValue__}} {
                    # puts "   -> $key $value"
                    set $key $value
                    return [set $key]
                } else {
                    # puts "   -> $key [set $key]"
                    return [set $key]
                }
            }
            canvasPath {
                    # puts "   -> $key [set $key]"
                    return [set $key]
            }
            default {
            }
        }
    }
        #
        #
    method UpdateItemAttributes {type argDict} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
        variable unitScale_p
            #
        if [dict exists $argDict -width] {
            set lineWidth   [dict get $argDict -width]
                # puts "   -----> UpdateItemAttributes \$lineWidth $lineWidth"
            set newWidth    [expr {$lineWidth * $canvasScale / $stageUnitScale}]
                # puts "   ------------------> createLine \$lineWidth $newWidth"
            dict set argDict -width $newWidth
        } else {
            # puts "   --- ERROR --------> createLine \$lineWidth $newWidth"
            # appUtil::pdict $argDict
        }
            #
        if [dict exists $argDict -outline] {
            switch -exact -- $type {
                line {
                    set outlineColor    [dict get $argDict -outline]
                    dict unset argDict  -outline
                    dict set argDict    -fill $outlineColor
                }
            }
        } else {
            # puts "   --- ERROR --------> createLine \$lineWidth $newWidth"
            # appUtil::pdict $argDict
        }
            #
        if [dict exists $argDict -dash] {
                # in pixels
            # set dashArray   [dict get $argDict -dash]
                # puts "   ------------------> createLine \$dashArray $newArray"
                # dict set argDict -dash $newArray
        } else {
            # puts "   --- ERROR --------> createLine \$lineWidth $newWidth"
            # appUtil::pdict $argDict
        }
            #
        return $argDict    
            #
    }
        #
        #
    method createArc {coordList argList} {
            #
        variable canvasObject
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath            
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            #
        set newDict     {}
            # set argList     [dict create]
            #
        if [dict exists $argList -radius] {
            set Radius [dict get $argList -radius]
            set argList [dict remove $argList -radius]
        }
        dict for {key value} $argList {
            switch -exact $key {
                -tags {
                    set tagList [cad4tcl::_flattenNestedList $value]
                    dict set argList -tags $tagList
                }
            }
        }
            #
        if 0 {
            for {set x 0} {$x<[llength $new_args]} {incr x} {
                if {[string equal   [lindex $new_args $x] {-radius} ]} {
                    set Radius      [lindex $new_args $x+1]
                    incr x
                } else {
                    lappend args    [lindex $new_args $x]
                }
                if {[string equal   [lindex $new_args $x] {-tags} ]} {
                    set tagList     [cad4tcl::_flattenNestedList [lindex $new_args $x+1] ]
                    lappend args    [list $tagList ]
                    incr x
                }                                
            }
        }
            # tk_messageBox -message "createCircle Radius $Radius \n   $args"
        lassign $coordList  x y
            # foreach {x y} $coordList break
        set coordList   [list [expr {$x-$Radius}] [expr {$y+$Radius}] [expr {$x+$Radius}] [expr {$y-$Radius}]]
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]]
            #
        set argList     [my UpdateItemAttributes arc $argList]
            #
        set myItem      [eval $w create arc     $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createCenterLine {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable styleLinewidth
            #
        set w           $canvasPath            
        set wScale      $canvasScale            
        set stageScale  $stageScale            
        set lineWidth   $styleLinewidth            
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]] 
            #
        dict set argList  -width $lineWidth   
            #
        set lLong        12
        set lShort        1
        dict set argList  -dash [list $lLong $lShort $lShort $lShort]
            #
        set argList     [my UpdateItemAttributes line $argList]
            #
        set myItem      [eval $w create line        $coordList  $argList ]
            #
        return          $myItem
            #
    }
    method createCircle {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        if {      [lsearch -inline [dict keys $argList] {-r}] ne {}} {
            set radius [dict get $argList -r]
            set argList [dict remove $argList -r]
        } elseif {[lsearch -inline [dict keys $argList]{-radius}] ne {}} {
            set radius [dict get $argList -radius]
            set argList [dict remove $argList -radius]
        }
            #
        lassign $coordList  x y
            # foreach {x y} $coordList break
        set coordList   [list [expr {$x-$radius}] [expr {$y+$radius}] [expr {$x+$radius}] [expr {$y-$radius}] ]
        set coordList   [cad4tcl::_convertBottomLeft [expr {$canvasScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]]
            #
        set argList     [my UpdateItemAttributes oval $argList]
            #
        set myItem      [eval $canvasPath create oval        $coordList  $argList]
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
        set coordList   [cad4tcl::_convertBottomLeft [expr {$canvasScale*$stageScale}] $coordList]
            #
        set argList     [my UpdateItemAttributes line $argList]
            #
        set myItem      [eval $w create line    $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createOval {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath            
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            # 
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]]  
            #
        set argList     [my UpdateItemAttributes oval $argList]
            #
        set myItem      [eval $w create oval    $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createOvalArc {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath            
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]] 
            #
        set argList     [my UpdateItemAttributes    arc $argList]
            #
        set myItem      [eval $w create arc         $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createOvalArc2 {coordList argList} {
            #
            # 20180101 ... a copy of createOvalArc ... plese reimplement
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath            
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]] 
            #
        set argList     [my UpdateItemAttributes    arc $argList]
            #
        set myItem      [eval $w create arc         $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createPolygon {coordList argList} {
            #
        variable canvasPath
        variable canvasScale
        variable stageScale
            #
        set w           $canvasPath            
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]]
            #
            # puts "   -> createPolygon   -> $argList"    
            # puts "              \$width    [dict get $argList -width]"
            #
        set argList     [my UpdateItemAttributes    polygon $argList]
            #
        set myItem      [eval $w create polygon     $coordList  $argList]
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
        set wScale      $canvasScale            
        set stageScale  $stageScale            
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr {$wScale*$stageScale}] [cad4tcl::_flattenNestedList $coordList]]
            #
        set argList     [my UpdateItemAttributes    rectangle $argList]
            #
        set myItem      [eval $w create rectangle   $coordList  $argList]
            #
        return          $myItem
            #
    }
    method createText {coordList argList} {
            #
        variable canvasObject
        variable canvasPath
        variable canvasScale
        variable stageScale
        variable stageUnitScale
        variable unitScale_p
            #
        set w           $canvasPath            
            #
        set moveVector  [$canvasObject getOrigin]
            #
        set font        Helvetica
        set fontSize    8
        set myText      {}
        set anchor      "se"
            #
        set orgList $argList    
            #
        foreach key {-font -size -text -anchor} {
            if [dict exists $argList $key] {
                switch -exact $key {
                    -font { 
                        set font        [dict get $argList $key]
                    }
                    -size { 
                        set fontSize    [dict get $argList $key]
                        set fontSize    [expr {round($fontSize)}]
                    }
                    -text { 
                        set myText      [dict get $argList $key]
                    }
                    -anchor { 
                        set anchor      [dict get $argList $key]
                    }
                    default {}
                }
                set argList [dict remove $argList $key]
            }
        }
            #
        set myFont      [font create]
        font configure  $myFont  -family Helvetica  -size $fontSize
        set fontDescent [font metrics $myFont -descent]
            #
        set lineRatio   [expr {(1.0 * $fontSize + $fontDescent) / $fontSize}]
        set formatSize  [expr {round(1.0 * ($lineRatio * $fontSize * $canvasScale * $stageScale * ($unitScale_p / $stageUnitScale)))}]
            #
        font configure  $myFont  -size $formatSize
            #
        dict set argList -font      $myFont
        dict set argList -anchor    $anchor
        dict set argList -text      $myText
            #
        set coordList   [cad4tcl::_convertBottomLeft [expr $canvasScale * $stageScale] [join $coordList]]
            #
        switch -exact -- $anchor {
            sw -
            s -
            se {
                set fontDescent [font metrics $myFont -descent]
                set dy [expr {$fontDescent * $stageUnitScale}]
                    # puts "   -> $formatSize + $fontDescent <- $dy"
                set coordList [vectormath::addVector $coordList [list 0 $dy]]
                    # coordList [::math::geometry::+  $coordList [list 0 $dy]]
                    # 
            }
            default {}
        }
            # 
        set myItem      [eval $canvasPath create text  $coordList  $argList]
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
        set argList     [my UpdateItemAttributes line $argList]
            #
        foreach key {-text -anchor -angle -stroke -fill -width -size -tags} {
            if [dict exist $argList $key] {
                switch -exact $key {
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
                    -width { 
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
        #
    method createDraftFrame {argList} {
            #
        variable canvasObject
        variable stageFormat
        variable stageWidth 
        variable stageHeight
        variable stageScale 
            #
        variable DraftFrame    
            # set stageFormat $Stage(Format)
            # set stageWidth  $Stage(Width)
            # set stageHeight $Stage(Height)
            # set stageScale  $Stage(Scale)
            #
            #
        set itemTag __DraftFrame__    
            #
        my delete $itemTag
            #
        set label   {}    
        set title   {}    
        set date    {}    
        set descr   {}    
        foreach key [dict keys $argList] {
            switch -exact $key {
                -label {
                    set label [dict get $argList -label]
                }    
                -title {
                    set title   [dict get $argList -title]
                }    
                -date {
                    set date    [dict get $argList -date]
                }    
                -description -
                -descr {
                    set descr   [dict get $argList -descr]
                } 
            }
        }
            #
        set DraftFrame(label)        $label
        set DraftFrame(title)        $title
        set DraftFrame(date)         $date 
        set DraftFrame(descr)        $descr
            #
        puts ""
        puts "   -------------------------------"
        puts "    [self] createDraftFrame"
        puts "       stageFormat:   $stageFormat"
        puts "           label:     $label"
        puts "           title:     $title"
        puts "            date:     $date"
            #
            #

            # --- drafting frame
        set df_Border          5
        set df_Width        [expr {$stageWidth  - 2 * $df_Border}]
        set df_Height       [expr {$stageHeight - 2 * $df_Border}]
        set tb_Width         170
        set tb_Height         20
        set tb_BottomLeft   [expr {$stageWidth  - $df_Border  - $tb_Width}]
            # ----- outer frame
        set x_00            $df_Border
        set x_01            [expr {$df_Border + $df_Width}]
        set y_00            $df_Border
        set y_01            [expr {$df_Border + $df_Height}]
            # ----- title frame
        set x_10            [expr {$x_00 + $tb_BottomLeft}]
        set x_11            [expr {$x_10 + 18}]
        set x_12            [expr {$x_01 - 45}]
        set x_13            [expr {$x_01}]
        set y_10            $y_00
        set y_11            [expr {$y_00 + 11}]
        set y_12            [expr {$y_00 + $tb_Height}]
        
        
        set border_Coords   [list   $x_00 $y_00     $x_00 $y_01     $x_01 $y_01     $x_01 $y_00     $x_00 $y_00 ]
        my create draftLine $border_Coords  [list -fill black  -width 0.5  -tags $itemTag]
            
            #
            # --- title block
            #
        set border_Coords   [list   $x_10 $y_10        $x_10 $y_12        $x_01 $y_12        $x_01 $y_10        $x_10 $y_10    ]
        my create draftLine $border_Coords  [list -fill black  -width 0.5  -tags $itemTag]        ;# title block - border

        set line_Coords     [list   $x_10 $y_11        $x_01 $y_11]
        my create draftLine $line_Coords    [list -fill black  -width 0.5  -tags $itemTag]        ;# title block - horizontal line separator

        set line_Coords     [list   $x_11 $y_10        $x_11 $y_12]
        my create draftLine $line_Coords    [list -fill black  -width 0.5  -tags $itemTag]        ;# title block - first left column separator

        set line_Coords     [list   $x_12 $y_11        $x_12 $y_12]
        my create draftLine $line_Coords    [list -fill black  -width 0.5  -tags $itemTag]        ;# title block - second left column separator
            
            #
            # --- create Text
            #
        set scaleFactor        [expr {1.0 / $stageScale}]
            #
        if {[expr {round($scaleFactor)}] == $scaleFactor} {
            set formatScaleFactor        [expr {round($scaleFactor)}]
        } else {
            set formatScaleFactor        [format "%.1f" $scaleFactor ]
        }
        set scaleText "1:$formatScaleFactor"


            # --- create Text:
        set textSize        5

            # --- create Text: DIN Format
        set myPos       [list [expr {$x_10 + 5.0}] [expr {$y_11 + 2.0}]]
        set myText      $stageFormat
        set textFormat  [my create draftText $myPos  [list -text $myText  -size $textSize  -tags $itemTag]]
            
            # --- create Text: Scale
        set myPos       [list [expr {$x_10 + 5.0}] [expr {$y_10 + 3.0}]]
        set myText      $scaleText
        set textScale   [my create draftText $myPos  [list -text $myText  -size $textSize  -tags $itemTag]]
            
            # --- create Text: Project-File
        set myPos       [list [expr {$x_13 - 2.0}] [expr {$y_10 + 3.0}]]
        set myText      $title
        set textProject [my create draftText $myPos  [list -text $myText  -size $textSize  -tags $itemTag  -anchor se]]

            # --- create Text: Date
        set myPos       [list [expr {$x_13 - 2.0}] [expr {$y_11 + 2.5}]]
        set myText      $date
        set textDate    [my create draftText $myPos  [list -text $myText  -size 3.5        -tags $itemTag  -anchor se]]
            #
            
            # --- create Text: label
        if {[file exists $label]} {
                # ... is a SVG-file
                #
            set svgFile     $label    
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
            set refx_00     [expr {$x_11 + 2}]
            set refx_01     [expr {$x_12 - 2}]
            set refy_00     [expr {$y_11 + 2}]
            set refy_01     [expr {$y_12 - 2}]
                #
            set myCoords    [list $refx_00 $refy_00 $refx_01 $refy_01]
                #
            set svgLabel    [my create draftLabel $myCoords [list  -svgNode $svgNode  -tags $itemTag  -anchor w]]
                #
        } else {
                # ... is text
            set myPos       [list [expr {$x_11 + 2.0}] [expr {$y_11 + 2.0}]]
            set myText      $label
            set textCompany [my create draftText $myPos  [list  -text $myText  -size $textSize  -tags $itemTag  -anchor sw]]
                #
        }
            
            # --- create Text: Description
        if {$descr ne {}} {    
            set myPos       [list [expr {$x_12 - 2.0}] [expr {$y_11 + 2.0}]]
            set myText      $descr
            set textCompany [my create draftText $myPos  [list  -text $myText  -size 3.5        -tags $itemTag  -anchor se]]
        }
            #
            #
        $canvasObject lower $itemTag all
            #
        return [list pageScale $textScale pageFormat $textFormat]    
            #
    }
    method createDraftLabel {coordList argList} {
            #
        variable canvasObject
            #
        set svgNode {}    
        set anchor  w    
        set angle   0    
        set tags    {}    
            #
        foreach key [dict keys $argList] {
            switch -exact $key {
                -svgNode {
                    set svgNode [dict get $argList -svgNode]
                }    
                -anchor {
                    set anchor  [dict get $argList -anchor]
                }    
                -angle {
                    set angle   [dict get $argList -angle]
                }    
                -tags {
                    set tags    [dict get $argList -tags]
                }
            }
        }
            #
        if {$svgNode eq {}} {
            puts "\n     <E> ... key: -svgNode ... not defined"
            return
        }
            #
            #
            # puts ""
            # puts "---- createDraftLabel ----"
            # puts "        -> \$svgNode $svgNode"    
            # puts "        -> \$anchor  $anchor "    
            # puts "        -> \$angle   $angle  "    
            # puts "        -> \$tags    $tags   "    
            #
        #set myItem      [$canvasObject readSVGNode $svgNode]
        set myItem      [my create svg {0 0} [list -svgNode $svgNode]]
        set bboxItem    [$canvasObject bbox2 $myItem]
        set centerItem  [cad4tcl::_getBBoxInfo $bboxItem center]
        set heightItem  [cad4tcl::_getBBoxInfo $bboxItem height]
            #
        set lineRef     [$canvasObject create draftLine $coordList [list -fill red -width 0.5]]
        set bboxRef     [$canvasObject coords $lineRef]
        set centerRef   [cad4tcl::_getBBoxInfo $bboxRef center]
        set heightRef   [cad4tcl::_getBBoxInfo $bboxRef height]
            #
        set scaleItem   [expr {abs(double($heightRef / $heightItem))}]
            #"
        lassign $centerItem  x y
            # foreach {x y} $centerItem break
        $canvasObject scale $myItem  $x $y $scaleItem $scaleItem
            #
        set bboxItem    [$canvasObject bbox2 $myItem]
        lassign $bboxItem  item_x0 item_y0 item_x1 item_y1
        lassign $bboxRef   ref_x0 ref_y0 ref_x1 ref_y1
            # foreach {item_x0 item_y0 item_x1 item_y1} $bboxItem break
            # foreach {ref_x0 ref_y0 ref_x1 ref_y1} $bboxRef break
            #
        switch -exact $anchor {
            e {
                set posRef  [list $ref_x1 $ref_y0]
                set posItem [list $item_x1 $item_y1]
            }
            c {
                set posRef  [list [expr {0.5 * ($ref_x0 + $ref_x1)}]   [expr {0.5 * ($ref_y0 + $ref_y1)}]]
                set posItem [list [expr {0.5 * ($item_x0 + $item_x1)}] [expr {0.5 * ($item_y0 + $item_y1)}]]
            }
            w -
            default {
                set posRef  [list $ref_x0 $ref_y0]
                set posItem [list $item_x0 $item_y1]
            }
        }
            #
        set vctMove   [vectormath::subVector $posRef $posItem]
            # vctMove [::math::geometry::- $posRef $posItem]
            # 
            #
        $canvasObject move $myItem [lindex $vctMove 0] [lindex $vctMove 1]
            #
        $canvasObject delete $lineRef
            #
        foreach tag $tags {
            $canvasObject addtag $tag withtag $myItem
        }
        $canvasObject addtag {__Content__} withtag $myItem
            #
        return $myItem
            #
    }        
    method createDraftLine {coordList argList} {
            #
        variable canvasObject
        variable canvasScale
        variable stageScale
            #
            #
            # puts "------> createDraftLine $coordList $argList"
            # puts "     -> \$stageScale  $stageScale"
            #
            #
        set scaleFactor [expr {double(1/$stageScale)}]
        set coordList   [vectormath::scaleCoordList {0 0} $coordList    $scaleFactor]        
            #
        set myItem      [my create line     $coordList  $argList]    
            #
        $canvasObject addtag {__Content__} withtag $myItem
            #
        return $myItem    
            #
    }
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
    method updateDraftFrame {} {
        variable stageScale
        variable DraftFrame
            #
        puts "   -> updateDraftFrame: $stageScale"    
            #
        my create draftFrame {} [list \
                                    -label $DraftFrame(label) \
                                    -title $DraftFrame(title) \
                                    -date  $DraftFrame(date)  \
                                    -descr $DraftFrame(descr) ]
    }
        #
        #
    method createDraftRaster {argList} {
            #
            # creates a raster on stage defined by $defRaster
            # this raster does not belong to the $stageScale
            # the distance of the lines are in the unit oft the stage without $stageScale
            #
            # {defRaster {5 gray50 25 gray20}}
            #
        variable canvasObject
        variable stageFormat
        variable stageWidth 
        variable stageHeight
            #
        variable DraftRaster
            #
        set minorDistance   $DraftRaster(minorDistance)
        set minorColor      $DraftRaster(minorColor)
        set majorDistance   $DraftRaster(majorDistance)
        set majorColor      $DraftRaster(majorColor)    
            #
        set itemTag         __DraftRaster__
            #
        my delete $itemTag
            #
        foreach {distance color} [list $minorDistance $minorColor $majorDistance $majorColor] {
                #
            set x 0
            set y 0
                #
            while {$x < [expr {$stageWidth - $distance}]} {
                set x           [expr {$x + $distance}]
                set coordList   [list $x 0 $x $stageHeight]
                my create draftLine $coordList  [list  -width 0.05  -fill $color  -tags $itemTag]
            }
                #
            set x 0
            set y 0
                #
            while {$y < [expr {$stageHeight - $distance}]} {
                set y           [expr {$y + $distance}]
                set coordList   [list 0 $y $stageWidth $y]
                my create draftLine $coordList  [list  -width 0.05 -fill $color  -tags $itemTag]
            }             
                #
        }
            #
        $canvasObject lower $itemTag all
            #
        return
            #
    }
        #
    method createSVG {coordList argList} {
            #
        variable SVG
            # - -svgNode $svgNode -angle $angle -tags $customTag
        set canvPos $coordList
            #
        set svgNode {}    
        set svgFile {}    
        set angle   0    
        set tags    {}    
        foreach key [dict keys $argList] {
            switch -exact $key {
                -svgNode {
                    set svgNode [dict get $argList -svgNode]
                }
                -svgFile {
                    set svgFile [dict get $argList -svgFile]
                }
                -angle {
                    set angle   [dict get $argList -angle]
                }    
                -tags {
                    set tags    [dict get $argList -tags]
                } 
            }
        }
            #
        if {$svgNode eq {}} {
            puts     "\n     <W> ... key: -svgNode ... not defined"
            if {$svgFile eq {}} {
                puts "\n     <E> ... key: -svgFile ... also not defined"
                return
            } else {
                set fp      [open $svgFile]
                    #
                fconfigure  $fp -encoding utf-8
                set xml     [read $fp]
                close       $fp
                    #
                set doc     [dom parse  $xml]
                set svgNode [$doc documentElement]
            }
        }
            #
            # puts "    -> \$svgNode  $svgNode"    
            # puts "    -> \$canvPos  $canvPos"    
            # puts "    -> \$angle    $angle"    
            # puts "    -> \$tags     $tags"    
            #
            # puts [$svgNode asXML]    
            #
        set svgTag  [$SVG readNode $svgNode $canvPos $angle $tags]
            #
            # puts "     -> create \$svgTag $svgTag"
        return $svgTag
            #
    }
        #
        #
    method deleteDimension {} {
            #
        variable DimensionFactory
            #
        set dimensionList   [$DimensionFactory delete_Member]
            #
        return $dimensionList
            #
    }
    
        #
        #
    method exportDXF {fileName} {
            #
        variable DXF
        return [$DXF exportFile $fileName]
            #
    }    
        #
    method exportSVG {fileName} {
            #
        variable SVG
        return [$SVG exportFile $fileName]
            #
    }    
        #
        #
    method getPointOnEllipse {r1 r2 phi} {
            #
            # ... https://www.hackerboard.de/science-and-fiction/39279-geometrie-punkt-auf-ellipse.html
            # (x / y) = (a * cos(a) / b * sin(a))
            # -> (x / y) = (r1 * cos(phi) / r2 * sin(phi))
            #
        set phi [vectormath::rad $phi]
        set x   [expr $r1 * cos($phi)]
        set y   [expr $r2 * sin($phi)]
            #
        return [list $x $y]
            #
    }
        #
    method getPointOnEllipse2 {r1 r2 phi} {
            #
            # ... get the point on ellipse cut by line with angle phi through center
            #
            # ... https://www.hackerboard.de/science-and-fiction/39279-geometrie-punkt-auf-ellipse.html
            #       (x / y) = (a * cos(a) / b * sin(a))
            #        x = r1 * cos(phi) 
            #        y = r2 * sin(phi))
            #
            # ... http://www.chemieonline.de/forum/showthread.php?t=108424
            #        tan(alpha) = (h / b) * tan(phi)
            #
        set phi     [vectormath::rad $phi]
            #
        set alpha   [expr {atan(($r1/$r2) * tan($phi))}]    
            #
        set x       [expr {$r1 * cos($alpha)}]
        set y       [expr {$r2 * sin($alpha)}]
            #
        return [list $x $y] 
            #
    }
        #
        #
    method _____getDomNode {} {
        variable canvasObject
        puts "   -> \$canvasObject $canvasObject"
        return [$canvasObject getDomNode]
    }
        #
}

