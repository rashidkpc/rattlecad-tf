 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_bikeRendering.tcl
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
 #  namespace:  myGUI::rendering
 # ---------------------------------------------------------------------------
 #
 #

namespace eval myGUI::tubeMiter {        
        #
    variable tubeMiter  
    variable cvObject
        #
}

proc myGUI::tubeMiter::create {canvasObject} {
        #
        #
    variable tubeMiter
    variable cvObject
        #
        # variable pdfExport
        #
    set cvObject        $canvasObject
        #
    set tubeMiter       [::myGUI::model::model_TubeMiter::getDictionary TubeMiter]
        # set tubeMiter [myGUI::modelAdapter::get_TubeMiterDICT]
        #
        # first row
    set width_01_01     [dict get $tubeMiter TopTube_Head    minorPerimeter]
    set width_01_02     [dict get $tubeMiter DownTube_Head   minorPerimeter]
    set width_01_03     [dict get $tubeMiter SeatStay_01     minorPerimeter]
        # second row
    set width_02_01     [dict get $tubeMiter TopTube_Seat    minorPerimeter]
    set width_02_02     [dict get $tubeMiter DownTube_Seat   minorPerimeter]
    set width_02_03     [dict get $tubeMiter SeatTube_Down   minorPerimeter]
        #
        # column 01
    if {$width_01_01 > $width_02_01} {
        set column_01 $width_01_01
    } else {
        set column_01 $width_02_01
    }
        #
        # column 02
    if {$width_01_02 > $width_02_02} {
        set column_02 $width_01_02
    } else {
        set column_02 $width_02_02
    }
        #
        #
    set gap_01 [expr (420 - 10 - ($column_01 + $column_02 + 2*$width_01_03)) / 5]
    set gap_02 [expr (420 - 10 - ($column_01 + $column_02 +   $width_02_03)) / 4]
        #
    if {[expr 2*$width_01_03 + $gap_01] > $width_02_03} {
        set gapWidth $gap_01
        set column_03 [expr 2 * $width_01_03 + abs($gapWidth)]
    } else {
        set gapWidth $gap_02
        set column_03 $width_02_03
    }
        #
    set column_max $column_01
    if {$column_02 > $column_max} {set column_max $column_02}
    if {$column_03 > $column_max} {set column_max $column_03}
        #
    set column_01_offset    [expr 0.5 * ($column_max - $column_01)]     
    set column_02_offset    [expr 0.5 * ($column_max - $column_02)]     
    set column_03_offset    [expr 0.5 * ($column_max - $column_03)]     
        #
        #
    # set summaryWidth [expr $column_01 + $column_02 + $column_03]
    # set summaryFree  [expr 420 - 10 - $summaryWidth]
    # set gapWidth     [expr $summaryFree / 5]
        #   
        #
    set pos_01_x    [expr 5 + 1*$gapWidth + 0.5*$column_01]
    set pos_02_x    [expr 5 + 2*$gapWidth +     $column_01 + 0.5*$column_02]
    set pos_03_x    [expr 5 + 3*$gapWidth +     $column_01 +     $column_02 + 0.5*$column_03]
    set pos_03_x1   [expr $pos_03_x - 0.5*(abs($gapWidth) + $width_01_03)]
    set pos_03_x2   [expr $pos_03_x + 0.5*(abs($gapWidth) + $width_01_03)]
        #
        #
    set pos_01_01   [list $pos_01_x  250]
    set pos_01_02   [list $pos_02_x  250]
    set pos_01_03   [list $pos_03_x1 [expr 250 - 70]]
    set pos_01_04   [list $pos_03_x2 [expr 250 - 70]]
        #
    set pos_02_01   [list $pos_01_x   75]
    set pos_02_02   [list $pos_02_x   75]
    set pos_02_03   [list $pos_03_x   75]
        #
    set pos_03_01   [list $pos_01_x   40]
    set pos_03_03   [list $pos_03_x   40]
        #
        
        #
    set width_column_01 [expr $column_01 +10]   
    set width_column_02 [expr $column_02 +10]   
    set width_column_03 [expr $column_03 +10]   
        #
    set y1  55
    set y2  270
        #
    puts ""
    puts "          ---------------------------------------------"
    puts "              \$width_column_01   $width_column_01"
    puts "              \$width_column_02   $width_column_02"
    puts "              \$width_column_03   $width_column_03"
    puts ""
    puts "                   $y1  -> [expr $y2 - $y1] <-  $y2"
    puts "          ---------------------------------------------"
    puts ""
        
        #
        # draw miterArea 01   
    set x1  [expr round($pos_01_x - 0.5*$width_column_01)]
    set y1  55
    set x2  [expr round($pos_01_x + 0.5*$width_column_01)]
    set y2  270
    set miterArea_01    [list $x1 $y1 $x2 $y2 ]
    $cvObject create rectangle   $miterArea_01   -outline {white}  -fill {}  -tags {__tubeMiter__ __miterArea__ __miterArea_01__}    
        #
        # draw miterArea 02
    set x1  [expr round($pos_02_x - 0.5*$width_column_02)]
    set y1  55
    set x2  [expr round($pos_02_x + 0.5*$width_column_02)]
    set y2  270
    set miterArea_02    [list $x1 $y1 $x2 $y2 ]
    $cvObject create rectangle   $miterArea_02   -outline {white}  -fill {}  -tags {__tubeMiter__ __miterArea__ __miterArea_02__}    
        #
        # draw miterArea 03
    set x1  [expr round($pos_03_x - 0.5*$width_column_03)]
    set y1  55
    set x2  [expr round($pos_03_x + 0.5*$width_column_03)]
    set y2  270
    set miterArea_03    [list $x1 $y1 $x2 $y2 ]
    $cvObject create rectangle   $miterArea_03   -outline {white}  -fill {}  -tags {__tubeMiter__ __miterArea__ __miterArea_03__}    
        #
        #
        # draw miter: 1st row
        #
    drawMiter $pos_01_01  TopTube_Head    Origin
    drawMiter $pos_01_02  DownTube_Head   Origin
    drawMiter $pos_01_03  SeatStay_02     End     ;#rotate
    drawMiter $pos_01_04  SeatStay_01     End     ;#rotate
        #
        # draw miter: 2nd row
    drawMiter $pos_02_01  TopTube_Seat    End     ;#rotate
    drawMiter $pos_02_02  DownTube_Seat   End     ;#rotate 
    drawMiter $pos_02_03  SeatTube_Down   End     ;#rotate
        #   
        # draw reference  
    drawMiter $pos_03_03  Reference
        #
        #
    return
        #
}

proc myGUI::tubeMiter::drawMiter {xy type {positionName {Origin}}} {
        #
    variable tubeMiter
    variable cvObject
        #
    puts "              -> drawMiter: $cvObject $xy $type $positionName"
        #
        # puts "  \$type $type"    
        #
    set minorName       [dict get $tubeMiter $type minorName]
    set minorDiameter   [dict get $tubeMiter $type minorDiameter]
    set minorAngle      [dict get $tubeMiter $type minorDirection]
    set majorName       [dict get $tubeMiter $type majorName]
    set majorDiameter   [dict get $tubeMiter $type majorDiameter]
    set majorAngle      [dict get $tubeMiter $type majorDirection]
    set miterAngle      [dict get $tubeMiter $type miterAngle]
    set offset          [dict get $tubeMiter $type offset]
    set polygon         [join [dict get $tubeMiter $type polygon_01] " "]
    set perimeter       [dict get $tubeMiter $type minorPerimeter]
        #
        #
    set outlineMiter    0.5    
        #
    set polygon_in  {}
    set polygon_out {}
    catch {set polygon_in  [join [dict get $tubeMiter $type polygon_02] " "]}
    catch {set polygon_out [join [dict get $tubeMiter $type polygon_03] " "]}
        #
    if {$positionName eq {Origin}} {
        set Miter(polygon)      [vectormath::addVectorCoordList $xy  $polygon]
        set Miter(polygon_out)  [vectormath::addVectorCoordList $xy  $polygon_out]
        set Miter(polygon_in)   [vectormath::addVectorCoordList $xy  $polygon_in]
    } else {                        
        set Miter(polygon)      [vectormath::addVectorCoordList $xy  $polygon]
        set Miter(polygon_out)  [vectormath::addVectorCoordList $xy  $polygon_out]
        set Miter(polygon_in)   [vectormath::addVectorCoordList $xy  $polygon_in]
    }
        #
    set miterTag {}        
        #
    set tubeType {cylinder}
    set toolType {cylinder}
    catch {set tubeType  [dict get $tubeMiter $type tubeType]}
    catch {set toolType  [dict get $tubeMiter $type toolType]}
        #
    puts "                      -> $type - ($tubeType/$toolType)"
        
    switch -exact $toolType {
        cone {
            if {[catch {set baseDiameter   [dict get $tubeMiter $type baseDiameter  ]} eID]} {set baseDiameter {?}}
            if {[catch {set topDiameter    [dict get $tubeMiter $type topDiameter   ]} eID]} {set baseDiameter {?}}
            if {[catch {set baseHeight     [dict get $tubeMiter $type baseHeight    ]} eID]} {set baseDiameter {?}}
            if {[catch {set frustumHeight  [dict get $tubeMiter $type frustumHeight ]} eID]} {set baseDiameter {?}}
            if {[catch {set sectionPoint   [dict get $tubeMiter $type sectionPoint  ]} eID]} {set baseDiameter {?}}
            set _miterText_01  [format {%s (%s) / %s (%s %s %s (%s - %s))} \
                                        $tubeType  $minorDiameter  $toolType   \
                                        $baseDiameter  $topDiameter $frustumHeight  $sectionPoint $baseHeight  \
                                        ]
        }
        cylinder -
        default {
            set _miterText_01  [format {%s (%s) / %s (%s)} \
                                        $tubeType  $minorDiameter  $toolType  \
                                        $majorDiameter \
                                        ]
        }  
}
        #
    set _appendText_01  {}
    switch $type {
        DownTube_Seat -
        SeatTube_Down {
            catch {set diameter_in  [dict get $tubeMiter $type diameter_02]}
            catch {set diameter_out [dict get $tubeMiter $type diameter_03]}
                #
                # set _miterText_01  "diameter: $minorDiameter / $majorDiameter  ($diameter_in/$diameter_out) - ($tubeType/$toolType)"
            set _appendText_01  [format   { - (%s/%s)} $diameter_in  $diameter_out]
        }
        default {}
    }
        #
    append _miterText_01 $_appendText_01
        #
    
        #   
    set Miter(header) [format "%s / %s"  $minorName $majorName]    
        #
    
        # --- polygon reference lines
        #
    switch $type {

        Reference {
            # --- defining values
            #
        set Miter(text_01)     "Reference: 100.00 x 10.00 "
        set textPos     [vectormath::addVector $xy {10 3}]
            #
        }
        default {                   
                # --- defining values
                #
                # set Miter(text_01)     "diameter: $minorDiameter / $majorDiameter  $_addText"
            set Miter(text_01)     "$_miterText_01"
                #set     minorAngle          [vectormath::angle {0 1} {0 0} $minorDirection   ]
                #set     majorAngle          [vectormath::angle {0 1} {0 0} $majorDirection   ]                         
                #
            set     angle               [expr abs($majorAngle - $minorAngle) ]
                #
            if 0 {
                if {$angle > 90} {set angle [expr 180 - $angle]}
                set     angle [format "%.3f" $angle ]
                set     angleComplement     [format "%.3f" [expr 180 - $angle ] ]
                    #
                set Miter(text_02)     "angle:  $angle / $angleComplement  - check $miterAngle"
            }
            set complementAngle    [format "%.3f" [expr 180 - $miterAngle]]
            set Miter(text_02)     "angle:  $miterAngle / $complementAngle"
            set Miter(text_03)     "offset: $offset"
            set Miter(text_04)     "perimeter:  [format "%.3f" $perimeter]"
                #
            set pt_03   [myGUI::model::coords_xy_index $Miter(polygon) end ]
            set pt_04   [myGUI::model::coords_xy_index $Miter(polygon) end-1]
                # puts "  # --- $type ------------------------------"            
                # puts "     -> \$pt_03 $pt_03"            
                # puts "     -> \$pt_04 $pt_04"            
                # puts "  # ----------------------------------------"            
                
                # set perimeter       [dict get $tubeMiter $type minorPerimeter]
            set pt_03           [list [expr -1.0 * (5 + 0.5 * $perimeter)] 0]
            set pt_04           [list [expr        (5 + 0.5 * $perimeter)] 0]
            set pt_03           [vectormath::addVector $xy $pt_03]        
            set pt_04           [vectormath::addVector $xy $pt_04]        
                # puts "  # --- $type ------------------------------"            
                # puts "     -> \$pt_03 $pt_03"            
                # puts "     -> \$pt_04 $pt_04"            
                # puts "  # ----------------------------------------"            
            
            if {$positionName eq {Origin}} {               
                    #
                set pt_01   [vectormath::addVector $xy    {  0   5} ]
                set pt_02   [vectormath::addVector $xy    {  0 -75} ]
                set pt_03   [vectormath::addVector $pt_03 {  0 -50}]
                set pt_04   [vectormath::addVector $pt_04 {  0 -50}]
                set pt_05   [vectormath::addVector $pt_03 {  0  50}]
                set pt_06   [vectormath::addVector $pt_04 {  0  50}]
                    #
                set pt_10   [vectormath::addVector $xy    {  0 -50}]
                set pt_11   [vectormath::addVector $pt_10 {-20  10}] 
                    #
                set pt_12   [vectormath::addVector $pt_10 {-23  -5}] 
                set pt_13   [vectormath::addVector $pt_10 {-23  -9}] 
                set pt_14   [vectormath::addVector $pt_10 {-23 -13}]                                                               
                set pt_15   [vectormath::addVector $pt_10 {-10 -19}]                                                               
                    #
                set pt_logo [vectormath::addVector $pt_10 {  0   2}] 
                set orient_Logo s
                    #
            } else {    
                    #
                set pt_01   [vectormath::addVector $xy    {  0  -5}]
                set pt_02   [vectormath::addVector $xy    {  0  75}]
                set pt_03   [vectormath::addVector $pt_03 {  0  50}]
                set pt_04   [vectormath::addVector $pt_04 {  0  50}]
                set pt_05   [vectormath::addVector $pt_03 {  0 -50}]
                set pt_06   [vectormath::addVector $pt_04 {  0 -50}] 
                    #
                set pt_10   [vectormath::addVector $xy    {  0  50}]
                set pt_11   [vectormath::addVector $pt_10 {-20 -13}] ;# -10 + 3
                    #                                
                set pt_12   [vectormath::addVector $pt_10 {-23   2}] ;#  +5 + 3
                set pt_13   [vectormath::addVector $pt_10 {-23   6}] ;#  +4
                set pt_14   [vectormath::addVector $pt_10 {-23  10}] ;#  +4
                set pt_15   [vectormath::addVector $pt_10 {-10  16}]
                    #                                       
                set pt_logo [vectormath::addVector $pt_10 {  0  -7}] 
                set orient_Logo s
                    #
            }
        }
    }
        #
        #
        #
    set lastTag     [lindex [$cvObject find withtag all] end]
            #             
        # --- mitter polygon
        #
    set tagList [list __tubeMiter__ $type]    
        #
    $cvObject create polygon        $Miter(polygon)     -fill white  -outline black  -width $outlineMiter -tags $tagList
    catch {$cvObject create line    $Miter(polygon_in)  -fill black  -width $outlineMiter -tags $tagList} 
    catch {$cvObject create line    $Miter(polygon_out) -fill black  -width $outlineMiter -tags $tagList}
        #
        #
    switch $type {

        Reference {
                #
            $cvObject create draftText $textPos  -text $Miter(text_01) -size 2.5 -tags $tagList
                #
        }
        default {                   
                #
            $cvObject create centerline  [appUtil::flatten_nestedList $pt_01 $pt_02 ]  -fill red  -width 0.25 -tags $tagList
            $cvObject create line        [appUtil::flatten_nestedList $pt_03 $pt_04 ]  -fill blue -width 0.25 -tags $tagList
            $cvObject create centerline  [appUtil::flatten_nestedList $pt_05 $pt_06 ]  -fill red  -width 0.25 -tags $tagList
                #
            $cvObject create draftText $pt_11  -text $Miter(header)  -size 3.5 -tags $tagList
            $cvObject create draftText $pt_12  -text $Miter(text_01) -size 2.5 -tags $tagList
            $cvObject create draftText $pt_13  -text $Miter(text_02) -size 2.5 -tags $tagList
            $cvObject create draftText $pt_14  -text $Miter(text_03) -size 2.5 -tags $tagList
            $cvObject create draftText $pt_15  -text $Miter(text_04) -size 2.5 -tags $tagList
                #
            foreach {x y} $pt_logo break
            set coordList [list [expr $x - 40] [expr $y + 0] [expr $x + 40] [expr $y + 4]]
                #
            set tagID [myGUI::cvCustom::createWaterMark_Label   $cvObject     $coordList c]
                #
            $cvObject itemconfigure $tagID -width 0.3
                #
            $cvObject addtag        __tubeMiter__ withtag $tagID
                #
            puts "gettags: $tagID   [$cvObject gettags $tagID]"
                #
        }
    }
        #
    return
        #
} 

proc myGUI::tubeMiter::export_pdf {exportDir namePrefix} {
        #
    variable cvObject
        #
    $cvObject       fit    
        #
    set cvCanvas    [$cvObject getCanvas]
        #
        #
    set pageWidth   210
    set pageHeight  297
    set pageFormat  A4        
        #
        #
    set pdfFileName [format {%s_%s_tubeMiter.pdf} $namePrefix $pageFormat]
    set pdfFilePath [file join $exportDir $pdfFileName]
        #
        #
    puts "\n  -- myGUI::tubeMiter::export_pdf -------\n"
        #
        #   
    catch {mypdf destroy}
    pdf4tcl::new mypdf -paper A4 -landscape false -unit mm
        #
    set pageCoords    [$cvCanvas coords  __Stage__ ]
    puts "              $cvCanvas"
    puts "                     \$pageCoords   $pageCoords"
        #
        #
    array set miterGroup {}
    set miterGroup(__miterArea_01__) {__miterArea_01__ TopTube_Head     TopTube_Seat}
    set miterGroup(__miterArea_02__) {__miterArea_02__ DownTube_Head    DownTube_Seat}
    set miterGroup(__miterArea_03__) {__miterArea_03__ SeatTube_Down    SeatStay_01     SeatStay_02}
        #
    set miterAreas  [lsort [array names miterGroup]]
        #
        #
        # puts "\n\n  <I>   miterGroup: [lsort [array names miterGroup]] \n\n"    
        #
        #
    puts "     ... search __miterArea__  "
    foreach refArea [$cvCanvas find withtag __miterArea__] {
        # puts "          -> \$refArea $refArea"
        $cvObject itemconfigure $refArea -fill {white} -outline {white}
    }
        #
        #
    foreach miterArea $miterAreas {
            #
        puts "\n"
        puts "    ---- $miterArea --------------------------------\n"
            #
        set stageCoords    [$cvCanvas coords  $miterArea ]
        puts "                      -> $stageCoords"
            #
        set tag_Pos_x    [lindex $stageCoords 0]
        set tag_Pos_y    [lindex $stageCoords 1]
        set tag_Width    [expr [lindex $stageCoords 2] - $tag_Pos_x]
        set tag_Height   [expr [lindex $stageCoords 3] - $tag_Pos_y]
            #
        foreach myGroup [array names miterGroup] {
            puts "      -> $myGroup"
            if {$miterArea == $myGroup} {
                    # tk_messageBox -message "pause: $miterArea" 
                puts "                      ... raise $myGroup"
                $cvCanvas lower __tubeMiter__ __Stage__    
                puts "                           [array get miterGroup $myGroup]"
                set myMiters [lindex [array get miterGroup $myGroup] 1]
                foreach tubeMiter $myMiters {
                    puts "                           $tubeMiter"
                    $cvCanvas raise $tubeMiter all
                }
                $cvCanvas raise __Watermark_Label__ all
                    #
            }
        }   
            #
            # puts ""
            # puts ""
            # puts "myGUI::tubeMiter::export_pdf  000"
            # puts "\n"
            # puts "                         -> \$tag_Pos_x ....... $tag_Pos_x    "
            # puts "                         -> \$tag_Pos_y ....... $tag_Pos_y    "
            # puts "                         -> \$tag_Width ....... $tag_Width    "
            # puts "                         -> \$tag_Height ...... $tag_Height   <-  (215)"
            # puts "\n"
            #
        set tagPos_x     [$cvObject  getLength $tag_Pos_x]
        set tagPos_y     [$cvObject  getLength $tag_Pos_y]
        set tagWidth     [$cvObject  getLength $tag_Width]
        set tagHeight    [$cvObject  getLength $tag_Height]
            #
            # puts ""
            # puts "myGUI::tubeMiter::export_pdf  020"
            # puts "                         -> \$tagPos_x ....... $tagPos_x    "
            # puts "                         -> \$tagPos_y ....... $tagPos_y    "
            # puts "                         -> \$tagWidth ....... $tagWidth    "
            # puts "                         -> \$tagHeight ...... $tagHeight   <-  (215)"
            # puts ""
            # puts ""
            #
        set pdfPos_x  [expr 0.5 * ($pageWidth  - $tagWidth)]    
        set pdfPos_y  [expr 0.5 * ($pageHeight - $tagHeight)]    
            #
        puts "                     ... new pdf page"
        puts "                         -x      [format "%smm" $pdfPos_x]"
        puts "                         -y      [format "%smm" $pdfPos_y]"
        puts "                         -width  [format "%smm" $tagWidth]"
        puts "                         -height [format "%smm" $tagHeight]"
        puts "                         -bbox   $stageCoords"
            #
        mypdf startPage
            #
        mypdf canvas $cvCanvas  -x      [format "%smm" $pdfPos_x]  \
                                -y      [format "%smm" $pdfPos_y]  \
                                -width  [format "%smm" $tagWidth] \
                                -height [format "%smm" $tagHeight] \
                                -bbox   $stageCoords
            #
        mypdf endPage                        
            #
    }
        #
        #
    $cvCanvas raise __tubeMiter__ __Stage__
    foreach refArea [$cvCanvas find withtag __miterArea__] {
        puts "          -> \$refArea $refArea"
        puts "          -> [$cvObject type $refArea]"
        $cvObject itemconfigure $refArea -fill {} -outline {}
    }
        #
        #
    if {[catch {mypdf write -file $pdfFilePath} eID]} {
            #
        tk_messageBox -icon error -title "Export PDF" \
            -message "could not write file:\n   $pdfFilePath\n\n---<E>--------------\n$eID"
            #
        set pdfFilePath {}
            #
    }
        #
    mypdf destroy
        # 
        #
    return $pdfFilePath
        #
}



