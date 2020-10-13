 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classExtension_DXF__Super.tcl
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
namespace eval cad4tcl {oo::class create Extension_DXF__Super}
    #
oo::define cad4tcl::Extension_DXF__Super {
        #
        #
    constructor {cvObj args} { 
            #
        puts "              -> class Extension_DXF__Super"
            #
            #
        variable cvObject       $cvObj    
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
        variable unitScale
        variable wScale
        variable cv_ViewCenter_x
        variable cv_ViewCenter_y
            #
        variable dxfContent            
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy Extension_DXF__Super"
            #
    }
        #
    method unknown {target_method args} {
                     puts "<E> ... cad4tcl::Extension_DXF__Super $target_method $args  ... unknown"
    }
        #
        #
    method exportFile {dxfFile} {

        variable cvObject
        variable unitScale
        variable wScale
        variable cv_ViewCenter_x
        variable cv_ViewCenter_y
        
        variable dxfContent
        
        set cv           [$cvObject getCanvas]
        set wScale       [$cvObject configure   Canvas  Scale]      
        set stageScale   [$cvObject configure   Stage   Scale]      
        set stageUnit    [$cvObject configure   Stage   Unit]      
        set font         [$cvObject configure   Style   Font]
        set unitScale    [$cvObject configure   Stage   UnitScale] 
        
        set stageFormat  [$cvObject configure   Stage   Format]   
        set stageWidth   [$cvObject configure   Stage   Width]   
        set stageHeight  [$cvObject configure   Stage   Height]   
        
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
        set cv_ViewBox      [$cvObject coords __Stage__]
        set cv_View_x0      [lindex $cv_ViewBox 0]
        set cv_View_y0      [lindex $cv_ViewBox 1]
        set cv_View_x1      [lindex $cv_ViewBox 2]
        set cv_View_y1      [lindex $cv_ViewBox 3]
        set cv_ViewWidth    [expr {$cv_View_x1 - $cv_View_x0}]
            # set cv_ViewHeight  [ expr [ lindex $cv_ViewBox 0 ] - $cv_View_y0 ]
        set cv_ViewHeight   [expr {$cv_View_y1 - $cv_View_y0}]
        set cv_ViewCenter_x [expr {0.5*($cv_View_x0 + $cv_View_x1)}]
        set cv_ViewCenter_y [expr {0.5*($cv_View_y0 + $cv_View_y1)}]
            #               [ expr  $unitScale * $wScale ]  <- 20170909
        set svgScale        [expr {$wScale / $unitScale}]
            
            # -------------------------
            #  debug info
        puts "        --------------------------------------------"
        puts "           \$stageFormat $stageFormat  "
        puts "                   \$stageUnit      $stageUnit"
        puts "                   \$svgUnit        $svgUnit  "
        puts "                   \$unitScale      [ format "%.5f"  $unitScale ]"
        puts "                   \$stageWidth     $stageWidth  "
        puts "                   \$stageHeight    $stageHeight "
        puts "        --------------------------------------------"
        puts "               \$wScale         [format "%.5f  %.5f"  $wScale        [expr {1.0 / $wScale}]]"
        puts "               \$stageScale     [format "%.5f  %.5f"  $stageScale    [expr {1.0 / $stageScale}]]"
        puts "        --------------------------------------------"
        puts "               \$cv_ViewBox      $cv_ViewBox"
        puts "                   \$cv_ViewCenter_x $cv_ViewCenter_x"
        puts "                   \$cv_ViewCenter_y $cv_ViewCenter_y"
        puts "                   \$cv_View_x0      $cv_View_x0"
        puts "                   \$cv_View_y0      $cv_View_y0"
        puts "                   \$cv_View_x1      $cv_View_x1"
        puts "                   \$cv_View_y1      $cv_View_y1"
        puts "                   \$cv_ViewWidth    $cv_ViewWidth"
        puts "                   \$cv_ViewHeight   $cv_ViewHeight"
        puts "        --------------------------------------------"
        puts "               \$svgScale       ( $wScale / $unitScale )"
        puts "               \$svgScale       [format "%.5f "  $svgScale]"
        puts "        --------------------------------------------"
        
            
            # -------------------------
            #  create bounding boxes
        puts "  -> all             -> [$cvObject coords all] "
        puts "  -> __Stage__       -> [$cvObject coords __Stage__] "
        puts "  -> __SheetFormat__ -> [$cvObject coords __SheetFormat__] "



        
        variable colors
        variable lineType   0
        variable layer      0
            
        array set colors {
                red             1
                yellow          2
                green           3
                cyan            4
                blue            5
                magenta         6
                black           7
                gray            8
                lt-gray         9
        }
        set   dxfContent  {}



        $cvObject create rectangle  [$cvObject coords __Stage__]   \
                    -tags    {__SheetFormat__ __Content__}  \
                    -outline black    \
                    -width   0.01
            
            # -------------------------
            #  get svgViewBox
        set svgViewBox    [list  $cv_View_x0 $cv_View_y0 [expr $svgScale * $stageWidth]  [expr $svgScale * $stageHeight]]
            
            
        # ========================================================================
            # -------------------------
            #  create DXF Header
                    #
                    #
            my dxf_Header  $cv_View_x0 $cv_View_y0 $cv_View_x1 $cv_View_y1  
            
        # ========================================================================
            # -------------------------
            #  for each item
            #
            #          
        foreach cvItem [$cvObject find withtag __Content__] {
        
            set cv_Type     [$cv type $cvItem]
            set svgCoords   {}
            set svgAtts     {}
                    # puts "   $cv_Type"
            
            
            # --- get attributes
            catch {set lineColour [my formatXColor [$cvObject itemcget $cvItem -outline]]}    {set lineColour   gray50}
            catch {set lineWidth  [$cvObject itemcget $cvItem -width]}                        {set lineWidth     0.1}
            catch {set lineDash   [$cvObject itemcget $cvItem -dash]}                         {set lineDash     {none}}
            catch {set itemFill   [my formatXColor [$cvObject itemcget $cvItem -fill]]}       {set itemFill     gray50}
            
            # --- preformat attribues
            if {$lineDash == ""} {set lineDash     {none}}
            set lineDash  [string map {{ } {,}} $lineDash]          
            # --- get coords
            lassign [string map {".0 " " "} "[$cvObject coords $cvItem] "]  x0 y0 x1 y1
                # foreach {x0 y0 x1 y1} \
                #     [string map {".0 " " "} "[$cvObject coords $cvItem] "] break
            
            # --- get coords
            set cvPoints {}
            foreach {x y} [$cvObject coords $cvItem] {
                lappend cvPoints [list $x $y]
            }
                    
            # --- continue if object has no coords
            if {[llength $cvPoints] == 0} {
                puts "\n                ... <W> $cvItem -> $cv_Type  ... has no coords"
                continue
            }

            # -------------------------
            #  handle types      
            switch -exact $cv_Type {
                arc {
                    set c               [my scale_Value_flipXY [expr {($x0+$x1)/2}]  [expr {($y0+$y1)/2}]]
                    set cx              [lindex $c 0]
                    set cy              [lindex $c 1]
                    set rx              [my scale_Value [expr {($x1-$x0)/2}]]
                    set ry              [my scale_Value [expr {($y1-$y0)/2}]]
                    set start           [$cvObject itemcget $cvItem -start]
                    set extend          [$cvObject itemcget $cvItem -extent]
                    set end             [expr {$start + $extend}]
                    set layer           0
                    set lineType        0
                    my dxf_format       0 ARC        8 $layer  6 $lineType 10 $cx  20 $cy  40 $rx  50 $start  51 $end
                }            
                line_ {
                    puts "  line:\n        -> $cvPoints"
                    lassign [my scale_Value_flipXY [cad4tcl::_flattenNestedList $cvPoints]]  x1 y1 x2 y2
                        # foreach {x1 y1 x2 y2}   [my scale_Value_flipXY [cad4tcl::_flattenNestedList $cvPoints]] break
                    set layer           0
                    set lineType        0
                    my dxf_format       0 LINE       8 $layer 6 $lineType   10 $x1 20 $y1 11 $x2 21 $y2                
                }
                line -
                polyline {
                    set layer           0
                    set lineType        0
                    my dxf_format       0 POLYLINE   8 $layer 62 0   70 0    66 1    10 0.0  20 0.0  30 0.0                
                    set run             0
                    foreach {x y} [my scale_Value_flipXY [cad4tcl::_flattenNestedList  $cvPoints]] {
                        # puts "   polyline [incr run]"
                        my dxf_format   0 VERTEX 8 $layer    10 $x 20 $y
                    }
                    my dxf_format       0 SEQEND 8 $layer
                }
                polygon {
                    set layer           0
                    set lineType        0
                    my dxf_format       0 POLYLINE 8 $layer 62 0   70 1    66 1    10 0.0  20 0.0  30 0.0                
                    foreach {x y} [my scale_Value_flipXY [cad4tcl::_flattenNestedList  $cvPoints]] {
                        my dxf_format   0 VERTEX 8 $layer    10 $x 20 $y
                    }
                    my dxf_format       0 SEQEND 8 $layer
                }
                oval {
                    set cx [expr {($x0+$x1)/2}]
                    set cy [expr {($y0+$y1)/2}]
                    set rx [expr {($x1-$x0)/2}]
                    set ry [expr {($y1-$y0)/2}]
                        #
                    set _c  [my scale_Value_flipXY $cx $cy ] 
                    set _cx [lindex $_c 0]
                    set _cy [lindex $_c 1]
                    set _rx [my scale_Value $rx]
                    set _ry [my scale_Value $ry]
                    set layer           0
                    set lineType        0
                    if {$rx == $ry} {
                        my dxf_format   0 CIRCLE 8 $layer 6 $lineType   10 $_cx  20 $_cy  40 $_rx 
                    } else {
                        my dxf_format   0 CIRCLE 8 $layer 6 $lineType   10 $_cx  20 $_cy  40 $_rx
                        my dxf_format   0 CIRCLE 8 $layer 6 $lineType   10 $_cx  20 $_cy  40 $_ry
                    }
                }
                rectangle {
                    set layer           0
                    set lineType        0
                    my dxf_format       0 POLYLINE 8 $layer 62 0   70 1    66 1    10 0.0  20 0.0  30 0.0                
                    foreach {x0 y0 x1 y1} [my scale_Value_flipXY [cad4tcl::_flattenNestedList  $cvPoints]] {
                        my dxf_format   0 VERTEX 8 $layer    10 $x0 20 $y0
                        my dxf_format   0 VERTEX 8 $layer    10 $x1 20 $y0
                        my dxf_format   0 VERTEX 8 $layer    10 $x1 20 $y1
                        my dxf_format   0 VERTEX 8 $layer    10 $x0 20 $y1
                    }
                    my dxf_format       0 SEQEND 8 $layer
                }
                _text {
                    set    svgType      text
                    append svgAtts      [formatItemAttribute x $x0]
                    append svgAtts      [formatItemAttribute y $y0]
                    append svgAtts      [formatItemAttribute fill $itemFill "#000000"]
                    # set text [$c itemcget $item -text]
                    set text            [$cvObject itemcget $cvItem -text]
                }
                default {
                    # error "type $type not(yet) dumpable to SVG"
                    puts "type $cv_Type not (yet) dumpable to DXF"
                }
            }
            
            # -------------------------
            #  canvas item attributes
                #append dxfContent         "    <!-- $cv_Type:-->\n"
                #append dxfContent         "        <!--    cvPoints:    $cvPoints   -->\n"
                #append dxfContent         "        <!--    svgCoords:   $svgCoords   -->\n"
                # foreach attribute [$cv itemconfigure $cvItem] ;#{
                #     append dxfContent   "        <!--    $attribute   -->\n"
                # }
            
            # -------------------------
            #  SVG item, depending on cv_Type
            #     $style
                #append dxfContent "  <$svgType \n      $svgAtts\n      $svgCoords"        
            if {$cv_Type eq "text"} {
                #append dxfContent ">$text</$svgType>\n"
            } else {
                #append dxfContent " />\n"
            }
        }
        
            
        # ========================================================================
            # -------------------------
            #  close DXF
                    #
                    #
        my dxf_format 0 ENDSEC              
        my dxf_format 0 EOF


        # -- cleanup canvas
        #
        $cvObject delete -tags {__SheetFormat__}  

        #
        # -- fill export svgFile
        #
        set     fp [open $dxfFile w]          
        fconfigure  $fp -encoding utf-8
            #set dxfContent $::[namespace current]::dxfContent
        foreach line $dxfContent {
            puts     $fp "${line}"
        }
        close       $fp
        
        #
        # -- fill export dxfFile
        #
        if {[file exists $dxfFile]} {
            return $dxfFile
        } else {
            return {_noFile_}
        }
        
    }      
    
    #-----------------------------------------
    #  dxf procedures ....
    #
    method scale_Value_flipXY {args} {
        variable unitScale
        variable wScale
        variable cv_ViewCenter_x
        variable cv_ViewCenter_y
        
        set resList {}
        foreach {x y} [cad4tcl::_flattenNestedList $args] {
            # puts "      -> $arg / $args"
            #               [expr  1.0 * ($x - $cv_ViewCenter_x) / ($unitScale * $wScale)] <- 20170909
            #               [expr -1.0 * ($y - $cv_ViewCenter_y) / ($unitScale * $wScale)] <- 20170909
            lappend resList [expr { 1.0 * $unitScale * ($x - $cv_ViewCenter_x) / $wScale}]
            lappend resList [expr {-1.0 * $unitScale * ($y - $cv_ViewCenter_y) / $wScale}]
        }
        return $resList
    }
    method scale_Value {args} {
        variable unitScale
        variable wScale
        variable cv_ViewCenter_x
        variable cv_ViewCenter_y
        
        set resList {}
        foreach args [cad4tcl::_flattenNestedList $args] {
            # puts "      -> $arg / $args"
            #               [expr $args / ($unitScale * $wScale)] <- 20170909
            lappend resList [expr {($args * $unitScale) / $wScale}]
            #lappend resList [expr ($y - $cv_ViewCenter_y) / ($unitScale * $wScale)]
        }
        return $resList
    }
    method dxf_Header {x0 y0 x1 y1} {
        lappend [namespace current]::dxfContent   [format "%3d\n%s" 999 {DXF created by rattleCAD}]           
        my dxf_format 0 SECTION 2 HEADER
            my dxf_format 9   \$ACADVER 1 AC1009
            # dxf_format 9   \$ACADVER 1 AC1015    
            # dxf_format 9   \$ACADMAINTVER   70  {     6}     
            # dxf_format 9   \$DWGCODEPAGE     3  DOS850
            my dxf_format 9   \$INSBASE        10  0.0         20  0.0         30 0.0
            my dxf_format 9   \$EXTMIN         10  0.0 20  0.0
            my dxf_format 9   \$EXTMAX         10  0.0 20  0.0
            my dxf_format 9   \$LIMMIN         10  0.0 20  0.0
            my dxf_format 9   \$LIMMAX         10  0.0 20  0.0
        my dxf_format 0 ENDSEC

        my dxf_format 0 SECTION 2 TABLES
            my dxf_format 0 TABLE 2 LTYPE 70 2
            my dxf_LType 0
            my dxf_format 0 ENDTAB
            
            my dxf_format 0 TABLE 2 LAYER 70 5
            my dxf_Layer 0
            my dxf_Layer label   0 green
            my dxf_Layer holes   0 cyan
            my dxf_Layer outline 0 blue
            my dxf_Layer slits   0 red
            my dxf_format 0 ENDTAB
        my dxf_format 0 ENDSEC
        
        my dxf_format 0 SECTION 2 ENTITIES
    }
    method dxf_format {args} {
        variable dxfContent
        set lastArg [lindex $args end]
        
        if {[llength $lastArg] == 1} {
            foreach { code value } $args { 
                lappend dxfContent   [format "%3d\n%s" $code $value]
            }
        } else {
            foreach { code value } [lrange $args 0 end-1] { 
                lappend dxfContent   [format "%3d\n%s" $code $value]
            }
            foreach { code value } $lastArg { 
                lappend dxfContent   [format "%3d\n%s" $code $value]
            }
            
        }
    }

        # -- following funcitons by: John Roll 2009-03-18;  Writing DXF; http://www2.tcl.tk/22794 
    method dxf_LType {name {flags 0} } {
        my dxf_format  0 LTYPE 2 $name
        my dxf_format 70 $flags 3 $name 72 65 73 0 40 0.0000
    }
    method dxf_Layer {{name 0} {flags 0} {color 7} {ltype 0} } {
        variable colors
        catch { set color [set colors($color)] }
        my dxf_format  0 LAYER 2 $name
        my dxf_format 70 $flags 6 $ltype 62 $color
    }
    method dxf_rect {x y w h { t 0 } { o 0 } } {
        set sin_t [expr {sin($t * (3.14159265358979323846 * 2 / 360))}]
        set cos_t [expr {cos($t * (3.14159265358979323846 * 2 / 360))}]

        set wdx [expr {$w / 2.0 * $cos_t}]
        set wdy [expr {$w / 2.0 * $sin_t}]
        set hdx [expr {$h / 2.0 * $sin_t}]
        set hdy [expr {$h / 2.0 * $cos_t}]
        set odx [expr {$o       * $sin_t}]
        set ody [expr {$o       * $cos_t}]

        set x1 [expr {$x - $wdx - $hdx - $odx}]
        set y1 [expr {$y - $wdy + $hdy - $ody}]
        set x2 [expr {$x - $wdx + $hdx + $odx}]
        set y2 [expr {$y - $wdy - $hdy + $ody}]

        set x3 [expr {$x + $wdx + $hdx + $odx}]
        set y3 [expr {$y + $wdy - $hdy + $ody}]
        set x4 [expr {$x + $wdx - $hdx - $odx}]
        set y4 [expr {$y + $wdy + $hdy - $ody}]

        my dxf_polygon $x1 $y1 $x2 $y2 $x3 $y3 $x4 $y4
    }            
    method dxf_solid {x1 y1 x2 y2 x3 y3 x4 y4 } {
        item SOLID 10 $x1 20 $y1 11 $x2 21 $y2
        my dxf_format 12 $x4 22 $y4
        my dxf_format 13 $x3 23 $y3
    }
    method dxf_solidbox  {x1 y1 x2 y2 {color 256} } {
        my dxf_solid $x1 $y1 $x1 $y2 $x2 $y2 $x2 $y1
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

