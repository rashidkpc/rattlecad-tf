 ##+##########################################################################
 #
 # package: bikeModel    ->    classDomainMap.tcl
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
 #    namespace:  DomainMap
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


    oo::class create myGUI::modelAdapter::_AdapterModel {
            #
        variable _parentObject
        variable modelDOM
        variable persistenceDOM
        variable myLogging 1
            #
        constructor {} {
            puts "              -> superclass _AdapterModel"
            variable _parentObject  [lindex [self caller] 1]
                #
            variable modelDOM       {}
            variable persistenceDOM {}
            # variable _arrayResult;  array set _arrayResult {}
        }
            #
        destructor { 
            puts "            [self] destroy"
        }
            #
        method unknown {target_method args} {
            puts "            <E> ... myGUI::modelAdapter::_AdapterModel  $target_method $args  ... unknown"
        }
            #
        method _initParameter {} {
                #
                #
        }
            #
        method report_Values {} {
                #
            puts ""
            puts "  ---- [info object class [self object]] -------- report_Values ---------------- "
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
        method getMappingDict {{mode persist_2_domain}} {}
            #
        method updateModelDOM {persistenceDOM} {}
            #
        method updatePersistenceDOM {} {
                #
                # ... replace: 
                #   namespace import ::bikeGeometry::set_newProject
                #       ::bikeGeometry::set_newProject $projectDOM
                #
                # puts "[$modelDOM asXML]"   
                #
            variable modelDOM
            variable persistenceDOM
                #
            set mappingDict [my getMappingDict domain_2_persist]
                #
            foreach persistKey [dict keys [dict get $mappingDict mapping]] {
                    # puts "             update_persistenceDOM -> $persistKey"
                set domain_xPath [dict get $mappingDict mapping $persistKey]
                    # puts "                          domain_xPath  -> $domain_xPath"
                set modelNode   [$modelDOM selectNodes /root/$domain_xPath/text()]
                set modelValue  [$modelNode asXML]
                    # puts "                                    -> $modelValue"
                    #
                set persistNode    [$persistenceDOM selectNodes $persistKey/text()]
                if {$persistNode != {}} {
                    set persistValue   [$persistNode nodeValue  $modelValue]
                } else {
                    puts "    <W> ... $persistKey failed in [namespace current]::update_persistenceDOM"
                }
                    #
            }
                #
            set removeNode  [$persistenceDOM selectNodes /root/Result]
            if {$removeNode != {}} {
                set parentNode      [$removeNode parentNode]
                $parentNode removeChild $removeNode
                $removeNode delete   
            }
                #
            return $persistenceDOM
                #
        }
            #
    }
        
    


