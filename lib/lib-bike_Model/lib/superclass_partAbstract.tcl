 ##+##########################################################################
 #
 # package: bikeModel    ->    superclass_partAbstract.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/19
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
 #    namespace:  bikeModel
 # ---------------------------------------------------------------------------
 #
 # http://www.magicsplat.com/articles/oo.html
 #
 #
 # 0.00 - 20160417
 #      ... new: rattleCAD - 3.4.03
 #
 #
 #


oo::class create bikeModel::_partAbstract {
        #
    variable myComponentNode 
    variable myConfig 
    variable myDirection 
    variable myListBoxValues 
    variable myListValue 
    variable myPolygon 
    variable myPolyline 
    variable myPosition   
    variable myProfile
    variable myScalar 
    variable myVector    
        #
    
        #
    constructor {} {
            #
        puts "              -> class compObject"
            #
        variable myBoundingBox      ; array set myBoundingBox      {}
        variable myComponentNode    ; array set myComponentNode    {}
        variable myConfig           ; array set myConfig           {}
        variable myDirection        ; array set myDirection        {}
        variable myListBoxValues    ; array set myListBoxValues    {}
        variable myListValue        ; array set myListValue        {}
        variable myPolygon          ; array set myPolygon          {}
        variable myPolyline         ; array set myPolyline         {}
        variable myPosition         ; array set myPosition         {}
        variable myProfile          ; array set myProfile          {}
        variable myScalar           ; array set myScalar           {}
        variable myVector           ; array set myVector           {}
            #
    }
        #
    destructor { 
        puts "            [self] destroy"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... [info object class [self]]  $target_method $args  ... unknown"
        return -code error " '[info object class [self]]' $target_method $args  ... unknown"
    }
        #
    method update {} {}    
        #
    method initCompValue {arrayName arrayKey value} {
            #
            # internal use only
            #
        variable myBoundingBox
        variable myComponentNode 
        variable myConfig 
        variable myDirection 
        variable myListBoxValues 
        variable myListValue 
        variable myPolygon 
        variable myPolyline 
        variable myPosition 
        variable myProfile 
        variable myScalar 
        variable myVector                   
            #
            # puts "     .... $arrayName"
        set _arrayName [format {my%s} $arrayName]
        array set $_arrayName [list $arrayKey $value]
            #
            # parray ${_arrayName}
    }
        #
    method setValue {arrayName keyName value} {
        variable myBoundingBox
        variable myComponentNode 
        variable myConfig 
        variable myDirection 
        variable myListBoxValues 
        variable myListValue 
        variable myPolygon 
        variable myPolyline 
        variable myPosition   
        variable myProfile
        variable myScalar 
        variable myVector                   
            #
        set _arrayName [format {my%s} $arrayName]    
            #
        if ![info exists $_arrayName] {
            return -code error "[info object class [self object]]: setValue  ... $arrayName is not defined"
        }  
            #
        set keyValue [array get $_arrayName $keyName]
            # puts "   -> $keyValue"
        if {$keyValue != ""} {
                # set value [lindex $keyValue 1]
                # puts "   -> $value"
            switch -exact $arrayName {
                Scalar  {   return  [my _setScalar $keyName $value]}
                default {   array set $_arrayName [list $keyName $value]}
            }    
                #
                # my update
                #
            set keyValue [array get $_arrayName $keyName]
            return [lindex $keyValue 1]
        } else {
            return -code error "[info object class [self object]]: setValue  ... $keyName is not defined"
        }
            #  
    }
        #
    method _setScalar {keyName value} { 
            #
        variable myScalar
            #
        set formatValue [my _formatScalar $value]
            #
            # --- value is real
        if {$formatValue != {}} {
            array set myScalar [list $keyName $formatValue]
        }
            #
        set keyValue [array get myScalar $keyName]
        return [lindex $keyValue 1]
            #
    }
        #
    method getValue {arrayName keyName} {
        variable myBoundingBox
        variable myComponentNode 
        variable myConfig 
        variable myDirection 
        variable myListBoxValues 
        variable myListValue 
        variable myPolygon 
        variable myPolyline 
        variable myPosition   
        variable myProfile
        variable myScalar 
        variable myVector                   
            #
        set _arrayName [format {my%s} $arrayName]    
            #
        set keyValue [array get $_arrayName $keyName]
            # puts "   -> $keyValue"
        if {$keyValue != ""} {
                # set value [lindex $keyValue 1]
                # puts "   -> $value"
            return [lindex $keyValue 1]
        } else {
            return -code error "[info object class [self object]]: getValue  ... $arrayName $keyName does not exist"
        }                
    }
        #
    method _formatScalar {value} {
            #
            # --- value is allready real
        if ![catch {expr 1.0 * $value}] {
            return $value
        }
            # --- value contains , instead of . 
        set _value [string map {, .} $value]
        if ![catch {expr 1.0 * $_value}] {
            return $_value
        }
            #
        # puts "                          <W> _formatScalar: is not a real-Value: $value "
            #
        return {}
            #
    }
        #
    method reportValues {} {
            #
        foreach arrayName   [lsort [info object vars   [self]]] {
            variable $arrayName
            if {[array size $arrayName] > 0} {
                puts "\n     --- $arrayName --------"
                foreach arrayKey [lsort [array names $arrayName]] {
                    lassign [array get $arrayName $arrayKey]    key value
                        # foreach {key value} [array get $arrayName $arrayKey] break
                    puts "          -> [format {%-25s ... %s}  $key $value]"
                }
            }
        }
    }
        #
}



