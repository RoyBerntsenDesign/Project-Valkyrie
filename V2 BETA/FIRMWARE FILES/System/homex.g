; homex.g
M564 S0 H0
echo "home the X axis"
M400                              ; Make sure everything has stopped before we make changes
G91                               ; Rrelative positioning
M915 P0:1 S2 H200 F0 R0           ; Configure Stall Detection lower S number more sensative 
M906 X700 Y700                    ; Set homing motor current
G1 F5400
G1 H1 X350                        ; Home X-Axis independently

;~~~~~ move to set offset from end stop ~~~~~
G91                               ; Relative positioning
G1 X-14.5                         ; Distace to edge of print area
G92 X{move.axes[0].max}           ; Set User Position
M400                              ; Mmake sure everything has stopped before we make changes

;~~~~~ reset stepper motor  settings ~~~~~ 
M400                              ; Make sure everything has stopped before we make changes
M906 X1000 Y1000                  ; Reset homing motor current
M915 P0:1 S35 H500 F0 R1          ; Configure Stall Detection
M400                              ; Nake sure everything has stopped before we make changes
G90                               ; Absolute positioning
G1  X{move.axes[0].max/ 2} F30000 ; Back away from rail