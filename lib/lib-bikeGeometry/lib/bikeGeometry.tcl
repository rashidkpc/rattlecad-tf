 ##+##########################################################################
 #
 # package: bikeGeometry    ->    bikeGeometry.tcl
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
 #    namespace:  bikeGeometry
 # ---------------------------------------------------------------------------
 #
 #
 # 2.00 - 20160417
 #      ... refactor: rattleCAD - 3.4.03
 #
 #
 # 1.xx refactor
 #          split project completely from bikeGeometry
 #
 #
  
    package require tdom
        #
    package provide bikeGeometry 3.00
        #
    package require vectormath
    package require tubeMiter    0.03
        #
    namespace eval bikeGeometry {
        
            # --------------------------------------------
                # Export as global command
            variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
                #

            
            #-------------------------------------------------------------------------
                #  definitions of template parameter
            variable initRoot
            variable resultRoot
            # variable initRoot    $project::initRoot
            variable projectDOM
            # variable returnDict; set returnDict [dict create rattleCAD {}]
            variable projectRoot
                #
        
        
            #-------------------------------------------------------------------------
                #  current Project Values
            variable Project         ; array set Project         {}
            variable Geometry        ; array set Geometry        {}
            variable Reference       ; array set Reference       {}
            variable Component       ; array set Component       {}
            variable Config          ; array set Config          {}
            variable ListValue       ; array set ListValue       {}
            variable Result          ; array set Result          {}
            
            variable ConfigPrev      ; array set ConfigPrev      {}
            
            variable BottleCage      ; array set BottleCage      {}
            variable BottomBracket   ; array set BottomBracket   {}
            variable Fork            ; array set Fork            {}
            variable FrontDerailleur ; array set FrontDerailleur {}
            variable FrontWheel      ; array set FrontWheel      {}
            variable HandleBar       ; array set HandleBar       {}
            variable HeadSet         ; array set HeadSet         {}
            variable RearDerailleur  ; array set RearDerailleur  {}
            variable RearDropout     ; array set RearDropout     {}
            variable RearWheel       ; array set RearWheel       {}
            variable Saddle          ; array set Saddle          {}
            variable SeatPost        ; array set SeatPost        {}
            variable Spacer          ; array set Spacer          {}
            variable Stem            ; array set Stem            {}
            
            variable LegClearance    ; array set LegClearance    {}
            
            variable HeadTube        ; array set HeadTube        {}
            variable SeatTube        ; array set SeatTube        {}
            variable DownTube        ; array set DownTube        {}
            variable TopTube         ; array set TopTube         {}
            variable ChainStay       ; array set ChainStay       {}
            variable SeatStay        ; array set SeatStay        {}
            variable Steerer         ; array set Steerer         {}
            variable ForkBlade       ; array set ForkBlade       {}
            variable Lugs            ; array set Lugs            {}
            
            
            variable TubeMiter       ; array set TubeMiter       {}
            variable FrameJig        ; array set FrameJig        {}
            variable RearMockup      ; array set RearMockup      {}
            variable BoundingBox     ; array set BoundingBox     {}
            variable CustomCrank     ; array set CustomCrank     {}
            
            
            variable myFork          ; array set myFork          {}

            variable DEBUG_Geometry  ; array set DEBUG_Geometry  {}



            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            variable customFork      ; array set customFork { lastConfig    {} }
            
            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            # variable _updateValue   ; array set _updateValue    {}

            #-------------------------------------------------------------------------
                #  dataprovider of create_selectbox
            variable _listBoxValues

            #-------------------------------------------------------------------------
                #  default value
            set Steerer(Diameter)       28.6

           
            #-------------------------------------------------------------------------
                #  export procedures
            if 0 {
                namespace export set_newProject
                namespace export get_projectDOM
                namespace export get_projectDICT
                    #
                namespace export import_ProjectSubset
                    #
                namespace export get_Component
                namespace export get_Config
                namespace export get_ListValue
                namespace export get_Scalar
                    #
                namespace export set_Component
                namespace export set_Config
                namespace export set_ListValue
                namespace export set_Scalar
                    #
                namespace export get_Polygon
                namespace export get_Position
                namespace export get_Direction
                namespace export get_BoundingBox
                namespace export get_TubeMiter
                namespace export get_TubeMiterDICT
                namespace export get_paramComponent
                namespace export get_CenterLine
                    #
                namespace export get_ComponentDir 
                namespace export get_ComponentDirectories
                namespace export get_ListBoxValues 
                    #
                namespace export get_DebugGeometry
                namespace export get_ReynoldsFEAContent
                    #
                namespace export coords_xy_index
                    #
                # namespace export get_Value
                # namespace export get_Object
                # namespace export set_Value
                # namespace export set_resultParameter
                    #
            }
                # puts " Hallo!  ... [info command [namespace current]::*]" 
                #
    }
        
        
        #
    #-------------------------------------------------------------------------
        #  load newProject
        #
        #  ... loads a new project given by a XML-Project as rootNode
        #
    proc bikeGeometry::init {} {
                #
            variable packageHomeDir
                #
            variable initRoot
            variable projectRoot
            variable resultRoot
                #
            
                #
                # --- 
            set fp          [open [file join $packageHomeDir .. etc initNamespace.xml] ]
            fconfigure      $fp -encoding utf-8
            set initXML     [read $fp]
            close           $fp          
            set initDoc     [dom parse $initXML]
            set initRoot    [$initDoc documentElement]
                #
                #
                # --
            set fp          [open [file join $packageHomeDir .. etc initTemplate.xml] ]
            fconfigure      $fp -encoding utf-8
            set projectXML  [read $fp]
            close           $fp          
            set projectDoc  [dom parse $projectXML]
            set projectRoot [$projectDoc documentElement]
                #            
                #
                # --- 
            set fp          [open [file join $packageHomeDir .. etc resultTemplate.xml] ]
            fconfigure      $fp -encoding utf-8
            set resultXML   [read $fp]
            close           $fp          
            set resultDoc   [dom parse $resultXML]
            set resultRoot  [$resultDoc documentElement]

            #-------------------------------------------------------------------------
                #  init Values
                #    ... these is a default project
                #  
                #
            foreach arrayNode [$projectRoot childNodes] {
                # this is the arrayName level
                foreach keyNode [$arrayNode childNodes] {
                    # this is the key level
                    foreach textNode [$keyNode childNodes] {
                        set targetParameter     [format {%s::%s(%s)} [namespace current] [$arrayNode nodeName] [$keyNode nodeName]]
                        set targetValue         [$textNode nodeValue]
                        set $targetParameter    $targetValue
                        # puts "   ... [$textNode nodeValue]"
                        # $keyNode removeChild $textNode
                        # $textNode delete
                    }
                }
            }    


            # -- default Values -------------------------
                #
            set ::bikeGeometry::Component(RearHub)                      {hub/rattleCAD_rear.svg}                                                            
            set ::bikeGeometry::HeadSet(ShimDiameter)                   36
                #


            # -- set ::bikeGeometry::DEBUG_Geometry  ----
            #
            set ::bikeGeometry::DEBUG_Geometry(Base)                    {0 0}
            
            
            # --- update ConfigPrev ---------------------
                #
            foreach key [array names [namespace current]::Config] {
                set [namespace current]::ConfigPrev($key) [bikeGeometry::get_Config $key]
            }


            # --- compute geometry ----------------------
                #
            bikeGeometry::update_Geometry
              
                
            # -------------------------------------------
                #
            return
                #

    }

    #-------------------------------------------------------------------------
       #  handle different interfaces for different bicycle geometryconfig modes 
    proc bikeGeometry::set_geometryIF {interfaceName} {
                #
            puts "\n"
            puts "      ---- bikeGeometry::set_geometryIF    ----  $interfaceName  --"
                #
            switch -exact $interfaceName {
                    {Classic}       {set geometryIF    ::bikeGeometry::IF_Classic}
                    {Lugs}          {set geometryIF    ::bikeGeometry::IF_LugAngles}
                    {StackReach}    {set geometryIF    ::bikeGeometry::IF_StackReach}
                    {OutsideIn}     -
                    default         {set geometryIF    ::bikeGeometry::IF_OutsideIn
                                     set interfaceName OutsideIn
                                    }
            }
                #
            puts "                          ->  $geometryIF"
            puts "                 ----------------------------------------------------"
            foreach {subcmd proc} [namespace ensemble configure $geometryIF    -map] {
                        puts [format {                   %-30s %-20s  <- %s }     $subcmd [info args $proc] $proc ]
                    }
            puts ""
            puts "      ---- bikeGeometry::set_geometryIF    ----  $interfaceName  --"
            puts "\n"
                #
                # return $interfaceName   
            return [list $interfaceName $geometryIF]
                #
        }

    #-------------------------------------------------------------------------
       #  return structure of project definitio as xml or array-Structure	
    proc bikeGeometry::get_domainParameters {{type arrayStructure} {report no_report}} {
            #
            # type:   arrayStructure
            #         xmlStructure
            # report: no_report
            #         report
            #
            #
        variable projectRoot
            #
        if {$type == {xmlStructure}} {
                #
                # thats the simple way: return $projectRoot
                #
            if {$report == {report}} {    
                puts "\n    -- get_domainParameters - xmlStructure --"
                puts [$projectRoot asXML]
            }
                #
            set dom     [dom parse [$projectRoot asXML]]
            set root    [$dom documentElement]
                #
            foreach arrayNode [$root childNodes] {
                # this is the arrayName level
                foreach keyNode [$arrayNode childNodes] {
                    # this is the key level
                    foreach textNode [$keyNode childNodes] {
                        # puts "   ... [$textNode nodeValue]"
                        $keyNode removeChild $textNode
                        $textNode delete
                    }
                }
            }
                #
                # exit
            return $root
                #
        }
            #

            #
            # return a list of arrayName(arrayKey) 
            #
        set list_domainParameter {}    
            #
        foreach arrayNode [$projectRoot childNodes] {
            set arrayName [$arrayNode nodeName]
            # puts "    $arrayName"
            foreach keyNode [$arrayNode childNodes] {
                set arrayKey [$keyNode nodeName]
                # puts "        $arrayKey"
                set arrayNameKey [format {%s(%s)} $arrayName $arrayKey]
                # puts "            $arrayNameKey"
                lappend list_domainParameter [list $arrayName $arrayKey]
            }
        }
            #
        if {$report == {report}} {    
            puts "\n    -- get_domainParameters - arrayNames ----"
            foreach domainParameter $list_domainParameter {
                puts "    -> $domainParameter"
            }
        }
            #
        return $list_domainParameter
            #
    }

    #-------------------------------------------------------------------------
       #  reset project by given setting as xml-Structure	
    proc bikeGeometry::set_newProject {projectNode} {

            puts "\n"
            puts " -- bikeGeometry::set_newProject -- $projectNode"
            
            
            # --- report content of projectNode ----------
                #
            # puts "[$projectNode asXML]"

            # --- get values from $projectNode ----------
                #
            foreach arrayNode [$projectNode childNodes] {
                set arrayName [$arrayNode nodeName]
                # puts "    $arrayName"
                foreach keyNode [$arrayNode childNodes] {
                    set arrayKey [$keyNode nodeName]
                    # puts "        $arrayKey"
                    set parameterName [format {%s::%s(%s)} [namespace current] $arrayName $arrayKey]
                    # puts "            $parameterName"
                    set valueNode   [lindex [$keyNode childNodes] 0]
                    if {$valueNode != {}} {
                        set nodeValue  [$valueNode nodeValue]    
                            # puts "       -> $parameterName <- $nodeValue"
                        set $parameterName $nodeValue
                    } else {
                        puts ""
                        puts "    <W> could not set: $parameterName"
                    }
                }
            }

            # --- debug Values --------------------------
                #
            # puts "      <D> bikeGeometry::set_newProject ... \$::bikeGeometry::HeadTube(DiameterTaperedBase) $::bikeGeometry::HeadTube(DiameterTaperedBase)"
            # exit

            # --- check Values --------------------------
                #
            set ::bikeGeometry::ConfigPrev(Fork)    $::bikeGeometry::Config(Fork)
                #


            # --- compute geometry ----------------------
                #
            bikeGeometry::update_Geometry
                #

            # -------------------------------------------
                #
            puts " -- bikeGeometry::set_newProject -- done"
                #
            return
                #
                
    }

    #-------------------------------------------------------------------------
       #  import a subset of a project	
    proc bikeGeometry::import_ProjectSubset {nodeRoot} {
                #
            puts "\n\n"
            puts "       <W>"
			puts "       <W>"
			puts "       <W> ... requires new implementation"
			puts "       <W>"
			puts "       <W>"
			puts "\n\n"
            # project::import_ProjectSubset $nodeRoot
	}

    #-------------------------------------------------------------------------
        #  get current projectDOM as DOM Object
    proc bikeGeometry::get_projectStructure {{type xmlStructure} {report no_report}} {
            #
            # type:   arrayStructure
            #         xmlStructure
            # report: no_report
            #         report
            #
            #
        variable packageHomeDir
            #
        set fp [open [file join $packageHomeDir .. etc initTemplate.xml] ]
        fconfigure          $fp -encoding utf-8
        set structureXML    [read $fp]
        close               $fp
            #
        set structureDoc    [dom parse $structureXML]
        set structureRoot   [$structureDoc documentElement]
            #
            #
        if {$type == {xmlStructure}} {
                #
                # thats the simple way: return $projectRoot
                #
            if {$report == {report}} {    
                puts "\n    -- get_domainParameters - xmlStructure --"
                puts [$structureRoot asXML]
            }
                #
            foreach arrayNode [$structureRoot childNodes] {
                # this is the arrayName level
                foreach typeNode [$arrayNode childNodes] {
                    # this is the key level
                    # puts "   ... [$typeNode nodeName]"
                    foreach keyNode [$typeNode childNodes] {
                        foreach textNode [$keyNode childNodes] {
                            puts "   ... [$textNode nodeValue]"
                            $keyNode removeChild $textNode
                            $textNode delete
                        }
                    }
                }
            }
                #
                # exit
            return $structureRoot
                #
        }
        
            #
        # -- type == arrayStructure --------------------
            #
            # return a list of arrayName(arrayKey) 
            #
        set list_domainParameter {}    
            #
        foreach arrayNode [$structureRoot childNodes] {
            # this is the arrayName level
            set arrayName [$arrayNode nodeName]
            foreach typeNode [$arrayNode childNodes] {
                # this is the key level
                set typeName [$typeNode nodeName]
                # puts "   ... [$typeNode nodeName]"
                foreach keyNode [$typeNode childNodes] {
                    set keyName [$keyNode nodeName]
                    lappend list_domainParameter [format {%s/%s/%s} $arrayName $typeName $keyName]
                }
            }
        }
            
            #
        if {$report == {report}} {    
            puts "\n    -- get_domainParameters - arrayNames ----"
            foreach domainParameter $list_domainParameter {
                puts "    -> $domainParameter"
            }
        }
            #
        return $list_domainParameter
            #        
        
        
    }
        #
    
    
    
    #-------------------------------------------------------------------------
        #  get current projectDOM as DOM Object
    proc bikeGeometry::get_projectDOM {} {
                #
            variable resultRoot
                #
            puts "\n"
            puts " -- bikeGeometry::get_projectDOM --"
                #
            bikeGeometry::update_resultRoot
                #
            return $resultRoot
                #
    }

    #-------------------------------------------------------------------------
        #  get current projectDOM as Dictionary
    proc bikeGeometry::get_projectDICT {} {
            #   return $project::projectDICT
        set projDict   [dict create Component {}  Config {}  ListValue {}  Scalar {} ]
            #
            #
            #
        dict set projDict   Component   CrankSet                            $::bikeGeometry::Component(CrankSet)                            ;#[bikeGeometry::get_Component        CrankSet                          ]                ;# set _lastValue(Component/CrankSet/File)                                 
        dict set projDict   Component   ForkCrown                           $::bikeGeometry::Component(ForkCrown)                           ;#[bikeGeometry::get_Component        Fork CrownFile                    ]                ;# set _lastValue(Component/Fork/Crown/File)                               
        dict set projDict   Component   ForkDropout                         $::bikeGeometry::Component(ForkDropout)                         ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set projDict   Component   ForkSupplier                        $::bikeGeometry::Component(ForkSupplier)                        ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set projDict   Component   FrontBrake                          $::bikeGeometry::Component(FrontBrake)                          ;#[bikeGeometry::get_Component        FrontBrake                        ]                ;# set _lastValue(Component/Brake/Front/File)                              
        dict set projDict   Component   FrontCarrier                        $::bikeGeometry::Component(FrontCarrier)                        ;#[bikeGeometry::get_Component        FrontCarrier                      ]                ;# set _lastValue(Component/Carrier/Front/File)                            
        dict set projDict   Component   FrontDerailleur                     $::bikeGeometry::Component(FrontDerailleur)                     ;#[bikeGeometry::get_Component        FrontDerailleur                   ]                ;# set _lastValue(Component/Derailleur/Front/File)                         
        dict set projDict   Component   HandleBar                           $::bikeGeometry::Component(HandleBar)                           ;#[bikeGeometry::get_Component        HandleBar                         ]                ;# set _lastValue(Component/HandleBar/File)                                
        dict set projDict   Component   Label                               $::bikeGeometry::Component(Label)                               ;#[bikeGeometry::get_Component        Logo                              ]                ;# set _lastValue(Component/Logo/File)                                     
        dict set projDict   Component   RearBrake                           $::bikeGeometry::Component(RearBrake)                           ;#[bikeGeometry::get_Component        RearBrake                         ]                ;# set _lastValue(Component/Brake/Rear/File)                               
        dict set projDict   Component   RearCarrier                         $::bikeGeometry::Component(RearCarrier)                         ;#[bikeGeometry::get_Component        RearCarrier                       ]                ;# set _lastValue(Component/Carrier/Rear/File)                             
        dict set projDict   Component   RearDerailleur                      $::bikeGeometry::Component(RearDerailleur)                      ;#[bikeGeometry::get_Component        RearDerailleur                    ]                ;# set _lastValue(Component/Derailleur/Rear/File)                          
        dict set projDict   Component   RearDropout                         $::bikeGeometry::Component(RearDropout)                         ;#[bikeGeometry::get_Component        RearDropout File                  ]                ;# set _lastValue(Lugs/RearDropOut/File)                                   
        dict set projDict   Component   RearHub                             $::bikeGeometry::Component(RearHub)
        dict set projDict   Component   Saddle                              $::bikeGeometry::Component(Saddle)                              ;#[bikeGeometry::get_Component        Saddle                            ]                ;# set _lastValue(Component/Saddle/File)                                   
        dict set projDict   Component   BottleCage_DownTube                 $::bikeGeometry::Component(BottleCage_DownTube)                                
        dict set projDict   Component   BottleCage_DownTube_Lower           $::bikeGeometry::Component(BottleCage_DownTube_Lower)                          
        dict set projDict   Component   BottleCage_SeatTube                 $::bikeGeometry::Component(BottleCage_SeatTube)                                
            #                           
        dict set projDict   Config      BottleCage_DownTube                 $::bikeGeometry::Config(BottleCage_DownTube)                    ;#[bikeGeometry::get_Config           BottleCage_DT                     ]                ;# set _lastValue(Rendering/BottleCage/DownTube)                           
        dict set projDict   Config      BottleCage_DownTube_Lower           $::bikeGeometry::Config(BottleCage_DownTube_Lower)              ;#[bikeGeometry::get_Config           BottleCage_DT_L                   ]                ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
        dict set projDict   Config      BottleCage_SeatTube                 $::bikeGeometry::Config(BottleCage_SeatTube)                    ;#[bikeGeometry::get_Config           BottleCage_ST                     ]                ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
        dict set projDict   Config      ChainStay                           $::bikeGeometry::Config(ChainStay)                              ;#[bikeGeometry::get_Config           ChainStay                         ]                ;# set _lastValue(Rendering/ChainStay)                                     
        dict set projDict   Config      CrankSet_SpyderArmCount             $::bikeGeometry::Config(CrankSet_SpyderArmCount)
        dict set projDict   Config      Fork                                $::bikeGeometry::Config(Fork)                                   ;#[bikeGeometry::get_Config           Fork                              ]                ;# set _lastValue(Rendering/Fork)                                          
        dict set projDict   Config      ForkBlade                           $::bikeGeometry::Config(ForkBlade)                              ;#[bikeGeometry::get_Config           ForkBlade                         ]                ;# set _lastValue(Rendering/ForkBlade)                                     
        dict set projDict   Config      ForkDropout                         $::bikeGeometry::Config(ForkDropout)                            ;#[bikeGeometry::get_Config           ForkDropout                       ]                ;# set _lastValue(Rendering/ForkDropOut)                                   
        dict set projDict   Config      FrontBrake                          $::bikeGeometry::Config(FrontBrake)                             ;#[bikeGeometry::get_Config           FrontBrake                        ]                ;# set _lastValue(Rendering/Brake/Front)                                   
        dict set projDict   Config      FrontFender                         $::bikeGeometry::Config(FrontFender)                            ;#[bikeGeometry::get_Config           FrontFender                       ]                ;# set _lastValue(Rendering/Fender/Front)                                  
        dict set projDict   Config      HeadTube                            $::bikeGeometry::Config(HeadTube) 
        dict set projDict   Config      RearBrake                           $::bikeGeometry::Config(RearBrake)                              ;#[bikeGeometry::get_Config           RearBrake                         ]                ;# set _lastValue(Rendering/Brake/Rear)                                    
        dict set projDict   Config      RearDropout                         $::bikeGeometry::Config(RearDropout)                            ;#[bikeGeometry::get_Config           RearDropout                       ]                ;# set _lastValue(Rendering/RearDropOut)                                   
        dict set projDict   Config      RearDropoutOrient                   $::bikeGeometry::Config(RearDropoutOrient)                      ;#[bikeGeometry::get_Config           RearDropoutOrient                 ]                ;# set _lastValue(Lugs/RearDropOut/Direction)                              
        dict set projDict   Config      RearFender                          $::bikeGeometry::Config(RearFender)                             ;#[bikeGeometry::get_Config           RearFender                        ]                ;# set _lastValue(Rendering/Fender/Rear)                                   
        dict set projDict   Config      Color_FrameTubes                    $::bikeGeometry::Config(Color_FrameTubes)
        dict set projDict   Config      Color_Fork                          $::bikeGeometry::Config(Color_Fork)
        dict set projDict   Config      Color_Label                         $::bikeGeometry::Config(Color_Label)
            #                           
        dict set projDict   ListValue   CrankSetChainRings                  $::bikeGeometry::ListValue(CrankSetChainRings)                  ;#[bikeGeometry::get_Scalar           CrankSet ChainRings               ]                ;# set _lastValue(Component/CrankSet/ChainRings)                           
            #           
        dict set projDict   Scalar      BottleCage DownTube                 $::bikeGeometry::BottleCage(DownTube)                           ;#[bikeGeometry::get_Scalar           BottleCage DownTube               ]                ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
        dict set projDict   Scalar      BottleCage DownTube_Lower           $::bikeGeometry::BottleCage(DownTube_Lower)                     ;#[bikeGeometry::get_Scalar           BottleCage DownTube_Lower         ]                ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
        dict set projDict   Scalar      BottleCage SeatTube                 $::bikeGeometry::BottleCage(SeatTube)                           ;#[bikeGeometry::get_Scalar           BottleCage SeatTube               ]                ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
        dict set projDict   Scalar      BottomBracket InsideDiameter        $::bikeGeometry::BottomBracket(InsideDiameter)                  ;#[bikeGeometry::get_Scalar           BottomBracket InsideDiameter      ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
        dict set projDict   Scalar      BottomBracket OffsetCS_TopView      $::bikeGeometry::BottomBracket(OffsetCS_TopView)                ;#[bikeGeometry::get_Scalar           BottomBracket OffsetCS_TopView    ]                ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
        dict set projDict   Scalar      BottomBracket OutsideDiameter       $::bikeGeometry::BottomBracket(OutsideDiameter)                 ;#[bikeGeometry::get_Scalar           BottomBracket OutsideDiameter     ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
        dict set projDict   Scalar      BottomBracket Width                 $::bikeGeometry::BottomBracket(Width)                           ;#[bikeGeometry::get_Scalar           BottomBracket Width               ]                ;# set _lastValue(Lugs/BottomBracket/Width)                                
            #            
        dict set projDict   Scalar      ChainStay DiameterSS                $::bikeGeometry::ChainStay(DiameterSS)                          ;#[bikeGeometry::get_Scalar           ChainStay DiameterSS              ]                ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
        dict set projDict   Scalar      ChainStay Height                    $::bikeGeometry::ChainStay(Height)                              ;#[bikeGeometry::get_Scalar           ChainStay Height                  ]                ;# set _lastValue(FrameTubes/ChainStay/Height)                             
        dict set projDict   Scalar      ChainStay HeightBB                  $::bikeGeometry::ChainStay(HeightBB)                            ;#[bikeGeometry::get_Scalar           ChainStay HeigthBB                ]                ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
        dict set projDict   Scalar      ChainStay TaperLength               $::bikeGeometry::ChainStay(TaperLength)                         ;#[bikeGeometry::get_Scalar           ChainStay TaperLength             ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay WidthBB                   $::bikeGeometry::ChainStay(WidthBB)                             ;#[bikeGeometry::get_Scalar           ChainStay WidthBB                 ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay completeLength            $::bikeGeometry::ChainStay(completeLength)                      ;#[bikeGeometry::get_Scalar           ChainStay completeLength          ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
        dict set projDict   Scalar      ChainStay cuttingLeft               $::bikeGeometry::ChainStay(cuttingLeft)                         ;#[bikeGeometry::get_Scalar           ChainStay cuttingLeft             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
        dict set projDict   Scalar      ChainStay cuttingLength             $::bikeGeometry::ChainStay(cuttingLength)                       ;#[bikeGeometry::get_Scalar           ChainStay cuttingLength           ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
        dict set projDict   Scalar      ChainStay profile_x01               $::bikeGeometry::ChainStay(profile_x01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
        dict set projDict   Scalar      ChainStay profile_x02               $::bikeGeometry::ChainStay(profile_x02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
        dict set projDict   Scalar      ChainStay profile_x03               $::bikeGeometry::ChainStay(profile_x03)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x03             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
        dict set projDict   Scalar      ChainStay profile_y00               $::bikeGeometry::ChainStay(profile_y00)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y00             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
        dict set projDict   Scalar      ChainStay profile_y01               $::bikeGeometry::ChainStay(profile_y01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
        dict set projDict   Scalar      ChainStay profile_y02               $::bikeGeometry::ChainStay(profile_y02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        dict set projDict   Scalar      ChainStay segmentAngle_01           $::bikeGeometry::ChainStay(segmentAngle_01)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_01         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
        dict set projDict   Scalar      ChainStay segmentAngle_02           $::bikeGeometry::ChainStay(segmentAngle_02)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_02         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
        dict set projDict   Scalar      ChainStay segmentAngle_03           $::bikeGeometry::ChainStay(segmentAngle_03)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_03         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
        dict set projDict   Scalar      ChainStay segmentAngle_04           $::bikeGeometry::ChainStay(segmentAngle_04)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_04         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
        dict set projDict   Scalar      ChainStay segmentLength_01          $::bikeGeometry::ChainStay(segmentLength_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
        dict set projDict   Scalar      ChainStay segmentLength_02          $::bikeGeometry::ChainStay(segmentLength_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
        dict set projDict   Scalar      ChainStay segmentLength_03          $::bikeGeometry::ChainStay(segmentLength_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
        dict set projDict   Scalar      ChainStay segmentLength_04          $::bikeGeometry::ChainStay(segmentLength_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
        dict set projDict   Scalar      ChainStay segmentRadius_01          $::bikeGeometry::ChainStay(segmentRadius_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
        dict set projDict   Scalar      ChainStay segmentRadius_02          $::bikeGeometry::ChainStay(segmentRadius_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
        dict set projDict   Scalar      ChainStay segmentRadius_03          $::bikeGeometry::ChainStay(segmentRadius_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
        dict set projDict   Scalar      ChainStay segmentRadius_04          $::bikeGeometry::ChainStay(segmentRadius_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
            #            
        dict set projDict   Scalar      CrankSet ArmWidth                   $::bikeGeometry::CrankSet(ArmWidth)                             ;#[bikeGeometry::get_Scalar           CrankSet ArmWidth                 ]                ;# set _lastValue(Component/CrankSet/ArmWidth)                             
        dict set projDict   Scalar      CrankSet ChainLine                  $::bikeGeometry::CrankSet(ChainLine)                            ;#[bikeGeometry::get_Scalar           CrankSet ChainLine                ]                ;# set _lastValue(Component/CrankSet/ChainLine)                            
        dict set projDict   Scalar      CrankSet ChainRingOffset            $::bikeGeometry::CrankSet(ChainRingOffset)                                     
        dict set projDict   Scalar      CrankSet Length                     $::bikeGeometry::CrankSet(Length)                               ;#[bikeGeometry::get_Scalar           CrankSet Length                   ]                ;# set _lastValue(Component/CrankSet/Length)                               
        dict set projDict   Scalar      CrankSet PedalEye                   $::bikeGeometry::CrankSet(PedalEye)                             ;#[bikeGeometry::get_Scalar           CrankSet PedalEye                 ]                ;# set _lastValue(Component/CrankSet/PedalEye)                             
        dict set projDict   Scalar      CrankSet Q-Factor                   $::bikeGeometry::CrankSet(Q-Factor)                             ;#[bikeGeometry::get_Scalar           CrankSet Q-Factor                 ]                ;# set _lastValue(Component/CrankSet/Q-Factor)                             
            #
        dict set projDict   Scalar      DownTube DiameterBB                 $::bikeGeometry::DownTube(DiameterBB)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterBB               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
        dict set projDict   Scalar      DownTube DiameterHT                 $::bikeGeometry::DownTube(DiameterHT)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterHT               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
        dict set projDict   Scalar      DownTube OffsetBB                   $::bikeGeometry::DownTube(OffsetBB)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetBB                 ]                ;# set _lastValue(Custom/DownTube/OffsetBB)                                
        dict set projDict   Scalar      DownTube OffsetHT                   $::bikeGeometry::DownTube(OffsetHT)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetHT                 ]                ;# set _lastValue(Custom/DownTube/OffsetHT)                                
        dict set projDict   Scalar      DownTube TaperLength                $::bikeGeometry::DownTube(TaperLength)                          ;#[bikeGeometry::get_Scalar           DownTube TaperLength              ]                ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
            #            
        dict set projDict   Scalar      Fork BladeBendRadius                $::bikeGeometry::Fork(BladeBendRadius)                          ;#[bikeGeometry::get_Scalar           Fork BladeBendRadius              ]                ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
        dict set projDict   Scalar      Fork BladeDiameterDO                $::bikeGeometry::Fork(BladeDiameterDO)                          ;#[bikeGeometry::get_Scalar           Fork BladeDiameterDO              ]                ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
        dict set projDict   Scalar      Fork BladeEndLength                 $::bikeGeometry::Fork(BladeEndLength)                           ;#[bikeGeometry::get_Scalar           Fork BladeEndLength               ]                ;# set _lastValue(Component/Fork/Blade/EndLength)                          
        dict set projDict   Scalar      Fork BladeOffsetCrown               $::bikeGeometry::Fork(BladeOffsetCrown)                         ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrown             ]                ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
        dict set projDict   Scalar      Fork BladeOffsetCrownPerp           $::bikeGeometry::Fork(BladeOffsetCrownPerp)                     ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrownPerp         ]                ;# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
        dict set projDict   Scalar      Fork BladeOffsetDO                  $::bikeGeometry::Fork(BladeOffsetDO)                            ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDO                ]                ;# set _lastValue(Component/Fork/DropOut/Offset)                           
        dict set projDict   Scalar      Fork BladeOffsetDOPerp              $::bikeGeometry::Fork(BladeOffsetDOPerp)                        ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDOPerp            ]                ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
        dict set projDict   Scalar      Fork BladeTaperLength               $::bikeGeometry::Fork(BladeTaperLength)                         ;#[bikeGeometry::get_Scalar           Fork BladeTaperLength             ]                ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
        dict set projDict   Scalar      Fork BladeWidth                     $::bikeGeometry::Fork(BladeWidth)                               ;#[bikeGeometry::get_Scalar           Fork BladeWidth                   ]                ;# set _lastValue(Component/Fork/Blade/Width)                              
        dict set projDict   Scalar      Fork CrownAngleBrake                $::bikeGeometry::Fork(CrownAngleBrake)                          ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
        dict set projDict   Scalar      Fork CrownOffsetBrake               $::bikeGeometry::Fork(CrownOffsetBrake)                         ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
            # dict set projDict   Scalar      Fork BrakeAngle               $::bikeGeometry::Fork(BrakeAngle)                               ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
            # dict set projDict   Scalar      Fork BrakeOffset              $::bikeGeometry::Fork(BrakeOffset)                              ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
        dict set projDict   Scalar      Fork BladeBrakeOffset               $::bikeGeometry::Fork(BladeBrakeOffset)                         ;
        dict set projDict   Scalar      Fork Rake                           $::bikeGeometry::Fork(Rake)                                 ;
            
            
            #            
        dict set projDict   Scalar      FrontBrake LeverLength              $::bikeGeometry::FrontBrake(LeverLength)                        ;#[bikeGeometry::get_Scalar           FrontBrake LeverLength            ]                ;# set _lastValue(Component/Brake/Front/LeverLength)                       
        dict set projDict   Scalar      FrontBrake Offset                   $::bikeGeometry::FrontBrake(Offset)                             ;#[bikeGeometry::get_Scalar           FrontBrake Offset                 ]                ;# set _lastValue(Component/Brake/Front/Offset)                            
        dict set projDict   Scalar      FrontCarrier x                      $::bikeGeometry::FrontCarrier(x)                                ;#[bikeGeometry::get_Scalar           FrontCarrier x                    ]                ;# set _lastValue(Component/Carrier/Front/x)                               
        dict set projDict   Scalar      FrontCarrier y                      $::bikeGeometry::FrontCarrier(y)                                ;#[bikeGeometry::get_Scalar           FrontCarrier y                    ]                ;# set _lastValue(Component/Carrier/Front/y)                               
        dict set projDict   Scalar      FrontDerailleur Distance            $::bikeGeometry::FrontDerailleur(Distance)                      ;#[bikeGeometry::get_Scalar           FrontDerailleur Distance          ]                ;# set _lastValue(Component/Derailleur/Front/Distance)                     
        dict set projDict   Scalar      FrontDerailleur Offset              $::bikeGeometry::FrontDerailleur(Offset)                        ;#[bikeGeometry::get_Scalar           FrontDerailleur Offset            ]                ;# set _lastValue(Component/Derailleur/Front/Offset)                       
        dict set projDict   Scalar      FrontFender Height                  $::bikeGeometry::FrontFender(Height)                            ;#[bikeGeometry::get_Scalar           FrontFender Height                ]                ;# set _lastValue(Component/Fender/Front/Height)                           
        dict set projDict   Scalar      FrontFender OffsetAngle             $::bikeGeometry::FrontFender(OffsetAngle)                       ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngle           ]                ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
        dict set projDict   Scalar      FrontFender OffsetAngleFront        $::bikeGeometry::FrontFender(OffsetAngleFront)                  ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngleFront      ]                ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
        dict set projDict   Scalar      FrontFender Radius                  $::bikeGeometry::FrontFender(Radius)                            ;#[bikeGeometry::get_Scalar           FrontFender Radius                ]                ;# set _lastValue(Component/Fender/Front/Radius)                           
        dict set projDict   Scalar      FrontWheel RimHeight                $::bikeGeometry::FrontWheel(RimHeight)                          ;#[bikeGeometry::get_Scalar           FrontWheel RimHeight              ]                ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
            #            
        dict set projDict   Scalar      Geometry BottomBracket_Depth            $::bikeGeometry::Geometry(BottomBracket_Depth)                  ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Depth      ]                ;# set _lastValue(Custom/BottomBracket/Depth)                              
        dict set projDict   Scalar      Geometry BottomBracket_Offset_Excenter  $::bikeGeometry::Geometry(BottomBracket_Offset_Excenter)        ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Height     ]                ;# set _lastValue(Result/Length/BottomBracket/Height)                      
        dict set projDict   Scalar      Geometry BottomBracket_Height           $::bikeGeometry::Geometry(BottomBracket_Height)                 ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Height     ]                ;# set _lastValue(Result/Length/BottomBracket/Height)                      
        dict set projDict   Scalar      Geometry ChainStay_Length               $::bikeGeometry::Geometry(ChainStay_Length)                     ;#[bikeGeometry::get_Scalar           Geometry ChainStay_Length         ]                ;# set _lastValue(Custom/WheelPosition/Rear)                               
        dict set projDict   Scalar      Geometry FrontRim_Diameter              $::bikeGeometry::Geometry(FrontRim_Diameter)                    ;#[bikeGeometry::get_Scalar           FrontWheel RimDiameter            ]                ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
        dict set projDict   Scalar      Geometry FrontTyre_Height               $::bikeGeometry::Geometry(FrontTyre_Height)                     ;#[bikeGeometry::get_Scalar           FrontWheel TyreHeight             ]                ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
        dict set projDict   Scalar      Geometry FrontWheel_Radius              $::bikeGeometry::Geometry(FrontWheel_Radius)                    ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_Radius        ]                ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
        dict set projDict   Scalar      Geometry FrontWheel_x                   $::bikeGeometry::Geometry(FrontWheel_x)                         ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_x             ]                ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
        dict set projDict   Scalar      Geometry FrontWheel_xy                  $::bikeGeometry::Geometry(FrontWheel_xy)                        ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_xy            ]                ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
        dict set projDict   Scalar      Geometry HandleBar_Distance             $::bikeGeometry::Geometry(HandleBar_Distance)                   ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Distance       ]                ;# set _lastValue(Personal/HandleBar_Distance)                             
        dict set projDict   Scalar      Geometry HandleBar_Height               $::bikeGeometry::Geometry(HandleBar_Height)                     ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Height         ]                ;# set _lastValue(Personal/HandleBar_Height)                               
        dict set projDict   Scalar      Geometry HeadTube_Angle                 $::bikeGeometry::Geometry(HeadTube_Angle)                       ;#[bikeGeometry::get_Scalar           Geometry HeadTube_Angle           ]                ;# set _lastValue(Custom/HeadTube/Angle)                                   
        dict set projDict   Scalar      Geometry Inseam_Length                  $::bikeGeometry::Geometry(Inseam_Length)                        ;#[bikeGeometry::get_Scalar           Geometry Inseam_Length            ]                ;# set _lastValue(Personal/InnerLeg_Length)                                
        dict set projDict   Scalar      Geometry Reach_Length                   $::bikeGeometry::Geometry(Reach_Length)                         ;#[bikeGeometry::get_Scalar           Geometry ReachLengthResult        ]                ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
        dict set projDict   Scalar      Geometry RearRim_Diameter               $::bikeGeometry::Geometry(RearRim_Diameter)                     ;#[bikeGeometry::get_Scalar           RearWheel RimDiameter             ]                ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
        dict set projDict   Scalar      Geometry RearTyre_Height                $::bikeGeometry::Geometry(RearTyre_Height)                      ;#[bikeGeometry::get_Scalar           RearWheel TyreHeight              ]                ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
        dict set projDict   Scalar      Geometry RearWheel_Radius               $::bikeGeometry::Geometry(RearWheel_Radius)                     ;#[bikeGeometry::get_Scalar           Geometry RearWheel_Radius         ]                ;# set _lastValue(Result/Length/RearWheel/Radius)                          
        dict set projDict   Scalar      Geometry RearWheel_x                    $::bikeGeometry::Geometry(RearWheel_x)                          ;#[bikeGeometry::get_Scalar           Geometry RearWheel_x              ]                ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        dict set projDict   Scalar      Geometry SaddleNose_BB_x                $::bikeGeometry::Geometry(SaddleNose_BB_x)                      ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_BB_x          ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
        dict set projDict   Scalar      Geometry SaddleNose_HB                  $::bikeGeometry::Geometry(SaddleNose_HB)                        ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_HB            ]                ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
        dict set projDict   Scalar      Geometry Saddle_BB                      $::bikeGeometry::Geometry(Saddle_BB)                            ;#[bikeGeometry::get_Scalar           Geometry Saddle_BB                ]                ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
        dict set projDict   Scalar      Geometry Saddle_Distance                $::bikeGeometry::Geometry(Saddle_Distance)                      ;#[bikeGeometry::get_Scalar           Geometry Saddle_Distance          ]                ;# set _lastValue(Personal/Saddle_Distance)                                
        dict set projDict   Scalar      Geometry Saddle_HB_x                    $::bikeGeometry::Geometry(Saddle_HB_x)                                       
        dict set projDict   Scalar      Geometry Saddle_HB_y                    $::bikeGeometry::Geometry(Saddle_HB_y)                          ;#[bikeGeometry::get_Scalar           Geometry Saddle_HB_y              ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Height                  $::bikeGeometry::Geometry(Saddle_Height)                        ;#[bikeGeometry::get_Scalar           Geometry Saddle_Height            ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Offset_BB_ST            $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)                  ;#[bikeGeometry::get_Scalar           Geometry Saddle_Offset_BB_ST      ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
        dict set projDict   Scalar      Geometry SeatTube_LengthClassic         $::bikeGeometry::Geometry(SeatTube_LengthClassic)               
        dict set projDict   Scalar      Geometry SeatTube_LengthVirtual         $::bikeGeometry::Geometry(SeatTube_LengthVirtual)               ;#[bikeGeometry::get_Scalar           Geometry SeatTubeVirtual          ]                ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
        dict set projDict   Scalar      Geometry Stack_Height                   $::bikeGeometry::Geometry(Stack_Height)                         ;#[bikeGeometry::get_Scalar           Geometry StackHeightResult        ]                ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
        dict set projDict   Scalar      Geometry Stem_Angle                     $::bikeGeometry::Geometry(Stem_Angle)                           ;#[bikeGeometry::get_Scalar           Geometry Stem_Angle               ]                ;# set _lastValue(Component/Stem/Angle)                                    
        dict set projDict   Scalar      Geometry Stem_Length                    $::bikeGeometry::Geometry(Stem_Length)                          ;#[bikeGeometry::get_Scalar           Geometry Stem_Length              ]                ;# set _lastValue(Component/Stem/Length)                                   
        dict set projDict   Scalar      Geometry TopTube_LengthClassic          $::bikeGeometry::Geometry(TopTube_LengthClassic)
        dict set projDict   Scalar      Geometry TopTube_LengthVirtual          $::bikeGeometry::Geometry(TopTube_LengthVirtual)                ;#[bikeGeometry::get_Scalar           Geometry TopTubeVirtual           ]                ;# set _lastValue(Result/Length/TopTube/VirtualLength)                     
        dict set projDict   Scalar      Geometry TopTube_Angle                  $::bikeGeometry::Geometry(TopTube_Angle)                        ;#[bikeGeometry::get_Scalar           Geometry TopTube_Angle            ]                ;# set _lastValue(Custom/TopTube/Angle)                                    
        dict set projDict   Scalar      Geometry SeatTube_Angle                 $::bikeGeometry::Geometry(SeatTube_Angle)                       ;#[bikeGeometry::get_Scalar           SeatTube Angle                    ]                ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
        dict set projDict   Scalar      Geometry Fork_Height                    $::bikeGeometry::Geometry(Fork_Height)                          ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry Fork_Rake                      $::bikeGeometry::Geometry(Fork_Rake)                            ;#[bikeGeometry::get_Scalar           Fork Rake                         ]                ;# set _lastValue(Component/Fork/Rake)                                     
        dict set projDict   Scalar      Geometry HeadTube_Length                $::bikeGeometry::Geometry(HeadTube_Length)                      ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry HeadTube_Summary               $::bikeGeometry::Geometry(HeadTube_Summary)                     ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry HeadSet_Bottom                 $::bikeGeometry::Geometry(HeadSet_Bottom)
            # 
        dict set projDict   Scalar      Geometry BottomBracket_Angle_ChainStay  $::bikeGeometry::Geometry(BottomBracket_Angle_ChainStay)                                
        dict set projDict   Scalar      Geometry BottomBracket_Angle_DownTube   $::bikeGeometry::Geometry(BottomBracket_Angle_DownTube)                                
        dict set projDict   Scalar      Geometry HeadLug_Angle_Bottom           $::bikeGeometry::Geometry(HeadLug_Angle_Bottom)                                
            #
        dict set projDict   Scalar      Geometry HeadLug_Angle_Top          $::bikeGeometry::Geometry(HeadLug_Angle_Top)                    ;#[bikeGeometry::get_Scalar           Result Angle_HeadTubeTopTube      ]                ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
        dict set projDict   Scalar      Geometry HeadTube_Virtual           $::bikeGeometry::Geometry(HeadTube_Virtual)                     ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        dict set projDict   Scalar      Geometry HeadTube_CenterTopTube     $::bikeGeometry::Geometry(HeadTube_CenterTopTube)                     ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        dict set projDict   Scalar      Geometry HeadTube_CenterDownTube    $::bikeGeometry::Geometry(HeadTube_CenterDownTube)                     ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
            #
        dict set projDict   Scalar      HandleBar PivotAngle                $::bikeGeometry::HandleBar(PivotAngle)                          ;#[bikeGeometry::get_Scalar           HandleBar PivotAngle              ]                ;# set _lastValue(Component/HandleBar/PivotAngle)                          
        dict set projDict   Scalar      HeadSet Diameter                    $::bikeGeometry::HeadSet(Diameter)                              ;#[bikeGeometry::get_Scalar           HeadSet Diameter                  ]                ;# set _lastValue(Component/HeadSet/Diameter)                              
        dict set projDict   Scalar      HeadSet Height_Bottom               $::bikeGeometry::HeadSet(Height_Bottom)                         ;#[bikeGeometry::get_Scalar           HeadSet Height_Bottom             ]                ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
        dict set projDict   Scalar      HeadSet Height_Top                  $::bikeGeometry::HeadSet(Height_Top)                            ;#[bikeGeometry::get_Scalar           HeadSet Height_Top                ]                ;# set _lastValue(Component/HeadSet/Height/Top)                            
            #
        dict set projDict   Scalar      HeadTube Diameter                   $::bikeGeometry::HeadTube(Diameter)                             ;#[bikeGeometry::get_Scalar           HeadTube Diameter                 ]                ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
        dict set projDict   Scalar      HeadTube Length                     $::bikeGeometry::HeadTube(Length)                               ;#[bikeGeometry::get_Scalar           HeadTube Length                   ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                                     
        dict set projDict   Scalar      HeadTube DiameterTaperedTop         $::bikeGeometry::HeadTube(DiameterTaperedTop)            
        dict set projDict   Scalar      HeadTube DiameterTaperedBase        $::bikeGeometry::HeadTube(DiameterTaperedBase)           
        dict set projDict   Scalar      HeadTube HeightTaperedBase          $::bikeGeometry::HeadTube(HeightTaperedBase)             
        dict set projDict   Scalar      HeadTube LengthTapered              $::bikeGeometry::HeadTube(LengthTapered)            

            #            
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Angle      $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Angle        ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Tolerance  $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Tolerance    ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Angle       $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Angle         ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Tolerance   $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Tolerance     ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Angle               $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Angle         ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Tolerance           $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Tolerance     ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs HeadLug_Top_Angle                  $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Angle            ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs HeadLug_Top_Tolerance              $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Tolerance        ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
        dict set projDict   Scalar      Lugs RearDropOut_Angle                  $::bikeGeometry::Lugs(RearDropOut_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Angle            ]                ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
        dict set projDict   Scalar      Lugs RearDropOut_Tolerance              $::bikeGeometry::Lugs(RearDropOut_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Tolerance        ]                ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Angle             $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Angle       ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Tolerance         $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Tolerance   ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Angle              $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Angle        ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Tolerance          $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Tolerance    ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
            #            
        dict set projDict   Scalar      RearBrake   LeverLength                 $::bikeGeometry::RearBrake(LeverLength)                     ;#[bikeGeometry::get_Scalar           RearBrake LeverLength             ]                ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
        dict set projDict   Scalar      RearBrake   Offset                      $::bikeGeometry::RearBrake(Offset)                          ;#[bikeGeometry::get_Scalar           RearBrake Offset                  ]                ;# set _lastValue(Component/Brake/Rear/Offset)                             
        dict set projDict   Scalar      RearCarrier x                           $::bikeGeometry::RearCarrier(x)                             ;#[bikeGeometry::get_Scalar           RearCarrier x                     ]                ;# set _lastValue(Component/Carrier/Rear/x)                                
        dict set projDict   Scalar      RearCarrier y                           $::bikeGeometry::RearCarrier(y)                             ;#[bikeGeometry::get_Scalar           RearCarrier y                     ]                ;# set _lastValue(Component/Carrier/Rear/y)                                
        dict set projDict   Scalar      RearDerailleur Pulley_teeth             $::bikeGeometry::RearDerailleur(Pulley_teeth)               ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_teeth       ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
        dict set projDict   Scalar      RearDerailleur Pulley_x                 $::bikeGeometry::RearDerailleur(Pulley_x)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_x           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
        dict set projDict   Scalar      RearDerailleur Pulley_y                 $::bikeGeometry::RearDerailleur(Pulley_y)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_y           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
            #            
        dict set projDict   Scalar      RearDropout Derailleur_x                $::bikeGeometry::RearDropout(Derailleur_x)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_x          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
        dict set projDict   Scalar      RearDropout Derailleur_y                $::bikeGeometry::RearDropout(Derailleur_y)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_y          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
        dict set projDict   Scalar      RearDropout OffsetCS                    $::bikeGeometry::RearDropout(OffsetCS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS              ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
        dict set projDict   Scalar      RearDropout OffsetCSPerp                $::bikeGeometry::RearDropout(OffsetCSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetCSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
        dict set projDict   Scalar      RearDropout OffsetCS_TopView            $::bikeGeometry::RearDropout(OffsetCS_TopView)              ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS_TopView      ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
        dict set projDict   Scalar      RearDropout OffsetSS                    $::bikeGeometry::RearDropout(OffsetSS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetSS              ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
        dict set projDict   Scalar      RearDropout OffsetSSPerp                $::bikeGeometry::RearDropout(OffsetSSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetSSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
        dict set projDict   Scalar      RearDropout RotationOffset              $::bikeGeometry::RearDropout(RotationOffset)                ;#[bikeGeometry::get_Scalar           RearDropout RotationOffset        ]                ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
            #            
        dict set projDict   Scalar      RearFender  Height                      $::bikeGeometry::RearFender(Height)                         ;#[bikeGeometry::get_Scalar           RearFender Height                 ]                ;# set _lastValue(Component/Fender/Rear/Height)                            
        dict set projDict   Scalar      RearFender  OffsetAngle                 $::bikeGeometry::RearFender(OffsetAngle)                    ;#[bikeGeometry::get_Scalar           RearFender OffsetAngle            ]                ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
        dict set projDict   Scalar      RearFender  Radius                      $::bikeGeometry::RearFender(Radius)                         ;#[bikeGeometry::get_Scalar           RearFender Radius                 ]                ;# set _lastValue(Component/Fender/Rear/Radius)                            
        dict set projDict   Scalar      RearMockup  CassetteClearance           $::bikeGeometry::RearMockup(CassetteClearance)              ;#[bikeGeometry::get_Scalar           RearMockup CassetteClearance      ]                ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
        dict set projDict   Scalar      RearMockup  ChainWheelClearance         $::bikeGeometry::RearMockup(ChainWheelClearance)            ;#[bikeGeometry::get_Scalar           RearMockup ChainWheelClearance    ]                ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
        dict set projDict   Scalar      RearMockup  CrankClearance              $::bikeGeometry::RearMockup(CrankClearance)                 ;#[bikeGeometry::get_Scalar           RearMockup CrankClearance         ]                ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
        dict set projDict   Scalar      RearMockup  DiscClearance               $::bikeGeometry::RearMockup(DiscClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup DiscClearance          ]                ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
        dict set projDict   Scalar      RearMockup  DiscDiameter                $::bikeGeometry::RearMockup(DiscDiameter)                   ;#[bikeGeometry::get_Scalar           RearMockup DiscDiameter           ]                ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
        dict set projDict   Scalar      RearMockup  DiscOffset                  $::bikeGeometry::RearMockup(DiscOffset)                     ;#[bikeGeometry::get_Scalar           RearMockup DiscOffset             ]                ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
        dict set projDict   Scalar      RearMockup  DiscWidth                   $::bikeGeometry::RearMockup(DiscWidth)                      ;#[bikeGeometry::get_Scalar           RearMockup DiscWidth              ]                ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
        dict set projDict   Scalar      RearMockup  TyreClearance               $::bikeGeometry::RearMockup(TyreClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup TyreClearance          ]                ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
            #            
        dict set projDict   Scalar      RearWheel   FirstSprocket               $::bikeGeometry::RearWheel(FirstSprocket)                   ;#[bikeGeometry::get_Scalar           RearWheel FirstSprocket           ]                ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
        dict set projDict   Scalar      RearWheel   HubWidth                    $::bikeGeometry::RearWheel(HubWidth)                        ;#[bikeGeometry::get_Scalar           RearWheel HubWidth                ]                ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
        dict set projDict   Scalar      RearWheel   RimHeight                   $::bikeGeometry::RearWheel(RimHeight)                       ;#[bikeGeometry::get_Scalar           RearWheel RimHeight               ]                ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
        dict set projDict   Scalar      RearWheel   TyreShoulder                $::bikeGeometry::RearWheel(TyreShoulder)                    ;#[bikeGeometry::get_Scalar           RearWheel TyreShoulder            ]                ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
        dict set projDict   Scalar      RearWheel   TyreWidth                   $::bikeGeometry::RearWheel(TyreWidth)                       ;#[bikeGeometry::get_Scalar           RearWheel TyreWidth               ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
        dict set projDict   Scalar      RearWheel   TyreWidthRadius             $::bikeGeometry::RearWheel(TyreWidthRadius)                 ;#[bikeGeometry::get_Scalar           RearWheel TyreWidthRadius         ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
            #            
        dict set projDict   Scalar      Reference   HandleBar_Distance          $::bikeGeometry::Reference(HandleBar_Distance)              ;#[bikeGeometry::get_Scalar           Reference HandleBar_Distance      ]                ;# set _lastValue(Reference/HandleBar_Distance)                            
        dict set projDict   Scalar      Reference   HandleBar_Height            $::bikeGeometry::Reference(HandleBar_Height)                ;#[bikeGeometry::get_Scalar           Reference HandleBar_Height        ]                ;# set _lastValue(Reference/HandleBar_Height)                              
        dict set projDict   Scalar      Reference   SaddleNose_Distance         $::bikeGeometry::Reference(SaddleNose_Distance)             ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Distance     ]                ;# set _lastValue(Reference/SaddleNose_Distance)                           
        dict set projDict   Scalar      Reference   SaddleNose_HB               $::bikeGeometry::Reference(SaddleNose_HB)                   ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB           ]                ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
        dict set projDict   Scalar      Reference   SaddleNose_HB_y             $::bikeGeometry::Reference(SaddleNose_HB_y)                 ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB_y         ]                ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
        dict set projDict   Scalar      Reference   SaddleNose_Height           $::bikeGeometry::Reference(SaddleNose_Height)               ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Height       ]                ;# set _lastValue(Reference/SaddleNose_Height)                             
            #            
        dict set projDict   Scalar      Saddle      Height                      $::bikeGeometry::Saddle(Height)                             ;#[bikeGeometry::get_Scalar           Saddle Height                     ]                ;# set _lastValue(Personal/Saddle_Height)                                  
        dict set projDict   Scalar      Saddle      NoseLength                  $::bikeGeometry::Saddle(NoseLength)                         ;#[bikeGeometry::get_Scalar           Saddle NoseLength                 ]                ;# set _lastValue(Component/Saddle/LengthNose)     
        dict set projDict   Scalar      Saddle      Offset_x                    $::bikeGeometry::Saddle(Offset_x)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_x                   ]                ;# set _lastValue(Rendering/Saddle/Offset_X)                               
            #            
        dict set projDict   Scalar      SeatPost    Diameter                    $::bikeGeometry::SeatPost(Diameter)                         ;#[bikeGeometry::get_Scalar           SeatPost Diameter                 ]                ;# set _lastValue(Component/SeatPost/Diameter)                             
        dict set projDict   Scalar      SeatPost    PivotOffset                 $::bikeGeometry::SeatPost(PivotOffset)                      ;#[bikeGeometry::get_Scalar           SeatPost PivotOffset              ]                ;# set _lastValue(Component/SeatPost/PivotOffset)                          
        dict set projDict   Scalar      SeatPost    Setback                     $::bikeGeometry::SeatPost(Setback)                          ;#[bikeGeometry::get_Scalar           SeatPost Setback                  ]                ;# set _lastValue(Component/SeatPost/Setback)                              
        dict set projDict   Scalar      SeatStay    DiameterCS                  $::bikeGeometry::SeatStay(DiameterCS)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterCS               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
        dict set projDict   Scalar      SeatStay    DiameterST                  $::bikeGeometry::SeatStay(DiameterST)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterST               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
        dict set projDict   Scalar      SeatStay    OffsetTT                    $::bikeGeometry::SeatStay(OffsetTT)                         ;#[bikeGeometry::get_Scalar           SeatStay OffsetTT                 ]                ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
        dict set projDict   Scalar      SeatStay    SeatTubeMiterDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            ;#[bikeGeometry::get_Scalar           SeatStay SeatTubeMiterDiameter    ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
        dict set projDict   Scalar      SeatStay    TaperLength                 $::bikeGeometry::SeatStay(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatStay TaperLength              ]                ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
            #            
        dict set projDict   Scalar      SeatTube    DiameterBB                  $::bikeGeometry::SeatTube(DiameterBB)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterBB               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
        dict set projDict   Scalar      SeatTube    DiameterTT                  $::bikeGeometry::SeatTube(DiameterTT)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterTT               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
        dict set projDict   Scalar      SeatTube    Extension                   $::bikeGeometry::SeatTube(Extension)                        ;#[bikeGeometry::get_Scalar           SeatTube Extension                ]                ;# set _lastValue(Custom/SeatTube/Extension)                               
        dict set projDict   Scalar      SeatTube    OffsetBB                    $::bikeGeometry::SeatTube(OffsetBB)                         ;#[bikeGeometry::get_Scalar           SeatTube OffsetBB                 ]                ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
        dict set projDict   Scalar      SeatTube    TaperLength                 $::bikeGeometry::SeatTube(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatTube TaperLength              ]                ;# set _lastValue(FrameTubes/SeatTube/TaperLength) 
            #            
        dict set projDict   Scalar      TopTube     DiameterHT                  $::bikeGeometry::TopTube(DiameterHT)                        ;#[bikeGeometry::get_Scalar           TopTube  DiameterHT               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
        dict set projDict   Scalar      TopTube     DiameterST                  $::bikeGeometry::TopTube(DiameterST)                        ;#[bikeGeometry::get_Scalar           TopTube DiameterST                ]                ;# set _lastValue(Custom/TopTube/PivotPosition)                                        
        dict set projDict   Scalar      TopTube     OffsetHT                    $::bikeGeometry::TopTube(OffsetHT)                          ;#[bikeGeometry::get_Scalar           TopTube TaperLength               ] 
        dict set projDict   Scalar      TopTube     PivotPosition               $::bikeGeometry::TopTube(PivotPosition)                     ;#[bikeGeometry::get_Scalar           TopTube OffsetHT                  ] 
        dict set projDict   Scalar      TopTube     TaperLength                 $::bikeGeometry::TopTube(TaperLength)                       ;#[bikeGeometry::get_Scalar           TopTube PivotPosition             ]             
            #
            
        if 0 {    
                #            
            parray ::bikeGeometry::Geometry
            parray ::bikeGeometry::Component
            parray ::bikeGeometry::Config
            parray ::bikeGeometry::Reference
            parray ::bikeGeometry::ListValue
                #
            parray ::bikeGeometry::BottleCage
            parray ::bikeGeometry::BottomBracket
            parray ::bikeGeometry::ChainStay
            parray ::bikeGeometry::CrankSet
            parray ::bikeGeometry::DownTube
            parray ::bikeGeometry::Fork
            parray ::bikeGeometry::FrontBrake
            parray ::bikeGeometry::FrontCarrier
            parray ::bikeGeometry::FrontDerailleur
            parray ::bikeGeometry::FrontFender
            parray ::bikeGeometry::FrontWheel
            parray ::bikeGeometry::HandleBar
            parray ::bikeGeometry::HeadSet
            parray ::bikeGeometry::HeadTube
            parray ::bikeGeometry::Lugs
            parray ::bikeGeometry::RearBrake
            parray ::bikeGeometry::RearCarrier
            parray ::bikeGeometry::RearDerailleur
            parray ::bikeGeometry::RearDropout
            parray ::bikeGeometry::RearFender
            parray ::bikeGeometry::RearMockup
            parray ::bikeGeometry::RearWheel
            parray ::bikeGeometry::Saddle
            parray ::bikeGeometry::SeatPost
            parray ::bikeGeometry::SeatStay
            parray ::bikeGeometry::SeatTube
            parray ::bikeGeometry::TopTube
            #
        }
            #
        # project::pdict $projDict  4
            #
        return $projDict   
            #
        
    }

        #
    proc bikeGeometry::set_Scalar {object key value} {
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $value"
            #
            # -- check for existing parameter $object($key)
        if {[catch {array get [namespace current]::$object $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            #
            # -- check for values are mathematical values
        set newValue [bikeGeometry::check_mathValue $value] 
        if {$newValue == {}} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$value not accepted! ... $value"
            return {}
        }
            #
            # -- catch parameters that does not directly influence the model
        if 0 {
                exit
                switch -exact $object {
                    Geometry {
                            switch -exact $key {
                                {BottomBracket_Height}          {   bikeGeometry::set_Default_BottomBracketHeight    $newValue; return [get_Scalar $object $key] }
                                {FrontWheel_Radius}             {   bikeGeometry::set_Default_FrontWheelRadius       $newValue; return [get_Scalar $object $key] }
                                {FrontWheel_xy}                 {   bikeGeometry::set_Default_FrontWheeldiagonal     $newValue; return [get_Scalar $object $key] }
                                {FrontWheel_x}                  {   bikeGeometry::set_Default_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                                {HeadLug_Angle_Top}             {   bikeGeometry::set_Default_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                                {RearWheel_Radius}              {   bikeGeometry::set_Default_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                                {RearWheel_x}                   {   bikeGeometry::set_Default_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                                {SaddleNose_BB_x}               {   bikeGeometry::set_Default_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                                {SaddleNose_HB}                 {   bikeGeometry::set_Default_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                                {Saddle_BB}                     {   bikeGeometry::set_Default_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                                {Saddle_HB_x}                   {   bikeGeometry::set_Default_SaddleOffset_HB_X      $newValue; return [get_Scalar $object $key] }
                                {Saddle_HB_y}                   {   bikeGeometry::set_Default_SaddleOffset_HB_Y      $newValue; return [get_Scalar $object $key] }
                                {Saddle_Offset_BB_ST}           {   bikeGeometry::set_Default_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                                {SeatTube_Angle}                {   bikeGeometry::set_Default_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                                
                                {Reach_Length}                  {   bikeGeometry::set_StackReach_HeadTubeReachLength $newValue; return [get_Scalar $object $key] }
                                {Stack_Height}                  {   bikeGeometry::set_StackReach_HeadTubeStackHeight $newValue; return [get_Scalar $object $key] }
                                {HeadTube_Summary}              {   bikeGeometry::set_StackReach_HeadTubeSummary     $newValue; return [get_Scalar $object $key] }
                                
                                {SeatTube_LengthVirtual}        {   bikeGeometry::set_Classic__SeatTubeVirtualLength $newValue; return [get_Scalar $object $key] }
                                {TopTube_LengthVirtual}         {   bikeGeometry::set_Classic_TopTubeVirtualLength   $newValue; return [get_Scalar $object $key] }

                                {BottomBracket_Angle_ChainStay} {   bikeGeometry::model_lugAngle::set_Angle ChainStaySeatTube $newValue; return [get_Scalar $object $key] }                     
                                {BottomBracket_Angle_DownTube}  {   bikeGeometry::model_lugAngle::set_Angle SeatTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                                {HeadLug_Angle_Bottom}          {   bikeGeometry::model_lugAngle::set_Angle HeadTubeDownTube  $newValue; return [get_Scalar $object $key] }                     
                                
                                default {}
                            }
                        }
                    RearWheel {
                            switch -exact $key {
                                {TyreShoulder}              {   bikeGeometry::set_Result_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                                
                                default {}              
                            }
                        }
                    Reference {
                            switch -exact $key {
                                {SaddleNose_HB}             {   bikeGeometry::set_Result_ReferenceSaddleNose_HB $newValue; return [get_Scalar $object $key] }
                                {SaddleNose_HB_y}           {   bikeGeometry::set_Result_ReferenceHeigth_SN_HB  $newValue; return [get_Scalar $object $key] }

                                default {}              
                            }
                        }
                    default {}
                }
        }    
            #
            # -- set value to parameter
        array set [namespace current]::$object [list $key $newValue]
        bikeGeometry::update_Geometry
            #
        set scalarValue [bikeGeometry::get_Scalar $object $key ]
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $scalarValue"
            #
        return $scalarValue
            #
    }
        #
    proc bikeGeometry::set_ListValue {key value} { 
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::set_ListValue $key} eID]} {
            puts "\n              <W> bikeGeometry::set_ListValue ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::ListValue($key) $value
        bikeGeometry::update_Geometry
            #
        set listValue  [lindex [array get [namespace current]::ListValue $key] 1]
        puts "              <I> bikeGeometry::set_ListValue ... $key -> $listValue"
            #
        return $listValue    
    }    
        #
    proc bikeGeometry::set_Component {key value} {
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::Config $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Component ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::Component($key) $value
        bikeGeometry::update_Geometry
            #
        set componentValue  [bikeGeometry::get_Component $key]
        puts "              <I> bikeGeometry::set_Component ... $key -> $componentValue"
            #
        return $componentValue
            #
    }
        #
    proc bikeGeometry::set_Config {key value} {
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::Config $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Config ... \$key not accepted! ... $key / $value\n"
            return {}
        }  
            # -- set value to parameter
        set [namespace current]::Config($key) $value
        bikeGeometry::update_Geometry
            #
        set configValue [bikeGeometry::get_Config $key]
        puts "              <I> bikeGeometry::set_Config ... $key -> $configValue"
            #
        set [namespace current]::ConfigPrev($key) [bikeGeometry::get_Config $key]
            #
        return $configValue
            #
    }  
        #
        #
    proc bikeGeometry::get_Scalar {object key} {
        set scalarValue [lindex [array get [namespace current]::$object $key] 1]
        return $scalarValue    
    }
        #
    proc bikeGeometry::get_ListValue {key} { 
        set listValue   [lindex [array get [namespace current]::ListValue $key] 1]
        return $listValue    
    }    
        #
    proc bikeGeometry::get_Component {key} {
        set compFile    [lindex [array get [namespace current]::Component $key] 1]
        return $compFile
    } 
        #
    proc bikeGeometry::get_Config {key} {
        set configValue [lindex [array get [namespace current]::Config $key] 1]
        return $configValue
    }  
        #
        #
    proc bikeGeometry::get_Polygon {key {centerPoint {0 0}}} {
        set polygon     [lindex [array get [namespace current]::Polygon $key] 1]
        return [ vectormath::addVectorCoordList  $centerPoint  $polygon]
    }
        #
    proc bikeGeometry::get_Profile {key} {
        # parray [namespace current]::Polygon
        set polygon     [lindex [array get [namespace current]::Polygon $key] 1]
        return $polygon
    }
        #
    proc bikeGeometry::get_Position {key {centerPoint {0 0}}} {
        set position     [lindex [array get [namespace current]::Position $key] 1]
        return [ vectormath::addVector  $centerPoint  $position]                        
    }
    proc bikeGeometry::get_PositionList {} {
        return [array names [namespace current]::Position]                     
    }
        #
    proc bikeGeometry::get_Direction {key {type {polar}}} {
        set direction     [lindex [array get [namespace current]::Direction $key] 1]
            #
        switch -exact $type {
            degree  {   return [vectormath::angle {1 0} {0 0} $direction] }
            rad    -
            polar  -
            default {   return $direction}
        }
    }
    proc bikeGeometry::get_DirectionList {} {
        return [array names [namespace current]::Direction]                     
    }
        #
    proc bikeGeometry::get_NamespacePath {} {
        return [namespace current]                     
    }
    proc bikeGeometry::get_ArrayList {} {
        return [list Component Direction Geometry Polygon Position BoundingBox]
            # Project  
            # Geometry 
            # Reference
            # Component
            # Config   
            # ListValue
            # Result      
            # TubeMiter  
            # FrameJig   
            # RearMockup 
            # BoundingBox
    }
        #
    proc bikeGeometry::get_BoundingBox {key} {
        set boundingBox [lindex [array get [namespace current]::BoundingBox $key] 1]
        return $boundingBox
    }
        #
    proc bikeGeometry::get_CenterLine {key} {
        set centerLine  [lindex [array get [namespace current]::CenterLine $key] 1]
        return $centerLine
    }
        #
    proc bikeGeometry::get_CustomCrank {key} {
        set crankValue  [lindex [array get [namespace current]::CustomCrank $key] 1]
        return $crankValue
    }
        #
    proc bikeGeometry::get_TubeMiter {key} {
        set tubeMiter   [lindex [array get [namespace current]::TubeMiter $key] 1]
        return $tubeMiter
    }
        #
    proc bikeGeometry::get_TubeMiterDICT {} {
            #
        variable Direction
            #
        variable HeadTube
        variable SeatTube
        variable SeatStay
        variable TopTube
        variable DownTube
        variable TubeMiter
        variable BottomBracket
            #
        variable Position
            #
        variable Config
            #
        variable Result
            #
        
        set miterDict   [dict create    TopTube_Seat    {} \
                                        TopTube_Head    {} \
                                        DownTube_Head   {} \
                                        DownTube_Seat   {} \
                                        SeatTube_Down   {} \
                                        SeatStay_01     {} \
                                        SeatStay_02     {} \
                                        Reference       {} \
        ]

            #
        set key             TopTube_Seat
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         TopTube                          
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction TopTube    degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube                         
        dict set miterDict  $key    majorDiameter     $SeatTube(DiameterTT) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
            
            #
        set key             TopTube_Head
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         TopTube                          
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction TopTube    degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         HeadTube                          
        dict set miterDict  $key    majorDiameter     $HeadTube(Diameter) 
        dict set miterDict  $key    majorDirection    [get_Direction HeadTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
            
            #
        set key             DownTube_Head
        set minorDiameter   $::bikeGeometry::DownTube(DiameterHT)                       
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         DownTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction DownTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         HeadTube                     
        dict set miterDict  $key    majorDiameter     $HeadTube(Diameter) 
        dict set miterDict  $key    majorDirection    [get_Direction HeadTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    tubeType          {cylinder}  
        if {$Config(HeadTube) == {cylindric}} {
            dict set miterDict  $key    toolType      {cylinder}
        } else {
            dict set miterDict  $key    toolType      {cone}
            dict set miterDict  $key    baseDiameter  $HeadTube(DiameterTaperedBase)
            dict set miterDict  $key    topDiameter   $HeadTube(DiameterTaperedTop)   
            dict set miterDict  $key    baseHeight    $HeadTube(HeightTaperedBase)    
            dict set miterDict  $key    frustumHeight $HeadTube(LengthTapered)      
            dict set miterDict  $key    sectionPoint  [format {%.6f} [vectormath::length $Position(DownTube_End) $Position(HeadTube_Start)]]
        }            
                                    
            #
        set key     DownTube_Seat
        set minorDiameter   $::bikeGeometry::DownTube(DiameterBB)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         DownTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction DownTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube                     
        dict set miterDict  $key    majorDiameter     $SeatTube(DiameterBB) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    polygon_02        [list [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_in]  1] 0 end-4]] 
        dict set miterDict  $key    polygon_03        [list [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_out] 1] 0 end-4]] 
        dict set miterDict  $key    diameter_02       $BottomBracket(InsideDiameter)   
        dict set miterDict  $key    diameter_03       $BottomBracket(OutsideDiameter)   
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
        
            #
        set key             SeatTube_Down
        set minorDiameter   $::bikeGeometry::SeatTube(DiameterBB)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         SeatTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                            
        dict set miterDict  $key    minorDirection    [get_Direction SeatTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         DownTube                     
        dict set miterDict  $key    majorDiameter     $DownTube(DiameterBB) 
        dict set miterDict  $key    majorDirection    [get_Direction DownTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    polygon_02        [list [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_in]  1] 0 end-4]]  
        dict set miterDict  $key    polygon_03        [list [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_out] 1] 0 end-4]]
        dict set miterDict  $key    diameter_02       $BottomBracket(InsideDiameter)   
        dict set miterDict  $key    diameter_03       $BottomBracket(OutsideDiameter)
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
            #
        
            #
        set key             SeatStay_01
        set minorDiameter   $::bikeGeometry::SeatStay(DiameterST)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        set offset          [expr {0.5 * ($::bikeGeometry::SeatStay(SeatTubeMiterDiameter) - $::bikeGeometry::SeatStay(DiameterST))}]
            #
            #
        dict set miterDict  $key    minorName         SeatStay                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction SeatStay   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube(Lug)                     
        dict set miterDict  $key    majorDiameter     $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" $offset]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
        
            #
        set key     SeatStay_02
            #
        dict set miterDict  $key    minorName         SeatStay                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction SeatStay   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube(Lug)                     
        dict set miterDict  $key    majorDiameter     $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" $offset]
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
        
            #
        set key     Reference
            #
        dict set miterDict  $key    minorName         ReferenceWidth                         
        dict set miterDict  $key    majorName         ReferenceHeight                     
        dict set miterDict  $key    minorDiameter     0                             
        dict set miterDict  $key    minorDirection    0                        
        dict set miterDict  $key    minorPerimeter    100.00                        
        dict set miterDict  $key    majorDiameter     0 
        dict set miterDict  $key    majorDirection    1
        dict set miterDict  $key    offset            0.00                        
        dict set miterDict  $key    polygon_01        [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {plane}  
            
            #
            #           
        return $miterDict            
            #
    } 
        #
    proc bikeGeometry::get_TubeMiterDICT_org {} {
            #
        variable Direction
            #
        variable HeadTube
        variable SeatTube
        variable SeatStay
        variable TopTube
        variable DownTube
        variable TubeMiter
        variable BottomBracket
            #
        variable Position
            #
        variable Config
            #
        variable Result
            #
        
        set miterDict   [dict create    TopTube_Seat    {} \
                                        TopTube_Head    {} \
                                        DownTube_Head   {} \
                                        DownTube_Seat   {} \
                                        SeatTube_Down   {} \
                                        SeatStay_01     {} \
                                        SeatStay_02     {} \
                                        Reference       {} \
        ]

            #
        set key             TopTube_Seat
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         TopTube                          
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction TopTube    degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube                         
        dict set miterDict  $key    majorDiameter     $SeatTube(DiameterTT) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
            
            #
        set key             TopTube_Head
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         TopTube                          
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction TopTube    degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         HeadTube                          
        dict set miterDict  $key    majorDiameter     $HeadTube(Diameter) 
        dict set miterDict  $key    majorDirection    [get_Direction HeadTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
            
            #
        set key             DownTube_Head
        set minorDiameter   $::bikeGeometry::DownTube(DiameterHT)                       
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         DownTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction DownTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         HeadTube                     
        dict set miterDict  $key    majorDiameter     $HeadTube(Diameter) 
        dict set miterDict  $key    majorDirection    [get_Direction HeadTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    tubeType          {cylinder}  
        if {$Config(HeadTube) == {cylindric}} {
            dict set miterDict  $key    toolType      {cylinder}
        } else {
            dict set miterDict  $key    toolType      {cone}
            dict set miterDict  $key    baseDiameter  $HeadTube(DiameterTaperedBase)
            dict set miterDict  $key    topDiameter   $HeadTube(DiameterTaperedTop)   
            dict set miterDict  $key    baseHeight    $HeadTube(HeightTaperedBase)    
            dict set miterDict  $key    frustumHeight $HeadTube(LengthTapered)      
            dict set miterDict  $key    sectionPoint  [format {%.6f} [vectormath::length $Position(DownTube_End) $Position(HeadTube_Start)]]
        }            
                                    
            #
        set key     DownTube_Seat
        set minorDiameter   $::bikeGeometry::DownTube(DiameterBB)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         DownTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction DownTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube                     
        dict set miterDict  $key    majorDiameter     $SeatTube(DiameterBB) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    polygon_02        [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_in]  1] 0 end-4] 
        dict set miterDict  $key    polygon_03        [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_out] 1] 0 end-4] 
        dict set miterDict  $key    diameter_02       $BottomBracket(InsideDiameter)   
        dict set miterDict  $key    diameter_03       $BottomBracket(OutsideDiameter)   
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
        
            #
        set key             SeatTube_Down
        set minorDiameter   $::bikeGeometry::SeatTube(DiameterBB)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set miterDict  $key    minorName         SeatTube                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                            
        dict set miterDict  $key    minorDirection    [get_Direction SeatTube   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         DownTube                     
        dict set miterDict  $key    majorDiameter     $DownTube(DiameterBB) 
        dict set miterDict  $key    majorDirection    [get_Direction DownTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" 0]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    polygon_02        [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_in]  1] 0 end-4]  
        dict set miterDict  $key    polygon_03        [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_out] 1] 0 end-4]
        dict set miterDict  $key    diameter_02       $BottomBracket(InsideDiameter)   
        dict set miterDict  $key    diameter_03       $BottomBracket(OutsideDiameter)
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
            #
        
            #
        set key             SeatStay_01
        set minorDiameter   $::bikeGeometry::SeatStay(DiameterST)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        set offset          [expr {0.5 * ($::bikeGeometry::SeatStay(SeatTubeMiterDiameter) - $::bikeGeometry::SeatStay(DiameterST))}]
            #
            #
        dict set miterDict  $key    minorName         SeatStay                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction SeatStay   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube(Lug)                     
        dict set miterDict  $key    majorDiameter     $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" $offset]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
        
            #
        set key     SeatStay_02
            #
        dict set miterDict  $key    minorName         SeatStay                         
        dict set miterDict  $key    minorDiameter     $minorDiameter                             
        dict set miterDict  $key    minorDirection    [get_Direction SeatStay   degree]                        
        dict set miterDict  $key    minorPerimeter    $minorPerimeter                        
        dict set miterDict  $key    majorName         SeatTube(Lug)                     
        dict set miterDict  $key    majorDiameter     $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set miterDict  $key    majorDirection    [get_Direction SeatTube   degree]
        dict set miterDict  $key    offset            [format "%.3f" $offset]
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {cylinder}  
        
            #
        set key     Reference
            #
        dict set miterDict  $key    minorName         ReferenceWidth                         
        dict set miterDict  $key    majorName         ReferenceHeight                     
        dict set miterDict  $key    minorDiameter     0                             
        dict set miterDict  $key    minorDirection    0                        
        dict set miterDict  $key    minorPerimeter    100.00                        
        dict set miterDict  $key    majorDiameter     0 
        dict set miterDict  $key    majorDirection    1
        dict set miterDict  $key    offset            0.00                        
        dict set miterDict  $key    polygon_01        [lindex [array get [namespace current]::TubeMiter $key] 1]  
        dict set miterDict  $key    tubeType          {cylinder}  
        dict set miterDict  $key    toolType          {plane}  
            
            #
            #           
        return $miterDict            
            #
    } 
        #
    proc bikeGeometry::get_CustomCrankSetDICT {} {
            #
        # variable 
            #
        variable Result
            #
        
        set cranksetDict   [dict create crankArm    {} \
                                        crankSpider {} \
                                        ChainWheel  {} \
        ]
            # 
        # to be implemented    
        # ... see get_TubeMiterDICT  
            #
        return $cranksetDict            
            #
    } 
        #
    proc bikeGeometry::__remove__get_paramComponent {type args} {
            #
        variable Config    
        variable ListValue    
            #
        # set args [appUtil::flatten_nestedList $args]    
            #
        set visMode     "polyline"
        set armCount    __default__
        set bcDiameter  __default__
            #
        switch -exact $type {
            ChainWheelDefinition {
                        #
                        # teethCount
                        # position
                        # visMode
                        # armCount
                        # bcDiameter
                        #
                        #
                    return [bikeGeometry::paramComponent::_get_ChainWheelDefinition $ListValue(CrankSetChainRings) ]
                        #
                }
            ChainWheel {
                        #
                        # teethCount
                        # position
                        # visMode
                        # armCount
                        # bcDiameter
                        #
                    if {[llength $args] >= 2 } { 
                        set teethCount      [lindex $args 0]
                        set position        [lindex $args 1]
                        if {[llength $args] > 2 } {
                            set visMode     [lindex $args 2]
                        }
                        if {[llength $args] > 3 } {
                            set armCount    [lindex $args 3]
                        }
                        if {[llength $args] > 4 } {
                            set bcDiameter  [lindex $args 4]
                        }
                    } else {
                        return {}
                    }
                        #
                    return [bikeGeometry::paramComponent::_get_polygon_ChainWheel $teethCount $position $visMode $armCount $bcDiameter ]
                        #
                }
            CrankArm {
                    if {[llength $args] >= 2 } {
                        set crankLength [lindex $args 0]
                        set position    [lindex $args 1]
                    } else {
                        return {}
                    }
                        #
                    return [bikeGeometry::paramComponent::_get_polygon_CrankArm $crankLength $position]
                        #
                }
            CrankSpyder {
                        #
                    if {[llength $args] >= 2 } {
                        set bcDiameter  [lindex $args 0]
                        set position    [lindex $args 1]
                            # tk_messageBox -message " ... <$type> in proc bikeGeometry::get_paramComponent"
                        if {[llength $args] > 2 } {
                            set armCount    [lindex $args 2]
                        }
                    } else {
                        return {}
                    }
                        #
                    return [bikeGeometry::paramComponent::_get_polygon_CrankSpyder $bcDiameter $position $armCount]
                        #
                }
            ChainWheelBoltPosition {
                        #
                    if {[llength $args] >= 2 } {
                        set bcDiameter  [lindex $args 0]
                        set position    [lindex $args 1]
                        if {[llength $args] > 2 } {
                            set armCount    [lindex $args 2]
                        }
                    }  else {
                        return {}
                    }
                        #
                    return [bikeGeometry::paramComponent::_get_position_ChainWheelBolts $bcDiameter $position $armCount]
                        #
                }
            BoltCircleDiameter {
                        #
                    set bcRadius [bikeGeometry::paramComponent::__get_BCDiameter [lindex $args 0]]
                    return [expr {2 * $bcRadius}]
                        #
                }
            default {
                    tk_messageBox -message " ... <$type> not defined in proc bikeGeometry::get_paramComponent"
                    return {}
                }
        }
    }
        #
        #
        #
    proc bikeGeometry::get_ComponentDir {} {
            #
        variable packageHomeDir
            #
        set componentDir [file normalize [file join $packageHomeDir  .. etc  components]]
            #
        return $componentDir
            #
    }
        #
    proc bikeGeometry::get_ComponentDirectories {} {
            #
        variable initRoot
            #
        set dirList {} 
            #
        set locationNode    [$initRoot selectNodes /root/Options/ComponentLocation]
            #
        foreach childNode [$locationNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                set keyString  [$childNode getAttribute key {}]
                set dirString  [$childNode getAttribute dir {}]
                lappend dirList [list $keyString $dirString]
            }
        }            
            #
        return $dirList
            #
    }
    
        #
    proc bikeGeometry::get_ListBoxValues {} {    
            #
        variable initRoot
            #
        dict create dict_ListBoxValues {} 
            # variable valueRegistry
            # array set valueRegistry      {}
            #
        set optionNode    [$initRoot selectNodes /root/Options]
        foreach childNode [$optionNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    # puts "    init_ListBoxValues -> [$childNode nodeName]"
                set childNode_Name [$childNode nodeName]
                    # puts "    init_ListBoxValues -> $childNode_Name"
                    #
                    # set valueRegistry($childNode_Name) {}
                set nodeList {}
                    #
                foreach child_childNode [$childNode childNodes ] {
                    if {[$child_childNode nodeType] == {ELEMENT_NODE}} {
                          # puts "    ->$childNode_Name<"
                        switch -exact -- $childNode_Name {
                            {Rim} {
                                      # puts "    init_ListBoxValues (Rim) ->   $childNode_Name -> [$child_childNode nodeName]"
                                    set value_01 [$child_childNode getAttribute inch     {}]
                                    set value_02 [$child_childNode getAttribute metric   {}]
                                    set value_03 [$child_childNode getAttribute standard {}]
                                    if {$value_01 == {}} {
                                        set value {-----------------}
                                    } else {
                                        set value [format "%s ; %s %s" $value_02 $value_01 $value_03]
                                          # puts "   -> $value   <-> $value_02 $value_01 $value_03"
                                    }
                                        # lappend valueRegistry($childNode_Name)  $value
                                    lappend nodeList                        $value
                                }
                            {ComponentLocation} {}
                            default {
                                        # puts "    init_ListBoxValues (default) -> $childNode_Name -> [$child_childNode nodeName]"
                                    if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                                        # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                                    lappend nodeList                        [$child_childNode nodeName]
                                }
                        }
                    }
                }
                dict append dict_ListBoxValues $childNode_Name $nodeList
                
            }
        }
            #
            # puts "---"  
            #
        set forkNode        [$initRoot selectNodes /root/Fork]
        set childNode_Name  [$forkNode nodeName]
            # set valueRegistry($childNode_Name) {}
        set nodeList {}
        foreach child_childNode [$forkNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {            
                            # puts "    init_ListBoxValues -> $childNode_Name -> [$child_childNode nodeName]"
                        if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                            # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                        lappend nodeList                        [$child_childNode nodeName]
            }
        }
        dict append dict_ListBoxValues $childNode_Name $nodeList        
            #
          
            # 
            # exit          
            # parray valueRegistry
        # project::pdict $dict_ListBoxValues
            # exit
            #
        return $dict_ListBoxValues
            #
    }    
        #
        #
    proc bikeGeometry::get_DebugGeometry {} {
        # http://stackoverflow.com/questions/9676651/converting-a-list-to-an-array
        set dict_Geometry [array get ::bikeGeometry::DEBUG_Geometry]
        return $dict_Geometry
    }
        #
    #-------------------------------------------------------------------------
       #  check mathValue
    proc bikeGeometry::check_mathValue {value} {
                #
            puts "                  <1> bikeGeometry::check_mathValue $value"    
                # --- set new Value
            set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            if {[llength [split $newValue  ]] > 1} return {}
            if {[llength [split $newValue ;]] > 1} return {}
                #
            if { [catch { set newValue [expr {1.0 * $newValue}] } errorID] } {
                puts "\n                <E> bikeGeometry::check_mathValue"
                foreach line [split ${errorID} \n] {
                    puts "           $line"
                }
                puts ""
                return {}
            }
                #
                #
            set newValue [format "%.3f" $newValue]
                #
            puts "                  <2> bikeGeometry::check_mathValue $value  ->  $newValue"
                #
            return $newValue
                #
    }
    #-------------------------------------------------------------------------
       #  trace/update Project
    proc bikeGeometry::trace_Project {varname key operation} {
            if {$key != ""} {
        	    set varname ${varname}($key)
        	}
            upvar $varname var
                # value is 889 (operation w)
                # value is 889 (operation r)
            puts "trace_Prototype: (operation: $operation) $varname is $var "
    }
    #-------------------------------------------------------------------------
        #  add vector to list of coordinates
    proc bikeGeometry::coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr {-$y}]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
    }

    #-------------------------------------------------------------------------
        #  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
    proc bikeGeometry::coords_xy_index {coordlist index} {
            switch $index {
                {end} {
                      set index_y [expr {[llength $coordlist] - 1}]
                      set index_x [expr {[llength $coordlist] - 2}]
                    } 
                {end-1} {
                      set index_y [expr {[llength $coordlist] - 3}]
                      set index_x [expr {[llength $coordlist] - 4}]
                    }
                default {
                      set index_x [expr {2 * $index}]
                      set index_y [expr {$index_x + 1}]
                      if {$index_y > [llength $coordlist]} { return {0 0} }
                    }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }
    
    #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/440
        #
    proc bikeGeometry::flatten_nestedList { args } {
            if {[llength $args] == 0 } { return ""}
            set flatList {}
            foreach e [eval concat $args] {
                foreach ee $e { lappend flatList $ee }
            }
                # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
            return $flatList
    }
    #-------------------------------------------------------------------------
        #
    proc bikeGeometry::set_dictValue__ {dictPath dictValue args} {
            variable returnDict
                #
            puts "  ... set_dictValue"
            puts "      ... $dictPath  "
            #set command [format "dict set $returnDict %s \{%s\}"   $dictPath ${dictValue}]
			# set command [format "dict set projectDICT %s \{%s\}"   $dictPath ${dictValue}]
			    # puts "            ........ set value: $command"
			#{*}$command
            
            dict set returnDict $dictPath ${dictValue}
			    # dict set projectDICT Runtime ChainStay CenterLine angle_01 {-8.000}
			# return $dictionary
    }
    #-------------------------------------------------------------------------
        #
    proc bikeGeometry::get_dictValue__ {dictPath dictKey} {
            variable returnDict
              #
            set value "___undefined___"
           
            if { [catch {set value [dict get $returnDict {*}$dictPath $dictKey]} fid]} {
                puts "  <E> ... $fid"
                # exit
            } 
            return $value
    }
    #-------------------------------------------------------------------------
        #  get current projectDOM as Dictionary; moved to facade: myGUI::modelAdapter::AdapterBikeGeometry
    proc bikeGeometry::get_dictionaryGUIModel__ {} {
            #   return $project::projectDICT
        set projDict   [dict create]
            #
            #
            #
        dict set projDict   BoundingBox Summary                             $::bikeGeometry::BoundingBox(SummarySize)       
            #
        dict set projDict   CenterLine  ChainStay                           $::bikeGeometry::CenterLine(ChainStay)       
        dict set projDict   CenterLine  DownTube                            $::bikeGeometry::CenterLine(DownTube)        
        dict set projDict   CenterLine  ForkBlade                           $::bikeGeometry::CenterLine(ForkBlade)       
        dict set projDict   CenterLine  HeadTube                            $::bikeGeometry::CenterLine(HeadTube)        
        dict set projDict   CenterLine  RearMockup                          [list $::bikeGeometry::CenterLine(RearMockup)]
        dict set projDict   CenterLine  RearMockup_CtrLines                 [list $::bikeGeometry::CenterLine(RearMockup_CtrLines)]
        dict set projDict   CenterLine  RearMockup_UnCut                    [list $::bikeGeometry::CenterLine(RearMockup_UnCut)]
        dict set projDict   CenterLine  SeatStay                            $::bikeGeometry::CenterLine(SeatStay)        
        dict set projDict   CenterLine  SeatTube                            $::bikeGeometry::CenterLine(SeatTube)        
        dict set projDict   CenterLine  Steerer                             $::bikeGeometry::CenterLine(Steerer)         
        dict set projDict   CenterLine  TopTube                             $::bikeGeometry::CenterLine(TopTube)         
            #
        dict set projDict   Component   BottleCage_DownTube                 $::bikeGeometry::Component(BottleCage_DownTube)                                
        dict set projDict   Component   BottleCage_DownTube_Lower           $::bikeGeometry::Component(BottleCage_DownTube_Lower)                          
        dict set projDict   Component   BottleCage_SeatTube                 $::bikeGeometry::Component(BottleCage_SeatTube)                                
        dict set projDict   Component   CrankSet                            $::bikeGeometry::Component(CrankSet)                            ;#[bikeGeometry::get_Component        CrankSet                          ]                ;# set _lastValue(Component/CrankSet/File)                                 
        dict set projDict   Component   ForkCrown                           $::bikeGeometry::Component(ForkCrown)                           ;#[bikeGeometry::get_Component        Fork CrownFile                    ]                ;# set _lastValue(Component/Fork/Crown/File)                               
        dict set projDict   Component   ForkDropout                         $::bikeGeometry::Component(ForkDropout)                         ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set projDict   Component   ForkSupplier                        $::bikeGeometry::Component(ForkSupplier)                        ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set projDict   Component   FrontBrake                          $::bikeGeometry::Component(FrontBrake)                          ;#[bikeGeometry::get_Component        FrontBrake                        ]                ;# set _lastValue(Component/Brake/Front/File)                              
        dict set projDict   Component   FrontCarrier                        $::bikeGeometry::Component(FrontCarrier)                        ;#[bikeGeometry::get_Component        FrontCarrier                      ]                ;# set _lastValue(Component/Carrier/Front/File)                            
        dict set projDict   Component   FrontDerailleur                     $::bikeGeometry::Component(FrontDerailleur)                     ;#[bikeGeometry::get_Component        FrontDerailleur                   ]                ;# set _lastValue(Component/Derailleur/Front/File)                         
        dict set projDict   Component   HandleBar                           $::bikeGeometry::Component(HandleBar)                           ;#[bikeGeometry::get_Component        HandleBar                         ]                ;# set _lastValue(Component/HandleBar/File)                                
        dict set projDict   Component   Label                               $::bikeGeometry::Component(Label)                               ;#[bikeGeometry::get_Component        Logo                              ]                ;# set _lastValue(Component/Logo/File)                                     
        dict set projDict   Component   RearBrake                           $::bikeGeometry::Component(RearBrake)                           ;#[bikeGeometry::get_Component        RearBrake                         ]                ;# set _lastValue(Component/Brake/Rear/File)                               
        dict set projDict   Component   RearCarrier                         $::bikeGeometry::Component(RearCarrier)                         ;#[bikeGeometry::get_Component        RearCarrier                       ]                ;# set _lastValue(Component/Carrier/Rear/File)                             
        dict set projDict   Component   RearDerailleur                      $::bikeGeometry::Component(RearDerailleur)                      ;#[bikeGeometry::get_Component        RearDerailleur                    ]                ;# set _lastValue(Component/Derailleur/Rear/File)                          
        dict set projDict   Component   RearDropout                         $::bikeGeometry::Component(RearDropout)                         ;#[bikeGeometry::get_Component        RearDropout File                  ]                ;# set _lastValue(Lugs/RearDropOut/File)                                   
        dict set projDict   Component   RearHub                             $::bikeGeometry::Component(RearHub)
        dict set projDict   Component   Saddle                              $::bikeGeometry::Component(Saddle)                              ;#[bikeGeometry::get_Component        Saddle                            ]                ;# set _lastValue(Component/Saddle/File)                                   
            #                           
        dict set projDict   Config      BottleCage_DownTube                 $::bikeGeometry::Config(BottleCage_DownTube)                    ;#[bikeGeometry::get_Config           BottleCage_DT                     ]                ;# set _lastValue(Rendering/BottleCage/DownTube)                           
        dict set projDict   Config      BottleCage_DownTube_Lower           $::bikeGeometry::Config(BottleCage_DownTube_Lower)              ;#[bikeGeometry::get_Config           BottleCage_DT_L                   ]                ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
        dict set projDict   Config      BottleCage_SeatTube                 $::bikeGeometry::Config(BottleCage_SeatTube)                    ;#[bikeGeometry::get_Config           BottleCage_ST                     ]                ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
        dict set projDict   Config      ChainStay                           $::bikeGeometry::Config(ChainStay)                              ;#[bikeGeometry::get_Config           ChainStay                         ]                ;# set _lastValue(Rendering/ChainStay)                                     
        dict set projDict   Config      Color_Fork                          $::bikeGeometry::Config(Color_Fork)
        dict set projDict   Config      Color_FrameTubes                    $::bikeGeometry::Config(Color_FrameTubes)
        dict set projDict   Config      Color_Label                         $::bikeGeometry::Config(Color_Label)
        dict set projDict   Config      CrankSet_SpyderArmCount             $::bikeGeometry::Config(CrankSet_SpyderArmCount)
        dict set projDict   Config      Fork                                $::bikeGeometry::Config(Fork)                                   ;#[bikeGeometry::get_Config           Fork                              ]                ;# set _lastValue(Rendering/Fork)                                          
        dict set projDict   Config      ForkBlade                           $::bikeGeometry::Config(ForkBlade)                              ;#[bikeGeometry::get_Config           ForkBlade                         ]                ;# set _lastValue(Rendering/ForkBlade)                                     
        dict set projDict   Config      ForkDropout                         $::bikeGeometry::Config(ForkDropout)                            ;#[bikeGeometry::get_Config           ForkDropout                       ]                ;# set _lastValue(Rendering/ForkDropOut)                                   
        dict set projDict   Config      FrontBrake                          $::bikeGeometry::Config(FrontBrake)                             ;#[bikeGeometry::get_Config           FrontBrake                        ]                ;# set _lastValue(Rendering/Brake/Front)                                   
        dict set projDict   Config      FrontFender                         $::bikeGeometry::Config(FrontFender)                            ;#[bikeGeometry::get_Config           FrontFender                       ]                ;# set _lastValue(Rendering/Fender/Front)                                  
        dict set projDict   Config      HeadTube                            $::bikeGeometry::Config(HeadTube) 
        dict set projDict   Config      RearBrake                           $::bikeGeometry::Config(RearBrake)                              ;#[bikeGeometry::get_Config           RearBrake                         ]                ;# set _lastValue(Rendering/Brake/Rear)                                    
        dict set projDict   Config      RearDropout                         $::bikeGeometry::Config(RearDropout)                            ;#[bikeGeometry::get_Config           RearDropout                       ]                ;# set _lastValue(Rendering/RearDropOut)                                   
        dict set projDict   Config      RearDropoutOrient                   $::bikeGeometry::Config(RearDropoutOrient)                      ;#[bikeGeometry::get_Config           RearDropoutOrient                 ]                ;# set _lastValue(Lugs/RearDropOut/Direction)                              
        dict set projDict   Config      RearFender                          $::bikeGeometry::Config(RearFender)                             ;#[bikeGeometry::get_Config           RearFender                        ]                ;# set _lastValue(Rendering/Fender/Rear)                                   
            #                           
        dict set projDict   Direction   ChainStay                           [list $::bikeGeometry::Direction(ChainStay)]
        dict set projDict   Direction   DownTube                            [list $::bikeGeometry::Direction(DownTube)]
        dict set projDict   Direction   ForkCrown                           [list $::bikeGeometry::Direction(ForkCrown)]
        dict set projDict   Direction   ForkDropout                         [list $::bikeGeometry::Direction(ForkDropout)]
        dict set projDict   Direction   HeadTube                            [list $::bikeGeometry::Direction(HeadTube)]
        dict set projDict   Direction   RearDropout                         [list $::bikeGeometry::Direction(RearDropout)]
        dict set projDict   Direction   SeatStay                            [list $::bikeGeometry::Direction(SeatStay)]
        dict set projDict   Direction   SeatTube                            [list $::bikeGeometry::Direction(SeatTube)]
        dict set projDict   Direction   Steerer                             [list $::bikeGeometry::Direction(Steerer)]
        dict set projDict   Direction   TopTube                             [list $::bikeGeometry::Direction(TopTube)]
             #           
        dict set projDict   ListValue   CrankSetChainRings                  $::bikeGeometry::ListValue(CrankSetChainRings)                  ;#[bikeGeometry::get_Scalar           CrankSet ChainRings               ]                ;# set _lastValue(Component/CrankSet/ChainRings)                           
            #           
        dict set projDict   Polygon     ChainStay                           [list $::bikeGeometry::Polygon(ChainStay)]            
        dict set projDict   Polygon     ChainStay_RearMockup                [list $::bikeGeometry::Polygon(ChainStay_RearMockup)]            
        dict set projDict   Polygon     ChainStay_xy                        [list $::bikeGeometry::Polygon(ChainStay_xy)]            
        dict set projDict   Polygon     CrankArm_xy                         [list $::bikeGeometry::Polygon(CrankArm_xy)]            
        dict set projDict   Polygon     DownTube                            [list $::bikeGeometry::Polygon(DownTube)]            
        dict set projDict   Polygon     ForkBlade                           [list $::bikeGeometry::Polygon(ForkBlade)] 
        dict set projDict   Polygon     FrontFender                         [list $::bikeGeometry::Polygon(FrontFender)] 
        dict set projDict   Polygon     HeadSetBottom                       [list $::bikeGeometry::Polygon(HeadSetBottom)] 
        dict set projDict   Polygon     HeadSetCap                          [list $::bikeGeometry::Polygon(HeadSetCap)] 
        dict set projDict   Polygon     HeadSetTop                          [list $::bikeGeometry::Polygon(HeadSetTop)] 
        dict set projDict   Polygon     HeadTube                            [list $::bikeGeometry::Polygon(HeadTube)] 
        dict set projDict   Polygon     RearFender                          [list $::bikeGeometry::Polygon(RearFender)] 
        dict set projDict   Polygon     SeatTube                            [list $::bikeGeometry::Polygon(SeatTube)] 
        dict set projDict   Polygon     SeatPost                            [list $::bikeGeometry::Polygon(SeatPost)] 
        dict set projDict   Polygon     SeatStay                            [list $::bikeGeometry::Polygon(SeatStay)] 
        dict set projDict   Polygon     Spacer                              [list $::bikeGeometry::Polygon(Spacer)] 
        dict set projDict   Polygon     Steerer                             [list $::bikeGeometry::Polygon(Steerer)] 
        dict set projDict   Polygon     Stem                                [list $::bikeGeometry::Polygon(Stem)] 
        dict set projDict   Polygon     TopTube                             [list $::bikeGeometry::Polygon(TopTube)] 
            #           
        dict set projDict   Position    BottomBracket                       [list {0 0}]           
        dict set projDict   Position    BottomBracket_Ground                [list $::bikeGeometry::Position(BottomBracket_Ground)]          
        dict set projDict   Position    CarrierMount_Front                  [list $::bikeGeometry::Position(CarrierMount_Front)] 
        dict set projDict   Position    CarrierMount_Rear                   [list $::bikeGeometry::Position(CarrierMount_Rear)] 
        dict set projDict   Position    ChainStay_RearMockup                [list $::bikeGeometry::Position(ChainStay_RearMockup)] 
        dict set projDict   Position    ChainStay_RearWheel                 [list $::bikeGeometry::Position(ChainStay_RearWheel)] 
        dict set projDict   Position    ChainStay_SeatStay_IS               [list $::bikeGeometry::Position(ChainStay_SeatStay_IS)] 
        dict set projDict   Position    DerailleurMount_Front               [list $::bikeGeometry::Position(DerailleurMount_Front)] 
        dict set projDict   Position    DownTube_BottleCageBase             [list $::bikeGeometry::Position(DownTube_BottleCageBase)] 
        dict set projDict   Position    DownTube_BottleCageOffset           [list $::bikeGeometry::Position(DownTube_BottleCageOffset)] 
        dict set projDict   Position    DownTube_End                        [list $::bikeGeometry::Position(DownTube_End)] 
        dict set projDict   Position    DownTube_Lower_BottleCageBase       [list $::bikeGeometry::Position(DownTube_Lower_BottleCageBase)] 
        dict set projDict   Position    DownTube_Lower_BottleCageOffset     [list $::bikeGeometry::Position(DownTube_Lower_BottleCageOffset)] 
        dict set projDict   Position    DownTube_Start                      [list $::bikeGeometry::Position(DownTube_Start)] 
        dict set projDict   Position    ForkBlade_End                       [list $::bikeGeometry::Position(ForkBlade_End)] 
        dict set projDict   Position    ForkBlade_Start                     [list $::bikeGeometry::Position(ForkBlade_Start)] 
        dict set projDict   Position    ForkCrown                           [list $::bikeGeometry::Position(ForkCrown)] 
        dict set projDict   Position    FrontBrake_Definition               [list $::bikeGeometry::Position(FrontBrake_Definition)] 
        dict set projDict   Position    FrontBrake_Help                     [list $::bikeGeometry::Position(FrontBrake_Help)] 
        dict set projDict   Position    FrontBrake_Mount                    [list $::bikeGeometry::Position(FrontBrake_Mount)] 
        dict set projDict   Position    FrontBrake_Shoe                     [list $::bikeGeometry::Position(FrontBrake_Shoe)] 
        dict set projDict   Position    FrontDropout_MockUp                 [list $::bikeGeometry::Position(FrontDropout_MockUp)] 
        dict set projDict   Position    FrontWheel                          [list $::bikeGeometry::Position(FrontWheel)] 
        dict set projDict   Position    HandleBar                           [list $::bikeGeometry::Position(HandleBar)] 
        dict set projDict   Position    HeadTube_End                        [list $::bikeGeometry::Position(HeadTube_End)] 
        dict set projDict   Position    HeadTube_Start                      [list $::bikeGeometry::Position(HeadTube_Start)] 
        dict set projDict   Position    HeadTube_VirtualTopTube             [list $::bikeGeometry::Position(HeadTube_VirtualTopTube)] 
        dict set projDict   Position    LegClearance                        [list $::bikeGeometry::Position(LegClearance)] 
        dict set projDict   Position    RearBrake_Definition                [list $::bikeGeometry::Position(RearBrake_Definition)] 
        dict set projDict   Position    RearBrake_Help                      [list $::bikeGeometry::Position(RearBrake_Help)] 
        dict set projDict   Position    RearBrake_Mount                     [list $::bikeGeometry::Position(RearBrake_Mount)] 
        dict set projDict   Position    RearBrake_Shoe                      [list $::bikeGeometry::Position(RearBrake_Shoe)] 
        dict set projDict   Position    RearDerailleur                      [list $::bikeGeometry::Position(RearDerailleur)] 
        dict set projDict   Position    RearWheel                           [list $::bikeGeometry::Position(RearWheel)] 
        dict set projDict   Position    Reference_HB                        [list $::bikeGeometry::Position(Reference_HB)] 
        dict set projDict   Position    Reference_SN                        [list $::bikeGeometry::Position(Reference_SN)] 
        dict set projDict   Position    Saddle                              [list $::bikeGeometry::Position(Saddle)] 
        dict set projDict   Position    Saddle_Mount                        [list $::bikeGeometry::Position(Saddle_Mount)] 
        dict set projDict   Position    SaddleNose                          [list $::bikeGeometry::Position(SaddleNose)] 
        dict set projDict   Position    SaddleProposal                      [list $::bikeGeometry::Position(SaddleProposal)] 
        dict set projDict   Position    SeatPost_Pivot                      [list $::bikeGeometry::Position(SeatPost_Pivot)] 
        dict set projDict   Position    SeatPost_SeatTube                   [list $::bikeGeometry::Position(SeatPost_SeatTube)] 
        dict set projDict   Position    SeatStay_End                        [list $::bikeGeometry::Position(SeatStay_End)] 
        dict set projDict   Position    SeatStay_Start                      [list $::bikeGeometry::Position(SeatStay_Start)] 
        dict set projDict   Position    SeatTube_BottleCageBase             [list $::bikeGeometry::Position(SeatTube_BottleCageBase)] 
        dict set projDict   Position    SeatTube_BottleCageOffset           [list $::bikeGeometry::Position(SeatTube_BottleCageOffset)] 
        dict set projDict   Position    SeatTube_ClassicTopTube             [list $::bikeGeometry::Position(SeatTube_ClassicTopTube)] 
        dict set projDict   Position    SeatTube_End                        [list $::bikeGeometry::Position(SeatTube_End)] 
        dict set projDict   Position    SeatTube_Ground                     [list $::bikeGeometry::Position(SeatTube_Ground)] 
        dict set projDict   Position    SeatTube_Saddle                     [list $::bikeGeometry::Position(SeatTube_Saddle)] 
        dict set projDict   Position    SeatTube_Start                      [list $::bikeGeometry::Position(SeatTube_Start)] 
        dict set projDict   Position    SeatTube_VirtualTopTube             [list $::bikeGeometry::Position(SeatTube_VirtualTopTube)] 
        dict set projDict   Position    Steerer_End                         [list $::bikeGeometry::Position(Steerer_End)] 
        dict set projDict   Position    Steerer_Ground                      [list $::bikeGeometry::Position(Steerer_Ground)] 
        dict set projDict   Position    Steerer_Start                       [list $::bikeGeometry::Position(Steerer_Start)] 
        dict set projDict   Position    TopTube_End                         [list $::bikeGeometry::Position(TopTube_End)] 
        dict set projDict   Position    TopTube_Start                       [list $::bikeGeometry::Position(TopTube_Start)] 
            #
        dict set projDict   Position    _Edge_DownTubeHeadTube_DT           [list $::bikeGeometry::Position(_Edge_DownTubeHeadTube_DT)] 
        dict set projDict   Position    _Edge_HeadSetTopFront_Bottom        [list $::bikeGeometry::Position(_Edge_HeadSetTopFront_Bottom)] 
        dict set projDict   Position    _Edge_HeadSetTopFront_Top           [list $::bikeGeometry::Position(_Edge_HeadSetTopFront_Top)] 
        dict set projDict   Position    _Edge_HeadTubeBack_Bottom           [list $::bikeGeometry::Position(_Edge_HeadTubeBack_Bottom)] 
        dict set projDict   Position    _Edge_HeadTubeBack_Top              [list $::bikeGeometry::Position(_Edge_HeadTubeBack_Top)] 
        dict set projDict   Position    _Edge_HeadTubeFront_Bottom          [list $::bikeGeometry::Position(_Edge_HeadTubeFront_Bottom)] 
        dict set projDict   Position    _Edge_HeadTubeFront_Top             [list $::bikeGeometry::Position(_Edge_HeadTubeFront_Top)] 
        dict set projDict   Position    _Edge_SeatTubeTop_Front             [list $::bikeGeometry::Position(_Edge_SeatTubeTop_Front)] 
        dict set projDict   Position    _Edge_TopTubeHeadTube_TT            [list $::bikeGeometry::Position(_Edge_TopTubeHeadTube_TT)] 
        dict set projDict   Position    _Edge_TopTubeSeatTube_ST            [list $::bikeGeometry::Position(_Edge_TopTubeSeatTube_ST)] 
        dict set projDict   Position    _Edge_TopTubeTaperTop_HT            [list $::bikeGeometry::Position(_Edge_TopTubeTaperTop_HT)] 
        dict set projDict   Position    _Edge_TopTubeTaperTop_ST            [list $::bikeGeometry::Position(_Edge_TopTubeTaperTop_ST)]
            #          
        dict set projDict   Position    ChainStay_RearMockup                [list $::bikeGeometry::Position(ChainStay_RearMockup)]
            #           
        dict set projDict   Profile     ChainStay_xy                        [list $::bikeGeometry::Polygon(ChainStay_xy)]            
        dict set projDict   Profile     ChainStay_xz                        [list $::bikeGeometry::Polygon(ChainStay_xz)]            
            #           
        dict set projDict   Scalar      BottleCage DownTube                 $::bikeGeometry::BottleCage(DownTube)                           ;#[bikeGeometry::get_Scalar           BottleCage DownTube               ]                ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
        dict set projDict   Scalar      BottleCage DownTube_Lower           $::bikeGeometry::BottleCage(DownTube_Lower)                     ;#[bikeGeometry::get_Scalar           BottleCage DownTube_Lower         ]                ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
        dict set projDict   Scalar      BottleCage SeatTube                 $::bikeGeometry::BottleCage(SeatTube)                           ;#[bikeGeometry::get_Scalar           BottleCage SeatTube               ]                ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
        dict set projDict   Scalar      BottomBracket InsideDiameter        $::bikeGeometry::BottomBracket(InsideDiameter)                  ;#[bikeGeometry::get_Scalar           BottomBracket InsideDiameter      ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
        dict set projDict   Scalar      BottomBracket OffsetCS_TopView      $::bikeGeometry::BottomBracket(OffsetCS_TopView)                ;#[bikeGeometry::get_Scalar           BottomBracket OffsetCS_TopView    ]                ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
        dict set projDict   Scalar      BottomBracket OutsideDiameter       $::bikeGeometry::BottomBracket(OutsideDiameter)                 ;#[bikeGeometry::get_Scalar           BottomBracket OutsideDiameter     ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
        dict set projDict   Scalar      BottomBracket Width                 $::bikeGeometry::BottomBracket(Width)                           ;#[bikeGeometry::get_Scalar           BottomBracket Width               ]                ;# set _lastValue(Lugs/BottomBracket/Width)                                
            #            
        dict set projDict   Scalar      ChainStay DiameterSS                $::bikeGeometry::ChainStay(DiameterSS)                          ;#[bikeGeometry::get_Scalar           ChainStay DiameterSS              ]                ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
        dict set projDict   Scalar      ChainStay Height                    $::bikeGeometry::ChainStay(Height)                              ;#[bikeGeometry::get_Scalar           ChainStay Height                  ]                ;# set _lastValue(FrameTubes/ChainStay/Height)                             
        dict set projDict   Scalar      ChainStay HeightBB                  $::bikeGeometry::ChainStay(HeightBB)                            ;#[bikeGeometry::get_Scalar           ChainStay HeigthBB                ]                ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
        dict set projDict   Scalar      ChainStay TaperLength               $::bikeGeometry::ChainStay(TaperLength)                         ;#[bikeGeometry::get_Scalar           ChainStay TaperLength             ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay WidthBB                   $::bikeGeometry::ChainStay(WidthBB)                             ;#[bikeGeometry::get_Scalar           ChainStay WidthBB                 ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay completeLength            $::bikeGeometry::ChainStay(completeLength)                      ;#[bikeGeometry::get_Scalar           ChainStay completeLength          ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
        dict set projDict   Scalar      ChainStay cuttingLeft               $::bikeGeometry::ChainStay(cuttingLeft)                         ;#[bikeGeometry::get_Scalar           ChainStay cuttingLeft             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
        dict set projDict   Scalar      ChainStay cuttingLength             $::bikeGeometry::ChainStay(cuttingLength)                       ;#[bikeGeometry::get_Scalar           ChainStay cuttingLength           ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
        dict set projDict   Scalar      ChainStay profile_x01               $::bikeGeometry::ChainStay(profile_x01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
        dict set projDict   Scalar      ChainStay profile_x02               $::bikeGeometry::ChainStay(profile_x02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
        dict set projDict   Scalar      ChainStay profile_x03               $::bikeGeometry::ChainStay(profile_x03)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x03             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
        dict set projDict   Scalar      ChainStay profile_y00               $::bikeGeometry::ChainStay(profile_y00)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y00             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
        dict set projDict   Scalar      ChainStay profile_y01               $::bikeGeometry::ChainStay(profile_y01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
        dict set projDict   Scalar      ChainStay profile_y02               $::bikeGeometry::ChainStay(profile_y02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        dict set projDict   Scalar      ChainStay segmentAngle_01           $::bikeGeometry::ChainStay(segmentAngle_01)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_01         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
        dict set projDict   Scalar      ChainStay segmentAngle_02           $::bikeGeometry::ChainStay(segmentAngle_02)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_02         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
        dict set projDict   Scalar      ChainStay segmentAngle_03           $::bikeGeometry::ChainStay(segmentAngle_03)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_03         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
        dict set projDict   Scalar      ChainStay segmentAngle_04           $::bikeGeometry::ChainStay(segmentAngle_04)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_04         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
        dict set projDict   Scalar      ChainStay segmentLength_01          $::bikeGeometry::ChainStay(segmentLength_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
        dict set projDict   Scalar      ChainStay segmentLength_02          $::bikeGeometry::ChainStay(segmentLength_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
        dict set projDict   Scalar      ChainStay segmentLength_03          $::bikeGeometry::ChainStay(segmentLength_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
        dict set projDict   Scalar      ChainStay segmentLength_04          $::bikeGeometry::ChainStay(segmentLength_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
        dict set projDict   Scalar      ChainStay segmentRadius_01          $::bikeGeometry::ChainStay(segmentRadius_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
        dict set projDict   Scalar      ChainStay segmentRadius_02          $::bikeGeometry::ChainStay(segmentRadius_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
        dict set projDict   Scalar      ChainStay segmentRadius_03          $::bikeGeometry::ChainStay(segmentRadius_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
        dict set projDict   Scalar      ChainStay segmentRadius_04          $::bikeGeometry::ChainStay(segmentRadius_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
            #            
        dict set projDict   Scalar      CrankSet ArmWidth                   $::bikeGeometry::CrankSet(ArmWidth)                             ;#[bikeGeometry::get_Scalar           CrankSet ArmWidth                 ]                ;# set _lastValue(Component/CrankSet/ArmWidth)                             
        dict set projDict   Scalar      CrankSet ChainLine                  $::bikeGeometry::CrankSet(ChainLine)                            ;#[bikeGeometry::get_Scalar           CrankSet ChainLine                ]                ;# set _lastValue(Component/CrankSet/ChainLine)                            
        dict set projDict   Scalar      CrankSet ChainRingOffset            $::bikeGeometry::CrankSet(ChainRingOffset)                                     
        dict set projDict   Scalar      CrankSet Length                     $::bikeGeometry::CrankSet(Length)                               ;#[bikeGeometry::get_Scalar           CrankSet Length                   ]                ;# set _lastValue(Component/CrankSet/Length)                               
        dict set projDict   Scalar      CrankSet PedalEye                   $::bikeGeometry::CrankSet(PedalEye)                             ;#[bikeGeometry::get_Scalar           CrankSet PedalEye                 ]                ;# set _lastValue(Component/CrankSet/PedalEye)                             
        dict set projDict   Scalar      CrankSet Q-Factor                   $::bikeGeometry::CrankSet(Q-Factor)                             ;#[bikeGeometry::get_Scalar           CrankSet Q-Factor                 ]                ;# set _lastValue(Component/CrankSet/Q-Factor)                             
            #
        dict set projDict   Scalar      DownTube DiameterBB                 $::bikeGeometry::DownTube(DiameterBB)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterBB               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
        dict set projDict   Scalar      DownTube DiameterHT                 $::bikeGeometry::DownTube(DiameterHT)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterHT               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
        dict set projDict   Scalar      DownTube OffsetBB                   $::bikeGeometry::DownTube(OffsetBB)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetBB                 ]                ;# set _lastValue(Custom/DownTube/OffsetBB)                                
        dict set projDict   Scalar      DownTube OffsetHT                   $::bikeGeometry::DownTube(OffsetHT)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetHT                 ]                ;# set _lastValue(Custom/DownTube/OffsetHT)                                
        dict set projDict   Scalar      DownTube TaperLength                $::bikeGeometry::DownTube(TaperLength)                          ;#[bikeGeometry::get_Scalar           DownTube TaperLength              ]                ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
            #            
        dict set projDict   Scalar      Fork BladeBendRadius                $::bikeGeometry::Fork(BladeBendRadius)                          ;#[bikeGeometry::get_Scalar           Fork BladeBendRadius              ]                ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
        dict set projDict   Scalar      Fork BladeBrakeOffset               $::bikeGeometry::Fork(BladeBrakeOffset)
        dict set projDict   Scalar      Fork BladeDiameterDO                $::bikeGeometry::Fork(BladeDiameterDO)                          ;#[bikeGeometry::get_Scalar           Fork BladeDiameterDO              ]                ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
        dict set projDict   Scalar      Fork BladeEndLength                 $::bikeGeometry::Fork(BladeEndLength)                           ;#[bikeGeometry::get_Scalar           Fork BladeEndLength               ]                ;# set _lastValue(Component/Fork/Blade/EndLength)                          
        dict set projDict   Scalar      Fork BladeOffsetCrown               $::bikeGeometry::Fork(BladeOffsetCrown)                         ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrown             ]                ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
        dict set projDict   Scalar      Fork BladeOffsetCrownPerp           $::bikeGeometry::Fork(BladeOffsetCrownPerp)                     ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrownPerp         ]                ;# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
        dict set projDict   Scalar      Fork BladeOffsetDO                  $::bikeGeometry::Fork(BladeOffsetDO)                            ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDO                ]                ;# set _lastValue(Component/Fork/DropOut/Offset)                           
        dict set projDict   Scalar      Fork BladeOffsetDOPerp              $::bikeGeometry::Fork(BladeOffsetDOPerp)                        ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDOPerp            ]                ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
        dict set projDict   Scalar      Fork BladeTaperLength               $::bikeGeometry::Fork(BladeTaperLength)                         ;#[bikeGeometry::get_Scalar           Fork BladeTaperLength             ]                ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
        dict set projDict   Scalar      Fork BladeWidth                     $::bikeGeometry::Fork(BladeWidth)                               ;#[bikeGeometry::get_Scalar           Fork BladeWidth                   ]                ;# set _lastValue(Component/Fork/Blade/Width)                              
        dict set projDict   Scalar      Fork CrownAngleBrake                $::bikeGeometry::Fork(CrownAngleBrake)                          ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
        dict set projDict   Scalar      Fork CrownOffsetBrake               $::bikeGeometry::Fork(CrownOffsetBrake)                         ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
        dict set projDict   Scalar      Fork Rake                           $::bikeGeometry::Fork(Rake)
            # dict set projDict   Scalar      Fork BrakeAngle               $::bikeGeometry::Fork(BrakeAngle)                               ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
            # dict set projDict   Scalar      Fork BrakeOffset              $::bikeGeometry::Fork(BrakeOffset)                              ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
            #
        dict set projDict   Scalar      FrontBrake LeverLength              $::bikeGeometry::FrontBrake(LeverLength)                        ;#[bikeGeometry::get_Scalar           FrontBrake LeverLength            ]                ;# set _lastValue(Component/Brake/Front/LeverLength)                       
        dict set projDict   Scalar      FrontBrake Offset                   $::bikeGeometry::FrontBrake(Offset)                             ;#[bikeGeometry::get_Scalar           FrontBrake Offset                 ]                ;# set _lastValue(Component/Brake/Front/Offset)                            
        dict set projDict   Scalar      FrontCarrier x                      $::bikeGeometry::FrontCarrier(x)                                ;#[bikeGeometry::get_Scalar           FrontCarrier x                    ]                ;# set _lastValue(Component/Carrier/Front/x)                               
        dict set projDict   Scalar      FrontCarrier y                      $::bikeGeometry::FrontCarrier(y)                                ;#[bikeGeometry::get_Scalar           FrontCarrier y                    ]                ;# set _lastValue(Component/Carrier/Front/y)                               
        dict set projDict   Scalar      FrontDerailleur Distance            $::bikeGeometry::FrontDerailleur(Distance)                      ;#[bikeGeometry::get_Scalar           FrontDerailleur Distance          ]                ;# set _lastValue(Component/Derailleur/Front/Distance)                     
        dict set projDict   Scalar      FrontDerailleur Offset              $::bikeGeometry::FrontDerailleur(Offset)                        ;#[bikeGeometry::get_Scalar           FrontDerailleur Offset            ]                ;# set _lastValue(Component/Derailleur/Front/Offset)                       
        dict set projDict   Scalar      FrontFender Height                  $::bikeGeometry::FrontFender(Height)                            ;#[bikeGeometry::get_Scalar           FrontFender Height                ]                ;# set _lastValue(Component/Fender/Front/Height)                           
        dict set projDict   Scalar      FrontFender OffsetAngle             $::bikeGeometry::FrontFender(OffsetAngle)                       ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngle           ]                ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
        dict set projDict   Scalar      FrontFender OffsetAngleFront        $::bikeGeometry::FrontFender(OffsetAngleFront)                  ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngleFront      ]                ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
        dict set projDict   Scalar      FrontFender Radius                  $::bikeGeometry::FrontFender(Radius)                            ;#[bikeGeometry::get_Scalar           FrontFender Radius                ]                ;# set _lastValue(Component/Fender/Front/Radius)                           
        dict set projDict   Scalar      FrontWheel RimHeight                $::bikeGeometry::FrontWheel(RimHeight)                          ;#[bikeGeometry::get_Scalar           FrontWheel RimHeight              ]                ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
            #            
        dict set projDict   Scalar      Geometry BottomBracket_Angle_ChainStay  $::bikeGeometry::Geometry(BottomBracket_Angle_ChainStay)                                
        dict set projDict   Scalar      Geometry BottomBracket_Angle_DownTube   $::bikeGeometry::Geometry(BottomBracket_Angle_DownTube)                                
        dict set projDict   Scalar      Geometry BottomBracket_Depth            $::bikeGeometry::Geometry(BottomBracket_Depth)                  ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Depth      ]                ;# set _lastValue(Custom/BottomBracket/Depth)                              
        dict set projDict   Scalar      Geometry BottomBracket_Height           $::bikeGeometry::Geometry(BottomBracket_Height)                 ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Height     ]                ;# set _lastValue(Result/Length/BottomBracket/Height)                      
        dict set projDict   Scalar      Geometry ChainStay_Length               $::bikeGeometry::Geometry(ChainStay_Length)                     ;#[bikeGeometry::get_Scalar           Geometry ChainStay_Length         ]                ;# set _lastValue(Custom/WheelPosition/Rear)                               
        dict set projDict   Scalar      Geometry Fork_Height                    $::bikeGeometry::Geometry(Fork_Height)                          ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry Fork_Rake                      $::bikeGeometry::Geometry(Fork_Rake)                            ;#[bikeGeometry::get_Scalar           Fork Rake                         ]                ;# set _lastValue(Component/Fork/Rake)                                     
        dict set projDict   Scalar      Geometry FrontRim_Diameter              $::bikeGeometry::Geometry(FrontRim_Diameter)                    ;#[bikeGeometry::get_Scalar           FrontWheel RimDiameter            ]                ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
        dict set projDict   Scalar      Geometry FrontTyre_Height               $::bikeGeometry::Geometry(FrontTyre_Height)                     ;#[bikeGeometry::get_Scalar           FrontWheel TyreHeight             ]                ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
        dict set projDict   Scalar      Geometry FrontWheel_Radius              $::bikeGeometry::Geometry(FrontWheel_Radius)                    ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_Radius        ]                ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
        dict set projDict   Scalar      Geometry FrontWheel_x                   $::bikeGeometry::Geometry(FrontWheel_x)                         ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_x             ]                ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
        dict set projDict   Scalar      Geometry FrontWheel_xy                  $::bikeGeometry::Geometry(FrontWheel_xy)                        ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_xy            ]                ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
        dict set projDict   Scalar      Geometry HandleBar_Distance             $::bikeGeometry::Geometry(HandleBar_Distance)                   ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Distance       ]                ;# set _lastValue(Personal/HandleBar_Distance)                             
        dict set projDict   Scalar      Geometry HandleBar_Height               $::bikeGeometry::Geometry(HandleBar_Height)                     ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Height         ]                ;# set _lastValue(Personal/HandleBar_Height)                               
        dict set projDict   Scalar      Geometry HeadLug_Angle_Bottom           $::bikeGeometry::Geometry(HeadLug_Angle_Bottom)                                
        dict set projDict   Scalar      Geometry HeadLug_Angle_Top              $::bikeGeometry::Geometry(HeadLug_Angle_Top)                    ;#[bikeGeometry::get_Scalar           Result Angle_HeadTubeTopTube      ]                ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
        dict set projDict   Scalar      Geometry HeadSet_Bottom                 $::bikeGeometry::Geometry(HeadSet_Bottom)
        dict set projDict   Scalar      Geometry HeadTube_Angle                 $::bikeGeometry::Geometry(HeadTube_Angle)                       ;#[bikeGeometry::get_Scalar           Geometry HeadTube_Angle           ]                ;# set _lastValue(Custom/HeadTube/Angle)                                   
        dict set projDict   Scalar      Geometry HeadTube_CenterDownTube        $::bikeGeometry::Geometry(HeadTube_CenterDownTube)              ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        dict set projDict   Scalar      Geometry HeadTube_CenterTopTube         $::bikeGeometry::Geometry(HeadTube_CenterTopTube)               ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        dict set projDict   Scalar      Geometry HeadTube_Length                $::bikeGeometry::Geometry(HeadTube_Length)                      ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry HeadTube_Summary               $::bikeGeometry::Geometry(HeadTube_Summary)                     ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry HeadTube_Virtual               $::bikeGeometry::Geometry(HeadTube_Virtual)                     ;#[bikeGeometry::get_Scalar           HeadTube Length_Virtual           ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        dict set projDict   Scalar      Geometry Inseam_Length                  $::bikeGeometry::Geometry(Inseam_Length)                        ;#[bikeGeometry::get_Scalar           Geometry Inseam_Length            ]                ;# set _lastValue(Personal/InnerLeg_Length)                                
        dict set projDict   Scalar      Geometry Reach_Length                   $::bikeGeometry::Geometry(Reach_Length)                         ;#[bikeGeometry::get_Scalar           Geometry ReachLengthResult        ]                ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
        dict set projDict   Scalar      Geometry RearRim_Diameter               $::bikeGeometry::Geometry(RearRim_Diameter)                     ;#[bikeGeometry::get_Scalar           RearWheel RimDiameter             ]                ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
        dict set projDict   Scalar      Geometry RearTyre_Height                $::bikeGeometry::Geometry(RearTyre_Height)                      ;#[bikeGeometry::get_Scalar           RearWheel TyreHeight              ]                ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
        dict set projDict   Scalar      Geometry RearWheel_Radius               $::bikeGeometry::Geometry(RearWheel_Radius)                     ;#[bikeGeometry::get_Scalar           Geometry RearWheel_Radius         ]                ;# set _lastValue(Result/Length/RearWheel/Radius)                          
        dict set projDict   Scalar      Geometry RearWheel_x                    $::bikeGeometry::Geometry(RearWheel_x)                          ;#[bikeGeometry::get_Scalar           Geometry RearWheel_x              ]                ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        dict set projDict   Scalar      Geometry SaddleNose_BB_x                $::bikeGeometry::Geometry(SaddleNose_BB_x)                      ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_BB_x          ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
        dict set projDict   Scalar      Geometry SaddleNose_HB                  $::bikeGeometry::Geometry(SaddleNose_HB)                        ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_HB            ]                ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
        dict set projDict   Scalar      Geometry Saddle_BB                      $::bikeGeometry::Geometry(Saddle_BB)                            ;#[bikeGeometry::get_Scalar           Geometry Saddle_BB                ]                ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
        dict set projDict   Scalar      Geometry Saddle_Distance                $::bikeGeometry::Geometry(Saddle_Distance)                      ;#[bikeGeometry::get_Scalar           Geometry Saddle_Distance          ]                ;# set _lastValue(Personal/Saddle_Distance)                                
        dict set projDict   Scalar      Geometry Saddle_HB_x                    $::bikeGeometry::Geometry(Saddle_HB_x)                                       
        dict set projDict   Scalar      Geometry Saddle_HB_y                    $::bikeGeometry::Geometry(Saddle_HB_y)                          ;#[bikeGeometry::get_Scalar           Geometry Saddle_HB_y              ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Height                  $::bikeGeometry::Geometry(Saddle_Height)                        ;#[bikeGeometry::get_Scalar           Geometry Saddle_Height            ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Offset_BB_ST            $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)                  ;#[bikeGeometry::get_Scalar           Geometry Saddle_Offset_BB_ST      ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
        dict set projDict   Scalar      Geometry SeatTube_Angle                 $::bikeGeometry::Geometry(SeatTube_Angle)                       ;#[bikeGeometry::get_Scalar           SeatTube Angle                    ]                ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
        dict set projDict   Scalar      Geometry SeatTube_LengthClassic         $::bikeGeometry::Geometry(SeatTube_LengthClassic)               
        dict set projDict   Scalar      Geometry SeatTube_LengthVirtual         $::bikeGeometry::Geometry(SeatTube_LengthVirtual)               ;#[bikeGeometry::get_Scalar           Geometry SeatTubeVirtual          ]                ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
        dict set projDict   Scalar      Geometry Stack_Height                   $::bikeGeometry::Geometry(Stack_Height)                         ;#[bikeGeometry::get_Scalar           Geometry StackHeightResult        ]                ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
        dict set projDict   Scalar      Geometry Stem_Angle                     $::bikeGeometry::Geometry(Stem_Angle)                           ;#[bikeGeometry::get_Scalar           Geometry Stem_Angle               ]                ;# set _lastValue(Component/Stem/Angle)                                    
        dict set projDict   Scalar      Geometry Stem_Length                    $::bikeGeometry::Geometry(Stem_Length)                          ;#[bikeGeometry::get_Scalar           Geometry Stem_Length              ]                ;# set _lastValue(Component/Stem/Length)                                   
        dict set projDict   Scalar      Geometry TopTube_Angle                  $::bikeGeometry::Geometry(TopTube_Angle)                        ;#[bikeGeometry::get_Scalar           Geometry TopTube_Angle            ]                ;# set _lastValue(Custom/TopTube/Angle)                                    
        dict set projDict   Scalar      Geometry TopTube_LengthClassic          $::bikeGeometry::Geometry(TopTube_LengthClassic)
        dict set projDict   Scalar      Geometry TopTube_LengthVirtual          $::bikeGeometry::Geometry(TopTube_LengthVirtual)                ;#[bikeGeometry::get_Scalar           Geometry TopTubeVirtual           ]                ;# set _lastValue(Result/Length/TopTube/VirtualLength)                                 
            # 
        dict set projDict   Scalar      HandleBar PivotAngle                    $::bikeGeometry::HandleBar(PivotAngle)                          ;#[bikeGeometry::get_Scalar           HandleBar PivotAngle              ]                ;# set _lastValue(Component/HandleBar/PivotAngle)                          
        dict set projDict   Scalar      HeadSet Diameter                        $::bikeGeometry::HeadSet(Diameter)                              ;#[bikeGeometry::get_Scalar           HeadSet Diameter                  ]                ;# set _lastValue(Component/HeadSet/Diameter)                              
        dict set projDict   Scalar      HeadSet Height_Bottom                   $::bikeGeometry::HeadSet(Height_Bottom)                         ;#[bikeGeometry::get_Scalar           HeadSet Height_Bottom             ]                ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
        dict set projDict   Scalar      HeadSet Height_Top                      $::bikeGeometry::HeadSet(Height_Top)                            ;#[bikeGeometry::get_Scalar           HeadSet Height_Top                ]                ;# set _lastValue(Component/HeadSet/Height/Top)                            
            #
        dict set projDict   Scalar      HeadTube Diameter                       $::bikeGeometry::HeadTube(Diameter)                             ;#[bikeGeometry::get_Scalar           HeadTube Diameter                 ]                ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
        dict set projDict   Scalar      HeadTube DiameterTaperedBase            $::bikeGeometry::HeadTube(DiameterTaperedBase)           
        dict set projDict   Scalar      HeadTube DiameterTaperedTop             $::bikeGeometry::HeadTube(DiameterTaperedTop)            
        dict set projDict   Scalar      HeadTube HeightTaperedBase              $::bikeGeometry::HeadTube(HeightTaperedBase)             
        dict set projDict   Scalar      HeadTube Length                         $::bikeGeometry::HeadTube(Length)                               ;#[bikeGeometry::get_Scalar           HeadTube Length                   ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                                     
        dict set projDict   Scalar      HeadTube LengthTapered                  $::bikeGeometry::HeadTube(LengthTapered)            
            #            
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Angle      $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Angle        ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Tolerance  $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Tolerance    ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Angle       $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Angle         ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Tolerance   $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Tolerance     ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Angle               $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Angle         ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Tolerance           $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Tolerance     ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs HeadLug_Top_Angle                  $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Angle            ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs HeadLug_Top_Tolerance              $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Tolerance        ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
        dict set projDict   Scalar      Lugs RearDropOut_Angle                  $::bikeGeometry::Lugs(RearDropOut_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Angle            ]                ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
        dict set projDict   Scalar      Lugs RearDropOut_Tolerance              $::bikeGeometry::Lugs(RearDropOut_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Tolerance        ]                ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Angle             $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Angle       ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Tolerance         $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Tolerance   ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Angle              $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Angle        ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Tolerance          $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Tolerance    ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
            #            
        dict set projDict   Scalar      RearBrake   DiscWidth                   $::bikeGeometry::RearMockup(DiscWidth)                      ;#[bikeGeometry::get_Scalar           RearMockup DiscWidth              ]                ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
        dict set projDict   Scalar      RearBrake   DiscDiameter                $::bikeGeometry::RearMockup(DiscDiameter)                   ;#[bikeGeometry::get_Scalar           RearMockup DiscDiameter           ]                ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
        dict set projDict   Scalar      RearBrake   LeverLength                 $::bikeGeometry::RearBrake(LeverLength)                     ;#[bikeGeometry::get_Scalar           RearBrake LeverLength             ]                ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
        dict set projDict   Scalar      RearBrake   Offset                      $::bikeGeometry::RearBrake(Offset)                          ;#[bikeGeometry::get_Scalar           RearBrake Offset                  ]                ;# set _lastValue(Component/Brake/Rear/Offset)                             
            #
        dict set projDict   Scalar      RearCarrier x                           $::bikeGeometry::RearCarrier(x)                             ;#[bikeGeometry::get_Scalar           RearCarrier x                     ]                ;# set _lastValue(Component/Carrier/Rear/x)                                
        dict set projDict   Scalar      RearCarrier y                           $::bikeGeometry::RearCarrier(y)                             ;#[bikeGeometry::get_Scalar           RearCarrier y                     ]                ;# set _lastValue(Component/Carrier/Rear/y)                                
        dict set projDict   Scalar      RearDerailleur Pulley_teeth             $::bikeGeometry::RearDerailleur(Pulley_teeth)               ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_teeth       ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
        dict set projDict   Scalar      RearDerailleur Pulley_x                 $::bikeGeometry::RearDerailleur(Pulley_x)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_x           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
        dict set projDict   Scalar      RearDerailleur Pulley_y                 $::bikeGeometry::RearDerailleur(Pulley_y)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_y           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
            #            
        dict set projDict   Scalar      RearDropout Derailleur_x                $::bikeGeometry::RearDropout(Derailleur_x)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_x          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
        dict set projDict   Scalar      RearDropout Derailleur_y                $::bikeGeometry::RearDropout(Derailleur_y)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_y          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
        dict set projDict   Scalar      RearDropout OffsetCS                    $::bikeGeometry::RearDropout(OffsetCS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS              ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
        dict set projDict   Scalar      RearDropout OffsetCSPerp                $::bikeGeometry::RearDropout(OffsetCSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetCSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
        dict set projDict   Scalar      RearDropout OffsetCS_TopView            $::bikeGeometry::RearDropout(OffsetCS_TopView)              ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS_TopView      ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
        dict set projDict   Scalar      RearDropout OffsetSS                    $::bikeGeometry::RearDropout(OffsetSS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetSS              ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
        dict set projDict   Scalar      RearDropout OffsetSSPerp                $::bikeGeometry::RearDropout(OffsetSSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetSSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
        dict set projDict   Scalar      RearDropout RotationOffset              $::bikeGeometry::RearDropout(RotationOffset)                ;#[bikeGeometry::get_Scalar           RearDropout RotationOffset        ]                ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
            #            
        dict set projDict   Scalar      RearFender  Height                      $::bikeGeometry::RearFender(Height)                         ;#[bikeGeometry::get_Scalar           RearFender Height                 ]                ;# set _lastValue(Component/Fender/Rear/Height)                            
        dict set projDict   Scalar      RearFender  OffsetAngle                 $::bikeGeometry::RearFender(OffsetAngle)                    ;#[bikeGeometry::get_Scalar           RearFender OffsetAngle            ]                ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
        dict set projDict   Scalar      RearFender  Radius                      $::bikeGeometry::RearFender(Radius)                         ;#[bikeGeometry::get_Scalar           RearFender Radius                 ]                ;# set _lastValue(Component/Fender/Rear/Radius)                            
        dict set projDict   Scalar      RearMockup  CassetteClearance           $::bikeGeometry::RearMockup(CassetteClearance)              ;#[bikeGeometry::get_Scalar           RearMockup CassetteClearance      ]                ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
        dict set projDict   Scalar      RearMockup  ChainWheelClearance         $::bikeGeometry::RearMockup(ChainWheelClearance)            ;#[bikeGeometry::get_Scalar           RearMockup ChainWheelClearance    ]                ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
        dict set projDict   Scalar      RearMockup  CrankClearance              $::bikeGeometry::RearMockup(CrankClearance)                 ;#[bikeGeometry::get_Scalar           RearMockup CrankClearance         ]                ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
        dict set projDict   Scalar      RearMockup  DiscClearance               $::bikeGeometry::RearMockup(DiscClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup DiscClearance          ]                ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
        dict set projDict   Scalar      RearMockup  DiscOffset                  $::bikeGeometry::RearMockup(DiscOffset)                     ;#[bikeGeometry::get_Scalar           RearMockup DiscOffset             ]                ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
        dict set projDict   Scalar      RearMockup  TyreClearance               $::bikeGeometry::RearMockup(TyreClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup TyreClearance          ]                ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
            #            
        dict set projDict   Scalar      RearWheel   FirstSprocket               $::bikeGeometry::RearWheel(FirstSprocket)                   ;#[bikeGeometry::get_Scalar           RearWheel FirstSprocket           ]                ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
        dict set projDict   Scalar      RearWheel   HubWidth                    $::bikeGeometry::RearWheel(HubWidth)                        ;#[bikeGeometry::get_Scalar           RearWheel HubWidth                ]                ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
        dict set projDict   Scalar      RearWheel   RimHeight                   $::bikeGeometry::RearWheel(RimHeight)                       ;#[bikeGeometry::get_Scalar           RearWheel RimHeight               ]                ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
        dict set projDict   Scalar      RearWheel   TyreShoulder                $::bikeGeometry::RearWheel(TyreShoulder)                    ;#[bikeGeometry::get_Scalar           RearWheel TyreShoulder            ]                ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
        dict set projDict   Scalar      RearWheel   TyreWidth                   $::bikeGeometry::RearWheel(TyreWidth)                       ;#[bikeGeometry::get_Scalar           RearWheel TyreWidth               ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
        dict set projDict   Scalar      RearWheel   TyreWidthRadius             $::bikeGeometry::RearWheel(TyreWidthRadius)                 ;#[bikeGeometry::get_Scalar           RearWheel TyreWidthRadius         ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
            #            
        dict set projDict   Scalar      Reference   HandleBar_Distance          $::bikeGeometry::Reference(HandleBar_Distance)              ;#[bikeGeometry::get_Scalar           Reference HandleBar_Distance      ]                ;# set _lastValue(Reference/HandleBar_Distance)                            
        dict set projDict   Scalar      Reference   HandleBar_Height            $::bikeGeometry::Reference(HandleBar_Height)                ;#[bikeGeometry::get_Scalar           Reference HandleBar_Height        ]                ;# set _lastValue(Reference/HandleBar_Height)                              
        dict set projDict   Scalar      Reference   SaddleNose_Distance         $::bikeGeometry::Reference(SaddleNose_Distance)             ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Distance     ]                ;# set _lastValue(Reference/SaddleNose_Distance)                           
        dict set projDict   Scalar      Reference   SaddleNose_HB               $::bikeGeometry::Reference(SaddleNose_HB)                   ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB           ]                ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
        dict set projDict   Scalar      Reference   SaddleNose_HB_y             $::bikeGeometry::Reference(SaddleNose_HB_y)                 ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB_y         ]                ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
        dict set projDict   Scalar      Reference   SaddleNose_Height           $::bikeGeometry::Reference(SaddleNose_Height)               ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Height       ]                ;# set _lastValue(Reference/SaddleNose_Height)                             
            #            
        dict set projDict   Scalar      Saddle      Height                      $::bikeGeometry::Saddle(Height)                             ;#[bikeGeometry::get_Scalar           Saddle Height                     ]                ;# set _lastValue(Personal/Saddle_Height)                                  
        dict set projDict   Scalar      Saddle      Length                      $::bikeGeometry::Saddle(Length)
        dict set projDict   Scalar      Saddle      NoseLength                  $::bikeGeometry::Saddle(NoseLength)                         ;#[bikeGeometry::get_Scalar           Saddle NoseLength                 ]                ;# set _lastValue(Component/Saddle/LengthNose)     
        dict set projDict   Scalar      Saddle      Offset_x                    $::bikeGeometry::Saddle(Offset_x)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_x                   ]                ;# set _lastValue(Rendering/Saddle/Offset_X)                               
            #            
        dict set projDict   Scalar      SeatPost    Diameter                    $::bikeGeometry::SeatPost(Diameter)                         ;#[bikeGeometry::get_Scalar           SeatPost Diameter                 ]                ;# set _lastValue(Component/SeatPost/Diameter)                             
        dict set projDict   Scalar      SeatPost    PivotOffset                 $::bikeGeometry::SeatPost(PivotOffset)                      ;#[bikeGeometry::get_Scalar           SeatPost PivotOffset              ]                ;# set _lastValue(Component/SeatPost/PivotOffset)                          
        dict set projDict   Scalar      SeatPost    Setback                     $::bikeGeometry::SeatPost(Setback)                          ;#[bikeGeometry::get_Scalar           SeatPost Setback                  ]                ;# set _lastValue(Component/SeatPost/Setback)                              
        dict set projDict   Scalar      SeatStay    DiameterCS                  $::bikeGeometry::SeatStay(DiameterCS)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterCS               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
        dict set projDict   Scalar      SeatStay    DiameterST                  $::bikeGeometry::SeatStay(DiameterST)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterST               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
        dict set projDict   Scalar      SeatStay    OffsetTT                    $::bikeGeometry::SeatStay(OffsetTT)                         ;#[bikeGeometry::get_Scalar           SeatStay OffsetTT                 ]                ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
        dict set projDict   Scalar      SeatStay    SeatTubeMiterDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            ;#[bikeGeometry::get_Scalar           SeatStay SeatTubeMiterDiameter    ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
        dict set projDict   Scalar      SeatStay    TaperLength                 $::bikeGeometry::SeatStay(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatStay TaperLength              ]                ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
            #            
        dict set projDict   Scalar      SeatTube    DiameterBB                  $::bikeGeometry::SeatTube(DiameterBB)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterBB               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
        dict set projDict   Scalar      SeatTube    DiameterTT                  $::bikeGeometry::SeatTube(DiameterTT)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterTT               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
        dict set projDict   Scalar      SeatTube    Extension                   $::bikeGeometry::SeatTube(Extension)                        ;#[bikeGeometry::get_Scalar           SeatTube Extension                ]                ;# set _lastValue(Custom/SeatTube/Extension)                               
        dict set projDict   Scalar      SeatTube    OffsetBB                    $::bikeGeometry::SeatTube(OffsetBB)                         ;#[bikeGeometry::get_Scalar           SeatTube OffsetBB                 ]                ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
        dict set projDict   Scalar      SeatTube    TaperLength                 $::bikeGeometry::SeatTube(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatTube TaperLength              ]                ;# set _lastValue(FrameTubes/SeatTube/TaperLength) 
            #
        dict set projDict   Scalar      Spacer      Height                      $::bikeGeometry::Spacer(Height)                  
            #
        dict set projDict   Scalar      Steerer     Diameter                    $::bikeGeometry::Steerer(Diameter)                     
            #
        dict set projDict   Scalar      TopTube     DiameterHT                  $::bikeGeometry::TopTube(DiameterHT)                        ;#[bikeGeometry::get_Scalar           TopTube  DiameterHT               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
        dict set projDict   Scalar      TopTube     DiameterST                  $::bikeGeometry::TopTube(DiameterST)                        ;#[bikeGeometry::get_Scalar           TopTube DiameterST                ]                ;# set _lastValue(Custom/TopTube/PivotPosition)                                        
        dict set projDict   Scalar      TopTube     OffsetHT                    $::bikeGeometry::TopTube(OffsetHT)                          ;#[bikeGeometry::get_Scalar           TopTube TaperLength               ] 
        dict set projDict   Scalar      TopTube     PivotPosition               $::bikeGeometry::TopTube(PivotPosition)                     ;#[bikeGeometry::get_Scalar           TopTube OffsetHT                  ] 
        dict set projDict   Scalar      TopTube     TaperLength                 $::bikeGeometry::TopTube(TaperLength)                       ;#[bikeGeometry::get_Scalar           TopTube PivotPosition             ]             
            #
            
            # -- TubeMiter -----
            #
        set key             TopTube_Seat
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set projDict   TubeMiter   $key    minorName           TopTube                          
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                             
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction TopTube    degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           SeatTube                         
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatTube(DiameterTT) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction SeatTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(TopTube_Seat_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" 0]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {cylinder}  
            #
        set key             TopTube_Head
        set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set projDict   TubeMiter   $key    minorName           TopTube                          
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                             
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction TopTube    degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           HeadTube                          
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::HeadTube(Diameter) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction HeadTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(TopTube_Head_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" 0]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {cylinder}  
            #
        set key             DownTube_Head
        set minorDiameter   $::bikeGeometry::DownTube(DiameterHT)                       
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set projDict   TubeMiter   $key    minorName           DownTube                         
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                             
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction DownTube   degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           HeadTube                     
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::HeadTube(Diameter) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction HeadTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(DownTube_Head_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" 0]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        if {$::bikeGeometry::Config(HeadTube) == {cylindric}} { 
            dict set projDict   TubeMiter   $key    toolType        {cylinder}
        } else {    
            dict set projDict   TubeMiter   $key    toolType        {cone}
            dict set projDict   TubeMiter   $key    baseDiameter    $::bikeGeometry::HeadTube(DiameterTaperedBase)
            dict set projDict   TubeMiter   $key    topDiameter     $::bikeGeometry::HeadTube(DiameterTaperedTop)   
            dict set projDict   TubeMiter   $key    baseHeight      $::bikeGeometry::HeadTube(HeightTaperedBase)    
            dict set projDict   TubeMiter   $key    frustumHeight   $::bikeGeometry::HeadTube(LengthTapered)      
            dict set projDict   TubeMiter   $key    sectionPoint    [format {%.6f} [vectormath::length $::bikeGeometry::Position(DownTube_End) $::bikeGeometry::Position(HeadTube_Start)]]
        }
            #
        set key     DownTube_Seat
        set minorDiameter   $::bikeGeometry::DownTube(DiameterBB)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set projDict   TubeMiter   $key    minorName           DownTube                         
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                             
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction DownTube   degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           SeatTube                     
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatTube(DiameterBB) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction SeatTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(DownTube_Seat_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" 0]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]
        dict set projDict   TubeMiter   $key    polygon_02          [list [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_in]  1] 0 end-4]]
        dict set projDict   TubeMiter   $key    polygon_03          [list [lrange [lindex [array get [namespace current]::TubeMiter DownTube_BB_out] 1] 0 end-4]]
        dict set projDict   TubeMiter   $key    diameter_02         $::bikeGeometry::BottomBracket(InsideDiameter)   
        dict set projDict   TubeMiter   $key    diameter_03         $::bikeGeometry::BottomBracket(OutsideDiameter)   
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {cylinder}  
            #
        set key             SeatTube_Down
        set minorDiameter   $::bikeGeometry::SeatTube(DiameterBB)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
            #
        dict set projDict   TubeMiter   $key    minorName           SeatTube                         
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                            
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction SeatTube   degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           DownTube                     
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::DownTube(DiameterBB) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction DownTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(SeatTube_Down_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" 0]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set projDict   TubeMiter   $key    polygon_02          [list [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_in]  1] 0 end-4]]
        dict set projDict   TubeMiter   $key    polygon_03          [list [lrange [lindex [array get [namespace current]::TubeMiter SeatTube_BB_out] 1] 0 end-4]]
        dict set projDict   TubeMiter   $key    diameter_02         $::bikeGeometry::BottomBracket(InsideDiameter)   
        dict set projDict   TubeMiter   $key    diameter_03         $::bikeGeometry::BottomBracket(OutsideDiameter)
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {cylinder}  
            #
            #
        set key             SeatStay_01
        set minorDiameter   $::bikeGeometry::SeatStay(DiameterST)                        
        set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        set offset          [expr {0.5 * ($::bikeGeometry::SeatStay(SeatTubeMiterDiameter) - $::bikeGeometry::SeatStay(DiameterST))}]
            #
            #
        dict set projDict   TubeMiter   $key    minorName           SeatStay                         
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                             
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction SeatStay   degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           SeatTube(Lug)                     
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction SeatTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(SeatStay_Seat_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" $offset]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]  
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {cylinder}  
            #
        set key     SeatStay_02
            #
        dict set projDict   TubeMiter   $key    minorName           SeatStay                         
        dict set projDict   TubeMiter   $key    minorDiameter       $minorDiameter                             
        dict set projDict   TubeMiter   $key    minorDirection      [get_Direction SeatStay   degree]                        
        dict set projDict   TubeMiter   $key    minorPerimeter      $minorPerimeter                        
        dict set projDict   TubeMiter   $key    majorName           SeatTube(Lug)                     
        dict set projDict   TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
        dict set projDict   TubeMiter   $key    majorDirection      [get_Direction SeatTube   degree]
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(SeatStay_Seat_Angle)]
        dict set projDict   TubeMiter   $key    offset              [format "%.3f" $offset]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]]
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {cylinder}  
            #
        set key     Reference
            #
        dict set projDict   TubeMiter   $key    minorName           ReferenceWidth                         
        dict set projDict   TubeMiter   $key    majorName           ReferenceHeight                     
        dict set projDict   TubeMiter   $key    minorDiameter       0                             
        dict set projDict   TubeMiter   $key    minorDirection      0                        
        dict set projDict   TubeMiter   $key    minorPerimeter      100.00                        
        dict set projDict   TubeMiter   $key    majorDiameter       0 
        dict set projDict   TubeMiter   $key    majorDirection      1
        dict set projDict   TubeMiter   $key    offset              0.00                        
        dict set projDict   TubeMiter   $key    miterAngle          [format "%.3f" 0]
        dict set projDict   TubeMiter   $key    polygon_01          [list [lindex [array get [namespace current]::TubeMiter $key] 1]  ]
        dict set projDict   TubeMiter   $key    tubeType            {cylinder}  
        dict set projDict   TubeMiter   $key    toolType            {plane}              
            #
            # -- paramCrankset -----
            #
        dict set projDict   CustomCrank_XZ  ChainWheelDefinition    [get_paramComponent ChainWheelDefinition]
        dict set projDict   CustomCrank_XZ  PolygonList_ChainWheel  $::bikeGeometry::CustomCrank(polygonListChainWheel)
        dict set projDict   CustomCrank_XZ  Polygon_CrankArm        [list $::bikeGeometry::CustomCrank(polygonCrankArm)]
        dict set projDict   CustomCrank_XZ  Polygon_SpyderArm       [list $::bikeGeometry::CustomCrank(polygonSpyderArm)]
        dict set projDict   CustomCrank_XZ  PositionList_Bolts      $::bikeGeometry::CustomCrank(positionChainWheelBolts)
            
            
        if 0 {    
                #            
            parray ::bikeGeometry::Geometry
            parray ::bikeGeometry::Component
            parray ::bikeGeometry::Config
            parray ::bikeGeometry::Reference
            parray ::bikeGeometry::ListValue
                #
            parray ::bikeGeometry::BottleCage
            parray ::bikeGeometry::BottomBracket
            parray ::bikeGeometry::ChainStay
            parray ::bikeGeometry::CrankSet
            parray ::bikeGeometry::DownTube
            parray ::bikeGeometry::Fork
            parray ::bikeGeometry::FrontBrake
            parray ::bikeGeometry::FrontCarrier
            parray ::bikeGeometry::FrontDerailleur
            parray ::bikeGeometry::FrontFender
            parray ::bikeGeometry::FrontWheel
            parray ::bikeGeometry::HandleBar
            parray ::bikeGeometry::HeadSet
            parray ::bikeGeometry::HeadTube
            parray ::bikeGeometry::Lugs
            parray ::bikeGeometry::RearBrake
            parray ::bikeGeometry::RearCarrier
            parray ::bikeGeometry::RearDerailleur
            parray ::bikeGeometry::RearDropout
            parray ::bikeGeometry::RearFender
            parray ::bikeGeometry::RearMockup
            parray ::bikeGeometry::RearWheel
            parray ::bikeGeometry::Saddle
            parray ::bikeGeometry::SeatPost
            parray ::bikeGeometry::SeatStay
            parray ::bikeGeometry::SeatTube
            parray ::bikeGeometry::TopTube
            #
        }
            #
        # project::pdict $projDict  4
            #
        return $projDict   
            #
        
    }
        #
        #
        #
        

