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

namespace eval tubeMiter::app::createMiter::view::ConfigMiter {
        #
    variable cvObject
        #
    variable Scalar
    array set Scalar {
        Angle         90.0
        Offset_X       0.0
        Offset_Z      10.0
        Rotation_Z     0.0
        Precision_90  45
    }
        #
    variable Entry
    array set Entry {
        Angle       {}
        Offset_X    {}
        Offset_Z    {}
        Rotation_Z  {}
        Precision   {}
    }    
        #
}
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::ConfigMiter::fitContent {} {
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
proc tubeMiter::app::createMiter::view::ConfigMiter::build {w} {
        #
    variable Entry
        #
        # ----
        #
    set f_base      [labelframe     $w.f_precision -text "Precision" ]
    pack $f_base    -fill both  -expand yes  -ipadx 6  -ipady 2
        #
    set Entry(Precision)    [tubeMiter::ScalarEntry new  $f_base.sc_05  -text Precision(90) -textvariable  [namespace current]::Scalar(Precision_90) -resolution 1  -boundaryLow 2  -type integer]
        #
    set w_05    [$Entry(Precision)  getPath]
        #
    pack $w_05 \
                -side top  -fill x  -padx 6  -pady 1
        #
    $Entry(Precision)   bind <Return>           [namespace parent [namespace parent]]::control::update
        #
    $Entry(Precision)   bind <Double-Button-1>  [namespace parent [namespace parent]]::control::update
        #
        # ----
        #
    set f_base      [labelframe     $w.f_miter -text "Miter" ]
    pack $f_base    -fill both  -expand yes  -ipadx 6  -ipady 2
        #
    set Entry(Angle)        [tubeMiter::ScalarEntry new  $f_base.sc_01  -text Angle         -textvariable  [namespace current]::Scalar(Angle)        -resolution 0.1  -boundaryLow 0.1  -boundaryHigh 179.9]
    set Entry(Offset_X)     [tubeMiter::ScalarEntry new  $f_base.sc_02  -text Offset(x)     -textvariable  [namespace current]::Scalar(Offset_X)     -resolution 0.1]
    set Entry(Offset_Z)     [tubeMiter::ScalarEntry new  $f_base.sc_03  -text Offset(z)     -textvariable  [namespace current]::Scalar(Offset_Z)     -resolution 0.1]
    set Entry(Rotation_Z)   [tubeMiter::ScalarEntry new  $f_base.sc_04  -text Rotation(z)   -textvariable  [namespace current]::Scalar(Rotation_Z)   -resolution 0.1  -boundaryLow -90  -boundaryHigh 90]
                #
    set w_01    [$Entry(Angle)      getPath]
    set w_02    [$Entry(Offset_X)   getPath]
    set w_03    [$Entry(Offset_Z)   getPath]
    set w_04    [$Entry(Rotation_Z) getPath]
        #
    pack $w_01 $w_02 $w_03 $w_04 \
                -side top  -fill x  -padx 6  -pady 1
        #
    $Entry(Angle)       bind <Return>           [namespace parent [namespace parent]]::control::update
    $Entry(Offset_X)    bind <Return>           [namespace parent [namespace parent]]::control::update
    $Entry(Offset_Z)    bind <Return>           [namespace parent [namespace parent]]::control::update
    $Entry(Rotation_Z)  bind <Return>           [namespace parent [namespace parent]]::control::update
        #
    $Entry(Angle)       bind <Double-Button-1>  [namespace parent [namespace parent]]::control::update
    $Entry(Offset_X)    bind <Double-Button-1>  [namespace parent [namespace parent]]::control::update
    $Entry(Offset_Z)    bind <Double-Button-1>  [namespace parent [namespace parent]]::control::update
    $Entry(Rotation_Z)  bind <Double-Button-1>  [namespace parent [namespace parent]]::control::update
        #
}
    #
proc tubeMiter::app::createMiter::view::ConfigMiter::setMode {modeName} {
        #
    variable Entry
        #
    $Entry(Angle)       configure {-state normal}
    $Entry(Rotation_Z)  configure {-state normal}
    $Entry(Precision)   configure {-state normal}
        #
    switch -exact $modeName {
        Plane {
            $Entry(Offset_X)    configure {-state readonly}
            $Entry(Offset_Z)    configure {-state readonly}
        }
        Cylinder {
            $Entry(Offset_X)    configure {-state normal}
            $Entry(Offset_Z)    configure {-state readonly}
        }
        Frustum {
            $Entry(Offset_X)    configure {-state normal}
            $Entry(Offset_Z)    configure {-state normal}
        }
        Cone {
            $Entry(Offset_X)    configure {-state normal}
            $Entry(Offset_Z)    configure {-state readonly}
        }
    }
}
    #
proc tubeMiter::app::createMiter::view::ConfigMiter::checkValues {} {
        #
    variable Scalar
        #
    set value $Scalar(Angle)
    puts "   -> \$Scalar(Angle) -> $value"
    if {$value <= 0} {
        set value 0.5
    }
    if {$value >= 180} {
        set value 179.5
    }
        #
    set Scalar(Angle) $value
        #
        #
    set value $Scalar(Precision_90) 
    puts "   -> \$Scalar(Precision_90) -> $value"
        #
}
    #
proc tubeMiter::app::createMiter::view::ConfigMiter::getDict {} {
        #
    variable Scalar
        #
    set miterDict  \
        [list \
            angle       $Scalar(Angle) \
            offset_x    $Scalar(Offset_X) \
            offset_z    $Scalar(Offset_Z) \
            rotation    $Scalar(Rotation_Z) \
            precision   $Scalar(Precision_90) \
        ]
        #
    return $miterDict    
        #
}   
    #