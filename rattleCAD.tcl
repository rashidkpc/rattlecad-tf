#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

 #
 # rattleCAD.tcl
 #
 # rattleCAD is software for bicycle frame builders
 # rattleCAD provides a fully parametric bicycle model inside and guides you through the 
 # design process by configure the base geometry before refining the bicycle frame itself. 
 # Based on this refinement rattleCAD creates workshop drawings including the main miters 
 # of round tubes and settings for d0erent frame jigs. 
 #
 # rattleCAD is hosted on sourceforge.net http://rattlecad.sourceforge.net/
 # 
 #
 # Copyright (2017) by Manfred ROSENBERGER  (manfred.rosenberger@gmx.net)
 #    
 # See the file "licence.terms" for information on usage and redistribution
 # of this file, and for a DISCLAIMER OF ALL WARRANTIES. 
 #
 

  ###########################################################################
  #
  #                 I  -  N  -  I  -  T                        -  Application
  #
  ###########################################################################

    puts "\n\n ====== I N I T ============================ \n\n"
        
        # -- ::APPL_Config(BASE_Dir)  ------
        #
    set BASE_Dir  [file normalize $::argv0]
  
        # -- redefine on Starkit  -----
        #         exception for starkit compilation
        #        .../rattleCAD.exe
        #        .../rattleCAD.exe
    set APPL_Type       [file tail $::argv0]    
    switch -glob -- $APPL_Type {
        {rattleCAD*.kit}   { }    
        {main.tcl} -    
        default           {
           set BASE_Dir  [file dirname $BASE_Dir]
        }
    }


        # -- Libraries  ---------------
        #
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir lib lib-tcllib]
    lappend auto_path           [file join [file dirname $BASE_Dir] __ext_Libraries]

        # puts "  \$auto_path  $auto_path"
    
    
        # -- Packages  ----------------
        #
    package     require myGUI               0.01
        #
    catch {
            # tcl package for windows only
        package require registry            1.1
    }    

    
    proc redef_puts {{stdoutFile {}}} {
            # http://wiki.tcl.tk/8502
            #
        puts "    -> redef_puts"
            #
        return
            #
        if ![llength [info command ::tcl::puts]] {
                #
            rename puts ::tcl::puts
                #
                #
            if {$stdoutFile eq {}} {    
                    #
                    # -- the default implementation
                proc puts args {
                        #
                    set la [llength $args]
                    if {$la<1 || $la>3} {
                        error "usage: puts ?-nonewline? ?channel? string"
                    }
                    set nl \n
                    if {[lindex $args 0]=="-nonewline"} {
                        set nl ""
                        set args [lrange $args 1 end]
                    }
                    if {[llength $args]==1} {
                        set args [list stdout [join $args]] ;
                    }
                        #
                    foreach {channel s} $args break
                    switch -exact $channel {
                        "stdout" -
                        "stderr" {
                                    set cmd ::tcl::puts
                                    if {$nl==""} {lappend cmd -nonewline}
                                    lappend cmd $channel $s
                                    # We do not want to report errors writing to
                                    # stdout
                                    catch {eval $cmd}                        
                                }
                        default {
                                set cmd ::tcl::puts
                                if {$nl==""} {lappend cmd -nonewline}
                                lappend cmd $channel $s
                                eval $cmd
                        }
                    }
                }
                    #
            } else {
                    #
                    # -- the exception implementation
                proc puts args {
                        #
                    set la [llength $args]
                    if {$la<1 || $la>3} {
                        error "usage: puts ?-nonewline? ?channel? string"
                    }
                        #
                    set nl \n
                    if {[lindex $args 0]=="-nonewline"} {
                        set nl ""
                        set args [lrange $args 1 end]
                    }
                        #
                    if {[llength $args]==1} {
                        return
                    }
                        #
                    if {[llength $args]==1} {
                        set args [list stdout [join $args]]
                    }
                        #
                    foreach {channel s} $args break
                    switch -exact $channel {
                        "stdout" -
                        "stderr" {
                                    set cmd ::tcl::puts
                                    if {$nl==""} {lappend cmd -nonewline}
                                    lappend cmd $channel $s
                                    # We do not want to report errors writing to
                                    # stdout
                                    catch {eval $cmd}                        
                                }
                        default {
                                set cmd ::tcl::puts
                                if {$nl==""} {lappend cmd -nonewline}
                                lappend cmd $channel $s
                                eval $cmd
                        }
                    }
                        #
                }
                    #
            }    
                # -- that was the default implementation
            if 0 {
                if {$channel=="stdout" || $channel=="stderr"} {
                    set cmd ::tcl::puts
                    if {$nl==""} {lappend cmd -nonewline}
                    lappend cmd $channel $s
                    # We do not want to report errors writing to
                    # stdout
                    catch {eval $cmd}
                } else {
                    set cmd ::tcl::puts
                    if {$nl==""} {lappend cmd -nonewline}
                    lappend cmd $channel $s
                    eval $cmd
                }
            }
        }
    }
    
	# redef_puts null    

    
  ###########################################################################
  #
  #                 R  -  U  -  N  -  T  -  I  -  M  -  E 
  #
  ###########################################################################

        
        #
    puts "-- rattleCAD - $BASE_Dir --"
        #
        #
    if {$argc == 1} {
        myGUI::main $BASE_Dir [lindex $argv 0]
    } else {    
        myGUI::main $BASE_Dir
    }
        #
        #
        
 
    puts "\n\n ====== R U N T I M E ============================ \n\n"

    
    # -- check commandline args --
    if {$argc > 1} {
        set i 0
        array set argValues {}
        while {$i < [llength $argv]} {
            set arg [lindex $argv $i]
            # puts "         ... [string index $arg 0]"
            if {[string index $arg 0] == {-}} {
        	set key $arg
        	set argValues($key) {}
        	incr i
            } else {
                lappend argValues($key) [lindex $argv $i]
                incr i
            }
        }
          # parray argValues
          # puts "\n ... <D>  [array names argValues {-test}]"
	    
	    
        if {[array names argValues {-file}] == {-file}} {
            puts "\n =============================================="    
            puts "      ... CommandLine Argument: -file $argValues(-file)\n"    
            set openFile [lindex $argValues(-file) 0]
            if {$openFile != {}} {
        	puts "          ... $openFile\n"
    	        lib_file::openProject_xml   $openFile
    	    }    
        }
	    
        if {[array names argValues {-test}] == {-test}} {
    	    puts "\n =============================================="    
    	    puts "      ... CommandLine Argument: -test $argValues(-test)\n"    
    	    puts "      ... run some tests\n"    
    	    set testCommands $argValues(-test)
    	    foreach command $testCommands {
    	        puts "\n         ... $command"
	        rattleCAD_Test::controlDemo $command
    	   }
        }

	    
    }
    
        #
    # myGUI::test:::runDemo integrationTest_loopNotebook
        #

    
      # -- run a debug procedure
    # rattleCAD::debug::run_debug

    
    #osEnv::open_fileDefault "E:/manfred/Dateien/rattleCAD/html/index.html"
    #osEnv::open_fileDefault "http://rattlecad.sourceforge.net/"

