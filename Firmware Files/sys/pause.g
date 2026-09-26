; pause.g
; called when a print is paused

M83                             ; use relative extrusion
G1 E-5 F3600                    ; retract 5 mm of filament

; save current CPAP fan speed
set global.pauseFan0Speed = fans[0].requestedValue

; turn off CPAP fan during pause
M106 P0 S0

;~~~~~ increase clearance from print ~~~~~

if move.axes[2].machinePosition <= move.axes[2].max - 5
    G91
    G1 Z5 F1500                 ; move bed down 5 mm
    G90
else
    G90
    G1 Z{move.axes[2].max} F300 ; move only as far as Z maximum

M98 P"/macros/nozzle_park.g"    ; park nozzle over purge bucket