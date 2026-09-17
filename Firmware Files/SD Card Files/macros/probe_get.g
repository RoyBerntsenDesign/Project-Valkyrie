; called when the probe_get macro is executed

G90                                 ; use absolute coordinates

;~~~~~ probe dock position ~~~~~
var Xdock_center = 31               ; probe dock X center position
var Ydock_center = -15              ; probe dock Y center position

;~~~~~ pick up probe if not attached ~~~~~
if sensors.probes[0].value[0] == 0  ; 0 = probe attached
    echo "Probe already picked up"
else
    G1 Y{move.axes[1].max / 2} F30000
    G1 X{var.Xdock_center} F30000
    G1 Y{var.Ydock_center} F18000
    G1 Y10 F18000
    M400

    if sensors.probes[0].value[0] != 0
        abort "Probe pickup failed"

M98 P"/macros/probe_center.g"
M400