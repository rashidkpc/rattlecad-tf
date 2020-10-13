  
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

  
proc bikeModel::update_Model {projectNode} {
        #
    set structureRoot [init_dataStructure]    
        # puts "[$structureRoot asXML]"
        #
        # puts "[$projectNode asXML]"
        #
    foreach arrayNode [$projectNode childNodes] {
        # this is the arrayName level
        set arrayName   [$arrayNode nodeName]
        # set initObject  [get__Object init  $arrayName]
        set modelObject [get__Object $arrayName]
        foreach typeNode [$arrayNode childNodes] {
            # this is the key level
            set typeName [$typeNode nodeName]
            # puts "   ... [$typeNode nodeName]"
            foreach keyNode [$typeNode childNodes] {
                if {[$keyNode nodeType] == "ELEMENT_NODE"} {
                    set keyName  [$keyNode nodeName]
                    set keyValue {}
                    catch {set keyValue [[$keyNode selectNodes text()] asText]}
                    # puts "           -> $modelObject - ($arrayName) - $typeName $keyName $keyValue"
                    # puts "           -> $initObject / $modelObject - ($arrayName) - $typeName $keyName $keyValue"
                    # $initObject  setValue $typeName $keyName $keyValue
                    $modelObject setValue $typeName $keyName $keyValue
                }
            }
        }
    }
        #
    set TIME_000    [clock milliseconds]
        #
        #
    update_bikeGeometry
        #
    update_from_bikeGeometry
        #
    set TIME_001    [clock milliseconds]
        #
        #
    update_bikeFrame
        #
    update_from_bikeFrame
        #
    set TIME_002    [clock milliseconds]
        #
        #
    update_bikeComponent
        #
    update_bikeComponent_Placements
        #
    update_from_bikeComponent
        #
    set TIME_003    [clock milliseconds]
        #
        #
    puts "       -> \$TIME_000 $TIME_000"    
    puts "       -> \$TIME_001 $TIME_001"    
    puts "       -> \$TIME_002 $TIME_002"    
    puts "       -> \$TIME_003 $TIME_003"    
        #
    puts "    -----------"
        #
    puts "    bikeGeometry:  [format {%0.3f} [expr {0.001 * ($TIME_001 - $TIME_000)}]] seconds"
    puts "    bikeFrame:     [format {%0.3f} [expr {0.001 * ($TIME_002 - $TIME_001)}]] seconds"
    puts "    bikeComponent: [format {%0.3f} [expr {0.001 * ($TIME_003 - $TIME_002)}]] seconds"
        #
    return
        #
}
    #

  
    
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
    #
    #
puts "  -- 60 ---------------------------------------------"  
    #
    # ... done
    #
puts "   ... done"
 


exit
 
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
    
