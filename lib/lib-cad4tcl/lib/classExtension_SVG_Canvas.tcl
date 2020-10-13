 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classExtension_SVG_Canvas.tcl
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
namespace eval cad4tcl {oo::class create Extension_SVG_Canvas}
    #
oo::define cad4tcl::Extension_SVG_Canvas {
        #
    superclass cad4tcl::Extension_SVG__Super    
        #
    constructor {cvObj itemIF args} { 
            #
        puts "              -> class Extension_SVG_Canvas"
            #
        next $cvObj $itemIF $args
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy Extension_SVG_Canvas"
            #
    }
        #
    method unknown {target_method args} {
                     puts "<E> ... cad4tcl::Extension_SVG_Canvas $target_method $args  ... unknown"
    }
        #
}

