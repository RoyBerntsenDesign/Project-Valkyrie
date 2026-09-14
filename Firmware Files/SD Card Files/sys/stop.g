; stop.g
; called when M0 (Stop) is executed, e.g. when a print is cancelled

G1 Z{move.axes[2].max}       ; move bed to Z maximum
M98 P"/macros/nozzle_park"   ; move nozzle to purge bucket

G1 E-3 F1800                 ; retract filament 3 mm to reduce oozing

M104 S0                      ; turn off hotend heater
M140 S0                      ; turn off bed heater
M141 P0 R0                   ; turn off chamber heater

G4 P3000                     ; wait 3 seconds for nozzle to ooze
M98 P"/macros/nozzle_brush"  ; brush nozzle and park