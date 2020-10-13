package require tdom
    #
    # Export as global command
set packageHomeDir      [file normalize [file dirname [file dirname [file dirname [info script]]]]]
set packageParentDir    [file normalize [file dirname $packageHomeDir]]

puts "   -> \$packageParentDir $packageParentDir"
puts "   -> \$packageHomeDir $packageHomeDir"


lappend auto_path $packageParentDir
lappend auto_path $packageHomeDir

package require vectormath   1.00
package require appUtil
    #
# package require tubeMiter    0.03
    #

return
    #
    #
    #
set fp              [open [file join $packageHomeDir etc initTemplate.dict]]
fconfigure          $fp -encoding utf-8
set data            [read -nonewline $fp]
close               $fp
    #
foreach {key value} $data break
set projectDict [dict create $key $value]
    # dict set projectDict root [string map {\n {}} $data]

puts "    ----- 001 --------"

# puts "$data"    

puts "    ----- 002 --------"

appUtil::pdict $projectDict 2 "  "

puts "    ----- 003 --------"


set value       [dict get $projectDict root Geometry Scalar HeadTube_Angle]    
         
puts "   -> $value"


exit

    
