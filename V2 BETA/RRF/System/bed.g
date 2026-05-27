echo "bed.g G32"
M561                                             ; clear any bed transform
;== If the printer hasn't been homed, home it ==
if !move.axes[0].homed || !move.axes[1].homed 
	G28
if sensors.probes[0].value[0] == 1000            ; if sensor is value other than 1000 do this, 0=probe attached
	echo "already homed, going to pick up probe"
	M98 P"/macros/probe_get"                        ; probe pick up
if sensors.probes[0].value[0] == 0               ; Probe the bed and do auto calibration
		while true
			if iterations = 5                             ; maximum number of tries 
				M98 P"/macros/probe_leave"
				M98 P"/macros/nozzle_park"                   ; probe drop off; end loop
				abort "Too many auto calibration attempts"   ;could not level the bed 
			G30 P0 X15 Y10 Z-99999                        ; probe starboard bow 
			if result != 0
				continue
			G30 P1 X295 Y10 Z-99999                       ; probe port bow
			if result != 0
				continue
			G30 P2 X156 Y280 Z-99999 S3                   ; probe port stern 
			if result != 0
				continue
			if move.calibration.initial.deviation <= 0.01 ; maximum deveation required 
				break
			echo "Repeating calibration because deviation is too high (" ^ move.calibration.initial.deviation ^ "mm)"
echo "Auto calibration successful, deviation", move.calibration.final.deviation ^ "mm"
G1  X153 Y177.5 F30000                           ; move to center bed 	
G1 Z15 F1000                                     ; get the head out of the way
M400
echo"bed last stop height"                                        ; probe to center bed  
echo sensors.probes[0].lastStopHeight   
echo sensors.probes[1].lastStopHeight