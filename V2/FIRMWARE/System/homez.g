; homez.g
echo "homez.g "
if sensors.probes[0].value[0]==1000                             ; 0 = probe attached, 1000 = not attached
    M98 P"/macros/probe_get"
M561                                                     ; cancels any bed-plane values 3 or 4 point
G90                                                      ; Set to Absolute Positioning
M98 P"0:/macros/probe_center"
G30                                                      ; Single Z-Probe set height
echo sensors.probes[0].lastStopHeight,"REF center probe" ; report last stop height value
echo "homez.g finished"