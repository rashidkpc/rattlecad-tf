 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2010/02/06
 #
 # 



set WINDOW_Title      "cad4tcl, an extension for canvas"
    #
set BASE_Dir  [file normalize [file dirname [file normalize $::argv0]]]
    #
set TEST_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]
puts "   \$TEST_ROOT_Dir ... $TEST_ROOT_Dir"
    #
set TEST_Library_Dir [file dirname [file dirname $TEST_ROOT_Dir]]
puts "    -> \$TEST_Library_Dir ... $TEST_Library_Dir"
    #
set TEST_Sample_Dir [file join $TEST_ROOT_Dir _sample]
puts "    -> \$TEST_Sample_Dir .... $TEST_Sample_Dir"
    #
set TEST_Export_Dir [file join $TEST_ROOT_Dir _export]
puts "    -> \$TEST_Export_Dir .... $TEST_Export_Dir"
    #
    #
foreach dir $tcl_library {
    puts "   -> tcl_library $dir"
}
    #
set tcl_pkgPath $TEST_Library_Dir
foreach dir $tcl_pkgPath {
    puts "   -> tcl_pkgPath $dir"
}
    #
    #
lappend auto_path [file dirname $TEST_ROOT_Dir]
    #
lappend auto_path "$TEST_Library_Dir/vectormath"
lappend auto_path "$TEST_Library_Dir/appUtil"
lappend auto_path "$TEST_Library_Dir/__ext_Libraries"
    #
lappend auto_path "$TEST_Library_Dir/lib-vectormath"
lappend auto_path "$TEST_Library_Dir/lib-tkpath0.3.3"
lappend auto_path "$TEST_Library_Dir/lib-appUtil"
    #
    #
package require   cad4tcl 0.01
package require   appUtil
    #
    #
variable stageDict [dict create]
    #
variable stateRaster 0
    #
    #
proc crateNotebookTab {nb tabName} {
        #
    set wName [string tolower $tabName]
    $nb add [frame .f.nb.$wName] -text " $tabName "
    set frameCanvas  [labelframe $nb.$wName.f_canvas  -text "board"]
    set frameConfig  [labelframe $nb.$wName.f_config  -text "config"]
    pack  $frameCanvas \
          $frameConfig \
        -side left 
    pack  configure $frameCanvas -fill both -expand yes
    pack  configure $frameConfig -fill y    -expand no
        #
    .f.nb select .f.nb.$wName
        #
    return [list $frameCanvas $frameConfig]
}
    #
    #
proc scaleToCenter {cvObject scale} {
    set currentScale    [$cvObject configure Canvas Scale]
    set newScale        [expr $currentScale * $scale]
    puts "  -> scaleToCenter: $currentScale * $scale => $newScale"
    $cvObject           center $newScale
}
    #
proc scale {cvObject scale} {
    puts "  -> scaleToCenter: $scale"
    $cvObject           center $scale
}
    #
proc setFormat {cvObject stageFormat {updateCommand {}}} {   
    variable stageDict
    $cvObject configure Stage Format $stageFormat
    appUtil::pdict $stageDict
    puts "     -> setFormat: \$cvObject $cvObject"
        #
    if [dict exist $stageDict $cvObject] {
        set updateCommand [dict get $stageDict $cvObject]
        # puts "              -> \$updateCommand $updateCommand"
        # $updateCommand $cvObject
    }   
        #
}
    #
proc switchRaster {cvObject key} {
        #
    variable stateRaster
        #
    if $stateRaster {
        set stateRaster 0
    } else {
        set stateRaster 1
    }
        #
    $cvObject fit
        #
    updateCanvas $cvObject $key
        #
}
    #
proc exportDXF {cvObject} {
    variable TEST_Export_Dir
    set exportFile [file join $TEST_Export_Dir _test_030_a.dxf]
    $cvObject export DXF $exportFile
}    
    #
proc exportSVG {cvObject} {
    variable TEST_Export_Dir
    set exportFile [file join $TEST_Export_Dir _test_030_a.svg]
    $cvObject export SVG $exportFile
}    
    #
    #
proc fillTab {w cvObject key} {
        #
    variable stageDict
        #
    puts "     -> \$key $key"
        #
    if [dict exist $stageDict $key] {
        set fillCommand [dict get $stageDict $key]
    } else {
        set fillCommand {}
    }
        #
    puts "     -> \$fillCommand $fillCommand"
        #
    switch -exact -- $key {
        Tab_02 -
        Tab_03 -
        Tab_09 -
        Format {
            fillConfig_Format   $w $cvObject $key
        }
        NoFormat {
            fillConfig_NoFormat $w $cvObject $key
        }  
        Circle_Arc {
            fillConfig_06       $w $cvObject $key
        }
        Circle_Arc -
        Oval_Arc -
        Oval_Arc2 -
        default {
            fillConfig_Default  $w $cvObject $key
        }
    }
        #
    updateCanvas    $cvObject   $key
        #
    update
        #
    $cvObject       fit    
        #
        #   fillTab    $frameConfig $cvObject            Tab_06
        #   fillTab    $frameConfig $cvObject            Tab_07               
        #   fillTab  $frameConfig $cvObject              Tab_08
        #   fillTab $frameConfig $cvObject               Circle_Arc
        #   fillTab $frameConfig $cvObject               Oval_Arc
        #   fillConfig_Format   $frameConfig $cvObject      Format
        #   fillConfig_NoFormat $frameConfig $cvObject      NoFormat
        #
  
}    
    #
proc updateCanvas {cvObject key}    {
        #
    variable stageDict
        #
    puts "     -> updateCanvas: \$key $key"
        #
    appUtil::pdict $stageDict
    if [dict exist $stageDict $key] {
        set updateCommand [dict get $stageDict $key]
        dict append stageDict $cvObject $updateCommand
    } else {
        set updateCommand {}
    }
        #
    puts "                      \$updateCommand $updateCommand"
        #
    if {$updateCommand ne {}} {
        $updateCommand $cvObject
    }
        #
}
    #
    #
proc fillConfig_Default {w cvObject key} {
        #
    variable stageDict
        #
    puts "     -> \$key $key"
        #
    if [dict exist $stageDict $key] {
        set fillCommand [dict get $stageDict $key]
    } else {
        set fillCommand {}
    }
        #
    button $w.bt_fit   -text "refit"            -width 20  -command [list $cvObject fit]				
    pack   $w.bt_fit   -fill x
    button $w.bt_a5    -text "A5"               -width 20  -command [list setFormat $cvObject A5]
    pack   $w.bt_a5    -fill x                       
    button $w.bt_a4    -text "A4"               -width 20  -command [list setFormat $cvObject A4]
    pack   $w.bt_a4    -fill x                       
    button $w.bt_a3    -text "A3"               -width 20  -command [list setFormat $cvObject A3]
    pack   $w.bt_a3    -fill x                       
    button $w.bt_a2    -text "A2"               -width 20  -command [list setFormat $cvObject A2]
    pack   $w.bt_a2    -fill x                       
    button $w.bt_st05  -text "cvScale 0.5"      -width 20  -command [list $cvObject center 0.5]
    pack   $w.bt_st05  -fill x                      
    button $w.bt_st10  -text "cvScale 1.0"      -width 20  -command [list $cvObject center 1.0]
    pack   $w.bt_st10  -fill x                       
    button $w.bt_st20  -text "cvScale 2.0"      -width 20  -command [list $cvObject center 2.0]
    pack   $w.bt_st20  -fill x                       
    button $w.bt_cv05  -text "cvScale -"        -width 20  -command [list scaleToCenter $cvObject 0.5]
    pack   $w.bt_cv05  -fill x 
    button $w.bt_cv20  -text "cvScale +"        -width 20  -command [list scaleToCenter $cvObject 2.0]
    pack   $w.bt_cv20  -fill x 
    button $w.bt_bd10  -text "cvBorder 10"      -width 20  -command [list $cvObject configure Canvas InnerBorder 10]
    pack   $w.bt_bd10  -fill x 
    button $w.bt_bd20  -text "cvBorder 20"      -width 20  -command [list $cvObject configure Canvas InnerBorder 20]
    pack   $w.bt_bd20  -fill x 
    button $w.bt_bd40  -text "cvBorder 40"      -width 20  -command [list $cvObject configure Canvas InnerBorder 40]
    pack   $w.bt_bd40  -fill x 
    button $w.bt_rstr  -text "Raster on/off"    -width 20  -command [list switchRaster $cvObject $key]
    pack   $w.bt_rstr  -fill x                       
    button $w.bt_clean -text "clear"            -width 20  -command [list $cvObject deleteContent]
    pack   $w.bt_clean -fill x                       
    button $w.bt_fill  -text "update"           -width 20  -command [list updateCanvas $cvObject $key]
    pack   $w.bt_fill  -fill x
    button $w.bt_xDXF  -text "export DXF"       -width 20  -command [list exportDXF $cvObject]
    pack   $w.bt_xDXF  -fill x     
    button $w.bt_xSVG  -text "export SVG"       -width 20  -command [list exportSVG $cvObject]
    pack   $w.bt_xSVG  -fill x     
        #
}
    #
proc fillConfig_Format {w cvObject key} {
    button $w.bt_open  -text "open File"        -width 20  -command openFile
    pack   $w.bt_open  -fill x
    button $w.bt_fit   -text "refit"            -width 20  -command [list $cvObject fit]				
    pack   $w.bt_fit   -fill x
    button $w.bt_a5    -text "A5"               -width 20  -command [list setFormat $cvObject A5 fillCanvas_Summary]
    pack   $w.bt_a5    -fill x                       
    button $w.bt_a4    -text "A4"               -width 20  -command [list setFormat $cvObject A4 fillCanvas_Summary]
    pack   $w.bt_a4    -fill x                       
    button $w.bt_a3    -text "A3"               -width 20  -command [list setFormat $cvObject A3 fillCanvas_Summary]
    pack   $w.bt_a3    -fill x                       
    button $w.bt_a2    -text "A2"               -width 20  -command [list setFormat $cvObject A2 fillCanvas_Summary]
    pack   $w.bt_a2    -fill x                       
    button $w.bt_st05  -text "cvScale 0.5"      -width 20  -command [list $cvObject center 0.5]
    pack   $w.bt_st05  -fill x                      
    button $w.bt_st10  -text "cvScale 1.0"      -width 20  -command [list $cvObject center 1.0]
    pack   $w.bt_st10  -fill x                       
    button $w.bt_st20  -text "cvScale 2.0"      -width 20  -command [list $cvObject center 2.0]
    pack   $w.bt_st20  -fill x                       
    button $w.bt_cv05  -text "cvScale -"        -width 20  -command [list scaleToCenter $cvObject 0.5]
    pack   $w.bt_cv05  -fill x 
    button $w.bt_cv20  -text "cvScale +"        -width 20  -command [list scaleToCenter $cvObject 2.0]
    pack   $w.bt_cv20  -fill x 
    button $w.bt_bd10  -text "cvBorder 10"      -width 20  -command [list $cvObject configure Canvas InnerBorder 10]
    pack   $w.bt_bd10  -fill x 
    button $w.bt_bd20  -text "cvBorder 20"      -width 20  -command [list $cvObject configure Canvas InnerBorder 20]
    pack   $w.bt_bd20  -fill x 
    button $w.bt_bd40  -text "cvBorder 40"      -width 20  -command [list $cvObject configure Canvas InnerBorder 40]
    pack   $w.bt_bd40  -fill x 
    button $w.bt_rstr  -text "Raster on/off"    -width 20  -command [list switchRaster $cvObject $key]
    pack   $w.bt_rstr  -fill x                       
    button $w.bt_clean -text "clear"            -width 20  -command [list $cvObject deleteContent]
    pack   $w.bt_clean -fill x                       
    button $w.bt_fill  -text "update"           -width 20  -command [list updateCanvas $cvObject $key]
    pack   $w.bt_fill  -fill x     
    button $w.bt_xDXF  -text "export DXF"       -width 20  -command [list exportDXF $cvObject]
    pack   $w.bt_xDXF  -fill x     
    button $w.bt_xSVG  -text "export SVG"       -width 20  -command [list exportSVG $cvObject]
    pack   $w.bt_xSVG  -fill x     
}
    #
proc fillConfig_NoFormat {w cvObject key} {
    button $w.bt_open  -text "open File"        -width 20  -command openFile
    pack   $w.bt_open  -fill x
    button $w.bt_fit   -text "refit"            -width 20  -command [list $cvObject fit]				
    pack   $w.bt_fit   -fill x
    button $w.bt_st05  -text "cvScale 0.5"      -width 20  -command [list $cvObject center 0.5]
    pack   $w.bt_st05  -fill x                      
    button $w.bt_st10  -text "cvScale 1.0"      -width 20  -command [list $cvObject center 1.0]
    pack   $w.bt_st10  -fill x                       
    button $w.bt_st20  -text "cvScale 2.0"      -width 20  -command [list $cvObject center 2.0]
    pack   $w.bt_st20  -fill x                       
    button $w.bt_cv05  -text "cvScale -"        -width 20  -command [list scaleToCenter $cvObject 0.5]
    pack   $w.bt_cv05  -fill x 
    button $w.bt_cv20  -text "cvScale +"        -width 20  -command [list scaleToCenter $cvObject 2.0]
    pack   $w.bt_cv20  -fill x 
    button $w.bt_bd10  -text "cvBorder 10"      -width 20  -command [list $cvObject configure Canvas InnerBorder 10]
    pack   $w.bt_bd10  -fill x 
    button $w.bt_bd20  -text "cvBorder 20"      -width 20  -command [list $cvObject configure Canvas InnerBorder 20]
    pack   $w.bt_bd20  -fill x 
    button $w.bt_bd40  -text "cvBorder 40"      -width 20  -command [list $cvObject configure -borderwidth 40]
    pack   $w.bt_bd40  -fill x 
    button $w.bt_rstr  -text "Raster on/off"    -width 20  -command [list switchRaster $cvObject $key]
    pack   $w.bt_rstr  -fill x                       
    button $w.bt_clean -text "clear"            -width 20  -command [list $cvObject deleteContent]
    pack   $w.bt_clean -fill x                       
    button $w.bt_fill  -text "update"           -width 20  -command [list updateCanvas $cvObject $key]
    pack   $w.bt_fill  -fill x     
}
    #
proc fillConfig_06 {w cvObject key} {
    button $w.bt_open  -text "open File"        -width 20  -command openFile
    pack   $w.bt_open  -fill x
    button $w.bt_fit   -text "refit"            -width 20  -command [list $cvObject fit]				
    pack   $w.bt_fit   -fill x
    button $w.bt_a5    -text "A5"               -width 20  -command [list setFormat $cvObject A5]
    pack   $w.bt_a5    -fill x                       
    button $w.bt_a4    -text "A4"               -width 20  -command [list setFormat $cvObject A4]
    pack   $w.bt_a4    -fill x                       
    button $w.bt_a3    -text "A3"               -width 20  -command [list setFormat $cvObject A3]
    pack   $w.bt_a3    -fill x                       
    button $w.bt_a2    -text "A2"               -width 20  -command [list setFormat $cvObject A2]
    pack   $w.bt_a2    -fill x                       
    button $w.bt_rstr  -text "Raster on/off"    -width 20  -command [list switchRaster $cvObject $key]
    pack   $w.bt_rstr  -fill x                       
    button $w.bt_clean -text "clear"            -width 20  -command [list $cvObject deleteContent]
    pack   $w.bt_clean -fill x                       
    button $w.bt_fill  -text "update"           -width 20  -command [list updateCanvas $cvObject $key]
    pack   $w.bt_fill  -fill x     
}
    #
    #
proc fillCanvas_Summary {cvObject} {
        #
    variable stateRaster
        #
    puts ""    
    puts "  -> fillCanvas_Summary"    
    puts "      -> \$cvObject: $cvObject"    
        #
    $cvObject deleteContent
    puts ""    
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
        #
    $cvObject create  circle     {160 70}               [list -radius 50  -tags {Line_01}  -fill blue]  
    $cvObject create  rectangle  {14.5 23.1 36.2 35.0}  [list -tags {Line_01}  -fill violet]
    $cvObject create  polygon    {40 60  80 50  120 90  180 130  90 150  50 90 35 95}   [list -tags {Line_01}  -outline red  -fill yellow]
    $cvObject create  oval       {30 160 155 230}       [list -tags {Line_01}  -fill lightblue]
    $cvObject create  text       {133.4 62.2}           [list -text "text  3.4 2.2"]
    $cvObject create  arc        {250 150}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}  -outline gray  -style arc]
    $cvObject create  line       {20 100  20 190}       [list -tags {Line_01}  -fill orange]
    $cvObject create  line       {40 100  40 190}       [list -tags {Line_01}  -fill red]
    $cvObject create  line       {20 100  60 190}       [list -tags {Line_01}  -fill orange]
    $cvObject create  centerline {30 100  70 190}       [list -tags {Line_01}  -fill blue]
    $cvObject create  line       {40 100  80 190}       [list -tags {Line_01}  -fill red]
    #$cvObject create  draftline  {50 100  90 190}  -tags {Line_01}  -fill red  
    #$cvObject create  draftline  {55 100  95 190}  -tags {Line_01}  -fill red 
    #$cvObject create  draftline  {60 100 100 190}  -tags {Line_01}  -fill red
        #
    #set editFrame_01 [$cvObject create  editFrame  {0 0} -title "edit 01"  -size 20]
    #set editFrame_02 [$cvObject create  editFrame  {50 25} -title "edit 02"  -size 20]
        #
        #$stage create  drafttext   {160 30}  -text "draftText  160 30  -size 20"  -size 20
        #$stage create  vectortext  {154.0 131.5} -text "vectorText  4.0 1.5  -size 1.5"  -size 1.5  -tags "abcde"
        #$stage create  vectortext  {154.0 131.5} -text "35"  -size 35  -tags "abcde"
        #
    $cvObject create  rectangle  {0 0 50 25}            [list -tags {Line_01}  -fill lightgray]
    #$cvObject create  vectortext {0 0}  -text "25"  -size 25  -tags "abcde"
    #$cvObject create  vectortext {45 0} -text "I"  -size 25  -tags "abcde"
        #
    $cvObject create  rectangle  {0  40 50 55}          [list -tags {Line_01}  -fill lightgray]
    #$cvObject create  vectortext {0  40}  -text "15"  -size 15  -tags "abcde"
    #$cvObject create  vectortext {45 40}  -text "I"  -size 15  -tags "abcde"
    #$cvObject create  vectortext {55 85}  -text "vectorText  5.0 3.0  -size 10"  -size 10
        #
    $cvObject create  circle     {260 170}              [list -radius 20  -tags {Line_01}  -outline red  -width 1]  
        #
    $cvObject create  vectorText {260 190}              [list -radius 20  -tags {Line_01}  -text "my VectorText"]  
            # $cvObject create  circle     {260 70}   -radius 12.5  -tags {Line_01}  -fill yellow  -width 2 
        # $cvObject create  circle     {0 0}   -radius 25  -tags {Line_01}  -fill yellow  -width 2 
        #
    #puts " ... $editFrame_01 $editFrame_01"
    #puts " ... $editFrame_02 $editFrame_02"
        #
    if 0 {            
        # set cv02 [cad4tcl::new cv02  $f2_canvas.cv02 "MyCanvas_02"  880  610 A4 0.5 40 -bd 2  -bg white  -relief sunken ]
        # set cv02 [cad4tcl::new cv02  $f2_canvas.cv02  880  610 6.5  6.9 i 0.5 -bd 2  -bg white  -relief sunken ]
                
        #$cv create   polygon  {40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 
            
        #$cv create   text{3.4 2.2}  -text "text  3.4 2.2"
        #$cv create   vectortext{4.0 1.5}  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5
        $cv create   vectortext {5.0 3.0}  -text "vectorText  5.0 3.0  -size 1"  -size 1
    }
}
    #
proc fillCanvas_Circle_Arc {cvObject} {
        #
    variable stateRaster
        #
    puts "  -> fillCanvas_Circle_Arc"    
    puts "      -> \$cvObject: $cvObject"
        #
    $cvObject deleteContent
        #
    puts ""
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
        #
    $cvObject create  circle     {50 100}   [list  -radius 5   -tags {Line_01}  -fill blue  -outline blue -width 2                  ] 
    $cvObject create  arc        {50 100}   [list  -radius 30  -start 30  -extent  70  -tags {Line_01}  -outline blue  -style arc   ]
    $cvObject create  arc        {50 100}   [list  -radius 35  -start 30  -extent 180  -tags {Line_01}  -outline blue  -style arc   ]
    $cvObject create  arc        {50 100}   [list  -radius 40  -start 30  -extent 290  -tags {Line_01}  -outline blue  -style arc   ]
        #
    $cvObject create  circle     {150 100}  [list  -radius 5   -tags {Line_01}  -fill red   -outline red -width 2                   ]
    $cvObject create  arc        {150 100}  [list  -radius 30  -start 30  -extent -70  -tags {Line_01}  -outline red  -style arc    ]
    $cvObject create  arc        {150 100}  [list  -radius 35  -start 30  -extent -180 -tags {Line_01}  -outline red  -style arc    ]
    $cvObject create  arc        {150 100}  [list  -radius 40  -start 30  -extent -290 -tags {Line_01}  -outline red  -style arc    ]
        #
    $cvObject create  circle     {250 100}  [list  -radius 5   -tags {Line_01}  -fill red   -outline red -width 2                   ]
    $cvObject create  arc        {250 100}  [list  -radius 40  -start 30  -extent -150 -tags {Line_01}  -outline green              ]
    $cvObject create  arc        {250 100}  [list  -radius 35  -start 30  -extent -120 -tags {Line_01}  -outline green  -fill orange]
    $cvObject create  arc        {250 100}  [list  -radius 30  -start 30  -extent  -90 -tags {Line_01}  -outline green  -fill yellow -style chord]
    $cvObject create  arc        {250 100}  [list  -radius 25  -start 30  -extent  -90 -tags {Line_01}  -outline green  -fill yellow -style arc  ]
    #$cvObject create  arc        {250 100}  -radius 40  -start 30  -extent -290 -tags {Line_01}  -outline red  -style arc
        #
}
    #
proc fillCanvas_Oval_Arc {cvObject} {
        #
    variable stateRaster
        #
    puts "  -> fillCanvas_Oval_Arc"    
    puts "      -> \$cvObject: $cvObject"
        #
    $cvObject deleteContent
        #
    puts ""    
        #
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
    $cvObject create  oval       {30 160 130 190}   [list  -tags {Line_01}  -fill lightblue -outline blue]
        #
    $cvObject create  oval       {20  70 140 130}   [list  -tags {Line_01}  -outline blue]
    $cvObject create  circle     {80 100}           [list  -radius 5   -tags {Line_01}  -fill lightblue  -outline blue  -width 1]
        #
    set ptCenter {220 100}       
        #
    set i 0
    set pt1 [vectormath::addVector $ptCenter {0 70}]
    while {$i <360} {
        incr i 15
        set pt2 [vectormath::rotatePoint $ptCenter $pt1 $i]
        $cvObject create  line  [join "$ptCenter $pt2" " "]     
    }
        #
    $cvObject create  ovalarc    {160 40 280 160}   [list  -start 30  -extent 290 -tags {Line_01}  -outline blue -style arc     ]
    $cvObject create  ovalarc    {160 60 280 140}   [list  -start 30  -extent 290 -tags {Line_01}  -outline blue -style arc     ]
    $cvObject create  ovalarc    {180 60 260 140}   [list  -start 30  -extent 290 -tags {Line_01}  -outline blue -style arc     ]
    $cvObject create  circle     $ptCenter          [list  -radius 5   -tags {Line_01}  -fill lightblue  -outline blue -width 1 ]
        #
    return
        #
}
    #
proc fillCanvas_Oval_Arc2 {cvObject} {
        #
    variable stateRaster
        #
    puts "  -> fillCanvas_Oval_Arc2"    
    puts "      -> \$cvObject: $cvObject"
        #
    $cvObject deleteContent
        #
    puts ""    
        #
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
    $cvObject create  oval       {30 160 130 190}   [list  -tags {Line_01}  -fill lightblue -outline blue]
        #
    $cvObject create  oval       {20  70 140 130}   [list  -tags {Line_01}  -outline blue]
    $cvObject create  circle     {80 100}           [list  -radius 5   -tags {Line_01}  -fill lightblue  -outline blue  -width 1]
        #
    set ptCenter {220 100}       
        #
    set i 0
    set pt1 [vectormath::addVector $ptCenter {0 70}]
    while {$i <360} {
        incr i 15
        set pt2 [vectormath::rotatePoint $ptCenter $pt1 $i]
        $cvObject create  line  [join "$ptCenter $pt2" " "]     
    }
        #
    $cvObject create  ovalarc2   {160 40 280 160}   [list  -start 30  -extent 290 -tags {Line_01}  -outline blue -style arc     ]
    $cvObject create  ovalarc2   {160 60 280 140}   [list  -start 30  -extent 290 -tags {Line_01}  -outline blue -style arc     ]
    $cvObject create  ovalarc2   {180 60 260 140}   [list  -start 30  -extent 290 -tags {Line_01}  -outline blue -style arc     ]
    $cvObject create  circle     $ptCenter          [list  -radius 5   -tags {Line_01}  -fill lightblue  -outline blue -width 1 ]
        #
    return
        #
}
    #
proc fillCanvas_06 {cvObject} {
        #
    variable stateRaster
        #
    puts "  -> fillCanvas_06"    
    puts "      -> \$cvObject: $cvObject"
        #
    $cvObject deleteContent
        #
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
    set systemTime  [clock seconds]
    set timeString  [clock format $systemTime -format {%Y.%d.%m %H:%M:%S}]
    set description [package versions cad4tcl]
        #
    $cvObject create draftFrame {} [list \
                                    -label "test-030" \
                                    -title "Drafting Frame" \
                                    -date  $timeString \
                                    -descr $description ]
    #
    #$cvObject create draftRaster {} {}
    #
    puts ""    
        #
    return
        #
    $cvObject create  raster
        #
}
    #
proc fillCanvas_07 {cvObject} {
        #
    variable stateRaster
        #
    puts "  -> fillCanvas_07"    
    puts "      -> \$cvObject: $cvObject"
        #
    $cvObject deleteContent
        #
    puts ""    
        #
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
        #
    $cvObject create  centerline {30 20  70 150}  -tags {Line_01}  -fill blue
        
        
        
        #
    return
        #
        #$cvObject deleteContent
        #
    # $cvObject create  raster     5 gray70 25 gray20
    # return
    $cvObject create  circle     {160 70}   -radius 50  -tags {Line_01}  -fill blue  -width 2 
    $cvObject create  rectangle  {14.5 23.1 36.2 35.0}  -tags {Line_01}  -fill violet   -width 2
    $cvObject create  polygon    {40 60  80 50  120 90  180 130  90 150  50 90 35 95}  -tags {Line_01}  -outline red  -fill yellow  -width 2
    $cvObject create  oval       {30 160 155 230}  -tags {Line_01}  -fill lightblue   -width 2 
    $cvObject create  text       {133.4 62.2}  -text "text  3.4 2.2"
    $cvObject create  arc        {250 150}  -radius 50  -start 30  -extent 170  -tags {Line_01}  -outline gray  -width 2  -style arc
    $cvObject create  line       {20 100  20 190}  -tags {Line_01}  -fill orange  -width 5 
    $cvObject create  line       {40 100  40 190}  -tags {Line_01}  -fill red  -width 2 
    $cvObject create  line       {20 100  60 190}  -tags {Line_01}  -fill orange  -width 5 
    $cvObject create  line       {20 120  60 210}  -tags {Line_01}  -fill orange 
    $cvObject create  centerline {30 100  70 190}  -tags {Line_01}  -fill blue   
    $cvObject create  centerline {30 120  70 210}  -tags {Line_01}  -fill blue  -width 2 
    $cvObject create  line       {40 100  80 190}  -tags {Line_01}  -fill red  -width 2 
    $cvObject create  draftline  {50 100  90 190}  -tags {Line_01}  -fill red  -width 0.5
    $cvObject create  draftline  {55 100  95 190}  -tags {Line_01}  -fill red  -width 1.5
    $cvObject create  draftline  {60 100 100 190}  -tags {Line_01}  -fill red  -width 2.5
    set editFrame_01 [$cvObject create  editFrame  {0 0} -title "edit 01"  -size 20]
    set editFrame_02 [$cvObject create  editFrame  {50 25} -title "edit 02"  -size 20]
    #$stage create  drafttext   {160 30}  -text "draftText  160 30  -size 20"  -size 20
    #$stage create  vectortext  {154.0 131.5} -text "vectorText  4.0 1.5  -size 1.5"  -size 1.5  -tags "abcde"
    #$stage create  vectortext  {154.0 131.5} -text "35"  -size 35  -tags "abcde"
    $cvObject create  rectangle  {0 0 50 25}  -tags {Line_01}  -fill lightgray   -width 2
    $cvObject create  vectortext {0 0}  -text "25"  -size 25  -tags "abcde"
    $cvObject create  vectortext {45 0} -text "I"  -size 25  -tags "abcde"
                    
    $cvObject create  rectangle  {0  40 50 55}  -tags {Line_01}  -fill lightgray   -width 2
    $cvObject create  vectortext {0  40}  -text "15"  -size 15  -tags "abcde"
    $cvObject create  vectortext {45 40}  -text "I"  -size 15  -tags "abcde"
    $cvObject create  vectortext {55 85}  -text "vectorText  5.0 3.0  -size 10"  -size 10
        #
    # $cvObject create  circle     {260 70}   -radius 12.5  -tags {Line_01}  -fill yellow  -width 2 
    # $cvObject create  circle     {0 0}   -radius 25  -tags {Line_01}  -fill yellow  -width 2 
        #
    puts " ... $editFrame_01 $editFrame_01"
    puts " ... $editFrame_02 $editFrame_02"
        #
    puts "     \$cvObject   $cvObject"   
    [$cvObject getStage] reportSettings    
        #
    if 0 {            
        # set cv02 [cad4tcl::new cv02  $f2_canvas.cv02 "MyCanvas_02"  880  610 A4 0.5 40 -bd 2  -bg white  -relief sunken ]
        # set cv02 [cad4tcl::new cv02  $f2_canvas.cv02  880  610 6.5  6.9 i 0.5 -bd 2  -bg white  -relief sunken ]
                
        #$cv create   polygon  {40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 
            
        #$cv create   text{3.4 2.2}  -text "text  3.4 2.2"
        #$cv create   vectortext{4.0 1.5}  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5
        $cv create   vectortext {5.0 3.0}  -text "vectorText  5.0 3.0  -size 1"  -size 1
    }
}
    #
proc fillCanvas_08 {cvObject} {
        #
    variable stateRaster
        #
    puts "  -> fillCanvas_09"    
    puts "      -> \$cvObject: $cvObject"
        #
    $cvObject deleteContent
        #
    puts ""    
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
        #
    $cvObject create   line  		{0 0 20 0 20 20 0 20 0 0} 		-tags {Line_01}  -fill blue   -width 2 
    $cvObject create   line  		{30 30 90 30 90 90 30 90 30 30} -tags {Line_01}  -fill blue   -width 2 
    $cvObject create   line  		{0 0 30 30 } 		-tags {Line_01}  -fill blue   -width 2 
    $cvObject create   oval  		{30 160 155 230 } 	-tags {Line_01}  -fill red   -width 2 		
    $cvObject create   circle  	    {160 60}   -radius 50 -tags {Line_01}  -fill blue   -width 2 
    $cvObject create   arc  		{270 160}  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc
    $cvObject create   text		    {150 90}  -text "text 150 90 360°"
    $cvObject create   vectorText	{160 30}  -text "vectorText  160 30  -size 20"  -size 20	
    $cvObject create   vectorText	{210 70}  -text "vectorText  210 70  -size 10"  -size 10
    $cvObject create   vectorText	{120 170} -text "Sonderzeichen:  grad \°, exp ^"  -size 10
        #
}
    #
proc fillCanvas_99 {cvObject} {
        #
    variable stateRaster
        #
    puts ""    
    puts "  -> fillCanvas_99"    
    puts "      -> \$cvObject: $cvObject"    
    $cvObject deleteContent
    puts ""    
        #
    if $stateRaster {
        $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
    }
        #
        # $cvObject create  draftRaster   {} {}               ;#5 gray70 25 gray20
        #
    $cvObject create  circle     {160 70}               [list -radius 50  -tags {Line_01}  -fill blue]  
    $cvObject create  rectangle  {14.5 23.1 36.2 35.0}  [list -tags {Line_01}  -fill violet]
    $cvObject create  polygon    {40 60  80 50  120 90  180 130  90 150  50 90 35 95}   [list -tags {Line_01}  -outline red  -fill yellow]
    $cvObject create  oval       {30 160 155 230}       [list -tags {Line_01}  -fill lightblue]
    $cvObject create  text       {133.4 62.2}           [list -text "text  3.4 2.2"]
    $cvObject create  arc        {250 150}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}    -style arc         -outline gray              ]
    $cvObject create  arc        {250 100}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}    -style chord       -outline gray              ]
    $cvObject create  arc        {250  50}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}    -style pieslice    -outline gray              ]
    $cvObject create  arc        {350 150}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}    -style arc         -outline gray  -fill gray50]
    $cvObject create  arc        {350 100}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}    -style chord       -outline gray  -fill gray50]
    $cvObject create  arc        {350  50}              [list -radius 50  -start 30  -extent 170  -tags {Line_01}    -style pieslice    -outline gray  -fill gray50]
    $cvObject create  line       {10  70  10 190 70 70} [list -tags {Line_01}  -fill darkred]
    $cvObject create  line       {20 100  20 190}       [list -tags {Line_01}  -fill orange]
    $cvObject create  line       {40 100  40 190}       [list -tags {Line_01}  -fill red]
    $cvObject create  line       {20 100  60 190}       [list -tags {Line_01}  -fill orange]
    $cvObject create  centerline {30 100  70 190}       [list -tags {Line_01}  -fill blue]
    set myItem \
        [$cvObject  create  centerline {230 200  370 290} [list -tags {Line_01}  -fill blue]]
    #puts "\n--- strokedasharray: --- [$cvObject itemcget $myItem -strokedasharray] ---\n"
    #return
    $cvObject create  line       {40 100  80 190}       [list -tags {Line_01}  -fill red]
    $cvObject create  line       {50 100  90 190}       [list -tags {Line_01}  -fill red -width 1]
    $cvObject create  circle     {90 190}               [list -radius 5  -tags {Line_01}  -outline blue  -width 1]  
    #$cvObject create  draftline  {50 100  90 190}  -tags {Line_01}  -fill red  
    #$cvObject create  draftline  {55 100  95 190}  -tags {Line_01}  -fill red 
    #$cvObject create  draftline  {60 100 100 190}  -tags {Line_01}  -fill red
        #
    #set editFrame_01 [$cvObject create  editFrame  {0 0} -title "edit 01"  -size 20]
    #set editFrame_02 [$cvObject create  editFrame  {50 25} -title "edit 02"  -size 20]
        #
        #$stage create  drafttext   {160 30}  -text "draftText  160 30  -size 20"  -size 20
        #$stage create  vectortext  {154.0 131.5} -text "vectorText  4.0 1.5  -size 1.5"  -size 1.5  -tags "abcde"
        #$stage create  vectortext  {154.0 131.5} -text "35"  -size 35  -tags "abcde"
        #
    $cvObject create  rectangle  {0 0 50 25}            [list -tags {Line_01}  -fill lightgray]
    #$cvObject create  vectortext {0 0}  -text "25"  -size 25  -tags "abcde"
    #$cvObject create  vectortext {45 0} -text "I"  -size 25  -tags "abcde"
        #
    $cvObject create  rectangle  {0  40 50 55}          [list -tags {Line_01}  -fill lightgray]
    #$cvObject create  vectortext {0  40}  -text "15"  -size 15  -tags "abcde"
    #$cvObject create  vectortext {45 40}  -text "I"  -size 15  -tags "abcde"
    #$cvObject create  vectortext {55 85}  -text "vectorText  5.0 3.0  -size 10"  -size 10
        #
        # $cvObject create  circle     {260 70}   -radius 12.5  -tags {Line_01}  -fill yellow  -width 2 
        # $cvObject create  circle     {0 0}   -radius 25  -tags {Line_01}  -fill yellow  -width 2 
        #
    #puts " ... $editFrame_01 $editFrame_01"
    #puts " ... $editFrame_02 $editFrame_02"
        #
    $cvObject create  rectangle  {200 150 250 160}      [list -tags {Line_01}  -fill lightgray]
    $cvObject create  circle     {200 150}              [list -radius 5  -tags {Line_01}  -outline blue  -width 1]  
    set myItem \
        [$cvObject create  text  {200 150}              [list -text "ABCDEFG\nAB HIJKL" -size 10 -anchor sw]]
    
    #    set cv      [$cvObject getCanvas]
    #    set bbox    [$cv bbox $myItem]
    #set myBBox      [$cv create  rectangle  $bbox      -tags {Line_01}  -fill lightgreen]
    #$cvObject lower $myBBox $myItem

        
        
        
    if 0 {            
        # set cv02 [cad4tcl::new cv02  $f2_canvas.cv02 "MyCanvas_02"  880  610 A4 0.5 40 -bd 2  -bg white  -relief sunken ]
        # set cv02 [cad4tcl::new cv02  $f2_canvas.cv02  880  610 6.5  6.9 i 0.5 -bd 2  -bg white  -relief sunken ]
                
        #$cv create   polygon  {40 60  80 50  120 90  180 130  90 150  50 90 35 95} -tags {Line_01}  -outline red  -fill yellow -width 2 
            
        #$cv create   text{3.4 2.2}  -text "text  3.4 2.2"
        #$cv create   vectortext{4.0 1.5}  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5
        $cv create   vectortext {5.0 3.0}  -text "vectorText  5.0 3.0  -size 1"  -size 1
    }
        #
}
    #
    #
proc main {} {
    # --------------------------------------------
    variable TEST_ROOT_Dir
    variable stageDict
    
    pack [frame .f] -expand yes -fill both

    # --------------------------------------------
            # notebook
    pack [ ttk::notebook .f.nb] -fill both  -expand yes

            # cad4tcl::new  w width height stageFormat
    
            # foreach name {{Tab_01} {Tab_02} {Tab_08}} {}
    foreach name {{Format} {NoFormat} {Circle_Arc} {Oval_Arc} {Oval_Arc2} {Tab_02} {Tab_03} {Tab_04} {Tab_05} {Tab_06} {Tab_07} {Tab_08} {Tab_09}} {
            # foreach name {{Tab_01} {Tab_02} {Tab_03} {Tab_04} {Tab_05} {Tab_06} {Tab_07}} {}
            #
        foreach {frameCanvas frameConfig} [crateNotebookTab .f.nb $name] break   
            #
        set stageList {}    
            #
            # set cvObject    [cad4tcl::new cv01  $cv_path 	"cvObject"  $cv_width $cv_height $dinFormat $scale 20]
            #
        switch -exact -- $name {
            {Format} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      580 710 A4 1.0 20]
                dict append stageDict   $name                   fillCanvas_Summary
                fillTab                 $frameConfig $cvObject  $name
            }
            {NoFormat} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      580 710 passive {} {}]
                dict append stageDict   $name                   fillCanvas_Summary
                fillTab                 $frameConfig $cvObject  $name
            }
            {Circle_Arc} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 1.0 10] 
                dict append stageDict   $name                   fillCanvas_Circle_Arc
                fillTab                 $frameConfig $cvObject  $name
            }
            {Oval_Arc} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 1.0 10] 
                dict append stageDict   $name                   fillCanvas_Oval_Arc
                fillTab                 $frameConfig $cvObject  $name
            }
            {Oval_Arc2} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 1.0 10] 
                dict append stageDict   $name                   fillCanvas_Oval_Arc2
                fillTab                 $frameConfig $cvObject  $name
            }
            {Tab_02} {
                set cad4tcl::canvasType   10
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 0.5 10]                
                dict append stageDict   $name                   fillCanvas_Summary
                fillTab                 $frameConfig $cvObject  $name
            }
            {Tab_03} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 0.5 10]
                dict append stageDict   $name                   fillCanvas_Summary
                fillTab                 $frameConfig $cvObject  $name
            }
            {Tab_04} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 0.5 20]
                dict append stageDict   $name                   {}
            }
            {Tab_05} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A3 0.5 20]
                dict append stageDict   $name                   {}
            }
            {Tab_06} {
                set cad4tcl::canvasType   10
                set cvObject [cad4tcl::new  $frameCanvas      880 710 A4 0.5 20]
                dict append stageDict   $name                   fillCanvas_06
                fillTab                 $frameConfig $cvObject  $name
            }
            {Tab_07} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 1.0 20]
                dict append stageDict   $name                   fillCanvas_07
                fillTab                 $frameConfig $cvObject  $name               
            }
            {Tab_08} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      580 710 A4 1.0 20]
                dict append stageDict   $name                   fillCanvas_08
                fillTab                 $frameConfig $cvObject  $name
            }
            {Tab_09} {
                set cad4tcl::canvasType   1
                set cvObject [cad4tcl::new  $frameCanvas      880 610 A4 0.5 10]
                dict append stageDict $name                     fillCanvas_99
                fillTab                 $frameConfig $cvObject  $name
            }
                
        }
            #
    }
        #
    lappend stageList $cvObject
        #
    # --------------------------------------------
            # 	final
        #.f.nb select .f.nb.f1
    ttk::notebook::enableTraversal .f.nb
        #
    foreach cvObject $stageList {
        update
        # $cvObject fit
    }

}
    #
    #
main
    #
update
    #
if 0 {
    puts "$tkp::antialias"
    set tkp::antialias 1    
    puts "$tkp::antialias"
}
    #
set reportDoc   [cad4tcl::getReportDOC]
set reportRoot  [$reportDoc documentElement]
    #
puts [$reportDoc asXML]   
    
    
    
#cad4tcl::reportCanvas
    #
# puts "[$cad4tcl::dataFormatRoot asXML]"
    #
    