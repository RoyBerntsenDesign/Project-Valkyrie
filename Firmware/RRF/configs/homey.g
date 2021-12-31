; homey.g
; called to home the Y axis
;
M400                                                   ; make sure everything has stopped before we make changes
G91                                  ; relative positioning
M915 P0:1 S3 F0 R0                            ; Configure Z-Axis Stall Detection
M913 X70 Y70                                      ; Lower motor current by 50%
G1 F6000
G1 H1 Y-350                           ; Home Z-Axis actuators independently
M400                                                   ; make sure everything has stopped before we make changes
M913 X100 Y100                                    ; Reset motor current
G90                                  ; absolute positioning