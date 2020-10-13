  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"

    
        # -- Libraries  ---------------
    lappend auto_path   "$APPL_ROOT_Dir"
    lappend auto_path   [file join $APPL_ROOT_Dir lib]
    lappend auto_path   "$APPL_ROOT_Dir/../myPersist"
        # --eclipse reference
    lappend auto_path   "$APPL_ROOT_Dir/../lib-myPersist"
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   tdom
    package require   bikeAdapter
    # package require   vectormath
    # package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        # -- Dictionary  ------------
    variable projectDict
        
        # -- FAILED - Queries --------
    variable failedQueries; array set failedQueries {}

        # -- sampleFile  -----------
    set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
    set sampleFile  [file join $SAMPLE_Dir __debug_3.4.01.74__01__simplon_phasic_56_sramRed.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74_b.xml]
    set sampleFile  [file join $SAMPLE_Dir __road_3.4.03.00_legend_02.xml]
        # puts "   -> sampleFile: $sampleFile"

         # -- Content  --------------
    puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]
    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp
    set sampleDOC   [dom parse  $xml]
    set sampleDOM   [$sampleDOC documentElement]
    
        #
        #
        #
    proc bikeAdapter::open_ProjectFile {projectFile} {
                #
            variable persistenceDOM
                # variable bikeObject
                #
            variable persistenceObject 
                # variable model_BikeAdapter  ;# set in _init.tcl
                # variable model_BikeGeometry ;# set in _init.tcl
                # variable model_BikeModel    ;# set in _init.tcl
                #
            puts "\n"
            puts "   -------------------------------"
            puts "    bikeAdapter::open_ProjectFile"
            
                #
            set persistenceDOM [$persistenceObject readFile_rattleCAD $projectFile]
                # set persistenceDOM [$persistenceObject readFile_xml $projectFile]
                # set persistenceDOM [myPersist::file::openProject_xml $projectFile]
                #
                
                #
            if {$persistenceDOM == {}} {
                return
            }
                
                #
            set projectVersion  [[$persistenceDOM selectNodes /root/Project/rattleCADVersion/text()] asXML]
            set projectName     [[$persistenceDOM selectNodes /root/Project/Name/text()]             asXML]
            set projectModified [[$persistenceDOM selectNodes /root/Project/modified/text()]         asXML]       
                #
            puts "         ... version:    $projectVersion"
                #
                # myGUI::control::setSession  projectFile       [file normalize $projectFile]
                # myGUI::control::setSession  projectName       [file rootname [file tail $projectFile]]
                # myGUI::control::setSession  projectSave       [clock milliseconds]
                # myGUI::control::setSession  dateModified      ${projectModified}
                #
                
                #
                # -- bikeGeometry --
                #
            initDomainParameters
                # $modelContext initDomainParameters
            updateProjectValues     $persistenceDOM
                # $modelContext updateProjectValues $persistenceDOM
                
                # set domainDOM [bikeGeometry::get_domainParameters xmlStructure]
                # set domainDOM [$modelContext update_modelDOM $persistenceDOM $domainDOM]
                # bikeGeometry::set_newProject $domainDOM
                #
                # puts "  -> \$modelContext $modelContext"
            
            if 1 {    
                    #            
                parray ::bikeAdapter::Geometry
                parray ::bikeAdapter::Component
                parray ::bikeAdapter::Config
                parray ::bikeAdapter::Reference
                parray ::bikeAdapter::ListValue
                    #
                parray ::bikeAdapter::BottleCage
                parray ::bikeAdapter::BottomBracket
                parray ::bikeAdapter::ChainStay
                parray ::bikeAdapter::CrankSet
                parray ::bikeAdapter::DownTube
                parray ::bikeAdapter::Fork
                parray ::bikeAdapter::FrontBrake
                parray ::bikeAdapter::FrontCarrier
                parray ::bikeAdapter::FrontDerailleur
                parray ::bikeAdapter::FrontFender
                parray ::bikeAdapter::FrontWheel
                parray ::bikeAdapter::HandleBar
                parray ::bikeAdapter::HeadSet
                parray ::bikeAdapter::HeadTube
                parray ::bikeAdapter::Lugs
                parray ::bikeAdapter::RearBrake
                parray ::bikeAdapter::RearCarrier
                parray ::bikeAdapter::RearDerailleur
                parray ::bikeAdapter::RearDropout
                parray ::bikeAdapter::RearFender
                parray ::bikeAdapter::RearMockup
                parray ::bikeAdapter::RearWheel
                parray ::bikeAdapter::Saddle
                parray ::bikeAdapter::SeatPost
                parray ::bikeAdapter::SeatStay
                parray ::bikeAdapter::SeatTube
                parray ::bikeAdapter::Stem
                parray ::bikeAdapter::TopTube
                #
            }

            set dictOrigin [get_projectDICT]
                # set dictOrigin [$modelContext getDictionary]
            appUtil::pdict $dictOrigin
               
                #
                # -- bikeModel --
                #
            
            
                # -- update Model 
            # myGUI::modelAdapter::updateModel
                #
                    
                # --
            return
                #
    }
        #
    proc bikeAdapter::initDomainParameters {} {
            variable    modelDOM
            set modelDOM [get_domainParameters xmlStructure]
    }
    proc bikeAdapter::get_domainParameters {{type arrayStructure} {report no_report}} {
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
    proc bikeAdapter::updateProjectValues {persistDOM} {
                #
            variable    geometryIF    
            variable    modelDOM
            variable    persistenceDOM
                #
            set persistenceDOM $persistDOM
            set modelDOM [updateModelDOM $persistDOM]
            set_newProject $modelDOM
                #
    }
    proc bikeAdapter::updateModelDOM {persistDOM} {
                #
            variable modelDOM
                #
            puts "  -- bikeAdapter::updateModelDOM --"
                #
            set mappingDict [getMappingDict]
                #
                # puts $mappingDict
                # set value [dict get $mappingDict mapping]
                # puts $value
                # set value [dict get $mappingDict mapping /BottleCage/DownTube]
                # puts $value
                #
            set domainDoc  [$modelDOM ownerDocument]
                #
                # puts [$modelDOM asXML]
                #
            foreach xPath [dict keys [dict get $mappingDict mapping]] {
                    #
                foreach {arrayName arrayKey} [split $xPath /] break
                    #
                    #
                set domainKey   [format {/root/%s/%s} $arrayName $arrayKey]    
                set domainNode  [$modelDOM selectNodes $domainKey]
                    #
                if {$domainNode != {}} {
                        #
                    set domainKey    [format {%s/%s} $arrayName $arrayKey]    
                        # puts "              $domainKey"
                    set persistKey  [dict get $mappingDict mapping $domainKey]
                        # puts "                  $persistKey"
                    set persistNode [$persistDOM selectNodes $persistKey]
                        #
                    if {[llength $persistNode] > 1} {
                        puts "    <W> ... $persistKey handled in [namespace current]::set_newProject"
                        set persistNode [lindex $persistNode 0]
                    }   
                        #
                    if {$persistNode != {}} {
                        set persistValue [[$persistNode firstChild] nodeValue]
                        puts [format {                  %-60s -> %s} $persistKey $persistValue]
                        $domainNode appendChild [$domainDoc createTextNode $persistValue]
                    } else {
                        puts ""
                        puts "         <E> could not get key in $persistDOM"
                        puts "                    $persistKey "
                        puts ""
                    }
                } else {
                    puts ""
                    puts "         <E> could not get key in $modelDOM"
                    puts "                    $domainKey "
                    puts ""
                }
                    #
            }
                #
            return $modelDOM
                #
    }
    proc bikeAdapter::getMappingDict {{mode persist_2_domain}} {
                #
                # mode:   persist_2_domain  
                #         domain_2_persist
                #
                #
            set mappingTable_rattleCAD_Project {            
                {   BottleCage/DownTube                     /root/Component/BottleCage/DownTube/OffsetBB             }
                {   BottleCage/DownTube_Lower               /root/Component/BottleCage/DownTube_Lower/OffsetBB       }
                {   BottleCage/SeatTube                     /root/Component/BottleCage/SeatTube/OffsetBB             }
                {   BottomBracket/InsideDiameter            /root/Lugs/BottomBracket/Diameter/inside                 }
                {   BottomBracket/OffsetCS_TopView          /root/Lugs/BottomBracket/ChainStay/Offset_TopView        }
                {   BottomBracket/OutsideDiameter           /root/Lugs/BottomBracket/Diameter/outside                }
                {   BottomBracket/Width                     /root/Lugs/BottomBracket/Width                           }
                {   ChainStay/DiameterSS                    /root/FrameTubes/ChainStay/DiameterSS                    }
                {   ChainStay/Height                        /root/FrameTubes/ChainStay/Height                        }
                {   ChainStay/HeightBB                      /root/FrameTubes/ChainStay/HeightBB                      }
                {   ChainStay/TaperLength                   /root/FrameTubes/ChainStay/TaperLength                   }
                {   ChainStay/WidthBB                       /root/FrameTubes/ChainStay/WidthBB                       }
                {   ChainStay/completeLength                /root/FrameTubes/ChainStay/Profile/completeLength        }
                {   ChainStay/cuttingLeft                   /root/FrameTubes/ChainStay/Profile/cuttingLeft           }
                {   ChainStay/cuttingLength                 /root/FrameTubes/ChainStay/Profile/cuttingLength         }
                {   ChainStay/profile_x01                   /root/FrameTubes/ChainStay/Profile/length_01             }
                {   ChainStay/profile_x02                   /root/FrameTubes/ChainStay/Profile/length_02             }
                {   ChainStay/profile_x03                   /root/FrameTubes/ChainStay/Profile/length_03             }
                {   ChainStay/profile_y00                   /root/FrameTubes/ChainStay/Profile/width_00              }
                {   ChainStay/profile_y01                   /root/FrameTubes/ChainStay/Profile/width_01              }
                {   ChainStay/profile_y02                   /root/FrameTubes/ChainStay/Profile/width_02              }
                {   ChainStay/segmentAngle_01               /root/FrameTubes/ChainStay/CenterLine/angle_01           }
                {   ChainStay/segmentAngle_02               /root/FrameTubes/ChainStay/CenterLine/angle_02           }
                {   ChainStay/segmentAngle_03               /root/FrameTubes/ChainStay/CenterLine/angle_03           }
                {   ChainStay/segmentAngle_04               /root/FrameTubes/ChainStay/CenterLine/angle_04           }
                {   ChainStay/segmentLength_01              /root/FrameTubes/ChainStay/CenterLine/length_01          }
                {   ChainStay/segmentLength_02              /root/FrameTubes/ChainStay/CenterLine/length_02          }
                {   ChainStay/segmentLength_03              /root/FrameTubes/ChainStay/CenterLine/length_03          }
                {   ChainStay/segmentLength_04              /root/FrameTubes/ChainStay/CenterLine/length_04          }
                {   ChainStay/segmentRadius_01              /root/FrameTubes/ChainStay/CenterLine/radius_01          }
                {   ChainStay/segmentRadius_02              /root/FrameTubes/ChainStay/CenterLine/radius_02          }
                {   ChainStay/segmentRadius_03              /root/FrameTubes/ChainStay/CenterLine/radius_03          }
                {   ChainStay/segmentRadius_04              /root/FrameTubes/ChainStay/CenterLine/radius_04          }
                {   Component/BottleCage_DownTube           /root/Component/BottleCage/DownTube/File                 }
                {   Component/BottleCage_DownTube_Lower     /root/Component/BottleCage/DownTube_Lower/File           }
                {   Component/BottleCage_SeatTube           /root/Component/BottleCage/SeatTube/File                 }
                {   Component/CrankSet                      /root/Component/CrankSet/File                            }
                {   Component/ForkCrown                     /root/Component/Fork/Crown/File                          }
                {   Component/ForkDropout                   /root/Component/Fork/DropOut/File                        }
                {   Component/ForkSupplier                  /root/Component/Fork/Supplier/File                       }
                {   Component/FrontBrake                    /root/Component/Brake/Front/File                         }
                {   Component/FrontCarrier                  /root/Component/Carrier/Front/File                       }
                {   Component/FrontDerailleur               /root/Component/Derailleur/Front/File                    }
                {   Component/HandleBar                     /root/Component/HandleBar/File                           }
                {   Component/Label                         /root/Component/Label/File                               }
                {   Component/RearBrake                     /root/Component/Brake/Rear/File                          }
                {   Component/RearCarrier                   /root/Component/Carrier/Rear/File                        }
                {   Component/RearDerailleur                /root/Component/Derailleur/Rear/File                     }
                {   Component/RearDropout                   /root/Lugs/RearDropOut/File                              }
                {   Component/Saddle                        /root/Component/Saddle/File                              }
                {   Config/BottleCage_DownTube              /root/Rendering/BottleCage/DownTube                      }
                {   Config/BottleCage_DownTube_Lower        /root/Rendering/BottleCage/DownTube_Lower                }
                {   Config/BottleCage_SeatTube              /root/Rendering/BottleCage/SeatTube                      }
                {   Config/ChainStay                        /root/Rendering/ChainStay                                }
                {   Config/Color_Fork                       /root/Rendering/ColorScheme/Fork                         }
                {   Config/Color_FrameTubes                 /root/Rendering/ColorScheme/FrameTubes                   }
                {   Config/Color_Label                      /root/Rendering/ColorScheme/Label                        }
                {   Config/CrankSet_SpyderArmCount          /root/Component/CrankSet/SpyderArmCount                  }
                {   Config/Fork                             /root/Rendering/Fork                                     }
                {   Config/ForkBlade                        /root/Rendering/ForkBlade                                }
                {   Config/ForkDropout                      /root/Rendering/ForkDropOut                              }
                {   Config/FrontBrake                       /root/Rendering/Brake/Front                              }
                {   Config/FrontFender                      /root/Rendering/Fender/Front                             }
                {   Config/HeadTube                         /root/Rendering/HeadTube                                 }
                {   Config/RearBrake                        /root/Rendering/Brake/Rear                               }
                {   Config/RearDropout                      /root/Rendering/RearDropOut                              }
                {   Config/RearDropoutOrient                /root/Lugs/RearDropOut/Direction                         }
                {   Config/RearFender                       /root/Rendering/Fender/Rear                              }
                {   CrankSet/ArmWidth                       /root/Component/CrankSet/ArmWidth                        }
                {   CrankSet/ChainLine                      /root/Component/CrankSet/ChainLine                       }
                {   CrankSet/ChainRingOffset                /root/Component/CrankSet/ChainRingOffset                 }
                {   CrankSet/Length                         /root/Component/CrankSet/Length                          }
                {   CrankSet/PedalEye                       /root/Component/CrankSet/PedalEye                        }
                {   CrankSet/Q-Factor                       /root/Component/CrankSet/Q-Factor                        }
                {   DownTube/DiameterBB                     /root/FrameTubes/DownTube/DiameterBB                     }
                {   DownTube/DiameterHT                     /root/FrameTubes/DownTube/DiameterHT                     }
                {   DownTube/OffsetBB                       /root/Custom/DownTube/OffsetBB                           }
                {   DownTube/OffsetHT                       /root/Custom/DownTube/OffsetHT                           }
                {   DownTube/TaperLength                    /root/FrameTubes/DownTube/TaperLength                    }
                {   Fork/BladeBendRadius                    /root/Component/Fork/Blade/BendRadius                    }
                {   Fork/BladeDiameterDO                    /root/Component/Fork/Blade/DiameterDO                    }
                {   Fork/BladeEndLength                     /root/Component/Fork/Blade/EndLength                     }
                {   Fork/BladeOffsetCrown                   /root/Component/Fork/Crown/Blade/Offset                  }
                {   Fork/BladeOffsetCrownPerp               /root/Component/Fork/Crown/Blade/OffsetPerp              }
                {   Fork/BladeOffsetDO                      /root/Component/Fork/DropOut/Offset                      }
                {   Fork/BladeOffsetDOPerp                  /root/Component/Fork/DropOut/OffsetPerp                  }
                {   Fork/BladeTaperLength                   /root/Component/Fork/Blade/TaperLength                   }
                {   Fork/BladeWidth                         /root/Component/Fork/Blade/Width                         }
                {   Fork/BrakeAngle                         /root/Component/Fork/Crown/Brake/Angle                   }
                {   Fork/CrownAngleBrake                    /root/Component/Fork/Crown/Brake/Angle                   }
                {   Fork/CrownOffsetBrake                   /root/Component/Fork/Crown/Brake/Offset                  }
                {   FrontBrake/LeverLength                  /root/Component/Brake/Front/LeverLength                  }
                {   FrontBrake/Offset                       /root/Component/Brake/Front/Offset                       }
                {   FrontCarrier/x                          /root/Component/Carrier/Front/x                          }
                {   FrontCarrier/y                          /root/Component/Carrier/Front/y                          }
                {   FrontDerailleur/Distance                /root/Component/Derailleur/Front/Distance                }
                {   FrontDerailleur/Offset                  /root/Component/Derailleur/Front/Offset                  }
                {   FrontFender/Height                      /root/Component/Fender/Front/Height                      }
                {   FrontFender/OffsetAngle                 /root/Component/Fender/Front/OffsetAngle                 }
                {   FrontFender/OffsetAngleFront            /root/Component/Fender/Front/OffsetAngleFront            }
                {   FrontFender/Radius                      /root/Component/Fender/Front/Radius                      }
                {   FrontWheel/RimHeight                    /root/Component/Wheel/Front/RimHeight                    }
                {   Geometry/BottomBracket_Depth            /root/Custom/BottomBracket/Depth                         }
                {   Geometry/ChainStay_Length               /root/Custom/WheelPosition/Rear                          }
                {   Geometry/Fork_Height                    /root/Component/Fork/Height                              }
                {   Geometry/Fork_Rake                      /root/Component/Fork/Rake                                }
                {   Geometry/FrontRim_Diameter              /root/Component/Wheel/Front/RimDiameter                  }
                {   Geometry/FrontTyre_Height               /root/Component/Wheel/Front/TyreHeight                   }
                {   Geometry/HandleBar_Distance             /root/Personal/HandleBar_Distance                        }
                {   Geometry/HandleBar_Height               /root/Personal/HandleBar_Height                          }
                {   Geometry/HeadTube_Angle                 /root/Custom/HeadTube/Angle                              }
                {   Geometry/Inseam_Length                  /root/Personal/InnerLeg_Length                           }
                {   Geometry/RearRim_Diameter               /root/Component/Wheel/Rear/RimDiameter                   }
                {   Geometry/RearTyre_Height                /root/Component/Wheel/Rear/TyreHeight                    }
                {   Geometry/Saddle_Distance                /root/Personal/Saddle_Distance                           }
                {   Geometry/Saddle_Height                  /root/Personal/Saddle_Height                             }
                {   Geometry/Stem_Angle                     /root/Component/Stem/Angle                               }
                {   Geometry/Stem_Length                    /root/Component/Stem/Length                              }
                {   Geometry/TopTube_Angle                  /root/Custom/TopTube/Angle                               }
                {   HandleBar/PivotAngle                    /root/Component/HandleBar/PivotAngle                     }
                {   HeadSet/Diameter                        /root/Component/HeadSet/Diameter                         }
                {   HeadSet/Height_Bottom                   /root/Component/HeadSet/Height/Bottom                    }
                {   HeadSet/Height_Top                      /root/Component/HeadSet/Height/Top                       }
                {   HeadTube/Diameter                       /root/FrameTubes/HeadTube/Diameter                       }
                {   HeadTube/DiameterTaperedBase            /root/FrameTubes/HeadTube/DiameterTaperedBase            }
                {   HeadTube/DiameterTaperedTop             /root/FrameTubes/HeadTube/DiameterTaperedTop             }
                {   HeadTube/HeightTaperedBase              /root/FrameTubes/HeadTube/HeightTaperedBase              }
                {   HeadTube/Length                         /root/FrameTubes/HeadTube/Length                         }
                {   HeadTube/LengthTapered                  /root/FrameTubes/HeadTube/LengthTapered                  }
                {   ListValue/CrankSetChainRings            /root/Component/CrankSet/ChainRings                      }
                {   Lugs/BottomBracket_ChainStay_Angle      /root/Lugs/BottomBracket/ChainStay/Angle/value           }
                {   Lugs/BottomBracket_ChainStay_Tolerance  /root/Lugs/BottomBracket/ChainStay/Angle/plus_minus      }
                {   Lugs/BottomBracket_DownTube_Angle       /root/Lugs/BottomBracket/DownTube/Angle/value            }
                {   Lugs/BottomBracket_DownTube_Tolerance   /root/Lugs/BottomBracket/DownTube/Angle/plus_minus       }
                {   Lugs/HeadLug_Bottom_Angle               /root/Lugs/HeadTube/DownTube/Angle/value                 }
                {   Lugs/HeadLug_Bottom_Tolerance           /root/Lugs/HeadTube/DownTube/Angle/plus_minus            }
                {   Lugs/HeadLug_Top_Angle                  /root/Lugs/HeadTube/TopTube/Angle/value                  }
                {   Lugs/HeadLug_Top_Tolerance              /root/Lugs/HeadTube/TopTube/Angle/plus_minus             }
                {   Lugs/RearDropOut_Angle                  /root/Lugs/RearDropOut/Angle/value                       }
                {   Lugs/RearDropOut_Tolerance              /root/Lugs/RearDropOut/Angle/plus_minus                  }
                {   Lugs/SeatLug_SeatStay_Angle             /root/Lugs/SeatTube/SeatStay/Angle/value                 }
                {   Lugs/SeatLug_SeatStay_Tolerance         /root/Lugs/SeatTube/SeatStay/Angle/plus_minus            }
                {   Lugs/SeatLug_TopTube_Angle              /root/Lugs/SeatTube/TopTube/Angle/value                  }
                {   Lugs/SeatLug_TopTube_Tolerance          /root/Lugs/SeatTube/TopTube/Angle/plus_minus             }
                {   RearBrake/LeverLength                   /root/Component/Brake/Rear/LeverLength                   }
                {   RearBrake/Offset                        /root/Component/Brake/Rear/Offset                        }
                {   RearCarrier/x                           /root/Component/Carrier/Rear/x                           }
                {   RearCarrier/y                           /root/Component/Carrier/Rear/y                           }
                {   RearDerailleur/Pulley_teeth             /root/Component/Derailleur/Rear/Pulley/teeth             }
                {   RearDerailleur/Pulley_x                 /root/Component/Derailleur/Rear/Pulley/x                 }
                {   RearDerailleur/Pulley_y                 /root/Component/Derailleur/Rear/Pulley/y                 }
                {   RearDropout/Derailleur_x                /root/Lugs/RearDropOut/Derailleur/x                      }
                {   RearDropout/Derailleur_y                /root/Lugs/RearDropOut/Derailleur/y                      }
                {   RearDropout/OffsetCS                    /root/Lugs/RearDropOut/ChainStay/Offset                  }
                {   RearDropout/OffsetCSPerp                /root/Lugs/RearDropOut/ChainStay/OffsetPerp              }
                {   RearDropout/OffsetCS_TopView            /root/Lugs/RearDropOut/ChainStay/Offset_TopView          }
                {   RearDropout/OffsetSS                    /root/Lugs/RearDropOut/SeatStay/Offset                   }
                {   RearDropout/OffsetSSPerp                /root/Lugs/RearDropOut/SeatStay/OffsetPerp               }
                {   RearDropout/RotationOffset              /root/Lugs/RearDropOut/RotationOffset                    }
                {   RearFender/Height                       /root/Component/Fender/Rear/Height                       }
                {   RearFender/OffsetAngle                  /root/Component/Fender/Rear/OffsetAngle                  }
                {   RearFender/Radius                       /root/Component/Fender/Rear/Radius                       }
                {   RearMockup/CassetteClearance            /root/Rendering/RearMockup/CassetteClearance             }
                {   RearMockup/ChainWheelClearance          /root/Rendering/RearMockup/ChainWheelClearance           }
                {   RearMockup/CrankClearance               /root/Rendering/RearMockup/CrankClearance                }
                {   RearMockup/DiscClearance                /root/Rendering/RearMockup/DiscClearance                 }
                {   RearMockup/DiscDiameter                 /root/Rendering/RearMockup/DiscDiameter                  }
                {   RearMockup/DiscOffset                   /root/Rendering/RearMockup/DiscOffset                    }
                {   RearMockup/DiscWidth                    /root/Rendering/RearMockup/DiscWidth                     }
                {   RearMockup/TyreClearance                /root/Rendering/RearMockup/TyreClearance                 }
                {   RearWheel/FirstSprocket                 /root/Component/Wheel/Rear/FirstSprocket                 }
                {   RearWheel/HubWidth                      /root/Component/Wheel/Rear/HubWidth                      }
                {   RearWheel/RimHeight                     /root/Component/Wheel/Rear/RimHeight                     }
                {   RearWheel/TyreWidth                     /root/Component/Wheel/Rear/TyreWidth                     }
                {   RearWheel/TyreWidthRadius               /root/Component/Wheel/Rear/TyreWidthRadius               }
                {   Reference/HandleBar_Distance            /root/Reference/HandleBar_Distance                       }
                {   Reference/HandleBar_Height              /root/Reference/HandleBar_Height                         }
                {   Reference/SaddleNose_Distance           /root/Reference/SaddleNose_Distance                      }
                {   Reference/SaddleNose_Height             /root/Reference/SaddleNose_Height                        }
                {   Saddle/Height                           /root/Component/Saddle/Height                            }
                {   Saddle/Length                           /root/Component/Saddle/Length                            }
                {   Saddle/NoseLength                       /root/Component/Saddle/LengthNose                        }
                {   Saddle/Offset_x                         /root/Rendering/Saddle/Offset_X                          }
                {   SeatPost/Diameter                       /root/Component/SeatPost/Diameter                        }
                {   SeatPost/PivotOffset                    /root/Component/SeatPost/PivotOffset                     }
                {   SeatPost/Setback                        /root/Component/SeatPost/Setback                         }
                {   SeatStay/DiameterCS                     /root/FrameTubes/SeatStay/DiameterCS                     }
                {   SeatStay/DiameterST                     /root/FrameTubes/SeatStay/DiameterST                     }
                {   SeatStay/OffsetTT                       /root/Custom/SeatStay/OffsetTT                           }
                {   SeatStay/SeatTubeMiterDiameter          /root/Lugs/SeatTube/SeatStay/MiterDiameter               }
                {   SeatStay/TaperLength                    /root/FrameTubes/SeatStay/TaperLength                    }
                {   SeatTube/DiameterBB                     /root/FrameTubes/SeatTube/DiameterBB                     }
                {   SeatTube/DiameterTT                     /root/FrameTubes/SeatTube/DiameterTT                     }
                {   SeatTube/Extension                      /root/Custom/SeatTube/Extension                          }
                {   SeatTube/OffsetBB                       /root/Custom/SeatTube/OffsetBB                           }
                {   SeatTube/TaperLength                    /root/FrameTubes/SeatTube/TaperLength                    }
                {   TopTube/DiameterHT                      /root/FrameTubes/TopTube/DiameterHT                      }
                {   TopTube/DiameterST                      /root/FrameTubes/TopTube/DiameterST                      }
                {   TopTube/OffsetHT                        /root/Custom/TopTube/OffsetHT                            }
                {   TopTube/PivotPosition                   /root/Custom/TopTube/PivotPosition                       }
                {   TopTube/TaperLength                     /root/FrameTubes/TopTube/TaperLength                     }
            }
            
            
            if {$mode == {persist_2_domain}} {
                set mappingDict [dict create  mapping {}]
                foreach mapping $mappingTable_rattleCAD_Project {
                    foreach {a b} $mapping break
                    dict set mappingDict mapping $a $b                
                }
                return $mappingDict
            } else {
                set mappingDict [dict create  mapping {}]
                foreach mapping $mappingTable_rattleCAD_Project {
                    foreach {a b} $mapping break
                    dict set mappingDict mapping $b $a                
                }
                return $mappingDict
            }
        }
    proc bikeAdapter::getMappingDict_000 {{mode persist_2_domain}} {
                #
                # mode:   persist_2_domain  
                #         domain_2_persist
                #
                #
            set mappingTable_rattleCAD_Project {            
                {   BottleCage/DownTube                     /root/Component/BottleCage/DownTube/OffsetBB             }
                {   BottleCage/DownTube_Lower               /root/Component/BottleCage/DownTube_Lower/OffsetBB       }
                {   BottleCage/SeatTube                     /root/Component/BottleCage/SeatTube/OffsetBB             }
                {   BottomBracket/InsideDiameter            /root/Lugs/BottomBracket/Diameter/inside                 }
                {   BottomBracket/OffsetCS_TopView          /root/Lugs/BottomBracket/ChainStay/Offset_TopView        }
                {   BottomBracket/OutsideDiameter           /root/Lugs/BottomBracket/Diameter/outside                }
                {   BottomBracket/Width                     /root/Lugs/BottomBracket/Width                           }
                {   ChainStay/DiameterSS                    /root/FrameTubes/ChainStay/DiameterSS                    }
                {   ChainStay/Height                        /root/FrameTubes/ChainStay/Height                        }
                {   ChainStay/HeightBB                      /root/FrameTubes/ChainStay/HeightBB                      }
                {   ChainStay/TaperLength                   /root/FrameTubes/ChainStay/TaperLength                   }
                {   ChainStay/WidthBB                       /root/FrameTubes/ChainStay/WidthBB                       }
                {   ChainStay/completeLength                /root/FrameTubes/ChainStay/Profile/completeLength        }
                {   ChainStay/cuttingLeft                   /root/FrameTubes/ChainStay/Profile/cuttingLeft           }
                {   ChainStay/cuttingLength                 /root/FrameTubes/ChainStay/Profile/cuttingLength         }
                {   ChainStay/profile_x01                   /root/FrameTubes/ChainStay/Profile/length_01             }
                {   ChainStay/profile_x02                   /root/FrameTubes/ChainStay/Profile/length_02             }
                {   ChainStay/profile_x03                   /root/FrameTubes/ChainStay/Profile/length_03             }
                {   ChainStay/profile_y00                   /root/FrameTubes/ChainStay/Profile/width_00              }
                {   ChainStay/profile_y01                   /root/FrameTubes/ChainStay/Profile/width_01              }
                {   ChainStay/profile_y02                   /root/FrameTubes/ChainStay/Profile/width_02              }
                {   ChainStay/segmentAngle_01               /root/FrameTubes/ChainStay/CenterLine/angle_01           }
                {   ChainStay/segmentAngle_02               /root/FrameTubes/ChainStay/CenterLine/angle_02           }
                {   ChainStay/segmentAngle_03               /root/FrameTubes/ChainStay/CenterLine/angle_03           }
                {   ChainStay/segmentAngle_04               /root/FrameTubes/ChainStay/CenterLine/angle_04           }
                {   ChainStay/segmentLength_01              /root/FrameTubes/ChainStay/CenterLine/length_01          }
                {   ChainStay/segmentLength_02              /root/FrameTubes/ChainStay/CenterLine/length_02          }
                {   ChainStay/segmentLength_03              /root/FrameTubes/ChainStay/CenterLine/length_03          }
                {   ChainStay/segmentLength_04              /root/FrameTubes/ChainStay/CenterLine/length_04          }
                {   ChainStay/segmentRadius_01              /root/FrameTubes/ChainStay/CenterLine/radius_01          }
                {   ChainStay/segmentRadius_02              /root/FrameTubes/ChainStay/CenterLine/radius_02          }
                {   ChainStay/segmentRadius_03              /root/FrameTubes/ChainStay/CenterLine/radius_03          }
                {   ChainStay/segmentRadius_04              /root/FrameTubes/ChainStay/CenterLine/radius_04          }
                {   Component/BottleCage_DownTube           /root/Component/BottleCage/DownTube/File                 }
                {   Component/BottleCage_DownTube_Lower     /root/Component/BottleCage/DownTube_Lower/File           }
                {   Component/BottleCage_SeatTube           /root/Component/BottleCage/SeatTube/File                 }
                {   Component/CrankSet                      /root/Component/CrankSet/File                            }
                {   Component/ForkCrown                     /root/Component/Fork/Crown/File                          }
                {   Component/ForkDropout                   /root/Component/Fork/DropOut/File                        }
                {   Component/ForkSupplier                  /root/Component/Fork/Supplier/File                       }
                {   Component/FrontBrake                    /root/Component/Brake/Front/File                         }
                {   Component/FrontCarrier                  /root/Component/Carrier/Front/File                       }
                {   Component/FrontDerailleur               /root/Component/Derailleur/Front/File                    }
                {   Component/HandleBar                     /root/Component/HandleBar/File                           }
                {   Component/Label                         /root/Component/Label/File                               }
                {   Component/RearBrake                     /root/Component/Brake/Rear/File                          }
                {   Component/RearCarrier                   /root/Component/Carrier/Rear/File                        }
                {   Component/RearDerailleur                /root/Component/Derailleur/Rear/File                     }
                {   Component/RearDropout                   /root/Lugs/RearDropOut/File                              }
                {   Component/Saddle                        /root/Component/Saddle/File                              }
                {   Config/BottleCage_DownTube              /root/Rendering/BottleCage/DownTube                      }
                {   Config/BottleCage_DownTube_Lower        /root/Rendering/BottleCage/DownTube_Lower                }
                {   Config/BottleCage_SeatTube              /root/Rendering/BottleCage/SeatTube                      }
                {   Config/ChainStay                        /root/Rendering/ChainStay                                }
                {   Config/Color_Fork                       /root/Rendering/ColorScheme/Fork                         }
                {   Config/Color_FrameTubes                 /root/Rendering/ColorScheme/FrameTubes                   }
                {   Config/Color_Label                      /root/Rendering/ColorScheme/Label                        }
                {   Config/CrankSet_SpyderArmCount          /root/Component/CrankSet/SpyderArmCount                  }
                {   Config/Fork                             /root/Rendering/Fork                                     }
                {   Config/ForkBlade                        /root/Rendering/ForkBlade                                }
                {   Config/ForkDropout                      /root/Rendering/ForkDropOut                              }
                {   Config/FrontBrake                       /root/Rendering/Brake/Front                              }
                {   Config/FrontFender                      /root/Rendering/Fender/Front                             }
                {   Config/HeadTube                         /root/Rendering/HeadTube                                 }
                {   Config/RearBrake                        /root/Rendering/Brake/Rear                               }
                {   Config/RearDropout                      /root/Rendering/RearDropOut                              }
                {   Config/RearDropoutOrient                /root/Lugs/RearDropOut/Direction                         }
                {   Config/RearFender                       /root/Rendering/Fender/Rear                              }
                {   CrankSet/ArmWidth                       /root/Component/CrankSet/ArmWidth                        }
                {   CrankSet/ChainLine                      /root/Component/CrankSet/ChainLine                       }
                {   CrankSet/ChainRingOffset                /root/Component/CrankSet/ChainRingOffset                 }
                {   CrankSet/Length                         /root/Component/CrankSet/Length                          }
                {   CrankSet/PedalEye                       /root/Component/CrankSet/PedalEye                        }
                {   CrankSet/Q-Factor                       /root/Component/CrankSet/Q-Factor                        }
                {   DownTube/DiameterBB                     /root/FrameTubes/DownTube/DiameterBB                     }
                {   DownTube/DiameterHT                     /root/FrameTubes/DownTube/DiameterHT                     }
                {   DownTube/OffsetBB                       /root/Custom/DownTube/OffsetBB                           }
                {   DownTube/OffsetHT                       /root/Custom/DownTube/OffsetHT                           }
                {   DownTube/TaperLength                    /root/FrameTubes/DownTube/TaperLength                    }
                {   Fork/BladeBendRadius                    /root/Component/Fork/Blade/BendRadius                    }
                {   Fork/BladeDiameterDO                    /root/Component/Fork/Blade/DiameterDO                    }
                {   Fork/BladeEndLength                     /root/Component/Fork/Blade/EndLength                     }
                {   Fork/BladeOffsetCrown                   /root/Component/Fork/Crown/Blade/Offset                  }
                {   Fork/BladeOffsetCrownPerp               /root/Component/Fork/Crown/Blade/OffsetPerp              }
                {   Fork/BladeOffsetDO                      /root/Component/Fork/DropOut/Offset                      }
                {   Fork/BladeOffsetDOPerp                  /root/Component/Fork/DropOut/OffsetPerp                  }
                {   Fork/BladeTaperLength                   /root/Component/Fork/Blade/TaperLength                   }
                {   Fork/BladeWidth                         /root/Component/Fork/Blade/Width                         }
                {   Fork/BrakeAngle                         /root/Component/Fork/Crown/Brake/Angle                   }
                {   Fork/CrownAngleBrake                    /root/Component/Fork/Crown/Brake/Angle                   }
                {   Fork/CrownOffsetBrake                   /root/Component/Fork/Crown/Brake/Offset                  }
                {   Fork/Height                             /root/Component/Fork/Height                              }
                {   Fork/Rake                               /root/Component/Fork/Rake                                }
                {   FrontBrake/LeverLength                  /root/Component/Brake/Front/LeverLength                  }
                {   FrontBrake/Offset                       /root/Component/Brake/Front/Offset                       }
                {   FrontCarrier/x                          /root/Component/Carrier/Front/x                          }
                {   FrontCarrier/y                          /root/Component/Carrier/Front/y                          }
                {   FrontDerailleur/Distance                /root/Component/Derailleur/Front/Distance                }
                {   FrontDerailleur/Offset                  /root/Component/Derailleur/Front/Offset                  }
                {   FrontFender/Height                      /root/Component/Fender/Front/Height                      }
                {   FrontFender/OffsetAngle                 /root/Component/Fender/Front/OffsetAngle                 }
                {   FrontFender/OffsetAngleFront            /root/Component/Fender/Front/OffsetAngleFront            }
                {   FrontFender/Radius                      /root/Component/Fender/Front/Radius                      }
                {   FrontWheel/RimDiameter                  /root/Component/Wheel/Front/RimDiameter                  }
                {   FrontWheel/RimHeight                    /root/Component/Wheel/Front/RimHeight                    }
                {   FrontWheel/TyreHeight                   /root/Component/Wheel/Front/TyreHeight                   }
                {   Geometry/BottomBracket_Depth            /root/Custom/BottomBracket/Depth                         }
                {   Geometry/ChainStay_Length               /root/Custom/WheelPosition/Rear                          }
                {   Geometry/HandleBar_Distance             /root/Personal/HandleBar_Distance                        }
                {   Geometry/HandleBar_Height               /root/Personal/HandleBar_Height                          }
                {   Geometry/Inseam_Length                  /root/Personal/InnerLeg_Length                           }
                {   Geometry/Saddle_Distance                /root/Personal/Saddle_Distance                           }
                {   Geometry/Saddle_Height                  /root/Personal/Saddle_Height                             }
                {   Geometry/TopTube_Angle                  /root/Custom/TopTube/Angle                               }
                {   HandleBar/PivotAngle                    /root/Component/HandleBar/PivotAngle                     }
                {   HeadSet/Diameter                        /root/Component/HeadSet/Diameter                         }
                {   HeadSet/Height_Bottom                   /root/Component/HeadSet/Height/Bottom                    }
                {   HeadSet/Height_Top                      /root/Component/HeadSet/Height/Top                       }
                {   HeadTube/Angle                          /root/Custom/HeadTube/Angle                              }
                {   HeadTube/Diameter                       /root/FrameTubes/HeadTube/Diameter                       }
                {   HeadTube/DiameterTaperedBase            /root/FrameTubes/HeadTube/DiameterTaperedBase            }
                {   HeadTube/DiameterTaperedTop             /root/FrameTubes/HeadTube/DiameterTaperedTop             }
                {   HeadTube/HeightTaperedBase              /root/FrameTubes/HeadTube/HeightTaperedBase              }
                {   HeadTube/Length                         /root/FrameTubes/HeadTube/Length                         }
                {   HeadTube/LengthTapered                  /root/FrameTubes/HeadTube/LengthTapered                  }
                {   ListValue/CrankSetChainRings            /root/Component/CrankSet/ChainRings                      }
                {   Lugs/BottomBracket_ChainStay_Angle      /root/Lugs/BottomBracket/ChainStay/Angle/value           }
                {   Lugs/BottomBracket_ChainStay_Tolerance  /root/Lugs/BottomBracket/ChainStay/Angle/plus_minus      }
                {   Lugs/BottomBracket_DownTube_Angle       /root/Lugs/BottomBracket/DownTube/Angle/value            }
                {   Lugs/BottomBracket_DownTube_Tolerance   /root/Lugs/BottomBracket/DownTube/Angle/plus_minus       }
                {   Lugs/HeadLug_Bottom_Angle               /root/Lugs/HeadTube/DownTube/Angle/value                 }
                {   Lugs/HeadLug_Bottom_Tolerance           /root/Lugs/HeadTube/DownTube/Angle/plus_minus            }
                {   Lugs/HeadLug_Top_Angle                  /root/Lugs/HeadTube/TopTube/Angle/value                  }
                {   Lugs/HeadLug_Top_Tolerance              /root/Lugs/HeadTube/TopTube/Angle/plus_minus             }
                {   Lugs/RearDropOut_Angle                  /root/Lugs/RearDropOut/Angle/value                       }
                {   Lugs/RearDropOut_Tolerance              /root/Lugs/RearDropOut/Angle/plus_minus                  }
                {   Lugs/SeatLug_SeatStay_Angle             /root/Lugs/SeatTube/SeatStay/Angle/value                 }
                {   Lugs/SeatLug_SeatStay_Tolerance         /root/Lugs/SeatTube/SeatStay/Angle/plus_minus            }
                {   Lugs/SeatLug_TopTube_Angle              /root/Lugs/SeatTube/TopTube/Angle/value                  }
                {   Lugs/SeatLug_TopTube_Tolerance          /root/Lugs/SeatTube/TopTube/Angle/plus_minus             }
                {   RearBrake/LeverLength                   /root/Component/Brake/Rear/LeverLength                   }
                {   RearBrake/Offset                        /root/Component/Brake/Rear/Offset                        }
                {   RearCarrier/x                           /root/Component/Carrier/Rear/x                           }
                {   RearCarrier/y                           /root/Component/Carrier/Rear/y                           }
                {   RearDerailleur/Pulley_teeth             /root/Component/Derailleur/Rear/Pulley/teeth             }
                {   RearDerailleur/Pulley_x                 /root/Component/Derailleur/Rear/Pulley/x                 }
                {   RearDerailleur/Pulley_y                 /root/Component/Derailleur/Rear/Pulley/y                 }
                {   RearDropout/Derailleur_x                /root/Lugs/RearDropOut/Derailleur/x                      }
                {   RearDropout/Derailleur_y                /root/Lugs/RearDropOut/Derailleur/y                      }
                {   RearDropout/OffsetCS                    /root/Lugs/RearDropOut/ChainStay/Offset                  }
                {   RearDropout/OffsetCSPerp                /root/Lugs/RearDropOut/ChainStay/OffsetPerp              }
                {   RearDropout/OffsetCS_TopView            /root/Lugs/RearDropOut/ChainStay/Offset_TopView          }
                {   RearDropout/OffsetSS                    /root/Lugs/RearDropOut/SeatStay/Offset                   }
                {   RearDropout/OffsetSSPerp                /root/Lugs/RearDropOut/SeatStay/OffsetPerp               }
                {   RearDropout/RotationOffset              /root/Lugs/RearDropOut/RotationOffset                    }
                {   RearFender/Height                       /root/Component/Fender/Rear/Height                       }
                {   RearFender/OffsetAngle                  /root/Component/Fender/Rear/OffsetAngle                  }
                {   RearFender/Radius                       /root/Component/Fender/Rear/Radius                       }
                {   RearMockup/CassetteClearance            /root/Rendering/RearMockup/CassetteClearance             }
                {   RearMockup/ChainWheelClearance          /root/Rendering/RearMockup/ChainWheelClearance           }
                {   RearMockup/CrankClearance               /root/Rendering/RearMockup/CrankClearance                }
                {   RearMockup/DiscClearance                /root/Rendering/RearMockup/DiscClearance                 }
                {   RearMockup/DiscDiameter                 /root/Rendering/RearMockup/DiscDiameter                  }
                {   RearMockup/DiscOffset                   /root/Rendering/RearMockup/DiscOffset                    }
                {   RearMockup/DiscWidth                    /root/Rendering/RearMockup/DiscWidth                     }
                {   RearMockup/TyreClearance                /root/Rendering/RearMockup/TyreClearance                 }
                {   RearWheel/FirstSprocket                 /root/Component/Wheel/Rear/FirstSprocket                 }
                {   RearWheel/HubWidth                      /root/Component/Wheel/Rear/HubWidth                      }
                {   RearWheel/RimDiameter                   /root/Component/Wheel/Rear/RimDiameter                   }
                {   RearWheel/RimHeight                     /root/Component/Wheel/Rear/RimHeight                     }
                {   RearWheel/TyreWidth                     /root/Component/Wheel/Rear/TyreWidth                     }
                {   RearWheel/TyreWidthRadius               /root/Component/Wheel/Rear/TyreWidthRadius               }
                {   RearWheel/Tyre_Height                   /root/Component/Wheel/Rear/TyreHeight                    }
                {   Reference/HandleBar_Distance            /root/Reference/HandleBar_Distance                       }
                {   Reference/HandleBar_Height              /root/Reference/HandleBar_Height                         }
                {   Reference/SaddleNose_Distance           /root/Reference/SaddleNose_Distance                      }
                {   Reference/SaddleNose_Height             /root/Reference/SaddleNose_Height                        }
                {   Saddle/Height                           /root/Component/Saddle/Height                            }
                {   Saddle/Length                           /root/Component/Saddle/Length                            }
                {   Saddle/NoseLength                       /root/Component/Saddle/LengthNose                        }
                {   Saddle/Offset_x                         /root/Rendering/Saddle/Offset_X                          }
                {   SeatPost/Diameter                       /root/Component/SeatPost/Diameter                        }
                {   SeatPost/PivotOffset                    /root/Component/SeatPost/PivotOffset                     }
                {   SeatPost/Setback                        /root/Component/SeatPost/Setback                         }
                {   SeatStay/DiameterCS                     /root/FrameTubes/SeatStay/DiameterCS                     }
                {   SeatStay/DiameterST                     /root/FrameTubes/SeatStay/DiameterST                     }
                {   SeatStay/OffsetTT                       /root/Custom/SeatStay/OffsetTT                           }
                {   SeatStay/SeatTubeMiterDiameter          /root/Lugs/SeatTube/SeatStay/MiterDiameter               }
                {   SeatStay/TaperLength                    /root/FrameTubes/SeatStay/TaperLength                    }
                {   SeatTube/DiameterBB                     /root/FrameTubes/SeatTube/DiameterBB                     }
                {   SeatTube/DiameterTT                     /root/FrameTubes/SeatTube/DiameterTT                     }
                {   SeatTube/Extension                      /root/Custom/SeatTube/Extension                          }
                {   SeatTube/OffsetBB                       /root/Custom/SeatTube/OffsetBB                           }
                {   SeatTube/TaperLength                    /root/FrameTubes/SeatTube/TaperLength                    }
                {   Stem/Angle                              /root/Component/Stem/Angle                               }
                {   Stem/Length                             /root/Component/Stem/Length                              }
                {   TopTube/DiameterHT                      /root/FrameTubes/TopTube/DiameterHT                      }
                {   TopTube/DiameterST                      /root/FrameTubes/TopTube/DiameterST                      }
                {   TopTube/OffsetHT                        /root/Custom/TopTube/OffsetHT                            }
                {   TopTube/PivotPosition                   /root/Custom/TopTube/PivotPosition                       }
                {   TopTube/TaperLength                     /root/FrameTubes/TopTube/TaperLength                     }                
            }
            
            
            if {$mode == {persist_2_domain}} {
                set mappingDict [dict create  mapping {}]
                foreach mapping $mappingTable_rattleCAD_Project {
                    foreach {a b} $mapping break
                    dict set mappingDict mapping $a $b                
                }
                return $mappingDict
            } else {
                set mappingDict [dict create  mapping {}]
                foreach mapping $mappingTable_rattleCAD_Project {
                    foreach {a b} $mapping break
                    dict set mappingDict mapping $b $a                
                }
                return $mappingDict
            }
        }
        #-------------------------------------------------------------------------
        #  return structure of project definitio as xml or array-Structure	

    
        
        
        
    bikeAdapter::init    
    bikeAdapter::open_ProjectFile  $sampleFile   
