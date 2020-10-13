 ##+##########################################################################te
 #
 # package: bikeComponent   ->  BottleCage.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
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
 #  namespace:  bikeComponent::bareBottleCage      
 # ---------------------------------------------------------------------------
 #
 #

    oo::class create bikeComponent::bareBottleCage {

            # <Stem>
                 #<Angle>-6.00</Angle>
                 #<Length>110.00</Length>
            # </Stem>            
            
        superclass bikeComponent::ComponentBare
        
            #
        variable packageHomeDir
            #

        constructor {orientation} {
                #
            set   objectName    "BottleCage_${orientation}"
            next $objectName
                #
            puts "              -> class ComponentBare: $objectName"
                #

            variable Config             ; array set Config {
                                                Type                Bottle
                                                Orientation         right
                                            }
            variable Scalar             ; array set Scalar {
                                            }
                #
            variable ComponentNode      ; array set ComponentNode {
                                                XZ                  {}
                                            }
            variable Position           ; array set Position {
                                                End                 {64.00 0.00}
                                                Origin              { 0.00 0.00}
                                            }
                #
            set ComponentNode(XZ)       [my readSVGFile [file join $packageHomeDir components default_template.svg]]
            set Config(Orientation)     $orientation
                #
        }

        #-------------------------------------------------------------------------
            #  create custom Stem
            #
        method update {} {
                #
            variable Config
            variable ComponentNode
                #
            set compDoc     [$ComponentNode(XZ) ownerDocument ]
                #
            switch -exact $Config(Orientation) {
                left -
                right  {set orient $Config(Orientation)}
                default {
                        puts "        -> $Config(Orientation) not in right or left"
                        set orient right
                }
            }
                #
            switch -exact $Config(Type) {
                Cage {      set ComponentKey [format {etc:bottleCage/%s/%s} $orient bottleCage.svg]}
                Bottle {    set ComponentKey [format {etc:bottleCage/%s/%s} $orient bottle_Large.svg]}
                BrazeOn {   set ComponentKey [format {etc:bottleCage/%s/%s} $orient brazeOn.svg]}
                off -
                default {   return}           
            }
                #
            $compDoc delete
                #
            set compPath            [my getComponentPath BottleCage $ComponentKey]
            set ComponentNode(XZ)   [my readSVGFile $compPath]
                #
        }
            #
    }
        
        