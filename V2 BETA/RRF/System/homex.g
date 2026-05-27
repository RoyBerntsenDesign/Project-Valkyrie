var calibration = true   ; set to ture or false to check  sensorless homing repeatability  
; homex.g
echo "home the X axis"
M400                     ; make sure everything has stopped before we make changes
G91                      ; relative positioning
M915 P0:1 S2 H200 F0 R0  ; Configure Stall Detection lower S number more sensative 
M906 X600 Y600           ; set homing motor current
G1 F5500
G1 H1 X350               ; Home X-Axis independently

;~~~~~ move to set offset from end stop ~~~~~
G91
G1 X-15                  ; distace to edge of print area
G92 X310                 ; Set User Position
M400                     ; make sure everything has stopped before we make changes

;~~~~~ reset stepper motor  settings ~~~~~ 
M400                     ; make sure everything has stopped before we make changes
M906 X1000 Y1000         ; reset homing motor current
M915 P0:1 S35 H500 F0 R1 ; Configure Stall Detection
M400                     ; make sure everything has stopped before we make changes
G90                      ; absolute positioning
G1 F24000 X250           ; back away from rail