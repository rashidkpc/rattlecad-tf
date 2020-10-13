#!/bin/sh
# lib_dict.tcl \
exec tclsh "$0" ${1+"$@"}


    #-------------------------------------------------------------------------
        #
    proc appUtil::namespaceReport {{_namespace {}} {_format {domNode}}} {
            #
        set xml "<root/>"
        set domDOC  [dom parse $xml]
        set domNode [$domDOC documentElement]      
            #
        if {$_namespace == {}} {
           set _namespace {::}
        }
            #
        _add_namespaceReport $domNode $_namespace
            #
        switch -exact $_format {
            asText {    set retValue [$domNode asText]}
            asXML {     set retValue [$domNode asXML]}
            domNode -
            default {   set retValue $domNode}
        }
            #
            # set fd [open [file join $::APPL_Config(USER_Dir) log_appUtil_namespaceReport.txt] w]      
            # puts $fd "$retValue"
            # close $fd
            #
        return $retValue
            #
    }
    #-------------------------------------------------------------------------
        #
    proc appUtil::_add_namespaceReport {domNode namespaceName} {
            #
        set domDOC [$domNode ownerDocument]
            #
        set namespaceList   [namespace children $namespaceName]
            # puts "    $namespaceName  -> $namespaceList"
        foreach _element [lsort $namespaceList] {
            set childNamespace_Name [string map [list $namespaceName {}] $_element]
            set _nodeName   [string map [list {::} {}] $childNamespace_Name]
            set _nodeName   [check_nodeName $_nodeName]
                # puts "         -> $_nodeName"
                # puts "         -> $childNamespace_Name"
            if {[catch {set _node [$domDOC createElement $_nodeName]} err]} {
                puts "          ... $err"
                return
            } else {
                $domNode appendChild $_node
                    # -- add next Level
                _add_namespaceReport $_node $_element
                    # change: 0.16: _add_namespaceReport $_node $_element
            }
        }
            # -- add content of current Level
        _add_namespaceContent $domNode $namespaceName
            #
        return
            #
    }
        #
    proc appUtil::_add_namespaceContent {domNode namespaceName} {
        
        set domDOC [$domNode ownerDocument]
        
        catch {
            set className       [info object class          $namespaceName]
            $domNode setAttribute name "className:  $className"
                #
            set _domNode        [$domNode appendChild [$domDOC createElement className]]
            $_domNode           setAttribute name $className            
        }
        catch {
            set superClassNames [info class superclasses    $className]
            foreach superClassName $superClassNames {
                set _domNode    [$domNode appendChild [$domDOC createElement superclass]]
                $_domNode       setAttribute name $superClassName
            }
        }
        catch {
            set mixinNames      [info class mixins          $className]
            foreach mixinName   $mixinNames {
                set _domNode    [$domNode appendChild [$domDOC createElement mixin]]
                $_domNode       setAttribute name $mixinName
            }
        }
        catch {
            set isClass         [info object isa class  $namespaceName]
            if $isClass {
                set _domNode    [$domNode appendChild [$domDOC createElement isType]]
                $_domNode       setAttribute name class
            }
        }
        catch {
            set isObject     [info object isa object $namespaceName]
            if $isObject {
                set _domNode    [$domNode appendChild [$domDOC createElement isType]]
                $_domNode       setAttribute name object
            }
        }
            #
            #
        _add__procedureContent  $domNode   $namespaceName   [_childProcedures   $namespaceName]
        _add__arrayContent      $domNode   $namespaceName   [_childArrays       $namespaceName]
        _add__variableContent   $domNode   $namespaceName   [_childVars         $namespaceName]
        _add__objectContent     $domNode   $namespaceName   [_childObjects      $namespaceName]
            #
        catch {
            set isObject     [info object isa object $namespaceName]
            if $isObject {
                _add__methodContent     $domNode   $namespaceName    
            }
        }
            #
        return
            #
    }
        #
    proc appUtil::_add__procedureContent {domNode namespaceName procNameList} {
            #
        set domDOC [$domNode ownerDocument]
            #
        if {[llength $procNameList] > 0} {
            set nodeName   [format {____procedure_%s} [llength $procNameList]]
            set _domNode   [$domNode appendChild [$domDOC createElement $nodeName]]
        } else {
            return
        }
            #
        foreach _procName $procNameList {
            set _nodeName   [string map [list $namespaceName {} {::} {}] $_procName]
            set _nodeName   [check_nodeName $_nodeName]
                # puts "<oo>   -> \$_nodeName: $_procName -> $_nodeName"
            catch {
                set _node [$domDOC createElement $_nodeName]
                $_domNode appendChild $_node
                    #
                set _procArgs   [info args $_procName]
                set _nodeValue  [check_nodeValue $_procArgs]
                $_node appendChild [$domDOC createTextNode $_nodeValue]
            }
        }
            #
        return
            #
    }
        #
    proc appUtil::_add__methodContent {domNode objectName} {
            #
        set domDOC [$domNode ownerDocument]
            #
        set methodNameList [info object methods  $objectName -all]    
            
        if {[llength $methodNameList] > 0} {
            set nodeName   [format {____method_%s} [llength $methodNameList]]
            set _domNode   [$domNode appendChild [$domDOC createElement $nodeName]]
        } else {
            return
        }
            #
        foreach methodName $methodNameList {
            set methArgs {}
            foreach inf [info object call $objectName $methodName] {
                catch {
                    lassign $inf calltype name locus methodtype
                    # Assume no forwards or filters, and hence no $calltype
                    # or $methodtype checks...
                    if {$locus eq "object"} {
                        set methArgs [lindex [info object definition    $objectName $name] 0]
                    } else {
                        set methArgs [lindex [info class definition     $locus      $name] 0]
                    }
                }
            }
            set _node [$domDOC createElement $methodName]
            $_domNode appendChild $_node
            $_node appendChild [$domDOC createTextNode $methArgs]
        }                 
            #
        return    
            #
    }
        #
    proc appUtil::_add__arrayContent {domNode namespaceName arrayNameList} {
            #
        set domDOC [$domNode ownerDocument]
            #
        if {[llength $arrayNameList] > 0} {
            set nodeName   [format {____array_%s} [llength $arrayNameList]]
            set _domNode   [$domNode appendChild [$domDOC createElement $nodeName]]
        } else {
            return
        }
            #
        foreach _arrayName $arrayNameList {
            set _nodeName   [string map [list $namespaceName {} {::} {}] $_arrayName]
            set _nodeName   [check_nodeName $_nodeName]
                #
            set _node [$domDOC createElement $_nodeName]
            $_domNode appendChild $_node
                #
            set arrayKeys [lsort [array names $_arrayName]]
            if {[llength $arrayKeys] == 0} {
                $_node setAttribute name {keys}
                $_node appendChild [$domDOC createTextNode {... array is empty}]
            }
            foreach _key $arrayKeys {
                set __node [$domDOC createElement element]
                $_node appendChild $__node
                $__node setAttribute name $_key
                    #
                if {[catch {set _keyValue [array get $_arrayName $_key]} eID]} {
                    # puts "<oo> KO: $eID"
                    set _keyValue {could not get Value}
                } else {
                    # puts "<oo> OK: $_keyValue"
                    set _keyValue [lindex $_keyValue 1]
                    set _keyValue [check_nodeValue $_keyValue]
                }
                $__node appendChild [$domDOC createTextNode $_keyValue]
            }
        }
            #
        return
            #
    }
        #
    proc appUtil::_add__variableContent {domNode namespaceName variableNameList} {
            #
        set domDOC [$domNode ownerDocument]
            #
        if {[llength $variableNameList] > 0} {
            set nodeName   [format {____variable_%s} [llength $variableNameList]]
            set _domNode   [$domNode appendChild [$domDOC createElement $nodeName]]
        } else {
            return
        }
            #
        foreach _variableName $variableNameList {
            set _nodeName   [string map [list $namespaceName {} {::} {}] $_variableName]
            set _nodeName   [check_nodeName $_nodeName]
                #
            if {![catch {set _node [$domDOC createElement $_nodeName]} eID]} {
                $_domNode appendChild $_node
                    #
                if {[catch {set _varValue [set $_variableName]} eID]} {
                    # puts "<oo> KO: $eID"
                    set _varValue {could not get Value}
                } else {
                    # puts "<oo> OK: $_varValue"
                    set _varValue [check_nodeValue $_varValue]
                    $_node appendChild [$domDOC createTextNode $_varValue]
                }
            } else {
                #puts "<oo> KO $_variableName $_nodeName  <- $namespaceName"
                puts "          <E> appUtil::_add__variableContent $eID"
            }
        }
            #
        return
            #
    }
        #
    proc appUtil::_add__objectContent {domNode namespaceName objectNameList} {
            #
        set domDOC [$domNode ownerDocument]
            #
        if {[llength $objectNameList] > 0} {
            set nodeName   [format {____object_%s} [llength $objectNameList]]
            set _domNode   [$domNode appendChild [$domDOC createElement $nodeName]]
        } else {
            return
        }
                #
        foreach _objectName $objectNameList {
            set _nodeName   [string map [list $namespaceName {} {::} {}] $_objectName]
            set _nodeName   [check_nodeName $_nodeName]
                #
            if {![catch {set _node [$domDOC createElement $_nodeName]} eID]} {
                $_domNode appendChild $_node
                catch {
                    set className       [info object class  $_objectName]
                    $_node              setAttribute name "className:  $className"
                        #
                    set __domNode       [$_node appendChild [$domDOC createElement className]]
                    $__domNode          appendChild [$domDOC createTextNode $className]
                        #
                        set objectNS        [info object namespace $_objectName]
                        # puts "<oo>   -> $_node"
                        # puts "<oo>   -> $objectNS"
                        _add__arrayContent      $_node  $objectNS   [_childArrays   $objectNS]
                        _add__variableContent   $_node  $objectNS   [_childVars     $objectNS]
                        _add__methodContent     $_node  $_objectName
                }
            }
        }
            #
        return
            #
    }
        #
    proc appUtil::_childNamespaces {parent_namespace} {
        set namespaceList [namespace children $parent_namespace]
        foreach _namespace [lsort $namespaceList] {
            # puts "         -> namespace: $_namespace"
        }
        return [lsort $namespaceList]
    }

    proc appUtil::_childProcedures {parent_namespace} {
        set procedureList [info procs [format "%s::*" $parent_namespace]]
        foreach _procedure [lsort $procedureList] {
            # puts "         -> procedure: $_procedure"
        }
        return [lsort $procedureList]
    }
        #
    proc appUtil::_childVars {parent_namespace} {
        set _varList    [info vars  [format "%s::*" $parent_namespace]]
        set varList   {}
        foreach _variable [lsort $_varList] {
            if {[array exists $_variable] == 0} {
                lappend varList $_variable
            }
        }
        foreach _variable [lsort $varList] {
            # puts "         -> variable: $_variable"
        }
    
        return [lsort $varList]
    }
        #
    proc appUtil::_childArrays {parent_namespace} {
        set _varList    [info vars  [format "%s::*" $parent_namespace]]
        set arrayList   {}
        foreach _variable [lsort $_varList] {
            if {[array exists $_variable] == 1} {
                lappend arrayList $_variable
            }
        }
        foreach _variable [lsort $arrayList] {
            # puts "         -> variable: $_variable"
        }

        return [lsort $arrayList]
    }  
        #
    proc appUtil::_childObjects {parent_namespace} {
        set _varList    [info vars  [format "%s::*" $parent_namespace]]
        set objList   {}
        foreach _variable [lsort $_varList] {
            catch {
                set obj [set $_variable]
                if [info object isa object $obj] {
                    lappend objList $obj
                }
            }
        }
        foreach _variable [lsort $_varList] {
            catch {
                if [info object isa object $_variable] {
                    lappend objList $_variable
                }
            }
        }
        foreach _variable [lsort $objList] {
            # puts " <D>        -> variable: $_variable"
        }

        return [lsort $objList]
    }  
        #
    proc check_nodeName {_name} {
        set newName [string map {\\ {_}   \# {_}   {%} {_}   {'} {_}   {.} {_}   {:} {.}} $_name]
        set newName [string map {\\ {_}   \# {_}   {%} {_}   {'} {_}   {.} {_}   {:} {.}} $newName]
        if {$newName == {}} {set newName {___empty___}}
        if {$_name != $newName} {
            # puts "       -> check_nodeName: $_name / $newName"
            # puts "               ... check_nodeName: $_name / $newName" 
        }
        return $newName
    }
        #
    proc check_nodeValue {_value} {
        set newValue [string map {{”} {?}} $_value]
        return $newValue
    }
    
        #
        #
    proc appUtil::__orphan_add_procArgs {domNode varName} {
            
            set domDOC [$domNode ownerDocument]
    
                # puts "      -> _add_arraykeyValues:  $domNode $varName"
            
            set _procArgs   [info args $varName]
            set _varValue [check_nodeValue $_procArgs]
            $domNode appendChild [$domDOC createTextNode $_varValue]
    }

    proc appUtil::__orphan_add_arraykeyValues {domNode arrayName} {
            
            set domDOC [$domNode ownerDocument]
            
                # puts "      -> _add_arraykeyValues:  $domNode $arrayName"
            
            set arrayKeys [lsort [array names $arrayName]]
                # puts $arrayKeys
            foreach _key $arrayKeys {
                set _node [$domDOC createElement element]
                $domNode appendChild $_node
                $_node setAttribute name $_key
                # set value
                set cmdString [format "set _keyValue \$%s(%s)" $arrayName $_key]
                    # puts "   ... $cmdString"
                if {[catch {eval $cmdString} eID]} {
                    set _keyValue "<E> ERROR could not get Value: ... dont know why"
                    $_node appendChild [$domDOC createTextNode $_keyValue]
                } else {
                    set _keyValue [check_nodeValue $_keyValue]
                    $_node appendChild [$domDOC createTextNode $_keyValue]
                }
            }
    }

    proc appUtil::__orphan_add_objectValues {domNode object} {
            
            set domDOC [$domNode ownerDocument]
            set _node [$domDOC createElement className]
            $domNode appendChild $_node
            set className {}
            
            catch {
                set className [info object class $object]
                puts "<DD> $object  $className"
            } 
            if {$className == {::oo::class}} {
                set className $object
            }
            $_node appendChild [$domDOC createTextNode $className]
            
           
            set _objectNode   [$domNode appendChild [$domDOC createElement {______objects___}]]
            set _arrayNode    [$domNode appendChild [$domDOC createElement {______array_____}]]
            set _variableNode [$domNode appendChild [$domDOC createElement {______variable__}]]
            set _methodNode   [$domNode appendChild [$domDOC createElement {______methods___}]]
                
                #
                # -- objects --------
            foreach variableName [info object variables $object] {
                set variableValue {}
                set _node [$domDOC createElement $variableName]
                $_domNode appendChild $_node
                $_node appendChild [$domDOC createTextNode $variableValue]
            }
                #
                # -- variables ------
            foreach variable [info object variables $object] {
                set methArgs {}
            }
                #
                # --- methods -------
            foreach methodName [info object methods  $object -all] {
                set methArgs {}
                foreach inf [info object call $object $methodName] {
                    catch {
                        lassign $inf calltype name locus methodtype
                        # Assume no forwards or filters, and hence no $calltype
                        # or $methodtype checks...
                        if {$locus eq "object"} {
                            set methArgs [lindex [info object definition $obj $name] 0]
                        } else {
                            set methArgs [lindex [info class definition $locus $name] 0]
                        }
                    }
                }
                set _node [$domDOC createElement $methodName]
                $_methodNode appendChild $_node
                $_node appendChild [$domDOC createTextNode $methArgs]
            }            
                #
                #
            
            return
                # puts "      -> _add_arraykeyValues:  $domNode $arrayName"
            
            #set arrayKeys [lsort [array names $arrayName]]
                # puts $arrayKeys
            
            #$_node setAttribute name $_key                
            $_node appendChild [$domDOC createTextNode $className]
                
            return
            
            foreach _key $arrayKeys {
                set _node [$domDOC createElement element]
                $domNode appendChild $_node
                $_node setAttribute name $_key
                # set value
                set cmdString [format "set _keyValue \$%s(%s)" $arrayName $_key]
                    # puts "   ... $cmdString"
                if {[catch {eval $cmdString} eID]} {
                    set _keyValue "<E> ERROR could not get Value: ... dont know why"
                    $_node appendChild [$domDOC createTextNode $_keyValue]
                } else {
                    set _keyValue [check_nodeValue $_keyValue]
                    $_node appendChild [$domDOC createTextNode $_keyValue]
                }
            }
    }

    proc appUtil::__orphan_add_varValue {domNode varName} {
            
            set domDOC [$domNode ownerDocument]

                # puts "      -> _add_arraykeyValues:  $domNode $varName"
            
            set cmdString [format "set _varValue \$%s" $varName]
            if {[catch {eval $cmdString} eID]} {
                # puts "     -> array / not var: $::appUtil::config_var"
                set _varValue "<E> ERROR could not get Value: seems to be an array, but is not proper set as ARRAY"
            }
            set _varValue [check_nodeValue $_varValue]
            $domNode appendChild [$domDOC createTextNode $_varValue]
    }

 
    
        
    