; homez.g
if sensors.probes[0].value[0]==0                             ; if sensor is value other than 1000 do this, 0 = probe attached
    echo "Probe already picked up"
    echo "homez.g "
    M561                                                     ; cancels any bed-plane values 3 or 4 point
    G90                                                      ; Set to Absolute Positioning
    G1 F12000 X153 Y179.5                                    ; make sure X Y centreed need to +/- the values of the probe offsets	
    G30  F5000                                               ; Single Z-Probe set height
    echo sensors.probes[0].lastStopHeight,"REF center probe" ; report last stop height value
    echo "homez.g finished"
else
    echo "Probe NOT picked up!"