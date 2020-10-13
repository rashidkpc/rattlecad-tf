 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classExtension_DXF_Canvas.tcl
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
namespace eval cad4tcl {oo::class create Extension_DXF_Canvas}
    #
oo::define cad4tcl::Extension_DXF_Canvas {
        #
    superclass cad4tcl::Extension_DXF__Super    
        #
    constructor {cvObj args} { 
            #
        puts "              -> class Extension_DXF_Canvas"
            #
        next $cvObj $args
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy Extension_DXF_Canvas"
            #
    }
        #
    method unknown {target_method args} {
                     puts "<E> ... cad4tcl::Extension_DXF_Canvas $target_method $args  ... unknown"
    }
        #
}

