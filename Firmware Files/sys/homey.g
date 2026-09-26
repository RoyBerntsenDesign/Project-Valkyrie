; called to home the Y axis

M400                                  ; wait for previous motion to finish
G91                                   ; use relative positioning

M915 P0.0:0.1 S2 H200 F0 R0          ; set StallGuard for homing
M906 X800 Y800                        ; set homing motor current

G1 H1 Y-350 F3000                     ; home Y toward low end

M400                                  ; wait until homing move has finished

G90                                   ; return to absolute positioning

M906 X1750 Y1750                      ; restore normal X/Y motor current
M915 P0.0:0.1 S35 H500 F0 R1         ; restore normal StallGuard settings

G1 Y{move.axes[1].max / 2} F30000     ; move Y to center