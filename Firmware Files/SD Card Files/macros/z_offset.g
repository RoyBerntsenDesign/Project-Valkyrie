; simple sequence to set Z offset

var avg = 0                                                           ; average K0 probe result
var k0_offset = 3.5                                                   ; anvil distance from Y minimum
var k1_offset = 0.0                                                   ; safety distance from Y minimum


;~~~~~ step 1 - pick up probe and establish bed reference ~~~~~

if sensors.probes[0].value[0] == 1000                                 ; 1000 = probe not attached
    M98 P"/macros/probe_get.g"                                        ; pick up probe

if sensors.probes[0].value[0] != 0
    abort "Bed probe not detected correctly"

G31 K0 Z0                                                             ; clear K0 Z offset
G31 K1 Z0                                                             ; clear K1 Z offset

M98 P"/macros/probe_center.g"
M400
G30 K0

;~~~~~ step 2 - probe anvil 3 times and calculate average ~~~~~

G1 X{move.axes[0].max / 2} F30000
G1 Y{move.axes[1].min + var.k0_offset} F30000                         ; move K0 probe to anvil

G30 K0 P0 Z-99999
set var.avg = sensors.probes[0].lastStopHeight

G30 K0 P1 Z-99999
set var.avg = var.avg + sensors.probes[0].lastStopHeight

G30 K0 P2 Z-99999 S-1
set var.avg = var.avg + sensors.probes[0].lastStopHeight

set var.avg = var.avg / 3

echo var.avg, "K0 average anvil height"

G31 K0 Z{var.avg}                                                     ; set K0 trigger height from anvil average
G31 K1 Z{var.avg}                                                     ; set K1 trigger height from anvil average

echo sensors.probes[0].triggerHeight, "K0"
echo sensors.probes[1].triggerHeight, "K1"


;~~~~~ step 3 - move away and return bed probe ~~~~~

G1 X{move.axes[0].max / 2} Y{move.axes[1].max / 2} Z10 F30000

M98 P"/macros/probe_leave.g"                                          ; return bed probe
M400


;~~~~~ step 4 - clean nozzle ~~~~~

M98 P"/macros/nozzle_brush.g"                                         ; brush nozzle


;~~~~~ step 5 - release and probe nozzle on tool switch ~~~~~

M98 P"/macros/nozzle_probe_release.g"                                 ; make sure K1 is released
M400

G1 X{move.axes[0].max / 2} Y{move.axes[1].min + var.k1_offset} F18000 ; move nozzle to K1 probe position

G30 K1                                                                ; probe nozzle with K1

G1 Z15 F1500                                                          ; move bed down to Z15
M98 P"/macros/nozzle_center.g"                                        ; move nozzle to center of bed
M400                                                                  ; wait for final positioning move to finish