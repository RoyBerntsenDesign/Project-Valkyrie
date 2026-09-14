; called to level the bed

M561                                                ; clear any bed transform

;~~~~~ home printer if required ~~~~~
if !move.axes[0].homed || !move.axes[1].homed
    G28                                             ; home all axes

;~~~~~ make sure probe is attached ~~~~~
if sensors.probes[0].value[0] == 1000               ; 1000 = probe not attached
    echo "Already homed, going to pick up probe"
    M98 P"/macros/probe_get"                        ; pick up probe

M400                                                ; wait for probe pickup moves to finish

;~~~~~ move probe to bed center ~~~~~
M98 P"/macros/probe_center"

;~~~~~ automatic 3-point bed leveling ~~~~~
if sensors.probes[0].value[0] == 0                  ; 0 = probe attached
    while true
        echo "Repeating calibration because deviation is too high (" ^ move.calibration.initial.deviation ^ "mm)"

        if iterations == 5                          ; maximum number of attempts
            M98 P"/macros/probe_leave"              ; drop off probe
            M98 P"/macros/nozzle_park"              ; park toolhead over bucket
            abort "Too many auto calibration attempts"

        G30 P0 X{move.axes[0].min + 23} Y{move.axes[1].min + 35} Z-99999
                                                     ; probe front-left point
        if result != 0
            continue

        G30 P1 X{move.axes[0].max - 20} Y{move.axes[1].min + 35} Z-99999
                                                     ; probe front-right point
        if result != 0
            continue

        G30 P2 X{move.axes[0].max / 2} Y{move.axes[1].max - 25} Z-99999 S3
                                                     ; probe rear-center point
        if result != 0
            continue

        if move.calibration.initial.deviation <= 0.03
            break                                    ; leveling tolerance reached

echo "Auto calibration successful, deviation " ^ move.calibration.final.deviation ^ "mm"

;~~~~~ center probe and load mesh compensation ~~~~~
M98 P"/macros/probe_center"                         ; move probe to center of bed
M400                                                ; wait for move to finish

G1 Z15 F3000                                        ; move bed down 15 mm
G29 S1                                              ; load height map
M376 H5                                             ; mesh compensation fade height