 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_gui.tcl
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
 #    namespace:  myGUI::lib_gui
 # ---------------------------------------------------------------------------
 #
 # 
 
 
 namespace eval myGUI::gui {

    variable    canvasGeometry          ;   array   set canvasGeometry  {}
    variable    notebookObject          ;   array   set notebookObject  {}
    variable    externalObject          ;   array   set externalObject  {}
    variable    iconArray               ;   array   set iconArray       {}
    
    variable    notebookRegistry        [dict create _template {
                                                notebookWidget {}
                                                canvasObject   {}
                                                canvasPath     {}
                                            }]
    
    variable    canvasUpdate            ;   array   set canvasUpdate    {}
    variable    checkAngles             ;           set checkAngles    off
    
    variable    noteBook_top            {}
    variable    pluginFrame             {}
    
    variable    stageFormat             A4
    variable    stageScale              1.00

    variable    frame_configMethod      {OutsideIn}
    variable    show_secondaryDimension 1
    variable    show_resultDimension    1
    variable    show_summaryDimension   1
    
    variable    toggleFullScreenWidgets {}
 }


                        
    #-------------------------------------------------------------------------
    #  create MainFrame with Menue  
    #
proc myGUI::gui::create_MainFrame {} {        
        #
    set mainframe_Menue {
        "&File"     all file 0 {
            {command "&Open"            {}  "Open Project File"     {Ctrl o}        -command { myGUI::control::select_ProjectFile } }
            {command "&Open Template"   {}  "Open from Template"    {Ctrl n}        -command { myGUI::control::select_ProjectFile $::APPL_Config(TEMPLATE_Dir)} }
            {command "&Save"            {}  "Save Project File"     {Ctrl s}        -command { myGUI::control::save_ProjectFile } }
            {command "Save &As ..."     {}  "Save Project File As"  {CtrlAlt s}     -command { myGUI::control::save_ProjectFile saveAs} }
                {separator}
            {command "Impo&rt"          {}  "import Parameter"      {Ctrl i}        -command { myPersist::file::openProject_Subset_xml } }
            {command "&Rendering"       {}  "Rendering Settings"    {}              -command { myGUI::gui::change_Rendering } }
                {separator}                                                  
            {command "&Config Panel"    {}  "open Config Panel"     {Ctrl m}        -command { myGUI::view::configPanel::create } }
                {separator}                                                  
            {command "&SVG-Component"   {}  "open flatSVG"          {}              -command { cad4tcl::app::simplifySVG::buildToplevelGUI } }
            {command "&SVG-ChainWheel"  {}  "open chainWheel"       {}              -command { chainWheel::buildToplevelGUI } }
                {separator}                                                  
            {command "E&xit"            {}  "Exit rattle_CAD"       {Ctrl x}        -command { myGUI::control::exit_rattleCAD } }
        }                                                                    
                                                                             
        "&Edit"     all file 0 {
            {command "Undo"             {}  "Undo"                  {Ctrl z}        -command { myGUI::control::changeList::previous} }
            {command "Redo"             {}  "Redo"                  {Ctrl y}        -command { myGUI::control::changeList::next} }
                {separator}                                                  
            {command "&Update"          {}  "update Configuration"  {Ctrl u}        -command { myGUI::view::edit::updateView force } }
                {separator}
            {command "&Copy Reference"  {}  "Copy Reference"        {Ctrl r}        -command { myGUI::gui::notebook_switchTab  cv_Custom02} }
        }                                                                    
                                                                             
        "Export"    all info 0 {                                             
            {command "&Export PDF"      {}  "Export PDF-Report"     {Ctrl p}        -command { myGUI::export::export_Project      pdf} }
            {command "&Export HTML"     {}  "Export HTML-Report"    {Ctrl t}        -command { myGUI::export::export_Project      html} }
            {command "&Export SVG"      {}  "Export to SVG"         {}              -command { myGUI::export::notebook_exportSVG  $APPL_Config(EXPORT_Dir) } }
            {command "&Export DXF"      {}  "Export to DXF"         {}              -command { myGUI::export::notebook_exportDXF  $APPL_Config(EXPORT_Dir) } }
        }
        
        "Demo"      all info 0 {
            {command "Samples"          {}  "Example Projects"      {}              -command { myGUI::test::runDemo loopSamples } }
            {command "Stop Demo"        {}  "Stop running Demo"     {Ctrl b}        -command { myGUI::test::stopDemo} }
                {separator}         
            {command "Integration Test" {}  "Integration Test"      {CtrlAlt i}     -command { myGUI::test:::runDemo integrationTest_00} }
        }
        
        "?"         all info 0 {   
            {command "&Help"            {}  "Help"                  {Ctrl h}        -command { myGUI::infoPanel::create  .v_info 1} }
            {command "&License"         {}  "License"               {Ctrl l}        -command { myGUI::infoPanel::create  .v_info 2} }
            {command "ChangeLog"        {}  "ChangeLog"             {}              -command { myGUI::infoPanel::create  .v_info 4} }
                {separator} 
            {command "rattleCAD WebSite" {} "about rattleCAD"       {}              -command { myPersist::file::open_URL {http://rattlecad.sourceforge.net/index.html}    } }
            {command "... Features"     {}  "rattleCAD Features"    {}              -command { myPersist::file::open_URL {http://rattlecad.sourceforge.net/features.html} } }
            {command "... download"     {}  "rattleCAD @ sourceforge.net" {}        -command { myPersist::file::open_URL {https://sourceforge.net/projects/rattlecad/files/3.4.05/}      } }
                {separator}  
            {command "&Info"            {}  "Information"           {Ctrl i}        -command { myGUI::infoPanel::create  .v_info 0} }
                {separator}  
            {command "... contribute"   {}  "like and donate"       {}              -command { myPersist::file::open_URL {http://rattlecad.sourceforge.net/donate.html}   } }
        }
    }
    
    return [MainFrame .mainframe  -menu $mainframe_Menue ]
    
        # removed 20170816
        #  {command "Debug Test"       {}  "Debug Test"            {Alt d}         -command { myGUI::test:::runDemo integrationTest_loopNotebook} }
        #  {command "rattleCAD Method" {}  "HandleBar and Saddle"  {CtrlAlt r}     -command { myGUI::test::runDemo method_rattleCAD_HandleBarandSaddle } }
        #  {command "classic Method"   {}  "Seat- and TopTube"     {}              -command { myGUI::test::runDemo method_classic_SeatandTopTube } }
        #  {command "rattleCAD AddOn"  {}  "additional rattleCAD Features" {Alt a} -command { myGUI::control::start_AddOn } }
        #  {command "Demo"             {}  "rattleCAD Demo"        {}              -command { myGUI::test::runDemo demo_01 } }
        #  {command "Intro-Image"      {}  "Show Intro Window"     {}              -command { myGUI::create_intro .intro } }
        #  {command "Debug Special"    {}  "Debug Special"         {}              -command { myGUI::test:::runDemo integrationTest_special} }
        # removed 20160115
        #  {command "&Export PS"     {}  "Export to PostScript"  {}  -command { myGUI::gui::notebook_exportPS   $APPL_Config(EXPORT_Dir) } }  
        # removed 20150818
        #  {command "show Console"   {}  "show log Consolge"     {}  -command { myGUI::gui::show_Console } }
            
            
}


    #-------------------------------------------------------------------------
    #  create MainFrame with Menue  
    #
proc myGUI::gui::create_ButtonBar {tb_frame } {    
        #
    variable iconArray
        #
    variable toggleFullScreenWidgets
        #
    variable pluginFrame
        #
        
        #
        #   ----------------------------------------
        #
    set toolBar_left    [frame $tb_frame.left]
        #
    pack    $toolBar_left   -side left  -fill y
        #
        #
    ttk::button    $toolBar_left.open      -image  $iconArray(open)          -command { myGUI::control::select_ProjectFile }  
    ttk::button    $toolBar_left.save      -image  $iconArray(save)          -command { myGUI::control::save_ProjectFile } 
        #
    ttk::button    $toolBar_left.backward  -image  $iconArray(backward)      -command { myGUI::control::changeList::previous }          
    ttk::button    $toolBar_left.forward   -image  $iconArray(forward)       -command { myGUI::control::changeList::next }          
        #
    ttk::button    $toolBar_left.set_rd    -image  $iconArray(reset_r)       -command { myGUI::control::open_TemplateFile   Road }  
    ttk::button    $toolBar_left.set_mb    -image  $iconArray(reset_o)       -command { myGUI::control::open_TemplateFile   MTB  }  
        #
    ttk::button    $toolBar_left.clear     -image  $iconArray(clear)         -command { myGUI::gui::notebook_cleanCanvas} 
    ttk::button    $toolBar_left.render    -image  $iconArray(update)        -command { myGUI::view::edit::updateView force}  
    ttk::button    $toolBar_left.cfg       -image  $iconArray(cfg_panel)     -command { myGUI::view::configPanel::create } 
        #
    ttk::button    $toolBar_left.print_htm -image  $iconArray(print_html)    -command { myGUI::export::export_Project html }          
    ttk::button    $toolBar_left.print_pdf -image  $iconArray(print_pdf)     -command { myGUI::export::export_Project pdf }          
        #
    ttk::button    $toolBar_left.print_dxf -image  $iconArray(print_dxf)     -command { myGUI::export::notebook_exportDXF  $APPL_Config(EXPORT_Dir) }          
    ttk::button    $toolBar_left.print_svg -image  $iconArray(print_svg)     -command { myGUI::export::notebook_exportSVG  $APPL_Config(EXPORT_Dir) }          
        #
        #
    set pluginFrame [frame  $toolBar_left.rattleCAD_plugIn]
        # set buttonFrame     [myGUI::plugIn::create_buttonFrame $toolBar_left]
        # set buttonFrame     [myGUI::plugin::create_buttonFrame $toolBar_left]
        #
        #
    label   $toolBar_left.sp0      -text   ""
    label   $toolBar_left.sp1      -text   ""
    label   $toolBar_left.sp2      -text   ""
    label   $toolBar_left.sp3      -text   ""
    label   $toolBar_left.sp4      -text   ""
    label   $toolBar_left.sp5      -text   "     "
    label   $toolBar_left.sp6      -text   ""            
    label   $toolBar_left.sp7      -text   "     "            
        #
        #
    pack    $toolBar_left.open      $toolBar_left.save      $toolBar_left.sp0  \
            $pluginFrame    \
            $toolBar_left.backward  $toolBar_left.forward   $toolBar_left.sp2  \
            $toolBar_left.cfg                               $toolBar_left.sp3  \
            $toolBar_left.clear     $toolBar_left.render    $toolBar_left.sp4  \
            $toolBar_left.set_rd    $toolBar_left.set_mb    $toolBar_left.sp5  \
            $toolBar_left.print_htm $toolBar_left.print_pdf $toolBar_left.sp6  \
            $toolBar_left.print_dxf $toolBar_left.print_svg $toolBar_left.sp7  \
        -side left -fill y
               
        # ---------------------------------------------
        # bind tooltips
        # 
        # myGUI::gui::setTooltip  $widget "Hello World!"    
    myGUI::gui::setTooltip     $toolBar_left.open       "open ..."               
    myGUI::gui::setTooltip     $toolBar_left.save       "save ..."               
        #
    myGUI::gui::setTooltip     $toolBar_left.backward   "... backward"           
    myGUI::gui::setTooltip     $toolBar_left.forward    "forward ..."            
        #
    myGUI::gui::setTooltip     $toolBar_left.set_rd     "a roadbike Template"    
    myGUI::gui::setTooltip     $toolBar_left.set_mb     "a offroad Template"     
        #
    myGUI::gui::setTooltip     $toolBar_left.clear      "clear Canvas..."        
    myGUI::gui::setTooltip     $toolBar_left.render     "update Canvas..."       
    myGUI::gui::setTooltip     $toolBar_left.cfg        "open config Panel"      
        #
    myGUI::gui::setTooltip     $toolBar_left.print_htm  "export HTML"            
    myGUI::gui::setTooltip     $toolBar_left.print_pdf  "export PDF"             
        #
    myGUI::gui::setTooltip     $toolBar_left.print_dxf  "print DXF"              
    myGUI::gui::setTooltip     $toolBar_left.print_svg  "print SVG"
        #
    set myGUI::control::rattleCAD_plugIn(buttonFrame)    $pluginFrame
        #
                
        #
        #   ----------------------------------------
        #
    set toolBar_right [frame $tb_frame.right]
        #
    pack    $toolBar_right  -side right -fill y
        #
        #
    ttk::button    $toolBar_right.scale_p   -image  $iconArray(scale_p)       -command { myGUI::gui::notebook_scaleCanvas  [expr 3.0/2] }  
    ttk::button    $toolBar_right.scale_m   -image  $iconArray(scale_m)       -command { myGUI::gui::notebook_scaleCanvas  [expr 2.0/3] }  
    ttk::button    $toolBar_right.resize    -image  $iconArray(resize)        -command { myGUI::gui::notebook_refitCanvas }  
    
    ttk::button    $toolBar_right.donate    -image  $iconArray(donate)        -command { myPersist::file::open_URL {http://rattlecad.sourceforge.net/donate.html}   } 
    
    ttk::button    $toolBar_right.exit      -image  $iconArray(exit)          -command { myGUI::control::exit_rattleCAD }
        #
    label   $toolBar_right.sp6  -text   " "
    label   $toolBar_right.sp7  -text   " "
    label   $toolBar_right.sp8  -text   " "
        #
        #    
    grid    $toolBar_right.scale_m  $toolBar_right.scale_p  $toolBar_right.resize   $toolBar_right.sp8  \
            $toolBar_right.exit \
        -sticky w 
        
        # ---------------------------------------------
        # bind tooltips
        # 
    myGUI::gui::setTooltip  $toolBar_right.scale_p  "scale plus"             
    myGUI::gui::setTooltip  $toolBar_right.scale_m  "scale minus"            
    myGUI::gui::setTooltip  $toolBar_right.resize   "resize"                 
        #
    myGUI::gui::setTooltip  $toolBar_right.donate   "donate to rattleCAD"    
        #
        
        #
        # ---------------------------------------------
        # bind resize
        # 
    lappend toggleFullScreenWidgets  $toolBar_right.exit $toolBar_right.sp8
    bind $toolBar_right.resize  <Control-Button-1>      {myGUI::gui::toggle_Fullscreen}
        #
        # ---------------------------------------------
        # hide EXIT per default
        # 
    foreach widget $toggleFullScreenWidgets {
        grid remove $widget
    }
}


    #-------------------------------------------------------------------------
    #  register notebookCanvas in notebook - Tabs   
    #
proc myGUI::gui::create_Notebook {frame} {
        #
    variable canvasGeometry
    variable canvasUpdate
    variable noteBook_top
        #
    variable notebookObject
        #
        # ---     initialize canvasUpdate
    set canvasUpdate(recompute)    0
    
        # ---     create ttk::notebook
    set noteBook_top     [ ttk::notebook $frame.nb -width $canvasGeometry(width)    -height $canvasGeometry(height) ]                
        pack $noteBook_top -expand yes  -fill both  
    
        # ---     create and register any cadCanvas - canvas in myGUI::gui::notebookCanvas
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom02  "  Copy Reference  "     A4  0.2  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom00  "  Base Geometry  "      A4  0.2  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom10  "  Frame Details  "      A4  0.2  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom20  "  ChainStay Details  "  A2  1.0  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom30  "  Summary  "            A4  0.2  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom40  "  Frame Drafting  "     A4  0.2  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom50  "  Mockup  "             A4  0.2  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom60  "  Tube Miter  "         A3  1.0  25  -bd 2  -bg white  -relief sunken
    myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom70  "  Frame Jig  "          A4  0.2  25  -bd 2  -bg white  -relief sunken
        #
        #
    $noteBook_top add   [frame $noteBook_top.components]     -text "... Components" 
    $noteBook_top add   [frame $noteBook_top.report]         -text "... info" 
        #
        #
    $noteBook_top hide  0 ; # hide per default: cv_Custom02  "  Copy Concept   "
        #
        # ---     set fontSize
    foreach cvName {cv_Custom02 cv_Custom00 cv_Custom10 cv_Custom30 cv_Custom40 cv_Custom50 cv_Custom60 cv_Custom70} {
        set cvObject    [lindex [array get notebookObject $cvName] end]
        set fontSize    [$cvObject configure Style Fontsize 2.5]
    }
    foreach cvName {cv_Custom20} {
        set cvObject    [lindex [array get notebookObject $cvName] end]
        set fontSize    [$cvObject configure Style Fontsize 3.5]
    }
        #        
        # ---     fill with Report Widgets
    myGUI::cfg_report::createReport     $noteBook_top.report
        # ---     fill with Library Widgets
    myGUI::compLibrary::createLibrary $noteBook_top.components
    myGUI::compLibrary::update_compList
        #
        # ---     bind event to update Tab on selection
    bind $noteBook_top <<NotebookTabChanged>> {myGUI::view::edit::updateView}
        #
        # ---     bind event Control-Tab and Shift-Control-Tab
    ttk::notebook::enableTraversal $noteBook_top
        #
        # ---     select and update following Tab
    $noteBook_top select $noteBook_top.cv_Custom30
    
        # ---     return
    return $noteBook_top
        #
}


    #-------------------------------------------------------------------------
    #  register notebookCanvas in notebook - Tabs   
    #
proc myGUI::gui::create_cadCanvas {notebook id title stageFormat stageScale stageBorder args} {
        # myGUI::gui::create_cadCanvas  $noteBook_top  cv_Custom30  "Dimension Summary"  A4  0.2 -bd 2  -bg white  -relief sunken
    variable canvasGeometry
    variable notebookObject
    variable notebookRegistry
    
        # ---     add frame containing cadCanvas
    $notebook add   [frame $notebook.$id] -text $title 
    
        # ---     add cadCanvas to frame and select notebook tab before update 
    $notebook select $notebook.$id  
        #
    set cvObject    [eval cad4tcl::new  $notebook.$id  $canvasGeometry(width)  $canvasGeometry(height)  $stageFormat  $stageScale  $stageBorder  $args]
        #
    set cvCanvas    [$cvObject getCanvas]
    puts "     -> create_cadCanvas: $cvCanvas"
        #
    set notebookObject($id)   $cvObject
        #
    dict set notebookRegistry $id notebookWidget    $notebook.$id
    dict set notebookRegistry $id notebookTabTitle  [list $title]
    dict set notebookRegistry $id notebookTabID     [$notebook index $notebook.$id]
    dict set notebookRegistry $id canvasObject      $cvObject
    dict set notebookRegistry $id canvasPath        $cvCanvas
        #
        # appUtil::pdict $notebookRegistry
        #
}


    #-------------------------------------------------------------------------
    #  exit application   
    #
proc myGUI::gui::toggle_Fullscreen {} {   
        
    variable toggleFullScreenWidgets
    
    set changeIndex [myGUI::control::changeList::get_changeIndex]
        
    puts "\n"
    puts "  ====== fullscreen   r a t t l e C A D ==========="
    puts ""

        # puts "     ... wm maxsize: [wm maxsize .]"
    update
        # set x [winfo screenwidth  .]
        # set y [winfo screenheight .]
        # puts "     ... $x / $y"
    
    set currentState [wm attribute . -fullscreen]
    puts "     ... \$currentState: $currentState"
        #
    if {$currentState == 0} {
        wm attribute . -fullscreen 1
        foreach widget $toggleFullScreenWidgets {
            grid $widget
        }
    } else {
        wm attribute . -fullscreen 0
        foreach widget $toggleFullScreenWidgets {
            grid remove $widget
        }
    }
        #
    puts "\n"
    myGUI::gui::notebook_refitCanvas
        #
    puts "\n"
        #
    return
        #
}


    #-------------------------------------------------------------------------
    #  show Console   
    #
proc myGUI::gui::show_Console {} {   
    if {[catch { console show } eID]} {
        puts ""
        puts "      <E> myGUI::gui::show_Console"
        puts ""
        puts "            ... $eID"
        puts ""
    }
}


    #-------------------------------------------------------------------------
    #  get/select notebook-tab, canvasObject  as current/by id     
    #
proc myGUI::gui::current_notebookTabID {} {
        #
        #  -> key in dict: notebookRegistry
        #      -> cv_Custom30, ...
        #
    variable noteBook_top        
    variable notebookRegistry
    set currentTab [$noteBook_top select]
    dict for {index content} $notebookRegistry {
        if {[dict get $content notebookWidget] eq $currentTab} {
            return $index
        }
    }
        #
    return {}
        #
}
proc myGUI::gui::getCanvasObject {{tabID {}}} {
        #
        #  tabID: {}, cv_Custom30
        #  -> [tclOO::Object] eg.: ::oo::Obj406
        #
    variable notebookRegistry
        #
    if {$tabID eq {}} {
        set tabID       [current_notebookTabID]
    }
    set canvasObject    [dict get $notebookRegistry $tabID canvasObject]
        #
    if {$canvasObject eq {}} {
        puts "   ... \$tabID $tabID ... not defined in notebookRegistry"
    }
    puts "   -> \$tabID             $tabID"
    puts "   -> \$canvasObject      $canvasObject"
        #
    return $canvasObject
        #
}
proc myGUI::gui::selectNotebookTab {tabID} {
        #
        #  tabID: cv_Custom00
        #  -> [notebook.tab] eg.: .mainframe.frame.f2.nb.cv_Custom00
        #
    variable noteBook_top        
    variable notebookRegistry
        #
        # ... like cv_Custom00
        #
    puts " ... <D>  selectNotebookTab $tabID"
        # puts " ... <D>  [$noteBook_top select]"
        # appUtil::pdict $notebookRegistry
        #
    set notebookTab     [dict get $notebookRegistry $tabID notebookWidget]
        #
    if {[winfo exists $notebookTab]} {
        $noteBook_top select  $notebookTab 
        return [$noteBook_top select]
    } else {
        puts ""
        puts "         ... <E> selectNotebookTab:"
        puts "               $tabID / $tabID  ... does not exist\n"
        return {}
    }
}
    #-------------------------------------------------------------------------
    #  get notebook window   ... unused ... ????   
    #
proc myGUI::gui::__unused__notebook_getWidget {tabID} {
    variable notebookObject
    foreach index [array names notebookObject] {
        if {$index == $tabID} {
            set cvObject $notebookObject($index)
            set cvPath   [$cvObject getCanvas]
            return $cvPath
        }
    }
}
    #-------------------------------------------------------------------------
    #  get notebook id   ... unused ... ????  
    #
proc myGUI::gui::__unused__notebook_getTabInfo {tabID} {
        #
    variable noteBook_top       
       # puts "\n --------"
       # puts "[$noteBook_top tabs]"
    set i 0
    foreach index [$noteBook_top tabs] {
        set tabWidget "$noteBook_top.$tabID"
        if {$index == $tabWidget} {
            return [list $i $index]
        }
        incr i
    }
    return {}
        #
 }


    #-------------------------------------------------------------------------
    #  get notebook cvObject    
    #
proc myGUI::gui::notebook_getCanvasObject {tabID} {
        #
    variable notebookObject
    variable externalObject
        #   
        # -- myGUI::gui::notebookObject
    foreach varName [array names notebookObject] {
            # puts "          -> $varName $notebookObject($varName) "
        set compareString [file tail [string map {. /} $tabID]]
            # puts "  $varName <-> $compareString  <- $tabID"
        if {$varName eq $compareString} {
            foreach {name cvObject} [array get notebookObject $varName] break
            return $cvObject
        }
    }
        #
        # -- myGUI::gui::externalObject
        # parray externalObject 
    foreach varName [array names externalObject] {
            # puts "          -> $varName $external_cadCanvas($varName) "
        set compareString [file tail [string map {. /} $tabID]]
            # puts "  $varName <-> $compareString  <- $tabID"
        if {$varName eq $compareString} {
            foreach {name cvObject} [array get externalObject $varName] break
            return $cvObject
        }
    }
}


    #-------------------------------------------------------------------------
    #  register external cadCanvas-Widgets
    #
proc myGUI::gui::register_external_cadCanvas {notebook tabID cvObject} {
        #
    variable externalObject
    variable notebookRegistry
        #
    set cvCanvas    [$cvObject getCanvas]
    set externalObject($tabID) $cvObject
        #
        #
        # puts "\n"    
        # puts "   -> register_external_cadCanvas"    
        # puts "   -> $tabID"    
        # puts "   -> $cvObject"    
        #
    dict set notebookRegistry $tabID notebookWidget $notebook.$tabID
    dict set notebookRegistry $tabID canvasObject   $cvObject
    dict set notebookRegistry $tabID canvasPath     $cvCanvas
        #
    puts "\n            register_external_cadCanvas: $tabID -> $externalObject($tabID)"
    puts   "                                         [$externalObject($tabID) getCanvas]"
        #
        # appUtil::pdict $notebookRegistry
             ##
        # parray externalObject
        # variable notebookObject
        # parray notebookObject
        # exit
        
 }


    #-------------------------------------------------------------------------
    #  fill cadCanvas   
    #
proc myGUI::gui::fill_cadCanvas {{tabID {}}} {
    variable noteBook_top
    
    puts "         -------------------------------"
    puts "          myGUI::gui::fill_cadCanvas"
    puts "             tabID:         $tabID"
    if {$tabID == {}} {
        set current_cv [$noteBook_top select]
        puts "        current cadCanvas: $current_cv"
        set tabID [lindex [split $current_cv .] end]
        puts "        -> $tabID"
        # return
    }
    
    switch -exact -- $tabID {
        cv_Custom00 -
        cv_Custom01 -
        cv_Custom02 -
        cv_Custom10 -
        cv_Custom20 -
        cv_Custom30 -
        cv_Custom40 -
        cv_Custom50 -
        cv_Custom60 -
        cv_Custom70 -
        cv_Custom0A {
                $noteBook_top select $noteBook_top.$tabID
                myGUI::cvCustom::updateView $tabID 
                    # myGUI::cvCustom::updateView     myGUI::gui::$varName 
                    # myGUI::gui::notebook_refitCanvas
            }
        cv_Component {
                ::update
                myGUI::gui::notebook_refitCanvas
                myGUI::compLibrary::updateCanvas
            }
        __cv_Library {
                # ::update
                # myGUI::gui::notebook_refitCanvas
                # myGUI::view::configPanel::updateCanvas
                puts " \n\n <D> in fill_cadCanvas:   __cv_Library  \n please give a response to the developers \n"
                tk_messageBox -message " in fill_cadCanvas:   __cv_Library  \n please give a response to the developers"
            }
        
    }
}


    #-------------------------------------------------------------------------
    #  scale cadCanvas in current notebook-Tab  
    #
proc myGUI::gui::notebook_scaleCanvas {value} {
        #
    variable noteBook_top
    variable notebookRegistry
        #
    set tabID       [myGUI::gui::current_notebookTabID]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $tabID]
        #
    if {$cvObject == {}} {
        puts "   notebook_scaleCanvas::cvObject: $cvObject"
        return
    }
    set curScale    [$cvObject configure Canvas Scale]
        #
    set newScale    [format "%.4f" [ expr $value * $curScale * 1.0 ] ]
        #
    $cvObject center $newScale
        #
}


    #-------------------------------------------------------------------------
    #  refit notebookCanvas in current notebook-Tab  
    #
proc myGUI::gui::notebook_refitCanvas {} {
        #
    variable noteBook_top
        #
    update
        #
    set currentTab  [$noteBook_top select]
    set tabID       [myGUI::gui::current_notebookTabID]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $tabID]
    
    # set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
        #
    if {$cvObject eq ""} {
            # exception for notebook tabs that does not contain any cadCanvas - Object
        puts ""
        puts "        myGUI::view::edit::updateView:"
        puts "            -> \$currentTab $currentTab"
        puts ""
        return
    }
        #
    puts "       ... notebook_refitCanvas: $currentTab"
    puts "       ... notebook_refitCanvas: \$cvObject $cvObject"

        #
    $cvObject   fit
        #
    
        # remove position value in $myGUI::cvCustom::Position -> do a recenter
    myGUI::cvCustom::unsetPosition
        #
      
        #
    myGUI::cvCustom::updateView     $tabID
        #
      
    return
        #
}


    #-------------------------------------------------------------------------
    #  clean cadCanvas in current notebook-Tab  
    #
proc myGUI::gui::notebook_cleanCanvas {} {
        #
    variable noteBook_top
        #
    set currentTab  [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
    if { $cvObject == {} } {
        puts "   notebook_cleanCanvas::cvObject: $cvObject"
        return
    }
        #
    $cvObject deleteContent
        #
}


    #-------------------------------------------------------------------------
    #  switch notebook-Tab  
    #
proc myGUI::gui::notebook_switchTab {cvTab} {
    variable noteBook_top
      # puts ""
      # puts " ---------------"
      # puts " notebook_switchTab"
    set tabInfo [notebook_getTabInfo $cvTab]
    set tabID       [lindex $tabInfo 0]
    set tabWidget   [lindex $tabInfo 1]
    set tabState   [$noteBook_top tab  $tabID -state]
    
    if {$tabState == {hidden}} {
        $noteBook_top add    $tabWidget
        $noteBook_top select $tabID
    } else {
        $noteBook_top hide   $tabID
    }
    return
}


    #-------------------------------------------------------------------------
    #  create a Button inside a canvas of notebookCanvas
    #
proc myGUI::gui::notebook_createButton {cvObject cv_ButtonContent} {

    puts ""
    puts "         -------------------------------"
    puts "          myGUI::gui::notebook_createButton"
    puts "             cvObject:            $cvObject"
    puts "             cv_ButtonContent:    $cv_ButtonContent"
        #
    set idx 0
    set x_Position  4
    set y_Position  4
        #
        #
    switch -exact $cv_ButtonContent {
        change_Rendering {
                # -- create a Button to set Rendering: BottleCage, Fork, ...
            $cvObject createConfigCorner myGUI::gui::change_Rendering
                #$nb_Canvas configCorner [format {myGUI::gui::change_Rendering %s %s %s} $cv $x_Position $y_Position ]
        } 
        check_TubingAngles {
                # -- create a Button to execute tubing_checkAngles
            $cvObject createConfigCorner myGUI::view::edit::check_TubingAngles                   
                # $nb_Canvas configCorner myGUI::view::edit::check_TubingAngles                   
                # $nb_Canvas configCorner [format {myGUI::view::edit::tubing_checkAngles %s} $cv]                   
        }
        default {
            $cvObject createConfigCorner [format {myGUI::gui::notebook_ButtonEvent %s %s} $cvObject $cv_ButtonContent ]
                #$nb_Canvas configCorner [format {myGUI::gui::notebook_ButtonEvent %s %s} $cv $cv_ButtonContent ]
        }
    }
        #
    return
        #
}            


proc myGUI::gui::notebook_ButtonEvent {cvObject contentList} {
        #
    set x_Position  4
    set y_Position  4
        #
    puts "\n      myGUI::gui::notebook_ButtonEvent"
    puts "             \$cvObject    $cvObject"
    puts "             \$contentList $contentList"
    set cv [$cvObject getCanvas]
    puts "             \$cv     $cv"
        #
    set contentFrame [$cvObject createConfigContainer Config]
        # set contentFrame [notebook_createConfigContainer $cv $x_Position $y_Position ]
        #
    if {$contentFrame == {}} { 
        puts "  -> \$contentFrame $contentFrame"
        exit
        return 
    }
        #
    puts ""
    puts "-----> myGUI::gui::notebook_ButtonEvent"
    puts "          \$contentFrame  $contentFrame"
    puts "          \$cv  $cv"
    puts "          \$contentList  $contentList"
    puts ""
        #
    foreach addConfig [split $contentList ,] {
        lappend thisContent $addConfig 
        lappend thisContent separator 
    }
    
    set id 0
    foreach addConfig [lrange $thisContent 0 end-1] {
        incr id
        switch -exact $addConfig {
                separator {                 add_ConfigSeparator     $contentFrame $id}
                configMode_Frame {          add_ConfigFrameMode     $contentFrame }
                configMode_BaseDimension {  add_ConfigBaseDimension $contentFrame }
                configMode_ChainStay {      add_ConfigChainStay     $contentFrame }
                configMode_FrameJig {       add_ConfigFrameJig      $contentFrame }
                change_FormatScale {        add_ConfigFormatScale   $contentFrame }
                pageConfig_Scale {          add_ConfigScale         $contentFrame }
                pageConfig_Format {         add_ConfigFormat        $contentFrame }
                default {}
        }
    }
} 

proc myGUI::gui::add_ConfigSeparator {w index} {
        #
    variable frame_configMethod
    variable show_summaryDimension
        #
    set frameName [format {%s.sep_%s} $w $index]
    set frameName [format {sep_%s} $index]
    set contentFrame [frame $w.$frameName]
    pack $contentFrame -fill x
        #
    ttk::separator $contentFrame.seperator
    #grid config $contentFrame.seperator   -column 0 -row  1 -sticky "nsew"
    pack $contentFrame.seperator -fill x
        #
    return
        #
}

proc myGUI::gui::pushedButtonState mode {
    
        #
        #  not implemented yet
        #
    
    if {$mode != {}} {
        switch -exact $mode {
                {OutsideIn}  -
                {StackReach} -
                {Lugs}       -
                {Classic}   { 
                            set myGUI::control::frame_configMode $mode
                            myGUI::control::setFrameConfigMode
                        }
                default return
        }
    }
    
    foreach button [list $contentFrame.hybrid   ] {
        $button configure -relief raised
    }
    switch -exact $mode {
            {OutsideIn}  { $contentFrame.hybrid     configure -relief sunken}
            {StackReach} { $contentFrame.stackreach configure -relief sunken}
            {Lugs}       { $contentFrame.classic    configure -relief sunken}
            {Classic}    { $contentFrame.lugs       configure -relief sunken}
            default {}
    }
    
    return

}





    #-------------------------------------------------------------------------
    #  create menue to switch frame configuration mode 
    #
proc myGUI::gui::add_ConfigFrameMode {w {type {default}}} {
        #
    variable frame_configMethod
    variable show_summaryDimension
        #                #
    set contentFrame [frame $w.frameMode]
    pack $contentFrame -fill x 
            #
    #ttk::separator $contentFrame.seperator_1
    label       $contentFrame.label      -text "Frame Config:"      
    #ttk::separator $contentFrame.seperator_1
        # button $contentFrame.hybrid       -text "Outside-In"        -command {myGUI::gui::pushedButtonState OutsideIn }
        # button $contentFrame.stackreach   -text "Stack & Reach"     -command {myGUI::gui::pushedButtonState StackReach}
        # button $contentFrame.classic      -text "Classic"           -command {myGUI::gui::pushedButtonState Classic   }
        # button $contentFrame.lugs         -text "Lug Angles"        -command {myGUI::gui::pushedButtonState Lugs      }
    radiobutton $contentFrame.hybrid       -text "Outside-In"        -value {OutsideIn}     -variable myGUI::control::frame_configMode  -command {myGUI::control::setFrameConfigMode}
    radiobutton $contentFrame.stackreach   -text "Stack & Reach"     -value {StackReach}    -variable myGUI::control::frame_configMode  -command {myGUI::control::setFrameConfigMode}
    radiobutton $contentFrame.classic      -text "Classic"           -value {Classic}       -variable myGUI::control::frame_configMode  -command {myGUI::control::setFrameConfigMode}
    radiobutton $contentFrame.lugs         -text "Lug Angles"        -value {Lugs}          -variable myGUI::control::frame_configMode  -command {myGUI::control::setFrameConfigMode}
        #
    #grid config $contentFrame.seperator_1   -column 0 -row  1 -sticky "nsew"
    grid config $contentFrame.label         -column 0 -row  0 -sticky "w"
    #grid config $contentFrame.seperator_2   -column 0 -row  1 -sticky "nsew"
    grid config $contentFrame.hybrid        -column 0 -row  2 -sticky "w"
    grid config $contentFrame.stackreach    -column 0 -row  3 -sticky "w"
    grid config $contentFrame.classic       -column 0 -row  4 -sticky "w"
    grid config $contentFrame.lugs          -column 0 -row  5 -sticky "w"
        #                #
    set newFont [format {%s bold}  [$contentFrame.label cget -font]]
    # check this
    # $contentFrame.label configure   -font $newFont
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  create menue to show dimension in BaseConfig
    #
proc myGUI::gui::add_ConfigBaseDimension {w {type {default}}} {
        #
    variable frame_configMethod
    variable show_summaryDimension
        #                #
    set contentFrame [frame $w.baseDim]
    pack $contentFrame -fill x 
            #
    #ttk::separator $contentFrame.seperator  
    label       $contentFrame.label        -text "Show Dimension:"      
    checkbutton $contentFrame.dimSec       -text "Secondary"         -variable myGUI::gui::show_secondaryDimension                -command {myGUI::view::edit::updateView force}
    checkbutton $contentFrame.dimRes       -text "Result"            -variable myGUI::gui::show_resultDimension                   -command {myGUI::view::edit::updateView force}
    checkbutton $contentFrame.dimSum       -text "Summary"           -variable myGUI::gui::show_summaryDimension                  -command {myGUI::view::edit::updateView force}
        #
    #grid config $contentFrame.seperator    -column 0 -row  1 -sticky "nsew"
    grid config $contentFrame.label        -column 0 -row  2 -sticky "w"
    grid config $contentFrame.dimSec       -column 0 -row  3 -sticky "w"
    grid config $contentFrame.dimRes       -column 0 -row  4 -sticky "w"
    grid config $contentFrame.dimSum       -column 0 -row  5 -sticky "w"
        #
    $contentFrame.dimSec    configure  -activebackground $myGUI::cvCustom::DraftingColor(secondary)   -activeforeground white
    $contentFrame.dimRes    configure  -activebackground $myGUI::cvCustom::DraftingColor(result)      -activeforeground white
    $contentFrame.dimSum    configure  -activebackground $myGUI::cvCustom::DraftingColor(background)  -activeforeground white
        #
    set newFont [format {%s bold}  [$contentFrame.label cget -font]]
    # check this
    # $contentFrame.label configure   -font $newFont
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  create menue to switch ChainStayMode
    #
proc myGUI::gui::add_ConfigChainStay {w {type {default}}} {
        #
    set contentFrame [frame $w.chainStay]
    pack $contentFrame -fill x 
            #
    #ttk::separator $contentFrame.seperator
        #
    set valueKey    "Config:ChainStay"
    set varName     [format {%s::%s(%s)} ::myGUI::view::edit _viewValue $valueKey]
        #
    set $varName    [myGUI::model::model_XZ::getConfig ChainStay]

        #
    label       $contentFrame.label     -text "ChainStay Type:"      
    radiobutton $contentFrame.straight  -text "straight"         -value {straight}   -variable $varName     -command {myGUI::control::setChainStayType} 
    radiobutton $contentFrame.bent      -text "bent"             -value {bent}       -variable $varName     -command {myGUI::control::setChainStayType} 
    radiobutton $contentFrame.hide      -text "hide"             -value {off}        -variable $varName     -command {myGUI::control::setChainStayType} 
        #
        # grid config $contentFrame.seperator    -column 0 -row  1 -sticky "nsew"
        #
    grid config $contentFrame.label     -column 0 -row  2 -sticky "w"
    grid config $contentFrame.straight  -column 0 -row  3 -sticky "w"
    grid config $contentFrame.bent      -column 0 -row  4 -sticky "w"
    grid config $contentFrame.hide      -column 0 -row  5 -sticky "w"
        #
    # set newFont [format {%s bold}  [$contentFrame.label cget -font]]
    # check this
    # $contentFrame.label configure   -font $newFont
        #
    return
        #
}
    #-------------------------------------------------------------------------
    #  create menue to change size of Stage 
    #
proc myGUI::gui::add_ConfigFormat {w {header {default}}}  {
        #
        #
    variable noteBook_top
        #
        #
        # --- get stageScale
    set currentTab [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
        # puts "  -- > $cv_Name < --"
    set myGUI::gui::stageFormat  [$cvObject configure Stage Format]
        # set myGUI::gui::stageFormat  [$cv_Name getNodeAttr Stage format]
        # puts "  -- > $myGUI::gui::stageScale < --"
        #
    set contentFrame [frame $w.pageFormat]
    pack $contentFrame -fill x 
        #
    # ttk::separator $contentFrame.seperator
        #
    label       $contentFrame.label     -text "DIN Format:"      
        #
    radiobutton $contentFrame.a4 -text A4 -value A4    -variable myGUI::gui::stageFormat  -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.a3 -text A3 -value A3    -variable myGUI::gui::stageFormat  -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.a2 -text A2 -value A2    -variable myGUI::gui::stageFormat  -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.a1 -text A1 -value A1    -variable myGUI::gui::stageFormat  -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.a0 -text A0 -value A0    -variable myGUI::gui::stageFormat  -command {myGUI::gui::notebook_formatCanvas}
        #
    # grid config $contentFrame.seperator -column 0 -row 0 -sticky "news"
    grid config $contentFrame.label     -column 0 -row 1 -sticky "w"
    grid config $contentFrame.a4        -column 0 -row 2 -sticky "w"
    grid config $contentFrame.a3        -column 0 -row 3 -sticky "w"
    grid config $contentFrame.a2        -column 0 -row 4 -sticky "w"
    grid config $contentFrame.a1        -column 0 -row 5 -sticky "w"
    grid config $contentFrame.a0        -column 0 -row 6 -sticky "w"
        #
    set newFont [format {%s bold}  [$contentFrame.label cget -font]]
    # check this
    # $contentFrame.label configure   -font $newFont
        #
        #
    set rbName [format "%s.%s" $contentFrame [string tolower $myGUI::gui::stageFormat]]
        # puts "  -> $contentFrame "
        # puts "  -> $rbName "
    catch {$rbName select}
        #
    if {$header == {noHeader}} {
        grid forget $contentFrame.label
    }    
        #
        #
    return    
        #          
}
    #-------------------------------------------------------------------------
    #  create menue to change scale of Stage 
    #
proc myGUI::gui::add_ConfigScale {w {header {default}}}  {
        #
    variable noteBook_top
        #
        
        #
        # --- get stageScale
    set currentTab [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
    set myGUI::gui::stageScale  [format %.2f [$cvObject  configure  Stage    Scale ]]
        # set myGUI::gui::stageScale  [format %.2f [$cv_Name  getNodeAttr  Stage    scale ]]
        #
    set contentFrame [frame $w.pageScale]
    pack $contentFrame -fill x 
        #
        # ttk::separator $contentFrame.seperator
        #
    label       $contentFrame.label     -text "Page Scale:"
        #
    radiobutton $contentFrame.s020 -text "1:5  "     -value 0.20 -anchor w     -variable myGUI::gui::stageScale -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.s025 -text "1:4  "     -value 0.25 -anchor w     -variable myGUI::gui::stageScale -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.s033 -text "1:3  "     -value 0.33 -anchor w     -variable myGUI::gui::stageScale -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.s040 -text "1:2,5"     -value 0.40 -anchor w     -variable myGUI::gui::stageScale -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.s050 -text "1:2  "     -value 0.50 -anchor w     -variable myGUI::gui::stageScale -command {myGUI::gui::notebook_formatCanvas}
    radiobutton $contentFrame.s100 -text "1:1  "     -value 1.00 -anchor w     -variable myGUI::gui::stageScale -command {myGUI::gui::notebook_formatCanvas}
        #
        #
    grid config $contentFrame.label     -column 0 -row  2 -sticky "w"
    grid config $contentFrame.s020      -column 0 -row  3 -sticky "w"
    grid config $contentFrame.s025      -column 0 -row  4 -sticky "w"
    grid config $contentFrame.s033      -column 0 -row  5 -sticky "w"
    grid config $contentFrame.s040      -column 0 -row  6 -sticky "w"
    grid config $contentFrame.s050      -column 0 -row  7 -sticky "w"
    grid config $contentFrame.s100      -column 0 -row  8 -sticky "w"
        #
    set newFont [format {%s bold}  [$contentFrame.label cget -font]]
        #
    set rbName [format "%s.s%03i" $contentFrame [expr int(100*$myGUI::gui::stageScale)]]
        #
    catch {$rbName select}
        #
    if {$header == {noHeader}} {
        grid forget $contentFrame.label
    }       
        #
        #
    return    
        #          
}
    #-------------------------------------------------------------------------
    #  create menue to change change FrameJig Version 
    #
proc myGUI::gui::add_ConfigFrameJig {w {type {default}}}  {
        #
    set contentFrame [frame $w.frameJig]
    pack $contentFrame -fill x 
        #
    set f_FrameJig    [frame $contentFrame.jigType ]
      # foreach jig $::APPL_Config(list_FrameJigTypes) {}
        # foreach jig $myGUI::modelAdapter::valueRegistry(FrameJigType) {}
    foreach jig $myGUI::model::model_Edit::ListBoxValues(FrameJigType) {
        radiobutton     $f_FrameJig.option_$jig \
                                -text $jig \
                                -value $jig  \
                                -anchor w  \
                                -variable ::APPL_Config(FrameJigType)  \
                                -command {myGUI::gui::updateFrameJig}
        pack $f_FrameJig.option_$jig -fill x -expand yes -side top
    }
    pack $f_FrameJig -side left -fill x
 
}


    #-------------------------------------------------------------------------
    #  update Personal Geometry with parameters of Reference Geometry 
    #
proc myGUI::gui::geometry_reference2personal {} {

    set answer    [tk_messageBox -icon question -type okcancel -title "Reference to Personal" -default cancel\
                                -message "Do you really wants to overwrite your \"Personal\" parameter \n with \"Reference\" settings" ]
        #tk_messageBox -message "$answer"    
        
    switch $answer {
        cancel    return                
        ok        { frame_geometry_reference::export_parameter_2_geometry_custom  $myGUI::control::currentDOM
                    # frame_geometry_reference::export_parameter_2_geometry_custom  $::APPL_Config(root_ProjectDOM)
                    myGUI::gui::fill_cadCanvas cv_Custom00 
                  }
    }
}


    #-------------------------------------------------------------------------
    #  change Rendering Settings 
    #
proc myGUI::gui::change_Rendering  {}  {
        #
    set x 15
    set y 40
        #
    myGUI::view::edit::group_Rendering_Parameter    $x  $y  [myGUI::gui::getCanvasObject]
        #
    return
        #
}


    #-------------------------------------------------------------------------
    #  change cadCanvas Format and Scale
    #
proc myGUI::gui::notebook_formatCanvas {} {
        #
    variable canvasUpdate
    variable noteBook_top

        # puts "\n=================="
        # puts "    stageFormat $stageFormat"
        # puts "    stageScale  $stageScale"
        # puts "=================="
            
    set currentTab  [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #

    if { $cvObject == {} } {
            puts "   notebook_refitCanvas::cvObject: $cvObject"
            return
    }
                    
        #
    $cvObject configure Stage Format $myGUI::gui::stageFormat
    $cvObject configure Stage Scale  $myGUI::gui::stageScale
        # $cvObject formatStage $myGUI::gui::stageFormat  $myGUI::gui::stageScale
        # 

        #
    notebook_refitCanvas
    myGUI::view::edit::updateView   force
        # 
}


    #-------------------------------------------------------------------------
    #  change type of Frame Jig dimensioning
    #
proc myGUI::gui::updateFrameJig {} {
    variable noteBook_top
    
    set currentTab [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
    puts "   ... \$cvObject $cvObject"
        #
    set canvasUpdate($currentTab) [ expr $myGUI::control::model_Update -1 ]
        #
      
        #
    myGUI::view::edit::updateView force
        #
}

    #-------------------------------------------------------------------------
    #  load Template from File
    #
proc myGUI::gui::load_Template__3.4.03 {type} {
    variable canvasUpdate
    variable noteBook_top

    myPersist::file::openTemplate_xml $type
      #
    switch -exact $type {
        Road { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateRoad_default) }
        MTB  { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateMTB_default) }
    }
      # puts "\n\  -> \$type:  $type"
      # puts "\n\  -> \$::APPL_Config(TemplateInit):  $::APPL_Config(TemplateInit)"
    return
}
    #-------------------------------------------------------------------------
    #  cursor rendering on canvas objects
    #
proc myGUI::gui::object_CursorRendering {cvObject tag {cursor {hand2}} } {
        #
    $cvObject bind $tag     <Enter>     [list $cvObject configure Canvas Cursor  $cursor]
    $cvObject bind $tag     <Leave>     [list $cvObject configure Canvas Cursor  {}]
        #
}
    #-------------------------------------------------------------------------
    #  move canvas content
    #
proc myGUI::gui::move_Canvas {x y} {
        #
    variable canvasUpdate
    variable noteBook_top

        puts "\n=================="
        puts "    myGUI::gui::move_Canvas $x $y"
        puts "=================="
            
    set currentTab  [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
        #
    catch {$cvObject move [list $x $y]}
        #
}
    #-------------------------------------------------------------------------
    #
proc myGUI::gui::setTooltip {widget text} {
        # http://wiki.tcl.tk/1954
        #   setTooltip $widget "Hello World!"
        #   ttk::button does not support -helptext of Button in BWidget
    if { $text != "" } {
        # 2) Adjusted timings and added key and button bindings. These seem to
        # make artifacts tolerably rare.
        bind $widget <Any-Enter>    [list after 300 [list [namespace current]::showTooltip %W $text]]
        bind $widget <Any-Leave>    [list after 300 [list destroy %W.tooltip]]
        bind $widget <Any-KeyPress> [list after 300 [list destroy %W.tooltip]]
        bind $widget <Any-Button>   [list after 300 [list destroy %W.tooltip]]
    }
}
    #-------------------------------------------------------------------------
    #
proc myGUI::gui::showTooltip {widget text} {
        # http://wiki.tcl.tk/1954 
    global tcl_platform
    if { [string match $widget* [winfo containing  [winfo pointerx .] [winfo pointery .]] ] == 0  } {
            return
    }
        #
    catch { destroy $widget.tooltip }
        #
    set scrh [winfo screenheight $widget]    ; # 1) flashing window fix
    set scrw [winfo screenwidth $widget]     ; # 1) flashing window fix
    set tooltip [toplevel $widget.tooltip -bd 1 -bg black]
    wm geometry $tooltip +$scrh+$scrw        ; # 1) flashing window fix
    wm overrideredirect $tooltip 1
        #
    if {$tcl_platform(platform) == {windows}} { ; # 3) wm attributes...
        wm attributes $tooltip -topmost 1       ; # 3) assumes...
    }                                           ; # 3) Windows
    pack [label $tooltip.label -bg lightyellow -fg black -text $text -justify left]
        #
    set width [winfo reqwidth $tooltip.label]
    set height [winfo reqheight $tooltip.label]
        # 
        # b.) Is the pointer in the bottom half of the screen?
    set pointer_below_midline [expr [winfo pointery .] > [expr [winfo screenheight .] / 2.0]]                
        #
        # c.) Tooltip is centred horizontally on pointer.
        #     default x: - round($width / 2.0)
        #          set positionX [expr [winfo pointerx .] - round($width / 2.0)] 
    set positionX [expr [winfo pointerx .] +  5] 
        # b.) Tooltip is displayed above or below depending on pointer Y position.
    set positionY [expr [winfo pointery .] + 25 * ($pointer_below_midline * -2 + 1) - round($height / 2.0)]  
        #
        # a.) Ad-hockery: Set positionX so the entire tooltip widget will be displayed.
        # c.) Simplified slightly and modified to handle horizontally-centred tooltips and the left screen edge.
    if  {[expr $positionX + $width] > [winfo screenwidth .]} {
            set positionX [expr [winfo screenwidth .] - $width]
    } elseif {$positionX < 0} {
            set positionX 0
    }

    wm geometry $tooltip [join  "$width x $height + $positionX + $positionY" {}]
    raise $tooltip

    # 2) Kludge: defeat rare artifact by passing mouse over a tooltip to destroy it.
    bind $widget.tooltip <Any-Enter> {destroy %W}
    bind $widget.tooltip <Any-Leave> {destroy %W}
}    
    #-------------------------------------------------------------------------
    #  bindings
    #
proc myGUI::gui::binding_copyClass {class newClass} {
        #   http://wiki.tcl.tk/2944
    set bindingList [bind $class]
        # puts $bindingList
    foreach binding $bindingList {
        bind $newClass $binding [bind $class $binding]
    }
}
proc myGUI::gui::binding_removeAllBut {class bindList} {
    foreach binding $bindList {
      array set tmprab "<${binding}> 0"
    }

    foreach binding [bind $class] {
      if {[info exists tmprab($binding)]} {
        continue
      }
      bind $class $binding {}
    }
}
proc myGUI::gui::binding_removeOnly {class bindList} {
    foreach binding $bindList {
      array set tmprab "<${binding}> 0"
    }

    foreach binding [bind $class] {
      if {[info exists tmprab($binding)]} {
        bind $class $binding {}
      }
      continue
      # bind $class $binding {}
    }
}
proc myGUI::gui::binding_reportBindings {class} {
    puts "    reportBindings: $class"
    foreach binding [bind $class] {
        puts "           $binding"
    }
}    
    #
proc myGUI::gui::bind_keyBoard_global {ab} {
        #
    variable noteBook_top
        #
        # puts "\n   -----> keyboard binding \n -------------"
        #
    bind . <F1>                 {myGUI::infoPanel::create  .v_info 1}
    bind . <F3>                 {myGUI::gui::notebook_scaleCanvas  [expr 2.0/3]}
    bind . <F4>                 {myGUI::gui::notebook_scaleCanvas  [expr 3.0/2]}
    bind . <F5>                 {myGUI::gui::notebook_refitCanvas}
    bind . <F6>                 {myGUI::view::edit::updateView      force}
        #
    bind . <Control-Key-Up>     {myGUI::gui::bind_mouseWheel        scale  2}
    bind . <Control-Key-Down>   {myGUI::gui::bind_mouseWheel        scale -2}
        #
    bind . <Key-Up>             {myGUI::gui::move_Canvas                0 -5}
    bind . <Key-Down>           {myGUI::gui::move_Canvas                0  5}
    bind . <Key-Left>           {myGUI::gui::move_Canvas               -5  0}
    bind . <Key-Right>          {myGUI::gui::move_Canvas                5  0}
    
    bind . <MouseWheel>         {myGUI::gui::bind_mouseWheel    updown    %D}  ;# move up/down
    bind . <Shift-MouseWheel>   {myGUI::gui::bind_mouseWheel    leftright %D}  ;# move left/right
    bind . <Control-MouseWheel> {myGUI::gui::bind_mouseWheel    scale     %D}  ;# scale
        #
        # bind . <Key-Tab>    {myGUI::gui::notebook_nextTab}
        # bind . <Key-Tab>    {tk_messageBox -message "Keyboard Event: <Key-Tab>"}
        # bind . <F5>     { tk_messageBox -message "Keyboard Event: <F5>" }
        #
}
proc myGUI::gui::bind_mouseWheel {type value} {
    variable canvasUpdate
    variable noteBook_top

        # myGUI::view::edit::createEdit
        #    creates window $cv.f_edit
        #    catch <MouseWheel> for $cv.f_edit
    set currentTab  [$noteBook_top select]
    set cvObject    [myGUI::gui::notebook_getCanvasObject $currentTab]
    
        # ----------------------------
        # exception for the report tab
        #    ... there is no canvas
        #
    switch -glob $currentTab {
        *\.report {
                puts "  -- <E> -- $currentTab"
                return
            }
        default {}    
    } 
    
    puts "<D>  bind_mouseWheel $type $value"
    puts "<D>  bind_mouseWheel \$currentTab $currentTab"
    puts "<D>  bind_mouseWheel \$cvObject $cvObject"
    
    set cvCanvas         [$cvObject getCanvas]
        #
    if {[llength [$cvCanvas gettags  __cvEdit__]] > 0 } {
        # puts "\n=================="
        # puts "    bind_MouseWheel: catched"
        return
    }
    
        puts "\n=================="
        puts "    bind_MouseWheel"
        puts "       type   $type"
        puts "       value  $value"
        
    switch -exact $type {
        updown { if {$value > 0} {set scale 1.0} else {set scale -1.0}
                    myGUI::gui::move_Canvas    0  [expr $scale * 40] 
                }
        leftright {   if {$value > 0} {set scale 1.0} else {set scale -1.0}
                    myGUI::gui::move_Canvas    [expr $scale * 40]  0 
                }
        scale {  if {$value > 0} {set scale 1.1} else {set scale 0.9}
                    myGUI::gui::notebook_scaleCanvas $scale
                }
        default  {}
    }
        
    return     
}
proc myGUI::gui::bind_windowSize {{mode {}}} {
        #
    variable window_Size
    variable window_Update
        #
    set newSize [lindex [split [wm geometry .] +] 0]
        #
        # puts "   -> newSize:   $newSize"
        # puts "   -> lastSize:  [set [namespace current]::window_Size]"
        #
    if {$mode == {init}} {
          # puts ""
          # puts "     ... [namespace current]::bind_windowSize: init"
          # puts ""
        update
        set window_Size   $newSize
        set window_Update [clock milliseconds]
          # puts "     ... [namespace current]::bind_windowSize: [set window_Size]"
          # puts "     ... [namespace current]::bind_windowSize: [set window_Update]"
          # puts ""
        return
    }
        #
    if {![string equal $newSize [set [namespace current]::window_Size]]} {
          # puts ""
          # puts "     ... [namespace current]::bind_windowSize: [set window_Update]"
        set window_Size   $newSize
        set window_Update [clock milliseconds]
        
          # tk_messageBox -message "bind_windowSize"
          # puts "     ... [namespace current]::bind_windowSize: [set window_Size]"
          # puts "     ... [namespace current]::bind_windowSize: [set window_Update]"
          # puts ""
          #
        return
    }
}
        #
proc myGUI::gui::__bind_dimensionEvent {cv_Name dimObject procedureName {cursor {hand2}}} {
        #
        # puts "  dimension_CursorBinding: $cv_Name - $dimObject - $procedureName - $cursor"
        #
    if {$dimObject eq {}} {
        return
    }    
        #
    set sensArea [$dimObject createSensitiveArea]
        #
    $cv_Name bind $sensArea <Enter>           [list $cv_Name configure -cursor $cursor]
    $cv_Name bind $sensArea <Leave>           [list $cv_Name configure -cursor {}]
    $cv_Name bind $sensArea <ButtonPress-1>   [list myGUI::view::edit::$procedureName %x %y  $cv_Name ]
        #
    set sensText [$dimObject get_textTag]
        #
    $cv_Name bind $sensText <Enter>           [list $cv_Name configure -cursor $cursor]
    $cv_Name bind $sensText <Leave>           [list $cv_Name configure -cursor {}]
    $cv_Name bind $sensText <ButtonPress-1>   [list myGUI::view::edit::$procedureName %x %y  $cv_Name ]
}
proc myGUI::gui::__bind_objectEvent {cv_Name tag procedureName {cursor {hand2}} } {
    $cv_Name bind $tag    <Enter>           [list $cv_Name configure -cursor $cursor]
    $cv_Name bind $tag    <Leave>           [list $cv_Name configure -cursor {}]
    $cv_Name bind $tag    <ButtonPress-1>   [list myGUI::view::edit::$procedureName %x %y  $cv_Name ]
}
    #
proc myGUI::gui::bind_dimensionEvent_2 {cvObject dimObject procedureName {cursor {hand2}}} {
        #
        # puts "\n ----"
        # puts "  dimension_CursorBinding_2: $cvObject - $dimObject - $procedureName - $cursor"
        #
    if {$dimObject eq {}} {
        return
    }
        #
    set sensArea    [$dimObject createSensitiveArea]
        # puts "  dimension_CursorBinding_2: \$sensArea - $sensArea"
        #
        # $cvObject registerClickObject $sensArea     [list $procedureName]  
        #
    $cvObject bind $sensArea    <Enter>         [list $cvObject configure Canvas Cursor $cursor]
    $cvObject bind $sensArea    <Leave>         [list $cvObject configure Canvas Cursor {}]
    $cvObject bind $sensArea    <ButtonPress-1> [list myGUI::view::edit::$procedureName %x %y  $cvObject]
        #
    set sensText    [$dimObject get_textTag]
        #
        # $cvObject registerClickObject $sensText     [list $procedureName]  
        #
    $cvObject bind $sensText    <Enter>         [list $cvObject configure Canvas Cursor $cursor]
    $cvObject bind $sensText    <Leave>         [list $cvObject configure Canvas Cursor {}]
    $cvObject bind $sensText    <ButtonPress-1> [list myGUI::view::edit::$procedureName %x %y  $cvObject]
        #
}
proc myGUI::gui::bind_objectEvent_2 {cvObject tag procedureName {cursor {hand2}} } {
        #
    $cvObject registerClickObject $tag          [list $procedureName]  
        #
    $cvObject bind $tag         <ButtonPress-1> [list myGUI::view::edit::$procedureName %x %y  $cvObject]
        #
        # $cvObject bind $tag         <Enter>         [list $cvObject configure Canvas Cursor $cursor]
        # $cvObject bind $tag         <Leave>         [list $cvObject configure Canvas Cursor {}]
        #
}
    #


    #-------------------------------------------------------------------------
    #  create createSelectBox
proc myGUI::gui::__bind_parent_move__ {toplevel_widget parent} {
      # appUtil::get_procHierarchy
    if {![winfo exists $toplevel_widget]} {return}
    set toplevel_x    [winfo rootx $parent]
    set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
    wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
    wm  deiconify     $toplevel_widget
}

