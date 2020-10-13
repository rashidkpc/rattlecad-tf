 ##+##########################################################################
 #
 # frustumMiter.tcl
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
 # 0.01 2016-01-04   new: coneMiter, many thanks to Peter Dalhoff
 # 0.05 2017-05-24   new: refactoring from rattlecAD 3.4.04
 #
 #
    #
    #-------------------------------------------------------------------------
    #  coneMiter
    #
    #                              
    #                                |<-->|  frustum_TopRadius [mm]
    #                                |    | 
    #                           + -- +----+ 
    #                           |    |    | 
    #                           |    |    | 
    #                           +----+----+  -------------------------
    #          miterAngle [°]  /     |     \                        A
    #                         /      |      \                       |
    #         -----   +------+       |       \                      |
    #          A     /\       +      |        \                     |
    #          |     \/        +     |         \                    | 
    #          |   - / - - - - + - - o -        \  -----------      |
    #          |     |        +      |           \          A       | frustum_Height [mm]
    #          V     \      +        |            \         |       |
    #         -----   +-+ °          |             \        | hks   |   
    #    tubeRadius    /             |              \       |       |
    #       [mm]      /              |               \      V       V
    #                +---------------+----------------+  -------------
    #                |               |                |
    #                |               |                |
    #                +---------------+----------------+
    #                                |                |
    #                                |<-------------->|  frustum_BaseRadius [mm]
    #                              
    #
    # ... with many thanks to 
    #                      Peter Dalhoff
    #
    #
    #
oo::class create tubeMiter::FrustumMiter {
        #
        # this class will be sourced by concrete classes like
        # like triangles, squares, pentagons, hexagons ...
        #
    superclass tubeMiter::AbstractTubeMiter
        #
    variable coneDict_3D
        #
    variable cylinderTop
    variable coneMiddle
    variable cylinderBase   
        #
    constructor {} {
            #
        puts "              -> class FrustumMiter"    
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
            # tubeMiter::coneMiter {frustum_BaseRadius frustum_TopRadius frustum_Height tubeRadius miterAngle hks}
            #
            # coneMiter $frustum_BaseRadius $frustum_TopRadius $frustum_Height $tubeRadius $miterAngle $hks
            #     ... previous   {R_Frustum_Base R_Frustum_Top H_Frustum R_Tube alpha hks}
            #
            #   frustum_BaseRadius ... Radius des Kegelstumpf unten
            #   frustum_TopRadius .... Radius des Kegelstumpf oben
            #   frustum_Height ....... Höhe des Kegelstumpf    
            #
            #   tubeRadius ........... Radius Zylinder in mm
            #   miterAngle ........... Schnittwinkel in grad (FrustumTop -> Joint <- Tube)
            #   hks .................. Höhe von Kegelfuß bis Achsenschnittpunkt
            #
            #
            # puts "tubeMiter::coneMiter: \$frustum_BaseRadius    $frustum_BaseRadius"
            # puts "tubeMiter::coneMiter: \$frustum_TopRadius     $frustum_TopRadius"
            # puts "tubeMiter::coneMiter: \$frustum_Height        $frustum_Height"
            # puts "tubeMiter::coneMiter: \$tubeRadius            $tubeRadius"
            # puts "tubeMiter::coneMiter: \$miterAngle            $miterAngle"
            # puts "tubeMiter::coneMiter: \$hks                   $hks"   
            #
            #
        variable Scalar
            #
        variable dict3D_Final   
            #
        variable objProfile
            #
        variable cylinderTop     
        variable coneMiddle     
        variable cylinderBase
            #
            #
            # puts "    -> updateMiter3D - procMiter "
            #
        set Scalar(RadiusTool)  [expr {0.5 * $Scalar(DiameterTool)}]
        set Scalar(RadiusTop)   [expr {0.5 * $Scalar(DiameterTop)}]
            # parray Scalar
            #
        set dictMiter           {}
            #
        if {![info exist cylinderTop]} {
            set cylinderTop     [tubeMiter::createMiter cylinder]  
        }
            #
        set profileName [$objProfile getProfileType]    
        set objProfile  [my getProfileObject]    
        $objProfile     update
            #
            # my              reportValues
            #
            # $objProfile     reportValues
            #
            #
        if {$Scalar(DiameterTool) == $Scalar(DiameterTop)} {
                #
            $cylinderTop    setScalar   AngleTool           $Scalar(AngleTool)
            $cylinderTop    setScalar   DiameterTool        $Scalar(DiameterTop)
            $cylinderTop    setScalar   OffsetCenterLine    $Scalar(OffsetCenterLine)
            $cylinderTop    setScalar   Precision           $Scalar(Precision)
                #
            $cylinderTop    setProfile                      $objProfile
                #
            $cylinderTop    createProfileDict
            $cylinderTop    createMiter
            $cylinderTop    updateViews
                #
            set dict3D_Final    [$cylinderTop   getDictionary]
                #
            return
                #
        }
            #
        set k                   [expr {($Scalar(RadiusTool) - $Scalar(RadiusTop)) / $Scalar(HeightToolCone)}]
        set length_00           [expr {$Scalar(RadiusTool) / $k}]
        set heightCone          [expr {$length_00 - $Scalar(OffsetToolBase)}]
        set diameterCone        [expr {2.0 * $heightCone * $k}]                
                #
        if {![info exist coneMiddle]} {
            set coneMiddle      [tubeMiter::createMiter cone]    
        }
        if {![info exist cylinderBase]} {
            set cylinderBase    [tubeMiter::createMiter cylinder]    
        }
            #
            # puts ""
            # puts " -- frustum ----"
            # puts ""
            # puts "     -> \$objProfile   $objProfile"
            # puts "     -> \$cylinderTop  [$cylinderTop  getProfileObject]"
            # puts "     -> \$coneMiddle   [$coneMiddle   getProfileObject]"
            # puts "     -> \$cylinderBase [$cylinderBase getProfileObject]"
            #
            # $objProfile reportValues2    
            #
            #
        $cylinderTop    setScalar   AngleTool           $Scalar(AngleTool)
        $cylinderTop    setScalar   DiameterTool        $Scalar(DiameterTop)
        $cylinderTop    setScalar   OffsetCenterLine    $Scalar(OffsetCenterLine)
        $cylinderTop    setScalar   Precision           $Scalar(Precision)
            #
        $cylinderTop    setProfile                      $objProfile
            #
        $cylinderTop    createProfileDict
        $cylinderTop    createMiter
        $cylinderTop    updateViews
            #
            #
        $coneMiddle     setScalar   AngleTool           $Scalar(AngleTool)
        $coneMiddle     setScalar   DiameterTool        $diameterCone   
        $coneMiddle     setScalar   HeightToolCone      $heightCone      
        $coneMiddle     setScalar   OffsetCenterLine    $Scalar(OffsetCenterLine)
        $coneMiddle     setScalar   Precision           $Scalar(Precision)
            #
        $coneMiddle     setProfile                      $objProfile
            #
        $coneMiddle     createProfileDict
        $coneMiddle     createMiter
        $coneMiddle     updateViews
            #
            #
        $cylinderBase   setScalar   AngleTool           $Scalar(AngleTool)
        $cylinderBase   setScalar   DiameterTool        $Scalar(DiameterTool)
        $cylinderBase   setScalar   OffsetCenterLine    $Scalar(OffsetCenterLine)
        $cylinderBase   setScalar   Precision           $Scalar(Precision)
            #
        $cylinderBase   setProfile                      $objProfile
            #
        $cylinderBase   createProfileDict
        $cylinderBase   createMiter
        $cylinderBase   updateViews
            #
            # $objProfile reportValues2 
            #            
        set seg01_dictionary    [$cylinderTop   getDictionary]
        set seg02_dictionary    [$coneMiddle    getDictionary]
        set seg03_dictionary    [$cylinderBase  getDictionary]            
            #
            # puts "     -> \$seg01_dictionary $seg01_dictionary"    
            # puts "     -> \$seg02_dictionary $seg02_dictionary"    
            # puts "     -> \$seg03_dictionary $seg03_dictionary"    
            #
        foreach key [lsort [dict keys $seg02_dictionary]] {
                #
                #
            set dict02(a)   [dict get $seg02_dictionary $key phi_grd]
                #
            if {$dict02(a) >= -360 && $dict02(a) <= 360} {
                    #
                set dict01(r)   [dict get $seg01_dictionary $key rTool]
                    #
                set dict02(r)   [dict get $seg02_dictionary $key rTool]
                    #
                set dict03(r)   [dict get $seg03_dictionary $key rTool]
                    #
                    # puts "      $dict02(a) --> $dict01(r) -> $dict02(r) -> $dict03(r)"
                    # appUtil::pdict  [dict get $seg01_dictionary $key]  
                    #
                    
                set i_key           [dict get $seg02_dictionary $key i]
                set i_angle         [dict get $seg02_dictionary $key phi_grd]
                set x               [dict get $seg02_dictionary $key x]
                set y               [dict get $seg02_dictionary $key y]
                    # set i_angle         [dict get $seg02_dictionary $key i_angle]
                    #
                    # puts " ---- 0001 ----"    
                set r_Tool      $dict02(r)
                set z_Tube      [dict get $seg02_dictionary $key z]
                set z_Tool      [dict get $seg02_dictionary $key zTool]
                    #
                if {$dict01(r) > $dict02(r)} {
                    # puts " ---- 0002 ----"    
                    set r_Tool  $dict01(r)
                    set z_Tube  [dict get $seg01_dictionary $key z]
                    set z_Tool  [dict get $seg01_dictionary $key zTool]
                }
                if {$dict03(r) < $dict02(r)} {
                    # puts " ---- 0003 ----"    
                    set r_Tool  $dict03(r)
                    set z_Tube  [dict get $seg03_dictionary $key z]
                    set z_Tool  [dict get $seg03_dictionary $key zTool]
                }
                     #
                set phi_grd         [dict get $seg02_dictionary $key phi_grd]
                set phi_rad         [dict get $seg02_dictionary $key phi_rad]
                set perimeter       [dict get $seg02_dictionary $key perimeter]
                    #
                dict set indexDictionary $key   i           $i_key
                dict set indexDictionary $key   i_angle     $i_angle
                dict set indexDictionary $key   x           $x      
                dict set indexDictionary $key   y           $y
                dict set indexDictionary $key   z           $z_Tube
                dict set indexDictionary $key   rTool       $r_Tool
                dict set indexDictionary $key   zTool       $z_Tool
                dict set indexDictionary $key   phi_grd     $phi_grd
                dict set indexDictionary $key   phi_rad     $phi_rad
                dict set indexDictionary $key   perimeter   $perimeter
                    #
            }
        }
            #
        set dict3D_Final    $indexDictionary    
            #
        return
            #
    }
        #
}
    
