M400
G28 X0 Y0 Z0
G1 F6000 Z100
M584 Z5 U6 V7                            ; Separate Z-Axis Lead screws and drive independently
M92 X80.00 Y80.00 Z320.00 U320.00 V320.00 E810.00              ; set steps per mm
M566 X900.00 Y900.00 Z600 U600 V600 E900.00           ; set maximum instantaneous speed changes (mm/min)
M203 X90000.00 Y90000.00 Z6000.00 U6000.00 V6000.00 E6000.00      ; set maximum speeds (mm/min)
M201 X10000.00 Y10000.00 Z600.00 U600.00 V600.00 E10000.00      ; set accelerations (mm/s^2)
M906 X1200 Y1200 Z500 U500 V500 E300 I30                   ; set motor currents (mA) and motor idle factor in per cent
G1 F6000
G92 Z0 U0 V0
G1 Z20 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z20 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z20 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z20 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75
G1 Z75 U-75 V0
G1 Z0 U0 V75
G1 Z-75 U75 V-75

G1 Z0 U0 V0
M584 X0 Y1 Z5:6:7 E3                        ; Reset drive mapping
M203 Z6000.00