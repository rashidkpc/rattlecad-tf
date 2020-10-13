 ##+##########################################################################
 #
 # package: bikeModel    ->    classPersistence.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/19
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
 #    namespace:  myGUI::persistence
 # ---------------------------------------------------------------------------
 #
 # http://www.magicsplat.com/articles/oo.html
 #
 #
 # 0.00 - 20160417
 #      ... new: rattleCAD - 3.4.03
 #
 #
 #


oo::class create myPersist::Persistence {
        #
    variable _parentObject
    variable persistenceDOM
        #
    constructor {} {
        puts "              -> superclass Persistence"
            #
        variable persistenceDOM {}
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... myGUI::persistence::Persistence  $target_method $args  ... unknown"
    }
        #
    method readFile_rattleCAD {fileName} {
            #
        variable persistenceDOM
            #
        puts "\n\n  ====== readFile_rattleCAD ========================\n"
        puts "  -- [info object class [self object]] -- readFile_rattleCAD --"
        puts "         ... fileName:        $fileName"
            #
        set persistenceDOM [my readFile_xml $fileName]
        if {$persistenceDOM == {}} {
            return
        }
            #
        set versionNode         [$persistenceDOM selectNodes /root/Project/rattleCADVersion/text()]
        set rattleCADVersion    [$versionNode asXML]
        puts "             -> [$versionNode asXML]"
            #
            #
        set _version [lrange [split $rattleCADVersion .] 0 2]
            # puts $persistVersion
        if {${_version} < "3 4 02"} {
            my update__3_4_01 $persistenceDOM
        }
        if {${_version} < "3 4 03"} {
            my update__3_4_02 $persistenceDOM
        }
        if {${_version} < "3 4 05"} {
            my update__3_4_04 $persistenceDOM
        }
            #
            #
        set _version [split $rattleCADVersion .]
            #
        if {${_version} < "3 4 05 24"} {
            my update__3_4_05 $persistenceDOM
        }
            #
            #
        set _version [lrange [split $rattleCADVersion .] 0 2]
            # puts $persistVersion
        if {${_version} < "3 5 06"} {
            my update__3_5_06 $persistenceDOM
        }
            #
            #
        set failureList [my checkProject_rattleCAD $persistenceDOM]
            #
        if {[llength $failureList] > 0} {
            foreach failurePath $failureList {
                my repairPersistanceDOM $persistenceDOM $failurePath
            }
        } else {
            puts "         -> failureList: [llength $failureList]"
        }
            #
        return $persistenceDOM
            #
    }
        #
    method readFile_xml {fileName} {
            #
        puts "  -- [info object class [self object]] -- readFile_xml --"
        puts "         ... fileName:        $fileName"
            #
        if { [file readable $fileName ] } {
                #
            set persistDOM  [myPersist::file::get_XMLContent $fileName show]
                #
            puts "         ... done"             
                #
            return $persistDOM
                #
        } else {
                #
            puts "         <W> ... could not read file"
            puts "                   ... $fileName\n"
                #
            return {}
                #
        }
    }
        #
    method writeFile_xml {persistDOM {mode {save}} {type {Road}} } {
            #
            # --- select File
        set types {
                {{Project Files 3.x }       {.xml}  }
            }
            
            #
        puts "\n\n  ====== s a v e  F I L E =========================\n"
            #
        puts "       ... saveProject_xml - ... \"[myGUI::control::getSession  projectFile]\""
        puts "       ... saveProject_xml - ... \"[myGUI::control::getSession  dateModified]\""
            #
            
            # set userDir       [check_user_dir rattleCAD]
        if  {[myGUI::control::getSession  projectFile] != {}} {
            set initialName [                myGUI::control::getSession  projectName ]
            set initialFile [file tail      [myGUI::control::getSession  projectFile]]
            set initialDir  [file dirname   [myGUI::control::getSession  projectFile]]
        } else {
            set initialName "... empty"
            set initialFile "... empty"
            set initialDir  "... empty"
        }
            
            #
        puts "       ... saveProject_xml - mode:            \"$mode\""
        puts "       ... saveProject_xml - USER_Dir:        \"$::APPL_Config(USER_Dir)\""
        puts "       ... saveProject_xml - PROJECT_File:    \"[myGUI::control::getSession  projectFile]\""
        puts "       ... saveProject_xml - PROJECT_Name:    \"[myGUI::control::getSession  projectName]\""
        puts "       ... saveProject_xml - ... initialName:     \"$initialName\""
        puts "       ... saveProject_xml - ... initialFile:     \"$initialFile\""
        puts "       ... saveProject_xml - ... initialDir:      \"$initialDir\""
            #
            
            #
            # check for template out of $::APPL_CONFIG(TEMPLATE_Dir)
        if {$initialDir == $::APPL_Config(TEMPLATE_Dir)} {
            set mode "saveAs"
            set initialDir $::APPL_Config(USER_Dir)
        }
            
            #
            # check for template out of $::APPL_CONFIG(CONFIG_Dir)
        set isTemplate 0
        if {$initialDir  == $::APPL_Config(CONFIG_Dir)} { set isTemplate 1}
        if {$initialName == {Template Road}}            { set isTemplate 1}
        if {$initialName == {Template MTB}}             { set isTemplate 1}
            #
        if $isTemplate {
            switch -exact $initialFile {
                {Template Road} { set initialFile        [format "%s%s.xml" $::APPL_Config(USER_InitString) Road] }
                {Template MTB}  { set initialFile        [format "%s%s.xml" $::APPL_Config(USER_InitString) MTB ] }
                default         {}
            }
                #
            set retValue [tk_messageBox -title   "Save Project" -icon question \
                            -message "Save Project as Template: $initialFile?" \
                            -default cancel \
                            -type    yesnocancel]
            puts "\n      $retValue\n"
                #
            switch $retValue {
                yes     {   myGUI::control::setSession  projectFile [file join $::APPL_Config(USER_Dir) $initialFile ]
                        }
                no      {   set mode        "saveAs"
                            set initialFile {new_Project.xml}
                        }
                cancel  {   return }
            }
        }

            #
        puts "       ---------------------------"
        puts "       ... saveProject_xml - mode:                \"$mode\""
        puts "       ... saveProject_xml - ... initialFile:     \"$initialFile\""
            #

            #
        switch $mode {
            {save}        {
                            set fileName    [file normalize [myGUI::control::getSession  projectFile]]
                                # set windowTitle    $fileName
                        }
            {saveAs}    {
                            set fileName    [tk_getSaveFile -initialdir $::APPL_Config(USER_Dir) -initialfile $initialFile -filetypes $types]
                            set fileName    [file normalize $fileName]
                                #
                                puts "       ... saveProject_xml - fileName:        $fileName"
                                # -- $fileName is not empty
                            if {$fileName == {} } return
                                # -- $fileName has extension xml
                                    # puts " [file extension $fileName] "
                            if {! [string equal [file extension $fileName] {.xml}]} {
                                set fileName [format "%s.%s" $fileName xml]
                                puts "           ... new $fileName"
                            }

                                # --- set runtime Attributes
                            #myGUI::control::setSession  projectFile       [file normalize $fileName]
                            #myGUI::control::setSession  projectName       [file rootname [file tail $fileName]]

                                # --- set window Title
                                # set windowTitle    $fileName
                        }
            default     {    return {}     }
        }
            #
        set projectSave    [clock milliseconds]
        set dateModified   [clock format [clock seconds] -format {%Y.%m.%d - %H:%M:%S}]
            #
            #
        [$persistDOM selectNodes /root/Project/rattleCADVersion/text()]  nodeValue [myGUI::control::getSession  rattleCADVersion]
        [$persistDOM selectNodes /root/Project/Name/text()]              nodeValue [file rootname [file tail $fileName]]
        [$persistDOM selectNodes /root/Project/modified/text()]          nodeValue $dateModified
            #

            #
        puts ""
        puts "            -> [myGUI::control::getSession  rattleCADVersion]"
        puts "            -> [myGUI::control::getSession  projectName]"
        puts "            -> [myGUI::control::getSession  dateModified]"
        puts ""
            #
       
            # -- open File for writing
        if {[file exist $fileName]} {
            if {[file writable $fileName]} {
                set fp [open $fileName w]
                puts $fp [$persistDOM  asXML]
                close $fp
                puts ""
                puts "         -- update ----------------------"
                puts "           ... write:"   
                puts "                       $fileName"
                puts "                   ... done"
            } else {
            tk_messageBox -icon error -message "File: \n   $fileName\n  ... not writeable!"
            saveProject_xml saveAs
            }
        } else {
                set fp [open $fileName w]
                puts $fp [$persistDOM  asXML]
                close $fp
                puts ""
                puts "         -- new--------------------------"
                puts "           ... write:"  
                puts "                       $fileName "
                puts "                   ... done"
        }

            #
            # set ::APPL_Config(PROJECT_Save) [clock milliseconds]
        myGUI::control::setSession  projectSave       $dateModified
            #
            
            # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
        #rattleCAD::view::update_windowTitle           $windowTitle
        #rattleCAD::view::update_MainFrameStatus
            #
        
            #
        puts "\n"
        puts "    ------------------------"
        puts "    saveProject_xml"     
        puts "            $fileName"
        puts "        ... done"

        puts "\n  ====== s a v e  F I L E =========================\n\n"
            #
            
            #
        return $fileName
            #
    }
        #
    method get_XMLContent {{fileName {}} {show {}}} {
            #
        set types {
                {{xml }       {.xml}  }
            }
        if {$fileName == {} } {
            set fileName [tk_getOpenFile -initialdir $::APPL_Config(USER_Dir) -filetypes $types]
        }
            # -- $fileName is not empty
        if {$fileName == {} } return
            #
        set fp [open $fileName]
            #
        fconfigure    $fp -encoding utf-8
        set xml [read $fp]
        close         $fp
            #
        set doc  [dom parse  $xml]
        set root [$doc documentElement]
            #
            # -- fill tree
            #
        if {$show != {}} {
            # rattleCAD::cfg_report::fillTree "$root" root
        }
            #
            # -- return root  document
            #
        return $root
    }
        #
    method get_persistenceKeys {} {
            #
            # mode:   persist_2_domain  
            #         domain_2_persist
            #
            #
        set keyList {            
                /root/Component/BottleCage/DownTube/File
                /root/Component/BottleCage/DownTube/OffsetBB
                /root/Component/BottleCage/DownTube_Lower/File
                /root/Component/BottleCage/DownTube_Lower/OffsetBB
                /root/Component/BottleCage/SeatTube/File
                /root/Component/BottleCage/SeatTube/OffsetBB
                /root/Component/Brake/Front/File
                /root/Component/Brake/Front/LeverLength
                /root/Component/Brake/Front/Offset
                /root/Component/Brake/Rear/File
                /root/Component/Brake/Rear/LeverLength
                /root/Component/Brake/Rear/Offset
                /root/Component/Carrier/Front/File
                /root/Component/Carrier/Front/x
                /root/Component/Carrier/Front/y
                /root/Component/Carrier/Rear/File
                /root/Component/Carrier/Rear/x
                /root/Component/Carrier/Rear/y
                /root/Component/CrankSet/ArmWidth
                /root/Component/CrankSet/ChainLine
                /root/Component/CrankSet/ChainRingOffset
                /root/Component/CrankSet/ChainRings
                /root/Component/CrankSet/File
                /root/Component/CrankSet/Length
                /root/Component/CrankSet/PedalEye
                /root/Component/CrankSet/Q-Factor
                /root/Component/CrankSet/SpyderArmCount
                /root/Component/Derailleur/Front/Distance
                /root/Component/Derailleur/Front/File
                /root/Component/Derailleur/Front/Offset
                /root/Component/Derailleur/Rear/File
                /root/Component/Derailleur/Rear/Pulley/teeth
                /root/Component/Derailleur/Rear/Pulley/x
                /root/Component/Derailleur/Rear/Pulley/y
                /root/Component/Fender/Front/Height
                /root/Component/Fender/Front/OffsetAngle
                /root/Component/Fender/Front/OffsetAngleFront
                /root/Component/Fender/Front/Radius
                /root/Component/Fender/Rear/Height
                /root/Component/Fender/Rear/OffsetAngle
                /root/Component/Fender/Rear/Radius
                /root/Component/Fender/Rear/Width
                /root/Component/Fork/Blade/BendRadius
                /root/Component/Fork/Blade/DiameterDO
                /root/Component/Fork/Blade/EndLength
                /root/Component/Fork/Blade/TaperLength
                /root/Component/Fork/Blade/Width
                /root/Component/Fork/Crown/Blade/Offset
                /root/Component/Fork/Crown/Blade/OffsetPerp
                /root/Component/Fork/Crown/Brake/Angle
                /root/Component/Fork/Crown/Brake/Offset
                /root/Component/Fork/Crown/File
                /root/Component/Fork/DropOut/File
                /root/Component/Fork/DropOut/Offset
                /root/Component/Fork/DropOut/OffsetPerp
                /root/Component/Fork/Height
                /root/Component/Fork/Rake
                /root/Component/Fork/Supplier/File
                /root/Component/HandleBar/File
                /root/Component/HandleBar/PivotAngle
                /root/Component/HeadSet/Bottom/Height
                /root/Component/HeadSet/Bottom/Diameter
                /root/Component/HeadSet/Top/Height
                /root/Component/HeadSet/Top/Diameter
                /root/Component/Label/File
                /root/Component/Saddle/File
                /root/Component/Saddle/Height
                /root/Component/Saddle/Length
                /root/Component/Saddle/LengthNose
                /root/Component/SeatPost/Diameter
                /root/Component/SeatPost/PivotOffset
                /root/Component/SeatPost/Setback
                /root/Component/Stem/Angle
                /root/Component/Stem/Length
                /root/Component/Wheel/Front/RimDiameter
                /root/Component/Wheel/Front/RimHeight
                /root/Component/Wheel/Front/TyreHeight
                /root/Component/Wheel/Rear/FirstSprocket
                /root/Component/Wheel/Rear/HubWidth
                /root/Component/Wheel/Rear/RimDiameter
                /root/Component/Wheel/Rear/RimHeight
                /root/Component/Wheel/Rear/TyreHeight
                /root/Component/Wheel/Rear/TyreWidth
                /root/Component/Wheel/Rear/TyreWidthRadius
                /root/Custom/BottomBracket/Depth
                /root/Custom/DownTube/OffsetBB
                /root/Custom/DownTube/OffsetHT
                /root/Custom/HeadTube/Angle
                /root/Custom/SeatStay/OffsetTT
                /root/Custom/SeatTube/Extension
                /root/Custom/SeatTube/OffsetBB
                /root/Custom/TopTube/Angle
                /root/Custom/TopTube/OffsetHT
                /root/Custom/TopTube/PivotPosition
                /root/Custom/WheelPosition/Rear
                /root/FrameTubes/ChainStay/CenterLine/angle_01
                /root/FrameTubes/ChainStay/CenterLine/angle_02
                /root/FrameTubes/ChainStay/CenterLine/angle_03
                /root/FrameTubes/ChainStay/CenterLine/angle_04
                /root/FrameTubes/ChainStay/CenterLine/length_01
                /root/FrameTubes/ChainStay/CenterLine/length_02
                /root/FrameTubes/ChainStay/CenterLine/length_03
                /root/FrameTubes/ChainStay/CenterLine/length_04
                /root/FrameTubes/ChainStay/CenterLine/radius_01
                /root/FrameTubes/ChainStay/CenterLine/radius_02
                /root/FrameTubes/ChainStay/CenterLine/radius_03
                /root/FrameTubes/ChainStay/CenterLine/radius_04
                /root/FrameTubes/ChainStay/DiameterSS
                /root/FrameTubes/ChainStay/Height
                /root/FrameTubes/ChainStay/HeightBB
                /root/FrameTubes/ChainStay/Profile/completeLength
                /root/FrameTubes/ChainStay/Profile/cuttingAngle
                /root/FrameTubes/ChainStay/Profile/cuttingLeft
                /root/FrameTubes/ChainStay/Profile/cuttingLength
                /root/FrameTubes/ChainStay/Profile/length_01
                /root/FrameTubes/ChainStay/Profile/length_02
                /root/FrameTubes/ChainStay/Profile/length_03
                /root/FrameTubes/ChainStay/Profile/width_00
                /root/FrameTubes/ChainStay/Profile/width_01
                /root/FrameTubes/ChainStay/Profile/width_02
                /root/FrameTubes/ChainStay/TaperLength
                /root/FrameTubes/ChainStay/WidthBB
                /root/FrameTubes/DownTube/DiameterBB
                /root/FrameTubes/DownTube/DiameterHT
                /root/FrameTubes/DownTube/TaperLength
                /root/FrameTubes/HeadTube/Diameter
                /root/FrameTubes/HeadTube/DiameterTaperedBase
                /root/FrameTubes/HeadTube/DiameterTaperedTop
                /root/FrameTubes/HeadTube/HeightTaperedBase
                /root/FrameTubes/HeadTube/Length
                /root/FrameTubes/HeadTube/LengthTapered
                /root/FrameTubes/SeatStay/DiameterCS
                /root/FrameTubes/SeatStay/DiameterST
                /root/FrameTubes/SeatStay/TaperLength
                /root/FrameTubes/SeatTube/DiameterBB
                /root/FrameTubes/SeatTube/DiameterTT
                /root/FrameTubes/SeatTube/TaperLength
                /root/FrameTubes/TopTube/DiameterHT
                /root/FrameTubes/TopTube/DiameterST
                /root/FrameTubes/TopTube/TaperLength
                /root/Lugs/BottomBracket/ChainStay/Angle/plus_minus
                /root/Lugs/BottomBracket/ChainStay/Angle/value
                /root/Lugs/BottomBracket/ChainStay/Offset_TopView
                /root/Lugs/BottomBracket/Diameter/inside
                /root/Lugs/BottomBracket/Diameter/outside
                /root/Lugs/BottomBracket/DownTube/Angle/plus_minus
                /root/Lugs/BottomBracket/DownTube/Angle/value
                /root/Lugs/BottomBracket/Excenter/Offset
                /root/Lugs/BottomBracket/Width
                /root/Lugs/HeadTube/DownTube/Angle/plus_minus
                /root/Lugs/HeadTube/DownTube/Angle/value
                /root/Lugs/HeadTube/TopTube/Angle/plus_minus
                /root/Lugs/HeadTube/TopTube/Angle/value
                /root/Lugs/RearDropOut/Angle/plus_minus
                /root/Lugs/RearDropOut/Angle/value
                /root/Lugs/RearDropOut/ChainStay/Offset
                /root/Lugs/RearDropOut/ChainStay/OffsetPerp
                /root/Lugs/RearDropOut/ChainStay/Offset_TopView
                /root/Lugs/RearDropOut/Derailleur/x
                /root/Lugs/RearDropOut/Derailleur/y
                /root/Lugs/RearDropOut/Direction
                /root/Lugs/RearDropOut/File
                /root/Lugs/RearDropOut/RotationOffset
                /root/Lugs/RearDropOut/SeatStay/Offset
                /root/Lugs/RearDropOut/SeatStay/OffsetPerp
                /root/Lugs/SeatTube/SeatStay/Angle/plus_minus
                /root/Lugs/SeatTube/SeatStay/Angle/value
                /root/Lugs/SeatTube/SeatStay/MiterDiameter
                /root/Lugs/SeatTube/TopTube/Angle/plus_minus
                /root/Lugs/SeatTube/TopTube/Angle/value
                /root/Personal/HandleBar_Distance
                /root/Personal/HandleBar_Height
                /root/Personal/InnerLeg_Length
                /root/Personal/Saddle_Distance
                /root/Personal/Saddle_Height
                /root/Reference/HandleBar_Distance
                /root/Reference/HandleBar_Height
                /root/Reference/SaddleNose_Distance
                /root/Reference/SaddleNose_Height
                /root/Rendering/BottleCage/DownTube
                /root/Rendering/BottleCage/DownTube_Lower
                /root/Rendering/BottleCage/SeatTube
                /root/Rendering/Brake/Front
                /root/Rendering/Brake/Rear
                /root/Rendering/ChainStay
                /root/Rendering/ColorScheme/Fork
                /root/Rendering/ColorScheme/FrameTubes
                /root/Rendering/ColorScheme/Label
                /root/Rendering/Fender/Front
                /root/Rendering/Fender/Rear
                /root/Rendering/Fork
                /root/Rendering/ForkBlade
                /root/Rendering/ForkDropOut
                /root/Rendering/HeadTube
                /root/Rendering/RearDropOut
                /root/Rendering/RearMockup/CassetteClearance
                /root/Rendering/RearMockup/ChainWheelClearance
                /root/Rendering/RearMockup/CrankClearance
                /root/Rendering/RearMockup/DiscClearance
                /root/Rendering/RearMockup/DiscDiameter
                /root/Rendering/RearMockup/DiscOffset
                /root/Rendering/RearMockup/DiscWidth
                /root/Rendering/RearMockup/TyreClearance
                /root/Rendering/Saddle/Offset_X
        }
        return $keyList
    }
        #
        #
    method update__3_4_01 {persistDOM} {
            #
            #   /root/Custom/SeatStay/OffsetTT
            #
        puts "  -- [info object class [self object]] -- update__3_4_01 --"
            #
        return
            #
        
            # /root/Component/CrankSet/ChainRingOffset
            # /root/FrameTubes/HeadTube/DiameterTaperedBase
            # /root/FrameTubes/HeadTube/DiameterTaperedTop
            # /root/FrameTubes/HeadTube/HeightTaperedBase
            # /root/FrameTubes/HeadTube/LengthTapered
            # /root/Rendering/ColorScheme/Fork
            # /root/Rendering/ColorScheme/FrameTubes
            # /root/Rendering/ColorScheme/Label
            # /root/Rendering/HeadTube

            # <W> could not set: ::bikeGeometry::Component(ForkSupplier)
            # <W> could not set: ::bikeGeometry::Config(Color_Fork)
            # <W> could not set: ::bikeGeometry::Config(Color_FrameTubes)
            # <W> could not set: ::bikeGeometry::Config(Color_Label)
            # <W> could not set: ::bikeGeometry::Config(HeadTube)
            # <W> could not set: ::bikeGeometry::CrankSet(ChainRingOffset)                
            # <W> could not set: ::bikeGeometry::HeadTube(DiameterTaperedBase)
            # <W> could not set: ::bikeGeometry::HeadTube(DiameterTaperedTop)
            # <W> could not set: ::bikeGeometry::HeadTube(HeightTaperedBase)
            # <W> could not set: ::bikeGeometry::HeadTube(LengthTapered)                
            
            
            
            
        set xPath "/root/Custom/SeatStay/OffsetTT"
        puts "              $xPath"        
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode != {}} {
                #
            set nodeValue   [$searchNode  asXML]
                #
            puts $nodeValue
            if  {$nodeValue != {}} {
                set nodeValue [expr -1.0 * $nodeValue]
                $searchNode nodeValue $nodeValue
            } 
                #
        }
    }
        #
    method update__3_4_02 {persistDOM} {
            #
            #   /root/Custom/SeatStay/OffsetTT
            #
        puts "  -- [info object class [self object]] -- update__3_4_02 --"
            #
        set xPath "/root/Custom/SeatStay/OffsetTT"
        puts "              $xPath"        
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode != {}} {
                #
            set nodeValue   [$searchNode  asXML]
                #
            puts $nodeValue
            if  {$nodeValue != {}} {
                set nodeValue [expr -1.0 * $nodeValue]
                $searchNode nodeValue $nodeValue
            } 
                #
        }   
            #
        set xPath "/root/Lugs/RearDropOut/ChainStay/OffsetPerp"
        puts "              $xPath"        
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode != {}} {
                #
            set nodeValue   [$searchNode  asXML]
                #
            puts $nodeValue
            if  {$nodeValue != {}} {
                set nodeValue [expr -1.0 * $nodeValue]
                $searchNode nodeValue $nodeValue
            } 
                #
        }   
            #
        set xPath "/root/Lugs/RearDropOut/SeatStay/OffsetPerp"
        puts "              $xPath"        
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode != {}} {
                #
            set nodeValue   [$searchNode  asXML]
                #
            puts $nodeValue
            if  {$nodeValue != {}} {
                set nodeValue [expr -1.0 * $nodeValue]
                $searchNode nodeValue $nodeValue
            } 
                #
        }
    }
        #
    method update__3_4_04 {persistDOM} {
            #
            #   /root/Custom/SeatStay/OffsetTT
            #
        puts "  -- [info object class [self object]] -- update__3_4_04 --"
            #
        set xPath "/root/Lugs/BottomBracket/Excenter/Offset"
        puts "              $xPath"        
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode == {}} {
                #
            set parentNode  [$persistDOM selectNodes [file dirname [file dirname $xPath]]]
            $parentNode appendXML "<Excenter>
                                        <Offset>0.00</Offset>
                                    </Excenter>"
            #
        }
    }
        #
    method update__3_4_05 {persistDOM} {
            #
            #   /root/Custom/SeatStay/OffsetTT
            #
        puts "  -- [info object class [self object]] -- update__3_4_05 --"
            #
        set xPath "/root/FrameTubes/ChainStay/Profile/cuttingAngle"
        puts "              $xPath"  
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode == {}} {
                #
            set parentNode  [$persistDOM selectNodes [file dirname $xPath]]
            $parentNode appendXML "<cuttingAngle>90.00</cuttingAngle>"
                #
        }
            #
    }
        #
        #
        #
    method update__3_5_06 {persistDOM} {
            #
            #   /root/Custom/SeatStay/OffsetTT
            #
        puts "  -- [info object class [self object]] -- update__3_5_06 --"
            #
        set xPath "/root/Component/Fender/Rear/Width"
        puts "              $xPath"  
            #
        set searchNode  [$persistDOM selectNodes $xPath/text()]
            #
        if {$searchNode == {}} {
                #
            set parentNode  [$persistDOM selectNodes [file dirname $xPath]]
            $parentNode appendXML "<Width>45.00</Width>"
                #
        }
            #
    }
        #
        #
    method checkProject_rattleCAD {persistDOM} {
            #
        puts "  -- [info object class [self object]] -- checkProject_rattleCAD --"
            #
            
            #
        set failureList {}    
            #
        foreach persistenceKey [my get_persistenceKeys] {
                # puts "             update_persistenceDOM -> $persistKey"
                #
            set persistNode [$persistDOM selectNodes $persistenceKey/text()]
            if {$persistNode == {}} {
                lappend failureList $persistenceKey
            } else {
                # puts "            -> $persistenceKey"
            }
                #
        }
            #
        if {[llength $failureList] > 0} {
            puts "\n"
            puts "  -- myGUI::persistence::Persistence  checkProject_rattleCAD --"
            puts ""
            puts "          failureList:"
            foreach entry $failureList {
                puts "              $entry"
            }
        }
            #
        return $failureList
            #
    }
        #
    method repairPersistanceDOM {persistDOM xPath} {
            #
        puts "\n"
        puts "  ---- myGUI::persistence::persistence::repairPersistanceDOM --"
        puts "              $xPath"
        puts ""
        
        switch -exact $xPath {
            /root/Component/CrankSet/SpyderArmCount {   my repair__SpyderArmCount  $persistDOM $xPath  }
            /root/Component/Label/File              {   my repair__LabelFile       $persistDOM $xPath  }
            /root/Component/HeadSet/Bottom/Height   {   my repair__HeadSet         $persistDOM $xPath  }
            /root/Component/HeadSet/Bottom/Diameter {   my repair__HeadSet         $persistDOM $xPath  }
            /root/Component/HeadSet/Top/Height      {   my repair__HeadSet         $persistDOM $xPath  }
            /root/Component/HeadSet/Top/Diameter    {   my repair__HeadSet         $persistDOM $xPath  }
            default {}
        }
            #  /root/Component/Label/File
            #  /root/Rendering/ColorScheme/Fork
            #  /root/Rendering/ColorScheme/FrameTubes
            #  /root/Rendering/ColorScheme/Label
        return
            #
    }
        #
    method repair__SpyderArmCount {persistDOM xPath} {
            #
            #   /root/Component/CrankSet/SpyderArmCount
            #
        puts ""
        puts "  ------ myGUI::persistence::persistence::repair__SpyderArmCount --"
        puts "              $xPath"        
            #
        set targetPath  [file dirname $xPath]
        set targetNode  [$persistDOM selectNodes $targetPath]
            #
        set node_3402 [$persistDOM selectNodes /root/Rendering/CrankSet/SpyderArmCount/text()]
            #
        if {$node_3402 != {}} {
                #
            set nodeValue [$node_3402 asXML]
            puts "                  found: $nodeValue"
            set moveNode    [$persistDOM selectNodes /root/Rendering/CrankSet/SpyderArmCount]
            set parentNode  [$moveNode parentNode]
            $parentNode removeChild $moveNode
            $targetNode appendChild $moveNode
                #
            set deleteNode  $parentNode
            set parentNode  [$deleteNode parentNode]
            $parentNode removeChild $deleteNode
            $deleteNode delete
                #
        } else {
            $targetNode appendXML "<SpyderArmCount>5</SpyderArmCount>"
            puts "                  attached: 5 ... as Default"
        }
            #
        return
            #
    }
        #
    method repair__LabelFile {persistDOM xPath} {
            #
            #   /root/Component/Label/File
            #
        puts ""
        puts "  ------ myGUI::persistence::persistence::repair__LabelFile --"
        puts "              $xPath"        
            #
        set targetPath  [file dirname $xPath]
        set targetNode  [$persistDOM selectNodes $targetPath]
            #
        set searchNode  [$persistDOM selectNodes /root/Component/Logo/File/text()]
            #
        if {$searchNode != {}} {
                #
            set nodeValue [$searchNode asXML]
            set nodeValue  [string map {logo label} $nodeValue]
                #
            set deleteNode [$persistDOM selectNodes /root/Component/Logo]
            set parentNode [$deleteNode parentNode]
                #
            $parentNode removeChild $deleteNode
            $deleteNode delete
                #
        } else {
            set nodeValue "etc:label/rattleCAD_22.svg"
        }
            #
        set parentNode [$persistDOM selectNodes /root/Component]
        $parentNode appendXML " <Label>
                                    <File>$nodeValue</File>
                                </Label>"             
            #
        return
            #
    }
        #
    method repair__HeadSet {persistDOM xPath} {
            #
            #   /root/Component/HeadSet
            #
        puts ""
        puts "  ------ myGUI::persistence::persistence::repair_HeadSet --"
        puts "              $xPath"                
            #
            # <HeadSet>
            #     <Height>
            #         <Bottom>13.50</Bottom>
            #         <Top>15.50</Top>
            #     </Height>
            #     <Diameter>45.00</Diameter>
            # </HeadSet>                  
        set searchNode  [$persistDOM selectNodes $xPath]
        set parentNode  [$persistDOM selectNodes [file dirname [file dirname $xPath]]]
            # puts [$parentNode asXML]
        
        if {$searchNode != {}} {
            # puts [$parentNode asXML]
            return
        }
            
            #
        set heightBottom  [[$parentNode selectNodes Height/Bottom/text()] asXML]
        set heightTop     [[$parentNode selectNodes Height/Top/text()] asXML]
        set diameter      [[$parentNode selectNodes Diameter/text()] asXML]
            #
            # puts "    heightBottom  $heightBottom"
            # puts "    heightTop     $heightTop"
            # puts "    diameter      $diameter"
            #
        $parentNode appendXML \
               "<Bottom>
                    <Diameter>$diameter</Diameter>
                    <Height>$heightBottom</Height>
                </Bottom>"
        $parentNode appendXML \
               "<Top>
                    <Diameter>$diameter</Diameter>
                    <Height>$heightTop</Height>
                </Top>"
            #
        set deleteNode [$parentNode selectNodes Diameter]
        $parentNode removeChild $deleteNode
        $deleteNode delete
            #
        set deleteNode [$parentNode selectNodes Height]  
        $parentNode removeChild $deleteNode
        $deleteNode delete
            #
        return
            #
    }
        #
    method updatePersistenceDOM {domainDOM persistDOM} {
            #
            # ... replace: 
            #   namespace import ::bikeGeometry::set_newProject
            #       ::bikeGeometry::set_newProject $projectDOM
            #
            # puts "[$domainDOM asXML]"   
            #
        set mappingDict [my getMappingDict domain_2_persist]
        exit
            #
        foreach persistKey [dict keys [dict get $mappingDict mapping]] {
                # puts "             update_persistenceDOM -> $persistKey"
            set domain_xPath [dict get $mappingDict mapping $persistKey]
                # puts "                          domain_xPath  -> $domain_xPath"
            set domainNode      [$domainDOM selectNodes /root/$domain_xPath/text()]
            set modelValue     [$domainNode asXML]
                # puts "                                    -> $modelValue"
                #
            set persistNode    [$persistDOM selectNodes $persistKey/text()]
            if {$persistNode != {}} {
                set persistValue   [$persistNode nodeValue  $modelValue]
            } else {
                puts "    <W> ... $persistKey failed in [namespace current]::update_persistenceDOM"
            }
                #
        }
            #
        set removeNode  [$persistDOM selectNodes /root/Result]
        if {$removeNode != {}} {
            set parentNode      [$removeNode parentNode]
            $parentNode removeChild $removeNode
            $removeNode delete   
        }
            #
        #set persistDoc  [$persistDOM ownerDocument]
            #

            #
        return $persistDOM
            #
    }
        #
}