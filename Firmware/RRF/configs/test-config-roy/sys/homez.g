; homez.g
; called to home the Z axis
;
; generated by RepRapFirmware Configuration Tool v3.3.10 on Fri Mar 04 2022 20:32:00 GMT+0100 (sentraleuropeisk normaltid)
G91              ; relative positioning
G1 H2 Z5 F6000   ; lift Z relative to current position
G90              ; absolute positioning
G1 X15 Y15 F6000 ; go to first probe point
G30              ; home Z by probing the bed

; Uncomment the following lines to lift Z after probing
;G91             ; relative positioning
;G1 Z5 F100      ; lift Z relative to current position
;G90             ; absolute positioning

