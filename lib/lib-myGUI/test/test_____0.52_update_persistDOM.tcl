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
    set TEST_Dir    [file join $BASE_Dir _test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]



    # -- Libraries  ---------------
lappend auto_path           [file join $BASE_Dir lib]
lappend auto_path           [file join $BASE_Dir ..]

    # puts "  \$auto_path  $auto_path"

package require   appUtil       0.11 
package require   extSummary    0.3
package require   osEnv
package require   myGUI

set baseDir [file normalize [file join $BASE_Dir .. rattleCAD_3.4.04]]
    #
puts "    $baseDir -> $baseDir"    
    #
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
myGUI::init $baseDir     
    #
    
    # -- MVC - Model
    #
myGUI::control::init_Model
    #

lappend auto_path           [file normalize [file join $BASE_Dir .. add_Custom mockup_3D]]
foreach dir $auto_path {
    puts "  auto_path: $dir"
} 

    #
    # -- read project File
    #
set projectFile [file join $SAMPLE_Dir ____3.4.03.15.xml]
            
    #
    # -- open projectFile and update bikeModel via mappingObject (persist)
    #
myGUI::modelAdapter::open_ProjectFile $projectFile
    # bikeModel::read_projectDoc $projectDoc  
    
    #
    # -- get projectDoc from bikeModel via mappingObject (persist)
    #
set projectDoc [myGUI::modelAdapter::get_ProjectDoc]
    # bikeModel::read_projectDoc $projectDoc  
puts [$projectDoc asXML]
    
    
    
    
    
    
    
    
    
    
    
    
    exit
    
    
    

    puts "\n\n\n"
    puts "\n ====================== get_projectDoc ==="
set projectDoc    [myGUI::modelAdapter::get_ProjectDoc]
    # set projectDoc    [bikeModel::get_projectDoc]
    
    
    #
puts [$projectDoc asXML]
    #
    
    puts "\n\n\n"
    puts "\n ====================== get_inputModelDocument ==="
set myDoc   [bikeModel::get_inputModelDocument]
puts [$myDoc asXML]
    
exit
    #

