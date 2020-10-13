#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"


 ##+##########################################################################
 #
 # osEnv.tcl
 #
 #   osEnv is software of Manfred ROSENBERGER
 #       based on tclTk and BWidgets and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2013/03/17
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
  

proc osEnv::_init_tcl_info {} {
    variable registryDOM
        #
    set domNode [$registryDOM selectNode tcl]
        #
    puts "\n     ... init_tcl_info" 
      #
    puts "          ... [info library]"
      #
    _dom_add_nameValue $domNode patchlevel  \"[info patchlevel]\"
        # Returns the value of the global variable tcl_patchLevel;
    _dom_add_nameValue $domNode hostname    \"[info hostname]\"
        # Returns the name of the computer on which this invocation is being executed.
    _dom_add_nameValue $domNode library     \"[info library]\"
        # Returns the name of the library directory in which standard Tcl scripts are stored. 
        # This is actually the value of the tcl_library variable and may be changed by setting 
        # tcl_library. See the tclvars manual entry for more information.
        #
        #
    set parentNode  [_dom_add_nameValue $domNode loaded  {}]
        # Returns a list describing all of the packages that have been loaded into interp with the load command.    
    puts "[info loaded]"
    foreach packageDef [info loaded] {
        foreach {library package} $packageDef {
            _dom_add_nameValue $parentNode  $package     \"[file normalize ${library}]\"        
        }
    }    
}


proc osEnv::_init_tcl_platform {} {
    variable registryDOM
        #
    set domNode [$registryDOM selectNode tcl/platform]
        #
    puts "\n     ... init_tcl_platform" 
        #
    foreach key [lsort [array names ::tcl_platform]] {
          # puts "   ... $key  $::env($key)"
        _dom_add_nameValue $domNode $key  \"$::tcl_platform($key)\"
    }
}


proc osEnv::_init_tcl_loaded {} {
        # Returns a list describing all of the packages that have been loaded into interp with the load command.
    variable registryDOM
        #
    set domNode [$registryDOM selectNode tcl/loaded]
        #
    puts "\n     ... _init_tcl_loaded" 
        #
    foreach key [lsort [info loaded]] {
          # puts "   ... $key  $::env($key)"
        _dom_add_nameValue $domNode value \"$key\"
    }
}


proc osEnv::_init_os_env {} {
    variable registryDOM
        #
    set domNode [$registryDOM selectNode os/env]
        #
    puts "\n     ... init_os_env" 
        #
        # test on version 0.12, 2018.01.31
        # _dom_add_nameValue $domNode _3DSMAX_2011_PATH	\"[file normalize "C:\\Program Files\\Autodesk\\3ds Max 2011\\"]\"   
        # _dom_add_nameValue $domNode 3DSMAX_2011_PATH	\"[file normalize "C:\\Program Files\\Autodesk\\3ds Max 2011\\"]\"   
        #
    foreach key [lsort [array names ::env]] {
          # puts "   ... $key  $::env($key)"
        switch -glob -- $key {
            TCLLIBPATH {
                    # puts "  -> got a PATH node: $key"
                    # puts "  $::env($key)"
                    # set dirList [split $::env($key) \;]
                    # puts "[llength $::env($key)]"
                set parentNode  [_dom_add_nameValue $domNode $key  {}]
                foreach dir $::env(TCLLIBPATH) {
                   catch {_dom_add_nameValue $parentNode value  \"[file normalize ${dir}]\"}
                }
            }
            PATHEXT {
                    puts "  -> got a PATHEXT node: $key"
                    puts "       ---> $::env($key)"
                    # set dirList [split $::env($key) \;]
                    # puts "[llength $dirList]"
                set parentNode  [_dom_add_nameValue $domNode $key  {}]
                foreach dir [split $::env($key) \;] {
                   puts "         -> \$dir $dir"
                   _dom_add_nameValue $parentNode value  \"${dir}\"
                }
            }
            *PATH* -
            *Path* {
                    # puts "  -> got a PATH node: $key"
                    # puts "       ---> $::env($key)"
                    # set dirList [split $::env($key) \;]
                    # puts "[llength $dirList]"
                set parentNode  [_dom_add_nameValue $domNode $key  {}]
                foreach dir [split $::env($key) \;] {
                    # puts "         -> \$dir $dir"
                    _dom_add_nameValue $parentNode value  \"[file normalize ${dir}]\"
                }
            }
            default {
                    #    puts "  -> got a node: $key"
                    #    puts "       ---> $::env($key)"
                    _dom_add_nameValue $domNode $key     \"$::env($key)\"
            }
        }  
    }
    # puts "  [$registryDOM asXML]"
    # exit
}


proc osEnv::_init_os_mimeType {} {
        #
    puts "\n   ... init_os_mimeType" 
        #
    _add_ApplMimeType .ps
    _add_ApplMimeType .pdf
    _add_ApplMimeType .html
    _add_ApplMimeType .svg
    _add_ApplMimeType .dxf
    _add_ApplMimeType .jpg
    _add_ApplMimeType .gif
}


proc osEnv::_init_os_executable {} {
        #
    puts "\n   ... init_os_executable" 
        #
    _add_Executable gs         ; # {GPL Ghostscript}
}


proc osEnv::_add_Executable {execName} {
    variable registryDOM
        #
    set domDOC    [$registryDOM ownerDocument]
        # puts "   ->  _add_Executable $execName"   
    switch -exact $execName {
        GhostScript -
        gs {
            set applCmd [_get_ghostscriptExec]
        }
        default {
            set applCmd {}
        }
    }    
        #
    if {$applCmd != {}} {
        set domNode [$registryDOM selectNode os/exec]
            #       
        set domDOC    [$domNode ownerDocument]
        set execNode  [$domDOC createElement exec]
            #
        $execNode setAttribute name $execName
            #
        $domNode appendChild $execNode
            #
        $execNode appendChild [$domDOC createTextNode "$applCmd"] 
            #
        # puts "               [format {%5s ... %s} $execName $applCmd]"
            #
    }
} 


proc osEnv::_get_exec_inPATH {execName} {  
        # puts "   -> osEnv::_get_exec_Application $execName"
    switch -exact $::tcl_platform(platform) {
        "windows" { 
             set dirList [split $::env(PATH) \;]
        }
        default {
             set dirList [split $::env(PATH) \;]
        }
    }
        # -------------
        # puts "  -> $dirList"
        # -------------
    foreach directory $dirList {
        set executable [file join $directory $execName]
            # puts "$executable"
        if {[file executable $executable]} {
            return "$executable"
        }
    }
        #
    return {}
}


proc osEnv::_add_ApplMimeType {mimeType} {
        #
    variable registryDOM
        #
    set domDOC    [$registryDOM ownerDocument]
    set applCmd [find_mimeType_Application $mimeType]
        #
    if {$applCmd != {}} {  
        set domNode  [$registryDOM selectNode os/mime]
            #
        set mimeNode  [$domDOC createElement mime]
            #
        $mimeNode setAttribute name $mimeType
            #
        $domNode appendChild $mimeNode
            #
        $mimeNode appendChild [$domDOC createTextNode "$applCmd"] 
            #
        # puts "               [format {%5s ... %s} $mimeType $applCmd]"
            #
    }   
}


proc osEnv::_dom_add_nameValue {domNode nodeName nodeValue} {
        #
        # puts "-> _dom_add_nameValue $domNode $nodeName $nodeValue"
        # puts "   -> \$nodeName $nodeName"  
        # catch [0-9]
    if ![string match {[A-z]} [string index $nodeName 0]] {
        puts "   -> exception $nodeName"
        set nodeName [format {_%s} $nodeName]
    }
        #
        # catch "(,)"
    set nodeName    [string map {( _ ) _} $nodeName]    
        #
        # catch \"
    if {[string range $nodeValue end-1 end] == {\"}} {
        # puts "----"
        puts "     -> exception $nodeName $nodeValue"
        set nodeValue [format {%s %s} [string range ${nodeValue} 0 end-1] \"]
        # puts "     -> exception $nodeValue"
    }
        #
        # puts "  -> $nodeName \$nodeValue >$nodeValue<"
        # puts ""
        #        
    set domDOC    [$domNode ownerDocument]
    set newNode   [$domDOC createElement $nodeName]
    $domNode appendChild "$newNode"
        #
    if {[llength $nodeValue] == 1} {
        $newNode  appendChild [$domDOC createTextNode $nodeValue] 
    } else {
        foreach arg $nodeValue {
            foreach {name value} $arg break
                # puts "        ... $name / $value"
            set listNode  [$domDOC createElement $name]
            $newNode  appendChild $listNode
            $listNode appendChild [$domDOC createTextNode $value] 
        }
    }
        #
    return $newNode
        #
}


proc osEnv::_register_Executable {nodeName name executable} {
        #
    variable registryDOM
        #
        # puts "         ->  $nodeName   $name   $executable"    
        #
    set domDOC       [$registryDOM ownerDocument]      
    set parentNode   [$registryDOM selectNode /root/os/$nodeName]
    set thisNode     {}
    set thisNode     [lindex [$parentNode find name $name] 0]
        #
    if  {$thisNode != {}} {
        $parentNode removeChild $thisNode
        $thisNode   delete
    }
        #
    set thisNode  [$domDOC  createElement $nodeName]
        #
    $thisNode setAttribute name $name
        #
    $parentNode appendChild $thisNode
        #
    $thisNode appendChild [$domDOC createTextNode "$executable"] 
        # 
    # puts "[$parentNode asXML]"         
        #
}   

