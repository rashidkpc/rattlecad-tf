package require tdom

set inputFileName   input_xPathList.txt
set outputFileName  output_xPathList.xml
    #
    #
variable xmlDoc
variable list_Level2
    #
set xmlDoc  [dom createDocument root]
    #
proc createNode {xPath} {
        #
    variable    xmlDoc
    set         xmlRoot [$xmlDoc documentElement]
        #
    set parentNode $xmlRoot
        #
    set namePath {}
    foreach name [split $xPath /] {
        set namePath [string trimleft [append namePath / $name ] /]
        puts "    -> $namePath"
        set thisNode    [$xmlRoot selectNodes $namePath]
        if {$thisNode == {}} {
            set newNode [$xmlDoc createElement $name]
            $parentNode appendChild $newNode
            set parentNode $newNode
        } else {
            set parentNode $thisNode
        }
    }
        #
    return $parentNode
        #
}
proc addTextNode {domNode textValue} {
        #
    variable    xmlDoc  [$domNode ownerDocument]
        #
    set newNode [$xmlDoc createTextNode  $textValue]
    $domNode appendChild $newNode
        #
    return $newNode
        #
}
    #
proc gatherLevel2 {xPath} {
    variable list_Level2
    set level2  [lindex [split $xPath /] 1]
    if {$level2 != {}} {
        lappend list_Level2 $level2
    }
    set list_Level2 [lsort -unique $list_Level2]
}
    #
set lineList    {}
    #
set fp [open $inputFileName r]
while { [gets $fp data] >= 0 } {
     lappend lineList $data
}
close $fp
    #
foreach line $lineList {
    # puts "   ... $line"
    foreach {xPath value} [split $line =] break
    set xPath [string trim $xPath]
    set value [string trim $value]
    puts "   ... $xPath"
    
}
    #
    #
set comment         [$xmlDoc createComment "this is a comment"]
[$xmlDoc documentElement] appendChild $comment
    #
    #
foreach line [lsort $lineList] {
        # puts "   ... $line"
    gatherLevel2 $line
        #
    foreach {xPath textValue} [split $line =] break
    set xPath       [string trim $xPath]
    set textValue   [string trim $textValue]
    set myPath {}
    set parentPath /
    set newNode [createNode     $xPath]
    set newNode [addTextNode    $newNode $textValue]
        # puts "[$newNode asXML]"
}
    #
puts [[$xmlDoc documentElement] asXML]
    #
set fp [open $outputFileName w]
puts -nonewline $fp [[$xmlDoc documentElement] asXML]
close $fp    
#    
puts $list_Level2   

