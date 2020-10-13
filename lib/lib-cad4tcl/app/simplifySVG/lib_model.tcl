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
  
namespace eval cad4tcl::app::simplifySVG::model {
      
    # --------------------------------------------
        # Export as global command
    variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
    
    # --------------------------------------------
    #  create base config 
    #       -> registryDOM
    variable min_SegmentLength  0.4
    variable fillGeometry       {gray80}
    variable centerNode         {}
    variable trashNode          {}
    variable svg_LastHighlight  {}
    variable free_ObjectID      0
    variable file_saveCount     0
    variable tmpSVG             [dom parse "<root/>"]
    variable my_Center_Object   {}
    variable fitVector          {0 0 1}
    variable svgPrecision       1
        #
    variable CONST_PI           [expr 4*atan(1)]        
        #
    variable templateSVG \
           {<?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
            <svg width="297mm" height="210mm" viewBox="0 0 297 210">
            <defs>
            </defs>
            </svg>} 
    variable templateSVG \
           {<?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
            <svg width="420mm" height="297mm" viewBox="-210 -148.5 420 297">
            <defs>
            </defs>
            </svg>} 
}

    
# -- procedures from: canvasCAD	->	vectormath.tcl
# 
proc cad4tcl::app::simplifySVG::model::pointDistance { p1 p2 } { 
    # distance from  p1  to  p2 
    set vector [ subVector $p2 $p1 ]
    set length [ expr hypot([lindex $vector 0],[lindex $vector 1]) ] 
    return $length
}
proc cad4tcl::app::simplifySVG::model::addVector {v1 v2 {scaling 1}} {
    foreach {x1 y1} $v1 {x2 y2} $v2 break
    return [list [expr {$x1 + $scaling*$x2}] [expr {$y1 + $scaling*$y2}]]
}	 
proc cad4tcl::app::simplifySVG::model::subVector {v1 v2} { return [addVector $v1 $v2 -1] }
#
# ----------------------------------------------

proc cad4tcl::app::simplifySVG::model::simplifySVG {domSVG {parentTransform {1 0 0 1 0 0}}} {
    
    puts "\n"
    puts "  =============================================="
    puts "   -- simplifySVG"
    puts "  =============================================="
    puts "\n"

                
    variable detailText
    variable min_SegmentLength
    variable templateSVG
    variable flatSVG
    variable fillGeometry
    variable free_ObjectID
    variable trashNode
    
    set fillGeometry {gray80}
                
        # puts [$targetNode asXML]

        # puts "  ... [ $flatSVG::model asXML]\n"
    set flatSVG     [dom parse $templateSVG] 
    set root        [$flatSVG documentElement]
        # puts "  ... [ $root asXML]\n"
        
        #
        #
    set trashNode   [$root appendXML "<g id=\"trashNode_001\"></g>"]
    set trashNode   [$root find id trashNode_001]
        # puts "[$trashNode asXML]"
        # exit
        #
            #
    set svgOrigin {0 0}
    set nodeOrigin [$domSVG selectNodes "//*\[@id=\"center_00\"\]"]
        # set docSVG [$domSVG ownerDocument]
        # set nodeOrigin [$docSVG selectNodes "//*\[@id=\"center_00\"\]"]
        # set nodeOrigin [$domSVG getElementById {center_00}] ;# does not work
        # puts "   \$nodeOrigin >[$nodeOrigin asXML]<"
    if {$nodeOrigin != {}} {
        puts "   -> tagName <[$domSVG tagName]>"
        puts "   \$nodeOrigin [$nodeOrigin asXML]"
        # tk_messageBox -message "[$nodeOrigin asXML]"
        set dx [expr -1.0 * [$nodeOrigin getAttribute cx]]
        set dy [expr -1.0 * [$nodeOrigin getAttribute cy]]
        set transform [lrange $parentTransform 0 3]
        lappend transform $dx $dy
        set parentTransform $transform
    }
    # exit    
        
        
        #
    foreach node    [$domSVG childNodes] {
        add_SVGNode $node $root $parentTransform
    }
        #               
        
        #
    return $root
        #
}

proc cad4tcl::app::simplifySVG::model::setPrecision {{value {}}} {
    variable svgPrecision
    if {$value eq {}} {
        return $svgPrecision
    }
    if {[string is double -strict $value]} {
        set svgPrecision $value
    }
    return $svgPrecision
}

proc cad4tcl::app::simplifySVG::model::flatten_nestedList { args } {
    if {[llength $args] == 0 } { return ""}
    set flatList {}
    foreach e [eval concat $args] {
        foreach ee $e { lappend flatList $ee }
    }
        # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
    return $flatList
}

proc cad4tcl::app::simplifySVG::model::get_ObjectID {} {
    variable free_ObjectID
    incr free_ObjectID
    return [format "simplify_%s" $free_ObjectID]
}


proc cad4tcl::app::simplifySVG::model::mirrorPoint {p a} {
    # reflects point p on line {{0 0} a}

    foreach {px py} $p  {ax ay} $a  break;

    if {$px == $ax && $py == $ay} {
        # return empty an handle on calling position if points are coincindent
        # puts "  .. hot wos";
        return {}
    }
    
    
    variable CONST_PI
        # puts "\n       ... start:      0 / 0  --   --  $px / $py  --  $ax / $ay"


    set alpha [expr atan2($ay,$ax)]
        # puts "       ... \$alpha $alpha   [expr $alpha * 180 / $CONST_PI]"
    

    set beta [expr atan2($py,$px)]
        # puts "       ... \$beta  $beta    [expr $beta * 180 / $CONST_PI]"


        # -- angular gap of a and p
    set delta [expr 1.0*$beta - $alpha]
        # puts "       ... \$delta $delta    [expr $delta  * 180 / $CONST_PI]"    


        # -- rotation mirrored point p
    set gamma [expr -2.0*$delta]
        # puts "       ... \$gamma $gamma    [expr $gamma  * 180 / $CONST_PI]"


        # -- new temporary position of p
        # puts "       ... temporary:  $px $py _____________________________"
    set xx [ expr hypot($px,$py) * cos($beta + $gamma) ]
    set yy [ expr hypot($px,$py) * sin($beta + $gamma) ]

    
        # puts "       ... temporary:  $xx $yy _____________________________"


    # -- new position of p
    set x [expr $ax - $xx]
    set y [expr $ay - $yy]
        # puts "       ... result:      $x $y"
    
        # puts "\n       ... start:      0 0  --  $x $y  --  $px $py  --  $ax $ay"
    return [list $x $y]                                        
}	


proc cad4tcl::app::simplifySVG::model::filterList {inputList {filter {}}} {
    set returnList {}
    foreach value $inputList {
      if {$value == $filter} {continue}
      set value     [string trim $value]
      set pointList [lappend returnList $value]
    }
    return $returnList
}   


proc cad4tcl::app::simplifySVG::model::copyAttribute {node attributeName {targetNode {}}} {
    if {[$node hasAttribute $attributeName]} {
          # puts "       [$node asXML]"
        set attributeValue [$node getAttribute $attributeName]
        if {$targetNode != {}} {  
           $targetNode setAttribute $attributeName [$node getAttribute $attributeName]
        }
        return $attributeValue
    }
}   


proc cad4tcl::app::simplifySVG::model::update_Attributes {sourceNode targetNode} {
    variable svgID
    incr svgID
    if {[$sourceNode hasAttribute id]} {
        $targetNode setAttribute id [$sourceNode getAttribute id]
    } else {
        $targetNode setAttribute id [format "simplify_SVG__%06i" $svgID]
    }
    foreach attr [$sourceNode attributes] {
        if {$attr == {id}} continue
        $targetNode setAttribute $attr [$sourceNode getAttribute $attr]
    }
}        


proc cad4tcl::app::simplifySVG::model::unifyTransform {node} {
    
      # set constant Value
    variable CONST_PI
    variable svgPrecision
    
      # -- default Value
    set precisionScale  [expr 1.0 / $svgPrecision]
    set transformMatrix [list $precisionScale 0 0 $precisionScale 0 0]
    set translateMatrix {1 0 0 1 0 0}
    set transformArg {}
    
      # -- get transform Information
    if {[catch {set transformArg  [$node getAttribute transform]} eID]} {
        #return $matrix
        set transformType {__default__}
    } else {
        # puts "      -> $transformArg"
        set transformType  [lindex [split $transformArg (]  0]
        set transformValue [lindex [split $transformArg ()] 1]
        # puts "      --> \$transformType   $transformType"
        # puts "      --> \$transformValue  $transformValue"
        if {[string first {,} $transformValue] > 0} {
            set transformValue [string map {, { }} $transformValue]
        }
    }
    
    
      # -- define the unified translation matrix 
      #  from http://de.wikibooks.org/wiki/SVG/_Transformationen
      #
    set x [copyAttribute  $node  x]
    set y [copyAttribute  $node  y]
    if {$x != {}} {
        if {$y != {}} {
            set translateMatrix [list 1 0 0 1 $x $y]
        } else {
            set translateMatrix [list 1 0 0 1 $x 0]
        }
    }
      
      
      # -- define the unified transform matrix 
      #  from http://de.wikibooks.org/wiki/SVG/_Transformationen
      #  
    switch -exact $transformType {
        matrix {
            set transformMatrix $transformValue
        }
        translate {
              # puts "  ---> \$transformValue $transformValue"
            if {[llength $transformValue] == 1} {
                set translateMatrix [list 1 0 0 1 $transformValue 0]
            } else {
                set translateMatrix [list 1 0 0 1 [lindex $transformValue 0] [lindex $transformValue 1]]
            }                
        }
        scale {
            if {[llength $transformValue] == 1} {
                set transformMatrix [list [lindex $transformValue 0] 0 0 [lindex $transformValue 0] 0 0]
            } else {
                set transformMatrix [list [lindex $transformValue 0] 0 0 [lindex $transformValue 1] 0 0]
            }
        }
        rotate {
            set angleRad [expr -1.0*$transformValue*$CONST_PI/180]
            set transformMatrix [list [expr cos($angleRad)] [expr -1.0*sin($angleRad)] \
                                    [expr sin($angleRad)] [expr cos($angleRad)] \
                                    0 0]
        }
        skewX {
            set angleRad [expr $transformValue*$CONST_PI/180]
            set transformMatrix [list 1 0 \
                                    [expr tan($angleRad)] 1 \
                                    0 0]       
        }
        skewY {
              set angleRad [expr $transformValue*$CONST_PI/180]
              set transformMatrix [list 1 [expr tan($angleRad)] \
                                        0 1 \
                                        0 0]       
        }
        __default__ -
        default {

        }
    }

      # puts "  ---> \$transformMatrix $transformMatrix"
      # puts "  ---> \$translateMatrix $translateMatrix"

    return [list $translateMatrix $transformMatrix $transformType]
}    


proc cad4tcl::app::simplifySVG::model::matrixTransform {valueList matrix} {
    
        #
        #  -- the art of handling the transform matrix in SVG
        #           got it from here: http://commons.oreilly.com/wiki/index.php/SVG_Essentials/Matrix_Algebra
        #       | a  c  tx |                    | a*x  c*y  tx*1 |  -> x
        #       | b  d  ty |  *  |x  y  1|  =   | b*x  d*y  ty*1 |  -> y
        #       | 0  0   1 |                    | 0*x  0*y   1*1 |  -> z (not interesting in a 2D)   
        #
        # puts "    transform_SVGObject: $matrix"
    
    variable svgPrecision
    
    set valueList_Return {}
        
    foreach {a b c d e f} $matrix break

    foreach {x y} $valueList {
        set x [expr 1.0 * $x]
        set y [expr 1.0 * $y]
            # puts "\n--------------------"
            # puts "       -> $x $y"
        set new_x [ expr $a*$x + $c*$y + $e ]
        set new_y [ expr $b*$x + $d*$y + $f ]
            # puts "          x/y:  $x / $y"
            # puts "          a/b -> xt:  $a / $b -> $new_x"
            # puts "          c/d -> yt:  $c / $d -> $new_y"
        set valueList_Return [lappend valueList_Return $new_x $new_y ]
    }
    return $valueList_Return
}



proc cad4tcl::app::simplifySVG::model::Bezier {xy {PRECISION 10}} {
            # puts "           -> $xy"
        set PRECISION 8
        set np [expr {[llength $xy] / 2}]
        if {$np < 4} return
        
        set idx 0
        foreach {x y} $xy {
        set X($idx) $x
        set Y($idx) $y
        incr idx
        }

        set xy {}

        set idx 0
        while {[expr {$idx+4}] <= $np} {
            set a [list $X($idx) $Y($idx)]; incr idx
            set b [list $X($idx) $Y($idx)]; incr idx
            set c [list $X($idx) $Y($idx)]; incr idx
            set d [list $X($idx) $Y($idx)];# incr idx   ;# use last pt as 1st pt of next segment
            for {set j 0} {$j <= $PRECISION} {incr j} {
                set mu [expr {double($j) / double($PRECISION)}]
                set pt [BezierSpline $a $b $c $d $mu]
                lappend xy [lindex $pt 0] [lindex $pt 1]
            }
        }
            # puts "             -> $xy"
        return $xy
}

        proc cad4tcl::app::simplifySVG::model::BezierSpline {a b c d mu} {
                # --------------------------------------------------------
                # http://www.cubic.org/~submissive/sourcerer/bezier.htm
                # evaluate a point on a bezier-curve. mu goes from 0 to 1.0
                # --------------------------------------------------------

                set  ab   [Lerp $a    $b    $mu]
                set  bc   [Lerp $b    $c    $mu]
                set  cd   [Lerp $c    $d    $mu]
                set  abbc [Lerp $ab   $bc   $mu]
                set  bccd [Lerp $bc   $cd   $mu]
                return    [Lerp $abbc $bccd $mu]
        }

        proc cad4tcl::app::simplifySVG::model::Lerp {a b mu} {
                # -------------------------------------------------
                # http://www.cubic.org/~submissive/sourcerer/bezier.htm
                # simple linear interpolation between two points
                # -------------------------------------------------
                set ax [lindex $a 0]
                set ay [lindex $a 1]
                set bx [lindex $b 0]
                set by [lindex $b 1]
                return [list [expr {$ax + ($bx-$ax)*$mu}] [expr {$ay + ($by-$ay)*$mu}] ]
        }


proc cad4tcl::app::simplifySVG::model::check_pathValues {pathValueString} {

        # puts "\n  ==== check_pathValues_new ======"
        # puts "\n ---------"
        # puts "$pathValueString"
    set pathValueString   [string map { M { M }   Z { Z }   L { L }   H { H }   V { V }   C { C }   S { S }   Q { Q }   T { T }   A { A }  \
                                        m { m }   z { Z }   l { l }   h { h }   v { v }   c { c }   s { s }   q { q }   t { t }   a { a }  , { }  } \
                                    [string trim $pathValueString] ]
        # puts "\n ---------"
        # puts "$pathValueString"
    
    set valueList {}
    foreach value $pathValueString {
          # puts "       -> $xy"
        if {[string first {10e} $value] >= 0} {
                # ... sometimes the pathValueString contains values like: 10e-4
                # these values does not work in tcl
                # therfore
                # puts "           -> check:  $xy"
            set exponent [lindex [split $value e] 1]
            set value [expr 1.0 * pow(10,$exponent)]
        }
        lappend valueList $value
    }
    return $valueList
}


proc cad4tcl::app::simplifySVG::model::checkPoly__x {node} {
        #
    variable trashNode
        #
    # puts ""
    # puts "checkPoly__x:   -> [$node asXML]"
    # puts ""
        #
        # points="52.43729999999999,-32.5785"
        #
    set nodeName        [$node nodeName]
        # puts "   -> \$nodeName          $nodeName"
        #
    switch -exact $nodeName {
        polygon  -
        polyline {
            set pointAttribute  [$node getAttribute points]
                # puts "   -> \$pointAttribute    $pointAttribute"
            set pointCount      [llength $pointAttribute]
                # puts "   -> \$pointCount        $pointCount"
                #
            if {$pointCount > 1} {
                # puts "   -> \$node $node"
                return $node
            } else {
                # puts "   -> \$trashNode $trashNode"
                # puts "   -> \$node $node"
                $trashNode appendChild $node
                return {} 
            }
        }
        default {
            return $node
        }
    }
        #
}


proc cad4tcl::app::simplifySVG::model::format_absPath {pathDefinition {position {0 0}} } {

    set transform(x) [lindex $position 0]
    set transform(y) [lindex $position 1]
    
    set pathValueList [check_pathValues $pathDefinition]
        # puts "   001 ->\$pathValueList\n  $pathValueList"
        # puts "$pathDefList\n   ______pathDefList_____"
    
    
        #
    array \
        set penPosition    { x 0 \
                             y 0 }
                             
    
        # -- loop throug pathValueList
        #
    set pathValueList_abs     {}
    set listIndex            0
    while {$listIndex < [llength $pathValueList]} { 
            
            # -- get value at Position
                #
        set value [lindex $pathValueList $listIndex]
                        
            # -- get next Index
                #
        incr listIndex
            
            # -- check value on 
                #
        if {[checkControl $value]} {
                # puts "    ... $value"
            switch -exact $value {
                M {            # puts "    $value  ... implemented yet"
                    set pathValueList_abs        [lappend pathValueList_abs M]
                    foreach {x y} [lrange $pathValueList $listIndex end] {
                            # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                        if {[checkControl $x]} {break}                                
                        set penPosition(x)      $x    ; incr listIndex 
                        set penPosition(y)      $y    ; incr listIndex
                        #set penPosition(x)      [expr $x + $transform(x)]    ; incr listIndex 
                        #set penPosition(y)      [expr $y + $transform(y)]    ; incr listIndex
                        set pathValueList_abs    [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                                  
                    }
                    # set penPosition(x)       [expr [lindex $pathValueList $listIndex] + $transform(x)]    ; incr listIndex 
                    # set penPosition(y)       [expr [lindex $pathValueList $listIndex] + $transform(y)]    ; incr listIndex
                    # set pathValueList_abs    [lappend pathValueList_abs $value $penPosition(x) $penPosition(y)]
                }
                m {             # puts "    $value  ... implemented yet"
                    set pathValueList_abs        [lappend pathValueList_abs M]
                            # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                    foreach {x y} [lrange $pathValueList $listIndex end] {
                            # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                        if {[checkControl $x]} {break}                                
                        set penPosition(x)       [expr $x + $penPosition(x)]    ; incr listIndex 
                        set penPosition(y)       [expr $y + $penPosition(y)]    ; incr listIndex
                        set pathValueList_abs    [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                    }
                }
                l {     # puts "    $value  ... implemented yet"
                    set pathValueList_abs    [lappend pathValueList_abs L]
                            # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                    foreach {x y} [lrange $pathValueList $listIndex end] {
                            # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                        if {[checkControl $x]} {break}                                
                        set penPosition(x)       [expr $x + $penPosition(x)]    ; incr listIndex 
                        set penPosition(y)       [expr $y + $penPosition(y)]    ; incr listIndex
                        set pathValueList_abs    [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                    }
                }
                c {        # puts "    $value  ... implemented yet"
                    set pathValueList_abs        [lappend pathValueList_abs C]
                    set bezierIndex    0
                    foreach {x y} [lrange $pathValueList $listIndex end] {
                            # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                        if {[checkControl $x]} {break}
                        set ctrlPosition(x)      [expr $x + $penPosition(x)]    ; incr listIndex
                        set ctrlPosition(y)      [expr $y + $penPosition(y)]    ; incr listIndex
                        set pathValueList_abs    [lappend pathValueList_abs $ctrlPosition(x) $ctrlPosition(y)]
                        incr bezierIndex
                        if {$bezierIndex > 2} {
                            set penPosition(x)         $ctrlPosition(x) 
                            set penPosition(y)         $ctrlPosition(y)
                            set bezierIndex 0
                        }
                    }
                }
                h {        # puts "    $value  ... implemented yet"
                    set pathValueList_abs       [lappend pathValueList_abs L]
                    set x     [lindex $pathValueList $listIndex]
                    if {[checkControl $x]} {continue}
                    set penPosition(x)          [expr $x + $penPosition(x)]    ; incr listIndex
                    set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                }
                v {        # puts "    $value  ... implemented yet"
                    set pathValueList_abs       [lappend pathValueList_abs L]
                    set y     [lindex $pathValueList $listIndex]
                    if {[checkControl $y]} {continue}
                    set penPosition(y)          [expr $y + $penPosition(y)]    ; incr listIndex
                    set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                }
                L  {       # puts "    $value  ... implemented yet"
                    set pathValueList_abs       [lappend pathValueList_abs L]
                            # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                    foreach {x y} [lrange $pathValueList $listIndex end] {
                            # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                        if {[checkControl $x]} {break}                                
                        set penPosition(x)      $x    ; incr listIndex 
                        set penPosition(y)      $y    ; incr listIndex
                        # set penPosition(x)      [expr $x  + $transform(x)]    ; incr listIndex 
                        # set penPosition(y)      [expr $y  + $transform(y)]    ; incr listIndex
                        set pathValueList_abs   [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                        # puts "  [checkControl $x]
                    }
                }                    
                H {        # puts "    $value  ... implemented yet"
                    set pathValueList_abs       [lappend pathValueList_abs L]
                    set x     [lindex $pathValueList $listIndex]
                    if {[checkControl $x]} {continue}
                    set penPosition(x)          $x    ; incr listIndex
                    # set penPosition(x)          [expr $x  + $transform(x)]    ; incr listIndex
                    set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                }
                V {        # puts "    $value  ... implemented yet"
                    set pathValueList_abs       [lappend pathValueList_abs L]
                    set y     [lindex $pathValueList $listIndex]
                    if {[checkControl $y]} {continue}
                    set penPosition(y)          $y    ; incr listIndex
                    # set penPosition(y)          [expr $y  + $transform(y)]    ; incr listIndex
                    set pathValueList_abs       [lappend pathValueList_abs $penPosition(x) $penPosition(y)]
                }
                C {        # puts "    $value  ... implemented yet"
                    set pathValueList_abs       [lappend pathValueList_abs C]
                            # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                    foreach {x y} [lrange $pathValueList $listIndex end] {
                             # puts "          ... control: [checkControl $x]  ... $x $y  ";  
                        if {[checkControl $x]} {break}                                
                        set penPosition(x)      $x    ; incr listIndex 
                        set penPosition(y)      $y    ; incr listIndex
                        # set penPosition(x)      [expr $x + $transform(x)]    ; incr listIndex 
                        # set penPosition(y)      [expr $y + $transform(y)]    ; incr listIndex
                        set pathValueList_abs   [lappend pathValueList_abs $penPosition(x) $penPosition(y)]                        
                        # puts "  [checkControl $x]
                    }
                }                    
                S {       # puts "    $value  ... implemented yet"
                    set pathValueList_abs    [lappend pathValueList_abs C]
                            # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                    foreach {ctrl_x ctrl_y base_x base_y} [lrange $pathValueList $listIndex end] {
                                # puts " ... $listIndex"
                            if {[checkControl $ctrl_x]} {break}                           
                            if {[checkControl $base_x]} {break}                           
                            incr listIndex 4
                            set ctrl_dx  [expr $ctrl_x - $penPosition(x)]
                            set ctrl_dy  [expr $ctrl_y - $penPosition(y)]
                            set base_dx  [expr $base_x - $penPosition(x)]
                            set base_dy  [expr $base_y - $penPosition(y)]
                            
                            set ctrVector [ mirrorPoint [list $ctrl_dx $ctrl_dy] [list $base_dx $base_dy]] 
                                # puts "  ... ctrVector  $ctrVector"
                            set ctrl_1(x)      [expr $penPosition(x) + [lindex $ctrVector 0]]
                            set ctrl_1(y)      [expr $penPosition(y) + [lindex $ctrVector 1]]
                            set ctrl_2(x)      $ctrl_x
                            set ctrl_2(y)      $ctrl_y
                                # puts "     ---------------------------------------"
                                # puts "      $penPosition(x) $penPosition(y)"
                                # puts "      $ctrl_1(x) $ctrl_1(y)"
                                # puts "      $ctrl_2(x) $ctrl_2(y)"
                                # puts "      $base_x $base_y"
                            set penPosition(x) $base_x
                            set penPosition(y) $base_y
                            set pathValueList_abs [lappend pathValueList_abs $ctrl_1(x) $ctrl_1(y) $ctrl_2(x) $ctrl_2(y) $penPosition(x) $penPosition(y)]
                    }
                }
                s {       # puts "    $value  ... implemented yet"
                    set pathValueList_abs    [lappend pathValueList_abs C]
                            # puts "      $listIndex - [lindex $pathValueList $listIndex] "
                    foreach {ctrl_x ctrl_y base_x base_y} [lrange $pathValueList $listIndex end] {
                            # puts " ... $listIndex"
                        if {[checkControl $ctrl_x]} {break}                           
                        if {[checkControl $base_x]} {break}                           
                        incr listIndex 4
                        set ctrVector [ mirrorPoint [list $ctrl_x  $ctrl_y] [list $base_x $base_y]]                                     
                                # puts "  ... ctrVector  $ctrVector"
                        if {$ctrVector == {}} {
                            set pathValueList_abs    [lrange $pathValueList_abs 0 end-1]
                            set penPosition(x) [expr $penPosition(x) + $base_x]
                            set penPosition(y) [expr $penPosition(y) + $base_y]
                            set pathValueList_abs [lappend pathValueList_abs L $penPosition(x) $penPosition(y)]
                                # puts "   ... exception:  $pathValueList_abs"
                        } else {                                            
                            set ctrl_1(x)      [expr $penPosition(x) + [lindex $ctrVector 0]]
                            set ctrl_1(y)      [expr $penPosition(y) + [lindex $ctrVector 1]]
                            set ctrl_2(x)      [expr $penPosition(x) + $ctrl_x]
                            set ctrl_2(y)      [expr $penPosition(y) + $ctrl_y]
                            set base_2(x)      [expr $penPosition(x) + $base_x]
                            set base_2(y)      [expr $penPosition(y) + $base_y]
                                # puts "     ---------------------------------------"
                                # puts "      $penPosition(x) $penPosition(y)"
                                # puts "      $ctrl_1(x) $ctrl_1(y)"
                                # puts "      $ctrl_2(x) $ctrl_2(y)"
                                # puts "      $base_2(x) $base_2(y)"
                            set penPosition(x) [expr $penPosition(x) + $base_x]
                            set penPosition(y) [expr $penPosition(y) + $base_y]
                            set pathValueList_abs [lappend pathValueList_abs $ctrl_1(x) $ctrl_1(y) $ctrl_2(x) $ctrl_2(y) $penPosition(x) $penPosition(y)]
                        }
                    }
                }
                Q -
                T -
                A -
                q -
                t -
                a {
                        # incr listIndex
                    puts "    $value  ... not implemented yet  - $listIndex"
                }
                Z -
                z {
                        # puts "    $value  ... implemented yet  - $listIndex" 
                    set pathValueList_abs    [lappend pathValueList_abs Z]                        
                }

                default {
                        # incr listIndex
                    puts "    $value  ... not registered yet  - $listIndex"
                }    
            }
        
        }
    }
                
    set partList  {}
    set valueList {}
    foreach value $pathValueList_abs {
        switch -exact $value {
            m -
            M {
                lappend partList $valueList 
                set valueList {}
                lappend valueList $value
            }
            default {
                lappend valueList $value
            }
        }
    }
    lappend partList $valueList

      # puts "\n   -> format_absPath:\n ===================================="
    # puts "\n--------------"
    # puts "\n         [lrange $partList 1 end]\n"
    # puts "--------------"
    return [lrange $partList 1 end]
    
    
    # return $pathValueList_abs
}
        # -- internal procedure: return 1 if $value is a control-character in SVG-path element
        #
proc cad4tcl::app::simplifySVG::model::checkControl {value} {
    set controlChar [string map { M  {__}    Z  {__}    L  {__}    H  {__}    V  {__}    C  {__}    S  {__}    Q  {__}    T  {__}    A  {__}    \
                                  m  {__}    z  {__}    l  {__}    h  {__}    v  {__}    c  {__}    s  {__}    q  {__}    t  {__}    a  {__} } \
                                 $value ]
    if {$controlChar == {__}} {
        return 1
    } else {
        return 0
    }
}

        # -- convert all relative values to absolute values


proc cad4tcl::app::simplifySVG::model::format_pathtoLine {pathDefinition} {
    # -------------------------------------------------
    # http://www.selfsvg.info/?section=3.5
    # 
    # -------------------------------------------------
        # puts "\n\n === new format_pathtoLine =====================\n"        

        # puts "\npathString:\n  $pathString\n"            
    
        # puts "       - > pathDefinition:\n$pathDefinition\n"

    
    set canvasElementType   line
    set controlString       {}
    set isClosed            {no}
        
    
    set segment     {}
    set segmentList {}
      # foreach element [flatten_nestedList $pathDefinition] {}
    foreach element $pathDefinition {
          # puts "  -> $element"
        if {[string match {[A-Z]} $element]} {
           lappend segmentList $segment
           set segment $element
        } else {
           lappend segment $element
             # puts "  -> $element"
        }
    }
    lappend segmentList $segment
    set segmentList [lrange $segmentList 1 end]
    
    set prevCoord_x         55
    set prevCoord_y         55
    
    set ref_x 0
    set ref_y 0
    
    set loopControl 0
    set lineString  {}
    
      # puts "   -> \$pathDefinition: $pathDefinition"
      # puts "   -> \$segmentList:    $segmentList"
    #exit
    
    
    foreach segment $segmentList {

        
            # puts "\n\n_____loop_______________________________________________"
            # puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
            # puts "\n\n      <$segment>\n_____segment________"

    
            # puts "  ... $segment"
        set segmentDef            [split [string trim $segment]]
        set segmentType           [lindex $segmentDef 0]
        set segmentCoords         [lrange $segmentDef 1 end]
            # puts "\n$segmentType - [llength $segmentCoords] - $segmentCoords\n____type__segmentCoords__"
            
        switch -exact $segmentType {
            M { #MoveTo 
                set lineString         [ concat $lineString     $segmentCoords ]
                set ref_x     [ lindex $segmentCoords 0 ]
                set ref_y     [ lindex $segmentCoords 1 ]
            }
            L { #LineTo - absolute
                set lineString         [ concat $lineString     $segmentCoords ] 
                set ref_x     [ lindex $segmentCoords end-1]
                set ref_y     [ lindex $segmentCoords end  ]
            } 
            C { # Bezier - absolute
                    # puts "\n\n  [llength $segmentCoords] - $segmentCoords\n______segmentCoords____"
                # puts "\n( $ref_x / $ref_y )\n      ____start_position__"
                # puts "\n$segmentType - [llength $segmentCoords] - ( $ref_x / $ref_y ) - $segmentCoords\n      ______type__segmentCoords__"
                
                set segmentValues    {}
                foreach {value} $segmentCoords {
                    set segmentValues     [ lappend segmentValues $value ]                        
                }
                
                    # exception on to less values
                        #     - just a line to last coordinate
                        #                                
                if {[llength $segmentValues] < 6 } {\
                    set ref_x     [ lindex $segmentValues end-1]
                    set ref_y     [ lindex $segmentValues end  ]
                    set lineString [ concat $lineString $ref_x $ref_y ]
                        puts "\n\n      <[llength $segmentValues]> - $segmentValues\n_____Exception________"
                    return
                    # continue
                }
                
                    # continue Bezier definition
                        #     - just a line to last coordinate
                        #                                
                set segmentValues    [ linsert $segmentValues 0 $ref_x $ref_y ]                            
                    # puts "\n  [llength $segmentValues_abs] - $segmentValues_abs\n______segmentValues_abs____"
                set bezierValues    [ Bezier $segmentValues]
                set ref_x     [ lindex $bezierValues end-1]
                set ref_y     [ lindex $bezierValues end  ]
                    # puts "           ===================="
                    # puts "           $prevCoord -> $prevCoord"
                    # puts "                 $bezierString"
                    # puts "            ===================="                            
                set lineString         [ concat $lineString     [lrange $bezierValues 2 end] ]
            }
            
            default {
                puts "\n\n  ... whats on there?  ->  $segmentType"
                puts     "   ...     segmentList  ->  $segmentList \n\n"
            }
        }
        
            # incr loopControl
            # puts "  ... $loopControl"
        
        # puts "\n( $ref_x / $ref_y )\n      ____end_position__"                
        # puts "\n\n      $ref_x $ref_y\n_____ref_x___ref_y________"
    }
    
    set pointList [split $lineString { }]
    return $pointList

}



proc cad4tcl::app::simplifySVG::model::simplify_Rectangle {node parentTransform {targetNode {}}} {
    variable tmpSVG
      # -- handle as polygon
    set width     [$node getAttribute width]
    set height    [$node getAttribute height]
    set pointList [list 0,0 $width,0 $width,$height 0,$height]
    $node setAttribute points $pointList
    
    set myNode [ simplify_Polygon $node $parentTransform]
    return $myNode
}


proc cad4tcl::app::simplifySVG::model::simplify_Circle {node parentTransform} {   
    
    variable tmpSVG  
    variable svgPrecision  

    set transform       [unifyTransform $node]
    set translateMatrix [lindex $transform 0]
    set transformMatrix [lindex $transform 1]
    set transformType   [lindex $transform 2]
    
        # puts "\n === simplify_Circle ==========================\n  -> [$node asXML]"
        # puts "       \$transformType   $transformType"
        # puts "       \$translateMatrix $translateMatrix"   
        # puts "       \$transformMatrix $transformMatrix"   
        # puts "       \$parentTransform $parentTransform"
    

    # puts "       [$node asXML]"
    
    
    set radius      [$node getAttribute r]
    set center_x    0
    set center_y    0
    set transform   {}
    catch {set center_x    [$node getAttribute cx]}
    catch {set center_y    [$node getAttribute cy]}
    catch {set transform   [$node getAttribute transform]}
        #
    if {$transform ne {}} {
            # puts "    -> \$transform $transform"
        foreach {key value} [split $transform ()] break
            # puts "   -> $key"
            # puts "    -> $value"
        switch -exact -- $key {
            matrix {
                set center_x       [lindex $value end-1]
                set center_y       [lindex $value end]
            }
            default {}
        }
    }    
       #
        # puts "       -> \$center_x $center_x"   
        # puts "       -> \$center_y $center_y"   
       #
       #
    set newNode [$tmpSVG createElement circle]
    $newNode setAttribute id ""
        #
        # check transform
    foreach {a b c d e f} $transformMatrix break
    if {$a eq $d} {
            # puts "  -> is circle -- $a $b $c $d"
            #
            # set radius  [expr $radius * $a]
            # --
        set radius      [expr 1.0 * $radius   / $svgPrecision]
        set center_x    [expr 1.0 * $center_x / $svgPrecision]
        set center_y    [expr 1.0 * $center_y / $svgPrecision]
        foreach {dx dy} $parentTransform break
        set pointList [list [expr $center_x + $dx] [expr $center_y + $dy]]
        
        foreach {center_x center_y} $pointList break

        $newNode setAttribute cx $center_x
        $newNode setAttribute cy $center_y
        $newNode setAttribute r $radius
        
        $newNode setAttribute fill          none
        $newNode setAttribute stroke        black
        $newNode setAttribute stroke-width  0.1
    
        return $newNode
    
    } else {
         # -- handle as ellipse
        set rx     [copyAttribute $node r]
        set ry     [copyAttribute $node r]
        $node setAttribute rx $rx
        $node setAttribute ry $ry
        
        set myNode [simplify_Ellipse $node $parentTransform]
        
        return $myNode
    }
}    


proc cad4tcl::app::simplifySVG::model::simplify_Line {node parentTransform} { 
    
    variable tmpSVG  
    variable flatSVG 
    variable min_SegmentLength        
    
    set transform       [unifyTransform $node]
    set translateMatrix [lindex $transform 0]
    set transformMatrix [lindex $transform 1]
    set transformType   [lindex $transform 2]
    
        # puts "\n === simplify_Line ==========================\n  -> [$node asXML]"
        # puts "       \$transformType   $transformType"
        # puts "       \$translateMatrix $translateMatrix"   
        # puts "       \$transformMatrix $transformMatrix"   
        # puts "       \$parentTransform $parentTransform"   
    

      # -- define nodeType: line
    set resultNode [$tmpSVG createElement line]
    
      # -- get shape 
    set x1  [copyAttribute $node x1]
    set y1  [copyAttribute $node y1]
    set x2  [copyAttribute $node x2] 
    set y2  [copyAttribute $node y2]
    set pointList [list $x1 $y1 $x2 $y2]

    
      # -- handle translation by given x,y
    set pointList [matrixTransform $pointList $translateMatrix]
      # puts "   -> $pointList"
    
    
      # -- handle transformation by given attribute
    set pointList [matrixTransform $pointList $transformMatrix]
      # puts "   -> $pointList"
    
      # --check relevance
    set segLength  [pointDistance [lrange $pointList 0 1] [lrange $pointList 2 3]]
    # puts "   -> \$segLength $segLength"
    if {$segLength < $min_SegmentLength} {
        puts "line,segLength:  $segLength   < $min_SegmentLength"
        puts "      ... excepted\n"
        return {}
    }        
    
    set dx [lindex $parentTransform 0]
    set dy [lindex $parentTransform 1]
        #
    $resultNode setAttribute x1 [expr $dx + [lindex $pointList 0]]
    $resultNode setAttribute y1 [expr $dy + [lindex $pointList 1]]
    $resultNode setAttribute x2 [expr $dx + [lindex $pointList 2]]
    $resultNode setAttribute y2 [expr $dy + [lindex $pointList 3]]
    
      # -- create returnNode with ordered attributes
    set newNode [$tmpSVG createElement line]
    update_Attributes $resultNode $newNode

      
      # -- set defaults
    $newNode setAttribute stroke          black
    $newNode setAttribute stroke-width    0.1
    
      # -- return svg-Node
    return $newNode
}


proc cad4tcl::app::simplifySVG::model::simplify_Ellipse {node parentTransform {targetNode {}}} {   
    
    variable tmpSVG  
    variable flatSVG
    variable CONST_PI
    
    set transform       [unifyTransform $node]
    set translateMatrix [lindex $transform 0]
    set transformMatrix [lindex $transform 1]
    set transformType   [lindex $transform 2]
    
        # puts "\n === simplify_Ellipse ==========================\n  -> [$node asXML]"
        # puts "       \$transformType   $transformType"
        # puts "       \$translateMatrix $translateMatrix"   
        # puts "       \$transformMatrix $transformMatrix"   
    

      # -- define nodeType: polygon
    set resultNode [$tmpSVG createElement polygon]
    
    set center_x  [copyAttribute $node cx $resultNode]
    set center_y  [copyAttribute $node cy $resultNode]
    set radius_x  [copyAttribute $node rx] 
    set radius_y  [copyAttribute $node ry]
    
      # -- get the origin of the circle
    set origin_x [expr [lindex $translateMatrix 4] +[lindex $transformMatrix 4]]          
    set origin_y [expr [lindex $translateMatrix 5] +[lindex $transformMatrix 5]]          
    if {$center_x == {}} { set center_x 0 }
    if {$center_y == {}} { set center_y 0 }
    
    set nodeID  [$node getAttribute id]
    if {$nodeID =={center_00}} {
        puts "\n\n -----"
        puts " caught -> center_00"
        puts "    center $center_x/$center_y"
        puts "    new    $origin_x/$origin_y"
        puts "      \$translateMatrix $translateMatrix"
        puts "      \$transformMatrix $transformMatrix"
        puts "      \$parentTransform $parentTransform"
    }
    #     set centerNode [$flatSVG createElement circle]
    #     $centerNode setAttribute cx $origin_x
    #     $centerNode setAttribute cy $origin_y
    #     $centerNode setAttribute r  15
    #     $flatSVG addChild $centerNode

    

      # -- for handling id="center_00" and origin values
    # $resultNode setAttribute cx $center_x       
    # $resultNode setAttribute cy $center_y    


      # -- define shape as polygon        
    set pointList {}
    set i 0
    set j 60
    set deltaAngle  [expr 2*$CONST_PI/$j]
    set ratioRadius [expr 1.0*$radius_y/$radius_x]
    puts "   \$deltaAngle \$ratioRadius: $deltaAngle $ratioRadius"
    while {$i < $j} {
        set angle [expr $i*$deltaAngle]
        set x     [expr $center_x + ($radius_x * cos($angle))]
        set y     [expr $center_y + $ratioRadius * ($radius_x * sin($angle))]
        lappend pointList $x $y
        incr i
    }
    
      # -- handle translation by given x,y
    set pointList [matrixTransform $pointList $translateMatrix]
      # puts "   -> $pointList"
    
    
      # -- handle transformation by given attribute
    set pointList [matrixTransform $pointList $transformMatrix]
      # puts "   -> $pointList"
    
      # -- convert to svg-polygon attributes
    set tmpList {}
    foreach {x y} $pointList {
        lappend tmpList "[expr  $x + [lindex $parentTransform 0]],[expr $y + [lindex $parentTransform 1]]"
    }
    $resultNode setAttribute points $tmpList
    
    if {$nodeID =={center_00}} {
        puts "\n\n -----"
        puts " caught -> center_00"
        puts "   -> $pointList"
        puts "   -> $tmpList"
    }
    
    
      # -- create returnNode with ordered attributes
    set newNode [$tmpSVG createElement polygon]
    update_Attributes $resultNode $newNode
    
      # -- set defaults
    $newNode setAttribute fill          none
    $newNode setAttribute stroke        black
    $newNode setAttribute stroke-width  0.1
      
      # -- in case of circle as oval
    catch {
        $newNode setAttribute cx        $origin_x
        $newNode setAttribute cy        $origin_y
    }
    
      # -- return svg-Node
    return $newNode
} 


proc cad4tcl::app::simplifySVG::model::simplify_Polygon {node parentTransform {targetNode {}}} {
    
    variable tmpSVG  
    variable flatSVG
    
    set transform       [unifyTransform $node]
    set translateMatrix [lindex $transform 0]
    set transformMatrix [lindex $transform 1]
    set transformType   [lindex $transform 2]
    
        # puts "\n\n\n === simplify_Polygon ==========================\n  -> [$node asXML]"
        # puts "       \$transformType   $transformType"
        # puts "       \$translateMatrix $translateMatrix"   
        # puts "       \$transformMatrix $transformMatrix"
    

      # -- define nodeType: polygon
    set resultNode [$tmpSVG createElement polygon]
    
      # -- define shape as pointList
    set tmpList [$node getAttribute points]
    set pointList {}
    foreach point $tmpList {
        foreach {x y} [split $point ,] break
        lappend pointList $x $y
    }
      # puts "   -> $pointList"
    
      # -- handle translation by given x,y
    set pointList [matrixTransform $pointList $translateMatrix]
      # puts "   -> $pointList"
    
      # -- handle transformation by given attribute
    set pointList [matrixTransform $pointList $transformMatrix]
      # puts "   -> $pointList"
    
      # -- convert to svg-polygon attributes
    set tmpList {}
    foreach {x y} $pointList {
        lappend tmpList "[expr  $x + [lindex $parentTransform 0]],[expr $y + [lindex $parentTransform 1]]"
    }
    $resultNode setAttribute points $tmpList

    
      # -- create returnNode with ordered attributes
    set newNode [$tmpSVG createElement polygon]
    update_Attributes $resultNode $newNode

      # -- set defaults
    $newNode setAttribute fill            none
    $newNode setAttribute stroke          black
    $newNode setAttribute stroke-width    0.1
    
      # -- return svg-Node
        # puts "[$newNode asXML]"
    return $newNode
}


proc cad4tcl::app::simplifySVG::model::simplify_Path  {node parentTransform {targetNode {}}} {

    variable tmpSVG  
    variable flatSVG
    
    set transform       [unifyTransform $node]
    set translateMatrix [lindex $transform 0]
    set transformMatrix [lindex $transform 1]
    set transformType   [lindex $transform 2]
    
        # puts "\n == simplify_Path ===========================\n\n  -> [$node asXML]"
        # puts "       \$transformType   $transformType"
        # puts "       \$translateMatrix $translateMatrix"   
        # puts "       \$transformMatrix $transformMatrix"  

    foreach {a b c d e f} $translateMatrix break
    set e [expr $e + [lindex $parentTransform 0]]        
    set f [expr $f + [lindex $parentTransform 1]]    
    set translateMatrix [list $a $b $c $d $e $f]
    puts "       \$transformMatrix $transformMatrix"
    
    
    set splitPathCount 0
    set pathInfo [ $node getAttribute d ]
      # puts "  -> \$pathInfo $pathInfo\n"
    
    set svgPath     [ format_absPath [ $node getAttribute d ] $parentTransform ]
         # set svgPath     [format_absPath [ $node getAttribute d ]]
    foreach pathElement $svgPath {
        # puts "    00 -> \$pathElement $pathElement"
    }
    if {[llength $svgPath] > 1} {
        set newNode [$flatSVG createElement g]
        set nodeID [copyAttribute $node id $newNode]
          # $newNode setAttribute children  [llength $svgPath]
        set i 0
        foreach pathSegment $svgPath {
            set pathSegment [flatten_nestedList $pathSegment]
                # puts "\n--<D>---- loop ----------"
                # puts "    01 -> \$pathSegment $pathSegment"
                # puts "   ->   ende: [lindex $pathSegment end]"
            if { [lindex $pathSegment end] == {Z} } {
                  set pathSegment [lrange $pathSegment 0 end-1]
                  # puts "    02 -> \$pathSegment $pathSegment"
                  set loopNode    [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polygon ]
            } else {
                  set loopNode    [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polyline]
            }
            if {[$loopNode hasAttribute id]} {
                  set loopID [$loopNode getAttribute id]
                  $loopNode setAttribute id [format "%s___%s" $loopID $i]
            } else {
                  $loopNode setAttribute id [get_svgID]
            }
            set loopNode [checkPoly__x $loopNode]
            if {$loopNode != {}} {
                $newNode appendChild $loopNode
            } 
            incr i
        }
    } else {
        set pathSegment $svgPath
        set pathSegment [flatten_nestedList $svgPath]
          # puts "\n--<D>------- single -------"
          # puts "   -> \$pathSegment [llength $pathSegment] [lindex $pathSegment end]"
          # puts "   -> \$pathSegment $pathSegment"
          # puts "   ->   ende: [lindex $pathSegment end]"
        if { [lindex $pathSegment end] == {Z} } {
            set pathSegment [lrange $pathSegment 0 end-1]
            set newNode     [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polygon]
        } else {
            set newNode     [get_pathNode $node $pathSegment $translateMatrix $transformMatrix polyline]
        }             
    }
    
    return $newNode

}
    proc cad4tcl::app::simplifySVG::model::get_pathNode {node pathDescription translateMatrix transformMatrix nodeName } {
        variable flatSVG
        
        set newNode   [$flatSVG createElement $nodeName]
        foreach attr  [$node attributes] {
            puts "   -> $attr"
            # exclude namespace attributes
            if {[llength [split $attr :]] > 1} continue
            $newNode setAttribute $attr [$node getAttribute $attr]
        }
          # puts [$newNode asXML]
        set pointList [format_pathtoLine [flatten_nestedList $pathDescription]]
          # puts "\n"
          # puts "   -> \$pointList $pointList"

        
          # -- handle translation by given x,y
        set pointList [matrixTransform $pointList $translateMatrix]
          # puts "   -> $pointList"
        
          # -- handle transformation by given attribute
        set pointList [matrixTransform $pointList $transformMatrix]
          # puts "   -> $pointList"
          
          
        set pointList_Attribute {}
        foreach {x y} $pointList {
            lappend pointList_Attribute "$x,$y"
        }  
          # puts "   -> $pointList_Attribute"

          
          # -- add Attribute points
        $newNode setAttribute     points          $pointList_Attribute
          # -- and remove Attribute d and transform, because of above transformation
        $newNode removeAttribute  d
        catch {$newNode removeAttribute  transform}

          # update_Attributes $resultNode $newNode
        $newNode setAttribute     fill            none
        $newNode setAttribute     stroke          black
        $newNode setAttribute     stroke-width    0.1
        
        if {$pointList == {}} {
            puts "\n\n\n\n"
            puts "  -> [$node asXML]"
            puts "  -> $pathDescription"
            puts "  -> [$newNode asXML]"
            puts "\n\n\n\n"
        }
        
        return $newNode
    }


proc cad4tcl::app::simplifySVG::model::add_SVGNode {node targetNode parentTransform} {
            
        #
    variable detailText
    variable min_SegmentLength
    variable flatSVG
    variable fillGeometry
    variable free_ObjectID
        #

        # puts "   ... $node"
    if {[$node nodeType] != {ELEMENT_NODE}} return ;#continue


        # -- get nodeName
    set nodeName [$node nodeName]
    if  {[$node hasAttribute id]} {
        set nodeID   [$node getAttribute id]
    } else {
        set nodeID   [get_ObjectID]
        $node setAttribute id $nodeID 
    }

    set parentPosition [lrange $parentTransform 4 5]
        # puts "       \$parentPosition $parentPosition"
    
    switch -exact $nodeName {
        g {
                # puts "\n\n  ... looping"
                # puts "   [$node asXML]"
            set myNode [$flatSVG createElement g]
            $targetNode appendChild $myNode
            
            set transform       [unifyTransform $node]
            set translateMatrix [lindex $transform 0]
            set transformMatrix [lindex $transform 1]
            set transformType   [lindex $transform 2]
            catch {$node removeAttribute transform}
            
                # puts "\n === add_SVGNode ======= $parentTransform ===================\n  -> [$node asXML]"
                # puts "       \$transformType   $transformType"
                # puts "       \$translateMatrix $translateMatrix"   
                # puts "       \$transformMatrix $transformMatrix" 

            
              # -- handle translation by given x,y
            set parentPosition [matrixTransform $parentPosition $translateMatrix]
              # puts "   -> $parentPosition"
            
              # -- handle transformation by given attribute
            set parentPosition [matrixTransform $parentPosition $transformMatrix]       
                # puts "       \$parentPosition $parentPosition"
            
            set nodeTransform [list 1 0 0 1 [lindex $parentPosition 0] [lindex $parentPosition 1]]
                # puts "       \$nodeTransform   $nodeTransform"
            
            foreach childNode [$node childNodes] {
                add_SVGNode $childNode $myNode $nodeTransform
            }
        }
        rect {
            set myNode  [simplify_Rectangle $node $parentPosition]
            $myNode setAttribute id $nodeID
            $targetNode appendChild $myNode 
        }
        polygon {
            set myNode  [simplify_Polygon   $node $parentPosition]
            $myNode setAttribute id $nodeID
                #
            set myNode [checkPoly__x $myNode]
                #
            if {$myNode != ""} {
                $targetNode appendChild $myNode
            }
                #
        }
        polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ..."
            set polygonNode  [simplify_Polygon $node $parentPosition]
            
            set myNode [$flatSVG createElement polyline]
            $myNode setAttribute id $nodeID
            foreach attr [$polygonNode attributes] {
                $myNode setAttribute $attr [$polygonNode getAttribute $attr]
            }
                #
            set myNode [checkPoly__x $myNode]
                #
            if {$myNode != ""} {
                $targetNode appendChild $myNode
            }
                #
        }
        line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
            set myNode  [simplify_Line $node $parentPosition]
            if {$myNode != {}} {
                $myNode setAttribute id $nodeID
                $targetNode appendChild $myNode
            }                                        
        }
        ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
            set myNode  [simplify_Ellipse $node $parentPosition $targetNode]
            $myNode setAttribute id $nodeID
            $targetNode appendChild $myNode                                         
        }
        circle { # circle cx="58.4116" cy="120.791" r="5.04665"
                # --- dont display the center_object with id="center_00"
            set myNode  [simplify_Circle $node $parentPosition]
            $myNode setAttribute id $nodeID
            $targetNode appendChild $myNode 
        }
        path { # path d="M ......."
                # puts "   path: ->  $parentPosition"
            set tmpNodes [ simplify_Path $node $parentPosition]
            set loopID 0
              # puts "\n\n  tmpNodes -> $tmpNodes \n\n"
            foreach myNode $tmpNodes {
                if {$myNode == {}} continue
                incr loopID
                $myNode setAttribute id [format "%s_%s" $nodeID $loopID]
                    #
                set myNode [checkPoly__x $myNode]
                    #
                if {$myNode != {}} {
                    $targetNode appendChild $myNode
                }
            }
        }        

        default { 
            # -- for temporary use, will never be added to $targetNode
            set myNode [$flatSVG createElement unused ]
        }
    }
    
        # puts "[$myNode asXML]"
        # puts "        $nodeName:  $objectPoints"
        # -- get nodeID
    if {[$node hasAttribute id]} {
        set nodeID   [$node getAttribute id]
            # puts "  ... $nodeName / $nodeID"
    } else {
        set nodeID {... unset}  
    }
        # $detailText insert 1.0 "    -> $nodeName - $nodeID\n"
    update
    

}
