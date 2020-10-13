 ##+##########################################################################
 #
 # package: myGUI    ->    lib__export.tcl
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
 #    namespace:  myGUI::export
 # ---------------------------------------------------------------------------
 #
 # 

 namespace eval myGUI::export {

 }


 #-------------------------------------------------------------------------
   #  export cadCanvas from every notebook-Tab
   #
proc myGUI::export::export_Project { {type {html}}} {
        #
    set noteBook_top    $myGUI::gui::noteBook_top
        #
        # --- get currentTab
    set currentTab  [$noteBook_top select]
    set tabID       [myGUI::gui::current_notebookTabID]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $tabID]
        #
    puts "\n\n"
        #   
    switch -exact $type {
        html {   set exportDir  $::APPL_Config(EXPORT_HTML) }
        pdf  {   set exportDir  $::APPL_Config(EXPORT_PDF)}
        default {}
    }
        #
        # --- export content to HTML
    puts "\n\n  ====== e x p o r t  P R O J E C T ===============\n"                         
    puts "      export project to -> $type \n"
    puts "      export_Project   $currentTab / $cvObject / $tabID"
    puts "             currentTab-Parent  [winfo parent $currentTab]  "
    puts "             currentTab-Parent  [winfo name   $currentTab]  "
    puts ""
    
        # --- cleanup export directory
    if { [catch {set contents [glob -directory $exportDir *]} fid] } {
        set contents {}
    }

          # puts "Directory contents are:"
    puts ""
    foreach item $contents {
        puts "             ... cleanup $item"
        catch {file delete -force $item}
    }
    puts "\n"            
    
        # --- prepare export directory
    switch -exact $type {
        html {
            set indexHTML [file join $::APPL_Config(EXPORT_HTML) index.html]
            file copy -force [file join $::APPL_Config(CONFIG_Dir) html/index.html]     $::APPL_Config(EXPORT_HTML)
            file copy -force [file join $::APPL_Config(CONFIG_Dir) html/style.css]      $::APPL_Config(EXPORT_HTML)
            file copy -force [file join $::APPL_Config(CONFIG_Dir) html/rattleCAD.ico]  $::APPL_Config(EXPORT_HTML)
                  
                # --- get project file 
            if {[file exists [myGUI::control::getSession  projectFile]] == 1} {
                  # file exists
                puts "             ... [myGUI::control::getSession  projectFile]"
                set sourceFile  [myGUI::control::getSession  projectFile]
            } else {
                  # file does not exists
                puts "             ... $::APPL_Config(TemplateInit)"
                set sourceFile  $::APPL_Config(TemplateInit)
            } 

            catch {file copy -force $sourceFile [file join $::APPL_Config(EXPORT_HTML) project.xml]}
            
                # --- loop through content
                  # puts "[lsort [array names myGUI::gui::notebookObject]]"
            foreach index [dict keys $myGUI::gui::notebookRegistry] {
                    #
                puts "    -> $index"
                switch -exact $index {
                    _template   -
                    cv_Custom02 -
                    components {}
                    default {
                        puts "           -> $index"
                        myGUI::gui::selectNotebookTab   $index
                            # tk_messageBox -message "$index"
                        update
                        notebook_exportSVG $exportDir noOpen
                    }
                }
            }
                #
            myGUI::gui::selectNotebookTab   $tabID 

                # --- open index.html
            puts "    ------------------------------------------------"
            puts "      ... open $indexHTML "
            
            myPersist::file::open_localFile $indexHTML
        }
        
        pdf {
                #
            set projectName [myGUI::control::getSession projectName]
                # puts "   ->  \$projectName  $projectName"
            set namePrefix  [string map {{ } _ {.xml} {}} $projectName]  
                # puts "   ->  \$namePrefix   $namePrefix"
                #
            set pdfFileList {}
                #
            set fileList    [export_Project_pdf            $::APPL_Config(EXPORT_PDF) $namePrefix]
            set pdfFileList $fileList   
                #
            set fileList    [myGUI::tubeMiter::export_pdf  $::APPL_Config(EXPORT_PDF) $namePrefix]
            foreach file $fileList {
                lappend pdfFileList $file
            }    
                #
            puts "\n\n\n"
            puts "    ------------------------------------------------"
            foreach pdfFile $pdfFileList {
                puts "\n"
                puts "      ... open $pdfFile"
                    # catch {myPersist::file::openFile_byExtension "$pdfFile"}
                catch {osEnv::open_by_mimeType_DefaultApp "$pdfFile"}
            }
        }
        default {}
    }
        #
    $noteBook_top select $currentTab
        #
    return
        #
}


 #-------------------------------------------------------------------------
   #  export all cadCanvas to pdf 
   #
proc myGUI::export::export_Project_pdf {exportDir namePrefix} {
        #
    set noteBook_top    $myGUI::gui::noteBook_top
        #
        
        #
    puts "\n"
    puts "       ... myCustom"
    puts "           ... myGUI::export::export_PDF4TCL"
    puts ""
        #
        # --- get currentTab
    set currentTab  [$noteBook_top select]
    set cvObject    [myGUI::gui::getCanvasObject]
        #
    puts "\n\n"
        
        # --- export content to HTML
    puts "\n\n  ====== e x p o r t  P R O J E C T == P D F ======\n"                         
    puts "      export project to -> pdf using pdf4tcl \n"
    puts "      export_Project   $currentTab / $cvObject"
    puts "             currentTab-Parent  [winfo parent $currentTab]  "
    puts "             currentTab-Parent  [winfo name   $currentTab]  "
    puts ""
    
        # --- cleanup export directory
    if { [catch {set contents [glob -directory $exportDir *]} fid] } {
        set contents {}
    }
        # puts "Directory contents are:"
    puts ""
    foreach item $contents {
        puts "             ... cleanup $item"
        catch {file delete -force $item}
    }
    puts "\n"              

        #
        # objectName metadata ?option value...?
        #
        #    This method sets metadata fields for this document. Supported field options are 
        #       -author, -creator, -keywords, -producer, -subject, -title, -creationdate and -format.
        #
        # -- bundle formats
    set formatDict {}
    set count 0
    dict for {index content} $myGUI::gui::notebookRegistry {
            #
        set cvObject [dict get $content canvasObject]
            #
        puts "    -> $index $cvObject"
        switch -exact $index {
            cv_Custom02 -
            components {continue}
        }
        if {$cvObject eq {}} continue
            #
        set stage_Format       [$cvObject   configure   Stage  Format]            
        set stage_Width        [$cvObject   configure   Stage  Width ]            
        set stage_Height       [$cvObject   configure   Stage  Height] 
            #
        puts "        \$stage_Format ... $stage_Format"
        puts "        \$stage_Width .... $stage_Width"
        puts "        \$stage_Height ... $stage_Height"
            #
        dict append formatDict $stage_Format [format {%s } $index]
            #
        incr count +1
            #
    }
        #
    set pdfFileList {}    
        # -- export canvases to pdf
    foreach pageFormat [dict keys $formatDict] {
            #
        set indexList   [dict get $formatDict $pageFormat]
        set pdfFileName [format {%s_%s.pdf} $namePrefix $pageFormat]
        set pdfFilePath [file join $exportDir $pdfFileName]
            #
        puts "\n\n\n"
        puts "===== $pageFormat ====================================================="
        puts ""
        puts "      \$pdfFileName ... $pdfFileName"
        puts ""
            #
        catch {mypdf destroy}
        pdf4tcl::new mypdf -paper $pageFormat -landscape true  -unit mm
            #
        foreach index $indexList {
                #
            set cvObject        [myGUI::gui::getCanvasObject $index]    
            set w               [$cvObject   getCanvas]            
            set stage_Unit      [$cvObject   configure   Stage  Unit  ]            
            set stage_Width     [$cvObject   configure   Stage  Width ]            
            set stage_Height    [$cvObject   configure   Stage  Height] 
                #
            myGUI::view::edit::close_allEdit    
                #
            $cvObject           fit         
                #
            puts "      ---- $cvObject --------------------------------------\n"
            puts "           \$w ................. $w"
            puts "           \$pageFormat ........ $pageFormat"
            puts "           \$stage_Unit ........ $stage_Unit"
            puts "           \$stage_Width ....... $stage_Width"
            puts "           \$stage_Height ...... $stage_Height"
                #
            if {$stage_Width > $stage_Height} {
                set stage_Landscape true
            } else {
                set stage_Landscape false
            }
            puts "           \$stage_Landscape ... $stage_Landscape"
            puts "\n"
                #
            myGUI::gui::selectNotebookTab   $index
                #
            # continue
                #
            update
                #
            $w lower {__NB_Button__}        all
            $w lower {__cvEdit__}           all
            $w lower {__Select__SubMenue__} all
            $w lower {__configCorner__}     all
                #
            foreach item [$w find withtag {__Sensitive__}] {
                # puts "          -> lower __Sensitive__: $item"
                $w lower $item all
            }
                #
            set stageCoords    [ $w coords  {__Stage__} ]
                #
                # pdf4tcl::new mypdf -paper $stage_Format -landscape $stage_Landscape
            mypdf startPage -paper $pageFormat -landscape $stage_Landscape
                #
                # puts "export_Project: [mypdf configure]"
            mypdf canvas $w     -x      [format "%smm" 0]  \
                                -y      [format "%smm" 0]  \
                                -width  [format "%smm" $stage_Width] \
                                -height [format "%smm" $stage_Height] \
                                -bbox   $stageCoords
                # mypdf canvas $w -bbox $stageCoords
                #
            mypdf endPage
                #
            $w raise {__NB_Button__}        all
            $w raise {__cvEdit__}           all
            $w raise {__Select__SubMenue__} all
            $w raise {__configCorner__}     all
            foreach item [$w find withtag {__Sensitive__}] {
                # puts "          -> raise __Sensitive__: $item"
                $w raise $item all
            }
            foreach item [$w find withtag {__DimensionText__}] {
                # puts "          -> raise __DimensionText__: $item"
                $w raise $item all
            }
            update
        }
            #    
        if {[catch {mypdf write -file $pdfFilePath} eID]} {
                #
            mypdf destroy
                #
            $noteBook_top select $currentTab
                #
            tk_messageBox -icon error -title "Export PDF" \
                -message "could not write file:\n   $pdfFilePath\n\n---<E>--------------\n$eID"
                #
            return {}
                #
        }
            #
        lappend pdfFileList $pdfFilePath
            #
        mypdf destroy
            #
    }
        #
    $noteBook_top select $currentTab
        #
    return $pdfFileList
        #
}


 #-------------------------------------------------------------------------
   #  export cadCanvas from current notebook-Tab as Standard Vector Graphic
   #
proc myGUI::export::notebook_exportSVG {printDir {postEvent {open}}} {
        #
        # appUtil::pdict $myGUI::gui::notebookRegistry
        # puts "   -> $currentTab_ID"
        #
        #
    set noteBook_top        $myGUI::gui::noteBook_top
        #
        # --- get currentTab
    set currentTab          [$noteBook_top select]
    set currentTab_ID       [myGUI::gui::current_notebookTabID]
    set currentTab_Title    [dict get $myGUI::gui::notebookRegistry $currentTab_ID notebookTabTitle]
    set currentTab_Name     [string map {" " ""} [join $currentTab_Title]]
        #
    set cvObject    [myGUI::gui::getCanvasObject]
        #
    if { $cvObject == {} } {
            #
        puts "   notebook_exportDXF - cvObject: $cvObject"
        return
            #
    }
    
        # --- set exportFile
    set fileName        [format {%s___%s.svg} $currentTab_ID $currentTab_Name]
    set exportFile      [file join $printDir ${fileName}]
        
        # puts "          ->$currentTab_Name<-"
        # puts "          ->$fileName<-"
        # puts "          ->$exportFile<-"
        
        # --- export content to File
    puts "    ------------------------------------------------"
    puts "      export SVG - Content to    $exportFile \n"
    puts "         notebook_exportSVG     $currentTab "
    puts "             currentTab-Parent  [winfo name   $currentTab]  "
    puts "             currentTab-Parent  [winfo parent $currentTab]  "
    puts "             cadCanvas Object   $cvObject"
    
    set exportFile [$cvObject export SVG $exportFile]
    
    if {$postEvent == {open}} {
            #
        puts "\n"
        puts "    ------------------------------------------------"
        puts ""
        puts "      ... open $exportFile "
            #
        myPersist::file::open_localFile $exportFile
            #
    }
    
        # --- return fileName
    return $exportFile                 
        #
}


 #-------------------------------------------------------------------------
   #  export cadCanvas from current notebook-Tab as SVG Graphic
   #
proc myGUI::export::notebook_exportDXF {printDir {postEvent {open}}} {
        #
    set noteBook_top    $myGUI::gui::noteBook_top
        #

        # --- get currentTab
    set currentTab  [$noteBook_top select]
    set cvObject    [myGUI::gui::getCanvasObject]
        #
    if { $cvObject == {} } {
            #
        puts "   notebook_exportDXF - cvObject: $cvObject"
        return
            #
    }
    
        # --- set exportFile
    set stageTitle    [$cvObject  configure  Stage  Title ]
    set fileName      [winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle]]
    set exportFile    [file join $printDir ${fileName}.dxf]

        # --- export content to File
    puts "    ------------------------------------------------"
    puts "      export DXF - Content to    $exportFile \n"
    puts "         notebook_exportDXF     $currentTab "
    puts "             currentTab-Parent  [winfo name   $currentTab]  "
    puts "             currentTab-Parent  [winfo parent $currentTab]  "
    puts "             cadCanvas Object   $cvObject"
    
    set exportFile [$cvObject export DXF $exportFile]
    
    if {$postEvent == {open}} {
            #
        puts "\n"
        puts "    ------------------------------------------------"
        puts ""
        puts "      ... open $exportFile "
            #
        myPersist::file::open_localFile $exportFile
            #
    }            
        
        # --- return fileName
    return $exportFile 
        #
}

