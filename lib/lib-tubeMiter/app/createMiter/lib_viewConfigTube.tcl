 ########################################################################
 #
 # simplifySVG: lib_view.tcl
 #
 # Copyright (c) Manfred ROSENBERGER, 2017/11/26
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

namespace eval tubeMiter::app::createMiter::view::ConfigTube {
        #
    variable cvObject
        #
    variable Scalar
    array set Scalar    {
        Diameter        28.6
        Diameter_X      31.8
        Diameter_Y      25.4
    }
        #
    namespace import [namespace parent]::* 
        #
}
    #
    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::ConfigTube::build {w} {
        #
    variable notebookConfig    
        #
        #
    set f_base          [labelframe $w.f_tube  -text "Tube"]
    pack $f_base        -side top  -fill x  -expand yes
        #
    set notebookConfig  [ttk::notebook  $f_base.nb  -width 250]
    pack $notebookConfig -side top  -expand yes  -fill y  -pady 0
        #
            #
            #
            # ------------------------------------
            #
    set tab_round       [$notebookConfig  add  [frame $notebookConfig.round]   -text "round"]
            #
        set f_tab       [frame $notebookConfig.round.f_01  -relief flat  -bd 0]
        pack $f_tab    -side top  -expand yes  -fill both  -ipadx 4  -pady 4
            #
        set sc_01       [tubeMiter::ScalarEntry new  $f_tab.sc_01  -text Diameter       -textvariable  [namespace current]::Scalar(Diameter)      -resolution 0.1]
            #
        set w_01        [$sc_01 getPath]
            #
        pack $w_01 \
                        -side top  -fill x  -padx 2  -pady 1
            #
        $sc_01 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_01 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
            #
            #
            # ------------------------------------
            #
    set tab_oval        [$notebookConfig  add  [frame $notebookConfig.oval]    -text "oval"]
            #
        set f_tab       [frame $notebookConfig.oval.f_01  -relief flat  -bd 0]
        pack $f_tab    -side top  -expand yes  -fill both  -ipadx 4  -pady 4
            #
        set sc_01       [tubeMiter::ScalarEntry new  $f_tab.sc_01   -text Diameter(x)       -textvariable  [namespace current]::Scalar(Diameter_X)      -resolution 0.1]
        set sc_02       [tubeMiter::ScalarEntry new  $f_tab.sc_02   -text Diameter(y)       -textvariable  [namespace current]::Scalar(Diameter_Y)      -resolution 0.1]
            #
        set w_01        [$sc_01 getPath]
        set w_02        [$sc_02 getPath]
            #
        pack $w_01 $w_02 \
                        -side top  -fill x  -padx 2  -pady 1
            #
        $sc_01 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_02 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_01 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
        $sc_02 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
            #
            #
            # ------------------------------------
            #
    bind $notebookConfig <<NotebookTabChanged>>  [namespace parent]::update
        #
}
    #
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::ConfigTube::getTubeName {} {
        #
    variable notebookConfig
        #
    set currentTabID    [$notebookConfig index current]
    set tubeName        [$notebookConfig tab $currentTabID -text]    
        #
    return $tubeName
        #
}    
        #
proc tubeMiter::app::createMiter::view::ConfigTube::getDict {} {
        #
    variable Scalar
        #
    set tubeName        [getTubeName]
        #
    switch -exact $tubeName {
        round {
            set tubeDict \
                [list   type           round \
                        diameter       $Scalar(Diameter) \
                    ]
        }
        oval {
            set tubeDict \
                [list   type           oval \
                        diameter_x     $Scalar(Diameter_X) \
                        diameter_y     $Scalar(Diameter_Y) \
                    ]
        }
        default {
            set tubeDict {}
        }
    }
        #
    return $tubeDict
        #
}   
    #
    