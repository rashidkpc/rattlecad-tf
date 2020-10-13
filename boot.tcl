proc tclInit {} {
    rename tclInit {}

    global auto_path tcl_library tcl_libPath tcl_version tclkit_system_encoding

    set noe $::tcl::kitpath

    # Resolve symlinks
    set noe [file dirname [file normalize [file join $noe __dummy__]]]

    set tcl_library [file join $noe lib tcl$tcl_version]
    set tcl_libPath [list $tcl_library [file join $noe lib]]

    # get rid of a build residue
    unset -nocomplain ::tclDefaultLibrary

    # The following code only gets executed if we don't have our exe
    # already mounted.  This should only happen once per thread.
    # We could use [vfs::filesystem info], but that would require
    # loading vfs into every interp.
    if {![file isdirectory $noe]} {
	load {} vfs

	# lookup and emulate "source" of lib/vfs/{vfs*.tcl,mk4vfs.tcl}
	# must use raw MetaKit calls because VFS is not yet in place

	set d [mk::select exe.dirs parent 0 name lib]
	set d [mk::select exe.dirs parent $d name vfs]

	foreach x {vfsUtils vfslib mk4vfs} {
	    set n [mk::select exe.dirs!$d.files name $x.tcl]
	    set s [mk::get exe.dirs!$d.files!$n contents]
	    catch {set s [zlib decompress $s]}
	    uplevel \#0 $s
	}

	# mount the executable, i.e. make all runtime files available
	vfs::filesystem mount $noe [list ::vfs::mk4::handler exe]

	# alter path to find encodings
	if {$tcl_version > 8.4} {
	    encoding dirs [list [file join [info library] encoding]]
	} else {
	    load {} pwb
	    librarypath [file join [info library] encoding]
	}

	# if the C code passed us a system encoding, apply it here.
	if {[info exists tclkit_system_encoding]} {
	    # It is possible the chosen encoding is unavailable in which case
	    # we will be left with 'identity' to be handled below.
	    catch {encoding system $tclkit_system_encoding}
	    unset tclkit_system_encoding
	}

	# fix system encoding, if it wasn't properly set up (200207.004 bug)
	if {[encoding system] eq "identity"} {
	    switch $::tcl_platform(platform) {
		windows		{ encoding system cp1252 }
		macintosh	{ encoding system macRoman }
		default		{ encoding system iso8859-1 }
	    }
	}

	# now remount the executable with the correct encoding
	vfs::filesystem unmount $noe
	# XXX If we assume that ::tcl::kitpath was set as proper utf-8,
	# XXX then this is OK, otherwise we need to reascertain what the
	# XXX user wanted - this used to be the command 'info nameofexe'
	set noe $::tcl::kitpath

	# Resolve symlinks
	set noe [file dirname [file normalize [file join $noe __dummy__]]]

	set tcl_library [file join $noe lib tcl$tcl_version]
	set tcl_libPath [list $tcl_library [file join $noe lib]]
	vfs::filesystem mount $noe [list ::vfs::mk4::handler exe]
    }

    # load config settings file if present
    namespace eval ::vfs { variable tclkit_version 1 }
    catch { uplevel \#0 [list source [file join $noe config.tcl]] }

    uplevel \#0 [list source [file join $tcl_library init.tcl]]

    # reset auto_path, so that init.tcl's search outside of tclkit is cancelled
    set auto_path $tcl_libPath
}
