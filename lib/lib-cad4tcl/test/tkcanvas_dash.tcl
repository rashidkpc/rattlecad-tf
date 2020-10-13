 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2017/11/26
 #
 #

package require Tk

set cv [canvas .c -width 800 -height 600]
pack $cv

$cv create line {50 100 150 500} -width 1 -dash {20 1 1 1}
$cv create line {60 100 160 500} -width 2 -dash {20 1 1 1}
$cv create line {70 100 170 500} -width 3 -dash {20 1 1 1}

$cv create line {150 100 250 500} -width 1 -dash {50 5 5 5}
$cv create line {160 100 260 500} -width 2 -dash {50 5 5 5}
$cv create line {170 100 270 500} -width 3 -dash {50 5 5 5}

$cv create line {250 100 350 500} -width 1 -dash {150 5 5 5}
$cv create line {260 100 360 500} -width 2 -dash {150 5 5 5}
$cv create line {270 100 370 500} -width 3 -dash {150 5 5 5 5 6}


$cv create line {350 100 450 500} -width 1 -dash {150  5}
$cv create line {360 100 460 500} -width 2 -dash {200 10}
$cv create line {370 100 470 500} -width 3 -dash {150 5}


