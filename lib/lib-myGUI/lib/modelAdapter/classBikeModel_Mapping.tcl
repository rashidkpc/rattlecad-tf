 ##+##########################################################################
 #
 # package: bikeModel    ->    classBikeModel_Mapping.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2017/01/11
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
    
            #
    oo::class create myGUI::modelAdapter::BikeModelMapping {
            #
        variable packageHomeDir
            #
        constructor {} {
            puts "              -> class BikeModelMapping"
                #
            variable packageHomeDir     $myGUI::packageHomeDir
                # puts " ... -> \$packageHomeDir $packageHomeDir"
                #
            variable mappingDoc     {}
                set fp              [open [file join $packageHomeDir  etc mapping_bikeModel.xml]]
                fconfigure          $fp -encoding utf-8
                set mappingXML      [read $fp]
                close               $fp
            set mappingDoc          [dom parse $mappingXML]
                #
                #
            variable array_mappingDict;             array set array_mappingDict {}
                #
            set array_mappingDict(gui)              [my create_MappingDict gui]
            set array_mappingDict(guiDict)          [my create_MappingDict guiDict]
                #
            set array_mappingDict(inv_gui)          [my create_MappingDict gui      inverse]
            set array_mappingDict(inv_model)        [my create_MappingDict guiDict  inverse]
                #
                #
            return
                #
        }
            #
        destructor { 
            puts "            [self] destroy"
        }
            #
        method unknown {target_method args} {
            puts "            <E> ... myGUI::modelAdapter::BikeModelMapping  $target_method $args  ... unknown"
        }
            #
        method create_MappingDict {type {mode {default}}} {
                #
            variable mappingDoc
                #
            set mappingDict         [dict create]
                #
            set dataStructureRoot   [$mappingDoc documentElement]
                #
                # <DownTube>
                #   <Direction>
                #     <XZ guiDictKey=""  prjKey="" geometry   Key="" geometryKey="" componentKey="" frameKey="" projectXML="">0.6879964311861184 0.7257140695033855</XZ>
                # 
                # gui .......... path as used to write from myGUI to bikeModel
                # guiDictKey ... path as used in a dictionary to read results from bikeModel
                # persistKey ... path in rattleCAD-Project-File
                #
            switch -exact $type {
                gui         {set keyAttribute "guiKey"}
                guiDict     {set keyAttribute "guiDictKey"}
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
        method get_Mapping {mappingName key} {
                #
            variable array_mappingDict
                #
            # puts "\n -- $mappingName -- $key --\n"
                #
            if {[array names array_mappingDict -exact $mappingName] != {}} {
                    #
                set mappingDict $array_mappingDict($mappingName)   
                    #
                # puts "\n -- $mappingName -- \n"
                # appUtil::pdict $mappingDict    
                    #
                set keyExist [dict keys $mappingDict $key]
                    # puts "                   get_Mapping -> \$keyExist $keyExist"
                    #
                if {$keyExist eq {}} {
                    puts "              <E> myGUI::modelAdapter::BikeModelMapping::get_Mapping: $mappingName - $key ... does not exist!"
                    return {}
                } else {
                    set retValue [dict get $mappingDict $key]
                    return $retValue
                }
                    #
            } else {
                error "              <E> myGUI::modelAdapter::BikeModelMapping::get_Mapping: $mappingName ... does not exist!"
            }
                #
        }
            #
        method get_GUIDictionary {bikeModelDoc} {
                #
            variable array_mappingDict
                #
            set bikeModelRoot [$bikeModelDoc documentElement]
                #
            set myDict  [dict create]    
                #
            set mappingDict $array_mappingDict(inv_model)
                #
            # puts "\n\n --- get_GUIDictionary ---\n\n"    
                # puts "[$bikeModelRoot asXML]"    
                # appUtil::pdict $mappingDict    
                #
            foreach guiPath [dict keys $mappingDict] {
                    # puts "   -> $guiPath"
                set modelPath [dict get $mappingDict $guiPath]
                    # puts "       -> $modelPath"
                    #
                set modelNode   [$bikeModelRoot selectNodes /root/$modelPath]
                if {$modelNode ne {}} {
                    set modelValue  [$modelNode text]
                        # puts "          -> \$modelValue $modelValue"
                        #
                    foreach {objectName typeName keyName} [split $modelPath /] break
                    switch -exact $typeName {
                        Direction -
                        BoundingBox -
                        Polygon -   
                        Polyline -
                        Position -   
                        Profile {   
                                # puts "-> \$typeName $typeName"
                                if {[llength $modelValue] > 1} {
                                    set myValue [list $modelValue]
                                }
                            }
                        default {
                                    set myValue $modelValue
                            }
                    }                       
                        #
                    # puts "          -> \$myValue ${myValue}"
                        #
                    set pathList [split $guiPath /]
                        # puts "                -> [llength $pathList]"
                    switch -exact [llength $pathList] {
                        2 {     foreach {a key} $pathList break
                                    # puts "         get_dictGUI:     -> $a $key ${myValue}"
                                dict set myDict $a $key ${myValue}
                            }
                        3 {     foreach {a b key} $pathList break
                                    # puts "         get_dictGUI:     -> $a $b $key ${myValue}"
                                dict set myDict $a $b $key ${myValue}
                            }
                        4 {     foreach {a b c key} $pathList break
                                    # puts "         get_dictGUI:     -> $a $b $key ${myValue}"
                                dict set myDict $a $b $c $key ${myValue}
                            }
                        default {  
                                puts "         get_GUIDictionary:     ... except [llength $pathList]"
                                continue
                            }
                    }
                }
            }
                #
            return $myDict    
                #
        }    
            #
    }