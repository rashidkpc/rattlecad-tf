 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib__view.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2013/08/26
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
 #    namespace:  myGUI::view::edit
 # ---------------------------------------------------------------------------
 #
 #


namespace eval myGUI::view::edit {
 
    
    #-------------------------------------------------------------------------
        #  store createEdit-widgets position
    variable editPosition   {0 0}                          

    variable _drag          ; array set _drag        {}     ;# mouse drag on canvas
    
    variable canvasUpdate   ; array set canvasUpdate {}     ;# date of last canvas update
    variable canvasRefit    ; array set canvasRefit  {}  
    variable noteBook_top
    variable cboxWidth      15

    variable colorSet       ; array set colorSet {
                                    frameTube       wheat
                                    frameTube_OL    black
                                    tyre            gray98
                                    chainStay       burlywood
                                    chainStay_1     NavajoWhite3
                                    chainStay_2     NavajoWhite2
                                    chainStay_CL    {saddle brown}
                                    chainStayArea   gray80
                                    components      snow2
                                    tubeColor       gray95
                                    frameTubeColor  #edc778
                                    forkColor       #edc778
                                    labelColor      white                                 
                                    decoColor       gray98
                                    compColor       gray98
                                    tyreColor       gray95
                              } 
                                  # chainStayArea   {saddle brown}  

    variable _viewValue     ;# container for current paramteter to be updated
    upvar myGUI::view::viewValue _viewValue
                       
}


proc myGUI::view::edit::updateView {{mode {}}} {
        #
    variable noteBook_top
    variable canvasUpdate
    variable canvasRefit
        #
    set tabID       [myGUI::gui::current_notebookTabID]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $tabID]
        #
        # set currentTab         [$myGUI::gui::noteBook_top select]
        # puts "  ... $currentTab"
        # set cvObject           [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
    if {$cvObject eq ""} {
            # exception for notebook tabs that does not contain any cadCanvas - Object
        puts ""
        puts "        myGUI::view::edit::updateView:"
        puts "            -> \$tabID $tabID"
        puts ""
        return
    }
        #
        #
    set updateDone         {no}
    set refitDone          {no}
        #
        # -- update library selection
    if {$tabID eq "components"} {
            puts "   <01> -> $tabID $cvObject"
        myGUI::compLibrary::update_compList
    }
        #
        # -- register each canvas
    if { [catch { set lastUpdate $canvasUpdate($tabID) } msg] } {
        set canvasUpdate($tabID) [ expr $myGUI::control::model_Update -1 ]
        set lastUpdate             $canvasUpdate($tabID)
    }
        #
    if { [catch { set lastRefit $canvasRefit($tabID) } msg] } {
        set canvasRefit($tabID)  [ expr $myGUI::control::window_Update -1 ]
        set lastRefit              $canvasRefit($tabID)
    }
        #
    set timeStart     [clock milliseconds]
        #
        # -- update stage content if parameters changed
    puts "\n"
    puts "     -------------------------------"
    puts "      myGUI::view::edit::updateView  "
    puts "         \$canvasUpdate($tabID)"
    puts "               last:   $canvasUpdate($tabID)  -> [clock format [expr $canvasUpdate($tabID)/1000] -format {%Y.%m.%d / %H:%M:%S}]"
    puts "               new:    $myGUI::control::model_Update  -> [clock format [expr $myGUI::control::model_Update/1000] -format {%Y.%m.%d / %H:%M:%S}]"
    puts "               ---------------------------------"
    puts "            -> $myGUI::control::model_Update\n"
        #
        # -- configure cursor
    catch {$cvObject   configure   Canvas   Cursor  watch}
        #
        #

    if {$mode == {force}} {
            puts "\n             ... myGUI::view::edit::updateView ... update $tabID ... force\n"
            myGUI::gui::fill_cadCanvas $tabID
            set updateDone  {done}
    } else {
        if { $lastUpdate < $myGUI::control::model_Update } {
            puts "\n             ... myGUI::view::edit::updateView ... update $tabID\n"
            myGUI::gui::fill_cadCanvas $tabID
            set updateDone  {done}
        } else {
            puts "\n             ... myGUI::view::edit::updateView ... update $tabID ... not required\n"
        }
    }
        #
    if {$mode == {recenter}} {
            puts "\n             ... myGUI::view::edit::updateView ... update $tabID ... recenter\n"
            myGUI::gui::fill_cadCanvas $tabID recenter               
    }
        #
        # -- refit stage if window size changed
    if { $lastRefit < $myGUI::control::window_Update } {
            puts "\n             ... myGUI::view::edit::updateView ... refitStage ........ $tabID\n"
            update
            # catch {$tabID refitStage}
            myGUI::gui::notebook_refitCanvas
            set refitDone  {done}       
    }
        #
        # -- configure cursor
    catch {$cvObject   configure   Canvas   Cursor  arrow}
        #
    set timeEnd     [clock milliseconds]
    set timeDiff    [expr $timeEnd - $timeStart]
        #
        #
    puts "\n             ... time to update:"
    puts   "                 ... [format "%9.3f" $timeDiff] milliseconds"
    puts   "                 ... [format "%9.3f" [expr $timeDiff / 1000.0] ] seconds"
        #
    if {$updateDone == {done}} {
        set canvasUpdate($tabID) [ clock milliseconds ]
    }
    if {$refitDone == {done}} {
        set canvasRefit($tabID)  [ clock milliseconds ]
    }
        #
    puts ""
    puts "           -> \$canvasUpdate($tabID) $canvasUpdate($tabID)"
    puts "           -> \$canvasRefit($tabID)  $canvasRefit($tabID)\n"
    puts "      myGUI::view::edit::updateView  ... done"
    puts "     -------------------------------"
        #
}

proc myGUI::view::edit::updateControl {valueKey {cvEntry {}}} {
        #
    variable _viewValue
        #
    puts "  -> myGUI::view::edit::updateControl $valueKey $cvEntry "
        
        
        # --- handle valueKey values ---
    switch -glob $valueKey {
        {_update_} {}
        default {
            if {$cvEntry != {}} {
                set textVar     [$cvEntry cget -textvariable]
                set textValue   [set $textVar]
                    #
                puts "  ---> updateControl"
                puts "    -> $valueKey"
                puts "    -> $textVar: $textValue"
                    #
                    # puts "\n      ... myGUI::view::edit::updateControl ... $valueKey  $textValue\n"
                    #
                set newValue [myGUI::control::setValue [list $valueKey $textValue]]
                    # exit
            }
        }
    }
        #
        # --- finaly update
    update
        # catch {$cvEntry selection range 0 end}
        #
    return
        #
}

proc myGUI::view::edit::set_Color {colorName color} {
    variable colorSet
    array set colorSet [list $colorName $color]
        #
        # parray colorSet
        #
}

proc myGUI::view::edit::update_MainFrameStatus {{message {}}} {
  
        # appDebug  p     
    global APPL_Config
  
    if {$message != {}} {
        set  projectText  $message
        set  statusText   {}       
    } else {
        foreach {index size} [myGUI::control::changeList::get_undoStack] break
          # set  projectText  [format "%s " [file tail $APPL_Config(PROJECT_Name)]]
          # set  projectText  [format "%s (%s)" [file tail $APPL_Config(PROJECT_Name)] [myGUI::control::getSession dateModified]]
        set  projectText  [format "%s (%s)" [file tail [myGUI::control::getSession projectName]] [myGUI::control::getSession dateModified]]
        set  statusText   [format "UndoStack: %2s / %2s"  $index $size]
    }
      # set  statusText   [file tail $APPL_Config(PROJECT_Name)]
      # puts "   ---> \$projectText $projectText"
      # puts "   ---> \$statusText  $statusText"
    set ::APPL_Config(MainFrameInd_Project)  $projectText
    set ::APPL_Config(MainFrameInd_Status)   $statusText
    
    return
}    

proc myGUI::view::edit::update_windowTitle {{filename {}}} {
  
        # appDebug  p     
    global APPL_Config
  
    if {$filename == {}} {
        set  filename [myGUI::control::getSession projectName]
          # set  filename $APPL_Config(PROJECT_Name)
    }
    set  APPL_Config(WINDOW_Title)  "rattleCAD  $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision) - $filename"
    wm title . $APPL_Config(WINDOW_Title)
}   






proc myGUI::view::edit::create_Edit_2 { x y cvObject _arrayNameList {title {Edit:}}} {
        #
        # appUtil::get_procHierarchy
        #
    variable editPosition
        #
        # appUtil::get_procHierarchy
        # appUtil::appDebug p
        # appUtil::appDebug f
        #
    puts ""
    puts "   -------------------------------"
    puts "    create_Edit_2"
    puts "       x / y:           $x / $y"
    puts "       cvObject:        $cvObject"
    puts "       title:           $title"
        #
    set editPosition [list $x $y]
        #
    if {[llength $_arrayNameList] > 1} {
        puts "       _arrayNameList:"
        foreach entry $_arrayNameList {
            puts "                        $entry"
        }
    } else {
        puts "       _arrayNameList:  $_arrayNameList"
        if {$_arrayNameList == {}} {
            # ... used to return the container only
        } else {
            set key     [lindex $_arrayNameList 0]
            set title   [string trim [myGUI::view::edit::format_LabelText $key] ]
            set title   [lindex [split $title] end]
            set title   [string trim $title )]
        }
    }
    puts ""
    puts "     -> $title"
    puts ""

        #
        # ------ 
    set r [catch {info level [expr [info level] - 1]} e]
    if {$r} {
        puts "\n      ... create_Edit called directly by the interpreter (e.g.: .tcl on the commandline).\n"
    } {
        switch -glob ${e} {
            myGUI::view::edit::* {
                    puts "\n    <--->   ... create_Edit called by ${e}.\n"
                }
            default {
                    puts "\n    <OLD>   ... create_Edit called by ${e}.\n"
                }
        }
    }
        #
        # --- cvContentFrame ---
    set cvContainer [create_Edit_MultiLine $cvObject $title $x $y $_arrayNameList]
        #
        # --- reposition if out of canvas border ---
    fit_EditContainer $cvObject
        #
        # ------ 
    myGUI::view::edit::svg::update_svgEdit
        #
    return $cvContainer
        #
}

proc myGUI::view::edit::create_Edit_MultiLine {cvObject title x y _arrayNameList } {
        #
        # appUtil::get_procHierarchy
        #
        # set wList       [create_EditContainer   $x $y $cvObject $title 2]
        # set cvEdit      [lindex $wList 0]  
        # set cvContainer [lindex $wList 1]  
    set cvContainer [create_EditContainer  $cvObject $title $x $y]  
        # puts "  ... $cvEdit"
        # puts "  ... $cvContainer"            
        # set cvContentFrame  $cvEdit
    
        # set cvContentFrame      [frame $cvEdit.f_content    -bd 1 -relief sunken]
    set cvContentFrame $cvContainer
        #
    pack configure $cvContentFrame  -fill both
        #
        # --- parameter to edit ---
    set updateMode value
        #
    set editConfig_Components   {}
    set editConfig_Entries      {}
        #
    set index 0
    foreach key  $_arrayNameList {
        set index       [expr $index +1]
            #
        puts "              <10> create_Edit_MultiLine       -> $index   $key"
            #
            # puts "\n  -> here I am --- $key\n"
            #
        
        set cfgWidgets  [create_Config $cvContentFrame $index $key]
        set widget_1    [lindex $cfgWidgets 0]
        set widget_2    [lindex $cfgWidgets 1]
            #
            # puts "    ... $cvContentFrame"    
            # puts "    ... $widget_1"    
            # puts "    ... $widget_2"    
            #
        if {[llength $cfgWidgets] > 1} {
            grid            $widget_1    $widget_2    -sticky news
            grid configure  $widget_1    -padx 3 -sticky nws
            grid configure  $widget_2    -padx 2
                #
            lappend editConfig_Entries $widget_2    
                #
        } else {
            grid            $widget_1    -sticky news -columnspan 2
            grid configure  $widget_1    -padx 2 -pady 2
                # focus $widget_1
                # update
                # [namespace current]::svgEdit::selectCurrent
                #
            lappend editConfig_Components $widget_1
                #
            update
                #
            catch {[namespace current]::svgEdit::selectCurrent}
                #
                # 
        }
            #
    }

        #
        #
        # puts "    ... \$editConfig_Components [llength $editConfig_Components] - $editConfig_Components"    
        # puts "    ... \$editConfig_Entries    [llength $editConfig_Entries] - $editConfig_Entries"    
        #
    if {[llength $editConfig_Components] < 1} {
        set cvEntry [lindex $editConfig_Entries 0]
            # puts "   ... $cvEntry"
        catch {focus $cvEntry}
            # catch {$cvEntry selection range 0 end}
    }
        #
    return $cvContainer                
        #
}

proc myGUI::view::edit::create_EditContainer {cvObject title x y} {
        #
    puts ""
    puts "   -------------------------------"
    puts "    create_EditContainer"
    puts "       title:           $title"
    puts "       x / y:           $x / $y"
    puts ""
        #
    set cvContentFrame  [$cvObject createDivContainer $title $x $y]    
        #
    return $cvContentFrame
        #
}

proc myGUI::view::edit::fit_EditContainer {cvObject} {
        #
        # --- reposition if out of canvas border ---
    update
        #
    set cv          [$cvObject getCanvas]
    set cvEdit      [$cvObject getDivContainer]
        #    
    set id_bbox     [$cvObject bbox $cvEdit]
        #
        
    puts "\n\n\n\n"    
    puts "--------------------- myGUI::view::edit::fit_EditContainer"    
    puts "    -> \$cvEdit   $cvEdit"
    puts "    -> \$id_bbox  $id_bbox"
        
        
    set cv_width    [winfo width  $cv]
    set cv_height   [winfo height $cv]
        # puts "   -> bbox $id_bbox"
    foreach {dx dy} {0 0} break
        #
    if {[lindex $id_bbox 0] < 4}                    { set dx [expr 4  - [lindex $id_bbox 0]]}
    if {[lindex $id_bbox 1] < 4}                    { set dy [expr 4  - [lindex $id_bbox 1]]}
        #
    if {[lindex $id_bbox 2] > [expr $cv_width  -4]} { set dx [expr $cv_width  - [lindex $id_bbox 2] -4] }
    if {[lindex $id_bbox 3] > [expr $cv_height -4]} { set dy [expr $cv_height - [lindex $id_bbox 3] -4] }
        #
    # puts "            ... $id_bbox"    
    # puts "            ... $dx / $dy"    
        #
    $cv move $cvEdit $dx $dy
        # puts "  -> reposition $dx $dy"
        #
    return $cvEdit
        #
}


 #-------------------------------------------------------------------------
    # create different kind of config title     
proc myGUI::view::edit::create_ConfigTitle {w index title} {
            #
        set cvLabel     [label  $w.label__${index} -text "${title} : "]
        return $cvLabel
            #
}


 #-------------------------------------------------------------------------
    # create different kinds of config lines 
proc myGUI::view::edit::create_Config {cvContentFrame index key} {
        #
    variable _updateValue
        #
        # appUtil::get_procHierarchy
    
        # puts "\n   ---------------------------------"
        # puts "    <01>    \$key $key"
    puts "              <20>    create_Config           -> $key "
        #
    set listName "-"
    switch -glob $key {
        {list://*} {
                set type      [string range $key 0 3] 
                set keyValue  [string range $key 7 end]
                foreach {_key _listName} [split $keyValue {@}] break
                set key       [format "%s" $_key]
                set listName  [string range $_listName 0 end]                    
             }       
        {file://*} -
        {text://*} { # file://Lugs(RearDropOut/File) -> Lugs(RearDropOut/File) 
                set type      [string range $key 0 3] 
                set key       [string range $key 7 end]
            }
        default    {
                set type      {}
            }
    }
        #
    set labelText   [myGUI::view::edit::format_LabelText $key]
        #
    set cvLabel     [create_ConfigTitle  $cvContentFrame $index ${labelText}]
        #
        #
    puts "              <21>    create_Config           -> $key"
        # puts "              <21>    create_Config           -> $key ... $path"
        #                                                                 
    switch -exact $type {
        {file} {    set cvConfig    [ create_ConfigFile     $cvContentFrame $index $key ]
                    return $cvConfig
                }
        {list} {    set cvConfig    [ create_ConfigList     $cvContentFrame $index $key $listName] }
        {text} {    set cvConfig    [ create_ConfigText     $cvContentFrame $index $key ] }
        default {   set cvConfig    [ create_ConfigScalar   $cvContentFrame $index $key ] }
    }
        #
    return [list $cvLabel $cvConfig]
        #
}
    #
proc myGUI::view::edit::create_ConfigFile {cvContentFrame index valueKey} {
        #
    variable cboxWidth
    variable _viewValue
        #
    foreach {arrayName arrayKey} [split $valueKey :] break
        #
    set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
    array set _viewValue    [list $valueKey $currentValue]
        #
    set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        #
    puts "                  <30>    create_ConfigFile "
    puts "                          -> $index"
    puts "                          -> $valueKey <- $currentValue  "
        #
        # --- create listBox content ---
    set myFrame [frame $cvContentFrame.compFrame_$index]
        #
        # --- create cvSelect ---
    set cfgWidgets [myGUI::view::edit::svg::create_svgEdit \
                        $myFrame  \
                        $valueKey  \
                        $currentValue  \
                        {} ]
    set cvSelect [lindex $cfgWidgets 0]    
    set cvCanvas [lindex $cfgWidgets 1]
        #
    pack $cvSelect $cvCanvas -side left -fill both -expand true
    
        #
    return $myFrame
        #
    return [list $cvSelect $cvCanvas]
        #  
}
    #
proc myGUI::view::edit::create_ConfigScalar {cvContentFrame index valueKey} {
        #
        # appUtil::get_procHierarchy
        #
    variable cboxWidth
    variable _viewValue
        #
        # puts "a $valueKey"
    foreach {arrayName arrayKey} [split $valueKey :] break
        # set key [string trimright $key \)]
        # puts "b $arrayName $arrayKey"
        # set valueKey        [format {%s/%s} $arrayName $arrayKey]
        # puts "c $valueKey"
    set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
    array set _viewValue    [list $valueKey $currentValue]
        #
    set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        #
    puts "                  <30>    create_ConfigScalar"
    puts "                          -> $index"
    puts "                          -> $valueKey <- $currentValue  "
        #
    
        #
        # --- create cvLabel, cvEntry ---
    set cvEntry [spinbox $cvContentFrame.value_${index} \
                    -textvariable $varName \
                    -increment 1 \
                    -justify right \
                    -relief sunken \
                    -width $cboxWidth \
                    -bd 1]
    $cvEntry configure -command \
                    "[namespace current]::bind_SpinBoxButton %W %d $cvEntry"
        #
        # --- define bindings ---
    bind $cvEntry   <<Increment>>           [list [namespace current]::bind_SpinBoxButton       %W]
    bind $cvEntry   <<Decrement>>           [list [namespace current]::bind_SpinBoxButton       %W]
    bind $cvEntry   <MouseWheel>            [list [namespace current]::bind_SpinBoxMouseWheel   %W %D]
    bind $cvEntry   <Return>                [list [namespace current]::updateControl            $valueKey $cvEntry]
        # bind $cvEntry   <Leave>                 [list [namespace current]::updateControl            $valueKey $cvEntry]
        # bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateControl            $valueKey $cvEntry]
        #
    return $cvEntry
        #
}
    #
proc myGUI::view::edit::create_ConfigText  {cvContentFrame index valueKey} {
        #
    variable cboxWidth
    variable _viewValue
        #
    foreach {arrayName arrayKey} [split $valueKey :] break
    set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
    array set _viewValue    [list $valueKey $currentValue]
        #
    set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        #
    puts "                  <30>    create_ConfigText "
    puts "                          -> $index"
    puts "                          -> $valueKey <- $currentValue  "
        #
        
        #
        # --- create cvLabel, cvEntry ---
    set cvEntry [entry  $cvContentFrame.value_${index} \
                    -textvariable $varName \
                    -justify right \
                    -relief  sunken \
                    -width   $cboxWidth \
                    -bd 1  ]
        #
        # --- define bindings ---
    bind $cvEntry   <Return>                [list [namespace current]::updateControl    $valueKey $cvEntry]
    bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateControl    $valueKey $cvEntry]
        # bind $cvEntry   <Leave>                [list [namespace current]::updateControl    $valueKey $cvEntry]
        # bind $cvEntry   <MouseWheel>           [list [namespace current]::bind_SpinBoxMouseWheel  [namespace current]::_updateValue($key)  %D]
        #
    return $cvEntry
        #
}
    #
proc myGUI::view::edit::create_ConfigList  {cvContentFrame index valueKey type} {
        #
    variable cboxWidth
    variable _viewValue
        #
    foreach {arrayName arrayKey} [split $valueKey :] break
    puts "   -> $arrayName $arrayKey"
    set currentValue        [myGUI::model::model_Edit::getValue $arrayName $arrayKey]
    puts "   -> $arrayName $arrayKey $currentValue"
    array set _viewValue    [list $valueKey $currentValue]
        #
    set varName             [format {%s::%s(%s)} [namespace current] _viewValue $valueKey]
        #
    puts "                  <30>    create_ConfigList "
    puts "                          -> $index"
    puts "                          -> $valueKey <- $currentValue"
    puts "                          -> $type"
        #
    
        #
        # --- create listBox content ---
    switch -exact $type {
            {SELECT_File} { 
                    puts "     create_ConfigList -> SELECT_File:"
                    set listBoxContent [myGUI::control::getListBoxContent  $type $valueKey]
                }
            default { 
                    puts "     create_ConfigList -> $type" 
                    set listBoxContent [myGUI::control::getListBoxContent  $type]
                }
    }
      #
    puts "\n      -- listBoxContent ---"
    foreach entry $listBoxContent {
        puts "         ... $entry"
    }
    puts "      -- listBoxContent ---\n"
    
        #
        # --- create cvLabel, cvEntry, Select ---
    set cvCBox [ ttk::combobox $cvContentFrame.cb_${index} \
                    -textvariable $varName \
                    -values $listBoxContent \
                    -width  $cboxWidth \
                    -height 10 \
                    -justify right ]       
        #
        # --- define postcommand
    $cvCBox configure -postcommand \
                    [list set [namespace current]::_tmpValue ${currentValue}]
        #
        # --- define bindings ---
    bind $cvCBox    <<ComboboxSelected>>        [list [namespace current]::bind_ListBoxSelection    %W $valueKey]
        #
    return $cvCBox
        #
}


 #-------------------------------------------------------------------------
    #  listbox - bindings   
proc myGUI::view::edit::bind_ListBoxSelection {cvEntry valueKey args} {

    variable _viewValue
    variable _tmpValue
    
    puts "  .. bind_ListBoxSelection "
    puts "        $cvEntry"
    puts "        $valueKey"
    puts "        $args"
    
    switch $valueKey {
        {Scalar:Geometry/RearRim_Diameter} -
        {Scalar:Geometry/FrontRim_Diameter} {
                # -- exception for selection of Combobox
                    # list is splitted by: "----"
            if {[string range $_viewValue($valueKey) 0 3] == "----"} {
                puts "   ... reset value .. $_tmpValue"
                set _viewValue($valueKey) $_tmpValue
            } else {
                set value [string trim [lindex [split $_viewValue($valueKey) ;] 0]]
                set value [format "%.3f" $value]
                set _viewValue($valueKey) $value
                    #
                [namespace current]::updateControl $valueKey $cvEntry
            }
        }
        default {
                [namespace current]::updateControl $valueKey $cvEntry
        }
    }
} 


 #-------------------------------------------------------------------------
    #  spinbox - bindings
    #  -- Button
proc myGUI::view::edit::bind_SpinBoxButton {widget direction args} {
        #
        # puts "  -> bind_SpinBoxButton  $direction $args"
        #
        # --- update value of spinbox ---
    if {$direction eq "up"} {\
        increment_SpinBox $widget increment
    } else {
        increment_SpinBox $widget decrement
    }
}
    #  -- MouseWheel
proc myGUI::view::edit::bind_SpinBoxMouseWheel {widget value args} {
        #
        # puts "  -> bind_SpinBoxMouseWheel  $args"
        # return
        #
    set textVar [$widget cget -textvariable]
    set currentValue [set $textVar]
        #
    set direction 1
    catch {set direction [expr $value / $currentValue]} 
    if {$direction > 0} {
        increment_SpinBox $widget increment
    } else {
        increment_SpinBox $widget decrement
    }
}


    #  -- updateValue
proc myGUI::view::edit::increment_SpinBox {widget direction} {
        #
    set textVar [$widget cget -textvariable]
    set currentValue [set $textVar]
        #
        # puts " --> increment_SpinBox  $direction $textVar"
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


proc myGUI::view::edit::format_LabelText {key} {
        #
        # appUtil::get_procHierarchy
        #
        # puts "\n   ---------------------------------"
        # puts "    <01>    \$key $key"
    switch -glob $key {
        {list://*} {
                set keyValue  [string range $key 7 end]
                foreach {_key _listName} [split $keyValue {@}] break
                set key       [format "%s)" $_key]                
             }       
        {file://*} -
        {text://*} { # file://Lugs(RearDropOut/File) -> Lugs(RearDropOut/File) 
                set key       [string range $key 7 end]
            }
        default    {}
    }
        #
    set key     [string map {/File {}} $key]
        #
        # puts "  -> $key"
    set _name [lindex [split $key :] 1]
        #puts "  -> $_name"
        #
        # set labelText [format "%s ( %s )" $_array [string trim [ string map {{/} { / }} $_name] " "] ]
    set labelText   [format "%s "   [string trim [ string map {{/} { / }} $_name] " "] ]
        #
    return $labelText
        #   
}    


 #-------------------------------------------------------------------------
    #  switch check_TubingAngles
proc myGUI::view::edit::check_TubingAngles {} {
    if {$myGUI::gui::checkAngles != {on}} {
        set myGUI::gui::checkAngles {on}
    } else {
        set myGUI::gui::checkAngles {off}
    }
    myGUI::cvCustom::updateView         [myGUI::gui::current_notebookTabID]
    return
} 


 #-------------------------------------------------------------------------
    #  close all ProjectEdit Widgets
proc myGUI::view::edit::close_allEdit {} {
        # puts "  -- close_Edit: $cv $cvEdit"
        #
    set cvObject    [myGUI::gui::getCanvasObject]
        #
    $cvObject deleteConfigCorner
    $cvObject deleteConfigContainer
    $cvObject deleteDivContainer
        #
    return
        #
}   


 #-------------------------------------------------------------------------
    #  createEdit - sub procedures 
proc myGUI::view::edit::debug_compare {a b} {
    if {$a != $b} {
        appUtil::get_procHierarchy
        tk_messageBox -messager "   ... pleas check this:\n      $a $b"
    } else {
        puts "\n ... debug_compare:"
        puts   "       $a"
        puts   "       $b\n"
    }
}      

