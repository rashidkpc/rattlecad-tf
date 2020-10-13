 ########################################################################
 #
 # simplifySVG: lib_model.tcl
 #
 # Copyright (c) Manfred ROSENBERGER, 2017/11/26
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
  
namespace eval tubeMiter::app::createMiter::control {
        #
    variable mvcModel 
    variable mvcView 
    variable mvcControl
        #
}
    #
proc tubeMiter::app::createMiter::control::update {args} {
        #
    variable mvcModel 
    variable mvcView
    variable mvcControl
        #
    puts "  -> \$args $args"
        # ${mvcView}::ConfigMiter::checkValues
        #
    set configDict  [${mvcView}::getConfigDict]
        #
        # appUtil::pdict  $configDict  2 "  "
        #
    ${mvcModel}::update $configDict    
        #
    ${mvcView}::updateCanvas
        #
}
    #
    #
    #
proc tubeMiter::app::createMiter::control::init {w} {
        #
    variable mvcModel 
    variable mvcView
        #
    set mvcModel    [format {%s::model} [namespace parent]]
    set mvcView     [format {%s::view}  [namespace parent]]
        #
    ${mvcModel}::init
        #
    ${mvcView}::setMVC_Model    $mvcModel
    ${mvcView}::setMVC_Control  [namespace current]
        #
    ${mvcView}::init            $w
        #
    ${mvcView}::setMiterObject  [${mvcModel}::getMiterObject]
        #
    ${mvcView}::update
        #
    ${mvcView}::Canvas::updateGUI
        #
}
    #
proc tubeMiter::app::createMiter::control::getMVC_Model {} {
    variable mvcModel 
    return $mvcModel 
}
proc tubeMiter::app::createMiter::control::getMVC_View {} {
    variable mvcView
    return $mvcView
}
proc tubeMiter::app::createMiter::control::getMVC_Control {} {
    return [namespace current]
}
    #
proc tubeMiter::app::createMiter::control::setExportDir {dir} {
    variable mvcModel
    set exportDir   [${mvcModel}::setExportDir $dir]
    return $exportDir
}
    #
proc tubeMiter::app::createMiter::control::setPDFViewer {pdfViewer} {
    variable mvcModel
    set pdfViewer   [${mvcModel}::setPDFViewer $pdfViewer]
    return $pdfViewer
}
    #
proc tubeMiter::app::createMiter::control::exportMiter {} {
        #
    variable mvcModel
    variable mvcView
        #
    set pdfFilePath [${mvcView}::CanvasMiter::exportPDF]    
    set pdfViewer   [${mvcModel}::getPDFViewer]    
        #
    puts "   -> \$pdfFilePath $pdfFilePath"    
        #
        #
    if {$pdfFilePath eq {}} {
            #
        tk_messageBox \
                    -icon       error \
                    -title      "Export PDF" \
                    -message    "---<E>--------------\n<E> ... could not write file:\n   $pdfFilePath\n---<E>--------------\n"
            #
        return {}
            #
    }
        #
        #
    puts "   -> \$pdfViewer   $pdfViewer"
        #
    if {![catch {$pdfViewer [file normalize $pdfFilePath]} eID]} {
        return 1
    } else {
        puts "        <E> $eID"
    }
        #
        #
    set answer  [tk_messageBox \
                    -icon       question \
                    -title      "tubeMiter export successfully" \
                    -message    " ... could not open file: $pdfFilePath" \
                    -type       yesno \
                    -detail     "Select \"Yes\" to open directory"]       
        #
    puts "        -> $answer"    
        #
    if {$answer ne {yes}} {
        return
    }
        #
        #
    exec {*}[auto_execok start] "" [file nativename [file dirname $pdfFilePath]]
        #
        #
    return
        #
        #
}
    #
proc tubeMiter::app::createMiter::control::__xxx__ {} {
    return 
    
        #
        #
        #
    C:\Dateien\Eclipse\workspace\rattleCAD_3.4.05\customTube\lib\classTube.tcl:
        #
    method updateMiter_Origin {} {
            #
        variable Config    
        variable Scalar    
            #
        variable objMiterOrigin    
            #
        set miter(toolAngle)    [my getDictValue    MiterOrigin/toolAngle]
        set miter(toolRotation) [my getDictValue    MiterOrigin/toolRotation]
        set miter(toolType)     [my getDictValue    MiterOrigin/toolType]
        set miter(toolProfile)  [my getDictValue    MiterOrigin/toolProfile]
        set miter(toolOffset)   [my getDictValue    MiterOrigin/toolOffset]
        set miter(precision)    [my getDictValue    MiterOrigin/tubePrecision]
            #
            # puts "-- updateMiter_Origin\n"
            # puts "        -> \$miter(toolAngle)     $miter(toolAngle)"
            # puts "        -> \$miter(toolType)      $miter(toolType)"
            #
            #
        if {[format {%0.6f} $Scalar(Radius_X_Origin)] == [format {%0.6f} $Scalar(Radius_Y_Origin)]} {
            $objMiterOrigin setProfileDef \
                                [list   -type           round \
                                        -diameter       [expr 2 * $Scalar(Radius_X_Origin)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        } else {
            $objMiterOrigin setProfileDef \
                                [list   -type           oval \
                                        -diameter_x     [expr 2 * $Scalar(Radius_X_Origin)] \
                                        -diameter_y     [expr 2 * $Scalar(Radius_Y_Origin)] \
                                        -rotation       $miter(toolRotation) \
                                        -precision      $miter(precision)]
        }
            #
        switch -exact $miter(toolType) {
            frustum {
                set offset_x    [dict get $miter(toolOffset) x]
                set offset_y    [dict get $miter(toolOffset) y]
                    # puts "   -> \$miter(toolProfile) $miter(toolProfile)"
                foreach {lengthBase radiusBase lengthCone radiusTop} [lrange $miter(toolProfile) 2 5] break
                    # puts "    -> \$lengthBase    $lengthBase"
                    # puts "    -> \$radiusBase    $radiusBase"
                    # puts "    -> \$lengthCone    $lengthCone"
                    # puts "    -> \$radiusTop     $radiusTop"
                    #
                $objMiterOrigin setToolType                     frustum
                $objMiterOrigin setScalar  AngleTool            $miter(toolAngle)
                $objMiterOrigin setScalar  DiameterTool         [expr 2 * $radiusBase]   
                $objMiterOrigin setScalar  DiameterTop          [expr 2 * $radiusTop]  
                $objMiterOrigin setScalar  HeightToolCone       $lengthCone    
                $objMiterOrigin setScalar  OffsetCenterLine     $offset_x   
                $objMiterOrigin setScalar  OffsetToolBase       [expr $offset_y - $lengthBase] 
            }
            cylinder {
                set offset_x    [dict get $miter(toolOffset) x]
                set radiusTool  [lindex $miter(toolProfile) 1]
                $objMiterOrigin setToolType                     cylinder
                $objMiterOrigin setScalar   AngleTool           $miter(toolAngle)
                $objMiterOrigin setScalar   DiameterTool        [expr 2 * $radiusTool]   
                $objMiterOrigin setScalar   OffsetCenterLine    $offset_x   
            }
            plane -
            default {
                $objMiterOrigin setToolType                     plane 
                $objMiterOrigin setScalar   AngleTool           $miter(toolAngle)
            }
        }
            #
        $objMiterOrigin updateMiter
            #
    }    
        #  
}


