;Damon file runs every 10 seconds 

;===== log values to a file =====
var logging_data = false                                                                 ; set true or false to log data
var T = heat.heaters[3].current                                                          ; set heate number to log
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if var.logging_data
        if fileexists("0:/sys/logtemperature.txt") 
                echo >>"0:/sys/logtemperature.txt" {state.upTime}^","^{var.T}
        else
                echo >"0:/sys/logtemperature.txt" "0"
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;===== Ramping temperature to stop heater faulting =====
var Chamber_Ramping  = true                                                              ; set ture for active  or false  for off
var heater_number =3                                                                     ; 0= bed 1 = hot end  , 2= Chamber , 3 = Dry Box
var temperature_increase = 5                                                             ; step increase in temperature
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
if var.Chamber_Ramping 
        if heat.heaters[var.heater_number].state = "active"
                                                                                         ; var active_T = heat.heaters[var.heater_number].active
                                                                                         ; M141 H{var.heater_number}, R{var.active_T}
                if heat.heaters[var.heater_number].standby = 0
                        M141 P{var.heater_number} , S0                                   ; set Active temperature to 0
                        M141 P{var.heater_number} , S-273.1                              ; turn off heater
                        echo "set chamber off"                       

                else 
                        var target_temperature = heat.heaters[var.heater_number].standby ;required temperature 
                        echo var.target_temperature , "target temperature"
                        var new_setting =  heat.heaters[var.heater_number].current
                                if heat.heaters[var.heater_number].current < var.target_temperature
                                        var new_temperature =  heat.heaters[var.heater_number].current + var.temperature_increase 
                                        echo var.new_temperature, "new target Temperature"
                                        echo var.new_setting , "Current temperature" 
                                        M141 P{var.heater_number} , S{var.new_temperature}
                                        M106 P2 S1                                       ; turn on chamber fan
                                else
                                        if (heat.heaters[var.heater_number].current  >= (var.new_setting - 3)) && (heat.heaters[var.heater_number].current <= (var.new_setting + 3))
                                                echo "Value is within the +/- 3 tolerance range" 
                                                M141 P{var.heater_number} , S{var.target_temperature}
        else    
                echo " Chamber not Active"
                                                                                         ; if heat.heaters[3].state == "off" ||  sensors.analog[3].lastReading < 35  ;turn off fan when chamber has cooled down 
                                                                                         ; M106 P2 S0
        echo heat.heaters[var.heater_number].avgPwm, "Average PWM"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 
;===== Drybox Fan control =====
var drybox_fan_control  = true                                                           ; set ture for active  or false  for off
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;if global.currentState !=  heat.heaters[3].state ;||   sensors.analog[3].lastReading  > 30 || heat.heaters[3].active > 0
                                                                                         ; echo heat.heaters[3].state
if var.drybox_fan_control                                                                ; set global.currentState = heat.heaters[3].state

        if heat.heaters[3].state == "active" &&  heat.heaters[3].active > 20             ; demand vale of heating 
                M106 P2 S0.8                                                             ; turn on drybox fan 80%
                echo "Drybox Fan & Heater On"
   
        elif heat.heaters[3].state == "off"  || heat.heaters[3].state == "active"  &&  sensors.analog[3].lastReading  > 35 
                M106 P2 S0.8
                echo "Fan On, Heater Off"    
                                                                                         ; echo heat.heaters[3].state                                        ;echo "state the same"
        elif heat.heaters[3].state == "off" ||  sensors.analog[3].lastReading < 35 
                M106 P2 S0                                                               ; echo "Fan Off, Heater Off"    
        else
                M106 P2 S0                                                               ; echo "Fan Off,  Heater Off"  
if heat.heaters[3].state == "fault"                                                      ; checking for fan On and heater off
          M106 P2 S1                                                                     ; turn fan on full
           echo  "*****Heater Fault********* Fan On"   
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;===== Filter Fan control =====
var filter_fan_control = false     
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if var.filter_fan_control
        if sensors.analog[2].lastReading <35                                             ; check temperature in the chamber
                M106 P2 S0                                                               ; turn fan off
                echo "Filter Fan Off" 
        else
                M106 P2 S1                                                               ; turn fan off
                echo "Filter Fan On" 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                                                                         

;===== update filament weight =====
var filament_weight = false
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if var.filament_weight
        M98 P"/macros/filamentWeight"
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;====== Water Pump =====
var pumpFitted = false                                                                   ; need finsishing 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if var.pumpFitted
        if job.duration = null                                                           ; No job ignore sensor reading
                                                                                         ; enter pump on pins
                echo "Pump Off"
        else                                                                             ; Check Water Flow
                if fans[X].rpm < 100                                                             ; define fan  for monitiring  ; NO FLOW
                M25
                M117 "No Water flow!" 
                M118 S"No Water flow!" L1
                M118 P3 S"No Water flow!" 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~