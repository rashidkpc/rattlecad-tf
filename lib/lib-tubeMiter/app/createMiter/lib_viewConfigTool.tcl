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

namespace eval tubeMiter::app::createMiter::view::ConfigTool {
        #
    variable notebookConfig
        #
    variable Scalar
    array set Scalar    {
        Diameter_Cylinder     34.9
        Diameter_ConeBase     34.9
        Diameter_FrustumBase  44.5
        Diameter_FrustumTop   34.9
        Length_Cone           65.0
        Length_Frustum        50.0
    }
        #
}
    #
    # --- window ----------
    #
proc tubeMiter::app::createMiter::view::ConfigTool::build {w} {
        #
    variable notebookConfig    
        #
        #
    set f_base      [labelframe     $w.f_tool   -text "Tool"]
    pack $f_base    -fill x  -expand yes
        #
    set notebookConfig   [ttk::notebook  $f_base.nb  -width 250]
    pack $notebookConfig -expand yes -fill both  -pady 2
            #
            # ------------------------------------
            #   Diameter_ConeBase     34.9
            #   Diameter_Cylinder     34.9
            #   Diameter_FrustumBase  44.5
            #   Diameter_FrustumTop   34.9
            #   Length_Cone          100.0
            #   Length_Frustum        70.0
            # ------------------------------------
            #
    set tab_cylndr  [$notebookConfig  add  [frame $notebookConfig.cylinder] -text   "Cylinder"]
            #
        set f_tab   [frame $notebookConfig.cylinder.f_01  -relief flat  -bd 0]
        pack $f_tab     -side top  -expand yes  -fill both  -ipadx 4  -pady 4
            #
        set sc_01   [tubeMiter::ScalarEntry new  $f_tab.sc_01   -text Diameter          -textvariable  [namespace current]::Scalar(Diameter_Cylinder)  -resolution 0.1]
            #
        set w_01    [$sc_01 getPath]
            #
        pack $w_01      -side top  -fill x  -padx 2  -pady 1
            #
        $sc_01 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_01 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
            #
            #
            # ------------------------------------
            #
        set tab_cone    [$notebookConfig  add  [frame $notebookConfig.cone]     -text   "Cone"]
            #
        set f_tab   [frame $notebookConfig.cone.f_01  -relief flat  -bd 0]
        pack $f_tab     -side top  -expand yes  -fill both  -ipadx 4  -pady 4
            #
        set sc_01   [tubeMiter::ScalarEntry new  $f_tab.sc_01   -text Height            -textvariable  [namespace current]::Scalar(Length_Cone)          -resolution 0.1]
        set sc_02   [tubeMiter::ScalarEntry new  $f_tab.sc_02   -text Diameter(Base)    -textvariable  [namespace current]::Scalar(Diameter_ConeBase)    -resolution 0.1]
            #
        set w_01    [$sc_01 getPath]
        set w_02    [$sc_02 getPath]
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
    set tab_frustum [$notebookConfig  add  [frame $notebookConfig.frustum]  -text   "Frustum"]
            #
        set f_tab   [frame $notebookConfig.frustum.f_01  -relief flat  -bd 0]
        pack $f_tab    -side top  -expand yes  -fill both  -ipadx 4  -pady 4
            #
        set sc_01   [tubeMiter::ScalarEntry new  $f_tab.sc_01   -text Height(Frustum)   -textvariable  [namespace current]::Scalar(Length_Frustum)          -resolution 0.1]
        set sc_02   [tubeMiter::ScalarEntry new  $f_tab.sc_02   -text Diameter(Top)     -textvariable  [namespace current]::Scalar(Diameter_FrustumTop)     -resolution 0.1]
        set sc_03   [tubeMiter::ScalarEntry new  $f_tab.sc_03   -text Diameter(Base)    -textvariable  [namespace current]::Scalar(Diameter_FrustumBase)    -resolution 0.1]
            #
        set w_01    [$sc_01 getPath]
        set w_02    [$sc_02 getPath]
        set w_03    [$sc_03 getPath]
            #
        pack $w_01 $w_02 $w_03 \
                        -side top  -fill x  -padx 2  -pady 1
            #
        $sc_01 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_02 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_03 bind <Return>            [namespace parent [namespace parent]]::control::update
        $sc_01 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
        $sc_02 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
        $sc_03 bind <Double-Button-1>   [namespace parent [namespace parent]]::control::update
            #
            # ------------------------------------
            #
    set tab_plane   [$notebookConfig  add  [frame $notebookConfig.plane]    -text   "Plane"]
            #
        set f_tab   [frame $notebookConfig.plane.f_01  -relief flat  -bd 0]
        pack $f_tab    -side top  -expand yes  -fill both  -ipadx 4  -pady 4
            #
        set w_01    [label $f_tab.lb_01  -text "... no parameters neccessary"]    
            #
        pack $w_01  -side top   -fill x  -padx 2  -pady 1
            #
            #
        #
        #
        # ------------------------------------
        #
    bind $notebookConfig <<NotebookTabChanged>>  [namespace parent]::update
        #
}
    #
    # --- procedure -------
    #
proc tubeMiter::app::createMiter::view::ConfigTool::fitContent {} {
        #
    variable cvObject
        #
    puts "\n"
    puts "  =============================================="
    puts "   -- fitContent:   $cvObject"
    puts "  =============================================="
    puts "\n"
        #
    $cvObject fit
    $cvObject fitContent __Content__
        #
    return
        #
}
    #
proc tubeMiter::app::createMiter::view::ConfigTool::getToolName {} {
        #
    variable notebookConfig
        #
    set currentTabID    [$notebookConfig index current]
    set toolName        [$notebookConfig tab $currentTabID -text]    
        #
    return $toolName
        #
}
    #
proc tubeMiter::app::createMiter::view::ConfigTool::getDict {} {
        #
    variable Scalar
    set toolName        [getToolName]
        #
    switch -exact $toolName {
        Cylinder {
            set toolDict  \
                [list \
                    type            cylinder \
                    diameter        $Scalar(Diameter_Cylinder) \
                ]
        }
        Cone {
            set toolDict  \
                [list \
                    type            cone \
                    diameterBase    $Scalar(Diameter_ConeBase) \
                    length          $Scalar(Length_Cone) \
                ]
        }
        Frustum {
            set toolDict  \
                [list \
                    type    frustum \
                    diameterBase    $Scalar(Diameter_FrustumBase) \
                    diameterTop     $Scalar(Diameter_FrustumTop) \
                    length          $Scalar(Length_Frustum) \
                ]
        }
        Plane {
            set toolDict  \
                [list \
                    type    plane \
                ]
        }
        default {}
    }
        #
    return $toolDict    
        #
}   
    #
proc tubeMiter::app::createMiter::view::ConfigTool::getDict_org {} {
        #
    variable Scalar
    set toolName        [getToolName]
        #
    switch -exact $toolName {
        Cylinder {
            set toolDict  \
                [list \
                    type            cylinder \
                    diameter        $Scalar(Diameter_Cylinder) \
                    profile         [list \
                                        [list \
                                            0 $Scalar(Diameter_Cylinder) \
                                        ] \
                                    ] \
                ]
        }
        Cone {
            set toolDict  \
                [list \
                    type            cone \
                    diameterBase    $Scalar(Diameter_ConeBase)
                    length          $Scalar(Length_Cone)
                    profile         [list \
                                        [list \
                                            0 $radiusHTBase \
                                            $lengthHTBase $radiusHTBase \
                                            $lengthHTTaper $radiusHTTop \
                                            250 $radiusHTTop \
                                        ] \
                                    ] \
                ]
        }
        Frustum {
            set toolDict  \
                [list \
                    type    frustum \
                    diameterBase    $Scalar(Diameter_FrustumBase) \
                    diameterTop     $Scalar(Diameter_FrustumTop) \
                    length          $Scalar(Length_Frustum) \
                    profile         [list \
                                        [list \
                                            -50 $Scalar(Diameter_FrustumBase) \
                                              0 $Scalar(Diameter_FrustumBase) \
                                            $Scalar(Length_Frustum) $Scalar(Diameter_FrustumTop) \
                                            250 $Scalar(Diameter_FrustumTop) \
                                        ] \
                                    ] \
                ]
        }
        Plane {
            set toolDict  \
                [list \
                    type    plane \
                ]
        }
        default {}
    }
        #
    return $toolDict    
        #
}   
    #