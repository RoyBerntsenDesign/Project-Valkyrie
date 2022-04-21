; homez.g
; called to home the Z axis
G1 F18000 X155 Y175
G30                ; home Z by probing the bed

M98 P/macros/3pl ;P define the parameter and is not part of the name
M98 P/macros/3pl ;P define the parameter and is not part of the name

G1 F18000 X155 Y175
G30                ; home Z by probing the bed
G1 F18000 X155 Y150