 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classDimensionFactory.tcl
 #
 # ----------------------------------------------------------------------
 #  http://www.magicsplat.com/articles/oo.html
 #  http://stackoverflow.com/questions/24957666/tcloo-variable-scope-with-inheritance-superclass
 # ----------------------------------------------------------------------
 #  namespace:  cadCanvas
 # ----------------------------------------------------------------------
 #
 #  2017/11/26
 #      extracted from the rattleCAD-project (Version 3.4.05)
 #          http://rattlecad.sourceforge.net/
 #          https://sourceforge.net/projects/rattlecad/
 #
 #

    
    #
namespace eval cad4tcl {oo::class create DimensionFactory}
    #
oo::define cad4tcl::DimensionFactory {
        #
    variable _objectList
        #
    constructor {cvObj itemIF args} {
            #
        puts "            -> factory DimensionFactory"
            #
        variable cvObject       $cvObj
        variable ItemInterface  $itemIF
        variable _objectList    {}
            #
    }
        #
    destructor     { 
        puts "            -> [self] ... destroy DimensionFactory"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cadCanvas DimensionFactory $target_method $args  ... unknown"
    }
        #
    method create {type coordList args} {
            #
        variable cvObject
        variable ItemInterface
        variable _objectList
            #
            # puts "       -> $args"     
            # puts "              -> $coordList"    
            #
        set coordList   [cad4tcl::_flattenCoordList  $coordList]
        set args        [cad4tcl::_flattenNestedList $args]
            #
            
            #
            # puts "\n"
            # puts "----------------------------------------------------------------"
            # puts "<I> ... cadCanvas DimensionFactory "
            # puts "              -> $coordList"    
            # puts "              -> $args"    
            #
        switch -exact $type {
            angle { 
                        # puts "    -> $type $args"
                    lassign $args  dist offset colour
                        # foreach {dist offset colour} $args break
                    set myObject [cad4tcl::AngleDimension     new $cvObject  $ItemInterface  $coordList  $dist  $offset  $colour]
                    lappend _objectList $myObject
                    return $myObject
                }
            radius { 
                        # puts "    -> $type $args"
                    lassign $args  dist offset colour
                        # foreach {dist offset colour} $args break
                    set myObject [cad4tcl::RadiusDimension    new $cvObject  $ItemInterface  $coordList  $dist  $offset  $colour]
                    lappend _objectList $myObject
                    return $myObject
                }        
            length { 
                        # puts "    -> $type $args"
                    lassign $args  orient dist offset colour
                        # foreach {orient dist offset colour} $args break
                    set myObject [cad4tcl::LengthDimension    new $cvObject  $ItemInterface  $coordList  $orient  $dist  $offset  $colour]
                    lappend _objectList $myObject
                    return $myObject
                }        
            default {
                    return {}
                }                    
        }    
            #
    }
        #
    method get_memberList {} {
        variable _objectList
        return $_objectList
    }
        #
    method report_memberList {} {
        variable _objectList
        foreach dimObject $_objectList {
            puts "       $dimObject"
        }
        return $_objectList
    }                   
        #
    method delete_Member {} {
        variable _objectList
            #
        set newList {}
        foreach dimObject $_objectList {
            $dimObject destroy
            if [namespace exists $dimObject] {
                lappend newList $dimObject
            }
        }
            #
        set _objectList $newList
            #
        return $_objectList
    }
        #
}
