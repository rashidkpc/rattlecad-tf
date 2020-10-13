 ##+##########################################################################
 #
 # package: bikeModel    ->    classComponent.tcl
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
 #    namespace:  bikeFacade
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


    oo::class create bikeComponent::Component {
            #
        superclass bikeComponent::AbstractComponent
            #
        variable packageHomeDir
            #
            
        constructor {} {
                #
            puts "              -> class compObject"
                #
            next
                #
            variable Config             ; array set Config {
                                                ComponentKey        etc:default_blank.svg
                                            }
            variable Scalar             ; array set Scalar {
                                                Angle                       0.00
                                            }
            variable ListValue          ; array set ListValue {
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XZ                          {}
                                            }                     
            variable Direction          ; array set Direction {
                                                Origin                      0.00
                                            }
            variable Polygon            ; array set Polygon {
                                                XZ                    {0.00 0.00}
                                            }
            variable Polyline           ; array set Polyline {
                                                XZ                    {0.00 0.00}
                                            }
            variable Position           ; array set Position {
                                                Origin                {0.00 0.00}
                                            }
                #
            # puts "                  -> \$packageHomeDir $packageHomeDir"
                # parray array_CompBaseDir
                #                
        }
            #
        method update {} {}
            #
            #
        method setValue {arrayName keyName value} {
                #
            variable Config
            variable Scalar
            variable ListValue
                #
            variable myComponent
                #
            switch -exact $arrayName {
                Config -
                Scalar -
                ListValue {
                        if {[array names $arrayName -exact $keyName] != {}} {
                            $myComponent setValue $arrayName $keyName $value
                            $myComponent update
                            array set $arrayName [list $keyName [$myComponent getValue $arrayName $keyName]]
                                #
                            ### my update
                                #
                        }
                    }
                default {
                
                    }
            }
        }
            #
        method getValue {arrayName keyName} {
                #
            variable Config 
            variable Scalar
            variable ListValue
                #
            variable ComponentNode 
            variable Direction 
            variable Polyline 
            variable Polygon 
            variable Position 
                #
            set keyValue [array get $arrayName $keyName]
                # puts "   -> $keyValue"
            if {$keyValue != ""} {
                    # set value [lindex $keyValue 1]
                    # puts "   -> $value"
                return [lindex $keyValue 1]
            } else {
                return -code error "[info object class [self object]]  getValue  ... $arrayName $keyName does not exist"
            }
                #
        }
                #
        method setPlacement {pos {angle 0}} {
                #
                # position of ForkCrown
                #
            variable Direction   
            variable Position
                #
            set Direction(Origin)   $angle
            set Position(Origin)    $pos
                #
            ### my update
            my update
                #
            return [list $Position(Origin) $Direction(Origin)]
                #
        }
            #
    }