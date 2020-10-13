 ##+##########################################################################
 #
 # tool_SVG_Component.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2010/02/06
 #
 #   myGUI is licensed using the GNU General Public Licence,
 #        see http://www.gnu.org/copyleft/gpl.html
 # 
 


set WINDOW_Title      "myGUI - tool: SVG_Component"

set BASE_Dir            [file normalize [file dirname [file normalize $::argv0]]] 

set TEST_ROOT_Dir       [file normalize [file dirname [lindex $argv0]]]
set TEST_Library_Dir    [file dirname [file dirname $TEST_ROOT_Dir]]
set TEST_Sample_Dir     [file join $TEST_ROOT_Dir _sample]
set TEST_Export_Dir     [file join $TEST_ROOT_Dir _export]
    #
puts "   \$TEST_ROOT_Dir ... $TEST_ROOT_Dir"
puts "    -> \$TEST_Library_Dir ... $TEST_Library_Dir"
puts "    -> \$TEST_Sample_Dir .... $TEST_Sample_Dir"
puts "    -> \$TEST_Export_Dir .... $TEST_Export_Dir"
    #
    #
foreach dir $tcl_library {
    puts "   -> tcl_library $dir"
}
    #
set tcl_pkgPath $TEST_Library_Dir
foreach dir $tcl_pkgPath {
    puts "   -> tcl_pkgPath $dir"
}

lappend auto_path [file dirname $TEST_ROOT_Dir]
lappend auto_path "$TEST_Library_Dir/_ext__Libraries"
lappend auto_path "$TEST_Library_Dir"


package require myGUI

proc myGUI::main {baseDir {startupProject {}}} {
        #
        #
    puts "\n\n ====== M A I N ============================ \n\n"
        #
        
        #
    myGUI::init $baseDir     
        #
        
        # -- MVC - Model
        #
    myGUI::control::init_Model
        #
    myGUI::control::add_ComponentDir user   [file join $::APPL_Config(USER_Dir) components]
        #

        # -- ... if there is a given Project-File
        #
    # myGUI::open_StartupProject $startupProject
        #
        
        # -- MVC - View
        #
    # myGUI::init_GUI
        #
        
        #
    # myGUI::control::updateControl
        #
        
        #
    # myGUI::view::edit::update_windowTitle  
    # myGUI::view::edit::update_MainFrameStatus
        #
    # tk appname  rattleCAD
        #
        #
    puts "\n"
    puts "  ----------------------------------------------"
    puts "  rattleCAD      $::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"
    puts "                             $::APPL_Config(RELEASE_Date)"
    puts "  ----------------------------------------------\n"
    
        #
}


myGUI::init $BASE_Dir

# set cad4tcl::canvasType   1
puts "   -> \$myGUI::GUIConfig(antialias) $myGUI::GUIConfig(antialias)"
puts "   -> \$cad4tcl::canvasType $cad4tcl::canvasType"

cad4tcl::app::simplifySVG::buildToplevelGUI

# flatSVG::buildToplevelGUI




  
  
   
 
 

 