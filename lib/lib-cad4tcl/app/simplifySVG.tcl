 ########################################################################
 #
 # simplifySVG.tcl
 #
 # Copyright (c) Manfred ROSENBERGER, 2017/11/26
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


set WINDOW_Title      "simplifySVG"

set APP_BASE_Dir       [file normalize [file dirname [file dirname [file normalize $::argv0]]]]

set APP_ROOT_Dir       [file normalize [file dirname $argv0]]
    # set APP_Library_Dir    [file join $APP_ROOT_Dir simplifySVG]
    # set APP_Sample_Dir     [file join $APP_ROOT_Dir _sample]
    # set APP_Export_Dir     [file join $APP_ROOT_Dir _export]
    #
puts "   \$APP_BASE_Dir ... $APP_BASE_Dir"
puts "   \$APP_ROOT_Dir ... $APP_ROOT_Dir"
    # puts "    -> \$APP_Library_Dir ... $APP_Library_Dir"
    # puts "    -> \$APP_Sample_Dir .... $APP_Sample_Dir"
    # puts "    -> \$APP_Export_Dir .... $APP_Export_Dir"
    #
    #
lappend auto_path [file dirname $APP_BASE_Dir]
lappend auto_path $APP_BASE_Dir
    # lappend auto_path $APP_Library_Dir
    #
foreach dir $auto_path {
    puts "        -> auto_path $dir"
}
    #
    #
package require Tk
package require cad4tcl
    #
    #
    #
cad4tcl::app::simplifySVG::view::build .
    #
    #
return
    #
    #
