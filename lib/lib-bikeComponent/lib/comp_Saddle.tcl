 ##+##########################################################################te
 #
 # package: bikeComponent   ->  comp_Saddle.tcl
 #
 #   bikeComponent is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/09/12
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
 #  namespace:  bikeComponent::Saddle      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::Saddle {

            # <HeadSet>
            #     <Height>
            #         <Bottom>13.50</Bottom>
            #         <Top>15.50</Top>
            #     </Height>
            #     <Diameter>45.00</Diameter>
            # </HeadSet>
            
        superclass bikeComponent::Component
        
            #
        variable packageHomeDir
            #
            
        constructor {} {
                #
            next   
                #
            puts "              -> class Saddle"
                #
            variable Config             ; array set Config {
                                                Style                _any_
                                            }
            variable Scalar             ; array set Scalar {
                                                Height                    45.00                 
                                                Length                   280.00                 
                                                NoseLength               155.00
                                                Offset_X                   5.00
                                            }
                #
            variable Polyline           ; array set Polyline {
                                                XZ_Profile                  {}
                                            }
                #
            variable Position           ; array set Position {
                                                Mount               {0.00 -1.00}
                                                Nose                {1.00  0.00}
                                                Origin              {0.00  0.00}                                                
                                            }             
            variable ComponentNode                    
            variable Direction                
            variable Polygon                
                #
            variable nodeSVG_Empty      ; set nodeSVG_Empty [my readSVGFile [file join $packageHomeDir components default_template.svg]]
                #
            variable myComponent        ; set myComponent   [bikeComponent::ComponentBasic  new Saddle]
                #
            ### my update
                #                            
        }

        method update {} {
                #
            variable myComponent
                #
            variable Config
            variable Scalar
            variable ComponentNode
            variable Polyline
            variable Position
                #
                #
            $myComponent update
                #
            my update_Profile_XZ    
                #
            set ComponentNode(XZ)               [$myComponent getValue ComponentNode    XZ]     
                #
            set Polyline(XZ_Profile)            [vectormath::addVectorCoordList $Position(Origin)   $Polyline(XZ_Profile)]
                #
            set Position(Mount)                 [vectormath::subVector  $Position(Origin)   [list 0 $Scalar(Height)]]
            set Position(Nose)                  [vectormath::addVector  $Position(Origin)   [list [expr {$Scalar(NoseLength) + $Scalar(Offset_X)}] -15]]
                #
        }
            #
        method setValue {arrayName keyName value} {
                #
            variable Config
            variable Scalar
                #
            variable myComponent
                #
            set keyString "$arrayName/$keyName" 
            if {[array names $arrayName -exact $keyName] != {}} {
                switch -exact $keyString {
                    Config/Type -
                    Scalar/Height -
                    Scalar/Length -
                    Scalar/NoseLength -
                    Scalar/Offset_X {
                            array set $arrayName [list $keyName $value]
                            ### my update
                            return
                        }
                    default {}
                }
                switch -exact $arrayName {
                    Config -
                    Scalar -
                    _any_ {
                            $myComponent setValue $arrayName $keyName $value
                            $myComponent update
                            array set $arrayName [list $keyName [$myComponent getValue $arrayName $keyName]]
                                #
                            ### my update
                                #
                        }
                    default {}
                }
            }
        }
            #
        method update_Profile_XZ {} {
                #
            variable Scalar
            variable Polyline
                #
            set x_04   [expr {$Scalar(NoseLength) + $Scalar(Offset_X)}]
            set x_03   [expr {$x_04 -  20}]
            set x_02   [expr {$x_04 -  30}]
            set x_01   [expr {$x_04 - $Scalar(Length)}]
                #
            set polyline {}
            lappend polyline    "$x_01 4.00"
            lappend polyline    "0.00 0.00"
            lappend polyline    "$x_02 -1.00"
            lappend polyline    "$x_03 -5.00"
            lappend polyline    "$x_04 -12.00"
                #
            set Polyline(XZ_Profile)    [appUtil::flatten_nestedList $polyline]
                #
            return
                #
        }
            #
    }
