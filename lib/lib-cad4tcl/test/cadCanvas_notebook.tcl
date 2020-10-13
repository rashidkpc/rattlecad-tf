 ########################################################################
 #
 # test_cad4tcl.tcl
 # by Manfred ROSENBERGER
 #
 #   (c) Manfred ROSENBERGER 2017/11/26
 #
 #


	set WINDOW_Title      "cad4tcl, an extension for canvas"

	  
    set BASE_Dir  [file normalize [file dirname [file normalize $::argv0]]] 
    
    set APPL_ROOT_Dir [file normalize [file dirname [lindex $argv0]]]
    puts "   \$APPL_ROOT_Dir ... $APPL_ROOT_Dir"
    set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
    puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
    
    lappend auto_path [file dirname $APPL_ROOT_Dir]
    
    lappend auto_path "$APPL_Package_Dir/vectormath"
    
    lappend auto_path "$APPL_Package_Dir/lib-vectormath"
        
	package require   Tk
    package require   vectormath
    package require   cad4tcl
    
    variable APPL_ROOT_Dir
    variable cv01
    variable cv02
    variable cv03
    variable cv04
    
			
	#-------------------------------------------------------------------------
		#  open File 
		#
	proc openFile {{file {}}} {
		
		puts "\n -- openFile--"
		if {$file == {} } {
			set file [tk_getOpenFile]
		}
        set fileExtension [file extension $file]
        puts "        ... $fileExtension"
        switch -exact $fileExtension {
            {.svg}   {openFile_svg   $file}
            {.gif}   {open_imageFile $file}
            {.png}   {open_imageFile $file}
            default {
                        puts "\n ... sorry, dont know how to handle this FileType\n"
            }
        }
	}
			
	#-------------------------------------------------------------------------
		#  open File Type: gif, ...
		#
	proc open_imageFile {imgFile {x 200} {y 150} {anchor center}} {
		
		return
        
        global cv03
        global cv04
            #
        set cvCAD $cv04    
            #
        #set x "200"
        #set y "150"
            #
        puts "\n -- openFile_image -- $imgFile"
        set cvPath [$cvCAD getNodeAttr	    Canvas	path]
            #
        puts "          -> $cvPath"
        set myImage [image create photo -file $imgFile]
        set imageHeigth [image height $myImage]
        set imageWidth  [image width  $myImage]
            #
        puts "          -> \$myImage $myImage"
        puts "                 ->    \$x  $x"
        puts "                 ->    \$y  $y "
        puts "                 -> \$imageHeigth $imageHeigth"
        puts "                 -> \$imageWidth  $imageWidth "
            #
        set pos_x0 $x
        set pos_y0 $y
        set pos_x1 [expr $x + 100]
        set pos_y1 [expr $y + 150]
        #set pos_x [$x + 0.5 * $imageWidth]
        #set pos_y [$y + 0.5 * $imageHeigth]
            #
        #$cvPath create image    $x $y   -anchor nw -image $myImage
        #$cvPath create image    $pos_x $pos_y   -anchor center -image $myImage
            #
        $cvCAD  readImage $imgFile [list $pos_x0 $pos_y0]   $anchor     0   {__myImage__} 
		# $cvCAD  readImage $file [list $pos_x1 $pos_y1]   20  {__myImage__} 
		$cvCAD  create circle      [list $pos_x0 $pos_y0]   -radius 30 -tags {Line_01}  -outline red   -width 4 
				    
            
            
		#$cv03 readSVG $file {120 200} 0 AB
		#$cv03 readSVG $file {320 400} 
		
	}
			
	#-------------------------------------------------------------------------
		#  open File Type: svg
		#
	proc openFile_svg {{file {}}} {
		
		global cv03
		
		$cv03 readSVG $file {120 200} 0 AB
		$cv03 readSVG $file {320 400} 
		
	}
			
	#-------------------------------------------------------------------------
		#  open File Type: xml
		#
	proc add_cfgCorner {cv cmd} {	
		$cv configCorner ${cmd}  
        return

	}

    proc drag.canvas.item {canWin item newX newY} {
        puts "drag.canvas.item"
        set xDiff [expr {$newX - $::x}]
        set yDiff [expr {$newY - $::y}]
    
        set ::x $newX
        set ::y $newY
    
        puts "$xDiff -> $newX"
        puts "$yDiff -> $newY"
        $canWin move $item $xDiff $yDiff
    } 		

    proc main {} {
        # --------------------------------------------
        global APPL_ROOT_Dir
        global cv01
        global cv02
        global cv03
        global cv04
        
        
        pack [ frame .f ] -expand yes -fill both
	
		# --------------------------------------------
				# 	notebook
        pack [ ttk::notebook .f.nb] -fill both  -expand yes
	
	
		# --------------------------------------------
				# 	tab 1
			.f.nb add [frame .f.nb.f1] -text "First tab" 

			set f1_canvas  [labelframe .f.nb.f1.f_canvas   -text "board"  ]
			set f1_config  [frame      .f.nb.f1.f_config   ]

			pack  $f1_canvas  $f1_config    -side left -expand yes -fill both
			pack  configure   $f1_config    -fill y
			
			set cvObject    [cad4tcl::new  $f1_canvas  880  610  A3  0.5  40]
            set w           [$cvObject getCanvas]    
				
            $cvObject   create   line  		{0 0 20 0 20 20 0 20 0 0} 		[list  -tags {Line_01}  -fill blue   -width 2]
            $cvObject   create   line  		{30 30 90 30 90 90 30 90 30 30} [list  -tags {Line_01}  -fill blue   -width 2]
            $cvObject   create   line  		{0 0 30 30 } 		            [list  -tags {Line_01}  -fill blue   -width 2]
            $cvObject   create   oval  		{30 160 155 230 } 	            [list  -tags {Line_01}  -fill red   -width 2]
            $cvObject   create   circle  	{160 60}                        [list  -radius 50 -tags {Line_01}  -fill blue   -width 2]
            $cvObject   create   arc  		{270 160}                       [list  -radius 50  -start 30  -extent 170 -tags {Line_01}  -outline gray  -width 2  -style arc]
            $cvObject   create   text		{150 90}                        [list  -text "text 150 90 360°"]
            $cvObject   create   vectorText	{160 30}                        [list  -text "vectorText  160 30  -size 20"  -size 20]
            $cvObject   create   vectorText	{210 70}                        [list  -text "vectorText  210 70  -size 10"  -size 10]
            $cvObject   create   vectorText	{120 170}                       [list  -text "Sonderzeichen:  grad \°, exp ^"  -size 10]

				
					
	
		# --------------------------------------------
				# 	tab 2
			.f.nb add [frame .f.nb.f2] -text "Second tab"
			
			set f2_canvas  [labelframe .f.nb.f2.f_canvas   -text "board"  ]
			set f2_config  [frame      .f.nb.f2.f_config   ]

			pack  $f2_canvas  $f2_config    -side left -expand yes -fill both
			pack  configure   $f2_config    -fill y

			.f.nb select .f.nb.f2
			set cvObject    [cad4tcl::new  $f2_canvas  880  610  A4  0.5  40]
            set w           [$cvObject getCanvas]    
				
				$cvObject   create   rectangle  {4.5 3.1 6.2 5.0 } 	                                    [list  -tags {Line_01}  -fill violet   -width 2]
				$cvObject   create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95}    [list  -tags {Line_01}  -outline red  -fill yellow -width 2]

				$cvObject   create   text		{3.4 2.2}  [list  -text "text  3.4 2.2"]
				$cvObject   create   vectorText	{4.0 1.5}  [list  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5]
				$cvObject   create   vectorText	{5.0 3.0}  [list  -text "vectorText  5.0 3.0  -size 1"  -size 1]
	
	
		# --------------------------------------------
				# 	tab 3
			.f.nb add [frame .f.nb.f3] -text "Third tab"
			
			set f3_canvas  [labelframe .f.nb.f3.f_canvas   -text "board"  ]
			set f3_config  [frame      .f.nb.f3.f_config   ]

			pack  $f3_canvas  $f3_config    -side left -expand yes -fill both
			pack  configure   $f3_config    -fill y

			button $f3_config.bt_open -text "open File" -command openFile
			pack $f3_config.bt_open 
			button $f3_config.bt_fit -text "refit" -command {$cv03 refitStage}				
			pack $f3_config.bt_fit 
			button $f3_config.bt_small -text "small" -command {$cv03 scaleToCenter 0.5}
			pack $f3_config.bt_small 
			
			
			.f.nb select .f.nb.f3
			set cvObject    [cad4tcl::new  $f3_canvas  880  610  A3  0.5  40]
            set w           [$cvObject getCanvas]    
				
				$cvObject   create   rectangle  {4.5 3.1 6.2 5.0 } 	    [list  -tags {Line_01}  -fill violet   -width 2]
				$cvObject   create   polygon  	{40 60  80 50  120 90  180 130  90 150  50 90 35 95} [list  -tags {Line_01}  -outline red  -fill yellow -width 2]

				$cvObject   create   text		{3.4 2.2}  [list  -text "text  3.4 2.2"]
				$cvObject   create   vectorText	{4.0 1.5}  [list  -text "vectorText  4.0 1.5  -size 0.5"  -size 0.5]
				$cvObject   create   vectorText	{5.0 3.0}  [list  -text "vectorText  5.0 3.0  -size 1"  -size 1]
                
                
                $cvObject  readSVG "$APPL_ROOT_Dir/shimano_FC-M770.svg"     {550 450} 0 {crankset}
                #$cv03  readSVG "shimano_crankset_XT_FC-M770_try.svg"   {250 350} 0 {crankset}
	
	
		# --------------------------------------------
				# 	tab 4
			.f.nb add [frame .f.nb.f4] -text "Fourth tab"
			
			set f4_canvas  [labelframe .f.nb.f4.f_canvas   -text "board"  ]
			set f4_config  [frame      .f.nb.f4.f_config   ]

			pack  $f4_canvas  $f4_config    -side left -expand yes -fill both
			pack  configure   $f4_config    -fill y
            
            .f.nb select .f.nb.f4
			set cvObject    [cad4tcl::new  $f4_canvas  880  610  A3  0.5  40]
            set w           [$cvObject getCanvas]    
            set cv04        [$cvObject getNamespace]    

			button $f4_config.cfgCorner -text "configCorner" -command [list $cvObject configCorner [list puts [format "{execute -> %s}" $cvObject]]]
			pack $f4_config.cfgCorner 
			button $f4_config.bt_open -text "open File" -command openFile
			pack $f4_config.bt_open 
			button $f4_config.bt_fit -text "refit" -command {$cvObject fitContent}				
			pack $f4_config.bt_fit 
			button $f4_config.bt_small -text "small" -command {$cvObject center 0.5}
			pack $f4_config.bt_small 
            
            set string "abc°^Ø±"
            puts "  -> string: $string"
            foreach ch [split $string ""] {
				scan $ch %c asc
				set evalChar [format "%c" $asc]
                puts "    --> $ch -> $asc -> [format "%c" $asc]"
				#debug "compile $canv $fid,$asc"
				#compile $canv "$fid,$asc"
			}
            
            #exit
            
            set characterList [cad4tcl::characterList]
            foreach charID $characterList {
                puts [format "   -> %3s %c" $charID $charID]
            }
            $cvObject  create   vectorText	{50.0 30.0}  -text "vectorText  50.0 30.0  -size 10"  -size 10
            $cvObject  create   vectorText	{50.0 60.0}  -text "vectorText  Sonderzeichen abc°^Ø±"  -size 10
	
            #set moveButton [button .bt_move -text "Test Button"]
            #set id [$cv04 create window 100 100 -window $moveButton]
            #rectangle   {4.5 3.1 6.2 5.0 }  -tags {Line_01}  -fill violet   -width 2
            puts " -> Canvas $cvObject"
            set myCanvas [$cvObject getCanvas]
            # puts "   [$cv04 getPath] .. $myCanvas"
            #button .b -text "Test Button"
            #set id [$myCanvas create window 100 100 -window .b]
            
            
            
            # set id0 [$myCanvas  create   rectangle   {345 131 372 160}  -fill violet   -width 2]
            set id  [$myCanvas  create   rectangle   {245 131 262 150}  -tags {__dragObject__  abcd efghijk}  -fill violet   -width 2]
            $myCanvas addtag __Content__ withtag $id
              # puts " -> rectangle $id"
            
            set objectIDs [$myCanvas gettags $id] 
              # puts " -> rectangle $objectIDs"
            
            set oldX 0
            set oldY 0
            bind $id <1> {set oldX %x ; set oldY %y}
            bind $id <B1-Motion> {%W move current [expr %x-$oldX] [expr %y-$oldY]}
            
            
            bind $id <ButtonPress-3> {
                puts "   ... bind <1>"
                set ::x %X
                set ::y %Y
            }
            bind $id <3> {
                puts "   ... bind <3>"
                set ::x %X
                set ::y %Y
            }
            #bind $id <Control-B1-Motion> [list drag.canvas.item $myCanvas $id %X %Y]
            
            #bindtag $objectID 
            #puts "bindtags [bindtags $myCanvas]"
            #puts "bindtags [bindtags $myCanvas $objectID]"
            
		# --------------------------------------------
				# 	final
			#.f.nb select .f.nb.f1
			ttk::notebook::enableTraversal .f.nb
            
		# --------------------------------------------
				# 	settings
            #$cv03 reportXML
    
    }
    
    main
            
    set imgFile [file join $BASE_Dir test_150x100_80x50.png]
    puts " $imgFile"
    set pos_x 200
    set pos_y 150
    
    if 0 {
        open_imageFile $imgFile $pos_x $pos_y center
        open_imageFile $imgFile $pos_x $pos_y ne
        set refRect [$cv04 create rectangle [list [expr $pos_x - 40] [expr $pos_y - 25] [expr $pos_x + 40] [expr $pos_y + 25] ] -outline red -width 0.5]
        set bbox    [$cv04 bbox $refRect]
            #puts $bbox
            set width   [expr [lindex $bbox 2] - [lindex $bbox 0]] 
            set height  [expr [lindex $bbox 3] - [lindex $bbox 1]] 
            puts ""
            puts ""
            puts "  ---------------------------------------------------"
            puts "      -> $bbox"
            puts "              -> $width x $height" 
            puts "" 
            puts "              -> [$cv04 getLength  $width]" 
            puts "              -> [$cv04 getLength  $height]" 
            puts ""
        set bbox    [$cv04 bbox __Stage__]
            #puts $bbox
            set width   [expr [lindex $bbox 2] - [lindex $bbox 0]] 
            set height  [expr [lindex $bbox 3] - [lindex $bbox 1]] 
            puts ""
            puts ""
            puts "  ---------------------------------------------------"
            puts "      -> $bbox"
            puts "              -> $width x $height" 
            puts "" 
            puts "              -> [$cv04 getLength  $width]" 
            puts "              -> [$cv04 getLength  $height]" 
            puts ""
        
        set p_start [list [expr $pos_x - 40] [expr $pos_y - 25]]
        set p_end   [list [expr $pos_x + 40] [expr $pos_y - 25]]
        $cv04 dimension  length   [list $p_start $p_end]  {horizontal}  20  0  red
         
        set p_start [list [expr $pos_x + 40] [expr $pos_y - 25]]
        set p_end   [list [expr $pos_x + 40] [expr $pos_y + 25]]
        $cv04 dimension  length   [list $p_start $p_end]  {vertical}    20  0  red
    }
