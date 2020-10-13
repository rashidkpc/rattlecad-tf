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

namespace eval tubeMiter::app::createMiter::view::Shape {
        #
    variable cvObject
        #
    variable Scalar
    array set Scalar    {
        Angle     90.0
        Offset_X   0.0
        Offset_Z   0.0
    }
        #
}
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::Shape::fitContent {} {
        #
    variable cvObject
        #
    puts "\n"
    puts "  =============================================="
    puts "   -- fitContent:   $cvObject"
    puts "  =============================================="
    puts "\n"
        #
    $cvObject fit
    $cvObject fitContent __Content__
        #
    return
        #
}



    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::Shape::build {w} {
        #
    variable cvObject    
        #
        #
    set f_base      [labelframe     $w.f_shape  -text "Shape"]
    pack $f_base    -fill both  -expand yes
        #
        #
        # ------------------------------------
        #
    set canvasFrame     [frame $f_base.cv]
    pack $canvasFrame   -expand yes     -fill both
        #
    set cvObject        [cad4tcl::new   $canvasFrame  200  200  passive  1.0  0  -bd 1  -bg white  -relief sunken]
        #
        #
        #ttk::button $f_base.bt_update    -width 15   -text " update "           ;#-command [namespace current]::openSVGFile
            #
        #label       $f_base.sp_00        -text "      "
            #
        #pack        $f_base.bt_update \
                    $f_base.sp_00 \
                -side left  -padx 2  -pady 2
        #
}
    #


