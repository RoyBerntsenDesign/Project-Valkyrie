; resume.g
G1 E10 F3600          ; Extrude 10mm of filament
M400

M98 P"/macros/nozzle_brush"  

M106 R1               ; Restore fan speed to the state it was in before pause
M109 R1               ; Wait for hotend active/standby temperatures to be restored

G1 R1 X0 Y0 Z2 F18000 ; Go to 2mm above the paused position
G1 R1 X0 Y0 Z0 F3000  ; Lower down to the exact resume position