M141 P0 S0 R{chamber_temperature[0]}        ;  make chamber heater active and set standby temperature
M140 S{first_layer_bed_temperature[0]}      ; set bed temp
M104 S{first_layer_temperature[0]}          ; set extruder temp
M191 P0 S{chamber_minimal_temperature[0]}   ; wait for chamber minimal temperature
M190 S{first_layer_bed_temperature[0]}      ; wait for bed temp
M109 S{first_layer_temperature[0]}          ; wait for extruder temp

M400
M290 R0 S0 ;clear babystepping
G1 F18000
M400
M98 P"/sys/homez.g"
M400
M98 P"/macros/z_offset"
M400
G92 E0
G1 F18000