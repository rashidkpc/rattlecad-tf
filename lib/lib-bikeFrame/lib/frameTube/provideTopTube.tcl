 ##+##########################################################################
 #
 # package: bikeFrame    ->    classProvideTopTube.tcl
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
 

oo::class create bikeFrame::ProvideTopTube {
        #
    superclass bikeFrame::AbstractProvidePart
        #
    #variable tube_HeadTube
    #variable tube_SeatTube
        #
    constructor {} {
            #
        puts "              -> class ProvideTopTube"
            #
        variable tube_HeadTube  [bikeFrame::ProvideHeadTube new]
        variable tube_SeatTube  [bikeFrame::ProvideSeatTube new]
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
        variable Scalar     ; array set Scalar {
                                    Angle          2.21
                                    DiameterHT    19.25
                                    DiameterST     9.75
                                    LengthTaper  300.00
                                    OffsetHT       8.21
                                }
        variable Direction  ; array set Direction {
                                    Config       {-1.00 0.00}
                                }
        variable Miter      ; array set Miter {
                                    Origin          {}
                                    End             {}
                                }
        variable Position   ;  array set Position {
                                    Origin          {0 0}
                                    End            {-1 0}
                                    SeatTubeTop     {0 0}      
                                }
        variable Profile    ; array set Profile {
                                    xy              {}
                                    xz              {}
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
        variable Scalar
        variable Direction
        variable Position
        variable Profile
        variable Scalar
            #
        variable tube_HeadTube
        variable tube_SeatTube
            #
        variable miter_Origin
        variable miter_End
            #
            #
        set Direction(Config)       [vectormath::dirCarthesian [expr  {180 + $Scalar(Angle)}]]
            #
        set diameter(HeadTube)      [$tube_HeadTube getDiameter_Top]
        set direction(HeadTube)     [$tube_HeadTube getDirection Config]
        set pos(HeadTube)           [$tube_HeadTube getPosition  End]
            #
        set pos(HeadTubeTopLeft)    [vectormath::perpendicular  $pos(HeadTube) [vectormath::addVector $pos(HeadTube) $direction(HeadTube)] [expr {0.5*$diameter(HeadTube)}] left]
            #          
        set Position(HeadTubeTop)   [vectormath::addVector      $pos(HeadTubeTopLeft) $direction(HeadTube) [expr {-1 * $Scalar(OffsetHT)}]]
            #            
        set pt_01                   $Position(HeadTubeTop)
        set pt_02                   [vectormath::addVector      $pt_01 [my getDirection Config]]
        set vct_cl                  [vectormath::parallel       $pt_01 $pt_02   [expr {0.5*$Scalar(DiameterHT)}] left]
            #
        set pos(SeatTube_1)         [$tube_SeatTube getPosition SeatPost]
        set pos(SeatTube_2)         [$tube_SeatTube getPosition EndVirtual]
        set pos(HeadTube_1)         [$tube_HeadTube getPosition Origin]
        set pos(HeadTube_2)         [$tube_HeadTube getPosition End]
        set Position(Origin)        [vectormath::intersectPoint [lindex $vct_cl 0] [lindex $vct_cl 1] $pos(HeadTube_1) $pos(HeadTube_2)]
        set Position(End)           [vectormath::intersectPoint [lindex $vct_cl 0] [lindex $vct_cl 1] $pos(SeatTube_1) $pos(SeatTube_2)]
            #
            #
        set Scalar(MiterAngle_Origin)   [vectormath::angle $pos(HeadTube_2) $Position(Origin) $Position(End)]
        set Scalar(MiterAngle_End)      [vectormath::angle $Position(Origin) $Position(End) $pos(SeatTube_1)]
            #
        set Scalar(Length)          [vectormath::length $Position(Origin) $Position(End)]
            #
            #
        set CenterLine(xz)          [join "$Position(Origin) $Position(End)" " "]
            #
            #
        # set Profile(xy)             [$providedObject getProfile xy]
        # set Profile(xz)             [$providedObject getProfile xz]
            #
            #
        return
            #
    }
        #
    method updateShape {} {
            #
        variable tube_SeatTube
        variable tube_HeadTube
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
            # -- customTube:  myTubeDict -> myTube
            #    
        set lengthTube              $Scalar(Length)
        set length01                100
        set length02                [expr {$lengthTube - 2 * $length01}]
        set radius01                [expr {0.5 * $Scalar(DiameterHT)}]
        set radius02                [expr {0.5 * $Scalar(DiameterST)}]
            #
            #
        set lengthOffsetTool        [vectormath::length [$tube_HeadTube getPosition Origin] $Position(Origin)]
            #
        set radiusST                [expr {0.5 * [$tube_SeatTube getScalar DiameterTT]}]
            #
            #
            # -- Description --
            #
        dict set myTubeDict  MetaData {
                    Name            TopTube
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
            #
            # -- MiterEnd --
            #
        dict set myTubeDict  MiterEnd \
                [list \
                    toolType        cylinder \
                    toolAngle       $Scalar(MiterAngle_End) \
                    toolRotation    0 \
                    toolProfile     [list [list 0 $radiusST]] \
                    toolOffset \
                        [list \
                            x       0 \
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
        set miter                   [$miter_End        getMiter End]
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
    method setPosition {keyName listXY} {
        return [my prototype_setPosition $keyName $value]
    }
        #
    method setScalar {keyName value} {
        variable Scalar
        switch -exact $keyName {
            Angle {
                    set Scalar($keyName)    $value
                    my prototype_setDirection Config    [vectormath::dirCarthesian [expr {180 - $value}]]
                }
            default {
                    my prototype_setScalar $keyName $value
                }
        }
            #
        return [my prototype_getScalar $keyName]
    }
        #
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
    method getOffsetHT {} {
        variable Scalar
        return $Scalar(OffsetBB)
    }      
        #
    method getPosition_SeatTube {} {
        variable Position
        return $Position(End)
    }      
        #
    method getPosition_SeatTubeTop {} {
        variable Position
        return $Position(SeatTubeTop)
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
            # --- TopTube - Origin -----------
            #
        set key             TopTube_Head
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_HeadTube     getDirection    Config      degree]
        set angleMiter      [$miter_Origin      getScalar       AngleTool]
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
        dict set myDict     $key    minorName       TopTube
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
            # --- TopTube - End --------------
            #
        set key             TopTube_Seat
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_SeatTube     getDirection    Config      degree]
        set angleMiter      [$miter_End         getScalar       AngleTool]
            #
        set diameterTube    [$miter_End         getScalar       DiameterTube]                       
        set perimeterTube   [expr {$diameterTube * $vectormath::CONST_PI}]
        set diameterTool    [$miter_End         getScalar       DiameterTool]             
        set perimeterTool   [expr {$diameterTool * $vectormath::CONST_PI}]        
            #
        dict set myDict     $key    miterAngle      [format "%.3f" $angleMiter]               
        dict set myDict     $key    polygon_01      [list [join $Miter(End) " "]]
            #
        dict set myDict     $key    minorName       TopTube
        dict set myDict     $key    minorDiameter   $diameterTube
        dict set myDict     $key    minorDirection  [format "%.3f" $angleTube]
        dict set myDict     $key    minorPerimeter  $perimeterTube
        dict set myDict     $key    majorName       SeatTube
        dict set myDict     $key    majorDiameter   $diameterTool
        dict set myDict     $key    majorDirection  [format "%.3f" $angleTool]
        dict set myDict     $key    offset          [format "%.3f" 0]
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
    method reportTube {} {
            #
        variable tube_HeadTube
        variable miter_Origin  
        variable miter_End     
            #
        puts ""
        puts " -- [info object class [self object]] -- reportTube -- [self object]"
        puts ""
        set pos_HeadTubeStart   [$tube_HeadTube getPosition Origin]    
        set pos_HeadTubeEnd     [$tube_HeadTube getPosition End]    
        set miterAngle_Start    [$miter_Origin  getScalar Angle]    
        set miterAngle_End      [$miter_End     getScalar Angle]    
            #
        puts "    \$pos_HeadTubeStart   $pos_HeadTubeStart"    
        puts "    \$pos_HeadTubeEnd     $pos_HeadTubeEnd "    
        puts "    \$miterAngle_Start    $miterAngle_Start / [expr {270 - $miterAngle_Start}]"     
        puts "    \$miterAngle_End      $miterAngle_End / [expr {270 - $miterAngle_End}]"    
            #
        puts "\n"
            #
            # $miter_Origin   reportValues    
            # $miter_End      reportValues
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

