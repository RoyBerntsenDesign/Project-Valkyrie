; daemon.g
; Runs repeatedly to update background functions and safety checks

;~~~~~ logging ~~~~~

M98 P"/macros/logfile.g"       ; log chamber temperature and heater PWM


;~~~~~ chamber fan control ~~~~~

if heat.heaters[2].active > 0 || heat.heaters[2].standby > 0
    M106 P1 S1                 ; run chamber circulation fan while chamber heating is requested

    if fans[1].rpm < 1000
        set global.chamberFanFaultCounter = global.chamberFanFaultCounter + 1

        if global.chamberFanFaultCounter >= 2
            M141 P0 S-273.1 R0 ; turn chamber heater off and clear stored ramp target
            M106 P1 S0         ; stop chamber fan after fault shutdown
            set global.chamberFanFaultCounter = 0
    else
        set global.chamberFanFaultCounter = 0
else
    M106 P1 S0                 ; turn chamber fan off when chamber heating is not requested
    set global.chamberFanFaultCounter = 0


;~~~~~ chamber temperature control ~~~~~

M98 P"/macros/chamber_ramp.g"  ; update chamber temperature ramp


;~~~~~ drybox fan control ~~~~~

if heat.heaters[3].state == "active"
    M106 P2 S1                 ; turn drybox fan on while drybox heater is active
else
    M106 P2 S0                 ; turn drybox fan off when drybox heater is inactive