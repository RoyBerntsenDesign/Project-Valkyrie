; start.g
; print start sequence

;~~~~~ heat chamber, bed and hotend ~~~~~

M141 P0 S0 R{chamber_temperature[0]}        ; store final chamber target for chamber ramp
M140 S{first_layer_bed_temperature[0]}      ; set bed temperature
M104 S{first_layer_temperature[0]}          ; set hotend temperature

M191 P0 S{chamber_minimal_temperature[0]}   ; wait for minimum chamber temperature
M190 S{first_layer_bed_temperature[0]}      ; wait for bed temperature
M109 S{first_layer_temperature[0]}          ; wait for hotend temperature

;~~~~~ clear previous Z adjustment ~~~~~

M290 R0 S0                                  ; clear babystepping

;~~~~~ home and calibrate Z ~~~~~

M98 P"/sys/homez.g"                         ; home Z and run G32 bed leveling
M400

M98 P"/macros/z_offset.g"                   ; calibrate nozzle Z offset
M400

;~~~~~ prepare for print ~~~~~

G92 E0                                      ; reset extruder position

if fileexists("0:/sys/heightmap.csv")
    G29 S1                                  ; load saved height map

M106 P0 S1                                  ; enable CPAP part cooling