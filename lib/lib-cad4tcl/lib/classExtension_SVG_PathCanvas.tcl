 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classExtension_SVG_PathCanvas.tcl
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
namespace eval cad4tcl {oo::class create Extension_SVG_PathCanvas}
    #
oo::define cad4tcl::Extension_SVG_PathCanvas {
        #
    superclass cad4tcl::Extension_SVG__Super    
        #
    constructor {cvObj itemIF args} { 
            #
        puts "              -> class Extension_SVG_PathCanvas"
            #
        next $cvObj $itemIF $args
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy Extension_SVG_PathCanvas"
            #
    }
        #
    method unknown {target_method args} {
                     puts "<E> ... cad4tcl::Extension_SVG_PathCanvas $target_method $args  ... unknown"
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
        set cv_ViewBox    [$cv coords __Stage__]
        set cv_View_x0    [lindex $cv_ViewBox 0]
        set cv_View_y0    [lindex $cv_ViewBox 1]
        set cv_View_x1    [lindex $cv_ViewBox 2]
        set cv_View_y1    [lindex $cv_ViewBox 3]
        set cv_ViewWidth  [expr {$cv_View_x1 - $cv_View_x0}]
        set cv_ViewHeight [expr {$cv_View_y1 - $cv_View_y0}]        
            #           [ expr  $unitScale * $wScale ]  <- 20170909
        set svgScale      [expr {$wScale / $unitScale}]
            
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
        $cv create prect            [$cv coords __Stage__]   \
                    -tags           {__SheetFormat__ __Content__}  \
                    -stroke         black    \
                    -strokewidth    0.01
            
        # $cv create rectangle [$cv coords __Stage__]   \
                    -tags    {__SheetFormat__ __Content__}  \
                    -outline black    \
                    -width   0.01
            
            # -------------------------
            #  get svgViewBox
        set svgViewBox    [ list  $cv_View_x0 $cv_View_y0 [expr {$svgScale * $stageWidth}]  [expr {$svgScale * $stageHeight}]]
            
            
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
        
            set cvType     [$cv type $cvItem]
            set svgCoords   {}
            set svgAtts     {}
            
            puts "    -> $cvType"
           
                # set defaults
            if 0 {
                set lineDash    {}
                
                    # --- get attributes
                switch -exact -- $cvType {
                    line {
                        catch {set lineColour [my formatXColor  [$cv itemcget $cvItem -fill]]}              {set lineColour   gray50}
                        catch {set lineWidth                    [$cv itemcget $cvItem -width]}              {set lineWidth     0.1}
                        catch {set lineDash                     [$cv itemcget $cvItem -dash]}               {set lineDash     {none}}
                        catch {set itemFill                     {}}                                         {set itemFill     {}}
                    }
                    arc -
                    oval -
                    polygon -
                    rectangle -
                    text {
                        catch {set lineColour [my formatXColor  [$cv itemcget $cvItem -outline]]}           {set lineColour   gray50}
                        catch {set lineWidth                    [$cv itemcget $cvItem -width]}              {set lineWidth     0.1}
                        catch {set lineDash                     [$cv itemcget $cvItem -dash]}               {set lineDash     {none}}
                        catch {set itemFill   [my formatXColor  [$cv itemcget $cvItem -fill]]}              {set itemFill     gray50}
                    }
                    default {
                        catch {set lineColour [my formatXColor  [$cv itemcget $cvItem -stroke]]}            {set lineColour   gray50}
                        catch {set lineWidth                    [$cv itemcget $cvItem -strokewidth]}        {set lineWidth     0.1}
                        catch {set lineDash                     [$cv itemcget $cvItem -strokedasharray]}    {set lineDash     {none}}
                        catch {set itemFill   [my formatXColor  [$cv itemcget $cvItem -fill]]}              {set itemFill     gray50}
                    }
                }
                
                    # --- preformat attribues
                if {$lineDash eq ""} {
                    set lineDash    {none}
                } else {
                    set lineDash    [string map {{ } {,}} $lineDash]
                }
                
                puts "        -> [$cv itemconfigure $cvItem] "
                puts "        -> lineColour $lineColour "
                puts "        -> lineWidth  $lineWidth  "
                puts "        -> lineDash   $lineDash   "
                puts "        -> itemFill   $itemFill   "
            }
                #
                # --- get coords
            lassign [string map {".0 " " "} "[$cv coords $cvItem] "]  x0 y0 x1 y1
                # foreach {x0 y0 x1 y1} \
                #   [string map {".0 " " "} "[$cv coords $cvItem] "] break
            
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
        
            # update idletasks
            # update
    
            # -------------------------
            #  handle types      
            switch -exact $cvType {
            
                ________Canvas_like_Objects________ {}
                
                arc {
                }                                                            
                line {                                                       
                }                                                            
                polygon {                                                    
                }                                                            

                arc {
                    lassign [my CreateSVG_arc $cv $cvItem]          svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_arc $cv $cvItem] break
                }
                line {
                    lassign [my CreateSVG_line $cv $cvItem]         svgXML svgType svgAtts svgCoords 
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_polyline $cv $cvItem] break
                }
                oval {
                    lassign [my CreateSVG_oval $cv $cvItem]         svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_oval $cv $cvItem] break
                }
                polygon {
                    lassign [my CreateSVG_polygon $cv $cvItem]      svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_polygon $cv $cvItem] break
                }
                rectangle {
                    lassign [my CreateSVG_rectangle $cv $cvItem]    svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_rectangle $cv $cvItem] break
                }
                text {
                    lassign [my CreateSVG_text $cv $cvItem]         svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_text $cv $cvItem] break
                }
                
                ________PathCanvas_Objects_________ {}
                
                circle {
                    lassign [my CreateSVG_circle $cv $cvItem]       svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_circle $cv $cvItem] break
                }
                ellipse {
                    lassign [my CreateSVG_ellipse $cv $cvItem]      svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_ellipse $cv $cvItem] break
                }
                path {
                    lassign [my CreateSVG_path $cv $cvItem]         svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_path $cv $cvItem] break
                }
                pline {
                    lassign [my CreateSVG_pline $cv $cvItem]        svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_pline $cv $cvItem] break
                }
                polyline {
                    lassign [my CreateSVG_polyline $cv $cvItem]     svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_polyline $cv $cvItem] break
                }
                ppolygon {
                    lassign [my CreateSVG_polygon $cv $cvItem]      svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_polygon $cv $cvItem] break
                }
                prect {
                    lassign [my CreateSVG_prect $cv $cvItem]        svgXML svgType svgAtts svgCoords
                        # foreach {svgXML svgType svgAtts svgCoords} [my CreateSVG_prect $cv $cvItem] break
                }
                ptext {
                    set svgXML {}
                }               

                ________Exceptions_________________ {}
                
                pimage -
                group -
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
        # http://tclbitprint.sourceforge.net/tkpath/README.txt		
        #     circle
		#     ellipse
		#     group
		#     path
		#     pimage
		#     pline
		#     polyline
		#     ppolygon
		#     prect
		#     ptext
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
    method CreateSVG_circle {cv cvItem} {
            #
        if 0 {
            puts "---> CreateSVG_circle -- [$cv coords $cvItem]"
            foreach attrList [$cv itemconfigure $cvItem] {
                set key     [lindex $attrList 0]
                set value   [lrange $attrList 1 end]
                puts "   -> $key - $value"
                puts "   -> $key - [$cv itemcget $cvItem $key]"
            }
        }
            #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "]  x y
            # foreach {x y} [string map {".0 " " "} "[$cv coords $cvItem] "] break
            #
        set cx              $x
        set cy              $y
        set r               [$cv itemcget $cvItem -r]
            #
            #
        set svgType         circle
            #
            #
        set attrDictNew     [list   cx      "$cx" \
                                    cy      "$cy" \
                                    r       "$r"  ]
            
        set attrDictMap     [list   fill                {-fill              "none"} \
                                    stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"}  \
                                    stroke-dasharray    {-strokedasharray   "12,1,1,1"}]
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
    method CreateSVG_ellipse {cv cvItem} {
        #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "]  x y
            # foreach {x y} [string map {".0 " " "} "[$cv coords $cvItem] "] break
            #
        set cx              $x
        set cy              $y
        set rx              [$cv itemcget $cvItem -rx]
        set ry              [$cv itemcget $cvItem -ry]
            #
            #
        set svgType         ellipse
            #
            #
        set attrDictNew     [list   cx      "$cx" \
                                    cy      "$cy" \
                                    rx      "$rx" \
                                    ry      "$ry" ]
            
        set attrDictMap     [list   fill                {-fill              "none"} \
                                    stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"}  \
                                    stroke-dasharray    {-strokedasharray   "12,1,1,1"}]
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
    method CreateSVG_path {cv cvItem} {
            #
        if 0 {    
            puts "---> CreateSVG_path -- [$cv coords $cvItem]"
            foreach attrList [$cv itemconfigure $cvItem] {
                set key     [lindex $attrList 0]
                set value   [lrange $attrList 1 end]
                puts "   -> $key - $value"
                puts "   -> $key - [$cv itemcget $cvItem $key]"
            }
        }
            #
            #
        set pathDefinition  [$cv coords $cvItem]   
            #
            #
        set svgType         path
            #
            #
        set attrDictNew     [list   d       "$pathDefinition"]
            
        set attrDictMap     [list   fill                {-fill              "none"} \
                                    stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"}  \
                                    stroke-dasharray    {-strokedasharray   "12, 1, 1, 1"}]
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
    method CreateSVG_pline {cv cvItem} {
            #
        puts "\n  --- Extension_SVG_PathCanvas - CreateSVG_pline --- "    
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
        set attrDictMap     [list   stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"}  \
                                    stroke-dasharray    {-strokedasharray   "12,1,1,1"}]
            #        
        set svgAtts         [my FormatSVGAttribute $cvItem $attrDictNew $attrDictMap]
            #
        set svgXML          "  <$svgType \n      $svgAtts \n      $svgCoords/>\n"
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
    method CreateSVG_polyline {cv cvItem} {
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
        set attrDictMap     [list   stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"} \
                                    stroke-dasharray    {-strokedasharray   "12,1,1,1"}]
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
        set attrDictMap     [list   fill                {-fill              "none"} \
                                    stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"}  \
                                    stroke-dasharray    {-strokedasharray   "12,1,1,1"}]
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
    method CreateSVG_prect {cv cvItem} {
            #
        if 0 {
            puts "---> CreateSVG_prect -- [$cv coords $cvItem]"
            foreach attrList [$cv itemconfigure $cvItem] {
                set key     [lindex $attrList 0]
                set value   [lrange $attrList 1 end]
                puts "   -> $key - $value"
                puts "   -> $key - [$cv itemcget $cvItem $key]"
            }
        }
            #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "]  x y x1 y1
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
        set attrDictMap     [list   fill                {-fill              "none"} \
                                    stroke              {-stroke            "none"} \
                                    stroke-width        {-strokewidth       "0.1"} \
                                    stroke-dasharray    {-strokedasharray   "12,1,1,1"}]
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
        #
    method CreateSVG_oval_template {cv cvItem} {
            #
        lassign [string map {".0 " " "} "[$cv coords $cvItem] "]  x y x1 y1
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
        #
        #
}

