; called to home the Y axis
M400                                                 ; Ensure previous motion has finished
G91                                                  ; Relative positioning

M915 P0.0:0.1 S2 H200 F0 R0                          ; Homing stall detection
M906 X800 Y800                                       ; Homing motor current

G1 F3000                                             ; Set homing speed
G1 H1 Y-350                                          ; Home Y

M400                                                 ; Wait until homing move is completely finished

G90                                                  ; Absolute positioning

; Restore normal motor settings
M906 X{move.axes[0].current} Y{move.axes[1].current} ; reset motor current
M915 P0.0:0.1 S35 H500 F0 R1

G1 Y{move.axes[1].max/2} F30000