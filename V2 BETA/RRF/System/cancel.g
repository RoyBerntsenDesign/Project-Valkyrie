;cancel.g
echo "Cancel.g "
G1 E-0.5 F1800             ; retract filament
echo"park tool head"      ; Move printhead end pos
M98 P"/macros/nozzle_park"                 
echo"tool head over bucket"
M98 P"/macros/home_Z_max" ; send be to max z
M104 S0                   ; turn off Extruder temperature
M140 S0                   ; turn off Bed temperature
M106 P0 S0                ; turn off part cooling fan 
M141 P2 S0                ; turn off Chamber 
M84                       ; turn off stepper motors
M98 P"/macros/nozzle_brush"