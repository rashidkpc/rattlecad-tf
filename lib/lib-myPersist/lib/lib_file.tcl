 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_file.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
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
 #  namespace:  myPersist::file
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval myPersist::file {}


    #-------------------------------------------------------------------------
    #  open File Type: xml
    #
proc myPersist::file::openProject_xml {fileName} {

    
    puts "\n\n  ====== o p e n   F I L E ========================\n"
    puts "         myPersist::file::openProject_xml"
    puts "         ... fileName:        $fileName"
    puts ""

    if { [file readable $fileName ] } {
            #
        set persistDOM  [myPersist::file::get_XMLContent $fileName show]
            #
            #
        puts "\n"
        puts "         myPersist::file::openProject_xml"
        puts "         ... done"             
        puts "\n  ====== o p e n  F I L E =========================\n\n"
            #
        return $persistDOM
            #
    } else {
            #
        puts "         <W> ... could not read file"
        puts "                   ... $fileName\n"
        puts "\n  ====== o p e n  F I L E =========================\n\n"
            #
        return {}
            #
    }
}


    #-------------------------------------------------------------------------
    #  save File Type: xml
    #
proc myPersist::file::saveProject_xml {persistDOM {mode {save}} {type {Road}} } {
        #
        
        # --- select File
    set types {
            {{Project Files 3.x }       {.xml}  }
        }



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
    puts ""
    puts "            -> [myGUI::control::getSession  rattleCADVersion]"
    puts "            -> [myGUI::control::getSession  projectName]"
    puts "            -> [myGUI::control::getSession  dateModified]"
    puts ""
            
   
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


    #-------------------------------------------------------------------------
    #  open a File, containing just a subset of a Project-xml
    #
proc myPersist::file::openProject_Subset_xml {{fileName {}}} {
        #
    set types {
        {{Project Files 3.x }       {.xml}  }
    }
        #
    if {$fileName == {}} {
        set fileName    [tk_getOpenFile -title "Import" -initialdir $::APPL_Config(USER_Dir) -filetypes $types]
    } else {
        return
    }
    
        #
    set content [myPersist::file::get_XMLContent $fileName]
    myGUI::control::importSubset $content
        # 
    
        #
    myGUI::control::changeList::reset
        #
    
        # -- fill tree
    #
    puts "  <W> myPersist::file::openProject_Subset_xml\n"
    #rattleCAD::cfg_report::fillTree $myGUI::control::currentDOM root
        #

}


    #-------------------------------------------------------------------------
    #  ... renamed from openFile_xml to get_XMLContent  2012.07.29
    #
proc myPersist::file::get_XMLContent {{file {}} {show {}}} {

    set types {
            {{xml }       {.xml}  }
        }
    if {$file == {} } {
        set file [tk_getOpenFile -initialdir $::APPL_Config(USER_Dir) -filetypes $types]
    }
        # -- $fileName is not empty
    if {$file == {} } return

    set fp [open $file]

    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp

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


    #-------------------------------------------------------------------------
    #  open web URL
    #
proc myPersist::file::open_URL {url {mimeType {}}} {
    osEnv::open_by_mimeType_DefaultApp  $url $mimeType
    return
}


    #-------------------------------------------------------------------------
    #  open File by OS - Definition
    #
proc myPersist::file::open_localFile {fileName} {
    osEnv::open_by_mimeType_DefaultApp  $fileName
    return
}


    #-------------------------------------------------------------------------
    #  open File by Extension
    #
proc myPersist::file::openFile_byExtension {fileName {altExtension {}}} {
    osEnv::open_by_mimeType_DefaultApp $fileName $altExtension          
    return
}


    #-------------------------------------------------------------------------
    #  get user home directory
    #
proc myPersist::file::get_userhome {} {
        # thanks to:  http://wiki.tcl.tk/3834
        # puts "       -> \$::tcl_platform(platform) $::tcl_platform(platform)"
    switch -exact -- $::tcl_platform(platform) {
        windows {
            set homeDir_Request [registry get {HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders} {Personal}]
            set stringMapping   [list {%USERPROFILE%} $::env(USERPROFILE)]
            set homeDir_Request [string map $stringMapping $homeDir_Request]
              # puts "  ... -> \$homeDir_Request $homeDir_Request"
            set homeDir         [file dirname [file normalize $homeDir_Request]]
              # puts "  ... -> \$homeDir $homeDir"
              # tk_messageBox -message "  ... -> \$homeDir $homeDir"
              # puts "  ... -> \$homeDir $homeDir"
        }
        default {
            set homeDir         $::env(HOME)
        }
    }
        #
    return      [file normalize $homeDir]
        #
}


    #-------------------------------------------------------------------------
    #  check user project directory
    #
proc myPersist::file::check_user_dir {checkDir} {

    # changed since 3.2.78.03

        # thanks to:  http://wiki.tcl.tk/3834
        # puts "       -> \$::tcl_platform(platform) $::tcl_platform(platform)"
    switch -exact -- $::tcl_platform(platform) {
        windows {
            set homeDir_Request [registry get {HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders} {Personal}]
            set stringMapping   [list {%USERPROFILE%} $::env(USERPROFILE)]
            set homeDir_Request [string map $stringMapping $homeDir_Request]
              # puts "  ... -> \$homeDir_Request $homeDir_Request"
            set homeDir         [file normalize $homeDir_Request]
              # puts "  ... -> \$homeDir $homeDir"
              # tk_messageBox -message "  ... -> \$homeDir $homeDir"
              # puts "  ... -> \$homeDir $homeDir"
        }
        default {
            set testDir         [file join $::env(HOME) Documents]
            if {[file exists $testDir] && [file isdirectory $testDir]} {
                set homeDir     $testDir
            } else {
                set homeDir     $::env(HOME)
            }
        }
    }
        # and now the the directory to check for
    set checkDir [file join $homeDir $checkDir]

    if {[file exists $checkDir]} {
        if {[file isdirectory $checkDir]} {
            set checkDir $checkDir
                # puts  "         check_user_dir:  $checkDir"
        } else {
            tk_messageBox -title   "Config ERROR" \
                          -icon    error \
                          -message "There is a file \n   ... $checkDir\n     should be ad directory\n\n  ... please remove file"
            return
        }
    } else {
        file mkdir $checkDir
    }

    return [file normalize $checkDir]
}


    #-------------------------------------------------------------------------
    #  ...
    #
proc myPersist::file::getTemplateFile {type} {

    set TemplateRoad    [file join $::APPL_Config(USER_Dir) [format "%s%s.xml" $::APPL_Config(USER_InitString) Road] ]
    set TemplateMTB     [file join $::APPL_Config(USER_Dir) [format "%s%s.xml" $::APPL_Config(USER_InitString) MTB ] ]

    switch -exact $type {
        {Road} {    
            if {[file exists $TemplateRoad ]} {
                return $TemplateRoad
            } else {
                return $::APPL_Config(TemplateRoad_default)
            }
        }
        {MTB} {     
            if {[file exists $TemplateMTB ]} {
                return $TemplateMTB
            } else {
                return $::APPL_Config(TemplateMTB_default)
            }
        }
        default {   return {}
        }
    }

}


    #-------------------------------------------------------------------------
    # http://stackoverflow.com/questions/429386/tcl-recursively-search-subdirectories-to-source-all-tcl-files
    # 2010.10.15
proc myPersist::file::findFiles { basedir pattern } {
            # Fix the directory name, this ensures the directory name is in the
            # native format for the platform and contains a final directory seperator
    set basedir [string trimright [file join [file normalize $basedir] { }]]
    set fileList {}
            # Look in the current directory for matching files, -type {f r}
            # means ony readable normal files are looked at, -nocomplain stops
            # an error being thrown if the returned list is empty
    foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
        lappend fileList $fileName
    }
            # Now look for any sub direcories in the current directory
    foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
                # Recusively call the routine on the sub directory and append any
                # new files to the results
        set subDirList [findFiles $dirName $pattern]
        if { [llength $subDirList] > 0 } {
            foreach subDirFile $subDirList {
                lappend fileList $subDirFile
            }
        }
    }
    return $fileList
}


    #-------------------------------------------------------------------------
    # component alternatives
    #
proc myPersist::file::get_componentAlternatives {key} {
        #
        # ... handle switch in bikeGeometry 1.75
        #          ... <component key="Component/ForkCrown"    dir="components/fork/crown"        />
        #          ... <component key="ForkCrown"              dir="fork/crown"        />           
        # 
    puts "\n <D> myPersist::file::get_componentAlternatives"
        #
    set directory    [lindex [array get ::APPL_CompLocation $key ] 1 ]
        # puts "          ... directory  $directory"
    if {$directory == {}} {
                # tk_messageBox -message "no directory"
        puts "    -- <E> -------------------------------"
        puts "         ... no directory configured for"
        puts "               $key"
            # parray ::APPL_CompLocation
        puts "    -- <E> -------------------------------"
        return {}
    }

    set etcDir      [file normalize [file join $::APPL_Config(COMPONENT_Dir)            $directory]]
    set userDir     [file normalize [file join $::APPL_Config(USER_Dir)     components  $directory]]
    set custDir     [file normalize [file join $::APPL_Config(CUSTOM_Dir)   components  $directory]]
                puts "       \$::APPL_Config(COMPONENT_Dir) $::APPL_Config(COMPONENT_Dir)   "
                puts "       \$directory $directory"
                puts "            etc:  $etcDir"
                puts "            user: $userDir"
                puts "            cust: $custDir"
                
        #
        # ------------------------
        #     sum up all relevant components
    set listAlternative {}
        #
    foreach file [ glob -directory $etcDir  *.svg ] {
                # puts "     ... fileList: $file"
            set mapString [file normalize $::APPL_Config(COMPONENT_Dir)]
                # puts "                 : $mapString/"
            set fileString [ string map [list $mapString/ {etc:} ] $file ]
                # puts "                 : $fileString"
            lappend listAlternative $fileString
    }
    catch {
        foreach file [ glob -directory $userDir  *.svg ] {
                # puts "     ... fileList: $file"
            set mapString [file normalize [file join $::APPL_Config(USER_Dir)     components]]
                # puts "                 : $mapString/"
            set fileString [ string map [list $mapString/ {user:} ] $file ]
                # puts "                 : $fileString"
            lappend listAlternative $fileString
        }
    }
    catch {
        foreach file [ glob -directory $custDir  *.svg ] {
                # puts "     ... fileList: $file"
            set mapString [file normalize [file join $::APPL_Config(CUSTOM_Dir)   components]]
                # puts "                 : $mapString/"
            set fileString [ string map [list $mapString/ {cust:} ] $file ]
                # puts "                 : $fileString"
            lappend listAlternative $fileString
        }
    }

        #
        # ------------------------
        #     some components are not neccessary at all
    switch -exact $key {
            Component(Derailleur/File)  {
                    set listAlternative [lappend listAlternative {etc:default_blank.svg} ]
            }
    }
        
        #
        # ------------------------
        #     report all alternative components
    foreach comp $listAlternative {
        puts "                  -> $comp"
    }           
        
        #
    return $listAlternative
        #
}


