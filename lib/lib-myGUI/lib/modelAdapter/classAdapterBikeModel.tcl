 ##+##########################################################################
 #
 # package: bikeModel    ->    classAdapterBikeModel.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/19
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
 #    namespace:  myGUI::model
 # ---------------------------------------------------------------------------
 #
 # http://www.magicsplat.com/articles/oo.html
 #
 #
 # 0.00 - 20160417
 #      ... new: rattleCAD - 3.4.03
 #
 #
 #

# puts "$auto_path"
# lappend auto_path           [file join $APPL_Env(BASE_Dir) lib]

package require bikeModel 0.02

        #
oo::class create myGUI::modelAdapter::AdapterBikeModel {
        #
    superclass myGUI::modelAdapter::_AdapterModel
        #
        # variable _parentObject
        # variable bikeModel
    variable modelDOM
    variable persistenceDOM
        #
    constructor {} {
        puts "              -> class AdapterBikeModel"
            #
        variable modelDOM           {}
            #
        variable mappingObject      [myGUI::modelAdapter::BikeModelMapping new]
        variable projectMapping     [myPersist::ModelMapping new]
            #
            #
        bikeModel::init    
            #
        set return_IF   [my set_geometryIF {}]
            #
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... myGUI::modelAdapter::AdapterBikeModel  $target_method $args  ... unknown"
    }
        #
    method _initParameter {} {
            #
            #
    }
        #
    method initDomainParameters {} {
            #
        variable modelDOM
            #
            # set modelDOM [bikeGeometry::get_domainParameters xmlStructure]
            # puts [$modelDOM asXML]
        set modelDOM [bikeModel::init_dataStructure]
            # set modelDOM [bikeModel::get_initDataStructure]
            # puts [$modelDOM asXML]

            #
    }
        #
        #
    method set_geometryIF {{interfaceName ""}} {
            #
            # puts "    -> $geometryIF  <- $interfaceName"    
            #
        set lastIF_Name [my get_geometryIF]
        puts "  -> $lastIF_Name"
            #
        set return_IF  [bikeModel::set_geometryIF $interfaceName]
        foreach {new_Name new_IF} $return_IF break
            #
        if {$lastIF_Name != $new_Name} {
            return $new_Name
        } else {
            return $lastIF_Name
        }
    }
        #
    method get_geometryIF {} {
        return [bikeModel::get_geometryIF]
    }
        #
        #
    method add_ComponentDir {key dir} {
        return [bikeModel::add_ComponentDir $key $dir]
    }
        #
    method get_ComponentDir {} {
        return [bikeModel::get_ComponentBaseDirectory]
    }            
        #
    method get_ComponentAlternatives {xPath} {
        set key [file tail $xPath]
        return [bikeModel::get_componentAlternatives $key]
    }
        #
    method get_ComponentDirectories {} {
        return [bikeModel::get_ComponentDirectories]
    }            
        #
    method get_ComponentBaseDirectory {} {
        return [bikeModel::get_ComponentBaseDirectory]
    }            
        #
    method get_ComponentSubDirectories {} {
        return [bikeModel::get_ComponentSubDirectories]
    }            
        #
    method get_ComponentPath {objType key} {
        return [bikeModel::get_componentPath $objType $key]
    }
        #
        #
    method get_ListBoxValues {} {
        return [bikeModel::get_ListBoxValues]
    }
        #
    method get_DebugGeometry {} {
        return [bikeModel::get_DebugGeometry]
    }
        #
    method validate_ChainStayCenterLine {dict_ChainStay} {
        variable geometryIF
        return [$geometryIF validate_ChainStayCenterLine $dict_ChainStay]
    }            
        #
    method import_ProjectSubset {nodeRoot} {
        variable geometryIF
        return [$geometryIF import_ProjectSubset $nodeRoot]
    }            
        #
        #
        #
    method set_Value {key value} {
        variable mappingObject
        set modelKey      [$mappingObject get_Mapping inv_gui $key]
        if {$modelKey ne {}} {
            set retValue [bikeModel::set_Value $modelKey $value]
            return $retValue
        } else {
            tk_messageBox -message "[info object class [self object]] - set_Value: $key ... not registered"
        }
    }
        #
        #
        #
    method set_Config {key value} {
        set retValue [bikeModel::set_Config $key $value]
        return $retValue
    }
        #
    method set_Component {key value} {
        set retValue [bikeModel::set_Component $key $value]
        return $retValue
    }
        #
    method set_ListValue {key value} {
        set retValue [bikeModel::set_ListValue $key $value]
        return $retValue
    }
        #
    method set_Scalar {object key value} {
        set retValue [bikeModel::set_Scalar $object $key $value]
        return $retValue
    }
        #
    method set_ValueList {keyValueList} {
            #
        variable mappingObject
            #
        set newList {}
        foreach {key value} $keyValueList {
            set modelKey      [$mappingObject get_Mapping inv_gui $key]
                # puts "    $key  <-> $modelKey"
            if {$modelKey ne {}} {
                lappend newList $modelKey $value
            } else {
                tk_messageBox -message "[info object class [self object]] - set_Value: $key ... not registered"
            }
        }
        bikeModel::set_ValueList $newList
            #
        set retList {}
        foreach {key value} $keyValueList {
            set modelKey    [$mappingObject get_Mapping inv_gui $key]
            set value       [bikeModel::get_Value $modelKey]
            lappend retList $key $value
                # puts "    $key  <-> $modelKey"
        }
            #
        return $retList
            #
    }
        #
    method update {} {
            #
    }
        #
    method reportValues {} {
            #
        puts ""
        puts "  ---- [info object class [self object]] -------- reportValues ---------------- "
        foreach varName [lsort [info object vars [self object]]] {
            set qualifiedVarName [self object]::$varName
                # puts "     -> $qualifiedVarName [array exists $qualifiedVarName]"
            if {[ array exists $qualifiedVarName ]} {
                puts     "[format {%20s %25s ---- array  ----} {} $qualifiedVarName]"
                foreach key [lsort [array names $qualifiedVarName]] {
                    puts "[format {%20s %25s ... %s}  {}  $key  [lindex [array get $qualifiedVarName $key] 1]]"
                }
                if {[array size $qualifiedVarName] == 0} {
                    puts "[format {%20s %25s ...}  {} {empty}]"
                }
            } else {
                    # puts "[info vars $qualifiedVarName]"
                    puts "[format {%15s %25s ... %s}  {}  $varName  [set $qualifiedVarName]]"
            }
        }
            #  
    }
        #
    method getModelDictionary {} {
            #
            # puts "  -- [info object class [self object]] -- getModelDictionary --"
            #
        return [bikeModel::get_resultModelDictionary]
            # return [bikeModel::get_modelDictionary]
    }
        #
    method getGUIDictionary {} {
            #
            # puts "  -- [info object class [self object]] -- getGUIDictionary --"
            #
        variable mappingObject
            #
        set bikeModelDoc    [bikeModel::get_resultModelDocument]
        set tubeMiterDict   [bikeModel::get_resultMiterDictionary]
            # set tubeMiterDict   [bikeModel::get_resultTubeMiterDictionary]
            #
        set guiDict         [$mappingObject get_GUIDictionary $bikeModelDoc]
            #
            # appUtil::pdict $guiDict
            # appUtil::pdict $tubeMiterDict
            #
        set myDict          [dict get $tubeMiterDict TubeMiter]
            #
        foreach key [dict keys $myDict] {
            set keyDict [dict get $myDict $key]
            # appUtil::pdict $keyDict
            dict set guiDict TubeMiter $key $keyDict
        }
            #
            # appUtil::pdict $guiDict
            #
        return $guiDict
            #
    }
        #
    method readProjectDoc {projectDoc} {
            #
        puts "  -- [info object class [self object]] -- readProjectDoc --"
            #
        variable projectMapping
            #
            # puts [$projectDoc asXML]
        set bikeModelDoc [bikeModel::get_inputModelDocument]
            # puts [$bikeModelDoc asXML]
            #
        $projectMapping update_bikeModel_InputDoc $projectDoc $bikeModelDoc
            #
            # puts [$bikeModelDoc asXML]
            #
        return [bikeModel::read_inputModelDocument $bikeModelDoc]
            #
    }
        #
    method getProjectDoc {} {
            #
        puts "  -- [info object class [self object]] -- getProjectDoc --"
            #
        variable projectMapping
            #
            # puts [$projectDoc asXML]
        set bikeModelDoc [bikeModel::get_resultModelDocument]
            # puts [$bikeModelDoc asXML]
            #
        set projectDoc [$projectMapping get_PersistDoc $bikeModelDoc]
            #
            # puts " -- getProjectDoc: end --"
            # puts [$projectDoc asXML]
            #
        return $projectDoc
            #
    }
        #
}