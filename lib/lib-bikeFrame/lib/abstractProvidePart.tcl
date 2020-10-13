 ##+##########################################################################
 #
 # package: bikeFrame    ->    classAbstractProvidePart.tcl
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
 #    namespace:  bikeFrame
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


oo::class create bikeFrame::AbstractProvidePart {
        #
    variable CenterLine     ;# {x y x y x y ...}        
    variable Config         ;# config Parameter set by
    variable Direction      ;# {x y}
    variable Position       ;# {x y}
    variable Profile        ;# {x y x y x y ...}
    variable Scalar         ;# {x}
        #
    variable providedObject ;# Object of type AbstractComponent, AbstractTube, ...
        #
        #
    constructor {} {
            #
        if {![lindex [self call] 1]} {
            return -code error "class '[info object class [self]]' is abstract"
        }
            #
        puts "              -> superclass AbstractProvidePart"
            #
        variable providedObject
            #
        variable Position;    array set Position    {Origin {0 0}}
        variable Direction;   array set Direction   {Config {1 0}}
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
    method initValues {myDict} {
            #
        my prototype_initValues $myDict
            #
    }
        #
    method update {} {}    
        #
    method _initParameter {} {
            #
        variable _Scalar;     array set _Scalar {
                
        }
            #
    }
        #
    method _getEdgePosition_New {positionName} {
        variable myTube
        variable Position
        if 0 {
            switch -exact $positionName {
                _EdgeTaperStartLeft {   set keyName RefOriginLeft}
                _EdgeOriginLeft {       set keyName EdgeOriginLeft}
                _EdgeOriginRight {      set keyName EdgeOriginRight}
                _EdgeTaperStartRight {  set keyName RefOriginRight }
                _EdgeTaperEndLeft {     set keyName RefEndLeft}
                _EdgeEndLeft {          set keyName EdgeEndLeft}
                _EdgeEndRight {         set keyName EdgeEndRight}
                _EdgeTaperEndRight {    set keyName RefEndRight}
                default {
                    set keyName $positionName
                }
            }
            puts "   -> $positionName -> $keyName"
            puts ""
        }
            #
        set keyName $positionName
        switch -exact $keyName {
            RefOriginLeft -
            EdgeOriginLeft -
            EdgeOriginRight -
            RefOriginRight  -
            RefEndLeft -
            EdgeEndLeft -
            EdgeEndRight -
            RefEndRight {
                    set pos [$myTube getPosition $keyName]
                }
        }
        set pos [vectormath::rotatePoint {0 0} $pos [my getDirection Config degree]]
        set pos [vectormath::addVector   $pos $Position(Origin)]
        return $pos
    }
        #
    method _getEdgePosition {positionName} {
        variable providedObject
        variable Position
        switch -exact $positionName {
            _EdgeEndRight   -
            _EdgeTaperStartRight -
            _EdgeTaperEndRight -
            _EdgeOriginRight -
            _EdgeEndLeft -
            _EdgeTaperStartLeft -
            _EdgeTaperEndLeft -
            _EdgeOriginLeft {
                    set pos [$providedObject getPosition $positionName]
                }
        }
        set pos [vectormath::rotatePoint {0 0} $pos [my getDirection Config degree]]
        set pos [vectormath::addVector   $pos $Position(Origin)]
        return $pos
    }
        #
    method setConfig {keyName value} {
        return [my prototype_setConfig $keyName $value]
    }
        #
    method setDirection {keyName listXY} {
        return [my prototype_setDirection $keyName $listXY]
    }
        #
    method setPosition {keyName listXY} {
        return [my prototype_setPosition $keyName $listXY]
    }
        #
    method setConfig {keyName value} {
        variable providedObject
        if [info exists providedObject] {
            $providedObject setConfig $keyName $value
        }
        return [my prototype_setConfig $keyName $value]
    }
        #
    method setScalar {keyName value} {
        variable providedObject
        if [info exists providedObject] {
            $providedObject setScalar $keyName $value
        }
        return [my prototype_setScalar $keyName $value]
    }
        #
    method getAngle {} {
        variable Config
        return $Config(Angle)
    }       
        #
    method getDictionary {} {
            # puts "\n\n\n --- AbstractProvidePart getDictionary \n"
        variable providedObject
            #
        set myDict  [my prototype_getDictionary]
            #
        # set objDict         [$providedObject getDictionary]
        # set objClassName    [$providedObject getClassName]
        # set keyName         [format {___%s} $objClassName]
            # puts "     -> $objClassName"
            # puts "     -> $keyName"
        # dict append myDict $keyName $objDict
            # appUtil::pdict $myDict 4
            # puts " ---"
        return $myDict
    }
        #
    method getConfig {keyName} {
        return [my prototype_getConfig $keyName]
    }
        #
    method getCenterLine {keyName} {
        return [my prototype_getCenterLine $keyName]
    }
        #
    method getDirection {keyName {type cartesian}} {
        return [my prototype_getDirection $keyName $type]
    }
        #
    method getPosition {keyName} {
        return [my prototype_getPosition $keyName]
    }
        #
    method getPosition_End {} {
        return [my prototype_getPosition End]
    }
        #
    method getPosition_Start {} {
        return [my prototype_getPosition Origin]
    }
        #
    method getProvidedObject {} {
        return [my prototype_getProvidedObject]
    }            
        #
    method getScalar {keyName} {
        return [my prototype_getScalar $keyName]
    }
        #
    method getShapeNew {shapeName} {
            #
        variable providedObject
        variable myTube
        variable Position
            #
        if 0 {
            switch -exact $shapeName {
                xz {
                    set shape [$myTube getView ZY]
                }
                xy {
                    set shape [$myTube getView ZX]
                }
                default {
                    set shape [$myTube getView $shapeName]
                }
            }
            puts "   -> \$shape $shapeName -> $shape"
                #
        }    
            #
        set shape [$myTube getView $shapeName]    
            #
        switch -exact $shapeName {
            xz -
            ZY {
                set shape [vectormath::rotateCoordList      {0 0} $shape [my getDirection Config degree]]
                set shape [vectormath::addVectorCoordList   $Position(Origin) $shape]
            }
        }
            #
        return $shape
            #
    }
        #
    method getShape {{shapeName {}}} {
        return [my prototype_getShape $shapeName]
    }
        #
    method getMiterDict {} {
            #
            # --- original from: bikeModel::get_resultTubeMiterDictionary (3.4.04.xx)
            #
        return [dict create]
            #
    }    
        #
    method reportValues {} {
        my prototype_reportValues
    }
        #
}
    #
oo::define bikeFrame::AbstractProvidePart {mixin bikeFrame::MixinMethodProtoypes}
    #
        