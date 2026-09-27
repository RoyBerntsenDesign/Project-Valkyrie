; resume.g
; called before a paused print is resumed
;
; If the print was paused because of a water pump fault:
;   - force the pump to full speed
;   - verify tachometer RPM
;   - restore the original hotend temperature
;   - wait for the hotend to reach temperature
;   - restore normal thermostatic pump control
;   - then resume the normal print sequence


; ---------------------------------------------------------------------------
; Water pump fault recovery
; ---------------------------------------------------------------------------

if global.waterPumpFault

    M117 CHECKING WATER PUMP

    ; Temporarily force water pump to full speed
    M106 P4 S1 H-1

    ; Give pump time to reach normal running speed
    G4 S3

    ; Do not continue resume until pump RPM is safe
    if fans[4].rpm < 2000

        echo "RESUME BLOCKED: Water pump RPM too low: " ^ fans[4].rpm ^ " RPM"
        M117 RESUME BLOCKED - CHECK WATER PUMP

        ; Stay here until pump/tachometer recovers
        while fans[4].rpm < 2000
            G4 S1

    ; Pump is now confirmed running
    echo "Water pump OK: " ^ fans[4].rpm ^ " RPM"

    ; Restore original print temperatures
    M568 P0 S{global.waterPumpSavedActiveTemp} R{global.waterPumpSavedStandbyTemp} A2

    M117 HEATING HOTEND - PLEASE WAIT

    ; Wait for Tool 0 to return to print temperature
    M116 P0

    ; Final pump check before allowing extrusion/movement
    if fans[4].rpm < 2000

        M568 P0 S0 R0 A0
        M117 RESUME BLOCKED - WATER PUMP FAULT

        echo "RESUME BLOCKED: Water pump failed during reheating: " ^ fans[4].rpm ^ " RPM"

        while fans[4].rpm < 2000
            G4 S1

        ; Pump recovered - restore temperature and wait again
        M568 P0 S{global.waterPumpSavedActiveTemp} R{global.waterPumpSavedStandbyTemp} A2
        M116 P0

    ; Restore normal thermostatic water pump control
    M106 P4 S1 H1 T50

    ; Clear fault latch
    set global.waterPumpFault = false

    M117 WATER PUMP OK - RESUMING


; ---------------------------------------------------------------------------
; Normal resume sequence
; ---------------------------------------------------------------------------

M83                            ; use relative extrusion
G1 E5 F3600                    ; restore the 5 mm pause retract

M98 P"/macros/nozzle_brush.g"  ; clean nozzle before returning to print

G1 R1 X0 Y0 F18000             ; return to saved X/Y position, keep current Z
G1 R1 Z0 F1500                 ; return to exact saved print Z position

; restore CPAP fan speed from before pause
M106 P0 S{global.pauseFan0Speed}