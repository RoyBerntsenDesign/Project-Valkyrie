; homez.g
if sensors.probes[0].value[0]==0                             ;1000 = probe not attached, 0 = probe attached
    echo "Probe already picked up"
    echo "homez.g "
    M561                                                     ; cancels any bed-plane values 3 or 4 point
    G90                                                      ; Set to Absolute Positioning
    G1  X{global.center_tool_Y } Y{global.center_tool_X} F30000               ; probe to center bed  
    G30                                                ; Single Z-Probe set height
    echo sensors.probes[0].lastStopHeight,"REF center probe" ; report last stop height value
    echo "homez.g finished"
else
    echo "Probe NOT picked up!"