 ##+##########################################################################
 #
 # package: bikeFrame    ->    classProvideSeatTube.tcl
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
 

oo::class create bikeFrame::ProvideHeadTube {
        #
    superclass bikeFrame::AbstractProvidePart
        #
    constructor {} {
            #
        puts "              -> class ProvideHeadTube"
            #
        variable providedObject [bikeFrame::HeadTube new]
            #
        next
            #
        variable CenterLine ; array set CenterLine {
                                    xy              {}
                                    xz              {}
                                }
        variable Config     ; array set Config {
                                    Type            cylindric                                            
                                }
        variable Profile    ; array set Profile {
                                    xy              {}
                                    xz              {}
                                }
        variable Scalar     ; array set Scalar {
                                    Angle                  71.99
                                    Diameter               27.99
                                    DiameterTaperedBase    45.99
                                    DiameterTaperedTop     32.99
                                    HeightTaperedBase      11.99
                                    Length                 99.99
                                    LengthTaper            45.99
                                }
        variable Direction  ; array set Direction {
                                    Config          {0.00   1.00}
                                }
        variable Position   ; array set Position {
                                    Origin          {0.00   0.00}
                                    End             {0.00 100.00}
                                }
            #
        variable Shape      ; array set Shape {
                                    xy              {}
                                    xz              {}
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
    method initValues {myDict} {
            #
        variable providedObject
        variable Scalar
            #
        $providedObject initValues $myDict
            #
        my prototype_initValues $myDict
            #
        set myAngle $Scalar(Angle)
            #
        my prototype_setDirection Config    [vectormath::dirCarthesian [expr {180 - $Scalar(Angle)}]]
            #
        return
            #
    }            
        #
    method updateGeometry {} {
            # method is called by ... my
            #
        variable providedObject
            #
        variable CenterLine
        variable Config
        variable Direction
        variable Position
        variable Profile
        variable Scalar
            #
            #
            # puts " $Position(Origin) - $Direction(Scalar) - $Scalar(Length)                "
        set Position(End)               [vectormath::addVector $Position(Origin) $Direction(Config) $Scalar(Length)]                  
            #
            #
        set CenterLine(xz)              [join "$Position(Origin) $Position(End)" " "]
            #
            #
        $providedObject                 update_Geometry 
            #
            #
        set Config(Type)                [$providedObject getConfig Type]
            #
        set Scalar(Diameter)            [$providedObject getScalar Diameter]
        set Scalar(DiameterTaperedBase) [$providedObject getScalar DiameterTaperedBase]
        set Scalar(DiameterTaperedTop)  [$providedObject getScalar DiameterTaperedTop]
        set Scalar(HeightTaperedBase)   [$providedObject getScalar HeightTaperedBase]
        set Scalar(Length)              [$providedObject getScalar Length]
        set Scalar(LengthTaper)         [$providedObject getScalar LengthTaper]
        set Scalar(Shape)               [$providedObject getConfig Type]                                          
            #
        set Profile(xy)                 [$providedObject getProfile xy]
        set Profile(xz)                 [$providedObject getProfile xz]
            #
            #
        return
            #
    }
        #
    method updateShape {} {
            #
        variable providedObject
            #
        variable Position
        variable Shape
            #
            #
            # -- Shape
            #
        $providedObject                     update_Shape
            #
        set Shape(xz)                       [my _getShape    xz]
        set Shape(xy)                       [my _getShape    xy]
            #
        set Position(_EdgeEndRight)         [my _getEdgePosition _EdgeEndRight]
        set Position(_EdgeTaperStartRight)  [my _getEdgePosition _EdgeTaperStartRight]
        set Position(_EdgeTaperEndRight)    [my _getEdgePosition _EdgeTaperEndRight]
        set Position(_EdgeOriginRight)      [my _getEdgePosition _EdgeOriginRight]
        set Position(_EdgeEndLeft)          [my _getEdgePosition _EdgeEndLeft]
        set Position(_EdgeTaperStartLeft)   [my _getEdgePosition _EdgeTaperStartLeft]
        set Position(_EdgeTaperEndLeft)     [my _getEdgePosition _EdgeTaperEndLeft]
        set Position(_EdgeOriginLeft)       [my _getEdgePosition _EdgeOriginLeft]
            #
    }
        #
    method _getShape {shapeName} {
            #
        variable providedObject
        variable Position
            #
        set shape [$providedObject getShape $shapeName]
            #
        if {$shapeName == {xz}} {
            set shape [vectormath::rotateCoordList      {0 0} $shape [my getDirection Config degree]]
            set shape [vectormath::addVectorCoordList   $Position(Origin) $shape]
        }
            #
        return $shape
            #
    }
        #
        #
    method setScalar {keyName value} {
        variable Scalar
        variable providedObject
        switch -exact $keyName {
            Angle {
                    set Scalar($keyName)  $value
                    my prototype_setDirection Config    [vectormath::dirCarthesian [expr {180 - $value}]]
                }
            default { 
                    $providedObject setScalar $keyName $value
                }
        }
            #
        return [my prototype_getScalar $keyName]
    }
        #
        #
    method getDiameter_Base {} {
        variable Config
        variable Scalar
        switch -exact $Config(Type) {
            tapered {   return $Scalar(DiameterTaperedBase)}
            cylindric -
            default {   return $Scalar(Diameter)}
        }
    }
        #
    method getDiameter_Top {} {
        variable Config
        variable Scalar
        switch -exact $Config(Type) {
            tapered {   return $Scalar(DiameterTaperedTop)}
            cylindric -
            default {   return $Scalar(Diameter)}
        }
    }
        #
    method getProfileTool {} {
            #
        variable Config
        variable Scalar
            #
        set lengthHTTaper           $Scalar(LengthTaper)
        set lengthHTBase            $Scalar(HeightTaperedBase)
        set radiusHT                [expr {0.5 * $Scalar(Diameter)}]
        set radiusHTBase            [expr {0.5 * $Scalar(DiameterTaperedBase)}]
        set radiusHTTop             [expr {0.5 * $Scalar(DiameterTaperedTop)}]
            #
        switch -exact $Config(Type) {
            tapered {
                return [list 0 $radiusHTBase  $lengthHTBase $radiusHTBase  $lengthHTTaper $radiusHTTop  250 $radiusHTTop]
            }
            cylindric -
            default {
                return [list 0 $radiusHT]
            }
        }
            #
    }
        #
}

    