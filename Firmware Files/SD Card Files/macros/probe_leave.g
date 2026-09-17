; called to return the probe to the docking station

G90                                 ; use absolute coordinates

var Xdock_center = 31
var Ydock_center = -15

if sensors.probes[0].value[0] != 1000
    G1 X{var.Xdock_center} F30000
    G1 Y{var.Ydock_center} F18000
    G1 X70 F6000
    M400

    if sensors.probes[0].value[0] != 1000
        abort "Probe release failed"

M98 P"/macros/probe_center.g"
M400