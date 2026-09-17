; logfile.g
; logs chamber temperature and heater PWM to logtemperature.txt
; daemon.g runs approximately once every 10 seconds

var logging_data = false                              ; set true to enable logging
var T = heat.heaters[2].current                       ; chamber heater temperature
var PWM = heat.heaters[2].avgPwm                      ; chamber heater average PWM
var log_time_interval = 10                            ; logging interval in seconds

;~~~~~ logging enabled ~~~~~

if var.logging_data

    set global.logCounter = global.logCounter + 1     ; count daemon cycles

    ; daemon runs every ~10 seconds, so divide desired interval by 10
    if global.logCounter >= var.log_time_interval / 10

        ;~~~~~ append data if logfile already exists ~~~~~

        if fileexists("0:/sys/logtemperature.txt")

            set var.PWM = var.PWM * 100               ; convert PWM from 0-1 to percent

            echo >>"0:/sys/logtemperature.txt" {floor((state.upTime - global.start_uptime) / 60)}^","^{floor(var.T)}^"."^{floor((var.T - floor(var.T)) * 10)}^","^{floor(var.PWM)}^"."^{floor((var.PWM - floor(var.PWM)) * 10)}

        ;~~~~~ create logfile if it does not exist ~~~~~

        else

            echo >"0:/sys/logtemperature.txt" "time,T,PWM"
            set global.start_uptime = state.upTime     ; record logging start time

        set global.logCounter = 0                     ; reset counter after logging