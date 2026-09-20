; chamber_ramp.g
;
; Heater 2 = chamber heater
; Fan 1    = chamber circulation fan
;
; Chamber standby temperature = final requested chamber target
; Chamber active temperature  = temporary ramp target
;
; During chamber heat-up:
;   - chamber uses bang-bang mode
;   - active target stays 5C ahead of measured temperature
;
; While printer is IDLE:
;   - bed moves to Z100
;   - bed target follows the requested chamber target
;
; During printing / any non-idle state:
;   - chamber can still ramp
;   - bed does NOT move
;   - bed target is NOT changed
;
; Once chamber reaches final requested temperature:
;   - active target is no longer increased
;   - chamber continues toward the last overshoot target
;   - when actual temperature is within +/-3C of active target,
;     active is set back to final target
;   - chamber switches to PID
;
; If chamber target is changed:
;   - higher target = new bang-bang ramp
;   - lower target = bed follows new target while idle
;                    and chamber returns to PID at new target

var Chamber_Ramping = true
var heater_number = 2
var fan_number = 1
var temperature_increase = 5
var tolerance = 3
var preheat_z = 100


if var.Chamber_Ramping

    ;~~~~~ chamber heating requested ~~~~~

    if heat.heaters[var.heater_number].standby != 0

        ; keep chamber circulation fan running
        M106 P{var.fan_number} S1


        ;~~~~~ active target differs from final requested target ~~~~~

        if heat.heaters[var.heater_number].active != heat.heaters[var.heater_number].standby

            var target_temperature = heat.heaters[var.heater_number].standby
            var active_temperature = heat.heaters[var.heater_number].active
            var current_temperature = heat.heaters[var.heater_number].current


            ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ; BED ASSIST - IDLE ONLY
            ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            if state.status == "idle"

                ; move bed to chamber preheat position
                if move.axes[2].homed
                    G90
                    G1 Z{var.preheat_z} F3000
                    M400

                ; bed follows requested chamber target
                M140 S{var.target_temperature}


            ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ; CHAMBER BELOW FINAL TARGET
            ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            if var.current_temperature < var.target_temperature

                ; use bang-bang during upward ramp
                M307 H{var.heater_number} B1

                ; keep active target 5C ahead
                var new_temperature = var.current_temperature + var.temperature_increase

                M141 H{var.heater_number} S{var.new_temperature}


            ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ; CHAMBER AT OR ABOVE FINAL TARGET
            ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            else

                ; stop increasing active target
                ; wait until measured temperature is
                ; within tolerance of last active target

                if (var.current_temperature >= var.active_temperature - var.tolerance) && (var.current_temperature <= var.active_temperature + var.tolerance)

                    echo "Chamber ramp complete - switching to PID"

                    ; set chamber to requested final target
                    M141 H{var.heater_number} S{var.target_temperature}

                    ; switch chamber back to PID
                    M307 H{var.heater_number} B0


        ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ; ACTIVE AND STANDBY ALREADY EQUAL
        ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        else

            ; normal steady-state chamber control
            M307 H{var.heater_number} B0


    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ; CHAMBER HEATING OFF
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    else

        ; clear bed target while idle
        if state.status == "idle"
            M140 S0

        ; clear chamber active target
        M141 H{var.heater_number} S0

        ; turn chamber heater fully off
        M141 H{var.heater_number} S-273.1

        ; prepare bang-bang for next heat-up
        M307 H{var.heater_number} B1


    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ; CHAMBER FAN COOLDOWN
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    if heat.heaters[var.heater_number].state == "off" && heat.heaters[var.heater_number].current >= 40
        M106 P{var.fan_number} S1

    elif heat.heaters[var.heater_number].state == "off" && heat.heaters[var.heater_number].current < 40
        M106 P{var.fan_number} S0