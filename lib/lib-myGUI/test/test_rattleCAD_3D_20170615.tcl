#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # rattleCAD.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 

  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################

    puts "\n\n ====== I N I T ============================ \n\n"
    
    # -- ::APPL_Config(BASE_Dir)  ------
set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
puts "   -> BASE_Dir: $BASE_Dir\n"
  
    # -- redefine on Starkit  -----
    #         exception for starkit compilation
    #        .../rattleCAD.exe
set APPL_Type       [file tail $BASE_Dir]    
if {$APPL_Type == {rattleCAD.exe}}    {    
    set BASE_Dir    [file dirname $BASE_Dir]
}



    # -- Libraries  ---------------
lappend auto_path           [file join $BASE_Dir lib]
lappend auto_path           [file join $BASE_Dir ..]

    # puts "  \$auto_path  $auto_path"

package require   appUtil       0.11 
package require   extSummary    0.3
package require   osEnv
package require   myGUI

set baseDir [file normalize [file join $BASE_Dir .. rattleCAD_3.4.05]]
    #
puts "    $baseDir -> $baseDir"    
    #
myGUI::init $baseDir     
    #
    
    # -- MVC - Model
    #
myGUI::control::init_Model
    #
myGUI::control::add_ComponentDir user   [file join $::APPL_Config(USER_Dir) components]
    #
puts "\n"
puts " == rattleCAD_3D =================="
puts "       $baseDir -> $baseDir"    
puts "\n"
    #
lappend auto_path           [file normalize [file join $BASE_Dir .. _plugin rattleCAD_3D]]
foreach dir $auto_path {
    puts "  auto_path: $dir"
}  
package require rattleCAD_3D 1.03
rattleCAD_3D::initPackage
rattleCAD_3D::model_MVC::__gather_Parameter    
rattleCAD_3D::model_MVC::__writeReport    
    
puts "\n     ... done 001 \n"    

rattleCAD_3D::export_FreeCAD

puts "\n     ... done 002\n"

exit    
    
    
return

            # -- ... if there is a given Project-File
            #
        myGUI::open_StartupProject $startupProject
            #
            
            # -- MVC - View
            #
        myGUI::init_GUI
            #
            
            #
        myGUI::control::updateControl

