 ########################################################################
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 #      package: cadCanvas 	->	classCanvasFactory.tcl
 #
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
namespace eval cad4tcl {oo::class create CanvasFactory}
    #
oo::define cad4tcl::CanvasFactory {
        #
    variable _counter    
    variable _objectList    
        #
    constructor {} { 
            #
        puts "            -> factory CanvasFactory"
            #
        variable _counter       0
        variable _objectList    {}
            #
    }
        #
    destructor     { 
        puts "            -> [self] ... destroy CanvasFactory"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... cad4tcl::CanvasFactory $target_method $args  ... unknown"
    }
        #
    method create {parentWidget cv_width cv_height stageFormat stageScale stageBorder args} {
            #
        variable _counter
        variable _objectList
            #
        incr _counter
            #
        set cvName      [format {cadCanvas_%s} $_counter]
            # set cvName cvCAD
            # 
            # puts "   -> $args"
        set arguments   [cad4tcl::_flattenNestedList $args]
            # puts "   -> $arguments"
        set myObject    [cad4tcl::CADCanvas  new $parentWidget.$cvName $cv_width $cv_height $stageFormat $stageScale $stageBorder $arguments]
            #
        cad4tcl::setNodeAttributeRoot /root/_package_/UnitScale   m   [$myObject configure UnitScale m  ]
        cad4tcl::setNodeAttributeRoot /root/_package_/UnitScale   c   [$myObject configure UnitScale c  ]
        cad4tcl::setNodeAttributeRoot /root/_package_/UnitScale   i   [$myObject configure UnitScale i  ]
        cad4tcl::setNodeAttributeRoot /root/_package_/UnitScale   p   [$myObject configure UnitScale p  ]
        cad4tcl::setNodeAttributeRoot /root/_package_/UnitScale   std [$myObject configure UnitScale std]
            #
        lappend _objectList $myObject
            #
        return $myObject
            #
    }
        #
    method createNew {parentWidget width height {stageFormat {noFormat}} {stageScale 1.0} {stageBorder 10} args} {
            #
        variable _counter
        variable _objectList
            #
        if 1 {
            puts "   \$parentWidget        $parentWidget"
            puts "   \$width               $width       "
            puts "   \$height              $height      "
            puts "   \$stageFormat         $stageFormat "
            puts "   \$stageScale          $stageScale  "
            puts "   \$stageBorder         $stageBorder"
        }
            #
        incr _counter
            #
        set refNameOld      [format {_cvCAD_%03d} $_counter]
        set parentWidget    $parentWidget.cv
            #
        set myObject [cad4tcl::CADCanvas new $refNameOld $parentWidget $width $height $stageFormat $stageScale $stageBorder]
            #
        lappend _objectList $myObject
            #
            # ... history purpose ... remove in final version
            #my createLog $_counter $myObject 
            #
        return $myObject
            #
    }
        #
    method getMemberDOM {} {
            #
        variable _objectList
            #
        set xmlDoc  [dom parse [[cad4tcl::getXMLRoot] asXML]]
        set xmlRoot [$xmlDoc documentElement]
            #
        foreach node [$xmlRoot childNodes] {
            if {[$node nodeName] eq {instance}} {
                $xmlRoot removeChild $node
                $node delete
            }
        }
            #
        foreach cvObject $_objectList {
            set objectDoc   [$cvObject updateReportDOM]
            $xmlRoot appendXML [$objectDoc asXML]
        }
            #
        return $xmlDoc
            #
    }
        #
    method getMemberList {} {
        variable _objectList
        return $_objectList
    }
        #
        #
        #
        #
    method reportMemberList {} {
        variable _objectList
        foreach cvObject $_objectList {
            puts "       CanvasFactory:  $cvObject"
        }
        return $_objectList
    }
        #
    method __remove_update_memberList {} {
        variable _objectList
            # puts "   ----- update_memberList -----"
        foreach cvObject $_objectList {
            if [info exist $cvObject] {
                puts "  -1- $cvObject"
            } else {
                puts "  -0- $cvObject"
            }
        }
        return $_objectList
    }
        #
    method __remove_get_memberXML {} {
            #
        variable _objectList
            #
        set firstObject [lindex $_objectList 0]
        set domNode     [$firstObject getDomNode]
        set domParent   [$domNode parentNode]
            #
        return $domParent
            #
    }
        #
        #
}
