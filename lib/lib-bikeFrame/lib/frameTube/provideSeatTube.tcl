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
 

oo::class create bikeFrame::ProvideSeatTube {
        #
    superclass bikeFrame::AbstractProvidePart
        #
    variable tube_TopTube            
    variable tube_DownTube            
    variable lug_BottomBracket            
        #
    constructor {} {
            #
        puts "              -> class ProvideSeatTube"
            #
        variable tube_TopTube       ;#[bikeFrame::ProvideTopTube          new]
        variable tube_DownTube      ;#[bikeFrame::ProvideDownTube         new]
            #
        variable lug_BottomBracket  [bikeFrame::ProvideBottomBracket    new]
            #
        variable myTube             [customTube::Tube new]
        variable myTubeDict         [dict create]
            #
        variable miter_BB_Inside    [bikeFrame::FacadeTubeMiter new cylinder]
        variable miter_BB_Outside   [bikeFrame::FacadeTubeMiter new cylinder]
            #
        next
            #
        variable CenterLine ; array set CenterLine {
                                    xy              {}
                                    xz              {}
                                }
        variable Direction  ; array set Direction {
                                    Config          {0.00 -1.00}
                                }
        variable Miter      ; array set Miter {
                                    Origin          {}
                                    End             {}
                                }
        variable Position   ; array set Position {
                                    End             { 0.00 0.00} 
                                    EndVirtual      {-1.00 1.00}
                                    SeatPost        {-2.00 2.00}
                                }
        variable Profile    ; array set Profile {
                                    xy              {}
                                    xz              {}
                                }
        variable Scalar     ; array set Scalar {
                                    DiameterBB          {}
                                    DiameterTT          {}
                                    OffsetBB           0.21
                                    LengthExtension   51.21
                                    LengthTaper         {} 
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
            # method is called by ... my initValues -> next
            #
        variable CenterLine
        variable Scalar
        variable Direction
        variable Position
        variable Profile
        variable Scalar
            #
        variable tube_TopTube
        variable tube_DownTube     
            #
            #
        set pos_BottomBracket       [$lug_BottomBracket getPosition Origin]
        set Position(EndVirtual)    [vectormath::cathetusPoint $Position(SeatPost) $pos_BottomBracket [expr {-1.0 * $Scalar(OffsetBB)}] opposite]
        set Direction(Config)       [vectormath::unifyVector   $Position(SeatPost) $Position(EndVirtual)]
            #
        my updateTopTubeJoint       ;# get Positon(Origin)
        my updateDownTubeJoint      ;# get Positon(End)
            #
            #
        set pos(DownTube_1)         [$tube_DownTube getPosition Origin]
        set Scalar(MiterAngle_End)  [vectormath::angle  $pos(DownTube_1) $Position(End) $Position(Origin)]
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
    method updateTopTubeJoint {} {
            #
        variable Scalar
            #
        variable Direction
        variable Position
            #
        variable tube_TopTube
        variable comp_Saddle
        variable comp_SeatPost
            #
        if {[info exists tube_TopTube]} {
                #
                # puts "   \$tube_TopTube  $tube_TopTube"
            $tube_TopTube  updateGeometry   
            $tube_DownTube updateGeometry   
                #
            set pos(TopTube_1)      [$tube_TopTube getPosition Origin]
            set pos(TopTube_2)      [$tube_TopTube getPosition End]
            set radius(TopTube)     [expr {0.5*[$tube_TopTube getScalar DiameterST]}]
        } else {
            puts "   \$tube_TopTube  ... currently not exist"
            set pos(TopTube_1)      { 399.50              529.70}
            set pos(TopTube_2)      {-149.80              515.70}
            set radius(TopTube)     13.5
        }
            #
        set pos(SeatTube_1)         [my getPosition SeatPost]
        set pos(SeatTube_2)         [my getPosition EndVirtual]
            #
        set radius(SeatTube)        [expr {0.5*$Scalar(DiameterTT)}]
        set radius(TopTube)         $radius(TopTube)
            #
        set vector(SeatTube)        [vectormath::parallel $pos(SeatTube_1) $pos(SeatTube_2) $radius(SeatTube) left]
        set vector(TopTube)         [vectormath::parallel $pos(TopTube_1)  $pos(TopTube_2)  $radius(TopTube)]
            #
        set pos(JointEdge)          [vectormath::intersectPoint [lindex $vector(SeatTube) 0] [lindex $vector(SeatTube) 1] [lindex $vector(TopTube) 0] [lindex $vector(TopTube) 1]]
        set pos(ExtEdge)            [vectormath::addVector      $pos(JointEdge) [my getDirection Config] [expr {-1.0 * $Scalar(LengthExtension)}]] 
        set pos(End)                [vectormath::perpendicular  $pos(ExtEdge) $pos(JointEdge) $radius(SeatTube)] 
            #
            # puts "  SeatTube -- updateTopTubeJoint -> my getDirection     [my getDirection]"
            # puts "  SeatTube -- updateTopTubeJoint -> \$pos(TopTube_1)          $pos(TopTube_1)"
            # puts "  SeatTube -- updateTopTubeJoint -> \$pos(TopTube_2)          $pos(TopTube_2)"
            # puts "  SeatTube -- updateTopTubeJoint -> \$pos(SeatTube_1)         $pos(SeatTube_1)"
            # puts "  SeatTube -- updateTopTubeJoint -> \$pos(SeatTube_2)         $pos(SeatTube_2)"
            # puts "  SeatTube -- updateTopTubeJoint -> \$pos(JointEdge)   ---    $pos(JointEdge)"
            # puts "  SeatTube -- updateTopTubeJoint -> \$pos(ExtEdge)            $pos(ExtEdge)"
            # puts "  SeatTube -- updateTopTubeJoint -> my getPosition      [my getPosition]"
            # puts "  SeatTube -- updateTopTubeJoint   -> \$Position(Origin)    $Position(Origin)"
            #
        set Position(Origin)      $pos(End)
            #
            # puts "  SeatTube -- updateTopTubeJoint -> my getPosition      [my getPosition]"
            # puts "  SeatTube -- updateTopTubeJoint   -> \$Position(Origin)    $Position(Origin)"
            #
        set Position(TopFront)    $pos(ExtEdge)
        set Position(TopTubeTop)  $pos(JointEdge)
            #
        return
            #
    }
        #
    method updateDownTubeJoint {} {
            #
        variable Scalar
            #
        variable Position
            #
        variable tube_DownTube
        variable lug_BottomBracket
            #
            # puts "  -- updateDownTubeJoint"    
            #
        if {[info exists tube_DownTube]} {
            # puts "   \$tube_DownTube $tube_DownTube"
            set pos(DownTube)   [$tube_DownTube getPosition Origin]
            set dir(DownTube)   [$tube_DownTube getDirection Config cartesian]
        } else {
            puts "   \$tube_DownTube ... currently not exist"
            #set pos(DownTube)   {419.50        399.80}
            #set dir(DownTube)   {  0.707106781   0.707106781}
            set Position(End)   [vectormath::addVector $Position(Origin) [my getDirection Config] 600]
            return
        }
            #
        set pos(DownTube_1)     [$tube_DownTube getPosition Origin]
        set pos(DownTube_2)     [$tube_DownTube getPosition End]
        set pos(SeatTube_1)     [my getPosition SeatPost]
        set pos(SeatTube_2)     [my getPosition EndVirtual]
            #
        set Position(End)       [vectormath::intersectPoint $pos(DownTube_1) $pos(DownTube_2) $pos(SeatTube_1) $pos(SeatTube_2)]
            #
            #
            #
            # puts "  SeatTube -- updateDownTubeJoint -> my getDirection     [my getDirection]"
            # puts "  SeatTube -- updateDownTubeJoint -> \$pos(DownTube_1)         $pos(DownTube_1)"
            # puts "  SeatTube -- updateDownTubeJoint -> \$pos(DownTube_2)         $pos(DownTube_2)"
            # puts "  SeatTube -- updateDownTubeJoint -> \$pos(SeatTube_1)         $pos(SeatTube_1)"
            # puts "  SeatTube -- updateDownTubeJoint -> \$pos(SeatTube_2)         $pos(SeatTube_2)"
            #
    }
        #
    method updateShape {} {
            #
        variable lug_BottomBracket
        variable tube_DownTube
            #
        variable myTube
        variable myTubeDict
            #
        variable miter_Origin
        variable miter_End
        variable miter_BB_Inside
        variable miter_BB_Outside
            #
        variable Miter
        variable Position
        variable Profile
        variable Scalar
        variable Shape
            #
        if {[info exists tube_DownTube]} {
            # puts "   \$tube_DownTube $tube_DownTube"
        } else {
            puts "   \$tube_DownTube ... currently not exist"
            return
        }
            #
        set lengthTube              $Scalar(Length)
        set length01                100
        set length02                [expr {$lengthTube - 2 * $length01}]
        set radius01                [expr {0.5 * $Scalar(DiameterTT)}]
        set radius02                [expr {0.5 * $Scalar(DiameterBB)}]
            #
        set radiusDT                [expr {0.5 * [$tube_DownTube getScalar DiameterBB]}]
        set radiusBBInside          [expr {0.5 * [$lug_BottomBracket getScalar DiameterInside]}]
            #
        set angleMiterBB            90
        set rotationMiterBB        -90
        set offsetBB                [expr {-1 * $Scalar(OffsetBB)}]
            #
            # -- Description --
            #
        dict set myTubeDict  MetaData {
                    Name            SeatTube
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
            # puts "   -> \$Scalar(MiterAngle_End) $Scalar(MiterAngle_End)"    
            #
        dict set myTubeDict  MiterEnd \
                [list \
                    toolType        cylinder \
                    toolAngle       [expr {180 - $Scalar(MiterAngle_End)}] \
                    toolRotation    0 \
                    toolProfile     [list [list 0 $radiusDT]] \
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
            # ---- BottomBracket inside
            #
        set miter_angleTool          90
        set miter_viewStartAngle     90
            #
        $miter_BB_Inside    setConfig   Type                cylinderMiter
        $miter_BB_Inside    setConfig   View                opposite
        $miter_BB_Inside    setScalar   Angle               $miter_angleTool
        $miter_BB_Inside    setScalar   DiameterTube        $Scalar(DiameterBB)
        $miter_BB_Inside    setScalar   DiameterTool        [$lug_BottomBracket getScalar DiameterInside]
        $miter_BB_Inside    setScalar   OffsetCenterLine    $Scalar(OffsetBB)
        $miter_BB_Inside    setScalar   StartAngle          $miter_viewStartAngle
            #
        $miter_BB_Inside    updateMiter
            #
            #
            # ---- BottomBracket outside
            #
        $miter_BB_Outside   setConfig   Type                cylinderMiter
        $miter_BB_Outside   setConfig   View                opposite
        $miter_BB_Outside   setScalar   Angle               $miter_angleTool
        $miter_BB_Outside   setScalar   DiameterTube        $Scalar(DiameterBB)
        $miter_BB_Outside   setScalar   DiameterTool        [$lug_BottomBracket getScalar DiameterOutside]
        $miter_BB_Outside   setScalar   OffsetCenterLine    $Scalar(OffsetBB)
        $miter_BB_Outside   setScalar   StartAngle          $miter_viewStartAngle
            #
        $miter_BB_Outside   updateMiter
            #
            #
            # -- Shape
            #
        set miter_Origin            [$myTube getMiterOrigin]    
        set miter_End               [$myTube getMiterEnd]    
            #
            #
        set miter                   [$miter_Origin      getMiter Origin]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(Origin)           [lappend miter  $x_End -70 $x_Origin -70]
            #   
        set miter                   [$miter_End         getMiter End opposite]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(End)              [lappend miter  $x_End  70 $x_Origin  70]
        set Miter(DownTube)         $Miter(End)
            #
        set miter                   [$miter_BB_Inside   getMiterNew End]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(BBInside)         [lappend miter  $x_End  70 $x_Origin  70]
            #
        set miter                   [$miter_BB_Outside  getMiterNew End]
        set x_Origin                [lindex $miter 0]
        set x_End                   [lindex $miter end-1]
        set Miter(BBOutside)        [lappend miter  $x_End  70 $x_Origin  70]
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
    method setDirection {keyName listXY} {
        variable Direction
        variable Scalar
        if {$keyName == {Config}} {
            set Direction(Config) $listXY
            set Scalar(Angle)     [expr {180 - [my getDirection Config degree]}]   ;# Configuration Value, starting 9 o'clock, clock direction
        }            
            #
        return  [my getDirection $keyName degree]
    }
        #
        #
    method setTopTube {object} {
        variable tube_TopTube
        # catch {$tube_TopTube destroy}
        set tube_TopTube $object
    }
        #
    method setDownTube {object} {
        variable tube_DownTube
        # catch {$tube_DownTube destroy}
        set tube_DownTube $object
    }
        #
    method setBottomBracket {object} {
        variable lug_BottomBracket
        # $lug_BottomBracket destroy
        set lug_BottomBracket $object
    }
        #
        #
    method getAngle_Result {} {
        variable Scalar
        return $Scalar(Angle)
    }
        #
        #
    method getMiterDict {} {
            #
            # --- original from: bikeModel::get_resultTubeMiterDictionary (3.4.04.xx)
            #
        variable tube_DownTube
            #
        variable miter_Origin
        variable miter_End
        variable miter_BB_Inside
        variable miter_BB_Outside
            #
        variable Config
        variable Miter
            #
            #
        set myDict [dict create]             
            #
            #
            # --- SeatTube - End -------------
            #
        set key             SeatTube_Down
            #
        set angleTube       [my                 getDirection    Config      degree]
        set angleTool       [$tube_DownTube     getDirection    Config      degree]
        set angleMiter      [$miter_End         getScalar       AngleTool]
            #
        set diameterTube    [$miter_End         getScalar       DiameterTube]                       
        set perimeterTube   [expr {$diameterTube * $vectormath::CONST_PI}]
        set diameterTool    [$miter_End         getScalar       DiameterTool]             
            #
        dict set myDict     $key    miterAngle      [format "%.3f" $angleMiter]               
        dict set myDict     $key    polygon_01      [list [join $Miter(DownTube) " "]]
        dict set myDict     $key    polygon_02      [list [lrange [join $Miter(BBInside)  " "] 0 end-4]]
        dict set myDict     $key    polygon_03      [list [lrange [join $Miter(BBOutside) " "] 0 end-4]]
            #
        dict set myDict     $key    minorName       SeatTube
        dict set myDict     $key    minorDiameter   $diameterTube
        dict set myDict     $key    minorDirection  [format "%.3f" $angleTube]
        dict set myDict     $key    minorPerimeter  $perimeterTube
        dict set myDict     $key    majorName       DownTube
        dict set myDict     $key    majorDiameter   $diameterTool
        dict set myDict     $key    majorDirection  [format "%.3f" $angleTool]
        dict set myDict     $key    offset          [format "%.3f" 0]
        dict set myDict     $key    diameter_02     [$miter_BB_Inside   getScalar   DiameterTool]   ;#$::bikeGeometry::BottomBracket(InsideDiameter)   
        dict set myDict     $key    diameter_03     [$miter_BB_Outside  getScalar   DiameterTool]   ;#$::bikeGeometry::BottomBracket(OutsideDiameter)   
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