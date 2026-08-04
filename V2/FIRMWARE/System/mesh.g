;General mesh probing routine
echo "mesh.g / G29"
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
    G28                            ; Home all axes if not already homed

if sensors.probes[0].value[0] == 0 ; if sensor is value =1000 not attached , 0=probe attached
	echo "probe attached"
else 
    M98 P"/macros/probe_get"       
M561                               ; Clear any existing bed transform
M564 S0                            ; Allow movement lower than z0
G29 S0                             ; do mesh bed measure