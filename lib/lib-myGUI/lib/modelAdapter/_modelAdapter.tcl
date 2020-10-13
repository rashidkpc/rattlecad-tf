 ##+##########################################################################
 #
 # package: rattleCAD    ->    _model.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2014/01/11
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
 #    namespace:  myGUI::modelAdapter
 # ---------------------------------------------------------------------------
 #
 # 
 # --- this is the interface to the bikeGeometry - namespace
 #

namespace eval myGUI::modelAdapter {

    variable  persistenceRoot   ; set persistenceRoot [[dom parse "<root/>"] documentElement] ;# a XML-Object
      
      # ----------------- #	    
    variable  modelDICT_GUI     {}   
    variable  modelDICT         {}   
    variable  modelUpdate        0

      # ----------------- #	
    variable  valueRegistry 
    array set valueRegistry     {}
    
      # ----------------- #	
    variable geometry_IF        ::bikeGeometry::IF_OutsideIn
      
      # ----------------- #	
    variable modelContext
    variable model_BikeModel 
      
      # ----------------- #
    variable persistenceObject  [myPersist::Persistence new]
      
      # ----------------- #	
      
    variable global_dict2List   {}
      
      
      
        # namespace import ::bikeGeometry::get_projectDICT
        #
        #
        # namespace import ::bikeComponents::set_Component
        # namespace import ::bikeComponents::get_Component
        # namespace import ::bikeComponents::get_ComponentDir 
        # namespace import ::bikeComponents::get_ComponentDirectories
        #
        # namespace import ::bikeGeometry::set_Component
        # namespace import ::bikeGeometry::set_Config
        # namespace import ::bikeGeometry::set_ListValue
        #
        # namespace import ::bikeGeometry::get_Component
        # namespace import ::bikeGeometry::get_ComponentDir 
        # namespace import ::bikeGeometry::get_ComponentDirectories
        #
        # namespace import ::bikeGeometry::import_ProjectSubset
        #
        # namespace import ::bikeGeometry::get_ListBoxValues 
        #
    # namespace import ::bikeGeometry::get_DebugGeometry
        #
    # namespace import ::bikeGeometry::validate_ChainStayCenterLine
        #
    # namespace import ::bikeGeometry::coords_xy_index
        #
    # namespace import ::bikeGeometry::get_Config
    # namespace import ::bikeGeometry::get_ListValue
    # namespace import ::bikeGeometry::get_Scalar
        #
    # namespace import ::bikeGeometry::get_Polygon
    # namespace import ::bikeGeometry::get_Position
    # namespace import ::bikeGeometry::get_Direction
    # namespace import ::bikeGeometry::get_BoundingBox
    # namespace import ::bikeGeometry::get_CenterLine
    # namespace import ::bikeGeometry::get_TubeMiter
    # namespace import ::bikeGeometry::get_TubeMiterDICT
    # namespace import ::bikeGeometry::get_paramComponent
        #
    # namespace import ::bikeGeometry::get_BoundingBox
    # namespace import ::bikeGeometry::get_paramComponent
        #
    
}

    
    proc myGUI::modelAdapter::init {} {
            #

            # -- directories of custom user components
        myGUI::modelAdapter::update_UserCompDirectories
            #
            # -- directories of local templates
        myGUI::modelAdapter::update_UserTemplateDirecty
            #
            # -- load template
        myGUI::modelAdapter::open_ProjectFile $::APPL_Config(TemplateInit)
            #
            # -- set session
		myGUI::control::setSession  projectName       "Template $::APPL_Config(TemplateType)"
		myGUI::control::setSession  projectSave       [expr 2 * [clock milliseconds]] 
        myGUI::control::setSession  dateModified      "template"        
            #
        return
            #
    }    
    
    

        # -------------------------------------------------------------------------
        #  return all geometry-values to create specified tube in absolute position
        #  set interface (strategy-pattern)
        #
    proc myGUI::modelAdapter::set_geometry_IF {interfaceName} {
            #
        variable modelContext
            #
        set lastIF_Name     [$modelContext get_geometryIF]    
        set geometryIF_Name [$modelContext set_geometryIF $interfaceName]
            #
        if {$geometryIF_Name != $lastIF_Name} {
            return 1
        } else {
            return 0
        }
            #
    }
        #
        #
    proc myGUI::modelAdapter::add_ComponentDir {key dir} {
            #
            # puts "          myGUI::modelAdapter::add_ComponentDir"    
            #
		variable modelContext
            #
        set retValue    [$modelContext add_ComponentDir $key $dir]
            #
        puts "                             -> $retValue\n"
            #
        return $retValue
            #    
    }
        #
    proc myGUI::modelAdapter::get_ComponentDir {} {
            #
        puts "          myGUI::modelAdapter::get_ComponentDir"    
            #
		variable modelContext
            #
        set componentDir    [$modelContext get_ComponentDir]
            #
        puts "                             -> $componentDir\n"
            #
        return $componentDir
            #    
    }
        #
    proc myGUI::modelAdapter::get_ComponentDirectories {} {
            #
        puts "          myGUI::modelAdapter::get_ComponentDirectories"    
            #
		variable modelContext
            #
        set componentDirectories    [$modelContext get_ComponentDirectories]
            #
        puts "                             -> $componentDirectories\n"
            #
        return $componentDirectories
            #    
    }
        #
    proc myGUI::modelAdapter::get_ComponentSubDirectories {} {
            #
        puts "          myGUI::modelAdapter::get_ComponentSubDirectories"    
            #
		variable modelContext
            #
        set componentSubDirectories [$modelContext get_ComponentSubDirectories]
            #
        puts "                             -> $componentSubDirectories\n"
            #
        return $componentSubDirectories
            #    
    }
        #
    proc myGUI::modelAdapter::get_ComponentList {key} {
            #
        variable modelContext 
            #
        # puts "      ...   myGUI::modelAdapter::get_ComponentList $key"
            #
        set xPath       [string map {: /} $key]
            #
        switch -exact $key {
            RearDropout -
            ForkCrown -
            ForkDropout {
                    set compList    [myPersist::file::get_componentAlternatives  $xPath]
                }
            default {
                    set compList    [$modelContext get_componentAlternatives  $xPath]
                }
        }
            # set compList    [myPersist::file::get_componentAlternatives  $xPath]
        
            #
        # puts "\n------------------------------"
        # puts " -> \$compList $compList"
            #
        return $compList
            #
    }        
        #
    proc myGUI::modelAdapter::get_ComponentPath {key value} {
            #
        puts "          myGUI::modelAdapter::get_ComponentPath $key $value"    
            #
        variable modelContext
            #
        set componentPath   [$modelContext get_ComponentPath $key $value]
            #
        puts "                             -> $componentPath\n"
            #
        return $componentPath
            #
    }
        #
    proc myGUI::modelAdapter::get_DebugGeometry {} {
            #
        puts "          myGUI::modelAdapter::get_DebugGeometry"    
            #
		variable modelContext
            #
        set debugGeometry    [$modelContext get_DebugGeometry]
            #
        puts "                             -> $debugGeometry\n"
            #
        return $debugGeometry
            #    
    }
        #
        #
    proc myGUI::modelAdapter::set_Value {key value} {
            #
        puts "            myGUI::modelAdapter::set_Value $key $value"    
            #
		variable modelContext
            #
        set valueKey    [string map {: /} $key]    
        puts "                                           $valueKey $value"    
            #
        set newValue    [$modelContext set_Value $valueKey $value]
            #
        puts "                             -> $newValue\n"
            #
        return $newValue
            #
    }
        #
    proc myGUI::modelAdapter::set_Config {key value} {
            #
        puts "          myGUI::modelAdapter::set_Config $key $value"    
            #
		variable modelContext
            #
        set configValue       [$modelContext set_Config $key $value]
            #
        puts "                             -> $configValue\n"
            #
        return $configValue
            #
    }
        #
    proc myGUI::modelAdapter::set_Component {key value} {
            #
        puts "          myGUI::modelAdapter::set_Component $key $value"    
            #
        variable modelContext
            #
        set componentValue  [$modelContext set_Component $key $value]
            #
        puts "                             -> $componentValue\n"
            #
        return $componentValue
            #
    }
        #
    proc myGUI::modelAdapter::set_ListValue {key value} {
            #
        puts "          myGUI::modelAdapter::set_ListValue $key $value"    
            #
        variable modelContext
            #
        set listValue   [$modelContext set_ListValue $key $value]
            #
        puts "                             -> $listValue\n"
            #
        return $listValue
            #
    }
        #
    proc myGUI::modelAdapter::set_Scalar {object key value} {
            #
        puts "          myGUI::modelAdapter::set_Scalar $object $key $value"    
            #
        variable modelContext
            #
        set scalarValue [$modelContext set_Scalar ${object} ${key} ${value}]
            #
        puts "                             -> $scalarValue\n"
            #
        return $scalarValue
            #
            #
    }
        #
        #
    proc myGUI::modelAdapter::set_ValueList {keyValueList} {
            #
        puts "            myGUI::modelAdapter::set_Value $keyValueList"    
            #
		variable modelContext
            #
        set newList {}
        foreach {key value} $keyValueList {
            set valueKey    [string map {: /} $key]    
            puts "                                           $valueKey $value"
            lappend newList $valueKey $value
        }
            #
        set newValueList    [$modelContext set_ValueList $newList]
            #
        foreach {key value} $newValueList {
            # puts "                             -> $newValueList\n"
            puts "                             -> $key $value\n"
        }
            #
        set returnList {}
        foreach {key value} $newValueList {
            foreach {a b c} [split $key /] break
            set guiKey [format {%s:%s/%s} $a $b $c]
            lappend returnList $guiKey $value
        }
            #
        return $returnList
            #
    }
        #
        #
    proc myGUI::modelAdapter::validate_ChainStayCenterLine {dict} {
            #
        variable  geometry_IF
        return  [$geometry_IF validate_ChainStayCenterLine $dict]
            #
    }    
        #
        #
        #
        # -------------------------------------------------------------------------
        #
    proc myGUI::modelAdapter::open_ProjectFile {projectFile} {
            #
        variable persistenceRoot
            # variable bikeObject
            #
        variable persistenceObject 
        variable modelContext 
            #
        puts "\n"
		puts "   -------------------------------"
		puts "    myGUI::modelAdapter::open_ProjectFile"
		
            #
		catch {[$persistenceRoot ownerDocument] delete}
        set persistenceRoot [$persistenceObject readFile_rattleCAD $projectFile]
            #
            
            #
        if {$persistenceRoot == {}} {
            return
        }
            
            #
        set projectVersion  [[$persistenceRoot selectNodes /root/Project/rattleCADVersion/text()] asXML]
        set projectName     [[$persistenceRoot selectNodes /root/Project/Name/text()]             asXML]
        set projectModified [[$persistenceRoot selectNodes /root/Project/modified/text()]         asXML]       
            #
        puts "         ... version:    $projectVersion"
            #
        myGUI::control::setSession  projectFile       [file normalize $projectFile]
        myGUI::control::setSession  projectName       [file rootname [file tail $projectFile]]
        myGUI::control::setSession  projectSave       [clock milliseconds]
        myGUI::control::setSession  dateModified      ${projectModified}
            #
            #
            #
        $modelContext initDomainParameters
        $modelContext readProjectDoc    [$persistenceRoot ownerDocument]
            #
            #
            # -- update MVC - Model 
        myGUI::modelAdapter::updateModel
            #
            #
               
            # --
        return
            #
    }
        #
        #
    proc myGUI::modelAdapter::updateModel {} {
            #
        variable modelContext
            #
        variable modelDICT_GUI
		variable modelDICT
		variable modelUpdate 
            #
            # update control-model
		    #
        set modelDICT_GUI   [$modelContext getGUIDictionary]
        set modelDICT       [$modelContext getModelDictionary]
            #
            # appUtil::pdict $modelDICT_GUI
            # exit
            #
            # update timestamp
		set modelUpdate     [clock milliseconds]
            # set ::APPL_Config(cadCanvas_Update) [clock milliseconds]
            #
	}
        #
        #
    proc myGUI::modelAdapter::updateModel_Info {targetNamespace} {
            #
        variable modelContext
        variable persistenceRoot   
            #
        variable modelDICT_GUI
            #
            # puts "\n\n    --- myGUI::modelAdapter::updateModel_Edit ---"
            #
        ${targetNamespace}::setDictionary   modelDICT   $modelDICT_GUI
            #
            #
        ${targetNamespace}::setDOMNode      persistenceRoot $persistenceRoot
            #
            # ${targetNamespace}::setDOMNode      persistenceDOM  [$modelContext getPersistenceDOM]
            #
            #
        return     
            #
    }
        #
        #
    proc myGUI::modelAdapter::updateModel_Edit {targetNamespace} {
            #
        variable modelDICT_GUI
            #
            # puts "\n\n    --- myGUI::modelAdapter::updateModel_Edit ---"
            #
        dict for {arrayName _dict} ${modelDICT_GUI} {
                # appUtil::pdict $_dict
            set pathList [myGUI::modelAdapter::_dict2List {} $_dict {}]
            foreach {path} $pathList {
                    # puts "updateModel_Edit: $path"
                set pathValue [appUtil::get_dictValue $_dict $path]
                    #
                switch -exact $arrayName {
                    Component   {${targetNamespace}::setComponent  $path $pathValue}
                    Config      {${targetNamespace}::setConfig     $path $pathValue}
                    ListValue   {${targetNamespace}::setListValue  $path $pathValue}
                    Scalar      {${targetNamespace}::setScalar     $path $pathValue}
                    default     {
                                    #puts "     <W> updateModel_Edit ... $arrayName: $path / $pathValue"
                                }
                }
                    #
            }
                #
            # ${targetNamespace}::setScalar Geometry/ChainStay_Length   [dict get $modelDICT_GUI  Scalar    Geometry    ChainStay_Length]
            ${targetNamespace}::setScalar   Geometry/Fork_Height        [dict get $modelDICT_GUI  Scalar    Fork        Height]
            ${targetNamespace}::setScalar   Geometry/Fork_Rake          [dict get $modelDICT_GUI  Scalar    Fork        Rake]
            ${targetNamespace}::setScalar   Geometry/HeadTube_Length    [dict get $modelDICT_GUI  Scalar    HeadTube    Length]
            ${targetNamespace}::setScalar   Geometry/FrontRim_Diameter  [dict get $modelDICT_GUI  Scalar    FrontWheel  RimDiameter]
            ${targetNamespace}::setScalar   Geometry/FrontTyre_Height   [dict get $modelDICT_GUI  Scalar    FrontWheel  TyreHeight]
            ${targetNamespace}::setScalar   Geometry/FrontWheel_x       [dict get $modelDICT_GUI  Scalar    Geometry    FrontWheel_X]
            ${targetNamespace}::setScalar   Geometry/FrontWheel_xy      [dict get $modelDICT_GUI  Scalar    Geometry    FrontWheel_XZ]
            ${targetNamespace}::setScalar   Geometry/RearRim_Diameter   [dict get $modelDICT_GUI  Scalar    RearWheel   RimDiameter]
            ${targetNamespace}::setScalar   Geometry/RearTyre_Height    [dict get $modelDICT_GUI  Scalar    RearWheel   TyreHeight]
            ${targetNamespace}::setScalar   Geometry/RearWheel_x        [dict get $modelDICT_GUI  Scalar    Geometry    RearWheel_X]
            ${targetNamespace}::setScalar   Geometry/Saddle_HB_x        [dict get $modelDICT_GUI  Scalar    Geometry    Saddle_HB_X]
            ${targetNamespace}::setScalar   Geometry/Saddle_HB_y        [dict get $modelDICT_GUI  Scalar    Geometry    Saddle_HB_Z]
            ${targetNamespace}::setScalar   Geometry/SaddleNose_BB_x    [dict get $modelDICT_GUI  Scalar    Geometry    SaddleNose_BB_X]
            ${targetNamespace}::setScalar   Geometry/Stem_Angle         [dict get $modelDICT_GUI  Scalar    Stem        Angle]
            ${targetNamespace}::setScalar   Geometry/Stem_Length        [dict get $modelDICT_GUI  Scalar    Stem        Length]
            ${targetNamespace}::setScalar   HeadSet/Height_Bottom       [dict get $modelDICT_GUI  Scalar    HeadSet     Height_Bottom]
            ${targetNamespace}::setScalar   HeadSet/Height_Top          [dict get $modelDICT_GUI  Scalar    HeadSet     Height_Top]
                #
        }
            #
    }
        #
    proc myGUI::modelAdapter::updateModel_Edit_ListBoxValues {targetNamespace} {    
            #
        variable modelContext
            #
        set _listDict [$modelContext get_ListBoxValues]
            #
            # puts " -> $_listDict"
            # appUtil::pdict $_listDict
            #
        dict for {listName _dict} ${_listDict} {
                # puts "   -> $listName : $_dict"
            switch -exact $listName {
                ComponentLocation {
                        ${targetNamespace}::setListBoxValues $listName $_dict
                    }
                default {
                        ${targetNamespace}::setListBoxValues $listName $_dict
                    }
            }
        }
            #
            # ${targetNamespace}::reportListBoxValues
        return    
            #
    }    
        #
        #
    proc myGUI::modelAdapter::updateModel_TubeMiter {targetNamespace} {
        
        puts "\n\n    --- myGUI::modelAdapter::updateModel_TubeMiter ---"
            #
        variable modelDICT_GUI
            #
            
            # --- dictionary ---- Custom CrankSet ---------
            #
            # appUtil::pdict [dict get $modelDICT_GUI    TubeMiter]
        ${targetNamespace}::setDictionary   TubeMiter                   [dict get $modelDICT_GUI    TubeMiter]
            #
    }
        #
    proc myGUI::modelAdapter::updateModel_XY {targetNamespace} {
        
        puts "\n\n    --- myGUI::modelAdapter::updateModel_XY ---"
            #
        variable modelDICT_GUI
            #
        
            # --- dictionary -----------------------------
            #
        ${targetNamespace}::setCenterLine   RearMockup_CtrLines         [join [dict get $modelDICT_GUI  CenterLine RearMockup_CtrLines] " "]
        ${targetNamespace}::setCenterLine   RearMockup                  [join [dict get $modelDICT_GUI  CenterLine RearMockup       ]   " "]
        ${targetNamespace}::setCenterLine   RearMockup_UnCut            [join [dict get $modelDICT_GUI  CenterLine RearMockup_UnCut ]   " "]
            #
        ${targetNamespace}::setComponentNode  CrankSet                  [dict get $modelDICT_GUI  ComponentNode   CrankSet_XY_Custom    ]
        ${targetNamespace}::setComponentNode  RearFender_XY             [dict get $modelDICT_GUI  ComponentNode   RearFender_XY         ]
        ${targetNamespace}::setComponentNode  RearHub                   [dict get $modelDICT_GUI  ComponentNode   RearHub               ]
        ${targetNamespace}::setComponentNode  RearHub_Disc              [dict get $modelDICT_GUI  ComponentNode   RearHub_Disc          ]
            #
        ${targetNamespace}::setConfig       ChainStay                   [dict get $modelDICT_GUI  Config    ChainStay]
        ${targetNamespace}::setConfig       RearFender                  [dict get $modelDICT_GUI  Config    RearFender]
            #
        ${targetNamespace}::setListValue    CrankSetChainRings          [split [dict get $modelDICT_GUI  ListValue CrankSetChainRings] -]
            #
        ${targetNamespace}::setPolygon      ChainStay                   [join [dict get $modelDICT_GUI  Polygon ChainStay           ]   " "]
        ${targetNamespace}::setPolygon      CrankArm_XY                 [join [dict get $modelDICT_GUI  Polygon CrankArm_xy         ]   " "]           
        ${targetNamespace}::setPolygon      ChainStay_XY                [join [dict get $modelDICT_GUI  Polygon ChainStay_XY        ]   " "]
        ${targetNamespace}::setPolygon      RearFender_XY               [join [dict get $modelDICT_GUI  Polygon RearFender_XY       ]   " "]
            #
        ${targetNamespace}::setProfile      ChainStay_XY                [join [dict get $modelDICT_GUI  Profile ChainStay_XY        ]   " "]
            #
        ${targetNamespace}::setPosition     ChainStay_XY                [join [dict get $modelDICT_GUI  Position    ChainStay_XY    ]   " "]  
            #
        ${targetNamespace}::setScalar       BottomBracket   InsideDiameter                      [dict get $modelDICT_GUI  Scalar    BottomBracket InsideDiameter           ]
        ${targetNamespace}::setScalar       BottomBracket   OffsetCS_TopView                    [dict get $modelDICT_GUI  Scalar    BottomBracket OffsetCS_TopView         ]
        ${targetNamespace}::setScalar       BottomBracket   OutsideDiameter                     [dict get $modelDICT_GUI  Scalar    BottomBracket OutsideDiameter          ]
        ${targetNamespace}::setScalar       BottomBracket   Width                               [dict get $modelDICT_GUI  Scalar    BottomBracket Width                    ]
        ${targetNamespace}::setScalar       ChainStay       WidthBB                             [dict get $modelDICT_GUI  Scalar    ChainStay WidthBB                      ]
        ${targetNamespace}::setScalar       ChainStay       completeLength                      [dict get $modelDICT_GUI  Scalar    ChainStay completeLength               ]
        ${targetNamespace}::setScalar       ChainStay       cuttingAngle                        [dict get $modelDICT_GUI  Scalar    ChainStay cuttingAngle                 ]
        ${targetNamespace}::setScalar       ChainStay       cuttingLeft                         [dict get $modelDICT_GUI  Scalar    ChainStay cuttingLeft                  ]
        ${targetNamespace}::setScalar       ChainStay       cuttingLength                       [dict get $modelDICT_GUI  Scalar    ChainStay Length                       ]
        ${targetNamespace}::setScalar       ChainStay       profile_x01                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_x01                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_x02                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_x02                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_x03                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_x03                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y00                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_y00                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y01                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_y01                  ]
        ${targetNamespace}::setScalar       ChainStay       profile_y02                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_y02                  ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_01                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_01              ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_02                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_02              ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_03                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_03              ]
        ${targetNamespace}::setScalar       ChainStay       segmentAngle_04                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_04              ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_01                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_01             ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_02                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_02             ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_03                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_03             ]
        ${targetNamespace}::setScalar       ChainStay       segmentLength_04                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_04             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_01                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_01             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_02                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_02             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_03                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_03             ]
        ${targetNamespace}::setScalar       ChainStay       segmentRadius_04                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_04             ]
        ${targetNamespace}::setScalar       CrankSet        ArmWidth                            [dict get $modelDICT_GUI  Scalar    CrankSet ArmWidth                      ]
        ${targetNamespace}::setScalar       CrankSet        ChainLine                           [dict get $modelDICT_GUI  Scalar    CrankSet ChainLine                     ]
        ${targetNamespace}::setScalar       CrankSet        ChainRingOffset                     [dict get $modelDICT_GUI  Scalar    CrankSet ChainRingOffset               ]
        ${targetNamespace}::setScalar       CrankSet        Length                              [dict get $modelDICT_GUI  Scalar    CrankSet Length                        ]
        ${targetNamespace}::setScalar       CrankSet        PedalEye                            [dict get $modelDICT_GUI  Scalar    CrankSet PedalEye                      ]
        ${targetNamespace}::setScalar       CrankSet        Q-Factor                            [dict get $modelDICT_GUI  Scalar    CrankSet Q-Factor                      ]
        ${targetNamespace}::setScalar       Geometry        ChainStay_Length                    [dict get $modelDICT_GUI  Scalar    Geometry ChainStay_Length              ]
        ${targetNamespace}::setScalar       Geometry        RearRim_Diameter                    [dict get $modelDICT_GUI  Scalar    RearWheel RimDiameter                  ]
        ${targetNamespace}::setScalar       Geometry        RearTyre_Height                     [dict get $modelDICT_GUI  Scalar    RearWheel TyreHeight                   ]
        ${targetNamespace}::setScalar       RearBrake       DiscDiameter                        [dict get $modelDICT_GUI  Scalar    RearBrake DiscDiameter                 ]
        ${targetNamespace}::setScalar       RearBrake       DiscWidth                           [dict get $modelDICT_GUI  Scalar    RearBrake DiscWidth                    ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCS                            [dict get $modelDICT_GUI  Scalar    RearDropout OffsetCS                   ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCS_TopView                    [dict get $modelDICT_GUI  Scalar    RearDropout OffsetCS_TopView           ]
        ${targetNamespace}::setScalar       RearFender      Radius                              [dict get $modelDICT_GUI  Scalar    RearFender Radius                      ]
        ${targetNamespace}::setScalar       RearMockup      CassetteClearance                   [dict get $modelDICT_GUI  Scalar    RearMockup CassetteClearance           ]
        ${targetNamespace}::setScalar       RearMockup      ChainWheelClearance                 [dict get $modelDICT_GUI  Scalar    RearMockup ChainWheelClearance         ]
        ${targetNamespace}::setScalar       RearMockup      CrankClearance                      [dict get $modelDICT_GUI  Scalar    RearMockup CrankClearance              ]
        ${targetNamespace}::setScalar       RearMockup      DiscClearance                       [dict get $modelDICT_GUI  Scalar    RearMockup DiscClearance               ]
        ${targetNamespace}::setScalar       RearMockup      DiscOffset                          [dict get $modelDICT_GUI  Scalar    RearMockup DiscOffset                  ]
        ${targetNamespace}::setScalar       RearMockup      TyreClearance                       [dict get $modelDICT_GUI  Scalar    RearMockup TyreClearance               ]
        ${targetNamespace}::setScalar       RearWheel       FirstSprocket                       [dict get $modelDICT_GUI  Scalar    RearWheel FirstSprocket                ]
        ${targetNamespace}::setScalar       RearWheel       HubWidth                            [dict get $modelDICT_GUI  Scalar    RearWheel HubWidth                     ]
        ${targetNamespace}::setScalar       RearWheel       TyreWidth                           [dict get $modelDICT_GUI  Scalar    RearWheel TyreWidth                    ]
        ${targetNamespace}::setScalar       RearWheel       TyreWidthRadius                     [dict get $modelDICT_GUI  Scalar    RearWheel TyreWidthRadius              ]
            #  
    }
        #
    proc myGUI::modelAdapter::updateModel_XZ {targetNamespace} {
        
        puts "\n\n    --- myGUI::modelAdapter::updateModel_XZ ---"
            #
        variable modelDICT_GUI
            #
        ${targetNamespace}::setComponent    CrankSet                    [dict get $modelDICT_GUI  Component CrankSet                    ]
        ${targetNamespace}::setComponent    ForkCrown                   [dict get $modelDICT_GUI  Component ForkCrown                   ]
        ${targetNamespace}::setComponent    ForkDropout                 [dict get $modelDICT_GUI  Component ForkDropout                 ]
        ${targetNamespace}::setComponent    FrontBrake                  [dict get $modelDICT_GUI  Component FrontBrake                  ]
        ${targetNamespace}::setComponent    FrontCarrier                [dict get $modelDICT_GUI  Component FrontCarrier                ]
        ${targetNamespace}::setComponent    FrontDerailleur             [dict get $modelDICT_GUI  Component FrontDerailleur             ]
        ${targetNamespace}::setComponent    HandleBar                   [dict get $modelDICT_GUI  Component HandleBar                   ]
        ${targetNamespace}::setComponent    Label                       [dict get $modelDICT_GUI  Component Label                       ]
        ${targetNamespace}::setComponent    RearBrake                   [dict get $modelDICT_GUI  Component RearBrake                   ]
        ${targetNamespace}::setComponent    RearCarrier                 [dict get $modelDICT_GUI  Component RearCarrier                 ]
        ${targetNamespace}::setComponent    RearDerailleur              [dict get $modelDICT_GUI  Component RearDerailleur              ]
        ${targetNamespace}::setComponent    RearDropout                 [dict get $modelDICT_GUI  Component RearDropout                 ]
        ${targetNamespace}::setComponent    RearHub                     [dict get $modelDICT_GUI  Component RearHub                     ]
        ${targetNamespace}::setComponent    Saddle                      [dict get $modelDICT_GUI  Component Saddle                      ]
            #
        ${targetNamespace}::setComponentNode  BottleCage_DownTube       [dict get $modelDICT_GUI  ComponentNode   BottleCage_DownTube   ]
        ${targetNamespace}::setComponentNode  BottleCage_DownTube_Lower [dict get $modelDICT_GUI  ComponentNode   BottleCage_DownTube_Lower ]
        ${targetNamespace}::setComponentNode  BottleCage_SeatTube       [dict get $modelDICT_GUI  ComponentNode   BottleCage_SeatTube   ]
        ${targetNamespace}::setComponentNode  CrankSet                  [dict get $modelDICT_GUI  ComponentNode   CrankSet_XZ           ]
        ${targetNamespace}::setComponentNode  CrankSet_Custom           [dict get $modelDICT_GUI  ComponentNode   CrankSet_XZ_Custom    ]
        ${targetNamespace}::setComponentNode  ForkCrown                 [dict get $modelDICT_GUI  ComponentNode   ForkCrown             ]
        ${targetNamespace}::setComponentNode  ForkBlade                 [dict get $modelDICT_GUI  ComponentNode   ForkBlade             ]
        ${targetNamespace}::setComponentNode  ForkDropout               [dict get $modelDICT_GUI  ComponentNode   ForkDropout           ]
        ${targetNamespace}::setComponentNode  FrontBrake                [dict get $modelDICT_GUI  ComponentNode   FrontBrake            ]
        ${targetNamespace}::setComponentNode  FrontCarrier              [dict get $modelDICT_GUI  ComponentNode   FrontCarrier          ]
        ${targetNamespace}::setComponentNode  FrontDerailleur           [dict get $modelDICT_GUI  ComponentNode   FrontDerailleur       ]
        ${targetNamespace}::setComponentNode  FrontFender_XZ            [dict get $modelDICT_GUI  ComponentNode   FrontFender_XZ        ]
        ${targetNamespace}::setComponentNode  Label                     [dict get $modelDICT_GUI  ComponentNode   Label                 ]
        ${targetNamespace}::setComponentNode  HandleBar                 [dict get $modelDICT_GUI  ComponentNode   HandleBar             ]
        ${targetNamespace}::setComponentNode  HeadSetBottom             [dict get $modelDICT_GUI  ComponentNode   HeadSetBottom         ]
        ${targetNamespace}::setComponentNode  HeadSetTop                [dict get $modelDICT_GUI  ComponentNode   HeadSetTop            ]
        ${targetNamespace}::setComponentNode  RearBrake                 [dict get $modelDICT_GUI  ComponentNode   RearBrake             ]
        ${targetNamespace}::setComponentNode  RearCarrier               [dict get $modelDICT_GUI  ComponentNode   RearCarrier           ]
        ${targetNamespace}::setComponentNode  RearDerailleur            [dict get $modelDICT_GUI  ComponentNode   RearDerailleur        ]
        ${targetNamespace}::setComponentNode  RearDropout               [dict get $modelDICT_GUI  ComponentNode   RearDropout           ]
        ${targetNamespace}::setComponentNode  RearFender_XZ             [dict get $modelDICT_GUI  ComponentNode   RearFender_XZ         ]
        ${targetNamespace}::setComponentNode  Saddle                    [dict get $modelDICT_GUI  ComponentNode   Saddle                ]
        ${targetNamespace}::setComponentNode  SeatPost                  [dict get $modelDICT_GUI  ComponentNode   SeatPost              ]
        ${targetNamespace}::setComponentNode  Steerer                   [dict get $modelDICT_GUI  ComponentNode   Steerer               ]
        ${targetNamespace}::setComponentNode  Stem                      [dict get $modelDICT_GUI  ComponentNode   Stem                  ]
        
        # ${targetNamespace}::setComponent      ForkSupplier            [dict get $modelDICT_GUI  Component ForkSupplier                ]
        # ${targetNamespace}::setComponentNode  ForkSupplier            [dict get $modelDICT_GUI  ComponentNode   ForkSupplier          ]
            
            # --- get config Values -----------------------
            #
        ${targetNamespace}::setConfig       CrankSet                    [dict get $modelDICT_GUI  Component CrankSet]
            #
        ${targetNamespace}::setConfig       ChainStay                   [dict get $modelDICT_GUI  Config    ChainStay]
        ${targetNamespace}::setConfig       FrontBrake                  [dict get $modelDICT_GUI  Config    FrontBrake]
        ${targetNamespace}::setConfig       RearBrake                   [dict get $modelDICT_GUI  Config    RearBrake]
        ${targetNamespace}::setConfig       FrontFender                 [dict get $modelDICT_GUI  Config    FrontFender]
        ${targetNamespace}::setConfig       RearFender                  [dict get $modelDICT_GUI  Config    RearFender]
        ${targetNamespace}::setConfig       BottleCage_SeatTube         [dict get $modelDICT_GUI  Config    BottleCage_SeatTube]
        ${targetNamespace}::setConfig       BottleCage_DownTube         [dict get $modelDICT_GUI  Config    BottleCage_DownTube]
        ${targetNamespace}::setConfig       BottleCage_DownTube_Lower   [dict get $modelDICT_GUI  Config    BottleCage_DownTube_Lower]
        ${targetNamespace}::setConfig       Fork                        [dict get $modelDICT_GUI  Config    Fork]
        ${targetNamespace}::setConfig       ForkDropout                 [dict get $modelDICT_GUI  Config    ForkDropout]
        ${targetNamespace}::setConfig       HeadTube                    [dict get $modelDICT_GUI  Config    HeadTube]
        ${targetNamespace}::setConfig       RearDropout                 [dict get $modelDICT_GUI  Config    RearDropout]
        ${targetNamespace}::setConfig       RearDropoutOrient           [dict get $modelDICT_GUI  Config    RearDropoutOrient]
        ${targetNamespace}::setConfig       Stem                        [dict get $modelDICT_GUI  Config    Stem]
                    
            # --- set direction values --------------------
            #
        ${targetNamespace}::setDirection    ChainStay                   [join   [dict get $modelDICT_GUI  Direction ChainStay]      " "]
        ${targetNamespace}::setDirection    DownTube                    [join   [dict get $modelDICT_GUI  Direction DownTube]       " "]
        ${targetNamespace}::setDirection    ForkBlade                   [join   [dict get $modelDICT_GUI  Direction ForkBlade]      " "]
        ${targetNamespace}::setDirection    ForkCrown                   [join   [dict get $modelDICT_GUI  Direction ForkCrown]      " "]
        ${targetNamespace}::setDirection    ForkDropout                 [join   [dict get $modelDICT_GUI  Direction ForkDropout]    " "]
        ${targetNamespace}::setDirection    HeadTube                    [join   [dict get $modelDICT_GUI  Direction HeadTube]       " "]
        ${targetNamespace}::setDirection    Label                       [join   [dict get $modelDICT_GUI  Direction Label]          " "]
        ${targetNamespace}::setDirection    RearDropout                 [join   [dict get $modelDICT_GUI  Direction RearDropout]    " "]
        ${targetNamespace}::setDirection    SeatStay                    [join   [dict get $modelDICT_GUI  Direction SeatStay]       " "]           
        ${targetNamespace}::setDirection    SeatTube                    [join   [dict get $modelDICT_GUI  Direction SeatTube]       " "]           
        ${targetNamespace}::setDirection    Steerer                     [join   [dict get $modelDICT_GUI  Direction Steerer]        " "]
            #
        ${targetNamespace}::setDirection    Stem                        [join   [dict get $modelDICT_GUI  Direction Stem]           " "]           
        ${targetNamespace}::setDirection    SeatPost                    [join   [dict get $modelDICT_GUI  Direction SeatPost]       " "]           
        ${targetNamespace}::setDirection    FrontFender                 [join   [dict get $modelDICT_GUI  Direction FrontFender]    " "]           
        ${targetNamespace}::setDirection    HandleBar                   [join   [dict get $modelDICT_GUI  Direction HandleBar]      " "]           
        ${targetNamespace}::setDirection    HeadSet                     [join   [dict get $modelDICT_GUI  Direction HeadSet]        " "]           
        ${targetNamespace}::setDirection    RearFender                  [join   [dict get $modelDICT_GUI  Direction RearFender]     " "]           
            
            # --- list values -----------------------------
            #
        ${targetNamespace}::setListValue    CrankSetChainRings          [split [dict get $modelDICT_GUI  ListValue CrankSetChainRings] -]
            # ... this value should not be necessary here 
            
            # --- polygon value ---------------------------
            #
        ${targetNamespace}::setPolygon      ChainStay                   [join [dict get $modelDICT_GUI  Polygon ChainStay           ]   " "]
        ${targetNamespace}::setPolygon      DownTube                    [join [dict get $modelDICT_GUI  Polygon DownTube            ]   " "]
        ${targetNamespace}::setPolygon      ForkBlade                   [join [dict get $modelDICT_GUI  Polygon ForkBlade           ]   " "]
        ${targetNamespace}::setPolygon      FrontFender_XZ              [join [dict get $modelDICT_GUI  Polygon FrontFender_XZ      ]   " "]
        ${targetNamespace}::setPolygon      HeadSetBottom               [join [dict get $modelDICT_GUI  Polygon HeadSetBottom       ]   " "]
        ${targetNamespace}::setPolygon      HeadSetTop                  [join [dict get $modelDICT_GUI  Polygon HeadSetTop          ]   " "]
        ${targetNamespace}::setPolygon      HeadTube                    [join [dict get $modelDICT_GUI  Polygon HeadTube            ]   " "]
        ${targetNamespace}::setPolygon      RearFender_XZ               [join [dict get $modelDICT_GUI  Polygon RearFender_XZ       ]   " "]
        ${targetNamespace}::setPolygon      SeatPost                    [join [dict get $modelDICT_GUI  Polygon SeatPost            ]   " "]
        ${targetNamespace}::setPolygon      SeatStay                    [join [dict get $modelDICT_GUI  Polygon SeatStay            ]   " "]
        ${targetNamespace}::setPolygon      SeatTube                    [join [dict get $modelDICT_GUI  Polygon SeatTube            ]   " "]
        ${targetNamespace}::setPolygon      Spacer                      [join [dict get $modelDICT_GUI  Polygon Spacer              ]   " "]
        ${targetNamespace}::setPolygon      Steerer                     [join [dict get $modelDICT_GUI  Polygon Steerer             ]   " "]
        ${targetNamespace}::setPolygon      Stem                        [join [dict get $modelDICT_GUI  Polygon Stem                ]   " "]
        ${targetNamespace}::setPolygon      TopTube                     [join [dict get $modelDICT_GUI  Polygon TopTube             ]   " "]
     
            # --- polyline value --------------------------
            #
        ${targetNamespace}::setPolyline     SaddleProfile               [join [dict get $modelDICT_GUI  Polyline SaddleProfile      ]   " "]
        
            # --- get defining Point coords ---------------
            #
        ${targetNamespace}::setPosition     BottomBracket               [join   [dict get $modelDICT_GUI  Position  BottomBracket            ]  " "]
        ${targetNamespace}::setPosition     BottomBracket_Ground        [join   [dict get $modelDICT_GUI  Position  BottomBracket_Ground     ]  " "]
        ${targetNamespace}::setPosition     BottleCage_DT_Bottom        [join   [dict get $modelDICT_GUI  Position  DownTube_BottleCageBottom       ]  " "]
        ${targetNamespace}::setPosition     BottleCage_DT_BottomOffset  [join   [dict get $modelDICT_GUI  Position  DownTube_BottleCageBottomOffset ]  " "]
        ${targetNamespace}::setPosition     BottleCage_DT_Top           [join   [dict get $modelDICT_GUI  Position  DownTube_BottleCageTop          ]  " "]
        ${targetNamespace}::setPosition     BottleCage_DT_TopOffset     [join   [dict get $modelDICT_GUI  Position  DownTube_BottleCageTopOffset    ]  " "]
        ${targetNamespace}::setPosition     BottleCage_ST_Base          [join   [dict get $modelDICT_GUI  Position  SeatTube_BottleCageBase  ]  " "]
        ${targetNamespace}::setPosition     BottleCage_ST_Offset        [join   [dict get $modelDICT_GUI  Position  SeatTube_BottleCageOffset]  " "]
        ${targetNamespace}::setPosition     CarrierMount_Front          [join   [dict get $modelDICT_GUI  Position  CarrierMount_Front       ]  " "]
        ${targetNamespace}::setPosition     CarrierMount_Rear           [join   [dict get $modelDICT_GUI  Position  CarrierMount_Rear        ]  " "]
        ${targetNamespace}::setPosition     ChainStay_RearWheel         [join   [dict get $modelDICT_GUI  Position  ChainStay_RearWheel      ]  " "]
        ${targetNamespace}::setPosition     CrankSet                    [join   [dict get $modelDICT_GUI  Position  CrankSet                 ]  " "]
        ${targetNamespace}::setPosition     DerailleurMount_Front       [join   [dict get $modelDICT_GUI  Position  DerailleurMount_Front    ]  " "]
        ${targetNamespace}::setPosition     DownTube_End                [join   [dict get $modelDICT_GUI  Position  DownTube_End             ]  " "]
        ${targetNamespace}::setPosition     DownTube_Start              [join   [dict get $modelDICT_GUI  Position  DownTube_Start           ]  " "]
        ${targetNamespace}::setPosition     ForkBlade                   [join   [dict get $modelDICT_GUI  Position  ForkBlade                ]  " "]
        ${targetNamespace}::setPosition     ForkCrown                   [join   [dict get $modelDICT_GUI  Position  ForkCrown                ]  " "]
        ${targetNamespace}::setPosition     ForkDropout                 [join   [dict get $modelDICT_GUI  Position  ForkDropout              ]  " "]
        ${targetNamespace}::setPosition     FrontBrake_Definition       [join   [dict get $modelDICT_GUI  Position  FrontBrake_Definition    ]  " "]
        ${targetNamespace}::setPosition     FrontBrake_Help             [join   [dict get $modelDICT_GUI  Position  FrontBrake_Help          ]  " "]
        ${targetNamespace}::setPosition     FrontBrake_Mount            [join   [dict get $modelDICT_GUI  Position  FrontBrake_Mount         ]  " "]
        ${targetNamespace}::setPosition     FrontBrake_Shoe             [join   [dict get $modelDICT_GUI  Position  FrontBrake_Origin        ]  " "]
        ${targetNamespace}::setPosition     FrontFender                 [join   [dict get $modelDICT_GUI  Position  FrontFender              ]  " "]
        ${targetNamespace}::setPosition     FrontWheel                  [join   [dict get $modelDICT_GUI  Position  FrontWheel               ]  " "]
        ${targetNamespace}::setPosition     HandleBar                   [join   [dict get $modelDICT_GUI  Position  HandleBar                ]  " "]
        ${targetNamespace}::setPosition     HeadSet_Bottom              [join   [dict get $modelDICT_GUI  Position  HeadSet_Bottom           ]  " "]
        ${targetNamespace}::setPosition     HeadSet_Top                 [join   [dict get $modelDICT_GUI  Position  HeadSet_Top              ]  " "]
        ${targetNamespace}::setPosition     HeadTube_End                [join   [dict get $modelDICT_GUI  Position  HeadTube_End             ]  " "]
        ${targetNamespace}::setPosition     HeadTube_Start              [join   [dict get $modelDICT_GUI  Position  HeadTube_Start           ]  " "]
        ${targetNamespace}::setPosition     HeadTube_VirtualTopTube     [join   [dict get $modelDICT_GUI  Position  HeadTube_VirtualTopTube  ]  " "]
        ${targetNamespace}::setPosition     IS_ChainSt_SeatSt           [join   [dict get $modelDICT_GUI  Position  ChainStay_SeatStay_IS    ]  " "]
        ${targetNamespace}::setPosition     Label                       [join   [dict get $modelDICT_GUI  Position  Label                    ]  " "]
        ${targetNamespace}::setPosition     LegClearance                [join   [dict get $modelDICT_GUI  Position  LegClearance             ]  " "]
        ${targetNamespace}::setPosition     RearBrake_Definition        [join   [dict get $modelDICT_GUI  Position  RearBrake_Definition     ]  " "]
        ${targetNamespace}::setPosition     RearBrake_Help              [join   [dict get $modelDICT_GUI  Position  RearBrake_Help           ]  " "]
        ${targetNamespace}::setPosition     RearBrake_Mount             [join   [dict get $modelDICT_GUI  Position  RearBrake_Mount          ]  " "]
        ${targetNamespace}::setPosition     RearBrake_Shoe              [join   [dict get $modelDICT_GUI  Position  RearBrake_Origin         ]  " "]
        ${targetNamespace}::setPosition     RearDropout                 [join   [dict get $modelDICT_GUI  Position  RearDropout              ]  " "]
        ${targetNamespace}::setPosition     RearDerailleur              [join   [dict get $modelDICT_GUI  Position  RearDerailleur           ]  " "]
        ${targetNamespace}::setPosition     RearFender                  [join   [dict get $modelDICT_GUI  Position  RearFender               ]  " "]
        ${targetNamespace}::setPosition     RearWheel                   [join   [dict get $modelDICT_GUI  Position  RearWheel                ]  " "]
        ${targetNamespace}::setPosition     Reference_HB                [join   [dict get $modelDICT_GUI  Position  Reference_HB             ]  " "]
        ${targetNamespace}::setPosition     Reference_SN                [join   [dict get $modelDICT_GUI  Position  Reference_SN             ]  " "]
        ${targetNamespace}::setPosition     Saddle                      [join   [dict get $modelDICT_GUI  Position  Saddle                   ]  " "]
        ${targetNamespace}::setPosition     SaddleNose                  [join   [dict get $modelDICT_GUI  Position  SaddleNose               ]  " "]
        ${targetNamespace}::setPosition     SaddleProposal              [join   [dict get $modelDICT_GUI  Position  SaddleProposal           ]  " "]
        ${targetNamespace}::setPosition     Saddle_Mount                [join   [dict get $modelDICT_GUI  Position  SaddleMount              ]  " "]
        ${targetNamespace}::setPosition     SeatPost                    [join   [dict get $modelDICT_GUI  Position  SeatPost                 ]  " "]
        ${targetNamespace}::setPosition     SeatPost_Pivot              [join   [dict get $modelDICT_GUI  Position  SeatPost_Pivot           ]  " "]
        ${targetNamespace}::setPosition     SeatPost_SeatTube           [join   [dict get $modelDICT_GUI  Position  SeatPost_SeatTube        ]  " "]
        ${targetNamespace}::setPosition     SeatStay_End                [join   [dict get $modelDICT_GUI  Position  SeatStay_End             ]  " "]
        ${targetNamespace}::setPosition     SeatStay_Start              [join   [dict get $modelDICT_GUI  Position  SeatStay_Start           ]  " "]
        ${targetNamespace}::setPosition     SeatTube_ClassicTopTube     [join   [dict get $modelDICT_GUI  Position  SeatTube_ClassicTopTube  ]  " "]
        ${targetNamespace}::setPosition     SeatTube_End                [join   [dict get $modelDICT_GUI  Position  SeatTube_End             ]  " "]
        ${targetNamespace}::setPosition     SeatTube_Ground             [join   [dict get $modelDICT_GUI  Position  SeatTube_Ground          ]  " "]
        ${targetNamespace}::setPosition     SeatTube_Saddle             [join   [dict get $modelDICT_GUI  Position  SeatTube_Saddle          ]  " "]
        ${targetNamespace}::setPosition     SeatTube_Start              [join   [dict get $modelDICT_GUI  Position  SeatTube_Start           ]  " "]
        ${targetNamespace}::setPosition     SeatTube_VirtualTopTube     [join   [dict get $modelDICT_GUI  Position  SeatTube_VirtualTopTube  ]  " "]
        ${targetNamespace}::setPosition     Spacer                      [join   [dict get $modelDICT_GUI  Position  Spacer                   ]  " "]
        ${targetNamespace}::setPosition     Spacer_End                  [join   [dict get $modelDICT_GUI  Position  Spacer_End               ]  " "]
        ${targetNamespace}::setPosition     Stem                        [join   [dict get $modelDICT_GUI  Position  Stem                     ]  " "]
        ${targetNamespace}::setPosition     Steerer_Ground              [join   [dict get $modelDICT_GUI  Position  Steerer_Ground           ]  " "]
        ${targetNamespace}::setPosition     Steerer_Start               [join   [dict get $modelDICT_GUI  Position  Steerer_Start            ]  " "]
        ${targetNamespace}::setPosition     Steerer_Stem                [join   [dict get $modelDICT_GUI  Position  Steerer_Stem             ]  " "]
        ${targetNamespace}::setPosition     TopTube_End                 [join   [dict get $modelDICT_GUI  Position  TopTube_End              ]  " "]
        ${targetNamespace}::setPosition     TopTube_Start               [join   [dict get $modelDICT_GUI  Position  TopTube_Start            ]  " "]
            #
        ${targetNamespace}::setPosition     _Edge_DownTubeHeadTube_DT       [join [dict get $modelDICT_GUI  Position  _Edge_DownTubeHeadTube_DT   ] " "]
        ${targetNamespace}::setPosition     _Edge_DownTubeSeatTube_Miter    [join [dict get $modelDICT_GUI  Position  _Edge_DownTubeSeatTube_Miter] " "]
        ${targetNamespace}::setPosition     _Edge_HeadSetBottomFront_Bottom [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetBottomFront_Bottom]  " "]
        ${targetNamespace}::setPosition     _Edge_HeadSetBottomFront_Top    [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetBottomFront_Top] " "]
        ${targetNamespace}::setPosition     _Edge_HeadSetTopBack_Bottom     [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetTopBack_Bottom ] " "]
        ${targetNamespace}::setPosition     _Edge_HeadSetTopBack_Top        [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetTopBack_Top    ] " "]
        ${targetNamespace}::setPosition     _Edge_HeadSetTopFront_Bottom    [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetTopFront_Bottom] " "]
        ${targetNamespace}::setPosition     _Edge_HeadSetTopFront_Top       [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetTopFront_Top   ] " "]
        ${targetNamespace}::setPosition     _Edge_HeadTubeBack_Bottom       [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeBack_Bottom   ] " "]
        ${targetNamespace}::setPosition     _Edge_HeadTubeBack_Top          [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeBack_Top      ] " "]
        ${targetNamespace}::setPosition     _Edge_HeadTubeFront_Bottom      [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeFront_Bottom  ] " "]
        ${targetNamespace}::setPosition     _Edge_HeadTubeFront_Top         [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeFront_Top     ] " "]
        ${targetNamespace}::setPosition     _Edge_SeatTubeBottom_Back       [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeBottom_Back   ] " "]
        ${targetNamespace}::setPosition     _Edge_SeatTubeTaperEnd_Back     [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTaperEnd_Back ] " "]
        ${targetNamespace}::setPosition     _Edge_SeatTubeTop_Back          [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTop_Back      ] " "]
        ${targetNamespace}::setPosition     _Edge_SeatTubeTop_Front         [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTop_Front     ] " "]
        ${targetNamespace}::setPosition     _Edge_SpacerBack_Bottom         [join [dict get $modelDICT_GUI  Position  _Edge_SpacerBack_Bottom     ] " "]
        ${targetNamespace}::setPosition     _Edge_SpacerBack_Top            [join [dict get $modelDICT_GUI  Position  _Edge_SpacerBack_Top        ] " "]
        ${targetNamespace}::setPosition     _Edge_TopTubeHeadTube_TT        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeHeadTube_TT    ] " "]
        ${targetNamespace}::setPosition     _Edge_TopTubeSeatTube_ST        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeSeatTube_ST    ] " "]
        ${targetNamespace}::setPosition     _Edge_TopTubeTaperTop_HT        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeTaperTop_HT    ] " "]
        ${targetNamespace}::setPosition     _Edge_TopTubeTaperTop_ST        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeTaperTop_ST    ] " "] 
            #

            # --- scalar settings -------------------------
            #
        ${targetNamespace}::setScalar       Steerer         Diameter                            [dict get $modelDICT_GUI  Scalar    Steerer         Diameter]
            #
        ${targetNamespace}::setScalar       BottleCage      DownTube                            [dict get $modelDICT_GUI  Scalar    BottleCage DownTube                    ]
        ${targetNamespace}::setScalar       BottleCage      DownTube_Lower                      [dict get $modelDICT_GUI  Scalar    BottleCage DownTube_Lower              ]
        ${targetNamespace}::setScalar       BottleCage      SeatTube                            [dict get $modelDICT_GUI  Scalar    BottleCage SeatTube                    ]
        ${targetNamespace}::setScalar       BottomBracket   Depth                               [dict get $modelDICT_GUI  Scalar    Geometry BottomBracket_Depth           ]
        ${targetNamespace}::setScalar       BottomBracket   InsideDiameter                      [dict get $modelDICT_GUI  Scalar    BottomBracket InsideDiameter           ]
        ${targetNamespace}::setScalar       BottomBracket   OutsideDiameter                     [dict get $modelDICT_GUI  Scalar    BottomBracket OutsideDiameter          ]
        ${targetNamespace}::setScalar       BottomBracket   ExcenterOffset                      [dict get $modelDICT_GUI  Scalar    Geometry BottomBracket_Offset_Excenter ]
        ${targetNamespace}::setScalar       ChainStay       WidthBB                             [dict get $modelDICT_GUI  Scalar    ChainStay WidthBB                      ]
        ${targetNamespace}::setScalar       CrankSet        Length                              [dict get $modelDICT_GUI  Scalar    CrankSet Length                        ]
        ${targetNamespace}::setScalar       DownTube        OffsetBB                            [dict get $modelDICT_GUI  Scalar    DownTube OffsetBB                      ]
        ${targetNamespace}::setScalar       DownTube        OffsetHT                            [dict get $modelDICT_GUI  Scalar    DownTube OffsetHT                      ]
        ${targetNamespace}::setScalar       Fork            CrownAngleBrake                     [dict get $modelDICT_GUI  Scalar    Fork CrownAngleBrake                   ]
        ${targetNamespace}::setScalar       Fork            Height                              [dict get $modelDICT_GUI  Scalar    Fork Height                            ]
        ${targetNamespace}::setScalar       Fork            Rake                                [dict get $modelDICT_GUI  Scalar    Fork Rake                              ]
        ${targetNamespace}::setScalar       FrontFender     Radius                              [dict get $modelDICT_GUI  Scalar    FrontFender Radius                     ]
        ${targetNamespace}::setScalar       FrontWheel      RimDiameter                         [dict get $modelDICT_GUI  Scalar    FrontWheel RimDiameter                 ]
        ${targetNamespace}::setScalar       FrontWheel      RimHeight                           [dict get $modelDICT_GUI  Scalar    FrontWheel RimHeight                   ]
        ${targetNamespace}::setScalar       FrontWheel      TyreHeight                          [dict get $modelDICT_GUI  Scalar    FrontWheel TyreHeight                  ]
            #
        ${targetNamespace}::setScalar       FrontBrake      BladeOffset                         [dict get $modelDICT_GUI  Scalar    FrontBrake BladeOffset                       ]
            # puts "      updateModel_XZ: [${targetNamespace}::getScalar       FrontBrake      BladeOffset]"
            #
        ${targetNamespace}::setScalar       Geometry        BottomBracket_Depth                 [dict get $modelDICT_GUI  Scalar    Geometry BottomBracket_Depth           ]
        ${targetNamespace}::setScalar       Geometry        BottomBracket_Height                [dict get $modelDICT_GUI  Scalar    Geometry BottomBracket_Height          ]
        ${targetNamespace}::setScalar       Geometry        ChainStay_Length                    [dict get $modelDICT_GUI  Scalar    Geometry ChainStay_Length              ]
        ${targetNamespace}::setScalar       Geometry        HandleBar_Distance                  [dict get $modelDICT_GUI  Scalar    Geometry HandleBar_Distance            ]
        ${targetNamespace}::setScalar       Geometry        HandleBar_Height                    [dict get $modelDICT_GUI  Scalar    Geometry HandleBar_Height              ]
        ${targetNamespace}::setScalar       Geometry        HeadTube_Angle                      [dict get $modelDICT_GUI  Scalar    Geometry HeadTube_Angle                ]
        ${targetNamespace}::setScalar       Geometry        RearWheel_x                         [dict get $modelDICT_GUI  Scalar    Geometry RearWheel_X                   ]
        ${targetNamespace}::setScalar       Geometry        SaddleNose_BB_x                     [dict get $modelDICT_GUI  Scalar    Geometry SaddleNose_BB_X               ]
        ${targetNamespace}::setScalar       Geometry        Saddle_Distance                     [dict get $modelDICT_GUI  Scalar    Geometry Saddle_Distance               ]
        ${targetNamespace}::setScalar       Geometry        Saddle_Height                       [dict get $modelDICT_GUI  Scalar    Geometry Saddle_Height                 ]
        ${targetNamespace}::setScalar       Geometry        SeatTube_Angle                      [dict get $modelDICT_GUI  Scalar    Geometry SeatTube_Angle                ]
        ${targetNamespace}::setScalar       Geometry        SeatTube_LengthVirtual              [dict get $modelDICT_GUI  Scalar    Geometry SeatTube_LengthVirtual        ]
        ${targetNamespace}::setScalar       Geometry        TopTube_Angle                       [dict get $modelDICT_GUI  Scalar    Geometry TopTube_Angle                 ]
        ${targetNamespace}::setScalar       Geometry        TopTube_LengthVirtual               [dict get $modelDICT_GUI  Scalar    Geometry TopTube_LengthVirtual         ]
            #
        ${targetNamespace}::setScalar       HandleBar       PivotAngle                          [dict get $modelDICT_GUI  Scalar    HandleBar PivotAngle                   ]
        ${targetNamespace}::setScalar       HeadSet         Diameter_Bottom                     [dict get $modelDICT_GUI  Scalar    HeadSet Diameter_Bottom                ]
        ${targetNamespace}::setScalar       HeadSet         Diameter_Top                        [dict get $modelDICT_GUI  Scalar    HeadSet Diameter_Top                   ]
        ${targetNamespace}::setScalar       HeadSet         Height_Bottom                       [dict get $modelDICT_GUI  Scalar    HeadSet Height_Bottom                  ]
        ${targetNamespace}::setScalar       HeadSet         Height_Top                          [dict get $modelDICT_GUI  Scalar    HeadSet Height_Top                     ]
        ${targetNamespace}::setScalar       HeadTube        Diameter                            [dict get $modelDICT_GUI  Scalar    HeadTube Diameter                      ]
        ${targetNamespace}::setScalar       HeadTube        Length                              [dict get $modelDICT_GUI  Scalar    HeadTube Length                        ]
            #
        ${targetNamespace}::setScalar       Lugs            BottomBracket_ChainStay_Angle       [dict get $modelDICT_GUI  Scalar    Lugs BottomBracket_ChainStay_Angle     ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_ChainStay_Tolerance   [dict get $modelDICT_GUI  Scalar    Lugs BottomBracket_ChainStay_Tolerance ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_DownTube_Angle        [dict get $modelDICT_GUI  Scalar    Lugs BottomBracket_DownTube_Angle      ]
        ${targetNamespace}::setScalar       Lugs            BottomBracket_DownTube_Tolerance    [dict get $modelDICT_GUI  Scalar    Lugs BottomBracket_DownTube_Tolerance  ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Bottom_Angle                [dict get $modelDICT_GUI  Scalar    Lugs HeadLug_Bottom_Angle              ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Bottom_Tolerance            [dict get $modelDICT_GUI  Scalar    Lugs HeadLug_Bottom_Tolerance          ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Top_Angle                   [dict get $modelDICT_GUI  Scalar    Lugs HeadLug_Top_Angle                 ]
        ${targetNamespace}::setScalar       Lugs            HeadLug_Top_Tolerance               [dict get $modelDICT_GUI  Scalar    Lugs HeadLug_Top_Tolerance             ]
        ${targetNamespace}::setScalar       Lugs            RearDropOut_Angle                   [dict get $modelDICT_GUI  Scalar    Lugs RearDropOut_Angle                 ]
        ${targetNamespace}::setScalar       Lugs            RearDropOut_Tolerance               [dict get $modelDICT_GUI  Scalar    Lugs RearDropOut_Tolerance             ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_SeatStay_Angle              [dict get $modelDICT_GUI  Scalar    Lugs SeatLug_SeatStay_Angle            ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_SeatStay_Tolerance          [dict get $modelDICT_GUI  Scalar    Lugs SeatLug_SeatStay_Tolerance        ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_TopTube_Angle               [dict get $modelDICT_GUI  Scalar    Lugs SeatLug_TopTube_Angle             ]
        ${targetNamespace}::setScalar       Lugs            SeatLug_TopTube_Tolerance           [dict get $modelDICT_GUI  Scalar    Lugs SeatLug_TopTube_Tolerance         ]
        ${targetNamespace}::setScalar       RearBrake       DiscDiameter                        [dict get $modelDICT_GUI  Scalar    RearBrake DiscDiameter                 ]
        ${targetNamespace}::setScalar       RearDerailleur  Pulley_teeth                        [dict get $modelDICT_GUI  Scalar    RearDerailleur Pulley_teeth            ]
        ${targetNamespace}::setScalar       RearDerailleur  Pulley_x                            [dict get $modelDICT_GUI  Scalar    RearDerailleur Pulley_x                ]
        ${targetNamespace}::setScalar       RearDerailleur  Pulley_y                            [dict get $modelDICT_GUI  Scalar    RearDerailleur Pulley_y                ]
        ${targetNamespace}::setScalar       RearDropout     Derailleur_y                        [dict get $modelDICT_GUI  Scalar    RearDropout Derailleur_y               ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCS                            [dict get $modelDICT_GUI  Scalar    RearDropout OffsetCS                   ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCSPerp                        [dict get $modelDICT_GUI  Scalar    RearDropout OffsetCSPerp               ]
        ${targetNamespace}::setScalar       RearDropout     OffsetCS_TopView                    [dict get $modelDICT_GUI  Scalar    RearDropout OffsetCS_TopView           ]
        ${targetNamespace}::setScalar       RearDropout     OffsetSSPerp                        [dict get $modelDICT_GUI  Scalar    RearDropout OffsetSSPerp               ]            
        ${targetNamespace}::setScalar       RearDropout     RotationOffset                      [dict get $modelDICT_GUI  Scalar    RearDropout RotationOffset             ]
        ${targetNamespace}::setScalar       RearFender      Radius                              [dict get $modelDICT_GUI  Scalar    RearFender Radius                      ]
        ${targetNamespace}::setScalar       RearWheel       FirstSprocket                       [dict get $modelDICT_GUI  Scalar    RearWheel FirstSprocket                ]
        ${targetNamespace}::setScalar       RearWheel       HubWidth                            [dict get $modelDICT_GUI  Scalar    RearWheel HubWidth                     ]
        ${targetNamespace}::setScalar       RearWheel       RimDiameter                         [dict get $modelDICT_GUI  Scalar    RearWheel RimDiameter                  ]
        ${targetNamespace}::setScalar       RearWheel       RimHeight                           [dict get $modelDICT_GUI  Scalar    RearWheel RimHeight                    ]
        ${targetNamespace}::setScalar       RearWheel       TyreHeight                          [dict get $modelDICT_GUI  Scalar    RearWheel TyreHeight                   ]
        ${targetNamespace}::setScalar       RearWheel       TyreWidth                           [dict get $modelDICT_GUI  Scalar    RearWheel TyreWidth                    ]
        ${targetNamespace}::setScalar       RearWheel       TyreWidthRadius                     [dict get $modelDICT_GUI  Scalar    RearWheel TyreWidthRadius              ]
        ${targetNamespace}::setScalar       Saddle          Length                              [dict get $modelDICT_GUI  Scalar    Saddle Length                          ]
        ${targetNamespace}::setScalar       Saddle          NoseLength                          [dict get $modelDICT_GUI  Scalar    Saddle NoseLength                      ]
        ${targetNamespace}::setScalar       Saddle          Offset_x                            [dict get $modelDICT_GUI  Scalar    Saddle Offset_x                        ]
        ${targetNamespace}::setScalar       SeatStay        OffsetTT                            [dict get $modelDICT_GUI  Scalar    SeatStay OffsetTT                      ]
        ${targetNamespace}::setScalar       SeatTube        Diameter                            [dict get $modelDICT_GUI  Scalar    SeatTube DiameterTT                    ]
        ${targetNamespace}::setScalar       SeatTube        Extension                           [dict get $modelDICT_GUI  Scalar    SeatTube Extension                     ]
        ${targetNamespace}::setScalar       SeatTube        OffsetBB                            [dict get $modelDICT_GUI  Scalar    SeatTube OffsetBB                      ]
        ${targetNamespace}::setScalar       Spacer          Height                              [dict get $modelDICT_GUI  Scalar    Spacer Height                          ]
        ${targetNamespace}::setScalar       Stem            Angle                               [dict get $modelDICT_GUI  Scalar    Stem Angle                             ]
        ${targetNamespace}::setScalar       Stem            Length                              [dict get $modelDICT_GUI  Scalar    Stem Length                            ]        
        ${targetNamespace}::setScalar       TopTube         OffsetHT                            [dict get $modelDICT_GUI  Scalar    TopTube OffsetHT                       ]
            #
            #
        ${targetNamespace}::setScalar       Geometry        Fork_Height                         [dict get $modelDICT_GUI  Scalar    Fork Height                            ]
        ${targetNamespace}::setScalar       Geometry        Fork_Rake                           [dict get $modelDICT_GUI  Scalar    Fork Rake                              ]
        ${targetNamespace}::setScalar       Geometry        FrontRim_Diameter                   [dict get $modelDICT_GUI  Scalar    FrontWheel RimDiameter                 ]
        ${targetNamespace}::setScalar       Geometry        FrontTyre_Height                    [dict get $modelDICT_GUI  Scalar    FrontWheel TyreHeight                  ]
        ${targetNamespace}::setScalar       Geometry        RearRim_Diameter                    [dict get $modelDICT_GUI  Scalar    RearWheel RimDiameter                  ]
        ${targetNamespace}::setScalar       Geometry        RearTyre_Height                     [dict get $modelDICT_GUI  Scalar    RearWheel  TyreHeight                  ]
        ${targetNamespace}::setScalar       Geometry        Stem_Angle                          [dict get $modelDICT_GUI  Scalar    Stem Angle                             ]
        ${targetNamespace}::setScalar       Geometry        Stem_Length                         [dict get $modelDICT_GUI  Scalar    Stem Length                            ]            
            #
            #
            # --- centerline settings ----------------------
            #
        # ${targetNamespace}::setCenterLine   RearMockup_CtrLines         [myGUI::modelAdapter::_pointList2coordList  [join [dict get $modelDICT_GUI  CenterLine RearMockup_CtrLines] " "]]
        # ${targetNamespace}::setCenterLine   RearMockup                  [myGUI::modelAdapter::_pointList2coordList  [join [dict get $modelDICT_GUI  CenterLine RearMockup]          " "]]
        # ${targetNamespace}::setCenterLine   RearMockup_UnCut            [myGUI::modelAdapter::_pointList2coordList  [join [dict get $modelDICT_GUI  CenterLine RearMockup_UnCut]    " "]]
            #
            # --- component settings ----------------------
            #
        # ${targetNamespace}::setComponent    BottleCage_DownTube         [dict get $modelDICT_GUI  Component BottleCage_DownTube         ]
        # ${targetNamespace}::setComponent    BottleCage_DownTube_Lower   [dict get $modelDICT_GUI  Component BottleCage_DownTube_Lower   ]
        # ${targetNamespace}::setComponent    BottleCage_SeatTube         [dict get $modelDICT_GUI  Component BottleCage_SeatTube         ]
        # ${targetNamespace}::setPolygon      ChainStay_RearMockup        [join [dict get $modelDICT_GUI  Polygon ChainStay_RearMockup]   " "]
        # ${targetNamespace}::setPolygon      ChainStay_XY                [join [dict get $modelDICT_GUI  Polygon ChainStay_xy        ]   " "]
        # ${targetNamespace}::setPolygon      CrankArm_XY                 [join [dict get $modelDICT_GUI  Polygon CrankArm_xy         ]   " "]
        # ${targetNamespace}::setPolygon      HeadSetCap                  [join [dict get $modelDICT_GUI  Polygon HeadSetCap          ]   " "]
            #
            # ... XY-View
        # ${targetNamespace}::setPosition     ChainStay_RearMockup          [join [dict get $modelDICT_GUI  Position  ChainStay_RearMockup        ]   " "]  
        # ${targetNamespace}::setScalar       BottomBracket   OffsetCS_TopView                    [dict get $modelDICT_GUI  Scalar    BottomBracket OffsetCS_TopView         ]
        # ${targetNamespace}::setScalar       BottomBracket   Width                               [dict get $modelDICT_GUI  Scalar    BottomBracket Width                    ]
        # ${targetNamespace}::setScalar       ChainStay       completeLength                      [dict get $modelDICT_GUI  Scalar    ChainStay completeLength               ]
        # ${targetNamespace}::setScalar       ChainStay       cuttingLeft                         [dict get $modelDICT_GUI  Scalar    ChainStay cuttingLeft                  ]
        # ${targetNamespace}::setScalar       ChainStay       cuttingLength                       [dict get $modelDICT_GUI  Scalar    ChainStay cuttingLength                ]
        # ${targetNamespace}::setScalar       ChainStay       profile_x01                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_x01                  ]
        # ${targetNamespace}::setScalar       ChainStay       profile_x02                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_x02                  ]
        # ${targetNamespace}::setScalar       ChainStay       profile_x03                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_x03                  ]
        # ${targetNamespace}::setScalar       ChainStay       profile_y00                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_y00                  ]
        # ${targetNamespace}::setScalar       ChainStay       profile_y01                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_y01                  ]
        # ${targetNamespace}::setScalar       ChainStay       profile_y02                         [dict get $modelDICT_GUI  Scalar    ChainStay profile_y02                  ]
        # ${targetNamespace}::setScalar       ChainStay       profile_y03                         [dict get $modelDICT_GUI  Scalar    ChainStay WidthBB                      ]
        # ${targetNamespace}::setScalar       ChainStay       segmentAngle_01                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_01              ]
        # ${targetNamespace}::setScalar       ChainStay       segmentAngle_02                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_02              ]
        # ${targetNamespace}::setScalar       ChainStay       segmentAngle_03                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_03              ]
        # ${targetNamespace}::setScalar       ChainStay       segmentAngle_04                     [dict get $modelDICT_GUI  Scalar    ChainStay segmentAngle_04              ]
        # ${targetNamespace}::setScalar       ChainStay       segmentLength_01                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_01             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentLength_02                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_02             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentLength_03                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_03             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentLength_04                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentLength_04             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentRadius_01                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_01             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentRadius_02                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_02             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentRadius_03                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_03             ]
        # ${targetNamespace}::setScalar       ChainStay       segmentRadius_04                    [dict get $modelDICT_GUI  Scalar    ChainStay segmentRadius_04             ]
        # ${targetNamespace}::setScalar       CrankSet        ArmWidth                            [dict get $modelDICT_GUI  Scalar    CrankSet ArmWidth                      ]
        # ${targetNamespace}::setScalar       CrankSet        ChainLine                           [dict get $modelDICT_GUI  Scalar    CrankSet ChainLine                     ]
        # ${targetNamespace}::setScalar       CrankSet        ChainRingOffset                     [dict get $modelDICT_GUI  Scalar    CrankSet ChainRingOffset               ]
            #
        # ${targetNamespace}::setScalar       CrankSet        PedalEye                            [dict get $modelDICT_GUI  Scalar    CrankSet PedalEye                      ]
        # ${targetNamespace}::setScalar       CrankSet        Q-Factor                            [dict get $modelDICT_GUI  Scalar    CrankSet Q-Factor                      ]
        # ${targetNamespace}::setScalar       RearBrake       DiscWidth                           [dict get $modelDICT_GUI  Scalar    RearMockup DiscWidth                   ]
        # ${targetNamespace}::setScalar       RearMockup      CassetteClearance                   [dict get $modelDICT_GUI  Scalar    RearMockup CassetteClearance           ]
        # ${targetNamespace}::setScalar       RearMockup      ChainWheelClearance                 [dict get $modelDICT_GUI  Scalar    RearMockup ChainWheelClearance         ]
        # ${targetNamespace}::setScalar       RearMockup      CrankClearance                      [dict get $modelDICT_GUI  Scalar    RearMockup CrankClearance              ]
        # ${targetNamespace}::setScalar       RearMockup      DiscClearance                       [dict get $modelDICT_GUI  Scalar    RearMockup DiscClearance               ]
        # ${targetNamespace}::setScalar       RearMockup      DiscOffset                          [dict get $modelDICT_GUI  Scalar    RearMockup DiscOffset                  ]
        # ${targetNamespace}::setScalar       RearMockup      TyreClearance                       [dict get $modelDICT_GUI  Scalar    RearMockup TyreClearance               ]
            #
            #
            
            
            # --- vector settings ---- Bounding - Box -----
            #
        ${targetNamespace}::setBoundingBox  Summary                                             [join   [dict get $modelDICT_GUI  BoundingBox   Summary]    " "]
        
            
            # --- dictionary ---- Custom CrankSet ---------
            #
        ${targetNamespace}::setDictionary   CrankSet                                            [dict get $modelDICT_GUI  CustomCrank_XZ]
            # set ${targetNamespace}::Dictionary(CrankSet)                                            [dict get $modelDICT_GUI  CustomCrank_XZ]
                        
            
            # --- local vars ------------------------------
            #
        set BottomBracket(Position)         [${targetNamespace}::getPosition    BottomBracket       ]
        set CrankSet(Position)              [${targetNamespace}::getPosition    CrankSet            ]
        set FrontWheel(Position)            [${targetNamespace}::getPosition    FrontWheel          ]
        set HeadTube(Stem)                  [${targetNamespace}::getPosition    HeadTube_End        ]
        set Saddle(Position)                [${targetNamespace}::getPosition    Saddle              ]
        set Position(BaseCenter)            [${targetNamespace}::getPosition    BottomBracket_Ground]
        set RearWheel(Position)             [${targetNamespace}::getPosition    RearWheel           ]
        set HandleBar(Position)             [${targetNamespace}::getPosition    HandleBar           ]
            #
            # set HeadSet(polygon)          [${targetNamespace}::getPolygon     HeadSet             ]
        set HeadTube(polygon)               [${targetNamespace}::getPolygon     HeadTube            ]
        set SeatTube(polygon)               [${targetNamespace}::getPolygon     SeatTube            ]
        set HeadTube(End)                   [${targetNamespace}::getPosition    HeadTube_End        ]
        set HeadTube(Start)                 [${targetNamespace}::getPosition    HeadTube_Start      ]
        set Steerer(End)                    [${targetNamespace}::getPosition    Steerer_Stem        ]
        set Steerer(Fork)                   [${targetNamespace}::getPosition    Steerer_Start       ]
        set Steerer(Ground)                 [${targetNamespace}::getPosition    Steerer_Ground      ]        
            #
        set FrontWheel(RimDiameter)         [${targetNamespace}::getScalar      FrontWheel  RimDiameter ]
        set FrontWheel(TyreHeight)          [${targetNamespace}::getScalar      FrontWheel  TyreHeight  ]
        set HeadSet(Diameter)               [${targetNamespace}::getScalar      HeadSet     Diameter_Top]
        set HeadSet(HeightTop)              [${targetNamespace}::getScalar      HeadSet     Height_Top  ]        
        set Length(CrankSet)                [${targetNamespace}::getScalar      CrankSet    Length      ]
        set Steerer(Diameter)               [${targetNamespace}::getScalar      Steerer     Diameter    ]
            #
            
            # -- set Helping - Position -------------------
            #
            set vct_90  [vectormath::unifyVector                $CrankSet(Position)     $FrontWheel(Position) ]
        ${targetNamespace}::setPosition     help_91             [vectormath::addVector  $CrankSet(Position)     [vectormath::unifyVector {0 0} $vct_90 $Length(CrankSet)]]
        ${targetNamespace}::setPosition     help_92             [vectormath::addVector  $FrontWheel(Position)   [vectormath::unifyVector {0 0} $vct_90 [expr - ( 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)) ] ] ]
        ${targetNamespace}::setPosition     help_93             [vectormath::addVector  $CrankSet(Position)     [vectormath::unifyVector $Saddle(Position) $BottomBracket(Position) $Length(CrankSet) ] ]
                
                
            # -- set Wheel - Ground - Positions -----------
            #
        ${targetNamespace}::setPosition     RearWheel_Ground    [list [lindex $RearWheel(Position)  0] [lindex $Steerer(Ground) 1] ]
        ${targetNamespace}::setPosition     FrontWheel_Ground   [list [lindex $FrontWheel(Position) 0] [lindex $Steerer(Ground) 1] ]


            # --- geometry for tubing dimension -----------
            #
            # set pt_01_               [coords_xy_index $HeadTube(polygon) 2 ]
            # set pt_02_               [coords_xy_index $HeadTube(polygon) 1 ]
            # set pt_03_               [coords_xy_index $HeadTube(polygon) 3 ]
            # set pt_04_               [coords_xy_index $HeadTube(polygon) 0 ]
            set pt_01               [join   [dict get $modelDICT_GUI  Position  HeadTube_Start          ]   " "]
            set pt_02               [join   [dict get $modelDICT_GUI  Position  HeadTube_End            ]   " "]
            set pt_03               [join   [dict get $modelDICT_GUI  Position  _Edge_HeadTubeBack_Top  ]   " "]
            set pt_04               [join   [dict get $modelDICT_GUI  Position  _Edge_HeadTubeBack_Bottom]  " "]
            # puts " --- $HeadTube(polygon) "
            # puts "   01 HeadTube_Top    $pt_01_    $pt_01  "
            # puts "   02                 $pt_02_    $pt_02  "
            # puts "   03 HeadTube_Bottom $pt_03_    $pt_03  "
            # puts "   04                 $pt_04_    $pt_04  "       
        ${targetNamespace}::setVector       HeadTube_Top    [list $pt_01 $pt_02 ]
        ${targetNamespace}::setVector       HeadTube_Bottom [list $pt_03 $pt_04 ]

                #
            set pt_01               [join   [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTop_Back  ] " "]
            set pt_02               [join   [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTop_Front ] " "]                
        ${targetNamespace}::setVector       SeatTube_Top    [list $pt_01 $pt_02 ]
                #
            set   dir_01            [join   [dict get $modelDICT_GUI  Direction Steerer]    " "]
            set   pt_01             [vectormath::addVector        $Steerer(Fork)  $dir_01 [expr -0.5 * $Steerer(Diameter)] ]
            set   pt_02             [vectormath::addVector        $Steerer(Fork)  $dir_01 [expr  0.5 * $Steerer(Diameter)] ]
        ${targetNamespace}::setVector       Steerer_Bottom  [list $pt_01 $pt_02 ]
                #
            set   pt_01             [vectormath::addVector        $Steerer(Fork)  $dir_01 [expr -0.5 * $HeadSet(Diameter)] ]
            set   pt_02             [vectormath::addVector        $Steerer(Fork)  $dir_01 [expr  0.5 * $HeadSet(Diameter)] ]
        ${targetNamespace}::setVector       HeadSet_Bottom  [list $pt_01 $pt_02 ]
                #
            set   pt_01             $HeadTube(End)
            set   pt_02             $Steerer(End)
            set   vct_91            [vectormath::unifyVector $pt_01 $pt_02 $HeadSet(HeightTop)]
            set   pt_03             [vectormath::addVector   $pt_01 $vct_91]
            # set   pt_02             $Steerer(End)
            # set   pt_01             [coords_xy_index $HeadSet(polygon) 0 ]
            # set   pt_02             [coords_xy_index $HeadSet(polygon) 7 ]
            # puts "  updateModel_XZ Steerer(End) $pt_02"
            # exit
        ${targetNamespace}::setPosition     HeadSet_Top     $pt_03
        ${targetNamespace}::setVector       HeadSet_Top     [list $pt_01 $pt_02 ]
                #

                
        #${targetNamespace}::setPosition     _Edge_DownTubeHeadTube_DT       [join [dict get $modelDICT_GUI  Position  _Edge_DownTubeHeadTube_DT   ] " "]
        #${targetNamespace}::setPosition     _Edge_DownTubeSeatTube_Miter    [join [dict get $modelDICT_GUI  Position  _Edge_DownTubeSeatTube_Miter] " "]
        #${targetNamespace}::setPosition     _Edge_HeadSetBottomFront_Bottom [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetBottomFront_Bottom]  " "]
        #${targetNamespace}::setPosition     _Edge_HeadSetBottomFront_Top    [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetBottomFront_Top] " "]
        #${targetNamespace}::setPosition     _Edge_HeadSetTopFront_Bottom    [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetTopFront_Bottom] " "]
        #${targetNamespace}::setPosition     _Edge_HeadSetTopFront_Top       [join [dict get $modelDICT_GUI  Position  _Edge_HeadSetTopFront_Top   ] " "]
        #${targetNamespace}::setPosition     _Edge_HeadTubeBack_Bottom       [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeBack_Bottom   ] " "]
        #${targetNamespace}::setPosition     _Edge_HeadTubeBack_Top          [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeBack_Top      ] " "]
        #${targetNamespace}::setPosition     _Edge_HeadTubeFront_Bottom      [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeFront_Bottom  ] " "]
        #${targetNamespace}::setPosition     _Edge_HeadTubeFront_Top         [join [dict get $modelDICT_GUI  Position  _Edge_HeadTubeFront_Top     ] " "]
        #${targetNamespace}::setPosition     _Edge_SeatTubeBottom_Back       [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeBottom_Back   ] " "]
        #${targetNamespace}::setPosition     _Edge_SeatTubeTaperEnd_Back     [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTaperEnd_Back ] " "]
        #${targetNamespace}::setPosition     _Edge_SeatTubeTop_Front         [join [dict get $modelDICT_GUI  Position  _Edge_SeatTubeTop_Front     ] " "]
        #${targetNamespace}::setPosition     _Edge_TopTubeHeadTube_TT        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeHeadTube_TT    ] " "]
        #${targetNamespace}::setPosition     _Edge_TopTubeSeatTube_ST        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeSeatTube_ST    ] " "]
        #${targetNamespace}::setPosition     _Edge_TopTubeTaperTop_HT        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeTaperTop_HT    ] " "]
        #${targetNamespace}::setPosition     _Edge_TopTubeTaperTop_ST        [join [dict get $modelDICT_GUI  Position  _Edge_TopTubeTaperTop_ST    ] " "] 
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                

            # --- additional wheel values -----------------
            #
        ${targetNamespace}::setScalar       RearWheel   Radius          [expr [lindex $RearWheel(Position)  1] - [lindex $Position(BaseCenter) 1] ]
        ${targetNamespace}::setScalar       FrontWheel  Radius          [expr [lindex $FrontWheel(Position) 1] - [lindex $Position(BaseCenter) 1] ]
            
            
            # --- set helping values ----------------------
            #
        ${targetNamespace}::setLength       Height_HB_Seat              [expr [lindex $Saddle(Position)     1] - [lindex $HandleBar(Position)  1] ]
        ${targetNamespace}::setLength       Height_HT_Seat              [expr [lindex $Saddle(Position)     1] - [lindex $HeadTube(Stem)       1] ]
        ${targetNamespace}::setLength       Length_BB_Seat              [expr [lindex $Saddle(Position)     0] - [lindex $Position(BaseCenter) 0] ]
                #
    }
        #
        #
        #
    proc myGUI::modelAdapter::get_ProjectDoc {} {
            #
        variable modelContext
        variable persistenceObject
        variable modelUpdate
            #
        puts "\n"
		puts "   -------------------------------"
		puts "    myGUI::modelAdapter::get_ProjectDoc"
		
            #
            # 
        set persistenceDoc  [$modelContext getProjectDoc]
            # set persistenceDOM  [$modelContext getPersistenceDOM]
            #
            # puts "[$persistenceDoc asXML]"
            #
        set domNode [$persistenceDoc selectNodes /root/Project/rattleCADVersion]
           $domNode appendChild [$persistenceDoc  createTextNode "$::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"]
            #
        set domNode [$persistenceDoc selectNodes /root/Project/Name]                
           $domNode appendChild [$persistenceDoc  createTextNode [myGUI::control::getSession  projectName]]
            #
        set domNode [$persistenceDoc selectNodes /root/Project/modified]            
           $domNode appendChild [$persistenceDoc  createTextNode [myGUI::control::getSession  dateModified]]
            #
            #
            # puts "[$persistenceDoc asXML]"
            #
            #
        return $persistenceDoc
            #
    }
        #
    proc myGUI::modelAdapter::save_ProjectFile {mode} {
            #
        variable modelContext
        variable modelUpdate
        variable persistenceObject
        variable persistenceRoot
            # variable persistenceDOM
            #
        puts "\n"
		puts "   -------------------------------"
		puts "    myGUI::modelAdapter::save_ProjectFile"
		
            #
            # 
        set persistenceDoc  [get_ProjectDoc]
        set persistenceRoot [$persistenceDoc documentElement]
            # set persistenceDOM  [$modelContext getPersistenceDOM]
            #
            # puts "[$persistenceDoc asXML]"
            #
        set projectFile     [$persistenceObject writeFile_xml $persistenceDoc $mode]
            #
        if {$projectFile ne {}} {
                #
            set projectFileName    [file normalize $projectFile]
                #
            myGUI::control::setSession  projectFile       [file normalize $projectFileName]
            myGUI::control::setSession  projectName       [[$persistenceDoc selectNodes /root/Project/Name/text()]   nodeValue]
                #
                # -- update View 
            myGUI::view::edit::update_windowTitle           $projectFileName
            myGUI::view::edit::update_MainFrameStatus
                #
                # -- update Model 
            [namespace current]::updateModel
                #
                #
            $persistenceDoc delete    
                #
            return $projectFileName
                #
        } else {
                #
            $persistenceDoc delete
                #
            return {}
                #
        }   
            #
    }
        #
        # -------------------------------------------------------------------------
        #
        #
    proc myGUI::modelAdapter::_dict2List {dictPath dictVar pathList} {
        dict for {key val} ${dictVar} {
            set path "$dictPath/$key"
            if {[catch {[namespace current]::_dict2List  $path ${val} $pathList} eID]} {
                    # puts "    -> append ... $path"
                set path [string trimleft $path /]
                lappend pathList $path
            } else {
                set pathList [[namespace current]::_dict2List  $path ${val} $pathList]
            }
        }
        return $pathList
    }
    proc myGUI::modelAdapter::_dict2Model_Edit_2 {dictPath dictVar targetNamespace} {
        dict for {key val} ${dictVar} {
            set path "$dictPath/$key"
            if {[catch {[namespace current]::_dict2Model_Edit_2  ${val} $path $targetNamespace} eID]} {
                    # puts "       [format {%-10s ... %-40s ... %s} $rootNode $path $val]"
                array set ${targetNamespace}::editValue [list $path $val]
                # array set ${targetNamespace}::_updateValue  [list $path $val]
            }
        }
        return
    }
    proc myGUI::modelAdapter::_pointList2coordList {xyList} {
        set spaceList {}
        foreach {xy} $xyList {
            foreach {x y} [split $xy ,] break
            lappend spaceList $x $y
        }
        return $spaceList
    }
        #
        #
        # -------------------------------------------------------------------------
        #
    proc myGUI::modelAdapter::update_UserCompDirectories {} {
            #
            #  check User Components Directories
            #
        set dirList [myGUI::modelAdapter::get_ComponentSubDirectories]
            #
            # puts $dirList
            #
        foreach node $dirList {
            set pathString [lindex $node 1]
                # puts "  ... $pathString"
            myPersist::file::check_user_dir rattleCAD/components/$pathString 
        }
        set surprDir     [myPersist::file::check_user_dir rattleCAD/components/surprise]
        set sourceDir    $::APPL_Config(TOOL_Dir)
        catch {file copy [file join $sourceDir Tcl_logo.svg]       $surprDir}
        catch {file copy [file join $sourceDir rattleCAD_logo.svg] $surprDir}
            #
        return
            #
    }
        #
    proc myGUI::modelAdapter::update_UserTemplateDirecty {} {    
            #
            #  check User Components Directories
            #
        puts ""
		puts "     ... check_templateDirecty  \n"
		puts "            ... \$::APPL_Config(TEMPLATE_Dir) $::APPL_Config(TEMPLATE_Dir)"
		
		if {[catch {glob -directory $::APPL_Config(TEMPLATE_Dir) *} errMsg]} {
			foreach sampleFile [glob -directory $::APPL_Config(SAMPLE_Dir) *] {
				puts "          -> [file normalize ${sampleFile}]"
				file copy -force [file normalize ${sampleFile}] $::APPL_Config(TEMPLATE_Dir)
			}
		} else {
            puts "\n            ... not updated, because of not empty!\n" 
		}
		
		return

    }     
        #
    proc myGUI::modelAdapter::importSubset {nodeRoot} {
			# puts "[$nodeRoot asXML]"
		puts "\n"
		puts "   -------------------------------"
		puts "    myGUI::modelAdapter::importSubset"
            #
		variable modelContext
            #
        $modelContext import_ProjectSubset $nodeRoot	
            # bikeGeometry::import_ProjectSubset $nodeRoot	
            #
		[namespace current]::updateModel
            #
    }	
        #
        # -------------------------------------------------------------------------
        #
    proc myGUI::modelAdapter::coords_xy_index {coordlist index} {
            return [myGUI::model::coords_xy_index $coordlist $index]
    }        
 
             
        #
        #
        #
        # -- unused or expired ----------
        #   
    if 0 {
        proc myGUI::modelAdapter::compareDict {dictOrigin dictNew} {
                #
            set errorCode 1
                #
            puts "\n"        
            puts " --- origin ---"        
            appUtil::pdict $dictOrigin 1 "    "
            puts " --- new ------"        
            appUtil::pdict $dictNew    1 "    "            
                #
            set dictPathList [getDictPaths $dictOrigin]
                #
            puts "\n---------"
            foreach keyPath $dictPathList {
                puts "      -> $keyPath"
            }  
                #
            puts "\n---------"
            set lastPath {}
            foreach keyPath $dictPathList {
                    #
                set getOriginCommand    [format {[dict get $dictOrigin %s]} $keyPath]
                set getNewCommand       [format {[dict get $dictNew    %s]} $keyPath]
                    #
                if {[llength $keyPath] < [llength $lastPath]} {
                    continue
                }
                set lastPath $keyPath
                eval set dictOriginValue    $getOriginCommand
                if {[catch {eval set dictNewValue       $getNewCommand} eID]} {
                    set dictNewValue {      __blank}
                }
                #eval set dictOriginValue $getCommand
                puts [format {%-50s   %20s   <-   %-15s}  $keyPath    $dictOriginValue    $dictNewValue]
                #puts "      -> $keyPath     -> $dictOriginValue  <- $dictNewValue"
            }  
                #
            return
                #
            foreach item [dict keys $dictOrigin] {
                set val [dict get $dictOrigin $item]
                #puts "We have $item with a value $val"
            }    
                #
            return $errorCode
                #
        }
            #
        proc myGUI::modelAdapter::getDictPaths {dict {pathList {}} {keyPath {}}} {
                #
            #puts "\n"
            #puts "  --- 0 --- \$pathList  $pathList"
            # puts "  --- 1 --- \$keyPath   $keyPath"
                #
            set getCommand  [format {[dict get $dict %s]} $keyPath]
                # puts "        ... $getCommand"
                #
            if {[catch {eval set _dict $getCommand} eID]} {
                return $pathList
            }
                #
                # puts "        ... $_dict"
                #
            if {[llength $_dict] < 2} {
                return $pathList
            }    
                #
            foreach key [dict keys $_dict] {
                set _keyPath     [string trim "$keyPath $key"]
                #puts "  --- 2 --- \$_keyPath   $_keyPath"
                set getCommand  [format {[dict get $dict %s]} $_keyPath]
                eval set __dict $getCommand
                if {[llength $__dict] < 2} {
                    lappend pathList $_keyPath
                }
                set pathList [getDictPaths $dict $pathList $_keyPath]
            }                        
                #
            # puts "   - \$pathList: $pathList"    
                #
            return $pathList
                #
        }    
            #

        proc myGUI::modelAdapter::__getDictValue {xpath {format {value}} args} {
               # key type args
            variable modelDICT_GUI
            
            # puts $::APPL_Config(LogFile) "$xpath <- $format $args"
            
            set value     [appUtil::get_dictValue $modelDICT_GUI $xpath]
            switch -exact $format {
                position  {}
                direction {
                        set value [split [dict get ${value} polar] ,]
                        # puts "    -> getValue -> direction"
                    }
                polygon   {}
                value     -
                default   {}
            }
            return ${value}
        }
            #
        proc myGUI::modelAdapter::__get_paramComponent___ {mode args} {
            puts "      myGUI::modelAdapter::get_paramComponent $mode $args"
            switch -exact $mode {
                ChainWheelDefinition    {
                            set polygon [::bikeGeometry::get_paramComponent $mode]
                        }
                ChainWheel {
                            foreach {teethCount position objectType any bcDiameter} ${args} break
                            set polygon [::bikeGeometry::get_paramComponent $mode $teethCount $position $objectType $any $bcDiameter]
                            # set polygon [vectormath::addVectorPointList $position $polygon]
                        }
                CrankSpyder {
                            foreach {bcDiameter position} ${args} break
                            set polygon [::bikeGeometry::get_paramComponent $mode $bcDiameter $position]
                        }
                ChainWheelBoltPosition {
                            foreach {bcDiameter position} ${args} break
                            set polygon [::bikeGeometry::get_paramComponent $mode $bcDiameter $position]
                        }
                CrankArm {
                            foreach {crankArmLength position} ${args} break
                            set polygon [::bikeGeometry::get_paramComponent $mode $crankArmLength $position]
                        }
                default {
                            set polygon {}
                        }
            }
                #
            puts "     -> $polygon"
                # set polygon [vectormath::vectormath::addVectorCoordList  $centerPoint  $polygon]    
                #
            return $polygon
                # myGUI::modelAdapter::get_paramComponent ChainWheelDefinition
                # myGUI::modelAdapter::get_paramComponent ChainWheel 39 {1019.0787082983509 524.8875562218891} polyline __default__ 130
                # myGUI::modelAdapter::get_paramComponent ChainWheel 53 {1019.0787082983509 524.8875562218891} polyline __default__ 130
                # myGUI::modelAdapter::get_paramComponent CrankSpyder 130 {1019.0787082983509 524.8875562218891}        
                # myGUI::modelAdapter::get_paramComponent ChainWheelBoltPosition 130 {1019.0787082983509 524.8875562218891}
                # myGUI::modelAdapter::get_paramComponent CrankArm 172.50 {1019.0787082983509 524.8875562218891}
                #
                # myGUI::modelAdapter::get_paramComponent ChainWheelDefinition 
                # myGUI::modelAdapter::get_paramComponent ChainWheel 22 {1027.0933882829045 573.428895612708} polyline __default__ 60
                # myGUI::modelAdapter::get_paramComponent ChainWheel 32 {1027.0933882829045 573.428895612708} polyline __default__ 100
                # myGUI::modelAdapter::get_paramComponent ChainWheel 44 {1027.0933882829045 573.428895612708} polyline __default__ 100
                # myGUI::modelAdapter::get_paramComponent CrankSpyder 100 {1027.0933882829045 573.428895612708}
                # myGUI::modelAdapter::get_paramComponent ChainWheelBoltPosition 100 {1027.0933882829045 573.428895612708}
                # myGUI::modelAdapter::get_paramComponent CrankArm 175 {1027.0933882829045 573.428895612708}
                #
        }
        # namespace import ::bikeGeometry::get_paramComponent
       

        proc myGUI::modelAdapter::__unifyKey_remove {key} {
            
            puts "\n"
            puts "  -- remove this procedure"
            puts "  -> myGUI::modelAdapter::unifyKey $key"
            puts "\n"
            
            set isArray [string first "(" $key 0]
            if {$isArray > 1} {
                  # puts "          <D> -> got Array  $key <- ($isArray)"
                set arrayName   [lindex [split $key (]  0]
                set keyName     [lindex [split $key ()] 1]
                set xPath       [format "%s/%s" $arrayName $keyName]
                  # puts "          <D> -> got Array  $arrayName $keyName"
                return [list $arrayName $keyName $xPath]
            } else {
                set values      [split $key /]
                set slashIndex  [string first {/} $key 1]
                  # puts "          <D> -> got xPath  $key <- ($isArray) <- $slashIndex"
                set arrayName   [string range $key 0 $slashIndex-1]
                set keyName     [string range $key $slashIndex+1 end]       
                set xPath       [format "%s/%s" $arrayName $keyName]
                  # puts "          <D> -> got xPath  $arrayName $keyName"
                return [list $arrayName $keyName $xPath]
            }
        }
            
        proc myGUI::modelAdapter::__get_CustomCrankSetDICT {} {
                #
            variable modelDICT_GUI
                #
            set cranksetDICT [dict get $modelDICT_GUI CustomCrank_XZ]
                # appUtil::pdict $cranksetDICT
            return $cranksetDICT
                #
        }
        proc myGUI::modelAdapter::__get_TubeMiterDICT {} {
                #
            variable modelDICT_GUI
                #
            set miterDICT [dict get $modelDICT_GUI TubeMiter]
                # appUtil::pdict $miterDICT
            return $miterDICT
                #
        }

        proc myGUI::modelAdapter::__set_geometry_IF_new {interfaceName} {
                #
            variable  geometry_IF
                #
            set last_IF $geometry_IF
                #
            puts "\n"
                #
            set return_IF  [$geometry_IF set_geometryIF $interfaceName]
            foreach {new_Name new_IF} $return_IF break
                #
            puts "\n   .... $new_IF"
                #
            if {$last_IF != $new_IF} {
                    # puts " ... $last_IF != $geometry_IF  -> 1"
                set geometry_IF $new_IF
                return 1
            } else {
                    # puts " ... $last_IF == $geometry_IF  -> 0"
                return 0
            }
        }
            #
        proc myGUI::modelAdapter::__set_geometry_IF_org {interfaceName} {
                #
            variable  geometry_IF
                #
            set last_IF $geometry_IF
                #
            puts "\n"
            puts "    =========== myGUI::modelAdapter::set_geometry_IF ==============-start-=="
                #
            switch -exact $interfaceName {
                    {Classic}       {set geometry_IF ::bikeGeometry::IF_Classic}
                    {Lugs}          {set geometry_IF ::bikeGeometry::IF_LugAngles}
                    {OutsideIn}     {set geometry_IF ::bikeGeometry::IF_OutsideIn}
                    {StackReach}    {set geometry_IF ::bikeGeometry::IF_StackReach}
                    default         {}
            }
                #
            puts "          <I> new Interface: $geometry_IF"
            puts ""
            foreach {subcmd proc} [namespace ensemble configure $geometry_IF -map] {
                        puts [format {                   %-30s %-20s  <- %s }     $subcmd [info args $proc] $proc ]
                    }
            puts ""
            puts "    =========== myGUI::modelAdapter::set_geometry_IF ================-end-=="
            puts "\n"
                #
            if {$last_IF != $geometry_IF} {
                    # puts " ... $last_IF != $geometry_IF  -> 1"
                return 1
            } else {
                    # puts " ... $last_IF == $geometry_IF  -> 0"
                return 0
            }
        }
            #
        proc myGUI::modelAdapter::__get_keyListBoxValues {key} {
                #
            variable valueRegistry
                #
            puts "  -> myGUI::modelAdapter::get_keyListBoxValues <$key>"    
                #
            set returnValue [set valueRegistry($key)]
                #
            foreach value $returnValue {
                puts "       -> get_ListBoxValues: $value"
            }
                #
            return $returnValue
                #        
        }
            #
        proc myGUI::modelAdapter::__get_projectDICT {} {
                #
            variable modelContext
                #
            set modelDICT_GUI       [$modelContext getModelDictionary]
                #
            return $modelDICT_GUI
                #
        }
            #
        #
    }
        