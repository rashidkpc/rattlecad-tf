 ##+##########################################################################
 #
 # package: bikeFrame    ->    classTestTube.tcl
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


oo::class create bikeFrame::StraightTube {
        #
    superclass bikeFrame::AbstractTube
        #
    constructor {} {
            #
        puts "              -> class StraightTube"
            #
        next                ;# call constructor of superclass AbstractTube
            #
        variable Scalar ; array set Scalar {
                                Length      450.21
                                LengthTaper 300.00
                                DiameterHT   32.21
                                DiameterST   28.21
                            }
        variable Shape  ; array set Shape {
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
    method update {} {
            #
        variable Scalar
        variable Position
        variable Profile
        variable Shape 
            #
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
        set endLength   [expr {0.5 * ($Scalar(Length) - $Scalar(LengthTaper))}]
        set Profile(xy) [list   0               [expr {0.5 * $Scalar(DiameterHT)}] \
                                $endLength      [expr {0.5 * $Scalar(DiameterHT)}] \
                                [expr {$endLength + $Scalar(LengthTaper)}] [expr {0.5 * $Scalar(DiameterST)}] \
                                $Scalar(Length) [expr {0.5 * $Scalar(DiameterST)}]]
        set Profile(xz) $Profile(xy)
            #
        return
            #   
    }
        #
    method update_Shape {} {
            #
        variable Scalar
            #
        variable tubeMiter_Start
        variable tubeMiter_End
            #
        puts "   -> update_Shape"
            #
        set diameter(p0)    $Scalar(DiameterHT)
        set diameter(p1)    $diameter(p0)
        set diameter(p2)    $Scalar(DiameterST)
        set diameter(p3)    $diameter(p2)
            #
        set length(p1)      [expr {0.5 * ($Scalar(Length) - $Scalar(LengthTaper))}]
        set length(p2)      $Scalar(LengthTaper)
        set length(p3)      $length(p1)
            #
        parray Scalar
            #
        puts "   -> \$tubeMiter_Start $tubeMiter_Start"    
        puts "   -> \$tubeMiter_End $tubeMiter_End"    
        puts "   -> \$diameter(p0) $diameter(p0)"    
        puts "   -> \$length(p1) $length(p1)"    
        puts "   -> \$diameter(p1) $diameter(p1)"    
        puts "   -> \$length(p2) $length(p2)"    
        puts "   -> \$diameter(p2) $diameter(p2)"    
        puts "   -> \$length(p3) $length(p3)"    
        puts "   -> \$diameter(p3) $diameter(p3)"    
            #
            #
        my _setShape5       $tubeMiter_Start \
                            $tubeMiter_End \
                            $diameter(p0) \
                            $length(p1) \
                            $diameter(p1) \
                            $length(p2) \
                            $diameter(p2) \
                            $length(p3) \
                            $diameter(p3) 
            #
        return
            #
    }
        #
        #
    method setScalar {keyName value} {
        variable Scalar
        switch -exact $keyName {
            Length      -
            LengthTaper -
            DiameterHT  -
            DiameterST {   
                    set Scalar($keyName) $value
                } 
            default {   
                    return
                }
        }
        return [my prototype_getScalar $keyName]
    }
        #
        #
    method _setShape6 {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable Profile
        variable Shape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        # $miterObjectBase            updateMiter    
        # $miterObjectEnd             updateMiter    
            #
            #
        set myMiterProfile(Base)    [$miterObjectBase   getProfile Origin]
        set myMiterProfile(End)     [$miterObjectEnd    getProfile Origin]
            # set myMiterProfile(Base)    [$miterObjectBase   getMiter XZ]
            # set myMiterProfile(End)     [$miterObjectEnd    getMiter XZ]
            #
            # puts "         -> \$myMiterProfile(Base)    $myMiterProfile(Base)"
            # puts "         -> \$myMiterProfile(End)     $myMiterProfile(End)"
            #
            #
        set pointList(Left)  {}    
        set pointList(Right) {}    
            #
        if {$args == {}} {
            lappend args $diameterBase
        }
            #
        set _radius                 [expr {0.5 * $diameterBase}]
        set _offset                 0
        set _posLeft                [list $_offset $_radius]
        set _posRight               [list $_offset [expr {-1.0 * $_radius}]]
        lappend pointList(Left)     $_posLeft    
        lappend pointList(Right)    $_posRight    
            #
        set _radius                 [expr {0.5 * $diameterFirst}]
        set _offset                 $lengthFirst
        set _posLeft                [list $_offset $_radius]
        set _posRight               [list $_offset [expr {-1.0 * $_radius}]]
        lappend pointList(Left)     $_posLeft    
        lappend pointList(Right)    $_posRight    
            #
        foreach {_length _diameter } $args {
            set _radius                 [expr {0.5 * $_diameter}]
            set _offset                 [expr {$_offset + $_length}]
            set _posLeft                [list $_offset   $_radius]
            set _posRight               [list $_offset   [expr {-1.0 * $_radius}]]
            lappend pointList(Left)     $_posLeft    
            lappend pointList(Right)    $_posRight    
        }
            #
            
            #
            # -- add tubeMiter
        set myMiterProfile(End)         [vectormath::mirrorPointList    $myMiterProfile(End) y]   
        set myMiterProfile(End)         [vectormath::addVectorPointList [list $_offset 0] $myMiterProfile(End)]   
            #
        set _pointList(Left)            $pointList(Left) 
        set _pointList(Right)           $pointList(Right)
            #

            #
            # --- Shape side View
        set Shape(xz) {}
            #
        set pos(originLeft)     [lindex $myMiterProfile(Base) end]
        set pos(endLeft)        [lindex $myMiterProfile(End)  end]
        set pos(endRight)       [lindex $myMiterProfile(End)  0]
        set pos(originRight)    [lindex $myMiterProfile(Base) 0]
            #
        foreach coord   $pos(originLeft) {
            append Shape(xz) "$coord "
        }
            # foreach coord   [lrange $_pointList(Left) 1 end-1] 
            # foreach coord   $_pointList(Left)
            # set pos(Origin_Right) [lrange $]   
            #
        foreach coord   [lrange $_pointList(Left) 1 end-1] {
            append Shape(xz) "$coord "
        }
            #
        foreach coord   [lreverse $myMiterProfile(End)] {
            append Shape(xz) "$coord "
        }
            # foreach coord   [lreverse [lrange $_pointList(Right) 1 end-1]]
            # foreach coord   [lreverse $_pointList(Right)]
        foreach coord   [lreverse [lrange $_pointList(Right) 1 end-1]] {
            append Shape(xz) "$coord "
        }
            # foreach coord   [lrange $myMiterProfile(Base) 0 end-1]
            # foreach coord   $myMiterProfile(Base)
        foreach coord   [lrange $myMiterProfile(Base) 0 end-1] {
            append Shape(xz) "$coord "
        }
        set Shape(xz) [string trim $Shape(xz)] 
            #
            # --- Shape top View
        set Shape(xy)     $Shape(xz)                

            #
            # puts " \$Shape(xz) $Shape(xz)"
            
            #
        set Position(_EdgeOriginLeft)         $pos(originLeft)
        set Position(_EdgeTaperStartLeft)     [lindex $_pointList(Left)     1]
        set Position(_EdgeTaperEndLeft)       [lindex $_pointList(Left)     end-1]
        set Position(_EdgeEndLeft)            $pos(endLeft)
        set Position(_EdgeEndRight)           $pos(endRight)
        set Position(_EdgeTaperEndRight)      [lindex $_pointList(Right)    end-1]
        set Position(_EdgeTaperStartRight)    [lindex $_pointList(Right)    1]
        set Position(_EdgeOriginRight)        $pos(originRight)
            #
            #
            # set Position(_EdgeOriginLeft)         [lindex $_pointList(Left)     0]
            # set Position(_EdgeEndLeft)            [lindex $_pointList(Left)     end]
            # set Position(_EdgeEndRight)           [lindex $_pointList(Right)    end]
            # set Position(_EdgeOriginRight)        [lindex $_pointList(Right)    0]
            #
        return    
            #
    }
        #
        
        
        
        
        
}