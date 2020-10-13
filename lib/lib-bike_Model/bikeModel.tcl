 ##+##########################################################################
 #
 # package: bikeModel    ->    bike_Model.tcl
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
 #    namespace:  bikeModel
 # ---------------------------------------------------------------------------
 #
 #
 # 2.00 - 20160417
 #      ... refactor: rattleCAD - 3.4.04
 #
 #
 # 1.xx refactor
 #          split project completely from bikeModel
 #
 #
  
package require tdom
    #
package provide bikeModel 0.03
    #
package require appUtil
package require vectormath
    #
package require myPersist
    #
package require bikeGeometry
package require bikeComponent
package require bikeFrame
    #
    
namespace eval bikeModel {
    
    # --------------------------------------------
        # export as global command
    variable packageHomeDir [file dirname [file normalize [info script]]]
        #
        
    # --------------------------------------------
        # dataModel.xml 
    variable dataStructureDoc   {}
        set fp              [open [file join $packageHomeDir etc dataModel.xml]]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
    set dataStructureDoc    [dom parse $projetXML]
        #
                        
    # --------------------------------------------
        # resultModelDoc ... is a cleanuped version of dataStructureDoc
    variable inputModelDoc      ;# is a cleanuped version of dataStructureDoc, containing all init="1" parameters
    variable resultModelDoc     ;# is a cleanuped version of dataStructureDoc, containing all init="0" and init="1" parameters
        #
        
    # --------------------------------------------
        # hash-tables
    variable mappingDict_ModelDict      {}
    variable mappingDict_ModelDict_inv  {}
    variable mappingDict_Project        {}
    variable mappingDict_Project_inv    {}
    variable mappingDict_Geometry       {}
    variable mappingDict_Geometry_inv   {}
    variable mappingDict_Frame          {}
    variable mappingDict_Frame_inv      {}
    variable mappingDict_Component      {}

    # --------------------------------------------
        # persistence 
    variable persistenceObject  [myPersist::Persistence new]
        #
        
    # --------------------------------------------
        # geometry & frame
    variable geometryIF         ::bikeGeometry::IF_StackReach
    variable geometryIF_Name    {}
        # frame
    variable frameObject        [[::bikeFrame::FrameFactory new] create]
        # components & lugs
    variable componentIF        ::bikeComponent::IF_Component
        #
        
    # --------------------------------------------
        # init
    $componentIF init   

}
    
    
    #
#-------------------------------------------------------------------------
    #  load newProject
    #
    #  ... loads a new project given by a XML-Project as rootNode
    #
proc bikeModel::init {} {
        #
    variable compFactory
        #
    variable geometryIF
    variable geometryIF_Name
        #
    variable mappingDict_Component
    variable mappingDict_Frame
    variable mappingDict_Frame_inv
    variable mappingDict_Geometry
    variable mappingDict_Geometry_inv
    variable mappingDict_Project   
    variable mappingDict_Project_inv  
        #
        
        #
        # --- create compFactory ---
    set compFactory                 [bikeModel::compFactory new]   
        #
        
        #
        # --- mapping Hashs ---
    set mappingDict_Component       [get_MappingDict component]
    set mappingDict_Frame           [get_MappingDict frame]
    set mappingDict_Frame_inv       [get_MappingDict frame    inverse]
    set mappingDict_Geometry        [get_MappingDict geometry]
    set mappingDict_Geometry_inv    [get_MappingDict geometry inverse]
    set mappingDict_Project         [get_MappingDict project]
    set mappingDict_Project_inv     [get_MappingDict project  inverse]
        #
        
        #
    init_Objects
        #
       
        #
    # $compFactory report_Object
        #

        #
        # --- init bikeGeometry ---
        # ... set the default interface
    set_geometryIF
        # puts "$geometryIF_Name ... $geometryIF"
        #
        # puts "  $geometryIF "
    $geometryIF init
        #
        
        #
        # --- init ListBoxValues ---
    update_ListBoxValues
        #
        
        #
        # --- init DOM-Documents --- ... as templates
    update_inputModelDocument
    update_resultModelDocument
        #
        
        #
    return
        #
}
    #
proc bikeModel::init_Objects {{structureNode {}}} {
        #
        # --- read childNodes of $initRoot, 
        #       every $childNode leads to an object "obj_"[$childNode nodeName]
        #
    variable compFactory
        #
    variable dataStructureDoc
    variable resultModelDoc
        #
    set structureNode [$dataStructureDoc documentElement]
        #
        # puts "\n\n ------ bikeModel::init_Objects -------- \n"
        # puts "[$structureNode asXML]"
        #
    foreach modelNode [$structureNode childNodes] {
            #
        set objectName  [$modelNode nodeName]
        set varName     $objectName
            #
        puts "            init_Objects -> $varName"    
            #
        set [namespace current]::${varName} [$compFactory create $objectName]
        set newObject [set [namespace current]::${varName}]
            #
        foreach typeNode [$modelNode selectNodes */*] {
                #
            if {[[$typeNode parentNode] nodeType] == "ELEMENT_NODE"} {
                set modelXPath  [$typeNode toXPath]
                set modelPath   [string map {/root/ {}} $modelXPath]
                    #
                lassign [split $modelPath /]    objectName typeName keyName
                    # foreach {objectName typeName keyName} [split $modelPath /] break
                    # puts "        <typeNode> $objectName $typeName $keyName"
                    #
                if {[$typeNode nodeType] == "ELEMENT_NODE"} {
                    # puts "  $newObject initCompValue $typeName $keyName"
                    $newObject initCompValue $typeName $keyName {}
                }
            }
        }
        
        if {$objectName eq "HeadSet"} {
            # tk_messageBox -message "HeadSet"
        }
    }
        #
    return
        #
}
    #
    #
    #
proc bikeModel::update_Model {projectNode} {
        #
    set structureRoot [init_dataStructure]    
        # puts "[$structureRoot asXML]"
        #
        # puts "[$projectNode asXML]"
        #
    foreach arrayNode [$projectNode childNodes] {
        # this is the arrayName level
        set arrayName   [$arrayNode nodeName]
        # set initObject  [get__Object init  $arrayName]
        set modelObject [get__Object $arrayName]
        foreach typeNode [$arrayNode childNodes] {
            # this is the key level
            set typeName [$typeNode nodeName]
            # puts "   ... [$typeNode nodeName]"
            foreach keyNode [$typeNode childNodes] {
                if {[$keyNode nodeType] == "ELEMENT_NODE"} {
                    set keyName  [$keyNode nodeName]
                    set keyValue {}
                    catch {set keyValue [[$keyNode selectNodes text()] asText]}
                    # puts "           -> $modelObject - ($arrayName) - $typeName $keyName $keyValue"
                    # puts "           -> $initObject / $modelObject - ($arrayName) - $typeName $keyName $keyValue"
                    # $initObject  setValue $typeName $keyName $keyValue
                    $modelObject setValue $typeName $keyName $keyValue
                }
            }
        }
    }
        #
    update_bikeGeometry
        #
    update_from_bikeGeometry
        #
        #
    update_bikeFrame
        #
    update_from_bikeFrame
        #
        #
    update_bikeComponent
        #
    update_bikeComponent_Placements
        #
    update_from_bikeComponent
        #
        #
    return
        #
}
    #
proc bikeModel::set_Value {objectPath value} {
        #
    variable geometryIF
    variable componentIF
    variable frameObject
        #
        #
    puts ""
    puts "      =========== bikeModel::set_Value ========================"
    puts ""
    puts "              $objectPath $value"
        #
        #
        # ==== objectPath ===================
        #
    lassign [split $objectPath /]   objName objType objKey
        # foreach {objName objType objKey} [split $objectPath /] break  
    set myObject [get__Object $objName]    
        #
    puts "                  -> $myObject"
        #

        #
        #
    set geometryPath    [get_Mapping Geometry   $objectPath]
    set framePath       [get_Mapping Frame      $objectPath]
    set componentPath   [get_Mapping Component  $objectPath]
        #
        # puts "              \$geometryPath ->  $geometryPath"
        # puts "              \$framePath ->     $framePath"
        # puts "              \$componentPath -> $componentPath"
        #
        #
        # ==== geometryPath =================
        #
        # myValue = 1 ... this value is neither handled in
        #                   $geometryIF nor in
        #                   $componentIF
    set myValue 1    
        #
    if {$geometryPath ne {}} {
            #
        set myValue 0
            #
        puts ""
        puts "              handle: $geometryIF "
        puts "                  \$geometryPath  $geometryPath"
            #
        lassign [split $geometryPath /] _objType _objName _keyName
            # foreach {_objType _objName _keyName} [split $geometryPath /] break
        switch -exact $_objType {
            Scalar {
                set value    [string map {, .} $value]
                set retValue [$geometryIF set_Scalar    $_objName $_keyName    $value]
                set retValue [$geometryIF get_Scalar    $_objName $_keyName]
            }
            Config {
                set retValue [$geometryIF set_Config    $_objName $value]
                set retValue [$geometryIF get_Config    $_objName]                    
            }
            ListValue {
                set retValue [$geometryIF set_ListValue $_objName $value]
                set retValue [$geometryIF get_ListValue $_objName]                    
            }
            default {
                puts "                   -> $geometryPath ... not registered"
                return {}
            }
        }
        puts "                      -> $retValue"
            #
        update_from_bikeGeometry
            #
        update_bikeFrame
            #
        update_from_bikeFrame
            #
            # update_bikeComponent
            #
            # update_from_bikeComponent
            #
    } else {
        puts "\n"
        puts "                  set_Value ... geometryPath -> no update ... $objectPath $value"
        puts "\n"
    } 
    
        #
        #
        #
        # ==== framePath ====================
        #
    if {$framePath ne {}} {
            # puts "   ... \$framePath $framePath"
            #
        lassign [split $framePath /]    _objName _objType _keyName
            # foreach {_objName _objType _keyName} [split $framePath /] break
        puts "  $_objName $_objType $_keyName"
        set targetObject    [$frameObject getComponent $_objName]
        puts "   \$_objName $_objName  -> $targetObject"
                    

        switch -exact $_objType {
            Scalar {
                set value    [string map {, .} $value]
                set retValue [$targetObject setScalar    $_keyName    $value]
                set retValue [$targetObject getScalar    $_keyName]
            }
            Config {
                set retValue [$targetObject setConfig    $_keyName $value]
                set retValue [$targetObject getConfig    $_keyName]                    
            }
            default {
                puts "                   -> $framePath ... not registered"
                return {}
                # error "    <E> bikeModel::set_Value: bikeFrame: $_objName $_objType $_keyName"
            }
        }
            #
        $frameObject update
        
            #
        update_from_bikeFrame
            #
    }
        #
        #
        #
        # ==== componentPath ================
        #
    if {$componentPath ne {}} {
            #
        set myValue 0
            #
        lassign [split $componentPath /]    _objName _objType _keyName  
            # foreach {_objName _objType _keyName} [split $componentPath /] break  
            #
        puts ""
        puts "              handle: $componentIF "
        puts "                  \$componentPath $componentPath -> $_objName $_objType $_keyName"
            #
        switch -exact $_objType {
            Scalar {
                set value    [string map {, .} $value]
                set retValue [$componentIF set_Scalar       $_objName  $_keyName  $value]
                set retValue [$componentIF get_Scalar       $_objName  $_keyName]
            }
            Config {
                set retValue [$componentIF set_Config       $_objName  $_keyName  $value]
                set retValue [$componentIF get_Config       $_objName  $_keyName]                    
            }
            ListValue {
                set retValue [$componentIF set_ListValue    $_objName  $_keyName  $value]
                set retValue [$componentIF get_ListValue    $_objName  $_keyName]                    
            }
            default {
                puts "                   -> $componentPath ... not registered"
                return {}
            }
        }
            #
        update_from_bikeComponent
            #
            # puts "                  \$componentPath $componentPath -> $_objName $_objType $_keyName - $retValue"
            #
    } else {
        puts "\n"
        puts "                  set_Value ... componentPath -> no update ... $objectPath $value"
        puts "\n"
    } 
        #
        #
        # tk_messageBox -message " handle now: $myValue  \$objectPath $objectPath"
        # foreach {myName myType myKey}  [split $objectPath /] break
        # puts "   -> $myName $myType $myKey"
        #
        #
        # ... neither geometry nor component
        #
    if {$geometryPath eq {} && $framePath eq {} && $componentPath eq {}} {
            # tk_messageBox -message " handle \$objectPath $objectPath"
            # puts "  \$objectPath $objectPath"
            # puts " --- "
        lassign [split $objectPath /]   myName myType myKey
            # foreach {myName myType myKey}  [split $objectPath /] break
            #
        puts "              handle: myObject  $myName"
        puts "                  ->  $myType $myKey $value"
            #
        set myObject    [get__Object $myName]
        $myObject       setValue $myType $myKey $value
            #
    } else {
        puts "\n"
        puts "                  set_Value ... objectPath -> no update ... $objectPath $value"
        puts "\n"
    }
        #
        #
        #
    if {$objName ne {_View}} {
            #
        update_bikeComponent
            #
        update_bikeComponent_Placements
            #
        update_from_bikeComponent
            #
    }
        #
        #
        # ==== update objects ===============
        #
    set retValue [$myObject getValue $objType $objKey]
    puts ""
    puts "              $objectPath  $value  ($objType) "
    puts "              -> $retValue"
    puts "      =========== bikeModel::set_Value ========================"
    puts ""
        #
    return $retValue
        #
}
    #
proc bikeModel::set_ValueList {parameterList} {
        #
    variable geometryIF
    variable componentIF
    variable frameObject
        #
        #
    puts ""
    puts "      =========== bikeModel::set_ValueList ========================"
    puts ""
        #
    set updateFrame     0
    set parameterDict   {}
        #
    foreach {objectPath value} $parameterList {
            # puts "              $objectPath  -----> $value"
        set framePath       [get_Mapping Frame      $objectPath]
        if {$framePath ne {}} {
            set updateFrame 1
            puts "                   -> $objectPath --> $framePath"
            lassign [split $framePath /]    objectName type keyName
                # foreach {objectName type keyName} [split $framePath /] break
            puts "                          $objectName $type $keyName  -> $value"
            dict set parameterDict $objectName $type $keyName $value
        }
    }
        #
    appUtil::pdict $parameterDict 2
        #
    if $updateFrame {
            #
        puts "\n"
        puts "    -> $frameObject setSubset_DICT \$parameterDict"
        puts ""
        $frameObject setSubset_DICT $parameterDict
            #
        $frameObject update
            #
    }
        #
    update_from_bikeFrame
        #
    update_bikeComponent
        #
    update_bikeComponent_Placements
        #
    update_from_bikeComponent
        #
    return {}
        #
} 
    #
proc bikeModel::set__ObjectValue {objectName objType objKey value} {
    set objectVar [get__Object $objectName]
    set retValue  [$objectVar setValue $objType $objKey $value]
    return $retValue
}
    #
    #
proc bikeModel::get_Value {objectPath} {
    lassign [split $objectPath /]   breakobjectName objType objKey
        # foreach {objectName objType objKey} [split $objectPath /] break
    set retValue [get__ObjectValue $objectName $objType $objKey]
    return $retValue
} 
    #
proc bikeModel::get__ObjectValue {objectName objType objKey} {
    set objectVar [get__Object $objectName]
    set retValue  [$objectVar getValue $objType $objKey]
    return $retValue
}
    #
proc bikeModel::get__Object {objectName} {
    variable compFactory
    set objectVar   [$compFactory get_Object $objectName]
    return $objectVar
        #
    set varName     [lindex [split $objectName /] 0]
    set objectVar   [set [namespace current]::${varName}]
    return $objectVar
}
    #
    #
    #
proc bikeModel::init_dataStructure {{type xmlStructure} {report no_report}} {
        #
        # filters dataStructureDoc by nodes with attribute: init="1"
        #
        # type:   arrayStructure
        #         xmlStructure
        # report: no_report
        #         report
        #
        #
    variable dataStructureDoc
        #
    set dataStructureRoot   [$dataStructureDoc  documentElement]
        #
        #
    set myDoc  [dom parse [$dataStructureRoot asXML]]
    set myRoot [$myDoc documentElement]
        #
    set nodeList [$myRoot selectNodes */*/*]
    foreach myNode $nodeList {
        set myXPath [$myNode toXPath]
        set myInit  [$myNode getAttribute init]
        if $myInit {
                # puts "      $myInit $myXPath"
            foreach attr [$myNode attributes] {
                $myNode removeAttribute $attr
            }
            foreach textNode [$myNode childNodes] {
                # puts "   ... [$textNode nodeValue]"
                $myNode removeChild $textNode
                $textNode delete
            }            
        } else {
                # puts "      $myInit -- $myXPath "
            set parentNode [$myNode parentNode]
            $parentNode removeChild $myNode
            $myNode delete
            set siblingList [$parentNode childNodes] 
            if {[llength $siblingList] == 0} {
                set parentParentNode [$parentNode parentNode]
                $parentParentNode removeChild $parentNode
                $parentNode delete
            }
        }
    }
    set removeNode [$myRoot selectNodes _Result]
    if {$removeNode != {}} {
        # puts "  $removeNode [$removeNode asXML]"
        set parentNode [$removeNode parent]
        $parentNode removeChild $removeNode
        $removeNode delete
    }
        # exit
        # puts " -- dataCleanup --"
        # puts [$myRoot asXML]

        #
    if {$type == {xmlStructure}} {
        return $myRoot
    }

    
        #
    # -- type == arrayStructure --------------------
        #
        # return a list of arrayName(arrayKey) 
        #
    set list_domainParameter {}    
        #
    foreach arrayNode [$myRoot childNodes] {
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
proc bikeModel::get_MappingDict {type {mode {default}}} {
        #
    variable dataStructureDoc
        #
    set mappingDict         [dict create]
        #
    set dataStructureRoot   [$dataStructureDoc documentElement]
        #
        # <DownTube>
        #   <Direction>
        #     <XZ guiDictKey=""  prjKey="" geometry   Key="" geometryKey="" componentKey="" frameKey="" projectXML="">0.6879964311861184 0.7257140695033855</XZ>
        # 
        # guiDictKey .......... path as used in myGUI
        # projectXML .......... xml-Path to set init new project in bikeGeometry -> 
        # geometryKey ......... read from bikeGeometry
        # componentKey ........ path to bikeComponent
        # persistKey .......... currently unused
        # frameKey ............ currently unused
        # geometryKey ......... currently unused
        #
    switch -exact $type {
        gui         {set keyAttribute "guiKey"}
        modelDict   {set keyAttribute "guiDictKey"}
        project     {set keyAttribute "projectXML"}
        geometry    {set keyAttribute "geometryKey"}
        component   {set keyAttribute "componentKey"}
        persist     {set keyAttribute "persistKey"}
        frame       {set keyAttribute "frameKey"}
        default     {set keyAttribute "__unknown"}
    }
        #
    if {$keyAttribute eq "__unknown"} {
        puts "              <E> bikeModel::get_MappingDict -> $type ... unknown"
    }
        #
    set nodeList [$dataStructureRoot selectNodes */*/*]
    foreach node $nodeList {
        if {[$node nodeType] == "ELEMENT_NODE"} {
            set modelXPath  [$node toXPath]
            set modelPath   [string map {/root/ {}} $modelXPath]
            set targetPath  [$node getAttribute $keyAttribute]
                # puts "   $modelPath -?- $targetPath"
            if {$targetPath != {}} {
                dict set mappingDict $modelPath $targetPath
            }
        }
    }
        #
    # appUtil::pdict $mappingDict
        #
    if {$mode ne {default}} {
        set invDict {}
        foreach source [dict keys $mappingDict] {
            set target [dict get $mappingDict $source]
            dict set invDict $target $source
        }
            # appUtil::pdict $invDict
        return $invDict
    }    
       
    return $mappingDict
}    
    #
proc bikeModel::get_Mapping {mappingName key} {
        #
    # variable mappingDict_GUI
    # variable mappingDict_GUI_inv
    # variable mappingDict_ModelDict
    # variable mappingDict_ModelDict_inv
    variable mappingDict_Project    
    variable mappingDict_Project_inv  
    variable mappingDict_Geometry
    variable mappingDict_Geometry_inv
    variable mappingDict_Component
    variable mappingDict_Frame
    # variable mappingDict_Persist
    # variable mappingDict_Persist_inv
        #
    set mappingDict [format {mappingDict_%s} $mappingName]    
        #
    if [info exists $mappingDict] {
            #
        set keyExist [dict keys [set $mappingDict] $key]
            # puts "                   get_Mapping -> \$keyExist $keyExist"
            #
        if {$keyExist eq {}} {
            puts "              <E> bikeModel::get_Mapping: $mappingName - $key ... does not exist!"
            return {}
        } else {
            set retValue [dict get  [set $mappingDict] $key]
            return $retValue
        }
            #
    } else {
        error "              <E> bikeModel::get_Mapping: $mappingName ... does not exist!"
    }
}
    #
    #
    #
proc bikeModel::update_ListBoxValues {} {           
        #
    variable componentIF
        # variable geometryIF
        #
    set _listDict [$componentIF get_ListBoxValues]
        # set _listDict [$geometryIF get_ListBoxValues]
        #
    dict for {listName _dict} ${_listDict} {
            # puts "   -> $listName : $_dict"
        switch -exact $listName {
            ComponentLocation   {}
            default {
                    set objectVar    [get__Object _View]
                        # puts "    ... $objectVar"
                        puts "    ... ListBox $listName $_dict"
                    $objectVar setValue ListBoxValues $listName $_dict
                        # ${targetNamespace}::setListBoxValues $listName $_dict
                }
        }
    }    
        
}
    #
proc bikeModel::get_DebugGeometry {} {           
    variable geometryIF
    return [$geometryIF get_DebugGeometry]  
}
    #
    #
    #
proc bikeModel::update_bikeGeometry {} {
        #
        # create the defining xml-required for bikeGeometry
        # the xml-structure is based on the mapping defined in dataStructure.xml
        #   -> attribute: projectXML
        #       -> is the same Value as stored in attribute: geometryKey
        #           ... if attribute: init = 1
        #
        # reset bikeGeometry
        #   -> by the updated 
        #       -> $geometryRoot 
        #
    variable geometryIF
        #
    variable mappingDict_Project    
        #
    puts "\n\n=== bikeModel::update_bikeGeometry ========================= \n"    
        #
        
        #
    set timeStart   [clock milliseconds]
        #
        
    set geometryRoot [$geometryIF get_projectStructure]
    set geometryDoc  [$geometryRoot ownerDocument]
        #
        #
        # -- source obj - bikeModel
        # -- target xml - bikeGeometry
        # set mappingDict [bikeModel::geometry::getMappingDict domain_2_geometry]    
        # set mappingDict [dict get $mappingDict mapping]  
    set mappingDict $mappingDict_Project        
        #
    # appUtil::pdict $mappingDict
        #
        # exit
    # puts "[$geometryRoot asXML]"
        #
    foreach myPath [dict keys $mappingDict] {
        # puts "   -> $myPath"
        set targetPath  [dict get $mappingDict $myPath]
        # puts "   -> $targetPath"
        set pathList    [split $myPath /]
        lassign $pathList   objName objType objKey
            # foreach {objName objType objKey} $pathList break
            # puts "          -> $objName $objType $objKey"
            #
            # set myObject [get__Object init $objName]
        set myObject    [get__Object $objName]
        set myValue     {}
        catch {set myValue  [$myObject getValue $objType $objKey]}
            # puts "         update_bikeGeometry: -> $myPath $targetPath <- $myValue"
            #
        set targetNode  {}
        set targetNode  [$geometryRoot selectNodes /root/$targetPath]
        # puts "                -> $targetNode"
        if {$targetNode == {}} {
            # error "\n<E> bikeModel::update_bikeGeometry could not get node /root/$targetPath\n\n[$geometryRoot asXML]"
            continue
        }
            # remove existing textNodes
        foreach node [$targetNode childNodes] {
            if {[$node nodeType] == "TEXT_NODE"} {
                $targetNode removeChild $node
                $node delete
            }
        }
            # create new textNodes
        set textNode    [$geometryDoc  createTextNode $myValue]
        $targetNode appendChild $textNode
        # puts "                -> $targetNode [$targetNode asXML]"
    }
        #
    puts "\n\n  ---- \$geometryRoot ----\n"
        # puts "[$geometryRoot asXML]"
        #
    puts "\n\n  ---- \$geometryIF set_newProject -----\n"
    $geometryIF set_newProject $geometryRoot
        #

        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001 * ($timeEnd - $timeStart)}]
        #            
    puts "                 ... $timeUsed seconds used for update_bikeGeometry"
        #
        #
    return
        #
}
    #
proc bikeModel::update_from_bikeGeometry {{objectPath {}}} {
        #
    variable geometryIF
    variable mappingDict_Geometry
        #
    # appUtil::pdict $mappingDict_Geometry
        #
    set mappingDICT $mappingDict_Geometry   
        #
    puts "\n\n=== bikeModel::update_from_bikeGeometry ==================== \n"    
        #
        
        #
    set timeStart   [clock milliseconds]
        #
        
        # puts ".... $objectPath"    
        #
    if {$objectPath != {}} {
        set geometryPath [get_Mapping Geometry  $objectPath]
        if {$geometryPath != {}} {
            set mappingDICT [list $objectPath $geometryPath]
        } else {
            error "could not get geometryPath for $objectPath"
        }
    }    
        
    foreach objectPath [dict keys $mappingDICT] {
        #
        set geometryPath [dict get $mappingDICT $objectPath]
        # puts "                   -> $objectPath -> $geometryPath"
            #
        lassign [split $objectPath /]   objectName typeName keyName
            # foreach {objectName typeName keyName} [split $objectPath /] break
        set myObject [get__Object $objectName]
            #
            # puts "         -> $myObject"
            #
        set pathList    [split $geometryPath /]
        set getterKey   [lindex $pathList 0]
        set attrList    [lrange $pathList 1 end]
            #
            # puts ""
            # puts "                  -> $getterKey  - $attrList"
            # puts ""
            #
        switch -exact $getterKey {
            BoundingBox {   set retValue [$geometryIF get_BoundingBox   $attrList]}
            CenterLine  {   set retValue [$geometryIF get_CenterLine    $attrList]}
            Component   {   set retValue [$geometryIF get_Component     $attrList]}
            Config      {   set retValue [$geometryIF get_Config        $attrList]}
            Direction   {   set retValue [$geometryIF get_Direction     $attrList]}
            ListValue   {   set retValue [$geometryIF get_ListValue     $attrList]}
            Polygon     {   set retValue [$geometryIF get_Polygon       $attrList]}
            Position    {   set retValue [$geometryIF get_Position      $attrList]}
            Profile     {   set retValue [$geometryIF get_Profile       $attrList]}
            Scalar      {   set retValue [$geometryIF get_Scalar        [lindex $attrList 0] [lindex $attrList 1]]}
            TubeMiter   {   set retValue [$geometryIF get_TubeMiter     $attrList]}
            CustomCrank {   set retValue [$geometryIF get_CustomCrank   $attrList]}
            default     {   set retValue {}
                            error "could not get getter for $getterKey ($objectPath)"
                        }
        }
            #
        $myObject setValue $typeName $keyName  $retValue
            #
    }
        #
    if {$mappingDICT != $mappingDict_Geometry} {
        puts "                   -> $objectPath -> $geometryPath: $retValue"
    }    
        #
        
        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001 * ($timeEnd - $timeStart)}]
        #            
    puts "                 ... $timeUsed seconds used for update_from_bikeGeometry"
        #
        
        #
    return
        #
}
    #
    #
    #
proc bikeModel::update_bikeFrame {} {
        #
    variable frameObject
    variable mappingDict_Frame_inv
        #
    puts "\n\n=== bikeModel::update_bikeFrame ============================ \n"    
        # puts "   -> \$frameObject $frameObject"
        #
    set myObject    $frameObject        
    set mappingDict $mappingDict_Frame_inv        
        #
        # appUtil::pdict $mappingDict
        #
        # 
    # puts "[$geometryRoot asXML]"
        #
        # set lug_BottomBracket               [$myObject getLug BottomBracket]  
        # set lug_RearDropout                 [$myObject getLug RearDropout]  
        #
        # set tube_ChainStay                  [$myObject getTube ChainStay]
        # set tube_DownTube                   [$myObject getTube DownTube ]
        # set tube_HeadTube                   [$myObject getTube HeadTube ]
        # set tube_SeatStay                   [$myObject getTube SeatStay ]
        # set tube_SeatTube                   [$myObject getTube SeatTube ]
        # set tube_TopTube                    [$myObject getTube TopTube  ]
        #
    set targetPathList  [$myObject getInitKeys]
        #
        # appUtil::pdict $mappingDict 2 "  "    
        #
    set initFrameDict   {}
        #
    foreach targetPath $targetPathList {
            #
        # puts "    -> $targetPath"    
            #
        if {[catch {set sourcePath [dict get $mappingDict $targetPath]} eID]} {
                #
                # puts "         -> no reference for $targetPath"
                #
        } else {
                #
                # puts "         -> $targetPath -> $sourcePath"
                #
            lassign [split $sourcePath /]   sourceName sourceType sourceKey
                # foreach {sourceName sourceType sourceKey} [split $sourcePath /] break
            set sourceObject    [get__Object $sourceName]
                # puts "                  -> $sourceObject"
            set sourceValue     [$sourceObject getValue $sourceType $sourceKey]
                # puts "                        -> $sourceValue"
                #
            lassign [split $targetPath /]   targetName targetType targetKey
                # foreach {targetName targetType targetKey} [split $targetPath /] break
            dict set initFrameDict $targetName $targetType $targetKey $sourceValue
        }
    }    
        #
        # puts "\n--- \$initFrameDict ---"
        # appUtil::pdict $initFrameDict 2 "    "
        #
    $myObject   initProject_DICT    $initFrameDict
        #
    # set resultFrameDict  [$myObject getDictionary]    
        #
    # puts "\n--- \$resultFrameDict ---"
    # appUtil::pdict $resultFrameDict 2 "    "
        #
        #
        #
        # set sourceObject    [get__Object RearDropout]
        # puts "                  -> $sourceObject" 
        # $sourceObject reportValues
        #
    return
        #
}     
    #
proc bikeModel::update_from_bikeFrame {} {
        #
    variable frameObject
    variable mappingDict_Frame
        #
    # puts "   -> \$frameObject $frameObject"
        #
    set myObject    $frameObject        
    set mappingDict $mappingDict_Frame        
        # set mappingDict $mappingDict_Frame        
        #
    # appUtil::pdict $mappingDict
        #
    set resultFrameDict  [$myObject getDictionary]    
        #
        # puts "\n--- \$resultFrameDict ---"
        # appUtil::pdict $resultFrameDict 2 "    "
        #
        #
    dict for {modelPath framePath} $mappingDict {
            # puts "        -> \$modelPath      $modelPath"
            # puts "             -> \$framePath $framePath"
        lassign [split $framePath /]    frameObj frameType frameKey
            # foreach {frameObj frameType frameKey} [split $framePath /] break
        set frameValue [dict get $resultFrameDict $frameObj  $frameType $frameKey]
        lassign [split $modelPath /]    modelObj modelType modelKey 
            # foreach {modelObj modelType modelKey} [split $modelPath /] break
        set myObject [get__Object $modelObj]
        $myObject setValue $modelType $modelKey $frameValue
    }
        #
    return
        #
}     
    #
    #
    #
proc bikeModel::update_bikeComponent {} {
        #
        # this procedure will not be necessary in the future
        # because of the direct reference of the bikeComponent objects
        # in local objects of bikeModel
        #
        #
    variable componentIF
        #
    variable mappingDict_Component
        #
    puts "\n\n=== bikeModel::update_bikeComponent ======================== \n"    
        #
        # appUtil::pdict $mappingDict_Component 1 "                   "
        #
    set timeStart    [clock milliseconds]
        #
        # strategy Objects
        #
    foreach objPath [dict keys $mappingDict_Component] {
            # puts "                   -> $objPath  -> $objPath"
            # puts "\n"
            # puts "--> update_bikeComponent - $objPath"
            #
        lassign [split $objPath /]  objName objType objKey
            # foreach {objName objType objKey} [split $objPath /] break
            #
            # puts "----> $objName $objType $objKey"    
            #
        switch -exact $objType {
            ComponentKey -
            Config -
            ListValue -
            Scalar {}
            default {
                    # puts "                       -> ignore resultVariable:  $objPath\n\n"
                    continue
                }
        }        
            #
        set myObject    [get__Object $objName]
        set myValue     [$myObject getValue $objType $objKey]
            #
        # $myObject reportValues
            #
        # puts "                   -> $objPath  -> $objName -> $objType -> $objKey -- $myObject --- $myValue"
            #
            #
        set compPath     [get_Mapping Component $objPath]
            #
        lassign [split $compPath /] compName compType compKey
            # foreach {compName compType compKey} [split $compPath /] break    
            # puts "----> $compName $compType $compKey"
            # puts "                   -> $compPath  -> $compName -> $compType -- $compKey <- $myValue"
            # continue
        set retValue {}
            #
        switch -exact $compType {
            Config {        set retValue [$componentIF set_Config    $compName $compKey $myValue]}
            ListValue {     set retValue [$componentIF set_ListValue $compName $compKey $myValue]}
            Scalar {        set retValue [$componentIF set_Scalar    $compName $compKey $myValue]}
        }
            #
            # puts "                   -> $retValue <--"
            # puts ""
            #
        # if {$compName eq {CrankSet}} {exit}
            #
    }
        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001 * ($timeEnd - $timeStart)}]
        #            
    puts "                 ... $timeUsed seconds used for update_bikeComponent"
            
        #
    return 
        #
}
    #
proc bikeModel::update_bikeComponent_Placements {} {
        #
    variable componentIF
        #
        #
    puts "\n\n=== bikeModel::update_bikeComponent_Placements ============= \n"
        #
        
        #
    set timeStart   [clock milliseconds]
        #
        
        #
        #
        # == BottleCage == DownTube ==
        #
    set pos_DownTube            [get__ObjectValue DownTube Position End]
    set angle_DownTube          [expr {[vectormath::localVector_2_Degree [get__ObjectValue DownTube Direction XZ]] - 180 + 180}]
        #
    set offset_BB               [get__ObjectValue BottleCage_DownTube Scalar OffsetBB]
    set offset_CenterLine       [expr {0.5 * [get__ObjectValue DownTube Scalar DiameterEnd]}]
    set pos_BottleCage          [vectormath::addVector $pos_DownTube [vectormath::rotatePoint {0 0} [list $offset_BB $offset_CenterLine] $angle_DownTube]]
    $componentIF set_Placement  BottleCage_DownTube     $pos_BottleCage $angle_DownTube
        #
        #
        # == BottleCage == DownTube == Lower ==
        #
    set offset_BB               [get__ObjectValue BottleCage_DownTube_Lower Scalar OffsetBB]
    set offset_CenterLine       [expr {-0.5 * [get__ObjectValue DownTube Scalar DiameterEnd]}]
    set pos_BottleCage          [vectormath::addVector $pos_DownTube [vectormath::rotatePoint {0 0} [list $offset_BB $offset_CenterLine] $angle_DownTube]]
    $componentIF set_Placement  BottleCage_DownTubeLower    $pos_BottleCage $angle_DownTube
        #
        #
        # == BottleCage == SeatTube ==
        #
    set pos_SeatTube            [get__ObjectValue SeatTube Position End]
    set angle_SeatTube          [expr {[vectormath::localVector_2_Degree [get__ObjectValue SeatTube Direction XZ]] + 180}]
    set offset_BB               [get__ObjectValue BottleCage_SeatTube Scalar OffsetBB]
    set offset_CenterLine       [expr {-0.5 * [get__ObjectValue SeatTube Scalar DiameterEnd]}]
    set pos_BottleCage          [vectormath::addVector $pos_SeatTube [vectormath::rotatePoint {0 0} [list $offset_BB $offset_CenterLine] $angle_SeatTube]]
    $componentIF set_Placement  BottleCage_SeatTube     $pos_BottleCage $angle_SeatTube
        #
        #
        # == Label == DownTube ==
        #
    set pos_DownTube_Origin     [get__ObjectValue   DownTube    Position    Origin]
    set pos_DownTube_End        [get__ObjectValue   DownTube    Position    End]
    set offset_BB               [expr {0.5 * [vectormath::length $pos_DownTube_Origin $pos_DownTube_End] - 90}]
    set angle_DownTube          [vectormath::localVector_2_Degree [get__ObjectValue DownTube Direction XZ]]
    set pos_Label               [vectormath::addVector $pos_DownTube_End [vectormath::rotateLine {0 0} $offset_BB $angle_DownTube]]
        # 
    $componentIF set_Placement  Label       $pos_Label  $angle_DownTube
        #
        #
        # == CrankSet ==
        #
    set pos_BottomBracket       {0.00 0.00}  
    set angle_BottomBracket     0.00
        #
    $componentIF set_Placement  CrankSet    $pos_BottomBracket  $angle_BottomBracket
        #
        #
        # == Fork ==
        #
    set strategy_Fork           [get__ObjectValue Fork      Config      Type]
    set height_Fork             [get__ObjectValue Fork      Scalar      Height]
    set rake_Fork               [get__ObjectValue Fork      Scalar      Rake]
    set pos_HeadTube            [get__ObjectValue HeadTube  Position    End]
    set pos_Fork                [get__ObjectValue Fork      Position    Origin]  
    set angle_Fork              [expr {90 - [get__ObjectValue Geometry Scalar   HeadTube_Angle]}]
    set length_ForkSteerer      [expr {[vectormath::length $pos_HeadTube $pos_Fork] + 10}]
    $componentIF set_Config     Fork        Type            $strategy_Fork
    $componentIF set_Scalar     Fork        SteererLength   $length_ForkSteerer
    $componentIF set_Scalar     Fork        Height          $height_Fork
    $componentIF set_Scalar     Fork        Rake            $rake_Fork
        #
    $componentIF set_Placement  Fork        $pos_Fork       $angle_Fork
        #
        #
        # == FrontDerailleur ==
        #
    set dist_FrontDerailleur    [get__ObjectValue FrontDerailleur   Scalar      Distance]
    set offset_FrontDerailleur  [get__ObjectValue FrontDerailleur   Scalar      Offset]
    set dir_SeatTube            [get__ObjectValue SeatTube Direction XZ]
    set angle_FrontDerailleur   [expr {[vectormath::localVector_2_Degree $dir_SeatTube] - 90 + 180}]
    set pos_FrontDerailleur     [vectormath::rotatePoint {0 0} [list $offset_FrontDerailleur $dist_FrontDerailleur] $angle_FrontDerailleur]
        #
    $componentIF set_Placement  FrontDerailleur $pos_FrontDerailleur    $angle_FrontDerailleur
        #
        #
        # == FrontFender ==
        #
    set pos_FrontWheel          [get__ObjectValue FrontWheel Position Origin] 
    set angle_FrontFender       [get__ObjectValue Geometry Scalar   HeadTube_Angle]
        #
    $componentIF set_Placement  FrontFender $pos_FrontWheel $angle_FrontFender
        #
        #
        # == HeadSet ==
        #
    set cfg_HeadTube            [get__ObjectValue HeadTube Config Type]
    if {$cfg_HeadTube eq {cylindric}} {
        set diam_HTTop      [get__ObjectValue HeadTube Scalar Diameter]
        set diam_HTBase     [get__ObjectValue HeadTube Scalar Diameter]
    } else {
        set diam_HTTop      [get__ObjectValue HeadTube Scalar DiameterTaperedTop]                  
        set diam_HTBase     [get__ObjectValue HeadTube Scalar DiameterTaperedBase]
    }
    set pos_HeadSet             [get__ObjectValue HeadTube Position Origin]
    set angle_HeadSet           [expr {[vectormath::localVector_2_Degree [get__ObjectValue HeadTube Direction XZ]] - 90 + 180}]
    set dist_HeadTube           [get__ObjectValue HeadTube Scalar Length]
    $componentIF set_Config     HeadSet     Style_HeadTube          $cfg_HeadTube
    $componentIF set_Scalar     HeadSet     Diameter_HeadTube       $diam_HTTop
    $componentIF set_Scalar     HeadSet     Diameter_HeadTubeBase   $diam_HTBase
        #
    $componentIF set_Placement  HeadSet     $pos_HeadSet    $angle_HeadSet  $dist_HeadTube
        #
        #
        # == SeatPost ==
        #
    set pos_SeatPost            [get__ObjectValue SeatPost  Position Pivot]  
    set pos_SeatPostST          [get__ObjectValue SeatPost  Position SeatTube] 
    set pos_TopTubeEnd          [get__ObjectValue TopTube   Position End] 
    set pos_TopTubeStart        [get__ObjectValue TopTube   Position Origin] 
    set dir_SeatTube            [get__ObjectValue SeatTube  Direction XZ]
    set length_SeatPost         [expr {[vectormath::length   $pos_SeatPostST $pos_TopTubeEnd] + 60}]
    set angle_SeatTube          [expr {[vectormath::localVector_2_Degree $dir_SeatTube] - 90}]
        #
    $componentIF set_Scalar     SeatPost    Length          $length_SeatPost
        #
    $componentIF set_Placement  SeatPost    $pos_SeatPost   $angle_SeatTube
        #
        #
        # == Stem ==
        #
    set pos_HandleBar           [get__ObjectValue HandleBar Position Origin]    
    set pos_SteererEnd          [get__ObjectValue Steerer   Position Stem]    
    set pos_HeadTubeTop         [get__ObjectValue HeadTube  Position End]
    set height_HeadSetTop       [get__ObjectValue HeadSet   Scalar   HeightTop]
    set dir_HeadTube            [get__ObjectValue HeadTube  Direction XZ]
    set length_StemShaft        [expr {[vectormath::length   $pos_HeadTubeTop $pos_SteererEnd] - $height_HeadSetTop}]
    set angle_Stem              [expr {[vectormath::localVector_2_Degree $dir_HeadTube] + 90}]
        #
    $componentIF set_Scalar     Stem        Length_Shaft    $length_StemShaft
        #
    $componentIF set_Placement  Stem        $pos_HandleBar  $angle_Stem
        #
        #
        # == RearDropout ==
        #
    set pos_RearDropout         [get__ObjectValue RearDropout     Position Origin] 
    set dir_Dropout             [get__ObjectValue RearDropout     Direction XZ]
    set angle_Dropout           [vectormath::localVector_2_Degree $dir_Dropout]
        #
    $componentIF set_Placement  RearDropout $pos_RearDropout $angle_Dropout
        #
        #
        # == RearDerailleur ==
        #
    set pos_RearDerailleur      [$componentIF get_Position  RearDropout Derailleur]
    $componentIF set_Placement  RearDerailleur $pos_RearDerailleur  0
        #
        #
        # == RearFender ==
        #
    set pos_RearWheel           [get__ObjectValue RearWheel Position Origin] 
    set angle_RearFender        [vectormath::localVector_2_Degree [get__ObjectValue ChainStay Direction XZ]]
        #
    $componentIF set_Placement  RearFender   $pos_RearWheel  $angle_RearFender
        #
        #
        # == FrontCarrier ==
        #
    set pos_FrontWheel          [get__ObjectValue FrontWheel Position Origin]  
    set x_FrontCarrier          [expr {-1.0 * [get__ObjectValue FrontCarrier Scalar x]}]  
    set y_FrontCarrier          [get__ObjectValue FrontCarrier Scalar y]  
    set pos_FrontCarrier        [vectormath::addVector $pos_FrontWheel [list $x_FrontCarrier $y_FrontCarrier]]
        #
    $componentIF set_Placement  FrontCarrier    $pos_FrontCarrier 0
        #
        #
        # == HandleBar ==
        #
    set pos_HandleBar           [get__ObjectValue HandleBar Position Origin]  
    set angle_HandleBar         [get__ObjectValue HandleBar Scalar   PivotAngle]
        #
    $componentIF set_Placement  HandleBar   $pos_HandleBar  $angle_HandleBar
        #
        #
        # == RearHub ==
        #
    set pos_RearWheel           [get__ObjectValue RearWheel Position Origin] 
    $componentIF set_Placement  RearHub     $pos_RearWheel  0
        #
        #
        # == RearCarrier ==
        #
    set pos_RearWheel           [get__ObjectValue RearWheel Position Origin]  
    set x_RearCarrier           [expr {-1.0 * [get__ObjectValue RearCarrier Scalar x]}]
    set y_RearCarrier           [get__ObjectValue RearCarrier Scalar y] 
    set pos_RearCarrier         [vectormath::addVector $pos_RearWheel [list $x_RearCarrier $y_RearCarrier]]
        #
    $componentIF set_Placement  RearCarrier     $pos_RearCarrier 0
        #
        #
        # == Saddle ==
        #
    set pos_Saddle              [get__ObjectValue Saddle Position Origin] 
    $componentIF set_Placement  Saddle          $pos_Saddle     0
        #
        #
        # == FrontBrake ==
        #
    set angle_FrontBrakeCrown   [$componentIF get_Scalar    Fork    CrownBrakeAngle]
    set offset_FrontBrake       [$componentIF get_Scalar    Fork    BladeBrakeOffset]
    set offset_FrontBrakeCrown  [$componentIF get_Scalar    Fork    CrownBrakeOffset]
    set vector_ForkBlade        [$componentIF get_Vector    Fork    BladeDefinition]        
    set radius_FrontRim         [expr {0.5 * [get__ObjectValue FrontWheel Scalar RimDiameter]}]
    set pos_FrontWheel          [get__ObjectValue FrontWheel Position Origin]
    set p_01                    [lrange $vector_ForkBlade 0 1]
    set p_02                    [lrange $vector_ForkBlade 2 3]
        #
    set vector_BrakeDef         [vectormath::parallel $p_01 $p_02 $offset_FrontBrake left]
    lassign                     $vector_BrakeDef    p_11 p_12
        # foreach {p_11 p_12}   $vector_BrakeDef break
        #
    set p_14                    [vectormath::intersectPerp $p_11 $p_12 $pos_FrontWheel]
        #
    set dist_Perp               [vectormath::distancePerp  $p_11 $p_12 $pos_FrontWheel]
        #
    set dist_Wheel              [expr {sqrt(pow($radius_FrontRim,2) - pow($dist_Perp,2))}]
        #
    set dir_Definition          [vectormath::unifyVector $p_11 $p_12]
    set pos_FrontBrake          [vectormath::addVector $p_14 [vectormath::unifyVector $p_12 $p_11] $dist_Wheel]
    set angle_FrontBrake        [expr {[vectormath::localVector_2_Degree [get__ObjectValue HeadTube Direction XZ]] + $angle_FrontBrakeCrown}]
        #
    $componentIF set_Placement  FrontBrake  $pos_FrontBrake $angle_FrontBrake
        #
    set dir_FrontBrakeAxle      [$componentIF get_Direction     FrontBrake  Axle]
    set pos_FrontBrakeAxle      [$componentIF get_Position      FrontBrake  Axle]
    set pos_HeadSet_Origin      [get__ObjectValue   HeadTube    Position    Origin]
    set pos_HeadSet_End         [get__ObjectValue   HeadTube    Position    End]
    set pos_FrontBrakeDef       [vectormath::intersectPerp  $p_01 $p_02 $pos_FrontBrake]
    set angle_FrontBrakeAxle    [vectormath::localVector_2_Degree $dir_FrontBrakeAxle]
    set p_20                    [vectormath::addVector $pos_FrontBrakeAxle [vectormath::rotateLine {0 0} 1 [expr {90 + $angle_FrontBrakeAxle}]]]
    set vector_BrakeMountDef    [vectormath::parallel $pos_HeadSet_Origin $pos_HeadSet_End $offset_FrontBrakeCrown right]
    lassign                     $vector_BrakeMountDef   p_11 p_12
        # foreach {p_11 p_12}   $vector_BrakeMountDef break
    set pos_FrontBrakeMount     [vectormath::intersectPoint $p_11 $p_12 $pos_FrontBrakeAxle $p_20]
        #
    set__ObjectValue FrontBrake Position    Definition  $pos_FrontBrakeDef
    set__ObjectValue FrontBrake Position    Help        $pos_FrontBrakeAxle
    set__ObjectValue FrontBrake Position    Mount       $pos_FrontBrakeMount            
        #
        #
        # == RearBrake ==
        #
    set offset_RearBrake        [$componentIF get_Scalar    RearBrake   BladeOffset]
    set pos_RearWheel           [get__ObjectValue RearWheel Position    Origin]
    set pos_SeatStay_End        [get__ObjectValue SeatStay  Position    End]
    set pos_SeatStay_Origin     [get__ObjectValue SeatStay  Position    Origin]
    set radius_RearRim          [expr {0.5 * [get__ObjectValue RearWheel Scalar  RimDiameter]}]
    set radius_SeatStay         [expr {0.5 * [get__ObjectValue SeatStay  Scalar  DiameterEnd]}]
        #
    set p_01                    $pos_SeatStay_End
    set p_02                    $pos_SeatStay_Origin
    set vector_SeatStay         [vectormath::parallel $p_01 $p_02   $radius_SeatStay    right]
    set vector_BrakeDef         [vectormath::parallel $p_01 $p_02   [expr {$radius_SeatStay + $offset_RearBrake}] right]
    lassign                     $vector_BrakeDef    p_11 p_12
        # foreach {p_11 p_12}   $vector_BrakeDef break
    set p_14                    [vectormath::intersectPerp $p_11 $p_12 $pos_RearWheel]
    set dist_Perp               [vectormath::distancePerp  $p_11 $p_12 $pos_RearWheel]
    set dist_Wheel              [expr {sqrt(pow($radius_RearRim,2) - pow($dist_Perp,2))}]
    set pos_RearBrake           [vectormath::addVector $p_14 [vectormath::unifyVector $p_12 $p_11] $dist_Wheel]
    set angle_RearBrake         [expr {[vectormath::localVector_2_Degree [get__ObjectValue SeatStay Direction XZ]] - 180}]
        #
    $componentIF set_Placement  RearBrake  $pos_RearBrake $angle_RearBrake
        #
        
        #
    set timeEnd     [clock milliseconds]
    set timeUsed    [expr {0.001 * ($timeEnd - $timeStart)}]
        #            
    puts "                 ... $timeUsed seconds used for update_bikeComponent_Placements"
        #
        
        #
    return
        #
}    
    #
proc bikeModel::update_from_bikeComponent {} {
        #
    variable componentIF
        #
    variable mappingDict_Component
        #
    puts "\n\n=== bikeModel::update_from_bikeComponent =================== \n"    
        #
        # appUtil::pdict $mappingDict_Component 1 "                   "
        #
        #
    foreach objPath [dict keys $mappingDict_Component] {
            # puts "                   -> $objPath  -> $objPath"
            # puts "--- $objPath"
            #
        lassign [split $objPath /]      objName objType objKey
            # foreach {objName objType objKey} [split $objPath /] break
            #
        set myObject    [get__Object $objName]
            #
        set oldValue     [$myObject getValue $objType $objKey]
            #
            # puts "                   -> $objPath  -> $objType -> $objKey -- $myObject --- $oldValue"
            #
            #
        set compPath     [get_Mapping Component $objPath]
            #
        lassign [split $compPath /]     compName compType compKey    
            # foreach {compName compType compKey} [split $compPath /] break    
            # puts "                   -> $compPath  -> $compName -> $compType -- $compKey"
        
        
        set retValue {}
            #
            # this is the future solution
        switch -exact $compName {
            _HeadSet_ -
            _any_ {return}
        }
            #
            # this is the old solution
        switch -exact $compType {
            ComponentKey  { set retValue [$componentIF get_ComponentKey     $compName $compKey]}
            ComponentNode { set retValue [$componentIF get_ComponentNode    $compName $compKey]}
            Config {        set retValue [$componentIF get_Config           $compName $compKey]}
            Direction {     set retValue [$componentIF get_Direction        $compName $compKey]}
            ListValue {     set retValue [$componentIF get_ListValue        $compName $compKey]}
            Polygon {       set retValue [$componentIF get_Polygon          $compName $compKey]}
            Polyline {      set retValue [$componentIF get_Polyline         $compName $compKey]}
            Position {      set retValue [$componentIF get_Position         $compName $compKey]}
            Scalar {        set retValue [$componentIF get_Scalar           $compName $compKey]}
        }
            #
            #               set retValue [$componentIF get_ComponentKey $compType $compKey]
    
            # puts "                   -> $retValue"
            #
        $myObject setValue $objType $objKey $retValue
            #
    }
        #
        #
    return 
        #
}
    
    
    #
    #
    #
    #
proc bikeModel::set_geometryIF {{interfaceName {}}} {
        #
        #   set the interface ensemble of bikeGeometry
        #
    variable geometryIF
    variable geometryIF_Name
        #
    puts "      ---- bikeModel::set_geometryIF    ----  $interfaceName  --"
        #
    switch -exact $interfaceName {
            {Classic}       {set geometryIF     ::bikeGeometry::IF_Classic}
            {Lugs}          {set geometryIF     ::bikeGeometry::IF_LugAngles}
            {StackReach}    {set geometryIF     ::bikeGeometry::IF_StackReach}
            {OutsideIn}     -
            default         {set geometryIF     ::bikeGeometry::IF_OutsideIn
                             set interfaceName  OutsideIn
            }
    }
        #
    set geometryIF_Name $interfaceName    
        #
    puts "                          ->  $geometryIF"
    puts "                 ----------------------------------------------------"
        #
    foreach {subcmd proc} [namespace ensemble configure $geometryIF    -map] {
                puts [format {                   %-30s %-20s  <- %s }     $subcmd [info args $proc] $proc ]
            }
        #
    puts ""
    puts "      ---- bikeModel::set_geometryIF    ----  $geometryIF_Name  --"
    puts "\n"
        #
    return [list $geometryIF_Name $geometryIF]
        #
} 
    #
proc bikeModel::get_geometryIF {{interfaceName {}}} {
    variable geometryIF_Name
    return $geometryIF_Name
}
    #
    #
    #
proc bikeModel::get_ListBoxValues {} {
        #
    variable componentIF
        # variable geometryIF
        #
    set _listDict [$componentIF get_ListBoxValues]
        #
        # -- frame rendering --
    dict append _listDict   DropOutDirection "Chainstay horizontal"
    dict append _listDict   DropOutPosition  "front behind"
    dict append _listDict   HeadTube         "cylindric tapered"
    dict append _listDict   ChainStay        "straight bent"
        #
        # set _listDict [$geometryIF get_ListBoxValues]
        #
    return $_listDict
        #
}    
    #
proc bikeModel::get_ComponentBaseDirectory {} {
        #
        #   ... this will disappear for bikeComponent
        #
    variable componentIF
    variable geometryIF
        #
        # puts "bikeModel::get_ComponentDir"
    set retValue [$componentIF  get_ComponentBaseDirectory]
    return $retValue
        #
    # return [bikeGeometry::get_ComponentDir]
        #
}    
    #
proc bikeModel::get_ComponentDirectories {} {
        #
        #   ... this will disappear for bikeComponent
        #
    variable componentIF
    variable geometryIF
        #
    # puts "bikeModel::get_ComponentDirectories"
    set retValue [$componentIF  get_ComponentDirectories]
        #
    return $retValue
        #
}    
    #
proc bikeModel::get_ComponentSubDirectories {} {
        #
    variable componentIF
    variable geometryIF
        #
    puts "bikeModel::get_ComponentDirectories"
    set retValue [$componentIF  get_ComponentSubDirectories]
    foreach dir $retValue {
        puts "    -> $dir"
    }
    puts "\n        --------\n"
    return $retValue
        #
    return [bikeGeometry::get_ComponentDirectories]
        #
}    
    #
proc bikeModel::get_componentAlternatives {key} {
    variable componentIF
    set retValue    [$componentIF get_CompAlternatives $key]
    return $retValue    
}  
    #
proc bikeModel::get_componentPath {objectName key} {
    variable componentIF
    set retValue    [$componentIF get_ComponentPath $objectName $key]
    return $retValue    
}  
    #
    #
proc bikeModel::add_ComponentDir {key dir} {
    variable componentIF
    set retValue    [$componentIF add_ComponentDir $key $dir]
    return $retValue
}
    #
    #
    # --- interface -------------------------------
    #
proc bikeModel::read_inputModelDocument {domDoc} {
        #
    variable dataStructureDoc 
        #
    set modelDoc $dataStructureDoc
        #
        # puts [$domDoc asXML]    
        #
    update_Model [$domDoc documentElement]
        #
    return
        #
}
    #
proc bikeModel::get_inputModelDocument {} {
        #
    puts "\n    ---- get_inputModelDocument [namespace current] ----\n"
        #
        #   -- return a copy of inputModelDoc
        #
    variable inputModelDoc
        #
    set myDoc   [dom parse [$inputModelDoc asXML]]
        #
    return $myDoc
        #
}
    #
proc bikeModel::get_resultModelDocument {{type update}} {
        #
    puts "\n    ---- get_resultModelDocument [namespace current] -- $type --\n"
        #
    variable resultModelDoc
        #
    update_resultModelDocument $type
        #
    return $resultModelDoc
        #
}  
    #
proc bikeModel::get_resultModelDictionary {} {
        #
    puts "\n    ---- get_resultModelDictionary [namespace current] --------\n"
        #
    variable dataStructureDoc
        #
    set my_Dict [dict create]
     #
    set myDoc   [dom parse [$dataStructureDoc asXML]]
    set myRoot  [$myDoc documentElement]
        #
    foreach objectNode [$myRoot selectNodes *] {
            #
        if {[$objectNode nodeType] == "ELEMENT_NODE"} {
            set objectXPath  [$objectNode toXPath]
            set objectName   [string map {/root/ {}} $objectXPath]
            set myObject [get__Object $objectName]
            # puts "      -> $objectName  -  $objectXPath <- $myObject"
                #
            foreach typeNode [$objectNode childNodes] {
                if {[$typeNode nodeType] == "ELEMENT_NODE"} {
                    set typeName [$typeNode nodeName]
                    # puts "          -> $typeName"
                    foreach valueNode [$typeNode childNodes] {
                        if {[$valueNode nodeType] == "ELEMENT_NODE"} {
                            set valueName [$valueNode nodeName]
                            set value     [$myObject getValue $typeName $valueName]
                                # puts "              -> $valueName   <- $value"
                                #
                            if {[llength $value] > 1} {
                                set value [list $value]
                            }
                                #
                            dict set my_Dict $objectName $typeName $valueName $value
                                #
                        }
                    }

                }
            }
                #
            
        }
            #
        continue  
            #
    }
        #
    return $my_Dict
        #
}
    #
proc bikeModel::get_resultMiterDictionary {} {
        #
    puts "\n    ---- get_resultMiterDictionary [namespace current] --------\n"
        #
    variable frameObject
        # set baseDict    [get_guiDictionary]
        #
    set myDict      [$frameObject getDictionary_TubeMiter]
        #
    return $myDict
        #
}        
proc bikeModel::get_resultTubeMiterDictionary {} {
        #
    puts "\n    ---- get_resultTubeMiterDictionary [namespace current] ----\n"
        #
    set myDict      [dict create]
        #
        
        #
        # --- DownTube_Head
        #
    set key             DownTube_Head
        #
        # puts "$minorDiameter"
        # puts "[get__ObjectValue DownTube Scalar DiameterOrigin]"
        # puts "$::bikeGeometry::HeadTube(Diameter)"
        # puts "[get__ObjectValue DownTube Scalar DiameterOrigin]"
        # puts [format "%.3f" [dict get $baseDict TubeMiter   $key    miterAngle]]
        # puts [format "%.3f" [get__ObjectValue DownTube Scalar MiterAngelOrigin]]
        #
        #DownTube_Head -> 
        #    miterAngle -> '60.971717549732055'
        #    polygon_01 -> '{-49.9513231920777 -29.40978531454691 -48.56378643674221 -29.315109986553182 -47.176249681406716 -29.03211439449813 -45.788712926071234 -28.563900332781873 -44.401176170735745 -27.915674657241816 -43.01363941540025 -27.0948116137102 -41.62610266006475 -26.11095395785076 -40.23856590472926 -24.976168586579494 -38.851029149393774 -23.705179423311083 -37.463492394058285 -22.315708540534683 -36.07595563872279 -20.828964138695717 -34.6884188833873 -19.270314867435683 -33.30088212805181 -17.670167561014583 -31.913345372716314 -16.064981777895824 -30.52580861738082 -14.498137449620815 -29.13827186204533 -13.019930809602535 -27.750735106709836 -11.685340548702111 -26.363198351374347 -10.5479235820105 -24.975661596038854 -9.649596156793052 -23.58812484070336 -9.009837929786435 -22.200588085367873 -8.62087500478892 -20.813051330032376 -8.452407807164276 -19.425514574696887 -8.462318596651846 -18.037977819361394 -8.606803300394304 -16.650441064025905 -8.846390700565589 -15.262904308690409 -9.148093893889374 -13.875367553354916 -9.485335265624903 -12.487830798019425 -9.837003633133827 -11.100294042683934 -10.186368960773537 -9.712757287348442 -10.520138879406106 -8.32522053201295 -10.8277241209025 -6.937683776677457 -11.10069625431274 -5.550147021341966 -11.332398650791069 -4.1626102660064745 -11.517672422942754 -2.7750735106709827 -11.652666668458343 -1.3875367553354907 -11.734710535505338 1.4404579271992006e-15 -11.762231593648908 1.3875367553354934 -11.734710535505338 2.7750735106709854 -11.652666668458343 4.162610266006478 -11.517672422942754 5.55014702134197 -11.332398650791069 6.937683776677461 -11.10069625431274 8.325220532012954 -10.827724120902497 9.712757287348445 -10.520138879406103 11.100294042683938 -10.186368960773533 12.487830798019429 -9.837003633133824 13.87536755335492 -9.485335265624899 15.262904308690413 -9.14809389388937 16.650441064025905 -8.846390700565586 18.037977819361394 -8.6068033003943 19.425514574696887 -8.462318596651842 20.813051330032376 -8.452407807164272 22.200588085367873 -8.620875004788912 23.58812484070336 -9.009837929786428 24.975661596038854 -9.649596156793045 26.363198351374347 -10.547923582010492 27.750735106709836 -11.685340548702104 29.13827186204533 -13.019930809602528 30.52580861738082 -14.498137449620808 31.91334537271632 -16.064981777895817 33.30088212805181 -17.670167561014576 34.6884188833873 -19.270314867435676 36.07595563872279 -20.82896413869571 37.463492394058285 -22.315708540534676 38.851029149393774 -23.705179423311076 40.23856590472926 -24.976168586579487 41.62610266006475 -26.110953957850754 43.01363941540025 -27.094811613710192 44.401176170735745 -27.9156746572418 45.788712926071234 -28.56390033278186 47.17624968140673 -29.032114394498116 48.56378643674223 -29.315109986553168 49.951323192077716 -29.409785314546895 49.951323192077716 -70 -49.9513231920777 -70}'
        #
    set minorDiameter   [get__ObjectValue DownTube Scalar DiameterOrigin]                       
    set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        #
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" [get__ObjectValue DownTube Scalar MiterAngelOrigin]]               
    dict set myDict     TubeMiter   $key    polygon_01          [list [join [get__ObjectValue DownTube Polygon MiterOrigin] " "]]
        #
    dict set myDict     TubeMiter   $key    minorName           DownTube                         
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                             
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction DownTube   degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           HeadTube                     
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::HeadTube(Diameter) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction HeadTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" 0]
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    if {$::bikeGeometry::Config(HeadTube) == {cylindric}} { 
        dict set myDict   TubeMiter   $key    toolType        {cylinder}
    } else {    
        dict set myDict   TubeMiter   $key    toolType        {cone}
        dict set myDict   TubeMiter   $key    baseDiameter    $::bikeGeometry::HeadTube(DiameterTaperedBase)
        dict set myDict   TubeMiter   $key    topDiameter     $::bikeGeometry::HeadTube(DiameterTaperedTop)   
        dict set myDict   TubeMiter   $key    baseHeight      $::bikeGeometry::HeadTube(HeightTaperedBase)    
        dict set myDict   TubeMiter   $key    frustumHeight   $::bikeGeometry::HeadTube(LengthTapered)      
        dict set myDict   TubeMiter   $key    sectionPoint    [format {%.6f} [vectormath::length $::bikeGeometry::Position(DownTube_End) $::bikeGeometry::Position(HeadTube_Start)]]
    }
        #
        # --- DownTube_Seat
        #
        #DownTube_Seat -> 
        #    miterAngle -> '59.97186433200594'
        #    polygon_01 -> '{-54.82079180514189 -8.278756718763198 -53.29799203277683 -8.232931314871813 -51.77519226041178 -8.095403509338611 -50.25239248804674 -7.865974304218679 -48.72959271568168 -7.544154141212075 -47.20679294331663 -7.128884601657179 -45.683993170951574 -6.618045612509981 -44.16119339858652 -6.007581389009326 -42.638393626221465 -5.289876977314401 -41.11559385385642 -4.450491198821824 -39.59279408149136 -3.460742331903585 -38.069994309126315 -2.2574575558387746 -36.54719453676126 -0.6661942432367516 -35.024394764396206 2.3669778038015528 -33.50159499203115 3.4496804123497746 -31.978795219666104 2.610498263498712 -30.45599544730105 1.7514486466004737 -28.933195674935995 0.8790694479480008 -27.410395902570944 -3.974406422573611e-15 -25.88759613020589 -0.8790694479480065 -24.36479635784084 -1.7514486466004813 -22.841996585475787 -2.6104982634987173 -21.319196813110732 -3.449680412349782 -19.79639704074568 -6.1582390167762195 -18.27359726838063 -10.752385012021458 -16.750797496015576 -13.827860270871467 -15.227997723650523 -16.42729924212269 -13.70519795128547 -18.71451897671945 -12.182398178920419 -20.7428177586453 -10.659598406555363 -22.531828963686806 -9.136798634190312 -24.08784047887727 -7.613998861825259 -25.411271072230665 -6.091199089460207 -26.499992215743923 -4.568399317095154 -27.350998609113738 -3.0455995447301016 -27.96132124425727 -1.522799772365049 -28.328550850482255 3.484259539771651e-15 -28.451138256332584 1.5227997723650561 -28.328550850482255 3.0455995447301087 -27.96132124425727 4.568399317095161 -27.350998609113738 6.091199089460214 -26.499992215743923 7.613998861825266 -25.411271072230665 9.136798634190319 -24.08784047887727 10.65959840655537 -22.531828963686806 12.182398178920423 -20.7428177586453 13.705197951285474 -18.71451897671945 15.227997723650526 -16.427299242122682 16.750797496015576 -13.827860270871463 18.27359726838063 -10.752385012021454 19.79639704074568 -6.158239016776214 21.319196813110732 -3.449680412349777 22.841996585475787 -2.610498263498712 24.36479635784084 -1.7514486466004755 25.88759613020589 -0.879069447948 27.410395902570944 2.7392042985154352e-15 28.933195674935995 0.8790694479480079 30.45599544730105 1.7514486466004813 31.978795219666104 2.61049826349872 33.50159499203115 3.4496804123497826 35.024394764396206 2.3669778038015616 36.54719453676126 -0.6661942432367427 38.069994309126315 -2.2574575558387657 39.59279408149136 -3.460742331903575 41.11559385385642 -4.450491198821814 42.638393626221465 -5.289876977314391 44.16119339858652 -6.0075813890093155 45.683993170951574 -6.61804561250997 47.20679294331663 -7.128884601657167 48.72959271568168 -7.544154141212062 50.25239248804674 -7.865974304218667 51.77519226041178 -8.095403509338597 53.29799203277683 -8.232931314871799 54.82079180514189 -8.278756718763184 54.82079180514189 -70 -54.82079180514189 -70}'
        #    polygon_02 -> '{-54.82079180514189 -4.41559735483208 -53.29799203277683 -4.67017543505596 -51.77519226041178 -5.355312677105754 -50.25239248804674 -6.316272614609396 -48.72959271568168 -7.424117858680712 -47.20679294331663 -8.595553091029824 -45.683993170951574 -9.778707736710418 -44.16119339858652 -10.93964147737429 -42.638393626221465 -12.054484555134986 -41.11559385385642 -13.105294731519782 -39.59279408149136 -14.077886990241554 -38.069994309126315 -14.960673258463752 -36.54719453676126 -15.744026645048598 -35.024394764396206 -16.419925915158323 -33.50159499203115 -16.981754150276068 -31.9787952196661 -17.424184349860845 -30.455995447301046 -17.743114893682865 -28.93319567493599 -17.93563384455091 -27.41039590257094 -18.000000000000004 -25.887596130205885 -17.93563384455091 -24.364796357840838 -17.743114893682865 -22.841996585475783 -17.424184349860845 -21.31919681311073 -16.981754150276068 -19.796397040745678 -16.419925915158323 -18.273597268380627 -15.744026645048594 -16.750797496015572 -14.960673258463748 -15.227997723650523 -14.07788699024155 -13.70519795128547 -13.105294731519779 -12.182398178920419 -12.054484555134982 -10.659598406555364 -10.939641477374286 -9.136798634190313 -9.778707736710414 -7.613998861825261 -8.59555309102982 -6.0911990894602095 -7.424117858680707 -4.568399317095157 -6.316272614609391 -3.0455995447301047 -5.355312677105748 -1.522799772365052 -4.6701754350559535 5.407547166918618e-16 -4.415597354832073 1.5227997723650533 -4.6701754350559535 3.0455995447301056 -5.355312677105748 4.5683993170951585 -6.316272614609389 6.091199089460211 -7.424117858680697 7.613998861825263 -8.595553091029814 9.136798634190317 -9.778707736710405 10.659598406555368 -10.939641477374277 12.182398178920423 -12.054484555134978 13.705197951285474 -13.105294731519775 15.227997723650526 -14.077886990241543 16.75079749601558 -14.960673258463741 18.273597268380634 -15.74402664504859 19.796397040745685 -16.419925915158313 21.319196813110736 -16.98175415027606 22.84199658547579 -17.424184349860838 24.364796357840845 -17.743114893682858 25.887596130205893 -17.935633844550903 27.410395902570947 -17.999999999999996 28.933195674935998 -17.935633844550903 30.455995447301053 -17.743114893682858 31.978795219666107 -17.42418434986084 33.50159499203115 -16.98175415027606 35.024394764396206 -16.419925915158316 36.54719453676126 -15.744026645048585 38.069994309126315 -14.960673258463745 39.59279408149136 -14.077886990241543 41.11559385385642 -13.105294731519772 42.638393626221465 -12.054484555134977 44.16119339858652 -10.939641477374282 45.683993170951574 -9.778707736710409 47.20679294331663 -8.595553091029824 48.72959271568168 -7.4241178586807 50.25239248804674 -6.3162726146093835 51.77519226041178 -5.355312677105742 53.29799203277683 -4.670175435055947 54.82079180514189 -4.415597354832066 54.82079180514189 -70 -54.82079180514189 -70}'
        #    polygon_03 -> '{-54.82079180514189 -9.77228223088139 -53.29799203277683 -9.889921061070215 -51.77519226041178 -10.231293851198375 -50.25239248804674 -10.765467929545128 -48.72959271568168 -11.450656137513777 -47.20679294331663 -12.242693042819967 -45.683993170951574 -13.100500944620409 -44.16119339858652 -13.988415051516307 -42.638393626221465 -14.87651161697486 -41.11559385385642 -15.74003653108849 -39.59279408149136 -16.558589979524598 -38.069994309126315 -17.315361513595732 -36.54719453676126 -17.99651007834575 -35.024394764396206 -18.590695712083715 -33.50159499203115 -19.088739456035814 -31.9787952196661 -19.483382669801866 -30.455995447301046 -19.769120519902515 -28.93319567493599 -19.9420901965115 -27.41039590257094 -20.000000000000004 -25.887596130205885 -19.9420901965115 -24.364796357840838 -19.769120519902515 -22.841996585475783 -19.483382669801866 -21.31919681311073 -19.088739456035814 -19.796397040745678 -18.590695712083715 -18.273597268380627 -17.99651007834575 -16.750797496015572 -17.315361513595732 -15.227997723650523 -16.558589979524598 -13.70519795128547 -15.740036531088487 -12.182398178920419 -14.876511616974856 -10.659598406555364 -13.988415051516304 -9.136798634190313 -13.100500944620405 -7.6139988618252605 -12.242693042819964 -6.091199089460209 -11.450656137513771 -4.568399317095157 -10.765467929545123 -3.045599544730104 -10.231293851198368 -1.5227997723650515 -9.889921061070208 1.196759415441344e-15 -9.772282230881382 1.5227997723650537 -9.889921061070208 3.0455995447301065 -10.231293851198368 4.5683993170951585 -10.765467929545123 6.091199089460212 -11.450656137513766 7.613998861825264 -12.242693042819957 9.136798634190317 -13.100500944620396 10.659598406555368 -13.988415051516295 12.182398178920423 -14.876511616974852 13.705197951285474 -15.740036531088482 15.227997723650526 -16.558589979524587 16.75079749601558 -17.31536151359572 18.273597268380634 -17.996510078345743 19.796397040745685 -18.590695712083708 21.319196813110736 -19.088739456035807 22.84199658547579 -19.483382669801856 24.364796357840845 -19.769120519902508 25.887596130205893 -19.942090196511494 27.410395902570947 -19.999999999999996 28.933195674935998 -19.942090196511494 30.455995447301053 -19.769120519902508 31.978795219666107 -19.48338266980186 33.50159499203115 -19.088739456035807 35.024394764396206 -18.590695712083708 36.54719453676126 -17.996510078345743 38.069994309126315 -17.31536151359573 39.59279408149136 -16.55858997952459 41.11559385385642 -15.74003653108848 42.638393626221465 -14.87651161697485 44.16119339858652 -13.988415051516299 45.683993170951574 -13.1005009446204 47.20679294331663 -12.242693042819964 48.72959271568168 -11.450656137513766 50.25239248804674 -10.765467929545117 51.77519226041178 -10.23129385119836 53.29799203277683 -9.8899210610702 54.82079180514189 -9.772282230881375 54.82079180514189 -70 -54.82079180514189 -70}'
        #
    set key     DownTube_Seat
    set minorDiameter   $::bikeGeometry::DownTube(DiameterBB)                        
    set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        #
        # puts [format "%.3f" [dict get $baseDict TubeMiter   $key    miterAngle]]                   
        # puts [list [lrange [join [dict get $baseDict TubeMiter $key    polygon_02] " "] 0 end-4]]    
        # puts [list [lrange [join [dict get $baseDict TubeMiter $key    polygon_03] " "] 0 end-4]]    
        #
        # puts [get__ObjectValue DownTube Scalar MiterAngelEnd]
        # puts [list [lrange [join [get__ObjectValue DownTube Polygon MiterEndBBInside] " "] 0 end-4]]
        # puts [list [lrange [join [get__ObjectValue DownTube Polygon MiterEndBBOutside] " "] 0 end-4]]
        #
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" [get__ObjectValue DownTube Scalar MiterAngelEnd]]               
    dict set myDict     TubeMiter   $key    polygon_01          [list [join [get__ObjectValue DownTube Polygon MiterEnd] " "]]
    dict set myDict     TubeMiter   $key    polygon_02          [list [lrange [join [get__ObjectValue DownTube Polygon MiterEndBBInside]  " "] 0 end-4]]
    dict set myDict     TubeMiter   $key    polygon_03          [list [lrange [join [get__ObjectValue DownTube Polygon MiterEndBBOutside] " "] 0 end-4]]
        #
    dict set myDict     TubeMiter   $key    minorName           DownTube                         
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                             
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction DownTube   degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           SeatTube                     
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatTube(DiameterBB) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction SeatTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" 0]
    dict set myDict     TubeMiter   $key    diameter_02         $::bikeGeometry::BottomBracket(InsideDiameter)   
    dict set myDict     TubeMiter   $key    diameter_03         $::bikeGeometry::BottomBracket(OutsideDiameter)   
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {cylinder}  
        #
        # --- Reference
        #
    set key     Reference
        #
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" 0]
    dict set myDict     TubeMiter   $key    polygon_01          [list [lindex [array get bikeGeometry::TubeMiter $key] 1]]
        #
    dict set myDict     TubeMiter   $key    minorName           ReferenceWidth                         
    dict set myDict     TubeMiter   $key    majorName           ReferenceHeight                     
    dict set myDict     TubeMiter   $key    minorDiameter       0                             
    dict set myDict     TubeMiter   $key    minorDirection      0                        
    dict set myDict     TubeMiter   $key    minorPerimeter      100.00                        
    dict set myDict     TubeMiter   $key    majorDiameter       0 
    dict set myDict     TubeMiter   $key    majorDirection      1
    dict set myDict     TubeMiter   $key    offset              0.00                        
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {plane}              
        #
        # --- SeatStay_01
        #
        #SeatStay_01   -> 
        #    miterAngle -> '131.75410730398946'
        #    offset     -> 
        #    polygon_01 -> '{-25.13274122871834 -24.34945267983858 -24.434609527920607 -23.83121631620244 -23.73647782712288 -23.194532503088926 -23.038346126325145 -22.4394979604178 -22.340214425527414 -21.567303002912844 -21.642082724729683 -20.580211797672835 -20.94395102393195 -19.481533065445912 -20.245819323134217 -18.275582010918583 -19.547687622336486 -16.967634188261247 -18.849555921538755 -15.56387195193547 -18.151424220741028 -14.071324106127049 -17.453292519943293 -12.497799345480361 -16.755160819145562 -10.85181407148364 -16.05702911834783 -9.142515169599843 -15.358897417550098 -7.379598339174763 -14.660765716752369 -5.573222578846884 -13.962634015954636 -3.7339214426263636 -13.264502315156905 -1.8725116943907831 -12.566370614359172 -1.101657837500442e-15 -11.868238913561441 -0.6277004905078336 -11.170107212763709 -1.2537727997595691 -10.471975511965978 -1.8766119257231557 -9.773843811168245 -2.4946591149389126 -9.075712110370514 -3.106424711355256 -8.377580409572781 -3.710510672308629 -7.679448708775049 -4.305632636279526 -6.981317007977317 -4.890641422122915 -6.283185307179585 -5.464543831801076 -5.585053606381853 -6.0265226171318655 -4.8869219055841215 -6.575955454274304 -4.18879020478639 -7.112432745810453 -3.490658503988658 -7.635774037145599 -2.7925268031909263 -8.146042788916667 -2.0943951023931944 -8.643559187159678 -1.3962634015954625 -9.12891059484894 -0.6981317007977306 -9.602959148757018 1.2328330586274658e-15 -10.066845881488542 0.6981317007977331 -10.521990598282846 1.396263401595465 -10.970086562383791 2.0943951023931966 -11.413088846119859 2.7925268031909285 -11.853194998361289 3.4906585039886604 -12.29281648297026 4.188790204786392 -12.73453918980746 4.886921905584124 -13.18107125741097 5.585053606381856 -13.63517653832043 6.283185307179588 -14.099592361494185 6.98131700797732 -14.57693088387646 7.679448708775052 -15.06956434602491 8.377580409572783 -15.579495988790363 9.075712110370516 -16.108220213754166 9.773843811168247 -16.656577642605562 10.47197551196598 -17.224612794032204 11.17010721276371 -17.811443788791905 11.868238913561443 -18.415154401498103 12.566370614359174 -19.032718535539434 13.264502315156907 -19.659965605381053 13.962634015954638 -20.2915924316587 14.66076571675237 -20.921223447155928 15.358897417550102 -21.54151686684141 16.057029118347835 -22.14431067199875 16.755160819145566 -22.72079938796538 17.453292519943297 -23.26173105522574 18.15142422074103 -23.75761356788059 18.849555921538762 -24.198920481628576 19.547687622336493 -24.57628810944981 20.245819323134224 -24.88069781405525 20.94395102393196 -25.103639509442914 21.64208272472969 -25.237254243497485 22.34021442552742 -25.274455212357463 23.038346126325152 -25.209027619377974 23.736477827122886 -25.03570847062377 24.434609527920614 -24.750247765728265 25.13274122871835 -24.349452679838574 25.13274122871835 -70 -25.13274122871834 -70}'
    set key             SeatStay_01
    set minorDiameter   $::bikeGeometry::SeatStay(DiameterST)                        
    set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
    set offset          [expr {0.5 * ($::bikeGeometry::SeatStay(SeatTubeMiterDiameter) - $::bikeGeometry::SeatStay(DiameterST))}]
        #
        # puts [format "%.3f" [dict get $baseDict TubeMiter   $key    miterAngle]] 
        # puts [format "%.3f" [get__ObjectValue SeatStay Scalar MiterAngleEnd]]
        #
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" [get__ObjectValue SeatStay Scalar MiterAngleEnd]]               
    dict set myDict     TubeMiter   $key    polygon_01          [list $::bikeGeometry::TubeMiter(SeatStay_01)]  
        #
    dict set myDict     TubeMiter   $key    minorName           SeatStay                         
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                             
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction SeatStay   degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           SeatTube(Lug)                     
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction SeatTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" $offset]
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {cylinder}  
        #
        # --- SeatStay_02
        #
    set key             SeatStay_02
        #
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" $::bikeGeometry::TubeMiter(SeatStay_Seat_Angle)]
    dict set myDict     TubeMiter   $key    polygon_01          [list $::bikeGeometry::TubeMiter(SeatStay_02)]  
        #
    dict set myDict     TubeMiter   $key    minorName           SeatStay                         
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                             
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction SeatStay   degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           SeatTube(Lug)                     
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction SeatTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" $offset]
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {cylinder}
        #
        # --- SeatTube_Down
        #
    set key             SeatTube_Down
    set minorDiameter   $::bikeGeometry::SeatTube(DiameterBB)                        
    set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        #
        # puts [format "%.3f" [dict get $baseDict TubeMiter   $key    miterAngle]]                   
        # puts [list [lrange [join [dict get $baseDict TubeMiter $key    polygon_02] " "] 0 end-4]]    
        # puts [list [lrange [join [dict get $baseDict TubeMiter $key    polygon_03] " "] 0 end-4]]    
        # 
        # puts [get__ObjectValue SeatTube Scalar MiterAngelEnd]
        # puts [list [lrange [join [get__ObjectValue SeatTube Polygon MiterEndBBInside] " "] 0 end-4]]
        # puts [list [lrange [join [get__ObjectValue SeatTube Polygon MiterEndBBOutside] " "] 0 end-4]]
        #
        # SeatTube_Down -> 
        #    miterAngle -> '59.97186433200594'
        #    polygon_01 -> '{-49.95132319207771 -10.964958404319953 -48.56378643674222 -10.936274143740572 -47.17624968140672 -10.850689303849716 -45.788712926071234 -10.709620518105089 -44.401176170735745 -10.515473386945995 -43.01363941540025 -10.27171608885745 -41.62610266006475 -9.982997207525655 -40.23856590472926 -9.655325509205438 -38.851029149393774 -9.296339190617859 -37.463492394058285 -8.915706114464836 -36.07595563872279 -8.525715650168479 -34.6884188833873 -8.142145247275067 -33.30088212805181 -7.785499666600026 -31.913345372716318 -7.48268887675585 -30.52580861738082 -7.269023962159696 -29.13827186204533 -7.189835316806905 -27.750735106709836 -7.299764772634242 -26.363198351374347 -7.656224169626725 -24.975661596038854 -8.304363190752573 -23.58812484070336 -9.258196000271225 -22.200588085367873 -10.491516460994998 -20.813051330032376 -11.94707570530313 -19.425514574696887 -13.555547578934656 -18.03797781936139 -15.250651481179135 -16.6504410640259 -16.975782372827915 -15.262904308690409 -18.68480445466875 -13.875367553354916 -20.340515356328005 -12.487830798019424 -21.91272855965523 -11.100294042683933 -23.37666918621449 -9.71275728734844 -24.711803242006123 -8.325220532012949 -25.901033790633953 -6.9376837766774555 -26.930165652302634 -5.550147021341965 -27.787555070903387 -4.162610266006473 -28.463883351791708 -2.7750735106709805 -28.952012626784196 -1.3875367553354885 -29.246895955557534 3.593790181151681e-15 -29.345523816775728 1.3875367553354956 -29.246895955557534 2.7750735106709876 -28.952012626784196 4.16261026600648 -28.463883351791708 5.550147021341972 -27.787555070903387 6.937683776677463 -26.930165652302634 8.325220532012956 -25.901033790633953 9.712757287348447 -24.711803242006123 11.10029404268394 -23.37666918621449 12.48783079801943 -21.91272855965523 13.87536755335492 -20.340515356328005 15.262904308690413 -18.684804454668743 16.65044106402591 -16.975782372827908 18.037977819361398 -15.250651481179132 19.425514574696887 -13.555547578934652 20.813051330032376 -11.947075705303126 22.200588085367873 -10.49151646099499 23.58812484070336 -9.258196000271218 24.975661596038854 -8.304363190752566 26.363198351374347 -7.656224169626718 27.750735106709836 -7.2997647726342345 29.13827186204533 -7.189835316806898 30.52580861738082 -7.269023962159689 31.913345372716318 -7.482688876755843 33.30088212805181 -7.785499666600017 34.6884188833873 -8.14214524727506 36.07595563872279 -8.525715650168472 37.463492394058285 -8.915706114464825 38.851029149393774 -9.296339190617848 40.23856590472926 -9.655325509205428 41.62610266006475 -9.982997207525644 43.01363941540025 -10.27171608885744 44.401176170735745 -10.515473386945985 45.788712926071234 -10.709620518105078 47.17624968140672 -10.850689303849705 48.56378643674222 -10.936274143740562 49.95132319207771 -10.964958404319942 49.95132319207771 -70 -49.95132319207771 -70}'
        #    polygon_02 -> '{-49.95132319207771 -8.437416666255146 -48.56378643674222 -8.550460571249474 -47.17624968140672 -8.877677301499382 -45.788712926071234 -9.387494811430155 -44.401176170735745 -10.038085084693481 -43.01363941540025 -10.786261270596642 -41.62610266006475 -11.592777924207818 -40.23856590472926 -12.42424821801782 -38.851029149393774 -13.253112921197488 -37.463492394058285 -14.056848864521529 -36.07595563872279 -14.817050917709247 -34.6884188833873 -15.518635771777147 -33.30088212805181 -16.14922598764412 -31.913345372716314 -16.69869958417203 -30.525808617380818 -17.158870820437297 -29.138271862045325 -17.523268563980068 -27.750735106709833 -17.78698529066809 -26.363198351374344 -17.946576944350927 -24.97566159603885 -18.000000000000004 -23.588124840703358 -17.946576944350927 -22.20058808536787 -17.78698529066809 -20.813051330032373 -17.523268563980068 -19.425514574696884 -17.158870820437297 -18.03797781936139 -16.69869958417203 -16.6504410640259 -16.14922598764412 -15.262904308690409 -15.518635771777145 -13.875367553354916 -14.817050917709246 -12.487830798019425 -14.056848864521525 -11.100294042683934 -13.253112921197484 -9.712757287348442 -12.424248218017816 -8.32522053201295 -11.592777924207814 -6.937683776677458 -10.786261270596636 -5.550147021341967 -10.038085084693476 -4.162610266006475 -9.38749481143015 -2.775073510670983 -8.877677301499377 -1.387536755335491 -8.550460571249468 1.033285531340189e-15 -8.43741666625514 1.3875367553354931 -8.550460571249468 2.775073510670985 -8.877677301499377 4.162610266006477 -9.38749481143015 5.550147021341969 -10.038085084693472 6.93768377667746 -10.786261270596635 8.325220532012954 -11.592777924207809 9.712757287348445 -12.424248218017809 11.100294042683938 -13.25311292119748 12.487830798019429 -14.05684886452152 13.87536755335492 -14.817050917709238 15.262904308690413 -15.518635771777138 16.65044106402591 -16.14922598764411 18.037977819361398 -16.698699584172022 19.42551457469689 -17.15887082043729 20.81305133003238 -17.52326856398006 22.200588085367876 -17.78698529066808 23.588124840703365 -17.94657694435092 24.975661596038858 -17.999999999999996 26.36319835137435 -17.94657694435092 27.75073510670984 -17.78698529066808 29.138271862045332 -17.523268563980064 30.525808617380825 -17.15887082043729 31.91334537271632 -16.698699584172022 33.30088212805181 -16.149225987644108 34.6884188833873 -15.518635771777141 36.07595563872279 -14.81705091770924 37.463492394058285 -14.056848864521518 38.851029149393774 -13.253112921197479 40.23856590472926 -12.424248218017812 41.62610266006475 -11.59277792420781 43.01363941540025 -10.786261270596636 44.401176170735745 -10.038085084693474 45.788712926071234 -9.387494811430145 47.17624968140672 -8.877677301499372 48.56378643674222 -8.550460571249463 49.95132319207771 -8.437416666255135 49.95132319207771 -70 -49.95132319207771 -70}'
        #    polygon_03 -> '{-49.95132319207771 -12.132188590687178 -48.56378643674222 -12.211075955070132 -47.17624968140672 -12.4423934301065 -45.788712926071234 -12.81113027155013 -44.401176170735745 -13.295230429275973 -43.01363941540025 -13.868793465820058 -41.62610266006475 -14.504912960786775 -40.23856590472926 -15.177679130318937 -38.851029149393774 -15.863322542960912 -37.463492394058285 -16.540707360932306 -36.07595563872279 -17.19142221859461 -34.6884188833873 -17.799664497317956 -33.30088212805181 -18.352043482947618 -31.913345372716314 -18.8373715736147 -30.525808617380818 -19.246476244561094 -29.138271862045325 -19.57204488972402 -27.750735106709833 -19.808504378938935 -26.363198351374344 -19.951932839189 -24.97566159603885 -20.000000000000004 -23.588124840703358 -19.951932839189 -22.20058808536787 -19.808504378938935 -20.813051330032373 -19.57204488972402 -19.425514574696884 -19.246476244561094 -18.03797781936139 -18.8373715736147 -16.6504410640259 -18.352043482947618 -15.262904308690409 -17.799664497317956 -13.875367553354916 -17.191422218594607 -12.487830798019425 -16.540707360932302 -11.100294042683934 -15.863322542960908 -9.712757287348442 -15.177679130318934 -8.32522053201295 -14.504912960786772 -6.937683776677457 -13.868793465820053 -5.550147021341966 -13.295230429275968 -4.1626102660064745 -12.811130271550125 -2.7750735106709827 -12.442393430106495 -1.3875367553354905 -12.211075955070127 1.4857645924237085e-15 -12.132188590687173 1.3875367553354936 -12.211075955070127 2.7750735106709854 -12.442393430106495 4.162610266006478 -12.811130271550125 5.55014702134197 -13.295230429275966 6.937683776677461 -13.868793465820051 8.325220532012954 -14.504912960786767 9.712757287348445 -15.177679130318927 11.100294042683938 -15.863322542960905 12.487830798019429 -16.5407073609323 13.87536755335492 -17.191422218594607 15.262904308690413 -17.799664497317945 16.65044106402591 -18.35204348294761 18.037977819361398 -18.837371573614693 19.42551457469689 -19.246476244561087 20.81305133003238 -19.572044889724012 22.200588085367876 -19.808504378938927 23.588124840703365 -19.951932839188988 24.975661596038858 -19.999999999999996 26.36319835137435 -19.95193283918899 27.75073510670984 -19.808504378938927 29.138271862045332 -19.572044889724015 30.525808617380825 -19.246476244561087 31.91334537271632 -18.837371573614693 33.30088212805181 -18.35204348294761 34.6884188833873 -17.799664497317952 36.07595563872279 -17.191422218594603 37.463492394058285 -16.5407073609323 38.851029149393774 -15.863322542960903 40.23856590472926 -15.177679130318928 41.62610266006475 -14.504912960786767 43.01363941540025 -13.868793465820051 44.401176170735745 -13.295230429275964 45.788712926071234 -12.81113027155012 47.17624968140672 -12.44239343010649 48.56378643674222 -12.211075955070122 49.95132319207771 -12.132188590687168 49.95132319207771 -70 -49.95132319207771 -70}'
        #
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" [get__ObjectValue SeatTube Scalar MiterAngelEnd]]               
    dict set myDict     TubeMiter   $key    polygon_01          [list [join [get__ObjectValue SeatTube Polygon MiterEnd] " "]]
    dict set myDict     TubeMiter   $key    polygon_02          [list [lrange [join [get__ObjectValue SeatTube Polygon MiterEndBBInside]  " "] 0 end-4]]
    dict set myDict     TubeMiter   $key    polygon_03          [list [lrange [join [get__ObjectValue SeatTube Polygon MiterEndBBOutside] " "] 0 end-4]]
        #
    dict set myDict     TubeMiter   $key    minorName           SeatTube                         
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                            
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction SeatTube   degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           DownTube                     
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::DownTube(DiameterBB) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction DownTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" 0]
    dict set myDict     TubeMiter   $key    diameter_02         $::bikeGeometry::BottomBracket(InsideDiameter)   
    dict set myDict     TubeMiter   $key    diameter_03         $::bikeGeometry::BottomBracket(OutsideDiameter)
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {cylinder}  
        #
        # --- TopTube_Head
        #
    set key             TopTube_Head
    set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
    set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        #
        # puts [format "%.3f" [dict get $baseDict TubeMiter   $key    miterAngle]]                   
        # 
        # puts [format "%.3f" [get__ObjectValue TopTube Scalar MiterAngleOrigin]]
        #
        #TopTube_Head  -> 
        #    miterAngle -> '74.99999999999999'
        #    polygon_01 -> '{-44.92477494633405 -14.803297795616444 -43.6768645311581 -14.773154610028703 -42.42895411598216 -14.683334243723467 -41.181043700806214 -14.535675528718675 -39.93313328563026 -14.333281399461436 -38.68522287045432 -14.080578517547849 -37.437312455278374 -13.783405031651778 -36.18940204010243 -13.449129777877404 -34.941491624926485 -13.086805095740822 -33.69358120975053 -12.707351354871555 -32.44567079457459 -12.323761670616115 -31.19776037939864 -11.95129610598253 -29.949849964222697 -11.607600792367567 -28.701939549046752 -11.312635256253214 -27.454029133870804 -11.08822644132934 -26.20611871869486 -10.957020136000153 -24.958208303518916 -10.940638266660253 -23.710297888342968 -11.057065493511427 -22.462387473167023 -11.317704358648621 -21.21447705799108 -11.72497018482156 -19.96656664281513 -12.27136449128777 -18.718656227639187 -12.940440263861175 -17.470745812463242 -13.70924544762903 -16.22283539728729 -14.551305603739083 -14.974924982111347 -15.439274244132625 -13.7270145669354 -16.346811313431154 -12.479104151759456 -17.249666108934978 -11.23119373658351 -18.12615591694263 -9.983283321407564 -18.957269406883093 -8.73537290623162 -19.72657605999981 -7.4874624910556715 -20.42005812812167 -6.239552075879726 -21.02592949098039 -4.99164166070378 -21.53447193523122 -3.7437312455278344 -21.937900218650768 -2.4958208303518887 -22.230257688342018 -1.247910415175943 -22.407340164963195 2.751370451839068e-15 -22.466644699146556 1.2479104151759484 -22.407340164963195 2.495820830351894 -22.230257688342018 3.7437312455278398 -21.937900218650768 4.9916416607037855 -21.53447193523122 6.239552075879732 -21.02592949098039 7.487462491055677 -20.42005812812167 8.735372906231623 -19.72657605999981 9.983283321407567 -18.957269406883093 11.231193736583513 -18.12615591694263 12.47910415175946 -17.249666108934978 13.727014566935404 -16.346811313431154 14.97492498211135 -15.439274244132621 16.222835397287298 -14.55130560373908 17.470745812463242 -13.709245447629026 18.718656227639187 -12.940440263861172 19.96656664281513 -12.271364491287766 21.21447705799108 -11.724970184821556 22.462387473167023 -11.317704358648614 23.710297888342968 -11.05706549351142 24.958208303518916 -10.940638266660246 26.20611871869486 -10.957020136000146 27.454029133870804 -11.088226441329333 28.701939549046752 -11.312635256253207 29.949849964222697 -11.60760079236756 31.19776037939864 -11.951296105982523 32.44567079457459 -12.323761670616108 33.69358120975053 -12.707351354871548 34.941491624926485 -13.086805095740814 36.18940204010243 -13.449129777877397 37.437312455278374 -13.783405031651768 38.68522287045432 -14.080578517547838 39.93313328563026 -14.333281399461425 41.181043700806214 -14.535675528718665 42.42895411598216 -14.683334243723456 43.6768645311581 -14.773154610028692 44.92477494633405 -14.803297795616434 44.92477494633405 -70 -44.92477494633405 -70}'
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" [get__ObjectValue TopTube Scalar MiterAngleOrigin]]               
    dict set myDict     TubeMiter   $key    polygon_01          [list [join [get__ObjectValue TopTube Polygon MiterOrigin]  " "]]
        #
    dict set myDict     TubeMiter   $key    minorName           TopTube                          
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                             
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction TopTube    degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           HeadTube                          
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::HeadTube(Diameter) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction HeadTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" 0]
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {cylinder}  
        #
        # --- TopTube_Seat
        #
    set key             TopTube_Seat
    set minorDiameter   $::bikeGeometry::TopTube(DiameterHT)                        
    set minorPerimeter  [expr {$minorDiameter * $vectormath::CONST_PI}]                        
        #
        #puts [format "%.3f" [dict get $baseDict TubeMiter   $key    miterAngle]]                   
        # 
        #puts [format "%.3f" [get__ObjectValue TopTube Scalar MiterAngleEnd]]
        #
        #TopTube_Seat  -> 
        #    miterAngle -> '104.00014678227389'
        #    polygon_01 -> '{-44.92477494633405 -18.303213665573857 -43.6768645311581 -18.23356441168506 -42.42895411598216 -18.025146722896128 -41.181043700806214 -17.67954678366479 -39.93313328563026 -17.199394818207548 -38.68522287045432 -16.58834507290521 -37.437312455278374 -15.851048005281456 -36.18940204010243 -14.993114891213033 -34.941491624926485 -14.021075119732192 -33.69358120975053 -12.942326500433559 -32.44567079457459 -11.765078961676224 -31.19776037939864 -10.498292068071615 -29.949849964222697 -9.151606832786927 -28.701939549046752 -7.7352723436134365 -27.454029133870804 -6.26006776121991 -26.20611871869486 -4.737220283231231 -24.958208303518916 -3.178319698475365 -23.710297888342968 -1.5952301816921763 -22.462387473167023 -2.5325295098309284e-15 -21.21447705799108 -0.9737348948720714 -19.96656664281513 -1.9400590792369707 -18.718656227639187 -2.8916182425691552 -17.470745812463242 -3.821170445068578 -16.222835397287295 -4.721641233195215 -14.974924982111348 -5.586177480532317 -13.727014566935402 -6.408199544216384 -12.479104151759458 -7.181451339992288 -11.23119373658351 -7.9000479547919715 -9.983283321407564 -8.558520434476312 -8.73537290623162 -9.151857405878356 -7.487462491055673 -9.675543216379076 -6.239552075879728 -10.125592300750423 -4.991641660703782 -10.49857951371327 -3.7437312455278358 -10.791666197361128 -2.49582083035189 -11.002621785060857 -1.2479104151759444 -11.129840777411598 1.3682188742005855e-15 -11.172354961064633 1.247910415175947 -11.129840777411598 2.4958208303518927 -11.002621785060857 3.7437312455278384 -10.791666197361128 4.991641660703784 -10.49857951371327 6.23955207587973 -10.125592300750423 7.487462491055675 -9.675543216379072 8.735372906231623 -9.151857405878353 9.983283321407567 -8.558520434476309 11.231193736583513 -7.900047954791968 12.479104151759458 -7.181451339992284 13.727014566935402 -6.40819954421638 14.974924982111348 -5.586177480532314 16.222835397287295 -4.721641233195212 17.470745812463242 -3.8211704450685735 18.718656227639187 -2.891618242569151 19.96656664281513 -1.9400590792369659 21.21447705799108 -0.9737348948720663 22.462387473167023 2.9691686742133916e-15 23.710297888342968 -1.5952301816921706 24.958208303518916 -3.178319698475359 26.20611871869486 -4.737220283231224 27.454029133870804 -6.2600677612199025 28.701939549046752 -7.735272343613429 29.949849964222697 -9.15160683278692 31.19776037939864 -10.498292068071608 32.44567079457459 -11.765078961676217 33.69358120975053 -12.942326500433552 34.941491624926485 -14.021075119732185 36.18940204010243 -14.993114891213025 37.437312455278374 -15.851048005281445 38.68522287045432 -16.588345072905202 39.93313328563026 -17.19939481820754 41.181043700806214 -17.679546783664783 42.42895411598216 -18.02514672289612 43.6768645311581 -18.233564411685045 44.92477494633405 -18.303213665573843 44.92477494633405 -70 -44.92477494633405 -70}'
    dict set myDict     TubeMiter   $key    miterAngle          [format "%.3f" [get__ObjectValue TopTube Scalar MiterAngleEnd]]               
    dict set myDict     TubeMiter   $key    polygon_01          [list [join [get__ObjectValue TopTube Polygon MiterEnd] " "]]
        #
    dict set myDict     TubeMiter   $key    minorName           TopTube                          
    dict set myDict     TubeMiter   $key    minorDiameter       $minorDiameter                             
    dict set myDict     TubeMiter   $key    minorDirection      [bikeGeometry::get_Direction TopTube    degree]                        
    dict set myDict     TubeMiter   $key    minorPerimeter      $minorPerimeter                        
    dict set myDict     TubeMiter   $key    majorName           SeatTube                         
    dict set myDict     TubeMiter   $key    majorDiameter       $::bikeGeometry::SeatTube(DiameterTT) 
    dict set myDict     TubeMiter   $key    majorDirection      [bikeGeometry::get_Direction SeatTube   degree]
    dict set myDict     TubeMiter   $key    offset              [format "%.3f" 0]
    dict set myDict     TubeMiter   $key    tubeType            {cylinder}  
    dict set myDict     TubeMiter   $key    toolType            {cylinder}  
        #

        #
    return $myDict
        #
}
    #
proc bikeModel::update_resultModelDocument {{type update}} {
        #
    puts "\n    ---- update_resultModelDocument [namespace current] -- $type --\n"
        # -- get_namespaceXML
    variable dataStructureDoc
    variable resultModelDoc
        # 
    set resultModelDoc  [dom parse [$dataStructureDoc asXML]]
    set myRoot          [$resultModelDoc documentElement]
        #
    foreach typeNode [$myRoot selectNodes */*] {
        foreach node [$typeNode childNodes] {
                # puts "[$node nodeType] [$node toXPath]" 
            switch -exact [$node nodeType] {
                COMMENT_NODE {
                        # puts "   ... comment "
                    $typeNode removeChild $node
                    $node delete
                    continue
                }
                ELEMENT_NODE {
                    # puts [$node asXML]
                    set textNode [$node selectNodes text()]
                    if {$textNode != {}} {
                            #puts [$textNode asXML]
                        $node removeChild $textNode
                        $textNode delete
                    }
                }
            }
                #
            foreach attr [$node attributes] {
                $node removeAttribute  $attr
            }
                #
        }
    }
        #
    if {$type ne {update}} {
        return
    }
        #
    foreach node [$myRoot selectNodes */*/*] {
        set modelXPath  [$node toXPath]
        set modelPath   [string map {/root/ {}} $modelXPath]            
            # puts "$modelPath"
        lassign [split $modelPath /] objectName typeName keyName
            # foreach {objectName typeName keyName} [split $modelPath /] break
            # puts "   $objectName $typeName $keyName"
        set myObject [get__Object $objectName]
        set myValue  [$myObject getValue $typeName $keyName]
            # puts "      $myValue"
            #
        set textNode [$resultModelDoc createTextNode $myValue]
        $node appendChild $textNode
    }      
        #
}
    #
proc bikeModel::update_inputModelDocument {} {
        #
    puts "\n    ---- update_inputModelDocument [namespace current] ----\n"
        # -- get_namespaceXML
    variable dataStructureDoc
    variable inputModelDoc
        # 
    set inputModelDoc   [dom parse [$dataStructureDoc asXML]]
    set myRoot          [$inputModelDoc documentElement]
        #
    foreach objectNode [$myRoot childNodes] {
        if {[$objectNode nodeType] eq "COMMENT_NODE"} {
            $myRoot removeChild $objectNode
            $objectNode delete
            continue
        }
        foreach typeNode [$objectNode childNodes] {
            if {[$typeNode nodeType] eq "COMMENT_NODE"} {
                $objectNode removeChild $typeNode
                $typeNode delete
                continue
            }
            foreach paramNode [$typeNode childNodes] {
                if {[$paramNode nodeType] eq "COMMENT_NODE"} {
                    $typeNode removeChild $paramNode
                    $paramNode delete
                    continue
                }
            }
        }
    }
        #
    foreach typeNode [$myRoot selectNodes */*] {
            #
        set parentNode [$typeNode parentNode]
            # puts "-- [$parentNode nodeName] -> [$typeNode nodeName] ([$typeNode nodeType]) --"
            #
        switch -exact [$typeNode nodeType] {
            ELEMENT_NODE {
                foreach node [$typeNode childNodes] {
                        #
                    # puts "[$node asXML]"    
                        #
                    switch -exact [$node nodeType] {
                        ELEMENT_NODE { 
                            set initMode [$node getAttribute init]
                            if $initMode {
                                foreach attr [$node attributes] {
                                    switch -exact $attr {
                                        init    {continue}
                                        default {
                                            $node removeAttribute  $attr                
                                        }
                                    }
                                }
                                set textNode [$node selectNodes text()]
                                if {$textNode != {}} {
                                        #puts [$textNode asXML]
                                    $node removeChild $textNode
                                    $textNode delete
                                }
                            } else {
                                $typeNode removeChild $node
                                $node delete 
                            }
                        }
                        default {
                                # puts "   ... comment "
                            $typeNode removeChild $node
                            $node delete
                            continue
                        }
                    }
                }
            }
            default {
                set parentNode [$typeNode parentNode]
                $parentNode removeChild $typeNode
                $typeNode delete
            }
        }
            #
        if ![$typeNode hasChildNodes] {
            set parentNode [$typeNode parentNode]
            $parentNode removeChild $typeNode
            $typeNode delete
        }
    }
    foreach objectNode [$myRoot childNodes] {
        if ![$objectNode hasChildNodes] {
            $myRoot removeChild $objectNode
            $objectNode delete
        }
    }
        #
    return
        #
    puts [$inputModelDoc asXML]   
        #
    exit    
        #
}
    #
    # --- interface -------------------------------
    #
    #
    #
proc bikeModel::report_Namespace {} {
        #
    variable compFactory
    $compFactory report_Object
        #
    return
        #
        
        #
    set list_varName [lsort [info vars [namespace current]::*]]
    # set list_varName [concat [lsort [info vars [namespace current]::init_*]] [lsort [info vars [namespace current]::model_*]]]
    foreach varName $list_varName {
        set objectVar   [set $varName]
            # puts "        ... $varName -> $objectVar -> [info object isa object $objectVar]"
        puts "\n\n === $varName ==========================="
        if [info object isa object $objectVar] {
            # puts "                ... is an object"
            $objectVar reportValues                
        }
        puts ""
        puts "     --- methods:   [info object methods    $objectVar  -all]"
        puts "     --- variables: [info object vars       $objectVar]"
        # puts "            [info object variables    $objectVar]"
        # puts "            ... [info object variables $varName]"
        
    }
    variable compFactory
}
    #
    #
    #
