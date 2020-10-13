 ########################################################################
 #
 # simplifySVG: lib_view.tcl
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

namespace eval cad4tcl::app::simplifySVG::view {

    variable exportFileName     {export.svg}
    
    variable min_SegmentLength  0.4
    variable fillGeometry       {gray80}
    variable centerNode         {}
    variable trashNode          {}
    variable free_ObjectID      0
    variable file_saveCount     0
    variable tmpSVG             [dom parse "<root/>"]
    variable my_Center_Object   {}
    variable fitVector          {0 0 1}
    variable svgPrecision       1
    
    variable svg_LastID         {}
    variable svg_CurrentID      {}
            
    variable CONST_PI           [expr 4*atan(1)]
    
    variable currentVersion     [set [namespace parent]::currentVersion]
    
    variable svgRootSource
    variable svgTextDeep
    variable svgRootTarget
    
    variable sourceTree
    variable sourceText
    variable workTree
    variable cvObject
    variable detailText
    variable targetText
    
    variable svgPrecision
    
    variable inputDir   $[namespace parent]::packageHomeDir
    variable outputDir  $[namespace parent]::packageHomeDir
    
}

# -- handling puts
# http://wiki.tcl.tk/1290
proc cad4tcl::app::simplifySVG::view::InCommand {} {
   uplevel {puts [info level 0]}
}

proc cad4tcl::app::simplifySVG::view::newproc {name args body} {
   set body "InCommand\n$body"
   _orig_puts $name $args $body
}


proc cad4tcl::app::simplifySVG::view::openSVGFile {{argv {}}} {
    variable cvObject
    variable fileName
    variable sourceTree
    variable sourceText
    variable workTree
    variable targetText 
    variable svgRootSource
    variable svgTextDeep
    variable svgRootTarget 
    variable currentVersion
        #
    variable inputDir
        #
    variable exportFileName {exportFile.svg}
        #
    puts "\n"
    puts "  =============================================="
    puts "   -- openSVGFile:   $argv"
    puts "  =============================================="
    puts "\n"
        #
        # --- open File ------------
    if {[llength $argv] == 0} {
        set fileName [tk_getOpenFile -initialdir $inputDir]
        set inputDir [file dirname $fileName]
        set exportFileName $fileName
    } else {
        set fileName ${argv}
        set inputDir [file dirname $fileName]
    }
    if {$fileName == {}} {return}
        #
    set fp [open $fileName]
        # 
    set svgTextDeep [read $fp]
    close   $fp
        #
        # --- compute results ------            
    set svgDoc [dom parse  $svgTextDeep]
        # $doc documentElement root
        #
    set svgRootSource [$svgDoc documentElement]
        #
        #
    updateSVGDom    
        #
        #
    wm title . "simplifySVG $currentVersion - $fileName"
        #
}

proc cad4tcl::app::simplifySVG::view::reloadSVGFile {} {
    variable fileName
    puts "\n\n        -> $fileName"
    openSVGFile ${fileName}
}

proc cad4tcl::app::simplifySVG::view::updateSVGDom {} {
        #
    variable cvObject
    variable fileName
    variable sourceTree
    variable sourceText
    variable workTree
    variable targetText 
    variable svgRootSource
    variable svgRootTarget 
    variable svgTextDeep
    variable currentVersion            
        #
        #
    if ![info exists svgRootSource] {
        return
    }
        # puts "[$svgRootSource asXML]"    
        #
    set svgRootTarget [cad4tcl::app::simplifySVG::model::simplifySVG $svgRootSource]
        #
    $svgRootTarget setAttribute xmlns "http://www.w3.org/2000/svg"
        #
        #
        # --- cleanup outputs ------            
    $cvObject deleteContent
    cleanupTree $sourceTree
    $sourceText delete 1.0 end
    cleanupTree $workTree
        #
    fitContent    
        #
        #
        # --- fill outputs ---------
    recursiveInsertTree $sourceTree    $svgRootSource   {}
        #
    $sourceText insert end $svgTextDeep
        #
        # --- working 
    puts [$svgRootTarget asXML]    
    drawSVG $svgRootTarget $cvObject {15 15}
        #
        # $targetText delete 1.0 end
        # $targetText insert end {<?xml version="1.0" encoding="UTF-8"?>}
        # $targetText insert end "\n"
        # $targetText insert end [[$svgRootTarget ownerDocument ] asXML -doctypeDeclaration 1]
        #
    update_TargetText    
        #
    updateContent
        #
        #                
}

proc cad4tcl::app::simplifySVG::view::update_TargetText {} {
        #
    variable targetText    
    variable svgRootTarget    
        #
    $targetText delete 1.0 end
    $targetText insert end {<?xml version="1.0" encoding="UTF-8"?>}
    $targetText insert end "\n"
    $targetText insert end [[$svgRootTarget ownerDocument ] asXML -doctypeDeclaration 1]
        #
}        

proc cad4tcl::app::simplifySVG::view::drawSVG {domSVG cvObject {transform {0 0}}} {
                           
    variable targetText
    variable fillGeometry
    variable centerNode
    variable free_ObjectID
    
    puts "\n"
    puts "  =============================================="
    puts "   -- drawSVG"
    puts "  =============================================="
    puts "\n"

          
    set nodeList       [$domSVG childNodes]         
    set centerNode     {}
    set tagID 0
    
    
    foreach {transform_x transform_y} $transform break;    
    
        # return
    foreach node $nodeList {
         if {[catch {drawSVGNode $node $cvObject $transform_x $transform_y} eID]} {
             puts "   -> $eID"
             tk_messageBox -title "creation Error: drawSVG" -icon error -message "\n$eID\n-----------\n[$node asXML]"
         }
    }
    
    if {$centerNode != {}} {
        puts   "\n     CenterNode:  \n"
        puts   "         [$node asXML]\n"
        set cx [$centerNode getAttribute cx]
        set cy [expr -1.0 * [$centerNode getAttribute cy]]
        if {$cx == {}} {
            tk_messageBox -icon error -message "... please check coordinates cx/cy for node with id=\"center_00\"" 
        }
        if {$cy == {}} {
            tk_messageBox -icon error -message "... please check coordinates cx/cy for node with id=\"center_00\"" 
        }
        set radius  2.5
            #
               
        set stageHeight    [$cvObject configure Stage Height]
        
        set x_00 [expr $cx - 0.35 * $stageHeight]
        set x_01 [expr $cx + 0.35 * $stageHeight]
        set y_00 [expr $cy - 0.35 * $stageHeight]
        set y_01 [expr $cy + 0.35 * $stageHeight]
        
        set objectPoints    [list    $x_00 $cy  $x_01 $cy]
        $cvObject create    centerline $objectPoints [list  -fill red  -tags  __center_00__]
         
        set objectPoints    [list    $cx $y_00  $cx $y_01 ]
        $cvObject create    centerline $objectPoints [list  -fill red  -tags  __center_00__]

        set objectPoints    [list $cx $cy]
        $cvObject create    circle $objectPoints -r $radius  -outline blue  -fill {}  -tags {__center_00__}
    }
    
}


proc cad4tcl::app::simplifySVG::view::drawSVGNode {node cvObject transform_x transform_y} {
          
    variable targetText
    variable fillGeometry
    variable centerNode
    variable free_ObjectID

        # puts [$node asXML]
        
        # -- set defaults
    set objectPoints {}
    
        # -- get centerNode of SVG defined by id="center_00"
        #   circle or ellipse  by cx and cy attributes
        #
         #
    set nodeName [$node nodeName]
    if {[$node hasAttribute id]} {
            # puts "   -> [$node getAttribute id]"
        set tagName [$node getAttribute id]
        if {$tagName eq "center_00"} {
            if {$centerNode != {}} {
                tk_messageBox -icon info -message "centerNode allready exists:\n [$node asXML]" 
                return
            } else {
                set centerNode $node
                puts "\n       centerNode found:"
                puts   "         [$node asXML]\n"
                # tk_messageBox -message "centerNode found:\n [$node asXML]" 
                set nodeName centerNode
           }
        }
    } else {
        # -- give every node an id
        #
        incr free_ObjectID
        set  tagName  [format "_tag_%s_" $free_ObjectID]
        puts "\n   ... $tagName \n"
        $node setAttribute id $tagName
    }
    
    # -- give every node an id
        #   circle or ellipse  by cx and cy attributes
        #
    set myObject {}


    switch -exact $nodeName {
            g {
                foreach childNode [$node childNodes] {
                    if {[catch {drawSVGNode $childNode $cvObject $transform_x $transform_y} eID]} {
                         puts "   -> $eID"
                         tk_messageBox -title "creation Error: drawSVGNode" -icon error -message "\n$eID\n-----------\n[$childNode asXML]"
                    }    
                    set myObject {}
                    # break
                }
            }
            rect {
                set x         [expr [$node getAttribute x] + $transform_x ]
                set y         [expr [$node getAttribute y] + $transform_y ]
                set width     [$node getAttribute  width ]
                set height    [$node getAttribute  height]
                set x2 [expr $x + $width ]
                set y2 [expr $y + $height]
                set objectPoints [list $x $y $x $y2 $x2 $y2 $x2 $y]
                    #
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                    # -- create rectangle
                        # puts "$cvObject create polygon     $objectPoints -outline black -fill white"
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                set myObject [$cvObject create polygon     $objectPoints -outline black -fill $fillGeometry -tags $tagName]
            }
            polygon {
                set valueList [ $node getAttribute points ]
                if {[llength $valueList] < 2} {return}
                foreach {coords} $valueList {
                    foreach {x y}  [split $coords ,] break
                    set x     [expr $x + $transform_x ]
                    set y     [expr $y + $transform_y ]
                    set objectPoints [lappend objectPoints $x $y ]
                }
                    #
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                    # -- create polygon
                        # puts "\n$cvObject create polygon     $objectPoints -outline black -fill white"
                set myObject [$cvObject create polygon     $objectPoints -outline black -fill $fillGeometry  -tags $tagName]
            }
            polyline { # polyline class="fil0 str0" points="44.9197,137.492 47.3404,135.703 48.7804,133.101 ..."
                set valueList [ $node getAttribute points ]
                if {[llength $valueList] < 2} {return}
                foreach {coords} $valueList {
                    foreach {x y}  [split $coords ,] break
                    set x     [expr $x + $transform_x ]
                    set y     [expr $y + $transform_y ]
                    set objectPoints [lappend objectPoints $x $y ]
                }
                    #
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                    # -- create polyline
                        # puts "$cvObject create line $objectPoints -fill black"
                set myObject [$cvObject create line $objectPoints -fill black  -tags $tagName]
            }
            line { # line class="fil0 str0" x1="89.7519" y1="133.41" x2="86.9997" y2= "119.789"
                set objectPoints [list    [expr [$node getAttribute x1] + $transform_x ] [expr [$node getAttribute y1] + $transform_y ] \
                                        [expr [$node getAttribute x2] + $transform_x ] [expr [$node getAttribute y2] + $transform_y ] ]
                    #
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                        # -- create line
                        # puts "$cvObject create line $objectPoints -fill black"
                set myObject [$cvObject create line $objectPoints -fill black]
            }
            circle { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                    # puts "[$node asXML]"
                set cx [expr [$node getAttribute cx] + $transform_x ]
                set cy [expr [$node getAttribute cy] + $transform_y ]
                set r  [$node getAttribute  r]
                set x1 [expr $cx - $r]
                set y1 [expr $cy - $r]
                set x2 [expr $cx + $r]
                set y2 [expr $cy + $r]
                set objectPoints [list $x1 $y1 $x2 $y2]
                    #
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                    # -- create circle
                        # puts "$cvObject create oval $objectPoints -fill black"
                set myObject [$cvObject create oval $objectPoints -outline black -fill $fillGeometry  -tags $tagName]
            }
            ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                    # --- dont display the center_object with id="center_00"
                set cx [expr [$node getAttribute cx] + $transform_x ]
                set cy [expr [$node getAttribute cy] + $transform_y ]
                set rx  [$node getAttribute  rx]
                set ry  [$node getAttribute  ry]
                set x1 [expr $cx - $rx]
                set y1 [expr $cy - $ry]
                set x2 [expr $cx + $rx]
                set y2 [expr $cy + $ry]
                set objectPoints [list $x1 $y1 $x2 $y2]
                    #
                set objectPoints [cad4tcl::_convertBottomLeft 1.0 $objectPoints]
                    # -- create circle
                        # puts "$cvObject create oval $objectPoints -fill black"
                set myObject [$cvObject create oval $objectPoints -outline black -fill $fillGeometry  -tags $tagName]
            }
            default {
                set myObject {}
            }
            # $detailText insert end 
    }
    
    if {$myObject eq {}} {
        return
    } else {
        $cvObject bind    $myObject    <ButtonPress-1> [list [namespace current]::event_Canvas $tagName]
        $cvObject registerClickObject $myObject
    }
        # $cvObject bind    $myObject    <ButtonPress-1> [list puts "    -> $tagName"]
        # $cvObject bind    $myObject    <ButtonPress-1> [list searchrep'next $targetText $tagName]
        # $canvas bind    $myObject    <ButtonPress-1> [list puts "    -> $tagName"; set ::Find $tagName; searchrep'next $targetText]
}


proc cad4tcl::app::simplifySVG::view::recursiveInsertTree {w node parent} {
        
    variable free_ObjectID
      
    set domDepth [llength [split [$node toXPath] /]]            
              
              # node Attributes
    set nodeName [$node nodeName]
    set nodeID   {}
    set done 0
    if {$nodeName eq "#text" || $nodeName eq "#cdata"} {
        set text [string map {\n " "} [$node nodeValue]]
    } else {
        set text {}
        foreach att [getAttributes $node] {
            switch -exact $att {
                id {
                    set nodeID [$node getAttribute id]
                }
                default {
                    catch {append text " $att=\"[$node getAttribute $att]\""}
                }
            }
        }
       
        set children [$node childNodes]
        if {[llength $children]==1 && [$children nodeName] eq "#text"} {
            append text "-textValue [$children nodeValue]"
            set done 1
        }
        
    }
        
        # -- set a unique ID to every treeNode
    if {$nodeID eq {}} {
        incr free_ObjectID
        set  tree_nodeID [format "_set_to_%s" $free_ObjectID]
    } else {
        set  tree_nodeID $nodeID
    }
    
    append nodeText "<$nodeName id=\"$tree_nodeID\" "
    append nodeText "$text"
    append nodeText "/>"

    
        # -- insert the treeNode
    set treeItem [$w insert $parent end -id $tree_nodeID -text $nodeName -tags $node -open 1 -values [list $nodeID "$nodeText" ] ]
        
    switch -exact [expr $domDepth-1] {
       0     {    set r [format %x  0];    set g [format %x  0];    set b [format %x 15]}
       1     {    set r [format %x  3];    set g [format %x  0];    set b [format %x 12]}
       2     {    set r [format %x  6];    set g [format %x  0];    set b [format %x  9]}
       3     {    set r [format %x  9];    set g [format %x  0];    set b [format %x  6]}
       4     {    set r [format %x 12];    set g [format %x  0];    set b [format %x  3]}
       5     {    set r [format %x 15];    set g [format %x  0];    set b [format %x  0]}
       6     {    set r [format %x 12];    set g [format %x  3];    set b [format %x  0]}
       7     {    set r [format %x  9];    set g [format %x  6];    set b [format %x  0]}
       8     {    set r [format %x  6];    set g [format %x  9];    set b [format %x  0]}
       9     {    set r [format %x  3];    set g [format %x 12];    set b [format %x  0]}
      10     {    set r [format %x  0];    set g [format %x 15];    set b [format %x  0]}
      11     {    set r [format %x  0];    set g [format %x 12];    set b [format %x  3]}
      12     {    set r [format %x  0];    set g [format %x  9];    set b [format %x  6]}
      13     {    set r [format %x  0];    set g [format %x  6];    set b [format %x  9]}
      14     {    set r [format %x  0];    set g [format %x  3];    set b [format %x 12]}
      15     {    set r [format %x  0];    set g [format %x  0];    set b [format %x 15]}
      default 
        {    set r [format %x 12];    set g [format %x 12];    set b [format %x 12]}
    }
    set fill [format "#%s%s%s%s%s%s" $r $r $g $g $b $b] 
    
    $w tag configure $treeItem -foreground $fill

    if {$parent eq {}} {$w item $treeItem -open 1}

    if !$done {
        foreach child [$node childNodes] {
            recursiveInsertTree $w $child $treeItem
        }
    }
}


proc cad4tcl::app::simplifySVG::view::cleanupTree {w} {
    foreach childNode [$w children {} ] {
        $w detach     $childNode
        $w delete     $childNode
    }    
}

proc cad4tcl::app::simplifySVG::view::getAttributes node {
    if {![catch {$node attributes} res]} {set res}
} 

proc cad4tcl::app::simplifySVG::view::updateContent {} {
    
    variable cvObject
    variable fileName
    variable sourceTree
    variable sourceText
    variable workTree
    variable targetText 
    variable svgRootTarget
    variable currentVersion
    
    $cvObject deleteContent

    cleanupTree $workTree

        # --- fill outputs ---------
    set svg [$targetText get 1.0 end]
    dom parse  $svg doc
    $doc documentElement root
    
    drawSVG $root $cvObject {0 0}
    
    recursiveInsertTree $workTree     $root     {}
    
    fitContent
    
    wm title . "simplifySVG $currentVersion - $fileName (modified)"
   
}

proc cad4tcl::app::simplifySVG::view::fitContent {} {
    variable cvObject
    variable fitVector
    variable svgRootTarget
    
    puts "\n"
    puts "  =============================================="
    puts "   -- fitContent:   $cvObject"
    puts "  =============================================="
    puts "\n"
    
    
    set fitVector [list 0 0 1]
    
    $cvObject fit
    $cvObject fitContent __Content__
    
    
    return
    
}


proc cad4tcl::app::simplifySVG::view::setCenter {} {

    variable svg_CurrentID 
    variable targetText 
    variable exportFileName
    variable file_saveCount
    
    variable svgRootSource
    variable svgRootTarget
    
    
    puts "\n"
    puts "  =============================================="
    puts "   -- setCenter:   $svgRootTarget "
    puts "        -> $svg_CurrentID"
    puts "        -> $::Find"
    puts "  =============================================="
    puts "\n"
    
        # puts "    -> ::Find   $::Find"
    if {$svg_CurrentID eq {}} {
        if {$::Find eq {}} {
            return
        } else {
            set svg_CurrentID $::Find
        }
    }
        #
    set nodeCurrent [$svgRootTarget selectNodes "//*\[@id=\"$svg_CurrentID\"\]"]
    set center_x {}
    set center_y {}
    catch {set center_x [$nodeCurrent getAttribute cx]}    
    catch {set center_y [$nodeCurrent getAttribute cy]}    
        #
        # puts ""
        # puts "    -> \$svg_CurrentID $svg_CurrentID"
        # puts ""
        # puts "[$svgRootTarget asXML]"
        # puts ""
        # puts "[$nodeCurrent asXML]"
        # puts ""
        # puts "      -> \$center_x $center_x"    
        # puts "      -> \$center_y $center_y"    
        #
    if {$center_x eq {} || $center_y eq {}} {
        return
    }
        #
    set nodeOrigin  [$svgRootTarget selectNodes "//*\[@id=\"center_00\"\]"]
        #
    if {$nodeOrigin ne {}} {
        # puts "[$nodeOrigin asXML]"
        set parentNode [$nodeOrigin parentNode]
        $parentNode removeChild $nodeOrigin
        $nodeOrigin delete
    }
        #  
    set nodeRoot    [$svgRootTarget root]
    set nodeCenter  [$nodeCurrent   cloneNode]
    $nodeCenter setAttribute id "center_00"
        #
    #set parentNode  [$nodeCurrent parentNode]
    $nodeRoot appendChild $nodeCenter
        #
        # puts "[$svgRootTarget asXML]"
        # puts ""
        # puts "[$nodeCenter asXML]"
        #
        #
        # updateSVGDom
    update_TargetText
        # targetText    
        
    updateContent
        #
        #
    return
        #
}


proc cad4tcl::app::simplifySVG::view::saveContent {{mode {}}} {
    variable targetText 
    variable exportFileName
    variable file_saveCount
    variable outputDir

    puts "\n"
    puts "  =============================================="
    puts "   -- saveContent:   $exportFileName"
    puts "  =============================================="
    puts "\n"
    
    set systemTime [clock seconds]
    set timeString [clock format $systemTime -format %Y%m%d_%H%M%S]
    incr file_saveCount
   
    set fileName   [file rootname  [file tail $exportFileName]]
    set fileName   [format "%s_%s_%s.svg" $fileName $timeString $file_saveCount]
    
    
    set svgText [$targetText get 1.0 end]            
    dom parse  $svgText doc
    $doc documentElement root
    $root setAttribute  xmlns "http://www.w3.org/2000/svg"
     
    if {$mode eq {}} {
        set fileName [tk_getSaveFile -title "Export Content as svg" -initialdir $outputDir -initialfile $fileName ]
        set outputDir [file dirname $fileName]
        if {$fileName eq {}} return
    }
    
    set fileId [open $fileName "w"]
        # puts -nonewline $fileId {<?xml version="1.0" encoding="UTF-8"?>}
        # puts -nonewline $fileId "\n"
    puts [encoding names]
        # fconfigure $fileId -encoding {utf-8}
        # fconfigure $fileId -encoding {iso8859-8}
        # puts -nonewline $fileId $svgText
    puts -nonewline $fileId [$doc asXML -doctypeDeclaration 1]
        # puts -nonewline $fileId [$doc asXML]
    close $fileId
    
    puts "\n         ... file saved as:"
    puts "               [file join [file normalize .] $exportFileName] \n"
}


proc cad4tcl::app::simplifySVG::view::event_workTree {W T x y args} {
    variable flatSVG
    variable targetText
    variable detailText
    variable cvObject
    variable my_Center_Object
    variable svg_LastID
    variable svg_CurrentID  
    
    
    puts "\n  -> event_workTree:  $W $T $x $y $args"
    set treeItem     [$W selection]
    puts "         treeItem: $treeItem"

    foreach itemID $treeItem {
        puts "         itemID: $itemID"
        set itemObject   [$W item $itemID]                     
            # puts "         $itemObject"
        set svgNodeID    [$W set $itemID nodeID]
        set svgNodeType  [$W item $itemID -text]
            # puts "           -> \$svgNodeID $svgNodeID"
            puts "           -> \$svgNodeType $svgNodeType"
            # searchrep'init $targetText $svgNodeID
        searchrep'next $targetText $svgNodeID
        
        toggle_highlight_Object $svgNodeID  on          
        toggle_highlight_Object $svg_LastID off               
        set svg_LastID    $svgNodeID
        set svg_CurrentID $svgNodeID  
           # puts "\n"
    }
    
        #set selectedNode [$flatSVG getElementById $svgNodeID]
        #puts "\n   ->selectedNode: $svgNodeID"
        #puts "$selectedNode"
    
        # puts "   [$W item $itemID -text]\n"
        # puts "   [$W set $itemID nodeID]\n"
        # puts "   [$W set $itemID nodeValue]\n"
    
    set nodeXML [$W set $itemID nodeValue]
        # puts "$nodeXML"
        #
    set nodeSVG [dom parse $nodeXML]
    $nodeSVG documentElement root
        # puts [$nodeSVG asXML]
        #
    set nodeType [$root nodeName]    
        #
        
    $detailText delete 1.0 end
    
        #$detailText insert end "$my_Center_Object\n"
    $detailText insert end "------------------------\n"
    $detailText insert end "Node Attributes: $nodeType\n"
    $detailText insert end "------------------------\n\n"
        #$detailText insert end "   item -text:     [$W item $itemID -text]\n"
        #$detailText insert end "   item nodeID:    [$W set $itemID nodeID]\n"
        #$detailText insert end "   item nodeValue: [$W set $itemID nodeValue]\n"
    
    foreach attr [$root attributes] {
        # puts "   -> $attr   [$root getAttribute $attr]"
        set attrValue [$root getAttribute $attr]
        $detailText insert end [format {%-8s: %s} $attr $attrValue]
        $detailText insert end "\n"    
    }

    switch -exact $nodeType {
        polygon {
                set points [$root getAttribute points]
                set p0 [lindex $points 0]
                foreach {x y} [split $p0 ,] break
                set min_x $x
                set min_y $y 
                set max_x $x
                set max_y $y
                foreach xy [lrange $points 1 end] {
                    foreach {x y} [split $xy ,] break
                    if {$x < $min_x} {set min_x $x}
                    if {$x > $max_x} {set max_x $x}
                    if {$y < $min_y} {set min_y $y}
                    if {$y > $max_y} {set max_y $y}
                }
                set center_x [expr ($min_x + $max_x)/2]
                set center_y [expr ($min_y + $max_y)/2]
                    #
                $detailText insert end "\n"    
                $detailText insert end "------------------------\n"
                $detailText insert end "<circle id=\"center_00\" cx=\"$center_x\" cy=\"$center_y\" r=\"5\"/>"    
                $detailText insert end "\n"    
                    #
            }
    }
        #
    return
}           


proc cad4tcl::app::simplifySVG::view::event_Canvas {tagName {type {}}} {
    variable cvObject
    variable workTree
    variable targetText
    variable my_Center_Object
    variable fitVector
    variable svg_CurrentID
    
      # -- set svg_CurrentID
      #
    set svg_CurrentID $tagName  
      
      # -- create a center Circle on canvas
      #
    puts "\n    .. $tagName"
    catch {$cvObject delete {_my_Center_}}
        #
    set objectBBox  [$cvObject bbox $tagName]
        #
    set objectCntr  [cad4tcl::_getBBoxInfo $objectBBox center]
        #
    puts "         ... \$objectCntr $objectCntr"
        #
    set objectSize  [cad4tcl::_getBBoxInfo $objectBBox size]
        #
    puts "         ... \$objectCntr $objectCntr"
    puts "         ... \$objectSize $objectSize"
        #
    foreach {center_x center_y} $objectCntr break
    foreach {width height} $objectSize break
        #
    puts "         ... \$center_x $center_x"
    puts "         ... \$center_y $center_y"
        #
    set cvCanvas    [$cvObject getCanvas]
    $cvCanvas create oval [list [expr $center_x - 5]  [expr $center_y - 5]  [expr $center_x + 5]  [expr $center_y + 5]] -tags  {_my_Center_  __Content__}
        #
        #
        
        #   cx="278.8849839782714" cy="147.361163
        # puts "         ... [$cvObject coords $tagName]"
        # set my_Center_Object "$fitVector\ncenter:$center_x/$center_y\nc: $cx/$cy\n<circle id=\"center_00\" cx=\"$center_x\" cy=\"$center_y\" r=\"5\"/>" 
    set my_Center_Object    "" 
        #append my_Center_Object "$canvasWidth / $canvasHeight   \n" 
        #append my_Center_Object "$fitVector   \n" 
        #append my_Center_Object "    center on Canvas -> $center_x $center_y  ($width/$height)\n" 
        #append my_Center_Object "<circle id=\"center_00\" cx=\"$center_x\" cy=\"$center_y\" r=\"5\"/>" 
        # set my_Center_Object "<circle id=\"center_00\" cx=\"$cx\" cy=\"$cy\" r=\"5\"/>" 
    puts $my_Center_Object
        #
        #
        #
    
    
        #
        # searchrep'next $targetText $tagName
    open_toNode $workTree $tagName
    catch {$workTree focus $tagName}
    catch {$workTree selection set $tagName}
    catch {$workTree see [lindex $tagName 0]}

}


proc cad4tcl::app::simplifySVG::view::open_toNode {w itemID} {
    if {$itemID != {}} {
        $w item [$w parent $itemID] -open 1
        open_toNode $w [$w parent $itemID]
    }
}


proc cad4tcl::app::simplifySVG::view::toggle_fillGeometry {} {
    variable fillGeometry
    
    if {$fillGeometry eq {}} {
        set fillGeometry gray80
    } else {
        set fillGeometry {}
    }

    updateContent   
}


proc cad4tcl::app::simplifySVG::view::toggle_highlight_Object {svgObject {status {on}}} {
    variable cvObject
    if {$status eq {on}} {
        set highlight_Color red
    } else {
        set highlight_Color black
    }
    set svgType [$cvObject type $svgObject]
    switch -exact $svgType {
                     g {}
                     polyline -
                     line { # set myObject [$canvas create line $objectPoints -fill black]
                                $cvObject itemconfigure $svgObject -fill $highlight_Color
                            }                           
                     rect -
                     polygon -
                     oval -
                     circle -
                     ellipse { # circle class="fil0 str2" cx="58.4116" cy="120.791" r="5.04665"
                                 $cvObject itemconfigure $svgObject -outline $highlight_Color 
                        }
                     default {
                            # tk_messageBox -message "What about $svgType"
                     }
    }
}

            
        # -- http://wiki.tcl.tk/15612
        #    Richard Suchenwirth 2006-03-17
        #
        variable IgnoreCase 0
        variable Find {}
        variable Replace {}
        
        
        proc cad4tcl::app::simplifySVG::view::searchrep {t {replace 1}} {
           #variable IgnoreCase
           set w .sr
           if ![winfo exists $w] {
               toplevel $w
               wm title $w "Search"
               grid [label $w.1 -text Find:] [entry $w.f -textvar ::Find] \
                       [button $w.bn -text Next \
                       -command [list searchrep'next $t]] -sticky ew
               bind $w.f <Return> [list $w.bn invoke]
               if $replace {
                   grid [label $w.2 -text Replace:] [entry $w.r -textvar ::Replace] \
                           [button $w.br -text Replace \
                           -command [list searchrep'rep1 $t]] -sticky ew
                   bind $w.r <Return> [list $w.br invoke]
                   grid x x [button $w.ba -text "Replace all" \
                           -command [list searchrep'all $t]] -sticky ew
               }
               grid x [checkbutton $w.i -text "Ignore case" -variable ::IgnoreCase] \
                       [button $w.c -text Cancel -command "destroy $w"] -sticky ew
               grid $w.i -sticky w
               grid columnconfigure $w 1 -weight 1
               $t tag config hilite -background lightblue
           } else {raise $w}
        }       
        
        
        proc cad4tcl::app::simplifySVG::view::searchrep'init {w {searchString {}}} {
            #
            # ... check this in flatSVG::gui::event_workTree
            #
            $w tag config hilite -background lightblue
            if {$searchString ne {}} {
                puts "   searchrep'init 00 -> searchString: $::Find"
                puts "   searchrep'init 01 -> searchString: $searchString"
                set ::Find $searchString
            }
            puts "   searchrep'init 02 -> searchString: $::Find"
            foreach {from to} [$w tag ranges hilite] {
                 $w tag remove hilite $from $to
            }
            set cmd [list $w search -count n -- $::Find insert+2c]
            puts "\$cmd $cmd"
            if $::IgnoreCase {set cmd [linsert $cmd 2 -nocase]}
            set pos [eval $cmd]
            set pos 0.0
            puts "\$pos $pos"
            set lineNb 0
            puts "\$lineNb $lineNb"
                # puts "   ... found at $pos - $n -> $lineNb"        
                # puts "   ... found at $pos - $n"        
            if {$pos ne ""} {
                 $w mark set insert ${lineNb}.0
                 $w see insert
                 $w tag add hilite ${lineNb}.0 [expr $lineNb +1].0-1c
                 # $w mark set insert $pos
                 # $w see insert
                 # $w tag add hilite $pos $pos+${n}c
            }
        }
        
        
        proc cad4tcl::app::simplifySVG::view::searchrep'next {w {searchString {}}} {
            $w tag config hilite -background lightblue
            if {$searchString ne {}} {
                puts "   searchrep'next 00 -> searchString: $::Find"
                puts "   searchrep'next 01 -> searchString: $searchString"
                set ::Find $searchString
            }
            puts "   searchrep'next 02 -> searchString: $::Find"
            foreach {from to} [$w tag ranges hilite] {
                 $w tag remove hilite $from $to
            }
            set cmd [list $w search -count n -- $::Find insert+2c]
            if $::IgnoreCase {set cmd [linsert $cmd 2 -nocase]}
            set pos [eval $cmd]
            set lineNb [lindex [split $pos .] 0]
                # puts "   ... found at $pos - $n -> $lineNb"        
                # puts "   ... found at $pos - $n"        
            if {$pos ne ""} {
                 $w mark set insert ${lineNb}.0
                 $w see insert
                 $w tag add hilite ${lineNb}.0 [expr $lineNb +1].0-1c
                 # $w mark set insert $pos
                 # $w see insert
                 # $w tag add hilite $pos $pos+${n}c
            }
        }   
        
        
        proc cad4tcl::app::simplifySVG::view::searchrep'rep1 w {
           if {[$w tag ranges hilite] ne ""} {
               $w delete insert insert+[string length $::Find]c
               $w insert insert $::Replace
               searchrep'next $w
               return 1
           } else {return 0}
        }
        
        
        proc cad4tcl::app::simplifySVG::view::searchrep'all w {
            set go 1
            while {$go} {set go [searchrep'rep1 $w]}
        }
        
        # -- http://wiki.tcl.tk/15612
        #    Richard Suchenwirth 2006-03-17
        #


proc cad4tcl::app::simplifySVG::view::bindPrecision {} {
    variable svgPrecision
    puts "   -> bindPrecision $svgPrecision"
    set oldPrecision [cad4tcl::app::simplifySVG::model::setPrecision]
    set svgPrecision [cad4tcl::app::simplifySVG::model::setPrecision $svgPrecision]
    puts "                 -> $oldPrecision - $svgPrecision"
    if {$oldPrecision ne $svgPrecision} {
        set svgPrecision $svgPrecision
        reloadSVGFile
    }
}
    
    #
# =====================================================================================
    #
    # --- window ----------
    #
proc cad4tcl::app::simplifySVG::view::build {w} {
    
    variable sourceTree
    variable sourceText
    variable workTree
    variable cvObject
    variable detailText
    variable targetText
    variable svgPrecision
    
    variable currentVersion
    
    
    if {$w == {.} || $w == {}} {
        set rootFrame   [frame .f -bg lightblue]
        #pack $rootFrame  -expand yes  -fill both
    } else {
        set rootFrame   [frame $w.f -bg lightblue]
    }
    pack $rootFrame  -expand yes  -fill both
        # pack [ frame .f -bg lightblue]
        
        # -- Menue Frame ----------------------
    set buttonBar       [frame $rootFrame.bb  -bd 2  -relief sunken]
    pack $buttonBar      -expand yes  -fill x 
        #
    ttk::button $buttonBar.bt_open      -width 15   -text " open "             -command [namespace current]::openSVGFile
    ttk::button $buttonBar.bt_reopen    -width 15   -text " reopen "           -command [namespace current]::reloadSVGFile
    label       $buttonBar.lb_prec                  -text "   Precision: "
    ttk::button $buttonBar.bt_update    -width 15   -text " update -> "           -command [namespace current]::updateSVGDom
    ttk::entry  $buttonBar.nt_prec      -width 10   -textvar [namespace current]::svgPrecision  
    ttk::button $buttonBar.bt_fit       -width 15   -text " fit "              -command [namespace current]::fitContent
    ttk::button $buttonBar.bt_updCnt    -width 15   -text " <- update "   -command [namespace current]::updateContent   
    ttk::button $buttonBar.bt_toggle    -width 15   -text " toggle fill "      -command [namespace current]::toggle_fillGeometry
        #
    ttk::button $buttonBar.bt_save      -width 15   -text " export "     -command [namespace current]::saveContent
        #
    label       $buttonBar.sp_00                     -text "      "
    label       $buttonBar.sp_01                     -text "      "
    label       $buttonBar.sp_02                     -text "      "
    label       $buttonBar.sp_03                     -text "      "
        #
    
    #button $buttonBar.saveContent    -text "   save Content   "        -command saveContent
    pack        $buttonBar.bt_open  $buttonBar.bt_reopen  $buttonBar.lb_prec $buttonBar.nt_prec $buttonBar.bt_update \
                    $buttonBar.sp_00 \
                $buttonBar.bt_fit \
                    $buttonBar.sp_01 \
                $buttonBar.bt_updCnt \
                    $buttonBar.sp_02\
                $buttonBar.bt_toggle    \
            -side left  -padx 2  -pady 2
    pack        $buttonBar.bt_save \
            -side right  -padx 2  -pady 2
             
    set nb_result       [ttk::notebook $rootFrame.nb]
    pack $nb_result     -expand yes -fill both   
     
    $nb_result add      [frame $nb_result.nb_source]      -text "     SVG Source-View     "         
    $nb_result add      [frame $nb_result.nb_work]        -text "      SVG Work-View      "         

       
       # --- ttk::style - treeview ---
       #
       # ttk::style map Treeview.Row  -background [ list selected gainsboro ]
    ttk::style map Treeview.Row  -background [ list selected blue ]
    
  
        #
        # -- SOURCE Frame ----------------------
        #
    set sourceFrame        [frame $nb_result.nb_source.f    -relief flat ]    
    pack $sourceFrame    -expand yes -fill both
        #
        # -- build content
        #
    build_SourceView $sourceFrame
    
        
        #
        # -- WORKING Frame ----------------------
        #
    set workFrame         [frame $nb_result.nb_work.f    -relief flat ]
    pack $workFrame    -expand yes -fill both
        #
        # -- build content
        #
    build_WorkView $workFrame
   
        

        # --- compute ----------
        #
    $nb_result select  1
    update    
    #$nb_result select  0    
    
        # --- update Canvas ----------
        #
    $cvObject fit
    
    puts "   ->\$rootFrame $rootFrame"
    if {$rootFrame eq {.}} {   
        wm title . "simplifySVG $currentVersion"
    }
    
    bind $buttonBar.nt_prec <Return>            [list [namespace current]::bindPrecision]
    bind $buttonBar.nt_prec <Enter>             [list [namespace current]::bindPrecision]
    bind $buttonBar.nt_prec <Leave>             [list [namespace current]::bindPrecision]
    bind $workTree          <<TreeviewSelect>>  [list [namespace current]::event_workTree %W %T %x %y %k]    
    bind .                  <Control-Key-f>     [list [namespace current]::searchrep $targetText]
    bind .                  <Control-Key-s>     [list [namespace current]::saveContent force]
    
    set svgPrecision [cad4tcl::app::simplifySVG::model::setPrecision 100]
    
    return $rootFrame

}

proc cad4tcl::app::simplifySVG::view::build_SourceView {w} {

    variable sourceTree
    variable sourceText
    
    set sourceTreeFrame     [ frame    $w.f_tree       -relief sunken ]
    set sourceTextFrame     [ frame    $w.f_text       -relief sunken ]
        pack $sourceTreeFrame $sourceTextFrame   \
                     -expand yes -fill both -padx 15 -pady 15 -side left  
                     
        # --- result deep svg  - treeview---
        #
    set sourceTree [ ttk::treeview $sourceTreeFrame.t   \
                    -columns         "nodeID nodeValue" \
                    -displaycolumns "nodeID nodeValue" \
                    -xscrollcommand "$sourceTreeFrame.x set" \
                    -yscrollcommand "$sourceTreeFrame.y set" \
                    -height 20 ]
        $sourceTree heading "#0"  -text "XML" -anchor w
        $sourceTree column  "#0"  -width 150
        $sourceTree heading nodeID     -text "id" 
        $sourceTree column  nodeID     -width 100 -stretch no
        $sourceTree heading nodeValue -text "Value" 
        $sourceTree column  nodeValue -width 100 
        
    scrollbar $sourceTreeFrame.x -ori hori -command  "$sourceTreeFrame.t xview"
    scrollbar $sourceTreeFrame.y -ori vert -command  "$sourceTreeFrame.t yview"
        grid $sourceTreeFrame.t $sourceTreeFrame.y    -sticky news
        grid $sourceTreeFrame.x                     -sticky news
        grid rowconfig    $sourceTreeFrame 0 -weight 1
        grid columnconfig $sourceTreeFrame 0 -weight 1

                
        # --- result flattend svg - textview ---
    set sourceText [ text $sourceTextFrame.txt -wrap none -xscroll "$sourceTextFrame.h set" \
                                                      -yscroll "$sourceTextFrame.v set" -height 20 -width 70 ]
    scrollbar $sourceTextFrame.v -orient vertical   -command "$sourceTextFrame.txt yview"
    scrollbar $sourceTextFrame.h -orient horizontal -command "$sourceTextFrame.txt xview"
        # Lay them out
        grid $sourceTextFrame.txt $sourceTextFrame.v    -sticky nsew
        grid $sourceTextFrame.h                         -sticky nsew
        # Tell the text widget to take all the extra room
        grid rowconfigure    $sourceTextFrame.txt 0 -weight 1
        grid columnconfigure $sourceTextFrame.txt 0 -weight 1                      
        #
        # 

        # --- final layout
         
        
}

proc cad4tcl::app::simplifySVG::view::build_WorkView {w} {

    variable workTree
    variable cvObject
    variable detailText
    variable targetText
    variable svgPrecision
    
    set workTreeFrame   [frame  $w.f_tree   -relief sunken ]
    set workDetailFrame [frame  $w.f_detail -relief sunken ]
    set workTextFrame   [frame  $w.f_text   -relief sunken ]
        #
    pack $workTreeFrame $workDetailFrame $workTextFrame \
                     -expand yes -fill both -padx 5 -pady 5 -side left

        
      
        # --- result flattend svg - treeview ---
        #
    set workTree [ ttk::treeview $workTreeFrame.t  \
                    -columns        "nodeID nodeValue" \
                    -displaycolumns "nodeID nodeValue" \
                    -xscrollcommand "$workTreeFrame.x set" \
                    -yscrollcommand "$workTreeFrame.y set" \
                    -height 20 ]
        $workTree heading "#0"      -text "XML" -anchor w
        $workTree column  "#0"      -width 150
        $workTree heading nodeID     -text "id" 
        $workTree column  nodeID     -width 100 -stretch no
        $workTree heading nodeValue -text "Value" 
        $workTree column  nodeValue -width 100 
    
    scrollbar $workTreeFrame.x -ori hori -command  "$workTreeFrame.t xview"
    scrollbar $workTreeFrame.y -ori vert -command  "$workTreeFrame.t yview"
        grid $workTreeFrame.t     $workTreeFrame.y  -sticky news
        grid $workTreeFrame.x                       -sticky news
        grid rowconfig        $workTreeFrame 0  -weight 1
        grid columnconfig     $workTreeFrame 0  -weight 1
             

        # --- result canvas ---
        #
    set resultFrame [frame $workDetailFrame.cv]
    set cvObject    [cad4tcl::new  $resultFrame  500 330  A3  1.0  30  -bd 2  -bg white  -relief sunken]
    
        # --- center button ---
        #
    ttk::button $workDetailFrame.bt_ct   -text " set as Center "  -command [namespace current]::setCenter
        
        # --- detail text ---
        #
    set detailText  [text $workDetailFrame.txt -wrap none \
                                                 -xscroll "$workDetailFrame.h set" \
                                                 -yscroll "$workDetailFrame.v set" -width 20 -height 10]
        scrollbar $workDetailFrame.v -orient vertical   -command "$workDetailFrame.txt yview"
        scrollbar $workDetailFrame.h -orient horizontal -command "$workDetailFrame.txt xview"
            #
            
        # --- layout --------   
            # grid $resultCanvas          -column 0 -row 0 -sticky nsew -columnspan 2
        grid $resultFrame           -column 0 -row 0 -sticky nsew -columnspan 2
        grid $workDetailFrame.bt_ct -column 0 -row 1 -sticky nsew -columnspan 2  -padx 2  -pady 2
        grid $workDetailFrame.txt   -column 0 -row 2 -sticky nsew
        grid $workDetailFrame.v     -column 1 -row 2 -sticky ns
        grid $workDetailFrame.h     -column 0 -row 3 -sticky ew
            # Tell the text widget to take all the extra room
        grid rowconfigure    $workDetailFrame 0 -weight 60
        grid rowconfigure    $workDetailFrame 2 -weight 40
        grid columnconfigure $workDetailFrame 0 -weight 100
        grid columnconfigure $workDetailFrame 1 -weight 0


        # --- result flattend svg - textview ---
        #
    set targetText  [text $workTextFrame.txt        -wrap none \
                                                    -xscroll "$workTextFrame.h set" \
                                                    -yscroll "$workTextFrame.v set" \
                                                    -width 40 -height 30]
    scrollbar $workTextFrame.v  -orient vertical    -command "$workTextFrame.txt yview"
    scrollbar $workTextFrame.h  -orient horizontal  -command "$workTextFrame.txt xview"
        # Lay them out
    grid $workTextFrame.txt     -column 0 -row 0 -sticky nsew
    grid $workTextFrame.v       -column 1 -row 0 -sticky nsew
    grid $workTextFrame.h       -column 0 -row 1 -sticky nsew
        # grid $workTextFrame.bt_save -column 0 -row 2 -sticky nsew -columnspan 2
        # Tell the text widget to take all the extra room
    grid rowconfigure    $workTextFrame 0 -weight 90
    grid rowconfigure    $workTextFrame 1 -weight 10
    grid columnconfigure $workTextFrame 0 -weight 1 
        #
        #
}
