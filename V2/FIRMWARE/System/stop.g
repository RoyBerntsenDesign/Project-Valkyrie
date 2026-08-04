; stop.g  runs after a sucsessfull print 
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)
echo "stop.g"
G91                     ; Relative positioning
G1 Z5 F3000             ; Move bed down 
G90                     ; Absolute positioning
M98 P"/macros/nozzle_park" 
M98 P"/macros/nozzle_brush"    
G1 Z300 F3000
M83                     ; relative extrusion
G1 E-3 F1800            ; Retract filament to stop ooz
M82                     ; set to absolute 
M104 S0                 ; Turn off Extruder temperature
M140 S0                 ; Turn off Bed temperature
M141 P2 R0              ; Turn off chamber temperature
echo "turn off motors"
echo "turn off Chamber to be added"
;M106 P0 S0              ; Turn off fan
M557 X15:295 Y15:280 P5 ; Reset bed mesh same as config !!! note need to check if i still need to do this 

;~~~~~ Delete lines below if not logging print time or history ~~~~~

;~~~~~ Log running time for service interval ~~~~~
M98 P"/sys/log_PrintTime.g"

;~~~~~ Saves the print data to the SD card ~~~~~
echo "stop.g run history logged to sd card"
echo >>"history_job.g" state.time^ ",file," ^ job.file.fileName ^ ",elapsed time," ^ job.duration/60
echo "print time logged"
M98 P"/macros/printTime.g"