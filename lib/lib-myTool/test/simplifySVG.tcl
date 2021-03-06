#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # 
 #
 # http://wiki.tcl.tk/3884 - Richard Suchenwirth - 2002-08-13
 # http://wiki.tcl.tk/10530 - Greg Blair - 2003-09-29    
 #
 # add a converter to read SVG-Path and convert path-Elements into polygon & polyline
 #
 # http://www.w3.org/TR/SVG/expanded-toc.html
 #
 # http://www.selfsvg.info/?section=3.5
 #
 #
 # 20150923:
 #       search polygons, polylines defined by only one point
 #
 #
 #

    package require Tk
    package require tdom
    #tk_messageBox -message "$auto_path"
    
    set APPL_BASE_Dir [file dirname [lindex $argv0]]
    set APPL_ROOT_Dir [file dirname $APPL_BASE_Dir]
    lappend auto_path [file normalize $APPL_ROOT_Dir/..]
    lappend auto_path [file normalize $APPL_BASE_Dir]
    lappend auto_path [file normalize $APPL_BASE_Dir/../lib]
        # lappend auto_path [file normalize $APPL_ROOT_Dir/../lib/lib-svgDOM]
    
    foreach path $auto_path {
        puts "    -> $path"
    }
    
    #tk_messageBox -message "$auto_path"
    
    package require cad4tcl
 
    cad4tcl::app::simplifySVG::buildToplevelGUI
    
    return
    
