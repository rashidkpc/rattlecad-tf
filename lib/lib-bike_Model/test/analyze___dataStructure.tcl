  
puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
    set APPL_ROOT_Dir [file dirname $BASE_Dir]
    puts "   \$BASE_Dir ........ $BASE_Dir"
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
    
    package require tdom
    
    set xmlFile [file join $BASE_Dir etc dataStructure_44.xml]

    puts "   \$xmlFile ......... $xmlFile"
    
        set fp              [open $xmlFile]
        fconfigure          $fp -encoding utf-8
        set xmlContent      [read $fp]
        close               $fp
            #
        set sourceDoc       [dom parse $xmlContent]
        set sourceRoot      [$sourceDoc documentElement] 
        
    puts "\n"
    
    puts [$sourceRoot asXML]
    
    foreach node [lsort [$sourceRoot selectNodes */*/*]] {
        set modelXPath  [$node toXPath]
        set modelPath   [string map {/root/ {}} $modelXPath]            
            # puts "$modelPath"
            #
        set myDict [dict create]    
            #
        foreach attrName [$node attributes] {
            set attrValue [$node getAttribute $attrName]
            dict set myDict $attrName $attrValue 
        }
            #
        foreach attrName [$node attributes] {
            set attrValue [dict get $myDict $attrName]
            switch -exact $attrName {
                geometryKey {
                        if {$attrValue ne {}} {
                            set position    [string first / $attrValue]
                            # puts $position
                            set newString_A "[string replace $attrValue $position $position (])"
                            set newString_B "[string map {/ " "} $modelPath]"
                            puts "geometryKey;$newString_A;modelPath;$newString_B;"
                        }
                    }
                default {
                        # puts "          ->  $attrName     <- $attrValue"
                    }
            }
            # $modelNode removeAttribute $attrName
            # dict append nodeDict $attrName $attrValue
            # $modelNode setAttribute $attr $attrValue
        }

        continue
    }    
