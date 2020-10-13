 ##+##########################################################################
 #
 # package: bikeModel    ->    class_AbstractComponent.tcl
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
 #    namespace:  bikeComponent
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


    oo::class create bikeComponent::AbstractComponent {
            #
        # superclass bikeFacade::_compAbstract
            #
        variable packageHomeDir     
        variable array_CompBaseDir
            #
        variable Config 
        variable Scalar 
        variable ListValue
            #
        variable ComponentNode 
        variable Direction 
        variable ListBoxValues 
        variable Polygon 
        variable Polyline 
        variable Position   
        variable Profile
        variable Vector    
            #
            
        
            #
        constructor {} {
                #
            puts "              -> class AbstractComponent"
                #
            variable packageHomeDir     $bikeComponent::packageHomeDir
                #
            variable Config             ; array set Config           {}
            variable Scalar             ; array set Scalar           {}
            variable ListValue          ; array set ListValue        {}
            variable ComponentNode      ; array set ComponentNode    {}
            variable Direction          ; array set Direction        {}
            variable Polyline           ; array set Polyline         {}
            variable Polygon            ; array set Polygon          {}
            variable Position           ; array set Position         {}
            variable Profile            ; array set Profile          {}
            variable Vector             ; array set Vector           {}
                #
            variable svgNode_Default    ; set svgNode_Default   [my readSVGFile [file join $packageHomeDir components default_exception.svg]]
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
        method setValue {arrayName keyName value} {
            variable Config 
            variable ListValue 
            variable Scalar 
                #
            if ![info exists $arrayName] {
                return -code error [my formatError "... $arrayName is not defined"] 
                # return -code error "[info object class [self object]]: setValue  ... $arrayName is not defined"
            }  
                #
            set keyValue [array get $arrayName $keyName]
                # puts "   -> $keyValue"
            if {$keyValue != ""} {
                    # set value [lindex $keyValue 1]
                    # puts "   -> $value"
                switch -exact $arrayName {
                    Scalar  {   
                        return [my _setScalar $keyName $value]
                    }
                    default {   
                        array set $arrayName [list $keyName $value]
                    }
                }    
                    #
                ### my update
                    #
                set keyValue [array get $arrayName $keyName]
                return [lindex $keyValue 1]
            } else {
                return -code error [my formatError "$keyName is not defined"]
                # return -code error "[info object class [self object]]: setValue  ... $keyName is not defined"
            }
                #  
        }
            #
        method _setScalar {keyName value} { 
                #
            variable Scalar
                #
            set formatValue [my _formatScalar $value]
                #
                # --- value is real
            if {$formatValue != {}} {
                array set Scalar [list $keyName $formatValue]
            }
                #
            ### my update    
                #
            set keyValue [array get myScalar $keyName]
            return [lindex $keyValue 1]
                #
        }
            #
        method _formatScalar {value} {
                #
                # --- value is allready real
            if ![catch {expr {1.0 * $value}}] {
                return $value
            }
                # --- value contains , instead of . 
            set _value [string map {, .} $value]
            if ![catch {expr {1.0 * $_value}}] {
                return $_value
            }
                #
                # puts "            <I> $value is not a real-Value"
                #
            return {}
                #
        }
            #
        method checkValue {arrayName keyName} {
            variable BoundingBox
            variable ComponentNode 
            variable Config 
            variable Direction 
            variable ListBoxValues 
            variable ListValue 
            variable Polygon 
            variable Position   
            variable Profile
            variable Scalar 
            variable Vector                   
                #
            set keyValue [array get $arrayName $keyName]
                # puts "   -> $keyValue"
            if {$keyValue != ""} {
                return 1
            } else {
                return 0
            }                
        }
            #
        method getValue {arrayName keyName} {
            variable BoundingBox
            variable ComponentNode 
            variable Config 
            variable Direction 
            variable ListBoxValues 
            variable ListValue 
            variable Polyline 
            variable Polygon 
            variable Position   
            variable Profile
            variable Scalar 
            variable Vector                   
                #
            set keyValue [array get $arrayName $keyName]
                # puts "   -> $keyValue"
            if {$keyValue != ""} {
                    # set value [lindex $keyValue 1]
                    # puts "   -> $value"
                return [lindex $keyValue 1]
            } else {
                return -code error [my formatError "$arrayName $keyName does not exist"] 
            }                
        }
            #
        method readSVGFile {filePath} {
                #
            variable svgNode_Default
                #
            if [file exist $filePath] {
                set fp      [open $filePath]   
                fconfigure  $fp -encoding utf-8
                set xml     [read $fp]
                close       $fp
                set doc     [dom parse  $xml]
                set root    [$doc documentElement]
                return $root
            } else {
                return $svgNode_Default
                # return -code error [my formatError "readSVGFile $filePath ... does not exist"] 
                # return -code error [returnError "[self class] ... called from [info object class [self object]]: readSVGFile: >$filePath< ... does not exist"
            }
        }
            #
        method getComponentPath {objectName key} {
                #
            set componentPath       [bikeComponent::get_ComponentPath $objectName $key]
            return $componentPath 
                #
        }
           #
        method format_PointList {pointList} {
            set _pointList {}
            foreach {x y} $pointList {
                lappend _pointList   "$x,$y"
            }
            return $_pointList
        }            
            #
        method coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr {-$y}]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
        }    
            #
        method reportValues {} {
                #
            foreach arrayName   [lsort [info object vars   [self]]] {
                variable $arrayName
                if {[array size $arrayName] > 0} {
                    puts "\n     --- $arrayName --------"
                    foreach arrayKey [lsort [array names $arrayName]] {
                        lassign [array get $arrayName $arrayKey]  key value
                            # foreach {key value} [array get $arrayName $arrayKey] break
                        puts "          -> [format {%-25s ... %s}  $key $value]"
                    }
                }
            }
        }
            #
        method formatError {{errorMsg {}} args} {
                #
            variable objectName
                #
            set errorText {}
                #
            append errorText "name of method:   [lindex [info level 0] end]\n"
            append errorText "owning class:     [self class]\n"
            append errorText "calling object:   [info object class [self object]] ([self object])\n"
                #
            if [info exist objectName] {
                append errorText "  objectName:     $objectName\n"
            }
                #
            append errorText "-------------------------\n"
            append errorText "  [info level 0]\n"
            append errorText "-------------------------\n"
            append errorText "errorMsg:         $errorMsg\n"
            append errorText "-------------------------\n"
            append errorText "arguments:\n"
            foreach arg $args {
                append errorText "$arg\n"
            }
                #
            puts "\n"    
            puts "<E>\n<E>\n<E> ===  E R R O R  ====================================\n<E>"    
                #
            puts "<E>\n<E> ---  Report Error  -------------------------\n<E>"
            puts "<E>"
                #
            foreach line [split $errorText \n] {
                puts "      $line"
            }
                #
            puts "<E>\n<E> ---  Report Variables  ---------------------\n<E>"    
                #
            my reportValues
                #
            puts ""
            puts "<E>\n<E>\n<E> ===  E R R O R  ====================================\n<E>\n"    
                #
            return "$errorText"
                #
        }
            #
    }



