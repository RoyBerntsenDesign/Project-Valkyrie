echo "bed.g G32"
M561                                             ; Clear any bed transform
;== If the printer hasn't been homed, home it ==
if !move.axes[0].homed || !move.axes[1].homed 
	G28
if sensors.probes[0].value[0] == 1000            ; 1000 = probe not attached, 0=probe attached
	echo "already homed, going to pick up probe"
	M98 P"/macros/probe_get"                        ; Probe pick up
M400
M98 P"0:/macros/probe_center"                    ; Probe the center of the bed	
if sensors.probes[0].value[0] == 0               ;Check if probe is attached, Probe = 0 attached, probe = 1000  not attached 
		while true
			if iterations = 5                             ; Maximum number of tries 
				M98 P"/macros/probe_leave"                   ; Pprobe drop off
				M98 P"/macros/nozzle_park"                   ; Park over bucket
				abort "Too many auto calibration attempts"   ; Could not level the bed 
			G30 P0 X{move.axes[0].min}+15 Y{move.axes[1].min} Z-99999                        ; Probe starboard bow 
			if result != 0
				continue
			G30 P1 X{move.axes[0].max}-15 Y{move.axes[1].min} Z-99999                       ; Probe port bow
			if result != 0
				continue
			G30 P2 X{move.axes[0].max}/2 Y{move.axes[1].max}-15 Z-99999 S3                   ; Probe port stern 
			if result != 0
				continue
			if move.calibration.initial.deviation <= 0.02 ; Maximum deveation required 
				break
			echo "Repeating calibration because deviation is too high (" ^ move.calibration.initial.deviation ^ "mm)"
echo "Auto calibration successful, deviation", move.calibration.final.deviation ^ "mm"
;~~~~~ calculate center of bed including offset on the Z probe ~~~~~
M98 P"0:/macros/probe_center"                    ; Probe the center of the bed
G1 Z15 F3000                                     ; Move bed down to get the head out of the way
M400
echo"bed last stop heights"  
echo "K0", sensors.probes[0].lastStopHeight   
echo "K1", sensors.probes[1].lastStopHeight