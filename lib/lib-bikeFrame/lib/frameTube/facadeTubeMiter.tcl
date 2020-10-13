 ##+##########################################################################
 #
 # package: bikeFrame    ->   facadeTubeMiter.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/19
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


oo::class create bikeFrame::FacadeTubeMiter {
        #
        #
    variable tubeMiter    
        #
    variable Scalar
    variable Config
        #
        #
    constructor {toolType} {
            #
        puts "              -> class FacadeTubeMiter"
            #
            #
        variable tubeMiter  [tubeMiter::createMiter $toolType]
            #
        variable Scalar     ; array set Scalar {
                                    Angle             90.00
                                    DiameterTool      45.21
                                    DiameterTop       39.21
                                    DiameterTube      31.21
                                    HeightToolCone    45.31
                                    OffsetCenterLine   0.00
                                    OffsetToolBase    32.12
                                    StartAngle         0.00                                        
                                }
        variable Config     ; array set Config {
                                    Type            $toolType
                                    View            origin
                                }
            #
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... [info object class [self]]  $target_method $args  ... unknown"
        return -code error " '[info object class [self]]' $target_method $args  ... unknown"
    }
        #
    method updateMiter {} {
            #
        variable tubeMiter
            #
        variable Config
        variable Scalar
            #
        variable Miter
        variable Shape
            #
        $tubeMiter  setScalar   DiameterTube        $Scalar(DiameterTube)
            #
        $tubeMiter  setScalar   AngleTool           $Scalar(Angle)          
        $tubeMiter  setScalar   DiameterTool        $Scalar(DiameterTool)
        $tubeMiter  setScalar   DiameterTop         $Scalar(DiameterTop)
        $tubeMiter  setScalar   HeightToolCone      $Scalar(HeightToolCone)
        $tubeMiter  setScalar   OffsetCenterLine    $Scalar(OffsetCenterLine)
        $tubeMiter  setScalar   OffsetToolBase      $Scalar(OffsetToolBase)
        $tubeMiter  setScalar   AngleToolPlane      $Scalar(StartAngle)
            #
        $tubeMiter  updateMiter    
            #
    }
        #
    method getProfile {positionName {keyName right}} {
            #
        variable tubeMiter
            #
        variable Config
        variable Scalar
            #
        switch -exact $positionName {
            Origin  -
            End {
                    set myProfile   {}
                    set __Profile   [$tubeMiter getProfile  $positionName   $keyName    $Config(View)]
                        # puts "   -> \$__Profile $__Profile"
                        #
                    set __profile   [vectormath::rotateCoordList    {0 0}   $__Profile  180]
                        #
                    foreach {x y} $__profile {
                        lappend myProfile   [list $x $y]
                    }
                        #
                        # puts "   -> \$myProfile $myProfile"
                        #
                    return $myProfile
                }
            default {
                    puts "  -> <E> getProfile $positionName"
                    return {{0 1} {0 -1}}
                }
        }
            #
    }
        #
    method getMiterNew {positionName  {view origin}} {
            #
        variable tubeMiter
            #
        variable Scalar
            #
        switch -exact $positionName {
            Origin  -
            End {
                    set myMiter     [$tubeMiter getMiter    $positionName $view]
                    return $myMiter
                }
            default {
                    puts "  -> <E> getMiter $positionName $view"
                    exit
                    return {0 -1  0 1}
                }
        }
            #
    }
        #
    method getMiter {positionName} {
            #
        variable tubeMiter
            #
        variable Config
        variable Scalar
            #
        switch -exact $positionName {
            Origin  -
            End {
                    set myMiter     [$tubeMiter getMiter    $positionName $Config(View)]
                    return $myMiter
                }
            default {
                    puts "  -> <E> getMiter $positionName"
                    exit
                    return {-99 -99 99 99}
                }
        }
            #
    }
        #
    method getMiter_org {positionName} {
            #
        variable tubeMiter
            #
        variable Config
        variable Scalar
            #
        switch -exact $positionName {
            Unwrapped {
                    set myMiter     [$tubeMiter getMiter    $positionName $Config(View)]
                    return $myMiter
                }
            default {
                    puts "  -> <E> getMiter $positionName"
                    exit
                    return {-99 -99 99 99}
                }
        }
            #
    }
        #
    method setConfig {keyName value} {
            #
        variable tubeMiter
        variable Config
            #
        switch -exact $keyName {
            Type {
                    switch -exact $value {
                        coneMiter       {set value "frustum"}
                        cylinderMiter   {set value "cylinder"}
                        planeMiter      {set value "plane"}
                        default         {}
                    }
                    set currentType [$tubeMiter getToolType]
                        #
                    if {$value ne $currentType} {
                        $tubeMiter setToolType  $value
                    }
                }
            default {}
        }
        return [my prototype_setConfig $keyName $value]
    }
        #
    method setScalar {keyName value} {
        return [my prototype_setScalar $keyName $value]
    }
        #
    method getConfig {keyName} {
        return [my prototype_getConfig $keyName]
    }
        #
    method getScalar {keyName} {
        return [my prototype_getScalar $keyName]
    }
        #
}
    #
oo::define bikeFrame::FacadeTubeMiter {mixin bikeFrame::MixinMethodProtoypes}
    #
