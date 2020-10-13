set dir  [file normalize [file dirname [info script]]]
set tail [file tail [info script]]
    #
lappend auto_path [file normalize [file dirname $dir]]
puts "  -> [file normalize $dir]"
puts "  -> [file normalize [file dirname $dir]]"
puts "  -> \$auto_path  $auto_path"
    #
foreach fileName [glob -nocomplain -directory $dir *.tcl] {
    if {[file tail $fileName] ne $tail} {
        source $fileName
    }
}