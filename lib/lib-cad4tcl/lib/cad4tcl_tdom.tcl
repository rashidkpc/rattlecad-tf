 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas  -> cadCanvas_tdom.tcl
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


proc cad4tcl::getXMLRoot {} {
    variable __packageRoot
    return $__packageRoot			
}

proc cad4tcl::getNodeRoot {pathString} {
    variable __packageRoot
    return [$__packageRoot selectNodes $pathString ]			
}

proc cad4tcl::setNodeAttributeRoot {pathString attribute value} {
    variable __packageRoot
    set node [$__packageRoot selectNodes $pathString ]
    return [$node setAttribute $attribute $value]
}

proc cad4tcl::getNodeAttributeRoot {pathString attribute} {
    variable __packageRoot
    set node [$__packageRoot selectNodes $pathString ]
    return [$node getAttribute $attribute]
}

proc cad4tcl::getNode {node pathString} {
    return [$node selectNodes $pathString ]			
}

proc cad4tcl::setNodeAttribute {node pathString attribute value} {
    set node [$node selectNodes $pathString ]
    set retValue    [$node setAttribute $attribute $value]
    return $retValue
}

proc cad4tcl::getNodeAttribute {node pathString attribute} {
    set node [$node selectNodes $pathString]
    set value [$node getAttribute $attribute]
    return [$node getAttribute $attribute]
}

proc cad4tcl::getCanvasDOMNode {pathString} {
    variable __packageRoot
    set canvasNode [$__packageRoot find path $pathString]
    set canvasID [$canvasNode parentNode ]
    return $canvasID
}

proc cad4tcl::reportXML {parent {counter {?}}} {
    puts "\n ---- $counter ------"
    set XML [$parent asXML]
    puts $XML
    puts " ---- $counter ------\n"
} 	

proc cad4tcl::reportXMLRoot {} {
    variable __packageRoot		
    puts "\n ---- __packageRoot ------"
    set XML [$__packageRoot asXML]
    puts $XML
    puts " ---- __packageRoot ------\n"
}
