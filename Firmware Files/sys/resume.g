; resume.g
; called before a paused print is resumed

M83                           ; use relative extrusion
G1 E5 F3600                   ; restore the 5 mm pause retract

M98 P"/macros/nozzle_brush.g" ; clean nozzle before returning to print

G1 R1 X0 Y0 F18000            ; return to saved X/Y position, keep current Z
G1 R1 Z0 F1500                ; return to exact saved print Z position

; restore CPAP fan speed from before pause
M106 P0 S{global.pauseFan0Speed}