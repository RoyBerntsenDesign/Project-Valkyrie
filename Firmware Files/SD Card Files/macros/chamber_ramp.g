; chamber_ramp.g
; ramps chamber temperature to reduce heater faults
; standby temperature stores the final requested chamber temperature
; active temperature is raised 5C ahead of the measured temperature
; ramping ends when current temperature is within +/-3C of the active target
; active is then set equal to standby, which prevents ramping from restarting

var Chamber_Ramping = true
var heater_number = 2
var chamber_number = 0
var temperature_increase = 5
var tolerance = 3

;~~~~~ chamber ramping enabled ~~~~~

if var.Chamber_Ramping

    ;~~~~~ chamber heating requested ~~~~~

    if heat.heaters[var.heater_number].standby != 0

        ; only ramp while active target differs from final standby target
        if heat.heaters[var.heater_number].active != heat.heaters[var.heater_number].standby

            var target_temperature = heat.heaters[var.heater_number].standby
            var active_temperature = heat.heaters[var.heater_number].active
            var current_temperature = heat.heaters[var.heater_number].current

            ; keep active target 5C ahead while below final target
            if var.current_temperature < var.target_temperature

                var new_temperature = var.current_temperature + var.temperature_increase

                M141 P{var.chamber_number} S{var.new_temperature} R{var.target_temperature}
                M106 P1 S1                                  ; turn chamber circulation fan on

            ; final temperature reached - wait for overshoot target
            else

                if (var.current_temperature >= var.active_temperature - var.tolerance) && (var.current_temperature <= var.active_temperature + var.tolerance)

                    echo "Chamber within +/-3C tolerance - ramping complete"

                    M141 P{var.chamber_number} S{var.target_temperature} R{var.target_temperature}

        ;~~~~~ ramping complete ~~~~~

        else

            M307 H2 R0.25 K0.25:0.000 D11 E1.35 S1.00 B0

    ;~~~~~ chamber heating off ~~~~~

    else

        M141 P{var.chamber_number} S-273.1 R0             ; switch chamber heater off
        M307 H2 S1.00 B1                                  ; restore bang-bang mode

    ;~~~~~ chamber fan cooldown ~~~~~

    if heat.heaters[var.heater_number].state == "off" && heat.heaters[var.heater_number].current >= 40
        M106 P1 S1                                        ; keep fan on while chamber is hot

    elif heat.heaters[var.heater_number].state == "off" && heat.heaters[var.heater_number].current < 40
        M106 P1 S0                                        ; turn fan off below 40C