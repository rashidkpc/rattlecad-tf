  
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
    set myFrame [bikeFrame::DiamondFrame  new]
        #
        
        #
        #
    bikeModel::add_ComponentDir user [file normalize "C:\\Users\\manfred\\Documents\\rattleCAD\\components"]
        #
    bikeModel::init
        #
        #
        #
    puts "  -- 10 ---------------------------------------------"   
        #
        # ... define a projectFile
    set projectFile [file join $SAMPLE_Dir ____3.4.05.14.xml]
        #set projectFile [file join $SAMPLE_Dir template_offroad_3.5.xml]
        #
        set fp              [open $projectFile]
        fconfigure          $fp -encoding utf-8
        set projetXML       [read $fp]
        close               $fp
            #
        set sourceDoc       [dom parse $projetXML]
        #
        #
        #
    puts "  -- 20 ---------------------------------------------"   
        #
        # ... get bikeModelDoc from a template
        #
    set bikeModelDoc [bikeModel::get_inputModelDocument]
        # puts [$bikeModelDoc asXML]
        #
        #
        #
    puts "  -- 30 ---------------------------------------------"
        #
        # ... init the mappingObject
        #
    set mappingObject      [myPersist::ModelMapping new]        
        #
        #
        #
    puts "  -- 40 ---------------------------------------------"   
        #
        # ... update bikeModelDoc
        #
    $mappingObject update_bikeModel_InputDoc $sourceDoc $bikeModelDoc
        # ... print the updated bikeModelDoc
        # puts [$bikeModelDoc asXML]
        #
        #
        #
    puts "  -- 50 ---------------------------------------------"  
        #
        # ... read $bikeModelDoc, which was updated by the $mappingObject
        #
    bikeModel::read_inputModelDocument $bikeModelDoc
        #
        #
        #
    puts "  -- 50 ---------------------------------------------"  
        #
        # ... do some stuff
        #
        # bikeModel::set__ObjectValue {objectName objType objKey value}
    #puts "[bikeModel::get__ObjectValue RearDropout Position Derailleur]"
    
        #
    proc bikeModel::set_Value_ {objectPath value} {
            #
        variable geometryIF
        variable componentIF
        variable frameObject
            #
            #
        puts ""
        puts "      =========== bikeModel::set_Value ========================"
        puts ""
        puts "              $objectPath $value"
            #
            #
            # ==== objectPath ===================
            #
        foreach {objName objType objKey} [split $objectPath /] break  
        set myObject [get__Object $objName]    
            #
        puts "                  -> $myObject"
            #

            #
            #
        set geometryPath    [get_Mapping Geometry   $objectPath]
        set framePath       [get_Mapping Frame      $objectPath]
        set componentPath   [get_Mapping Component  $objectPath]
            #
        puts "              \$geometryPath ->  $geometryPath"
        puts "              \$framePath ->     $framePath"
        puts "              \$componentPath -> $componentPath"
            #
            #
            # ==== geometryPath =================
            #
            # myValue = 1 ... this value is neither handled in
            #                   $geometryIF nor in
            #                   $componentIF
        set myValue 1    
            #
        if {$geometryPath ne {}} {
                    #
                set myValue 0
                    #
                puts ""
                puts "              handle: $geometryIF "
                puts "                  \$geometryPath  $geometryPath"
                    #
                foreach {_objType _objName _keyName} [split $geometryPath /] break
                switch -exact $_objType {
                    Scalar {
                            set value    [string map {, .} $value]
                            set retValue [$geometryIF set_Scalar    $_objName $_keyName    $value]
                            set retValue [$geometryIF get_Scalar    $_objName $_keyName]
                        }
                    Config {
                            set retValue [$geometryIF set_Config    $_objName $value]
                            set retValue [$geometryIF get_Config    $_objName]                    
                        }
                    ListValue {
                            set retValue [$geometryIF set_ListValue $_objName $value]
                            set retValue [$geometryIF get_ListValue $_objName]                    
                        }
                    default {
                            puts "                   -> $geometryPath ... not registered"
                            return {}
                        }
                }
                puts "                      -> $retValue"
                    #
                update_from_bikeGeometry
                    #
                update_bikeFrame
                    #
                update_from_bikeFrame
                    #
                    # update_bikeComponent
                    #
                    # update_from_bikeComponent
                    #
        } else {
            puts "\n"
            puts "                  set_Value ... geometryPath -> no update ... $objectPath $value"
            puts "\n"
        } 
        
            #
            #
            #
            # ==== framePath ====================
            #
    if 1 {    
        if {$framePath ne {}} {
                    # puts "   ... \$framePath $framePath"
                if 0 {
                    update_bikeFrame
                }
                    #
                foreach {_objName _objType _keyName} [split $framePath /] break
                puts "  $_objName $_objType $_keyName"
                set targetObject    [$frameObject getComponent $_objName]
                puts "   \$_objName $_objName  -> $targetObject"
                            

                switch -exact $_objType {
                    Scalar {
                            set value    [string map {, .} $value]
                            set retValue [$targetObject setScalar    $_keyName    $value]
                            set retValue [$targetObject getScalar    $_keyName]
                        }
                    Config {
                            set retValue [$targetObject setConfig    $_keyName $value]
                            set retValue [$targetObject getConfig    $_keyName]                    
                        }
                    default {
                            puts "                   -> $framePath ... not registered"
                            return {}
                            # error "    <E> bikeModel::set_Value: bikeFrame: $_objName $_objType $_keyName"
                        }
                }
                    #
                $frameObject update
                
                    #
                update_from_bikeFrame
                    #
        }
    }
    if 1 {    
            #
            #
            #
            # ==== componentPath ================
            #
        if {$componentPath ne {}} {
                    #
                set myValue 0
                    #
                foreach {_objName _objType _keyName} [split $componentPath /] break  
                    #
                puts ""
                puts "              handle: $componentIF "
                puts "                  \$componentPath $componentPath -> $_objName $_objType $_keyName"
                    #
                switch -exact $_objType {
                    Scalar {
                            set value    [string map {, .} $value]
                            set retValue [$componentIF set_Scalar       $_objName  $_keyName  $value]
                            set retValue [$componentIF get_Scalar       $_objName  $_keyName]
                        }
                    Config {
                            set retValue [$componentIF set_Config       $_objName  $_keyName  $value]
                            set retValue [$componentIF get_Config       $_objName  $_keyName]                    
                        }
                    ListValue {
                            set retValue [$componentIF set_ListValue    $_objName  $_keyName  $value]
                            set retValue [$componentIF get_ListValue    $_objName  $_keyName]                    
                        }
                    default {
                            puts "                   -> $componentPath ... not registered"
                            return {}
                        }
                }
                    #
                update_from_bikeComponent
                    #
                    # puts "                  \$componentPath $componentPath -> $_objName $_objType $_keyName - $retValue"
                    #
        } else {
            puts "\n"
            puts "                  set_Value ... componentPath -> no update ... $objectPath $value"
            puts "\n"
        } 
            #
            #
            # tk_messageBox -message " handle now: $myValue  \$objectPath $objectPath"
            # foreach {myName myType myKey}  [split $objectPath /] break
            # puts "   -> $myName $myType $myKey"
            #
            #
            # ... neither geometry nor component
            #
        if {$geometryPath eq {} && $framePath eq {} && $componentPath eq {}} {
                # tk_messageBox -message " handle \$objectPath $objectPath"
                # puts "  \$objectPath $objectPath"
                # puts " --- "
            foreach {myName myType myKey}  [split $objectPath /] break
                #
            puts "              handle: myObject  $myName"
            puts "                  ->  $myType $myKey $value"
                #
            set myObject    [get__Object $myName]
            $myObject       setValue $myType $myKey $value
                #
        } else {
            puts "\n"
            puts "                  set_Value ... objectPath -> no update ... $objectPath $value"
            puts "\n"
        }
            #
            #
            #
        if {$objName ne {_View}} {
                #
            update_bikeComponent
                #
            update_bikeComponent_Placements
                #
            update_from_bikeComponent
                #
        }
    }            
            
            #
            #
            # ==== update objects ===============
            #
        set retValue [$myObject getValue $objType $objKey]
        puts ""
        puts "              $objectPath $value"
        puts "              -> $retValue"
        puts "      =========== bikeModel::set_Value ========================"
        puts ""
            #
        return $retValue
            #
    }
        #
        #
        #
        #
    puts "[bikeModel::get__ObjectValue HandleBar    Position    Origin]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HandleBar_Distance]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HeadTube_Angle]"
    puts "[bikeModel::get__ObjectValue Stem         Scalar      Length]"
        #
    bikeModel::set_geometryIF OutsideIn
        #
    bikeModel::set_Value Stem/Scalar/Length 120
    puts "[bikeModel::get__ObjectValue HandleBar    Position    Origin]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HandleBar_Distance]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HeadTube_Angle]"
    puts "[bikeModel::get__ObjectValue Stem         Scalar      Length]"
        #
    bikeModel::set_Value Stem/Scalar/Length 110
        #
        #
    bikeModel::set_geometryIF StackReach
        #
    bikeModel::set_Value Stem/Scalar/Length 120
    puts "   ---  StackReach --- Stem/Scalar/Length 120 ---"
    puts "[bikeModel::get__ObjectValue HandleBar    Position    Origin]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HandleBar_Distance]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HeadTube_Angle]"
    puts "[bikeModel::get__ObjectValue Stem         Scalar      Length]"
        #
    # bikeModel::set_Value Stem/Scalar/Length 110
    # bikeModel::set_Value HeadSet/Scalar/DiameterTop 55
    # bikeModel::set_Value HeadSet/Scalar/DiameterBottom 56
    
    
    exit
        #
        # bikeModel::set_geometryIF
        # 
        #         {Classic}       {set geometryIF     ::bikeGeometry::IF_Classic}
        #         {Lugs}          {set geometryIF     ::bikeGeometry::IF_LugAngles}
        #         {StackReach}    {set geometryIF     ::bikeGeometry::IF_StackReach}
        #         {OutsideIn}