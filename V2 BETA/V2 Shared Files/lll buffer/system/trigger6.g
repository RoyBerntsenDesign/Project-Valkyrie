;Retract button click, will unload loaded filament 
;unload speed need to be at 28mm/s
echo "unload trigger 6"
; Check if Tool 0 (Extruder 0) has a filament loaded
if move.extruders[0].filament = ""
    echo "no filament loaded"
    M291 P"Error: No filament registered to Tool 0!" S2 T10
else ; Store the filament name into a variable
    if sensors.filamentMonitors[0].status="ok"
        var currentFilament = move.extruders[0].filament
        echo var.currentFilament
        ; Notify user of the detected type of filment 
        M291 P{"Detected loaded filament:" ^var.currentFilament} S1 T3
         ; Call the matching unload file using string concatenation
        M98 P{"0:/filaments/" ^ var.currentFilament ^ "/unload.g"}