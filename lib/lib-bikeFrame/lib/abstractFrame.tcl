 ##+##########################################################################
 #
 # package: bikeFrame    ->    classBicycle.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/051/08 #
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
 #    namespace:  bikeFrame
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

    
oo::class create bikeFrame::AbstractFrame {
        #
    variable packageHomeDir
    variable _projectName
        #
    variable _domProjectRoot
        #
        #
    variable geometryObject 
        #
        # variable comp_BottleCage_DownTube
        # variable comp_CrankSet
        # variable comp_Fork
        # variable comp_FrontWheel
        # variable comp_HandleBar
        # variable comp_RearWheel
        # variable comp_Saddle
        # variable comp_SeatPost
        # variable comp_Stem
        #
    variable lug_BottomBracket
    variable lug_RearDropout
        #
    variable tube_HeadTube
    variable tube_SeatTube
        #
        # ----------------------------------------------------
        #
    constructor {} {
        if {![lindex [self call] 1]} {
            return -code error "class '[info object class [self]]' is abstract"
        }
        puts "            -> superclass AbstractFrame"
        variable packageHomeDir [file normalize [file join [pwd] [file dirname [file dirname [info script]]]] ]
        variable projectName    "myProject"
            #
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... [info object class [self]]  $target_method $args  ... unknown"
    }
        #
    method initProject_DOM {projectNode} {}
        #
    method initProject_DICT {projectDict} {}
        #
    method setSubset_DICT {paramDict} {}
        #
    method set_projectName {newProjectName} {
        variable _projectName
        set _projectName $newProjectName 
        return $_projectName
    }
        #
    method get_domainParameters {{type arrayStructure} {report no_report}} {
            #
            # type:   arrayStructure
            #         xmlStructure
            # report: no_report
            #         report
            #
            #
        variable _domProjectRoot
            #
        if {$type == {xmlStructure}} {
                #
                # thats the simple way: return $_domProjectRoot
                #
            if {$report == {report}} {    
                puts "\n    -- get_domainParameters - xmlStructure --"
                puts [$_domProjectRoot asXML]
            }
                #
            set dom     [dom parse [$_domProjectRoot asXML]]
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
            return $root
                #
        }
            #

            #
            # return a list of arrayName(arrayKey) 
            #
        set list_domainParameter {}    
            #
        foreach arrayNode [$_domProjectRoot childNodes] {
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
        #
    method get_projectName {} {
        variable _projectName
        return $_projectName
    }
        #
    method get_packageHomeDir {} {
        variable packageHomeDir
        return $packageHomeDir
    }
        #
    method getGeometry {} {
        variable geometryObject 
        return $geometryObject 
    }
        #
    method getComponent {componentName} {}
        #
    method getLug {lugName} {}
        #
    method getTube {tubeName} {}
        #
    method getDictionary {} {
            #
        variable geometryObject   
            #
        puts "\n"
        puts "  ---- [info object class [self object]] ---- getDictionary ------  [self object]  "
        puts ""
            #
        set myDict   [dict create]
            #
            # ---- Geometry ----
        # set geometryDict    [$geometryObject getDictionary]
        # dict append myDict Geometry $geometryDict
            # ---- Lugs ----
        foreach object [my getLug __all] {
                # puts "\n      -- [info object class $bicycleComponent] -- $bicycleComponent"
            set objectName [lindex [split [info object class $object] ::] end]
            set objectName [string map {Provide {}} $objectName]
                # puts "\n         $objectName"
            set objectDict [$object getDictionary]
            dict append myDict $objectName $objectDict
        }
            #
            # ---- Tubes ----
        foreach object [my getTube __all] {
                # puts "\n      -- [info object class $bicycleComponent] -- $bicycleComponent"
            set objectName [lindex [split [info object class $object] ::] end]
            set objectName [string map {Provide {}} $objectName]
                # puts "\n         $objectName"
            set objectDict [$object getDictionary]
            dict append myDict $objectName $objectDict
        }
            #
        # appUtil::pdict $myDict 4 "    "
            #
        return $myDict
            #
    }
        #
    method getDictionary_TubeMiter {} {
    
    }
        #
}
