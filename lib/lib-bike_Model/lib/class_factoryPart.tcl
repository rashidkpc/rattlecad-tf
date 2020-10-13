
 ##+##########################################################################
 #
 # package: bikeModel 	->	class_factoryPart.tcl
 #
 #   bikeModel is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 # ---------------------------------------------------------------------------
 #	namespace:  bikeModel
 # ---------------------------------------------------------------------------
 #
 # http://www.magicsplat.com/articles/oo.html
 # http://stackoverflow.com/questions/24957666/tcloo-variable-scope-with-inheritance-superclass
 #
 
    
    
namespace eval bikeModel {oo::class create compFactory}
    #
oo::define bikeModel::compFactory {
        #
    variable _counter    
    variable _objectList    
    variable _objectDict    
        #
    constructor {} { 
            #
        puts "            -> factory bikeModel::compFactory"
            #
        variable _counter       0
        variable _objectList    {}
        variable _objectDict   ; set _objectDict [dict create]
            #
    }
        #
    destructor     { 
        puts "            -> [self] ... destroy objFactory"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... bikeModel::compFactory $target_method $args  ... unknown"
    }
        #
    method create {{objName {}}} {
            #
        variable _counter
        variable _objectList
        variable _objectDict
            #
        incr _counter
            #
        puts "            -> create: $objName"
            #
        if 0 {
            switch -exact $objName {
                HeadSet_    { set myObject [bikeModel::HeadSet new] }
                Fork_       { set myObject [bikeModel::Fork new] }
                default     { set myObject [bikeModel::PartSimple new] }
            }
        }
            #
        set myObject [bikeModel::PartSimple new]
            #
        lappend _objectList $myObject
        dict set _objectDict $objName $myObject
            #
        return $myObject
            #
    }
        #
    method get_objectList {} {
        variable _objectList
        return $_objectList
    }
        #
    method get_Object {key} {
        variable _objectDict
            #
        if {$key eq ""} {
            error "    <E> bikeModel::compFactory -> object with name: $key does not exist"
        } else {
            set myObject [dict get $_objectDict $key]
            # puts "         get_Object -> $key $myObject"
            return $myObject
        }
    }
        #
    method report_Object {{key {}}} {
        variable _objectDict
        puts "\n ==== report bikeModel::compFactory ====\n"
            #
        if {$key != {}} {
            set myObject [dict get $myDict $key]
            set myDict [list $key $myObject]
        } else {
            set myDict $_objectDict
        }
            #
        foreach objName [lsort [dict keys $myDict]] {
            puts "\n    === object ==< $objName >=="
            set myObject [dict get $myDict $objName]
            $myObject reportValues
        }
    }   
        #
}
