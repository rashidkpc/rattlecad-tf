 
 ########################################################################
 #
 #  This software is copyrighted by Manfred Rosenberger and other parties.  
 #  The following terms apply to all files associated with the software unless
 #  explicitly disclaimed in individual files.
 #  
 #  The authors hereby grant permission to use, copy, modify, distribute,
 #  and license this software and its documentation for any purpose, provided
 #  that existing copyright notices are retained in all copies and that this
 #  notice is included verbatim in any distributions. No written agreement,
 #  license, or royalty fee is required for any of the authorized uses.
 #  Modifications to this software may be copyrighted by their authors
 #  and need not follow the licensing terms described here, provided that
 #  the new terms are clearly indicated on the first page of each file where
 #  they apply.
 #  
 #  IN NO EVENT SHALL THE AUTHORS OR DISTRIBUTORS BE LIABLE TO ANY PARTY
 #  FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 #  ARISING OUT OF THE USE OF THIS SOFTWARE, ITS DOCUMENTATION, OR ANY
 #  DERIVATIVES THEREOF, EVEN IF THE AUTHORS HAVE BEEN ADVISED OF THE
 #  POSSIBILITY OF SUCH DAMAGE.
 #  
 #  THE AUTHORS AND DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES,
 #  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY,
 #  FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.  THIS SOFTWARE
 #  IS PROVIDED ON AN "AS IS" BASIS, AND THE AUTHORS AND DISTRIBUTORS HAVE
 #  NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 #  MODIFICATIONS.
 #  
 #  GOVERNMENT USE: If you are acquiring this software on behalf of the
 #  U.S. government, the Government shall have only "Restricted Rights"
 #  in the software and related documentation as defined in the Federal 
 #  Acquisition Regulations (FARs) in Clause 52.227.19 (c) (2).  If you
 #  are acquiring the software on behalf of the Department of Defense, the
 #  software shall be classified as "Commercial Computer Software" and the
 #  Government shall have only "Restricted Rights" as defined in Clause
 #  252.227-7013 (c) (1) of DFARs.  Notwithstanding the foregoing, the
 #  authors grant the U.S. Government and others acting in its behalf
 #  permission to use and distribute the software in accordance with the
 #  terms specified in this license.
 # 
 # ----------------------------------------------------------------------
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 # ----------------------------------------------------------------------
 #  http://www.magicsplat.com/articles/oo.html
 #  https://www.mathematik.ch/anwendungenmath/ellipsenumfang/
 # ----------------------------------------------------------------------
 # 
 #  2017/12/06
 #      ... initialize
 #
 # ----------------------------------------------------------------------
 #  namespace:  customTube
 # ----------------------------------------------------------------------
 #
 #
 
    #
namespace eval customTube {oo::class create Tube}
    #
oo::define customTube::Tube {
        #
    constructor {args} { 
            #
        puts "              -> class customTube::Tube"
            #
        variable Config
        variable Position
        variable Profile
        variable Scalar
        variable View
            #
        variable tubeDictionary
            #
            #
        variable    objMiterOrigin  [tubeMiter::createMiter]
        variable    objMiterEnd     [tubeMiter::createMiter]
            #
        set tubeDictionary  [dict create]
            #
        array set Config {}
        array set Position {
                    Origin            {0 0}
                    EdgeOriginLeft    {0 0}
                    EdgeOriginRight   {0 0}
                    RefOriginLeft     {0 0}
                    RefOriginRight    {0 0}
                    End               {0 0}
                    EdgeEndLeft       {0 0}
                    EdgeEndRight      {0 0}
                    RefEndLeft        {0 0}
                    RefEndRight       {0 0}
        }
        array set Profile {}
        array set Scalar {}
        array set View   {}
            #
    }
        #
    destructor { 
        puts "            -> [self] ... destroy cadCanvas"
    }
        #
    method unknown {target_method args} {
        puts "<E> ... customTube::Tube $target_method $args  ... unknown"
    }
        #
        #
    method update {} {
            #
        variable Config
        variable Position
        variable Profile
        variable Scalar
        variable View
            #
        variable tubeDictionary
            #
        variable objMiterOrigin    
        variable objMiterEnd    
            #
            #
        array unset Config *    
        array unset Scalar *    
        array unset View   *    
            #
        set profile(round)  [my getDictValue    Tube/profile_round]
        set profile(x)      [my getDictValue    Tube/profile_x]
        set profile(y)      [my getDictValue    Tube/profile_y]
        set lengthTube          [my getDictValue    Tube/length]
            #
            # puts "-- update --"
            # puts "        -> \$profile(round)   $profile(round)"
            # puts "        -> \$profile(x)       $profile(x)"
            # puts "        -> \$profile(y)       $profile(y)"
            # puts "        -> \$lengthTube           $lengthTube    "
            #
            #
            # --- View Round --- 
            #
        if {$profile(x) eq {}  &&  $profile(y) eq {}  &&  $profile(round) ne {}} {
                #
                # puts "\n"    
            puts "     ... customTube::Tube -> update: \$profile(round) -> $profile(round)"    
                #
            set profile(x) $profile(round)
                #
        }   
            #
            #
            # --- View ZX --- 
            #
        set profile(zx) {}
        if {$profile(x) ne {}} {
                #
            set Scalar(Radius_X_Origin) [lindex $profile(x) 1]
                #
            set length_z        0
            set radius(X_0)     $Scalar(Radius_X_Origin)
            set lastX           $radius(X_0)
            foreach {z x} $profile(x) {
                    # puts "     -> $z $x"
                set length_z    [expr $length_z + $z]
                if {$length_z > $lengthTube} {
                    set length_z $lengthTube
                }
                lappend profile(zx)  $length_z $x
            }
                #
            set Scalar(Radius_X_End)    [lindex $profile(zx) end]
            set Profile(ZX)             $profile(zx)
                #
            set profile(zx)  [vectormath::rotateCoordList {0 0} $profile(zx) 180]    
                #
        }
            #
            #
            # --- View ZY --- 
            #
        set profile(zy) {}
        if {$profile(y) ne {}} {
                #
            set Scalar(Radius_Y_Origin) [lindex $profile(y) 1]
                #
            set length_z        0
            set radius(Y_0)     $Scalar(Radius_Y_Origin)
            set lastY           $radius(Y_0)
            foreach {z y} $profile(y) {
                    # puts "     -> $z $y"
                set length_z    [expr $length_z + $z]
                if {$length_z > $lengthTube} {
                    set length_z $lengthTube
                }
                lappend profile(zy)  $length_z  $y
            }
                #
            set Scalar(Radius_Y_End)    [lindex $profile(zy) end]
            set Profile(ZY)             $profile(zy)
                #
            set profile(zy)  [vectormath::rotateCoordList {0 0} $profile(zy) 180]
                #
        }    
            #
            #
            # puts " --- update 001 ---"
            # parray profile
            # parray Scalar
            #
        if {$profile(x) eq {} && $profile(y) ne {}} {
            set profile(x)              $profile(y) 
            set profile(zx)             $profile(zy) 
            set Profile(ZX)             $Profile(ZY)
            set Scalar(Radius_X_Origin) $Scalar(Radius_Y_Origin)
            set Scalar(Radius_X_End)    $Scalar(Radius_Y_End)
        }
        if {$profile(y) eq {} && $profile(x) ne {}} {
            set profile(y)              $profile(x) 
            set profile(zy)             $profile(zx) 
            set Profile(ZY)             $Profile(ZX)
            set Scalar(Radius_Y_Origin) $Scalar(Radius_X_Origin)
            set Scalar(Radius_Y_End)    $Scalar(Radius_X_End)
        }
            # puts " --- update 002 ---"
            # parray profile
            # parray Scalar
            #
            #
            # -- View - Debug
            #
        set View(Debug_ZX)        $profile(zx)
        foreach {x z} [lreverse $profile(zx)] {
            lappend View(Debug_ZX) $z [expr -1 * $x]
        }   
        set View(Debug_ZX)          [vectormath::mirrorCoordList $View(Debug_ZX) y]
            #
        set View(Debug_ZY)        $profile(zy)
        foreach {y z} [lreverse $profile(zy)] {
            lappend View(Debug_ZY) $z [expr -1 * $y]
        }   
        set View(Debug_ZY)          [vectormath::rotateCoordList {0 0} $View(Debug_ZY) -180]
            #
            #
            # -- update Miter
            #
        my updateMiter_Origin
        my updateMiter_End
            #
            #
            # -- VIEW ZX
            #
        set miterViewOrigin_x       [$objMiterOrigin    getProfile Origin   bottom origin]
        set miterViewEnd_x          [$objMiterEnd       getProfile End      bottom origin]
            #
        set miterViewOrigin_x       [vectormath::rotateCoordList    {0 0}   $miterViewOrigin_x   270] ; # 180
        set miterViewEnd_x          [vectormath::rotateCoordList    {0 0}   $miterViewEnd_x      270] ; # 180
        set miterViewEnd_x          [vectormath::addVectorCoordList [list [expr -1 * $lengthTube] 0] $miterViewEnd_x]
            #
        set profile_01              [lrange $profile(zx)  2 end-2]
        set profile_02              {}
        foreach {x z} [lreverse $profile_01] {
            lappend profile_02 $z [expr -1 * $x]
        }   
        set View(ZX)            [join "$miterViewOrigin_x $profile_01 $miterViewEnd_x $profile_02" " "]
        set View(ZX)            [vectormath::mirrorCoordList $View(ZX) y]
            #
            #
            # -- VIEW ZY -- the relevant view ...
            #
        set miterViewOrigin_y       [$objMiterOrigin    getProfile Origin   right origin]
        set miterViewEnd_y          [$objMiterEnd       getProfile End      left  opposite]
            #
        set miterViewOrigin_y       [vectormath::rotateCoordList    {0 0}   $miterViewOrigin_y   270] ; # 180
        set miterViewEnd_y          [vectormath::rotateCoordList    {0 0}   $miterViewEnd_y      270] ; # 180
        set miterViewEnd_y          [vectormath::addVectorCoordList [list [expr -1 * $lengthTube] 0] $miterViewEnd_y]
            #
            #
        set profile_01              [lrange $profile(zy)  2 end-2]
        set profile_02              {}
        foreach {x z} [lreverse $profile_01] {
            lappend profile_02 $z [expr -1 * $x]
        }   
        set View(ZY)            [join "$miterViewOrigin_y $profile_01 $miterViewEnd_y $profile_02" " "]
        set View(ZY)            [vectormath::rotateCoordList {0 0} $View(ZY) -180]
            #
        if {$profile(x) eq {} && $profile(y) ne {}} {
            set View(Debug_ZX)  $View(Debug_ZY)
        }
        if {$profile(y) eq {} && $profile(x) ne {}} {
            set View(Debug_ZY)  $View(Debug_ZX) 
        }
            #
            #
        set Position(Origin)           {0 0}
            # set Position(EdgeOriginLeft)   [vectormath::rotatePoint {0 0} [lrange $miterViewOrigin_y 0 1]       180]
            # set Position(EdgeOriginRight)  [vectormath::rotatePoint {0 0} [lrange $miterViewOrigin_y end-1 end] 180]
        set Position(EdgeOriginLeft)   [vectormath::rotatePoint {0 0} [lrange $miterViewOrigin_y end-1 end]       180]
        set Position(EdgeOriginRight)  [vectormath::rotatePoint {0 0} [lrange $miterViewOrigin_y 0 1]             180]
        set Position(RefOriginLeft)    [vectormath::addVector $Position(EdgeOriginLeft)     {5 0}]
        set Position(RefOriginRight)   [vectormath::addVector $Position(EdgeOriginRight)    {5 0}]
            # set Position(EdgeOriginLeft)   [vectormath::rotatePoint {0 0} [lrange $miterViewOrigin_y end-1 end] 180]
            # set Position(EdgeOriginRight)  [vectormath::rotatePoint {0 0} [lrange $miterViewOrigin_y 0 1]       180]
            # set Position(_EdgeTaperStartLeft)   [vectormath::rotatePoint {0 0} [lrange $profile_02 end-1 end] 180]
            # set Position(_EdgeTaperStartRight)  [vectormath::rotatePoint {0 0} [lrange $profile_01 0 1] 180]
            #
        set Position(End)              [list $lengthTube 0]
        set Position(EdgeEndLeft)      [vectormath::rotatePoint {0 0} [lrange $miterViewEnd_y 0 1] 180]
        set Position(EdgeEndRight)     [vectormath::rotatePoint {0 0} [lrange $miterViewEnd_y end-1 end] 180]
        set Position(RefEndLeft)       [vectormath::addVector $Position(EdgeEndLeft)        {-5 0}]
        set Position(RefEndRight)      [vectormath::addVector $Position(EdgeEndRight)       {-5 0}]
            # set Position(_EdgeTaperEndLeft)     [vectormath::rotatePoint {0 0} [lrange $profile_01 end-1 end] 180]
            # set Position(_EdgeTaperEndRight)    [vectormath::rotatePoint {0 0} [lrange $profile_02 0 1] 180]
            #
            #
            #
            #
            # puts "-> customTube::Tube update" 
            # parray profile   
            # parray Scalar
            # parray View
            #
        return
            #
    }
        #
    method updateMiter_Origin {} {
            #
        variable Config    
        variable Scalar    
            #
        variable objMiterOrigin    
            #
        set miter(toolAngle)    [my getDictValue    MiterOrigin/toolAngle]
        set miter(toolRotation) [my getDictValue    MiterOrigin/toolRotation]
        set miter(toolType)     [my getDictValue    MiterOrigin/toolType]
        set miter(toolProfile)  [my getDictValue    MiterOrigin/toolProfile]
        set miter(toolOffset)   [my getDictValue    MiterOrigin/toolOffset]
        set miter(precision)    [my getDictValue    MiterOrigin/tubePrecision]
            #
            # puts "-- updateMiter_Origin\n"
            # puts "        -> \$miter(toolAngle)     $miter(toolAngle)"
            # puts "        -> \$miter(toolType)      $miter(toolType)"
            #
            #
        if {[format {%0.6f} $Scalar(Radius_X_Origin)] == [format {%0.6f} $Scalar(Radius_Y_Origin)]} {
            $objMiterOrigin setProfileDef \
                                [list   -type           round \
                                        -diameter       [expr 2 * $Scalar(Radius_X_Origin)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        } else {
            $objMiterOrigin setProfileDef \
                                [list   -type           oval \
                                        -diameter_x     [expr 2 * $Scalar(Radius_X_Origin)] \
                                        -diameter_y     [expr 2 * $Scalar(Radius_Y_Origin)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        }
            #
        switch -exact $miter(toolType) {
            frustum {
                set offset_x    [dict get $miter(toolOffset) x]
                set offset_y    [dict get $miter(toolOffset) y]
                    # puts "   -> \$miter(toolProfile) $miter(toolProfile)"
                foreach {lengthBase radiusBase lengthCone radiusTop} [lrange $miter(toolProfile) 2 5] break
                    # puts "    -> \$lengthBase    $lengthBase"
                    # puts "    -> \$radiusBase    $radiusBase"
                    # puts "    -> \$lengthCone    $lengthCone"
                    # puts "    -> \$radiusTop     $radiusTop"
                    #
                $objMiterOrigin setToolType                     frustum
                $objMiterOrigin setScalar  AngleTool            $miter(toolAngle)
                $objMiterOrigin setScalar  DiameterTool         [expr 2 * $radiusBase]   
                $objMiterOrigin setScalar  DiameterTop          [expr 2 * $radiusTop]  
                $objMiterOrigin setScalar  HeightToolCone       $lengthCone    
                $objMiterOrigin setScalar  OffsetCenterLine     $offset_x   
                $objMiterOrigin setScalar  OffsetToolBase       [expr $offset_y - $lengthBase] 
            }
            cylinder {
                set offset_x    [dict get $miter(toolOffset) x]
                set radiusTool  [lindex $miter(toolProfile) 1]
                $objMiterOrigin setToolType                     cylinder
                $objMiterOrigin setScalar   AngleTool           $miter(toolAngle)
                $objMiterOrigin setScalar   DiameterTool        [expr 2 * $radiusTool]   
                $objMiterOrigin setScalar   OffsetCenterLine    $offset_x   
            }
            plane -
            default {
                $objMiterOrigin setToolType                     plane 
                $objMiterOrigin setScalar   AngleTool           $miter(toolAngle)
            }
        }
            #
        $objMiterOrigin updateMiter
            #
    }    
        #
    method updateMiter_End {} {
            #
        variable Config    
        variable Scalar    
            #
        variable objMiterEnd    
            #
        set miter(toolAngle)    [my getDictValue    MiterEnd/toolAngle]
        set miter(toolRotation) [my getDictValue    MiterEnd/toolRotation]
        set miter(toolType)     [my getDictValue    MiterEnd/toolType]
        set miter(toolProfile)  [my getDictValue    MiterEnd/toolProfile]
        set miter(toolOffset)   [my getDictValue    MiterEnd/toolOffset]
        set miter(precision)    [my getDictValue    MiterEnd/tubePrecision]
            #
            # puts "\n -> updateMiter_End\n"
            # puts "        -> \$miter(toolAngle)     $miter(toolAngle)"
            # puts "        -> \$miter(toolType)      $miter(toolType)"
            #
            # parray Scalar    
            #
        if {[format {%0.6f} $Scalar(Radius_X_End)] == [format {%0.6f} $Scalar(Radius_Y_End)]} {
            $objMiterEnd    setProfileDef \
                                [list   -type           round \
                                        -diameter       [expr 2 * $Scalar(Radius_X_End)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        } else {
            $objMiterEnd    setProfileDef \
                                [list   -type           oval \
                                        -diameter_x     [expr 2 * $Scalar(Radius_X_End)] \
                                        -diameter_y     [expr 2 * $Scalar(Radius_Y_End)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        }
            #
            #
        switch -exact $miter(toolType) {
            frustum {
                set offset_x    [dict get $miter(toolOffset) x]
                set offset_y    [dict get $miter(toolOffset) y]
                    # puts "   -> \$miter(toolProfile) $miter(toolProfile)"
                foreach {lengthBase radiusBase lengthCone radiusTop} [lrange $miter(toolProfile) 2 5] break
                    # puts "    -> \$lengthBase    $lengthBase"
                    # puts "    -> \$radiusBase    $radiusBase"
                    # puts "    -> \$lengthCone    $lengthCone"
                    # puts "    -> \$radiusTop     $radiusTop"
                    #
                $objMiterEnd    setToolType                     frustum
                $objMiterEnd    setScalar  AngleTool            $miter(toolAngle)
                $objMiterEnd    setScalar  DiameterTool         [expr 2 * $radiusBase]  
                $objMiterEnd    setScalar  DiameterTop          [expr 2 * $radiusTop]
                $objMiterEnd    setScalar  HeightToolCone       $lengthCone    
                $objMiterEnd    setScalar  OffsetCenterLine     $offset_x   
                $objMiterEnd    setScalar  OffsetToolBase       [expr $offset_y - $lengthBase] 
            }
            cylinder {
                set offset_x    [dict get $miter(toolOffset) x]
                set radiusTool  [lindex $miter(toolProfile) 1]
                $objMiterEnd    setToolType                     cylinder
                $objMiterEnd    setScalar   AngleTool           $miter(toolAngle)
                $objMiterEnd    setScalar   DiameterTool        [expr 2 * $radiusTool]
                $objMiterEnd    setScalar   OffsetCenterLine    $offset_x   
            }
            plane -
            default {
                $objMiterEnd    setToolType                     plane 
                $objMiterEnd    setScalar   AngleTool           $miter(toolAngle)
            }
        }
            #
            #
        $objMiterEnd    updateMiter
            #
    }    
        #
    method setDictionary {tubeDict} {
            #
        variable tubeDictionary
            #
        set tubeDictionary $tubeDict 
            #
        return
            #
    }
        
        
        #
    method getDictValue {dictPath} {
            #
        variable tubeDictionary
            #
        set dictPath [string map {"/" " "} $dictPath]
            #
        if {[catch {set value [dict get $tubeDictionary {*}$dictPath]} eID]} {
            return {}
        } else {
            return [join $value]
        }
            #
    }    
        #
    method getView {key} {
            #
        variable View
            #
        switch -exact $key {
            Debug_ZX {
                return $View(Debug_ZX)
            }
            Debug_ZY {
                return $View(Debug_ZY)
            }
            zx -
            zx -
            ZX -
            xz -
            XZ {
                return $View(ZX)
            }
            zy -
            ZY -
            yz -
            YZ -
            default {
                return $View(ZY)
            }
        }    
            #
    }    
        #
    method getMiterOrigin {} {    
        variable objMiterOrigin
        return  $objMiterOrigin
    }
        #
    method getMiterEnd {} {    
        variable objMiterEnd
        return  $objMiterEnd
    }    
        #
    method getPosition {keyName} {
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
        #
        #
    method ____updateMiterObject {key} {
            #
        variable Config    
        variable Scalar    
            #
        variable objMiterOrigin        
        variable objMiterEnd           
            #
        switch -exact $key {
            origin {
                set objMiter    $objMiterOrigin
                set keyDict     MiterOrigin
            }
            end -
            default {
                set objMiter    $objMiterEnd
                set keyDict     MiterEnd
            }
        }
            #
        set miter(toolAngle)    [my getDictValue    $keyDict/toolAngle]
        set miter(toolRotation) [my getDictValue    $keyDict/toolRotation]
        set miter(toolType)     [my getDictValue    $keyDict/toolType]
        set miter(toolProfile)  [my getDictValue    $keyDict/toolProfile]
        set miter(toolOffset)   [my getDictValue    $keyDict/toolOffset]
        set miter(precision)    [my getDictValue    $keyDict/tubePrecision]
            #
        puts "-- updateMiter: $key -> $objMiter \n"
        puts "        -> \$miter(toolAngle)     $miter(toolAngle)"
        puts "        -> \$miter(toolType)      $miter(toolType)"
            #
            #
        if {[format {%0.6f} $Scalar(Radius_X_Origin)] == [format {%0.6f} $Scalar(Radius_Y_Origin)]} {
            $objMiter setProfileDef \
                                [list   -type           round \
                                        -diameter       [expr 2 * $Scalar(Radius_X_Origin)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        } else {
            $objMiter setProfileDef \
                                [list   -type           oval \
                                        -diameter_x     [expr 2 * $Scalar(Radius_X_Origin)] \
                                        -diameter_y     [expr 2 * $Scalar(Radius_Y_Origin)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        }
            #
        switch -exact $miter(toolType) {
            frustum {
                set offset_x    [dict get $miter(toolOffset) x]
                set offset_y    [dict get $miter(toolOffset) y]
                    # puts "   -> \$miter(toolProfile) $miter(toolProfile)"
                foreach {lengthBase radiusBase lengthCone radiusTop} [lrange $miter(toolProfile) 2 5] break
                    # puts "    -> \$lengthBase    $lengthBase"
                    # puts "    -> \$radiusBase    $radiusBase"
                    # puts "    -> \$lengthCone    $lengthCone"
                    # puts "    -> \$radiusTop     $radiusTop"
                    #
                $objMiter   setToolType                     frustum
                $objMiter   setScalar  AngleTool            $miter(toolAngle)
                $objMiter   setScalar  DiameterTool         [expr 2 * $radiusBase]   
                $objMiter   setScalar  DiameterTop          [expr 2 * $radiusTop]  
                $objMiter   setScalar  HeightToolCone       $lengthCone    
                $objMiter   setScalar  OffsetCenterLine     $offset_x   
                $objMiter   setScalar  OffsetToolBase       [expr $offset_y - $lengthBase] 
            }
            cylinder {
                set offset_x    [dict get $miter(toolOffset) x]
                set radiusTool  [lindex $miter(toolProfile) 1]
                $objMiter   setToolType                     cylinder
                $objMiter   setScalar   AngleTool           $miter(toolAngle)
                $objMiter   setScalar   DiameterTool        [expr 2 * $radiusTool]   
                $objMiter   setScalar   OffsetCenterLine    $offset_x   
            }
            plane -
            default {
                $objMiter   setToolType                     plane 
                $objMiter   setScalar   AngleTool           $miter(toolAngle)
            }
        }
            #
        $objMiter updateMiter
            #
    }    
        #
    method getProfile {keyName} {
        variable Profile
        if {[array names Profile -exact $keyName] != {}} {
            set value [lindex [array get Profile $keyName] 1]
            return $value
        } else {
            return -code error "[info object class [self]] getProfile $keyName ... does not exist"
        }
    }
        #
}

