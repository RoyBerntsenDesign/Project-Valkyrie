; nozzle_probe_release.g
;
; Probe 1 = nozzle probe
; 0     = released
; != 0  = needs releasing
;
; Uses the calibrated trigger height of probe 1
; and presses 0.5 mm below it, then retracts 1 mm above it.
;
; Maximum 3 attempts.

var safe_z = 10
var press_offset = 0.5
var retract_offset = 1.0
var max_attempts = 3

var probe_x = move.axes[0].max / 2
var probe_y = move.axes[1].min + 0

var trigger_z = sensors.probes[1].triggerHeight
var press_z = var.trigger_z - var.press_offset
var retract_z = var.trigger_z + var.retract_offset


if sensors.probes[1].value[0] != 0

    echo "Releasing nozzle probe"

    G90

 ; move to safe Z first
    G1 Z{var.safe_z} F1500
    M400

 ; move nozzle over probe
    G1 X{var.probe_x} Y{var.probe_y} F18000
    M400

    var attempt = 0

    while sensors.probes[1].value[0] != 0 && var.attempt < var.max_attempts

        set var.attempt = var.attempt + 1

        echo "Nozzle probe release attempt"^var.attempt

 ; press slightly below calibrated trigger height
        G1 Z{var.press_z} F300
        M400

 ; retract slightly above trigger height
        G1 Z{var.retract_z} F900
        M400

 ; allow probe state to settle
        G4 P250

    if sensors.probes[1].value[0] == 0

        echo "Nozzle probe released after"^var.attempt^"attempt(s)"

    else

        echo "WARNING: Nozzle probe failed to release after"^var.max_attempts^"attempts"

else

    echo "Nozzle probe already released"