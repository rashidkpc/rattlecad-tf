#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # myGUI.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk and tdom and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2016/08/15
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
 
 #
 # 0.01  2016-08-08  init
 #
 #
 

###########################################################################
#
#                 I  -  N  -  I  -  T                        -  Application
#
###########################################################################

package provide myGUI 0.01

namespace eval myGUI {
  
    # --------------------------------------------
        # initial package definition
    package require BWidget
    package require snit             
    package require tdom
        #
    package require appUtil     0.17
    package require vectormath  1.00
    package require bikeModel   0.02
    package require extSummary  0.4
    package require osEnv       0.11
    package require cad4tcl     0.01
    package require myPersist   0.01
        #
    package require myTool
        #
    
    # --------------------------------------------
        #
        # variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]]]
    variable packageHomeDir [file dirname [file normalize [info script]]]
        #
    variable GUIConfig ;    array set GUIConfig {}
        #

    # --------------------------------------------
        #  create base config 
        #       -> registryDOM
}

    ###########################################################################
    #
    #         V  -  A  -  R  -  I  -  A  -  B  -  L  -  E  -  S 
    #
    ###########################################################################

array set APPL_Config { 
                RELEASE_Version     {3.4}  
                RELEASE_Revision    {tbd}
                RELEASE_Date        {04. May. 2014}
                
                VECTOR_Font         {}
                Language            {english}

                USER_InitString     {_init_Template}
                WINDOW_Title        {}
                FILE_List           {}

                PROJECT_Save        {0}
                
                TemplateType        {}
                FrameJigType        {}

                BASE_Dir            {}
                ROOT_Dir            {}
                CONFIG_Dir          {}
                IMAGE_Dir           {}
                TEST_Dir            {}
                USER_Dir            {}
                EXPORT_Dir          {}
                EXPORT_PDF          {}
                EXPORT_HTML         {}
                
                user_InitDOM        {}
                root_InitDOM        {}
                
            }   
            
              # root_ProjectDOM     {}
              # cadCanvas_Update    {0}
              # window_Size         {0}
              # window_Update       {0}
              # GUI_Font            {Helvetica 8}
                

                 
array set APPL_CompLocation {}

variable projectDOM
    
    #
namespace eval myGUI::image {}
    #


###########################################################################
#
#         F  -  U  -  N  -  C  -  T  -  I  -  O  -  N  -  S 
#
###########################################################################


    #-------------------------------------------------------------------------
    #  init GUI-Config
    #
proc myGUI::main {baseDir {startupProject {}}} {
        #
        #
    puts "\n\n ====== M A I N ============================ \n\n"
        #
        
        #
    myGUI::init $baseDir     
        #
        
        # -- MVC - Model
        #
    myGUI::control::init_Model
        #
    myGUI::control::add_ComponentDir user   [file join $::APPL_Config(USER_Dir) components]
        #

        # -- ... if there is a given Project-File
        #
    myGUI::open_StartupProject $startupProject
        #
        
        # -- MVC - View
        #
    myGUI::init_GUI
        #
        
        #
    myGUI::control::updateControl
        #
        
        #
    myGUI::view::edit::update_windowTitle  
    myGUI::view::edit::update_MainFrameStatus
        #
    tk appname  rattleCAD
        #
        #
    puts "\n"
    puts "  ----------------------------------------------"
    puts "  rattleCAD      $::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"
    puts "                             $::APPL_Config(RELEASE_Date)"
    puts "  ----------------------------------------------\n"
    
        #
}


    #-------------------------------------------------------------------------
    #  init GUI-Config
    #
proc myGUI::init {baseDir} {

    variable packageHomeDir
    variable GUIConfig
    
        # --
        #
    set packageConfigDir [file normalize [file join    $packageHomeDir ..]]
    
    
        # -- Application Directories  -----------
        #
    set rootDir                         [file dirname   $baseDir]
        #
    set ::APPL_Config(BASE_Dir)         $baseDir
    set ::APPL_Config(ROOT_Dir)         $rootDir
    set ::APPL_Config(CONFIG_Dir)       [file join      $packageHomeDir etc]
    set ::APPL_Config(IMAGE_Dir)        [file join      $packageHomeDir image]
    set ::APPL_Config(SAMPLE_Dir)       [file join      $packageHomeDir sample]
    set ::APPL_Config(TEST_Dir)         [file join      $packageHomeDir test]
    set ::APPL_Config(TOOL_Dir)         [file join      $packageHomeDir _tool]
        #
    set ::APPL_Config(COMPONENT_Dir)    {}   
    set ::APPL_Config(CUSTOM_Dir)       {}
        #
    set ::APPL_Config(USER_Dir)         [myPersist::file::check_user_dir rattleCAD]
        #
    migrate_USER_Dir                    ;# 3.4.05.50 ... harmonize Linux and MacOS with Windows    
        #
    set ::APPL_Config(EXPORT_Dir)       [myPersist::file::check_user_dir rattleCAD/export]
    set ::APPL_Config(EXPORT_HTML)      [myPersist::file::check_user_dir rattleCAD/html]
    set ::APPL_Config(EXPORT_PDF)       [myPersist::file::check_user_dir rattleCAD/pdf]
    set ::APPL_Config(EXPORT_FEA)       [myPersist::file::check_user_dir rattleCAD/analysis]
    set ::APPL_Config(EXPORT_IMAGE)     [myPersist::file::check_user_dir rattleCAD/image]
    set ::APPL_Config(TEMPLATE_Dir)     [myPersist::file::check_user_dir rattleCAD/___template/rattleCAD]
        #
        # -- Application Directories  -----------
        #
    set ::APPL_Config(PLUGIN_Dir)       [file join      $rootDir        _plugin]
    if {$::tcl_platform(os) eq {Darwin}} {
        if {![file exists $::APPL_Config(PLUGIN_Dir)]} {
            set dir_PlugIns [file join $::APPL_Config(ROOT_Dir) .. PlugIns]
            if [file exists $dir_PlugIns] {
                set ::APPL_Config(PLUGIN_Dir)   $dir_PlugIns
            }
        } 
    }
    set ::APPL_Config(PLUGIN_Dir)       [file normalize $::APPL_Config(PLUGIN_Dir)]    
        # -- Application - Logging  -----------
        #
    myGUI::control::redirect_STDOUT    
        # set ::APPL_Config(LogFile)          [file join $::APPL_Config(USER_Dir) _logFile.txt]
        # set ::APPL_Config(LogFile)          [open [file join $::APPL_Config(USER_Dir) _logFile.txt] w]
    
                   
        # -- MainFrame - Indicator  -----------
        #
    set ::APPL_Config(MainFrameInd_Project)  {}
    set ::APPL_Config(MainFrameInd_Status)   {}

    
        # -- Version Info  ----------------------
        #
    if {[file exists [file join $baseDir tclkit.inf]]} {
        # puts " customizing strings in executable"
        set fd [open [file join $baseDir tclkit.inf]]
        array set strinfo [read $fd]
        close $fd
    } else {
        set message {}
        append message "\n ... $::argv0"
        append message "\n ... $::APPL_Config(ROOT_Dir)"
        append message "\n ... $::APPL_Config(BASE_Dir)"

        tk_messageBox -title "tclkit.inf" -message $message
    
        array set strinfo {
            ProductVersion  {3.4.xx}
            FileVersion     {??}
            FileDate        {??. ???. 201?}
        }
    }
        # parray strinfo
  
        
        # -- Version Info  ----------------------
        #
    set ::APPL_Config(RELEASE_Version)  $strinfo(ProductVersion)    ;#{3.2}
    set ::APPL_Config(RELEASE_Revision) $strinfo(FileVersion)       ;#{66}
    set ::APPL_Config(RELEASE_Date)     $strinfo(FileDate)          ;#{18. Dec. 2011}
    
        
        # -- check equality BASE_Dir / USER_Dir
        #
    check_BASE_Dir \
            $::APPL_Config(BASE_Dir) \
            $::APPL_Config(USER_Dir)
            
            
        # -- rattleCAD Config  ----------------
        #
    set ::APPL_Config(root_InitDOM)     [myPersist::file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]]
    puts "     ... root_InitDOM      [file join $::APPL_Config(CONFIG_Dir) rattleCAD_init.xml]"


        # --- get Template Files --------------
        #
    set node    [ $::APPL_Config(root_InitDOM) selectNodes /root/Template/Road ]
    set ::APPL_Config(TemplateRoad_default)  [file join $::APPL_Config(CONFIG_Dir) [$node asText] ]
    set node    [ $::APPL_Config(root_InitDOM) selectNodes /root/Template/MTB ]
    set ::APPL_Config(TemplateMTB_default)   [file join $::APPL_Config(CONFIG_Dir) [$node asText] ]
    
    
        # --- get Template - Type to load
        #
    set node    [ $::APPL_Config(root_InitDOM) selectNodes /root/Startup/TemplateFile ]
    set ::APPL_Config(TemplateType) [$node asText]


        # --- get FrameJig - Type to load
        #
    set node    [ $::APPL_Config(root_InitDOM) selectNodes /root/Startup/FrameJigType ]
    set ::APPL_Config(FrameJigType) [$node asText]

    
        # --- set GUI - Options
        #
    set node    [ $::APPL_Config(root_InitDOM) selectNodes /root/Options/FrameJigType ]
    myGUI::control::setListBoxContent   FrameJigType    $node
        #


        # -- initialize OS --------------------
        #
    init_OS_Settings  


        # -- rattleCAD Config  ----------------
        #
    read_userXdefaults
    read_userInit

    foreach configKey [array names GUIConfig] {
        switch -exact -- $configKey {
            antialias {
                set value [lindex [array get GUIConfig $configKey] 1]
                if {$value eq {on}} {
                    set cad4tcl::canvasType   1
                } else {
                    set cad4tcl::canvasType   0
                }
            }
        }
    }
    
        # -- GUI - Style  ---------------------
        #
    ttk::style configure TCombobox -padding 0
        
        
        # -- set standard font ----------------
        #
    if 0 {
        switch $::tcl_platform(platform) {
                "macintosh" { set ::APPL_Config(GUI_Font)  {Helvetica 10} }
                "_windows"  { set ::APPL_Config(GUI_Font)  $::APPL_Config(GUI_Font) }
        }
        #  option add *font $::APPL_Config(GUI_Font)
    }

    
        # --- fill ICON - Array
        #
    foreach child [[$::APPL_Config(root_InitDOM) selectNodes /root/lib_gui/images] childNodes] {            
            # puts [ $child asXML ]
        if {[$child nodeType] == {ELEMENT_NODE}} {    
            set name      [ $child getAttribute {name} ]
            set source    [ $child getAttribute {src} ]
                # puts "   $name  $source"
            set myGUI::gui::iconArray($name) [image create photo ::myGUI::image::$name -file $::APPL_Config(IMAGE_Dir)/$source ]
        }
    }
    # set ::cfg_panel [image create photo ::myGUI::image::cfg_panel -file $::APPL_Config(IMAGE_Dir)/cfg_panel.gif]


        # --- fill CANVAS - Array
        #
    set node    [$::APPL_Config(root_InitDOM) selectNodes /root/lib_gui/geometry/canvas]
    set myGUI::gui::canvasGeometry(width)   [$node getAttribute {width}]
    set myGUI::gui::canvasGeometry(height)  [$node getAttribute {height}]              
    
    
        # -- rattleCAD Template  --------------
        #
    set ::APPL_Config(TemplateInit)     [myPersist::file::getTemplateFile   $::APPL_Config(TemplateType)]
        # puts "   \$::APPL_Config(TemplateType) $::APPL_Config(TemplateType)"
        # puts "   \$::APPL_Config(TemplateInit) $::APPL_Config(TemplateInit)"                    
    
        
        #
        #
    myGUI::control::setSession  rattleCADVersion  "$strinfo(ProductVersion).$strinfo(FileVersion)"
        
}


    #-------------------------------------------------------------------------
    #  init Project (control and model)
    #     
proc myGUI::open_StartupProject {startupProject} {
        #
      
    puts "\n\n ======  S T A R T U P  -  P R O J E C T  ========\n\n"
        #
        
    if {$startupProject != {}} {
          # set startupProject  [lindex $argv 0]
        puts "\n"
        puts " ====== startup   F I L E ========================"
        puts "        ... [file normalize $startupProject]\n"
            #
        myPersist::file::openProject_xml $startupProject    [file tail $startupProject]
            #
    }
        
        
        # --- init ListBox Values  
        #

        
    # --- check this for bikeComponent implementation
    
        # --- register Component Directories
        #

        # --- set ::APPL_Config(COMPONENT_Dir)  
        #
    #myGUI::control::set_ComponentDir
        # puts "   \$::APPL_Config(COMPONENT_Dir) $::APPL_Config(COMPONENT_Dir)"
        
        # --- fill APPL_CompLocation
        #
    # myGUI::control::set_CompLocation
        #
        
}


    #-------------------------------------------------------------------------
    #  build GUI
    #     
proc myGUI::init_GUI {} {
        
                  
    puts "\n\n ====== G U I ============================== \n\n"
    
    
        # --- update global variable  -----
        #
    set ::APPL_Config(COMPONENT_Dir)  [myGUI::control::get_ComponentDirectory]
        #
    array unset ::APPL_CompLocation 
    foreach node [myGUI::modelAdapter::get_ComponentSubDirectories] {
        set key     [lindex $node 0]
        set dir     [lindex $node 1]
        # puts "  childNode ->   $node   $key  $dir "
        set ::APPL_CompLocation($key) $dir
    }    

        
        # --- init gui report  -----
        #
    myGUI::init_GUI_Report
            
        
        # --- create iconBitmap  -----
        # puts " \$tcl_platform(os)  $tcl_platform(os) $tcl_platform(platform)"
        #
    set w .
    switch -exact $::tcl_platform(platform) {
        windows {
                wm iconbitmap $w [file join $::APPL_Config(BASE_Dir) tclkit.ico]
            }
        MacOS -
        Darwin {
                wm iconbitmap $w [file join $::APPL_Config(BASE_Dir) icon16.gif] 
            }
        default {
                wm iconphoto  $w [image create photo .ico1 -format gif -file [file join $::APPL_Config(BASE_Dir)  icon16.gif] ]
            }
    }

    
        # --- create intro  -----
        #
    myGUI::create_intro  .intro  
      
      
        # --- create Mainframe  -----
        #
    set   ::APPL_Config(MainFrame)  [myGUI::gui::create_MainFrame]
        pack $::APPL_Config(MainFrame)  -fill both  -expand yes  -side top 
        
        
        # --- create Indicator  -----
        #
    $::APPL_Config(MainFrame) addindicator -textvariable "::APPL_Config(MainFrameInd_Project)"  -anchor e  -width 90
    $::APPL_Config(MainFrame) addindicator -textvariable "::APPL_Config(MainFrameInd_Status)"   -anchor e  -width 20
        [$::APPL_Config(MainFrame) getindicator 0]  configure -relief flat
        [$::APPL_Config(MainFrame) getindicator 1]  configure -relief flat
            # $::APPL_Config(MainFrame) addindicator -text "undoStack:"     -anchor e  -width 12
            # [$::APPL_Config(MainFrame) getindicator 2]  configure -relief flat


        # --- get MainFrame  --------
        #
    set    frame      [$::APPL_Config(MainFrame) getframe]


        # --- Button-bar frame  -----
        #
    set bb_frame [ frame $frame.f1  -relief sunken        -bd 1  ]
        pack  $bb_frame  -padx 0  -pady 3  -expand no   -fill x
    myGUI::gui::create_ButtonBar $bb_frame 

        
        # ---     handle existance rattleCAD Plugin
        #
    ::myGUI::plugIn::init $myGUI::gui::pluginFrame
    ::myGUI::plugIn::loadPlugins

    
        # --- notebook frame  -------
        #
    set nb_frame [ frame $frame.f2  -relief sunken        -bd 1  ]
        pack  $nb_frame  -padx 0  -pady 0  -expand yes  -fill both
        
        
        # --- notebook  -------------
        #
    myGUI::gui::create_Notebook $nb_frame

        
        # --- noteBook_top - widget -
        #
    set  myGUI::view::edit::noteBook_top $myGUI::gui::noteBook_top
        #
        
        # --- set minimum size ------
    update 
    wm minsize . [winfo width  .]   [winfo height  .]
        #
        
    myGUI::set_Bindings          
        # myGUI::view::edit::init
        # myGUI::view::edit::createGUI

      
        # --- finalize GUI ----------------------------
        #
        # wm minsize . [expr 100 + [winfo width  .]]   [expr 50 + [winfo height  .]]
        # -- destroy intro - image ----
        # after  50 destroy .intro
    destroy .intro            
    
        # -- keep on top --------------
    wm deiconify .
        
 }


    #-------------------------------------------------------------------------
    #  build GUI
    #     
proc myGUI::set_Bindings {} {
       
        # -- update currentView -----------------------
    myGUI::gui::bind_windowSize init
        
        # -- window binding -----------------------
    bind . <Configure> [list myGUI::gui::bind_windowSize]
        
        # -- keyboard bindings -----------------------
    myGUI::gui::bind_keyBoard_global ab
    
        # -- window delete binding -----------------------
    wm protocol . WM_DELETE_WINDOW {
        myGUI::control::exit_rattleCAD yesnocancel
    }
    
        # -- GUI - Bindings  ------------------
    myGUI::gui::binding_copyClass      Spinbox mySpinbox
    myGUI::gui::binding_removeOnly     mySpinbox [list <Clear>]        
    
}


    #-------------------------------------------------------------------------
    #  initialze rattleCAD
    #
proc myGUI::init_GUI_Report {} {

        #
    #variable projectDOM     
        #

    ###########################################################################      
    #
    #                 B  -  A  -  S  -  E 
    #
    ###########################################################################
    
    
        # -- Version Info   ----------------------        
    # init_APPL_Config $baseDir  

      
      
        # -- Version Info Summary  ---------------
    puts "  ----------------------------------------------"
    puts "  rattleCAD      $::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"
    puts "                             $::APPL_Config(RELEASE_Date)"
    puts "  ----------------------------------------------"
  
  
    # -- Tcl/Tk Runtime  --------------------
    puts "  Tcl/Tk:    [info patchlevel]"
    puts "  Exec:      [info nameofexecutable]"
    puts "  ----------------------------------------------"
    puts "    Tk:            [package require Tk]"
    puts "    BWidget:       [package require BWidget]"
    puts "    tdom:          [package require tdom]"
    puts "    snit:          [package require snit]"
    puts "    pdf4tcl:       [package require pdf4tcl]"
    puts "    bikeGeometry:  [package require bikeGeometry]"
    puts "    cad4tcl:       [package require cad4tcl]"
    puts "    myGUI:         [package require myGUI]"
    puts "    myPersist:     [package require myPersist]"
    puts "    vectorMath:    [package require vectormath]"
    puts "    osEnv:         [package require osEnv]"
    puts "    appUtil:       [package require appUtil]"
    puts "    myTool:        [package require myTool]"
    puts "    extSummary:    [package require extSummary]"
    catch  {
        puts "    registry:      [package require registry 1.1]"
    }
    
    puts "  ----------------------------------------------"
    puts "    APPL_Config(ROOT_Dir)         $::APPL_Config(ROOT_Dir)"
    puts "    APPL_Config(BASE_Dir)         $::APPL_Config(BASE_Dir)"
    puts "    APPL_Config(CONFIG_Dir)       $::APPL_Config(CONFIG_Dir)"
    puts "    APPL_Config(IMAGE_Dir)        $::APPL_Config(IMAGE_Dir)"
    puts "    APPL_Config(USER_Dir)         $::APPL_Config(USER_Dir)"
    puts "    APPL_Config(TOOL_Dir)         $::APPL_Config(TOOL_Dir)"
    puts "    APPL_Config(EXPORT_Dir)       $::APPL_Config(EXPORT_Dir)"
    puts "    APPL_Config(COMPONENT_Dir)    $::APPL_Config(COMPONENT_Dir)"
    puts "    APPL_Config(CUSTOM_Dir)       $::APPL_Config(CUSTOM_Dir)"
    puts "    APPL_Config(EXPORT_HTML)      $::APPL_Config(EXPORT_HTML)"
    puts "    APPL_Config(EXPORT_PDF)       $::APPL_Config(EXPORT_PDF)"
    
    puts "  ----------------------------------------------"
    puts ""
    
    # puts "    rattleCAD:     [package require rattleCAD]"
    

        # -- initialize GUI ----------
    # puts "     ... GUI_Font"
    # puts "         ... $::APPL_Config(GUI_Font)\n"
        #

        
        # --- puts "\n     APPL_CompLocation"
    foreach index [array names APPL_CompLocation] {
        puts [format "        -> %-42s %s" $index    $APPL_CompLocation($index)]
    } 

}


    #-------------------------------------------------------------------------
    # init OS Settings
    #  
proc myGUI::init_OS_Settings {} {
    
        osEnv::init_osEnv
        
        switch -glob $::tcl_platform(platform) {
            windows {
                    foreach mimeType {.pdf .html .svg .dxf .jpg .gif} {
                        set defaultApp {}
                        set defaultApp [osEnv::find_mimeType_Application $mimeType]
                        puts "         ... $mimeType -> $defaultApp"
                        if {$defaultApp != {}} {
                            osEnv::register_mimeType $mimeType $defaultApp
                        }
                    }    
                }
            unix {
                    foreach {mimeType appName} {.html firefox .svg firefox .pdf evince .txt nedit} {
                        puts "         ... $mimeType -> $appName "
                        set defaultApp {}
                        set defaultApp [osEnv::find_OS_Application $appName]
                        puts "         ... $defaultApp"
                        puts "         ... $mimeType -> $appName -> $defaultApp"
                        if {$defaultApp != {}} {
                            osEnv::register_mimeType $mimeType $defaultApp
                        }
                    }
                    foreach appName {sh gs} {
                        set defaultApp {}
                        set defaultApp [osEnv::find_OS_Application $appName]
                        puts "         ... $appName -> $defaultApp"
                        if {$defaultApp != {}} {
                            osEnv::register_Executable $appName $defaultApp
                        }
                    }

                }
            default {}
        }

}


    #-------------------------------------------------------------------------
    # check user settings in $::APPL_Config(USER_Dir)/_rattleCAD_[info hostname].init
    #            
proc myGUI::read_userXdefaults {} {
        #
    set hostName    [info hostname]
    set fileName    [format ".rattleCAD_%s.Xdefaults" $hostName ]
    set fileName    [file join $::APPL_Config(USER_Dir) $fileName ]
    puts ""
    puts "   ... read_userXdefaults"
    puts "         ... .Xdefaults        $fileName"
    puts ""
    
    if {[file exists $fileName ]} {
        if { [catch {option readfile $fileName userDefault} fid] } {
            puts stderr "         ... <E> ... could not open .Xdefaults $fileName\n             ... $fid"
            # exit 1
        }
    } else {
          set   timeString    [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
            #
          set    fp [open $fileName w]
          puts  $fp "! ... created by  rattleCAD ($::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision))"
          puts  $fp "!     ... on  $timeString"
          puts  $fp {!}
          puts  $fp {!*Menu.foreground: black}
          puts  $fp {!}
          puts  $fp {!*Menu.background: lemonChiffon2}
          puts  $fp {!*Menu.foreground: red}
          puts  $fp {!}
          puts  $fp {!}
          puts  $fp {! --- any untested examples: -----------------}
          puts  $fp {!       ... see: http://computer-programming-forum.com/57-tcl/714fcdf48fb18c6c.htm}
          puts  $fp {!}
          puts  $fp {! ----- try some attributes ------------------}
          puts  $fp {!*padX: 10}
          puts  $fp {!*padY: 10}
          puts  $fp {!*sliderLength: 20}
          puts  $fp {!*yScrollSide: left}
          puts  $fp {!*Scale.width: 8}
          puts  $fp {!*Scrollbar.width: 10}
          puts  $fp {!*tearOff: 0}
          puts  $fp {!*activeBorderWidth: 1}
          puts  $fp {! ----- font settings ------------------------}
          puts  $fp {!*font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {!*Text.font: *-cour*-medium-r-*-100-*-iso8859-1}
          puts  $fp {!*Radiobutton.font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {!*Message.font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {!*Listbox.font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {!*Label.font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {!*Entry.font: *-cour*-medium-r-*-100-*-iso8859-1}
          puts  $fp {!*Checkbutton.font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {!*Button.font: *-helv*-bold-r-*-120-*-iso8859-1}
          puts  $fp {! ----- menubar setups -----------------------}
          puts  $fp {!*Menubar.relief: raised}
          puts  $fp {!*Menubar.borderWidth: 2}
          puts  $fp {!*Menubar.Menubutton.padX: 8}
          puts  $fp {!*Menubar*font: *-helv*-bold-o-*-120-*-iso8859-1}
          puts  $fp {!}              
          puts  $fp {}
          close $fp
          puts ""
          puts "     ... .Xdefaults        $fileName"
          puts "         ------------------------"
          puts "           ... write new:"   
          puts "                           $fileName"
          puts "                   ... done"
          
          read_userXdefaults
    }
}

   
    #-------------------------------------------------------------------------
    # check user settings in $::APPL_Config(USER_Dir)/_rattleCAD_[info hostname].init
    #            
proc myGUI::read_userInit {} {
        #
    variable GUIConfig    
        #
    set hostName    [info hostname]
    set fileName    [format ".rattleCAD_%s.init" $hostName ]
    set fileName    [file join $::APPL_Config(USER_Dir) $fileName ]
    puts ""
    puts "   ... read_userInit"
    puts "         ... user_InitDOM      $fileName"
    puts "        ->\$::APPL_Config(TemplateType) $::APPL_Config(TemplateType)"
    puts "        ->\$::APPL_Config(FrameJigType) $::APPL_Config(FrameJigType)"
        # puts "        ->\$::APPL_Config(GUI_Font)     $::APPL_Config(GUI_Font)"
        # puts "        ->\$::APPL_Config(FrameMethod)  $::APPL_Config(FrameMethod)"
    puts ""
    
    if {[file exists $fileName ]} {
            set ::APPL_Config(user_InitDOM)  [myPersist::file::get_XMLContent $fileName]
                # puts "     ... user_InitDOM      $fileName"
                # puts "[$::APPL_Config(user_InitDOM) asXML]"
            catch {set ::APPL_Config(TemplateType) [[$::APPL_Config(user_InitDOM) selectNodes /root/TemplateFile/text()] asXML]}
            catch {set ::APPL_Config(FrameJigType) [[$::APPL_Config(user_InitDOM) selectNodes /root/FrameJigType/text()] asXML]}
                # catch {set ::APPL_Config(GUI_Font)     [[$::APPL_Config(user_InitDOM) selectNodes /root/GUI_Font/text()]     asXML]}
            
                # catch {set ::APPL_Config(FrameMethod)  [[$::APPL_Config(user_InitDOM) selectNodes /root/FrameMethod/text()] asXML]}
            
            
            if {$::APPL_Config(user_InitDOM) != {}} {
                puts "        ----------------------------"
                prettyPrint_XML $::APPL_Config(user_InitDOM)
                puts "        ----------------------------"
            }
            puts "          ->\$::APPL_Config(TemplateType) $::APPL_Config(TemplateType)"
            puts "          ->\$::APPL_Config(FrameJigType) $::APPL_Config(FrameJigType)"
            puts "        ----------------------------"
            
            puts ""
            puts "          config:"
            puts "        ----------------------------"
            set applConfig [$::APPL_Config(user_InitDOM) selectNodes /root/config]
            if {$applConfig != {}} {
                foreach node   [$applConfig childNodes] {
                    if {[$node nodeType] == {ELEMENT_NODE}} {    
                        # puts "         [$node asXML]"
                        set key    [$node getAttribute name]
                        set value  [[$node firstChild] nodeValue]
                        puts "          -> $key  $value"
                        set GUIConfig($key) $value
                    }
                }
            }
            
            puts ""
            puts "          mime Types:"
            puts "        ----------------------------"
            set mimeConfig [$::APPL_Config(user_InitDOM) selectNodes /root/mime]
            if {$mimeConfig != {}} {
                foreach node   [$mimeConfig childNodes] {
                    if {[$node nodeType] == {ELEMENT_NODE}} {    
                        # puts "         [$node asXML]"
                        set key    [$node getAttribute name]
                        set value  [[$node firstChild] nodeValue]
                        puts "          -> $key  $value"
                        osEnv::register_mimeType $key $value
                    }
                }
            }
            
            puts ""
            puts "          executables:"
            puts "        ----------------------------"
            set execConfig [$::APPL_Config(user_InitDOM) selectNodes /root/exec]
            if {$execConfig != {}} {
                foreach node [$execConfig childNodes] {
                    if {[$node nodeType] == {ELEMENT_NODE}} { 
                        # puts "         [$node asXML]"
                        set key    [$node getAttribute name]
                        set value  [[$node firstChild] nodeValue]
                        puts "          -> $key  $value"
                        osEnv::register_Executable $key $value
                    }
                } 
            }
          
    } else {
            set   timeString    [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
                #          
            set    fp [open $fileName w]
            puts  $fp {<?xml version="1.0" encoding="UTF-8" ?>}
            puts  $fp {<root>}
            puts  $fp "    <hostname>$hostName</hostname>"
            puts  $fp "    <fileName>$fileName</fileName>"
            puts  $fp "    <fileCreated>$timeString</fileCreated>"
            # puts  $fp "    <GUI_Font>$::APPL_Config(GUI_Font)</GUI_Font>"
            puts  $fp "    <config>"
            puts  $fp "        <config name=\"_test\">_any_Value</config>"
            puts  $fp "        <config name=\"antialias\">on</config>"
            puts  $fp "    </config>"
            puts  $fp "    <mime>"
            puts  $fp "        <mime name=\"_test\">_any_Value</mime>"
            puts  $fp "    </mime>"
            puts  $fp "    <exec>"
            puts  $fp "        <exec name=\"_test\">_any_Value</exec>"
            puts  $fp "    </exec>"
            puts  $fp {</root>}
            close $fp
            puts ""
            puts "     ... user_InitDOM      $fileName"
            puts "         ------------------------"
            puts "           ... write new:"   
            puts "                           $fileName"
            puts "                   ... done"
            
            read_userInit
    }
}


    #-------------------------------------------------------------------------
   #  startup intro image
   #
proc myGUI::create_intro {w {type toplevel} {cv_border 0} } {

        #
    puts "\n"
    puts "  create_intro: \$::APPL_Config(IMAGE_Dir)  $::APPL_Config(IMAGE_Dir)"
        #
        
        #
    catch {destroy .intro}
        #
        
    if { $type != "toplevel" } {        
        return [intro_content $w $cv_border]
    }
    
    toplevel $w  -bd 0

    wm withdraw           $w  
    wm overrideredirect $w 1
    
    switch $::tcl_platform(platform) {
        "windows" { wm attributes  $w -topmost 1 }
    }

    intro_content $w $cv_border
    
    BWidget::place $w 0 0 center
    wm deiconify $w
    
    bind $w  <ButtonPress> { destroy .intro }

    return
}


proc myGUI::intro_content {w cv_border} {

    set start_image     [image create  photo  ::myGUI::image::start_image -file $::APPL_Config(IMAGE_Dir)/start_image.gif ]
    set  start_image_w  [image width   $start_image]
    set  start_image_h  [image height  $start_image]

    puts "      create_intro: \$start_image:  $start_image  -> $start_image_w  $start_image_h \n"

    canvas $w.cv    -width  $start_image_w \
                    -height $start_image_h \
                    -bd     0 \
                    -bg     gray 
                 
    pack   $w.cv   -fill both  -expand yes -padx $cv_border -pady $cv_border 

    $w.cv create image  [expr 0.5*$start_image_w] \
                        [expr 0.5*$start_image_h] \
                     -image $start_image
    
    set x [expr 0.5*$start_image_w]
    set y [expr 0.5*$start_image_h]

     # $w.cv create text  [expr $x+ 65]  [expr $y+155]  -font "Swiss 18"  -text "Version"                  -fill white
     # $w.cv create text  [expr $x+155]  [expr $y+155]  -font "Swiss 18"  -text "$APPL_Config(RELEASE_Version)"  -fill white 
     # $w.cv create text  [expr $x+210]  [expr $y+156]  -font "Swiss 14"  -text "$APPL_Config(RELEASE_Revision)"  -fill white 
    $w.cv create text  [expr $x+155]  [expr $y+150]  -font "Swiss 12"  -text "Version: $::APPL_Config(RELEASE_Version) - $::APPL_Config(RELEASE_Revision)"  -fill white -justify left
    #$w.cv create text  [expr $x+150]  [expr $y+156]  -font "Swiss 14"  -text "$APPL_Config(RELEASE_Version) - $APPL_Config(RELEASE_Revision)"  -fill white 

        ;# --- beautify --- but i dont know the reason, why to center manually
    $w.cv move   all   1 1            
    return $w.cv
}



   #-------------------------------------------------------------------------
   #  check BASE_Dir
   #
proc myGUI::check_BASE_Dir {BASE_Dir USER_Dir} {
    if {$BASE_Dir eq $USER_Dir} {
        set     message "Dear User!\n"
        append  message "\n  ...  since rattleCAD Version 3.2.78.03"
        append  message "\n        there is a new definition of the user-Directory."
        append  message "\n"
        append  message "\n  ... your new user-Directory is defined as:"
        append  message "\n        $USER_Dir"
        append  message "\n"
        append  message "\n  ... please install rattleCAD in an other Directory"
        append  message "\n"
        append  message "\n    e.g.:\n"
        append  message "\n         \[Windows\] C:\\Program Files\\rattleCAD\\"
        append  message "\n                                     .\\3.4.00.60"
        append  message "\n                                     .\\rattleCAD.tcl"
        append  message "\n"
        append  message "\n         \[Linux\]   /opt/rattleCAD/"
        append  message "\n                                     ./3.4.00.60"
        append  message "\n                                     ./rattleCAD.tcl"
        append  message "\n"
        append  message "\n                            your rattleCAD!"

        tk_messageBox -icon info -message $message
        exit
    }           
}  

   #-------------------------------------------------------------------------
   #  check USER_Dir
   #
proc myGUI::migrate_USER_Dir {} {
        #
    puts "\n"
    puts "================================================="
    puts "    migrate ::APPL_Config(USER_Dir)"
    puts "-------------------------------------------------"
        #
    set newDir  $::APPL_Config(USER_Dir)
        #
    set homeDir [myPersist::file::get_userhome]
    set oldDir  [file join $homeDir rattleCAD]
    puts "       $oldDir"
    puts "           ->  $newDir"
        #
        #
    set hostName    [info hostname]
    set fileName    [format ".rattleCAD_%s.init" $hostName ]
        
        #
    if [file exists [file join $oldDir $fileName]] {
        puts "       ... $oldDir ... exists"
        if ![file exists [file join $newDir $fileName]] {
                #
            puts "       ... $newDir ... empty"
                #
            foreach contentFile [glob [file join $oldDir *]] {
                puts "           -> \$contentFile $contentFile"
                catch {file rename $contentFile $newDir}
            }
                #
            catch {file rename $oldDir [file join $newDir _rattleCAD_remove]}   
                #
            puts "       ... migrated"
                #
        } else {
                #
            puts "       ... $newDir ... not empty"
                #
        }
    } else {
        puts "           -> nothing to migrate\n"
    }
        #
    puts "-------------------------------------------------"
    puts "\n"
        #
    return
        #
}  





    #-------------------------------------------------------------------------
   #   http://computer-programming-forum.com/57-tcl/aea710a848418614.htm
   #
proc prettyPrint_XML {dom} {
    set s ""
    set str [$dom asXML]
    set sep \n
    foreach chunk [split $str $sep] {
    if {[string length $s]>0} {
        append s "$sep$chunk"
    } else {
        set s $chunk
    }
    if {[info complete $s]} {
        if {$s == {}} continue
        puts "          $s"
        set s ""
    }
    }
}   
