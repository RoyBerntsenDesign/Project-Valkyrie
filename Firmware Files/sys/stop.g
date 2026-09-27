; stop.g
; called when a print finishes or M0 is executed
; retracts, clears the finished part, parks and cleans the nozzle


; ---------------------------------------------------------------------------
; Retract filament
; ---------------------------------------------------------------------------

M83                                     ; use relative extrusion
G1 E-5 F3600                            ; retract 5 mm immediately to reduce oozing


; ---------------------------------------------------------------------------
; Shut down heaters and cooling
; ---------------------------------------------------------------------------

M568 P0 S0 R0 A0                        ; fully disable hotend active/standby temperatures
M140 S0                                 ; turn off bed heater
M106 P0 S0                              ; turn off part cooling fan
M141 P0 S-273.1 R0                      ; turn off chamber and clear stored ramp target


; ---------------------------------------------------------------------------
; Clear water pump fault / recovery state
; ---------------------------------------------------------------------------

set global.waterPumpFault = false
set global.waterPumpFaultCounter = 0
set global.waterPumpSavedActiveTemp = 0.0
set global.waterPumpSavedStandbyTemp = 0.0


; ---------------------------------------------------------------------------
; Move bed away from finished part
; ---------------------------------------------------------------------------

if move.axes[2].machinePosition <= move.axes[2].max - 5
    G91
    G1 Z5 F1500                          ; move bed 5 mm away from nozzle
    G90
else
    G90
    G1 Z{move.axes[2].max} F1500

M400                                    ; make sure print is clear before XY travel


; ---------------------------------------------------------------------------
; Park and clean nozzle
; ---------------------------------------------------------------------------

M98 P"/macros/nozzle_park.g"            ; move nozzle over purge bucket

G1 Z{move.axes[2].max} F1500            ; move bed fully down
M400

G4 P3000                                ; allow remaining ooze to fall into bucket
M98 P"/macros/nozzle_brush.g"           ; clean nozzle