 ##+##########################################################################
 #
 # package: bikeComponent    ->    bikeComponent.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/07
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
 #    namespace:  bikeComponent
 # ---------------------------------------------------------------------------
 #
 #
 # 0.00 - 20160057
 #      ... refactor: rattleCAD - 3.4.03
 #
 #
 # 1.xx refactor
 #          split project completely from bikeGeometry
 #
 #
  
package require tdom
    #
package provide bikeComponent 0.01
    #
package require vectormath
package require appUtil
    #
namespace eval bikeComponent {
    
        # --------------------------------------------
            # Export as global command
        variable packageHomeDir [file dirname [file normalize [info script]]]
            #
            # puts " <Ref> bikeComponent $packageHomeDir"
           
        #-------------------------------------------------------------------------
            #  definitions of template parameter
        variable initRoot
        variable resultRoot
        variable projectDOM
        variable projectRoot
            #
        # variable initRoot    $project::initRoot
        # variable returnDict; set returnDict [dict create rattleCAD {}]
            #
    
        #-------------------------------------------------------------------------
            #  manage all svg-Files
        variable comp_Library    
                        
        #-------------------------------------------------------------------------
            #  namespace settings
        variable array_CompObject   ; array set array_CompObject    {}
        variable array_CompDir      ; array set array_CompDir       {}
        variable array_CompBaseDir  ; array set array_CompBaseDir   {}
                                            # set array_CompBaseDir(User)    {}
                                            # set array_CompBaseDir(Custom)  {}

        #-------------------------------------------------------------------------
            #  current Project Values
        variable array_Component    ; array set array_Component {}   
        variable objectStrategy     ; array set objectStrategy  {}
        
        #-------------------------------------------------------------------------
            #  register Objects to Update
        variable list_UpdateRegistry {}   
        
        #-------------------------------------------------------------------------
            #  svg cache
        variable array_CompCache    ; array set array_CompCache {}   
        
        #-------------------------------------------------------------------------
            #  update loop and delay; store last value
        # variable _updateValue   ; array set _updateValue    {}

        
        #-------------------------------------------------------------------------
            #  dataprovider of create_selectbox
        variable _listBoxValues
        
        #-------------------------------------------------------------------------
            #  export procedures

}
    
    
    #
    #-------------------------------------------------------------------------
    # init Namespace
proc bikeComponent::init {} {
            #
        variable packageHomeDir
            #
        variable initRoot
        variable projectRoot
        variable resultRoot
            #
        variable array_CompObject
        variable array_CompDir
        variable array_Component
            #
        variable array_CompBaseDir
            #
            #
            # ... define location of components
        set array_CompBaseDir(etc)  [file normalize [file join $packageHomeDir components]]
            #
            # parray  array_CompBaseDir
            #
            # ... 
        set fp          [open [file join $packageHomeDir etc initTemplate.xml] ]
        fconfigure      $fp -encoding utf-8
        set initXML     [read $fp]
        close           $fp          
        set projectDoc  [dom parse $initXML]
        set projectRoot [$projectDoc documentElement]
            #
            # ...
        set fp          [open [file join $packageHomeDir etc initNamespace.xml] ]
        fconfigure      $fp -encoding utf-8
        set initXML     [read $fp]
        close           $fp          
        set initDoc     [dom parse $initXML]
        set initRoot    [$initDoc documentElement]
            #
            # ... update array_CompDir
        update_DirStructure    
            #
            #
        set array_CompObject(BottleCage_DownTube)       [bikeComponent::BottleCage      new right]
        set array_CompObject(BottleCage_DownTubeLower)  [bikeComponent::BottleCage      new left] 
        set array_CompObject(BottleCage_SeatTube)       [bikeComponent::BottleCage      new left]  
            #       
        set array_CompObject(CrankSet)                  [bikeComponent::CrankSet        new]    
        set array_CompObject(Fork)                      [bikeComponent::Fork            new]
        set array_CompObject(FrontBrake)                [bikeComponent::FrontBrake      new]    
        set array_CompObject(FrontFender)               [bikeComponent::FrontFender     new]    
        set array_CompObject(HeadSet)                   [bikeComponent::HeadSet         new]    
        set array_CompObject(RearBrake)                 [bikeComponent::RearBrake       new]   
        set array_CompObject(RearFender)                [bikeComponent::RearFender      new]    
        set array_CompObject(RearHub)                   [bikeComponent::RearHub         new]    
        set array_CompObject(RearDropout)               [bikeComponent::RearDropout     new]   
        set array_CompObject(Saddle)                    [bikeComponent::Saddle          new]             
        set array_CompObject(SeatPost)                  [bikeComponent::SeatPost        new]    
        set array_CompObject(Stem)                      [bikeComponent::Stem            new]    
            #
        set array_CompObject(FrontCarrier)              [bikeComponent::ComponentBasic  new FrontCarrier]   
        set array_CompObject(FrontDerailleur)           [bikeComponent::ComponentBasic  new FrontDerailleur]   
        set array_CompObject(HandleBar)                 [bikeComponent::ComponentBasic  new HandleBar]   
        set array_CompObject(Label)                     [bikeComponent::ComponentBasic  new Label]   
        set array_CompObject(RearCarrier)               [bikeComponent::ComponentBasic  new RearCarrier]   
        set array_CompObject(RearDerailleur)            [bikeComponent::ComponentBasic  new RearDerailleur]   
            #
            #
        $array_CompObject(BottleCage_DownTube)          update
        $array_CompObject(BottleCage_DownTubeLower)     update
        $array_CompObject(BottleCage_SeatTube)          update
            #
        $array_CompObject(CrankSet)                     update
        $array_CompObject(FrontFender)                  update
        $array_CompObject(HeadSet)                      update
        $array_CompObject(RearFender)                   update
        $array_CompObject(RearHub)                      update
        $array_CompObject(SeatPost)                     update
        $array_CompObject(Stem)                         update
            #
        $array_CompObject(Fork)                         update
            #
        $array_CompObject(FrontBrake)                   update
        $array_CompObject(FrontCarrier)                 update
        $array_CompObject(FrontDerailleur)              update
        $array_CompObject(HandleBar)                    update
        $array_CompObject(Label)                        update
        $array_CompObject(RearBrake)                    update
        $array_CompObject(RearCarrier)                  update
        $array_CompObject(RearDerailleur)               update
        $array_CompObject(RearDropout)                  update
        $array_CompObject(Saddle)                       update
            #
            
            #
            #
            # --
        # set fp          [open [file join $packageHomeDir .. etc initTemplate.xml] ]
        # fconfigure      $fp -encoding utf-8
        # set projectXML  [read $fp]
        # close           $fp          
        # set projectDoc  [dom parse $projectXML]
        # set projectRoot [$projectDoc documentElement]
            #            
            #
            # --- 
        # set fp          [open [file join $packageHomeDir .. etc resultTemplate.xml] ]
        # fconfigure      $fp -encoding utf-8
        # set resultXML   [read $fp]
        # close           $fp          
        # set resultDoc   [dom parse $resultXML]
        # set resultRoot  [$resultDoc documentElement]

        #-------------------------------------------------------------------------
            #  init Values
            #    ... these is a default project
            #  
            #
        if 0 {
            foreach arrayNode [$projectRoot childNodes] {
                # this is the arrayName level
                foreach keyNode [$arrayNode childNodes] {
                    # this is the key level
                    foreach textNode [$keyNode childNodes] {
                        set targetParameter     [format {%s::%s(%s)} [namespace current] [$arrayNode nodeName] [$keyNode nodeName]]
                        set targetValue         [$textNode nodeValue]
                        set $targetParameter    $targetValue
                        # puts "   ... [$textNode nodeValue]"
                        # $keyNode removeChild $textNode
                        # $textNode delete
                    }
                }
            }    
        }

        # -- default Values -------------------------
            #
        set Component(RearHub)                      {hub/rattleCAD_rear.svg}                                                            
        set ::bikeComponent::HeadSet(ShimDiameter)  36
            #


        # -- set ::bikeComponent::DEBUG_Geometry  ----
        #
        set ::bikeComponent::DEBUG_Geometry(Base)                    {0 0}
        
        
        # --- update ConfigPrev ---------------------
            #
        if 0 {
            foreach key [array names [namespace current]::Config] {
                set [namespace current]::ConfigPrev($key) [bikeComponent::get_Config $key]
            }
        }

        # --- compute geometry ----------------------
            #
        # bikeComponent::update_Geometry
          
            
        # -------------------------------------------
            #
        return
            #

}
    #-------------------------------------------------------------------------
    # keep content of initRoot in array_CompDir	
proc bikeComponent::initProject {domNode} {
}
    #-------------------------------------------------------------------------
    # keep content of initRoot in array_CompDir	
proc bikeComponent::update_DirStructure {} {
        variable array_CompDir
        variable initRoot
            #
        set locationNode    [$initRoot selectNodes /root/Options/ComponentLocation]
            #
        foreach childNode [$locationNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                set keyString  [$childNode getAttribute key {}]
                set dirString  [$childNode getAttribute dir {}]
                lappend dirList [list $keyString $dirString]
                array set array_CompDir [list $keyString $dirString]
            }
        }
}
    #-------------------------------------------------------------------------
    # return structure of project definitio as xml or array-Structure	
proc bikeComponent::create_LibraryWidget {w} {
    set widgetNS [namespace current]::libWidget
    set retValue [${widgetNS}::createLibrary $w]
    lassign $retValue  cv cvNS
        # foreach {cv cvNS} $retValue break 
    return [list $widgetNS $cv $cvNS]
}

    #-------------------------------------------------------------------------
    # add additional component directories:	
proc bikeComponent::add_ComponentDir {key dir} {
    variable    array_CompBaseDir
    set myDir [file normalize $dir]
    if {[file isdirectory  $dir]} {
        array set   array_CompBaseDir   [list $key $dir]
        return [array get array_CompBaseDir $key]
    } else {
        return {}
    }
}
    #
    #-------------------------------------------------------------------------
    # -- setter
proc bikeComponent::set_Config {objectName key value} {
        #
    #puts "              <I> bikeComponent::set_Config ...... $objectName $key -> $value"
        #
    register_UpdateObject $objectName
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) setValue Config $key $value]
    #puts "              <I> bikeComponent::set_Config ...... $objectName $key -> $returnValue <- return"
    return $returnValue
        #
}  
proc bikeComponent::set_Scalar {objectName key value} {
        #
    #puts "              <I> bikeComponent::set_Scalar ...... $objectName $key -> $value"
        #
    register_UpdateObject $objectName
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) setValue Scalar $key $value]
    return $returnValue
        #
}
proc bikeComponent::set_ListValue {objectName key value} { 
        #
    #puts "              <I> bikeComponent::set_ListValue ... $objectName $key -> $value"
        #
    register_UpdateObject $objectName
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) setValue ListValue $key $value]
    return $returnValue
        #
}    
proc bikeComponent::set_Placement {objectName {pos {0 0}} angle args} { 
        #
    #puts "              <I> bikeComponent::set_Placement ... $objectName $pos $angle"
        #
        
        #
    # register_UpdateObject $objectName
        #
        
        #
    variable array_CompObject
        #
        # puts "  $angle"
    switch -exact $objectName {
        HeadSet {
                #
            register_UpdateObject $objectName
                #
            set retValue [$array_CompObject($objectName) setPlacement $pos $angle $args]
                #puts "                  set_Placement: $objectName -> $retValue"
                return $retValue
            }
        default {
                set retValue [$array_CompObject($objectName) setPlacement $pos $angle]
                #puts "                  set_Placement: $objectName -> $retValue"
                return $retValue
        }
    }
}    
    #-------------------------------------------------------------------------
    # -- update
proc bikeComponent::register_UpdateObject {objectName} {
        #
    variable list_UpdateRegistry
        #
    if {[lsearch $list_UpdateRegistry $objectName] < 0} {
        puts "          ... append $objectName to updateRegistry"
        lappend list_UpdateRegistry $objectName
    }
        #
}
proc bikeComponent::update_RegisteredComponents {} {
        #
    variable list_UpdateRegistry
    variable array_CompObject
        #
    if {$list_UpdateRegistry ne {}} {
            #
        puts "          ... update_RegisteredComponents:"
        foreach ___keyName $list_UpdateRegistry {
            puts "                  -> $___keyName"
            $array_CompObject($___keyName) update
        }
        set list_UpdateRegistry {}
            #
    }
        # puts ""
        #
    return
        #
}
    #-------------------------------------------------------------------------
    # -- getter
proc bikeComponent::get_Strategy {objectName} {
        #
    variable array_CompObject
        #
    #puts " bikeComponent::get_Strategy $objectName"    
        #
    switch -exact $objectName {
        Fork -
        _any_ {
            set retValue [$array_CompObject($objectName) getStrategy]
            return $retValue
        }
        default {}
    }
        #
}  
proc bikeComponent::get_Config {objectName key} {
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) getValue Config $key]
    return $returnValue
        #
}  
proc bikeComponent::get_Scalar {objectName key} {
        #
    variable array_CompObject
        # puts "  $objectName $key"
    set returnValue [$array_CompObject($objectName) getValue Scalar $key]
    return $returnValue
        #
}
proc bikeComponent::get_ListValue {objectName key} { 
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) getValue ListValue $key]        
    return $returnValue
        #
}    
    #
proc bikeComponent::get_ComponentNode {objectName key {value {}}} {
        #
    update_RegisteredComponents
        #
    variable array_CompDir
    variable array_Component
    variable array_CompBaseDir
        #
    variable array_CompObject

    if {$value ne {}} {
        set_Component $objectName $key $value
    }        

        #
        # puts " --- "
    # puts "              <I> bikeComponent::get_ComponentNode ... $objectName $key $value"
        #
        
        #
        # -- get the custom svg-components
        #
    switch -exact $objectName {                    
            HandleBar                 { return [$array_CompObject(HandleBar)                getValue ComponentNode XZ]}
            BottleCage_DownTube       { return [$array_CompObject(BottleCage_DownTube)      getValue ComponentNode XZ]}
            BottleCage_DownTubeLower  { return [$array_CompObject(BottleCage_DownTubeLower) getValue ComponentNode XZ]}
            BottleCage_SeatTube       { return [$array_CompObject(BottleCage_SeatTube)      getValue ComponentNode XZ]}
            CrankSet_XY_Custom        { return [$array_CompObject(CrankSet)                 getValue ComponentNode XY_Custom]}
            CrankSet_XZ_Custom        { return [$array_CompObject(CrankSet)                 getValue ComponentNode XZ_Custom]}
            CrankSet_XZ               { return [$array_CompObject(CrankSet)                 getValue ComponentNode XZ]}
            ForkCrown                 { return [$array_CompObject(Fork)                     getValue ComponentNode XZ_Crown]}
            ForkBlade                 { return [$array_CompObject(Fork)                     getValue ComponentNode XZ_Blade]}
            ForkDropout               { return [$array_CompObject(Fork)                     getValue ComponentNode XZ_Dropout]}
            FrontBrake                { return [$array_CompObject(FrontBrake)               getValue ComponentNode XZ]}
            FrontCarrier              { return [$array_CompObject(FrontCarrier)             getValue ComponentNode XZ]}
            FrontDerailleur           { return [$array_CompObject(FrontDerailleur)          getValue ComponentNode XZ]}
            FrontFender_XZ            { return [$array_CompObject(FrontFender)              getValue ComponentNode XZ]}
            HeadSetBottom             { return [$array_CompObject(HeadSet)                  getValue ComponentNode XZ_Bottom]}
            HeadSetTop                { return [$array_CompObject(HeadSet)                  getValue ComponentNode XZ_Top]}
            Label                     { return [$array_CompObject(Label)                    getValue ComponentNode XZ]}
            RearBrake                 { return [$array_CompObject(RearBrake)                getValue ComponentNode XZ]}
            RearCarrier               { return [$array_CompObject(RearCarrier)              getValue ComponentNode XZ]}
            RearDerailleur            { return [$array_CompObject(RearDerailleur)           getValue ComponentNode XZ]}
            RearFender_XY             { return [$array_CompObject(RearFender)               getValue ComponentNode XY]}
            RearFender_XZ             { return [$array_CompObject(RearFender)               getValue ComponentNode XZ]}
            RearDropout               { return [$array_CompObject(RearDropout)              getValue ComponentNode XZ]}
            RearHub                   { return [$array_CompObject(RearHub)                  getValue ComponentNode XY]}
            RearHub_Disc              { return [$array_CompObject(RearHub)                  getValue ComponentNode XY_Disc]}
            Saddle                    { return [$array_CompObject(Saddle)                   getValue ComponentNode XZ]}
            SeatPost                  { return [$array_CompObject(SeatPost)                 getValue ComponentNode XZ]}
            Steerer                   { return [$array_CompObject(Fork)                     getValue ComponentNode XZ_Steerer]}
            Stem                      { return [$array_CompObject(Stem)                     getValue ComponentNode XZ]}
            default {
                            # parray array_CompCache
                            # tk_messageBox -message "\$objectName $objectName"
                            # set svgRoot $array_CompCache($objectName)  
                            # return $svgRoot
                            puts "\n              <W> bikeComponent::get_ComponentNode ... \$objectName not accepted! ... $objectName"
                            return
            }
    }
        #
        # -- check for existing parameter $Config($objectName)
    if {[catch {array get array_CompDir $objectName} eID]} {
        puts "\n              <W> bikeComponent::get_Component ... \$objectName not accepted! ... $objectName"
        parray array_CompDir
        return {}
    }
        #
    return {}
        #
}
proc bikeComponent::get_Direction {objectName key} {
#
    update_RegisteredComponents
        #
    variable array_CompObject
    set retAngle [$array_CompObject($objectName) getValue Direction $key]
    set retValue [vectormath::rotateLine {0 0} 1 $retAngle]
    return $retValue
        #
}
proc bikeComponent::get_Polyline {objectName key} {
        #
    update_RegisteredComponents
        #
    variable array_CompObject
    set polylineValue [$array_CompObject($objectName) getValue Polyline $key]
    return $polylineValue
        #
}
proc bikeComponent::get_Polygon {objectName key} {
        #
    update_RegisteredComponents
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) getValue Polygon $key]
    return $returnValue
        #
}
proc bikeComponent::get_Position {objectName key} {
        #
    update_RegisteredComponents
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) getValue Position $key]
    return $returnValue
        #
}
proc bikeComponent::get_Vector {objectName key} {
        #
    update_RegisteredComponents
        #
    variable array_CompObject
    set returnValue [$array_CompObject($objectName) getValue Vector $key]
    return $returnValue
        #
}
    #
proc bikeComponent::get_ComponentKey {objectName key} {
        #
    variable array_CompObject
    set compKey [$array_CompObject($objectName) getValue Config ComponentKey]
    return $compKey
        #
}
    #
proc bikeComponent::get_ComponentPath {objectName key} {
        #
        # required in Edit - Preview
        #
    variable array_CompDir
    variable array_Component
    variable array_CompBaseDir
    variable array_CompCache
        #
        #
        # puts "   -> bikeComponent::get_ComponentPath $objectName $key"
        #
    set parentDir   {}
    set dirKey      {}
    set fileString  {}
        #
    if {$key ne {}} {    
        set compKey $key
    } else {
        set compKey [lindex [array get array_Component $objectName] 1]
    }
        #
    lassign [split $compKey :]  dirKey fileString
        # foreach {dirKey fileString} [split $compKey :] break
        # puts "       >$objectName< >$dirKey< >$fileString<"
        # parray array_CompBaseDir 
    if {$dirKey == {}} return {}
        # parray array_CompBaseDir
    set retValue [array get array_CompBaseDir $dirKey]
    if {$retValue ne {}} {
        lassign $retValue  key parentDir
        # foreach {key parentDir} $retValue break
    }
        #
    if {$parentDir == {}} {
        return {}
    }
        #
    if {[catch {array get array_CompCache $objectName} eID]} {
        #
    } else {
            #
        set fileString  [string trim $fileString /]
            #
        set fileString [string map {bottle_cage/ bottleCage/} $fileString]
            #
        set filePath    [file normalize [file join $parentDir $fileString]]
            #
        return $filePath
            #
    }
        #
}
    #
proc bikeComponent::get_ComponentDirectories {} {
        #
    variable array_CompBaseDir
        #
    set dirList {} 
        #
    foreach key [lsort [array names array_CompBaseDir]] {
        foreach {_key _value} [array get array_CompBaseDir $key] {
            lappend dirList [list $_key $_value]
        }
    }            
        #
    return $dirList 
        #
}

proc bikeComponent::get_ComponentBaseDirectory {} {
        #
    variable array_CompBaseDir
    return $array_CompBaseDir(etc) 
        #
}

proc bikeComponent::get_ComponentSubDirectories {} {
        #
        # get list: key <-> subDirectory
    variable array_CompDir
        #
    set dirList {} 
        #
    foreach key [lsort [array names array_CompDir]] {
        foreach {_key _value} [array get array_CompDir $key] {
            lappend dirList [list $_key $_value]
        }
    }            
        #
    return $dirList
        #
}

    #-------------------------------------------------------------------------
    # get alternatives to type ...
proc bikeComponent::get_CompAlternatives {key} {
            #
    variable array_CompDir
    variable array_CompBaseDir
        #
            # ... handle switch in bikeGeometry 1.75
            #          ... <component key="ForkCrown"              dir="fork/crown"        />           
            # 
    # puts "\n <D> bikeComponent::get_CompAlternatives"
        #
        # parray array_CompBaseDir
        #
    set directory    [lindex [array get array_CompDir $key] 1]
        # set directory    [lindex [array get ::APPL_CompLocation $key ] 1 ]
            # puts "          ... directory  $directory"
    if {$directory == {}} {
                # tk_messageBox -message "no directory"
        puts "    -- <E> -------------------------------"
        puts "         ... no directory configured for"
        puts "               $key"
            # parray ::APPL_CompLocation
        puts "    -- <E> -------------------------------"
        return {}
    }
    
    # puts "       \$directory $directory"
    foreach arrayKey [array names array_CompBaseDir] {
        set keyDir  [lindex [array get array_CompBaseDir $arrayKey] 1]
        # puts [format {            %-8s %s} ${arrayKey}: $keyDir]
    }
        #
    set listAlternative {}
        #
    foreach arrayKey [array names array_CompBaseDir] {
        set keyDir  [lindex [array get array_CompBaseDir $arrayKey] 1]
        set compDir [file join $keyDir $directory]
        # puts [format {            %-8s %s} $arrayKey: $compDir]
            #
        if {![file exist $compDir]} continue   
            #
        if {[catch {glob -directory $compDir  *.svg} fileList]} {
            set fileList {}
        } else {
            foreach file [lsort $fileList] {
                    # puts "     ... fileList: $file"
                    # set mapString $array_CompBaseDir(etc)
                    # set mapString [file normalize $::APPL_Config(COMPONENT_Dir)]
                    # puts "                 : $mapString/"
                set fileString [ string map [list $keyDir/ ${arrayKey}:] $file ]
                # puts "                      $fileString <- $file"
                lappend listAlternative $fileString
            }
        }
    }

        #
        # ------------------------
        #     report all alternative components
    foreach comp $listAlternative {
        # puts "                  -> $comp"
    }           
        
        #
    return $listAlternative
        #
}       
    
    
    


    #-------------------------------------------------------------------------
    # get Component
proc bikeComponent::get_ListBoxValues {} {    
        #
    variable initRoot
        #
    dict create dict_ListBoxValues {} 
        # variable valueRegistry
        # array set valueRegistry      {}
        #
    set optionNode    [$initRoot selectNodes /root/Options]
    foreach childNode [$optionNode childNodes ] {
        if {[$childNode nodeType] == {ELEMENT_NODE}} {
                # puts "    init_ListBoxValues -> [$childNode nodeName]"
            set childNode_Name [$childNode nodeName]
                # puts "    init_ListBoxValues -> $childNode_Name"
                #
                # set valueRegistry($childNode_Name) {}
            set nodeList {}
                #
            foreach child_childNode [$childNode childNodes ] {
                if {[$child_childNode nodeType] == {ELEMENT_NODE}} {
                      # puts "    ->$childNode_Name<"
                    switch -exact -- $childNode_Name {
                        {Rim} {
                                  # puts "    init_ListBoxValues (Rim) ->   $childNode_Name -> [$child_childNode nodeName]"
                                set value_01 [$child_childNode getAttribute inch     {}]
                                set value_02 [$child_childNode getAttribute metric   {}]
                                set value_03 [$child_childNode getAttribute standard {}]
                                if {$value_01 == {}} {
                                    set value {-----------------}
                                } else {
                                    set value [format "%s ; %s %s" $value_02 $value_01 $value_03]
                                      # puts "   -> $value   <-> $value_02 $value_01 $value_03"
                                }
                                    # lappend valueRegistry($childNode_Name)  $value
                                lappend nodeList                        $value
                            }
                        {ComponentLocation} {}
                        default {
                                    # puts "    init_ListBoxValues (default) -> $childNode_Name -> [$child_childNode nodeName]"
                                if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                                    # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                                lappend nodeList                        [$child_childNode nodeName]
                            }
                    }
                }
            }
            dict append dict_ListBoxValues $childNode_Name $nodeList
            
        }
    }
        #
        # puts "---"  
        #
    set forkNode        [$initRoot selectNodes /root/Fork]
    set childNode_Name  [$forkNode nodeName]
        # set valueRegistry($childNode_Name) {}
    set nodeList {}
    foreach child_childNode [$forkNode childNodes ] {
        if {[$childNode nodeType] == {ELEMENT_NODE}} {            
                        # puts "    init_ListBoxValues -> $childNode_Name -> [$child_childNode nodeName]"
                    if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                        # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                    lappend nodeList                        [$child_childNode nodeName]
        }
    }
    dict append dict_ListBoxValues $childNode_Name $nodeList        
        #
      
        # 
        # exit          
        # parray valueRegistry
    # project::pdict $dict_ListBoxValues
        # exit
        #
    return $dict_ListBoxValues
        #
}    

    
    #-------------------------------------------------------------------------
    #  check mathValue
proc bikeComponent::__check_mathValue {value} {
            #
        puts "                  <1> bikeComponent::__check_mathValue $value"    
            # --- set new Value
        set newValue [ string map {, .} $value]
            # --- check Value --- ";" ... like in APPL_RimList
        if {[llength [split $newValue  ]] > 1} return {}
        if {[llength [split $newValue ;]] > 1} return {}
            #
        if { [catch { set newValue [expr {1.0 * $newValue}] } errorID] } {
            puts "\n                <E> bikeComponent::__check_mathValue"
            foreach line [split ${errorID} \n] {
                puts "           $line"
            }
            # puts ""
            return {}
        }
            #
            #
        set newValue [format "%.3f" $newValue]
            #
        puts "                  <2> bikeComponent::__check_mathValue $value  ->  $newValue"
            #
        return $newValue
            #
}
    
    
    #-------------------------------------------------------------------------
    # format list to x,y x,y x,y ...
proc bikeComponent::__format_PointList {pointList} {
    set _pointList {}
    foreach {x y} $pointList {
        lappend _pointList   "$x,$y"
    }
    return $_pointList
}
    #-------------------------------------------------------------------------
    # mirror about x-axis
proc bikeComponent::__coords_flip_y {coordlist} {
        set returnList {}
        foreach {x y} $coordlist {
            set new_y [expr {-$y}]
            set returnList [lappend returnList $x $new_y]
        }
        return $returnList
}    
    
    
    
    #
    #
    #-------------------------------------------------------------------------
    # report
proc bikeComponent::report_Settings {} {
        #
    variable array_Component
    variable array_CompObject
        #
        
        #
    puts "\n\n --- array_CompObject ---\n"
    parray array_CompObject
        #
    puts "\n  -- CrankSet"
    $array_CompObject(CrankSet) reportValues
        # parray CrankSet::Config
        # parray CrankSet::Scalar
        # parray CrankSet::ListValue
        #
    puts "          CrankSet Config    SpyderArmCount       -> [get_Config      CrankSet    SpyderArmCount     ]"
    puts "          CrankSet Scalar    ArmWidth             -> [get_Scalar      CrankSet    ArmWidth           ]"
    puts "          CrankSet Scalar    BottomBracket_Width  -> [get_Scalar      CrankSet    BottomBracket_Width]"
    puts "          CrankSet Scalar    ChainLine            -> [get_Scalar      CrankSet    ChainLine          ]"
    puts "          CrankSet Scalar    ChainRingOffset      -> [get_Scalar      CrankSet    ChainRingOffset    ]"
    puts "          CrankSet Scalar    Length               -> [get_Scalar      CrankSet    Length             ]"
    puts "          CrankSet Scalar    PedalEye             -> [get_Scalar      CrankSet    PedalEye           ]"
    puts "          CrankSet Scalar    Q-Factor             -> [get_Scalar      CrankSet    Q-Factor           ]"
    puts "          CrankSet ListValue ChainRings           -> [get_ListValue   CrankSet    ChainRings         ]"
        #
    puts "\n  -- HeadSet"
    $array_CompObject(HeadSet) reportValues
        # parray HeadSet::Config
        # parray HeadSet::Scalar
        #
    puts "\n  -- FrontFender"
    $array_CompObject(FrontFender) reportValues
        # parray FrontFender::Config
        # parray FrontFender::Scalar
        #
    puts "\n  -- RearFender"
    $array_CompObject(RearFender) reportValues
        # parray RearFender::Config
        # parray RearFender::Scalar
        #
    puts "\n  -- RearHub"
    $array_CompObject(RearHub) reportValues
        # parray RearHub::Config
        # parray RearHub::Scalar
        #
    puts "\n  -- SeatPost"
    $array_CompObject(SeatPost) reportValues
        # parray SeatPost::Config
        # parray SeatPost::Scalar
        #
    puts "\n  -- Stem"
    $array_CompObject(Stem) reportValues
        # parray Stem::Config
        # parray Stem::Scalar
        #
}
    #
    #
    #
    #
proc bikeComponent::evaltree { } {
    set result [list]
    set level [info level]
    incr level -1
    for { set i 1 } { $i <= $level } { incr i 1 } {
        lappend result [lindex [info level $i] 0]
    }
    return $result
}
    #
    #-------------------------------------------------------------------------
    #
    #
proc bikeComponent::__set_UserDir__ {dir} {
    variable    array_CompBaseDir
    array set   array_CompBaseDir   [list User      $dir]
}        
    # set additional Custom directory   cust:	
proc bikeComponent::__set_CustomDir__ {dir} {
    variable    array_CompBaseDir
    array set   array_CompBaseDir   [list Custom    $dir]
}
    #
proc bikeComponent::__set_Strategy__ {objectName {value {}}} {
        #
    puts " bikeComponent::set_Strategy $objectName $value"    
        #
    variable array_CompObject
    variable objectStrategy
        #
    switch -exact $objectName {
        Fork -
        _any_ {
            if {$value ne {}} {
                set objectStrategy(Fork)    $value
                set retValue [$array_CompObject($objectName) setStrategy $value]
                set retValue [$array_CompObject($objectName) getStrategy ]
                puts "$value -> $retValue"
            }
            return $objectStrategy(Fork)
        }
        default {}
    }
        #
}  
    #
proc bikeComponent::__update_Component__ {objectName} {
    # puts "   - bikeComponent::update_Component $objectName -------"
    switch -exact $objectName {    
            __FrontFender__ {   bikeComponent::Fender::update_Front}    
            __RearFender__ {    bikeComponent::Fender::update_Rear }    
            __RearHub__ {       bikeComponent::RearHub::update     }    
            __Stem__ {          bikeComponent::Stem::update        }
            __SeatPost__ {      bikeComponent::SeatPost::update    }    
            __CrankSet_XZ__ {   bikeComponent::CrankSet::update    }    
            __CrankSet_XY__ {   bikeComponent::CrankSet::update    }    
            __HeadSet__ -    
            __HeadSetBottom__ -
            __HeadSetTop__ {    bikeComponent::HeadSet::update     }    
            default {}
    }
}
    #
proc bikeComponent::__update_Component {{objectName {}}} {
        #
    variable array_CompObject
        #
    return    
        #
    if {$objectName eq {}} {
        foreach ___keyName [array names array_CompObject] {
            $array_CompObject($___keyName) update
        }
    } else {
            $array_CompObject($objectName) update
    }
        #
}
    #
