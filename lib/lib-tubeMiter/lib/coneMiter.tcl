 ##+##########################################################################
 #
 # ConeMiter.tcl
 #
 #   tubeMiter is software of Manfred ROSENBERGER
 #       based on tclTk and their 
 #       own Licenses.
 # 
 # Copyright (c) Manfred ROSENBERGER, 2016/01/01
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
        #
        #-------------------------------------------------------------------------
        #  cylinderMiter
        #
        #                              
        #                           +--------+--------+
        #        miterAngle [°]     |        |        |
        #                           |        |        |
        #         ----    +---------+        |        |
        #          ^     /\          \       |        |
        #          |     \/           |      |        |
        #          |   - / - - - - - -+- - - o        |
        #          |     |            |      |        |
        #          V     \           /       |        |
        #         ----    +---------+        |        |
        #                           |        |        |
        #    tubeRadius [mm]        |        |        |
        #                           +--------+--------+
        #             right                  |        |
        #                                    |<------>|    toolRadius [mm]
        #
        #
        #
        # from bikeGeometry::tube_intersection
        #
        #
        #
oo::class create tubeMiter::ConeMiter {
        #
        # this class will be sourced by concrete classes like
        # like triangles, squares, pentagons, hexagons ...
        #
    superclass tubeMiter::AbstractTubeMiter
        #
    constructor {} {
            #
        puts "              -> class ConeMiter"    
            #
        next
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
    method updateMiter {} {
            #
        my updateProfileObj
        my createProfileDict
            #
        my createMiter
            #
        my updateViews
            #
    }
        #    
    method createMiter {} {
            #
            # ... toolRadius tubeRadius miterAngle {side {right}} {offset {0}}  {startAngle {0}}  {opposite {no}}
            #
            # side: 
            #       ... right: top view of tube, on the right end of the tube
            #       ... left:                 ... on the left end of the tube
            #
        variable Scalar
            #
        variable dictProfile
        variable dict3D_Final   
            #
            #
        set dictMiter       {}
            #
        set gamma           [vectormath::rad [expr {90 - $Scalar(AngleTool)}]]
        set radiusTool      [expr {0.5 * $Scalar(DiameterTool)}]
            #
        dict for {key keyDict} $dictProfile {
                #
            set x           [dict get $keyDict  x1]                 ;# ... perpendicular to tube axis, in plane of tube- and cone axis
            set y           [dict get $keyDict  y1]                 ;# ... perpendicular offset of surface line in plane of x and y axis
                #
            set x_Tool      [expr {$x - $Scalar(OffsetCenterLine)}] ;# ... cutting plane offset in regard of offset of tube centerline
                #
                #
            lassign [tubeMiter::CutCone  $radiusTool  $Scalar(HeightToolCone)  $x_Tool  $y  $Scalar(AngleTool)] \
                pos_01 pos_02
            lassign  $pos_01 \
                z_Tube y_01 r_Tool     ;# ... $y_02 should be equal to $y_Tube
                # foreach {pos_01 pos_02} [tubeMiter::CutCone  $radiusTool  $Scalar(HeightToolCone)  $x_Tool  $y  $Scalar(AngleTool)]  break
                # foreach {z_Tube y_01 r_Tool} $pos_01  break     ;# ... $y_02 should be equal to $y_Tube
                #
            set z_Tool_1    [expr {$y / cos($gamma)}]       ;# ... cutting offset in cone(z) axis
            set z_Tool_2    [expr {$z_Tube * sin($gamma)}]  ;# ... cutting offset of surface line in x/y perpendicular to cone(z) axis
            set z_Tool      [expr {$z_Tool_1 - $z_Tool_2}]  ;# ... cutting offset representing a cylinder cutting in this position
                #
                #
            dict set dictMiter  $key   $keyDict   
                #
            dict set dictMiter  $key   z           $z_Tube
            dict set dictMiter  $key   rTool       $r_Tool
            dict set dictMiter  $key   zTool       $z_Tool
                #
        }
            #
        # appUtil::pdict  $dictMiter
            #
        set dict3D_Final    $dictMiter    
            #
        return                
            #
    }
        #    
    method getToolShape {} {
            #
        variable Scalar
            #
        set heightTool  $Scalar(HeightToolCone)
        set radiusTool  $Scalar(RadiusTool)
            #
        set pos_00      {0 0}
        set pos_10      [list [expr {-1.0 * $radiusTool}] 0]
        set pos_99      [list 0 $heightTool]
        set pos_01      [list [expr { 1.0 * $radiusTool}] 0]
            #
        set polygon_z   [join "$pos_00 $pos_10 $pos_99 $pos_01" " "]    
            #
        return $polygon_z    
            #
    }
        #
}