; bed.g
; called to level the bed with G32

M561                                                                 ; clear any bed transform

;~~~~~ home X and Y if required ~~~~~

if !move.axes[0].homed || !move.axes[1].homed
    M98 P"/sys/homey.g"                                              ; home Y axis
    M98 P"/sys/homex.g"                                              ; home X axis

;~~~~~ make sure probe is attached ~~~~~

if sensors.probes[0].value[0] == 1000                                ; 1000 = probe not attached
    echo "Probe not attached, picking up probe"
    M98 P"/macros/probe_get.g"

M400                                                                 ; wait for probe pickup moves to finish

if sensors.probes[0].value[0] != 0                                   ; anything other than 0 = probe connection problem
    abort "Probe not detected correctly"

;~~~~~ move probe to bed center ~~~~~

M98 P"/macros/probe_center.g"

;~~~~~ automatic 3-point bed leveling ~~~~~

while true

    if iterations == 5                                               ; maximum of 5 attempts
        M98 P"/macros/probe_leave.g"                                   ; drop off probe
        M98 P"/macros/nozzle_park.g"                                   ; park toolhead over bucket
        abort "Too many auto calibration attempts"

    G30 P0 X{move.axes[0].min + 13} Y{move.axes[1].min + 35} Z-99999 ; probe front-left point
    if result != 0
        continue

    G30 P1 X{move.axes[0].max - 10} Y{move.axes[1].min + 35} Z-99999 ; probe front-right point
    if result != 0
        continue

    G30 P2 X{move.axes[0].max / 2} Y{move.axes[1].max - 20} Z-99999 S3 ; probe rear-center point
    if result != 0
        continue

    if move.calibration.initial.deviation <= 0.03
        break                                                        ; leveling tolerance reached

    echo "Repeating calibration because deviation is too high (" ^ move.calibration.initial.deviation ^ "mm)"

echo "Auto calibration successful, deviation " ^ move.calibration.final.deviation ^ "mm"

;~~~~~ center probe and load mesh compensation ~~~~~

M98 P"/macros/probe_center.g"
M400

G1 Z15 F3000

if fileexists("0:/sys/heightmap.csv")
    G29 S1                              ; load saved height map
    M376 H5                             ; fade mesh compensation over 5mm
else
    echo "No saved height map found - mesh compensation not loaded"