 ##+##########################################################################
 #
 # package: bikeFrame    ->    classProvideDownTube.tcl
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
 

oo::class create bikeFrame::ProvideDownTube {
        #
    superclass bikeFrame::AbstractProvidePart
        #
        #
    constructor {} {
            #
        puts "              -> class ProvideDownTube"
            #
        variable lug_BottomBracket  [bikeFrame::ProvideBottomBracket    new]
        variable tube_HeadTube      [bikeFrame::ProvideHeadTube         new]
        variable tube_SeatTube      [bikeFrame::ProvideSeatTube         new]
            #
        variable myTube             [customTube::Tube new]
        variable myTubeDict         [dict create]
            #
        variable miter_BBracket     [bikeFrame::FacadeTubeMiter new cylinder]
        variable miter_SeatTube     [bikeFrame::FacadeTubeMiter new cylinder]
            #
        next
            #
        variable CenterLine ; array set CenterLine {
                                    xy              {}
                                    xz              {}
                                }
        variable Direction  ; array set Direction {
                                    Config         {-1.00  -1.00} 
                                }
        variable Miter      ; array set Miter {
                                    Origin          {}
                                    End             {} 
                                }
        variable Position   ; array set Position {
                                    Origin          {0.00   0.00} 
                                    End            {-1.00  -1.00} 
                                }
        variable Profile    ; array set Profile {
                                    xy              {}
                                    xz              {}
                                }
        variable Scalar     ; array set Scalar {
                                    DiameterBB      {}
                                    DiameterHT      {}
                                    LengthTaper     {}
                                    OffsetBB        0.21
                                    OffsetHT        7.21
                                }
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
    method updateGeometry {} {
            #
        variable CenterLine
        variable Config
        variable Direction
        variable Position
        variable Profile
        variable Scalar
            #
        variable lug_BottomBracket
        variable tube_HeadTube
        variable tube_SeatTube
            #
        variable miter_Origin
        variable miter_End
            #
            #
        set diameter(HeadTube)          [$tube_HeadTube getDiameter_Top]
        set direction(HeadTube)         [$tube_HeadTube getDirection Config]
        set pos(HeadTube)               [$tube_HeadTube getPosition_End]
            #
        set pos(HeadTubeTopLeft)        [vectormath::perpendicular  $pos(HeadTube) [vectormath::addVector $pos(HeadTube) $direction(HeadTube)] [expr {0.5*$diameter(HeadTube)}] left]
            #
        set Position(HeadTubeTop)       [vectormath::addVector      $pos(HeadTubeTopLeft) $direction(HeadTube) [expr {-1 * $Scalar(OffsetHT)}]]
            #
        set diameter(HeadTube)          [$tube_HeadTube getDiameter_Base]
        set direction(HeadTube)         [$tube_HeadTube getDirection Config]
        set pos(HeadTube)               [$tube_HeadTube getPosition Origin]
            #
        set pos(HeadTubeBottomLeft)     [vectormath::perpendicular $pos(HeadTube) [vectormath::addVector $pos(HeadTube) $direction(HeadTube)] [expr {0.5*$diameter(HeadTube)}] left]
        set Position(HeadTubeBottom)    [vectormath::addVector $pos(HeadTubeBottomLeft) $direction(HeadTube) $Scalar(OffsetHT)]
            #
        set pt_01                       $Position(HeadTubeBottom)
        set pt_02                       [vectormath::cathetusPoint     [$lug_BottomBracket getPosition Origin]  $pt_01 [expr {0.5 * $Scalar(DiameterHT) - $Scalar(OffsetBB)}]]    ;# DownTube lower Vector
        set vct_cl                      [vectormath::parallel          $pt_01 $pt_02 [expr {0.5 * $Scalar(DiameterHT)}] right]                        ;# DownTube centerline Vector
            #
        set Direction(Config)           [vectormath::unifyVector    [lindex $vct_cl 0] [lindex $vct_cl 1]]
            #
        set Position(Origin)            [vectormath::intersectPoint [lindex $vct_cl 0] [lindex $vct_cl 1]   [$tube_HeadTube getPosition Origin] [$tube_HeadTube getPosition End]]
        set Position(End)               [lindex $vct_cl 1] ;
            #
            # -- intersect with BottomBracket
            #             
        set Scalar(MiterAngle_Origin)   [vectormath::angle [$tube_HeadTube getPosition End] $Position(Origin) $Position(End)]
        set Scalar(MiterAngle_End)      [vectormath::angle  $Position(Origin) [$tube_SeatTube getPosition End] [$tube_SeatTube getPosition Origin]]
            #
        set Scalar(Length)              [vectormath::length $Position(Origin) $Position(End)]
            #
            #
        set CenterLine(xz)              [join "$Position(Origin) $Position(End)" " "]
            #
            #
        # set Profile(xy)                 [$providedObject getProfile xy]
        # set Profile(xz)                 [$providedObject getProfile xz]
            #
            #
        return
            #
    }
        #
    method updateShape {} {
            #
        variable lug_BottomBracket
        variable tube_HeadTube
        variable tube_SeatTube
            #
        variable myTube
        variable myTubeDict
            #
        variable miter_Origin
        variable miter_End
        variable miter_BBracket
        variable miter_SeatTube
            #
        variable Miter
        variable Position
        variable Profile
        variable Scalar
        variable Shape
            #
            #
            # -- customTube:  myTubeDict -> myTube
            #    
        set lengthTube              $Scalar(Length)
        set length01                100
        set length02                [expr {$lengthTube - 2 * $length01}]
        set radius01                [expr {0.5 * $Scalar(DiameterHT)}]
        set radius02                [expr {0.5 * $Scalar(DiameterBB)}]
            #
        set lengthOffsetTool        [vectormath::length [$tube_HeadTube getPosition Origin] $Position(Origin)]
            #
        set radiusBBInside          [expr {0.5 * [$lug_BottomBracket getScalar DiameterInside]}]
            #
        set angleMiterBB            90
        set rotationMiterBB        -90
        set offsetBB                [expr {-1 * $Scalar(OffsetBB)}]
            #
            # -- Description --
            #
        dict set myTubeDict  MetaData {
                    Name            DownTube
                }
            #
            # -- Tube --
            #
        dict set myTubeDict  Tube \
                    [list \
                        length          $lengthTube \
                        profile_round   [list [list 0 $radius01  $length01 $radius01  $length02 $radius02  $length01 $radius02]] \
                        centerLine      {} \
                    ]
            #
            # -- MiterOrigin --
            #
        set toolProfile [$tube_HeadTube getProfileTool]
            #
        switch -exact [$tube_HeadTube getConfig Type] {
            tapered {
                dict set myTubeDict  MiterOrigin \
                    [list \
                        toolType        frustum \
                        toolAngle       $Scalar(MiterAngle_Origin) \
                        toolRotation    0 \
                        toolProfile     [list $toolProfile] \
                        toolOffset \
                            [list \
                                x       0 \
                                y       $lengthOffsetTool \
                            ] \
                        tubePrecision   45 \
                    ]
            }
            cylindric -
            default {
                dict set myTubeDict  MiterOrigin \
                    [list \
                        toolType        cylinder \
                        toolAngle       $Scalar(MiterAngle_Origin) \
                        toolRotation    0 \
                        toolProfile     [list $toolProfile] \
                        toolOffset \
                            [list \
                                x       0 \
                            ] \
                        tubePrecision   45 \
                    ]
            }
        }
            #
            # -- MiterEnd --
            #
        dict set myTubeDict  MiterEnd \
                [list \
                    toolType        cylinder \
                    toolAngle       $angleMiterBB \
                    toolRotation    $rotationMiterBB \
                    toolProfile     [list [list 0 $radiusBBInside]] \
                    toolOffset \
                        [list \
                            x       $offsetBB \
                        ] \
                    tubePrecision   45 \
                ]
            #
            # appUtil::pdict $myTubeDict    
            #
        $myTube setDictionary   $myTubeDict    
        $myTube update    
            #
            #
        set miter_angleTool         90
        set miter_viewStartAngle   -90
        set miter_centerLineOffset  $Scalar(OffsetBB)
            #
            #
            # ---- BottomBracket outside
            #
        $miter_BBracket setConfig   Type                cylinderMiter
        $miter_BBracket setScalar   Angle               $miter_angleTool
        $miter_BBracket setScalar   DiameterTube        $Scalar(DiameterBB)
        $miter_BBracket setScalar   DiameterTool        [$lug_BottomBracket getScalar DiameterOutside]
        $miter_BBracket setScalar   OffsetCenterLine    $miter_centerLineOffset
        $miter_BBracket setScalar   StartAngle          $miter_viewStartAngle
        $miter_BBracket setConfig   View                origin
            #
        $miter_BBracket updateMiter
            #
            #
            # ---- SeatTube
            #
        $miter_SeatTube setConfig   Type                cylinderMiter
        $miter_SeatTube setScalar   Angle               $Scalar(MiterAngle_End)
        $miter_SeatTube setScalar   DiameterTube        $Scalar(DiameterBB)
        $miter_SeatTube setScalar   DiameterTool        [$tube_SeatTube     getScalar DiameterBB]
        $miter_SeatTube setScalar   OffsetCenterLine    0
        $miter_SeatTube setScalar   StartAngle          0
        $miter_BBracket setConfig   View                opposite
            #
        $miter_SeatTube updateMiter
            #
            #
            # -- update SeatTubeIntersection
            #
        catch {my update_SeatTubeIntersection}
            #
            #
            # -- get Miter
            #
        set miter_Origin            [$myTube getMiterOrigin]    
        set miter_End               [$myTube getMiterEnd]    
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
        set Miter(BBInside)         $Miter(End)
            #   
        set miter                   [$miter_BBracket   getMiterNew End]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(BBOutside)        [lappend miter  $x_End  70 $x_Origin  70]
            #   
        set lng(SeatTube_1)         [vectormath::length $Position(Origin) [$tube_SeatTube   getPosition End]]
        set offset_SeatTube         [expr {-1.0 * ($Scalar(Length) - $lng(SeatTube_1))}]
        set miter                   [$miter_SeatTube   getMiter End]
        set miter                   [vectormath::addVectorCoordList [list 0 $offset_SeatTube] $miter]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(SeatTube)         [lappend miter  $x_End  70 $x_Origin  70]
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
    method update_SeatTubeIntersection {} {
            #
        variable tube_SeatTube
            #
        variable Position
            #
            #puts " -> update_SeatTubeIntersection"
            #
        set pos(SeatTube_1) [$tube_SeatTube getPosition _EdgeTaperEndLeft]
        set pos(SeatTube_2) [$tube_SeatTube getPosition _EdgeEndLeft]
            #
        set pos(DownTube_1) $Position(_EdgeTaperEndRight)
        set pos(DownTube_2) $Position(_EdgeEndRight)
            #
        set Position(_EdgeSeatTubeIS)   [vectormath::intersectPoint     $pos(SeatTube_1)    $pos(SeatTube_2)    $pos(DownTube_1)    $pos(DownTube_2)]
            #
            # my reportValues
            #
        return
            #
    }
        #
        #
    method setBottomBracket {object} {
        variable lug_BottomBracket
        set lug_BottomBracket $object
    }
        #
    method setHeadTube {object} {
        variable tube_HeadTube
        set tube_HeadTube $object
    }
        #
    method setSeatTube {object} {
        variable tube_SeatTube
        set tube_SeatTube $object
    }
        #
        #
    method getMiterDict {} {
            #
            # --- original from: bikeModel::get_resultTubeMiterDictionary (3.4.04.xx)
            #
        variable tube_HeadTube
        variable tube_SeatTube
            #
        variable miter_Origin  
        variable miter_End     
        variable miter_BBracket
        variable miter_SeatTube
            #
        variable Config
        variable Miter
            #
            #
        set myDict [dict create]
            #
            #
            # --- DownTube - Origin ----------
            #
        set key             DownTube_Head
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_HeadTube     getDirection    Config      degree]
        set angleMiter      [$miter_Origin      getScalar       AngleTool]
            # set angleMiter      [$miter_Origin      getScalar       Angle]
            #
        set diameterTube    [$miter_Origin      getScalar       DiameterTube]                       
        set perimeterTube   [expr {$diameterTube * $vectormath::CONST_PI}]
        set diameterTool    [$miter_Origin      getScalar       DiameterTool]             
        set perimeterTool   [expr {$diameterTool * $vectormath::CONST_PI}]        
        set typeTool        [$tube_HeadTube     getConfig       Type]
            #
        dict set myDict     $key    miterAngle      [format "%.3f" $angleMiter]               
        dict set myDict     $key    polygon_01      [list [join $Miter(Origin) " "]]
            #   
        dict set myDict     $key    minorName       DownTube
        dict set myDict     $key    minorDiameter   $diameterTube
        dict set myDict     $key    minorDirection  [format "%.3f" $angleTube]
        dict set myDict     $key    minorPerimeter  $perimeterTube
        dict set myDict     $key    majorName       HeadTube
        dict set myDict     $key    majorDiameter   $diameterTool 
        dict set myDict     $key    majorDirection  [format "%.3f" $angleTool]
        dict set myDict     $key    offset          [format "%.3f" 0]
        dict set myDict     $key    tubeType        cylinder
            #
        if {$typeTool == {cylindric}} { 
            dict set myDict $key    toolType        cylinder
        } else {    
            dict set myDict $key    toolType        cone
            dict set myDict $key    baseDiameter    [$tube_HeadTube getScalar   DiameterTaperedBase]
            dict set myDict $key    topDiameter     [$tube_HeadTube getScalar   DiameterTaperedTop]   
            dict set myDict $key    baseHeight      [$tube_HeadTube getScalar   HeightTaperedBase]   
            dict set myDict $key    frustumHeight   [$tube_HeadTube getScalar   LengthTaper]     
            dict set myDict $key    sectionPoint    [$miter_Origin  getScalar   OffsetToolBase]
        }                
            #
            #
            # --- DownTube - End -------------
            #
        set key             DownTube_Seat
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_SeatTube     getDirection    Config      degree]
        set angleMiter      [$miter_SeatTube    getScalar       Angle]
            #
        set diameterTube    [$miter_SeatTube    getScalar       DiameterTube]                       
        set perimeterTube   [expr {$diameterTube * $vectormath::CONST_PI}]
        set diameterTool    [$miter_SeatTube    getScalar       DiameterTool]             
            #
        dict set myDict     $key    miterAngle      [format "%.3f" $angleMiter]               
        dict set myDict     $key    polygon_01      [list [join $Miter(SeatTube) " "]]
        dict set myDict     $key    polygon_02      [list [lrange [join $Miter(BBInside)  " "] 0 end-4]]
        dict set myDict     $key    polygon_03      [list [lrange [join $Miter(BBOutside) " "] 0 end-4]]
            #
        dict set myDict     $key    minorName       DownTube
        dict set myDict     $key    minorDiameter   $diameterTube
        dict set myDict     $key    minorDirection  [format "%.3f" $angleTube]
        dict set myDict     $key    minorPerimeter  $perimeterTube
        dict set myDict     $key    majorName       SeatTube
        dict set myDict     $key    majorDiameter   $diameterTool
        dict set myDict     $key    majorDirection  [format "%.3f" $angleTool]
        dict set myDict     $key    offset          [format "%.3f" 0]
        dict set myDict     $key    diameter_02     [$miter_End         getScalar   DiameterTool]   ;#$::bikeGeometry::BottomBracket(InsideDiameter)   
        dict set myDict     $key    diameter_03     [$miter_BBracket    getScalar   DiameterTool]   ;#$::bikeGeometry::BottomBracket(OutsideDiameter)   
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

