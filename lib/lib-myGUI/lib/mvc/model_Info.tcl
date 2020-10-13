 ##+##########################################################################
 #
 # package: myGUI   ->  mvc::model_Info.tcl
 #
 #   rattleCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2016/08/22
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
 #    namespace:  myGUI::model::model_Info
 # ---------------------------------------------------------------------------
 #
 #

    namespace eval myGUI::model::model_Info {
            #
        variable Project        ;   array set Project       {}
            #
        variable Dictionary     ;   array set Dictionary    {}
            #
        variable DOMNode        ;   array set DOMNode       {}
            #
        variable projectDoc     ;   set projectDoc [dom parse "<root/>"]
            #
    }
        #
    proc myGUI::model::model_Info::setProject {key value} {
            #
        variable    Project
        array set   Project     [list $key $value]
            #
    }
    proc myGUI::model::model_Info::getProject {key} {
            #
        variable    Project
        set keyValue [array get Project $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_Info::setDictionary {key value} {
            #
        variable    Dictionary
        array set   Dictionary  [list $key $value]
            #
    }
    proc myGUI::model::model_Info::getDictionary {key} {
            #
        variable    Dictionary
        set keyValue [array get Dictionary $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_Info::setDOMNode {key value} {
            #
        variable    DOMNode
            #
            
        array set   DOMNode     [list $key $value]
            #
    }
    proc myGUI::model::model_Info::getDOMNode {key} {
            #
        variable    DOMNode
        set keyValue [array get DOMNode $key]
        foreach {key value} $keyValue break
        return $value
            #
    }
        #
    proc myGUI::model::model_Info::setProjectDoc {projDoc} {
            #
        variable projectDoc
            #
        catch [$projectDoc delete]
            #
        set projectDoc [dom parse [$projDoc asXML]]
            #
    }
    proc myGUI::model::model_Info::getProjectDoc {} {
            #
        variable projectDoc
            #
        return $projectDoc
            #
    }