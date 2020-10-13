  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"

    
        # -- Libraries  ---------------
    lappend auto_path   "$APPL_ROOT_Dir"
    lappend auto_path   [file join $APPL_ROOT_Dir lib]
    lappend auto_path   "$APPL_ROOT_Dir/../myPersist"
        # --eclipse reference
    lappend auto_path   "$APPL_ROOT_Dir/../lib-myPersist"
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   tdom
    package require   bikeModel
    package require   myPersist
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
    
        #
        #
    puts "  -- 00 ---------------------------------------------"   
        #
        # ... source model mapping
    set dictFile    [file join $TEST_Dir ____3.4.05.00_model_xx.pureDict]    
        set fp              [open $dictFile r]
        fconfigure          $fp -encoding utf-8
        set dictData        [read $fp]
        close $fp
        
    puts ""    
    puts "---------------------------"
    
    appUtil::pdict $dictData 2 "  "
    
    puts "---------------------------"
    puts ""    
        
      
        