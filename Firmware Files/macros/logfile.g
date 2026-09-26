; logfile.g
; logs elapsed time, chamber temperature, bed temperature
; and chamber heater PWM to logtemperature.txt
; daemon.g runs approximately once every 10 seconds

var logging_data = true                            ; set true to enable logging
var T = heat.heaters[2].current                    ; chamber temperature
var BedT = heat.heaters[0].current                 ; bed temperature
var PWM = heat.heaters[2].avgPwm                   ; chamber heater average PWM
var log_time_interval = 10                         ; logging interval in seconds

;~~~~~ logging enabled ~~~~~

if var.logging_data

    set global.logCounter = global.logCounter + 1  ; count daemon cycles

    ; daemon runs every ~10 seconds,
    ; so divide desired interval by 10
    if global.logCounter >= var.log_time_interval / 10

        ;~~~~~ append data if logfile already exists ~~~~~

        if fileexists("0:/sys/tmp/logtemperature.txt")

            set var.PWM = var.PWM * 100            ; convert PWM 0-1 to percent

            var elapsed = floor(state.upTime - global.start_uptime)

            var logline = var.elapsed^","
            set var.logline = var.logline^{floor(var.T)}^"."^{floor((var.T - floor(var.T)) * 10)}^","
            set var.logline = var.logline^{floor(var.BedT)}^"."^{floor((var.BedT - floor(var.BedT)) * 10)}^","
            set var.logline = var.logline^{floor(var.PWM)}^"."^{floor((var.PWM - floor(var.PWM)) * 10)}

            echo >>"0:/sys/tmp/logtemperature.txt" var.logline

        ;~~~~~ create logfile if it does not exist ~~~~~

        else

            echo >"0:/sys/tmp/logtemperature.txt" "time_s,T,BedT,PWM"
            set global.start_uptime = state.upTime ; record logging start time

        set global.logCounter = 0                  ; reset counter after logging