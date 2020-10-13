 ##+##########################################################################
 #
 # test_customTube_init.tcl
 #
 #   customTube is software of Manfred ROSENBERGER
 #       based on tclTk and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2018/01/04
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
 # ---------------------------------------------------------------------------
 #    namespace:  customTube
 # ---------------------------------------------------------------------------
 #
 #

set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir _ext__Libraries]

package require   appUtil
package require   vectormath
package require   customTube

    # package require   Tk
    # package require   cad4tcl
    # set cad4tcl::canvasType 1
 
    ##+######################

set myTube  [customTube::Tube new]