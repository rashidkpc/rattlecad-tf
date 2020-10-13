puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   Tk    
    package require   vectormath    
    package require   appUtil
    
    set angle -360
    while {$angle <= 360} {
        set angle [expr $angle + 5]
        set rad   [expr $angle * $vectormath::CONST_PI/180]
        puts "          $angle - ($rad)"
        set x [expr cos($rad)]
        set y [expr sin($rad)]
        #puts "                  -> $x / $y"
        #set newAngle1 [vectormath::angle {1 0} {0 0} [list $x $y]]
        set newAngle2 [vectormath::localVector_2_Degree  [list $x $y]]
        #puts "                      -> $newAngle1"
        puts "                      -> $newAngle2"
    
    }