;update values below 
var filament_type = "PLA"                                                                          ; filamenmnt type
var toolT =230                                                                                     ; set hotend temperature     
var dryboxT = 25                                                                                   ; set dry box off temperature    
var purge_length = 5                                                                               ; set the length of filament to purge
var unload_length = 80    
var extruder_retract_speed = 200  
var unload_time_buffer = 50                                                                        ; unload buffer time in seconds                                                                                                                      ; unload extruder speed                                                                       ; unload length 


;~~~~~ Don't touch anyting beyond this point(unless you know what you're doing)!! ~~~~~
echo "Going to unload", {var.filament_type}
M98 P"/macros/nozzle_park"                                                                         ; Move the nozzle to the bucket defined in the settings section
M400                                                                                               ; Wait for moves to finish
M291 S1 P"Please wait while the nozzle is being heated up" R{"Unloading " ^ var.filament_type} T15 ; Display message
M109 P0 S{var.toolT}                                                                               ; Set & wait for current tool temperature
M291 P"Unfeeding filament..." R{"Unloading " ^ var.filament_type}                                  ; Display new message
M83   
G1 E{var.purge_length} F{var.extruder_retract_speed}                                               ; Extruder to relative mode
G1 E{-(var.unload_length)} F{var.extruder_retract_speed}                                           ; unload filament from extruder
M82                                                                                                ; Set extruder to absolute mode
M400                                                                                          
G10 P0 S0                                                                                          ; turn off extuder

;~~~~~  unfeed filament from buffer ~~~~~~
M42 P14 S1                                                                                         ; Turn on retract on buffer
G4 S{var.unload_time_buffer}                                                                       ; unload time of buffer
M400                                                                                               ; Wait for moves to complete
M292                                                                                               ; Hide the message
M42 P14 S0                                                                                         ; Turn off reract  filament onbuffer
M702 P0                                                                                            ; Sets loaded filament to null   
M291 S1 P"Remove Filament from Buffer " T15
M400                                                                                 
;~~~~~ Set Dry box Temperature ~~~~~ 
M291 S1 P{"Dry box temperature being set to " ^ var.dryboxT^"°C"} T5                                  ; Display message
M141 P1 S{var.dryboxT}                                                                             ; set drybox temperature