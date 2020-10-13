  set WINDOW_Title      "tcl tubeMiter, based on canvasCAD@rattleCAD"

  
  set APPL_ROOT_Dir [file dirname [lindex $argv0]]
  
  puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
  set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
  puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
   
  lappend auto_path "$APPL_ROOT_Dir/.."
  # lappend auto_path "$APPL_Package_Dir/canvasCAD"
  # lappend auto_path "$APPL_Package_Dir/bikeGeometry"
  # lappend auto_path "$APPL_Package_Dir/vectormath"
  # lappend auto_path "$APPL_Package_Dir/appUtil"
  # lappend auto_path "$APPL_Package_Dir/rattleCAD_3.4.02/lib/app-rattleCAD"
  # lappend auto_path "$APPL_Package_Dir/rattleCAD_3.4.02/lib/app-rattleCAD"
  # 
  package require   tubeMiter
  # package require   Tk
  # package require   canvasCAD
  # package require   bikeGeometry
  # package require   vectormath
  # package require   appUtil
  # package require   rattleCAD

     
    proc miter_02_SciLab {} {
                //Eingabedaten
            R_Tube=19 //Radius Zylinder in mm

            alpha=120*%pi/180 // Schnittwinkel in rad

            hks=45 //Kegelhöhe von Kegelfuß bis Achsenschnittpunkt

            print (%io(2), R_Tube,alpha,hks)

            // Geometrie Columbus Tapered Head Tube

            // Das HT hat unten D=56mm und oben 46 mm bei einer Kegelstumpfhöhe von 70mm

            R_Tool_base=28

            R_Tool_top=23

            H_Tool_Frustum=70

            // print (%io(2), R_Tool_base, R_Tool_top, H_Tool_Frustum)

            // Dies wird umgerechnet in eine Funktion Kegelradius in Abhängigkeit der Koordinate z2. Zunächst Geradengleichung bestimmen

            a2=R_Tool_base+(R_Tool_top-R_Tool_base)*hks/H_Tool_Frustum;

            b2=(R_Tool_top-R_Tool_base)/H_Tool_Frustum;

            // print (%io(2), a2,b2)

            //Wertebereich für Z2 ermitteln. 
            //Z2 läuft entlang der Kegelachse vom Achsenschnittpunkt aus positiv nach oben
            //Z1 läuft entlang der Zylinderachse. Vom Achsenschnittpunkt aus von links nach rechts ist positiv. Daher werden im Ergebnis negative Werte ausgespuckt, denn die Schnittkurve liegt ja links vom Achsenschnittpunkt. 
            //Oberer Sattelpunkt

            Z2_top=(R_Tube+a2*cos(alpha))/(-b2*cos(alpha)+sin(alpha))
            //unterer Sattelpunkt
            Z2_bot=(-R_Tube+a2*cos(alpha))/(-b2*cos(alpha)+sin(alpha))

            print (%io(2), Z2_top, Z2_bot)

            //Durchführung der Berechnungen mit Hilfsebenen, die senkrecht zur Kegelachse verlaufen. Vom oberen Sattel bis zum unteren sind es nz2max+1 Hilfsebenen. Der Laufparameter dafür ist nz2 und zu jedem nz2 wird die entsprechende z2-Koordinate ermittelt, also in welchem Abstand sich die Hilfsebene zum Achsenschnittpunkt befindet. 
            //Dabei wandert der Winkel PHI1 für den Zylinder zwischen 0 und pi. Später wird das Ganze gespiegelt, um den Bereich zwischen pi und 2pi abzudecken. PHI1s ist eine Berechnung von PHI1, allerdings fehlt dort die korrekte Berücksichtigung des Quadranten, da die Arkusfunktion dies nicht kann. In einem weiteren Schritt wird dann der Quadrant festgestellt, um auch Werte >pi/2 erhalten zu können.
            //PHI2 ist der Umlaufwinkel am Kegel, siehe auch Skizze in der theoretischen Herleitung. 

            nz2max=400

            for nz2=1:nz2max+1

                Z2(nz2)=Z2_top-(nz2-1)/nz2max*(Z2_top-Z2_bot);

                Z1(nz2)=-sqrt((a2+b2*Z2(nz2))^2+Z2(nz2)^2-R_Tube^2);

                PHI2(nz2)=acos((-Z2(nz2)*cos(alpha)-Z1(nz2))/((a2+b2*Z2(nz2))*sin(alpha)));

                PHI1s(nz2)=asin((a2+b2*Z2(nz2))*sin(PHI2(nz2))/R_Tube);

                // print (%io(2), Z2(nz2), Z1(nz2), PHI2(nz2),  PHI1s(nz2)) 
                
                if nz2 > 2 then

                    if real(2*PHI1(nz2-1)-PHI1(nz2-2)) < real(%pi/2) then 

                        PHI1(nz2)=PHI1s(nz2);

                    else

                        PHI1(nz2)=%pi-PHI1s(nz2);

                    end

                else PHI1(nz2)=PHI1s(nz2)

                end 

            end

    
    
    }
    
    
   
    proc miter_02 {} {
    
            # set pi $vectormath::CONST_PI
            set pi [ expr 4*atan(1) ]
            
            # Eingabedaten
            
            set R_Tube 19.0 ;# Radius Zylinder in mm

            set alpha [expr 120.0 * $pi / 180] ;# Schnittwinkel in rad

            set hks 45.0 ;# Kegelhöhe von Kegelfuß bis Achsenschnittpunkt

            # print (%io(2), R_Tube,alpha,hks)

            # Geometrie Columbus Tapered Head Tube

            # Das HT hat unten D=56mm und oben 46 mm bei einer Kegelstumpfhöhe von 70mm

            set R_Tool_base 28.0

            set R_Tool_top 23.0

            set H_Tool_Frustum 70.0
            
            #
            
            #
            #

            # print (%io(2), R_Tool_base, R_Tool_top, H_Tool_Frustum)

            # Dies wird umgerechnet in eine Funktion Kegelradius in Abhängigkeit der Koordinate 
            # z2. Zunächst Geradengleichung bestimmen

            set a2 [expr $R_Tool_base + ($R_Tool_top - $R_Tool_base) * $hks / $H_Tool_Frustum]

            set b2 [expr ($R_Tool_top - $R_Tool_base) / $H_Tool_Frustum]

            #  print (%io(2), a2,b2)

            # Wertebereich für Z2 ermitteln. 
            # Z2 läuft entlang der Kegelachse vom Achsenschnittpunkt aus positiv nach oben
            # Z1 läuft entlang der Zylinderachse. Vom Achsenschnittpunkt aus von links nach 
            # rechts ist positiv. Daher werden im Ergebnis negative Werte ausgespuckt, denn 
            # die Schnittkurve liegt ja links vom Achsenschnittpunkt. 
            # Oberer Sattelpunkt

            set Z2_top [expr (   $R_Tube+$a2*cos($alpha))/(-1*$b2*cos($alpha)+sin($alpha))]
            # unterer Sattelpunkt
            set Z2_bot [expr (-1*$R_Tube+$a2*cos($alpha))/(-1*$b2*cos($alpha)+sin($alpha))]

            puts ""
            puts "pi              [format {%3.8f} $pi]"
            puts ""
            puts "R_Tube:         [format {%3.8f} $R_Tube]"
            puts "alpha:          [format {%3.8f} $alpha]"
            puts "hks:            [format {%3.8f} $hks]"
            puts "R_Tool_base:    [format {%3.8f} $R_Tool_base]"
            puts "R_Tool_top:     [format {%3.8f} $R_Tool_top]"
            puts "H_Tool_Frustum: [format {%3.8f} $H_Tool_Frustum]"
            puts "a2:             [format {%3.8f} $a2]"
            puts "b2:             [format {%3.8f} $b2]"
            puts ""
       
            

            # Durchführung der Berechnungen mit Hilfsebenen, die senkrecht zur Kegelachse verlaufen. Vom oberen Sattel bis zum unteren sind es nz2max+1 Hilfsebenen. Der Laufparameter dafür ist nz2 und zu jedem nz2 wird die entsprechende z2-Koordinate ermittelt, also in welchem Abstand sich die Hilfsebene zum Achsenschnittpunkt befindet. 
            # Dabei wandert der Winkel PHI1 für den Zylinder zwischen 0 und pi. Später wird das Ganze gespiegelt, um den Bereich zwischen pi und 2pi abzudecken. PHI1s ist eine Berechnung von PHI1, allerdings fehlt dort die korrekte Berücksichtigung des Quadranten, da die Arkusfunktion dies nicht kann. In einem weiteren Schritt wird dann der Quadrant festgestellt, um auch Werte >pi/2 erhalten zu können.
            # PHI2 ist der Umlaufwinkel am Kegel, siehe auch Skizze in der theoretischen Herleitung. 

            set nz2max 400
            set nz2 1
            puts "\n"
            puts "          \$nz2max .... $nz2max"
            puts "          \$nz2 ....... $nz2"
        
            array set Z1    {}
            array set Z2    {}
            array set PHI2  {}
            array set PHI1s {}
            
            while {$nz2 <= ($nz2max + 1)} {
                puts ""
                puts "---- $nz2 -------------------------------------------"
                    # Z2(nz2)=Z2_top-(nz2-1)/nz2max*(Z2_top-Z2_bot);
                set Z2($nz2)        [expr $Z2_top - (1.0*$nz2-1) / $nz2max * ($Z2_top - $Z2_bot)]
                puts "       Z2($nz2):     [format {%3.8f} $Z2($nz2)]"
                    #
                    #
                    # Z1(nz2)=-sqrt((a2+b2*Z2(nz2))^2+Z2(nz2)^2-R_Tube^2);
                set Z1($nz2)        [expr -1 * sqrt(pow(($a2+$b2*$Z2($nz2)),2) + pow($Z2($nz2),2)- pow($R_Tube,2))]
                puts "       Z1($nz2):     [format {%3.8f} $Z1($nz2)]"
                    #
                    #
                    # PHI2(nz2)=acos((-Z2(nz2)*cos(alpha)-Z1(nz2))/((a2+b2*Z2(nz2))*sin(alpha)));
                set value           [expr (-1 * $Z2($nz2) * cos($alpha) - $Z1($nz2)) / (($a2 + $b2 * $Z2($nz2)) * sin($alpha))]
                if {$value < -1 || $value > 1} {
                    set roundedValue [format {%3.8f} $value]
                    if {abs($roundedValue) > 1.0} {
                        puts "\n"
                        puts "          <E> tcl expr error: $value"
                        puts "\n"
                        return -1
                    } else {
                        puts "          <I> tcl expr error: $value"
                        set value $roundedValue
                    }
                }
                set PHI2($nz2)      [expr acos($value)]
                puts "       PHI2($nz2):   [format {%3.8f} $PHI2($nz2)]"
                    #
                    #
                    # PHI1s(nz2)=asin((a2+b2*Z2(nz2))*sin(PHI2(nz2))/R_Tube);
                set PHI1s($nz2)     [expr asin(($a2 + $b2 * $Z2($nz2)) * sin($PHI2($nz2)) / $R_Tube)]
                puts "       PHI1s($nz2):  [format {%3.8f} $PHI1s($nz2)]"
                    #
                    #
                if {$nz2 > 2} {
                    set nz2_1 [expr $nz2 - 1]
                    set nz2_2 [expr $nz2 -2]
                    
                    if { (2 * $PHI1($nz2_1) - $PHI1($nz2_2)) < $pi/2} { 
                        puts "       -> if:"
                        set PHI1($nz2) $PHI1s($nz2)
                    } else {
                        puts "       -> else:"
                        set PHI1($nz2) [expr $pi - $PHI1s($nz2)]
                    }
                } else  {
                    set PHI1($nz2) $PHI1s($nz2)
                } 
                puts "       PHI1($nz2):   [format {%3.8f} $PHI1($nz2)]"
                    #
                    #
                    # end loop and incr nz2
                    #
                incr nz2 1
                    #
            }
            
            # puts "  -> \$Z2(1) ... $Z2(1)"
            # puts "  -> \$Z2(2) ... $Z2(2)"
            
            puts "\n\n"
            puts "---- mirror -------------------------"

            while {$nz2 <= (2 * $nz2max + 1)} {
                    #
                # puts $nz2
                    #
                    # Z1(nz2)=Z1(2*nz2max-nz2+2);
                set nz2_id [expr 2 * $nz2max - $nz2 + 2]
                set Z1($nz2) $Z1($nz2_id)
                puts "       Z1($nz2):     [format {%3.8f} $Z1($nz2)]"
                    #
                    #
                    # PHI1(nz2)=2*%pi-PHI1(2*nz2max-nz2+2);
                set PHI1($nz2) [expr 2 * $pi - $PHI1($nz2_id)]
                puts "       PHI1($nz2):   [format {%3.8f} $PHI1($nz2)]"
                    #
                    # end loop and incr nz2
                    #
                incr nz2 1
                    #
            }
                #
            set miter_Cone {}
            foreach key [lsort -integer [array names PHI1]] {
                # puts "   -> $key"
                set i_perimeter     [expr $PHI1($key) * $R_Tube]
                set i_miterOffset   $Z1($key)
                lappend miter_Cone $i_perimeter $i_miterOffset
            }
                #
            # parray PHI1
            # parray Z1
                #
            return $miter_Cone
                #    
    }
    
    proc miter_03 {R_Frustum_Base R_Frustum_Top H_Frustum R_Tube alpha hks} {
                #
                # set miterCone [miter_03 $R_Frustum_Base $R_Frustum_Top $H_Frustum $R_Tube $alpha $hks]
                #
                #   R_Frustum_Base ... Radius des Kegelstumpf unten
                #   R_Frustum_Top .... Radius des Kegelstumpf oben
                #   H_Frustum ........ Höhe des Kegelstumpf    
                #
                #   R_Tube ........... Radius Zylinder in mm
                #   alpha ............ Schnittwinkel in grad (FrustumTop -> Joint <- Tube)
                #   hks .............. Höhe von Kegelfuß bis Achsenschnittpunkt
                #
                #
            set pi [ expr 4*atan(1) ]
                #
                # Eingabedaten
                #
            set R_Frustum_Base  [expr 1.0 * $R_Frustum_Base]
            set R_Frustum_Top   [expr 1.0 * $R_Frustum_Top]
            set H_Frustum       [expr 1.0 * $H_Frustum]
                #
            set R_Tube          [expr 1.0 * $R_Tube]                ;# Radius Zylinder in mm
                #
            set alpha           [expr (180 - $alpha) * $pi / 180]   ;# Schnittwinkel in rad
            set hks             [expr 1.0 * $hks]                   ;# Höhe von Kegelfuß bis Achsenschnittpunkt
                #
                #
                # Dies wird umgerechnet in eine Funktion Kegelradius in Abhängigkeit der Koordinate z2. 
                # Zunächst Geradengleichung bestimmen
            set a2 [expr $R_Frustum_Base + ($R_Frustum_Top - $R_Frustum_Base) * $hks / $H_Frustum]
            set b2 [expr ($R_Frustum_Top - $R_Frustum_Base) / $H_Frustum]
                #
                # Wertebereich für Z2 ermitteln. 
                # Z2 läuft entlang der Kegelachse vom Achsenschnittpunkt aus positiv nach oben
                # Z1 läuft entlang der Zylinderachse. Vom Achsenschnittpunkt aus von links nach 
                # rechts ist positiv. Daher werden im Ergebnis negative Werte ausgespuckt, denn 
                # die Schnittkurve liegt ja links vom Achsenschnittpunkt. 
                # Oberer Sattelpunkt
                #
            set Z2_top [expr (   $R_Tube+$a2*cos($alpha))/(-1*$b2*cos($alpha)+sin($alpha))]
                # unterer Sattelpunkt
            set Z2_bot [expr (-1*$R_Tube+$a2*cos($alpha))/(-1*$b2*cos($alpha)+sin($alpha))]
                #
                #
            puts ""
            puts "pi              [format {%3.8f} $pi]"
            puts ""
            puts "R_Tube:         [format {%3.8f} $R_Tube]"
            puts "alpha:          [format {%3.8f} $alpha]"
            puts "hks:            [format {%3.8f} $hks]"
            puts "R_Frustum_Base:    [format {%3.8f} $R_Frustum_Base]"
            puts "R_Frustum_Top:     [format {%3.8f} $R_Frustum_Top]"
            puts "H_Frustum: [format {%3.8f} $H_Frustum]"
            puts "a2:             [format {%3.8f} $a2]"
            puts "b2:             [format {%3.8f} $b2]"
            puts ""
                #
                #
                # Durchführung der Berechnungen mit Hilfsebenen, die senkrecht zur Kegelachse verlaufen. Vom oberen Sattel bis zum unteren sind es nz2max+1 Hilfsebenen. Der Laufparameter dafür ist nz2 und zu jedem nz2 wird die entsprechende z2-Koordinate ermittelt, also in welchem Abstand sich die Hilfsebene zum Achsenschnittpunkt befindet. 
                # Dabei wandert der Winkel PHI1 für den Zylinder zwischen 0 und pi. Später wird das Ganze gespiegelt, um den Bereich zwischen pi und 2pi abzudecken. PHI1s ist eine Berechnung von PHI1, allerdings fehlt dort die korrekte Berücksichtigung des Quadranten, da die Arkusfunktion dies nicht kann. In einem weiteren Schritt wird dann der Quadrant festgestellt, um auch Werte >pi/2 erhalten zu können.
                # PHI2 ist der Umlaufwinkel am Kegel, siehe auch Skizze in der theoretischen Herleitung. 
                #
            set nz2max 400
            set nz2 1
            puts "\n"
            puts "          \$nz2max .... $nz2max"
            puts "          \$nz2 ....... $nz2"
                #
            array set Z1    {}
            array set Z2    {}
            array set PHI2  {}
            array set PHI1s {}
                #
            while {$nz2 <= ($nz2max + 1)} {
                puts ""
                puts "---- $nz2 -------------------------------------------"
                    # Z2(nz2)=Z2_top-(nz2-1)/nz2max*(Z2_top-Z2_bot);
                set Z2($nz2)        [expr $Z2_top - (1.0*$nz2-1) / $nz2max * ($Z2_top - $Z2_bot)]
                puts "       Z2($nz2):     [format {%3.8f} $Z2($nz2)]"
                    #
                    #
                    # Z1(nz2)=-sqrt((a2+b2*Z2(nz2))^2+Z2(nz2)^2-R_Tube^2);
                set Z1($nz2)        [expr -1 * sqrt(pow(($a2+$b2*$Z2($nz2)),2) + pow($Z2($nz2),2)- pow($R_Tube,2))]
                puts "       Z1($nz2):     [format {%3.8f} $Z1($nz2)]"
                    #
                    #
                    # PHI2(nz2)=acos((-Z2(nz2)*cos(alpha)-Z1(nz2))/((a2+b2*Z2(nz2))*sin(alpha)));
                set value           [expr (-1 * $Z2($nz2) * cos($alpha) - $Z1($nz2)) / (($a2 + $b2 * $Z2($nz2)) * sin($alpha))]
                if {$value < -1 || $value > 1} {
                    set roundedValue [format {%3.8f} $value]
                    if {abs($roundedValue) > 1.0} {
                        puts "\n"
                        puts "          <E> tcl expr error: $value"
                        puts "\n"
                        return -1
                    } else {
                        puts "          <I> tcl expr error: $value"
                        set value $roundedValue
                    }
                }
                set PHI2($nz2)      [expr acos($value)]
                puts "       PHI2($nz2):   [format {%3.8f} $PHI2($nz2)]"
                    #
                    #
                    # PHI1s(nz2)=asin((a2+b2*Z2(nz2))*sin(PHI2(nz2))/R_Tube);
                set PHI1s($nz2)     [expr asin(($a2 + $b2 * $Z2($nz2)) * sin($PHI2($nz2)) / $R_Tube)]
                puts "       PHI1s($nz2):  [format {%3.8f} $PHI1s($nz2)]"
                    #
                    #
                if {$nz2 > 2} {
                    set nz2_1 [expr $nz2 - 1]
                    set nz2_2 [expr $nz2 -2]
                    
                    if { (2 * $PHI1($nz2_1) - $PHI1($nz2_2)) < $pi/2} { 
                        puts "       -> if:"
                        set PHI1($nz2) $PHI1s($nz2)
                    } else {
                        puts "       -> else:"
                        set PHI1($nz2) [expr $pi - $PHI1s($nz2)]
                    }
                } else  {
                    set PHI1($nz2) $PHI1s($nz2)
                } 
                puts "       PHI1($nz2):   [format {%3.8f} $PHI1($nz2)]"
                    #
                    #
                    # end loop and incr nz2
                    #
                incr nz2 1
                    #
            }
            
                # puts "  -> \$Z2(1) ... $Z2(1)"
                # puts "  -> \$Z2(2) ... $Z2(2)"
            
            puts "\n\n"
            puts "---- mirror -------------------------"
                #
                # 1 ... add mirror
                # 0 ... dont add mirror
                #
            if {0} {
                while {$nz2 <= (2 * $nz2max + 1)} {
                        #
                    # puts $nz2
                        #
                        # Z1(nz2)=Z1(2*nz2max-nz2+2);
                    set nz2_id [expr 2 * $nz2max - $nz2 + 2]
                    set Z1($nz2) $Z1($nz2_id)
                    puts "       Z1($nz2):     [format {%3.8f} $Z1($nz2)]"
                        #
                        #
                        # PHI1(nz2)=2*%pi-PHI1(2*nz2max-nz2+2);
                    set PHI1($nz2) [expr 2 * $pi - $PHI1($nz2_id)]
                    puts "       PHI1($nz2):   [format {%3.8f} $PHI1($nz2)]"
                        #
                        # end loop and incr nz2
                        #
                    incr nz2 1
                        #
                }
            }
                #
            set miter_Cone {}
            foreach key [lsort -integer [array names PHI1]] {
                # puts "   -> $key"
                set i_perimeter     [expr $PHI1($key) * $R_Tube]
                set i_miterOffset   $Z1($key)
                lappend miter_Cone $i_perimeter $i_miterOffset
            }
                #
            # parray PHI1
            # parray Z1
                #
            return $miter_Cone
                #    
    }
    
    # set miterCone [miter_02]
    
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

    
    
    set miterCone [miter_03 $R_Frustum_Base $R_Frustum_Top $H_Frustum $R_Tube $alpha $hks]
    
    foreach {x y} $miterCone {
        # puts "   $x -- $y"
    
    }
    
