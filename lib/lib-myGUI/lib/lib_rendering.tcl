 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_bikeRendering.tcl
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
 #  namespace:  myGUI::rendering
 # ---------------------------------------------------------------------------
 #
 #

namespace eval myGUI::rendering {
    variable    cvObject
}

    # --- check existance of File --- regarding on user/etc
proc myGUI::rendering::checkFileString {fileString} {
    switch -glob $fileString {
        etc:*   {   set svgFile [file join $::APPL_Config(COMPONENT_Dir)         [lindex [split $fileString :] 1] ]}
        user:*  {   set svgFile [file join $::APPL_Config(USER_Dir)/components   [lindex [split $fileString :] 1] ]}
        cust:*  {   set svgFile [file join $::APPL_Config(CUSTOM_Dir)/components [lindex [split $fileString :] 1] ]}
        default {   set svgFile [file join $::APPL_Config(COMPONENT_Dir)         $fileString ]}
    }
        
        #
      # puts "            ... myGUI::rendering::checkFileString: $fileString"
      # puts "                        ... $svgFile"
        #
    if {![file exists $svgFile]} {
            # puts "           ... does not exist, therfore .."
        set svgFile [file join $::APPL_Config(COMPONENT_Dir) default_exception.svg]
    }
        # puts "            ... createDecoration::checkFileString $svgFile"
    return $svgFile
}

proc myGUI::rendering::createDecoration {cvObj BB_Position type {updateCommand {}}} {
        #
    variable    cvObject   $cvObj
        #
    switch $type {
        BottleCage          { createDecoration_BottleCage           $BB_Position    $type   $updateCommand;     return }
        Brake               { createDecoration_Brake                $BB_Position    $type   $updateCommand;     return }
        CarrierFront        { createDecoration_CarrierFront         $BB_Position    $type   $updateCommand;     return }  
        CarrierRear         { createDecoration_CarrierRear          $BB_Position    $type   $updateCommand;     return }  
        Cassette            { createDecoration_Cassette             $BB_Position    $type   $updateCommand;     return }
        Chain               { createDecoration_Chain                $BB_Position    $type   $updateCommand;     return }
        CrankSet            { createDecoration_CrankSet             $BB_Position    $type   $updateCommand;     return }
        DerailleurFront     { createDecoration_DerailleurFront      $BB_Position    $type   $updateCommand;     return }
        DerailleurRear      { createDecoration_DerailleurRear       $BB_Position    $type   $updateCommand;     return }
        DerailleurRear_ctr  { createDecoration_DerailleurRear_ctr   $BB_Position    $type   $updateCommand;     return }
        Fender              { createDecoration_Fender               $BB_Position    $type   $updateCommand;     return }
        Fender_Rep          { createDecoration_Fender_Rep           $BB_Position    $type   $updateCommand;     return }
        FrontWheel          { createDecoration_FrontWheel           $BB_Position    $type   $updateCommand;     return }
        FrontWheel_Rep      { createDecoration_FrontWheel_Rep       $BB_Position    $type   $updateCommand;     return }
        HandleBar           { createDecoration_HandleBar            $BB_Position    $type   $updateCommand;     return }
        HeadSetBottom       { createDecoration_HeadSetBottom        $BB_Position    $type   $updateCommand;     return }
        HeadSetBottom_2     { createDecoration_HeadSetBottom_2      $BB_Position    $type   $updateCommand;     return }
        HeadSetTop          { createDecoration_HeadSetTop           $BB_Position    $type   $updateCommand;     return }
        Label               { createDecoration_Label                $BB_Position    $type   $updateCommand;     return }
        LegClearance_Rep    { createDecoration_LegClearance_Rep     $BB_Position    $type   $updateCommand;     return }
        RearWheel           { createDecoration_RearWheel            $BB_Position    $type   $updateCommand;     return }
        RearWheel_Pos       { createDecoration_RearWheel_Pos        $BB_Position    $type   $updateCommand;     return }
        RearWheel_Rep       { createDecoration_RearWheel_Rep        $BB_Position    $type   $updateCommand;     return }
        Saddle              { createDecoration_Saddle               $BB_Position    $type   $updateCommand;     return }
        SeatPost            { createDecoration_SeatPost             $BB_Position    $type   $updateCommand;     return }
        Stem                { createDecoration_Stem                 $BB_Position    $type   $updateCommand;     return }                    
        default             {}
    }
        #
} 

proc myGUI::rendering::createReference {cvObj BB_Position type args} {
        #
    variable    cvObject   $cvObj
        #
    switch $type {
        FrameCenterLine     { createLine_FrameCenterLines               $BB_Position    $type   [join $args];     return }
        BaseLine            { createLine_BaseLine                       $BB_Position    $type   [join $args];     return }
        CopyReference       { createLine_CopyReference                  $BB_Position    $type   [join $args];     return }
        default             {}
    }
        #
} 


proc myGUI::rendering::createDecoration_Cassette {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create Cassette ----------
    set cassette_OuterTeethCount    28    
    set cassette_InnerTeethCount    [myGUI::model::model_XZ::getScalar RearWheel FirstSprocket]    
        # 
    set cassette_OuterDiameter  [expr $cassette_OuterTeethCount * 12.7 / $vectormath::CONST_PI ]
    set cassette_InnerDiameter  [expr $cassette_InnerTeethCount * 12.7 / $vectormath::CONST_PI ]
    set Hub(position)           [myGUI::model::model_XZ::getPosition    RearWheel   $BB_Position]
        #
    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $cassette_OuterDiameter]     -tags {__Decoration__ __Cassette__}     -fill white
    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $cassette_InnerDiameter]     -tags {__Decoration__ __Cassette__}     -fill white
    if {$updateCommand != {}}   { 
        # myGUI::gui::bind_objectEvent_2  $cvObject   $Chain(object)  group_Chain_Parameter_15
    }
        #
}
proc myGUI::rendering::createDecoration_Chain {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        # --- create Chain -------------
    set Chain(object)           [createChain  $cvObject  $BB_Position]
    $cvObject addtag  __Decoration__ withtag $Chain(object)
    if {$updateCommand != {}} { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $Chain(object)  group_Chain_Parameter_15
    }
        #
}
proc myGUI::rendering::createDecoration_CrankSet {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        
        # --- create Handlebar -------------
    set customType [file tail [myGUI::model::model_XZ::getConfig CrankSet]]
        #
    if {$customType eq {custom.svg}} {
        set myNode  [myGUI::model::model_XZ::getComponent   CrankSet_Custom]
    } else {
        set myNode  [myGUI::model::model_XZ::getComponent   CrankSet]
    }
    set myPosition  [myGUI::model::model_XZ::getPosition    CrankSet   $BB_Position]
    set myAngle     0
        #
    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __CrankSet__ ]]
                     $cvObject addtag    __Decoration__  withtag $myObject
    if {$updateCommand != {}}   { 
        if {$customType eq {custom.svg}} {
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_Crankset_Parameter_16
        } else {
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_CrankSetFile
        }
    }
        #
}
proc myGUI::rendering::createDecoration_DerailleurFront {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create FrontDerailleur --------
    set myPosition  [myGUI::model::model_XZ::getPosition    DerailleurMount_Front   $BB_Position]
    set myNode      [myGUI::model::model_XZ::getComponent   FrontDerailleur]
    set myDirection [myGUI::model::model_XZ::getDirection SeatTube]
    set myAngle     [expr  90 + [vectormath::dirAngle {0 0} $myDirection]]
        #
    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __DerailleurFront__]]
                     $cvObject addtag    __Decoration__  withtag $myObject
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_DerailleurFront_Parameter_17
    }
        #
}
proc myGUI::rendering::createDecoration_DerailleurRear {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create FrontDerailleur --------
    set myPosition  [myGUI::model::model_XZ::getPosition    RearDerailleur   $BB_Position]
    set myNode      [myGUI::model::model_XZ::getComponent   RearDerailleur]
    set myAngle     0
        #
    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __DerailleurRear__]]
                     $cvObject addtag    __Decoration__  withtag $myObject
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_RearDerailleurFile
    }
        #
}
proc myGUI::rendering::createDecoration_DerailleurRear_ctr {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create RearDerailleur --------
    set myPosition  [myGUI::model::model_XZ::getPosition    RearDerailleur     $BB_Position]
    foreach {x y} $myPosition   break
    set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
    $cvObject create line  [list $x1 $y $x2 $y]   -fill gray60  -tags __Decoration__
    $cvObject create line  [list $x $y1 $x $y2]   -fill gray60  -tags __Decoration__
        #
}

proc myGUI::rendering::createDecoration_BottleCage {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # 
    set Config(BottleCage_DT)    [myGUI::model::model_XZ::getConfig BottleCage_DownTube]
    set Config(BottleCage_DT_L)  [myGUI::model::model_XZ::getConfig BottleCage_DownTube_Lower]
    set Config(BottleCage_ST)    [myGUI::model::model_XZ::getConfig BottleCage_SeatTube]
        #

        # --- create BottleCage - SeatTube ----------------
    if {$Config(BottleCage_ST) != {off}} {
        set myNode      [myGUI::model::model_XZ::getComponent   BottleCage_SeatTube]
            # puts $Config(BottleCage_ST)
            # puts [$myNode asXML]
            # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
        set myDirection [myGUI::model::model_XZ::getDirection SeatTube]
        set myAngle     [vectormath::dirAngle {0 0} $myDirection]
        set myPosition  [myGUI::model::model_XZ::getPosition    BottleCage_ST_Base      $BB_Position]
        set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __BottleCage_ST__]]
            #
        $cvObject addtag  __Decoration__ withtag $myObject
            #
        if {$updateCommand != {}}   { 
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_SeatTube_BottleCageFile
        }
    }
        
        # --- create BottleCage - DownTube ----------------
    if {$Config(BottleCage_DT) != {off}} {
        set myNode      [myGUI::model::model_XZ::getComponent   BottleCage_DownTube]
            # puts $Config(BottleCage_ST)
            # puts [$myNode asXML]
            # puts "   ... $Rendering(BottleCage_ST): BottleCage(file)  $BottleCage(file)"
        set myDirection [myGUI::model::model_XZ::getDirection DownTube]
        set myAngle     [expr 180 + [vectormath::dirAngle {0 0} $myDirection]]
        set myPosition  [myGUI::model::model_XZ::getPosition    BottleCage_DT_Top       $BB_Position]
        set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __BottleCage_DT__ ]]
            #
        $cvObject addtag  __Decoration__ withtag $myObject
            #
        if {$updateCommand != {}}   { 
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_DownTube_BottleCageFile
        }
    }
        
        # --- create BottleCage - DownTube - Bottom -------
    if {$Config(BottleCage_DT_L) != {off}} {
        set myNode      [myGUI::model::model_XZ::getComponent   BottleCage_DownTube_Lower]
            #
        set myDirection [myGUI::model::model_XZ::getDirection DownTube]
        set myAngle     [vectormath::dirAngle {0 0} $myDirection]
        set myPosition  [myGUI::model::model_XZ::getPosition    BottleCage_DT_Bottom    $BB_Position]
        set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __BottleCage_DT_L__]]
            #
        $cvObject addtag  __Decoration__ withtag $myObject
            #
        if {$updateCommand != {}}   { 
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_DownTube_BottleCageFileLower
        }
    }
        #
    return
        #
}
proc myGUI::rendering::createDecoration_Brake {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- get Rendering Style
    set cfgFront    [myGUI::model::model_XZ::getConfig FrontBrake]
    set cfgRear     [myGUI::model::model_XZ::getConfig RearBrake]
        # --- create RearBrake -----------------
    if {$cfgRear != {off}} {
          # puts "          ... \$cfgRear $cfgRear"
        switch $cfgRear {
            Rim {
                    set myPosition  [myGUI::model::model_XZ::getPosition    RearBrake_Shoe   $BB_Position]
                    set myNode      [myGUI::model::model_XZ::getComponent   RearBrake]
                    set myDirection [myGUI::model::model_XZ::getDirection   SeatStay ]
                    set myAngle     [expr - [vectormath::angle {0 1} {0 0} $myDirection ]]
                    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __RearBrake__]]
                        #
                    $cvObject addtag    __Decoration__  withtag $myObject
                        #
                    if {$updateCommand != {}}   { 
                        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_RearBrake_Parameter_14
                    }
                }
            Disc {
                    set myDiameter              [myGUI::model::model_XZ::getScalar      RearBrake   DiscDiameter] 
                    set myPosition              [myGUI::model::model_XZ::getPosition    RearWheel   $BB_Position]
                    $cvObject create circle  $myPosition  -radius [expr 0.5 * $myDiameter]     -tags {__Decoration__ __RearBrake__}     -fill white
                }
            default {}
        }
    }

        # --- create FrontBrake ----------------
    if {$cfgFront != {off}} {
          # puts "          ... \$cfgFront $cfgFront"
        switch $cfgFront {
            Rim {
                    set myPosition  [myGUI::model::model_XZ::getPosition    FrontBrake_Shoe   $BB_Position]
                    set myNode      [myGUI::model::model_XZ::getComponent   FrontBrake]
                    set ht_dir      [myGUI::model::model_XZ::getDirection   HeadTube ]
                    set ht_angle    [expr [vectormath::angle {0 1} {0 0} $ht_dir ] ]
                    set fb_angle    [myGUI::model::model_XZ::getScalar Fork CrownAngleBrake]
                    set myAngle     [expr $ht_angle + $fb_angle]
                    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __FrontBrake__]]
                        #
                    $cvObject addtag    __Decoration__  withtag $myObject
                        #
                    if {$updateCommand != {}}   { 
                        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_FrontBrake_Parameter_13
                    }
                }
            Disc {
                    set myDiameter              [myGUI::model::model_XZ::getScalar      RearBrake   DiscDiameter] 
                    set myPosition              [myGUI::model::model_XZ::getPosition    FrontWheel   $BB_Position]
                    $cvObject create circle  $myPosition  -radius [expr 0.5 * $myDiameter]     -tags {__Decoration__ __FrontBrake__}     -fill white
                }
            default {}
        }
    }
}
proc myGUI::rendering::createDecoration_CarrierFront {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create CarrierFront --------
    set myPosition  [myGUI::model::model_XZ::getPosition    CarrierMount_Front  $BB_Position]
    set myNode      [myGUI::model::model_XZ::getComponent   FrontCarrier]
    set myAngle     0
    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __CarrierFront__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_CarrierFront_Parameter_07
    }
        #
}  
proc myGUI::rendering::createDecoration_CarrierRear {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create CarrierFront --------
    set myPosition  [myGUI::model::model_XZ::getPosition    CarrierMount_Rear  $BB_Position]
    set myNode      [myGUI::model::model_XZ::getComponent   RearCarrier]
    set myAngle     0
    set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __CarrierRear__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_CarrierRear_Parameter_11
    }
        #
}  
proc myGUI::rendering::createDecoration_Fender {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        #
    set cfgFront    [myGUI::model::model_XZ::getConfig FrontFender]
    set cfgRear     [myGUI::model::model_XZ::getConfig RearFender]                
        #
        # --- create RearWheel Fender ----------
    if {$cfgRear != {off}} { # --- create RearWheel Fender ----------
        set myPosition  [myGUI::model::model_XZ::getPosition    RearFender $BB_Position ]
        set myAngle     [myGUI::model::model_XZ::getDirection   RearFender degree]
        set myNode      [myGUI::model::model_XZ::getComponent   RearFender_XZ]
            # puts "RearWheel Fender"
            # puts [$myNode asXML]
        set myObject    [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __RearFender__]]
            #
        $cvObject addtag  __Decoration__ withtag $myObject
            #
        if {$updateCommand != {}} {
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject  group_RearFender_Parameter_00
        }
    }
        #
        # --- create FrontWheel Fender ---------
    if {$cfgFront != {off}} {
        set myPosition  [myGUI::model::model_XZ::getPosition    FrontFender $BB_Position ]
        set myAngle     [myGUI::model::model_XZ::getDirection   FrontFender degree]
        set myNode      [myGUI::model::model_XZ::getComponent   FrontFender_XZ]
            # puts "RearWheel Fender"
            # puts [$myNode asXML]
        set myFrontObj  [$cvObject create svg  $myPosition   [list -svgNode $myNode  -angle $myAngle  -tags __FrontFender__]]
            #
        $cvObject addtag  __Decoration__ withtag $myFrontObj
            #
        if {$updateCommand != {}} {
            myGUI::gui::bind_objectEvent_2  $cvObject   $myFrontObj group_FrontFender_Parameter_00
        }
    }
        #
}
proc myGUI::rendering::createDecoration_Label {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create Label --------------------
    set myPosition  [myGUI::model::model_XZ::getPosition    Label   $BB_Position]
    set myNode      [myGUI::model::model_XZ::getComponent   Label]
    set myDirection [myGUI::model::model_XZ::getDirection   Label]
    set myAngle     [vectormath::dirAngle {0 0} $myDirection ]
    set myObject    [$cvObject create svg  $myPosition [list -svgNode $myNode  -angle $myAngle  -tags __Label__]]
                     $cvObject addtag    __Decoration__  withtag $myObject
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_LabelFile
    }
        #
}
proc myGUI::rendering::createDecoration_RearWheel {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        # --- create RearWheel -----------------
    set Hub(position)           [myGUI::model::model_XZ::getPosition             RearWheel        $BB_Position]
    set RimHeight               [myGUI::model::model_XZ::getScalar RearWheel RimHeight   ]
    set RimDiameter             [myGUI::model::model_XZ::getScalar Geometry RearRim_Diameter ]
    set TyreHeight              [myGUI::model::model_XZ::getScalar Geometry RearTyre_Height ]
                                    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
    set my_Rim                  [  $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                  # $cvObject create circle  $Hub(position)  -radius 45                                          -tags {__Decoration__ __Cassette__} -fill white
                                    $cvObject create circle  $Hub(position)  -radius 23                                          -tags {__Decoration__ __Hub__}      -fill white
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $my_Rim     single_RearWheel_RimHeight
    }
        #
}
proc myGUI::rendering::createDecoration_FrontWheel {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create FrontWheel ----------------
    set Hub(position)       [myGUI::model::model_XZ::getPosition            FrontWheel  $BB_Position ]
    set RimHeight           [myGUI::model::model_XZ::getScalar FrontWheel RimHeight ]
    set RimDiameter         [myGUI::model::model_XZ::getScalar Geometry FrontRim_Diameter ]
    set TyreHeight          [myGUI::model::model_XZ::getScalar Geometry FrontTyre_Height ]
                                    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight]     -tags {__Decoration__ __Tyre__}     -fill white
                                    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter + 5]               -tags {__Decoration__ __Rim_01__}   -fill white
    set my_Rim                  [  $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - 4]               -tags {__Decoration__ __Rim_02__}   -fill white ]
                                    $cvObject create circle  $Hub(position)  -radius [expr 0.5 * $RimDiameter - $RimHeight + 5]  -tags {__Decoration__ __Rim_03__}   -fill white
                                    $cvObject create circle  $Hub(position)  -radius 20                                          -tags {__Decoration__ __Hub__}      -fill white
                                    $cvObject create circle  $Hub(position)  -radius 4.5                                         -tags {__Decoration__}              -fill white
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $my_Rim     single_FrontWheel_RimHeight    
    }
        #
}

proc myGUI::rendering::createDecoration_RearWheel_Pos {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # 
    set Hub(position)       [myGUI::model::model_XZ::getPosition             RearWheel  $BB_Position ]
    foreach {x y} $Hub(position) break
    set x1    [expr $x + 15];        set x2    [expr $x - 15];     set y1    [expr $y + 15];     set y2    [expr $y - 15]
    $cvObject create line  [list $x1 $y $x2 $y]   -fill darkred  -tags __Decoration__
    $cvObject create line  [list $x $y1 $x $y2]   -fill darkred  -tags __Decoration__
        #
}

proc myGUI::rendering::createDecoration_Fender_Rep {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        #
    set cfgFront     [myGUI::model::model_XZ::getConfig FrontFender]
    set cfgRear      [myGUI::model::model_XZ::getConfig RearFender]
        # --- create Fender Representaton ----
    if {$cfgRear != {off}} { # --- create RearWheel Fender ----------
        set myPosition      [myGUI::model::model_XZ::getPosition    RearFender $BB_Position]
        set myRadius        [myGUI::model::model_XZ::getScalar      RearFender Radius]
        set angleStart      [myGUI::model::model_XZ::getDirection   RearFender degree]
        set angleEnd        [expr   90 - $angleStart ]
        set my_Fender       [$cvObject create arc   $myPosition  -radius $myRadius -start $angleStart  -extent $angleEnd -style arc -outline gray40  -tags __Decoration__]
        if {$updateCommand != {}} {
            myGUI::gui::bind_objectEvent_2  $cvObject   $my_Fender  option_RearFenderBinary
        }
    }
        #
    if {$cfgFront != {off}} { # --- create FrontWheel Fender ----------
        set myPosition      [myGUI::model::model_XZ::getPosition    FrontFender $BB_Position]
        set myRadius        [myGUI::model::model_XZ::getScalar      FrontFender Radius]
        set angleStart      100
        set angleEnd         95
        set my_Fender             [$cvObject create arc   $myPosition  -radius $myRadius -start $angleStart  -extent $angleEnd -style arc -outline gray40  -tags __Decoration__]
        if {$updateCommand != {}} {
            myGUI::gui::bind_objectEvent_2  $cvObject   $my_Fender  option_FrontFenderBinary
        }
    }
        #
}
proc myGUI::rendering::createDecoration_RearWheel_Rep {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        #
    set Hub(position)       [myGUI::model::model_XZ::getPosition    RearWheel   $BB_Position ]
    set RimHeight           [myGUI::model::model_XZ::getScalar RearWheel RimHeight ]
    set RimDiameter         [myGUI::model::model_XZ::getScalar Geometry RearRim_Diameter ]
    set TyreHeight          [myGUI::model::model_XZ::getScalar Geometry RearTyre_Height ]
    set my_Wheel            [$cvObject create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start -20  -extent 105 -style arc -outline gray60  -tags __Decoration__]
    set my_Wheel            [$cvObject create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start -25  -extent 100 -style arc -outline gray60  -tags __Decoration__  -width 0.35]
        #
}
proc myGUI::rendering::createDecoration_FrontWheel_Rep {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        #
    set Hub(position)       [myGUI::model::model_XZ::getPosition    FrontWheel  $BB_Position ]
    set RimHeight           [myGUI::model::model_XZ::getScalar      FrontWheel  RimHeight]
    set RimDiameter         [myGUI::model::model_XZ::getScalar Geometry FrontRim_Diameter]
    set TyreHeight          [myGUI::model::model_XZ::getScalar Geometry FrontTyre_Height]
    set my_Wheel            [$cvObject create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter + $TyreHeight] -start  95  -extent  85 -style arc -outline gray60 -tags __Decoration__]
    set my_Wheel            [$cvObject create arc   $Hub(position)  -radius [expr 0.5 * $RimDiameter ]              -start  90  -extent  80 -style arc -outline gray60 -tags __Decoration__  -width 0.35  ]
}
proc myGUI::rendering::createDecoration_LegClearance_Rep {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        #
    set LegClearance(position)  [myGUI::model::model_XZ::getPosition    LegClearance  $BB_Position ]
    $cvObject create circle      $LegClearance(position)  -radius 5  -outline grey60 -tags __Decoration__
        #
}  

proc myGUI::rendering::createDecoration_HandleBar {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create Handlebar -------------
    set myPosition  [myGUI::model::model_XZ::getPosition    HandleBar      $BB_Position]
    set myNode      [myGUI::model::model_XZ::getComponent   HandleBar]
        # set HandleBar(file)         [checkFileString [myGUI::model::model_XZ::getComponent   HandleBar]]
    set myAngle     [myGUI::model::model_XZ::getDirection HandleBar degree]
        #
    set myObject    [$cvObject create svg  $myPosition [list -svgNode $myNode  -angle $myAngle  -tags __HandleBar__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_HandleBar_Parameter
    }
        #
}
proc myGUI::rendering::createDecoration_HeadSetTop {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create HeadSet -- Top -------------
    set myAngle             [myGUI::model::model_XZ::getDirection   HeadSet degree]
    set myPosition          [myGUI::model::model_XZ::getPosition    HeadSet_Top     $BB_Position ]
    set myNode              [myGUI::model::model_XZ::getComponent   HeadSetTop]
        #
    set myObject            [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __HeadSet_Top__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_HeadSet_Parameter_10
    }
}    
proc myGUI::rendering::createDecoration_HeadSetBottom {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create HeadSet -- Bottom ----------
    set myAngle             [myGUI::model::model_XZ::getDirection   HeadSet degree]
    set myPosition          [myGUI::model::model_XZ::getPosition    HeadSet_Bottom  $BB_Position ]
    set myNode              [myGUI::model::model_XZ::getComponent   HeadSetBottom]
        #
    set myObject            [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __HeadSet_Bottom__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   group_HeadSet_Parameter_09
    }
}
proc myGUI::rendering::createDecoration_HeadSetBottom_2 {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create HeadSet -- Top -------------
    set myAngle             [myGUI::model::model_XZ::getDirection   HeadSet degree]
    set myPosition          [myGUI::model::model_XZ::getPosition    HeadSet_Bottom  $BB_Position ]
    set myNode              [myGUI::model::model_XZ::getComponent   HeadSetBottom]
        #
    set myObject            [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __HeadSet_Bottom__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_HeadSet_BottomDiameter
    }
}
proc myGUI::rendering::createDecoration_Stem {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create Stem --------------------
    set myAngle             [myGUI::model::model_XZ::getDirection   Stem        degree]
    set myPosition          [myGUI::model::model_XZ::getPosition    HandleBar   $BB_Position ]
    set myNode              [myGUI::model::model_XZ::getComponent   Stem]
    set myObject            [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __Stem__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject  option_Stem
    }
        #
}
proc myGUI::rendering::createDecoration_Saddle {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create Saddle --------------------
    set myAngle             0
    set myPosition          [myGUI::model::model_XZ::getPosition    Saddle_Mount    $BB_Position ]
    set myPosition          [vectormath::addVector $myPosition      [list [myGUI::model::model_XZ::getScalar Saddle Offset_x] 0 ] ]
    set myNode              [myGUI::model::model_XZ::getComponent   Saddle]
    set myObject            [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __Saddle__]]
        #
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $myObject  group_Saddle_Parameter_12
    }
        #
}
proc myGUI::rendering::createDecoration_SeatPost {BB_Position type {updateCommand {}}} {
        #
    variable    cvObject
        #
        #
        # --- create SeatPost ------------------
    set myAngle             [myGUI::model::model_XZ::getDirection   SeatPost    degree]
    set myPosition          [myGUI::model::model_XZ::getPosition    SeatPost    $BB_Position]
    set myNode              [myGUI::model::model_XZ::getComponent   SeatPost]
    set myObject            [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle   -tags  __SeatPost__]]
        #
        # puts "--- SeatPost ----"
        # puts "[$myNode asXML]"
    $cvObject addtag  __Decoration__ withtag $myObject
        #
    if {$updateCommand != {}}     { 
            myGUI::gui::bind_objectEvent_2  $cvObject   $myObject   single_SeatPost_Diameter
    }
        #
    return    
        #
}


proc myGUI::rendering::createLine_FrameCenterLines {BB_Position type {status active}} {
        #
    variable cvObject
        #
        # --- get stageScale
    set stageScale          [$cvObject  configure   Stage   Scale ]
        
        # --- get defining Values ----------
    set CrankSetLength      [myGUI::model::model_XZ::getScalar CrankSet Length]
        # --- get defining Point coords ----------
    set BottomBracket       $BB_Position
    set CrankSet            [myGUI::model::model_XZ::getPosition        CrankSet                $BB_Position ]
    set RearWheel           [myGUI::model::model_XZ::getPosition        RearWheel               $BB_Position ]
    set FrontWheel          [myGUI::model::model_XZ::getPosition        FrontWheel              $BB_Position ]
    set Saddle              [myGUI::model::model_XZ::getPosition        Saddle                  $BB_Position ]
    set Saddle_Proposal     [myGUI::model::model_XZ::getPosition        SaddleProposal          $BB_Position ]
    set Saddle_Mount        [myGUI::model::model_XZ::getPosition        Saddle_Mount            $BB_Position ]
    set SeatPost_SeatTube   [myGUI::model::model_XZ::getPosition        SeatPost_SeatTube       $BB_Position ]
    set SeatPost_Pivot      [myGUI::model::model_XZ::getPosition        SeatPost_Pivot          $BB_Position ]
    set SeatTube_Ground     [myGUI::model::model_XZ::getPosition        SeatTube_Ground         $BB_Position ]
    set SeatTube_BBracket   [myGUI::model::model_XZ::getPosition        SeatTube_End            $BB_Position ]
    set SeatStay_SeatTube   [myGUI::model::model_XZ::getPosition        SeatStay_End            $BB_Position ]
    set SeatStay_RearWheel  [myGUI::model::model_XZ::getPosition        SeatStay_Start          $BB_Position ]
    set TopTube_SeatTube    [myGUI::model::model_XZ::getPosition        TopTube_End             $BB_Position ]
    set TopTube_SeatClassic [myGUI::model::model_XZ::getPosition        SeatTube_ClassicTopTube $BB_Position ]
    set TopTube_SeatVirtual [myGUI::model::model_XZ::getPosition        SeatTube_VirtualTopTube $BB_Position ]
    set TopTube_Steerer     [myGUI::model::model_XZ::getPosition        TopTube_Start           $BB_Position ]
    set HeadTube_Stem       [myGUI::model::model_XZ::getPosition        HeadTube_End            $BB_Position ]
    set TopTube_HeadVirtual [myGUI::model::model_XZ::getPosition        HeadTube_VirtualTopTube $BB_Position ]
    set Steerer_Stem        [myGUI::model::model_XZ::getPosition        Steerer_Stem            $BB_Position ]
    set Steerer_Fork        [myGUI::model::model_XZ::getPosition        Steerer_Start           $BB_Position ]
    set DownTube_Steerer    [myGUI::model::model_XZ::getPosition        DownTube_Start          $BB_Position ]
    set HandleBar           [myGUI::model::model_XZ::getPosition        HandleBar               $BB_Position ]
    set BaseCenter          [myGUI::model::model_XZ::getPosition        BottomBracket_Ground    $BB_Position ]
    set Steerer_Ground      [myGUI::model::model_XZ::getPosition        Steerer_Ground          $BB_Position ]
        #
    set ChainStay_Dropout   [myGUI::model::model_XZ::getPosition        ChainStay_RearWheel     $BB_Position ]
        #
    set Saddle_PropRadius   [vectormath::length    $Saddle_Proposal   $BB_Position]
    set SeatTube_Angle      [vectormath::angle     $SeatPost_SeatTube $BB_Position [list -500 [lindex $BB_Position 1] ] ]
    set SeatPost_Radius     [vectormath::length    $Saddle_Mount      $SeatPost_Pivot] 
        #
    set RimDiameter_Front   [myGUI::model::model_XZ::getScalar Geometry FrontRim_Diameter]
    set TyreHeight_Front    [myGUI::model::model_XZ::getScalar Geometry FrontTyre_Height]
    set RimDiameter_Rear    [myGUI::model::model_XZ::getScalar Geometry RearRim_Diameter]
    set TyreHeight_Rear     [myGUI::model::model_XZ::getScalar Geometry RearTyre_Height]
        #

        #
    set highlightList_1 {} 
    set highlightList_2 {} 
    set highlightList_3 {baseLine frontWheel rearWheel}
    set backgroundList  {}
    set excludeList     {}
        #
    switch -exact $myGUI::gui::frame_configMethod {
        {OutsideIn} {
                    set highlightList_1 {chainstay fork saddle seattube steerer stem } 
                    set highlightList_2 {} 
                }
        {StackReach} {
                    set highlightList_1 {chainstay fork saddle seattube steerer} 
                    set highlightList_2 {seatpost stem} 
                }
        {Classic} {
                    set highlightList_1 {chainstay fork saddle steerer stem virtualtoptube} 
                    set highlightList_2 {seatpost} 
                }
        {Lugs} {
                    set highlightList_1 {chainstay downtube fork saddle seattube steerer stem} 
                    set highlightList_2 {seatpost}
                        #
                    $cvObject create line    [appUtil::flatten_nestedList  $RearWheel    $ChainStay_Dropout  $BottomBracket ]       -fill gray60  -width 1.00     -tags {__CenterLine__    chainstaydropout}
                    $cvObject create circle  $ChainStay_Dropout                                                       -radius 7  -outline gray60  -width 0.35     -tags {__CenterLine__    chainstaydropout}  
                }
        default {}
    }     
        #
        

        # ------ rearwheel representation
    $cvObject create circle     $RearWheel   -radius [expr 0.5*$RimDiameter_Rear + $TyreHeight_Rear ]    -outline gray60 -width 0.35   -tags {__CenterLine__    rearWheel}
        # ------ frontwheel representation
    $cvObject create circle     $FrontWheel  -radius [expr 0.5*$RimDiameter_Front + $TyreHeight_Front ]  -outline gray60 -width 0.35   -tags {__CenterLine__    frontWheel}


        # ------ headtube extension to ground
    $cvObject create centerline [appUtil::flatten_nestedList  $Steerer_Fork       $Steerer_Ground   ]    -fill gray60                  -tags __CenterLine__
        # ------ seattube extension to ground
    $cvObject create centerline [appUtil::flatten_nestedList  $SeatTube_BBracket  $SeatTube_Ground  ]    -fill gray60                  -tags {__CenterLine__    seattube_center}
        

        # ------ chainstay
    $cvObject create line     [appUtil::flatten_nestedList  $RearWheel            $BottomBracket    ]    -fill gray60  -width 0.35     -tags {__CenterLine__    chainstay}
        # ------ seatstay
    $cvObject create line     [appUtil::flatten_nestedList  $SeatStay_SeatTube    $RearWheel        ]    -fill gray60  -width 0.35     -tags {__CenterLine__    seatstay}
        # ------ toptube
    $cvObject create line     [appUtil::flatten_nestedList  $TopTube_SeatTube     $TopTube_Steerer  ]    -fill gray60  -width 0.35     -tags {__CenterLine__    toptube}
        # ------ downtube
    $cvObject create line     [appUtil::flatten_nestedList  $DownTube_Steerer     $BB_Position      ]    -fill gray60  -width 0.35     -tags {__CenterLine__    downtube}
        # ------ fork
    $cvObject create line     [appUtil::flatten_nestedList  $Steerer_Fork         $FrontWheel       ]    -fill gray60  -width 0.35     -tags {__CenterLine__    fork}

        
        # ------ saddlemount
    $cvObject create line     [appUtil::flatten_nestedList  $Saddle               $Saddle_Mount     ]    -fill gray60  -width 0.5      -tags {__CenterLine__    saddlemount}


        # ------ crankset representation
    $cvObject create arc     $CrankSet       -radius $CrankSetLength     -start -95  -extent 170  -style arc  -outline gray \
                                                                                                                       -width 0.35     -tags {__CenterLine__    crankset}
        # ------ saddle proposal
    $cvObject create arc     $BottomBracket  -radius $Saddle_PropRadius  -start [expr 177 - $SeatTube_Angle]  -extent 6  -style arc  -outline darkmagenta \
                                                                                                                       -width 0.35     -tags {__CenterLine__    saddleproposal}
        # ------ seatpost pivot
    $cvObject create arc     $SeatPost_Pivot -radius $SeatPost_Radius    -start  55   -extent 70  -style arc  -outline darkmagenta \
                                                                                                                       -width 0.35     -tags {__CenterLine__    saddlepivot}

        # ------ saddle representation
    set saddle_polyline [myGUI::model::model_XZ::getPolyline SaddleProfile  $BB_Position]
    $cvObject create line  $saddle_polyline        -fill gray60  -width 1.0      -tags {__CenterLine__    saddle}


        # ------ virtual top- and seattube 
    switch -exact $myGUI::gui::frame_configMethod {
        OutsideIn {
                # ------ stem
            $cvObject create line    [appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $HeadTube_Stem ]                 -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                # ------ steerer
            $cvObject create line    [appUtil::flatten_nestedList  $HeadTube_Stem   $Steerer_Fork]                           -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                # ------ seattube
            $cvObject create line    [appUtil::flatten_nestedList  $Saddle_Mount    $SeatPost_SeatTube  $SeatTube_BBracket]  -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
        }
        StackReach {
                # ------ stem
            $cvObject create line    [appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $HeadTube_Stem ]                 -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                # ------ steerer
            $cvObject create line    [appUtil::flatten_nestedList  $HeadTube_Stem   $Steerer_Fork]                           -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                # ------ seatpost
            $cvObject create line    [appUtil::flatten_nestedList  $Saddle_Mount  $SeatPost_SeatTube  $TopTube_SeatTube]     -fill gray60  -width 1.0      -tags {__CenterLine__    seatpost}
                # ------ seattube
            $cvObject create line    [appUtil::flatten_nestedList  $TopTube_SeatVirtual $SeatTube_BBracket]                  -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
        }
        Lugs {
                # ------ stem
            $cvObject create line    [appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $TopTube_HeadVirtual ]           -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                # ------ steerer
            $cvObject create line    [appUtil::flatten_nestedList  $TopTube_HeadVirtual $Steerer_Fork]                       -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                # ------ seatpost
            $cvObject create line    [appUtil::flatten_nestedList  $Saddle_Mount  $SeatPost_SeatTube  $TopTube_SeatTube]     -fill gray60  -width 1.0      -tags {__CenterLine__    seatpost}
                # ------ seattube
            $cvObject create line    [appUtil::flatten_nestedList  $TopTube_SeatVirtual $SeatTube_BBracket]                  -fill gray60  -width 1.0      -tags {__CenterLine__    seattube}
        }
        Classic {
                # ------ stem
            $cvObject create line    [appUtil::flatten_nestedList  $HandleBar $Steerer_Stem $TopTube_HeadVirtual ]           -fill gray60  -width 1.0      -tags {__CenterLine__    stem}
                # ------ steerer
            $cvObject create line    [appUtil::flatten_nestedList  $TopTube_HeadVirtual $Steerer_Fork]                       -fill gray60  -width 1.0      -tags {__CenterLine__    steerer}
                # ------ seatpost
            $cvObject create line    [appUtil::flatten_nestedList  $Saddle_Mount  $SeatPost_SeatTube  $TopTube_SeatClassic]  -fill gray60  -width 1.0      -tags {__CenterLine__    seatpost}
                # ------ virtualtoptube
            $cvObject create line    [appUtil::flatten_nestedList  $TopTube_Steerer $TopTube_SeatClassic $SeatTube_BBracket] -fill gray60  -width 1.0      -tags {__CenterLine__    virtualtoptube}
        }       
        default {}
    }     
        #
        # puts "  $highlightList "
        # --- highlightList
            # set highlight(color) firebrick
            # set highlight(color) darkorchid
            # set highlight(color) darkred
            # set highlight(color) firebrick
            # set highlight(color) blue
            
        #
    if {$status eq {active}} {
        set highlight(color) red
        set highlight(width)  1.0
    } else {
        set highlight(color) gray60
        set highlight(width)  1.0
    }
            #
        # --- create position points
    $cvObject create circle  $BottomBracket          -radius 20  -outline $highlight(color)     -width $highlight(width)    -tags {__CenterLine__  bottombracket}
    $cvObject create circle  $FrontWheel             -radius 15  -outline $highlight(color)     -width $highlight(width)    -tags {__CenterLine__}  
    $cvObject create circle  $RearWheel              -radius 15  -outline $highlight(color)     -width $highlight(width)    -tags {__CenterLine__}  
    $cvObject create circle  $BaseCenter             -radius 15  -outline $highlight(color)     -width $highlight(width)    -tags {__CenterLine__}  
    $cvObject create circle  $Saddle_Mount           -radius 10  -outline $highlight(color)     -width $highlight(width)    -tags {__CenterLine__}  
        #
        #
    switch -exact $myGUI::gui::frame_configMethod {
        {StackReach} {  $cvObject create circle  $HeadTube_Stem          -radius 10  -outline $highlight(color)     -tags {__CenterLine__}  -width $highlight(width)    }
        {Classic}    {  $cvObject create circle  $TopTube_HeadVirtual    -radius 10  -outline $highlight(color)     -tags {__CenterLine__}  -width $highlight(width)    }       
        default { }
    }
        
        #
        # set exploreItem     [$cvObject create circle  {0 0}  -radius 50  -fill yellow  -outline red  -width 1]
        # set highlight(unit) [$cvObject itemcget $exploreItem -width]
        # $cvObject delete $exploreItem
        #
        # set highlight(width2)   [expr $highlight(unit) * $highlight(width)]
        #
        # puts "      -> \$highlight(unit)   $highlight(unit)"    
        # puts "      -> \$highlight(width2) $highlight(width2)"    
        #
        # -- highlightList_1
        #
    if {$status eq {active}} {
        set highlight(color)    red
        set highlight(width)    1.4
    } else {
        set highlight(color)    gray60
        set highlight(width)    1.4
    }
        # ------------------------
    foreach item $highlightList_1 {
        catch {$cvObject itemconfigure                      $item  -fill      $highlight(color)} error
        catch {$cvObject itemconfigure                      $item  -outline   $highlight(color)} error
        myGUI::cvCustom::itemconfigureLineWidth  $cvObject  $item  $highlight(width)
            # catch {$cvObject itemconfigure $item  -fill      $highlight(color)  -width $highlight(width2)} error
            # catch {$cvObject itemconfigure $item  -outline   $highlight(color)  -width $highlight(width2)} error
    }
        #
        # -- highlightList_2
        # 
        set highlight(color) darkorange
        set highlight(color) orange
        set highlight(color) goldenrod
        set highlight(color) gray70
            # ------------------------
    foreach item $highlightList_2 {
        catch {$cvObject itemconfigure                      $item  -fill      $highlight(color)} error
        catch {$cvObject itemconfigure                      $item  -outline   $highlight(color)} error
        myGUI::cvCustom::itemconfigureLineWidth  $cvObject  $item  $highlight(width)
            # catch {$cvObject itemconfigure $item  -fill      $highlight(color)  -width $highlight(width2) } error
            # catch {$cvObject itemconfigure $item  -outline   $highlight(color)  -width $highlight(width2) } error
    }
        #
        # -- backgroundList
        # 
    foreach item $backgroundList {
        myGUI::cvCustom::itemconfigureLineWidth  $cvObject  $item  $highlight(width)
            # catch {$cvObject itemconfigure $item  -width $highlight(width2) } error
            # catch {$cvObject itemconfigure $item  -width $highlight(width2) } error
    }

    puts "  $excludeList "
        # --- highlightList
    foreach item $excludeList {
        catch {$cvObject delete $item } error
    }
    
            # --- bindings -----------
    myGUI::gui::bind_objectEvent_2  $cvObject   stem            group_FrontGeometry
    myGUI::gui::bind_objectEvent_2  $cvObject   steerer         group_FrontGeometry
    myGUI::gui::bind_objectEvent_2  $cvObject   fork            group_FrontGeometry
    myGUI::gui::bind_objectEvent_2  $cvObject   bottombracket   group_BottomBracket_DepthHeight
        #
}
proc myGUI::rendering::createLine_BaseLine {BB_Position type args} {
        #
    variable cvObject
        #
        #
    if {[lindex $args 0] eq {}} {
        set color {gray}
    } else {
        set color [lindex $args 0]
    }
        #
        # --- get distance to Ground
    set BB_Ground(position)     [myGUI::model::model_XZ::getPosition    BottomBracket_Ground    $BB_Position]
        # puts "   -> \$BB_Ground(position) $BB_Ground(position)"
        # exit
    
    set RimDiameter_Front       [myGUI::model::model_XZ::getScalar      Geometry FrontRim_Diameter]
    set RimDiameter_Rear        [myGUI::model::model_XZ::getScalar      Geometry RearRim_Diameter]
        #   puts "  -> \$RimDiameter_Front $RimDiameter_Front"
        #   puts "  -> \$RimDiameter_Rear  $RimDiameter_Rear"


    set FrontWheel(position)    [myGUI::model::model_XZ::getPosition    FrontWheel      $BB_Position]
    set RearWheel(position)     [myGUI::model::model_XZ::getPosition    RearWheel       $BB_Position]
        # puts "   ... \$RearWheel(position)  $RearWheel(position)"


        # --- get RearWheel
    foreach {x y} $RearWheel(position) break
    set Rear(xy)                [list [expr $x - 0.8 * 0.5 * $RimDiameter_Rear ] [lindex $BB_Ground(position) 1] ]

        # --- get FrontWheel
    foreach {x y} $FrontWheel(position) break
    set Front(xy)                [list [expr $x + 0.8 * 0.5 * $RimDiameter_Front ] [lindex $BB_Ground(position) 1] ]


        # --- create line
    $cvObject create line    [list  [lindex $Rear(xy)   0 ] [lindex $Rear(xy)   1 ] [lindex $Front(xy)   0 ] [lindex $Front(xy)   1 ] ]  -fill $color -tags {__CenterLine__ baseLine}
    $cvObject create circle  $BB_Position  -radius  4    -outline $color
}
proc myGUI::rendering::createLine_CopyReference {BB_Position type args} {
        #
    variable cvObject
        #
        
        # --- get stageScale
    set stageScale          [$cvObject  configure   Stage   Scale ]
    
        # --- get defining Point coords ----------
    set BottomBracket       $BB_Position
    set RearWheel           [myGUI::model::model_XZ::getPosition      RearWheel               $BB_Position ]
    set FrontWheel          [myGUI::model::model_XZ::getPosition      FrontWheel              $BB_Position ]
    set Saddle_Mount        [myGUI::model::model_XZ::getPosition      Saddle_Mount            $BB_Position ]
    set HandleBar           [myGUI::model::model_XZ::getPosition      HandleBar               $BB_Position ]
    set SeatTube_Ground     [myGUI::model::model_XZ::getPosition      SeatTube_Ground         $BB_Position ]
    set Steerer_Ground      [myGUI::model::model_XZ::getPosition      Steerer_Ground          $BB_Position ]
    set Reference_HB        [myGUI::model::model_XZ::getPosition      Reference_HB            $BB_Position ]
    set Reference_SN        [myGUI::model::model_XZ::getPosition      Reference_SN            $BB_Position ]
   
        # ------ centerlines
        # linetype
        #    centerline
        #    line
        # colour
        #    darkviolet
        #    red
        #    darkorange
        #    orange
        #
        
    set line(color) gray50
    set line(width) 0.5
        # -----------------------------------                          
    $cvObject create centerline  [appUtil::flatten_nestedList  $BottomBracket     $SeatTube_Ground   ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
    $cvObject create centerline  [appUtil::flatten_nestedList  $Steerer_Ground    $FrontWheel        ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
                            
    
    
    set line(color) orange
    set line(width) 1.0
        # -----------------------------------                          
    $cvObject create centerline  [appUtil::flatten_nestedList  $BottomBracket     $Reference_HB      ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
        # ------ front triangle
    $cvObject create centerline  [appUtil::flatten_nestedList  $BottomBracket     $FrontWheel        ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
    $cvObject create centerline  [appUtil::flatten_nestedList  $FrontWheel        $Reference_HB      ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
        # ------ seat triangle
    $cvObject create centerline  [appUtil::flatten_nestedList  $BottomBracket     $Reference_SN      ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
    $cvObject create centerline  [appUtil::flatten_nestedList  $Reference_SN      $Reference_HB      ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
        # ------ rear triangle
    $cvObject create centerline  [appUtil::flatten_nestedList  $RearWheel         $BottomBracket     ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}                             
        # ------ diagonal
    # $cvObject create centerline  [appUtil::flatten_nestedList  $RearWheel         $Reference_SN      ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}
    # $cvObject create centerline  [appUtil::flatten_nestedList  $RearWheel         $Reference_HB      ]    -fill $line(color)  -width $line(width)      -tags {__CenterLine__ __copyConcept__}                             
    
        # ------ position 
    set position(color)  darkred
    set position(width)       2.0
    set position(radius)      7.0
        # -----------------------------------                                                     
    $cvObject create circle  $Reference_HB       -radius $position(radius)  -outline $position(color)     -tags {__CenterLine__}  -width $position(width)
    $cvObject create circle  $Reference_SN       -radius $position(radius)  -outline $position(color)     -tags {__CenterLine__}  -width $position(width)
    $cvObject create circle  $BottomBracket      -radius $position(radius)  -outline $position(color)     -tags {__CenterLine__}  -width $position(width)
    $cvObject create circle  $RearWheel          -radius $position(radius)  -outline $position(color)     -tags {__CenterLine__}  -width $position(width)
    $cvObject create circle  $FrontWheel         -radius $position(radius)  -outline $position(color)     -tags {__CenterLine__}  -width $position(width)
        #
}


proc myGUI::rendering::createFrame_Tubes {cvObject BB_Position {updateCommand {}}} {

    set domInit     $::APPL_Config(root_InitDOM)
    
        # --- get stageScale
    set stageScale      [$cvObject  configure   Stage   Scale ]
        
        # --- set tubeColor
        # set tubeColor "gray90"
    set tubeColor   "white"


        # --- create HeadTube --------------------
    set HeadTube(polygon)       [myGUI::model::model_XZ::getPolygon     HeadTube            $BB_Position  ]
    set HeadTube(object)        [$cvObject create polygon $HeadTube(polygon) -fill $tubeColor -outline black  -tags __HeadTube__]
                                  $cvObject addtag  __Frame__ withtag $HeadTube(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $HeadTube(object)   group_HeadTube_Parameter_03
    }
    if 0 {
                # ... the edge lines of the conical headtube
        if {[myGUI::model::model_XZ::getConfig HeadTube] != {cylindric}} {
                #
            set pt_01   [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Top          $BB_Position]
            set pt_02   [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Top         $BB_Position]
            set pt_03   [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_Bottom       $BB_Position]
            set pt_04   [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_Bottom      $BB_Position]
                #
                # set pt_01 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_tpEdge       $BB_Position]
                # set pt_02 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_tpEdge      $BB_Position]
                # set pt_03 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeBack_btEdge       $BB_Position]
                # set pt_04 [myGUI::model::model_XZ::getPosition    _Edge_HeadTubeFront_btEdge      $BB_Position]
                #
            set length_a    [expr 0.15 * [vectormath::length $pt_01 $pt_02]]   
            set length_b    [expr 0.05 * [vectormath::length $pt_01 $pt_02]]   
            set pt_01_a     [vectormath::addVector $pt_01   [vectormath::unifyVector $pt_01 $pt_02 $length_a]]
            set pt_01_b     [vectormath::addVector $pt_01   [vectormath::unifyVector $pt_01 $pt_02 $length_b]]
            set pt_02_a     [vectormath::addVector $pt_02   [vectormath::unifyVector $pt_02 $pt_01 $length_a]]
                #
            set length_a    [expr 0.15 * [vectormath::length $pt_03 $pt_04]]   
            set length_b    [expr 0.05 * [vectormath::length $pt_03 $pt_04]]   
            set pt_03_a     [vectormath::addVector $pt_03   [vectormath::unifyVector $pt_03 $pt_04 $length_a]]
            set pt_03_b     [vectormath::addVector $pt_03   [vectormath::unifyVector $pt_03 $pt_04 $length_b]]
            set pt_04_a     [vectormath::addVector $pt_04   [vectormath::unifyVector $pt_04 $pt_03 $length_a]]
                #
            set edge_01     [$cvObject create line    [appUtil::flatten_nestedList $pt_01_a $pt_02_a]  -fill gray70  -tags {__HeadTube__ __HeadTubeEdge__}]
            set edge_02     [$cvObject create line    [appUtil::flatten_nestedList $pt_03_a $pt_04_a]  -fill gray70  -tags {__HeadTube__ __HeadTubeEdge__}]
            set edge_03     [$cvObject create line    [appUtil::flatten_nestedList $pt_01   $pt_01_b]  -fill darkred -tags {__HeadTube__ __HeadTubeEdge__}]
            set edge_04     [$cvObject create line    [appUtil::flatten_nestedList $pt_03   $pt_03_b]  -fill darkred -tags {__HeadTube__ __HeadTubeEdge__}]
                #
            $cvObject addtag  __Frame__ withtag $edge_01
            $cvObject addtag  __Frame__ withtag $edge_03
                #
        }
    }
        # --- create DownTube --------------------
    set DownTube(polygon)       [myGUI::model::model_XZ::getPolygon     DownTube            $BB_Position  ]
    set DownTube(object)        [$cvObject create polygon $DownTube(polygon) -fill $tubeColor -outline black  -tags __DownTube__]
                                  $cvObject addtag  __Frame__ withtag $DownTube(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $DownTube(object)   group_DownTube_Parameter_06
    }

        # --- create SeatTube --------------------
    set SeatTube(polygon)       [myGUI::model::model_XZ::getPolygon     SeatTube            $BB_Position  ]
    set SeatTube(object)        [$cvObject create polygon $SeatTube(polygon) -fill $tubeColor -outline black  -tags __SeatTube__]
                                  $cvObject addtag  __Frame__ withtag $SeatTube(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $SeatTube(object)   group_SeatTube_Parameter_05
    }

        # --- create TopTube ---------------------
    set TopTube(polygon)        [myGUI::model::model_XZ::getPolygon     TopTube             $BB_Position  ]
    set TopTube(object)         [$cvObject create polygon $TopTube(polygon) -fill $tubeColor -outline black  -tags __TopTube__]
                                  $cvObject addtag  __Frame__ withtag $TopTube(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $TopTube(object)    group_TopTube_Parameter_04
    }

        # --- create Rear Dropout ----------------
        # set RearWheel(position)     [myGUI::model::model_XZ::getPosition    RearWheel           $BB_Position]
        # set RearDropout(file)       [checkFileString [myGUI::model::model_XZ::getComponent RearDropout] ]
        # set RearDropout(angle)      [myGUI::model::model_XZ::getDirection   RearDropout degree]
    set Config(RearDropOut)     [myGUI::model::model_XZ::getConfig      RearDropout ]
        #
    
        # --- Rear Dropout behind Chain- and SeatStay 
    if {$Config(RearDropOut) != {front}} {
        set myAngle             [myGUI::model::model_XZ::getDirection   RearDropout degree]
        set myPosition          [myGUI::model::model_XZ::getPosition    RearDropout $BB_Position]
        set myNode              [myGUI::model::model_XZ::getComponent   RearDropout]
        set RearDropout(object) [$cvObject create svg  $myPosition [list -svgNode $myNode  -angle $myAngle  -tags __RearDropout__]]
    }


        # --- create ChainStay -------------------
    set ChainStay(polygon)      [myGUI::model::model_XZ::getPolygon     ChainStay           $BB_Position  ]
    set ChainStay(object)       [$cvObject create polygon $ChainStay(polygon) -fill $tubeColor -outline black  -tags __ChainStay__]
                                  $cvObject addtag  __Frame__ withtag $ChainStay(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $ChainStay(object)  group_ChainStay_Parameter_01
    }

        # --- create SeatStay --------------------
    set SeatStay(polygon)       [myGUI::model::model_XZ::getPolygon     SeatStay            $BB_Position  ]
    set SeatStay(object)        [$cvObject create polygon $SeatStay(polygon) -fill $tubeColor -outline black  -tags __SeatStay__]
                                  $cvObject addtag  __Frame__ withtag $SeatStay(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $SeatStay(object)   group_SeatStay_Parameter_01
    }
        # --- Rear Dropout in front of Chain- and SeatStay 
    if {$Config(RearDropOut) == {front}} {
        set myAngle             [myGUI::model::model_XZ::getDirection   RearDropout degree]
        set myPosition          [myGUI::model::model_XZ::getPosition    RearDropout $BB_Position]
        set myNode              [myGUI::model::model_XZ::getComponent   RearDropout]
        set RearDropout(object) [$cvObject create svg  $myPosition  [list -svgNode $myNode  -angle $myAngle  -tags __RearDropout__]]
    }
        # --- handle Rear Dropout - properties ---
    $cvObject addtag  __Frame__ withtag $RearDropout(object)
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   $RearDropout(object)    group_RearDropout_Parameter_01
    }


        # --- create BottomBracket ---------------
    set BottomBracket(outerDiameter)    [myGUI::model::model_XZ::getScalar BottomBracket OutsideDiameter]
    set BottomBracket(innerDiameter)    [myGUI::model::model_XZ::getScalar BottomBracket InsideDiameter]
    set BottomBracket(object_1)         [$cvObject create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(outerDiameter)]    -fill $tubeColor    -tags {__Frame__  __BottomBracket__  outside} ]
    set BottomBracket(object_2)         [$cvObject create circle  $BB_Position  -radius [expr 0.5 * $BottomBracket(innerDiameter)]    -fill $tubeColor    -tags {__Frame__  __BottomBracket__  inside} ]
    set BottomBracket(object)   __BottomBracket__
    $cvObject addtag $BottomBracket(object) withtag $BottomBracket(object_1)
    $cvObject addtag $BottomBracket(object) withtag $BottomBracket(object_2)

        # --- create CrankSet --------------------
    set CrankSet(Position)              [myGUI::model::model_XZ::getPosition  CrankSet    $BB_Position]
    set BottomBracket(object_3)         [$cvObject create circle  $CrankSet(Position)  -radius  7            -tags {__Frame__  __BottomBracket__  crankset} ]
    $cvObject addtag $BottomBracket(object) withtag $BottomBracket(object_3)
    
    if {$updateCommand != {}}   { 
        myGUI::gui::bind_objectEvent_2  $cvObject   __BottomBracket__      group_BottomBracket_Diameter_01
    }
    
}


proc myGUI::rendering::createFork {cvObject BB_Position {updateCommand {}} } {
        #
    set config_Fork      [myGUI::model::model_XZ::getConfig Fork]
        #
    puts "        -> $config_Fork"
        #
    switch -glob $config_Fork {
            Supplier {  createFork_Supplier $cvObject $BB_Position $updateCommand    }
            default {   createFork_all      $cvObject $BB_Position $updateCommand    }
    }
}
proc myGUI::rendering::createFork_all {cvObject BB_Position {updateCommand {}} } {

        #
        #
    set domInit     $::APPL_Config(root_InitDOM)

        # --- get stageScale
    set stageScale      [$cvObject  configure   Stage   Scale ]
        
        # --- set tubeColor
    set tubeColor      "white"

        # --- get Rendering Style
    set config_Fork         [myGUI::model::model_XZ::getConfig Fork]
    set config_ForkDropOut  [myGUI::model::model_XZ::getConfig ForkDropout]
    
        # tk_messageBox -message "Rendering(ForkDropOut): $Rendering(ForkDropOut)"

    set angle_Crown         [myGUI::model::model_XZ::getDirection   ForkCrown   degree]
    set angle_Blade         [myGUI::model::model_XZ::getDirection   ForkBlade   degree]
    set angle_Dropout       [myGUI::model::model_XZ::getDirection   ForkDropout degree]
    # set ht_angle            [myGUI::model::model_XZ::getDirection   ForkCrown   degree]
    # set bd_angle            [myGUI::model::model_XZ::getDirection   ForkBlade   degree]
    # set do_angle            [myGUI::model::model_XZ::getDirection   ForkDropout degree]
    # set angle_Crown         [expr $ht_angle - 90]
    # set angle_Dropout       [expr 90 - $do_angle]
        #
    set position_Crown      [myGUI::model::model_XZ::getPosition    ForkCrown   $BB_Position ]
    set position_Blade      [myGUI::model::model_XZ::getPosition    ForkBlade   $BB_Position ]
    set position_Dropout    [myGUI::model::model_XZ::getPosition    ForkDropout $BB_Position ]
        #
    
        #
        # --- create Fork Representation ----------------
        #
    set node_Crown          [myGUI::model::model_XZ::getComponent   ForkCrown]
    set node_Blade          [myGUI::model::model_XZ::getComponent   ForkBlade]
    set node_Dropout        [myGUI::model::model_XZ::getComponent   ForkDropout]
    set node_Steerer        [myGUI::model::model_XZ::getComponent   Steerer]
        #
        #
        
        # puts "  -> \$node_Crown   $node_Crown"    
        # puts "  -> \$node_Dropout $node_Dropout"    
        #
    switch -glob $config_Fork {
            Suspension* {
                    set angle_Dropout       $angle_Crown
                    set position_Dropout    [myGUI::model::model_XZ::getPosition    ForkDropout $BB_Position ] 
                    #set position_Dropout    [myGUI::model::model_XZ::getPosition    FrontDropout_MockUp    $BB_Position ] 
                        #
                        # puts "  <-2-> $position_Dropout"
                        # set position_Dropout   [myGUI::model::model_XZ::getPosition    FrontWheel    $BB_Position ]   
                }
            default {}
    }
    
        # --- create Steerer ---------------------
        #
    set object_Steerer  [$cvObject create svg  $position_Crown [list -svgNode $node_Steerer  -angle $angle_Crown  -tags __ForkSteerer__]]
    $cvObject addtag  __Fork__ withtag $object_Steerer
    

        # --- create Fork Dropout ---------------
        #
    if {$config_ForkDropOut == {behind}} {
        set object_Dropout  [$cvObject create svg  $position_Dropout  [list -svgNode $node_Dropout  -angle $angle_Dropout  -tags __ForkDropout__]]
        $cvObject addtag  __Fork__ withtag $object_Dropout
    }

        # --- create Fork Blade -----------------
        #
    set object_Blade       [$cvObject create svg  $position_Blade  [list -svgNode $node_Blade  -angle $angle_Blade  -tags __ForkBlade__]]
    $cvObject addtag  __Fork__ withtag $object_Blade
        #
    switch -exact $updateCommand {
        editable {
            switch -glob $config_Fork {
                SteelLugged -
                SteelCustom* {
                    myGUI::gui::bind_objectEvent_2  $cvObject   $object_Blade  group_ForkBlade_Parameter
                }
                default {}
            }
        }
        selectable {            
                    myGUI::gui::bind_objectEvent_2  $cvObject   $object_Blade  option_ForkType
        }   
        default {}
    }                                                   


        # --- create ForkCrown -------------------
        #
    set object_Crown       [$cvObject create svg  $position_Crown  [list -svgNode $node_Crown  -angle $angle_Crown  -tags __ForkCrown__ ]]
    $cvObject addtag  __Fork__ withtag $object_Crown
            #
    switch -exact $updateCommand {
        editable {              
            switch -glob $config_Fork {
                SteelLugged -
                SteelCustom* {            
                    myGUI::gui::bind_objectEvent_2  $cvObject   $object_Crown  group_ForkCrown_Parameter
                }
                default {            
                    myGUI::gui::bind_objectEvent_2  $cvObject   $object_Crown  option_ForkType
                }
            }
        }      
        selectable {            
                    myGUI::gui::bind_objectEvent_2  $cvObject   $object_Crown  option_ForkType
        }
        default {}
    }

        # --- create Fork Dropout -------------------
        #
    if {$config_ForkDropOut == {front}} {
        set object_Dropout     [$cvObject create svg  $position_Dropout  [list -svgNode $node_Dropout  -angle $angle_Dropout  -tags __ForkDropout__]]
        $cvObject addtag  __Fork__ withtag $object_Dropout
    }
        #
    switch -exact $updateCommand {
        editable { 
                switch -glob $config_Fork {
                    SteelLugged -
                    SteelCustom* {
                        myGUI::gui::bind_objectEvent_2  $cvObject   $object_Dropout  group_ForkDropout_Parameter
                    }
                    default {}
                }
            }
        default {}
    }

        # --- check bindings and remove ----------
    switch $config_Fork {
        Composite        -
        Suspension       -
        Suspension_26    -
        Suspension_28    -
        Suspension_29   {}
        default         {}
    }
        #
    $cvObject create circle  $position_Dropout    -radius 4.5    -fill white    -tags __ForkDropoutPosition__
    $cvObject addtag  __Fork__  withtag __ForkDropoutPosition__
    $cvObject addtag  __Frame__ withtag __Fork__
        #
    return
        #
}
proc myGUI::rendering::createFork_Supplier {cvObject BB_Position {updateCommand {}} } {

        #
        # --- get stageScale
    set stageScale      [$cvObject  configure   Stage   Scale ]
        
        # --- set tubeColor
        # set tubeColor "gray90"
    set tubeColor      "white"

        #
    set ht_direction        [myGUI::model::model_XZ::getDirection   ForkCrown ]
    set ht_angle            [myGUI::model::model_XZ::getDirection   ForkCrown   degree]
        #

        # --- create Fork Representation ----------------
        # puts "          ... \$Rendering(Fork)    $Rendering(Fork)"
        #
    set do_direction        [myGUI::model::model_XZ::getDirection   ForkDropout ]
    set angle_Dropout       [expr -90 + [vectormath::angle $do_direction {0 0} {-1 0} ] ]
    set do_direction        [myGUI::model::model_XZ::getDirection   HeadTube ]
    set angle_Dropout       [vectormath::angle {0 1} {0 0} $do_direction ]
        #
    set ht_angle            [myGUI::model::model_XZ::getDirection   ForkCrown   degree]
    set do_angle            [myGUI::model::model_XZ::getDirection   ForkDropout degree]
    set angle_Dropout       [expr 90 - $do_angle]
    set angle_Fork          [expr $ht_angle - 90]
        #
    set angle_Crown         [myGUI::model::model_XZ::getDirection   ForkCrown   degree]
    set angle_Dropout       [myGUI::model::model_XZ::getDirection   ForkDropout degree]
        #
    set position_Fork       [myGUI::model::model_XZ::getPosition    ForkCrown       $BB_Position ] 
    set position_Dropout    [myGUI::model::model_XZ::getPosition    ForkDropout     $BB_Position ]
        #

        
        # --- create Steerer ---------------------
        #
    set node_Steerer        [myGUI::model::model_XZ::getComponent   Steerer]
    set object_Steerer      [$cvObject create svg  $position_Fork  [list -svgNode $node_Steerer  -angle $angle_Crown  -tags __ForkSteerer__]]
        #
    $cvObject addtag  __Fork__ withtag $object_Steerer
    

        # --- ForkSupplier 
    set node_Fork           [myGUI::model::model_XZ::getComponent   ForkCrown]
    set object_Fork         [$cvObject create svg  $position_Fork  [list -svgNode $node_Fork  -angle $angle_Crown  -tags __ForkSupplier__]]
        #
    $cvObject addtag  __Fork__ withtag $object_Fork
        #
    switch -exact $updateCommand {
        editable -  
        selectable {            
                myGUI::gui::bind_objectEvent_2  $cvObject   $object_Fork  option_ForkType
            }
        default {}
    }
        #
    $cvObject create circle  $position_Dropout    -radius 4.5    -fill white    -tags __ForkDropoutPosition__
    $cvObject addtag  __Fork__  withtag __ForkDropoutPosition__
    $cvObject addtag  __Frame__ withtag __Fork__
        #
    return
        #
}


proc myGUI::rendering::createChain {cvObject BB_Position} {
        #
    set crankWheelPosition      [myGUI::model::model_XZ::getPosition    CrankSet   $BB_Position]
    set crankWheelTeethCount    [lindex [lsort [myGUI::model::model_XZ::getListValue CrankSetChainRings]] end]
    set casetteTeethCount       15
    set toothWith               12.7
    
          # puts ""
          # puts "   -------------------------------"
          # puts "    createChain"
          # puts "       teethCount:     $crankWheelTeethCount / $casetteTeethCount"   
            
    set Hub(position)           [myGUI::model::model_XZ::getPosition    RearWheel           $BB_Position ]
    set Derailleur(position)    [myGUI::model::model_XZ::getPosition    RearDerailleur      $BB_Position]
    
    set Pulley(x)               [myGUI::model::model_XZ::getScalar      RearDerailleur Pulley_x      ]
    set Pulley(y)               [myGUI::model::model_XZ::getScalar      RearDerailleur Pulley_y      ]
    set Pulley(teeth)           [myGUI::model::model_XZ::getScalar      RearDerailleur Pulley_teeth  ]
    
    set Pulley(position)        [vectormath::addVector $Derailleur(position) [list $Pulley(x) [expr -1.0*$Pulley(y)]] ]
           # puts "       Pulley:         $Pulley(x) / $Pulley(y)  $Pulley(teeth)"   
            
    
        # -----------------------------
        #   initValues
    set crankWheelRadius    [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/$crankWheelTeethCount]))]
    set casetteWheelRadius  [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/$casetteTeethCount]))]
    if {$Pulley(teeth) > 3} { 
        set pulleyRadius    [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/$Pulley(teeth)]))]
    } else {
        set pulleyRadius    [expr $toothWith/(2*sin([expr $vectormath::CONST_PI/2]))]
    }
                    
        # -----------------------------
        #   upper Section 
    set deltaRadius         [expr $crankWheelRadius - $casetteWheelRadius]   
    set p_ch_02 [vectormath::cathetusPoint $crankWheelPosition $Hub(position) $deltaRadius close]
      # $cvObject create circle  $p_ch_02          -radius 150  -outline red     -tags {__debug__}  -width 1
    set ang_02  [vectormath::dirAngle   $crankWheelPosition $p_ch_02]
    set p_01    [vectormath::rotateLine $Hub(position) $casetteWheelRadius $ang_02]
    set p_03    [vectormath::rotateLine $crankWheelPosition   $crankWheelRadius $ang_02]
      # $cvObject create circle  $p_ch_02          -radius 150  -outline red     -tags {__debug__}  -width 1
      # $cvObject create circle  $p_03             -radius  50  -outline red     -tags {__debug__}  -width 1
    set p_03    [vectormath::subVector $p_03 [vectormath::unifyVector $p_01 $p_03 40]]
      # $cvObject create circle  $p_03             -radius  30  -outline red     -tags {__debug__}  -width 1
    set p_02    [vectormath::center $p_01 $p_03]
    
    set polyline_00 {}
    set p_cas   $p_01
    set ang_cas [expr 360/$casetteTeethCount]
    set i       [expr round(0.5 * $casetteTeethCount - 2)]
    while {$i > 0} {
          # puts "   $i"
        set i [expr $i - 1]
        set p_cas [vectormath::rotatePoint $Hub(position) $p_cas $ang_cas]
        lappend polyline_00 $p_cas
    }
    set polyline_00 [lreverse $polyline_00]
    set polyline_01         [appUtil::flatten_nestedList $polyline_00 $p_01 $p_02]     
    set polyline_02         [appUtil::flatten_nestedList $p_02 $p_03]   
    
    
        # -----------------------------
        #   lower Section 
      # $cvObject create circle  $Pulley(position)      -radius 20  -outline red     -tags {__debug__}  -width 1  
    set deltaRadius         [expr $crankWheelRadius - $pulleyRadius]   
    set p_ch_03 [vectormath::cathetusPoint $Pulley(position) $crankWheelPosition $deltaRadius opposite]
      # $cvObject create circle  $p_ch_03       -radius  80  -outline red     -tags {__debug__}  -width 1
    set ang_03  [vectormath::dirAngle   $crankWheelPosition $p_ch_03]   
    set p_05    [vectormath::rotateLine $crankWheelPosition   $crankWheelRadius $ang_03]
      # $cvObject create circle  $p_05          -radius  20  -outline red     -tags {__debug__}  -width 1
    set p_06    [vectormath::rotateLine $Pulley(position) $pulleyRadius  $ang_03]

    set polyline_03         [appUtil::flatten_nestedList $p_05 $p_06]     
    
    
        # -----------------------------
        #   create representation
    set chainObject_01      [$cvObject create line    $polyline_01       -tags {__Decoration__ __Chain__ __Chain_Section_01__}    -fill gray70  -width 0.7 ]
    set chainObject_02      [$cvObject create line    $polyline_02       -tags {__Decoration__ __Chain__ __Chain_Section_02__}    -fill gray70  -width 0.7 ]
    set chainObject_03      [$cvObject create line    $polyline_03       -tags {__Decoration__ __Chain__ __Chain_Section_03__}    -fill gray70  -width 0.7 ]

    set tagName myTags
    $cvObject addtag $tagName withtag $chainObject_01
    $cvObject addtag $tagName withtag $chainObject_02
    $cvObject addtag $tagName withtag $chainObject_03
        #
    catch {$cvObject lower $chainObject_01  {__Frame__}    }
    catch {$cvObject lower $chainObject_02  {__DerailleurFront__} }
    catch {$cvObject lower $chainObject_03  {__CrankSet__ __DerailleurRear__} }
        #
    return $tagName
        #
}

proc myGUI::rendering::debug_geometry {cvObject BB_Position} {
        #
    puts ""
    puts "   -------------------------------"
    puts "    debug_geometry"
    puts "           ... please reimplement !"
    puts ""
        # tk_messageBox -message "debug_geometry"
    
    set debug_Geometry  [myGUI::modelAdapter::get_DebugGeometry]
    foreach key [dict keys $debug_Geometry] {
        puts "[format "         %20s ... %s"  $key [dict get $debug_Geometry $key] ]"
    }
    return 

    # foreach position [array names bikeGeometry::DEBUG_Geometry] 
            # puts "       name:            $position    $bikeGeometry__DEBUG_Geometry($position)"
        # set myPosition            [rattleCAD__model__getObject        DEBUG_Geometry            $bikeGeometry__DEBUG_Geometry($position)    $BB_Position ]
        # puts "         ... $position  $bikeGeometry__DEBUG_Geometry($position)"
        # puts "                    + ($BB_Position)"
        # puts "             -> $myPosition"
        # $cvObject create circle     $myPosition   -radius 5  -outline orange  -tags {__CenterLine__} -width 2.0
    # 
}






