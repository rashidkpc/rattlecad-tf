 ##+##########################################################################
 #
 # package: myGUI    ->    _control.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2016/08/22
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
 #    namespace:  myGUI::control
 # ---------------------------------------------------------------------------
 #
 # 


namespace eval myGUI::control {

    # variable  currentDICT    {} ;# a dictionary
    # variable  currentDOM     {} ;# a XML-Object
    
    variable  project_Saved  {0}
    variable  project_Name   {0}
        # ----------------- #
    variable  model_Update   {0}
    variable  window_Update  {0}
    variable  window_Size    {0}
        # ----------------- #
    variable _lastValue
    variable _currentValue; array set _currentValue {}
        # ----------------- #
    variable  Session              
    array set Session {
                rattleCADVersion  {}
                dateModified      {init}
                projectName       {}
                projectFile       {}
                projectSave       {}
            }
        # ----------------- #
    variable    frame_configMode    {OutsideIn}
        # variable    frame_chainStayType {}
        # ----------------- #
    variable    rattleCAD_plugIn; array set rattleCAD_plugIn {}  
        # ----------------- #
        #
    variable    rattleCAD_STDOUT  {}  
        # ----------------- #
        #
        # ----------------- #	
    #variable geometry_IF        ::bikeGeometry::IF_OutsideIn
        #
    #namespace import ::bikeGeometry::set_Config
    #namespace import ::bikeGeometry::set_Component
    #namespace import ::bikeGeometry::set_ListValue  
}

    #
proc myGUI::control::updateControl {} {
    
    puts "\n"
    puts "    =========== myGUI::control::updateControl ==============-start-=="
         #
    variable model_Update
    
        #
        # update model model_Edit, continue here
        # update model model_ZX, continue here
        
        #
        # -- summaryze values in modelAdapter
    myGUI::modelAdapter::updateModel
        #
        # -- update model_Info
    myGUI::modelAdapter::updateModel_Info       ::myGUI::model::model_Info   
        #
        # -- update model_Edit
    myGUI::modelAdapter::updateModel_Edit       ::myGUI::model::model_Edit   
        #
        # -- update model_TubeMiter
    myGUI::modelAdapter::updateModel_TubeMiter  ::myGUI::model::model_TubeMiter
        #
        # -- update model_XZ
    myGUI::modelAdapter::updateModel_XZ         ::myGUI::model::model_XZ
        #
        # -- update model_XY
    myGUI::modelAdapter::updateModel_XY         ::myGUI::model::model_XY
        #
        # myGUI::model::model_XZ::reportModel
        #
        # myGUI::model::model_XZ::compareModel {40 50}
        #
        # myGUI::cvCustom::set_DebugValues {40 50}
        #
        
        # -- set model timestamp
    set model_Update  $myGUI::modelAdapter::modelUpdate 
        #
        # -- update view
        #
    myGUI::view::edit::set_Color frameTubeColor [::myGUI::model::model_Edit::getValue Config Color_FrameTubes]
    myGUI::view::edit::set_Color forkColor      [::myGUI::model::model_Edit::getValue Config Color_Fork]
    myGUI::view::edit::set_Color labelColor     [::myGUI::model::model_Edit::getValue Config Color_Label] 
        #
    myGUI::view::edit::updateView  
        #
    myGUI::view::edit::update_windowTitle       [myGUI::control::getSession  projectName] 
    myGUI::view::edit::update_MainFrameStatus

        #
    puts "\n"
    puts   "      myGUI::control::Session:"
    puts   "          [myGUI::control::getSession  projectFile]"
    puts   "          [myGUI::control::getSession  projectName]"
    puts   "          [myGUI::control::getSession  projectSave]"
    puts   "          [myGUI::control::getSession  dateModified]"
    puts   "          [myGUI::control::getSession  rattleCADVersion]\n"
    puts   ""
    puts "    =========== myGUI::control::updateControl ================-end-=="            
        # 
    return
        #
}
    #
    #
proc myGUI::control::setFrameConfigMode {} {
        #
    variable frame_configMode
        #
    switch -exact $frame_configMode {
        {OutsideIn}  -
        {StackReach} -
        {Lugs}       -
        {Classic}   {
            if {[myGUI::modelAdapter::set_geometry_IF $frame_configMode]} {
                    # puts "   <I>  myGUI::control::setFrameConfigMode ... $frame_configMode"
                    # set steering parameter in myGUI::gui
                set myGUI::gui::frame_configMethod $frame_configMode
                    # update view
                myGUI::view::edit::updateView force
                    #
            }
        }
        default         {}            
    }            
        #
}
    #
proc myGUI::control::setChainStayType {} {
        #
    puts "-----> myGUI::control::setChainStayType"
        #
    set valueKey    "Config:ChainStay"
    set varName     [format {%s::%s(%s)} ::myGUI::view::edit _viewValue $valueKey]
    set chainStayType [set $varName]
        #
    switch -exact $chainStayType {
        {straight}  -
        {bent} -
        {off}   {
            setValue [list Config:ChainStay $chainStayType]        
                # myGUI::modelAdapter::set_Config ChainStay $chainStayType
            puts "   <I>  myGUI::control::setFrameConfigMode ... $chainStayType"
                # update view
            myGUI::view::edit::updateView force
                #
        }
        default {}            
    }            
        #
}
    #
proc myGUI::control::init_Model {} {
        #
    myGUI::modelAdapter::init 
        #
    myGUI::modelAdapter::updateModel_Edit_ListBoxValues myGUI::model::model_Edit
        # puts "  -- myGUI::control::init_ListBoxValues "
        # myGUI::model::model_Edit::reportListBoxValues
        #
        # exit
}
    #
    #
    #
proc myGUI::control::setValue {keyValueList {mode {update}} {history {append}}} {
        #
        # -- setValue gets key and value as a list
        #           like { key1 value1  key2 value2  key3 value3 ...}
        #
    puts ""
    puts "  =========== myGUI::control::setValue ===========================-start-=="
        #
    variable  Session
        #
        # -- set busy cursor
    set currentTab      [$myGUI::gui::noteBook_top select]
    set cvObject        [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
    catch {$cvObject    configure   Canvas  Cursor  watch}          
        #
        #
        
        #
        # -- start time stopping
    set timeStart       [clock milliseconds]
        #

        #
    set doUpdate    0
    set loopCount   0
    set currentList {}
    set updateList  {}
        #
    puts "\n"
    puts "    -> [llength $keyValueList] <- $keyValueList"
    puts "\n"
        #
        #
        # -- check for doing update
        #
    foreach {valueKey value} $keyValueList {
            #
            # puts "   -> valueKey = value:   $valueKey  $value"
            #
        incr loopCount 1
            #
        puts ""
        puts "    =========== myGUI::control::setValue ===========-loop-==-start-==-${loopCount}-"
        puts ""
        puts "              \$mode/\$history .... $mode/$history\n"
            #
        foreach {arrayName arrayKey} [split $valueKey :] break
        set modelValue      [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
        puts "              \$valueKey   $valueKey: ... old: $modelValue ->  new: $value\n"
            #
            # -- check for equal value
        if {$value == $modelValue} { 
            puts "              ... equal values!"
            puts "             -------------------------------"
            continue
        }
            #
            # -- check for exception
            #     -- Project/* does not influence the model
        switch -exact $arrayName {
            Project {
                continue				
            }
            default {}
        }
            #
            # -- check mode (force/update)
            #
        switch -exact $mode {
            {force} -
            {update} {
                    #
                set doUpdate    1
                    #
                set keyList  [split $arrayKey /]
                set rootName $arrayName
                puts ""
                puts "              -> <D>  $rootName $keyList $value"
                puts "                         -> \$valueKey  $valueKey"
                switch -exact $valueKey {
                    Component:ForkSupplier {set updateKey Component:ForkCrown}
                    default                {set updateKey $valueKey}
                }
                puts "                         -> \$updateKey $updateKey"
                    # set newValue  [myGUI::modelAdapter::set_Value   $updateKey   ${value}]
                lappend currentList $updateKey ${modelValue}
                lappend updateList  $updateKey ${value}
                    #
            }
            default {
                tk_messageBox -message "myGUI::control::setValue    $valueKey    ${value}    $mode    $history" 
            }
        }
            #
    }
        #
        #
        # -- do the update ($doUpdate eq 1)
        #
    puts "\n"
    puts "    -> [llength $updateList] <- $updateList"
    puts "\n"
        #
    set loopCount   0   
        #
    if $doUpdate {
            #
        if {[llength $updateList] == 2} {
                #
            foreach {updateKey value} $updateList break
                #
            puts "\n"
            puts "                         \$modelValue:    $modelValue"
            puts "                  -> myGUI::modelAdapter::set_Value:   $updateKey  -> ${value}"
                #
            set newValue  [myGUI::modelAdapter::set_Value   $updateKey   ${value}]
                #
            puts "                         \$newValue:      $newValue"
            puts ""
                #
            if {$newValue == {}} {
                puts "\n"
                puts "              <W>"
                puts "              <W> ... value  \"$value\"  not accepted for  $valueKey  ... :\("
                puts "              <W>"
                puts "\n\n"
                set myGUI::view::edit::_viewValue($valueKey) $modelValue
                catch {eval $cv_VarName   configure -cursor arrow}
                return
            }
                #
            if {$history == {append}} {
                    # ... in case of myGUI::modelAdapter::set_Value did not accept the new Value
                changeList::append        $valueKey $modelValue ${newValue}
            }
                # -- report update key
            puts ""
            puts "       \$valueKey:    $valueKey"
            puts "       \$value:       $value"
            puts "       \$modelValue:  $modelValue"
            puts "       \$newValue:    $newValue"
                #
        } else {
                #
            set newList [myGUI::modelAdapter::set_ValueList   $updateList]
                #
            if 0 {    
                puts "  --- old -------------"
                foreach {key value} $currentList {
                    puts "         old -> $key $value"
                }
                puts "  --- new -------------"
                foreach {key value} $newList {
                    puts "         new -> $key $value"
                }
            }
                #
            if {$history == {append}} {
                    # ... in case of myGUI::modelAdapter::set_Value did not accept the new Value
                
                foreach valueKey [dict keys $newList] {
                    set oldValue        [dict get $currentList  $valueKey]
                    set newValue        [dict get $newList      $valueKey]
                    changeList::append  $valueKey $oldValue ${newValue}
                }
            }
        }
            #
        puts ""
        puts "    =========== myGUI::control::setValue ===========-loop-====-end-==-${loopCount}-"
        puts ""
            #
    }    
        
        #
        # -- end time stopping
    set timeEnd     [clock milliseconds]
        #
        
        #
        # -- update View
    updateControl
        #
        
        #
        # -- reconfigur cursor
    catch {eval $cv_VarName   configure -cursor arrow}
        #
        
        #
        # -- after updating Values
        # puts "   -- <D> ----------------------------"
    puts "\n"
    foreach {key value} $keyValueList {
        puts "          -> $key -> $value"
    }
        #
        
        #
        # -- elapsed time to open file
    set timeUsed    [expr 0.001*($timeEnd - $timeStart)]
        #            
    puts "                 ... $timeUsed seconds to set value"
        #
        
        #
    puts ""
    puts "          ... history: $history"
        # puts "          ... $mode/$history"
    puts ""
    puts "  =========== myGUI::control::setValue ==========================-finish-=="
    puts ""
        #
    return
        # return $newValue

}
    #
    #
    #
proc myGUI::control::add_ComponentDir {key dir} {
        #
    set retValue    [myGUI::modelAdapter::add_ComponentDir $key $dir]
    puts "    myGUI::control::add_ComponentDir -> $retValue"
        #
    set_ComponentDirectories
        #
    return $retValue
        #
}
    #
proc myGUI::control::setSession {name value} {
    variable  Session
    set Session($name) "${value}"
}
    #
    #
proc myGUI::control::importSubset {nodeRoot} {
      # puts "[$nodeRoot asXML]"
    puts "\n"
    puts "   -------------------------------"
    puts "    myGUI::control::importSubset"
      #
    myGUI::modelAdapter::importSubset $nodeRoot	
      #
    [namespace current]::updateControl
      #
}
    #
    #
proc myGUI::control::check_saveCurrentProject {} {
        #
    set changeIndex [myGUI::control::changeList::get_changeIndex]
        #
    puts "\n"
    puts "  ====== s a v e   c u r r e n t   P r o j e c t  ="
    puts ""
    puts "         ... file:       [myGUI::control::getSession  projectFile]"
    puts "           ... saved:    [myGUI::control::getSession  projectSave]"
    puts "           ... modified: $changeIndex"
        #
    if { $changeIndex > 0 } {
        set retValue [tk_messageBox -title   "Save Project" -icon question \
                    -message "... save modifications in Project:  [myGUI::control::getSession projectFile] ?" \
                    -default cancel \
                    -type    yesnocancel]
        puts "\n           ... $retValue\n"
            #
        switch $retValue {
            yes     {   save_ProjectFile save
                        # saveProject_xml save
                        return  {continue}
                    }
            no      {   return  {continue}
                    }
            cancel  {   return  {break}
                    }
        }
    } else {
        return 0
    }
}
    #
proc myGUI::control::select_ProjectFile {{initialDir {}}} {
        # open rattleCAD-Project File
        #   points to initialDir
        #   file-type: xml
        #
        
        #
        # -- check current Project for modification
    if {[myGUI::control::check_saveCurrentProject] == {break}} {
        return
    }  
        
        #
        # -- check initialDir to select project Files from
    if {$initialDir == {}} {
        set initialDir $::APPL_Config(USER_Dir)
    }
    
        #
        # -- select projectFile
    set types {
            {{Project Files 3.x }       {.xml}  }
    }
    set fileName    [tk_getOpenFile -initialdir $initialDir -filetypes $types]
        #
        
        #
        # -- open project-Files
    if { [file readable $fileName ] } {
        myGUI::control::open_ProjectFile $fileName
    } else {
        return
    }
    
        #
        # -- handle as template      
    if {$initialDir == $::APPL_Config(TEMPLATE_Dir)} {            
        set projectName [file tail $fileName]
        myGUI::control::setSession  projectName       "Template $projectName"
        myGUI::control::setSession  projectSave       [expr 2 * [clock milliseconds]]
        myGUI::control::setSession  dateModified      "template"
    }

}
    #
proc myGUI::control::open_TemplateFile {type} {
        #
        # -- check current Project for modification
    if {[myGUI::control::check_saveCurrentProject] == {break}} {
        return
    }  
    
    
    puts "  ====== o p e n   T E M P L A T E ================"
    puts "         ... type:    $type"
    
        #
    set templateFile    [ myPersist::file::getTemplateFile $type ]
    puts "         ... templateFile:   $templateFile"
        #
    # puts "\n   -> FrameTubes/ChainStay/CenterLine/angle_03:  [rattleCAD__model__getValue FrameTubes/ChainStay/CenterLine/angle_03]"
    # puts "\n   -> FrameTubes/ChainStay/CenterLine/angle_04:  [rattleCAD__model__getValue FrameTubes/ChainStay/CenterLine/angle_04]"
    # puts "\n   -> FrameTubes/ChainStay/CenterLine/radius_01: [rattleCAD__model__getValue FrameTubes/ChainStay/CenterLine/radius_01]"

        #
    if { [file readable $templateFile ] } {
            #
        myGUI::control::open_ProjectFile $templateFile
            #
        # myGUI::control::setSession  projectFile       "Template"
        myGUI::control::setSession  projectName     "Template $type"
        myGUI::control::setSession  projectSave     [expr 2 * [clock milliseconds]]
        myGUI::control::setSession  dateModified    "template"
            #
        switch -exact $type {
            Road { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateRoad_default) }
            MTB  { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateMTB_default) }
        }
            #
    } else {
        tk_messageBox -message "... could not load template: $window_title"
    }
}
    #
proc myGUI::control::open_ProjectFile {projectFile} {
        # open rattleCAD-Project File
        #   points to $::APPL_Config(USER_Dir)
        #   file-type: xml

        #
        # -- start time stopping
    set timeStart    [clock milliseconds]
        #
        
        #
        # -- open project File
    if { [file readable $projectFile] } {
        myGUI::modelAdapter::open_ProjectFile $projectFile
    } else {
        return 
    }
    
        #
        # -- end time stopping
    set timeEnd     [clock milliseconds]
        #
    
        #
        # -- reset history
    [namespace current]::changeList::reset
        #
        
        #
        # -- remove position value in $myGUI::cvCustom::Position -> do a recenter
    myGUI::cvCustom::unsetPosition
        #
        
        #
        # -- update View
    [namespace current]::updateControl            
        #
        
        #
        # -- fill ReportTree
        # puts [$myGUI::modelAdapter::projectDOM asXML]
    myGUI::cfg_report::fillTree $myGUI::modelAdapter::persistenceRoot root
        #
        
        #
        # -- elapsed time to open file
    set timeUsed    [expr 0.001*($timeEnd - $timeStart)]
        #
        
        #
    puts "\n"
    puts "    ------------------------"
    puts "    open_ProjectFile"   
    puts "            [myGUI::control::getSession projectFile] "
    puts "            [myGUI::control::getSession projectName] "
    puts "                 ... $timeUsed seconds to open file"
    puts "        ... done"             
    puts "\n  ====== myGUI::control::open_ProjectFile =========================\n\n"            
        
        #
        # tk_messageBox -title "Demonstration" -message "elapsed time to open file: \n    $projectFile\n        $timeUsed seconds"
        #
    return    
        #
}         
    #
proc myGUI::control::save_ProjectFile {{mode {save}}} {
        # open template rattleCAD-Project File
        #   points to $::APPL_Config(TEMPLATE_Dir)
        #
        # --- from -- myPersist::file::openSampleProject_xml
        #
    myGUI::modelAdapter::save_ProjectFile $mode
        # myPersist::file::saveProject_xml $mode
}          
    #
    #
proc myGUI::control::getSession {name} {
    variable  Session
    set value [set Session($name)] 
    return ${value}
}
    #
proc myGUI::control::getValue {valueKey} {      
        #
    foreach {arrayName key} [split $valueKey :] break
        #
    puts "   -> myGUI::control::getValue $arrayName $key"
    set returnValue [myGUI::model::model_Edit::getValue  $arrayName $key]
    puts "   -> myGUI::control::getValue $returnValue"
    return ${returnValue}
        #
}
    #
proc myGUI::control::getListBoxContent {type {key {}}} {      
        #
        #   set optionNode    [$initDOM selectNodes /root/Options]
        #
    set listBoxContent {}
        # puts "       -> getListBoxContent:  $type $key"
        # myGUI::model::model_Edit::reportListBoxValues
        #
    switch -exact $type {
        {SELECT_Binary_OnOff}       { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  Binary_OnOff] }                 
        {SELECT_BottleCage}         { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  BottleCage] }
        {SELECT_BrakeType}          { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  Brake] }
        {SELECT_ChainStay}          { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  ChainStay] }
        {SELECT_DropOutDirection}   { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  DropOutDirection] }
        {SELECT_DropOutPosition}    { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  DropOutPosition] }
        {SELECT_ForkBladeType}      { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  ForkBlade] }
        {SELECT_ForkType}           { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  Fork] }
        {SELECT_FrameJigType}       { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  FrameJigType] }
        {SELECT_HeadTubeType}       { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  HeadTube] }
        {SELECT_Rim}                { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  Rim] }        
        {SELECT_StemType}           { set listBoxContent [myGUI::model::model_Edit::getListBoxValues  Stem] }        
        {SELECT_File}               { set listBoxContent [myGUI::modelAdapter::get_ComponentList      $key] }
        default                     {}
    }
        #
    switch -exact $type {
        {SELECT_ChainStay}          { lappend listBoxContent off}
        default {}
    }
        #
    puts "       -> getListBoxContent:  $type $key -> $listBoxContent"
        # myGUI::model::model_Edit::reportListBoxValues
        #
    return $listBoxContent
        #
}    
    #
proc myGUI::control::setListBoxContent {type domNode} {      
        #
    switch -exact $type {
        FrameJigType {
                    set valueList {}
                    foreach childNode [$domNode childNodes] {
                        set nodeName [$childNode nodeName]
                        lappend valueList $nodeName
                    }
                    myGUI::model::model_Edit::setListBoxValues $type $valueList
                }
        default {}
    }
        #
}    
    #
    #
proc myGUI::control::set_ComponentDirectories {} {
        # -- check if neccessary -- 20170105
    set retValue [myGUI::modelAdapter::get_ComponentDirectories]
        #
    foreach entry $retValue {
        foreach {key value} $entry break
         # puts "          -> $key  $value"
        switch -exact $key {
            cust {
                    set ::APPL_Config(CUSTOM_Dir) $value
                }
        }
    }
        # puts $retValue    
        #
    # parray ::APPL_Config    
        #
    # tk_messageBox -message $retValue
        # set ::APPL_Config(COMPONENT_Dir)    
        #
}
    #
proc myGUI::control::set_ComponentDir {} {
        # -- will be invalid in future
        #       orphan: 2017-01-07 - check this
    set ::APPL_Config(COMPONENT_Dir)    [myGUI::modelAdapter::get_ComponentDir]    
}
    #
proc myGUI::control::set_CompLocation {} {
        #
        # necessary for components tab
        #       orphan: 2017-01-07 - check this
        #
    array unset ::APPL_CompLocation 
    set dirList [myGUI::modelAdapter::get_ComponentSubDirectories]
    foreach node $dirList {
        set key     [lindex $node 0]
        set dir     [lindex $node 1]
        # puts "  childNode ->   $node   $key  $dir "
        set ::APPL_CompLocation($key) $dir
    }    
}
    #
proc myGUI::control::get_ComponentDirectory {} {
        # -- will be invalid in future
    set compDir [myGUI::modelAdapter::get_ComponentDir]
    return $compDir
        #
}
    #
proc myGUI::control::get_ComponentSubDirectories {} {
        # -- will be invalid in future
    set compDirs [myGUI::modelAdapter::get_ComponentSubDirectories]
    return $compDirs
        #
}
    #
proc myGUI::control::get_CompPath {key value} {
        #
    set compPath [myGUI::modelAdapter::get_ComponentPath $key $value]
    return $compPath
        #
}
    #
    #
proc myGUI::control::redirect_STDOUT {{stdoutFile {}}} {
        # http://wiki.tcl.tk/8502
        #
        # 	# redef_puts null
        #
    variable    rattleCAD_STDOUT
        #
    if {$stdoutFile eq {}} {
        set rattleCAD_STDOUT [open [file join $::APPL_Config(USER_Dir) _logFile.txt] w]
    } else {
        set rattleCAD_STDOUT [open $stdoutFile w]
    }
        #
        #puts "    -> myGUI::redirect_STDOUT"
        #
    return
        #
        # set ::APPL_Config(LogFile)          [open [file join $::APPL_Config(USER_Dir) _logFile.txt] w]

        #
    if ![llength [info command myGUI::control::_puts]] {
            #
        rename ::puts ::myGUI::control::_puts
            #
            #
        proc ::puts args {
                #
            set la [llength $args]
            if {$la<1 || $la>3} {
                error "usage: puts ?-nonewline? ?channel? string"
            }
                #
            set nl \n
            if {[lindex $args 0]=="-nonewline"} {
                set nl ""
                set args [lrange $args 1 end]
            }
                #
            if {[llength $args]==1} {
                set args [list stdout [join $args]]
            }
                #
            foreach {channel s} $args break
            switch -exact $channel {
                "stdout" -
                "stderr" {
                            set cmd ::myGUI::control::_puts
                            if {$nl==""} {lappend cmd -nonewline}
                            lappend cmd $channel $s
                            # We do not want to report errors writing to stdout
                            # eval $cmd
                            catch {eval $cmd}                        
                        }
                default {
                            set cmd ::myGUI::control::_puts
                            if {$nl==""} {lappend cmd -nonewline}
                            lappend cmd $channel $s
                            eval $cmd
                }
            }
                #
        }
                #  
            # -- that was the default implementation
        if 0 {
            if {$channel=="stdout" || $channel=="stderr"} {
                set cmd ::tcl::puts
                if {$nl==""} {lappend cmd -nonewline}
                lappend cmd $channel $s
                # We do not want to report errors writing to
                # stdout
                catch {eval $cmd}
            } else {
                set cmd ::tcl::puts
                if {$nl==""} {lappend cmd -nonewline}
                lappend cmd $channel $s
                eval $cmd
            }
        }
    }
}




    
    
    
    
    #
    #
#-------------------------------------------------------------------------
    #  exit application   
    #
proc myGUI::control::exit_rattleCAD {{type {yesnocancel}} {exitMode {}}} {   
        
    variable rattleCAD_STDOUT
    
    set changeIndex [myGUI::control::changeList::get_changeIndex]
        
        puts "\n"
        puts "  ====== e x i t   r a t t l e C A D =============="
        puts ""
        puts "         ... file:       [myGUI::control::getSession  projectFile]"
        puts "           ... saved:    [myGUI::control::getSession  projectSave]"
        puts "           ... modified: $changeIndex"
        puts "                     ... $myGUI::control::model_Update"
        puts ""
        puts "        ... type:        $type"
        puts "        ... exitMode:    $exitMode"

  
    if { $changeIndex > 0 } {
        
        puts " ......... save File before exit"
        puts "        project save:   [myGUI::control::getSession  projectSave]"
        puts "        project change: $myGUI::control::model_Update"

        set decission [tk_messageBox  -type $type \
                                      -icon warning \
                                      -title   "exit rattleCAD" \
                                      -message "Save current Project before EXIT"]
        puts "        ... save Project: $decission\n"
        puts "\n"
        
        switch  -exact -- $decission {
            {yes}     { 
                        # even if saved or not, because of handling of bind of <Destroy>
                        puts "        ... save current project\n"
                        myGUI::control::save_ProjectFile
                        #myPersist::file::saveProject_xml 
                      }
            {no}      {
                        # even if saved or not, because of handling of bind of <Destroy>
                        puts "        ... exit rattleCAD withoud saving current project\n"
                        myGUI::control::setSession  projectSave  [clock milliseconds]
                          # set ::APPL_Config(PROJECT_Save) [clock milliseconds] 
                      }
            {cancel}  {
                        # leef this control - go back to rattleCAD
                        puts "        ... exit rattleCAD canceled\n"
                        return
                      }
            default   {}
        }
        
        puts "\n"
        puts "        ... check file save by date\n\n"
        puts "  ====== e x i t   r a t t l e C A D ============== END ==\n\n"
        # exit
        
    } else {
    
        puts "\n"
        puts "        ... save current project not required\n\n"
        puts "  ====== e x i t   r a t t l e C A D ============== END ==\n\n"
        # exit
        
    }
        #
    flush $rattleCAD_STDOUT
    catch {close $rattleCAD_STDOUT}
        #
    exit
        #
}
    #
    #
