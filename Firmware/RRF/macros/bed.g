; bed.g
; called to perform automatic bed compensation via G32

; 3Z
G28 ; home
M401 ; deploy Z probe (omit if using bltouch)
G1 F6000
G30 P0 X0 Y50 Z-99999 ; probe near a leadscrew
G30 P1 X330 Y50 Z-99999 ; probe near a leadscrew
G30 P2 X165 Y310 Z-99999 S3 ; probe near a leadscrew and calibrate 3 motors
M402 ; retract probe (omit if using bltouch)