; pause.g M600  unless  macro file filament-change.g exists in /sys on the SD card, it is run in preference to pause.g.
echo "pause"                       ; Called when a print from SD card is paused
M83                                ; Relative extruder moves
G1 E-3 F3600                       ; Retract 10mm of filament
G91                                ; Relative positioning
G1 Z15 F300                        ; Lift Z by 5mm
G90                                ; Absolute positioning
echo "end of pause"
if sensors.probes[0].value[0] == 0 ; Iif sensor is value >0  probe not attached , 0=probe attached
	echo "already have probe"
	M98 P"/macros/probe_leave"
	M400
M98 P"/macros/nozzle_park"