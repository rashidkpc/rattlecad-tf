 ##+##########################################################################
 #
 # package: bikeModel    ->    myPersist_ModelMapping.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
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
 #    namespace:  myGUI::modelMapping
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

    #
oo::class create myPersist::ModelMapping {
        #
    variable packageHomeDir
        #
    constructor {} {
        puts "              -> class ModelMapping"
            #
        variable packageHomeDir     $myPersist::packageHomeDir
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
        variable projectTemplateDoc {}
            set fp              [open [file join $packageHomeDir  etc template__Project.xml]]
            fconfigure          $fp -encoding utf-8
            set projectXML      [read $fp]
            close               $fp
        set projectTemplateDoc  [dom parse $projectXML]
            #
            #
        variable array_mappingDict;             array set array_mappingDict {}
            #
        set array_mappingDict(persist)          [my create_MappingDict persist]
            #
        set array_mappingDict(inv_persist)      [my create_MappingDict persist  inverse]
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
        puts "            <E> ... myPersist::ModelMapping  $target_method $args  ... unknown"
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
            # persistKey ... path in rattleCAD-Project-File
            #
        switch -exact $type {
            persist     {set keyAttribute "persistKey"}
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
                puts "              <E> myPersist::ModelMapping: $mappingName - $key ... does not exist!"
                return {}
            } else {
                set retValue [dict get $mappingDict $key]
                return $retValue
            }
                #
        } else {
            error "              <E> myPersist::ModelMapping::get_Mapping: $mappingName ... does not exist!"
        }
            #
    }
        #
    method update_bikeModel_InputDoc {projectDoc bikeModelDoc} {
            #
        set projectRoot     [$projectDoc documentElement]
        set bikeModelRoot   [$bikeModelDoc documentElement]
            #
            # puts [$projectRoot asXML]    
            #
        foreach modelNode [$bikeModelRoot selectNodes */*/*] {
                #
            set modelXPath  [$modelNode toXPath]
            set modelPath   [string map {/root/ {}} $modelXPath]
                #
                # puts "  -> $modelPath"    
            set projectPath [my get_Mapping persist $modelPath]
                # puts "      -> $projectPath"
                #
            if {$projectPath ne {}} {
                set projectNode [$projectRoot selectNodes /root/$projectPath]
                if {$projectNode ne {}} {
                    # puts "          -> $projectNode"
                    # puts "              -> [[lindex $projectNode 0] asXML]"
                    # puts "                  -> [[lindex $projectNode 0] text]"
                    set projectValue [[lindex $projectNode 0] text]
                    set valueNode [$bikeModelDoc createTextNode $projectValue]
                    $modelNode appendChild $valueNode
                }
            }
        }  
            #
        return $bikeModelDoc
            #
    }
        #
    method get_PersistDoc {bikeModelDoc} {
            #
        variable projectTemplateDoc
            #
        set bikeModelRoot   [$bikeModelDoc documentElement]
            # puts [$bikeModelRoot asXML]
            # exit
            #
        set projectDoc  [dom parse [$projectTemplateDoc asXML]]
        set projectRoot [$projectDoc documentElement]
            # puts [$projectRoot asXML]    
            #
        foreach projectNode [$projectDoc getElementsByTagName *] {
                #
            # puts "  c -> $node [$node toXPath]"
                #
            if {[$projectNode hasChildNodes]} {
                continue
            }
                #
            set projectXPath    [$projectNode toXPath]
            set projectPath     [string map {/root/ {}} $projectXPath]
                #
                # puts "      -> $projectNode $projectPath"
                #
            set modelPath       [my get_Mapping inv_persist $projectPath]
            if {$modelPath ne {}} {
                    # puts "          -> $modelPath"
                set modelNode   [$bikeModelRoot selectNodes /root/$modelPath]
                    # puts "              -> $modelNode"
                if {$modelNode ne {}} {
                    set modelNode   [lindex $modelNode 0]
                    set modelValue  [$modelNode text]
                    # puts "                  -> [$modelNode asXML]"
                    # puts "                  -> $modelValue"
                        #
                    set valueNode [$projectDoc createTextNode $modelValue]
                    $projectNode appendChild $valueNode
                }
            } 
        }
            #
        return $projectDoc
            #
    }
        #
}