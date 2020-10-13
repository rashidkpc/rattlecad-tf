  
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
    package require   bikeFacade
    # package require   vectormath
    # package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
    
    proc getMappingDict {{mode domain_2_persist}} {
            #
            # mode:   persist_2_domain  
            #         domain_2_persist
            #
            #
            #   bikeFacade                                              persisted rattleCAD - Project File
            #
        set mappingTable_rattleCAD_Project {            
            {   BottleCage_DownTube/ComponentKey/XZ                     Component/BottleCage/DownTube/File              }
            {   BottleCage_DownTube/Config/Type                         Rendering/BottleCage/DownTube                   }
            {   BottleCage_DownTube/Scalar/OffsetBB                     Component/BottleCage/DownTube/OffsetBB          }
            {   BottleCage_DownTube_Lower/ComponentKey/XZ               Component/BottleCage/DownTube_Lower/File        }
            {   BottleCage_DownTube_Lower/Config/Type                   Rendering/BottleCage/DownTube_Lower             }
            {   BottleCage_DownTube_Lower/Scalar/OffsetBB               Component/BottleCage/DownTube_Lower/OffsetBB    }
            {   BottleCage_SeatTube/ComponentKey/XZ                     Component/BottleCage/SeatTube/File              }
            {   BottleCage_SeatTube/Config/Type                         Rendering/BottleCage/SeatTube                   }
            {   BottleCage_SeatTube/Scalar/OffsetBB                     Component/BottleCage/SeatTube/OffsetBB          }
            
            {   BottomBracket/Scalar/InsideDiameter                     Lugs/BottomBracket/Diameter/inside              }
            {   BottomBracket/Scalar/OffsetCS_TopView                   Lugs/BottomBracket/ChainStay/Offset_TopView     }
            {   BottomBracket/Scalar/OutsideDiameter                    Lugs/BottomBracket/Diameter/outside             }
            {   BottomBracket/Scalar/Width                              Lugs/BottomBracket/Width                        }
            
            {   ChainStay/Config/Type                                   Rendering/ChainStay                             }
            {   ChainStay/Scalar/DiameterSS                             FrameTubes/ChainStay/DiameterSS                 }
            {   ChainStay/Scalar/Height                                 FrameTubes/ChainStay/Height                     }
            {   ChainStay/Scalar/HeightBB                               FrameTubes/ChainStay/HeightBB                   }
            {   ChainStay/Scalar/Length                                 Custom/WheelPosition/Rear                       }
            {   ChainStay/Scalar/TaperLength                            FrameTubes/ChainStay/TaperLength                }
            {   ChainStay/Scalar/WidthBB                                FrameTubes/ChainStay/WidthBB                    }
            {   ChainStay/Scalar/completeLength                         FrameTubes/ChainStay/Profile/completeLength     }
            {   ChainStay/Scalar/cuttingLeft                            FrameTubes/ChainStay/Profile/cuttingLeft        }
            {   ChainStay/Scalar/cuttingLength                          FrameTubes/ChainStay/Profile/cuttingLength      }
            {   ChainStay/Scalar/profile_x01                            FrameTubes/ChainStay/Profile/length_01          }
            {   ChainStay/Scalar/profile_x02                            FrameTubes/ChainStay/Profile/length_02          }
            {   ChainStay/Scalar/profile_x03                            FrameTubes/ChainStay/Profile/length_03          }
            {   ChainStay/Scalar/profile_y00                            FrameTubes/ChainStay/Profile/width_00           }
            {   ChainStay/Scalar/profile_y01                            FrameTubes/ChainStay/Profile/width_01           }
            {   ChainStay/Scalar/profile_y02                            FrameTubes/ChainStay/Profile/width_02           }
            {   ChainStay/Scalar/profile_y03                            FrameTubes/ChainStay/Profile/width_03           }
            {   ChainStay/Scalar/segmentAngle_01                        FrameTubes/ChainStay/CenterLine/angle_01        }
            {   ChainStay/Scalar/segmentAngle_02                        FrameTubes/ChainStay/CenterLine/angle_02        }
            {   ChainStay/Scalar/segmentAngle_03                        FrameTubes/ChainStay/CenterLine/angle_03        }
            {   ChainStay/Scalar/segmentAngle_04                        FrameTubes/ChainStay/CenterLine/angle_04        }
            {   ChainStay/Scalar/segmentLength_01                       FrameTubes/ChainStay/CenterLine/length_01       }
            {   ChainStay/Scalar/segmentLength_02                       FrameTubes/ChainStay/CenterLine/length_02       }
            {   ChainStay/Scalar/segmentLength_03                       FrameTubes/ChainStay/CenterLine/length_03       }
            {   ChainStay/Scalar/segmentLength_04                       FrameTubes/ChainStay/CenterLine/length_04       }
            {   ChainStay/Scalar/segmentRadius_01                       FrameTubes/ChainStay/CenterLine/radius_01       }
            {   ChainStay/Scalar/segmentRadius_02                       FrameTubes/ChainStay/CenterLine/radius_02       }
            {   ChainStay/Scalar/segmentRadius_03                       FrameTubes/ChainStay/CenterLine/radius_03       }
            {   ChainStay/Scalar/segmentRadius_04                       FrameTubes/ChainStay/CenterLine/radius_04       }
            
            {   CrankSet/ComponentKey/XZ                                Component/CrankSet/File                         }
            {   CrankSet/Config/SpyderArmCount                          Component/CrankSet/SpyderArmCount               }
            {   CrankSet/ListValue/ChainRings                           Component/CrankSet/ChainRings                   }
            {   CrankSet/Scalar/ArmWidth                                Component/CrankSet/ArmWidth                     }
            {   CrankSet/Scalar/ChainLine                               Component/CrankSet/ChainLine                    }
            {   CrankSet/Scalar/ChainRingOffset                         Component/CrankSet/ChainRingOffset              }
            {   CrankSet/Scalar/Length                                  Component/CrankSet/Length                       }
            {   CrankSet/Scalar/PedalEye                                Component/CrankSet/PedalEye                     }
            {   CrankSet/Scalar/Q-Factor                                Component/CrankSet/Q-Factor                     }
            
            {   DownTube/Scalar/DiameterBB                              FrameTubes/DownTube/DiameterBB                  }
            {   DownTube/Scalar/DiameterHT                              FrameTubes/DownTube/DiameterHT                  }
            {   DownTube/Scalar/TaperLength                             FrameTubes/DownTube/TaperLength                 }
            
            {   Fork/Config/ForkDropout                                 Rendering/ForkDropOut                           }
            {   Fork/Config/Type                                        Rendering/Fork                                  }
            {   Fork/Scalar/BladeBrakeOffset                            Component/Fork/Crown/Brake/Offset               }
            {   Fork/Scalar/BladeOffsetCrown                            Component/Fork/Crown/Blade/Offset               }
            {   Fork/Scalar/BladeOffsetCrownPerp                        Component/Fork/Crown/Blade/OffsetPerp           }
            {   Fork/Scalar/BladeOffsetDO                               Component/Fork/DropOut/Offset                   }
            {   Fork/Scalar/BladeOffsetDOPerp                           Component/Fork/DropOut/OffsetPerp               }
            {   Fork/Scalar/CrownAngleBrake                             Component/Fork/Crown/Brake/Angle                }
            {   Fork/Scalar/CrownOffsetBrake                            Component/Fork/Crown/Brake/Offset               }
            {   Fork/Scalar/Height                                      Component/Fork/Height                           }
            {   Fork/Scalar/Rake                                        Component/Fork/Rake                             }
            
            {   ForkBlade/Scalar/BendRadius                             Component/Fork/Blade/BendRadius                 }
            {   ForkBlade/Scalar/DiameterDO                             Component/Fork/Blade/DiameterDO                 }
            {   ForkBlade/Scalar/EndLength                              Component/Fork/Blade/EndLength                  }
            {   ForkBlade/Scalar/TaperLength                            Component/Fork/Blade/TaperLength                }
            {   ForkBlade/Scalar/Width                                  Component/Fork/Blade/Width                      }            
            {   ForkBlade/Config/Type                                   Rendering/ForkBlade                             }
            
            {   ForkCrown/ComponentKey/XZ                               Component/Fork/Crown/File                       }
            {   ForkDropout/ComponentKey/XZ                             Component/Fork/DropOut/File                     }
            {   ForkDropout/Config/Layer                                Rendering/ForkDropOut                           }
            {   ForkSupplier/ComponentKey/XZ                            Component/Fork/Supplier/File                    }
            
            {   FrontBrake/ComponentKey/XZ                              Component/Brake/Front/File                      }
            {   FrontBrake/Config/Type                                  Rendering/Brake/Front                           }
            {   FrontBrake/Scalar/LeverLength                           Component/Brake/Front/LeverLength               }
            {   FrontBrake/Scalar/Offset                                Component/Brake/Front/Offset                    }
            
            {   FrontCarrier/ComponentKey/XZ                            Component/Carrier/Front/File                    }
            {   FrontCarrier/Scalar/x                                   Component/Carrier/Front/x                       }
            {   FrontCarrier/Scalar/y                                   Component/Carrier/Front/y                       }
            
            {   FrontDerailleur/ComponentKey/XZ                         Component/Derailleur/Front/File                 }
            {   FrontDerailleur/Scalar/Distance                         Component/Derailleur/Front/Distance             }
            {   FrontDerailleur/Scalar/Offset                           Component/Derailleur/Front/Offset               }
            
            {   FrontFender/Config/Type                                 Rendering/Fender/Front                          }
            {   FrontFender/Scalar/Height                               Component/Fender/Front/Height                   }
            {   FrontFender/Scalar/OffsetAngle                          Component/Fender/Front/OffsetAngle              }
            {   FrontFender/Scalar/OffsetAngleFront                     Component/Fender/Front/OffsetAngleFront         }
            {   FrontFender/Scalar/Radius                               Component/Fender/Front/Radius                   }
            
            {   FrontWheel/Scalar/RimDiameter                           Component/Wheel/Front/RimDiameter               }
            {   FrontWheel/Scalar/RimHeight                             Component/Wheel/Front/RimHeight                 }
            {   FrontWheel/Scalar/TyreHeight                            Component/Wheel/Front/TyreHeight                }
            
            {   Geometry/Scalar/BottomBracket_Depth                     Custom/BottomBracket/Depth                      }
            {   Geometry/Scalar/DownTube_OffsetBB                       Custom/DownTube/OffsetBB                        }
            {   Geometry/Scalar/DownTube_OffsetHT                       Custom/DownTube/OffsetHT                        }
            {   Geometry/Scalar/HandleBar_Distance                      Personal/HandleBar_Distance                     }
            {   Geometry/Scalar/HandleBar_Height                        Personal/HandleBar_Height                       }
            {   Geometry/Scalar/HeadTube_Angle                          Custom/HeadTube/Angle                           }
            {   Geometry/Scalar/Inseam_Length                           Personal/InnerLeg_Length                        }
            {   Geometry/Scalar/Saddle_Distance                         Personal/Saddle_Distance                        }
            {   Geometry/Scalar/Saddle_Height                           Personal/Saddle_Height                          }
            {   Geometry/Scalar/TopTube_Angle                           Custom/TopTube/Angle                            }
            {   Geometry/Scalar/TopTube_OffsetHT                        Custom/TopTube/OffsetHT                         }
            {   Geometry/Scalar/TopTube_PivotOffset                     Custom/TopTube/PivotPosition                    }
            
            {   HandleBar/ComponentKey/XZ                               Component/HandleBar/File                        }
            {   HandleBar/Scalar/PivotAngle                             Component/HandleBar/PivotAngle                  }
            
            {   HeadSet/Scalar/Diameter                                 Component/HeadSet/Diameter                      }
            {   HeadSet/Scalar/Height_Bottom                            Component/HeadSet/Height/Bottom                 }
            {   HeadSet/Scalar/Height_Top                               Component/HeadSet/Height/Top                    }
            
            {   HeadTube/Config/Type                                    Rendering/HeadTube                              }
            {   HeadTube/Scalar/Diameter                                FrameTubes/HeadTube/Diameter                    }
            {   HeadTube/Scalar/DiameterTaperedBase                     FrameTubes/HeadTube/DiameterTaperedBase         }
            {   HeadTube/Scalar/DiameterTaperedTop                      FrameTubes/HeadTube/DiameterTaperedTop          }
            {   HeadTube/Scalar/HeightTaperedBase                       FrameTubes/HeadTube/HeightTaperedBase           }
            {   HeadTube/Scalar/Length                                  FrameTubes/HeadTube/Length                      }
            {   HeadTube/Scalar/LengthTapered                           FrameTubes/HeadTube/LengthTapered               }
            
            {   Label/ComponentKey/XZ                                   Component/Label/File                            }
            
            {   Lug_BottomBracket/Scalar/ChainStay_Angle                Lugs/BottomBracket/ChainStay/Angle/value        }
            {   Lug_BottomBracket/Scalar/ChainStay_Tolerance            Lugs/BottomBracket/ChainStay/Angle/plus_minus   }
            {   Lug_BottomBracket/Scalar/DownTube_Angle                 Lugs/BottomBracket/DownTube/Angle/value         }
            {   Lug_BottomBracket/Scalar/DownTube_Tolerance             Lugs/BottomBracket/DownTube/Angle/plus_minus    }
            {   Lug_HeadBottom/Scalar/Angle                             Lugs/HeadTube/DownTube/Angle/value              }
            {   Lug_HeadBottom/Scalar/Angle_Tolerance                   Lugs/HeadTube/DownTube/Angle/plus_minus         }
            {   Lug_HeadTop/Scalar/Angle                                Lugs/HeadTube/TopTube/Angle/value               }
            {   Lug_HeadTop/Scalar/Angle_Tolerance                      Lugs/HeadTube/TopTube/Angle/plus_minus          }
            {   Lug_Seat/Scalar/Angle                                   Lugs/SeatTube/TopTube/Angle/value               }
            {   Lug_Seat/Scalar/Angle_Tolerance                         Lugs/SeatTube/TopTube/Angle/plus_minus          }
            {   Lug_SeatStay/Scalar/Angle                               Lugs/SeatTube/SeatStay/Angle/value              }
            {   Lug_SeatStay/Scalar/Angle_Tolerance                     Lugs/SeatTube/SeatStay/Angle/plus_minus         }
            {   Lug_SeatStay/Scalar/Diameter_Miter                      Lugs/SeatTube/SeatStay/MiterDiameter            }
            
            {   RearBrake/ComponentKey/XZ                               Component/Brake/Rear/File                       }
            {   RearBrake/Config/Type                                   Rendering/Brake/Rear                            }
            {   RearBrake/Scalar/LeverLength                            Component/Brake/Rear/LeverLength                }
            {   RearBrake/Scalar/Offset                                 Component/Brake/Rear/Offset                     }
            
            {   RearCarrier/ComponentKey/XZ                             Component/Carrier/Rear/File                     }
            {   RearCarrier/Scalar/x                                    Component/Carrier/Rear/x                        }
            {   RearCarrier/Scalar/y                                    Component/Carrier/Rear/y                        }
            
            {   RearDerailleur/ComponentKey/XZ                          Component/Derailleur/Rear/File                  }
            {   RearDerailleur/Scalar/Pulley_teeth                      Component/Derailleur/Rear/Pulley/teeth          }
            {   RearDerailleur/Scalar/Pulley_x                          Component/Derailleur/Rear/Pulley/x              }
            {   RearDerailleur/Scalar/Pulley_y                          Component/Derailleur/Rear/Pulley/y              }
            
            {   RearDropout/ComponentKey/XZ                             Lugs/RearDropOut/File                           }
            {   RearDropout/Config/Layer                                Rendering/RearDropOut                           }
            {   RearDropout/Config/Orient                               Lugs/RearDropOut/Direction                      }
            {   RearDropout/Scalar/Angle                                Lugs/RearDropOut/Angle/value                    }
            {   RearDropout/Scalar/Angle_Tolerance                      Lugs/RearDropOut/Angle/plus_minus               }
            {   RearDropout/Scalar/Derailleur_x                         Lugs/RearDropOut/Derailleur/x                   }
            {   RearDropout/Scalar/Derailleur_y                         Lugs/RearDropOut/Derailleur/y                   }
            {   RearDropout/Scalar/OffsetCS                             Lugs/RearDropOut/ChainStay/Offset               }
            {   RearDropout/Scalar/OffsetCSPerp                         Lugs/RearDropOut/ChainStay/OffsetPerp           }
            {   RearDropout/Scalar/OffsetCS_TopView                     Lugs/RearDropOut/ChainStay/Offset_TopView       }
            {   RearDropout/Scalar/OffsetSS                             Lugs/RearDropOut/SeatStay/Offset                }
            {   RearDropout/Scalar/OffsetSSPerp                         Lugs/RearDropOut/SeatStay/OffsetPerp            }
            {   RearDropout/Scalar/RotationOffset                       Lugs/RearDropOut/RotationOffset                 }
            
            {   RearFender/Config/Type                                  Rendering/Fender/Rear                           }
            {   RearFender/Scalar/Height                                Component/Fender/Rear/Height                    }
            {   RearFender/Scalar/OffsetAngle                           Component/Fender/Rear/OffsetAngle               }
            {   RearFender/Scalar/Radius                                Component/Fender/Rear/Radius                    }
            
            {   RearHub/Scalar/HubWidth                                 Component/Wheel/Rear/HubWidth                   }
            
            {   RearMockup/Scalar/CassetteClearance                     Rendering/RearMockup/CassetteClearance          }
            {   RearMockup/Scalar/ChainWheelClearance                   Rendering/RearMockup/ChainWheelClearance        }
            {   RearMockup/Scalar/CrankClearance                        Rendering/RearMockup/CrankClearance             }
            {   RearMockup/Scalar/DiscClearance                         Rendering/RearMockup/DiscClearance              }
            {   RearMockup/Scalar/DiscDiameter                          Rendering/RearMockup/DiscDiameter               }
            {   RearMockup/Scalar/DiscOffset                            Rendering/RearMockup/DiscOffset                 }
            {   RearMockup/Scalar/DiscWidth                             Rendering/RearMockup/DiscWidth                  }
            {   RearMockup/Scalar/TyreClearance                         Rendering/RearMockup/TyreClearance              }
            
            {   RearWheel/Config/FirstSprocket                          Component/Wheel/Rear/FirstSprocket              }
            {   RearWheel/Scalar/RimDiameter                            Component/Wheel/Rear/RimDiameter                }
            {   RearWheel/Scalar/RimHeight                              Component/Wheel/Rear/RimHeight                  }
            {   RearWheel/Scalar/TyreHeight                             Component/Wheel/Rear/TyreHeight                 }
            {   RearWheel/Scalar/TyreWidth                              Component/Wheel/Rear/TyreWidth                  }
            {   RearWheel/Scalar/TyreWidthRadius                        Component/Wheel/Rear/TyreWidthRadius            }
            
            {   Reference/Scalar/HandleBar_Distance                     Reference/HandleBar_Distance                    }
            {   Reference/Scalar/HandleBar_Height                       Reference/HandleBar_Height                      }
            {   Reference/Scalar/SaddleNose_Distance                    Reference/SaddleNose_Distance                   }
            {   Reference/Scalar/SaddleNose_Height                      Reference/SaddleNose_Height                     }
            
            {   Saddle/ComponentKey/XZ                                  Component/Saddle/File                           }
            {   Saddle/Scalar/Height                                    Component/Saddle/Height                         }
            {   Saddle/Scalar/Length                                    Component/Saddle/Length                         }
            {   Saddle/Scalar/NoseLength                                Component/Saddle/LengthNose                     }
            {   Saddle/Scalar/Offset_x                                  Rendering/Saddle/Offset_X                       }
            
            {   SeatPost/Scalar/Diameter                                Component/SeatPost/Diameter                     }
            {   SeatPost/Scalar/PivotOffset                             Component/SeatPost/PivotOffset                  }
            {   SeatPost/Scalar/Setback                                 Component/SeatPost/Setback                      }
            
            {   SeatStay/Scalar/DiameterCS                              FrameTubes/SeatStay/DiameterCS                  }
            {   SeatStay/Scalar/DiameterST                              FrameTubes/SeatStay/DiameterST                  }
            {   SeatStay/Scalar/OffsetTT                                Custom/SeatStay/OffsetTT                        }
            {   SeatStay/Scalar/TaperLength                             FrameTubes/SeatStay/TaperLength                 }
            
            {   SeatTube/Scalar/DiameterBB                              FrameTubes/SeatTube/DiameterBB                  }
            {   SeatTube/Scalar/DiameterTT                              FrameTubes/SeatTube/DiameterTT                  }
            {   SeatTube/Scalar/Extension                               Custom/SeatTube/Extension                       }
            {   SeatTube/Scalar/OffsetBB                                Custom/SeatTube/OffsetBB                        }
            {   SeatTube/Scalar/TaperLength                             FrameTubes/SeatTube/TaperLength                 }
            
            {   Stem/Scalar/Angle                                       Component/Stem/Angle                            }
            {   Stem/Scalar/Length                                      Component/Stem/Length                           }
            
            {   TopTube/Scalar/DiameterHT                               FrameTubes/TopTube/DiameterHT                   }
            {   TopTube/Scalar/DiameterST                               FrameTubes/TopTube/DiameterST                   }
            {   TopTube/Scalar/TaperLength                              FrameTubes/TopTube/TaperLength                  }
            
            {   _View/Config/Color_Fork                                 Rendering/ColorScheme/Fork                      }
            {   _View/Config/Color_FrameTubes                           Rendering/ColorScheme/FrameTubes                }
            {   _View/Config/Color_Label                                Rendering/ColorScheme/Label                     }
            {   _View/Scalar/Saddle_Offset_x                            Rendering/Saddle/Offset_X                       }
            {   _View/Scalar/Saddle_Offset_y                            Rendering/Saddle/Offset_Y                       }
            
        }
        
            #                                           /root/Crown/Blade/Offset
        
        if {$mode == {domain_2_persist}} {
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
        #
    
    
    bikeFacade::init
        # bikeFacade::report_Namespace
    
        #
    set packageHomeDir  $bikeFacade::packageHomeDir
    set fp [open [file join $packageHomeDir .. etc dataStructure_complete.xml] ]
        fconfigure          $fp -encoding utf-8
        set structureXML    [read $fp]
        close               $fp
            #
        set structureDoc    [dom parse $structureXML]
        set structureRoot   [$structureDoc documentElement]   
    
        #
    puts [$structureRoot asXML]
        #
    set mappingDict     [dict create]    
    set guiDict         [getMappingDict]
    set geometryDict    [bikeFacade::geometry::getMappingDict]
        #
    puts "\n --- guiDict --- "
    appUtil::pdict $guiDict    
    puts "\n --- geometryDict --- "
    appUtil::pdict $geometryDict   
        # exit
    puts "\n --- create main mapping --- "
        #
    foreach arrayNode [$structureRoot childNodes] {
        # this is the arrayName level
        set arrayName [$arrayNode nodeName]
        set arrayDict [dict create]
        foreach typeNode [$arrayNode childNodes] {
            # this is the key level
            set typeName [$typeNode nodeName]
            set typeDict [dict create]
            foreach keyNode [$typeNode childNodes] {
                if {$keyNode == {}} {
                    continue
                }
                set keyName [$keyNode nodeName]
                set modelKey [format {%s/%s/%s} $arrayName $typeName $keyName]
                puts "\n"
                puts "     -> $modelKey <------------------"
                    #
                set guiKey {}
                catch {set guiKey [dict get $guiDict mapping $modelKey]}
                puts "         -- gui -> $guiKey <---------"
                    #
                set geometryKey {}
                catch {set geometryKey [dict get $geometryDict mapping $modelKey]}
                puts "         -- geo -> $geometryKey <----"
                    #
                set keyDict [dict create]
                    dict set    keyDict gui         $guiKey
                    dict set    keyDict geometry    $geometryKey
                    dict set    keyDict frame       {}
                    dict set    keyDict component   {}
                    #
                # appUtil::pdict $keyDict
                    #
                dict append typeDict $modelKey $keyDict
            }
            dict append arrayDict $typeName $typeDict
        }
        dict append mappingDict $arrayName $arrayDict
    }
        #
    appUtil::pdict $mappingDict 2 "    "
        #
        
        #
    puts "   \n --- debug --\n"
        #
    #set myDict [dict get $mappingDict Component/BottleCage_DownTube]    
    #appUtil::pdict $myDict   
        
        
    exit   
    
        
        #
    puts "\n --- bikeFacade::get_DataStructure xmlStructure ---"
        # bikeFacade::get_DataStructure arrayStructure report
    set targetRoot [bikeFacade::get_DataStructure]
    set targetDoc  [$targetRoot ownerDocument]
        #
        
        #
    puts "\n --- getMappingDict ---"
    set mappingDict [getMappingDict]
        # appUtil::pdict $mappingDict
        #
        
        #
    set projectFile [file join $SAMPLE_Dir __road_3.4.03.00_legend_02.xml]
            #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set sourceDoc       [dom parse $projetXML]
        set sourceRoot      [$sourceDoc documentElement]    
            #
        #
        
        #
    foreach targetKey [dict keys [dict get $mappingDict mapping]] {
        set sourceKey [dict get $mappingDict mapping $targetKey]
        set projectValue [$sourceRoot selectNodes /root/$sourceKey/text()]
        if {$projectValue != {}} {
            set value [$projectValue asXML]
            puts "    -> $targetKey   -> $sourceKey   .... $value"
        } else {
            puts "         -> $targetKey   -> $sourceKey"
        }
        set targetNode [$targetRoot selectNodes /root/$targetKey]
        set textNode   [$targetDoc createTextNode $value]
        puts "                -> $targetNode [$targetNode asXML]"
        $targetNode appendChild $textNode
    }
        #

        #
    puts "\n --- bikeFacade::init_Project $targetRoot ---"
    bikeFacade::update_Project $targetRoot
        #
        
        #
    puts "\n --- bikeFacade::report_Namespace ---"
    bikeFacade::report_Namespace
        #
        
        #
    puts "\n --- bikeFacade::init_bikeGeometry ---"
    bikeFacade::update_bikeGeometry
        #
        
        #
    bikeFacade::report_Namespace
        #
        
        #
    exit
    
    
 