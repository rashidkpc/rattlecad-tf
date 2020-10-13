#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}



puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  3.00
    package require   vectormath
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        # -- Dictionary  ------------
    variable projectDict
        
        # -- FAILED - Queries --------
    variable failedQueries; array set failedQueries {}

        # -- sampleFile  -----------
    set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
    set sampleFile  [file join $SAMPLE_Dir __debug_3.4.01.74__01__simplon_phasic_56_sramRed.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74_b.xml]
        # puts "   -> sampleFile: $sampleFile"

         # -- Content  --------------
    puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]
    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp
    set sampleDOC   [dom parse  $xml]
    set sampleDOM   [$sampleDOC documentElement]
        #
        #
        #
    bikeGeometry::init    
        #
        #
    set geometryIF  ::bikeGeometry::IF_OutsideIn
        #
    puts "   -> \$::bikeGeometry::Geometry(HandleBar_Distance)  $::bikeGeometry::Geometry(HandleBar_Distance)"
    puts "   -> \$::bikeGeometry::Position(HandleBar)           $::bikeGeometry::Position(HandleBar)"
    puts "   -> \$::bikeGeometry::Geometry(Stem_Length)         $::bikeGeometry::Geometry(Stem_Length)"
        #
    $geometryIF set_Scalar Geometry HandleBar_Distance 490
        #
    puts "   -> \$::bikeGeometry::Geometry(HandleBar_Distance)  $::bikeGeometry::Geometry(HandleBar_Distance)"
    puts "   -> \$::bikeGeometry::Position(HandleBar)           $::bikeGeometry::Position(HandleBar)"
    puts "   -> \$::bikeGeometry::Geometry(Stem_Length)         $::bikeGeometry::Geometry(Stem_Length)"
        #
    $geometryIF set_Scalar Geometry Stem_Length 120
        #
    puts "   -> \$::bikeGeometry::Geometry(HandleBar_Distance)  $::bikeGeometry::Geometry(HandleBar_Distance)"
    puts "   -> \$::bikeGeometry::Position(HandleBar)           $::bikeGeometry::Position(HandleBar)"
    puts "   -> \$::bikeGeometry::Geometry(Stem_Length)         $::bikeGeometry::Geometry(Stem_Length)"
        #
    set geometryIF  ::bikeGeometry::IF_StackReach
        #
    $geometryIF set_Scalar Geometry Stem_Length 110
        #
    puts "   -> \$::bikeGeometry::Geometry(HandleBar_Distance)  $::bikeGeometry::Geometry(HandleBar_Distance)"
    puts "   -> \$::bikeGeometry::Position(HandleBar)           $::bikeGeometry::Position(HandleBar)"
    puts "   -> \$::bikeGeometry::Geometry(Stem_Length)         $::bikeGeometry::Geometry(Stem_Length)"
        #
    
    