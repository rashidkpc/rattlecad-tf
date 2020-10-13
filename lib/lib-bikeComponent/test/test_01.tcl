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

set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir __ext_Libraries]
 
package require   Tk
package require   appUtil
package require   cad4tcl
package require   vectormath
package require   extSummary

variable APPL_ROOT_Dir

    
namespace eval myTest {
        #
    variable cv01
    variable cv02
    variable cv03
    variable cv04
        #
    variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]] ..]]
        #
    }

source [file join $APPL_ROOT_Dir lib_compLibrary.tcl]    
        
#-------------------------------------------------------------------------
    #  open File 
    #
proc openFile {{file {}}} {
    
    puts "\n -- openFile--"
    if {$file == {} } {
        set file [tk_getOpenFile]
    }
    set fileExtension [file extension $file]
    puts "        ... $fileExtension"
    switch -exact $fileExtension {
        {.svg}   {openFile_svg   $file}
        {.gif}   {open_imageFile $file}
        {.png}   {open_imageFile $file}
        default {
                    puts "\n ... sorry, dont know how to handle this FileType\n"
        }
    
    }		
}
        
#-------------------------------------------------------------------------
    #  open File Type: gif, ...
    #
proc openFile_svg {{file {}}} {
    
    global cv03
    
    $cv03 readSVG $file {120 200} 0 AB
    $cv03 readSVG $file {320 400} 
    
}
        

#-------------------------------------------------------------------------
    #
    #
proc myTest::main {} {

    # --------------------------------------------
        #
        global APPL_ROOT_Dir
        global cv01
        global cv02
        global cv03
        global cv04
    
    
        pack [ frame .f ] -expand yes -fill both

    # --------------------------------------------
            # 	notebook
        pack [ ttk::notebook .f.nb] -fill both  -expand yes


    # --------------------------------------------
            # 	tab 1
        .f.nb add [frame .f.nb.f1] -text "First tab" 

        myTest::compLibrary::createLibrary .f.nb.f1
    
    
    # --------------------------------------------
            # 	tab 2
        .f.nb add [frame .f.nb.f2] -text "Second tab" 

        set f2_canvas  [labelframe .f.nb.f2.f_canvas   -text "board"  ]
        set f2_config  [frame      .f.nb.f2.f_config   ]

        pack  $f2_canvas  $f2_config    -side left -expand yes -fill both
        pack  configure   $f2_config    -fill y
        
        pack [frame $f2_canvas.cv01]
        
            # set retValue [canvasCAD::newCanvas cv01  $f2_canvas.cv01 	"MyCanvas_02"  880  610 	A3 0.5 40 -bd 2  -bg white  -relief sunken ]
            # foreach {cv ns} $retValue break
            # set cv02 $ns
        
        set cad4tcl::canvasType   1
        
        set cvObject [cad4tcl::new  $f2_canvas.cv01   880 610 A3 0.5 40]
        set cv02     [$cvObject getNamespace]
                
        
            
            # $cv01  create   line  		{0 0 20 0 20 20 0 20 0 0} 		-tags {Line_01}  -fill blue   -width 2 
            # $cv01  create   line  		{30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
            # $cv01  create   line  		{0 0 30 30 } 		-tags {Line_01}  -fill blue   -width 2 
            # $cv01  create   oval  		{30 160 155 230 } 	-tags {Line_01}  -fill red   -width 2 		
            # $cv01  create   circle  	{160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
            # $cv01  create   arc  		{270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
            # $cv01  create   text		{150 90}  -text "text 150 90 360°"
            # $cv01  create   vectortext	{160 30}  -text "vectorText  160 30  -size 20"  -size 20	
            # $cv01  create   vectortext	{210 70}  -text "vectorText  210 70  -size 10"  -size 10
            # $cv01  create   vectortext	{120 170} -text "Sonderzeichen:  grad \°, exp ^"  -size 10

            
        ttk::notebook::enableTraversal .f.nb				

}

#-------------------------------------------------------------------------
    #
    #
myTest::main

myTest::compLibrary::setUserDir C:/Users/manfred/Documents/rattleCAD/components
# myTest::compLibrary::setSystemDir [file join $APPL_ROOT_Dir etc components]
puts "  -- 01--  C:/Dateien/Eclipse/workspace/rattleCAD_3.4.03/bikeGeometry/components"
puts "  -- 01--  [file join $APPL_ROOT_Dir components]"
puts "   -> $myTest::compLibrary::dir_System"
puts "   -> $myTest::compLibrary::dir_User"
puts "   -> $myTest::compLibrary::dir_Custom"
myTest::compLibrary::update_compList

    