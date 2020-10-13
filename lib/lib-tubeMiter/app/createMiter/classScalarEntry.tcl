 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2018
 #
 #      package: tubeMiter 	->	classScalarEntry.tcl
 #
 # ----------------------------------------------------------------------
 #  namespace:  tubeMiter
 # ----------------------------------------------------------------------
 #
 #
    #
package require TclOO
    #
namespace eval tubeMiter {oo::class create ScalarEntry}
    #
oo::define tubeMiter::ScalarEntry {
        #
    constructor {args} { 
            #
        puts "              -> class ScalarEntry"
            #
        variable myPath
        variable myLabel   
        variable myEntry   
        variable myScalarType   double  ;# integer, double
        variable myResolution   1
        variable myBoundaryLow  {}
        variable myBoundaryHigh {}
            #
        variable currentValue   0.0
            #
        set myPath      [lindex $args 0]
        set argDict     [lrange $args 1 end]
            #
            # puts "   -> \$myPath $myPath"
        frame $myPath
            #
            #
        set myLabel [label  $myPath.myLabel  \
                            -text {} \
                            -bd 1  -anchor w]
            #
        set myEntry [entry  $myPath.cfg \
                            -textvariable entryVar \
                            -width 10 \
                            -validate all \
                            -validatecommand [list [self] validateScalar %s %P] \
                            -invalidcommand bell \
                            -bd 1  -justify right  -bg white]
            #
        label $myPath.sp \
                            -width 2 \
                            -bd 1
            #
        pack $myLabel       -side left  -expand yes  -fill both
        pack $myPath.sp     -side left  -padx 2  -fill none
        pack $myEntry       -side right
            #
        my configure    $argDict    
            #
        bind $myEntry   <MouseWheel>    [list [self] event_ScaleEntry   %D]
        bind $myEntry   <Key-Up>        [list [self] event_ScaleEntry    1]
        bind $myEntry   <Key-Down>      [list [self] event_ScaleEntry   -1]
            #
        bind $myEntry   <Return>        [list [self] event_ScaleEntry    0]
            #
        # pack $myPath   -side top  -fill x  -expand yes             
            #
    }
        #
    destructor { 
            #
        puts "            -> [self] ... destroy ScalarEntry"
            #
    }
        #
    method unknown {target_method args} {
        puts "<E> ... tubeMiter::ScalarEntry $target_method $args  ... unknown"
    }
        #
        #
    method configure {argDict} {
            #
        variable myPath
        variable myLabel   
        variable myEntry   
        variable myResolution   1
        variable myBoundaryLow
        variable myBoundaryHigh
        variable myScalarType       ;# integer, double
            #
        variable currentValue
            #
            # puts "    -> configure"
            #
        dict for {key value} $argDict {
                # puts "      -> $key $value"
            switch -exact $key {
                -text {
                        $myLabel configure -text $value
                    }
                -textvariable {
                        $myEntry configure -textvariable $value
                        set currentValue [set $value] 
                    }
                -fgentry -
                -fgEntry -
                -foregroundentry -
                -ForegroundEntry {
                        $myEntry configure -fg $value
                    }
                -fglabel -
                -fgLabel -
                -foregroundlabel -
                -ForegroundLabel {
                        $myLabel configure -fg $value
                    }
                -widthentry -
                -widthEntry {
                        $myEntry configure -width $value
                    }
                -widthlabel -
                -widthLabel {
                        $myLabel configure -width $value
                    }
                -orient {
                        pack $myPath configure -side $value
                    }
                -resolution {
                        set myResolution $value
                    }
                -type {
                        switch -exact $value {
                            int -
                            integer {
                                set myScalarType integer
                            }
                            double {
                                set myScalarType $value
                            }
                        }
                    }
                -boundaryLow {
                        set myBoundaryLow $value
                    }
                -boundaryHigh {
                        set myBoundaryHigh $value
                    }
                -state {
                        switch -exact $value {
                            normal {
                                # label, entry
                                $myLabel configure -state $value
                                $myEntry configure -state $value
                            }
                            active {
                                # label
                                $myLabel configure -state $value
                                $myEntry configure -state normal
                            } 
                            disabled {
                                # label, entry
                                $myLabel configure -state $value
                                $myEntry configure -state $value
                            }
                            readonly {
                                # entry
                                $myLabel configure -state disabled
                                $myEntry configure -state $value
                            }
                        }    
                    }
            }
        }
            #
    }
        #
    method pack {args} {
            #
        variable  myPath
            #
        pack $myPath {*}$args    
            #
    }
        #
    method getPath {} {
        variable myPath
        puts "           -> getPath \$myPath $myPath"
        return  $myPath
    }
        #
    method bind {event command} {
            #
        variable myEntry
            # puts "   -> bind: $myEntry   $event $command"
            #
        set bindingCurrent [bind $myEntry $event]
            # puts "\n   ----> \$bindingCurrent  --> $bindingCurrent\n"
            #
        if {$bindingCurrent ne {}} {
            bind $myEntry   $event  [list eval $bindingCurrent \; $command]
        } else {
            bind $myEntry   $event  $command
        }     
            #
    }
        #
    method event_ScaleEntry {direction} {
            #
            # puts "            -- [self] bind_EntryMouseWheel --start--"
            # puts "                    $direction"
            #
        variable myEntry   
        variable currentValue
            #
        variable myScalarType       ;# integer, double
        variable myResolution 
        variable myBoundaryLow
        variable myBoundaryHigh
            #
        set textVariable    [$myEntry cget -textvariable]  
        set currentValue    [set $textVariable]
            #
        set state           [$myEntry cget -state]   
            #
        switch -exact $state {
            disabled -
            readonly {
                return
            }
        }
            #
            # puts "    -> $currentValue +/- $myResolution"
        if {$direction != 0} {
                #
            if {$direction > 0} {
                set currentValue    [expr $currentValue + $myResolution]
            } else {
                set currentValue    [expr $currentValue - $myResolution]
            }
                #
        }
            #
            #
        if {$myBoundaryLow ne {}} {
            if {$currentValue < $myBoundaryLow} {
                set currentValue $myBoundaryLow
            }
        }
            #
        if {$myBoundaryHigh ne {}} {
            if {$currentValue > $myBoundaryHigh} {
                set currentValue $myBoundaryHigh
            }
        }
            #
            # puts "   1 -> \$myScalarType $myScalarType"    
            #
        switch -exact $myScalarType {
            double {
                    #
                set numberDecimalPlace  [string length [lindex [split $currentValue .] 1]]
                    # puts "  -> \$numberDecimalPlace  $numberDecimalPlace"
                set numberDecimalPlace  [expr $numberDecimalPlace - 2]
                    # puts "  -> \$numberDecimalPlace  $numberDecimalPlace"
                    #
                if {$numberDecimalPlace > 8} {
                    set formatString    "%.${numberDecimalPlace}f"
                    set currentValue    [format "$formatString" $currentValue]
                    set currentValue    [string trimright $currentValue "0"]
                }
                    #
            }
            integer {
                    #puts "   2 -> \$myScalarType $myScalarType"    
                set currentValue    [expr int($currentValue)]
            }
            default {
            }
        }
            #
            # ... debug
            #       ... 35.2 + 0.1 = 35.300000000000004
            #
            #
            # ... debug
            #
            #
        set $textVariable       $currentValue
            #
            # puts "    -> [set $textVariable]"
            #
            # puts "            -- [self] bind_EntryMouseWheel ---end---"
            #
    }
        #
    method validateScalar {old new} {
            #
        variable myEntry
        variable myScalarType       ;# int, entier, double
            #
        # puts "    -> validateScalar: $old $new"
            #
        if [string is double $new] {
                # puts "   -> 1 -> $new"
            switch -exact $myScalarType {
                _double {
                    return 1
                }
                _entier {
                    return 1
                }
                _int {
                    if [string is int $new] {
                    
                    }
                    return 1
                }
                _default {    
                    return 1
                }
            }
            return 1
        } else {
                # puts "   -> 0 -> $old -> $new -> $old "
                # set textVariable    [$myEntry cget -textvariable]
                # puts "    -> \$textVariable $textVariable"
                # set $textVariable   $old
                # bell
            return 0
        }
            #
    }
        #
}