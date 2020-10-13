 ##+##########################################################################
 #
 # package: bikeFrame    ->    bikeFrame.tcl
 #
 #   bikeFrame is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/05/16
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
 #
 # 2.00 - 20160417
 #      ... refactor: rattleCAD - 3.4.03
 #
 #
 # 1.xx refactor
 #          split project completely from bikeFrame
 #
 #
  
package require tdom
    #
package provide bikeFrame    0.00
    #
package require vectormath   1.00
package require tubeMiter    0.06
package require customTube   0.01
    #
namespace eval bikeFrame {

    # --------------------------------------------
        #
    variable frameFactory {}
    variable frameObject  {}
    
    # --------------------------------------------
        # Export as global command
    variable packageHomeDir [file dirname [file normalize [info script]]]
        #

    #-------------------------------------------------------------------------
        #  definitions of template parameter
    variable initRoot       {}
    variable resultRoot     {}
    # variable initRoot    $project::initRoot
    variable projectDOM     {}
    # variable returnDict; set returnDict [dict create rattleCAD {}]
    variable projectRoot    {}
        #


    #-------------------------------------------------------------------------
        #  current Project Values
    variable Project         ; array set Project         {}
    variable Geometry        ; array set Geometry        {}
    variable Reference       ; array set Reference       {}
    variable Component       ; array set Component       {}
    variable Config          ; array set Config          {}
    variable ListValue       ; array set ListValue       {}
    variable Result          ; array set Result          {}
    
    variable ConfigPrev      ; array set ConfigPrev      {}
    
    variable BottleCage      ; array set BottleCage      {}
    variable BottomBracket   ; array set BottomBracket   {}
    variable Fork            ; array set Fork            {}
    variable FrontDerailleur ; array set FrontDerailleur {}
    variable FrontWheel      ; array set FrontWheel      {}
    variable HandleBar       ; array set HandleBar       {}
    variable HeadSet         ; array set HeadSet         {}
    variable RearDerailleur  ; array set RearDerailleur  {}
    variable RearDropout     ; array set RearDropout     {}
    variable RearWheel       ; array set RearWheel       {}
    variable Saddle          ; array set Saddle          {}
    variable SeatPost        ; array set SeatPost        {}
    variable Spacer          ; array set Spacer          {}
    variable Stem            ; array set Stem            {}
    
    variable LegClearance    ; array set LegClearance    {}
    
    variable HeadTube        ; array set HeadTube        {}
    variable SeatTube        ; array set SeatTube        {}
    variable DownTube        ; array set DownTube        {}
    variable TopTube         ; array set TopTube         {}
    variable ChainStay       ; array set ChainStay       {}
    variable SeatStay        ; array set SeatStay        {}
    variable Steerer         ; array set Steerer         {}
    variable ForkBlade       ; array set ForkBlade       {}
    variable Lugs            ; array set Lugs            {}
    
    
    variable TubeMiter       ; array set TubeMiter       {}
    variable FrameJig        ; array set FrameJig        {}
    variable RearMockup      ; array set RearMockup      {}
    variable BoundingBox     ; array set BoundingBox     {}
    
    
    variable myFork          ; array set myFork          {}

    variable DEBUG_Geometry  ; array set DEBUG_Geometry  {}



    #-------------------------------------------------------------------------
        #  update loop and delay; store last value
    variable customFork      ; array set customFork { lastConfig    {} }
    
    #-------------------------------------------------------------------------
        #  dataprovider of create_selectbox
    variable _listBoxValues {}
    
    #-------------------------------------------------------------------------
        #  export procedures
    namespace export set_newProject
    namespace export get_projectDOM
    namespace export get_projectDICT
        #
    namespace export import_ProjectSubset
        #
    namespace export get_ComponentDir 
    namespace export get_ComponentDirectories
    namespace export get_ListBoxValues 
        #
    namespace export get_DebugGeometry
    namespace export get_ReynoldsFEAContent
        #
    namespace export coords_xy_index
        #
}
    
    
    #
#-------------------------------------------------------------------------
    #
proc bikeFrame::get_BoundingBox {key} {
    set boundingBox [lindex [array get [namespace current]::BoundingBox $key] 1]
    return $boundingBox
}
    #
    #
