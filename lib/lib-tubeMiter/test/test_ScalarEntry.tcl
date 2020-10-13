 ########################################################################
 #
 # tubeMiter.tcl
 #
 # Copyright (c) Manfred ROSENBERGER, 2018/01/21
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


set WINDOW_Title    "test - ScalarEntry"

set APP_BASE_Dir    [file normalize [file dirname [file dirname [file normalize $::argv0]]]]

set APP_ROOT_Dir    [file normalize [file dirname $argv0]]
    #
puts "   \$APP_BASE_Dir ... $APP_BASE_Dir"
puts "   \$APP_ROOT_Dir ... $APP_ROOT_Dir"
    #
    #
lappend auto_path   [file dirname $APP_BASE_Dir]
lappend auto_path   $APP_BASE_Dir
    #
foreach dir $auto_path {
    puts "        -> auto_path $dir"
}
    #
    #
package require Tk
package require tubeMiter
    #
    #
array set Scalar {
        Diameter   28.6
        Diameter_X 31.2
        Diameter_Y 25.4
    }
    #
    #
frame .f    -bg gray30
pack .f     -fill both  -expand yes  -ipadx 9  -ipady 20
    #
frame .f.f  -bg gray50
pack .f.f   -fill both  -expand yes  -padx 2   -pady 2
    #
set scalarEntry_01 [tubeMiter::ScalarEntry new .f.f.sc_01  -text Diameter     -textvariable  ::Scalar(Diameter)    -resolution 0.20  -fglabel orangered]
set scalarEntry_02 [tubeMiter::ScalarEntry new .f.f.sc_02  -text Diameter(X)  -textvariable  ::Scalar(Diameter_X)  -resolution 0.20  -fglabel red   -widthEntry 15]
set scalarEntry_03 [tubeMiter::ScalarEntry new .f.f.sc_03  -text Diameter(Y)  -textvariable  ::Scalar(Diameter_Y)  -resolution 0.20  -fglabel blue  -widthLabel 30]
    # puts "   -> \$scalarEntry $scalarEntry"
    # pack configure [$scalarEntry_02 getPath] -side left
$scalarEntry_02 configure  [list  -side right -resolution 0.5]
$scalarEntry_03 configure  [list  -side left  -resolution 0.2]
    
    
    #
