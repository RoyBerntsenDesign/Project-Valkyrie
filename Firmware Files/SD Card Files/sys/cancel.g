; cancel.g runs when canceling a job midprint
G1 E-5 F1800                ; retract filament
M98 P"/macros/nozzle_park"  ; move nozzle to purge bucket
G1 Z{move.axes[2].max}      ; move bed to Z max
M104 S0                     ; Turn off Extruder temperature
M140 S0                     ; Turn off Bed temperature
M106 P0 S0                  ; Turn off part cooling fan
M141 P2 S0                  ; Turn off Chamber
M98 P"/macros/nozzle_brush" ; brush nozzle and park