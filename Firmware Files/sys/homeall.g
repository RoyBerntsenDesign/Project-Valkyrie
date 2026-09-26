; homeall.g
; called when homing all axes with G28

if !move.axes[0].homed || !move.axes[1].homed
    M561                         ; clear bed transform
    M98 P"/sys/homey.g"          ; home Y axis
    M98 P"/sys/homex.g"          ; home X axis

M98 P"/sys/homez.g"              ; home Z axis