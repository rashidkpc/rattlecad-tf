 ##+##########################################################################
 #
 # package: bikeModel    ->    classModelContext.tcl
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


oo::class create myGUI::modelAdapter::ModelContext {
        #
    variable _parentObject
    variable _contextObject
        #
    constructor {} {
        puts "              -> class ModelContext"
        catch {variable _parentObject  [lindex [self caller] 1]}
        # variable _arrayResult;  array set _arrayResult {}
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... myGUI::modelAdapter::ModelContext  $target_method $args  ... unknown"
    }
        #
    method setModelStrategy {strategyObject} {
        variable _contextObject
        set _contextObject $strategyObject
    }
        #
        #
    method add_ComponentDir {key dir} {
        variable _contextObject
        return [$_contextObject add_ComponentDir $key $dir]
    }
        #
    method get_ComponentDir {} {
        variable _contextObject
        return [$_contextObject get_ComponentBaseDirectory]
    }
        #
    method get_ComponentDirectories {} {
        variable _contextObject
        return [$_contextObject get_ComponentDirectories]
    }
        #
    method get_ComponentBaseDirectory {} {
        variable _contextObject
        return [$_contextObject get_ComponentBaseDirectory]
    }
        #
    method get_ComponentSubDirectories {} {
        variable _contextObject
        return [$_contextObject get_ComponentSubDirectories]
    }
        #
    method get_componentAlternatives {xPath} {
        variable _contextObject
        return [$_contextObject get_ComponentAlternatives $xPath]
    }
        #
    method get_ComponentPath {key value} {
        variable _contextObject
        return [$_contextObject get_ComponentPath $key $value]
    }
        #
    method get_ListBoxValues {} {
        variable _contextObject
        return [$_contextObject get_ListBoxValues]
    }
        #
    method get_DebugGeometry {} {
        variable _contextObject
        return [$_contextObject get_DebugGeometry]
    }
        #
    method validate_ChainStayCenterLine {dict_ChainStay} {
        variable _contextObject
        return [$_contextObject validate_ChainStayCenterLine $dict_ChainStay]
    }
        #
    method import_ProjectSubset {nodeRoot} {
        variable _contextObject
        return [$_contextObject import_ProjectSubset $nodeRoot]
    }   
        #
        #
    method initDomainParameters {} {
        variable _contextObject
        $_contextObject initDomainParameters
    }
        #
        #
    method set_geometryIF {interfaceName} {
        variable _contextObject
        return [$_contextObject set_geometryIF $interfaceName]
    }
        #
    method get_geometryIF {} {
        variable _contextObject
        return [$_contextObject get_geometryIF]
    }
        #
        #
    method set_Value {key value} {
        variable _contextObject
        return [$_contextObject set_Value $key $value]
    }
        #
        #
    method set_Config {key value} {
        variable _contextObject
        return [$_contextObject set_Config $key $value]
    }
        #
    method set_Component {key value} {
        variable _contextObject
        return [$_contextObject set_Component $key $value]
    }
        #
    method set_ListValue {key value} {
        variable _contextObject
        return [$_contextObject set_ListValue $key $value]
    }
        #
    method set_Scalar {object key value} {
        variable _contextObject
        return [$_contextObject set_Scalar $object $key $value]
    }
        #
    method set_ValueList {keyValueList} {
        variable _contextObject
        return [$_contextObject set_ValueList $keyValueList]
    }
        #
        #
    method getModelDictionary {} {
        variable _contextObject
        return [$_contextObject getModelDictionary]
    }
    method getGUIDictionary {} {
        variable _contextObject
        return [$_contextObject getGUIDictionary]
    }
        #
        #
        #
    method readProjectDoc {projectDoc} {
        variable _contextObject
        return [$_contextObject readProjectDoc $projectDoc]
    }
        #
    method getProjectDoc {} {
        variable _contextObject
        return [$_contextObject getProjectDoc]
    }
        #
        #
        #
        #
    method ___updateProjectValues {persistDOM} {
            # update $_contextObject 
        variable _contextObject
        $_contextObject updateProjectValues $persistDOM
    }
        #
    method ___getPersistenceDOM {} {
        variable _contextObject
        return [$_contextObject getPersistenceDOM]
    }    
        #
    method ___remove__updatePersistenceDOM__ {} {
        variable _contextObject
        return [$_contextObject updatePersistenceDOM]
    }
        #
}