 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_plugIn.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2017/02/18
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
 #    namespace:  myGUI::plugIn
 # ---------------------------------------------------------------------------
 #
 # 

    namespace eval myGUI::plugIn {
            #
        variable packageHomeDir     [file normalize [file join [pwd] [file dirname [file dirname [info script]]]] ]
        variable packageImageDir    [file join $packageHomeDir image]
        variable pluginDir          {}
        variable buttonID           0
        variable buttonFrame        {}
            #
        variable cfg_Position   {}
            #
        variable fileName
        variable sourceText
        variable targetText     
            #
        variable targetContent  {}
            #
        variable exportFileName
        variable exportDir
        
        variable exportFileExtension {scad}    
        variable rattleCAD_DOM
        
        variable importDir
        
        variable FrontHubWidth   100.00
        variable RearHubWidth    200
        variable ChainStayOffset 50
            
        variable RearDropout;   array set RearDropout {}
        variable HandleBar;     array set HandleBar {}
        variable Saddle;        array set Saddle {}
        
        set      fileName       {}
        
        variable colorFrame     gold
        variable colorComponent LightGray
        variable colorTyre      DimGray
        variable colorSaddle    DimGray
        variable colorHandleBar DimGray
            #
            #
        # expr 1/0  ;# test not existing package  
            #
        if 0 {
            if {![file exists $pluginDir]} {
                file mkdir $pluginDir
            } 
                #
            lappend auto_path $pluginDir
                #
            puts "\n        ... \$auto_path:"
            foreach dir $auto_path {
                puts "          ... $dir"
            }
        }
        puts "\n"
            #
    }    

    namespace eval myGUI::plugIn {
            namespace ensemble create -command ::myGUI::plugIn \
                -map {
                        create     create
                    } 
    }

    proc myGUI::plugIn::init {parentFrame} {
            #
        puts "\n"
        puts "   --< myGUI::plugIn::create_buttonFrame >---------------------"
        puts ""
            # puts "\n\n\n"
            #
        variable buttonFrame    $parentFrame
        variable pluginDir
        variable configFile
            #
        set pluginDir   $::APPL_Config(PLUGIN_Dir)
        set configFile  [file join $pluginDir plugin.xml]
            #
        if {![file exists $pluginDir]} {
            file mkdir $pluginDir
        } 
            #
        lappend ::auto_path $pluginDir         
            #
        if {[file exists $configFile]} {   
            set spaceRight  [label  $buttonFrame.spaceRight   -text   " "]
            pack    $spaceRight -side right
            puts "     ... plugin   $configFile"
        } else {
            puts "     ... plugin   $configFile ... does not exist"
        }       
            #
            #
            # puts "      \$parent      $parent"
            # puts "      \$buttonFrame $buttonFrame"
            # puts "\n\n\n"
        return $buttonFrame
            #
    }

    proc myGUI::plugIn::addButton {buttonImage buttonProcedure {toolTip {}}} {
            #
        variable buttonID
            #
        variable buttonFrame
            #
        set buttonPath          [format {%s.plugIn_%d} $buttonFrame $buttonID]   
        ttk::button             $buttonPath -image  $buttonImage   -command $buttonProcedure  
        myGUI::gui::setTooltip  $buttonPath $toolTip            
            #
        pack    $buttonPath -fill y -expand yes -side left
            #
        incr buttonID
            #
    }

    proc myGUI::plugIn::loadPlugins {} {
            #
        puts "\n"
        puts "   --< myGUI::plugIn::addPlugins >----------------------------"
        puts ""
            #
        variable pluginDir
        variable configFile
            #
        if {![file exists $configFile]} {
            return
        }
            #
        set pluginDOM  [myPersist::file::get_XMLContent     $configFile]
        puts "     ... plugIn        $configFile"
            # puts [$pluginDOM asXML]
            #
        foreach pluginNode [$pluginDOM childNodes] {
            if {[$pluginNode nodeType] eq {ELEMENT_NODE}} {
                    #
                set pluginName  [$pluginNode nodeName]
                puts "   -> $pluginName"
                    # puts "   -> $pluginNode $pluginName"
                    #
                    # -- starkit --
                set starkitNodes [$pluginNode selectNodes starkit]
                if {$starkitNodes eq {}} {
                    set starkit {}
                } else {
                    set starkit [[lindex $starkitNodes end] text]
                    puts "       -> starkit: $starkit"
                    # puts "       -> starkit: $starkitNode -> $starkit"
                }
                    #
                    # -- script ---
                set scriptNodes  [$pluginNode selectNodes script]
                if {$scriptNodes eq {}} {
                    set script  {}
                } else {
                    set script  [[lindex $scriptNodes end] text]
                    puts "       -> script:  $script"
                    # puts "       -> script:  $scriptNode -> $script"
                }
                    #
                if {$starkit ne {}} {
                        set packageFile [file join $pluginDir $starkit]
                        addStarkit $pluginName $packageFile
                } else {
                    if {$script ne {}} {
                        set packageDir  [file join $pluginDir $pluginName]
                        addScript  $pluginName $packageDir
                    }
                }
            }
        }
            #
        return
            #
    }

    proc myGUI::plugIn::addStarkit {pluginName packageFile} {
            #
        puts "\n"
        puts "   ----< myGUI::plugIn::addStarkit >--------------------------"
        puts "          ... $pluginName"
        puts "          ... $packageFile"
            #
        if {[catch {source $packageFile} eID]} {
            puts "\n"
            puts "   <E> source $packageFile"
            puts "   <E> $eID"
            puts "\n"
        }
        if {[catch {package require $pluginName} eID]} {
            puts "\n"
            puts "   <E> package require $pluginName"
            puts "   <E> $eID"
            puts "\n"
        } else {
            set packageVersion [package require $pluginName]
            puts ""
            puts "   <I> packageVersion"
            puts "   <I> $pluginName  ($packageVersion)   <- $pluginName"
            [list [format {::%s::initPackage} $pluginName]]   
        }
            #
     }

    proc myGUI::plugIn::addScript {pluginName packageDir} {
            #
        puts "\n"
        puts "   ----< myGUI::plugIn::addScript >---------------------------"
        puts "          ... $pluginName"
        puts "          ... $packageDir"
            #
            #
        lappend ::auto_path $packageDir
            #
        if {[catch {package require $pluginName} eID]} {
            puts "\n"
            puts "   <E> package require $pluginName"
            puts "   <E> $eID"
            puts "\n"
        } else {
            set packageVersion [package require $pluginName]
                #
            puts "   <I> $pluginName  ($packageVersion)   <- $pluginName"
            puts "\n"
                #
            [list [format {::%s::initPackage} $pluginName]]
        }
            #
        return    
            #
     } 

    #-------------------------------------------------------------------------
       #  create toplevel widget
       #
    proc myGUI::plugIn::create_Window {wTitle {wPath ".plugin"}} {
            # 
        variable cfg_Position 
            #
        set master  . 
        set w       $wPath
        
            # -----------------
            # master window information
        set root_xy [split  [wm geometry $master] +]
        set root_w  [winfo width $master]
        set root_x  [lindex $root_xy 1]
        set root_y  [lindex $root_xy 2]
            #
        if {$wPath eq {.plugin}} {  
            set pos_x   [expr $root_x -  80]
            set pos_y   [expr $root_y - 200]
        } else {
            set pos_x   [expr $root_x - 180]
            set pos_y   [expr $root_y - 280]
        }
            #
        set cfg_Position [list $root_x $root_y $root_w [expr $root_x+8+$root_w] 0 ]
            #
            # -----------------
            # check if window exists
        if [winfo exists $wPath] {
            destroy $wPath
        }
            #
            # -----------------
            # create a toplevel window to edit the attribute values
            #
        set w   [toplevel $wPath]
            #
        puts "  -> \$w $w"
        puts ""
            #
            #
            # create iconBitmap  -----
        switch -exact $::tcl_platform(platform) {
            windows {
                wm iconbitmap $w [file join $::APPL_Config(BASE_Dir) tclkit.ico]
            }
            default {
                wm iconphoto  $w [image create photo .ico1 -format gif -file [file join $::APPL_Config(BASE_Dir)  icon16.gif] ]
            }
        }
            #
            # -----------------
            # create content
        # catch {fill_GUI        $w}
            #
            # -----------------
            #
        bind $w         <Configure> [list [namespace current]::register_relative_position     $master $w]
        bind $master    <Configure> [list [namespace current]::reposition_to_master           $master $w]
            #
            #
        wm deiconify    $master
            #
        wm title        $w $wTitle
        wm geometry     $w +[expr $root_x+600]+[expr $root_y+200]
            # wm attributes   $w -toolwindow 
        wm transient    $w $master 
            #
        focus           $w
            #
        return $w
            #
    }

    proc myGUI::plugIn::create_TextWindow {wTitle {wPath ".pluginText"}} {
            #
        set w   [create_Window $wTitle $wPath]
            #
        menu $w.menubar         -tearoff 0
        menu $w.menubar.file    -tearoff 0
        $w.menubar      add cascade -label "File"   -menu $w.menubar.file  
        $w.menubar.file add command -label "Close"  -command [list destroy $w]
            #
        $w configure -menu $w.menubar
            #
            # $w.menubar      configure -background green -foreground green -activebackground green -activeforeground green ;# does not work ???
            # $w.menubar.file configure -background green -foreground green -activebackground green -activeforeground green ;# work
            #
            #
        text     $w.txt \
                    -width 60 -height 25 \
                    -wrap none \
                    -yscrollcommand "$w.scroll_y set" \
                    -xscrollcommand "$w.scroll_x set"
        scrollbar $w.scroll_y \
                    -command "$w.txt yview" \
                    -orient v
        scrollbar $w.scroll_x \
                    -command "$w.txt xview" \
                    -orient h
            #
        grid $w.txt         -row 1 -column 1 -sticky nsew 
        grid $w.scroll_y    -row 1 -column 2 -sticky ns   
        grid $w.scroll_x    -row 2 -column 1 -sticky ew   
            #
        grid rowconfigure    $w 1 -weight 1 ;# this row will expand
        grid columnconfigure $w 1 -weight 1 ;# this column will expand   
            #
        update
        wm minsize $w [winfo width $w]   [winfo height $w]  
            #
        return $w.txt
            #
    }

    #-------------------------------------------------------------------------
       #  create ScreenShot
       #
    proc myGUI::plugIn::canvas2Photo { canvId bbox} {
            # http://code.activestate.com/recipes/68411-canvastoimg/
            # The following line grabs the contents of the canvas canvId into photo image my_canvasSreenShot.
        set retVal [catch {set mySreenShot [image create photo ::myGUI::plugIn::mySreenShot -format window -data $canvId]}]
        if { $retVal != 0 } {
           puts "\n\tFATAL ERROR: Cannot create photo from canvas window"
           return -1
        }
            #
        puts "         -> $bbox"
        set myPhoto [image create photo ::myGUI::plugIn::myPhoto]
        $myPhoto copy $mySreenShot -from [lindex $bbox 0] [lindex $bbox 1] [lindex $bbox 2] [lindex $bbox 3]
            #
        image delete $mySreenShot
            #
        return $myPhoto
            #
    }    
    proc myGUI::plugIn::create_ScreenShot {} {
            #
        update
            #
        set cvObject    [myGUI::gui::getCanvasObject]    
        set cvCurrent   [$cvObject getCanvas]    
            #
        puts "\n"    
        puts "      ... export $cvName"    
        puts "             ... $cvCurrent"    
            #
        set retVal [catch {package require Img} version]
        if { $retVal } {
            error "      ... try to load package Img: $version"
        }
            #
        if { $::tcl_platform(platform) == "windows" } {
            catch { console show }
        }
            #
            #
        foreach imageName [lsort [image names]] {
            puts "     -> $imageName -0- [image inuse $imageName]"
        }
            #
        set canvasBox   [list 0 0 [$cvName cget -width] [$cvName cget -height]]
        set stageBox    [$cvName bbox __Stage__]
            # puts "      ... $canvasBox"
            # puts "      ... $stageBox"
            #
        set cnv_x  [lindex $canvasBox 2]
        set cnv_y  [lindex $canvasBox 3]
            #
        set img_x1 [lindex $stageBox 0]    
        set img_y1 [lindex $stageBox 1]    
        set img_x2 [lindex $stageBox 2]
        set img_y2 [lindex $stageBox 3]
        set img_x  [expr $img_x2 - $img_x1]
        set img_y  [expr $img_y2 - $img_y1]
            #
        if {$img_x2 > $cnv_x}   {set img_x2 $cnv_x}
        if {$img_y2 > $cnv_y}   {set img_y2 $cnv_y}
        if {$img_x1 < 0}        {set img_x1 0}
        if {$img_y1 < 0}        {set img_y1 0}
            #
            # puts "           ... $img_x"
            # puts "           ... $img_y"
            # puts "          --------------------"
            # puts "              ... $img_x1"
            # puts "              ... $img_y1"
            # puts "              ... $img_x2"
            # puts "              ... $img_y2"
                #
        set cvBBox [list $img_x1 $img_y1 $img_x2 $img_y2]      
        puts "         -> $cvBBox"
        #
        set canvasPhoto [canvas2Photo $cvCurrent $cvBBox]
        if {$canvasPhoto == -1} {
            puts "\n"
            puts "           <E> ... could not get photo of $cvCurrent"
            puts "\n"
            return
        }
            #
        foreach imgFormat {PNG JPEG GIF} {}
        foreach imgFormat {GIF} {
            switch -exact $imgFormat {
                JPEG    {set fileExtension {jpg}}
                PNG     {set fileExtension {png}}
                GIF      -
                default {
                        set imgFormat GIF
                        set fileExtension {gif}
                }
            }
                #
            set imageFile [format {screenShot_%s.%s} [clock format [clock seconds] -format {%Y%m%d_%H%M%S}] $fileExtension]
            set imagePath [file join $::APPL_Config(EXPORT_IMAGE) $imageFile]
            puts "        ... writing canvas as $imgFormat image:"
            puts "                  $canvasPhoto"
            puts "                  $imageFile"
            puts "                  $imagePath"
                #
            if {[catch {$canvasPhoto write $imagePath -format $imgFormat} eID]} {
                puts "\n"
                puts "           <E> $eID"
                puts "\n"
            }
                #$canvasPhoto write $imagePath -format $imgFormat
                #
            puts "\n"
            foreach imageID [image names] {
                # puts "          -> $imageID"
            }     
                #
        }
            #
        foreach imageName [lsort [image names]] {
            puts "     -> $imageName -1- [image inuse $imageName]"
        }
            #
        image delete $canvasPhoto
            #
        foreach imageName [lsort [image names]] {
            puts "     -> $imageName -2- [image inuse $imageName]"
        }
            #
        puts "\n"    
            #
        return    
            #
    }


    #-------------------------------------------------------------------------
       #  postion config panel to master window
       #
    proc myGUI::plugIn::reposition_to_master {master w} {

        variable cfg_Position

        if {![winfo exists $w]} return

        # wm deiconify   $w

        set root_xy [split  [wm geometry $master] +]
        set root_w    [winfo  width $master]
        set root_x    [lindex $root_xy 1]
        set root_y    [lindex $root_xy 2]

        set update no

        if {$root_x != [lindex $cfg_Position 0]} {set update yes}
        if {$root_y != [lindex $cfg_Position 1]} {set update yes}
        if {$root_w != [lindex $cfg_Position 2]} {set update resize}

        switch $update {
            yes {
                    set dx [lindex $cfg_Position 3]
                    set dy [lindex $cfg_Position 4]
                      # puts "   -> reposition_to_master  - $w +[expr $root_x+$dx]+[expr $root_y+$dy]"
                    catch {wm geometry    $w +[expr $root_x+$dx]+[expr $root_y+$dy]}
                }
            resize {
                    set d_root [expr $root_w - [lindex $cfg_Position 2]]
                    set dx [ expr [lindex $cfg_Position 3] + $d_root ]
                    set dy [lindex $cfg_Position 4]
                    catch {wm geometry    $w +[expr $root_x+$dx]+[expr $root_y+$dy]}
            }
        }
    }
    #-------------------------------------------------------------------------
       #  register_relative_position
       #
    proc myGUI::plugIn::register_relative_position {master w} {

        variable cfg_Position

        set root_xy [split  [wm geometry $master] +]
        set root_w  [winfo width $master]
        set root_x  [lindex $root_xy 1]
        set root_y  [lindex $root_xy 2]
            # puts "    master: $master: $root_x  $root_y"

        set w_xy [split  [wm geometry $w] +]
            # puts "    w   .... $w_xy"
        set w_x [lindex $w_xy 1]
        set w_y [lindex $w_xy 2]
            # puts "    w   ..... $w: $w_x  $w_y"
        set d_x     [ expr $w_x-$root_x]
        set d_y     [ expr $w_y-$root_y]
            # puts "    w   ..... $w: $d_x  $d_y"
            # puts "    w   ..... $root_x $root_y $d_x $d_y"
        set cfg_Position [list $root_x $root_y $root_w $d_x $d_y ]
            # puts "     ... register_relative_position $cfg_Position"
    }

    
    #-------------------------------------------------------------------------
       #  create config Content
       #
    proc myGUI::plugIn::__fill_GUI_orphan {w} {
            #
        variable compCanvas
            #
            # -----------------
            #   clean berfoe create
            # -----------------
            #   create notebook
        pack [  frame $w.nb_Continer ]
            #
        set nb_Config   [ ttk::notebook $w.nb_Continer.nb ]
        pack $nb_Config     -expand no -fill both
            #
        $nb_Config add [frame $nb_Config.openSCAD]      -text "openSCAD - 3D Mockup"
        $nb_Config add [frame $nb_Config.reynoldsFEA]   -text "  Reynolds FEA  "
            #
            # -----------------
            # add content
        ::mockup_3D     insert_ControlWidget $nb_Config.openSCAD
        ::reynolds_FEA  insert_ControlWidget $nb_Config.reynoldsFEA
            #
            # -----------------
            #			
        # bind $nb_Config <<NotebookTabChanged>> [list [namespace current]::bind_notebookTabChanged  $nb_Config]
            #
            # -----------------
            #
        # wm resizable    $w  0 0
            #
            #
        $nb_Config      select 0
            #
        return
    }
        #
    