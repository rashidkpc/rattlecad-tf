  set WINDOW_Title      "tcl tubeMiter, based on canvasCAD@rattleCAD"

  
  set APPL_ROOT_Dir [file dirname [lindex $argv0]]
  
  puts "  -> \$APPL_ROOT_Dir $APPL_ROOT_Dir"
  set APPL_Package_Dir [file dirname [file dirname $APPL_ROOT_Dir]]
  puts "  -> \$APPL_Package_Dir $APPL_Package_Dir"
   
  lappend auto_path "$APPL_Package_Dir/canvasCAD"
  lappend auto_path "$APPL_Package_Dir/bikeGeometry"
  lappend auto_path "$APPL_Package_Dir/vectormath"
  lappend auto_path "$APPL_Package_Dir/appUtil"
  lappend auto_path "$APPL_Package_Dir/rattleCAD_3.4.02/lib/app-rattleCAD"
  
  package require   Tk
  package require   canvasCAD
  package require   bikeGeometry
  package require   vectormath
  package require   appUtil
  package require   rattleCAD

  
    proc miterConePeter {} {
           #Schnittkurvenberechnung Kreiszylinder-Kegel

                #
                # Eingabedaten
                #
            set pi $vectormath::CONST_PI
            set R1 19                       ;#Radius Zylinder in mm
            set alpha [expr 120*$pi/180]    ;# Schnittwinkel in rad
            set hks 45                      ;#Kegelhöhe von Kegelfuß bis Achsenschnittpunkt
                #
            puts "     \$pi ........ $pi"
            puts "     \$R1 ........ $R1"
            puts "     \$alpha ..... $alpha"
            puts "     \$hks ....... $hks"
                #
                # Geometrie Columbus Tapered Head Tube
                # Das HT hat unten D=56mm und oben 46 mm bei einer Kegelstumpfhöhe von 70mm
                #
            set R2col_u 28
            set R2col_o 23
            set h2col   70
                #
            puts "     \$R2col_u ... $R2col_u"
            puts "     \$R2col_o ... $R2col_o"
            puts "     \$h2col ..... $h2col"
                #
                # Dies wird umgerechnet auf einen Kegelfuß im Achsenschnittpunkt und die Kegelhöhe bis zur virtuellen Kegelspitze
                #
            set h2 [expr $h2col/(1-$R2col_o/$R2col_u)]
            set R20 (1-$hks/$h2)*$R2col_u
                #
            puts "     \$h2 ........ $h2"
            puts "     \$R20 ....... $R20"
                # Wertebereich für Z2 ermitteln
                #
                # Oberer Sattelpunkt
                #
            set Z2_top [expr ($R1+$R20*cos($alpha))/($R20/$h2*cos($alpha)+sin($alpha))]
            set Z2_bot [expr (-$R1+$R20*cos($alpha))/($R20/$h2*cos($alpha)+sin($alpha))]
                #
            puts "     \$Z2_top .... $Z2_top"
            puts "     \$Z2_bot .... $Z2_bot"
                #
                # Durchführung der Berechnungen mit nz2 Hilfsebenen
                #
                # 
                # PHI1 läuft zwischen 0 und pi
                #
            set nz2max 400
            set nz2max 100
            set nz2 1
                #
            puts "     \$nz2max .... $nz2max"
            puts "     \$nz2 ....... $nz2"
                #
            array set Z1 {}
            array set Z2 {}
            array set PHI2 {}
            array set PHI1s {}
                #
            while {$nz2 < [expr $nz2max + 1]} {

                array set Z2    [list $nz2  [expr $Z2_top - ($nz2 - 1) / ($nz2max * ($Z2_top - $Z2_bot))]]
                array set Z1    [list $nz2  [expr -1 * sqrt( pow(($R20*(1-$Z2($nz2)/$h2)),2) + pow($Z2($nz2),2) - pow($R1,2))]]
                set PHI2($nz2)  [expr acos((-$Z2($nz2)*cos($alpha)-$Z1($nz2))/($R20*(1-$Z2($nz2)/$h2)*sin($alpha)))]
                set PHI1s($nz2) [expr asin(($R20*(1-$Z2($nz2)/$h2)*sin($PHI2($nz2)))/$R1)]
                    #
                if {$nz2 > 2} {

                    if {(2*$PHI1([expr $nz2-1])-$PHI1([expr $nz2-2])) < ($pi/2)} {
                        set PHI1($nz2) $PHI1s($nz2)
                    } else {
                        set PHI1($nz2) $pi-$PHI1s($nz2)
                    }

                } else {
                    set PHI1($nz2) $PHI1s($nz2)
                } 
                puts "   -> $nz2"
                puts "   -> \$Z2($nz2) [array get Z2 $nz2]"
                puts "   -> \$Z1($nz2) [array get Z1 $nz2]"
                    #
                incr nz2 1
                
            }
                #
            return
                #
            parray Z1    
            parray Z2    
            parray PHI2    
            parray PHI1s    
                #
            return
                # Jetzt noch das Ganze spiegeln für den Bereich PHI1 von pi bis 2pi

            set nz2 [expr $nz2max+2]
            while {$nz2 <= [expr 2*$nz2max+1]} {
                set id [expr 2*$nz2max-$nz2+2]
                set Z1($nz2) [expr $Z1($id)]
                set PHI1($nz2) [expr 2*$pi-$PHI1($id)]
            }           
            return
            //Schnittkurvenberechnung Kreiszylinder-Kegel

            //Eingabedaten

            R1=19 //Radius Zylinder in mm

            alpha=120*%pi/180 // Schnittwinkel in rad

            hks=45 //Kegelhöhe von Kegelfuß bis Achsenschnittpunkt

            // Geometrie Columbus Tapered Head Tube

            // Das HT hat unten D=56mm und oben 46 mm bei einer Kegelstumpfhöhe von 70mm

            R2col_u=28

            R2col_o=23

            h2col=70

            // Dies wird umgerechnet auf einen Kegelfuß im Achsenschnittpunkt und die Kegelhöhe bis zur virtuellen Kegelspitze

            h2=h2col/(1-R2col_o/R2col_u)

            R20=(1-hks/h2)*R2col_u

            //Wertebereich für Z2 ermitteln

            //Oberer Sattelpunkt

            Z2_top=(R1+R20*cos(alpha))/(R20/h2*cos(alpha)+sin(alpha))

            Z2_bot=(-R1+R20*cos(alpha))/(R20/h2*cos(alpha)+sin(alpha))

            //Durchführung der Berechnungen mit nz2 Hilfsebenen

            //PHI1 läuft zwischen 0 und pi

            nz2max=400

            for nz2=1:nz2max+1

                Z2(nz2)=Z2_top-(nz2-1)/nz2max*(Z2_top-Z2_bot);

                Z1(nz2)=-sqrt((R20*(1-Z2(nz2)/h2))^2+Z2(nz2)^2-R1^2);

                PHI2(nz2)=acos((-Z2(nz2)*cos(alpha)-Z1(nz2))/(R20*(1-Z2(nz2)/h2)*sin(alpha)));

                PHI1s(nz2)=asin((R20*(1-Z2(nz2)/h2)*sin(PHI2(nz2)))/R1);

                if nz2 > 2 then

                    if real(2*PHI1(nz2-1)-PHI1(nz2-2)) < real(%pi/2) then 

                        PHI1(nz2)=PHI1s(nz2);

                    else

                        PHI1(nz2)=%pi-PHI1s(nz2);

                    end

                else PHI1(nz2)=PHI1s(nz2)

                end 

            end

            // Jetzt noch das Ganze spiegeln für den Bereich PHI1 von pi bis 2pi

            for nz2=nz2max+2:2*nz2max+1

                Z1(nz2)=Z1(2*nz2max-nz2+2);

                PHI1(nz2)=2*%pi-PHI1(2*nz2max-nz2+2);

            end

            //Schnittkurve plotten

            //Im Diagramm entsprechen der linke und rechte Rand dem oberen Sattel. Die Diagrammmitte entspricht dem unteren Sattel

            clf()

            //plot(PHI1*R1,Z1)

            //Falls der obere Sattel in die Mitte gerückt werden soll, dann folgende Darstelung verwenden:

            Z1sort(1:nz2max+1)=Z1(nz2max+1:2*nz2max+1);

            Z1sort(nz2max+2:2*nz2max+1)=Z1(1:nz2max);

            plot(PHI1*R1,[Z1sort Z1]);

    }

    miterConePeter