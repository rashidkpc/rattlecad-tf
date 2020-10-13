  set WINDOW_Title      "tcl tubeMiter, based on canvasCAD@rattleCAD"

  
  set APPL_ROOT_Dir [file dirname [lindex $argv0]]
  
  puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
  set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
  puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
   
  lappend auto_path "$APPL_ROOT_Dir/.."
      # lappend auto_path "$APPL_Package_Dir/canvasCAD"
      # 
  package require   tubeMiter
      # package require   Tk
      # package require   canvasCAD


     
        # Geometrie Columbus Tapered Head Tube
        # Das HT hat unten D=56mm und oben 46 mm bei einer Kegelstumpfhöhe von 70mm
    set R_Frustum_Base  28.0
    set R_Frustum_Top   23.0
    set H_Frustum       70.0 ;# Kegelhöhe
        # Das zu schneidende Rohr
    set R_Tube          19.0 ;# Radius Zylinder in mm
        # Miter Parameter
    set alpha           60.0 ;# Schnittwinkel in grad (Tube -> Joint <- Frustum_Base)
    set hks             45.0 ;# Höhe von Kegelfuß bis Achsenschnittpunkt

    
    
    set coneMiter [tubeMiter::coneMiter $R_Frustum_Base $R_Frustum_Top $H_Frustum $R_Tube $alpha $hks]
    
    foreach {x y} $coneMiter {
        puts "   $x -- $y"
    }
    
