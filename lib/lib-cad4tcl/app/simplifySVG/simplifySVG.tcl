 ########################################################################
 #
 # simplifySVG: simplifySVG.tcl
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
 
 #
 # 0.01  
 #      2017-11-26  init
 #
 #
 
 
  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################
  
package require Tk
package require tdom

package provide cad4tcl_simplifySVG 0.01

namespace eval cad4tcl::app::simplifySVG {
    variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]] ..]]
    variable currentVersion   "0.01"
    puts "       simplifySVG -> \$packageHomeDir $packageHomeDir"
}
  
proc cad4tcl::app::simplifySVG::buildGUI {{w {}}} {
    cad4tcl::app::simplifySVG::view::build $w
}

proc cad4tcl::app::simplifySVG::buildToplevelGUI {} {
        # ->
    variable packageHomeDir
    
    set w    .simplifySVG
        #
        # -----------------
        # check if window exists
    if {[winfo exists $w]} {
            # restore if hidden
            # puts "   ... $w allready exists!"
        wm deiconify    $w
        focus           $w
        return
    }
        #
        # -----------------
        # create a toplevel window to edit the attribute values
        #
    toplevel    $w
        #
        # create iconBitmap  -----
    if {$::tcl_platform(platform) == {windows}} {
        wm iconbitmap $w [file join $packageHomeDir etc icon tclkit.ico]
    } else {
        wm iconphoto  $w [image create photo ::myGUI::view::configPanel::img_icon16 -format gif -file [file join $packageHomeDir etc icon icon16.gif] ]
    }
        #
        # -----------------
        # create content
    set childWidget [buildGUI $w]
    puts $childWidget
    pack $childWidget -fill both -expand yes
        #
    loadFile    {}
        #
    focus       $w
        #
    return
        #
}

proc cad4tcl::app::simplifySVG::loadFile {fileName} {
        #
    puts " ... $fileName"
        #
    update idle
        #
    view::fitContent
        #
    view::openSVGFile $fileName
        #
}
