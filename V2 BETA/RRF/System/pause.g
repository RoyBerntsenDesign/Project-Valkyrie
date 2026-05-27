; pause.g M600  unless  macro file filament-change.g exists in /sys on the SD card, it is run in preference to pause.g.
echo "pause"                       ; called when a print from SD card is paused
M83                                ; relative extruder moves
G1 E-1 F1800                        ; retract 1mm of filament
G91                                ; relative positioning
G1 Z30 F3000                       ; lift Z 
G90; absolute positioning
M400
if sensors.probes[0].value[0] == 0 ; if sensor is value other than 1000 do this, 0=probe attached
	echo "already have probe"
	M98 P"/macros/probe_leave"       ; probe drop off
M400
M98 P"/macros/nozzle_park"
M291 R"Do you want to change filament" P"your choice" S4 T15 J1 K{"Yes","NO"} F15
if input = 0
	M98 P"/macros/filament_change" ; filament change 
	echo "changing filament"