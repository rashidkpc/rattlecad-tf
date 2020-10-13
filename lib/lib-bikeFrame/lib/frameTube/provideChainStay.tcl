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
 

oo::class create bikeFrame::ProvideChainStay {
        #
    superclass bikeFrame::AbstractProvidePart
        #
    variable lug_BottomBracket
    variable lug_RearDropout            
        #
    constructor {} {
            #
        puts "              -> class ProvideChainStay"
            #
        variable lug_BottomBracket  [bikeFrame::ProvideBottomBracket  new]
        variable lug_RearDropout    [bikeFrame::ProvideRearDropout    new]
            #
        next
            #
        variable providedObject     [bikeFrame::ChainStay new]
            #
        variable CenterLine ; array set CenterLine {
                                    xy              {}
                                    xz              {}
                                }
        variable Config     ; array set Config {
                                    Type            {}
                                }
        variable Direction  ; array set Direction {
                                    Config      {-1.00 -1.00}
                                }
        variable Profile    ; array set Profile {
                                    xy              {}
                                    xz              {}
                                }
        variable Position   ; array set Position {
                                }
        variable Scalar     ; array set Scalar {
                                    OffsetBBTopView      3.21
                                    OffsetDO            31.21
                                    OffsetDOPerp        -3.21
                                    OffsetDOTopView      5.21
                                    DiameterSS          {}
                                    Height              {}
                                    HeightBB            {}
                                    LengthCntrCntr      {}
                                    LengthTaper         {}
                                    WidthBB             {}
                                    completeLength      {}
                                    cuttingAngle        {}
                                    cuttingLeft         {}
                                    cuttingLength       {}
                                    profile_x01         {}
                                    profile_x02         {}
                                    profile_x03         {}
                                    profile_y00         {}
                                    profile_y01         {}
                                    profile_y02         {}
                                    segmentAngle_01     {}
                                    segmentAngle_02     {}
                                    segmentAngle_03     {}
                                    segmentAngle_04     {}
                                    segmentLength_01    {}
                                    segmentLength_02    {}
                                    segmentLength_03    {}
                                    segmentLength_04    {}
                                    segmentRadius_01    {}
                                    segmentRadius_02    {}
                                    segmentRadius_03    {}
                                    segmentRadius_04    {}
                                }
        variable Shape      ; array set Shape {
                                    xy          {}
                                    xz          {}
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
            #
        my prototype_initValues $myDict
            #
        $providedObject initValues $myDict
            #
    }    
        #
    method updateGeometry {} {
            #
        variable providedObject
            #
        variable CenterLine
        variable Config
        variable Scalar
        variable Direction
        variable Position
        variable Scalar
        variable Shape
        variable Profile
            #
            #
        variable lug_BottomBracket
        variable lug_RearDropout
            #
            #
        $providedObject setScalar   BottomBracket_DiaInside [$lug_BottomBracket getScalar DiameterInside]
        $providedObject setScalar   BottomBracket_Width     [$lug_BottomBracket getScalar Width]
        $providedObject setScalar   RearHub_Width           [$lug_RearDropout   getScalar WidthHub]
            #
            # exit
            #
            # set angle(Dropout)          [$lug_RearDropout getDirection Config degree]
        set angle(OffsetRotation)   [$lug_RearDropout getScalar OffsetRotation]
        set orient(Dropout)         [$lug_RearDropout getConfig Orientation]
        set vct(OffsetDO)           [list $Scalar(OffsetDO) $Scalar(OffsetDOPerp)]
        set pos(RearDropout)        [$lug_RearDropout   getPosition Origin]
        set pos(BottomBracket)      [$lug_BottomBracket getPosition Origin]
        set dir(Geometry)           [vectormath::unifyVector $pos(RearDropout) $pos(BottomBracket)]
            #
        switch -exact $orient(Dropout) {
            horizontal {
                    set angle(Dropout)  [expr {-1.0 * $angle(OffsetRotation)}]
                }
            chainstay -
            Chainstay -
            ChainStay -
            default {
                     set angle(Dropout) [expr {[vectormath::localVector_2_Degree $dir(Geometry)] - $angle(OffsetRotation)}]
                }
        }
            #
            # --++-- update RearDropout --++++++++++++++++--
            #
        $lug_RearDropout   setDirection Config $angle(Dropout)
        $lug_RearDropout   updateGeometry
            #
            # --++-- update RearDropout --++++++++++++++++--
            #
            #
        set vct(OffsetDO)               [vectormath::rotatePoint   {0 0} $vct(OffsetDO) $angle(Dropout)]
        set pos(ChainStay)              [vectormath::addVector     $pos(RearDropout)    $vct(OffsetDO)]
            #
        set lng(Geometry)               [vectormath::length $pos(RearDropout) $pos(BottomBracket)]
        set lng(ChainStay)              [vectormath::length $pos(ChainStay)   $pos(BottomBracket)]
        $providedObject setScalar       Length_XZ   $lng(ChainStay)    
            #
            #
        set Position(ChainStay)         $pos(ChainStay)
            #
        set Position(Origin)            $pos(ChainStay)
        set Position(End)               $pos(BottomBracket)
            #
        set Direction(Config)           [vectormath::unifyVector $Position(Origin) $Position(End)]
            #
        set CenterLine(xz)              [join "$Position(Origin) $Position(End)" " "]
            #
            #
        set Config(Type)                [$providedObject getConfig Type]
            #
        set Scalar(DiameterSS)          [$providedObject getScalar DiameterSS]      
        set Scalar(Height)              [$providedObject getScalar Height]
        set Scalar(HeightBB)            [$providedObject getScalar HeightBB]
        set Scalar(LengthTaper)         [$providedObject getScalar LengthTaper]
        set Scalar(WidthBB)             [$providedObject getScalar WidthBB]
        set Scalar(completeLength)      [$providedObject getScalar completeLength] 
        set Scalar(cuttingAngle)        [$providedObject getScalar cuttingAngle]
        set Scalar(cuttingLeft)         [$providedObject getScalar cuttingLeft]
        set Scalar(cuttingLength)       [$providedObject getScalar cuttingLength]
        set Scalar(profile_x01)         [$providedObject getScalar profile_x01]
        set Scalar(profile_x02)         [$providedObject getScalar profile_x02]
        set Scalar(profile_x03)         [$providedObject getScalar profile_x03]
        set Scalar(profile_y00)         [$providedObject getScalar profile_y00]
        set Scalar(profile_y01)         [$providedObject getScalar profile_y01]
        set Scalar(profile_y02)         [$providedObject getScalar profile_y02]
        set Scalar(segmentAngle_01)     [$providedObject getScalar segmentAngle_01]
        set Scalar(segmentAngle_02)     [$providedObject getScalar segmentAngle_02]
        set Scalar(segmentAngle_03)     [$providedObject getScalar segmentAngle_03]
        set Scalar(segmentAngle_04)     [$providedObject getScalar segmentAngle_04]
        set Scalar(segmentLength_01)    [$providedObject getScalar segmentLength_01]
        set Scalar(segmentLength_02)    [$providedObject getScalar segmentLength_02]
        set Scalar(segmentLength_03)    [$providedObject getScalar segmentLength_03]
        set Scalar(segmentLength_04)    [$providedObject getScalar segmentLength_04]
        set Scalar(segmentRadius_01)    [$providedObject getScalar segmentRadius_01]
        set Scalar(segmentRadius_02)    [$providedObject getScalar segmentRadius_02]
        set Scalar(segmentRadius_03)    [$providedObject getScalar segmentRadius_03]
        set Scalar(segmentRadius_04)    [$providedObject getScalar segmentRadius_04]
            #
        # $providedObject setScalar Length_XZ  [vectormath::length $Position(Origin) $Position(End)]    
            #
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
        variable Shape
        variable CenterLine
        variable Position
        variable Profile
            #
            
            #
            # -- Shape
            #
        $providedObject     update_Shape
            #
        set Shape(xz)               [my _getShape xz]
        set Shape(xy)               [my _getShape xy]
            # 
        set CenterLine(xy)          [$providedObject getCenterLine xy]
        set CenterLine(xy_Control)  [$providedObject getCenterLine xy_Control]
        set CenterLine(xy_Full)     [$providedObject getCenterLine xy_Full]
        set Position(Origin_XY)     [$providedObject getPosition   xy]
        set Profile(xy)             [$providedObject getProfile    xy]
        set Profile(xz)             [$providedObject getProfile    xz]
             
            #
            
            #
        return             
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
        switch -exact $shapeName {    
            xz {
                set shape [vectormath::rotateCoordList      {0 0} $shape [my getDirection Config degree]]
                set shape [vectormath::addVectorCoordList   $Position(Origin) $shape]
            }
        }
            #
        return $shape
            #
    }
        #
        #
    method setRearDropout {object} {
        variable lug_RearDropout
        set lug_RearDropout $object
    }
        #
    method setBottomBracket {object} {
        variable lug_BottomBracket
        set lug_BottomBracket $object
    }
        #
        #
}

