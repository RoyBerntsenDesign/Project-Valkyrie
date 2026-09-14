; WIP
; this file runs and refreshes every 10 seconds to update everything inside this file

; log temp and pwm on the chamber heater
M98 P"/macros/logfile"
; ramp temp
M98 P"/macros/chamber_ramp"
;~~~~ safety features ~~~~~
; activate drybox fan if heater active
if heat.heaters[3].state == "active"
    M106 P2 S1

; turn off chamber heater if chamber fan is not running
if fans[1].rpm <1000
    M141 H2 S-273.1 ; turn off heater