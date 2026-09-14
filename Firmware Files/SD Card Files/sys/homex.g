; called to home the X axis

M400                                                 ; wait for previous moves to finish
G91                                                  ; set relative positioning

M915 P0.0:0.1 S2 H200 F0 R0                          ; configure stall detection for homing
M906 X800 Y800                                       ; set homing motor current

G1 F3000                                             ; set homing speed
G1 H1 X-350                                          ; home X-axis independently

M400                                                 ; wait until homing move has fully finished
G90                                                  ; reset to absolute positioning

;~~~~~ reset stepper motor settings ~~~~~
M906 X{move.axes[0].current} Y{move.axes[1].current} ; reset motor current
M915 P0.0:0.1 S35 H500 F0 R1                         ; restore normal stall detection

G1 X{move.axes[0].max/2} F30000                      ; move toolhead to X-axis center