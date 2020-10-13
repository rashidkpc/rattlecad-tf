
 ##+##########################################################################
 #
 # abstractTubeMiter.tcl
 #
 #   tubeMiter is software of Manfred ROSENBERGER
 #       based on tclTk and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2016/01/01
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
oo::class create tubeMiter::AbstractTubeMiter {
        #
        # this class will be sourced by concrete classes like
        # like coneMiter, cylinderMiter, planeMiter ...
        #
    constructor {} {
            #
        if {![lindex [self call] 1]} {
            return -code error "class '[info object class [self]]' is abstract"
        }
            #
        puts "              -> superclass AbstractTubeMiter"
            #
            #
        variable Scalar    
        variable Config    
            #
        variable dictProfile    {}  ; # dict ... build by $objProfile
        variable dictBase       {}  ; # dict ... describes the base shape of tube
        variable dict3D_Final   {}  ; # dict ... finaly updated by $Scalar(AngleToolPlane)
            #
        variable objProfile     [tubeMiter::RoundProfile new]
            #
        variable Miter          ; # {x y x y x y ...}
        variable Profile        ; # {x y x y x y ...} 
            #
        variable dictTool
        variable dictProfile
            #
        variable PI     [expr {4 * atan(1)}]    
            #
        set dictTool    [dict create \
                            cone        tubeMiter::ConeMiter \
                            cylinder    tubeMiter::CylinderMiter \
                            frustum     tubeMiter::FrustumMiter \
                            plane       tubeMiter::PlaneMiter \
                        ]
            #
        set dictProfile [dict create \
                            round       tubeMiter::RoundProfile \
                            oval        tubeMiter::OvalProfile \
                        ]
            #
            #
            #
        array set   Config {
                                View            right
                        }
        array set   Scalar {
                            AngleTool         81.00
                            DiameterTool      27.23
                            DiameterTop       20.23
                            OffsetToolBase    45.23
                            OffsetCenterLine   0.00
                            HeightToolCone   154.23
                            DiameterTube      25.21
                            DiameterTube2     39.65
                            AngleToolPlane     0.00
                            Precision         45
                        }
        array set   Profile {
                            top                {}  
                            bottom             {}  
                            left               {}  
                            right              {}  
                        }                   
        array set   Profile___remove {
                            XZ                 {}
                            XY                 {}
                            YZ                 {}  
                            top                {}  
                            bottom             {}  
                            left               {}  
                            right              {}  
                        }                   
            # 
        array set   Miter {
                            Unwrapped          {}
                        }
            #
        array set   Result {
                            Perimeter          {}
                        }
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
    method updateProfileObj {} {
            #
        variable Scalar
        variable objProfile
            #
        set profileName [$objProfile getProfileType]
            #
            # $objProfile     reportValues2
            # parray Scalar    
            #
        switch -exact $profileName {
            oval {
                $objProfile setProfileDef \
                            [list \
                                -type           oval \
                                -diameter_x     $Scalar(DiameterTube) \
                                -diameter_y     $Scalar(DiameterTube2) \
                                -rotation       $Scalar(AngleToolPlane) \
                                -precision      $Scalar(Precision) ]
            }
            round -
            default {
                $objProfile setProfileDef \
                            [list \
                                -type           round \
                                -diameter       $Scalar(DiameterTube) \
                                -rotation       $Scalar(AngleToolPlane) \
                                -precision      $Scalar(Precision) ]
            }
        }
            #
            # $objProfile     reportValues2
            #
        return
            #
    }
        #
    method createProfileDict {} {
            #
        variable objProfile
        variable dictProfile
            #
            # $objProfile     reportValues2
            #
        set dictProfile [$objProfile getDictionary720]
            #
        return
            #
    }
        #
        #
    method updateMiter {} {
            #
        puts "   ... prototype implementation of method: updateMiter"
            #
    }
        #
    method updateViews {} {
            #
            # -- tubeMiter - xz view (side View)
            #
        variable PI
        variable Scalar
            #
        variable dict3D_Final    
            #
        variable Miter
        variable Profile
            #
            #
        set indexDictionary     $dict3D_Final
            #
            #
        set profile_xz {}
        set profile_yz {}
            #
        set profileRight {}
        set profileTop {}
        set profileLeft {}
        set profileBottom {}
            #
        set toolMiter {}
            #
            #
        foreach key [lsort [dict keys $indexDictionary]] {
            set phi_grd     [dict get $indexDictionary $key phi_grd]
            set x           [dict get $indexDictionary $key x]
            set y           [dict get $indexDictionary $key y]
            set z           [dict get $indexDictionary $key z]
            set p           [dict get $indexDictionary $key perimeter]
                #
                # set rho_grd     [dict get $indexDictionary $key rho_grd]
                #
                # puts "        <D> -> \$phi_grd $phi_grd"
                # puts "        <D> -> \$phi_grd $phi_grd  -> $z"
            if {-270 <= $phi_grd && $phi_grd <= -90} {
                # puts "        <D> -> profileBottom          $phi_grd"
                set a [expr {-1.0 * $x}]
                lappend profileBottom   [format {%3.8f} $a] [format {%3.8f} $z]
            }
            if {-180 <= $phi_grd && $phi_grd <=   0} {
                # puts "        <D> -> profileLeft            $phi_grd"
                set a [expr {-1.0 * $y}]
                lappend profileLeft     [format {%3.8f} $a] [format {%3.8f} $z]
            }
            if { -90 <= $phi_grd && $phi_grd <=  90} {
                # puts "        <D> -> profileTop             $phi_grd"
                lappend profileTop      [format {%3.8f} $x] [format {%3.8f} $z]
            }
            if {   0 <= $phi_grd && $phi_grd <= 180} {
                # puts "        <D> -> profileRight           $phi_grd"
                lappend profileRight    [format {%3.8f} $y] [format {%3.8f} $z]
            }
                #
            if {-180 <= $phi_grd && $phi_grd <= 180} {
                lappend toolMiter       [format {%3.8f} $p] [format {%3.8f} $z]
            }
                #
        }
            #
            # puts "    \$profileRight    $profileRight "
            # puts "    \$profileTop      $profileTop   "
            # puts "    \$profileLeft     $profileLeft  "
            # puts "    \$profileBottom   $profileBottom"
            #
        set Profile(bottom)     $profileBottom  ;#  90
        set Profile(left)       $profileLeft    ;# 270
        set Profile(top)        $profileTop     ;#  90
        set Profile(right)      $profileRight   ;# 270
            #
            # set Profile(bottom)     [vectormath::rotateCoordList {0 0} $profileBottom    270] ;#  90
            # set Profile(left)       [vectormath::rotateCoordList {0 0} $profileLeft      270] ;# 270
            # set Profile(top)        [vectormath::rotateCoordList {0 0} $profileTop       270]
            # set Profile(right)      [vectormath::rotateCoordList {0 0} $profileRight     270]
            #
        set Miter(Unwrapped)    $toolMiter
            #
            # puts "    \$Profile(bottom)  $Profile(bottom)"
            # puts "    \$Profile(left)    $Profile(left)  "
            # puts "    \$Profile(top)     $Profile(top)   "
            # puts "    \$Profile(right)   $Profile(right) "
            #
        return
            #
    }
        #
        #
    method setConfig {keyName value} {
        variable Config
        if {[array names Config -exact $keyName] != {}} {
            array set Config [list $keyName $value]
            # my update
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
        variable objProfile
            #
            # puts "----> \$objProfile $objProfile -> setScalar --> $keyName <- $value"    
            #
        if {[array names Scalar -exact $keyName] != {}} {
                #
            switch -exact [$objProfile getProfileType] {
                oval {
                    switch -exact $keyName {
                        DiameterTube {
                            $objProfile setScalar   Diameter_X  $value
                            array set Scalar [list $keyName $value]
                        }
                        DiameterTube_2 {
                            $objProfile setScalar   Diameter_Y  $value
                            array set Scalar [list $keyName $value]
                        }
                    }
                }
                round -
                default {
                    switch -exact $keyName {
                        DiameterTube {
                            $objProfile setScalar   Diameter    $value
                            array set Scalar [list $keyName $value]
                        }
                    }
                }
            }
                #
            switch -exact $keyName {
                AngleToolPlane {
                    $objProfile setScalar   Rotation        $value
                    array set Scalar [list $keyName $value]
                }
                Precision {
                    $objProfile setScalar   Precision       $value
                    array set Scalar [list $keyName [$objProfile getScalar   Precision]]
                }
                default {
                    array set Scalar [list $keyName $value]
                }
            }
                # my update
            return [lindex [array get Scalar $keyName] 1]
                #
        } else {
                #
            return -code error "[info object class [self]] setScalar $keyName ... does not exist"
                #
        }
        return $value
    }
        #
    method setToolType {toolName} {
            #
            # ... a strategy pattern
            #
        variable dictTool
            #
            # puts "            ... current Strategy: [info object class [self]]"
            # puts "                ... set Strategy: $toolName"
        set className [dict get $dictTool $toolName]
            # puts "    -> \$className $className"
        if {$className ne ""} {
            oo::objdefine [self] class $className
        }
            # puts "   -> 2 - [self]"
            # puts "       new Strategy: setToolType -> [info object class [self]]"

    }
        #
    method setProfile {obj} {
            #
        variable objProfile
            # puts "\n --- setProfile ----------------------------- \n"
            puts "         -> setProfile \$objProfile $objProfile  <- $obj"
            #
        if {$obj != $objProfile} {
            $objProfile destroy
            #puts "   -> [info object namespace $objProfile]" 
            #puts "   -> [info object namespace $obj]" 
            #oo::copy $obj $objProfile
            set objProfile $obj
            
        }
        puts "         -> \$objProfile $objProfile"
            # $objProfile update
            # puts "\n --- setProfile ----------------------------- \n"
        return  $objProfile
            #
    }
        #
    method setProfileDef {argDict} {
            #
        variable objProfile
        $objProfile setProfileDef $argDict
            #
        set profileName [my getProfileType]
            #
        switch -exact -- $profileName {
            oval {
                my setScalar DiameterTube   [$objProfile getScalar Diameter_X]    
                my setScalar DiameterTube2  [$objProfile getScalar Diameter_Y]    
            }
            round -
            default {
                my setScalar DiameterTube   [$objProfile getScalar Diameter]    
            }
        }
        my setScalar Precision              [$objProfile getScalar Precision]    
        my setScalar AngleToolPlane         [$objProfile getScalar Rotation]    
            #
    }
        #
    method setProfileType {profileName} {
            #
        variable objProfile
            # puts "        ----> setProfileType: $profileName"
        $objProfile setProfileType $profileName
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
    method getToolType {} {
            #
            # returns the classname of the object
            #
        variable dictTool
            #
        set toolName    [string trim  [info object class [self]] "::"]
        set className   [dict get [lreverse $dictTool] $toolName]
            # puts "      -> getMiterType: $className"
        return $className
            #
    }
        #
    method getProfileObject {} {
            #
        variable objProfile
        return  $objProfile
            #
    }
        #
    method getProfileType {} {
            #
        variable objProfile
        return  [$objProfile getProfileType]
            #
    }
        #
        #
    method getMiter {{positionName Origin} {view {origin}}} {
            #
        variable Miter
            #
        set keyName {Unwrapped}    
        if {[array names Miter -exact $keyName] != {}} {
            set miter [lindex [array get Miter $keyName] 1]
            
            switch -exact $view {
                    # 20180110
                opposite {
                    set miterOpposite {}
                    set miterLeft {}
                    set miterRight {}
                    set x_0 [lindex $miter 0]
                    foreach {x z} $miter {
                        if {$x <= 0} {
                            lappend miterLeft $x $z
                        }
                        if {$x >= 0} {
                            lappend miterRight $x $z
                        }
                    }
                    foreach {x z} $miterRight {
                        lappend miterOpposite [expr {$x + $x_0}] $z
                    }
                    foreach {x z} [lrange $miterLeft 2 end] {
                        lappend miterOpposite [expr {$x - $x_0}] $z
                    }
                    set miter $miterOpposite
                }
            }
                #
            switch -exact $positionName {
                Origin  {
                        set posMiter $miter
                    }
                End -
                default {
                        set posMiter {}
                        foreach {x z} $miter {
                            lappend posMiter $x [expr {-1.0 * $z}]
                        }
                    }
            }
                #
            if 0 {    
                # 20180110
                switch -exact $view {
                    __left__ -
                    opposite {
                            foreach {z x} [lreverse $posMiter] {
                                lappend viewMiter [expr {-1.0 * $x}] $z
                            }
                        }
                    __right__ -
                    _origin -
                    default {
                            set viewMiter $posMiter
                        }
                }
            }
                #
            set viewMiter $posMiter
            return $viewMiter
                #
        } else {
            return -code error "[info object class [self]] Miter $keyName ... does not exist"
        }
    }
        #
    method getProfile {{positionName Origin} {keyName right} {view {origin}}} {
            #
        variable Config
            #
        variable Profile
            #
            # puts "    -> \$positionName $positionName  -> \$keyName $keyName  -> \$view $view"
            # parray Profile
            #
        if {[array names Profile -exact $keyName] != {}} {
            set profile [lindex [array get Profile $keyName] 1]
            switch -exact $positionName {
                Origin  {
                        set posProfile $profile
                    } 
                End {
                        set posProfile {}
                        foreach {z a} [lreverse $profile] {
                            lappend posProfile $a [expr {-1.0 * $z}]
                        }
                    }
                default {
                        set posProfile {0 -1  0 1}
                    }
            }
                #
            switch -exact $view {
                origin -
                __right__ {
                        set viewProfile $posProfile
                    }
                opposite -
                __left__ {
                        set viewProfile {}
                        foreach {y x} [lreverse $posProfile] {
                            lappend viewProfile [expr {-1.0 * $x}] $y
                        }
                    }
                default {
                        set viewProfile {0 -1  0 1}
                    }
            }
                #
            return $viewProfile
                #
        } else {
            return -code error "[info object class [self]] Profile $keyName ... does not exist"
        }
    }
        #
    method getPerimeter {} {
            #
        variable objProfile
            #
        set perimeter [$objProfile getResult Perimeter]
            # puts "  -> \$perimeter $perimeter"
        return $perimeter
            #
    }
        #
    method getProfileShape {} {
            #
        variable objProfile
            #
        set profileShape    [$objProfile getProfile]
            #
        return $profileShape
            #
    }
        #
    method getDictionary {} {
            #
        variable dict3D_Final
        return  $dict3D_Final
            #
    }
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
}

proc tubeMiter::CutPlane {z angle} {
            #
            # z ....... perpendicular offset of cutting line in plane(y/z)
            # angle ... direction of cutting line in plane(y/z)
            #
        set phi_2   [vectormath::rad [expr {$angle - 90}]]    
            #
        set k       [expr {tan($phi_2)}]
            #
        set x1      [expr {-1.0 * $k * $z}]
        set x2      [expr {       $k * $z}]
            #
        return      [list $x1 $x2]
            #
    }
proc tubeMiter::CutCylinder {r x z angle} {
            #
            # r ....... radius Tool
            # x ....... perpendicular offset of cutting plane(y/z)
            # z ....... perpendicular offset of cutting line in plane(y/z)
            # angle ... direction of cutting line in plane(y/z)
            #
        set k           [expr {tan([vectormath::rad [expr $angle - 90]])}]
            #
        if {$r >= abs($x)} {
            set y [expr {sqrt(pow($r,2) - pow($x,2))}]
        } else {
            set y 0
        }
            #
        set x_1     [expr {$y / cos([vectormath::rad [expr $angle - 90]])}]
        set x_2     [expr {$k * $z}]
            #
        set x1      [expr {-1.0 * ($x_1 + $x_2)}] 
        set x2      [expr {        $x_1 + $x_2}]
            #
        return [list $x1 $x2)]
            #
    }
proc tubeMiter::CutCone {r h x z angle} {
            #
            # r ....... base radius of cone
            # h ....... height of cone
            # x ....... offset of cutting plane
            # z ....... perpendicular offset of cutting line
            # angle ... direction of surface line 
            #
            # puts "\n -- tubeMiter::CutCone -----"
            # puts "         \$r $r"
            # puts "         \$h $h"
            # puts "         \$x $x"
            # puts "         \$z $z"
            # puts "         \$angle $angle"
            #
        set myAngle [expr {$angle - 90}]
        set z       [expr {-1.0 * $z}]
            #
        set z2      [expr {$z / cos([vectormath::rad $myAngle])}] 
            #
            # puts "         \$z2 $z2"
            #
        set k       [expr {-1.0 * tan([vectormath::rad $myAngle])}]
        set distTip [expr {$h - $z2}]
            #
        if {$r == 0 } {
            set a       0 
            set b       0 
        } else {
            set a       [expr {abs($x * ($h / $r))}]
            if {$h == 0 } {
                set b   0 
            } else {
                set b   [expr {abs($a / ($h / $r))}]
            }
        }
            #
            #
            # puts "        -------"
            # puts "         \$myAngle $myAngle"
            # puts "         \$distTip $distTip"
            # puts "        -------"
            # puts "         \$k $k"
            # puts "        -------"
            # puts "         \$a $a"
            # puts "         \$b $b"
            #
            #
        if {$a == 0} {
                #
            set xy_1    [vectormath::intersectPoint [list 0 0] \
                                                    [list [expr {-1.0 * $r}] $h] \
                                                    [list 0 $distTip] \
                                                    [list 1 [expr {$distTip + $k}]]]
            set xy_2    [vectormath::intersectPoint [list 0 0] \
                                                    [list [expr  {1.0 * $r}] $h] \
                                                    [list 0 $distTip] \
                                                    [list 1 [expr {$distTip + $k}]]]
                #
        } else {
                #
            foreach {xy_1 xy_2} [tubeMiter::IntersectHyperbelLine $a $b $distTip $k] break
                #
        } 
            #
            # puts "   -> \$xy_1 $xy_1 "   
            # puts "   -> \$xy_2 $xy_2 "    
            # puts "   ----------------"    
            #
        set xy_1    [vectormath::subVector $xy_1 [list 0 $h]]
        set xy_2    [vectormath::subVector $xy_2 [list 0 $h]]
            #
        set x1      [lindex $xy_1 0]
        set x2      [lindex $xy_2 0]
            #
            # puts "   -> \$xy_1 $xy_1 "   
            # puts "   -> \$xy_2 $xy_2 "    
            # puts "   ----------------"    
            #
        set r1      [expr {sqrt(pow($x,2) + pow($x1,2))}]
        set r2      [expr {sqrt(pow($x,2) + pow($x2,2))}]
            #
        set xy_1    [vectormath::rotatePoint {0 0} $xy_1 $myAngle]
        set xy_2    [vectormath::rotatePoint {0 0} $xy_2 $myAngle]
            #
            # puts "   -> \$xy_1 $xy_1 "   
            # puts "   -> \$xy_2 $xy_2 "    
            # puts "   ----------------"
            #
        lassign $xy_1  x1 y1
        lassign $xy_2  x2 y2
            # foreach {x1 y1} $xy_1 break
            # foreach {x2 y2} $xy_2 break
            #
        set y1 [expr {-1.0 * $y1}]
        set y2 [expr {-1.0 * $y2}]
            #
        set xy_1 [list $x1 $y1 $r1]
        set xy_2 [list $x2 $y2 $r2]
             #
            # puts "  --> \$xy_1 $xy_1 "   
            # puts "  --> \$xy_2 $xy_2 "    
            # puts "   ----------------"
            #
            #
        return [list $xy_1 $xy_2]
            #
}
proc tubeMiter::IntersectHyperbelLine {a b d k} {
            #
            # puts "\n -- tubeMiter::IntersectHyperbelLine -----"
            # puts "         \$a $a"
            # puts "         \$b $b"
            # puts "        -------"
            # puts "         \$k $k"
            # puts "         \$d $d"
            #
        if {$a == 0} {
            set b 1
        }
            #
        if {$b == 0} {
            set x1      0
            set x2      0
            set y1      $d
            set y2      $d
        } else {
            set _A_ [expr {1.0 * (pow($k,2) - (pow($a,2) / pow($b,2)))}]
            set _B_ [expr {2.0 * $k * $d}]
            set _C_ [expr {pow($d,2) - pow($a,2)}]
                # puts "           --->  $b [expr pow($b,2)]"
                # puts "           --->  $a [expr pow($a,2)]"
                # puts "           --->  $k [expr pow($k,2)]"
                # puts "           --->  \$_A_: $_A_  \$_B_: $_B_  \$_C_: $_C_"
                #
            set __D_    [expr {pow($_B_,2) - 4 * $_A_ * $_C_}]
                # puts "           --->  \$__D_: $__D_"
                #
            if {$__D_ > 0} {
                set x1  [expr {(-1.0 * $_B_ + sqrt(pow($_B_,2) - 4 * $_A_ * $_C_ )) / (2 * $_A_)}]
                set x2  [expr {(-1.0 * $_B_ - sqrt(pow($_B_,2) - 4 * $_A_ * $_C_ )) / (2 * $_A_)}]
            } else {
                set x1 0
                set x2 0
            }
            set y1      [expr {$k * $x1 + $d}]
            set y2      [expr {$k * $x2 + $d}]
        }
            #
        return [list [list $x1 $y1] [list $x2 $y2]]
            #
    }
   
    