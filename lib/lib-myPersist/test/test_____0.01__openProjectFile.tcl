  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"

    
        # -- Libraries  ---------------
    lappend auto_path   "$APPL_ROOT_Dir"
    lappend auto_path   [file join $APPL_ROOT_Dir lib]

        # -- Packages  ---------------
    package require   tdom
    package require   myPersist

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        #
    set myPersist   [myPersist::Persistence new]
    
        #
    set projectFile [file join $SAMPLE_Dir template_road_3.4.04.xml]   

        #
    set projectDOM  [$myPersist readFile_rattleCAD $projectFile]
    
        #
    puts [$projectDOM asXML]
    
        #
    set node [$projectDOM selectNodes /root/Component/HeadSet]
        #
    puts [$node asXML]