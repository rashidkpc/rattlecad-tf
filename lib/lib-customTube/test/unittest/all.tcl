 #
 # https://wuhrr.wordpress.com/2011/03/28/getting-started-with-tcltest/
 #
 # all.tcl
 #
package require tcltest
namespace import ::tcltest::*

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
