; cancel.g
; called after a paused print is cancelled
; pause.g has already retracted, cleared the print and parked the nozzle


; ---------------------------------------------------------------------------
; Shut down heaters and cooling
; ---------------------------------------------------------------------------

M568 P0 S0 R0 A0                        ; fully disable hotend active/standby temperatures
M140 S0                                 ; turn off bed heater
M106 P0 S0                              ; keep part cooling / CPAP fan off
M141 P0 S-273.1 R0                      ; turn off chamber and clear stored ramp target


; ---------------------------------------------------------------------------
; Clear water pump fault / recovery state
; ---------------------------------------------------------------------------

set global.waterPumpFault = false
set global.waterPumpFaultCounter = 0
set global.waterPumpSavedActiveTemp = 0.0
set global.waterPumpSavedStandbyTemp = 0.0


; ---------------------------------------------------------------------------
; Move bed fully away
; ---------------------------------------------------------------------------

G90                                     ; use absolute positioning
G1 Z{move.axes[2].max} F1500            ; move bed fully down
M400                                    ; wait for Z move to finish


; ---------------------------------------------------------------------------
; Clean nozzle
; ---------------------------------------------------------------------------

G4 P3000                                ; allow remaining ooze to fall into bucket
M98 P"/macros/nozzle_brush.g"           ; clean nozzle