 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2017/11/26
 #
 #

set TEST_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]
    #
set TEST_Library_Dir [file dirname [file dirname $TEST_ROOT_Dir]]
puts "    -> \$TEST_Library_Dir ... $TEST_Library_Dir"
    #
    #
lappend auto_path [file dirname $TEST_ROOT_Dir]
lappend auto_path "$TEST_Library_Dir/__ext_Libraries"
lappend auto_path "$TEST_Library_Dir"

package require tkpath 0.3.4

set cv [tkp::canvas .c -width 800 -height 600]
pack $cv

set item_001 [$cv create polyline { 50 100 150 500} -strokewidth 1 -tags {__CenterLine__} -strokedasharray {40 4 4 4}]
set item_002 [$cv create polyline { 60 100 160 500} -strokewidth 2 -strokedasharray {20 2 2 2}]
set item_003 [$cv create polyline { 70 100 170 500} -strokewidth 4 -strokedasharray {10 1 1 1}]

set item_011 [$cv create polyline {150 100 250 500} -strokewidth 1 -strokedasharray {50 5 5 5}]
set item_012 [$cv create polyline {160 100 260 500} -strokewidth 2 -strokedasharray {50 5 5 5}]
set item_013 [$cv create polyline {170 100 270 500} -strokewidth 3 -strokedasharray {50 5 5 5}]

set item_021 [$cv create polyline {250 100 350 500} -strokewidth 1 -strokedasharray {150 5 5 5}]
set item_022 [$cv create polyline {260 100 360 500} -strokewidth 2 -strokedasharray {150 5 5 5}]
set item_023 [$cv create polyline {270 100 370 500} -strokewidth 3 -strokedasharray {150 5 5 5 5 6}]


set item_031 [$cv create polyline {350 100 450 500} -strokewidth 1 -strokedasharray {150  5}]
set item_032 [$cv create polyline {360 100 460 500} -strokewidth 2 -strokedasharray {200 10}]
set item_033 [$cv create polyline {370 100 470 500} -strokewidth 3 -strokedasharray {150 5}]

set itemAttr [$cv itemconfigure $item_001]

puts "  -> $itemAttr"
foreach attr $itemAttr {
    puts "   -> $attr"
}
puts "    $item_001 -> [$cv itemcget $item_001 -strokedasharray]"
puts "\n----\n"
foreach item [$cv find withtag __CenterLine__] {
    puts "   -> $item"
    puts "       -> [$cv itemcget $item -strokedasharray]"
}
puts "\n----\n"
foreach item [$cv find withtag __CenterLine__] {
    puts "   -> $item"
    puts "       itempdf       -> [$cv itempdf $item]"
    puts "       itemconfigure -> [$cv itemconfigure $item]"
    # puts "       itemsvg -> [$cv itemsvg $item]"
}


