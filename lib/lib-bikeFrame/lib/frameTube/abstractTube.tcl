 ##+##########################################################################
 #
 # package: bikeFrame    ->    classAbstractTube.tcl
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


oo::class create bikeFrame::AbstractTube {
        #
    superclass bikeFrame::AbstractComponent
        #
        #
    constructor {} {
        if {![lindex [self call] 1]} {
            return -code error "class '[info object class [self]]' is abstract"
        }
            #
        #variable miter_Origin       [tubeMiter::createMiter cylinder]
        #variable miter_End          [tubeMiter::createMiter cylinder]
            #   
            
            #
        variable tubeMiter_Start    [bikeFrame::FacadeTubeMiter new cylinder]
        variable tubeMiter_End      [bikeFrame::FacadeTubeMiter new cylinder]
            #
        next                ;# call constructor of superclass AbstractComponent
            #
        puts "              -> superclass AbstractTube"
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
    method _setShape5 {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable Profile
        variable Shape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        $miterObjectBase            updateMiter    
        $miterObjectEnd             updateMiter    
            #
            #
        set myMiterProfile(Base)    [$miterObjectBase   getProfile Origin]
        set myMiterProfile(End)     [$miterObjectEnd    getProfile Origin]
            #
        set myMiterProfile(Base)    [vectormath::rotatePointList    {0 0} $myMiterProfile(Base)  270]
        set myMiterProfile(End)     [vectormath::rotatePointList    {0 0} $myMiterProfile(End)   270]
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
        foreach {_length _diameter} $args {
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
    method _setShape5_org3 {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable Profile
        variable Shape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        $miterObjectBase            updateMiter    
        $miterObjectEnd             updateMiter    
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
    method _setShape5_org2 {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable Profile
        variable Shape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        $miterObjectBase            updateMiter    
        $miterObjectEnd             updateMiter    
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
        set _posRight               [list $_offset [{expr -1.0 * $_radius}]]
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
    method _setShape5_org {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable Profile
        variable Shape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        $miterObjectBase            updateMiter    
        $miterObjectEnd             updateMiter    
            #
        set myMiterProfile(Base)    [$miterObjectBase   getMiter XZ]
        set myMiterProfile(End)     [$miterObjectEnd    getMiter XZ]
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
    method _setShape4 {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable myProfile
        variable myShape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        $miterObjectBase            updateMiter    
        $miterObjectEnd             updateMiter    
            #
        set myMiterProfile(Base)    [$miterObjectBase   getMiter XZ]
        set myMiterProfile(End)     [$miterObjectEnd    getMiter XZ]
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
        set myShape(xz) {}
            #
        foreach coord   [lindex $myMiterProfile(Base) end] {
            append myShape(xz) "$coord "
        }
            # foreach coord   [lrange $_pointList(Left) 1 end-1] 
            # foreach coord   $_pointList(Left)
        foreach coord   [lrange $_pointList(Left) 1 end-1] {
            append myShape(xz) "$coord "
        }
        foreach coord   [lreverse $myMiterProfile(End)] {
            append myShape(xz) "$coord "
        }
            # foreach coord   [lreverse [lrange $_pointList(Right) 1 end-1]]
            # foreach coord   [lreverse $_pointList(Right)]
        foreach coord   [lreverse [lrange $_pointList(Right) 1 end-1]] {
            append myShape(xz) "$coord "
        }
            # foreach coord   [lrange $myMiterProfile(Base) 0 end-1]
            # foreach coord   $myMiterProfile(Base)
        foreach coord   [lrange $myMiterProfile(Base) 0 end-1] {
            append myShape(xz) "$coord "
        }
        set myShape(xz) [string trim $myShape(xz)] 
            #
            # --- Shape top View
        set myShape(xy)     $myShape(xz)                

            #
            # puts " \$myShape(xz) $myShape(xz)"
            
            #
        set Position(_EdgeOriginLeft)         [lindex $_pointList(Left)     0]
        set Position(_EdgeTaperStartLeft)     [lindex $_pointList(Left)     1]
        set Position(_EdgeTaperEndLeft)       [lindex $_pointList(Left)     end-1]
        set Position(_EdgeEndLeft)            [lindex $_pointList(Left)     end]
        set Position(_EdgeOriginRight)        [lindex $_pointList(Right)    0]
        set Position(_EdgeTaperStartRight)    [lindex $_pointList(Right)    1]
        set Position(_EdgeTaperEndRight)      [lindex $_pointList(Right)    end-1]
        set Position(_EdgeEndRight)           [lindex $_pointList(Right)    end]
        
        return    
            
                # --- Profile side View
            set length(02)      [expr {$length(Start) + $length(Taper)}]
            set myProfile(xz)   [format "%s,%s %s,%s %s,%s %s,%s" \
                                    0           $radius(Start) \
                                    $length(01) $radius(Start) \
                                    $length(02) $radius(End)  \
                                    $length(03) $radius(End)  \
                                    ]
                # --- Profile top View
            set myProfile(xy)   $myProfile(xz)
            #
    }
        #
    method _setShape3_ {miterObjectBase miterObjectEnd diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable myProfile
        variable myShape
            #
        #puts "_setShape3 $diameterBase $lengthFirst - $args"    
            #
        $miterObjectBase            updateMiter    
        $miterObjectEnd             updateMiter    
            #
        set myMiterProfile(Base)    [$miterObjectBase   getMiter XZ]
        set myMiterProfile(End)     [$miterObjectEnd    getMiter XZ]
            #
        #puts "_setShape3 \$myMiterProfile(Base) $myMiterProfile(Base)"    
        #puts "_setShape3 \$myMiterProfile(Base)   [lindex $myMiterProfile(Base) 0]"    
        #puts "_setShape3 \$myMiterProfile(Base)   [lindex $myMiterProfile(Base) 1]"    
        #puts "_setShape3 \$myMiterProfile(End)  $myMiterProfile(End)"    
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
        #puts "_setShape3 \$pointList(Left)  $pointList(Left)"    
        #puts "_setShape3 \$pointList(Right) $pointList(Right)"    
            #
            
            #
            # -- add tubeMiter
        set myMiterProfile(End)         [vectormath::mirrorPointList    $myMiterProfile(End) y]   
        set myMiterProfile(End)         [vectormath::addVectorPointList [list $_offset 0] $myMiterProfile(End)]   
            #
        set _pointList(Left)            $pointList(Left) 
        set _pointList(Right)           $pointList(Right)
            #
        set _pointList(Left)            [lreplace $_pointList(Left)     0   0   [lindex $myMiterProfile(Base) 0]]
        set _pointList(Right)           [lreplace $_pointList(Right)    0   0   [lindex $myMiterProfile(Base) end]]
        set _pointList(Left)            [lreplace $_pointList(Left)     end end [lindex $myMiterProfile(End)  0]]
        set _pointList(Right)           [lreplace $_pointList(Right)    end end [lindex $myMiterProfile(End)  end]]
            #
            
            
            
            #set _pointList(Left)            [linsert $_pointList(Left) 0 [lindex $myMiterProfile(Base) 0]]    
            # set _pointList(Right)           [linsert $_pointList(Left) 0 [lindex $myMiterProfile(Base) 1]]    
            #lappend _pointList(Left)        [lindex $myMiterProfile(End) 1]    
            #lappend _pointList(Right)       [lindex $myMiterProfile(End) 0]    
            #
        #puts "_setShape3 \$_pointList(Left)  $_pointList(Left)"    
        #puts "_setShape3 \$_pointList(Right) $_pointList(Right)"    
            #
            # set pointList(Left)             $_pointList(Left)     
            # set pointList(Right)            $_pointList(Right)
            #
            # --- Shape side View
        set myShape(xz) {}
            #
        foreach coord   [lindex $myMiterProfile(Base) end] {
            #append myShape(xz) "$coord "
        }
        foreach coord   [lrange $_pointList(Left) 1 end-1] {
            append myShape(xz) "$coord "
        }
        foreach coord   [lreverse $myMiterProfile(End)] {
            append myShape(xz) "$coord "
        }
        foreach coord   [lreverse [lrange $_pointList(Right) 1 end-1]] {
            append myShape(xz) "$coord "
        }
        foreach coord   [lrange $myMiterProfile(Base) 0 end-1] {
            append myShape(xz) "$coord "
        }
        set myShape(xz) [string trim $myShape(xz)] 
            #
            # --- Shape top View
        set myShape(xy)     $myShape(xz)                

            #
            # puts " \$myShape(xz) $myShape(xz)"
            
            #
        set Position(_EdgeOriginLeft)         [lindex $_pointList(Left)     0]
        set Position(_EdgeTaperStartLeft)     [lindex $_pointList(Left)     1]
        set Position(_EdgeTaperEndLeft)       [lindex $_pointList(Left)     end-1]
        set Position(_EdgeEndLeft)            [lindex $_pointList(Left)     end]
        set Position(_EdgeOriginRight)        [lindex $_pointList(Right)    0]
        set Position(_EdgeTaperStartRight)    [lindex $_pointList(Right)    1]
        set Position(_EdgeTaperEndRight)      [lindex $_pointList(Right)    end-1]
        set Position(_EdgeEndRight)           [lindex $_pointList(Right)    end]
        
        return    
            
                # --- Profile side View
            set length(02)      [expr {$length(Start) + $length(Taper)}]
            set myProfile(xz)   [format "%s,%s %s,%s %s,%s %s,%s" \
                                    0           $radius(Start) \
                                    $length(01) $radius(Start) \
                                    $length(02) $radius(End)  \
                                    $length(03) $radius(End)  \
                                    ]
                # --- Profile top View
            set myProfile(xy)   $myProfile(xz)
            #
    }
        #
    method _setShape2_ {diameterBase lengthFirst diameterFirst args} {
            #
        variable Position
        variable myProfile
        variable myShape
            #
        #puts "_setShape2 $diameterBase $lengthFirst - $args"    
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
            # puts "_setShape2 \$pointList(Left) $pointList(Left)"    
            # puts "_setShape2 \$pointList(Right) $pointList(Right)"    
            
            #
            # --- Shape side View
        set myShape(xz) {}
            #
        foreach coord $pointList(Left) {
            append myShape(xz) "$coord "
        }
        foreach coord [lreverse $pointList(Right)] {
            append myShape(xz) "$coord "
        }
        set myShape(xz) [string trim $myShape(xz)] 
            #
            # --- Shape top View
        set myShape(xy)     $myShape(xz)                

            #
        set Position(_EdgeOriginLeft)         [lindex $pointList(Left)     0]
        set Position(_EdgeTaperStartLeft)     [lindex $pointList(Left)     1]
        set Position(_EdgeTaperEndLeft)       [lindex $pointList(Left)     end-1]
        set Position(_EdgeEndLeft)            [lindex $pointList(Left)     end]
        set Position(_EdgeOriginRight)        [lindex $pointList(Right)    0]
        set Position(_EdgeTaperStartRight)    [lindex $pointList(Right)    1]
        set Position(_EdgeTaperEndRight)      [lindex $pointList(Right)    end-1]
        set Position(_EdgeEndRight)           [lindex $pointList(Right)    end]
        
        return    
            
                # --- Profile side View
            set length(02)      [expr {$length(Start) + $length(Taper)}]
            set myProfile(xz)   [format "%s,%s %s,%s %s,%s %s,%s" \
                                    0           $radius(Start) \
                                    $length(01) $radius(Start) \
                                    $length(02) $radius(End)  \
                                    $length(03) $radius(End)  \
                                    ]
                # --- Profile top View
            set myProfile(xy)   $myProfile(xz)
            #
    }
        #
    method _setShapeSimple_ {diameterStart lengthFull {diameterEnd {}} {lengthStart {}} {lengthTaper {}}} {
            #
        variable myProfile
        variable myShape
            #
            #
        set radius(Start)   [expr {0.5 * $diameterStart}]
        set length(Total)   $lengthFull
            #
            #
            # puts "_setShapeSimple - [info object class [self object]] \n  $diameterStart \n  $lengthFull \n  $diameterEnd \n  $lengthStart \n  $lengthTaper "
            #
        if {$diameterEnd == {}} {
            # tk_messageBox -message "[info object class [self object]] \n    _setShapeSimple - ?  \n $diameterStart \n $lengthFull \n $diameterEnd \n $lengthStart \n $lengthTaper "
            # puts " -> except cylinder"
            set radius(End)     $radius(Start)
            set length(Taper)   [expr {$length(Total) / 3.0}] 
            set length(Start)   $length(Taper)
        } else {
            # puts " -> cone"
            set radius(End)     [expr {0.5 * $diameterEnd}]
            set length(Taper)   $lengthTaper
            set length(Start)   $lengthStart
                # set length(Start)   [expr 0.5 * ($length(Total) - $length(Taper))]
        }
            # puts "\$radius(End) $radius(End)"
            # puts "\$length(Start) $length(Start)"
            # puts "\$length(Taper) $length(Taper)"
            #
        set pos(Start)      {0 0}
        set pos(End)        [list $lengthFull 0]
            #
        set length(01)      $length(Start)
        set length(02)      [expr {$length(Start) + $length(Taper)}]
        set length(03)      $length(Total)
            #
        set pos_01      $pos(Start) 
        set pos_04      $pos(End) 
            #
        set pos_02      [vectormath::addVector  $pos_01 [vectormath::unifyVector $pos_01 $pos_04 $length(01)]]
        set pos_03      [vectormath::addVector  $pos_02 [vectormath::unifyVector $pos_01 $pos_04 $length(Taper)]]
            #
        set vct_01      [vectormath::parallel   $pos_01 $pos_02 $radius(Start) ]
        set vct_04      [vectormath::parallel   $pos_02 $pos_01 $radius(Start) ]
            #   
        set vct_02      [vectormath::parallel   $pos_03 $pos_04 $radius(End) ]
        set vct_03      [vectormath::parallel   $pos_04 $pos_03 $radius(End) ]
            #
        set Position(_EdgeOriginLeft)         [lindex $vct_04 1]
        set Position(_EdgeTaperStartLeft)     [lindex $vct_04 0]
        set Position(_EdgeTaperEndLeft)       [lindex $vct_03 1]
        set Position(_EdgeEndLeft)            [lindex $vct_03 0]
        set Position(_EdgeOriginRight)        [lindex $vct_01 0] 
        set Position(_EdgeTaperStartRight)    [lindex $vct_01 1] 
        set Position(_EdgeTaperEndRight)      [lindex $vct_02 0] 
        set Position(_EdgeEndRight)           [lindex $vct_02 1]
            #
            # --- Shape side View
        set myShape(xz)     [format "%s %s %s %s %s %s %s %s" \
                                [lindex $vct_01 0] [lindex $vct_01 1] \
                                [lindex $vct_02 0] [lindex $vct_02 1] \
                                [lindex $vct_03 0] [lindex $vct_03 1] \
                                [lindex $vct_04 0] [lindex $vct_04 1] \
                                ]
            # --- Shape top View
        set myShape(xy)     $myShape(xz)
            
            # --- Profile side View
        set length(02)      [expr {$length(Start) + $length(Taper)}]
        set myProfile(xz)   [format "%s,%s %s,%s %s,%s %s,%s" \
                                0           $radius(Start) \
                                $length(01) $radius(Start) \
                                $length(02) $radius(End)  \
                                $length(03) $radius(End)  \
                                ]
            # --- Profile top View
        set myProfile(xy)   $myProfile(xz)
            #
    }
        #
    method getTubeMiter_Start {} {
            #
        variable tubeMiter_Start
        return $tubeMiter_Start
            #
    }
        #
    method getTubeMiter_End {} {
        variable tubeMiter_End
        return $tubeMiter_End
            #
    }
        #
    method getCenterLine {keyName} {
        return [my prototype_getCenterLine $keyName]
    }
        #
    method getProfile {keyName} {
        return [my prototype_getProfile $keyName]
    }
        #
        #
    method __format_XcommaY {xyList} {
        return $xyList  ; #maybe later ... 
            #
        set commaList {}
        foreach {x y} $xyList { append commaList "$x,$y "}
        return $commaList
    }
        #
    method __flatten_nestedList {args} {
            if {[llength $args] == 0 } { return ""}
            set flatList {}
            foreach e [eval concat $args] {
                foreach ee $e { lappend flatList $ee }
            }
                # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
            return $flatList
    }
        #
    method __init_centerLine {centerLineDef} {
                #
            variable arcPrecission
            variable centerLineDirAngle;  array set centerLineDirAngle  {} 
            variable centerLineRadius;    array set centerLineRadius    {} 
            variable centerLineSegement;  array set centerLineAngle     {} 
            variable centerLineDefLength; array set centerLineDefLength {} 
            variable centerLinePosition;  array set centerLinePosition  {} 
            variable centerLineEnd
                # puts "  -> $arcPrecission"
            
                #
            # set centerLineDef [init_checkCenterLine $centerLineDef]
                #
          
                # --
                # puts "   ->[llength $centerLineDef] < 14"
            if {[llength $centerLineDef] < 14} {
                lassign $centerLineDef \
                        S01_length S02_length S03_length S04_length S05_length \
                        P01_angle  P02_angle  P03_angle  P04_angle \
                        S01_radius S02_radius S03_radius S04_radius
                  # foreach {S01_length S02_length S03_length S04_length S05_length \
                         P01_angle  P02_angle  P03_angle  P04_angle \
                         S01_radius S02_radius S03_radius S04_radius \
                        } $centerLineDef break
                        set cuttingLength_x [expr {$S01_length + $S02_length + $S03_length + $S04_length + $S05_length}]
            } else {
                lassign $centerLineDef \
                        S01_length S02_length S03_length S04_length S05_length \
                        P01_angle  P02_angle  P03_angle  P04_angle \
                        S01_radius S02_radius S03_radius S04_radius \
                        cuttingLength_x 
                  # foreach {S01_length S02_length S03_length S04_length S05_length \
                         P01_angle  P02_angle  P03_angle  P04_angle \
                         S01_radius S02_radius S03_radius S04_radius \
                         cuttingLength_x \
                        } $centerLineDef break
            }
                     
                  # puts "   <D> ---- \$centerLineDef ----------"
                  # puts $centerLineDef
                  # puts "   <D> --------------"

            set centerLineDefLength(1) $S01_length
            set centerLineDefLength(2) $S02_length
            set centerLineDefLength(3) $S03_length
            set centerLineDefLength(4) $S04_length
            set centerLineDefLength(5) $S05_length
            
            set centerLineAngle(0)     0
            set centerLineAngle(1)     $P01_angle
            set centerLineAngle(2)     $P02_angle
            set centerLineAngle(3)     $P03_angle
            set centerLineAngle(4)     $P04_angle
            set centerLineAngle(5)     0
            
            set centerLineDirection(0) 0
            set centerLineDirection(1) [expr {$centerLineDirection(0) + $P01_angle}]
            set centerLineDirection(2) [expr {$centerLineDirection(1) + $P02_angle}]
            set centerLineDirection(3) [expr {$centerLineDirection(2) + $P03_angle}]
            set centerLineDirection(4) [expr {$centerLineDirection(3) + $P04_angle}]
            set centerLineDirection(5) $centerLineDirection(4)
            
            set centerLineRadius(0)    0
            set centerLineRadius(1)    $S01_radius
            set centerLineRadius(2)    $S02_radius
            set centerLineRadius(3)    $S03_radius
            set centerLineRadius(4)    $S04_radius
            set centerLineRadius(5)    0
            
            set centerLineUncut        [list {0 0}]
            set ctrlPoints             {}
            
            
                #
                # puts " -> centerLineDefLength [array size centerLineDefLength]"
                #
            set i 0
            while {$i <= [array size centerLineDefLength]-1} {
                    # puts "\n"
                    # puts " == <$i> ==========================="
                set lastId $i
                set nextId [expr {$i+1}]
                set retValue    [my __init_centerLineNextPosition   \
                                                        $centerLineUncut $ctrlPoints\
                                                        $centerLineRadius($lastId)  $centerLineAngle($lastId)  $centerLineDirection($lastId) \
                                                        $centerLineDefLength($nextId) \
                                                        $centerLineRadius($nextId)  $centerLineAngle($nextId)  $centerLineDirection($nextId)]
                set centerLineUncut     [lindex $retValue 0]
                set ctrlPoints          [lindex $retValue 1] 
                    # puts "  -> $ctrlPoints"
                    #if {$i == 20} { exit }
                
                incr i
            }
                #
            set controlPoints [list {0 0}]
            set i 0
            foreach {start end} $ctrlPoints {
                lappend controlPoints $start $end
            }
                #
                # puts "  -> $cuttingLength_x"
            set retValue [my __cut_centerLine_inside $centerLineUncut $cuttingLength_x]
            set centerLineCut [lindex $retValue 0]
            set cuttingLength [lindex $retValue 1]
                # puts "  -> $centerLine"
                # puts "  -> $centerLineCut"
                #
            return [list $centerLineUncut $controlPoints $centerLineCut $cuttingLength]
                # return [list $centerLine $controlPoints]
                #
        }
        #
    method __init_centerLineNextPosition {polyLine ctrlPoints lastRadius lastAngle lastDir distance nextRadius nextAngle nextDir} {
          #
        variable arcPrecission
          #
        set lastPos     [lindex $polyLine end]
          #
          # puts "\n -- <D> ---------------------------"
          # puts "   -> \$lastPos    $lastPos"
          # puts "   -> \$lastRadius $lastRadius"
          # puts "   -> \$lastAngle  $lastAngle"
          # puts "   -> \$lastDir    $lastDir"
          # puts "   -> \$distance   $distance"
          # puts "   -> \$nextRadius $nextRadius"
          # puts "   -> \$nextAngle  $nextAngle"
          # puts "   -> \$nextDir    $nextDir"

          #
        set lastSegment [expr {abs($lastRadius * [vectormath::rad $lastAngle])}]
        set nextSegment [expr {abs($nextRadius * [vectormath::rad $nextAngle])}]
          #
        set lastArc     [expr {0.5 * $lastSegment}]  ;# length of previous arc
        set nextArc     [expr {0.5 * $nextSegment}]  ;# length of next arc
          #        
        
          # -- get sure to have a smooth shape
        set offset      [expr {$distance - ($lastArc + $nextArc)}]
        if {$offset < 0} {
            set offset 0.5
        }
          #
          
          # puts "      -> \$offset $offset"
        set arcStart    [vectormath::addVector $lastPos  [vectormath::rotateLine {0 0} ${offset}  ${lastDir}]]  
        set ctrlEnd     [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} ${nextArc} ${lastDir}]] 
          #
        lappend polyLine   $arcStart
          #
              # puts "    <1>  \$lastPos                              \$arcStart"
              # puts "    <1>  {69.45050226731068 -2.385231474777072} {179.76990416419986 -15.896650836506808}"
              # puts "    <1>   $lastPos  $arcStart"
              # puts "    <1>         \$offset  ${offset}"
              # puts "    <1>         \$lastDir ${lastDir}"
              # puts "    <1>     ---------------------------"
              # puts "    <D>       distance: $distance"
              # puts "    <D>        lastArc: $lastArc"
              # puts "    <D>        nextArc: $nextArc"
              # puts "    <D>       -----------------------"
              # puts "    <D>                 [expr $distance - $lastArc - $nextArc]"
              # puts "    <D>       length: \$lastPos  <-> \$arcStart  [vectormath::length $lastPos  $arcStart]"
              # puts "    <1>     ---------------------------\n"

          #
        if {$nextAngle == 0} {   
            lappend ctrlPoints $arcStart
            lappend ctrlPoints $arcStart
              #
            return [list $polyLine $ctrlPoints]
        } else {
            if {$nextAngle < 0} {
                set arcCenter [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} $nextRadius [expr {-1.0 * (90 - $lastDir)}]]]
            } else {  
                set arcCenter [vectormath::addVector $arcStart [vectormath::rotateLine {0 0} $nextRadius [expr {(90 + $lastDir)}]]]
            }
        }
        
          #
        set nrSegments  [expr {abs(round($nextSegment/$arcPrecission))}]
        if {$nrSegments < 1} {
              # puts "    -> nrSegments: $nrSegments"
            set nrSegments 1
        }
          #
        set deltaAngle  [expr {1.0*$nextAngle/$nrSegments}]
          # puts "  ->  Segments/Angle: $nrSegments $deltaAngle"
        set arcEnd  $arcStart
        set i 0
        while {$i < $nrSegments} {
              set arcEnd  [vectormath::rotatePoint $arcCenter $arcEnd $deltaAngle]
              lappend polyLine $arcEnd
                # puts "  -> i/p_End:  $i  $p_End"
                # set pStart $p_End
              incr i
        }
        set ctrlStart [vectormath::addVector $arcEnd  [vectormath::rotateLine {0 0} ${nextArc}  [expr {180 + ${nextDir}}]]] 
          #
        lappend ctrlPoints $ctrlEnd
        lappend ctrlPoints $ctrlStart
          #
        return [list $polyLine $ctrlPoints]
    }
        #
    method __cut_centerLine_inside {centerLine length_x} {
        set centerLineCut {}
          # puts "\n ------"
          # puts "   -> \$centerLine $centerLine"
          # puts "   -> \$length_x   $length_x"
          # puts " ------\n"
        set newLength     0
        set lastLength    0
        set lastXY       {0 0}
        set i 0
        foreach {xy} $centerLine {
            incr i
                # puts "     $i -> $xy"
            lassign $xy  x y
                # foreach {x y} $xy break
            set offset      [vectormath::length $lastXY $xy]
                # puts "               -> $offset  <- $lastXY"
            set newLength   [expr {$newLength + $offset}]
                #
            if {$x < $length_x} {
                set lastLength  $newLength
                set lastXY      $xy
                lappend centerLineCut $xy
                    # puts "   -> $x  <- $length_x"
            } else {
                    # puts "   -> $x  <- $length_x ... exception"
                lassign $lastXY  last_x last_y
                    # foreach {last_x last_y} $lastXY break
                set seg_x       [expr {$length_x - $last_x}]
                set segVct      [vectormath::unifyVector $lastXY $xy]
                set dx          [expr {$seg_x * [lindex $segVct 0]}]
                set dy          [expr {$seg_x * [lindex $segVct 1]}]
                set segEnd      [vectormath::addVector $lastXY [list $dx $dy]]
                
                #set deltaOffset  [expr $length - $lastLength]
                #set lastPosVct   [vectormath::unifyVector $lastXY $xy $deltaOffset]
                lappend centerLineCut $segEnd
                    #
                set cuttingLength [expr {$lastLength + [vectormath::length {0 0} [list $dx $dy]]}]
                    #
                    # puts "   -> [lindex $segEnd 0]  <- $length_x"
                    #
                return [list $centerLineCut $cuttingLength]
            }

        }
            #
            #
            #
            # ... in case of centerLine definition does not reach length_x
            #
            # puts "\n\n\n\n   <E> cut_centerLine exception \n\n\n\n "
            # puts "\n ------"
            # puts "   -> $x  ... did not reach $length_x"
            # puts "   ... \$length_x   $length_x"
            # puts "   ... \$lastLength $lastLength"
            # puts "   ... \$lastXY     $lastXY"
            #
        # just give it a try ( a copy from cut_centerLine) ... not analyzed    
            #
        set prevXY  [lindex $centerLineCut end-1]
            # puts "   ... \$prevXY     $prevXY"
        set delta_X [expr {$length_x - [lindex $lastXY 0]}]
            # puts "   ... \$delta_X     $delta_X"
            # puts "   ... [expr $length_x / $lastLength]"
        if {[expr {$length_x / $lastLength}] < 1.001} {
            return [list $centerLineCut $lastLength]
        }
            #
        set dirVct  [vectormath::unifyVector $prevXY $lastXY]
        set delta_L [expr {[lindex $dirVct 0] / $delta_X}]
            #
        set cuttingLength [expr {$lastLength + $delta_L}]
            #puts "   ... \$cuttingLength     $cuttingLength"
            #
        set vctExt  [vectormath::unifyVector $prevXY $lastXY $delta_L]
            #
        lappend centerLineCut [vectormath::addVector $lastXY $vctExt]
            #
            # puts "\n ------"
            #
        return [list $centerLineCut $cuttingLength]
            #
            # -- exception if length is longer than the profile
        # return  $centerLineCut
    }
        #
    method __init_tubeProfile {profileDef args} {

        variable unbentShape
        
        array unset _tubeProfileArray
        set tubeProfile [dict create]
        
        set x 0
        set y 0
        set k 0
        set i 0
        set profLength [llength $profileDef]
        while {$i < $profLength} {
            set xy [lindex $profileDef $i]
            lassign $xy  x0 y0
              # foreach {x0 y0} $xy break
            set x   [expr {$x + $x0}]
            set y0  [expr {0.5 * $y0}]
              #
            set j [expr {$i + 1}]
            if {$j < $profLength} {
                set xy [lindex $profileDef $j]
                    # puts "   profileDef ($j) -> $profileDef"
                    # puts "   xy -> $xy"
                lassign $xy  x1 y1
                    # foreach {x1 y1} $xy break
                    # puts "   ->    $x1    $y1"
                set y1  [expr {0.5 * $y1}]
                set k [expr {1.0 * ($y1 - $y0) / $x1}]
            } else {
                set x1 10
                set y1 $y0
                set k  0
            }
            set _tubeProfileArray($x) [list  $y0 $k]
            incr i
        }
        set _tubeProfileArray([expr {$x + 1}]) [list  $y0 0]
        
        foreach index [lsort -real [array names _tubeProfileArray]] {
            dict append tubeProfile $index $_tubeProfileArray($index)
            # lappend profileIndex $index
            # puts "   -> $index"
        }
       
        return $tubeProfile       
    }
        #
    method __create_tubeShape {centerLine tubeProfile side} {
      
        variable arcPrecission
        
        set linePosition 0
            # set bentProfile {}
          
        set lineOffset  [my __get_tubeProfileOffset $tubeProfile $linePosition]
        if {$side == {left}} {
            #lappend bentProfile [list $linePosition $lineOffset]
        } else {
            #lappend bentProfile [list $linePosition [expr -1.0 * $lineOffset]]
        }
            # puts "        ---> $bentProfile"
        set xPrev {}
        set yPrev {}
            #
        set p_last [lindex $centerLine end]
        set p_last_1    [lindex $centerLine end-1]
            # removed by 1.49
            # set vct_last    [vectormath::unifyVector $p_last_1 $p_last 0.5]
            # set p_apnd      [vectormath::addVector $p_last $vct_last]
            # lappend centerLine $p_apnd
            #
        set i 0
        while {$i < [llength $centerLine]-1} {
            set xy1 [lindex $centerLine $i]
            set xy2 [lindex $centerLine $i+1]         
            incr i
                #
            lassign $xy1  x1 y1 
            lassign $xy2  x2 y2 
                # foreach {x1 y1} $xy1 break 
                # foreach {x2 y2} $xy2 break 
                # puts "   $xy1"
                # puts "   $xy2"
                #
            set angle       [vectormath::dirAngle $xy1 $xy2]
            set segLength   [vectormath::length   $xy1 $xy2]
                #
            if {$side == {left}} {
                set offsetAngle [expr {$angle + 90}]
            } else {
                set offsetAngle [expr {$angle - 90}]
            }
                #
            set nrSegments  [expr {abs(round($segLength/$arcPrecission))}]
            if {$nrSegments < 1} {
                  # puts "    -> nrSegments: $nrSegments"
                set nrSegments 1
            }
            set segLength   [expr {$segLength/$nrSegments}]            
                #
            set p_Start    $xy1
            set lastOffset {}
            set j 0
            while {$j < $nrSegments} {
                set linePosition  [expr {$linePosition + $segLength}]
                set lineOffset    [my __get_tubeProfileOffset $tubeProfile $linePosition]
                set p_Offset      [vectormath::rotateLine $p_Start $lineOffset  $offsetAngle]
                set p_Next        [vectormath::rotateLine $p_Start $segLength   $angle]
                  # -- add to bentProfile
                if {$p_Offset != $lastOffset} {
                    lappend bentProfile $p_Offset
                }
                    # puts "        ---> [lindex $bentProfile end]"
                    # puts "         ->  + $segLength = $linePosition / $lineOffset  |  $offsetAngle"
                    # -- prepare next loop
                set p_Start    $p_Next
                set lastOffset $p_Offset
                incr j
            }             

        }
            #
            #
        if {$side == {left}} {
            return $bentProfile
        } else {
            return [lreverse $bentProfile]
        }
            #
    } 
        #
    method __get_tubeProfileOffset {profile position} {
        
        variable unbentShape

        #set profileIndex {}
          # puts "dict: $profile"
          # puts "keys: [dict keys $profile]"
        foreach offset [lsort -real [dict keys $profile]] {
            lappend profileIndex $offset
            # puts "   -> $offset"
        } 
            # puts "\$profileIndex  $profileIndex"

        foreach index $profileIndex {
            #puts "      <D10>  $index $position"        
          if {$position >= [expr {1.0 * $index}]} {
            set k {}
            set value [dict get $profile $index]
              # set value $tubeProfile($index)
            set d_profile $index
            lassign $value d k
                # foreach {d k}  $value break
          }
        }
        set dx [expr {$position - $d_profile}]
        set offset [expr {$d + $dx*$k}]
          # puts ">$offset"
        
        return $offset
          # return [list $position $offset]
    }
        #
    method __get_shapeInterSection {shape length} {
        
        set shape_llength [llength $shape]  
        set pLast {0 0}
        set precission 1
        
        set shapeIndex 0
        while {$shapeIndex < $shape_llength} {
            # -- get current point of shape
          set pIdx [lindex $shape $shapeIndex]  
          lassign $pIdx  x y
              # foreach {x y} $pIdx break
          set xAbs  [expr {abs($x)}]
          set yAbs  [expr {abs($y)}]
          set lpIdx    [vectormath::length {0 0} $pIdx]

            # -- get last point of shape
          if {$shapeIndex > 0} {
            set pLast [lindex $shape $shapeIndex-1]
          }

            # -- incr shapeIndex before continue
          incr shapeIndex

            # -- precheck values to optimize loop through shape
          if {$lpIdx < $length} continue
          
          set pNow  $pLast
          set dir   [vectormath::dirAngle $pLast $pIdx] 
          set lEnd  [vectormath::length {0 0} $pIdx]
          
          if {$lpIdx > $length} {
              set lNow [vectormath::length {0 0} $pLast]
              while {$lNow < $length} {
                set pNow [vectormath::rotateLine $pNow $precission $dir]
                set lNow [vectormath::length {0 0} $pNow]
              }
              return $pNow
          }
        }
        
          # -- exception: intersection is out of shape
        set pLast [lindex $shape end-1]
        set pNow  [lindex $shape end]
        set lNow  [vectormath::length {0 0} $pNow]
        set dir   [vectormath::dirAngle $pLast $pNow]

        while {$lNow < $length} {
          set pNow  [vectormath::rotateLine $pNow $precission $dir]
          set lNow  [vectormath::length {0 0} $pNow]
        }
        return $pNow
    }
        #
    method __cut_centerLine {centerLine length_x} {
        set centerLineCut {}
          # puts "\n ------"
          # puts "   -> \$centerLine      $centerLine"
          # puts "   -> \$centerLine      [llength $centerLine]"
          # puts "   -> \$length_x   $length_x"
          # puts " ------\n"
        set newLength     0
        set lastLength    0
        set lastXY       {0 0}
        set i 0
        foreach {x y} $centerLine {
            incr i
            set xy [list $x $y]
                # puts "     $i -> $xy"
                #
                # $x .......... running x-coordinate of centerLine
                # $length_x ... x-length of intersection with BB-Center
                #
            if {$x < $length_x} {
                set offset      [vectormath::length $lastXY $xy]
                    # puts "   -> offset        -> $offset  <- $lastXY / $xy"
                set newLength   [expr {$lastLength + $offset}]
                lappend centerLineCut $xy
                set lastXY      $xy
                set lastLength  $newLength
                    # puts "   -> $x  <- $length_x    ($y)"
                # puts " -> \$lastLength $lastLength"
                    #
            } else {
                    #
                    # ... in case of centerLine definition reaches length_x
                    #
                lassign $lastXY  last_x last_y
                    # foreach {last_x last_y} $lastXY break
                set seg_x       [expr {$length_x - $last_x}]
                set segVct      [vectormath::unifyVector $lastXY $xy]
                set dx          [expr {$seg_x * [lindex $segVct 0]}]
                set dy          [expr {$seg_x * [lindex $segVct 1]}]
                set segEnd      [vectormath::addVector $lastXY [list $dx $dy]]
                
                lappend centerLineCut $segEnd
                    #
                set cuttingLength [expr {$lastLength + [vectormath::length {0 0} [list $dx $dy]]}]
                    #
                # puts "    -1-> \$cuttingLength $cuttingLength"    
                    #
                return [list $centerLineCut $cuttingLength]
            }
        }
        
            #
            # ... in case of centerLine definition does not reach length_x
            #
            # puts "\n ------"
            # puts "   -> $x  ... did not reach $length_x"
            # puts "   ... \$length_x   $length_x"
            # puts "   ... \$lastLength $lastLength"
            # puts "   ... \$lastXY     $lastXY"
            #
        set prevXY  [lindex $centerLineCut end-1]
            # puts "   ... \$prevXY     $prevXY"
        set dirVct  [vectormath::unifyVector $prevXY $lastXY]
        lassign $dirVct  dx dy
            # foreach {dx dy} $dirVct break
            # foreach {dx dy} $dirVct break
            # puts "   ... \$dirVct      $dirVct"
        set delta_X [expr {$length_x - [lindex $lastXY 0]}]
            # puts "   ... \$delta_X     $delta_X"
        set delta_Y [expr {$dy * $delta_X / $dx}]
            # puts "   ... \$delta_Y     $delta_Y"
        set delta_L [expr {$delta_X / [lindex $dirVct 0]}]
            # puts "   ... \$delta_L     $delta_L"
            #
        set cuttingLength [expr {$lastLength + $delta_L}]
            # puts "    -2-> \$cuttingLength $cuttingLength"    
            #
        set vctExt  [vectormath::unifyVector $prevXY $lastXY $delta_L]
            #
        lappend centerLineCut [vectormath::addVector $lastXY $vctExt]
            #
            # puts "   -> [llength $centerLine]"
            # puts "   -> [llength $centerLineCut]"
            # puts "   -> [llength $centerLineCut]"
            # puts "   -> $centerLineCut"
            # -- exception if length is longer than the profile
            # puts "\n\n\n\n   <E> cut_centerLine exception \n\n\n\n "
        return [list $centerLineCut $cuttingLength]
            #
    } 
        #
        #
}
