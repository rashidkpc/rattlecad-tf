##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


	set WINDOW_Title      "bikeComponent, using canvasCAD"

	  
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
    lappend auto_path "$APPL_ROOT_Dir/../bikeComponent"
    lappend auto_path "$APPL_ROOT_Dir/../lib-bikeComponent"
        
	# package require     Tk
    # package require     canvasCAD
    package require     extSummary
    package require     vectormath
    package require     bikeComponent
    package require     tcltest
    
    variable APPL_ROOT_Dir
    
        #
        # ---------------------------------------------
        #
    bikeComponent::init
        #
    set compLibrary     $bikeComponent::comp_Library
        #
    $compLibrary report_Object
        #
        # ---------------------------------------------
        #
    tcltest::test "register_compBaseDir" "001 - add userDir" {$compLibrary register_compBaseDir user a} {}
    tcltest::test "register_compBaseDir" "002 - add userDir" {$compLibrary register_compBaseDir user [file normalize "C:\\Users\\manfred\\Documents\\rattleCAD\\components"]} "C:/Users/manfred/Documents/rattleCAD/components"
        #
    $compLibrary report_Object
        #
    puts "\n== get_CompAlternatives ==\n"
    set retValue    [$compLibrary get_CompAlternatives HandleBar]
        #
    puts "      --------------------------"
    foreach entry $retValue {
        puts "          -> $entry"
    }
        #
    puts "\n== get_ComponentPath ==\n"
    set retValue    [$compLibrary get_ComponentPath HandleBar user:handlebar/microshift_SB_R5xx.svg]
        #
    puts "      --------------------------"
    puts "          -> $retValue"
        #
        #
        #
        #     HandleBar ComponentKey -> user:handlebar/microshift_SB_R5xx.svg
        
