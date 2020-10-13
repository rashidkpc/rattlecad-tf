 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classDimension.tcl
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
namespace eval cad4tcl {oo::class create _Dimension}
    #
oo::define cad4tcl::_Dimension {
        #
    variable ItemFactory                ;# creates items on canvas
        #
    variable _parentCanvas              ;# the canvas, the dimension is created
    variable _canvasRegistryNode        ;# the node in the cadCanvas registry
    variable _canvasScale               ;# scale of the canvas itself
    variable _stageScale                ;# scale of the displayed stage of cadCanvas
    variable _stageUnit                 ;# m, ... ???
    variable _unitScale                 ;# unitspecific scale of the canvas in relation to ... ???
    variable _dimensionUID              ;# a unique dimension id
    variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
    variable _textTag                   ;# contains the tag of the dimensiontext
    variable _sensitiveTag              ;# contains the tag of the sensitive dimension area
    variable _sensitiveSize             ;# radius of sensitive area
    variable _fontSize                  ;# fontsize of dimension text
    variable _lineWidth                 ;# lione width of dimension
    
        #
        # ----------------------------------------------------
        #
    constructor {} {
            #
        # puts "            -> superclass _Dimension"
            #
    }
        #
    destructor { 
            #
        # puts "            -> [self] ... destroy _Dimension"
            #
        variable _parentCanvas
        variable _dimensionTag
        variable _sensitiveTag
            #
        $_parentCanvas     delete $_dimensionTag
            #
        if [info exists _sensitiveTag] {
            $_parentCanvas delete $_sensitiveTag
        }
            #
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cad4tcl::_Dimension::$target_method $args  ... unknown"
    }
        #
    method setCanvasSettings {} {
            #
        variable cvObject    
            #
        variable _canvasRegistryNode
        variable _parentCanvas
        variable _canvasScale
        variable _stageScale
        variable _stageUnit
        variable _unitScale              
        variable _fontSize
        variable _sensitiveSize
        variable _lineWidth
            #
            # set _canvasRegistryNode $canvasRegistryNode
            #
        set _parentCanvas   [$cvObject getCanvas]
        set _canvasScale    [$cvObject configure    Canvas  Scale]                
        set _stageScale     [$cvObject configure    Stage   Scale]                
            #   
        set _stageUnit      [$cvObject configure    Stage   Unit]
        set _unitScale      [$cvObject configure    Stage   UnitScale]
        set _lineWidth      [$cvObject configure    Style   Linewidth]
        set _fontSize       [$cvObject configure    Style   Fontsize]
            #
    }
        #
    method fit2Canvas {{myItem {}}} {
            #
        variable _parentCanvas
        variable _dimensionTag
        variable _canvasScale
        variable _unitScale              
            #
        set w       $_parentCanvas
            #
        if {$myItem == {}} {
            set myItem  $_dimensionTag
        }
            #
        set dimScale [expr {$_canvasScale / $_unitScale}]
        $w scale $myItem  0 0  $dimScale $dimScale
            #
        set moveVector  [cad4tcl::_getBottomLeft $w]
        $w move $myItem [lindex $moveVector 0] [ lindex $moveVector 1]    
            #
    }
        #
    method get_parentCanvas {} {
        variable _parentCanvas
        return $_parentCanvas
    }
        #
    method add_UID {tag} {
        variable _parentCanvas
        variable _dimensionTag
            #
        variable _dimensionUID $tag
            #
        $_parentCanvas addtag $_dimensionUID withtag $_dimensionTag
            #
        return $_dimensionTag
    }
        #
    method get_dimensionTag {} {
        variable _dimensionTag
        return $_dimensionTag
    }
        #
    method get_dimensionType {} {
        return {}
    }
        #
    method get_textTag {} {
        variable _textTag
        return $_textTag
    }
        #
    method get_editTag {} {
        variable _editTag
        return $_editTag
    }
        #
    method get_UID {} {
        variable _dimensionUID
        return $_dimensionUID
    }
        #
    method createSensitiveArea {{activeColor wheat}} {
            #
        variable cvObject
            #
        set w           [$cvObject configure    Canvas  Path]
        set canvasScale [$cvObject configure    Canvas  Scale]
        set unitScale   [$cvObject configure    Stage   UnitScale]
        set fontSize    [$cvObject configure    Style   Fontsize]
           #
        set unitScale_p [cad4tcl::_getUnitRefScale    p]
            #
        set textCoords  [$w bbox $_textTag]
            #
            # puts "  createSensitiveArea"
            # puts "  <D> \$textCoords $textCoords"
        if {$textCoords == {}} return
            #
        set textCenter  [cad4tcl::_getBBoxInfo  $textCoords center]
            # puts "  <D> \$textCenter $textCenter"
            #
        set editSize    [expr {2 * $_fontSize * 1 * $canvasScale / (1 * $unitScale)}]
            # puts "  <D> \$editSize   $editSize"
            # puts "  <D> \$unitScale    $unitScale"
            # puts "  <D> \$canvasScale  $canvasScale"
            #
        foreach {x y} $textCenter {
            set x1 [expr {$x - $editSize}]
            set x2 [expr {$x + $editSize}]
            set y1 [expr {$y - $editSize}]
            set y2 [expr {$y + $editSize}]
        }
        set coords      [list   $x1 $y1 $x2 $y2]
            #
        set tagName [format "sensitive_%s" [llength [$w find withtag all]] ]    
            #
            # set activeColor    {light gray}
            # set activeColor    {beige}
            # set activeColor    {wheat}
            #
        set _sensitiveTag    [ $w create  oval   $coords  \
                                -tags           "$tagName __Sensitive__" \
                                -fill           {} \
                                -disabledfill   {} \
                                -activefill     $activeColor \
                                -outline        {}] 
            #
            # puts "  <D>     -> $tagName $_sensitiveTag  "
        $w raise $_sensitiveTag   
        $w raise $_textTag   
        $w addtag $_dimensionTag    withtag $tagName  
            #
        $w addtag {__Content__}     withtag $tagName
        $w addtag {__Dimension__}   withtag $tagName
        $w addtag {__Sensitive__}   withtag $tagName
        $w addtag {__NoDrag__}      withtag $tagName
            #
            # puts "  <D>     -> [$w gettags  $tagName]"    
            # puts "  <D> createSensitiveArea [$w coords $tagName]"    
            #
            # my fit2Canvas $_sensitiveTag   
            #
        return $tagName
            #
    }
        #
    method report_UID {} {
        variable _parentCanvas
        variable _dimensionTag
        variable _dimensionUID
        puts "    ->   $_parentCanvas -> $_dimensionTag --> $_dimensionUID"
    }
        #
    method noramlizeAngle {angle} {
        while { $angle < 0} {
            set angle   [expr {$angle + 360}]
        }
        while { $angle > 360} {
            set angle   [expr {$angle - 360}]
        }
        return $angle
    }
        #
        #
    method createLine_2 {p1 p2 colour} {
            #
        variable cvObject    
        variable ItemInterface    
            #
        set w           [$cvObject configure    Canvas  Path]
        set canvasScale [$cvObject configure    Canvas  Scale]
        set stageScale  [$cvObject configure    Stage   Scale]
        set unitScale   [$cvObject configure    Stage   UnitScale]
        set lineWidth   [$cvObject configure    Style   Linewidth]
            #
        set coords      [list   [lindex $p1  0]  [lindex $p1  1] \
                                [lindex $p2  0]  [lindex $p2  1]]
            #
        set p1 [lrange $coords 0 1]
        set p2 [lrange $coords 2 3]
            #
        set myItem  [$ItemInterface create  line \
                            $coords  \
                            [list \
                                -fill   $colour \
                                -width  $lineWidth ]]
            #
        return $myItem
            #
    }
        #  
    method createArc_2 {p r start extent colour} {
            #
        variable cvObject    
        variable ItemInterface    
            #
        set w           [$cvObject configure    Canvas  Path]
        set stageScale  [$cvObject configure    Stage   Scale]
        set lineWidth   [$cvObject configure    Style   Linewidth]
            #
        lassign $p  x y
            # foreach {x y} $p break
        set coords  [list   [expr {$x - $r}] [expr {$y - $r}] \
                            [expr {$x + $r}] [expr {$y + $r}]]
            #
        set myItem  [$cvObject create arc \
                            $p \
                            [list \
                                -radius  $r \
                                -start   $start  \
                                -extent  $extent  \
                                -style   {arc}  \
                                -outline $colour  \
                                -width   $lineWidth]]
            #
        return $myItem
            #
    }
        #  
    method createLineEnd_2 {p end_angle colour {style inside} } {
            #
        variable cvObject    
        variable ItemInterface    
            #
        set w           [$cvObject configure    Canvas  Path]
        set stageScale  [$cvObject configure    Stage   Scale]
        set lineWidth   [$cvObject configure    Style   Linewidth]
        set stageUnit   [$cvObject configure    Stage   Unit]
        set fontSize    [$cvObject configure    Style   Fontsize]
        set lineDist    [$cvObject configure    Style   Fontdist]
            #
        set endListName [format "dimEnd_%s" [llength [$w find withtag all]] ]
            #
        if { $style != {inside} } { 
                #
            set end_angle   [expr {$end_angle + 180}] 
            set p_outl      [vectormath::rotateLine  $p  [expr ($fontSize + 2) / $stageScale]  $end_angle]
            set coords      [list   [lindex $p      0]  [lindex $p      1] \
                                    [lindex $p_outl 0]  [lindex $p_outl 1]]
            set myItem  [$ItemInterface create  line  \
                            $coords  \
                            [list \
                                -fill   $colour \
                                -width  $lineWidth]]
            $w addtag $endListName withtag $myItem
                #
        }
            #
            # -------------------------------
            # create arrow-end
        set asl     [expr {$fontSize / ($stageScale * cos([expr 15 * (4 * atan(1)) / 180]))}]
            #       [expr $fontSize / [expr $stageScale * cos([expr 15 * (4 * atan(1)) / 180])]]
        set p0      [vectormath::rotateLine     $p  [expr {1/$stageScale}]    [expr {$end_angle + 90  }]]
        set p1      [vectormath::rotateLine     $p  $asl                      [expr {$end_angle +  7.5}]]
        set p2      [vectormath::rotateLine     $p  $asl                      [expr {$end_angle -  7.5}]]
        set p3      [vectormath::rotateLine     $p  [expr {1/$stageScale}]    [expr {$end_angle - 90  }]]
            #
        set coords  [list   [lindex $p0  0]  [lindex $p0  1] \
                            [lindex $p   0]  [lindex $p   1] \
                            [lindex $p1  0]  [lindex $p1  1] \
                            [lindex $p2  0]  [lindex $p2  1] \
                            [lindex $p   0]  [lindex $p   1] \
                            [lindex $p3  0]  [lindex $p3  1]]
            #
        set myItem  [$ItemInterface create  line  \
                            $coords  \
                            [list \
                                -fill   $colour \
                                -width  $lineWidth]]
        $cvObject   addtag  $endListName withtag $myItem
            #
        return $endListName
            #
    }
        #
    method createText_2 {dimValue format p dimAngle colour } {
            #
        variable cvObject
        variable ItemInterface
            #
        set w           [$cvObject configure    Canvas      Path]
        set canvasScale [$cvObject configure    Canvas      Scale]
        set stageScale  [$cvObject configure    Stage       Scale]
        set stageUnit   [$cvObject configure    Stage       Unit]
        set fontSize    [$cvObject configure    Style       Fontsize]
        set fontColour  [$cvObject configure    Style       Fontcolour]
        set fontDist    [$cvObject configure    Style       Fontdist]
        set font        [$cvObject configure    Style       Font]
        set fontStyle   [$cvObject configure    Style       Fontstyle]
        set dimPrec     [$cvObject configure    Style       Precision]
        set lineWidth   [$cvObject configure    Style       Linewidth]
            #
        set unitScale   [$cvObject configure    Stage       UnitScale]
        set unitScale_p [$cvObject configure    UnitScale   p]
            #
            # format text
            #
        if {$fontColour != $colour} {set fontColour $colour}
        if {$dimValue < 0 } {set dimValue [expr {-1 * $dimValue}]}
        set formatString    "\%.${dimPrec}f"
        set dimValue        [format "$formatString" $dimValue]
            #
            # remove trailing zeros
            #
        set leading         [lindex [split $dimValue .] 0]
        set trailing        [lindex [split $dimValue .] 1]            
        if {[expr {$dimValue == $leading}]} {
            set text        [format "%s%s"  $leading $format]
        } else {
            set trailing [string trimright $trailing {0}]
            if {$trailing == {}} {
                set text    [format "%s%s"    $leading $format]
            } else {
                set text    [format "%s,%s%s" $leading $trailing $format]
            }
        }
            #
            # geometric definitions
            #
        set checkAngle $dimAngle
        if {$dimAngle <   0} { set checkAngle [expr {$dimAngle + 360}] }
        if {$dimAngle > 360} { set checkAngle [expr {$dimAngle - 360}] }
            #
        set fontDist    [expr {$fontDist / $stageScale}]
            #
        if {$checkAngle > 180} {
            set textOrient  +90
            set textPos     [vectormath::rotateLine   $p $fontDist [expr {180 + $dimAngle}]]
        } elseif { $checkAngle == 0} {
            set textOrient  +90
            set textPos     [vectormath::rotateLine   $p $fontDist [expr {180 + $dimAngle}]]
        } else {
            set textOrient  -90
            set textPos     [vectormath::rotateLine   $p $fontDist $dimAngle]
        }
            #
        lassign $p  x y
            # foreach {x y} $p break
            #
            # puts ""
            # puts "createText"
            # puts "      \$dimPrec       $dimPrec"
            # puts "      \$font          $font"
            # puts "      \$fontColour    $fontColour"
            # puts "      \$fontDist      $fontDist"
            # puts "      \$fontSize      $fontSize"
            # puts "      \$fontStyle     $fontStyle"
            # puts "      \$stageScale    $stageScale"
            # puts "      \$stageUnit     $stageUnit "
            #
            # -------------------------------
            # depend on style
        if {$fontStyle == "vector"} {
                #
            set mySize      [expr {$fontSize / $stageScale}]
                # set myWidth     [expr 0.1 * $mySize]
                # set myWidth     [expr 0.1 * $mySize / ($unitScale_p * $unitScale_p * $unitScale)]
                # set myWidth     [expr 0.1 * $mySize * ($unitScale / $unitScale_p)]
                # set myWidth     [expr 0.1 * $fontSize / ($stageScale * $canvasScale)]
            set myWidth     [expr {$lineWidth / $stageScale}]
                #
            set myItem  [$ItemInterface create vectorText \
                            $textPos \
                            [list \
                                -text   $text \
                                -anchor s \
                                -angle  [expr $dimAngle + $textOrient] \
                                -stroke $fontColour \
                                -width  $lineWidth \
                                -size   $mySize]]
                #
                # $cvObject configure $myItem -width $lineWidth    
                #
            if 0 {
                puts "\n---------------------------------------"
                puts "       size:  [expr $fontSize / $stageScale]"
                puts "       width: $myWidth"
                puts "          fontSize:    $fontSize"
                puts "          lineWidth:   $lineWidth"
                puts "              mySize:  $mySize"
                puts "              myWidth: $myWidth"
                puts "                  canvasScale: $canvasScale"
                puts "                  stageScale:  $stageScale"
                puts "                  unitScale:   $unitScale"
                puts "                  unitScale_p: $unitScale_p"
                puts "                      unitScale:   [$cvObject configure    Stage      UnitScale]"
                puts "                      unitScale_std:  [$cvObject configure    UnitScale  std]"
                puts "                      unitScale_m:    [$cvObject configure    UnitScale  m]"
                puts "                      unitScale_p:    [$cvObject configure    UnitScale  p]"
                puts "---------------------------------------\n"
                puts "          a)      [expr {($fontSize * 0.1) / $stageScale}]"
                puts "          b)      [expr {($fontSize * 0.1) / $stageScale}]"
                puts "---------------------------------------\n"
                    #
                lassign $textPos  debug_x0 debug_y0 
                    # foreach {debug_x0 debug_y0} $textPos break
                    #
                    # --- debug01 -------------------
                    #
                    set debug_x1    [expr {$debug_x0 + $mySize}]
                    set debug_y1    [expr {$debug_y0 + $mySize}]
                set debug01 [$ItemInterface create rectangle \
                                [list $debug_x0 $debug_y0 $debug_x1 $debug_y1] \
                                [list \
                                    -outline red \
                                    -fill    yellow \
                                    -width   $myWidth]]
                $w addtag $myItem withtag $debug01
                    #
                $w lower  $debug01 $myItem
                    #
                    #
                #
                    # --- debug02 -------------------
                    #
                    set mySize      [expr {$fontSize / ($stageScale)}]
                    set myWidth     [expr {0.1 * ($mySize * $canvasScale / $unitScale)}]
                    # set myWidth     [expr  0.1 * ($fontSize / 1)]
                    set debug_x1    [expr {$debug_x0 + $mySize}]
                    set debug_y1    [expr {$debug_y0 - $mySize}]
                set debug02 [$ItemInterface create rectangle \
                                [list $debug_x0 $debug_y0 $debug_x1 $debug_y1] \
                                [list \
                                    -outline blue \
                                    -fill    yellow \
                                    -width   $myWidth]]
                $w addtag $myItem withtag $debug02
                    #
            }
                #
        } else {
                #
            set myScale     [expr {1.0 * ($unitScale / $unitScale_p)}]
                #
            set fontSize    [expr {round($fontSize * $myScale)}]
            set font        [format "%s %s"   $font $fontSize]
                # puts "      \$fontSize      $fontSize"
            set myItem      [$w create text  $x $y \
                                -text   $text \
                                -anchor s \
                                -fill   $fontColour \
                                -font   $font]
                #
        }
            #
        return $myItem
            #
    }
        #  
    method createPoint_2 {p radius colour} {
            #
        variable cvObject    
        variable ItemInterface    
            #
        set w       [$cvObject configure    Canvas  Path]
            #
        set myItem  [$ItemInterface create circle \
                            $p \
                            [list \
                                -r      $radius \
                                -fill   $colour \
                                -width  0]]
        return $myItem
    }
        #
}


namespace eval cad4tcl {oo::class create AngleDimension}
    #
oo::define cad4tcl::AngleDimension {
        #
    superclass cad4tcl::_Dimension
        #
    variable _parentCanvas              ;# the canvas, the dimension is created
    variable _canvasRegistryNode        ;# the node in the cadCanvas registry
    variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
    variable _textTag                   ;# contains the tag of the dimensiontext
    variable _fontSize                  ;# fontsize of dimension text
    variable _lineWidth                 ;# lione width of dimension
    variable _editTag                   ;# contains the tag of the sensitive dimension area
        #
    constructor {cvObj itemIF p_Coords dimDistance {textOffset 0} {colour black}} {
            #
        # puts "            -> class AngleDimension"
            #
        variable cvObject       $cvObj
            #
        variable ItemInterface  $itemIF
            #
        variable _parentCanvas              ;# the canvas, the dimension is created
        variable _canvasRegistryNode        ;# the node in the cadCanvas registry
        variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
        variable _textTag                   ;# contains the tag of the dimensiontext
        variable _fontSize                  ;# fontsize of dimension text
        variable _lineWidth                 ;# lione width of dimension
        variable _editTag                   ;# contains the tag of the sensitive dimension area
            #
            #
        my setCanvasSettings
            #
        set _dimensionTag   _empty_    
        set _editTag        _empty_
            #
        set returnValues    [my createObject  $p_Coords  $dimDistance  $textOffset  $colour]    
            #
            # puts "     -> \$returnValues $returnValues"    
            #
        set _dimensionTag   [lindex $returnValues 0]
        set _textTag        [lindex $returnValues 1]
            #
            # my fit2Canvas  
            #
        set w $_parentCanvas
        $w addtag {__Content__}     withtag $_dimensionTag
        $w addtag {__Dimension__}   withtag $_dimensionTag
            #
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cad4tcl::AngleDimension $target_method $args  ... unknown"
    }
        #
    method createObject {p_Coords  dimRadius {textOffset 0} {colour black}} {
            #
        variable cvObject        
            #    
        set w           [$cvObject configure    Canvas  Path]
        set fontSize    [$cvObject configure    Style   Fontsize]
        set stageScale  [$cvObject configure    Stage   Scale]
            #
            # puts "      \$w             $w"
            # puts "      \$fontSize      $fontSize"
            # puts "      \$stageScale    $stageScale"
            #
        set pc  [list [lindex $p_Coords 0] [lindex $p_Coords 1]]
        set p1  [list [lindex $p_Coords 2] [lindex $p_Coords 3]]
        set p2  [list [lindex $p_Coords 4] [lindex $p_Coords 5]]
            #
        set checkLength [ expr {(1 + 2 * $fontSize) / $stageScale}]
            #
            # -------------------------------
            # ceck $w
        if {$w == {}} {
            error "cad4tcl::AngleDimension -> Error:  could not get \$w" 
        }
            #
            # -------------------------------
            # correct in case of {} parameters ... execution through cad4tcl::dimension
        if {$textOffset == {}} {set textOffset  0}
        if {$colour     == {}} {set colour      black}
            #
            # -------------------------------
            # reset item container
        set itemList    {}

            # -------------------------------
            # correct direction
        set arcRadius $dimRadius
        
            # -------------------------------
            # get direction
        set angle_p1    [ vectormath::dirAngle $pc $p1 ]
        set angle_p2    [ vectormath::dirAngle $pc $p2 ]

        # -------------------------------
            # negativ dimRadius exception
        if { $dimRadius < 0 } {
            set angle_x     $angle_p1
            set angle_p1    $angle_p2
            set angle_p2    [expr {360 + $angle_x}]
        }
        set gapAngle        [expr {$angle_p2 - $angle_p1}]
        
        # -------------------------------
            # angle in between 3 points
        set angle_p1        [my noramlizeAngle $angle_p1 ]
        set absAngle        [my noramlizeAngle $gapAngle ]     
        
                # set angle_p1    [ eval format "%0.3f" $angle_p1 ]
                # set angle_p2    [ eval format "%0.3f" $angle_p2 ]
        
        if { [eval format "%0.3f" $angle_p1] == [eval format "%0.3f" $angle_p2] } { return }
        
        set angle_p2        [expr {$angle_p1 + $absAngle}]
                # set angle_p2    [ eval format "%0.3f" $angle_p2 ]
        
                # puts "    ... angle_p1:       $angle_p1"
                # puts "    ... angle_p2:       $angle_p2"
                # puts "    ... gapAngle:       $gapAngle"

            # -------------------------------
            # dimension help lines parameters
        set angle_dim_p1    [expr {$angle_p1  +  90}]
        set angle_dim_p2    [expr {$angle_p2  -  90}]
        
        set p_hl_p1         [vectormath::rotateLine  $p1  [expr {2 / $stageScale}]  $angle_p1]
        set p_hl_p2         [vectormath::rotateLine  $p2  [expr {2 / $stageScale}]  $angle_p2]
        if { $dimRadius > 0 } {
            set p_hl_dim_p1 [vectormath::rotateLine  $pc  $arcRadius  $angle_p1]
            set p_hl_dim_p2 [vectormath::rotateLine  $pc  $arcRadius  $angle_p2]
        } else {
            set p_hl_dim_p1 [vectormath::rotateLine  $pc  $arcRadius  [expr {180 + $angle_p1}]]
            set p_hl_dim_p2 [vectormath::rotateLine  $pc  $arcRadius  [expr {180 + $angle_p2}]]
        }

            # -------------------------------
            # dimension help lines
        set check_ln_p1     [vectormath::length $pc $p1]
        set check_ln_p2     [vectormath::length $pc $p2]
        if {$check_ln_p1 < $arcRadius} {
            set myLine [my createLine_2     $p_hl_p1  $p_hl_dim_p1  $colour ]
            lappend itemList $myLine
                # $w addtag $tagListName withtag $myLine
        }
        if {$check_ln_p2 < $arcRadius } {
            set myLine [my createLine_2     $p_hl_p2  $p_hl_dim_p2  $colour ]
            lappend itemList $myLine
                # $w addtag $tagListName withtag $myLine 
        }

            # -------------------------------
            # dimension arc ends
        set asinParameter   [ expr {1.0 * $checkLength/(2*$arcRadius)}]
        set checkAngle      180
                # puts "   -> asinParameter  $asinParameter"
        if { [expr abs($asinParameter)] < 1 } {
            set checkAngle  [ expr {2 * asin($asinParameter) * 180 / $vectormath::CONST_PI}]
        }
        
        if { $absAngle > $checkAngle } {
            set myEnd [my createLineEnd_2   $p_hl_dim_p1  $angle_dim_p1  $colour ]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
            set myEnd [my createLineEnd_2   $p_hl_dim_p2  $angle_dim_p2  $colour ]
            lappend itemList $myEnd 
                # $w addtag $tagListName withtag $myEnd 
        } else {
            set myEnd [my createLineEnd_2   $p_hl_dim_p1  $angle_dim_p1  $colour  {outside} ]
            lappend itemList $myEnd 
                # $w addtag $tagListName withtag $myEnd
            set myEnd [my createLineEnd_2   $p_hl_dim_p2  $angle_dim_p2  $colour  {outside} ]
            lappend itemList $myEnd 
                # $w addtag $tagListName withtag $myEnd 
        }
        
            # -------------------------------
            # arc extension on offset 
        if { $textOffset != 0 } {
            set extAngle    0
            set offsetAngle 0
            # --- compute extension from fontSize
            set asinParameter   [expr {1.0 * $checkLength/$arcRadius}]
            if { $asinParameter < 1 } {
                set asinParameter   [expr {1.5 * $fontSize/$arcRadius}]
                set extAngle    [expr {asin($asinParameter) * 180 / $vectormath::CONST_PI}]
            } 
                # puts "    ... gapAngle:       $gapAngle"
            
            set offsetAngle     [expr {$angle_p1 + $absAngle/2 - $textOffset}]
            set offsetAngle_1   [expr {$angle_p1 + $absAngle/2 - $textOffset - $extAngle}]
            set offsetAngle_2   [expr {$angle_p2 - $absAngle/2 - $textOffset + $extAngle}]
                # puts "    ... textOffset:     $textOffset    "
                # puts "    ... angle_p1:       $angle_p1   $offsetAngle_1 "
                # puts "    ... angle_p2:       $angle_p2   $offsetAngle_2 "
            if { $textOffset > 0 } {
                if {$offsetAngle_1 < $angle_p1} {set angle_p1 $offsetAngle_1}
            } else {
                if {$offsetAngle_2 > $angle_p2} {set angle_p2 $offsetAngle_2}
            }

            # --- debug in graphic
                # set myOffSet  [ vectormath::rotateLine  $pc  $arcRadius  $offsetAngle ]
                # set myP1      [ vectormath::rotateLine  $pc  $arcRadius  $angle_p1 ]
                # set myP2      [ vectormath::rotateLine  $pc  $arcRadius  $angle_p2 ]
        }
        
            # -------------------------------
            # dimension arc and text position angle
        set arcAngle        [expr {$angle_p2 - $angle_p1}]
                # puts "    ... arcAngle:       $arcAngle   "
                # puts "    ... angle_p1:       $angle_p1   "
                # puts "    ... angle_p2:       $angle_p2   "
        # set checkValue        [expr $angle_p2 - $angle_p1 ]
                # puts "    ... checkValue:     $checkValue   "

        if {[expr {$angle_p2 - $angle_p1}] > 360} {
                set myArc [my createArc_2   $pc  $arcRadius  0 359.999  $colour]
                lappend itemList $myArc
                $w addtag $tagListName withtag $myArc
        } else {
            if {[expr {$angle_p1 + $arcAngle}] < 360} {
                set myArc [my createArc_2   $pc  $arcRadius  $angle_p1  $arcAngle  $colour ]
                lappend itemList $myArc
                        # $w addtag $tagListName withtag $myArc 
            } else {
                set myArc [my createArc_2   $pc  $arcRadius  $angle_p1  $arcAngle  $colour ]
                lappend itemList $myArc
                        # $w addtag $tagListName withtag $myArc 
                set myArc [my createArc_2   $pc  $arcRadius  0         [expr {$angle_p1 + $arcAngle - 360}]  $colour ]
                lappend itemList $myArc
                        # $w addtag $tagListName withtag $myArc 
            }
        }
        
            # -------------------------------
            # no text offset if distance less than 2+fontSize -> $checkLength
        if { [expr {abs($arcRadius)}] < $checkLength } { set textOffset 0 }
        
            # -------------------------------
            # dimension arc and text position angle
            # puts "    ... gapAngle:       $gapAngle"
        set textPosAngle        [expr {$angle_p1 + 0.5*$absAngle - $textOffset}]
        if { $dimRadius < 0 } {
            set textPosAngle    [expr {180 + $textPosAngle}]
        }
            # -------------------------------
            # text position
        set textPosition    [vectormath::rotateLine  $pc  $arcRadius  $textPosAngle]

            #  ---------------------------------------------
            # create text
            # set myItem [my createPoint_2 $textPosition 2 red]
            # lappend itemList $myItem    
            
        set myText [my createText_2   $absAngle  {°}  $textPosition  $textPosAngle  $colour ]
            $w itemconfigure $myText -tags [list $myText __DimensionText__]
            lappend itemList $myText
                # puts "[$w itemconfigure $myText]"
                # $w addtag $tagListName withtag $myText
            
            #  ---------------------------------------------
            #  sum up and return
                # $w addtag $tagListName withtag $myBase
                # $w addtag $tagListName withtag $myHelp
                # $w addtag $tagListName withtag $myPos
                # $w move {myArc} 30 0

            # -------------------------------
            # reset item container
        set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
        $w dtag  $tagListName all
        foreach item $itemList {
            $w addtag $tagListName withtag $item
        }

            # -------------------------------
            # 
        return [list $tagListName $myText]
            #
    }
        #
    method get_dimensionType {} {
        return {angle}
    }
        #
}


namespace eval cad4tcl {oo::class create RadiusDimension}
    #
oo::define cad4tcl::RadiusDimension {
        #
    superclass cad4tcl::_Dimension
        #
    variable _parentCanvas              ;# the canvas, the dimension is created
    variable _canvasRegistryNode        ;# the node in the cadCanvas registry
    variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
    variable _textTag                   ;# contains the tag of the dimensiontext
    variable _fontSize                  ;# fontsize of dimension text
    variable _lineWidth                 ;# lione width of dimension
    variable _editTag                   ;# contains the tag of the sensitive dimension area
        #
    constructor {cvObj  itemIF  p_Coords  dimDistance  {textOffset 0}  {colour black}} {
            #
        # puts "            -> class AngleDimension"
            #
        variable cvObject       $cvObj
            #
        variable ItemInterface  $itemIF
            #
        variable _parentCanvas              ;# the canvas, the dimension is created
        variable _canvasRegistryNode        ;# the node in the cadCanvas registry
        variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
        variable _textTag                   ;# contains the tag of the dimensiontext
        variable _fontSize                  ;# fontsize of dimension text
        variable _lineWidth                 ;# lione width of dimension
        variable _editTag                   ;# contains the tag of the sensitive dimension area
            #
            #
        my setCanvasSettings
            #
        set _dimensionTag   _empty_    
        set _editTag        _empty_
            #
            # set returnValues    [my createObject  $p_Coords  $dimDistance  $textOffset  $colour]    
        set returnValues    [my createObject  $p_Coords  $dimDistance  $textOffset  $colour]    
            #
            # puts "     -> \$returnValues $returnValues"    
            #
        set _dimensionTag   [lindex $returnValues 0]
        set _textTag        [lindex $returnValues 1]
            #
            # my fit2Canvas  
            #
        set w $_parentCanvas
        $w addtag {__Content__}     withtag $_dimensionTag
        $w addtag {__Dimension__}   withtag $_dimensionTag
            #
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cad4tcl::RadiusDimension $target_method $args  ... unknown"
    }
        #
    method createObject {p_Coords  dimDistAngle {textOffset 0} {colour black}} {
            #
        variable cvObject        
            #    
        set w           [$cvObject configure    Canvas  Path]
        set fontSize    [$cvObject configure    Style   Fontsize]
        set stageScale  [$cvObject configure    Stage   Scale]
            #
            # puts "      \$w             $w"
            # puts "      \$fontSize      $fontSize"
            # puts "      \$stageScale    $stageScale"
            #
        set checkLength [expr {(1 + 2 * $fontSize) / $stageScale}]
            #
        set p0    [list [lindex $p_Coords 0] [lindex $p_Coords 1]]
        set p1    [list [lindex $p_Coords 2] [lindex $p_Coords 3]]
            #
            # -------------------------------
            # ceck $w
        if { $w == {} } { 
            error "cad4tcl::RadiusDimension -> Error:  could not get \$w" 
        }
            #
            # -------------------------------
            # correct in case of {} parameters ... execution through cad4tcl::dimension
        if {$textOffset == {}} {set textOffset  0}
        if {$colour     == {}} {set colour      black}
            #
            # -------------------------------
            # reset item container
        set itemList    {}
            # set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
            # $w dtag  $tagListName all

            # -------------------------------
            # set helpline parameters
        set p_hl_dim_p0     $p0
        set p_hl_dim_p1     [vectormath::rotatePoint    $p0     $p1  $dimDistAngle ]
        set textAngle       [vectormath::dirAngle       $p0     $p_hl_dim_p1] 
        set textPosAngle    [expr {$textAngle - 90}]
        set dimLength       [vectormath::length         $p0     $p1]

            # -------------------------------
            # dimension line ends
        if {$dimLength > $checkLength} {
            set myEnd [my createLineEnd_2   $p_hl_dim_p1  $textAngle  $colour  {outside}]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
        } else {
            set myEnd [my createLineEnd_2   $p_hl_dim_p1  $textAngle  $colour ]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
        }

            # -------------------------------
            # line extension on offset 
        if { $textOffset != 0 } {
            set extLength       [expr {1.5 * $fontSize / $stageScale}]
            set offsetAngle     $textAngle 
            set refLength       [expr {$dimLength / 2}]
            set lineCenter      [vectormath::center     $p_hl_dim_p0 $p_hl_dim_p1 ]
            set offsetPoint     [vectormath::rotateLine $lineCenter     [expr {$textOffset / $stageScale}]   $offsetAngle]
            set offsetPoint_0   [vectormath::rotateLine $offsetPoint    $extLength  [expr {180 + $offsetAngle}]]
            set offsetPoint_1   [vectormath::rotateLine $offsetPoint    $extLength               $offsetAngle]
            
            set offsetLength_0  [vectormath::length $lineCenter $offsetPoint_0]
            set offsetLength_1  [vectormath::length $lineCenter $offsetPoint_1]
            
            if { $offsetLength_0 > $offsetLength_1 } {
                if { $offsetLength_0 > $refLength } { 
                        # puts "        $offsetLength_0 > $offsetLength_1"
                        # puts "        $offsetLength_0"
                        # puts "        $refLength"
                    set p_hl_dim_p0 $offsetPoint_0 
                } 
            } else {
                if { $offsetLength_1 > $refLength } { 
                        # puts "        $offsetLength_0 < $offsetLength_1"
                        # puts "        $offsetLength_1"
                        # puts "        $refLength"
                    set p_hl_dim_p1 $offsetPoint_1 
                } 
            }
                #
                # --- debug in graphic
                #
            if 0 {
                set myBase      [my createPoint $textPosition  1  darkgray]
                lappend itemList $myBase
                    # $w addtag $tagListName withtag $myBase
                set myBase      [my createPoint $offsetPoint  1  orange]
                lappend itemList $myBase
                    # $w addtag $tagListName withtag $myBase
                set myBase      [my createPoint $p_hl_dim_p0  1  red]
                lappend itemList $myBase
                    # $w addtag $tagListName withtag $myBase
                set myBase      [my createPoint $p_hl_dim_p1  1  blue]
                lappend itemList $myBase
                    # $w addtag $tagListName withtag $myBase
                set myBase      [my createPoint $offsetPoint_0  1  gray80]
                lappend itemList $myBase
                    # $w addtag $tagListName withtag $myBase
                set myBase      [my createPoint $offsetPoint_1  1  gray50]
                lappend itemList $myBase
                    # $w addtag $tagListName withtag $myBase
            }
        }
        
            # -------------------------------
            # dimension line
        set myLine [my createLine_2             $p_hl_dim_p0  $p_hl_dim_p1  $colour ]
        lappend itemList $myLine
                # $w addtag $tagListName withtag $myLine
                        
            # -------------------------------
            # helpline arc
        set angle_p1    [vectormath::dirAngle   $p0 $p1]
        set arcAngle    [vectormath::angle      $p_hl_dim_p1 $p0 $p1]
        set angle_p1_h  [expr {$angle_p1 + $arcAngle}]
        set arcRadius   $dimLength

            # gap to helpline 
        set asinParameter   [expr {2.0 / ($stageScale * $arcRadius)}]
        set gapAngle        [expr {asin($asinParameter) * 180 / $vectormath::CONST_PI}]
        
        if { $dimDistAngle > 0 } { 
            set angle_p1    [expr {$angle_p1 + $gapAngle}]
        } else {
            set angle_p1    [expr {$angle_p1 - $arcAngle}]
            set arcAngle    [expr {$arcAngle - $gapAngle}]
        }

        if { [expr {$angle_p1_h - $angle_p1}] > 360} {
                # puts "    $checkValue "
            set myArc [createArc            $p0  $arcRadius  0 359.999  $colour]
            lappend itemList $myArc
                # $w addtag $tagListName withtag $myArc 
        } else {
            if {$arcAngle > 0.5 } { # check for clean vizualisation of arc
                if {[expr {$angle_p1 + $dimDistAngle}] < 360} {
                        # puts "    $checkValue  $dimDistAngle"
                    set myArc [my createArc_2   $p0  $arcRadius  $angle_p1 $arcAngle  $colour]
                    lappend itemList $myArc
                        # $w addtag $tagListName withtag $myArc 
                } else {
                        # puts "    $checkValue  $dimDistAngle"
                    set myArc [my createArc_2   $p0  $arcRadius  $angle_p1 $arcAngle  $colour]
                    lappend itemList $myArc
                        # $w addtag $tagListName withtag $myArc 
                    set myArc [my createArc_2   $p0  $arcRadius  0         [expr {$angle_p1 + $arcAngle - 360}]  $colour ]
                    lappend itemList $myArc
                        # $w addtag $tagListName withtag $myArc 
                }
            } else { 
                #puts "   -> break" 
            }
        }

            # -------------------------------
            # text position
        set textPosition    [vectormath::center         $p_hl_dim_p0  $p_hl_dim_p1]  
        set textPosition    [vectormath::rotateLine     $textPosition  [expr {$textOffset / $stageScale}] $textAngle]
            #
            #  ---------------------------------------------
            # create text
            # set myItem [my createPoint_2 $textPosition 2 red]
            # lappend itemList $myItem    
            
        set myText [my createText_2 $dimLength  {}  $textPosition  $textPosAngle  $colour ]
        $w itemconfigure $myText -tags [list $myText __DimensionText__]
        lappend itemList $myText
                # puts "[$w itemconfigure $myText]"
                # $w addtag $tagListName withtag $myText

            #  ---------------------------------------------
            #  sum up and return
                # $w addtag $tagListName withtag $myBase
                # $w addtag $tagListName withtag $myHelp
                # $w addtag $tagListName withtag $myPos
                # $w move {myArc} 30 0
            #
            # -------------------------------
            # reset item container
        set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
        $w dtag  $tagListName all
        foreach item $itemList {
            $w addtag $tagListName withtag $item
        }
            #
            # -------------------------------
            # 
        return [list $tagListName $myText]
            #
    }
        #
    method get_dimensionType {} {
        return {radius}
    }
        #
}


namespace eval cad4tcl {oo::class create LengthDimension}
    #
oo::define cad4tcl::LengthDimension {
        #
    superclass cad4tcl::_Dimension
        #
    variable _parentCanvas              ;# the canvas, the dimension is created
    variable _canvasRegistryNode        ;# the node in the cadCanvas registry
    variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
    variable _textTag                   ;# contains the tag of the dimensiontext
    variable _fontSize                  ;# fontsize of dimension text
    variable _lineWidth                 ;# lione width of dimension
    variable _editTag                   ;# contains the tag of the sensitive dimension area
        #
    constructor {cvObj  itemIF  p_Coords  dimOrientation  dimDistance  {textOffset 0}  {colour black}} {
            #
        # puts "            -> class AngleDimension"
            #
        variable cvObject       $cvObj
            #
        variable ItemInterface  $itemIF
            #
        variable _parentCanvas              ;# the canvas, the dimension is created
        variable _canvasRegistryNode        ;# the node in the cadCanvas registry
        variable _dimensionTag              ;# name of taglist containing all canvas elements of this dimension
        variable _textTag                   ;# contains the tag of the dimensiontext
        variable _fontSize                  ;# fontsize of dimension text
        variable _lineWidth                 ;# lione width of dimension
        variable _editTag                   ;# contains the tag of the sensitive dimension area
            #
            #
        my setCanvasSettings
            #
        set _dimensionTag   _empty_    
        set _editTag        _empty_
            #
            # set returnValues    [my createObject  $p_Coords  $dimDistance  $textOffset  $colour]    
        set returnValues    [my createObject    $p_Coords  $dimOrientation  $dimDistance  $textOffset  $colour]    
            #
            # puts "     -> \$returnValues $returnValues"    
            #
        set _dimensionTag   [lindex $returnValues 0]
        set _textTag        [lindex $returnValues 1]
            #
            # my fit2Canvas  
            #
        set w $_parentCanvas
        $w addtag {__Content__}     withtag $_dimensionTag
        $w addtag {__Dimension__}   withtag $_dimensionTag
            #
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cad4tcl::LengthDimension $target_method $args  ... unknown"
    }
        #
    method createObject {p_Coords  dimOrientation dimDistance {textOffset 0} {colour black}} {
            #
        variable cvObject        
            #    
        set w           [$cvObject configure    Canvas  Path]
        set fontSize    [$cvObject configure    Style   Fontsize]
        set stageScale  [$cvObject configure    Stage   Scale]
            #
            # puts "      \$w             $w"
            # puts "      \$fontSize      $fontSize"
            # puts "      \$stageScale    $stageScale"
            #    
        set checkLength [expr {(1 + 2 * $fontSize) / $stageScale}]
            #
            # -------------------------------
            # ceck $w
        if { $w == {} } { 
            error "cad4tcl::LengthDimension -> Error:  could not get \$w" 
        }
        
            # -------------------------------
            # correct in case of {} parameters ... execution through cad4tcl::dimension
        if {$textOffset == {}} { set textOffset 0}
        if {$colour     == {}} { set colour     black}
            #
        set textOffset [expr {$textOffset / $stageScale}]
            #
            # -------------------------------
            # reset item container
        set itemList    {}
            #
            # -------------------------------
            # set type exceptions
        switch $dimOrientation {
            aligned {
                set p1          [list [lindex $p_Coords 0] [lindex $p_Coords 1]]
                set p2          [list [lindex $p_Coords 2] [lindex $p_Coords 3]]
                set p_start     $p1
                set p_end       $p2
            }
            horizontal {
                set p1          [list [lindex $p_Coords 0] [lindex $p_Coords 1]]
                set p2          [list [lindex $p_Coords 2] [lindex $p_Coords 3]]
                set p_start     $p1
                set p_end       [list [lindex $p2 0] [lindex $p1 1]]
            }
            vertical {
                set p1          [list [lindex $p_Coords 0] [lindex $p_Coords 1]]
                set p2          [list [lindex $p_Coords 2] [lindex $p_Coords 3]]
                set p_start     $p1
                set p_end       [list [lindex $p1 0] [lindex $p2 1] ]
            }
            perpendicular { # dimension line through p0 & p1 perpendicular through p2 , p0 as direction ref
                set p0          [list [lindex $p_Coords 0] [lindex $p_Coords 1]]
                set p1          [list [lindex $p_Coords 2] [lindex $p_Coords 3]]
                set p2          [list [lindex $p_Coords 4] [lindex $p_Coords 5]]
                set p_start     $p1
                set p_isect     [vectormath::intersectPerp  $p0 $p1 $p2]
                set p1_aln_vct  [vectormath::subVector      $p1 $p_isect]
                set p_end       [vectormath::addVector      $p2 $p1_aln_vct]
                set perpAngle   [vectormath::dirAngle_Coincidence $p_start $p_end  0.0001 $p0] 
                set dimPerp     [vectormath::length         $p_start $p_end]
                set dimDir      [vectormath::VRotate        $p1_aln_vct 90]
            }                  
        }
            #
            # -------------------------------
            # set helpline parameters
        set dimDistance     [expr {$dimDistance / $stageScale}]
        set textAngle       [vectormath::dirAngle   $p_start    $p_end]
        if {$dimOrientation == {perpendicular}} {
            set textAngle   $perpAngle
        }
        set textPosAngle    [expr {$textAngle - 90}]
        set dimLength       [vectormath::length     $p_start    $p_end]
        set p_hl_dim_p1     [vectormath::rotateLine $p_start    $dimDistance    $textPosAngle ]
        set p_hl_dim_p2     [vectormath::rotateLine $p_end      $dimDistance    $textPosAngle ]
            #
            # -------------------------------
            # define start position of helplines, in case of p_hl_dim_p? orientation
        set p_hl_p1         [vectormath::addVector  $p_start    [vectormath::unifyVector $p_start   $p_hl_dim_p1 ] [expr {2 / $stageScale}]]
        set p_hl_p2         [vectormath::addVector  $p2         [vectormath::unifyVector $p2        $p_hl_dim_p2 ] [expr {2 / $stageScale}]]
            # set p_hl_p1         [::math::geometry::movePointInDirection  $p_start    [::math::geometry::angle [join "$p_start $p_hl_dim_p1" " "]] [expr {2 / $stageScale}]]
            # set p_hl_p2         [::math::geometry::movePointInDirection  $p2         [::math::geometry::angle [join "$p2      $p_hl_dim_p2" " "]] [expr {2 / $stageScale}]]
            # puts " ------ Dimension: $p_hl_p1 $p_hl_p2"
            
            # p_hl_p1         [::math::geometry::+  $p_start    [vectormath::unifyVector $p_start   $p_hl_dim_p1 [expr {2 / $stageScale}]]]
            # p_hl_p2         [::math::geometry::+  $p2         [vectormath::unifyVector $p2        $p_hl_dim_p2 [expr {2 / $stageScale}]]]
            # puts " ------ Dimension: $p_hl_p1 $p_hl_p2"
            # p_hl_p1       [vectormath::addVector  $p_start    [vectormath::unifyVector $p_start   $p_hl_dim_p1 [expr {2 / $stageScale}]]]
            # p_hl_p2       [vectormath::addVector  $p2         [vectormath::unifyVector $p2        $p_hl_dim_p2 [expr {2 / $stageScale}]]]
            # p_hl_p1       [vectormath::addVector  $p_start    [vectormath::unifyVector $p_start   $p_hl_dim_p1 ] [expr {2 / $stageScale}]]
            # p_hl_p2       [vectormath::addVector  $p2         [vectormath::unifyVector $p2        $p_hl_dim_p2 ] [expr {2 / $stageScale}]]

            # -------------------------------
            # first debug
                # puts "  dimension::length     $p1  $p2  $textAngle  $textPosAngle  $textOffset  $colour "
        
            # -------------------------------
            # dimension help lines - createLine
            # puts "\n--helpLines---------------"
        set myLine [my createLine_2         $p_hl_p1  $p_hl_dim_p1  $colour]
        lappend itemList $myLine
            # $w addtag $tagListName withtag $myLine
        set myLine [my createLine_2         $p_hl_p2  $p_hl_dim_p2  $colour]
        lappend itemList $myLine
            # $w addtag $tagListName withtag $myLine 
        
            # -------------------------------
            # dimension line ends
        if { $dimLength > $checkLength } {
            set myEnd [my createLineEnd_2    $p_hl_dim_p1  $textAngle  $colour]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
            set myEnd [my createLineEnd_2    $p_hl_dim_p2  [expr {180 + $textAngle}]  $colour]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
        } else {
            set myEnd [my createLineEnd_2    $p_hl_dim_p1  $textAngle  $colour  {outside}]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
            set myEnd [my createLineEnd_2    $p_hl_dim_p2  [expr {180 + $textAngle}]  $colour  {outside}]
            lappend itemList $myEnd
                # $w addtag $tagListName withtag $myEnd
        }
            #
            # -------------------------------
            # line extension on offset 
        if { $textOffset != 0 } {
            set extLength       [expr {1.5 * $fontSize / $stageScale}]
            set offsetAngle     [expr {180 + $textAngle}] 
            set offsetLength_1  [expr {$extLength + $textOffset}]
            set offsetLength_2  [expr {$extLength - $textOffset}]
            set refLength       [expr {$dimLength / 2}]
            set lineCenter      [vectormath::center $p_hl_dim_p1 $p_hl_dim_p2]
                # puts "     -> refLength       $refLength"
                # puts "     -> offsetLength_1      $offsetLength_1"
                # puts "     -> offsetLength_2      $offsetLength_2"

            set offsetPoint     [vectormath::rotateLine $lineCenter     $textOffset $offsetAngle]
            set offsetPoint_1   [vectormath::rotateLine $offsetPoint    $extLength  $offsetAngle]
            set offsetPoint_2   [vectormath::rotateLine $offsetPoint    $extLength  [expr {180 + $offsetAngle}]]
            if { $textOffset > 0 } {
                if {[expr {abs($offsetLength_1)}] > $refLength } {set p_hl_dim_p1 $offsetPoint_1}
            } else {
                if {[expr {abs($offsetLength_2)}] > $refLength } {set p_hl_dim_p2 $offsetPoint_2}
            }
            # --- debug in graphic
                # set myOffSet  [ vectormath::rotateLine  $lineCenter   $textOffset     $offsetAngle ]
                # set myBase        [my createPoint  $cv_Dimension  $offsetPoint  1  orange]
                #   $w addtag $tagListName withtag $myBase
                # set myBase        [my createPoint  $cv_Dimension  $p_hl_dim_p1  1  red]
                #   $w addtag $tagListName withtag $myBase
                # set myBase        [my createPoint  $cv_Dimension  $p_hl_dim_p2  1  blue]
                #   $w addtag $tagListName withtag $myBase
        }
            #       
            # -------------------------------
            # dimension line
            # puts "\n--dimLine---------------"
        set myLine          [my createLine_2        $p_hl_dim_p1  $p_hl_dim_p2  $colour ]
        lappend itemList $myLine
            # $w addtag $tagListName withtag $myLine
            # 
            # puts " -> \$p_Coords $p_Coords"
            # puts "        -> help $p_hl_dim_p1  $p_hl_dim_p2"
            # puts "        -> \$p_Coords $p_Coords"
            # variable cvObject
            # variable ItemInterface
            # set aItem [$ItemInterface create line $p_Coords [list -fill red]]
            # lappend itemList $aItem
            # puts "        -> [$cvObject gettags $aItem]"
        
            # -------------------------------
            # text position
        set textPosition    [vectormath::center     $p_hl_dim_p1   $p_hl_dim_p2]  
        set textPosition    [vectormath::rotateLine $textPosition  $textOffset [expr {180 + $textAngle}]]
            # set textPosition  [ vectormath::rotateLine  $textPosition  [expr $textOffset/$stageScale]  [expr 180 + $textAngle ] ]
        
            #  ---------------------------------------------
            # create text
            # set myItem [my createPoint_2 $textPosition $fontSize red]
            # lappend itemList $myItem    
            
        set myText [my createText_2 $dimLength  {}  $textPosition  $textPosAngle  $colour]
        $w itemconfigure $myText -tags [list $myText __DimensionText__]
        lappend itemList $myText
            
            # -------------------------------
            # reset item container
        set tagListName [format "dimGroup_%s" [llength [$w find withtag all]] ]
        $w dtag  $tagListName all
        foreach item $itemList {
            $w addtag $tagListName withtag $item
        }
        
        
            # return $myEdit
                #
            # puts "   length ->  $w"    
            # puts "   length ->  $tagListName"    
            # puts "   length ->     $myEnd"    
            # puts "   length ->     $myLine"    
            # puts "   length ->     $myText"    
            # puts "   length ->  [$w gettags $tagListName]"
            # puts "   length ->     $itemList"
            # puts "   length ->  [$w find withtag dimGroup_64]"
            # puts "  ---------------------- "
            #
            
            # -------------------------------
            # 
        return [list $tagListName $myText]
            #
    }
        
        #
    method get_dimensionType {} {
        return {length}
    }
        #
}


