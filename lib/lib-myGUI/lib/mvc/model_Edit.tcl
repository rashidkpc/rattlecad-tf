 ##+##########################################################################
 #
 # package: myGUI   ->  mvc::_mvc.tcl
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
 #    namespace:  myGUI::model_XZ
 # ---------------------------------------------------------------------------
 #
 #

    namespace eval myGUI::model::model_Edit {
            #
        variable ListBoxValues  ;   array set ListBoxValues {}
            #
        variable Component      ;   array set Component     {}
        variable Config         ;   array set Config        {}
        variable ListValue      ;   array set ListValue     {}
        variable Scalar         ;   array set Scalar        {}
            #
        variable Color          ;   array set Color         {}
            #
        variable _currentValue  ;   array set _currentValue {}
        variable _updateValue   ;   array set _updateValue  {}
    }
        #
    proc myGUI::model::model_Edit::setListBoxValues   {key value} {
        variable ListBoxValues
        array set ListBoxValues [list $key $value]
    }
    proc myGUI::model::model_Edit::getListBoxValues   {key} {
        variable ListBoxValues
        set listBoxContent [lindex [array get ListBoxValues  $key] 1]
        return $listBoxContent
    }
        #
    proc myGUI::model::model_Edit::setComponent   {key value} {
        variable Component
        array set Component [list ${key} ${value}]
    }
    proc myGUI::model::model_Edit::setConfig      {key value} {
        variable Config
        array set Config [list ${key} ${value}]
    }
    proc myGUI::model::model_Edit::setListValue   {key value} {
        variable ListValue
        array set ListValue [list ${key} ${value}]
    }
    proc myGUI::model::model_Edit::setScalar      {key value} {
        variable Scalar
        array set Scalar [list ${key} ${value}]
    }
        #
    proc myGUI::model::model_Edit::getValue       {arrayName key} {
        variable Component
        variable Config
        variable ListValue
        variable Scalar
        switch -exact $arrayName {
            Component   {set keyValue [array get Component  $key]}
            Config      {set keyValue [array get Config     $key]}
            ListValue   {set keyValue [array get ListValue  $key]}
            Scalar      {set keyValue [array get Scalar     $key]}
            default     {
                            puts "   myGUI::model::model_Edit::getValue ... $arrayName: $key"
                            set keyValue {a -199.99}
            }
        }
        return [lindex $keyValue 1]
    }
        #
    proc myGUI::model::model_Edit::__setColor__   {key value} {
        variable Color
        array set Color [list $key $value]
    }
    proc myGUI::model::model_Edit::__getColor__   {key} {
        variable Color
        return [lindex [array get Color $key] 1]
    }
        #
        
        #
    proc myGUI::model::model_Edit::reportListBoxValues {} {
            #
        variable ListBoxValues
            #
        puts "\n -- myGUI::model::model_Edit::reportListBoxValues -----"
            #
        parray ListBoxValues
            #
    }
    proc myGUI::model::model_Edit::reportValues {} {
            #
        variable Component
        variable Config   
        variable ListValue
        variable Scalar
            #
        variable Color
            #
        # variable _currentValue
        # variable _updateValue
            #
        
            #
        puts "\n -- myGUI::model::model_Edit::reportValues -----"
            #
        puts "\n ---- myGUI::model::model_Edit::Component ------"
        parray Component
        puts "\n ---- myGUI::model::model_Edit::Config ---------"
        parray Config
        puts "\n ---- myGUI::model::model_Edit::ListValue ------"
        parray ListValue
        puts "\n ---- myGUI::model::model_Edit::Scalar ---------"
        parray Scalar
        puts "\n ---- myGUI::model::model_Edit::Color -------"
        parray Color
            # puts "\n ---- myGUI::model::model_Edit::_currentValue --"
            # parray _currentValue
            # puts "\n ---- myGUI::model::model_Edit::_updateValue ---"
            # parray _updateValue
    }
