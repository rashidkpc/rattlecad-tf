 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas   ->  cadCanvas_Image.tcl
 #
 # ----------------------------------------------------------------------
 #  namespace:  cad4tcl::image
 # ----------------------------------------------------------------------
 #
 #  2017/11/26
 #      extracted from the rattleCAD-project (Version 3.4.05)
 #          http://rattlecad.sourceforge.net/
 #          https://sourceforge.net/projects/rattlecad/
 #
 #


namespace eval cad4tcl::image {
    variable imageCounter 0
}
namespace eval cad4tcl::image:img {}
 

    #-------------------------------------------------------------------------
    #  read Image from File
    #
proc cad4tcl::image::readFile {canvasDOMNode file {canvasPosition {0 0}} {anchor {bottomLeft}} {angle {0}} {customTag {}} } {
        #
    variable imageCounter    
        #
        #   anchor:  n, ne, e, se, s, sw, w, nw, or center
        #
    set fileExtension [file extension $file]
        # puts "        ... $file"    
        # puts "        ... $canvasPosition"    
        # puts "        ... $anchor"
        # puts "        ... $angle"    
        # puts "        ... $fileExtension"
    switch -exact $fileExtension {
        {.gif}   -
        {.png}   {
                puts "        ... read $file"
            }
        default {
                puts "\n"
                puts "        ... sorry, dont know how to handle this file"
                puts "              $file"
                return {}
            }
    }
        #
    set w           [cad4tcl::getNodeAttribute    $canvasDOMNode  Canvas  path]        
        #
    set wScale      [cad4tcl::getNodeAttribute    $canvasDOMNode  Canvas  scale]            
    set stageScale  [cad4tcl::getNodeAttribute    $canvasDOMNode  Stage   scale]            
    set stageUnit   [cad4tcl::getNodeAttribute    $canvasDOMNode  Stage   unit]            
    set unitScale   [cad4tcl::_getUnitRefScale    $stageUnit]            
        #
    set posList     [cad4tcl::_convertBottomLeft  [expr {$wScale * $stageScale}] [cad4tcl::_flattenNestedList $canvasPosition]]
    set moveVector  [cad4tcl::_getBottomLeft      $w]
        #
        # puts ""
        # puts " ------------------------------------"
        # puts "       -> \$wScale     $wScale"    
        # puts "       -> \$stageScale $stageScale"    
        # puts "       -> \$unitScale  $unitScale"    
        # puts ""
        # puts "       -> \$moveVector $moveVector"
        # puts ""
        #
    if {$customTag eq {}} { 
        set imgTag  [format "img_%s" [llength [$w find withtag all]] ]
        set $imgTag {}
    } else {
        set imgTag  $customTag
    }
        #
    set img         [image create photo ::cad4tcl::image:img::img_$imageCounter -file $file]
    set imgWidth    [image width  $img]
    set imgHeigth   [image height $img]
        #puts "              00 -> $imgWidth x $imgHeigth" 
        #           [expr 1.0 * $stageScale * $wScale * $unitScale] -> 20170909
    set scale       [expr {1.0 * $stageScale * $wScale / $unitScale}]
    puts ""    
    puts "        ... cad4tcl::image::readFile  -  $img   ($imgWidth x $imgHeigth)"    
    puts "                  $file "    
    puts "                  $scale = $stageScale * $wScale / $unitScale"
    puts ""    
        #
    cad4tcl::image::scale $img $scale
        #
    set imgWidth    [image width  $img]
    set imgHeigth   [image height $img]
        #puts "              01 -> $imgWidth x $imgHeigth" 
        #
    set myItem [$w create image  $posList  -anchor $anchor   -image $img]
        #
        #puts "\n -- 80 ---------------------------------------------------"
        #cad4tcl::reportObjectBBox $canvasDOMNode $myItem
        #
        #      $myItem  0 0  $unitScale $unitScale  -> 20170909
    $w scale   $myItem  0 0  [expr {1.0 / $unitScale}] [expr {1.0 / $unitScale}]
    $w move    $myItem [lindex $moveVector 0] [lindex $moveVector 1]    
    $w addtag  {__Content__} withtag $myItem     
        #
        #puts "\n -- 90 ---------------------------------------------------"
        #cad4tcl::reportObjectBBox $canvasDOMNode $myItem
        #
    incr imageCounter    
        #
    return $myItem
        #
}

    #-------------------------------------------------------------------------
    #  image procedures
    #
proc cad4tcl::image::scale {image scale} {
        #
    puts ""    
    puts "          -- cad4tcl::scaleImage --< $scale >------"    
        #
    set precision 50    
        #
    set tmp [image create photo ::cad4tcl::image:img::tmp]
    $tmp copy $image -shrink -zoom [expr {int($precision * $scale)}]
    $image blank
    $image copy $tmp -shrink -subsample $precision
    image delete $tmp        
        #
    return
        #
}

    #-------------------------------------------------------------------------
    #  report size of object
    #
proc cad4tcl::reportObjectBBox {canvasDOMNode obj} {
    set w       [ cad4tcl::getNodeAttribute    $canvasDOMNode  Canvas   path]        
    set bbox    [$w bbox $obj]
    set width   [expr {[lindex $bbox 2] - [lindex $bbox 0]}] 
    set height  [expr {[lindex $bbox 3] - [lindex $bbox 1]}] 
    puts ""
    puts "      -> $bbox"
    puts "              -> $width x $height" 
    puts "" 
    puts "              -> [cad4tcl::getStageLength $canvasDOMNode $width]" 
    puts "              -> [cad4tcl::getStageLength $canvasDOMNode $height]" 
    puts ""
}

  
  
        
