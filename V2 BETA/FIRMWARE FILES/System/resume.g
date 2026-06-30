; resume.g
G1 E10 F3600          ; Extrude 10mm of filament
M400
M98 P"/macros/nozzle_brush"  
G1 R1 X0 Y0 Z5 F24000 ; Go to 5mm above position of the last print move
G1 R1 X0 Y0 Z0        ; Go back to the last print move
M83                   ; Relative extruder moves