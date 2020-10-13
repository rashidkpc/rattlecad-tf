 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classCanvas__Base.tcl
 #
 # ----------------------------------------------------------------------
 #  namespace:  cadCanvas
 # ----------------------------------------------------------------------
 #
 #  2017/11/26
 #      extracted from the rattleCAD-project (Version 3.4.05)
 #          http://rattlecad.sourceforge.net/
 #          https://sourceforge.net/projects/rattlecad/
 #
 #

 
    #
namespace eval cad4tcl {oo::class create Canvas__Base}
    #
oo::define cad4tcl::Canvas__Base {
        #
    variable packageHomeDir         ;# base dir of package
        #
    variable DimensionFactory
    variable ItemInterface
        #
    set cad4tcl::canvasType 10
        #
    puts "   -> \$cad4tcl::canvasType $cad4tcl::canvasType   ... Canvas__Base"
        #
        # ----------------------------------------------------
        #
    constructor {parentWidget cv_width cv_height stageFormat stageScale stageBorder} {
            #
        puts "            -> superclass Canvas__Base"
            #
            # <Canvas   path="" iborder="0" scale=""/>
            # <Stage    format="" unit="" scale="" width="" height="" title=""/>
            # <Style    linewidth="0.35" linecolour="black" fontstyle="vector" fontsize="3.5" fontdist="1" font="Arial" fontcolour="black" precision="2" defaultprecision="2"/>
            #
        variable Canvas ; array set Canvas {
                                Path            {}
                                Type            {}
                                InnerBorder     {}
                                Scale           {} 
                                Cursor          {} 
                            }  
        variable Stage  ; array set Stage {
                                Format          {}
                                Unit            {}
                                UnitScale       {} 
                                Scale           {}
                                Width           {}
                                Height          {}
                                Title           {}
                            }  
        variable Style  ; array set Style {
                                Linewidth       {}
                                Linecolour      {}
                                Fontstyle       {} 
                                Fontsize        {}
                                Fontdist        {}
                                Font            {}
                                Fontcolour      {}
                                Precision       {}
                                Defaultprecision {}
                            }
        variable UnitScale; array set UnitScale {
                                m       {}
                                c       {}
                                i       {} 
                                p       {}
                                std     {}
                            }
            #
    }
        #
    destructor { 
        puts "            -> [self] ... destroy superDimension"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cad4tcl::Canvas__Base::$target_method $args  ... unknown"
    }
        #
    method CreateStage {{type sheet}} {
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
                
            # -- get the Objects tdom attributes
        set w           $Canvas(Path)
        set stageUnit   $Stage(Unit)
            #
        update 
        
            # -- cleanup the canvas
        catch [$w delete  {__Stage__}       ]
        catch [$w delete  {__StageShadow__} ]
                            
            # -- size in points
        set w_width  [winfo width  $w]
        set w_height [winfo height $w]
        
            # -- get values from config variable
        set x          $Stage(Width)
        set y          $Stage(Height)
        
            # -- create reference squares in the canvas center
            #        100m
            #        4i
            # -- p ----- this is the reference for --- m, c, i ---
        $w create rectangle   0  0  10p  10p    -tags {__StageReference_p__}    -fill gray  -outline gray  -width   0            
                set coords          [$w coords __StageReference_p__] 
                set scale           [expr {10 / [lindex $coords 2]}]
                set UnitScale(p)    $scale
            catch [ $w delete {__StageReference_p__} ] 
                    # puts "       ->   p : 0  0  10p  10p  / $coords"
            # -- mm ----
        $w create rectangle   0  0  100m  100m  -tags {__StageReference_mm__}   -fill gray  -outline gray  -width 0            
                set coords          [$w coords __StageReference_mm__] 
                set scale           [expr {100 / [lindex $coords 2]}]
                set UnitScale(m)    $scale
                # cad4tcl::setNodeAttributeRoot /root/_package_/UnitScale m $scale
            catch [ $w delete {__StageReference_mm__} ]
                    # puts "       ->  mm : 0  0  10m  10m  / $coords / $scale"
            # -- cm ----
        $w create rectangle   0  0  10c  10c    -tags {__StageReference_cm__}   -fill gray  -outline gray  -width   0            
                set coords          [$w coords __StageReference_cm__] 
                set scale           [expr {10 / [lindex $coords 2]}]
                set UnitScale(c)    $scale
            catch [ $w delete {__StageReference_cm__} ] 
            # -- inch --
        $w create rectangle   0  0  1i  1i      -tags {__StageReference_inch__} -fill gray  -outline gray  -width   0            
                set coords          [$w coords __StageReference_inch__] 
                set scale           [expr {1 / [lindex $coords 2]}]
                set UnitScale(i)    $scale
            catch [ $w delete {__StageReference_inch__} ] 
                    # puts "       ->   i : 0  0  1i  1i  / $coords"
            # -- std -----
        $w create rectangle   0  0  10  10      -tags {__StageReference_std__}  -fill gray  -outline gray  -width   0            
                set coords          [$w coords __StageReference_std__] 
                set scale           [expr {10 / [lindex $coords 2]}]
                set UnitScale(std)  $scale
            catch [ $w delete {__StageReference_std__} ] 
                    
        update
        switch -exact $Stage(Unit) {
            m       {set Stage(UnitScale) $UnitScale(m)   }
            cm      {set Stage(UnitScale) $UnitScale(c)   }
            inch    {set Stage(UnitScale) $UnitScale(i)   }
            p       {set Stage(UnitScale) $UnitScale(p)   }
            std     {set Stage(UnitScale) $UnitScale(std) }
            default {set Stage(UnitScale) 1               }
        }
            #
        set Stage(PointScale)   $UnitScale(p)      
            #
        switch $type {
            sheet {
                        # -- create Stage
                        #        
                    $w create rectangle   0  0  $x$stageUnit  $y$stageUnit    \
                                          -tags    {__StageShadow__}  \
                                          -fill    gray40   \
                                          -outline gray40    \
                                          -width   0
                    $w create rectangle   0  0  $x$stageUnit  $y$stageUnit    \
                                          -tags    {__Stage__}  \
                                          -fill    white    \
                                          -outline white    \
                                          -width   0

                        # -- compute Canvas Scale
                        #        
                    set cvBorder       $Canvas(InnerBorder)
                    set stageCoords    [ $w coords  {__Stage__} ]
                    lassign $stageCoords  x1 y1 x2 y2
                        # foreach {x1 y1 x2 y2} $stageCoords break
                    set stage_x        [expr {$x2 - $x1}]
                    set stage_y        [expr {$y2 - $y1}]
                    set w_width_st     [expr {$w_width  - 2 * $cvBorder}]
                    set w_height_st    [expr {$w_height - 2 * $cvBorder}]
                    set scale_x        [format "%.4f" [expr {$w_width_st  / $stage_x}]]
                    set scale_y        [format "%.4f" [expr {$w_height_st / $stage_y}]]
                    if { $scale_x < $scale_y } { 
                            set cvScale $scale_x 
                    } else {
                            set cvScale $scale_y 
                    }
                    
                        # -- debug
                        # puts "         $w:  $scale_x  - $scale_y :  $cvScale"
                    
                        # -- set Scale Attribute
                    set Canvas(Scale) $cvScale
                        
                        # -- scale stage
                    $w scale {__StageShadow__}  0 0 $cvScale $cvScale
                    $w scale {__Stage__}        0 0 $cvScale $cvScale
                    
                        # -- move stage to center
                    set stageCoords    [ $w coords  {__Stage__} ]
                    lassign $stageCoords  x1 y1 x2 y2
                        # foreach {x1 y1 x2 y2} $stageCoords break
                    set move_x [expr {($w_width  - $x2) / 2}]
                    set move_y [expr {($w_height - $y2) / 2}]
                        #
                    $w move  {__Stage__}                   $move_x  $move_y
                    $w move  {__StageShadow__}             $move_x  $move_y
                        #
                    $w move  {__StageShadow__}  6 5
                    $w raise {__StageShadow__}  all
                    $w raise {__Stage__}        all
                        #
                }
                
            passive {
                    $w create rectangle   0  0  $x$stageUnit  $y$stageUnit    \
                                          -tags    {__Stage__}  \
                                          -fill    white    \
                                          -outline white    \
                                          -width   0
                    
                        # -- compute Canvas Scale
                        #        
                    set stageCoords    [ $w coords  {__Stage__} ]
                    lassign $stageCoords  x1 y1 x2 y2
                        # foreach {x1 y1 x2 y2} $stageCoords break
                    set stage_x        [expr {$x2 - $x1}]
                    set stage_y        [expr {$y2 - $y1}]
                    set scale_x        [format "%.4f" [expr {$w_width  / $stage_x}] ]
                    set scale_y        [format "%.4f" [expr {$w_height / $stage_y}] ]
                    if { $scale_x < $scale_y } { 
                            set cvScale $scale_x 
                    } else {
                            set cvScale $scale_y 
                    }
                    
                        # -- debug
                    # puts "         $w:  $scale_x  - $scale_y :  $cvScale"
                    
                        # -- set Scale Attribute
                    set Canvas(Scale)       $cvScale
                    set Canvas(InnerBorder) 0.0
                    set Stage(Scale)        1.0
                        
                        # -- scale stage
                    $w scale {__Stage__}         0 0 $cvScale $cvScale
                    
                        # -- move stage to center
                    set stageCoords    [ $w coords  {__Stage__} ]
                    lassign $stageCoords  x1 y1 x2 y2
                        # foreach {x1 y1 x2 y2} $stageCoords break
                    set move_x [expr {($w_width  - $x2) / 2}]
                    set move_y [expr {($w_height - $y2) / 2}]
                        #
                    update
                    $w move  {__Stage__}                   $move_x  $move_y
                }
                
            default {
                puts "\n"
                puts "          whats on?"
                puts "\n"
                # exit
            }
        }
            #
        return                 
            #
    }
        #
    method CreateWindow {coordList argList} {
        set w [my getCanvas]
        return [eval $w create window $coordList $argList]
    }
        #
    method reportSettings {} {
            #
        variable packageHomeDir
            #
        variable Canvas
        variable Stage
        variable Style
        variable UnitScale
            #
        puts ""
        puts "  -- reportSettings: [self] ----------"
            #
        puts "\n  -- Canvas --"
        parray Canvas
            #
        puts "\n  -- Stage --"
        parray Stage
            #
        puts "\n  -- Style --"
        parray Style
            #
        puts "\n  -- UnitScale --"
        parray UnitScale
            #
    }
        #
    method getPackageHomeDir {} {
        variable packageHomeDir
        return  $packageHomeDir
    }   
        #
    method getCanvas {} {
        variable Canvas
        return  $Canvas(Path)
    }
        #
    method getDimensionFactory {} {
        variable DimensionFactory
        return $DimensionFactory
    }
        #
    method getItemInterface {} {
        variable ItemInterface
        return $ItemInterface
    }
        #
    method getOrigin {{tagID __Stage__}} {
            #
        variable Canvas
            #
        set bbox [$Canvas(Path) coords $tagID] 
        lassign $bbox  x1 y1 x2 y2
            # foreach {x1 y1 x2 y2} $bbox break
        set bottomLeft [list $x1 $y2]
            #
        return $bottomLeft
            #
    }        
        #
        #
    method addtag {args} {
        set w [my getCanvas]
        return [eval $w addtag $args]
    }
        #
    method bbox {args} {
        set w [my getCanvas]
            # puts "      -> \$w      $w"
            # puts "      -> \$args   $args"
        return [eval $w bbox $args]
    }
        #
    method bbox2 {args} {
            # set precision $::tcl_platform(pointerSize)
        set x0  1e+8
        set y0  1e+8
        set x1  -1e+8
        set y1  -1e+8
            # 1e+20
        foreach tag [my find withtag $args] {
            # puts "     -> $tag"
            foreach {_x0 _y0 _x1 _y1} [my coords $tag] {
                if {$_x0 < $x0} {set x0 $_x0}
                if {$_y0 < $y0} {set y0 $_y0}
                if {$_x1 > $x1} {set x1 $_x1}
                if {$_y1 > $y1} {set y1 $_y1}
            }
        }
            # puts "---> bbox"
            # puts "   -> x0 $x0"
            # puts "   -> y0 $y0"
            # puts "   -> x1 $x1"
            # puts "   -> y1 $y1"
            #
        return [list $x0 $y0 $x1 $y1]
            #
    }
        #
    method bind {args} {
        set w [my getCanvas]
        return [eval $w bind $args]
    }
        #
    method coords {args} {
        set w [my getCanvas]
        set exceptID [lsearch $args {all}]
        if {$exceptID >= 0} {
            switch -exact [winfo class $w] {
                PathCanvas {
                        # puts "  -> \$args $args"
                        # puts "  -> \$exceptID $exceptID"
                    set args [lreplace $args $exceptID $exceptID 0]
                        # puts "  -> \$args $args"
                }
                default {}
            }
        }
        return [eval $w coords $args]
    }
        #
    method delete {args} {
        set w [my getCanvas]
        return [eval $w delete $args]
    }
        #
    method dtag {args} {
        set w [my getCanvas]
        return [eval $w dtag $args]
    }
        #
    method find {args} {
            #
        set w [my getCanvas]
            #
        switch -exact [winfo class $w] {
            PathCanvas {
                return [eval $w find $args]
            }
            default {
                return [eval $w find $args]
            }
        }
    }
        #
    method focus {tagID} {
        set w [my getCanvas]
        return [$w focus $tagID]
    }
        #
    method gettags {tagID} {
        set w [my getCanvas]
        return [$w gettags $tagID]
    }
        #
    method itemcget {args} {
        set w [my getCanvas]
        # puts "    00000000 -> $args"
        return [eval $w itemcget $args]
    }
        #
    method lower {args} {
            #
        set w [my getCanvas]
            #
        set referenceID [lindex $args end]
        set idList      [lrange $args 0 end-1]
            #
        if {$referenceID eq "all"} {
            $w lower   $idList  all
            $w raise   $idList  {__Stage__}
        }
            #
        return {}    
            #
    }
        #
    method move {tagID xAmount yAmount} {
        set w [my getCanvas]
        if {$tagID eq {all}} {
            switch -exact [winfo class $w] {
                PathCanvas {
                    return [$w move 0       $xAmount $yAmount]
                }
                default {
                    return [$w move all     $xAmount $yAmount]
                }
            }
        } else {
            return         [$w move $tagID  $xAmount $yAmount]        
        }
    }
        #
    method raise {args} {
            #
        set w [my getCanvas]
            #
        set referenceID [lindex $args end]
        set idList      [lrange $args 0 end-1]
            #
        if {$referenceID eq "all"} {
            $w lower   $idList  all
            $w lower   $idList  {__Stage__}
            if {[my find withtag {__StageShadow__}] ne {}} {
                    # __StageShadow__ ... does not exist in passive Canvas
                $w lower   $idList  {__StageShadow__}
            }
        }
            #
        return {}    
            #        
    }        
        #
    method scale {args} {
        set w [my getCanvas]
        lassign $args tagId xOrigin yOrigin xScale yScale
            # foreach {tagId xOrigin yOrigin xScale yScale} $args break
        if {$tagId eq {all}} {
            switch -exact [winfo class $w] {
                PathCanvas {
                    return [$w scale 0   $xOrigin $yOrigin $xScale $yScale]
                }
                default {
                    return [$w scale all $xOrigin $yOrigin $xScale $yScale]
                }
            }
        } else {
            return [eval $w scale $args]        
        }
    }
        #
    method type {tagID} {
        set w [my getCanvas]
        return [$w type $tagID]
    }
        #
}
    #
    #
