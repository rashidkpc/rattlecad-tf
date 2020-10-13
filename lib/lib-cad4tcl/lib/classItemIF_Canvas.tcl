 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classItemIF_Canvas.tcl
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
namespace eval cad4tcl {oo::class create ItemInterface_Canvas}
    #
oo::define cad4tcl::ItemInterface_Canvas {
        #
    superclass cad4tcl::ItemInterface__Super    
        #
    constructor {cvObj} { 
            #
        puts "              -> class ItemInterface_Canvas"
        puts "                  -> $cvObj"
            #
        next $cvObj
            #
        variable canvasObject   $cvObj
            #
        variable canvasPath     [$canvasObject getCanvas]
            #
        variable DXF            [cad4tcl::Extension_DXF_Canvas    new $canvasObject ]     
        variable SVG            [cad4tcl::Extension_SVG_Canvas    new $canvasObject [self]]
            #
        return
            #                     
    }
        #
    destructor {
        puts "            -> [self] ... destroy ItemInterface_Canvas"
    }
        #
    method unknown {target_method args} {
        puts "<E> ... cad4tcl::ItemInterface_Canvas $target_method $args  ... unknown"
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
}

