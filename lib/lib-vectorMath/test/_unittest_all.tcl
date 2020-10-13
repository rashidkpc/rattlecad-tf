 #
 # https://wuhrr.wordpress.com/2011/03/28/getting-started-with-tcltest/
 #
 # all.tcl
 #
package require tcltest
namespace import ::tcltest::*


set unitTestDir [file nativename [file join [file dirname [lindex $argv0]] unittest]]

puts "  -> $unitTestDir"

tcltest::testsDirectory $unitTestDir

if {$argc != 0} {
    foreach {action arg} $::argv {
        if {[string match -* $action]} {
            configure $action $arg
        } else {
            $action $arg
        }
    }
}

runAllTests
