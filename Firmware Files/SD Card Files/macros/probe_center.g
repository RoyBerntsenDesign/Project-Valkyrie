; called to position the probe at the center of the bed
; probe X and Y offsets are taken into account

G90                                                        ; use absolute coordinates
G1 F30000                                                  ; set positioning speed
G1 Y{move.axes[1].max / 2 - sensors.probes[0].offsets[1]}  ; center probe on Y axis
G1 X{move.axes[0].max / 2 - sensors.probes[0].offsets[0]}  ; center probe on X axis