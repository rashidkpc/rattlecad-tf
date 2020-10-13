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
    
    set APPL_BASE_Dir [file normalize [file dirname [lindex $argv0]]]
    set APPL_ROOT_Dir [file dirname $APPL_BASE_Dir]
    puts "   -> \$APPL_BASE_Dir $APPL_BASE_Dir"
    puts "   -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
        #
    lappend auto_path [file normalize $APPL_ROOT_Dir/..]
    lappend auto_path [file normalize $APPL_ROOT_Dir/../_ext__Libraries]
        #
    foreach path $auto_path {
        puts "   -> $path"
    }
    
    package require myTool
 
    chainWheel::buildToplevelGUI
    
