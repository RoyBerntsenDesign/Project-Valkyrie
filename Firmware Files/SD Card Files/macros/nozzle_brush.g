; called to brush the nozzle

G90

var Xbucket_position = (move.axes[0].max / 2) + 80
var Ybucket_position = move.axes[1].min + 1
var Xbrush_distance = 45
var number_brush = 10
var speed1 = 30000
var speed2 = 18000

if sensors.probes[0].value[0] != 1000
    M98 P"/macros/probe_leave.g"

G1 Y{var.Ybucket_position} F{var.speed1}
G1 X{var.Xbucket_position} F{var.speed1}
M400

G91

while true
    if iterations == var.number_brush
        break

    G1 X{var.Xbrush_distance} F{var.speed2}
    G1 X{-var.Xbrush_distance} F{var.speed2}

G90