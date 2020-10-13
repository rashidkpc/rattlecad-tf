 ##+##########################################################################te
 #
 # package: rattleCAD   ->  lib_config.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 # ---------------------------------------------------------------------------
 #  namespace:  myGUI::view::configPanel
 # ---------------------------------------------------------------------------
 #
 #

namespace eval myGUI::view::configPanel {

    variable    cfg_Position    {}

    variable    rdials_list     {}
    variable    cboxList        {}

    variable    configValue
    array set   configValue     {}

    variable    componentList   {}

    variable    objectFrameParts {}
    variable    objectComponents {}

        #
    variable _viewValue     ;# container for current paramteter to be updated
    upvar myGUI::view::viewValue _viewValue
        #
}


    #-------------------------------------------------------------------------
    #  create config widget
    #
    # proc create {master w {mode {}}}
proc myGUI::view::configPanel::create {} {
    # ->
    # return
    
    variable cfg_Position

    set master . 
    set w    .cfg
    
        # -----------------
        # master window information
    set root_xy [split  [wm geometry $master] +]
    set root_w  [winfo width $master]
    set root_x  [lindex $root_xy 1]
    set root_y  [lindex $root_xy 2]
        #
    set pos_x   [expr $root_x - 20 + $root_w - 200]
    set pos_y   [expr $root_y - 10 + 150]
        #
    set cfg_Position [list $root_x $root_y $root_w [expr $root_x+8+$root_w] 0 ]
        #
        # -----------------
        # check if window exists
    if {[winfo exists $w]} {
            # restore if hidden
            # puts "   ... $w allready exists!"
        wm geometry     $w +$pos_x+$pos_y
        wm deiconify    $w
        wm deiconify    $master
        focus           $w
        return
    }
        #
        # -----------------
        # create a toplevel window to edit the attribute values
        #
    toplevel    $w
        #
        # create iconBitmap  -----
    if {$::tcl_platform(platform) == {windows}} {
        wm iconbitmap $w [file join $::APPL_Config(BASE_Dir) tclkit.ico]
    } else {
        wm iconphoto  $w [image create photo ::myGUI::view::configPanel::img_icon16 -format gif -file [file join $::APPL_Config(BASE_Dir)  icon16.gif] ]
    }
        #
        # -----------------
        # create content
    create_Content  $w    
        #
        # -----------------
        #
    bind $w         <Configure> [list [namespace current]::register_relative_position     $master $w]
    bind $master    <Configure> [list [namespace current]::reposition_to_master           $master $w]
        #
        #
    wm deiconify    $master
        #
    wm geometry     $w +$pos_x+$pos_y
    wm title        $w "Configuration Panel"
    wm transient    $w $master  
        #
        # wm attributes   $w -toolwindow
        #
    focus           $w
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  create config Content
    #
proc myGUI::view::configPanel::create_Content {w} {

        # -----------------
        #   clean before create
    catch {destroy $w.f}

        # -----------------
        # reset value list
    array unset [namespace current]::configValue
        # -----------------
        #   initiate all tags and values
        # -----------------
        #   create notebook
    pack [  frame $w.f ]
        #
    set nb_Config   [ ttk::notebook $w.f.nb ]
        pack $nb_Config     -expand no -fill both
    $nb_Config add [frame $nb_Config.geometry]      -text "Geometry"
    $nb_Config add [frame $nb_Config.frameDetail]   -text " Frame "
    $nb_Config add [frame $nb_Config.frameCheck]    -text " Check "
    $nb_Config add [frame $nb_Config.bikeComp]      -text " Mockup "

        # -----------------
        # add content
    add_Basic           $nb_Config.geometry
    $nb_Config select   $nb_Config.frameDetail
        #
    add_FrameDetails    $nb_Config.frameDetail
    $nb_Config select   $nb_Config.frameCheck
        #
    add_FrameCheck      $nb_Config.frameCheck
    $nb_Config select   $nb_Config.bikeComp
        #
    add_BikeComponents  $nb_Config.bikeComp
    $nb_Config select   $nb_Config.geometry

        
        # -----------------
        #
    bind $nb_Config <<NotebookTabChanged>> [list [namespace current]::bind_NotebookTabChanged  $nb_Config]

        
        # -----------------
        #
    wm resizable    $w  0 0
        #


        # -----------------
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  add content 01
    #
proc myGUI::view::configPanel::add_Basic {w} {
    
        
        #
        # add content
        #
    set     menueFrame  [ frame $w.f_menue  -relief flat -bd 1]
        pack    $menueFrame         -side top  -fill x  -expand no


        # -----------------
        #   build frame
    frame           $menueFrame.sf -relief flat -bd 1
        pack $menueFrame.sf         -side top  -fill x  -expand yes


        # -----------------
        #   Concept - Primary
    ttk::labelframe $menueFrame.sf.lf_01            -text "Base Concept - Primary Values"
        pack $menueFrame.sf.lf_01                   -side top  -fill x  -expand yes  -pady 2
            create_configEdit $menueFrame.sf.lf_01      Scalar:Geometry/HandleBar_Distance      0.20  orangered     ;# Personal(HandleBar_Distance)    
            create_configEdit $menueFrame.sf.lf_01      Scalar:Geometry/HandleBar_Height        0.20  orangered     ;# Personal(HandleBar_Height)      
            create_configEdit $menueFrame.sf.lf_01      Scalar:Geometry/Saddle_Distance         0.20  orangered     ;# Personal(Saddle_Distance)       
            create_configEdit $menueFrame.sf.lf_01      Scalar:Geometry/Saddle_Height           0.02  orangered     ;# Personal(Saddle_Height)         
            create_configEdit $menueFrame.sf.lf_01      Scalar:Geometry/Inseam_Length           0.20  darkviolet    ;# Personal(InnerLeg_Length)       
            create_configEdit $menueFrame.sf.lf_01      Scalar:TopTube/PivotPosition            0.20  darkviolet    ;# Custom(TopTube/PivotPosition)   

        # -----------------
        #   Concept
    ttk::labelframe    $menueFrame.sf.lf_02         -text "Base Concept - Secondary Values"
        pack $menueFrame.sf.lf_02                   -side top  -fill x  -expand yes  -pady 2
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/Fork_Rake                       0.20  darkred       ;# Component(Fork/Rake)            
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/Fork_Height                     0.20  darkred       ;# Component(Fork/Height)          
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/HeadTube_Angle                  0.02  darkred       ;# Custom(HeadTube/Angle)          
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/Stem_Angle                      0.10  darkred       ;# Component(Stem/Angle)           
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/Stem_Length                     0.20  darkred       ;# Component(Stem/Length)          
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/ChainStay_Length                0.20  darkred       ;# Custom(WheelPosition/Rear)      
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/BottomBracket_Depth             0.20  darkred       ;# Custom(BottomBracket/Depth)     
            create_configEdit $menueFrame.sf.lf_02      Scalar:Geometry/BottomBracket_Offset_Excenter   0.20  darkred       ;# Custom(BottomBracket/Depth)     
            create_configEdit $menueFrame.sf.lf_02      Scalar:SeatPost/Setback                         1.00  darkred       ;# Component(SeatPost/Setback)     
            create_configEdit $menueFrame.sf.lf_02      Scalar:SeatPost/PivotOffset                     1.00  darkred       ;# Component(SeatPost/Setback)     
            create_configEdit $menueFrame.sf.lf_02      Scalar:Saddle/Height                            1.00  darkred       ;# Component(SeatPost/Setback)     
            
        # -----------------
        #   Alternatives
    ttk::labelframe    $menueFrame.sf.lf_03         -text "Base Concept - Alternative Values"
        pack $menueFrame.sf.lf_03                   -side top  -fill x  -expand yes  -pady 2
            create_configEdit $menueFrame.sf.lf_03      Scalar:Geometry/TopTube_LengthVirtual   0.20  darkblue          ;#Result(Length/TopTube/VirtualLength)  
            create_configEdit $menueFrame.sf.lf_03      Scalar:Geometry/FrontWheel_x            0.20  darkblue          ;#Result(Length/FrontWheel/horizontal)  
            create_configEdit $menueFrame.sf.lf_03      Scalar:Geometry/FrontWheel_xy           0.20  darkblue          ;#Result(Length/FrontWheel/diagonal)    
            create_configEdit $menueFrame.sf.lf_03      Scalar:Geometry/BottomBracket_Height    0.20  darkblue          ;#Result(Length/BottomBracket/Height)   
            create_configEdit $menueFrame.sf.lf_03      Scalar:Geometry/Saddle_BB               0.20  darkblue          ;#Result(Length/Saddle/SeatTube_BB)     
            
        # -----------------
        #   Wheels
    ttk::labelframe $menueFrame.sf.lf_04            -text "Wheels"
        pack $menueFrame.sf.lf_04                   -side top  -fill x  -pady 2
            set listBoxContent [myGUI::control::getListBoxContent  SELECT_Rim]
                #
            create_config_cBox  $menueFrame.sf.lf_04    Scalar:Geometry/RearRim_Diameter        $listBoxContent         ;# Component(Wheel/Rear/RimDiameter) 
            create_configEdit   $menueFrame.sf.lf_04    Scalar:Geometry/RearTyre_Height         0.20                                          ;# Component(Wheel/Rear/TyreHeight)  
            create_config_cBox  $menueFrame.sf.lf_04    Scalar:Geometry/FrontRim_Diameter       $listBoxContent         ;# Component(Wheel/Front/RimDiameter)
            create_configEdit   $menueFrame.sf.lf_04    Scalar:Geometry/FrontTyre_Height        0.20                                          ;# Component(Wheel/Front/TyreHeight) 
  
}
    #-------------------------------------------------------------------------
    #  add content 02
    #
proc myGUI::view::configPanel::add_FrameDetails {w} {

    variable _viewValue
    variable objectFrameParts
        #
        # add content
        #
    set     menueFrame    [ frame $w.f_menue    -relief flat -bd 1]
    pack     $menueFrame \
        -fill x  -side top  -expand no


        # -----------------
        #   build frame
    frame           $menueFrame.sf -relief flat -bd 1
        pack $menueFrame.sf         -side top  -fill x  -expand yes


        # -----------------
        #   Tube Details
    ttk::labelframe    $menueFrame.sf.lf_01        -text "Tube Details"
        #
    pack $menueFrame.sf.lf_01                  -side top  -fill x  -expand yes  -pady 2
        #
    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube - Length}             Scalar:HeadTube/Length              0.20  darkred       ;# FrameTubes(HeadTube/Length)     
    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube-TopTube - Angle}      Scalar:Geometry/HeadLug_Angle_Top   0.02  darkblue      ;# Result(Angle/HeadTube/TopTube)  
    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube-TopTube - Offset}     Scalar:TopTube/OffsetHT             0.20  darkred       ;# Custom(TopTube/OffsetHT)        
    create_configEdit_title $menueFrame.sf.lf_01    {HeadTube-DownTube - Offset}    Scalar:DownTube/OffsetHT            0.20  darkred       ;# Custom(DownTube/OffsetHT)       
    create_configEdit_title $menueFrame.sf.lf_01    {HeadSet - BottomHeight}        Scalar:HeadSet/Height_Bottom        0.20  darkred       ;# Component(HeadSet/Height/Bottom)
    create_configEdit_title $menueFrame.sf.lf_01    {SeatTube - Extension}          Scalar:SeatTube/Extension           0.20  darkred       ;# Custom(SeatTube/Extension)      
    create_configEdit_title $menueFrame.sf.lf_01    {TopTube-SeatStay - Offset}     Scalar:SeatStay/OffsetTT            0.20  darkred       ;# Custom(SeatStay/OffsetTT)       
    create_configEdit_title $menueFrame.sf.lf_01    {TopTube - Angle}               Scalar:Geometry/TopTube_Angle       0.20  darkred       ;# Custom(TopTube/Angle)           
    create_configEdit_title $menueFrame.sf.lf_01    {DownTube-BB - Offset}          Scalar:DownTube/OffsetBB            0.20  darkred       ;# Custom(DownTube/OffsetBB)       


        # -----------------
        #   Frame Parts
    ttk::labelframe    $menueFrame.sf.lf_09        -text "Frame & Fork Parts"
        #
        pack $menueFrame.sf.lf_09                 -side top  -fill x  -expand yes  -pady 2
        #
    set compList {  Component:RearDropout
                    Config:Fork
                    Component:ForkCrown
                    Component:ForkDropout}
        #
    set i 0
    foreach valueKey $compList {
            #
        foreach {arrayName arrayKey} [split $valueKey :] break
        set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
        array set _viewValue    [list $valueKey $currentValue]
            #
        set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        set labelString         "$arrayName: $arrayKey"
            #
            
            #
        set fileFrame [frame $menueFrame.sf.lf_09.f_$i]
            #
        incr i 1
        switch -exact $valueKey {
            Config:Fork {
                label $fileFrame.lb -text $labelString
                set listBoxContent [myGUI::control::getListBoxContent SELECT_ForkType]
                foreach entry $listBoxContent {
                    puts "         ... $entry"
                }
            }
            default {
                label $fileFrame.lb -text $labelString
                set listBoxContent [myGUI::control::getListBoxContent SELECT_File $valueKey]
            }
        }
            #
        ttk::combobox $fileFrame.cb \
                -textvariable $varName \
                -values $listBoxContent \
                -width 30
            pack $fileFrame     -fill x -expand yes  -pady 2
            pack $fileFrame.cb  -side right
            pack $fileFrame.lb  -side left
            #
        bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::bind_ComboBoxSelected %W cv_frameParts $valueKey select]
        bind $fileFrame.cb <ButtonPress>        [list [namespace current]::bind_ComboBoxSelected %W cv_frameParts $valueKey update]
            #
    }
        #
    if {$objectFrameParts != {}} {
        $objectFrameParts destroyCanvas
    }
        #
    set cvObject    [cad4tcl::new  $menueFrame.sf.lf_09  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
        #
    set objectFrameParts    $cvObject
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  add content 03
    #
proc myGUI::view::configPanel::add_FrameCheck {w} {

    variable _viewValue
        #
        #
        # add content
        #
    set     menueFrame    [ frame $w.f_menue    -relief flat -bd 1]
    pack     $menueFrame        -fill x  -side top  -expand no


        # -----------------
        #   build frame
    frame             $menueFrame.sf -relief flat -bd 1
        pack $menueFrame.sf     -side top  -fill x  -expand yes


        # -----------------
        #   Concept - Primary
    ttk::labelframe $menueFrame.sf.lf_06        -text "Check Frame Angles"
        pack $menueFrame.sf.lf_06               -side top  -fill x  -expand yes  -pady 2
            create_configEdit_title $menueFrame.sf.lf_06  {HeadTube/TopTube}            Scalar:Lugs/HeadLug_Top_Angle                   0.10    darkred      ;# Lugs(HeadTube/TopTube/Angle/value)            
            create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar:Lugs/HeadLug_Top_Tolerance               0.10                 ;# Lugs(HeadTube/TopTube/Angle/plus_minus)       
            create_configEdit_title $menueFrame.sf.lf_06  {HeadTube/DownTube}           Scalar:Lugs/HeadLug_Bottom_Angle                0.10    darkred      ;# Lugs(HeadTube/DownTube/Angle/value)           
            create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar:Lugs/HeadLug_Bottom_Tolerance            0.10                 ;# Lugs(HeadTube/DownTube/Angle/plus_minus)      
            create_configEdit_title $menueFrame.sf.lf_06  {BottomBracket/DownTube}      Scalar:Lugs/BottomBracket_DownTube_Angle        0.10    darkred      ;# Lugs(BottomBracket/DownTube/Angle/value)      
            create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar:Lugs/BottomBracket_DownTube_Tolerance    0.10                 ;# Lugs(BottomBracket/DownTube/Angle/plus_minus) 
            create_configEdit_title $menueFrame.sf.lf_06  {BottomBracket/ChainStay}     Scalar:Lugs/BottomBracket_ChainStay_Angle       0.10    darkred      ;# Lugs(BottomBracket/ChainStay/Angle/value)     
            create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar:Lugs/BottomBracket_ChainStay_Tolerance   0.10                 ;# Lugs(BottomBracket/ChainStay/Angle/plus_minus)
            create_configEdit_title $menueFrame.sf.lf_06  {RearDropOut}                 Scalar:Lugs/RearDropOut_Angle                   0.10    darkred      ;# Lugs(RearDropOut/Angle/value)                 
            create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar:Lugs/RearDropOut_Tolerance               0.10                 ;# Lugs(RearDropOut/Angle/plus_minus)            
            create_configEdit_title $menueFrame.sf.lf_06  {SeatTube/SeatStay}           Scalar:Lugs/SeatLug_SeatStay_Angle              0.10    darkred      ;# Lugs(SeatTube/SeatStay/Angle/value)           
            create_configEdit_title $menueFrame.sf.lf_06    {      Tolerance +/-}       Scalar:Lugs/SeatLug_SeatStay_Tolerance          0.10                 ;# Lugs(SeatTube/SeatStay/Angle/plus_minus)      

                #
            frame $menueFrame.sf.lf_06.bt_f        
                pack $menueFrame.sf.lf_06.bt_f               -side top  -fill x  -expand yes  -pady 5
            ttk::button  $menueFrame.sf.lf_06.bt_f.bt_check      -text {switch: check Frame Angles}  -width 30   -command [namespace current]::check_TubingAngles
                pack $menueFrame.sf.lf_06.bt_f.bt_check     -side right -fill both -expand yes
                
                

        # -----------------
        #   Rendering
    ttk::labelframe $menueFrame.sf.lf_02        -text "Check Fender"
    pack $menueFrame.sf.lf_02               -side top  -fill x  -expand yes  -pady 2
    set entryList { {Fender Front}      Config:FrontFender              SELECT_Binary_OnOff  \
                    {Fender Rear}       Config:RearFender               SELECT_Binary_OnOff  \
                }
        #
    set i 10
    foreach {label valueKey listName} $entryList {
                #
            incr i 1
            set optionFrame [frame $menueFrame.sf.lf_02.f___$i]
            label $optionFrame.lb -text "  $label"
                #
            foreach {arrayName arrayKey} [split $valueKey :] break
            set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
            array set _viewValue    [list $valueKey $currentValue]
                #
            set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
                #
            set listBoxContent      [ myGUI::control::getListBoxContent $listName]
                #
            ttk::combobox $optionFrame.cb \
                    -textvariable $varName \
                    -values $listBoxContent \
                    -width 30
                #
            bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::::bind_ComboBoxSelected %W cv_Components $valueKey select]
            bind $optionFrame.cb <ButtonPress>        [list [namespace current]::::bind_ComboBoxSelected %W cv_Components $valueKey update]
                #
            pack $optionFrame -fill x -expand yes  -pady 2
            pack $optionFrame.cb -side right
            pack $optionFrame.lb -side left
    }                        
                
        # -----------------
        #   Rendering
    ttk::labelframe $menueFrame.sf.lf_03    -text "Check DownTube Bottle"
    pack $menueFrame.sf.lf_03               -side top  -fill x  -expand yes  -pady 2
    set entryList { {BottleCage ST}     Config:BottleCage_SeatTube          SELECT_BottleCage \
                    {BottleCage DT}     Config:BottleCage_DownTube          SELECT_BottleCage \
                    {BottleCage DT L}   Config:BottleCage_DownTube_Lower    SELECT_BottleCage  \
                }
        #
    set i 10
    foreach {label valueKey listName} $entryList {
                #
            incr i 1
            set optionFrame [frame $menueFrame.sf.lf_03.f___$i]
            label $optionFrame.lb -text "  $label"
                #
            foreach {arrayName arrayKey} [split $valueKey :] break
            set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
            array set _viewValue    [list $valueKey $currentValue]
                #
            set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]

                #
            set listBoxContent      [myGUI::control::getListBoxContent $listName]
                #
            ttk::combobox $optionFrame.cb \
                    -textvariable $varName \
                    -values $listBoxContent \
                    -width 30
                #
            bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::::bind_ComboBoxSelected %W cv_Components $valueKey select]
            bind $optionFrame.cb <ButtonPress>        [list [namespace current]::::bind_ComboBoxSelected %W cv_Components $valueKey update]
                #
            pack $optionFrame -fill x -expand yes  -pady 2
            pack $optionFrame.cb -side right
            pack $optionFrame.lb -side left
    }                        
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  add content 04
    #
proc myGUI::view::configPanel::add_BikeComponents {w} {

    variable _viewValue
    variable objectComponents
        #
        # add content
        #
    set     menueFrame  [ frame $w.f_menue  -relief flat -bd 1]
    pack    $menueFrame \
        -fill both -side top -expand yes


        # -----------------
        #   build frame
    frame           $menueFrame.sf -relief flat -bd 1
    pack $menueFrame.sf         -side top  -fill x  -expand yes


        # -----------------
        #   Components
    ttk::labelframe    $menueFrame.sf.lf_01        -text "Components"
    pack $menueFrame.sf.lf_01                  -side top  -fill x  -expand yes  -pady 2

    set compList {  Component:HandleBar \
                    Component:Saddle \
                    Component:CrankSet \
                    Component:FrontBrake \
                    Component:RearBrake \
                    Component:FrontCarrier \
                    Component:RearCarrier \
                    Component:FrontDerailleur \
                    Component:RearDerailleur }
    set i 0
    foreach valueKey $compList {
            #
        foreach {arrayName arrayKey} [split $valueKey :] break
        set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
        array set _viewValue    [list $valueKey $currentValue]
            #
        set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        set labelString         "$arrayName: $arrayKey"
            #
        incr i 1
            #
        set fileFrame           [frame $menueFrame.sf.lf_01.f_$i]
        label $fileFrame.lb -text $labelString
        set listBoxContent      [myGUI::control::getListBoxContent SELECT_File $valueKey]
            #
        ttk::combobox $fileFrame.cb \
                -textvariable $varName \
                -values $listBoxContent \
                -width 30
            #
        pack $fileFrame     -fill x -expand yes  -pady 2
        pack $fileFrame.cb  -side right
        pack $fileFrame.lb  -side left
            #
        bind $fileFrame.cb <<ComboboxSelected>> [list [namespace current]::::bind_ComboBoxSelected %W cv_Components $valueKey select]
        bind $fileFrame.cb <ButtonPress>        [list [namespace current]::::bind_ComboBoxSelected %W cv_Components $valueKey update]
    }
        #
    if {$objectComponents != {}} {
        $objectComponents destroyCanvas
    }
        #
    set cvObject    [cad4tcl::new  $menueFrame.sf.lf_01  280  210  passive  1.0  0  -bd 2  -bg white  -relief sunken]
        #
    set objectComponents    $cvObject
        #


    ttk::labelframe $menueFrame.sf.lf_02    -text "Config"
    pack $menueFrame.sf.lf_02               -side top  -fill x -pady 2

        # -----------------
        #   Rendering
    set entryList { \
                    {BottleCage DT L}   Config:BottleCage_DownTube_Lower SELECT_BottleCage \
                    {BottleCage DT}     Config:BottleCage_DownTube       SELECT_BottleCage \
                    {BottleCage ST}     Config:BottleCage_SeatTube       SELECT_BottleCage \
                    {Fork }             Config:Fork                      SELECT_ForkType  \
                    {FrontBrake}        Config:FrontBrake                SELECT_BrakeType \
                    {FrontFender}       Config:FrontFender               SELECT_Binary_OnOff  \
                    {RearBrake}         Config:RearBrake                 SELECT_BrakeType \
                    {RearFender}        Config:RearFender                SELECT_Binary_OnOff  \
                    {Stem}              Config:Stem                      SELECT_StemType  \
                }
    set i 10
    foreach {label valueKey listName} $entryList {
            #
        incr i 1
        set optionFrame [frame $menueFrame.sf.lf_02.f___$i]
        label $optionFrame.lb -text "          $label"
            #
        foreach {arrayName arrayKey} [split $valueKey :] break
        set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
        array set _viewValue    [list $valueKey $currentValue]
            #
        set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        set labelString         "$arrayName: $arrayKey"
            #
        set listBoxContent      [myGUI::control::getListBoxContent   $listName]
            #
        ttk::combobox $optionFrame.cb \
                -textvariable $varName \
                -values $listBoxContent \
                -width 30
            #
        bind $optionFrame.cb <<ComboboxSelected>> [list [namespace current]::bind_ComboBoxSelected %W cv_Components $valueKey select]
        bind $optionFrame.cb <ButtonPress>        [list [namespace current]::bind_ComboBoxSelected %W cv_Components $valueKey update]
            #
        pack $optionFrame -fill x -expand yes  -pady 2
        pack $optionFrame.cb -side right
        pack $optionFrame.lb -side left
    }


    # -----------------
    #   Update Values

}
    #-------------------------------------------------------------------------
    #  create config_line
    #
proc myGUI::view::configPanel::updateCanvas {targetCanvas compName compKey} {
    variable objectComponents
    variable objectFrameParts
    
    set compType [lindex [split $compName :] end]
    set compPath [myGUI::control::get_CompPath $compType $compKey]
        
        puts ""
        puts "   -------------------------------"
        puts "    updateCanvas"
        puts "       targetCanvas:   $targetCanvas"
        puts "       compName:       $compName"
        puts "       compKey:        $compKey"
        puts "       compType:       $compType"
        puts "       compPath:       $compPath"
            #
            #
        
    if {$compPath != {}} {
        switch -regexp -- $targetCanvas {
            cv_frameParts {
                # puts "            ... $objectFrameParts"
                $objectFrameParts       deleteContent
                set __my_Component__    [$objectFrameParts create svg {0 0} [list -svgFile $compPath  -angle 0  -tags __Decoration__]]
                $objectFrameParts       fitContent  $__my_Component__
                $objectFrameParts       fit
            }
            cv_Components {
                # puts "            ... $objectComponents"
                $objectComponents       deleteContent
                set __my_Component__    [$objectComponents create svg {0 0} [list -svgFile $compPath  -angle 0  -tags __Decoration__]]
                $objectComponents       fitContent  $__my_Component__
                $objectComponents       fit
            }
            default {
                puts " ... do hots wos: $targetCanvas"
            }
        }
    }                
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  postion config panel to master window
    #
proc myGUI::view::configPanel::reposition_to_master {master w} {

    variable cfg_Position

    if {![winfo exists $w]} return

    # wm deiconify   $w

    set root_xy [split  [wm geometry $master] +]
    set root_w    [winfo  width $master]
    set root_x    [lindex $root_xy 1]
    set root_y    [lindex $root_xy 2]

    set update no

    if {$root_x != [lindex $cfg_Position 0]} {set update yes}
    if {$root_y != [lindex $cfg_Position 1]} {set update yes}
    if {$root_w != [lindex $cfg_Position 2]} {set update resize}

    switch $update {
        yes {
            set dx [lindex $cfg_Position 3]
            set dy [lindex $cfg_Position 4]
              # puts "   -> reposition_to_master  - $w +[expr $root_x+$dx]+[expr $root_y+$dy]"
            catch {wm geometry    $w +[expr $root_x+$dx]+[expr $root_y+$dy]}
            }
        resize {
            set d_root [expr $root_w - [lindex $cfg_Position 2]]
            set dx [ expr [lindex $cfg_Position 3] + $d_root ]
            set dy [lindex $cfg_Position 4]
            catch {wm geometry    $w +[expr $root_x+$dx]+[expr $root_y+$dy]}
        }
    }
}
    #-------------------------------------------------------------------------
    #  register_relative_position
    #
proc myGUI::view::configPanel::register_relative_position {master w} {

    variable cfg_Position

    set root_xy [split  [wm geometry $master] +]
    set root_w  [winfo width $master]
    set root_x  [lindex $root_xy 1]
    set root_y  [lindex $root_xy 2]
        # puts "    master: $master: $root_x  $root_y"

    set w_xy [split  [wm geometry $w] +]
        # puts "    w   .... $w_xy"
    set w_x [lindex $w_xy 1]
    set w_y [lindex $w_xy 2]
        # puts "    w   ..... $w: $w_x  $w_y"
    set d_x     [ expr $w_x-$root_x]
    set d_y     [ expr $w_y-$root_y]
        # puts "    w   ..... $w: $d_x  $d_y"
        # puts "    w   ..... $root_x $root_y $d_x $d_y"
    set cfg_Position [list $root_x $root_y $root_w $d_x $d_y ]
        # puts "     ... register_relative_position $cfg_Position"
}
    #-------------------------------------------------------------------------
    #  create config_line
    #
proc myGUI::view::configPanel::create_config_cBox {w valueKey contentList} {

    variable _viewValue
    variable    cboxList
        #
    puts "  myGUI::view::configPanel::create_config_cBox $w $valueKey $contentList"

    foreach {arrayName arrayKey} [split $valueKey :] break
    set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
    array set _viewValue    [list $valueKey $currentValue]

    if 0 {
        variable _currentValue
        variable _updateValue
            #
            # variable    configValue
            #set _array [lindex [split $_arrayName (] 0]
            #set _name [lindex [split $_arrayName ()] 1]


            #set xPath       [format "%s/%s" $_array $_name]
            #eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
            #set labelString $_name
        
        set xPath $_arrayName
            # eval set configValue($xPath)    [format "$%s(%s)" $_array $_name]
            # puts "   -> [format "$%s(%s)" $_array $_name]     <--- $xPath  <- $_array $_name "
        puts "   -> \$xPath ... $xPath"
            # eval set configValue($xPath)    [format "$%s::%s(%s)" project $_array $_name]
            # set labelString $_name
        set xPathNodes  [lrange [split $xPath /] 1 end]
        set labelString "[lindex $xPathNodes 0]:  [lrange $xPathNodes 1 end]"
    }
        #
    set valueKeyNodes   [split $arrayKey /]
    set labelString     "[lindex $valueKeyNodes 0]:  [lrange $valueKeyNodes 1 end]"

    
        # --------------
            # puts "    .. check ..     $xPath    "
            # puts "    .. check ..     [namespace current]::configValue($xPath)    "
    set cboxCount [llength $cboxList]
            # puts "      ... \$cboxCount $cboxCount"
            # puts "      ... $rdialCount"
            # set       $entryVar $current
            # puts "   ... \$entryVar [list [format "$%s" $entryVar]]"

    set cfgFrame    [frame   [format "%s.fcbx_%s" $w $cboxCount]]
    pack    $cfgFrame -fill x

    if {[string length $labelString] > 29} {
        set labelString "[string range $labelString 0 26] .."
    }
    
    set varName     [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
    # set textvariable [format "%s::%s(%s)"  [namespace current] _updateValue $xPath]
    # puts "  $textvariable"
    
    puts "     create_config_cBox:  \$varName $varName"                  
    puts "     create_config_cBox:  $currentValue"
        #set     textvariable [format "%s(%s)"  $_array $_name]
        # set     textvariable [format "%s::%s(%s)"  [namespace current] $_array $_name]
    
    
    label   $cfgFrame.lb    -text "   $labelString:"      \
                    -bd 1  -anchor w

    ttk::combobox $cfgFrame.cb \
                    -textvariable $varName \
                    -values $contentList    \
                    -width 17 \
                    -height 10 \
                    -justify right 
                    
                    #-postcommand [list eval set [namespace current]::oldValue \$[namespace current]::configValue($xPath)]


    lappend cboxList $cfgFrame.cb

    bind $cfgFrame.cb <<ComboboxSelected>>      [list [namespace current]::bind_ListBoxSelection %W $valueKey]
        # bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" [namespace current] _updateValue $textvariable]]
        # bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" [namespace current] $_array $_name]]
        # bind $cfgFrame.cb <<ComboboxSelected>>     [list [namespace current]::check_Value %W $xPath [format "%s::%s(%s)" project $_array $_name]]

    pack      $cfgFrame.lb  -side left
    pack      $cfgFrame.cb  -side right  -fill x
}
    #-------------------------------------------------------------------------
    #  create config_line
    #
proc myGUI::view::configPanel::create_configEdit_title {w title _arrayName scale {color {}}} {
    set cDial [create_configEdit $w $_arrayName $scale $color]
    $cDial.lb   configure -text "   $title"
}
    #-------------------------------------------------------------------------
    #  create config_line
    #
proc myGUI::view::configPanel::create_configEdit {w valueKey scale {color {}}} {

    variable _viewValue
        #
    puts "  myGUI::view::configPanel::create_configEdit $w $valueKey $scale $color"
        #
    foreach {arrayName arrayKey} [split $valueKey :] break
    set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
    array set _viewValue    [list $valueKey $currentValue]
        #
    variable    rdials_list
        #
    set valueKeyNodes   [split $arrayKey /]
    set labelString     "[lindex $valueKeyNodes 0]:  [lrange $valueKeyNodes 1 end]"
        #
        # --------------
    set rdialCount  [llength $rdials_list]
        #
    set cfgFrame    [frame   [format "%s.fscl_%s" $w $rdialCount]]
    pack    $cfgFrame -fill x -expand yes
        #
    if {[string length $labelString] > 33} {
        #set labelString "[string range $labelString 0 29] .."
    }
    if {[string length $labelString] > 40} {
        set labelString "[string range $labelString 0 36] .."
    }
    set varName     [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        #
        # puts "     create_configEdit:  \$varName $varName"                  
        # puts "     create_configEdit:  $currentValue"
        #
    label   $cfgFrame.sp    -text ""      \
                    -bd 1
    label   $cfgFrame.lb    -text "   $labelString "      \
                    -width 38  \
                    -bd 1  -anchor w

    entry   $cfgFrame.cfg    \
                    -textvariable $varName \
                    -width 10  \
                    -bd 1  -justify right -bg white

    

    if {$color != {}} {
        $cfgFrame.lb  configure -fg $color
        $cfgFrame.cfg configure -fg $color
    }


    lappend rdials_list [expr [llength $rdials_list] + 1]

    bind $cfgFrame.cfg <Enter>      [list [namespace current]::bind_EntryEnter  %W]
    bind $cfgFrame.cfg <Leave>      [list [namespace current]::bind_EntryLeave  %W]
    bind $cfgFrame.cfg <Return>     [list [namespace current]::bind_EntryLeave  %W]

    bind $cfgFrame.cfg <Double-1>   [list [namespace current]::bind_EntryDouble %W]  ;#

    bind $cfgFrame.cfg <MouseWheel> [list [namespace current]::bind_EntryMouseWheel %W %D   $scale]  ;# move up/down
    bind $cfgFrame.cfg <Key-Up>     [list [namespace current]::bind_EntryKeyUpDown  %W up   $scale]
    bind $cfgFrame.cfg <Key-Down>   [list [namespace current]::bind_EntryKeyUpDown  %W down $scale]


    pack      $cfgFrame.cfg  $cfgFrame.lb $cfgFrame.sp  -side right
    pack configure $cfgFrame.sp  -fill x
    pack configure $cfgFrame.cfg -padx 2
            # pack      $cfgFrame.sp  $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  -side left  -fill x
            # pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl -side left  -fill x
            # pack      $cfgFrame.lb  $cfgFrame.cfg  $cfgFrame.f  $cfgFrame.f.scl $cfgFrame.bt   -side left  -fill x
            # pack      configure $cfgFrame.f  -padx 2
    return    $cfgFrame
}
    #-------------------------------------------------------------------------
    #
    #
proc myGUI::view::configPanel::bind_ComboBoxSelected {w targetCanvas compType mode} {
        #
    puts "            -- myGUI::view::configPanel::bind_ComboBoxSelected -start--"
    puts "                    $w $targetCanvas $compType $mode"
        #
        # http://www.tek-tips.com/viewthread.cfm?qid=822756&page=42
        # 2010.10.15
    variable        compFile
        #
    set textVar         [$w cget -textvariable]
    set currentValue    [set $textVar]
    set valueKey        [string trim [lindex [split $textVar (] 1] )]
        #
    set compFile        $currentValue
        #
        
        #
    puts ""
    puts "   -------------------------------"
    puts "    bind_ComboBoxSelected"
    puts "       compFile:       $compFile"
    puts "       valueKey:       $valueKey"
    puts "       currentValue:   $currentValue"
    puts "       targetCanvas:   $targetCanvas"
    puts "       mode:           $mode"
        # return
        #
    [namespace current]::updateCanvas $targetCanvas $compType $compFile
        # catch {[namespace current]::updateCanvas $targetCanvas $compType}
        #
        # return
    if {$mode == {select}} {
        myGUI::control::setValue  [list $valueKey $currentValue]
        # myGUI::view::edit::close_allEdit
    }
        #
    puts "            -- myGUI::view::configPanel::bind_ComboBoxSelected ---end--"
        #
}
    #
proc myGUI::view::configPanel::bind_EntryDouble {w} {
        #
    puts "            -- myGUI::view::configPanel::bind_EntryDouble ------start--"
    puts "                    $w"
        #
    update_Entry $w
        #
    puts "            -- myGUI::view::configPanel::bind_EntryLeave ---------end--"
        #
    return
}
proc myGUI::view::configPanel::bind_EntryEnter {w} {
        #
    puts "            -- myGUI::view::configPanel::bind_EntryEnter -------start--"
    puts "                    $w"
        #
    return
        #
}
proc myGUI::view::configPanel::bind_EntryLeave {w} {
        #
    puts "            -- myGUI::view::configPanel::bind_EntryLeave -------start--"
    puts "                    $w"
        #
    update_Entry $w
        #
    puts "            -- myGUI::view::configPanel::bind_EntryLeave ---------end--"
        #
    return
}
proc myGUI::view::configPanel::update_Entry {w} {
        #
    variable _viewValue
        #
    set textVar [$w cget -textvariable]
    set currentValue [set $textVar]
    set valueKey [string trim [lindex [split $textVar (] 1] )]
        #
    puts "           ... \$textVar      $textVar"
    puts "           ... \$currentValue $currentValue"
        #
    array set _viewValue        [list $valueKey $currentValue]
    myGUI::control::setValue    [list $valueKey $currentValue]
        # myGUI::view::edit::close_allEdit
        #
    return
}
    #
proc myGUI::view::configPanel::bind_EntryKeyUpDown {w direction args} {
        #
    puts "            -- myGUI::view::configPanel::bind_EntryKeyUpDown -------start--"
    puts "                    $w $direction $args"
        # --- update value of spinbox ---
    if {$direction eq "up"} {\
        increment_Entry $w increment
    } else {
        increment_Entry $w decrement
    }
    puts "            -- myGUI::view::configPanel::bind_EntryKeyUpDown ---------end--"
}
proc myGUI::view::configPanel::bind_EntryMouseWheel {w value scale args} {
        #
    puts "            -- myGUI::view::configPanel::bind_EntryMouseWheel ------start--"
    puts "                    $w $value $scale $args"
        #
    set textVar [$w cget -textvariable]
    set currentValue [set $textVar]
        #
    set direction 1
    catch {set direction [expr $value / $currentValue]} 
    if {$direction > 0} {
        increment_Entry $w increment
    } else {
        increment_Entry $w decrement
    }
        #
    puts "            -- myGUI::view::configPanel::bind_EntryMouseWheel --------end--"
        #
}
proc myGUI::view::configPanel::increment_Entry {widget direction} {
        #
    set textVar [$widget cget -textvariable]
    set currentValue [set $textVar]
        #
        # puts " --> update_SpinBox  $direction $textVar"
        #
    set key [string trim [lindex [split $textVar (] 1] )]
        # puts "      key -> $key"
    switch -exact $key {
        Config:CrankSet_SpyderArmCount {
            set valueType integer
            set updateValue 1
        }
        default {
            set valueType real
            if {$currentValue < 20} {
                set updateValue 0.1 
            } else {
                set updateValue 1.0
            }
        }
    }
        #
    if {$direction eq "increment"} {\
        set newValue [expr {$currentValue + $updateValue}]\
    } else {\
        set newValue [expr {$currentValue - $updateValue}]\
    }
        #
    if {$valueType eq {real}} {
        set $textVar [format "%.3f" $newValue]
    } else {
        set $textVar [expr int($newValue)]
    }
        #
}
    #
proc myGUI::view::configPanel::bind_NotebookTabChanged {w} {
        #
    puts "            -- myGUI::view::configPanel::bind_NotebookTabChanged -------start--"
    puts "                    $w"
        #
    switch -exact [$w select] {
        {.cfg.f.nb.geometry}    { set target {cv_Custom00} }
        {.cfg.f.nb.frameDetail} { set target {cv_Custom10} }
        {.cfg.f.nb.frameCheck}  { set target {cv_Custom10} }
        {.cfg.f.nb.bikeComp}    { set target {cv_Custom50} }
        default {}
    }
    
    myGUI::gui::selectNotebookTab    $target
}	
proc myGUI::view::configPanel::bind_ListBoxSelection { w valueKey} {
        #
    puts "            -- myGUI::view::configPanel::bind_ListBoxSelection -------start--"
    puts "                    $w $valueKey"
        #
    set _viewValue {}
    set oldValue {}
        #
    switch $valueKey {
        {Scalar:Geometry/RearRim_Diameter} -
        {Scalar:Geometry/FrontRim_Diameter} {
            set oldValue [myGUI::control::getValue $$valueKey]
        }
        default {}
    }
        #
    switch $valueKey {
        {Scalar:Geometry/RearRim_Diameter} -
        {Scalar:Geometry/FrontRim_Diameter}  {
                #
            set textvariable [$w cget -textvariable]
            set textValue    [set $textvariable]
                #
            if {[string range $textValue 0 3] == "----"} {
                set $textvariable $oldValue
                return
            } else {
                set value [string trim [lindex [split $textValue ;] 0]]
                set value [format "%.3f" $value]
                myGUI::control::setValue [list $valueKey $value]
                # myGUI::view::edit::close_allEdit
                return
            }
        }
        default {
            #puts " ... bind_ListBoxSelection: $xPath"
        }
    }
    
    #puts "            -- myGUI::view::configPanel::bind_ListBoxSelection ---------end--"
    
}
    #
    #
proc myGUI::view::configPanel::check_TubingAngles {} {
    myGUI::gui::selectNotebookTab cv_Custom10
    myGUI::cvCustom::updateView   [myGUI::gui::current_notebookTabID]
    myGUI::view::edit::check_TubingAngles
}
    #
    #