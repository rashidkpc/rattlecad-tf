 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classExtension_SVG__Super.tcl
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
    #
namespace eval cad4tcl {oo::class create Extension_SVG__Super}
    #
oo::define cad4tcl::Extension_SVG__Super {
        #
        #
    constructor {cvObj itemIF args} { 
            #
        puts "              -> class Extension_SVG__Super"
            #
            #
        variable cvObject       $cvObj    
            #
        variable ItemInterface  $itemIF    
            #
            #
        variable Style;     array set Style {    
                                        Linewidth           "0.35" 
                                        Linecolour          "black" 
                                        Fontstyle           "vector" 
                                        Fontsize            "3.5" 
                                        Fontdist            "1" 
                                        Font                "Arial" 
                                        Fontcolour          "black" 
                                        Precision           "2" 
                                        Defaultprecision    "2"
                                }
            #
        variable packageHomeDir         $::cad4tcl::packageHomeDir
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy Extension_SVG__Super"
            #
    }
        #
    method unknown {target_method args} {
                     puts "<E> ... cad4tcl::Extension_SVG__Super $target_method $args  ... unknown"
    }
        #
        #
    method readNode {svgRoot canvasPosition angle customTag} {
            #
        variable cvObject    
            #
            #
            # puts "\n"
            # puts "    [self] readNode"
            # puts "    -> \$cvObject   $cvObject"
            #
        set root $svgRoot
            #
        set center_Node [$svgRoot find id center_00]
        if { $center_Node != {} } {
            set svgPosition(x)  [$center_Node getAttribute cx]
            set svgPosition(y)  [$center_Node getAttribute cy]
        } else {
            # puts "     ... no id=\"center_00\""
            set svgPosition(x)  0
            set svgPosition(y)  0
        }
        set svgCenter [list $svgPosition(x) $svgPosition(y)]
            #
                
            #
            # -- define a unique id for svgContent
            #
        set w [$cvObject getCanvas]
            #        
        if {$customTag eq {}} { 
            set svgTag      [format "svg_%s" [llength [$w find withtag all]] ]
            set $svgTag     {}
        } else {
            set svgTag     $customTag
        }
            #
            # -- get graphic content nodes
            #
        set svgNode [$svgRoot firstChild]
        while {$svgNode ne {}} {
            # puts "  -> [$svgNode asXML]"
            set newNode [my createNode $svgNode $canvasPosition $svgCenter $angle $svgTag]
            $w addtag $svgTag withtag $newNode
            set svgNode [$svgNode nextSibling]
        }
            #
        return $svgTag
            #
    }
        #
    method createNode {svgNode canvasPosition svgCenter angle svgTag {svgTag_20141118 {}}} {
            #
        variable cvObject
        variable ItemInterface        
            #
            #
            # -- canvasPosition
            #
        lassign $canvasPosition  pos_x pos_y
            # foreach {pos_x pos_y} $canvasPosition break
            #
            # -- get center SVG
            #    
        set svgPosition(x)  [lindex $svgCenter 0]
        set svgPosition(y)  [lindex $svgCenter 1]
        set svgPosition(xy)  [list $svgPosition(x) $svgPosition(y)]
            
            #
            # -- define item container
            #
        set w       [$cvObject getCanvas]        
                
                # -- handle exceptions
        if {[$svgNode nodeType] != {ELEMENT_NODE}} {
            return
        }
        if {[$svgNode hasAttribute id]} {
            if {[$svgNode getAttribute id] == {center_00}} {
                return
            }
        }
            
            #
            # -- get svg Object attributs
            #
            # puts "   write_svgNode -> $svgNode [$svgNode nodeName]"
            
            # -- set defaults
        set objectPoints {}

            # -- get transform attribute
        set transform {_no_transformation_}
        catch {set transform    [$svgNode getAttribute transform]}
        
        switch -exact [$svgNode nodeName] {
            g {      
                set childNode [$svgNode firstChild]
                while {$childNode ne {}} {
                    # puts "    -> $childNode  [$childNode nodeName]"
                    my createNode $childNode $canvasPosition $svgCenter $angle $svgTag
                    set childNode [$childNode nextSibling]
                }
            }
            g_old {      
                foreach childNode [$svgNode childNodes] {
                    # puts "    -> $childNode  [$childNode nodeName]"
                    my createNode $childNode $canvasPosition $svgCenter $angle $svgTag
                }
            }
            
            rect {
                set x  [expr { [$svgNode getAttribute x] - $svgPosition(x)}]
                set y  [expr {-[$svgNode getAttribute y] + $svgPosition(y)}]
                set width   [$svgNode getAttribute  width ]
                set height  [$svgNode getAttribute  height]
                set x2 [expr {$x + $width }]
                set y2 [expr {$y - $height}]
                set objectPoints [list $x $y $x $y2 $x2 $y2 $x2 $y]
                if {$angle != 0} { 
                    set objectPoints [vectormath::rotateCoordList {0 0} $objectPoints $angle] 
                }
            }
            polygon {
                set valueList [ $svgNode getAttribute points ]
                foreach {coords} $valueList {
                    lassign [split $coords ,] x y
                        # foreach {x y}  [split $coords ,] break
                    set objectPoints [lappend objectPoints $x $y ]
                }
                if {$transform != {_no_transformation_}} {
                        set matrix [split [string map {matrix( {} ) {}} $transform] ,]
                        set objectPoints    [my transformObject $objectPoints $matrix ]
                            # puts "      polygon  -> SVGObject $objectPoints " 
                            # puts "      polygon  -> matrix    $matrix" 
                }
                
                set tmpList {}
                foreach {x y} $objectPoints {
                    set tmpList [lappend tmpList [expr {$x - $svgPosition(x)}] [expr {-$y + $svgPosition(y)}]]  
                }
                set objectPoints $tmpList
                
                if {$angle != 0} { 
                    set objectPoints [vectormath::rotateCoordList {0 0} $objectPoints $angle] 
                }
            }
            polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ...
                set valueList [ $svgNode getAttribute points ]
                foreach {coords} $valueList {
                    lassign [split $coords ,] x y
                        # foreach {x y}  [split $coords ,] break
                    set objectPoints [lappend objectPoints $x $y ]
                }
                if {$transform != {_no_transformation_}} {
                        set matrix [split [string map {matrix( {} ) {}} $transform] ,]
                        set objectPoints    [my transformObject $objectPoints $matrix ]
                            # puts "      polygon  -> SVGObject $objectPoints " 
                            # puts "      polygon  -> matrix    $matrix" 
                }
                
                set tmpList {}
                foreach {x y} $objectPoints {
                    set tmpList [lappend tmpList [expr  {$x - $svgPosition(x)}] [expr {-$y + $svgPosition(y)}]]  
                }
                set objectPoints $tmpList
                
                if {$angle != 0} { 
                    set objectPoints [vectormath::rotateCoordList {0 0} $objectPoints $angle] 
                }
            }
            line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
                set objectPoints [list  [expr {[$svgNode getAttribute x1] - $svgPosition(x)}] [expr {-([$svgNode getAttribute y1] - $svgPosition(y))}] \
                                        [expr {[$svgNode getAttribute x2] - $svgPosition(x)}] [expr {-([$svgNode getAttribute y2] - $svgPosition(y))}] ]
                if {$angle != 0} { 
                    set objectPoints [vectormath::rotateCoordList {0 0} $objectPoints $angle] 
                }
            }
            circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                    # --- dont display the center_object with id="center_00"
                if {![$svgNode hasAttribute cx]} return
                set cx [expr {  [$svgNode getAttribute cx] - $svgPosition(x) }]
                set cy [expr {-([$svgNode getAttribute cy] - $svgPosition(y))}]
                if {$angle != 0} { 
                    set c_xy [vectormath::rotateCoordList {0 0} [list $cx $cy] $angle] 
                    lassign $c_xy   cx cy
                        # foreach {cx cy} $c_xy break
                }
                set objectRadius [$svgNode getAttribute  r]
                set objectPoints [list  $cx $cy]
                    # set x1 [expr $cx - $r]
                    # set y1 [expr $cy - $r]
                    # set x2 [expr $cx + $r]
                    # set y2 [expr $cy + $r]
                    # set objectPoints [list $x1 $y1 $x2 $y2]
            }
            path { # the complex all inclusive object in svg
                
                return
                # continue
                
                set valueList  [ $svgNode getAttribute d ]
                set partialPath  [split [string trim $valueList] "zZ"]
                    # [string map {Z {_Z}} {z {_z}} $valueList]
                foreach path $partialPath {    
                    set objectPoints [path2Line $valueList [list $svgPosition(x) $svgPosition(y)]]                    
                        # puts "\n path-valueList:  $objectPoints"                      
                    if {$angle != 0} { 
                        set objectPoints [vectormath::rotateCoordList {0 0} $objectPoints $angle] 
                    }
                    set pos_objectPoints {}
                    foreach {x y} $objectPoints {
                        set pos_objectPoints [lappend pos_objectPoints [expr {$x + $pos_x}]]
                        set pos_objectPoints [lappend pos_objectPoints [expr {$y + $pos_y}]]
                    }                  
                    if {$svgTag ne {}} {
                        $w addtag $svgTag withtag [$ItemInterface create    line    $pos_objectPoints [list -fill black  -tags $svgTag]]
                    } else {
                        $w addtag $svgTag withtag [$ItemInterface create    line    $pos_objectPoints [list -fill black]]
                    }
                }
                set nodeName {}
            }              
                          
            default { }
        }
        
            #
            # -- move the content to its canvasPosition
            #
        set pos_objectPoints {}
        foreach {x y} $objectPoints {
            set pos_objectPoints [lappend pos_objectPoints [expr {$x + $pos_x}]]
            set pos_objectPoints [lappend pos_objectPoints [expr {$y + $pos_y}]]
        }
        
            #
            # -- create object
            #
        set cvItem  {}    
            #
        if {$svgTag ne {}} {
            switch -exact [$svgNode nodeName] {
                rect {   
                    set cvItem  [$ItemInterface create  polygon \
                                    $pos_objectPoints \
                                    [list -fill white  -tags $svgTag -outline black ]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                polygon {   
                    if {[llength $pos_objectPoints] < 4} { return }
                    set cvItem  [$ItemInterface create  polygon \
                                        $pos_objectPoints \
                                        [list -fill white  -tags $svgTag -outline black ]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                polyline -
                line {
                    if {[llength $pos_objectPoints] < 4} { return }
                    set cvItem  [$ItemInterface create  line \
                                        $pos_objectPoints \
                                        [list -fill black  -tags $svgTag]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                circle {   
                    set cvItem  [$ItemInterface create  circle \
                                        $pos_objectPoints \
                                        [list -fill white  -tags $svgTag -outline black -r $objectRadius]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                default {}
            }
        } else {
            switch -exact [$svgNode nodeName] {
                rect        {   
                    set cvItem  [$ItemInterface create  polygon \
                                        $pos_objectPoints \
                                        [list -fill white -outline black]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                polygon     {   
                    if {[llength $pos_objectPoints] < 4} { return }
                    set cvItem  [$ItemInterface create  polygon \
                                        $pos_objectPoints \
                                        [list -fill white -outline black]] 
                                        $w addtag $svgTag withtag   $cvItem
                }
                polyline -
                line        {   
                    if {[llength $pos_objectPoints] < 4} { return }
                    set cvItem  [$ItemInterface create  line \
                                        $pos_objectPoints \
                                        [list -fill black ]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                circle      {   
                    set cvItem  [$ItemInterface create  oval \
                                        $pos_objectPoints \
                                        [list -fill white  -outline black -r $objectRadius]] 
                    $w addtag $svgTag withtag   $cvItem
                }
                default     {}
            }
        }
            #
            # -- add each to unique $svgTag
            #    
        return $svgTag

    }
        #
    method transformObject {valueList matrix} {
            #
        set valueList_Return {}
            # puts "    transformObject: $matrix"
        lassign $matrix  a b c d tx ty 
            # foreach {a b c d tx ty} $matrix break
            # puts "          $a $b $tx  /  $c $d $ty " 
        foreach {x y} $valueList {
                # puts "       -> $x $y"
            set xt [ expr {$a*$x - $b*$y + $tx}]
            set yt [ expr {$c*$x - $d*$y - $ty}]
            set valueList_Return [lappend valueList_Return $xt [expr {-1*$yt}] ]
                # puts "             function   x:  $a*$x - $b*$y + $tx    $xt"
                # puts "             function   y:  $c*$x - $d*$y - $ty    $yt"
        }
            #
        return $valueList_Return
            #
    }
        #
        #
    method exportFile {{svgFile {}}} {
            #
            # based on http://wiki.tcl.tk/4534
            #
        variable cvObject
            #
        set cv           [$cvObject getCanvas]
        set wType        [$cvObject configure   Canvas  Type]      
        set wScale       [$cvObject configure   Canvas  Scale]      
        set stageScale   [$cvObject configure   Stage   Scale]      
        set stageUnit    [$cvObject configure   Stage   Unit]      
        set font         [$cvObject configure   Style   Font]
        set unitScale    [$cvObject configure   Stage   UnitScale] 
            #
        set stageFormat  [$cvObject configure   Stage   Format]   
        set stageWidth   [$cvObject configure   Stage   Width]   
        set stageHeight  [$cvObject configure   Stage   Height]   
            #
            # set cv           [cad4tcl::getNodeAttribute   $canvasDOMNode  Canvas   path ]
            # set wScale       [cad4tcl::getNodeAttribute   $canvasDOMNode  Canvas   scale ]      
            # set stageScale   [cad4tcl::getNodeAttribute   $canvasDOMNode  Stage  scale ]      
            # set stageUnit    [cad4tcl::getNodeAttribute   $canvasDOMNode  Stage  unit  ]      
            # set font         [cad4tcl::getNodeAttribute   $canvasDOMNode  Style    font  ]
            # set unitScale    [cad4tcl::_getUnitRefScale   $stageUnit]
            # 
            # set stageFormat  [cad4tcl::getNodeAttribute   $canvasDOMNode  Stage  format ]   
            # set stageWidth   [cad4tcl::getNodeAttribute   $canvasDOMNode  Stage  width  ]   
            # set stageHeight  [cad4tcl::getNodeAttribute   $canvasDOMNode  Stage  height ]   
        
            # set scalePixel   [ cad4tcl::getNodeAttributeRoot /root/_package_/UnitScale p ]  -> 20170909
            # set scaleInch    [ cad4tcl::getNodeAttributeRoot /root/_package_/UnitScale i ]  -> 20170909
            # set scaleMetric  [ cad4tcl::getNodeAttributeRoot /root/_package_/UnitScale m ]  -> 20170909
        

            # -------------------------
            #  get SVG-Units and scale 
        case $stageUnit {
            m  {   set svgUnit  "mm"; }
            c  {   set svgUnit  "cm"}
            i  {   set svgUnit  "in"}
            p  {   set svgUnit  "px"}
        }

            # -------------------------
            #  get canvs scaling and reposition
        set cv_ViewBox      [$cv coords __Stage__]
        set cv_View_x0      [lindex $cv_ViewBox 0]
        set cv_View_y0      [lindex $cv_ViewBox 1]
        set cv_View_x1      [lindex $cv_ViewBox 2]
        set cv_View_y1      [lindex $cv_ViewBox 3]
        set cv_ViewWidth    [expr {$cv_View_x1 - $cv_View_x0}]
                # set cv_ViewHeight  [ expr [ lindex $cv_ViewBox 0 ] - $cv_View_y0 ]
        set cv_ViewHeight   [expr {$cv_View_y1 - $cv_View_y0}]
        
            #           [ expr  $unitScale * $wScale ]  <- 20170909
        set svgScale        [expr  {$wScale / $unitScale}]
            
            # -------------------------
            #  debug info
        puts "        --------------------------------------------"
        puts "           \$stageFormat $stageFormat  "
        puts "                   \$stageUnit      $stageUnit"
        puts "                   \$svgUnit        $svgUnit  "
        puts "                   \$unitScale      [format "%.5f"  $unitScale]"
        puts "                   \$stageWidth     $stageWidth  "
        puts "                   \$stageHeight    $stageHeight "
        puts "        --------------------------------------------"
        puts "               \$wScale         [ format "%.5f  %.5f"  $wScale        [expr {1.0/$wScale}]]"
        puts "               \$stageScale     [ format "%.5f  %.5f"  $stageScale    [expr {1.0/$stageScale}]]"
        puts "        --------------------------------------------"
        puts "               \$cv_ViewBox      $cv_ViewBox"
        puts "                   \$cv_View_x0      $cv_View_x0"
        puts "                   \$cv_View_y0      $cv_View_y0"
        puts "                   \$cv_View_x1      $cv_View_x1"
        puts "                   \$cv_View_y1      $cv_View_y1"
        puts "                   \$cv_ViewWidth    $cv_ViewWidth"
        puts "                   \$cv_ViewHeight   $cv_ViewHeight"
        puts "        --------------------------------------------"
        puts "               \$svgScale       ( $wScale / $unitScale )"
        puts "               \$svgScale       [ format "%.5f "  $svgScale ]"
        puts "        --------------------------------------------"
        puts "               \$svgFile        $svgFile"
        puts "        --------------------------------------------"
        
            
            # -------------------------
            #  create bounding boxes
        $cv create rectangle   [$cv coords __Stage__]   \
                    -tags    {__SheetFormat__ __Content__}  \
                    -outline black    \
                    -width   0.01
            
            # -------------------------
            #  get svgViewBox
        set svgViewBox    [list  $cv_View_x0 $cv_View_y0 [expr {$svgScale * $stageWidth}]  [expr {$svgScale * $stageHeight}]]
            
            
            # -------------------------
            #  create bounding boxes
        set      svgContent  "<svg xmlns=\"http://www.w3.org/2000/svg\" \n"
        append   svgContent  "         width=\"$stageWidth$svgUnit\" \n"
        append   svgContent  "         height=\"$stageHeight$svgUnit\"\n"
        append   svgContent  "         viewBox=\"$svgViewBox\"\n"
        append   svgContent  "     >\n"
        
        append   svgContent  "<g  id=\"__root__\">\n\n"

            
        # ========================================================================
            # -------------------------
            #  for each item
            #
            #          
        foreach cvItem   [$cv find withtag {__Content__}] {
        
            set cvType      [$cv type $cvItem]
            set svgCoords   {}
            set svgAtts     {}
            
                # set defaults
            if 0 {
                set lineDash    {}
                
                    # --- get attributes
                catch {set lineColour [my formatXColor [$cv itemcget $cvItem -outline]]}    {set lineColour   gray50}
                catch {set lineWidth  [$cv itemcget $cvItem -width]}                        {set lineWidth     0.1}
                catch {set lineDash   [$cv itemcget $cvItem -dash]}                         {set lineDash     {none}}
                catch {set itemFill   [my formatXColor [$cv itemcget $cvItem -fill]]}       {set itemFill     gray50}
                
                    # --- preformat attribues
                if {$lineDash eq ""} {
                    set lineDash    {none}
                } else {
                    set lineDash    [string map {{ } {,}} $lineDash]
                }
            }
                
                # --- get coords
            lassign [string map {".0 " " "} "[$cv coords $cvItem] "]  x0 y0 x1 y1
                # foreach {x0 y0 x1 y1} \
                #     [string map {".0 " " "} "[$cv coords $cvItem] "] break
            
                # --- get coords
            set cvPoints {}
            foreach {x y} [$cv coords $cvItem] {
                lappend cvPoints [list $x $y]
            }
            
                # --- continue if object has no coords / geometry
            if {[llength $cvPoints] == 0} {
                puts "\n                ... <W> $cvItem -> $cvType  ... has no coords"
                continue
            }
        
            # -------------------------
            #  handle types      
            switch -exact $cvType {
                arc {
                    lassign [my CreateSVG_arc $cv $cvItem]          svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_arc $cv $cvItem] break
                }
                line {
                    lassign [my CreateSVG_line $cv $cvItem]         svgXML svgType svgAtts svgCoords 
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_line $cv $cvItem] break
                }
                polygon {
                    lassign [my CreateSVG_polygon $cv $cvItem]      svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_polygon $cv $cvItem] break
                }
                oval {
                    lassign [my CreateSVG_oval $cv $cvItem]         svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_oval $cv $cvItem] break
                }
                rectangle {
                     lassign [my CreateSVG_rectangle $cv $cvItem]   svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_rectangle $cv $cvItem] break
                }
                text {                                                       
                    lassign [my CreateSVG_text $cv $cvItem]         svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_text $cv $cvItem] break
                }
                default {
                    # error "type $type not(yet) dumpable to SVG"
                    puts "type $cvType not (yet) dumpable to SVG"
                    set svgXML {}
                }
            }
                
                # -------------------------
                #  report
                # puts "     -> $cvType"
                # puts "               $svgXML"
                # puts "               $svgType"
                # puts "               $svgAtts"
                # puts "               $svgCoords"
            
                # -------------------------
                #  canvas item attributes
            append svgContent   "    <!-- $cvType:-->\n"
            append svgContent   "        <!--    cvPoints:    $cvPoints   -->\n"
            append svgContent   "        <!--    svgCoords:   $svgCoords   -->\n"
                # 
            append svgContent   "$svgXML"
                #
        }
        
            # -- close svg-Tag
            #
        append svgContent "</g>\n"
        append svgContent "</svg>"


            # -- cleanup canvas
            #
        $cv delete -tags {__SheetFormat__}  

            #
            # -- fill export svgFile
            #
        if {$svgFile ne {}} {
            set fp      [open $svgFile w]          
            fconfigure  $fp -encoding utf-8
            puts        $fp $svgContent
            close       $fp
        }
        
            #
            # -- fill export svgFile
            #
        if {[file exists $svgFile]} {
            return $svgFile
        } else {
            return {_noFile_}
        }
        
    } 
        #
    method CreateSVG_arc {cv cvItem} {
            #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "] x y x1 y1
            # foreach {x y x1 y1} [string map {".0 " " "} "[$cv coords $cvItem] "] break
            #
        set cx              [expr {($x+$x1)/2}]
        set cy              [expr {($y+$y1)/2}]
        set rx              [expr {($x1-$x)/2}]
        set ry              [expr {($y1-$y)/2}]
            #
        set itemStyle       [$cv itemcget $cvItem -style]
            #
        set angleStart      [$cv itemcget $cvItem -start]
        set angleExtent     [$cv itemcget $cvItem -extent]
            #
        set p_start_x       [expr {$cx + $rx * cos([vectormath::rad $angleStart])}]
        set p_start_y       [expr {$cy - $ry * sin([vectormath::rad $angleStart])}]
            #
            # set angleEnd        [expr {$angleStart + $angleExtent}]
        set p_end_x         [expr {$cx + $rx * cos([vectormath::rad [expr {$angleStart + $angleExtent}]])}]
        set p_end_y         [expr {$cy - $ry * sin([vectormath::rad [expr {$angleStart + $angleExtent}]])}]
            #
        set p_start         [list $p_start_x $p_start_y]  
        set p_end           [list $p_end_x   $p_end_y]   
            #
            #
        set svgType         path
            #
            #
        set attrDictNew     [list   cx      "$cx" \
                                    cy      "$cy" \
                                    rx      "$rx" \
                                    ry      "$ry"]
            #
        set attrDictMap     [list   fill            {-fill      "none"}     \
                                    stroke          {-outline   "#000000"}  \
                                    dash            {-dash      ""}         \
                                    stroke-width    {-width     "0.1"}]
            #            #
        if {$itemStyle eq {arc}} {
                # arc has no fill attribute
            $cv itemconfigure $cvItem -fill {}
                # arc has no fill attribute
        }    
            #
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
            #
            # Bogen läuft gegen den Uhrzeigersinn
            # rx, ry
            # x-axis-rotation   drehung der Ellipse
            # large-arc-flag	den großen(1) Bogen
            # sweep-flag
            # x, y						
            #    * the arc starts at the current point
            #    * the arc ends at point (x, y)
            #    * the ellipse has the two radii (rx, ry)
            #    * the x-axis of the ellipse is rotated by x-axis-rotation relative to the x-axis of the current coordinate system
            #
            #
        if {$angleExtent > 180} {
            set largeArc 1
        } else {
            set largeArc 0
        }
        switch -exact -- $itemStyle {
            arc {
                set svgPath "M $p_start_x $p_start_y  A $rx,$ry 0 $largeArc 0 $p_end_x $p_end_y"
            }
            chord {
                set svgPath "M $p_start_x $p_start_y  A $rx,$ry 0 $largeArc 0 $p_end_x $p_end_y z"
            }
            pieslice {  # pieslice segment of a circle results in a closed figure through the center point
                set svgPath "M $p_start_x $p_start_y  A $rx,$ry 0 $largeArc 0 $p_end_x $p_end_y L $cx,$cy z"
            }
            default {
            }
        }
            #
            # puts "   -> arcStyle: [$cv itemcget $cvItem -style]"
            # puts "   -> SVG-Export \"M $p_start_x $p_start_y  A $rx,$ry 0 $largeArc 0 $p_end_x $p_end_y L $cx,$cy z\""
            #
            # puts "   -> -style ... [$cv itemcget $cvItem -style]"
            # puts "   -> -style ... [$cv itemconfigure $cvItem]"
            #
            #
        set svgXML          "  <$svgType \n       $svgAtts  d=\"$svgPath\"/>\n"
            #
        return              [list  $svgXML  $svgType  $svgAtts {}]
            #
    }
        #
    method CreateSVG_line {cv cvItem} {
            #
            # puts "\n  --- Extension_SVG__Super - CreateSVG_polyline --- "    
            #
        set cvPoints {}
        foreach {x y}       [$cv coords $cvItem] {
            lappend cvPoints [list $x $y]
        }
            #
            #
        set svgType         polyline
            #
        set svgCoords       "points=\"[join $cvPoints ", "]\""
            #
            #
        set attrDictNew     [list   fill    "none"]
            #
        set attrDictMap     [list   stroke              {-fill      "none"}     \
                                    stroke-width        {-width     "0.1"}  \
                                    stroke-dasharray    {-dash      "12,1,1,1"}]
            #        
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
        set svgXML          "  <$svgType \n      $svgAtts \n      $svgCoords/>\n"
            #
            #
        if {[llength $cvPoints] == 0} {
                #
            puts "\n                ... <W> $cvItem -> [$cv type $cvItem]  ... has no coords"
                #
            return [list {}      $svgType $svgAtts $svgCoords]
                #
        } else {
                #
            return [list $svgXML $svgType $svgAtts $svgCoords]
                #
        }
    }       
        #
    method CreateSVG_polygon {cv cvItem} {
            #
        set cvPoints {}
        foreach {x y}       [$cv coords $cvItem] {
            lappend cvPoints [list $x $y]
        }
            #
            #
        set svgType         polygon
            #
        set svgCoords       "points=\"[join $cvPoints ", "]\""
            #
            #
        set attrDictNew     {}
            #
        set attrDictMap     [list   fill                {-fill      "none"}     \
                                    stroke              {-outline   "none"}     \
                                    stroke-width        {-width     "0.1"}  \
                                    stroke-dasharray    {-dash      "12,1,1,1"}]
            #        
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
        set svgXML          "  <$svgType \n      $svgAtts \n      $svgCoords/>\n"
            #
            #
        if {[llength $cvPoints] == 0} {
                #
            puts "\n                ... <W> $cvItem -> [$cv type $cvItem]  ... has no coords"
                #
            return [list {}      $svgType $svgAtts $svgCoords]
                #
        } else {
                #
            return [list $svgXML $svgType $svgAtts $svgCoords]
                #
        }
    }
        #
    method CreateSVG_oval {cv cvItem} {
            #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "] x y x1 y1
            # foreach {x y x1 y1} [string map {".0 " " "} "[$cv coords $cvItem] "] break
            #
        set cx              [expr {($x+$x1)/2}]
        set cy              [expr {($y+$y1)/2}]
        set rx              [expr {($x1-$x)/2}]
        set ry              [expr {($y1-$y)/2}]
            #
            #
        set svgType         ellipse
            #
            #
        set attrDictNew     [list   cx      "$cx" \
                                    cy      "$cy" \
                                    rx      "$rx" \
                                    ry      "$ry"]
            #
        set attrDictMap     [list   fill                {-fill      "none"}     \
                                    stroke              {-outline   "none"}     \
                                    stroke-width        {-width     "0.1"}  \
                                    stroke-dasharray    {-dash      "12,1,1,1"}]
            #        
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
        set svgXML          "  <$svgType \n      $svgAtts/>\n"
            #
            #
        return [list $svgXML $svgType $svgAtts {}]
            #
    }
        #
    method CreateSVG_rectangle {cv cvItem} {        
            #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "] x y x1 y1
            # foreach {x y x1 y1} [string map {".0 " " "} "[$cv coords $cvItem] "] break
            #
            #
        set svgType         rect
            #
            #
        set attrDictNew     [list   x       "$x" \
                                    y       "$y" \
                                    width  [expr {$x1-$x}] \
                                    height [expr {$y1-$y}]]
            #
        set attrDictMap     [list   fill                {-fill      "none"}     \
                                    stroke              {-outline   "none"}     \
                                    stroke-width        {-width     "0.1"}  \
                                    stroke-dasharray    {-dash      "12,1,1,1"}]
            #        
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
            #
        set svgXML          "  <$svgType \n      $svgAtts/>\n"
            #
        return [list $svgXML $svgType $svgAtts {}]
            #
    }
        #
    method CreateSVG_text {cv cvItem} {
            #
        variable cvObject
            #
        set canvasScale     [$cvObject configure Canvas Scale]   
            #
        lassign [string map {".0 " " "} "[$cv bbox $cvItem] "]  x y x1 y1
            # foreach {x y x1 y1} [string map {".0 " " "} "[$cv bbox $cvItem] "] break
            #
            #
        set svgType         text
            #
            #
        set svgFont         [$cv itemcget $cvItem -font]
        set svgFontFamily   [font configure $svgFont -family]
        set svgFontSize     [font configure $svgFont -size]
            #
        set svgFontSize     [expr {$svgFontSize / $canvasScale}]
            #
        set attrDictNew     [list   x           "$x" \
                                    y           "$y1" \
                                    font-family "$svgFontFamily" \
                                    font-size   "$svgFontSize"]
            #
        set attrDictMap     [list   fill    {-fill      "#000000"} \
                                    text    {-text      ""}]
            # 
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
            #
        set svgText         [$cv itemcget $cvItem -text]
            #
            #
        set svgXML          "  <$svgType \n      $svgAtts>$svgText</$svgType>\n"
            #
            # puts "CreateSVG_text [$cv coords $cvItem]"
            # puts "          \$x $x"
            # puts "          \$y $y"
            # puts "          \$x1 $x1"
            # puts "          \$y1 $y1"
            #
            # puts "          \$svgFont $svgFont"
            # puts "          \$svgFontFamily     $svgFontFamily"
            # puts "          \$svgFontSize       $svgFontSize"
            #
            # puts "[$cv itemconfigure $cvItem]"
            #
        return              [list $svgXML $svgType $svgAtts {}]
            #
    }
        #
        #
    method FormatSVGAttribute {cvItem attrDictNew attrDictMap} {
            #
        variable cvObject
            #
        set cv           [$cvObject getCanvas]
        set cvType       [$cvObject configure   Canvas  Type]      
            #
        set attrString {}
            #
        dict for {svgKey value} $attrDictNew {
            append attrString "$svgKey=\"$value\" "
        }
            #
            #appUtil::pdict $attrDictMap
            #
        dict for {svgKey value} $attrDictMap {
                #
            lassign $value  cvKey itemDefault
                # foreach {cvKey itemDefault} $value break
                #
            set itemValue [$cv itemcget $cvItem $cvKey]
                #
                #puts "      1 -> $cvItem -> $svgKey  -> $cvKey => $itemDefault <- $itemValue"
                #
            switch -exact -- $svgKey {
                fill -
                stroke {
                    if {$itemValue eq {}} {
                        set itemValue {none}
                    } else {
                        set itemValue [my formatXColor $itemValue]
                    }
                }
                default {}
            }
                #
            if {$itemValue eq {}} {
                continue
            }
                #
                #puts "      3 -> $cvItem -> $svgKey  -> $cvKey => $itemDefault <- $itemValue"
                #
            append attrString "$svgKey=\"$itemValue\" "
                #
        }
            #
        return $attrString
            #
    }
        #
        #
        #
    method ___formatItemAttribute {name value {default {}}} {
            #
        variable cvObject
            #
        set cv           [$cvObject getCanvas]
        set cvType       [$cvObject configure   Canvas  Type]      
            #
            # puts "     -> $cvType"
            #
        switch -exact $cvType {
            PathCanvas {
                puts "     -> PathCanvas"
            }
            default {
                if {$value != $default} {
                    return " $name=\"$value\""
                }
                return " $name=\"$default\""
            }
        }
    }
        #
    method formatXColor {rgb} {
        if {$rgb == ""} {return none}
        lassign [winfo rgb . $rgb]  r g b
            # foreach {r g b} [winfo rgb . $rgb] break
        return [format "#%02x%02x%02x" [expr {$r/256}] [expr {$g/256}] [expr {$b/256}] ]
    }
        #
}

