; called to home the Z axis
M561                        ; cancel any bed-plane values
G90                         ; set to absolute positioning

M98 P"/macros/probe_get"    ; pick up probe if not attached
M400                        ; wait for moves to finish

G30 K0                      ; home Z by probing the bed
G1 Z25                      ; move bed down 25mm
G32                         ; 3 point bed leveling by running /sys/bed.g