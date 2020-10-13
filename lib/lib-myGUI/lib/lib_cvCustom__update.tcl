 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
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
 #    namespace:  myGUI::cvCustom::updateView
 # ---------------------------------------------------------------------------
 #
 #

    set myGUI::cvCustom::frameTubeColor wheat
    set myGUI::cvCustom::frameTubeColor burlywood
    set myGUI::cvCustom::frameTubeColor #e9b956
    set myGUI::cvCustom::frameTubeColor #edc778
        #
    set myGUI::cvCustom::frameTubeColor #edc778
    set myGUI::cvCustom::forkColor      #edc778
    set myGUI::cvCustom::labelColor     white                                 
        #

    proc myGUI::cvCustom::updateView {tabId {updatePosition {keep}}} {
            #
        variable     bottomCanvasBorder
            #
        puts ""
        puts "         -------------------------------"
        puts "          myGUI::cvCustom::updateView"
        puts "             tabId:        $tabId"
        set cvObject    [myGUI::gui::notebook_getCanvasObject $tabId]
        puts "             cvObject:        $cvObject"
            #
        if {[catch {myGUI::model::model_XZ::getConfig   ChainStay} eID]} {
                # on init phase, when there is no model loaded
            puts "\n"
            puts "   <W>        ... can not update View: $tabId  $cvObject"
            puts "           ... $eID\n"
                # myGUI::model::model_XZ::getConfig   ChainStay
            return
        }
            #
            #
        switch $tabId {
            cv_Custom02     {myGUI::cvCustom::update_Reference          $cvObject   $updatePosition}
            cv_Custom00     {myGUI::cvCustom::update_BaseGeometry       $cvObject   $updatePosition}
            cv_Custom10     {myGUI::cvCustom::update_FrameDetails       $cvObject   $updatePosition}
            cv_Custom20     {myGUI::cvCustom::update_RearMockup         $cvObject   $updatePosition}
            cv_Custom30     {myGUI::cvCustom::update_DimensionSummary   $cvObject   $updatePosition}
            cv_Custom40     {myGUI::cvCustom::update_FrameDrafting      $cvObject   $updatePosition}
            cv_Custom50     {myGUI::cvCustom::update_Mockup             $cvObject   $updatePosition}
            cv_Custom60     {myGUI::cvCustom::update_Tubemiter          $cvObject   $updatePosition}
            cv_Custom70     {myGUI::cvCustom::update_DraftingFramejig   $cvObject   $updatePosition}
            cv_Custom99     {myGUI::cvCustom::update_ComponentPanel     $cvObject   $updatePosition}
            cv_Custom0A     {myGUI::cvCustom::update_bikeModel          $cvObject   $updatePosition}
        }
            #
            #
        ::update    ; #for sure otherwise confuse situation about location of cadCanvas Stage
            #
            # puts "  .... $xy"
            #
        return
            #
    }

    proc myGUI::cvCustom::update_Reference {cvObject updatePosition} {
            #
            # -- get reference
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
        set dimFilterKey                    Reference    
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition bicycle ]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
            #
        myGUI::rendering::createReference   $cvObject       $xy     BaseLine
            #
        myGUI::reference::create            $cvObject       $xy     point_seat
        myGUI::reference::create            $cvObject       $xy     point_frame
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel
        myGUI::rendering::createDecoration  $cvObject       $xy     Brake           editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     SeatPost
          #
        myGUI::rendering::createDecoration  $cvObject       $xy     Cassette        editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Chain           editable   ;# $updateCommand
          #
        myGUI::rendering::createFork        $cvObject       $xy     selectable                 ;# $updateCommand
        myGUI::rendering::createFrame_Tubes $cvObject       $xy
          #
        myGUI::rendering::createDecoration  $cvObject       $xy     Label           editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Saddle          editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetTop
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetBottom
        myGUI::rendering::createDecoration  $cvObject       $xy     Stem            editable
        myGUI::rendering::createDecoration  $cvObject       $xy     HandleBar       editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     BottleCage      editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear  editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurFront editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CrankSet        editable   ;# $updateCommand
            #
        myGUI::rendering::createReference   $cvObject       $xy     CopyReference
            #
        myGUI::dimension::create            $cvObject       $xy     reference_bg                $dimFilterKey
        myGUI::dimension::create            $cvObject       $xy     reference_fg                $dimFilterKey   active
            #
        myGUI::reference::create            $cvObject       $xy     point_reference
            #
        updateRenderingCanvas               $cvObject       $frameTubeColor $forkColor $labelColor
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]  [myGUI::control::getSession dateModified]
            #
            #
    }

    proc myGUI::cvCustom::update_BaseGeometry {cvObject updatePosition} {
            #
            # -- base geometry
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
        set dimFilterKey                    Geometry    
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition bicycle ]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
        myGUI::rendering::createReference   $cvObject       $xy     BaseLine
            #
        myGUI::reference::create            $cvObject       $xy     point_seat
        myGUI::reference::create            $cvObject       $xy     point_frame
            #
        myGUI::rendering::createReference   $cvObject       $xy     FrameCenterLine     active
            # myGUI::rendering::createCenterline  $cvObject       $xy     frame
            # myGUI::rendering::createCenterline_Frame $cvObject  $xy
            #
        myGUI::reference::create            $cvObject       $xy     point_personal
        myGUI::reference::create            $cvObject       $xy     point_crank
            #
        # puts "   ... \$myGUI::gui::show_summaryDimension $myGUI::gui::show_summaryDimension"
            #
        set dimSum  $myGUI::gui::show_summaryDimension
        set dimRes  $myGUI::gui::show_resultDimension
        set dimSec  $myGUI::gui::show_secondaryDimension          
            #
        switch -exact -- $myGUI::gui::frame_configMethod {
            OutsideIn {      
                if {$dimSum} {
                    myGUI::dimension::create    $cvObject   $xy     base_hybrid_summary         $dimFilterKey   
                }                                                                               
                if {$dimRes} {                                                                  
                    myGUI::dimension::create    $cvObject   $xy     base_hybrid_result          $dimFilterKey   active
                }                                                                               
                if {$dimSec} {                                                                  
                    myGUI::dimension::create    $cvObject   $xy     base_hybrid_secondary       $dimFilterKey   active
                }                                                                               
                myGUI::dimension::create        $cvObject   $xy     base_hybrid_primary         $dimFilterKey   active                      
                myGUI::dimension::create        $cvObject   $xy     base_hybrid_personal        $dimFilterKey   active                      
            }
            StackReach { 
                if {$dimSum} {
                    myGUI::dimension::create    $cvObject   $xy     base_stackreach_summary     $dimFilterKey   
                }
                if {$dimRes} {
                    myGUI::dimension::create    $cvObject   $xy     base_stackreach_result      $dimFilterKey   active
                }
                if {$dimSec} {
                    myGUI::dimension::create    $cvObject   $xy     base_stackreach_secondary   $dimFilterKey   active
                }
                myGUI::dimension::create        $cvObject   $xy     base_stackreach_primary     $dimFilterKey   active
                myGUI::dimension::create        $cvObject   $xy     base_stackreach_personal    $dimFilterKey   active 
            }
            Classic {
                if {$dimSum} {
                    myGUI::dimension::create    $cvObject   $xy     base_classic_summary        $dimFilterKey   
                }
                if {$dimRes} {
                    myGUI::dimension::create    $cvObject   $xy     base_classic_result         $dimFilterKey   active
                } 
                if {$dimSec} {
                    myGUI::dimension::create    $cvObject   $xy     base_classic_secondary      $dimFilterKey   active
                } 
                myGUI::dimension::create        $cvObject   $xy     base_classic_primary        $dimFilterKey   active 
                myGUI::dimension::create        $cvObject   $xy     base_classic_personal       $dimFilterKey   active 
            }
            Lugs { 
                if {$dimSum} {
                    myGUI::dimension::create    $cvObject   $xy     base_lugs_summary           $dimFilterKey
                }
                if {$dimRes} {
                    myGUI::dimension::create    $cvObject   $xy     base_lugs_result            $dimFilterKey   active
                }
                if {$dimSec} {
                    myGUI::dimension::create    $cvObject   $xy     base_lugs_secondary         $dimFilterKey   active
                }
                myGUI::dimension::create        $cvObject   $xy     base_lugs_primary           $dimFilterKey   active
                myGUI::dimension::create        $cvObject   $xy     base_lugs_personal          $dimFilterKey   active
            }
            default {}
        }
            #
        myGUI::reference::create            $cvObject       $xy     point_reference
            #
            # updateRenderingCenterline     $cvObject
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]  [myGUI::control::getSession dateModified]
            #
        createWaterMark_Label               $cvObject
            #
        myGUI::gui::notebook_createButton   $cvObject       {configMode_Frame,configMode_BaseDimension}
            #
            #
    }

    proc myGUI::cvCustom::update_FrameDetails {cvObject updatePosition} {
            #
            # -- frame - details
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    Frame    
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition frame ]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
        createLugRepresentation             $cvObject       $xy
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     SeatPost                editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel_Rep
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel_Rep
        myGUI::rendering::createDecoration  $cvObject       $xy     Fender_Rep              editable   ;# $updateCommand
            #
        myGUI::rendering::createFork        $cvObject       $xy     editable                           ;# $updateCommand
        myGUI::rendering::createFrame_Tubes $cvObject       $xy     editable                           ;# $updateCommand
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     CarrierRear             editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CarrierFront            editable   ;# $updateCommand
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Label                   editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel_Pos
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear_ctr      editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Saddle                  editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetTop              editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetBottom           editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     BottleCage              editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Stem                    editable
        myGUI::rendering::createDecoration  $cvObject       $xy     LegClearance_Rep
            #
        myGUI::reference::create            $cvObject       $xy     cline_frame             extend
            #       
        myGUI::reference::create            $cvObject       $xy     point_frame_dimension
        myGUI::reference::create            $cvObject       $xy     cline_brake
            #
        myGUI::dimension::create            $cvObject       $xy     frameTubing_bg              $dimFilterKey   
            #      
        myGUI::dimension::create            $cvObject       $xy     RearWheel_Clearance         $dimFilterKey
        myGUI::dimension::create            $cvObject       $xy     LegClearance                $dimFilterKey
        myGUI::dimension::create            $cvObject       $xy     DerailleurMount             $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     HeadTube_Length             $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     SeatTube_Extension          $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     SeatStay_Offset             $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     HeadTube_OffsetTT           $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     HeadTube_OffsetDT           $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     HeadTube_CenterDT           $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     DownTube_Offset             $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     SeatTube_Offset             $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     TopTube_Angle               $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     HeadSet_Top                 $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     HeadSet_Bottom              $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     ForkHeight                  $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     Brake_Rear                  $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     Brake_Front                 $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     TopHeadTube_Angle           $dimFilterKey   active  ;# $updateCommand
        myGUI::dimension::create            $cvObject       $xy     BottleCage                  $dimFilterKey   active  ;# $updateCommand
            #
        myGUI::rendering::debug_geometry    $cvObject       $xy
            #
        updateRenderingCanvas               $cvObject       $frameTubeColor $forkColor $labelColor
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]  [myGUI::control::getSession dateModified]
            #
        createWaterMark_Label               $cvObject
            #
        myGUI::gui::notebook_createButton   $cvObject       check_TubingAngles
            #
            #
    }

    proc myGUI::cvCustom::update_RearMockup {cvObject updatePosition} {
            #
            # -- rear - mockup
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    ChainStay
            #
        set stageScale                      [$cvObject  configure   Stage   Scale]
        set stageFormat                     [$cvObject  configure   Stage   Format]
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition frame $stageScale]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
        createDraftingFrame                 $cvObject
            #
        updateCanvasParameter               $cvObject       $xy
        createRearMockup                    $cvObject
            #
        $cvObject                           centerContent   {__Decoration__   __CenterLine__   __Dimension__  __Frame__  __Tube__  __Lug__  __Component__}    {0 5}
            #
        updateRenderingCanvas               $cvObject
            #    
        myGUI::gui::notebook_createButton   $cvObject       {configMode_ChainStay,pageConfig_Scale,pageConfig_Format}
            #
            #
    }

    proc myGUI::cvCustom::update_DimensionSummary {cvObject updatePosition} {
            #
            # -- dimension summary
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    Summary
            #
            #
        set stageFormat                     [$cvObject  configure   Stage   Format]
        set factor                          [getFormatFactor $stageFormat]
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition bicycle ]
            #
        foreach {x y} $xy break
            #
        set y  [expr $y + (120.0 / $factor)]
        set xy [list $x $y]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
            # myGUI::reference::create      $cvObject       $xy     point_seat
        myGUI::reference::create            $cvObject       $xy     point_center
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel           editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel          editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Fender              editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Brake               editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     SeatPost
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Cassette            editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Chain               editable    ;# $updateCommand
            #
        myGUI::rendering::createFork        $cvObject       $xy     selectable                      ;# $updateCommand
        myGUI::rendering::createFrame_Tubes $cvObject       $xy
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Label               editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Saddle              editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetTop          editable
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetBottom_2     editable
        myGUI::rendering::createDecoration  $cvObject       $xy     Stem                editable
        myGUI::rendering::createDecoration  $cvObject       $xy     HandleBar           editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     BottleCage          editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear      editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurFront     editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CrankSet            editable    ;# $updateCommand
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     CarrierRear         editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CarrierFront        editable    ;# $updateCommand
            #
        myGUI::reference::create            $cvObject       $xy     point_seat
            #
        myGUI::reference::create            $cvObject       $xy     cline_angle
            #
        myGUI::dimension::create            $cvObject       $xy     summary_bg          $dimFilterKey
            #
        myGUI::dimension::create            $cvObject       $xy     summary_fg          $dimFilterKey   active
            #
        myGUI::rendering::createReference   $cvObject       $xy     BaseLine            black
            #
        updateRenderingCanvas               $cvObject       {}  {}  {}  gray98  gray93  gray93
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]  [myGUI::control::getSession dateModified]
            #
        createWaterMark_Label               $cvObject
            #
        # myGUI::gui::notebook_createButton $cvObject       {pageConfig_Scale,pageConfig_Format}
            #
            #
    }

    proc myGUI::cvCustom::update_FrameDrafting {cvObject updatePosition} {
            #
            # -- frame - drafting
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    FrameDrafting
            #
        set stageScale                      [$cvObject  configure   Stage   Scale]
        set stageFormat                     [$cvObject  configure   Stage   Format]
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition frame $stageScale]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
        createDraftingFrame                 $cvObject
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel_Rep
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel_Rep
        myGUI::rendering::createDecoration  $cvObject       $xy     Fender_Rep
            #
        myGUI::rendering::createFork        $cvObject       $xy
        myGUI::rendering::createFrame_Tubes $cvObject       $xy
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Label                   editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel_Pos
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear_ctr
        myGUI::rendering::createDecoration  $cvObject       $xy     BottleCage
        myGUI::rendering::createDecoration  $cvObject       $xy     LegClearance_Rep
            #
        myGUI::reference::create            $cvObject       $xy     cline_frame             extend
        myGUI::reference::create            $cvObject       $xy     point_contact 
            #
        myGUI::reference::create            $cvObject       $xy     cline_brake
        myGUI::dimension::create            $cvObject       $xy     frameDrafting_bg        $dimFilterKey
            #
        $cvObject                           centerContent   {__Decoration__  __CenterLine__  __Dimension__  __Frame__}  {0 25}  
            #
        updateRenderingCanvas               $cvObject       $frameTubeColor $forkColor $labelColor
            #
        myGUI::gui::notebook_createButton   $cvObject       {pageConfig_Scale,pageConfig_Format}
            #
            #
    }

    proc myGUI::cvCustom::update_Mockup {cvObject updatePosition} {
            #
            # -- mockup
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    Mockup
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition bicycle ]
            #
        $cvObject                           deleteContent
            #
        myGUI::rendering::createReference   $cvObject       $xy     BaseLine
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel           editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel          editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Fender              editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Brake               editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     SeatPost
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Cassette            editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Chain               editable    ;# $updateCommand
            #                                          
        myGUI::rendering::createFork        $cvObject       $xy     selectable                      ;# $updateCommand
        myGUI::rendering::createFrame_Tubes $cvObject       $xy
        myGUI::rendering::createDecoration  $cvObject       $xy     Label               editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     BottleCage          editable    ;# $updateCommand
            #                                          
        myGUI::rendering::createDecoration  $cvObject       $xy     Saddle              editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetTop          editable
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetBottom_2     editable
        myGUI::rendering::createDecoration  $cvObject       $xy     Stem                editable
        myGUI::rendering::createDecoration  $cvObject       $xy     HandleBar           editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear      editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurFront     editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CrankSet            editable    ;# $updateCommand
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     CarrierRear         editable    ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CarrierFront        editable    ;# $updateCommand
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]  [myGUI::control::getSession dateModified]
            #
        updateRenderingCanvas               $cvObject       {}  {}  {}  gray98  gray93  gray93
            #
        createWaterMark_Label               $cvObject
            #
        myGUI::gui::notebook_createButton   $cvObject       change_Rendering
            #   
            #
    }

    proc myGUI::cvCustom::update_Tubemiter {cvObject updatePosition} {
            #
            # -- tubemiter
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    Tubemiter
            #
        $cvObject                           deleteContent
            #
        myGUI::tubeMiter::create            $cvObject 
            #
        updateRenderingCanvas               $cvObject
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]    [myGUI::control::getSession dateModified]
            #
        createWaterMark_Label               $cvObject
            #
            #
    }

    proc myGUI::cvCustom::update_DraftingFramejig {cvObject updatePosition} {
            #
            # -- drafting - framejig
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    FrameJig
            #
        set stageScale                      [$cvObject configure Stage Scale]
        set stageFormat                     [$cvObject configure Stage Format]
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition frame $stageScale]
            #
        $cvObject                           deleteContent
            #
        myGUI::dimension::updateParameter   $cvObject       $xy
            #
        createDraftingFrame                 $cvObject       {}  "<$::APPL_Config(FrameJigType)>  [myGUI::control::getSession  projectName]"
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel_Rep
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel_Rep
            #
        myGUI::rendering::createFrame_Tubes $cvObject       $xy
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Label
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear_ctr
            #
        myGUI::reference::create            $cvObject       $xy     cline_frame
            #
        myGUI::reference::create            $cvObject       $xy     cline_brake
            #
        myGUI::dimension::create            $cvObject       $xy     frameJig                    $dimFilterKey
            #
        $cvObject                           centerContent   {__Frame__  __Decoration__  __CenterLine__  __Dimension__}  {0 15}  
            #
        createJigParameterTable             $cvObject       $dimFilterKey            
            #
        updateRenderingCanvas               $cvObject       $frameTubeColor $forkColor $labelColor
            #
        myGUI::gui::notebook_createButton   $cvObject       configMode_FrameJig
            #
            #
    }

    proc myGUI::cvCustom::update_ComponentPanel {cvObject updatePosition} {
            #
            # -- component in ConfigPanel
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
        set dimFilterKey                    Component
            #
        set xy                              [myGUI::cvCustom::getBottomBracketPosition $cvObject $bottomCanvasBorder $updatePosition bicycle ]
            #
        $cvObject                           deleteContent
            #
        myGUI::rendering::createReference   $cvObject       $xy     BaseLine
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     RearWheel           editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     FrontWheel          editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     Brake               editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     SeatPost
            #
        myGUI::rendering::createFork        $cvObject       $xy
        myGUI::rendering::createFrame_Tubes $cvObject       $xy
        myGUI::rendering::createDecoration  $cvObject       $xy     BottleCage          editable   ;# $updateCommand
            #
        myGUI::rendering::createDecoration  $cvObject       $xy     Saddle              editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetTop
        myGUI::rendering::createDecoration  $cvObject       $xy     HeadSetBottom
        myGUI::rendering::createDecoration  $cvObject       $xy     Stem
        myGUI::rendering::createDecoration  $cvObject       $xy     HandleBar           editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurRear      editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     DerailleurFront     editable   ;# $updateCommand
        myGUI::rendering::createDecoration  $cvObject       $xy     CrankSet            editable   ;# $updateCommand
            #
        createWaterMark                     $cvObject       [myGUI::control::getSession projectFile]   [myGUI::control::getSession dateModified]
            #
            #
    }

    proc myGUI::cvCustom::update_bikeModel {cvObject updatePosition} {
            #
        variable    bottomCanvasBorder
            #
        variable    frameTubeColor
        variable    forkColor
        variable    labelColor
            #
            #
            #
        return
            #
        return
            #
    }
