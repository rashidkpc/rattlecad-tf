 ########################################################################
 #
 # simplifySVG: lib_view.tcl
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

namespace eval tubeMiter::app::createMiter::view::Config {
        #
    variable mvcView
    variable mvcControl    
        #
}
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::Config::setMVC_Control {ns} {
    variable mvcControl
    set mvcControl $ns
}
proc tubeMiter::app::createMiter::view::Config::setMVC_View {ns} {
    variable mvcView
    set mvcView $ns
}
    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::Config::build {w} {
        #
    variable mvcView
    variable mvcControl
        #
    set f_base          [labelframe $w.f_base -text "Config"]
    pack $f_base        -fill both  -expand yes  -side top
        #
    set configFrame     [frame $f_base.config  -relief flat  -bg yellow]    
    pack $configFrame   -fill both  -expand no  -side top
        #
    ${mvcView}::ConfigTube::build   $configFrame
    ${mvcView}::ConfigTool::build   $configFrame
    ${mvcView}::ConfigMiter::build  $configFrame
        # Shape::build  $configFrame
        #
        #
        # -- space Frame ----------------------
    set spaceFrame     [frame $f_base.space  -relief flat] 
    pack $spaceFrame   -expand no  -fill both  -side bottom
        #
    pack [label $spaceFrame.sp00  -text ""]  -expand yes  -fill both 
        #
}
    #
