 ##+##########################################################################
 #
 # package: bikeFrame    ->    classHeadTube.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk and tdom on their
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


oo::class create bikeFrame::HeadTube {
        #
    superclass bikeFrame::AbstractTube
        #
    constructor {} {
            #
        puts "              -> class HeadTube"
            #
        next                ;# call constructor of superclass AbstractComponent
            #
        variable Config ; array set Config {
                                Type               {cylindric}                                            
                            } 
        variable Scalar ; array set Scalar {
                                Diameter              35.21
                                DiameterTaperedBase   56.21
                                DiameterTaperedTop    46.21
                                HeightTaperedBase     15.21
                                Length               110.21
                                LengthTaper           70.21                                          
                            } 
        variable Shape  ; array set Shape {
                                xy                  {}
                                xz                  {}
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
    method update_Geometry {} {
            #
        variable CenterLine
        variable Config
        variable Position
        variable Profile
        variable Scalar
        variable Shape 
            #
        switch -exact $Config(Type) {
            tapered {
                    set Profile(xy) [list   0                           [expr {0.5 * $Scalar(DiameterTaperedBase)}] \
                                            $Scalar(HeightTaperedBase)  [expr {0.5 * $Scalar(DiameterTaperedBase)}] \
                                            [expr {$Scalar(HeightTaperedBase)} + $Scalar(LengthTaper)] [expr {0.5 * $Scalar(DiameterTaperedTop)}] \
                                            $Scalar(Length)             [expr {0.5 * $Scalar(DiameterTaperedTop)}]]
                }
            default {
                    set Profile(xy) [list   0                           [expr {0.5 * $Scalar(Diameter)}] \
                                            $Scalar(Length)             [expr {0.5 * $Scalar(Diameter)}]]
                }
        }               
        set Profile(xz) $Profile(xy)
            #
        return
            #   
    }            
        #
    method update_Shape {} {
            #
        variable tubeMiter_Start
        variable tubeMiter_End
            #
        variable Config
        variable Scalar
            #
        variable Position
            #
        switch -exact $Config(Type) {
            tapered {
                        set length(p1)      $Scalar(HeightTaperedBase)
                        set length(p2)      $Scalar(LengthTaper)
                        set length(p3)      [expr {$Scalar(Length) - $length(p1) - $length(p2)}]
                        set diameter(Base)  $Scalar(DiameterTaperedBase)
                        set diameter(End)   $Scalar(DiameterTaperedTop)
                    }
            cylindric -
            default {
                        set length(p1)      [expr {0.3 * $Scalar(Length)}]
                        set length(p2)      [expr {0.4 * $Scalar(Length)}]
                        set length(p3)      [expr {$Scalar(Length) - $length(p1) - $length(p2)}]
                        set diameter(Base)  $Scalar(Diameter)
                        set diameter(End)   $Scalar(Diameter)
                    }
        }
            #
        $tubeMiter_Start    setConfig   Type            planeMiter    
        $tubeMiter_Start    setScalar   DiameterTube    $diameter(Base)
        $tubeMiter_End      setConfig   Type            planeMiter    
        $tubeMiter_End      setScalar   DiameterTube    $diameter(End)
            #
        my _setShape5       $tubeMiter_Start \
                            $tubeMiter_End \
                            $diameter(Base) \
                            $length(p1) \
                            $diameter(Base) \
                            $length(p2) \
                            $diameter(End) \
                            $length(p3) \
                            $diameter(End)
            #
        return
            #
    }  
        #
        #
    method setScalar {keyName value} {
        variable Scalar
        switch -exact $keyName {
            Diameter            -
            DiameterTaperedBase -
            DiameterTaperedTop  -
            HeightTaperedBase   -
            Length              -
            LengthTaper {   
                    set Scalar($keyName) $value
                } 
            default {   
                    return
                }
        }
        return [my prototype_getScalar $keyName]
    }
        #
}
