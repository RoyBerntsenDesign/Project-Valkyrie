; called to home the Y axis
echo "homing Y Axis"
M564 S0 H0
M400                     ; Make sure everything has stopped before we make changes
G91                      ; Relative positioning
M915 P0:1 S2 H200 F0 R0  ; Configure Stall Detection
M906 X600 Y600           ; Set homing motor current
G1 F5200
G1 H1 Y360               ; Home Z-Axis actuators independently

;~~~~~ move to set offset from end stop ~~~~~ 
G91
G1 Y-20                  ; Distace to edge of print area
G92 Y{move.axes[1].max}  ; Set User Position
M400                     ; Make sure everything has stopped before we make changes

;~~~~~ reset stepper motor settings ~~~~~
M906 X1000 Y1000         ; Reset motor current
G90                      ; Absolute positioning
M915 P0:1 S35 H500 F0 R1 ; Configure Y-Axis Stall Detection
G1 Y{move.axes[1].max/ 2} F30000    
M564 S1 H1