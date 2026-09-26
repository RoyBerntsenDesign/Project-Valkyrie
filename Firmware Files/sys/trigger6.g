; trigger6.g
; Retract button click - unload currently loaded filament
; Unload speed should be 28 mm/s

echo "Unload trigger 6"

; Check whether Tool 0 has a filament registered
if move.extruders[0].filament == ""
    echo "No filament loaded"
    M291 P"Error: No filament registered to Tool 0!" S2 T10

else
    ; Store the currently loaded filament name
    var currentFilament = move.extruders[0].filament

    echo var.currentFilament

    ; Check that the filament monitor reports filament present
    if sensors.filamentMonitors[0].status == "ok"

        ; Notify user of detected filament type
        M291 P{"Detected loaded filament: " ^ var.currentFilament} S1 T3

        ; Call the matching filament unload macro
        M98 P{"0:/filaments/" ^ var.currentFilament ^ "/unload.g"}

    else
        echo "Filament monitor does not report filament present"
        M291 P"Error: Filament monitor does not detect filament!" S2 T10