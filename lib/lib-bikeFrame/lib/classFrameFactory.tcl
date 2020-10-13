 ##+##########################################################################
 #
 # package: bikeFrame    ->    classBicycle.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/051/08 #
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
  
package require tdom
    #
package require vectormath
    #
package require TclOO
    #

oo::class create bikeFrame::FrameFactory {
            #
    variable _objectList    
            #
    constructor {} { 
            #
        puts "            -> factory FrameFactory"
            #
        variable _counter       0
        variable _objectList    {}
            #
    }
        #
    destructor     { 
        puts "            -> [self] ... destroy FrameFactory"
    }
        #
    method unknown {target_method args} {
        puts "            <E> ... [info object class [self]]  $target_method $args  ... unknown"
    }
        #
    method  create {} {
            #
        variable _objectList
            #
        set myObject [bikeFrame::DiamondFrame  new]
        lappend _objectList $myObject
        return $myObject
            #
    }
        #
    method  get_memberList {} {
        variable _objectList
        return $_objectList
    }
        #
    method  report_memberList {} {
        variable _objectList
        foreach frameObject $_objectList {
            #set oldRef  [$cvObject get_canvasValue _refNameOld]
            #puts "       $cvObject - $oldRef"
        }
        return $_objectList
    }
        #
}
