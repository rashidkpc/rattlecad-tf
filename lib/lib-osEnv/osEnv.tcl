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
 
 #
 # 0.9  2015-03-24  debug: open_by_mimeType_DefaultApp for https://
 #
 # 0.10 2015-04-28  
 #          refactor osEnv::_find_ghostscriptExec
 #
 # 0.11 2015-04-29  
 #          refactor osEnv::find_ghostscriptExec, handle 32/64 bit Windows
 #
 # 0.12 2018-01-31  
 #          debug:   osEnv::_init_os_env
 #                   osEnv:_dom_add_nameValue
 #                       ... format values with ""
 #                       ... except [0-9] as first character of a nodeName 
 #                           by adding "_" at the beginning
 #
 #
 
 
  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################

package provide osEnv 0.12

namespace eval osEnv {
  
    # --------------------------------------------
        # initial package definition
    package require tdom
    catch {package require registry}
 
    # --------------------------------------------
        # Export as global command
    variable packageHomeDir [file dirname [file normalize [info script]]]
    
    #-------------------------------------------------------------------------
        #  definitions of template Documents
    variable registryDOM 

    # --------------------------------------------
        # get report Template
    set fp [open [file join $packageHomeDir etc initTemplate.xml] ]
    fconfigure      $fp -encoding utf-8
    set registryXML [read $fp]
    close           $fp          
    set registryDoc [dom parse $registryXML]
    set registryDOM [$registryDoc documentElement]     
}


    # --------------------------------------------
    #  create base config 
    #       -> registryDOM
proc osEnv::init_osEnv {} {                   
    variable registryDOM
    
    _init_tcl_info
    _init_tcl_platform 
    _init_os_env 
    
    # _init_os_mimeType
    # _init_os_executable
    
    return $registryDOM               
}


    # --------------------------------------------
    #  register mime-types per name 
    #       -> registryDOM
proc osEnv::register_mimeType {mimeType executable} {
    variable registryDOM
    set nodeName mime
    _register_Executable $nodeName $mimeType $executable
}


    # --------------------------------------------
    #  register executables per name 
    #       -> registryDOM
proc osEnv::register_Executable {execName executable} {
    variable registryDOM
    set nodeName exec
    _register_Executable $nodeName $execName $executable
}


    # --------------------------------------------
    #  get application per extension type 
    #       <- registryDOM
proc osEnv::get_mimeType_DefaultApp {fileExtension} {
    variable registryDOM
    set node [$registryDOM selectNode /root/os/mime]
    set extNode [lindex [$node find name $fileExtension] 0]
    if {$extNode != {}} {
        set defaultApp [file nativename [$extNode asText]]
        # set defaultApp [string trim $defaultApp \" ]
        return $defaultApp
    } else {
        puts "            <E> no entry found for $fileExtension"
        return {}
    }          
}


    # --------------------------------------------
    #  get application per name 
    #       <- registryDOM
proc osEnv::get_Executable {executable} {
        #
    variable registryDOM
        #
    set node [$registryDOM selectNode /root/os/exec]
    set extNode [lindex [$node find name $executable] 0]
    if {$extNode != {}} {
        set thisApp [file nativename [$extNode asText]]
        # set thisApp [string trim $thisApp \" ]
        return $thisApp
    } else {
        puts "      <E> no entry found for $executable"
        return {}
    }          
}


    # --------------------------------------------
    #  find executables per file-extension  
    #       -> Windows registry
proc osEnv::find_mimeType_Application {fileExtension} {
      #    http://wiki.tcl.tk/557
      # puts "\n"
      # puts  "         get_Application: $fileExtension"
      # puts  "       ---------------------------------------------"
      # puts  "               tcl_version   [info tclversion]"
      # puts  "               tcl_platform  $::tcl_platform(platform)"

    set appCmd {} ;# set as default
    switch -exact $::tcl_platform(platform) {
        "windows" {
            set root HKEY_CLASSES_ROOT

                # Get the application key for HTML files
            set appKey {}
            catch {set appKey [registry get $root\\$fileExtension ""]}
            if {$appKey == {}} {
                return {}
            }
                # puts  "               appKey  $appKey"

            set appCmd   {}
            set fileType {}
            catch { set appCmd   [registry get $root\\$appKey\\shell\\open\\command ""] }
            if {$appCmd == {}} {
                catch { set appCmd   [registry get $root\\$appKey\\shell\\open\\command ""] }
                if {$appCmd == {}} {
                    catch { set appCmd   [registry get $root\\$appKey\\shell\\edit\\command ""] }
                }
            }
              # puts "     -> \$appCmd   $appCmd"
              # puts "     -> \$fileType $fileType"

                
                # Get the command for opening HTML files
            if { $appCmd == {} } {
                puts  "         --<E>----------------------------------------------------"
                puts  "           <E> File Type: $fileExtension"
                puts  "           <E> could not find a registered COMMAND for this appKey"
                puts  "         --<E>----------------------------------------------------"
                return
            }
                # puts  "               appCmd  $appCmd"
                # set appArgs           [lrange $appCmd 1 end]
            if {[catch {set appCmd [lindex [string map {\\ \\\\} $appCmd] 0]} eID]} {
                set appCmd {}
            }
                #
            # puts "               [format {%-5s ... %s} $fileExtension $appCmd]"
                #
        }
        default {}
    }
    return "$appCmd"
}


    # --------------------------------------------
    #  find executable of ghostscript 
    #       <- Windows registry
proc osEnv::find_ghostscriptExec {{bitVersion {}}} {
        #
    switch -exact $bitVersion {
        32 -
        64 {    
            set bitVersionList $bitVersion
        }
        default {
            set bitVersionList {64 32}
        }
    }
        #
    set execList {}
        #
    foreach bitVersion $bitVersionList {
            #
        set gs_bitVersions [osEnv::_find_ghostscriptExec $bitVersion]
            #
        foreach gsExec $gs_bitVersions {
            lappend execList $gsExec 
        }
    }
        #
    foreach gsExec $execList {
        # puts "    -> $gsExec"
    }
        #
    set gsExec [lindex $execList 0]
        #
    return $gsExec    
        #
}


    # --------------------------------------------
    #  find executables per name  
    #       -> Unix PATH
proc osEnv::find_OS_Application {appName} {
    set appCmd {} ;# set as default
    switch -exact $::tcl_platform(platform) {
        unix {
                catch {set appCmd [exec which $appName]}
         }
        default {}      
    }
    return "$appCmd"
}


    # --------------------------------------------
    #  opens executables per mime-type  
    #       <- get_mimeType_DefaultApp
proc osEnv::open_by_mimeType_DefaultApp {fileName {altExtension {}}} {

    set fileExtension   [file extension $fileName]
        #
    if {$altExtension  != {}} {
        set fileExtension  $altExtension
    }
        #
    puts "\n"
    puts  "   -------------------------------"
    puts  "    osEnv::open_by_mimeType_DefaultApp:  $fileExtension ($altExtension)"       
    puts  "        fileName        $fileName"


                    # -- handle on file extension
        #
    if {![file exists $fileName]} {
        switch -glob $fileName {
            "https://*" -
            "http://*" {
                if {$fileExtension == {}} {set fileExtension .html}
            }
            default {
                puts  ""
                puts  "            --<E>----------------------------------------------------"
                puts  "              <E> File : $fileName"
                puts  "              <E>      ... does not exist! "
                puts  "            --<E>----------------------------------------------------"
                return
            }
        }
    }
        #
    set fileApplication     [osEnv::get_mimeType_DefaultApp $fileExtension]
        #
    if {$fileApplication == {}} {
        puts  ""
        puts  "            --<E>----------------------------------------------------"
        puts  "              <E> File : $fileName"
        puts  "              <E>      ... could not get default Application! "
        puts  "            --<E>----------------------------------------------------"
        return 1
    } else {
        set fileApplication     [format "\"%s\"" [osEnv::get_mimeType_DefaultApp $fileExtension]]
    }
      
    switch $fileExtension {
        {.htm} -
        {.html} { 
            if {[file exists $fileName]} {
                # ... is a local file
                set fileName        "file:///$fileName"
            }
        }
        default {}
    }

    puts  ""
    puts  "        fileExtension   $fileExtension"
    puts  "        fileApplication $fileApplication"


        # ---------------------
        # replace %1 by fileName
    proc os_format { cmdString substString } {
            # puts " --------------"
            # puts "        \$cmdString    >$cmdString<"
            # puts "        \$pattern      >$pattern<"
            # puts "        \$substString  >$substString<"
            # puts " --------------"
            # puts " [ string map [ list $pattern $substString ] $cmdString ]"
         switch -exact $::tcl_platform(platform) {
            "windows" { 
                set cmdString    [ string map [ list %1 $substString ] $cmdString ]
                return $cmdString
            }
            default {
                return $cmdString
            }
        }
    }

        # ---------------------
        # Substitute the HTML filename into the
        # command for %1
    set commandString [ os_format $fileApplication $fileName ]
    if {$commandString == $fileApplication} {
        set commandString "$fileApplication  $fileName"
    }

        # ---------------------
        # Double up the backslashes for eval (below)
    puts ""
    puts "        ... $commandString "

        # ---------------------
        # Double up the backslashes for eval (below)
    regsub -all {\\} $commandString  {\\\\} commandString

        # ---------------------
        # Invoke the command
    eval exec $commandString &

        # ---------------------
        # done ...
    puts  ""
    puts  "                    ... done"
    return
}

