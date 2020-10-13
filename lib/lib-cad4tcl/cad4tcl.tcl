 ########################################################################
 #
 #  This software is copyrighted by Manfred Rosenberger and other parties.  
 #  The following terms apply to all files associated with the software unless
 #  explicitly disclaimed in individual files.
 #  
 #  The authors hereby grant permission to use, copy, modify, distribute,
 #  and license this software and its documentation for any purpose, provided
 #  that existing copyright notices are retained in all copies and that this
 #  notice is included verbatim in any distributions. No written agreement,
 #  license, or royalty fee is required for any of the authorized uses.
 #  Modifications to this software may be copyrighted by their authors
 #  and need not follow the licensing terms described here, provided that
 #  the new terms are clearly indicated on the first page of each file where
 #  they apply.
 #  
 #  IN NO EVENT SHALL THE AUTHORS OR DISTRIBUTORS BE LIABLE TO ANY PARTY
 #  FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 #  ARISING OUT OF THE USE OF THIS SOFTWARE, ITS DOCUMENTATION, OR ANY
 #  DERIVATIVES THEREOF, EVEN IF THE AUTHORS HAVE BEEN ADVISED OF THE
 #  POSSIBILITY OF SUCH DAMAGE.
 #  
 #  THE AUTHORS AND DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES,
 #  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY,
 #  FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.  THIS SOFTWARE
 #  IS PROVIDED ON AN "AS IS" BASIS, AND THE AUTHORS AND DISTRIBUTORS HAVE
 #  NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 #  MODIFICATIONS.
 #  
 #  GOVERNMENT USE: If you are acquiring this software on behalf of the
 #  U.S. government, the Government shall have only "Restricted Rights"
 #  in the software and related documentation as defined in the Federal 
 #  Acquisition Regulations (FARs) in Clause 52.227.19 (c) (2).  If you
 #  are acquiring the software on behalf of the Department of Defense, the
 #  software shall be classified as "Commercial Computer Software" and the
 #  Government shall have only "Restricted Rights" as defined in Clause
 #  252.227-7013 (c) (1) of DFARs.  Notwithstanding the foregoing, the
 #  authors grant the U.S. Government and others acting in its behalf
 #  permission to use and distribute the software in accordance with the
 #  terms specified in this license.
 # 
 # ----------------------------------------------------------------------
 #
 #  Copyright (c) Manfred ROSENBERGER, 2017
 #
 # ----------------------------------------------------------------------
 #  http://www.magicsplat.com/articles/oo.html
 # ----------------------------------------------------------------------
 #
 #  rattleCAD 3.4.05:
 #          http://rattlecad.sourceforge.net/
 #          https://sourceforge.net/projects/rattlecad/
 #  
 #  vectorfont:
 #          Copyright (c) Gerhard Reithofer, 2006/12/27
 #  
 #  simplifySVG:
 #          is a library developed in the rattleCAD - project 
 #  
 #  other sources:
 #  
 #      rotate_item:
 #          kvetter@DELETETHIS.alltel.net
 #          http://wiki.tcl.tk/8595
 #      zoom:
 #          masse-navette.glfs@wanadoo.fr
 #          http://wiki.tcl.tk/4844
 #      vector algorythms:
 #          kvetter@DELETETHIS.alltel.net
 #          http://wiki.tcl.tk/8447
 #  
 #       http://www.magicsplat.com/articles/oo.html
 #
 # ----------------------------------------------------------------------
 # 
 #  2017/11/26
 #      ... extracted from the rattleCAD-project (Version 3.4.05) by
 #          the author of rattleCAD
 #
 # ----------------------------------------------------------------------
 #  namespace:  cad4tcl
 # ----------------------------------------------------------------------
 #
 #

 
    #
package provide cad4tcl 0.01
    #
package require TclOO
package require Tk
package require tdom
package require vectormath
    # package require math            1.2.5
    # package require math::geometry

    #
catch { package require pdf4tcl 0.9.1 }
catch { package require tkpath }
    #

    # -----------------------------------------------------------------------------------
    #
    #: Functions : namespace      c a n v a s C A D
    #

namespace eval cad4tcl {

    # --------------------------------------------
        # Export as global command
    namespace  export newCanvas 

    # --------------------------------------------
        #
    variable packageHomeDir [file dirname [file normalize [info script]]]
        set fp [open [file join $packageHomeDir etc cad4tcl.xml] ]
        fconfigure    $fp -encoding utf-8
    set __packageXML [read $fp]
        close         $fp
        
    variable canvasType         0   ;# antialiasing canvas
    variable DIN_Format         {}
    variable precValue          1
    
    set __packageDoc  [dom parse $__packageXML]
    set __packageRoot [$__packageDoc documentElement]
    
    variable canvasFactory  {}
        #
    variable debugItemTypes; array set debugItemTypes {}
        #
    lappend auto_path [file join $packageHomeDir lib]
        # 
        # -- apps
        # ---- simplifySVG
    puts "       cad4tcl -> \$packageHomeDir $packageHomeDir"
    lappend auto_path [file join $packageHomeDir app simplifySVG]
    package require cad4tcl_simplifySVG    
        # 
}

    #-------------------------------------------------------------------------
    #  create new Canvas Object
    #
proc cad4tcl::new {w width height stageFormat stageScale stageBorder args} {
        #
    variable canvasFactory
        #
        # -- create factory object if not allready existing --- 
    if {$canvasFactory eq {}} {
        set canvasFactory [cad4tcl::CanvasFactory new]
            # -- init vectorfont
        vectorfont::load_shape m_iso8.shp
        vectorfont::setscale 1.0 
    }
        #
    puts "    ... cad4tcl::new $w $stageFormat"
        #
        # -- update stageFormat for internal use ----------
        #       possible formats see: ./etc/dataFormat.xml
    switch -exact $stageFormat {
        passive -
        {}      {set stageFormat {noFormat}}
    }
        #
        # -- create the canvas Object --------------------- 
    set cvObject [$canvasFactory create  $w  $width  $height  $stageFormat  $stageScale  $stageBorder  $args]
        #
        # -- done -----------------------------------------
    puts "    ... cad4tcl::new $cvObject"
        #
    return $cvObject
        #
}

    #-------------------------------------------------------------------------
    #  get report XML
    #
proc cad4tcl::getReportDOC {} {
        #
    variable canvasFactory
        #
    if {$canvasFactory eq {}} {
        set xmlDoc  [dom parse [[getXMLRoot] asXML]]
        set xmlRoot [$xmlDoc documentElement]
        foreach node [$xmlRoot childNodes] {
            if {[$node nodeName] eq {instance}} {
                $xmlRoot removeChild $node
                $node delete
            }
        }
        return $xmlDoc
    } else {
        set xmlDoc  [$canvasFactory getMemberDOM]     
        return $xmlDoc
    }
        #
}

    # --------------------------------------------
    #     operation handler
    #     each operation has to be registered
proc cad4tcl::ObjectMethods {name method argList} {
        # puts " ObjectMethods  $name  $method  $argList"
    variable debugItemTypes    
        #
    switch -exact -- $method {
            # ------------------------            
        default {           
                #
            puts "\n"
            puts "      -> cad4tcl::ObjectMethods $name $method $argList"
            puts "\n"
                #
            set canvasDOMNode   [getNodeRoot [format "/root/instance\[@id='%s'\]" $name] ]
            set cv              [getNodeAttribute $canvasDOMNode Canvas path]
            eval $cv $method $argList
            return -code error  "\"$name $method\" is not defined"
                #
        }
    }
}

    #-------------------------------------------------------------------------
    #  get character of vectorfont
    #
proc cad4tcl::characterList {} {     
    # puts "  -- characterList_Vector"
    return [vectorfont::get_characterList]
}

