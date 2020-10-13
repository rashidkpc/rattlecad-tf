 ##+##########################################################################
 #
 # package: bikeFrame    ->    classProvideSeatTube.tcl
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
 

oo::class create bikeFrame::ProvideSeatStay {
        #
    superclass bikeFrame::AbstractProvidePart
        #
    #variable tube_SeatTube
    #variable tube_TopTube
    #variable lug_RearDropout            
        #
    constructor {} {
            #
        puts "              -> class ProvideSeatStay"
            #
        variable tube_ChainStay     [bikeFrame::ProvideChainStay      new]
        variable tube_SeatTube      [bikeFrame::ProvideSeatTube       new]
        variable tube_TopTube       [bikeFrame::ProvideTopTube        new]
        variable lug_RearDropout    [bikeFrame::ProvideRearDropout    new]
            #
        variable myTube             [customTube::Tube new]
        variable myTubeDict         [dict create]
            #
        next
            #
        variable CenterLine ; array set CenterLine {
                                    xy              {}
                                    xz              {}
                                }
        variable Direction;   array set Direction {
                                    Config          {-1.00  1.00}
                                }
        variable Miter      ; array set Miter {
                                    Origin          {}
                                    End             {} 
                                }
        variable Position;    array set Position {
                                    Origin              {0 0}
                                    End                 {1 1}
                                    IS_ChainStay        {2 1}
                                }
        variable Profile    ; array set Profile {
                                    xy              {}
                                    xz              {}
                                }
        variable Scalar;   array set Scalar {
                                    DiameterCS          {}
                                    DiameterST          {}
                                    DiameterMiterST   27.21
                                    LengthTaper         {} 
                                    OffsetDO          34.21
                                    OffsetDOPerp      -1.21                                   
                                    OffsetTT          21.21
                                }
        variable Shape      ; array set Shape {
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
    method updateGeometry {} {
            #
        variable CenterLine
        variable Scalar
        variable Direction
        variable Position
        variable Profile
            #
        variable tube_ChainStay
        variable tube_SeatTube
        variable tube_TopTube
        variable lug_RearDropout
            #
        variable miter_Origin
        variable miter_End
            #
            #
        set pos(RearDropout)        [$lug_RearDropout getPosition Origin]    
        set pos(TopTube)            [$tube_TopTube    getPosition_End]    
        set dir(SeatTube)           [$tube_SeatTube   getDirection Config]    
            #
        set Position(End)           [vectormath::addVector $pos(TopTube) $dir(SeatTube) $Scalar(OffsetTT)]
            #
            #
        set dir(SeatStay)           [vectormath::unifyVector    $pos(RearDropout) $Position(End)]
        set pos(SeatStay_1)         [vectormath::addVector      $pos(RearDropout) $dir(SeatStay)    $Scalar(OffsetDO)]
        set pos(SeatStay)           [vectormath::perpendicular  $pos(SeatStay_1)  $pos(RearDropout) $Scalar(OffsetDOPerp) right]
            #
        set Position(Origin)        $pos(SeatStay)
            #
        set Scalar(Length_XZ)       [vectormath::length $Position(Origin) $Position(End)]    
            #
            #
        set endLength   [expr {$Scalar(Length_XZ) - $Scalar(LengthTaper)}]
        set Profile(xy) [list 0 [expr {0.5 * $Scalar(DiameterCS)}] $Scalar(LengthTaper) [expr {0.5 * $Scalar(DiameterST)}] $Scalar(Length_XZ) [expr {0.5 * $Scalar(DiameterST)}]]
        set Profile(xz) $Profile(xy)
            #
            #
        set Scalar(MiterAngle_End)  [vectormath::angle $Position(Origin) $Position(End) [$tube_SeatTube getPosition Origin]]
            #
            #
        set Direction(Config)       [vectormath::unifyVector $Position(Origin) $Position(End)]
            #
            #
        set pos(ChainStay_1)        [$tube_ChainStay    getPosition Origin]
        set pos(ChainStay_2)        [$tube_ChainStay    getPosition End]
        set pos(ChainStay)          [vectormath::intersectPoint $Position(Origin) $Position(End) $pos(ChainStay_1) $pos(ChainStay_2)]
            #
            #
        set Position(IS_ChainStay)  $pos(ChainStay)
            #
            #
        set CenterLine(xz)          [join "$Position(Origin) $Position(End)" " "]
            #
            #
        return
            #
    }
        #
    method updateShape {} {
            #
        variable tube_SeatTube
            #
        variable myTube
        variable myTubeDict
            #
        variable miter_Origin
        variable miter_End
            #
        variable Miter
        variable Position
        variable Profile
        variable Scalar
        variable Shape
            #
            #
        set lengthTube              $Scalar(Length_XZ)
        set length01                $Scalar(LengthTaper)
        set length02                [expr {$lengthTube - $length01}]
        set radius01                [expr {0.5 * $Scalar(DiameterCS)}]
        set radius02                [expr {0.5 * $Scalar(DiameterST)}]
            #
            #  set radiusST                [expr  0.5 * [$tube_SeatTube getScalar DiameterTT]]
            #
        set diameter_ST              [$tube_SeatTube getScalar DiameterTT]
        set diameter_ST_Miter        $Scalar(DiameterMiterST)
        if {$diameter_ST_Miter > $diameter_ST} {
            set radius_Miter        [expr {0.5 * $diameter_ST_Miter}]
        } else {
            set radius_Miter        [expr {0.5 * $diameter_ST}]
        }
        set offsetST                [expr {$radius02 - $radius_Miter}]
            #
            # -- Description --
            #
        dict set myTubeDict  MetaData {
                    Name            SeatStay
                }
            #
            # -- Tube --
            #
        dict set myTubeDict  Tube \
                    [list \
                        length          $lengthTube \
                        profile_round   [list [list 0 $radius01  $length01 $radius02  $length02 $radius02]] \
                        centerLine      {} \
                    ]
            #
            # -- MiterOrigin --
            #
        dict set myTubeDict  MiterOrigin \
                    [list \
                        toolType        plane \
                        toolAngle       90 \
                        toolRotation    0 \
                        tubePrecision   1 \
                    ]
            #
            # -- MiterEnd --
            #
        dict set myTubeDict  MiterEnd \
                [list \
                    toolType        cylinder \
                    toolAngle       $Scalar(MiterAngle_End) \
                    toolRotation    180 \
                    toolProfile     [list [list 0 $radius_Miter]] \
                    toolOffset \
                        [list \
                            x       $offsetST \
                        ] \
                    tubePrecision   45 \
                ]
            #
            # appUtil::pdict $myTubeDict    
            #
        $myTube setDictionary       $myTubeDict    
        $myTube update    
            #            
            # -- Shape
            #
        set miter_Origin            [$myTube getMiterOrigin]    
        set miter_End               [$myTube getMiterEnd]    
            #
            #
        set miter                   [$miter_Origin     getMiter Origin]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(Origin)           [lappend miter  $x_End -70 $x_Origin -70]
            #   
        set miter                   [$miter_End        getMiter End opposite]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(End)              [lappend miter  $x_End  70 $x_Origin  70]
            #
            #
        set Shape(xz)               [my getShapeNew ZY] ;# xz
        set Shape(xy)               [my getShapeNew ZX] ;# xy
            #
            #
        set Position(_EdgeEndRight)         [my _getEdgePosition EdgeEndRight]
        set Position(_EdgeTaperStartRight)  [my _getEdgePosition RefOriginRight]
        set Position(_EdgeTaperEndRight)    [my _getEdgePosition RefEndRight]
        set Position(_EdgeOriginRight)      [my _getEdgePosition EdgeOriginRight]
        set Position(_EdgeEndLeft)          [my _getEdgePosition EdgeEndLeft]
        set Position(_EdgeTaperStartLeft)   [my _getEdgePosition RefOriginLeft]
        set Position(_EdgeTaperEndLeft)     [my _getEdgePosition RefEndLeft]
        set Position(_EdgeOriginLeft)       [my _getEdgePosition EdgeOriginLeft]
            #
        set Profile(xy)             [$myTube getProfile ZX]
        set Profile(xz)             [$myTube getProfile ZY]
            #
            # parray Profile    
            #
        return
            #
    }
        #
        #
    method setChainStay {object} {
        variable tube_ChainStay
        set tube_ChainStay $object
    }
        #            
    method setSeatTube {object} {
        variable tube_SeatTube
        set tube_SeatTube $object
    }
        #            
    method setTopTube {object} {
        variable tube_TopTube
        set tube_TopTube $object
    }
        #            
    method setRearDropout {object} {
        variable lug_RearDropout
        set lug_RearDropout $object
    }
        #
        #
    method getMiterDict {} {
            #
            # --- original from: bikeModel::get_resultTubeMiterDictionary (3.4.04.xx)
            #
        variable tube_SeatTube
            #
        variable miter_End
            #
        variable Config
        variable Miter
            #
            #
        set myDict [dict create]             
            #
            #
            # --- SeatStay - 01 --------------
            #
        set key             SeatStay_01
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_SeatTube     getDirection    Config      degree]
        set angleMiter      [$miter_End         getScalar       AngleTool]
            #
        set offsetMiter     [$miter_End         getScalar       OffsetCenterLine]
            #
        set diameterTube    [$miter_End         getScalar       DiameterTube]                       
        set perimeterTube   [expr {$diameterTube * $vectormath::CONST_PI}]
        set diameterTool    [$miter_End         getScalar       DiameterTool]             
            #
        set miterTube       [join $Miter(End)   " "]
            #
        dict set myDict     $key    miterAngle      [format "%.3f" $angleMiter]               
        dict set myDict     $key    polygon_01      [list $miterTube]
            #
        dict set myDict     $key    minorName       SeatStay
        dict set myDict     $key    minorDiameter   $diameterTube
        dict set myDict     $key    minorDirection  [format "%.3f" $angleTube]
        dict set myDict     $key    minorPerimeter  $perimeterTube
        dict set myDict     $key    majorName       SeatTube(Lug)
        dict set myDict     $key    majorDiameter   $diameterTool
        dict set myDict     $key    majorDirection  [format "%.3f" $angleTool]
        dict set myDict     $key    offset          $offsetMiter
        dict set myDict     $key    tubeType        cylinder
        dict set myDict     $key    toolType        cylinder
            #
            #
            # --- SeatStay - 02 --------------
            #
        set key             SeatStay_02
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_SeatTube     getDirection    Config      degree]
        set angleMiter      [$miter_End         getScalar       AngleTool]
            #
        set offsetMiter     [$miter_End         getScalar       OffsetCenterLine]
            #
        set diameterTube    [$miter_End         getScalar       DiameterTube]                       
        set perimeterTube   [expr {$diameterTube * $vectormath::CONST_PI}]
        set diameterTool    [$miter_End         getScalar       DiameterTool]             
            #
        set miterTube       [vectormath::mirrorCoordList    [join $Miter(End) " "] y]
            #
        dict set myDict     $key    miterAngle      [format "%.3f" $angleMiter]               
        dict set myDict     $key    polygon_01      [list $miterTube]
            #
        dict set myDict     $key    minorName       SeatStay
        dict set myDict     $key    minorDiameter   $diameterTube
        dict set myDict     $key    minorDirection  [format "%.3f" $angleTube]
        dict set myDict     $key    minorPerimeter  $perimeterTube
        dict set myDict     $key    majorName       SeatTube(Lug)
        dict set myDict     $key    majorDiameter   $diameterTool
        dict set myDict     $key    majorDirection  [format "%.3f" $angleTool]
        dict set myDict     $key    offset          $offsetMiter
        dict set myDict     $key    tubeType        cylinder
        dict set myDict     $key    toolType        cylinder
            #
            #
            # -- thats it
            #
        return $myDict
            #
    }
        #
        #
        #
    method _getEdgePosition {positionName} {
        set pos [my _getEdgePosition_New $positionName]
        return $pos
    }
        #
}

