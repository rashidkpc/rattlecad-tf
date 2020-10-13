 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_infoPanel.tcl
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
 #  namespace:  myGUI::infoPanel
 # ---------------------------------------------------------------------------
 #
 # 
 namespace eval myGUI::infoPanel {
 
 }
   
  #-------------------------------------------------------------------------
      #  create_config_design
       
    proc myGUI::infoPanel::create { w {tab 0}} {
        
        global APPL_Config

        if {[winfo exists $w]} {
            wm deiconify  $w
            $w.nb    raise [ $w.nb page $tab ]
            return
        }
        
        set widget_font {-*-Courier-Medium-R-Normal--*-120-*-*-*-*-*-*}

        toplevel       $w
        wm  title      $w  "Info Panel:    rattleCAD  $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)"
          ;# wm  transient  $w  .
 
        set   INFO_Notebook     [NoteBook    $w.nb]
        pack $INFO_Notebook     -expand true -fill both 
        
        bind .  <Escape> [list destroy $w]
        bind $w <Escape> [list destroy $w]
        

        ;# =======================================================================
          ;# -- version_intro -----------
          ;#
        set version_intro      [ $INFO_Notebook insert end intro \
                                           -text      "Intro" ]
                                           
             ;# -- intro image ----------
        set version_intro_content [myGUI::create_intro  $version_intro  content  60]
        $version_intro         configure  -borderwidth 2 
        
        set text_help          [ create_tab $INFO_Notebook 01 "Help"        $widget_font ]
        set text_license       [ create_tab $INFO_Notebook 02 "License"     $widget_font ]
        set text_reference     [ create_tab $INFO_Notebook 03 "Reference"   $widget_font ]
        set text_changelog     [ create_tab $INFO_Notebook 04 "ChangeLog"   $widget_font ]
        set text_runtime       [ create_tab $INFO_Notebook 05 "Runtime"     $widget_font ]
        set text_osenv         [ create_tab $INFO_Notebook 06 "osEnv"       $widget_font ]
        set text_appUtil       [ create_tab $INFO_Notebook 07 "appUtil"     $widget_font ]
        set text_project       [ create_tab $INFO_Notebook 08 "Project"     $widget_font ]
        
        fill_help               $text_help
        fill_license            $text_license
        fill_reference          $text_reference
        fill_changelog          $text_changelog
        fill_runtime            $text_runtime
        fill_osenv              $text_osenv
        fill_appUtil            $text_appUtil
        fill_project            $text_project

        # update
        
        $INFO_Notebook          compute_size
        $INFO_Notebook          raise [ $INFO_Notebook page $tab ]
        
        return $INFO_Notebook
    }

    proc myGUI::infoPanel::create_tab {nb  index labelText font} {
    
        set _tab          [ $nb insert end $index \
                                           -text      "$labelText" ]
        $_tab             configure  -borderwidth 2
        
             ;# -- text -----------------
        pack [set sw_tab  [ ScrolledWindow $_tab.sw] ] -fill both  -expand 1 

        set _text         [ text $sw_tab.text \
                                    -width       40 \
                                    -height      10 \
                                    -relief      sunken \
                                    -wrap        none \
                                    -background  white \
                                    -font        $font
                               ]
      
             ;# --- !!! IMPORTANT !!! DO NOT pack a ScrolledWindow child!!!     
        $sw_tab setwidget $_text
        
        return $_text
    }

    proc myGUI::infoPanel::fill_help {w} {    

        global APPL_Config

        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    Help\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
        
        set fd [open [file join $::APPL_Config(BASE_Dir) help.txt] r]
        fconfigure $fd -encoding utf-8
        while {![eof $fd]} {
             set line [gets $fd]
             $w    insert end "    $line\n"
        }
        close $fd

        $w    insert end "\n\n"
    }

    proc myGUI::infoPanel::fill_license {w} { 
        
        global APPL_Config
        
        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    License\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
        
        set fd [open [file join $::APPL_Config(BASE_Dir) license.terms] r]
        fconfigure $fd -encoding utf-8
        while {![eof $fd]} {
             set line [gets $fd]
             $w    insert end "    $line\n"
        }
        close $fd

        $w     insert end "\n\n"
    }

    proc myGUI::infoPanel::fill_reference {w} {    

        global APPL_Config

        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    Library Reference\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
        
        set fd [open [file join $::APPL_Config(BASE_Dir) reference.txt] r]
        fconfigure $fd -encoding utf-8
        while {![eof $fd]} {
             set line [gets $fd]
             $w    insert end "    $line\n"
        }
        close $fd

        $w    insert end "\n\n"
    }

    proc myGUI::infoPanel::fill_changelog {w} { 
        
        global APPL_Config
        
        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    Changelog\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
                
        set fd [open [file join $::APPL_Config(BASE_Dir) readme.txt] r]
        fconfigure $fd -encoding utf-8
        while {![eof $fd]} {
             set line [gets $fd]
             $w    insert end "    $line\n"
        }
        close $fd

        $w    insert end "\n\n"
    }    

    proc myGUI::infoPanel::fill_runtime {w} {    

        global APPL_Config
        
        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    Application-Runtime\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
        $w  insert end "   Runtime:          ... [file tail $::argv0]\n"
        $w  insert end "  ----------------------------------------------------\n"
        $w  insert end "     Tcl/Tk:         [info patchlevel]\n"
        $w  insert end "     Exec:             [info nameofexecutable]\n"
        $w  insert end "\n"
        $w  insert end "       Tk:             [package require Tk]\n"
        $w  insert end "       BWidget:        [package require BWidget]\n"
        $w  insert end "       tdom:           [package require tdom]\n"
        $w  insert end "       snit:           [package require snit]\n"
        $w  insert end "       pdf4tcl:        [package require pdf4tcl]\n"
        # $w  insert end "     rattleCAD:      [package require rattleCAD]\n"
        $w  insert end "       bikeGeometry:   [package require bikeGeometry]\n"
        $w  insert end "       bikeModel:      [package require bikeModel]\n"
        $w  insert end "       cad4tcl:        [package require cad4tcl]\n"
        $w  insert end "       vectormath:     [package require vectormath]\n"  
        $w  insert end "       extSummary:     [package require extSummary]\n"  
        $w  insert end "       osEnv:          [package require osEnv]\n"  
        $w  insert end "       appUtil:        [package require appUtil]\n"
        if { $::tcl_platform(platform) == "windows" } {
        $w  insert end "       registry:       [package require registry 1.1]\n"
        }
            #
        if 0 {
            $w  insert end "\n"
            foreach packageDef [info loaded] {
                foreach {library package} $packageDef {
                    $w  insert end "[format {       %-12s %s }  $package [file normalize ${library}]]\n"
                }
            }
        }
            #
        $w  insert end "\n\n"
        $w  insert end "   Version:\n"
        $w  insert end "  ----------------------------------------------------\n"
        $w  insert end "     Version:        $APPL_Config(RELEASE_Version)\n"
        $w  insert end "     Revision:       $APPL_Config(RELEASE_Revision)\n"
        $w  insert end "     Release Date:   $APPL_Config(RELEASE_Date)\n"
        $w  insert end "\n\n"
        $w  insert end "   Environment:\n"
        $w  insert end "  ----------------------------------------------------\n"
        $w  insert end "\n"
        $w  insert end "     APPL_Config(ROOT_Dir):     \n                   ... $APPL_Config(ROOT_Dir)\n"
        $w  insert end "     APPL_Config(BASE_Dir):     \n                   ... $APPL_Config(BASE_Dir)\n"
        $w  insert end "     APPL_Config(PLUGIN_Dir):   \n                   ... $APPL_Config(PLUGIN_Dir)\n"   
        $w  insert end "     APPL_Config(CONFIG_Dir):   \n                   ... $APPL_Config(CONFIG_Dir)\n"
        $w  insert end "     APPL_Config(IMAGE_Dir):    \n                   ... $APPL_Config(IMAGE_Dir)\n"
        $w  insert end "     APPL_Config(COMPONENT_Dir):\n                   ... $APPL_Config(COMPONENT_Dir)\n"   
        $w  insert end "     APPL_Config(CUSTOM_Dir):   \n                   ... $APPL_Config(CUSTOM_Dir)\n"   
        $w  insert end "     APPL_Config(SAMPLE_Dir):   \n                   ... $APPL_Config(SAMPLE_Dir)\n"
        $w  insert end "     APPL_Config(TEST_Dir):     \n                   ... $APPL_Config(TEST_Dir)\n"   
        $w  insert end "     APPL_Config(USER_Dir):     \n                   ... $APPL_Config(USER_Dir)\n"
        $w  insert end "     APPL_Config(TEMPLATE_Dir): \n                   ... $APPL_Config(TEMPLATE_Dir)\n"
        $w  insert end "\n"
        # $w  insert end "     APPL_Config(USER_Init):     $APPL_Config(USER_Init)\n"
        $w  insert end "\n\n"
        $w  insert end "   Packages:\n"
        $w  insert end "  ----------------------------------------------------\n"
        $w  insert end "\n"
        $w  insert end "     \$::vectorfont::font_dir\n                   ... $::vectorfont::font_dir  "
        $w  insert end "\n\n\n\n"
        $w  insert end "   APPL_Config:\n"
        $w  insert end "  ----------------------------------------------------\n"
        $w  insert end "\n"
        foreach name [lsort [array names ::APPL_Config]] {
            switch -glob $name {
                list_*  continue
                default {}
            }
        $w  insert end [format "     %-35s\n" APPL_Config($name): ]
        $w  insert end [format "     %-15s ... %s\n" {} $::APPL_Config($name)]
        }
        $w  insert end "\n"
        foreach name [lsort [array names ::APPL_Config]] {
            switch -glob $name {
                list_*  {}
                default continue
            }
            $w  insert end [format "     %-35s\n" APPL_Config($name):]
            foreach value $::APPL_Config($name) {  
                $w  insert end [format "     %-20s %s\n" "" $value]
            }  
        }
        $w  insert end "\n\n\n"
        $w  insert end "   others:\n"
        $w  insert end "  ----------------------------------------------------\n"
        $w  insert end "\n"
        $w  insert end "     \$::argv0:        \n                   ... $::argv0\n"     
    }    

    proc myGUI::infoPanel::fill_osenv {w} {    

        global APPL_Config

        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    OS-Environment\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
        $w  insert end "[$osEnv::registryDOM asXML] \n"
        $w  insert end "\n\n"
    }

    proc myGUI::infoPanel::fill_appUtil {w} {    

        global APPL_Config

        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    appUtil - Report\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
        
        if {[catch {set namespaceReport [appUtil::namespaceReport :: asXML]} eID]} {
            $w  insert end "\n ... namespaceReport failed \n"
            $w  insert end "§eID"
        } else {
            $w  insert end "\n ... namespaceReport OK \n"
            $w  insert end "\n   ... content asXML \n\n\n"
            $w  insert end $namespaceReport
        }
        $w  insert end "\n\n"
    }

    proc myGUI::infoPanel::fill_project {w} {    

        global APPL_Config

        $w  insert end "\n\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "   rattleCAD       $APPL_Config(RELEASE_Version).$APPL_Config(RELEASE_Revision)     --    Project\n"
        $w  insert end "  ===================================================================\n"
        $w  insert end "\n\n"
            # parray myGUI::model::model_Info::Dictionary
            # $w    insert end "[myGUI::model::model_Info::getDictionary modelDICT] \n"
        appUtil::pdict2text $w [myGUI::model::model_Info::getDictionary modelDICT] 2 "  "
        $w    insert end "\n\n"
    }



     #-------------------------------------------------------------------------
     #
     #  end  namespace eval infoPanel 
     #


  
