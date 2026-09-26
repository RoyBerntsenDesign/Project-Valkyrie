; called to park the nozzle over the purge bucket

G90                                                       ; use absolute coordinates

var Xbucket_position = (move.axes[0].max / 2) + 80        ; bucket X position
var Ybucket_position = move.axes[1].min + 1               ; bucket Y position

;~~~~~ do not change anything below this line ~~~~~

if sensors.probes[0].value[0] != 1000                     ; anything other than 1000 may mean probe is attached
    M98 P"/macros/probe_leave.g"                          ; drop off probe

G1 Y{var.Ybucket_position} X{var.Xbucket_position} F24000 ; move to bucket X position
; G1 Y{var.Ybucket_position} F24000                   ; move to bucket Y position