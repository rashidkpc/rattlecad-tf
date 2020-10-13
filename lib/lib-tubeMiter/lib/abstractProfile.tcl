
 ##+##########################################################################
 #
 # AbstractProfile.tcl
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
 # 0.01 2016-01-04   new: coneMiter, many thanks to Peter Dalhoff
 # 0.04 2017-05-01   new: coneMiter, many thanks to Peter Dalhoff
 #
 # -- http://www.magicsplat.com/articles/index.html
 # ---- http://wiki.tcl.tk/44401
 #
 
    #
package require TclOO
    #
oo::class create tubeMiter::AbstractProfile {
        #
        #
    constructor {} {
            #
        if {![lindex [self call] 1]} {
            return -code error "class '[info object class [self]]' is abstract"
        }
            #
        puts "              -> superclass AbstractProfile"
            #
            #
        variable Scalar    
        variable Result    
        variable Config    
            #
        variable listKeyScalar
            #
        variable dictBase       {}  ; # dict ... describes the working shape of tube
        variable dictFinal      {}  ; # dict ... describes the final shape of tube [-180°, +180°]
        variable dictFinal720   {}  ; # dict ... describes the final shape of tube [-180°, +540°]
        variable dictProfile    {}  ; # dict ... hold strategy classNames
            #
        variable Profile            ; # {x y x y x y ...}
            #
        variable PI         [expr {4 * atan(1)}]    
            #
            #
            #
        array set   Scalar {
                            Rotation           0.00
                            Diameter          25.21
                            Diameter_X        39.65
                            Diameter_Y        29.65
                            Length            50.00
                            Precision        180
                        }
            #
        array set   Profile {
                            XY                 {}
                            XZ                 {}
                            YZ                 {}
                            Debug_0            {}
                            Debug_X            {}
                            Debug_Y            {}
                            Debug_Z            {}
                        }                   
        array set   Result {
                            Perimeter          {}
                        }
            #
            #
        set dictProfile [dict create \
                            round       tubeMiter::RoundProfile \
                            oval        tubeMiter::OvalProfile \
                        ]
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
        #
    method createAngleDict {angleOffset} {
            #
            #   i ......... id [int]
            #   phi_grd ... double[°] ... index  Angle
            #   phi_rad ... double[] .... index  Angle
            #   rho_grd ... double[°] ... offset Angle
            #   rho_rad ... double[] .... offset Angle
            #
        variable Scalar
        variable dictAngle
            #
        set i_angle      -360.0
        set i               0
            #
        set incrAngle       [expr {90.0 / $Scalar(Precision)}]
            #
        set dictAngle       {}
        set listAngle       {}
            #
        set incrAngleOffset [expr {$angleOffset - ($incrAngle * int($angleOffset / $incrAngle))}]
            #
            # 2018.02.20 (8 * $Scalar(Precision)) -> (8 * $Scalar(Precision) + 1)
        while {$i <= 8 * $Scalar(Precision) + 1} {
                #
            set key             [format {key_%06d} [expr {10 * $i}]]
            set i_angleOff      [expr {$i_angle + $incrAngleOffset}]
                #
            set phi0_grd        $i_angle
            set phi1_grd        [expr {$phi0_grd + $incrAngleOffset}]
                #
            lappend listAngle   $phi0_grd $phi1_grd
                #
            set  i_angle        [expr {$i_angle + $incrAngle}]
            incr i
                #        
        }
            #
        set listAngle       [lsort -real -unique $listAngle]
            #
        set angle___0       [lindex $listAngle 0]
        
            # puts "  -> \$angle___0 $angle___0"
            # set angle_end   [lindex $listAngle end]    
        if {$angle___0 != -360} {
            set listAngle   [lrange $listAngle 1 end]
        } else {
            set listAngle   [lrange $listAngle 0 end-1]
        }
            # set angle___0   [lindex $listAngle 0]
            # set angle_end   [lindex $listAngle end]    
            #
        foreach phi_grd $listAngle {
                # puts "      --> $rho_grd"
            set key         [format {key_%06d} [expr {10 * $i}]]
            set rho_grd     [expr {$phi_grd - $angleOffset}]
                # puts "    --> $rho_grd -> \$phi_grd     $phi_grd"
            dict set dictAngle   $key   i           $i
            dict set dictAngle   $key   phi_grd     $phi_grd
            dict set dictAngle   $key   phi_rad     [vectormath::rad $phi_grd]
            dict set dictAngle   $key   rho_grd     $rho_grd
            dict set dictAngle   $key   rho_rad     [vectormath::rad $rho_grd]
                #
            incr i
                #
        }    
            #
        # puts " -> \$dictAngle  $dictAngle"
        # appUtil::pdict $dictAngle
            #
        return
            #
    }
        #
    method updateProfile {} {
            #
        variable Scalar
        variable Profile
            #
        variable dictBase
        variable dictFinal      {}
        variable dictFinal720   {}
            #
        set Profile(XY)         {}  ;# polyline
        set Profile(XZ)         {}  ;# polyline
        set Profile(YZ)         {}  ;# polyline
        set Profile(Debug_0)    {}  ;# polyline
        set Profile(Debug_X)    {}  ;# polyline
        set Profile(Debug_Y)    {}  ;# polyline
        set Profile(Debug_Z)    {}  ;# polyline
            #
            #
            # do hots wos!!!!!
            #
        dict for {key keyDict} $dictBase {
                #
            set x           [format {%0.8f} [dict get $keyDict x]]
            set y           [format {%0.8f} [dict get $keyDict y]]
            set z           [format {%0.8f} [dict get $keyDict z]]
            set angle       [format {%0.8f} [dict get $keyDict phi_grd]]
            set perimeter   [format {%0.8f} [dict get $keyDict perimeter]]
                #
            if {$angle >= -180 && $angle <= 180} {
                    #
                lappend Profile(XY)         $x          $y
                lappend Profile(XZ)         $x          $z
                lappend Profile(YZ)         $y          $z
                lappend Profile(Debug_0)    $perimeter  [expr {0.25 * $Scalar(Length) * sin([vectormath::rad $angle])}]
                lappend Profile(Debug_X)    $perimeter  $x
                lappend Profile(Debug_Y)    $perimeter  $y
                lappend Profile(Debug_Z)    $perimeter  $z
                    #
                dict set dictFinal  $key    $keyDict
                    #
            }
            if {$angle >= -360 && $angle <= 360} {
                    #
                dict set dictFinal720       $key    $keyDict
                    #
            }
                #
                # puts "     ---> $angle <- $x $y $z -> $perimeter"
                #
        }
            #
        # appUtil::pdict $dictBase  2 "  "
            #
            # puts "      -> \$dictFinal    -> [llength [dict keys $dictFinal]]"
            # puts "      -> \$dictFinal720 -> [llength [dict keys $dictFinal720]]"
            # puts " ---> updateProfile --"
            # parray Scalar
            # puts " ---> \$Profile(XY) $Profile(XY)"
            # parray Profile    
            #
            # appUtil::pdict $dictFinal    
            #
    }
        #
        #
    method setConfig {keyName value} {
        variable Config
        if {[array names Config -exact $keyName] != {}} {
            array set Config [list $keyName $value]
            return $value
        } else {
            return -code error "[info object class [self]] setConfig $keyName ... does not exist"
        }
        return $value
    }
        #
    method setScalar {keyName value} {
            #
        variable Scalar
            #
        set listKeyScalar [my getKeys_Scalar]
        set keyCheck    [lsearch -exact -inline $listKeyScalar $keyName]
            #
        if {$keyCheck eq $keyName} {
            if {$keyName eq {Precision}} {
                set value [expr {int($value)}]
                if {$value < 1} {
                    set value 1
                } elseif {$value > 180} {
                    set value 180
                }
            }
            array set Scalar [list $keyName $value]
            return $value
        } else {
            return -code error "[info object class [self]] setScalar $keyName ... does not exist"
        }
        return $value
            #
    }
        #
    method setProfileDef {argDict} {
            #
            # puts "   -> [info object class [self]] -> setProfile "    
            #
        set argDict [join $argDict]
        set argList [dict keys $argDict]
            #
            # appUtil::pdict $argDict 2 "      "
            #
        if [dict exist $argDict -type] {
            set typeProfile [dict get $argDict -type]
            my setProfileType   $typeProfile
        }
            #
            # puts "   --> object:  [my getProfileType]"
             #
        my setMyProfileDef      $argDict
            #
        my update
            #
        return    
            #
    }
        #
    method setProfileType {profileName} {
            #
            # ... a strategy pattern
            #
        variable dictProfile
            #
            # puts "            ... current Strategy: [info object class [self]]"
            # puts "                ... set Strategy: $profileName"
        set className [dict get $dictProfile $profileName]
            # puts "   -> \$className $className"
        if {$className ne ""} {
            oo::objdefine [self] class $className
        }
            # puts "\n   -> 2 - [self]"
            # my reportValues    
            #
            # puts "       new Strategy: setProfileType -> [info object class [self]]"
            #
        # puts "       new Strategy: [info object class [self]]"
            #
    }
        #
        #
    method getConfig {keyName {type cartesian}} {
        if {[array names Config -exact $keyName] != {}} {
            set value [lindex [array get Config $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getConfig $keyName ... does not exist"
        }
    }
        #
    method getScalar {keyName} {
        variable Scalar
            # parray Scalar
        if {[array names Scalar -exact $keyName] != {}} {
            set value [lindex [array get Scalar $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getScalar $keyName ... does not exist"
        }
    }
        #
    method getResult {keyName} {
        variable Result
            # parray Result
        if {[array names Result -exact $keyName] != {}} {
            set value [lindex [array get Result $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getResult $keyName ... does not exist"
        }
    }
        #
    method getProfileType {} {
            #
            # returns the classname of the object
            #
        variable dictProfile
            #
        set profileName [string trim  [info object class [self]] "::"]
        set className   [dict get [lreverse $dictProfile] $profileName]
            # puts "      -> getMiterType: $className"
        return $className
            #
    }
        #
    method getProfile {{view XY}} {
            #
        variable Profile
            #
        switch -exact $view {
            debug_0 -
            Debug_0 {
                return $Profile(Debug_0)
            }
            debug_x -
            Debug_X {
                return $Profile(Debug_X)
            }
            debug_y -
            Debug_Y {
                return $Profile(Debug_Y)
            }
            debug_z -
            Debug_Z {
                return $Profile(Debug_Z)
            }
            yz -
            YZ {
                return $Profile(YZ)
            }
            xz -
            XZ {
                return $Profile(XZ)
            }
            xy -
            XY -
            default {
                return $Profile(XY)
            }      
        }
            #
    }
        #
        #
    method getDictionary {} {
            #
        variable dictFinal
        return  $dictFinal
            #
    }
        #
    method getDictionary720 {} {
            #
        variable dictFinal720
        return  $dictFinal720
            #
    }
        #
        #
    method reportValues {} {
            #
        puts "\n"
        puts "  ---- [info object class [self object]] ---- reportValues ------  [self object]  "
        puts ""
        foreach varName [lsort [info object vars [self object]]] {
            set qualifiedVarName [self object]::$varName
                # puts "     -> $qualifiedVarName [array exists $qualifiedVarName]"
            if {[ array exists $qualifiedVarName ]} {
                puts     "[format {%15s %25s %s} {} $varName \{]"
                foreach key [lsort [array names $qualifiedVarName]] {
                    puts "[format {%45s %-20s ... %s}  {}  $key  [lindex [array get $qualifiedVarName $key] 1]]"
                }
                if {[array size $qualifiedVarName] == 0} {
                    puts "[format {%45s %-20s }  {} {array ... is empty}]"
                }
                puts     "[format {%15s %25s %s} {} {} \}]"
            }
        }
            #
    }
        #
    method reportValues2 {} {
            #
        variable Scalar
            #
        puts " ---> [info object class [self]]"
        puts " ---> [info class superclasses [info object class [self object]]]"
        puts " ---> [info object namespace [self]]"
            #
        parray Scalar
            #
            # parray [self object]::Scalar
            #
    }
        #
        #
}
