; pause.g
; called when a print is paused

M83                             ; use relative extrusion
G1 E-5 F3600                    ; retract 5 mm of filament

M106 P0 S0                      ; turn off part cooling / CPAP fan

;~~~~~ increase clearance from print ~~~~~

if move.axes[2].machinePosition <= move.axes[2].max - 5
    G91
    G1 Z5 F1500                 ; move bed down 5 mm
    G90
else
    G90
    G1 Z{move.axes[2].max} F300 ; move only as far as Z maximum

M98 P"/macros/nozzle_park.g"    ; park nozzle over purge bucket