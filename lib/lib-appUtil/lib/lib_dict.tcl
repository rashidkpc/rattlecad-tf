#!/bin/sh
# lib_dict.tcl \
exec tclsh "$0" ${1+"$@"}


#-------------------------------------------------------------------------
    #
proc appUtil::get_dictValue {_dict _dictPath} {
        #
    set value "___undefined___"
        # puts "   ->  $_dictPath"
    set dictPath [string map {"/" " "} $_dictPath]
        # puts "   ->  $dictPath"
    catch {set value [dict get $_dict {*}$dictPath]}
        # puts "   -> $value"
    return $value
        #
} 
#-------------------------------------------------------------------------
    # see  http://wiki.tcl.tk/23526
    #
proc appUtil::pdict {d {i 0} {p "  "} {s " -> "} } {
        #
    set errorInfo $::errorInfo
    set errorCode $::errorCode
    set fRepExist [expr {0 < [llength [info commands tcl::unsupported::representation]]}]
        #
    while 1 {
        if { [catch {dict keys $d}] } {
            if {! [info exists dName] && [uplevel 1 [list info exists $d]]} {
                set dName $d
                unset d
                upvar 1 $dName d
                continue
            }
            return -code error  "error: pdict - argument is not a dict"
        }
        break
    }
        #
    if {[info exists dName]} {
        puts "dict $dName"
    }
        #
    set prefix [string repeat $p $i]
    set max 0
    foreach key [dict keys $d] {
        if { [string length $key] > $max } {
            set max [string length $key]
        }
    }
        #
    foreach key [lsort [dict keys ${d}]] {
        set val [dict get ${d} $key]
        puts -nonewline "${prefix}[format "%-${max}s" $key]$s"
        if {    $fRepExist && ! [string match "value is a dict*"\
                    [tcl::unsupported::representation $val]]
                || ! $fRepExist && [catch {dict keys $val}] } {
            puts "'${val}'"
        } else {
            puts ""
            pdict $val [expr {$i+1}] $p $s
        }
    }
    set ::errorInfo $errorInfo
    set ::errorCode $errorCode
        #
    return ""
        #
}
#-------------------------------------------------------------------------
    # see  http://wiki.tcl.tk/23526
    #
proc appUtil::pdict2file {fileID d {i 0} {p "  "} {s " -> "} } {
        #
    set errorInfo $::errorInfo
    set errorCode $::errorCode
    set fRepExist [expr {0 < [llength [info commands tcl::unsupported::representation]]}]
        #
    while 1 {
        if { [catch {dict keys $d}] } {
            if {! [info exists dName] && [uplevel 1 [list info exists $d]]} {
                set dName $d
                unset d
                upvar 1 $dName d
                continue
            }
            return -code error  "error: pdict2file - argument is not a dict"
        }
        break
    }
        #
    if {[info exists dName]} {
        puts "dict $dName"
        puts $fileID "dict $dName"
    }
        #
    set prefix [string repeat $p $i]
    set max 0
    foreach key [dict keys $d] {
        if { [string length $key] > $max } {
            set max [string length $key]
        }
    }
        #
    foreach key [lsort [dict keys ${d}]] {
        set val [dict get ${d} $key]
        puts -nonewline $fileID "${prefix}[format "%-${max}s" $key]$s"
        if {    $fRepExist && ! [string match "value is a dict*"\
                    [tcl::unsupported::representation $val]]
                || ! $fRepExist && [catch {dict keys $val}] } {
            puts $fileID "'${val}'"
        } else {
            puts $fileID ""
            pdict2file $fileID $val [expr {$i+1}] $p $s
        }
    }
    set ::errorInfo $errorInfo
    set ::errorCode $errorCode
        #
    return ""
        #
}
    #
proc appUtil::pdict2text {w d {i 0} {p "  "} {s " -> "} } {
        #
    set errorInfo $::errorInfo
    set errorCode $::errorCode
    set fRepExist [expr {0 < [llength [info commands tcl::unsupported::representation]]}]
        #
    while 1 {
        if { [catch {dict keys $d}] } {
            if {! [info exists dName] && [uplevel 1 [list info exists $d]]} {
                set dName $d
                unset d
                upvar 1 $dName d
                continue
            }
            return -code error  "error: pdict2text - argument is not a dict"
        }
        break
    }
        #
    if {[info exists dName]} {
        puts "dict $dName"
        $w insert end "dict $dName \n"
    }
        #
    set prefix [string repeat $p $i]
    set max 0
    foreach key [dict keys $d] {
        if { [string length $key] > $max } {
            set max [string length $key]
        }
    }
        #
    foreach key [lsort [dict keys ${d}]] {
        set val [dict get ${d} $key]
        $w insert end "${prefix}[format "%-${max}s" $key]$s"
        if {    $fRepExist && ! [string match "value is a dict*"\
                    [tcl::unsupported::representation $val]]
                || ! $fRepExist && [catch {dict keys $val}] } {
            $w insert end  "'${val}'\n"
        } else {
            $w insert end  "\n"
            pdict2text $w $val [expr {$i+1}] $p $s
        }
    }
    set ::errorInfo $errorInfo
    set ::errorCode $errorCode
        #
    return ""
        #
}


