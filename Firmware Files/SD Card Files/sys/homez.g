; called to home the Z axis

M561                        ; cancel any bed-plane values
G90                         ; use absolute positioning

M98 P"/macros/probe_get.g"    ; pick up probe if not attached
M400                        ; wait for probe pickup moves to finish

G30 K0                      ; home Z using the removable bed probe
G1 Z15 F3000                ; move bed down to Z15
G32                         ; run 3-point bed leveling using /sys/bed.g