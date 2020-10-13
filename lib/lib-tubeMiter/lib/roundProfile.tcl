 ##+##########################################################################
 #
 # RoundProfile.tcl
 #
 #   tubeMiter is software of Manfred ROSENBERGER
 #       based on tclTk and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2018/01/01
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
 #
oo::class create tubeMiter::RoundProfile {
        #
        #
    superclass tubeMiter::AbstractProfile
        #
    constructor {} {
            #
        puts "              -> class RoundProfile"    
            #
        next
            #
        variable Scalar
        variable Result
            #
        array unset Scalar *
        array set   Scalar {
                        Rotation           0.00
                        Diameter          25.21
                        Length           100.00
                        Precision        180
                    }
        array unset Result *
        array set   Result {
                        Perimeter          0.00
                    }
            #
            #
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        next $target_method $args
    }
        #
    method getKeys_Scalar {} {
        return {Diameter Length Precision Rotation}
    }
            #
    method setMyProfileDef {argDict} {
            #
            # puts "   --> [info object class [self]] -> setMyProfileDef --> $argDict"    
            #
        set argDict [join $argDict]
        set argList [dict keys $argDict]
            #
        foreach key {-diameter -precision -rotation} {
                # puts " -> \$key $key"
            if [dict exist $argDict $key] {
                set keyValue [dict get $argDict $key]
                switch -exact $key {
                    -diameter {
                        my setScalar Diameter   $keyValue
                    }
                    -rotation {
                        my setScalar Rotation   $keyValue
                    }
                    -precision {
                        my setScalar Precision  $keyValue
                    }
                    default {}
                }
            }
        }
            #
    }
        #
    method update {} {
            #
        variable Scalar
            #
            # my reportValues2
            #
        my createAngleDict  $Scalar(Rotation)
        my updatePerimeter    
            #
        my createBaseDict
            #
        my updateProfile
            #
    }
        #
    method updatePerimeter {} {
            #
        variable Scalar
        variable Result
        variable PI
            #
        set Result(Perimeter)   [expr {$Scalar(Diameter) * $PI}]   
            #
    }
        #
    method createBaseDict {} {
            #
            #
        variable Scalar
            #
        variable dictAngle
        variable dictBase
            #
            #
        set r               [expr {0.5 * $Scalar(Diameter)}]
        set rx              $r
        set ry              [expr {-1 * $r}]   ;# ... y is negativ in [-180 0] and positiv in [0 180]
            # set ry        $r
            #
        set incrZ           [expr {0.25 * $Scalar(Length) / $Scalar(Precision)}]  
            #
        set i               0
        set dictBase        {}    
            #
        dict for {key keyDict} $dictAngle {
                #
            set phi_grd     [dict get $keyDict  phi_grd]
            set phi_rad     [dict get $keyDict  phi_rad]
            set rho_grd     [dict get $keyDict  rho_grd]
            set rho_rad     [dict get $keyDict  rho_rad]
                #
                # puts "        -> $i  --> $key  ---> $phi_grd"
                #
            set x           [expr {$rx * sin($phi_rad)}]  ;# ... side view, perpendicular to tube axis, in plane of tube- and tool axis
            set y           [expr {$ry * cos($phi_rad)}]  ;# .... top view, offset of surface line perpendicular to tube(z) axis
                #
            set z           [expr {$rx * $Scalar(Length) * sin([vectormath::rad $phi_rad])}]  ;# ... a little bit obscure
                #
            set x1          [expr {$rx * sin($rho_rad)}]  ;# ... side view, perpendicular to tube axis, in plane of tube- and tool axis
            set y1          [expr {$ry * cos($rho_rad)}]  ;# .... top view, offset of surface line perpendicular to tube(z) axis
                #
                # set z           [expr ($i - 2 * $Scalar(Precision)) * $incrZ]
                # set z           [expr $rx * sin($phi_rad) + $ry * cos($phi_rad)]
                # set z           [expr $rx * sin($phi_rad)]
                # set z           [expr 0.25 * $Scalar(Length) * sin([vectormath::rad $phi_grd])]
                # set z           [expr $rx * $Scalar(Length) * sin($phi_rad)]
                #
            set perimeter   [expr {$rx * $phi_rad}]
                #
            dict set dictBase   $key   i           $i
            dict set dictBase   $key   x           $x      
            dict set dictBase   $key   y           $y
            dict set dictBase   $key   z           $z
            dict set dictBase   $key   x1          $x1      
            dict set dictBase   $key   y1          $y1
            dict set dictBase   $key   phi_grd     $phi_grd
            dict set dictBase   $key   phi_rad     $phi_rad
            dict set dictBase   $key   rho_grd     $rho_grd
            dict set dictBase   $key   rho_rad     $rho_rad
            dict set dictBase   $key   perimeter   $perimeter
                #
            incr            i    
                #
        }
            #
            # appUtil::pdict $dictBase   
            #
    }
        #
}