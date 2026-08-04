
;~~~~~ Don't touch anyting beyond this point(unless you know what you're doing)!! ~~~~~
;~~~~~ move tool head ~~~~~
M98 P"/macros/nozzle_park"                                                                         ; Move the nozzle to the bucket defined in the settings section
M400                                                                                               ; Wait for moves to finish
M291 S1 P"Please wait while the nozzle is being heated up" R{"Loading " ^ var.filament_type}  T20  ; Display message non blocking
M109 P0 S{var.toolT}                                                                               ; Set & wait for current tool temperature
M292 P1

;~~~~~ Move  tool head to reduce friction in PTFE Tube ~~~~~
G1 X310 Y300 F24000                                                                                ; move tp [place to get less friction in the PTFE tube

;~~~~~ Loading filament into buffer ~~~~~
M291 S4 R"Inset filament into buffer" P"when Buffer stops feeding, then press OK." K{"OK","SKIP",} ; Display new me0mode
if input == 0
   M42 P13 S1                                                                                      ; small feed of filament to get over friction short pulse
   G4 P500                                                                                         ; Dwell S= seconds P = milliseconds
   M42 P13 S0  
   G4 P1000                                                                                        ; turn offf feed
   M98 P"/macros/nozzle_park"                                                                      ; Move the nozzle to the bucket defined in the settings section
   M400                                                                                            ; Wait for moves to finish
M42 P13 S1                                                                                         ; small feed of filament to get over friction short pulse
G4 P500                                                                                            ; Dwell S= seconds P = milliseconds
M42 P13 S0 
M83                                                                                                ; Set extruder to relative mode 
G1 E{var.purge_length} F{var.extruder_purge_speed}    
G4 P1000                                                                                           ; Wait one second  
G1 E-5 F180                                                                                        ; Retract filament
M82                                                                                                ; Set extruder to absolute mode
M400                                                                                               ; Wait for moves to complete
M292                                                                                               ; Hide the message
G10 S0                                                                                             ; Turn off the heater again
M291 S4 P"Check Filament has purged" R"if not ?" K{"Purge more and Brush or","Brush",} T15 
if (input == 0)
  M83
  G1 E{var.purge_length} F{var.extruder_purge_speed}  
  M82
  M98 P"/macros/nozzle_brush" 
  M400                                                                                             ; small feed of filament to get over friction short pulse
if (input == 1)    
  M98 P"/macros/nozzle_brush"                                                                      ; Move the nozzle to the bucket defined in the settings section
  M400                          

;~~~~~  Set Dry box Temperature ~~~~~

M291 S1 R"Dry Box" P{"Temperature being set to " ^ var.dryboxT ^ "°C"}  T15                        ; Display message

M141 P1 S{var.dryboxT}                                                                             ; set drybox temperature

M143 H3 S{var.dryboxT+10} A2         

; "SKIP"

if (input == 1) 
  echo "skipped"
M400                                                                                               ; Wait for moves to finish