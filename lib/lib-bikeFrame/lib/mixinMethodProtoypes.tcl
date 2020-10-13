 ##+##########################################################################
 #
 # package: bikeFrame    ->    classMixinMethodProtoypes.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/051/08 #
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
 #    namespace:  bikeFrame
 # ---------------------------------------------------------------------------
 #
 # http://www.magicsplat.com/articles/oo.html
 #
 #
 # 0.00 - 20160417
 #      ... new: rattleCAD - 3.4.03
 #
 #
 #

oo::class create bikeFrame::MixinMethodProtoypes {
        #
    method prototype_initValues {myDict} {
        variable Config   
        variable Position 
        variable Scalar
            #
        # appUtil::pdict $myDict    
            #
        dict for {key keyDict} $myDict {
                # puts "\n----> $key"
                # puts "            $keyDict"
            set arrayName     $key
                # puts "    -> $arrayName"
            switch -exact $arrayName {
                Config    -
                Position  -
                Scalar {
                        foreach {keyName keyValue} $keyDict {
                                # puts "    $keyName -> $keyValue"
                                # puts "-----> [array names $arrayName -exact $keyName]"
                            if {[array names $arrayName -exact $keyName] != {}} {
                                array set $arrayName [list $keyName $keyValue]
                            } else {
                                # puts "    <E> $arrayName -> $keyName ... missing\n"
                                continue
                            }
                        }
                        # parray $arrayName
                    }
                default {}
            }
        }
            #
        return    
            #
    }
        #
    method prototype_setConfig {keyName value} {
        variable Config
            # parray Config
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
    method prototype_setDirection {keyName value} {
        variable Direction
            # parray Direction
        if {[array names Direction -exact $keyName] != {}} {
            array set Direction [list $keyName $value]
            # my update
            return $value
        } else {
            return -code error "[info object class [self]] setDirection $keyName ... does not exist"
        }
        return $value
    }
        #
    method prototype_setPosition {keyName value} {
        variable Position
            # parray Position
        if {[array names Position -exact $keyName] != {}} {
            array set Position [list $keyName $value]
            # my update
            return $value
        } else {
            return -code error "[info object class [self]] setPosition $keyName ... does not exist"
        }
        return $value
    }
        #
    method prototype_setScalar {keyName value} {
        variable Scalar
            # parray Scalar
        if {[array names Scalar -exact $keyName] != {}} {
            array set Scalar [list $keyName $value]
            # my update
            return $value
        } else {
            return -code error "[info object class [self]] setScalar $keyName ... does not exist"
        }
        return $value
    }
        #
    method prototype_getCenterLine {keyName} {
        variable CenterLine
            # parray Position
        if {[array names CenterLine -exact $keyName] != {}} {
            set value [lindex [array get CenterLine $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getCenterLine $keyName ... does not exist"
        }
    }
        #
    method prototype_getConfig {keyName {type cartesian}} {
        variable Config
        if {[array names Config -exact $keyName] != {}} {
            set value [lindex [array get Config $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getConfig $keyName ... does not exist"
        }
    }
        #
    method prototype_getDirection {keyName {type cartesian}} {
        variable Direction
        switch -exact $type {
            degree      {return [vectormath::dirAngle_degree    {0 0} $Direction($keyName)]}
            radiant     {return [vectormath::dirAngle_radiant   {0 0} $Direction($keyName)]}
            cartesian   {return $Direction($keyName)}
            default     {}
        }
    }
        #
    method prototype_getPosition {keyName} {
        variable Position
            # parray Position
        if {[array names Position -exact $keyName] != {}} {
            set value [lindex [array get Position $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getPosition $keyName ... does not exist"
        }
    }
        #
    method prototype_getScalar {keyName} {
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
    method prototype_getClassName {} {
        return [lindex [split [info object class [self object]] :] end]
    }
        #
    method prototype_getDictionary {} {
            #
        # puts "\n"
        # puts "  ---- [info object class [self object]] ---- getDictionary ------  [self object]  "
        # puts ""
            #
        variable Config       ;# 
        variable CenterLine   ;# {x,y x,y x,y ... }
        variable Direction    ;# {x y}
        variable Miter        ;# {x y x y x y ...}
        variable Position     ;# {x y}
        variable Profile      ;# {dx y dx y dx y ...}
        variable Scalar       ;# {x}
        variable Shape        ;# {x y x y x y ...}
            #
        set myDict   [dict create]
            #
        foreach varName {Config CenterLine Direction Miter Position Profile Scalar Shape} {
            set qualifiedArrayName  [self object]::$varName
            set keyName             [string map {_  {}} $varName]
            set keyName             [string map {my {}} $keyName]
                # puts "     -> $qualifiedArrayName [array exists $qualifiedArrayName]"
            if {[array size $qualifiedArrayName] > 0} {
                    # puts     "[format {%15s %25s %s} {} $varName \{]"
                if {[array size $qualifiedArrayName] == 0} {
                    continue
                    #puts "[format {%45s %-20s }  {} {array ... is empty}]"
                }
                foreach key [lsort [array names $qualifiedArrayName]] {
                    set keyValue [lindex [array get $qualifiedArrayName $key] 1]
                    dict set myDict $keyName    $key    $keyValue
                    if 0 {
                        puts "[format {%45s %-20s ... %s}  {}  $key  $keyValue]"
                        if {[llength $keyValue] > 1} {
                            dict set myDict   $keyName   $key [format "%s" $keyValue]
                        } else {
                            dict set myDict   $keyName   $key $keyValue
                        }
                    }
                }
            }
        }
            #
        # appUtil::pdict $myDict 2 "        "
            # exit
        return $myDict   
            #
    }
        #
    method prototype_getProfile {keyName} {
            # keyName: xy, xz
        variable Profile
        if {[array names Profile -exact $keyName] != {}} {
            set value [lindex [array get Profile $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getProfile $keyName ... does not exist"
        }
    }
        #
    method prototype_getProvidedObject {} {
        variable providedObject
        return $providedObject
    }
        #
    method prototype_getShape {{shapeName {}}} {
        variable Shape
            # parray Shape
        if {$shapeName == {}} {
            set shapeName {xz}
        }
        set nameValue [array get Shape $shapeName]
        if {$nameValue == {}} {
            return -code error "[info object class [self]] getShape $shapeName ... does not exist"
        } else {
            set value [lindex $nameValue 1]
            return $value
        }
    }
        #
    method prototype_reportValues {} {
            #
        puts "\n"
        puts "  ---- [info object class [self object]] ---- reportValues ------  [self object]  "
        puts ""
        foreach varName [lsort [info object vars [self object]]] {
            set qualifiedVarName [self object]::$varName
                # puts "     -> $qualifiedVarName [array exists $qualifiedVarName]"
            if {![ array exists $qualifiedVarName ]} {
                    # puts "[info vars $qualifiedVarName]"
                    puts "[format {%15s %25s ... %s}  {}  $varName  [set $qualifiedVarName]]"
            }
        }
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
