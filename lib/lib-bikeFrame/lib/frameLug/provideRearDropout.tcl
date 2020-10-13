 ##+##########################################################################
 #
 # package: bikeFrame    ->    classProvideRearDropout.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
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
 #    namespace:  classRearDropout
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


    oo::class create bikeFrame::ProvideRearDropout {
            #
        superclass bikeFrame::AbstractProvidePart
            #
        variable lug_BottomBracket
        variable tube_ChainStay
            #
        constructor {} {
                #
            puts "              -> class ProvideRearDropout"
                #
            variable lug_BottomBracket  [bikeFrame::ProvideBottomBracket    new]
                #
            next
                #
            variable providedObject [bikeFrame::RearDropout new]
                #
            variable Config     ; array set Config {    
                                        Orientation         {Chainstay}
                                    }
            variable Direction;   array set Direction {
                                        Config          {-1.00  1.00}
                                    }
            variable Position   ; array set Position {
                                        Origin          {-1.00  0.00} 
                                    }
            variable Scalar     ; array set Scalar {    
                                        Derailleur_x      10.00
                                        Derailleur_y      25.00
                                        OffsetRotation     0.21
                                        WidthHub         121.55
                                    }
                #
            my update
                #
        }    
            #
        destructor { 
            puts "            [self] destroy"
        }
            #
        method unknown {target_method args} {
            next $target_method $args
        }
            #
        method update {} {
                # method is called by ... my initValues -> next
                #
            variable providedObject
                #
            variable Scalar
            variable Position
            variable Scalar
                #
                # set Scalar(File)               [$providedObject getFile]
                #
            # set Scalar(Derailleur_x)       [$providedObject getScalar Derailleur_x]
            # set Scalar(Derailleur_y)       [$providedObject getScalar Derailleur_y]
                #
            my updateGeometry
                #
        }
            #
        method updateGeometry {} {
                #
            variable lug_BottomBracket
                #
            variable Config
            variable Scalar
            variable Direction
            variable Position
                #
                #
                # -- Derailleur Mount
                #
            set angle(Direction)    [vectormath::localVector_2_Degree $Direction(Config)]
                #
            set vct(Mount)      [list $Scalar(Derailleur_x)  $Scalar(Derailleur_y)]
            set vct(Mount)      [vectormath::rotatePoint   {0 0}  $vct(Mount)   [expr {180 + $angle(Direction)}]]
            set pos(Mount)      [vectormath::addVector     $Position(Origin)    $vct(Mount)]
                #
            set Position(RearDerailleur)    $pos(Mount)
                #
            return    
                #
        }
            #
            #
        method setConfig {keyName value} {
            variable providedObject
            switch -exact $keyName {
                Orientation {
                        my prototype_setConfig    $keyName  $value
                    }
                default {}
            }
            return [my prototype_getConfig $keyName]
        }
            #
        method setScalar {keyName value} {
            variable providedObject
                # puts "\n --- > setScalar $keyName $value\n"
            switch -exact $keyName {
                Derailleur_x -
                Derailleur_y {
                        $providedObject setScalar $keyName $value
                    }
                WidthHub {
                        my prototype_setScalar    $keyName  $value
                    }
                OffsetRotation {
                        my prototype_setScalar    $keyName  $value
                        # puts "\n\n - OffsetRotation -- $value ----"
                        # my prototype_setDirection Config  [vectormath::dirCarthesian [expr 180 - $value]]
                    }
                default {}
            }
            return [my prototype_getScalar $keyName]
        }
            #
        method setDirection {keyName value} {
            my prototype_setDirection $keyName  [vectormath::dirCarthesian $value]
        }    
            #
        method setBottomBracket {object} {
            variable lug_BottomBracket
            set lug_BottomBracket $object
        }
            #
        method getPosition_ChainStay {} {
            variable Position
            return $Position(ChainStay)            
        }
            #
    }
