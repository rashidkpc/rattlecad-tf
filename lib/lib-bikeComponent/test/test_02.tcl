##+##########################################################################
#
# test_canvas_CAD.tcl
# by Manfred ROSENBERGER
#
#   (c) Manfred ROSENBERGER 2010/02/06
#
#   canvas_CAD is licensed using the GNU General Public Licence,
#        see http://www.gnu.org/copyleft/gpl.html
# 
 


set WINDOW_Title      "bikeComponent, using canvasCAD"

  

variable APPL_ROOT_Dir

set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]

puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"

lappend auto_path [file dirname $APPL_ROOT_Dir]

lappend auto_path "$APPL_Package_Dir"
lappend auto_path [file join $APPL_Package_Dir __ext_Libraries]
    
package require     Tk
package require     extSummary
package require     vectormath
package require     cad4tcl
package require     bikeComponent

    
namespace eval myTest {
        #
    variable cvObject
    variable cv01
    variable cv02
    variable cv03
    variable cv04
        #
    variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]] ..]]
    variable widgetNS       {}
        #
}

    #
#-------------------------------------------------------------------------
    #
proc myTest::main {} {

    # --------------------------------------------
        #
        global APPL_ROOT_Dir
        variable cvObject
        variable cv01
        variable cv02
        variable cv03
        variable cv04
        variable widgetNS
    
    
        pack [ frame .f ] -expand yes -fill both

    # --------------------------------------------
            # 	notebook
        pack [ ttk::notebook .f.nb] -fill both  -expand yes


    # --------------------------------------------
            # 	tab 1
        .f.nb add [frame .f.nb.f1] -text "First tab" 

        set retValue [bikeComponent::create_LibraryWidget .f.nb.f1]
        puts "  -> $retValue"
        foreach {widgetNS cv cvNS} $retValue break
            #
        puts "   -> cv01:  $cv $cvNS"    
            #
            # set widgetNS    [bikeComponent::createLibraryWidget .f.nb.f1]
            # bikeComponent::libWidget::createLibrary .f.nb.f1
    
    
    # --------------------------------------------
            # 	tab 2
        .f.nb add [frame .f.nb.f2] -text "Second tab" 
            #
        set f2_canvas  [labelframe .f.nb.f2.f_canvas   -text "board"  ]
        set f2_config  [frame      .f.nb.f2.f_config   ]
            #
        pack  $f2_config    $f2_canvas  -side left -expand yes -fill both
        pack  configure     $f2_config  -fill y
            #
        pack [frame $f2_canvas.cv01]
            #
            # sset retValue [canvasCAD::newCanvas cv01  $f2_canvas.cv01 	"MyCanvas_02"  1080  800 	A2 1.0 40 -bd 2  -bg white  -relief sunken ]
            # sforeach {cv cvNS} $retValue break
            # sset cv02 $cvNS
            #
            # set retValue [canvasCAD::newCanvas cv01  $f2_canvas.cv01 	"MyCanvas_02"  880  610 	A3 0.5 40 -bd 2  -bg white  -relief sunken ]
            # foreach {cv ns} $retValue break
            # set cv02 $ns
        
        set cad4tcl::canvasType   1
        
        set cvObject [cad4tcl::new  $f2_canvas.cv01   1080  800 	A2 1.0 40]
        set cv02     [$cvObject getCanvas]
            
            
            
            
            
        puts "   -> cv02:  $cv $cvNS"    
            #
        label        $f2_config.space_01    -text {}   
        label        $f2_config.space_02    -text {}   
        label        $f2_config.space_03    -text {}   
        label        $f2_config.space_04    -text {}
        label        $f2_config.space_05    -text {}
            #
        ttk::button  $f2_config.refit       -text {refit}               -width 20   -command [list $cv02 refitStage]
            #
        ttk::button  $f2_config.saddle      -text {Saddle}              -width 20   -command [list myTest::showComponent Saddle]
        ttk::button  $f2_config.cranks      -text {CrankSet}            -width 20   -command [list myTest::showComponent CrankSet_XZ]
        ttk::button  $f2_config.rbrake      -text {RearBrake}           -width 20   -command [list myTest::showComponent RearBrake]
            #
        ttk::button  $f2_config.crankXZ     -text {CrankSet - XZ}       -width 20   -command [list myTest::showComponent CrankSet_XZ_Custom]
        ttk::button  $f2_config.crankXY     -text {CrankSet - XY}       -width 20   -command [list myTest::showComponent CrankSet_XY_Custom]
        ttk::button  $f2_config.fenderFront -text {FenderFront}         -width 20   -command [list myTest::showComponent FenderFront]
        ttk::button  $f2_config.fenderRear  -text {FenderRear}          -width 20   -command [list myTest::showComponent FenderRear]
        ttk::button  $f2_config.headset     -text {HeadSet}             -width 20   -command [list myTest::showMultiComponent HeadSet]
        ttk::button  $f2_config.rearHub     -text {RearHub}             -width 20   -command [list myTest::showComponent RearHub]
        ttk::button  $f2_config.seatpost    -text {SeatPost}            -width 20   -command [list myTest::showComponent SeatPost]
        ttk::button  $f2_config.stem        -text {Stem}                -width 20   -command [list myTest::showComponent Stem]
            #
        ttk::button  $f2_config.fork        -text {Fork}                -width 20   -command [list myTest::showComponent Fork]
        ttk::button  $f2_config.forkSupply  -text {ForkSupplier}        -width 20   -command [list myTest::showComponent ForkSupplier]
        ttk::button  $f2_config.forkCrown   -text {ForkCrown}           -width 20   -command [list myTest::showComponent ForkCrown]
        ttk::button  $f2_config.forkBlade   -text {ForkBlade}           -width 20   -command [list myTest::showComponent ForkBlade]
        ttk::button  $f2_config.forkDropout -text {ForkDropout}         -width 20   -command [list myTest::showComponent ForkDropout]
            #
        ttk::button  $f2_config.bottleCL    -text {BottleCage - left}   -width 20   -command [list myTest::showComponent BottleCage_left]
        ttk::button  $f2_config.bottleCR    -text {BottleCage - right}  -width 20   -command [list myTest::showComponent BottleCage_right]
            #
        ttk::button  $f2_config.report      -text {- Report -}          -width 20   -command [list myTest::report]
        ttk::button  $f2_config.debug       -text {- Debug -}           -width 20   -command [list myTest::debugUpdate]
        pack    $f2_config.refit \
                $f2_config.space_01 \
                $f2_config.saddle \
                $f2_config.cranks \
                $f2_config.rbrake \
                $f2_config.space_02 \
                $f2_config.crankXZ \
                $f2_config.crankXY \
                $f2_config.fenderFront \
                $f2_config.fenderRear \
                $f2_config.headset \
                $f2_config.rearHub \
                $f2_config.seatpost \
                $f2_config.stem \
                $f2_config.space_03 \
                $f2_config.fork \
                $f2_config.forkSupply \
                $f2_config.forkCrown \
                $f2_config.forkBlade \
                $f2_config.forkDropout \
                $f2_config.space_04 \
                $f2_config.bottleCL \
                $f2_config.bottleCR \
                $f2_config.space_05 \
                $f2_config.report \
                $f2_config.debug \
                -side top
            
        ttk::notebook::enableTraversal .f.nb				

}
    #
#-------------------------------------------------------------------------
    #
proc myTest::showComponent {compType} {

            return
            
            #
            #   check this:    setConfig Saddle Config ComponentKey $.....
            #
            #
            
    variable cvObject
    switch -exact $compType {
            Saddle              {   set compSVG     [bikeComponent::get_Config    Saddle      XZ etc:saddle/selle_san_marco_concor.svg       ]}
            CrankSet            {   set compSVG     [bikeComponent::get_Component CrankSet    {} etc:crankset/campagnolo_1984_SuperRecord.svg]}
            RearBrake           {   set compSVG     [bikeComponent::get_Component RearBrake   {} etc:brake/rear/campagnolo_rearbrake.svg     ]}
            CrankSet_XZ         {   set compSVG     [bikeComponent::get_Component CrankSet_XZ {}] }
            CrankSet_XY_Custom  {   set compSVG     [bikeComponent::get_Component CrankSet_XY_Custom {}] }
            CrankSet_XZ_Custom  {   set compSVG     [bikeComponent::get_Component CrankSet_XZ_Custom {}] }
            FenderFront         {   set compSVG     [bikeComponent::get_Component FrontFender {}] }
            FenderRear          {   set compSVG     [bikeComponent::get_Component RearFender  {}] }
            Fork                {   set compSVG     [bikeComponent::get_Component Fork        {}] }
            ForkSupplier        {   set compSVG     [bikeComponent::get_Component ForkSupplier {} etc:/fork/supplier/columbus_Tusk_Straight_2015.svg   ]}
            ForkCrown           {   set compSVG     [bikeComponent::get_Component ForkCrown    {} etc:fork/crown/longshen_max_36_5.svg       ]}
            ForkBlade           {   set compSVG     [bikeComponent::get_Component ForkBlade   {}] }
            ForkDropout         {   set compSVG     [bikeComponent::get_Component ForkDropout {} etc:fork/dropout/llewellyn_LFD.svg         ]}
            RearHub             {   set compSVG     [bikeComponent::get_Component RearHub     {}] }
            SeatPost            {   set compSVG     [bikeComponent::get_Component SeatPost    {}] }
            Stem                {   set compSVG     [bikeComponent::get_Component Stem        {}] }
            BottleCage_left     {   set compSVG     [bikeComponent::get_Component BottleCage_DownTube   {}] }
            BottleCage_right    {   set compSVG     [bikeComponent::get_Component BottleCage_SeatTube   {}] }

            default {   
                                puts "\n -- myTest::showComponent $compType - not defined --- \n"
                                set compSVG     {}
                            }
    }
    if {$compSVG != {}} {
        puts " -- \$compSVG --"    
        puts "$compSVG"
        puts "[$compSVG asXML]"
        puts " -- \$compSVG --"
        $myTest::cv02 clean_StageContent
        $myTest::cv02 readSVGNode $compSVG {297 210}
    }
}
    #
proc myTest::showMultiComponent {compType} {
    switch -exact $compType {
            HeadSet             {   set compSVG_01     [bikeComponent::get_Component HeadSetTop        {}] 
                                    set compSVG_02     [bikeComponent::get_Component HeadSetBottom     {}] 
            }
    }
        #
    $myTest::cv02 clean_StageContent
        #
    if {$compSVG_01 != {}} {
        puts " -- \$compSVG_01 --"    
        puts "$compSVG_01"
        puts "[$compSVG_01 asXML]"
        puts " -- \$compSVG_01 --"
        $myTest::cv02 readSVGNode $compSVG_01 {297 240}
    }
        #
    if {$compSVG_02 != {}} {
        puts " -- \$compSVG_02 --"    
        puts "$compSVG_02"
        puts "[$compSVG_02 asXML]"
        puts " -- \$compSVG_02 --"
        $myTest::cv02 readSVGNode $compSVG_02 {297 180}
    }
}
    #
#-------------------------------------------------------------------------
    #
proc myTest::report {} {
puts "\n -- R E P O R T --\n"

bikeComponent::report_Settings
    # get_Component etc:crankset/campagnolo_1984_SuperRecord.svg
}
proc myTest::debugUpdate {} {
    puts "\n -- D E B U G --\n"
        #
    report    
        #
    bikeComponent::set_Config       BottleCage_DownTube    Type        Cage
    bikeComponent::set_Config       BottleCage_SeatTube    Type        BrazeOn
        #
    bikeComponent::set_Component    CrankSet    XZ                      etc:crankset/custom.svg
    bikeComponent::set_Config       CrankSet    SpyderArmCount          3
    bikeComponent::set_Scalar       CrankSet    ArmWidth               10
    bikeComponent::set_Scalar       CrankSet    BottomBracket_Width    35
    bikeComponent::set_Scalar       CrankSet    ChainLine              30
    bikeComponent::set_Scalar       CrankSet    ChainRingOffset        10
    bikeComponent::set_Scalar       CrankSet    Length                180
    bikeComponent::set_Scalar       CrankSet    PedalEye               30
    bikeComponent::set_Scalar       CrankSet    Q-Factor              180
    bikeComponent::set_ListValue    CrankSet    ChainRings             39-53
        #
    bikeComponent::set_Config       HeadSet     Style_HeadTube          Cone
    bikeComponent::set_Config       HeadSet     Type                    Quill
    bikeComponent::set_Scalar       HeadSet     Diameter               55.00
    bikeComponent::set_Scalar       HeadSet     Diameter_HeadTube      39.00
    bikeComponent::set_Scalar       HeadSet     Diameter_HeadTubeBase  59.00
    bikeComponent::set_Scalar       HeadSet     Diameter_Shim          35.00
    bikeComponent::set_Scalar       HeadSet     Height_Bottom          10.50
    bikeComponent::set_Scalar       HeadSet     Height_Top             10.50
    bikeComponent::set_Scalar       HeadSet     Length_HeadTube        125.00    
        #
    bikeComponent::set_Config       FrontFender Style                    any
    bikeComponent::set_Scalar       FrontFender Angle_HeadTube          65.00
    bikeComponent::set_Scalar       FrontFender Angle_Offset           100.00
    bikeComponent::set_Scalar       FrontFender Angle_OffsetStart       29.00
    bikeComponent::set_Scalar       FrontFender Height                  19.00
    bikeComponent::set_Scalar       FrontFender Radius                 206.00
        #                                                             
    bikeComponent::set_Config       RearFender  Style                    any
    bikeComponent::set_Scalar       RearFender  Angle_ChainStay         -7.00
    bikeComponent::set_Scalar       RearFender  Angle_Offset           102.00
    bikeComponent::set_Scalar       RearFender  Angle_OffsetStart        9.00
    bikeComponent::set_Scalar       RearFender  Height                  19.00
    bikeComponent::set_Scalar       RearFender  Radius                 206.00            
        #
    bikeComponent::set_Config       RearHub     Type                     SingleSpeed
    bikeComponent::set_Scalar       RearHub     HubWidth                180.00
        #
    bikeComponent::set_Config       SeatPost    Style                   Miche
    bikeComponent::set_Scalar       SeatPost    Diameter                 35.20
    bikeComponent::set_Scalar       SeatPost    Length                   350.00
    bikeComponent::set_Scalar       SeatPost    PivotOffset              50.00
    bikeComponent::set_Scalar       SeatPost    Setback                  35.00
        #
    bikeComponent::set_Config       Stem        Style                   Quill
    bikeComponent::set_Scalar       Stem        Angle                   15.00
    bikeComponent::set_Scalar       Stem        Length                 130.00        
        #
    #
    # get_Component etc:crankset/campagnolo_1984_SuperRecord.svg
}
    #
#-------------------------------------------------------------------------
    #
myTest::main
    #
bikeComponent::init
    #
#bikeComponent::set_UserDir      C:/Users/manfred/Documents/rattleCAD/components
#bikeComponent::set_CustomDir    C:/Dateien/Eclipse/workspace/rattleCAD_3.4.03/add__Addon/_addons/custom_bertolettiLegend__0.03.kit/etc
    #
bikeComponent::add_ComponentDir user C:/Users/manfred/Documents/rattleCAD/components
bikeComponent::add_ComponentDir cust C:/Dateien/Eclipse/workspace/rattleCAD_3.4.03/add__Addon/_addons/custom_bertolettiLegend__0.03.kit/etc
    #
    #
    # bikeComponent::set_Component    CrankSet    XZ                      etc:crankset/campagnolo_1984_SuperRecord.svg        
    #
.f.nb select .f.nb.f2
update
    #
    # $myTest::cv02 refitStage
${myTest::cvObject} refit
    #
    
    return
${myTest::widgetNS}::updateCompList
    #
    
    
array unset ::APPL_CompLocation 
set dirList [bikeComponent::get_CompLibDirs]
foreach element $dirList {
    set key     [lindex $element 0]
    set dir     [lindex $element 1]
    puts "  childNode ->   $element ->  $key  $dir "
    set ::APPL_CompLocation($key) $dir
}          



    
# set compList    [bikeComponent::get_CompAlternatives Saddle    ]
# set compList    [bikeComponent::get_CompAlternatives CrankSet  ]
# set compList    [bikeComponent::get_CompAlternatives RearBrake ]
#     
#     
#     
#     
# set compSVG     [bikeComponent::get_Component Saddle       etc:saddle/selle_san_marco_concor.svg       ]
# set compSVG     [bikeComponent::get_Component CrankSet     etc:crankset/campagnolo_1984_SuperRecord.svg]
# set compSVG     [bikeComponent::get_Component RearBrake    user:crankset/sram_red_22_2012_03.svg       ]
#     
# set compSVG     [bikeComponent::CrankSet::update]
# set compSVG     [bikeComponent::Stem::update]
# set compSVG     [bikeComponent::SeatPost::update]
# set compSVG     [bikeComponent::HeadSet::update]

# puts " -- \$compSVG --"    
# puts "$compSVG"
# puts "[$compSVG asXML]"
# puts " -- \$compSVG --"

# $myTest::cv02 readSVGNode $compSVG {210 148.5}
    
    #
return    
    
puts "---------------"
puts "    $myTest::cv02"
puts "       procs:  [info procs myTest::cv02::*]"
    #
return
    #
# myTest::compLibrary::setSystemDir [file join $APPL_ROOT_Dir components]
puts "  -- 01--  C:/Dateien/Eclipse/workspace/rattleCAD_3.4.03/bikeGeometry/etc/components"
puts "  -- 01--  [file join $APPL_ROOT_Dir components]"
puts "   -> $bikeComponent::libWidget::dir_System"
puts "   -> $bikeComponent::libWidget::dir_User"
puts "   -> $bikeComponent::libWidget::dir_Custom"


