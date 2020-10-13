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

namespace eval tubeMiter::app::createMiter::view::Canvas {
        #
    variable cvObject
        #
    variable Scalar
    array set Scalar    {
        Diameter        28.6
        Diameter_X      31.8
        Diameter_Y      25.4
    }
        #
    namespace import [namespace parent]::* 
        #
}
    #
    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::Canvas::build {w} {
        #
    variable notebookMiter    
        #
        #
    set f_base              [labelframe $w.f_tube  -text "Canvas"]
    pack $f_base            -side top  -fill both  -expand yes
        #
    set notebookMiter       [ttk::notebook  $f_base.nb  -width 700]
    pack $notebookMiter     -side top  -expand yes  -fill both  -pady 2
            #
            #
            # ------------------------------------
            #
    set tab_config          [$notebookMiter  add  [frame $notebookMiter.config]   -text "  Configure  "]
            #
        set f_tab           [frame $notebookMiter.config.f_01 -relief flat  -bd 0  -width 700]
        pack $f_tab         -side top  -expand yes  -fill both  -ipadx 4  -pady 0
            #
        set configFrame     [frame $f_tab.canvas  -relief flat]    
        pack $configFrame   -expand yes  -fill both  -side left 
            #
        update idle
            #
        $notebookMiter select $notebookMiter.config
        [namespace parent]::CanvasConfig::build  $configFrame
            #
            #
            # ------------------------------------
            #
    set tab_shape           [$notebookMiter  add  [frame $notebookMiter.shape]    -text "   Shape   "]
            #
        set f_tab           [frame $notebookMiter.shape.f_01  -relief flat  -bd 0  -width 700]
        pack $f_tab         -side top  -expand yes  -fill both  -ipadx 4  -pady 0
            #
        set shapeFrame      [frame $f_tab.canvas  -relief flat]    
        pack $shapeFrame    -expand yes  -fill both  -side left
            #
        update idle
            #
        $notebookMiter select $notebookMiter.shape
        [namespace parent]::CanvasMiter::build   $shapeFrame
            #
}
    #
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::Canvas::getTabName {} {
        #
    variable notebookMiter
        #
    set currentTabID    [$notebookMiter index current]
    set tubeName        [$notebookMiter tab $currentTabID -text]    
        #
    return $tubeName
        #
}    
    #
proc tubeMiter::app::createMiter::view::Canvas::updateGUI {} {
    [namespace parent]::CanvasMiter::fitContent
    [namespace parent]::CanvasConfig::fitContent
}
    #
 