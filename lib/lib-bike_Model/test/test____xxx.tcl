    set BASE_Dir  [file normalize [file dirname [file normalize $::argv0]]] 
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
    
	lappend auto_path "$APPL_ROOT_Dir"
    lappend auto_path "$APPL_ROOT_Dir/../appUtil"
    lappend auto_path "$APPL_ROOT_Dir/../lib-appUtil"
    lappend auto_path "$APPL_ROOT_Dir/../canvasCAD"
    lappend auto_path "$APPL_ROOT_Dir/../lib-canvasCAD"
    lappend auto_path "$APPL_ROOT_Dir/../extSummary"
    lappend auto_path "$APPL_ROOT_Dir/../lib-extSummary"
    lappend auto_path "$APPL_ROOT_Dir/../vectormath"
    lappend auto_path "$APPL_ROOT_Dir/../lib-vectormath"
    lappend auto_path "$APPL_ROOT_Dir/../bikeGeometry"
    lappend auto_path "$APPL_ROOT_Dir/../lib-bikeGeometry"
    lappend auto_path "$APPL_ROOT_Dir/../bikeComponent"
    lappend auto_path "$APPL_ROOT_Dir/../lib-bikeComponent"
    lappend auto_path "$APPL_ROOT_Dir/../tubeMiter"
    lappend auto_path "$APPL_ROOT_Dir/../lib-tubeMiter"
    
    package require bikeGeometry
    package require bikeComponent
    package require myGUI