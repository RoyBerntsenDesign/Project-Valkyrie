;cancel.g
echo "Cancel.g "
M83          ; relative extrusion
G1 E-2 F1800 ; Retract filament
M82          ; set to absolute
echo"park tool head"      
M98 P"/macros/nozzle_park"                 
echo"tool head over bucket"
M98 P"/macros/home_Z_max" 
M104 S0      ; Turn off Extruder temperature
M140 S0      ; Turn off Bed temperature
M106 P0 S0   ; Turn off part cooling fan 
M141 P2 S0   ; Turn off Chamber 
M84 E0       ; Turn off stepper motors
M98 P"/macros/nozzle_brush"