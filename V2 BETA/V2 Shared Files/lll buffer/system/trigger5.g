;Clicking the load button on the buffer triggers this 
;load speed need to be at 28mm/s
echo "load  trigger 5"
;the output goes high  for 3 second   

; Check if Tool 0 (Extruder 0) has a filament loaded
if move.extruders[0].filament = "" 
   M291 R"Use Load filament in DWC" S2 T10
    
else ; if there is a filament loaded, store the filament name into a variable
	var currentFilament = move.extruders[0].filament
	echo var.currentFilament
; Notify user of the detected type
	M291 R{"Detected loaded filament:" ^var.currentFilament} P"" S1 T5
	M291 R{"Do you wish to unload this filament " ^var.currentFilament} P"Select" S4 T5 J1 K{"Yes", "No"} F5 S2 T15
	if (input == 0)
		echo "Yes Retract Filament"
		M98 P{"0:/filaments/" ^ var.currentFilament ^ "/unload.g"}
	if (input = 1)
		echo "filament not remove"
		 