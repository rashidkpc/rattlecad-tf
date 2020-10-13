  
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

    
    
puts "  -- 00 ---------------------------------------------"   
    #
    # ... initialize
    #
bikeModel::add_ComponentDir user [file normalize "C:\\Users\\manfred\\Documents\\rattleCAD\\components"]
    #
bikeModel::init
    #
    #
    #
puts "  -- 10 ---------------------------------------------"
    #
    # ... init the mappingObject
    #
set mappingObject      [myPersist::ModelMapping new]        
    #
    #
    #
puts "  -- 20 ---------------------------------------------"   
    #
    # ... define a projectFile
    #
set projectFile  [file join $SAMPLE_Dir road_carbon_style_xl.xml]
set projectFile  [file join $SAMPLE_Dir ____3.5.06.xml]
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
puts "  -- 30 ---------------------------------------------"   
    #
    # ... get bikeModelDoc from a template
    #
set bikeModelDoc [bikeModel::get_inputModelDocument]
    # puts [$bikeModelDoc asXML]
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

puts "[bikeModel::get__ObjectValue HandleBar    Position    Origin]"
puts "[bikeModel::get__ObjectValue FrontFender  ComponentNode  XZ]"
puts "[bikeModel::get__ObjectValue RearFender   Scalar      Height]"
puts "[bikeModel::get__ObjectValue RearFender   Scalar      Width]"
    #
set compNode [bikeModel::get__ObjectValue RearFender   ComponentNode  XY]
puts " -> $compNode"
puts "[$compNode asXML]"
    #
set compNode [bikeModel::get__ObjectValue RearFender   ComponentNode  XZ]
puts " -> $compNode"
puts "[$compNode asXML]"
    #

    
    
exit    
    
    set chainStay_01 {   
            ChainStay/Config/Type               bent \
            ChainStay/Scalar/segmentAngle_01      -6.00 \
            ChainStay/Scalar/segmentAngle_02       5.00 \
            ChainStay/Scalar/segmentAngle_03       0.00 \
            ChainStay/Scalar/segmentAngle_04      -2.00 \
            ChainStay/Scalar/segmentLength_01     50.00 \
            ChainStay/Scalar/segmentLength_02    160.00 \
            ChainStay/Scalar/segmentLength_03     47.00 \
            ChainStay/Scalar/segmentLength_04     60.00 \
            ChainStay/Scalar/segmentRadius_01    320.00 \
            ChainStay/Scalar/segmentRadius_02    320.00 \
            ChainStay/Scalar/segmentRadius_03    320.00 \
            ChainStay/Scalar/segmentRadius_04    320.00 \
            Stem/Scalar/Length                   150.00 \
            TopTube/Scalar/Angle                   5.00 \
        }
                
    set chainStay_02 {   
            ChainStay/Config/Type               straight \
            ChainStay/Scalar/segmentAngle_01     -10.00 \
            ChainStay/Scalar/segmentAngle_02       7.00 \
            ChainStay/Scalar/segmentAngle_03       2.00 \
            ChainStay/Scalar/segmentAngle_04      -5.00 \
            ChainStay/Scalar/segmentLength_01     50.00 \
            ChainStay/Scalar/segmentLength_02    160.00 \
            ChainStay/Scalar/segmentLength_03     47.00 \
            ChainStay/Scalar/segmentLength_04     60.00 \
            ChainStay/Scalar/segmentRadius_01    320.00 \
            ChainStay/Scalar/segmentRadius_02    320.00 \
            ChainStay/Scalar/segmentRadius_03    320.00 \
            ChainStay/Scalar/segmentRadius_04    320.00 \
            Stem/Scalar/Length                   150.00 \
            TopTube/Scalar/Angle                   5.00 \
        }

        
    proc bikeModel::set_ValueList__ {parameterList} {
            #
        variable geometryIF
        variable componentIF
        variable frameObject
            #
            #
        puts ""
        puts "      =========== bikeModel::set_ValueList ========================"
        puts ""
            #
        set updateFrame     0
        set parameterDict   {}
            #
            
            
        foreach {objectPath value} $parameterList {
                # puts "              $objectPath  -----> $value"
            set framePath       [get_Mapping Frame      $objectPath]
            if {$framePath ne {}} {
                set updateFrame 1
                    puts "                   -> $objectPath --> $framePath"
                foreach {objectName type keyName} [split $framePath /] break
                    puts "                          $objectName $type $keyName  -> $value"
                dict set parameterDict $objectName $type $keyName $value
            }
        }
            #
        appUtil::pdict $parameterDict 2
            #
        if $updateFrame {
                #
            puts "\n"
            puts "    -> $frameObject setSubset_DICT \$parameterDict"
            puts ""
            $frameObject setSubset_DICT $parameterDict
                #
            $frameObject update
                #
        }
            #
        update_from_bikeFrame
            #
        update_bikeComponent
            #
        update_bikeComponent_Placements
            #
        update_from_bikeComponent
            #
        return
            #
    } 
        #
        
        #
        #
        
        
if 0 {    
        #
    puts "[bikeModel::get__ObjectValue HandleBar    Position    Origin]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HandleBar_Distance]"
    puts "[bikeModel::get__ObjectValue Geometry     Scalar      HeadTube_Angle]"
    puts "[bikeModel::get__ObjectValue Stem         Scalar      Length]"
    puts "[bikeModel::get__ObjectValue ChainStay    Config      Type]"
    puts "[bikeModel::get__ObjectValue ChainStay    Scalar      segmentAngle_01]"
    puts "[bikeModel::get__ObjectValue ChainStay    Scalar      segmentAngle_02]"
        #

    bikeModel::set_ValueList $chainStay_01

    puts "[bikeModel::get__ObjectValue ChainStay    Config      Type]"
    puts "[bikeModel::get__ObjectValue ChainStay    Scalar      segmentAngle_01]"
    puts "[bikeModel::get__ObjectValue ChainStay    Scalar      segmentAngle_02]"
        #
        
    bikeModel::set_ValueList $chainStay_02

    puts "[bikeModel::get__ObjectValue ChainStay    Config      Type]"
    puts "[bikeModel::get__ObjectValue ChainStay    Scalar      segmentAngle_01]"
    puts "[bikeModel::get__ObjectValue ChainStay    Scalar      segmentAngle_02]"
        #
        
    
return    

}

    #
    # bikeModel::set_geometryIF
    # 
    #         {Classic}       {set geometryIF     ::bikeGeometry::IF_Classic}
    #         {Lugs}          {set geometryIF     ::bikeGeometry::IF_LugAngles}
    #         {StackReach}    {set geometryIF     ::bikeGeometry::IF_StackReach}
    #         {OutsideIn}