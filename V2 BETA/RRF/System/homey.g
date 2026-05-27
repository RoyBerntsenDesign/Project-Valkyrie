; called to home the Y axis
echo "homing Y Axis"
M564 S0 H0
M400                     ; make sure everything has stopped before we make changes
G91                      ; relative positioning
M915 P0:1 S2 H200 F0 R0  ; Configure Stall Detection
M906 X600 Y600           ; set homing motor current
G1 F4500
G1 H1 Y360               ; Home Z-Axis actuators independently

;~~~~~ move to set offset from end stop ~~~~~ 
G91
G1 Y-20                  ; distace to edge of print area
G92 Y290                 ; Set User Position
M400                     ; make sure everything has stopped before we make changes

;~~~~~ reset stepper motor settings ~~~~~
M906 X1000 Y1000         ; Reset motor current
G90                      ; absolute positioning
M915 P0:1 S35 H500 F0 R1 ; Configure Y-Axis Stall Detection
G1 F30000 Y152.5         ; move to probe position midle bed (x155 y155)
M564 S1 H1