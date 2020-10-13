 ##+##########################################################################
 #
 # package: bikeFrame    ->    DiamondFrame.tcl
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

    
oo::class create bikeFrame::DiamondFrame {
        #
    superclass bikeFrame::AbstractFrame  
        #
    variable lug_BottomBracket             
    variable lug_RearDropout               
        #
    variable tube_DownTube
    variable tube_HeadTube             
    variable tube_SeatTube
    variable tube_TopTube        
    variable tube_ChainStay        
    variable tube_SeatStay        
        #
    variable init_ProjectDict
        #
        
        #
    constructor {} {
            #
        puts "              -> class DiamondFrame"
            #
        variable packageHomeDir $bikeFrame::packageHomeDir
        variable projectName    "myProject"
            #
        variable init_ProjectDict
            #
        variable _domProjectRoot
            #
            #
        variable lug_BottomBracket  [bikeFrame::ProvideBottomBracket    new]
        variable lug_RearDropout    [bikeFrame::ProvideRearDropout      new]
            #
        variable tube_DownTube      [bikeFrame::ProvideDownTube         new]                
        variable tube_HeadTube      [bikeFrame::ProvideHeadTube         new]                
        variable tube_SeatTube      [bikeFrame::ProvideSeatTube         new]                
        variable tube_TopTube       [bikeFrame::ProvideTopTube          new]                
        variable tube_ChainStay     [bikeFrame::ProvideChainStay        new]
        variable tube_SeatStay      [bikeFrame::ProvideSeatStay         new]                
            #
        variable templ_InputDict    
            #
            # puts "   -> \$packageHomeDir $packageHomeDir"    
            #
            #
            # -- extend lugs
            #
        # $lug_RearDropout        setBottomBracket    $lug_BottomBracket                
            #
            #
            # -- extend tubes
            #
        $tube_DownTube          setBottomBracket    $lug_BottomBracket
        $tube_DownTube          setHeadTube         $tube_HeadTube
        $tube_DownTube          setSeatTube         $tube_SeatTube
            #
        $tube_TopTube           setHeadTube         $tube_HeadTube
        $tube_TopTube           setSeatTube         $tube_SeatTube
            #
        $tube_SeatTube          setTopTube          $tube_TopTube
        $tube_SeatTube          setDownTube         $tube_DownTube
        $tube_SeatTube          setBottomBracket    $lug_BottomBracket
            #
        $tube_ChainStay         setBottomBracket    $lug_BottomBracket
        $tube_ChainStay         setRearDropout      $lug_RearDropout
            #
        $tube_SeatStay          setChainStay        $tube_ChainStay
        $tube_SeatStay          setSeatTube         $tube_SeatTube
        $tube_SeatStay          setTopTube          $tube_TopTube
        $tube_SeatStay          setRearDropout      $lug_RearDropout
            #
        
            #
            # -- initialize project
            #
        set initProject      [my getInitProject]
            #
            # set value           [dict get $projectDict $key Geometry Scalar HeadTube_Angle]    
            # puts "    -> \$value $value"
            #
        my initProject_DICT $initProject
            #
        
            #
        if 0 {
                #
                # -- init _domProjectRoot
                #
            set fp              [open [file join $packageHomeDir etc initDiamondFrame.xml]]
            fconfigure          $fp -encoding utf-8
            set projectXML      [read $fp]
            close               $fp          
            set projectDoc      [dom parse $projectXML]
            set _domProjectRoot [$projectDoc documentElement]
                #
            my initProject_DOM  $_domProjectRoot
                #
        }
            #
            #
        my updateGeometry
            #
        my updateShape    
            #
        puts ""
        puts "  ---- [info object class [self object]] ---- initialised ------------  [self object]"
        puts ""
            #
        return
            #
    }
        #
    method update {} {
            #
        puts "\n"
        puts "  ---- [info object class [self object]] ---- update -----------------  [self object]  "
            # puts "              ... called by [catch {self caller}]"  
        puts ""  
            #
        my updateGeometry
            #
        my updateShape
            #
        return
            #
    }
        #
    method updateGeometry {} {
            #
        puts "\n"
        puts "  ---- [info object class [self object]] ---- updateGeometry ---------  [self object]  "
        puts "              ... called by [catch {self caller}]"  
        puts ""  
            #
        variable lug_BottomBracket
        variable lug_RearDropout            
            #
        variable tube_DownTube
        variable tube_HeadTube
        variable tube_SeatTube
        variable tube_TopTube
        variable tube_ChainStay
        variable tube_SeatStay
            #
            #
        $tube_HeadTube      updateGeometry
        $tube_SeatTube      updateGeometry
        $tube_TopTube       updateGeometry
        $tube_DownTube      updateGeometry
            #   
        $tube_ChainStay     updateGeometry
            #
        $lug_RearDropout    updateGeometry
            #   
        $tube_SeatStay      updateGeometry
            #
            # $tube_TopTube reportValues    
            #
        return    
            #
    }
        #
    method updateShape {} {
            #
        puts "\n"
        puts "  ---- [info object class [self object]] ---- updateShape ------------  [self object]  "
        puts "              ... called by [catch {self caller}]"  
        puts ""  
            #
        variable lug_BottomBracket
        variable lug_RearDropout            
            #
        variable tube_DownTube
        variable tube_HeadTube
        variable tube_SeatTube
        variable tube_TopTube
        variable tube_ChainStay
        variable tube_SeatStay
            #
            #
        $tube_HeadTube      updateShape
        $tube_TopTube       updateShape
        $tube_DownTube      updateShape
        $tube_SeatTube      updateShape
            #   
        $tube_ChainStay     updateShape
        $tube_SeatStay      updateShape
            #
            # $lug_RearDropout    updateShape
            #
        return    
            #
    }
        #
    method initProject_DOM {projectNode} {
            #
        puts "\n\n\n\n\n"
        puts "  ---- [info object class [self object]] ---- initProject_DOM ------  [self object]  "
        puts ""  
            #
        variable lug_BottomBracket
        variable lug_RearDropout            
            #
        variable tube_DownTube
        variable tube_HeadTube
        variable tube_SeatTube
        variable tube_TopTube
        variable tube_ChainStay
        variable tube_SeatStay
            #
            
            #
        set debugMode 10
            #

            # puts "            initProject_DOM: $projectNode"
        if $debugMode {
            puts "[$projectNode asXML]"
        }
            #
        set node_Geometry                   [$projectNode selectNodes /root/Geometry]
            #
        set node_BottleCage_DownTube        [$projectNode selectNodes /root/BottleCage_DownTube]
        set node_BottleCage_DownTubeBottom  [$projectNode selectNodes /root/BottleCage_DownTubeBottom]
        set node_BottleCage_SeatTube        [$projectNode selectNodes /root/BottleCage_SeatTube]
            #
        set node_BottomBracket              [$projectNode selectNodes /root/BottomBracket]
        set node_RearDropout                [$projectNode selectNodes /root/RearDropout]
            #
        set node_DownTube                   [$projectNode selectNodes /root/DownTube]
        set node_HeadTube                   [$projectNode selectNodes /root/HeadTube]
        set node_SeatTube                   [$projectNode selectNodes /root/SeatTube]
        set node_TopTube                    [$projectNode selectNodes /root/TopTube]
        set node_ChainStay                  [$projectNode selectNodes /root/ChainStay]
        set node_SeatStay                   [$projectNode selectNodes /root/SeatStay]
            #
        if $debugMode {
                #
            puts "[$node_Geometry asXML]"
                #
            puts "[$node_BottleCage_DownTube asXML]"
            puts "[$node_BottleCage_DownTubeBottom asXML]"
            puts "[$node_BottleCage_SeatTube asXML]"
                #
            puts "[$node_DownTube asXML]"    
            puts "[$node_HeadTube asXML]"    
            puts "[$node_SeatTube asXML]"
            puts "[$node_TopTube asXML]"
            puts "[$node_ChainStay asXML]"
            puts "[$node_SeatStay asXML]"
                #
            puts "[$node_BottomBracket asXML]"    
            puts "[$node_RearDropout asXML]"    
        }
            #
        
            #
            # -- init components
            #
        $lug_BottomBracket              initValues  $node_BottomBracket
        $lug_RearDropout                initValues  $node_RearDropout
            #           
        $tube_HeadTube                  initValues  $node_HeadTube
        $tube_SeatTube                  initValues  $node_SeatTube
            #
        $tube_TopTube                   initValues  $node_TopTube
        $tube_DownTube                  initValues  $node_DownTube
        $tube_ChainStay                 initValues  $node_ChainStay
        $tube_SeatStay                  initValues  $node_SeatStay 
            #
            #
        my updateGeometry    
            #
        return
            #
    }
        #
    method initProject_DICT {projectDict} {
            #
        puts "\n\n\n\n\n"
        puts "  ---- [info object class [self object]] ---- initProject_DICT -----  [self object]  "
        puts ""  
            #
        variable lug_BottomBracket
        variable lug_RearDropout            
            #
        variable tube_DownTube
        variable tube_HeadTube
        variable tube_SeatTube
        variable tube_TopTube
        variable tube_ChainStay
        variable tube_SeatStay
            #
            
            #
        set debugMode 0
            #

            # puts "            initProject_DOM: $projectNode"
        if $debugMode {
            puts " --- "
            appUtil::pdict $projectDict 2 "    "
            puts " --- "
        }
            #
        set dict_BottomBracket              [dict get $projectDict BottomBracket]
        set dict_RearDropout                [dict get $projectDict RearDropout]
            #
        set dict_DownTube                   [dict get $projectDict DownTube]
        set dict_HeadTube                   [dict get $projectDict HeadTube]
        set dict_SeatTube                   [dict get $projectDict SeatTube]
        set dict_TopTube                    [dict get $projectDict TopTube]
        set dict_ChainStay                  [dict get $projectDict ChainStay]
        set dict_SeatStay                   [dict get $projectDict SeatStay]
            #
            # set dict_BottleCage_DownTube        [dict get $projectDict root BottleCage_DownTube]
            # set dict_BottleCage_DownTubeBottom  [dict get $projectDict root BottleCage_DownTubeBottom]
            # set dict_BottleCage_SeatTube        [dict get $projectDict root BottleCage_SeatTube]
            #
        if $debugMode {
                #
            appUtil::pdict $dict_DownTube       2 "    "    
            appUtil::pdict $dict_HeadTube       2 "    "    
            appUtil::pdict $dict_SeatTube       2 "    "
            appUtil::pdict $dict_TopTube        2 "    "
            appUtil::pdict $dict_ChainStay      2 "    "
            appUtil::pdict $dict_SeatStay       2 "    "
                #
            appUtil::pdict $dict_BottomBracket  2 "    "    
            appUtil::pdict $dict_RearDropout    2 "    "
                #
            # exit    
                #
                # appUtil::pdict $dict_BottleCage_DownTube  2 "    "
                # appUtil::pdict $dict_BottleCage_DownTubeBottom  2 "    "
                # appUtil::pdict $dict_BottleCage_SeatTube  2 "    "
                #
        }
            #
        
            #
            # -- init components
            #
            # puts "\n--> lug_BottomBracket"
        $lug_BottomBracket  initValues $dict_BottomBracket
            # puts "\n--> lug_RearDropout"
        $lug_RearDropout    initValues $dict_RearDropout
            #           
            # puts "\n--> tube_HeadTube"
        $tube_HeadTube      initValues $dict_HeadTube
            # puts "\n--> tube_SeatTube"
        $tube_SeatTube      initValues $dict_SeatTube
            #
            # puts "\n--> tube_TopTube"
        $tube_TopTube       initValues $dict_TopTube
            # puts "\n--> tube_DownTube"
        $tube_DownTube      initValues $dict_DownTube
            # puts "\n--> tube_ChainStay"
        $tube_ChainStay     initValues $dict_ChainStay
            # puts "\n--> tube_SeatStay"
        $tube_SeatStay      initValues $dict_SeatStay 
            #
        my updateGeometry    
            #
        my updateShape
            #
        return
            #
    }
        #
    method setSubset_DICT {paramDict} {
            #
        puts "\n\n\n\n\n"
        puts "  ---- [info object class [self object]] ---- setSubset_DICT -----  [self object]  "
        puts ""  
            #
            #
        set debugMode 0
            #

            # puts "            initProject_DOM: $projectNode"
        if $debugMode {
            puts " --- "
            appUtil::pdict $paramDict 2 "    "
            puts " --- "
        }
            #
        foreach key {BottomBracket RearDropout DownTube HeadTube SeatTube TopTube ChainStay SeatStay} {
            if {[dict exist $paramDict $key]} {
               #  puts "       -> exitsting in \$paramDict  \$key: $key"
                    #
                switch -exact -- {
                    BottomBracket -
                    RearDropout {
                        set myComponent [my getLug $key]
                    }
                    default {
                        set myComponent [my getTube $key]
                    }
                }
                set myDict  [dict get $paramDict $key]
                    #
                $myComponent initValues $myDict
                    #
                    # puts "\n-------------------------------------------------"
                    # puts "    -> [$myComponent getConfig Type]"
                    #
            } else {
                # puts "  <W> not exitsting in \$paramDict  \$key: $key"
            }
        }   
            #
        my updateGeometry    
            #
        my updateShape
            #
        return
            #
    }
        #
        #
    method getInitProject {} {
            #
        variable packageHomeDir
        variable init_ProjectDict
            #
        set fp              [open [file join $packageHomeDir etc initDiamondFrame.dict]]
        fconfigure          $fp -encoding utf-8
        set data            [read $fp]
        close               $fp
            #
        foreach {key keyDict} $data {
            # puts "  -> $key $keyDict"
            dict set init_ProjectDict $key $keyDict
        }
            # dict set templ_InputDict [join $data]
            #
        return $init_ProjectDict
            #
    }
        #
    method getInitKeys {} {
            #
        variable init_ProjectDict
            #
            # set myDict [dict get $templ_InputDict root]
        set keyList {}
        dict for {objKey objDict} $init_ProjectDict {
            dict for {typeKey typeDict} $objDict {
                dict for {nameKey nameValue} $typeDict {
                    # puts "  -> $objKey $typeKey $nameKey -> $nameValue"
                    # dict set myDict $objKey $typeKey $nameKey {}
                    lappend keyList "$objKey/$typeKey/$nameKey"
                }
            }
        }
        return $keyList
            #
    }
        #
    method getComponent {compName} {
            #
        switch -exact $compName {
            BottomBracket -
            RearDropout {
                    set lugObject   [my getLug  $compName]
                    return $lugObject
                }
            ChainStay -
            DownTube  -
            HeadTube  -
            SeatStay  -
            SeatTube  -
            TopTube {
                    set tubeObject  [my getTube $compName]
                    return $tubeObject
                }  
            __all {
                    set frameLugs   [my getLug  __all]
                    set frameTubes  [my getTube __all]
                    set listObject  [join $frameLugs $frameTubes " "]
                    return $listObject
                }
            default {
                    puts  "  <E> [info object class [self object]] ---- getComponent ---- [self object]"
                    # puts "              ... called by [catch {self caller}]"  
                    error "  <E> [info object class [self object]] ---- getComponent ---- [self object]"
                }
        }                
            #
    }            
        
        #
    method getLug {lugName} {
            #
        set listObject {}
        foreach objVarName [lsort [info object vars [self] lug_*]] {
            if [info exists $objVarName] {
                lappend listObject [set $objVarName]
            }
        }
            #
        switch -exact $lugName {
            BottomBracket   {return $lug_BottomBracket}
            RearDropout     {return $lug_RearDropout}
            __all           {return $listObject}
            default {return {}}
        }
            #
    }            
        
        #
    method getTube {tubeName} {
            #
        set listObject {}
        foreach objVarName [lsort [info object vars [self] tube_*]] {
            if [info exists $objVarName] {
                lappend listObject [set $objVarName]
            }
        }
            #
        switch -exact $tubeName {
            ChainStay       {return $tube_ChainStay}
            DownTube        {return $tube_DownTube}
            HeadTube        {return $tube_HeadTube}
            SeatStay        {return $tube_SeatStay}
            SeatTube        {return $tube_SeatTube}
            TopTube         {return $tube_TopTube}                
            __all           {return $listObject}
            default {return {}}
        }
            #
    }
        #
        #
    method computeBoundingBox {} {
            #
        variable tube_HeadTube
        variable tube_SeatTube            
        variable lug_BottomBracket
        variable lug_RearDropout
            #
        variable comp_FrontWheel
        variable comp_HandleBar
        variable comp_RearWheel
        variable comp_Saddle
            #
        variable myBoundingBox
            #
            # -- Summary
        set x1  [lindex [$lug_RearDropout   getPosition Origin] 0]
        set x2  [lindex [$tube_HeadTube     getPosition Origin] 0]
            #
        set y1  [lindex [$lug_BottomBracket getPosition Origin] 1]    
        set y2a 0  
        set y2b [lindex [$tube_HeadTube     getPosition End]    1]   
            #
        if {$y2a > $y2b} {
            set y2 $y2a
        } else {
            set y2 $y2b
        }
            #
        set myBoundingBox(Frame) [list $x1 $y1 $x2 $y2]
            #
        return
            #
    }
        #
    method getBoundingBox {{boxName {}}} {
        variable geometryObject
        return [$geometryObject getBoundingBox $boxName]
    }
        #
        #
    method getDictionary_TubeMiter {} {
            #
        variable tube_DownTube
        variable tube_HeadTube
        variable tube_SeatTube
        variable tube_TopTube
        variable tube_ChainStay
        variable tube_SeatStay
            #
            #
        set myDict      [dict create]
            #
            #
        set miterDict   [$tube_DownTube getMiterDict]
        foreach {key keyDict} $miterDict {
            dict set myDict TubeMiter   $key    $keyDict
        }
            #
        set miterDict   [$tube_TopTube  getMiterDict]
        foreach {key keyDict} $miterDict {
            dict set myDict TubeMiter   $key    $keyDict
        }
            #
        set miterDict   [$tube_SeatTube  getMiterDict]
        foreach {key keyDict} $miterDict {
            dict set myDict TubeMiter   $key    $keyDict
        }
            #
        set miterDict   [$tube_SeatStay  getMiterDict]
        foreach {key keyDict} $miterDict {
            dict set myDict TubeMiter   $key    $keyDict
        }
            #
            # --- Reference
            #
        set key     Reference
            #
        dict set myDict     TubeMiter   Reference   miterAngle      [format "%.3f" 0]
        dict set myDict     TubeMiter   Reference   polygon_01      [list "-50 0 50 0 50 10 -50 10"]
            #
        dict set myDict     TubeMiter   Reference   minorName       ReferenceWidth                         
        dict set myDict     TubeMiter   Reference   majorName       ReferenceHeight                     
        dict set myDict     TubeMiter   Reference   minorDiameter      0                             
        dict set myDict     TubeMiter   Reference   minorDirection     0                        
        dict set myDict     TubeMiter   Reference   minorPerimeter   100.00                        
        dict set myDict     TubeMiter   Reference   majorDiameter      0 
        dict set myDict     TubeMiter   Reference   majorDirection     1
        dict set myDict     TubeMiter   Reference   offset             0.00                        
        dict set myDict     TubeMiter   Reference   tubeType        cylinder 
        dict set myDict     TubeMiter   Reference   toolType        plane              
            #
            #
            #
        return $myDict            
            #
    }
        #
}
