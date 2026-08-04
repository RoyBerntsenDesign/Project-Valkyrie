; homeall.g G28
echo "Homeall / G28"
if !move.axes[0].homed || !move.axes[1].homed ; check to see if X and Y have been homed
    echo "G28 Homeall.g "
    M561                                      ; clear bed transforms   (same as G29 S2)
    M98 P"/sys/homey.g"        
    M400
    M98 P"/sys/homex.g"        
    M400
if sensors.probes[0].value[0] == 0            ; if sensor is value other than 1000 do this, 0 = probe attached
    M98 P"/macros/probe_leave" 
    M400
M98 P"/macros/nozzle_park"
M98 P"/macros/nozzle_brush"
M400 
M98 P"/macros/probe_get"                      ; probe pick up
M98 P"/sys/homez.g"        
M400