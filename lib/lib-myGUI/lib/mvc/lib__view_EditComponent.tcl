 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib__svgEdit.tcl
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
 #    namespace:  myGUI::view::edit::svg
 # ---------------------------------------------------------------------------
 #
 # 

namespace eval myGUI::view::edit::svg {
        #
    variable dict_svgEdit
    set dict_svgEdit [dict create   _template \
                                        [list \
                                                parentWidget    {} \
                                                compTree        {} \
                                                compTree_ID     {} \
                                                cvObject        {} \
                                                compFileString  {} \
                                                updateCommand   {} \
                                        ]
                                    ]
                                    
        #
    variable id_svgEdit     0
        #
    variable _viewValue     ;# container for current paramteter to be updated
    upvar myGUI::view::viewValue _viewValue
        #
}   

    #-------------------------------------------------------------------------
       #  create config Content
       #
proc myGUI::view::edit::svg::create_svgEdit {w  valueKey  currentValue {updateCmd {}}} {
        #			
    variable id_svgEdit
    variable dict_svgEdit
        #
    incr id_svgEdit
    set  _id    [format "%03s" $id_svgEdit]
        #
    # report_Dict
    # puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#"
    # puts "======================================================="
    # appUtil::pdict $dict_svgEdit
    # puts ""
    # puts "    \$w $w"
    # puts "    \$valueKey $valueKey"
    # puts "    \$currentValue $currentValue"
    # puts "    \$updateCmd $updateCmd"
    # puts $id_svgEdit
    # puts $id
    # puts "======================================================="
    # puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#"
        #
        #
    set compFileString $currentValue
        #
        #
        # -----------------
        #   add content
        # -----------------
        #   System Components Structure
    set f_select    [ frame     $w.treeFrame ]
        #
    set compTree    [ ttk::treeview $f_select.tree \
                                        -show           "" \
                                        -columns        "key value completeValue" \
                                        -displaycolumns "key value" \
                                        -yscroll        "$f_select.scb_try set" \
                                        -height         5]
        #
    $compTree heading key    -anchor w      -text   "type"
    $compTree column  key    -anchor center -width   45
    $compTree heading value  -anchor w      -text   "FileName"
    $compTree column  value  -anchor w      -width  160

        #
        # -----------------
    set compScrollBar   [ ttk::scrollbar  $f_select.scb_try \
                                -orient vertical   \
                                -command "$f_select.tree yview"]
        #
        # -----------------
    grid $compTree  $f_select.scb_try -sticky news -pady 2
        #
    grid rowconfigure    $f_select $compTree -weight 1
    grid columnconfigure $f_select $compTree -weight 1
        #
        # -----------------
    
        
        #####
        #
        # -----------------
    set f_canvas    [frame  $w.canvasFrame ]
        #
        #
    set cvObject    [cad4tcl::new  $f_canvas  120  100  passive  1.0  0  -bd 1  -bg white  -relief sunken]
        #
        # foreach {cvObject cv Name} $retValue break
        #
    set cvPath      [$cvObject getCanvas]
    set cvCanvas    [$cvObject getCanvas]
        #
    if {$cvCanvas == {}} {
        puts "   ... could not register $cvCanvas"
    }
        # report_CanvaCAD post
        #------------------
        #
    set type "SELECT_File"
    set compTree_ID [[namespace current]::fillSelectionList $compTree $compFileString $type $valueKey]
        #
        # -----------------
    dict set dict_svgEdit  $_id  parentWidget    $w   
    dict set dict_svgEdit  $_id  compTree        $compTree   
    dict set dict_svgEdit  $_id  compTree_ID     $compTree_ID   
    dict set dict_svgEdit  $_id  cvObject        $cvObject   
    dict set dict_svgEdit  $_id  compFileString  $compFileString   
    dict set dict_svgEdit  $_id  updateCommand   $updateCmd   
        #------------------
    # puts "\n <D> \$compFileString     $compFileString"    
    # puts "\n <D> \$compTree_ID         $compTree_ID"    
        #
    # report_Dict
        #
        #
        # -----------------
    bind $compTree <<TreeviewSelect>>       [list [namespace current]::bind_TreeViewSelect  %W $_id $valueKey]        
    bind $compTree <Return>                 [list [namespace current]::bind_TreeViewCommit  %W $_id $valueKey]        
    bind $compTree <Double-ButtonPress-1>   [list [namespace current]::bind_TreeViewCommit  %W $_id $valueKey]        
        #
    bind $cvCanvas <Double-ButtonPress-1>   [list [namespace current]::bind_TreeViewCommit  %W $_id $valueKey]        
        #
        # -----------------
        #
        #
    return [list $f_select $f_canvas]
        #
}    

    #-------------------------------------------------------------------------
       #  update canvas Content
       #
proc myGUI::view::edit::svg::update_svgEdit {} {
        #
    variable dict_svgEdit
        #
    puts "\n"
    puts "   ---------------------------------------------"
    puts "    myGUI::view::edit::svg::update_svgEdit"
    puts ""
        # myGUI::view::edit::svg::report_Dict
        # puts "\n\n"
        # report_Dict
        # report_CanvaCAD 
        #
    foreach key [dict keys $dict_svgEdit] {
            #
        puts "           -> \$key ... $key"
            #
        if {$key == {_template}} continue
            #
        set cvObject        [dict get $dict_svgEdit $key cvObject]
        set compFileString  [dict get $dict_svgEdit $key compFileString]
        puts "           ----------------------------------------------------- "
        puts "               -> updateCanvas $cvObject $compFileString"
        catch {updateCanvas $cvObject $compFileString}
            #
        set compTree        [dict get $dict_svgEdit $key compTree]
        set compTree_ID     [dict get $dict_svgEdit $key compTree_ID]
        puts "           ----------------------------------------------------- "
        puts "               -> $compTree \\ "
        puts "                       selection set $compTree_ID"
        if {[catch {$compTree selection set $compTree_ID} eID]} {
                #
            puts " ... could not execute: $compTree selection set $compTree_ID "
            puts "      ... $eID"
                #
        } else {
                #
            $compTree focus         $compTree_ID
                #
            set compList        [$compTree children {}]
            set listLength      [llength $compList]
            set itemPosition    [lsearch $compList $compTree_ID]
            set relPosition     [expr 1.0 * $itemPosition / [expr $listLength -1]]
                #
                # puts "     $compTree_ID   -> $relPosition <- $itemPosition ($listLength)"
                #
            $compTree yview moveto $relPosition
        }
            #
            # tk_messageBox -message "$compTree_ID"
            #
    }
        # report_Dict
        # report_CanvaCAD    
}

    #-------------------------------------------------------------------------
        #  debug procedures
        #
proc myGUI::view::edit::svg::report_Dict {} {
        #
    variable dict_svgEdit
        #
    puts "#\n#\n#\n#\n#"
    puts "==== - myGUI::view::edit::svg::report_Dict - ========"
    appUtil::pdict $dict_svgEdit
    puts "======================================================="
    puts "#\n#\n#\n#\n#"
        #
}
proc myGUI::view::edit::svg::report_CanvaCAD {{message {}}} {
        #
    variable dict_svgEdit
        #
    set dom_cadCanvas [cad4tcl::getXMLRoot]
    puts "==== - myGUI::view::edit::svg::report_CanvaCAD - ====== - $message - ===="
        # puts "[$dom_cadCanvas asXML]"
    foreach childNode [$dom_cadCanvas childNodes] {
        set id_Value {}
        catch {set id_Value [$childNode getAttribute "id"]}
        puts "      -> < [$childNode nodeName] $id_Value >"
        #puts "      -> < [$childNode nodeName] ... [$childNode getAttribute "id"] >"
    }
    puts "======================================================="
        #
}

    #-------------------------------------------------------------------------
        #  bind_TreeViewSelect
        #
proc myGUI::view::edit::svg::bind_TreeViewSelect {w _id key args} {
        #
    variable dict_svgEdit
        #
        # report_Dict
        #
        # puts "  --> $_id"
        # puts "  --> $args"
    puts ""
    puts "       ... myGUI::view::edit::svg::bind_TreeViewSelect"
    puts "             ... $w $_id $key $args"
    puts "\n"
        #
        #
    set compTree    [dict get $dict_svgEdit $_id compTree]
    set cvObject    [dict get $dict_svgEdit $_id cvObject]
    
        #
        puts " -> \$compTree    $compTree"
        puts " -> \$cvObject    $cvObject"
        puts " -> \$key         $key"
        puts " -> \$args        $args"
        #
        #
    set node [$compTree focus]
        # puts " -> \$node       $node"
        #
    set dictFileString  [$compTree set $node completeValue]
    set dictKey         [$compTree set $node key]
    set dictValue       [$compTree set $node value]
        #
    dict set dict_svgEdit $_id compFileString $dictFileString 
        #
        # puts "   ... 1 - $dictFileString"
        # puts "   ... 2 - $dictKey"
        # puts "   ... 3 - $dictValue"
        #
    [namespace current]::updateCanvas $cvObject $key $dictFileString
    if {[catch {[namespace current]::updateCanvas $cvObject $key $dictFileString} fid]} {
        puts "   ... could not open file $dictFileString"
        puts "      <E> $fid"
    }
        #
        # puts "   ... tried to open file $dictFileString"
        #
}

    #-------------------------------------------------------------------------
        #  updateCanvas
        #
proc myGUI::view::edit::svg::updateCanvas {cvObject compName compKey} {
        #
    puts ""
    puts "                   ------------------------------------------------"
    puts "                    updateCanvas"
    puts "                       cvObject:      $cvObject"
    puts "                       compName:      $compName"
    puts "                       compKey:       $compKey"
    set compType [lindex [split $compName :] end]
    puts "                       compType:      $compType"
        #
        # puts "                           $::APPL_Config(COMPONENT_Dir)"
        # puts "                           $::APPL_Config(USER_Dir)"
        # puts "                           $::APPL_Config(CUSTOM_Dir)"

    set filePath {}
    set filePath [myGUI::control::get_CompPath $compType $compKey]
        #
    puts "                       filePath:        $filePath"
        #
    if {$filePath != {}} {
            #
        $cvObject deleteContent
        set my_Component    [$cvObject create svg {0 0} [list -svgFile $filePath  -angle 0  -tags __Decoration__]]
        $cvObject fit
        $cvObject fitContent $my_Component
            #
        puts "                       ... canvas updated!"
    } else {
        puts "                       ... empty canvas updated!"
        $cvObject fit
    }
}

#-------------------------------------------------------------------------
    #  bind_TreeViewCommit
    #
proc myGUI::view::edit::svg::bind_TreeViewCommit {w _id key args} {
        #
    variable dict_svgEdit
    variable _viewValue
        #
    puts ""
    puts "       ... myGUI::view::edit::svg::bind_TreeViewCommit"
    puts "             ... $w $_id $key $args"
    puts "\n"
        #
    set compFileString  [dict get $dict_svgEdit $_id compFileString]
    set updateCommand   [dict get $dict_svgEdit $_id updateCommand]
        # puts " -> \$compFileString $compFileString"
    puts " -> \$updateCommand $updateCommand"
        #
    if {$compFileString != {}} {
            # puts "\n         ... $compFileString\n"
            # puts "    ... \$key $key"
            #
        array set _viewValue        [list $key $compFileString]
        myGUI::control::setValue    [list $key $compFileString]
            #
        if {$updateCommand != {}} {
            {*}${updateCommand}
        }
            #
        return $compFileString
            #
    } else {
            #
        puts "\n         ... $compFileString\n"
            #
        return $compFileString
            #
    }
        #
}

    #-------------------------------------------------------------------------
        #  fillSelectionList
        #
proc myGUI::view::edit::svg::fillSelectionList {compTree compFileString type valueKey} {
        #
    puts "  <D> ... fillSelectionList $type $valueKey "
        #    
    set listBoxContent [myGUI::control::getListBoxContent  $type $valueKey]
        #
    cleanupTree $compTree
        #
    set currentTreeID {}    
        #
    foreach entry [lsort $listBoxContent] {
            # puts "         ... $entry"
        foreach {key value} [split $entry  :]  break
        set value [file tail $value]
            # set entry [format "%s:%s" $key [file normalize $entry]]
            puts "         ... $entry ... $key ... $value"
        set entryID [$compTree insert {} end -text $key -values [list $key $value $entry]]
        if {$compFileString == $entry} {
            puts "          -> $compFileString <- $entryID ->"
            set currentTreeID $entryID
        }
    }
    return $currentTreeID
}   

    #-------------------------------------------------------------------------
        #  reset Positioning
        #    
proc myGUI::view::edit::svg::cleanupTree {treeWidget} {
        # puts "  ... $treeWidget "
    foreach childNode [$treeWidget children {}] {
            # puts "   .... $childNode"
        $treeWidget detach     $childNode
        $treeWidget delete     $childNode
    }
}

