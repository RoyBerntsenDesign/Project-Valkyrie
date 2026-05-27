; Configuration file for Duet 3 (firmware version 3.3)
; executed by the firmware on start-up

; General preferences
; M575 P1 S1 B57600                            ; enable support for PanelDue
G90                                          ; send absolute coordinates...
M83                                          ; ...but relative extruder moves
M550 P"V2-100"                               ; set printer name
M669 K1                                      ; select CoreXY mode

; Network
M552 S1 ; P192.168.101.183 S1                             ; enable network and acquire dynamic address via DHCP
M586 P0 S1                                   ; enable HTTP
M586 P1 S0                                   ; disable FTP
M586 P2 S0                                   ; disable Telnet

; Drives
M569 P0.0 S0                                 ; physical drive 0.0 goes forwards
M569 P0.1 S0                                 ; physical drive 0.1 goes forwards
M569 P0.2 S1                                ; Extruder physical drive 0.2 goes forwards
M569 P0.3 S0                                 ; Z1 physical drive 0.3 goes forwards
M569 P0.4 S1                                 ; Z2 physical drive 0.3 goes forwards
M569 P0.5 S0                                 ; Z3 physical drive 0.3 goes forwards

M584 X0.0 Y0.1 E0.2 Z0.3:0.4:0.5                   ; set drive mapping
M350 Z16 E16 I0                              ; configure microstepping without interpolation
M350 X16 Y16 I1                              ; configure microstepping with interpolation
M92 X80.00 Y80.00 Z320.00 E932.00            ; set steps per mm
M566 X600.00 Y600.00 Z600.00 E600.00         ; set maximum instantaneous speed changes (mm/min)
M203 X90000.00 Y90000.00 Z1500.00 E9000.00   ; set maximum speeds (mm/min)
M201 X10000.00 Y10000.00 Z600.00 E10000.00      ; set accelerations (mm/s^2)
M906 X1750 Y1750 E900 I30                 ; set motor currents (mA) for XYE and motor idle factor in per cent
M906 Z500 I50                ; set motor currents (mA) for Z and motor idle factor in per cent
M84 S30                                      ; Set idle timeout

; Axis Limits
M208 X-17 Y-26 Z-5 S1                           ; set axis minima
M208 X325 Y319 Z290 S0                         ; set axis maxima

; Endstops
M574 X1 S3                                   ; configure sensorless endstop for low end on X
M574 Y1 S3                                   ; configure sensorless endstop for high end on Y
M574 Z1 S2                                   ; configure Z-probe endstop for low end on Z

; 3Z
M671 X-10:320:155 Y-10:-10:320 S10 				; leadscrews at front left, rear middle and front right

; Filament runout
M591 P1 C"io3.in" S1 D0 ; filament monitor connected

; Sensorless config
M915 P0:1 S3 F0 R0
M915 P0.3:0.4:0.5 S4 F0 R0

; Z-Probe
M558 K0 P5 C"^io4.in" H10 F1200:300 T18000 A10 S0.03             ; set Z probe type to switch and the dive height + speeds
M558 K1 P8 C"^io2.in" H10 F1200:300 T18000 A10 S0.03             ; set Z probe type to switch and the dive height + speeds

G31 K0 P500 X0 Y-20 Z0                         ; set Z probe trigger value, offset and trigger height
G31 K1 P500 X0 Y0 Z0                         ; set Z probe trigger value, offset and trigger height

M557 X15:295 Y10:290 S70:70                         ; define mesh grid

; Heaters
; bed
M308 S0 P"temp3" Y"thermistor" T100000 B4138 A"Bed T°C" ; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out9" T0                           ; create bed heater output on out3 and map it to sensor 0
M307 H0 B1 S1.00                             ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                      ; map heated bed to heater 0
M143 H0 S135                                 ; set temperature limit for heater 0 to 130C
M307 H0 R1.177 K0.810:0.000 D4.88 E1.35 S1 B0 ; PID tunig parameters

; hotend
M308 S1 P"temp0" Y"pt1000" A"Hotend T°C"                 ; configure sensor 1 as PT1000 on pin temp1
M950 H1 C"out1" T1                           ; create nozzle heater output on out1 and map it to sensor 1
M307 H1 B0 S1                            ; disable bang-bang mode for heater  and set PWM limit
M143 H1 S450                                 ; set temperature limit for heater 1 to 300C
M307 H1 R3.134 K0.298:0.008 D6.77 E1.35 S1.00 B0 V23.2 ; PID parameters

; drybox
; M308 S2 P"io6.out" Y"dht22" A"dbx Temp[C]"
; M308 S2 P"temp2" Y"thermistor" T100000 B4138 A"Silicon H T°C" ; configure sensor 3 as thermistor
; M950 H2 C"out7" T2                          ; create chamber heater output and map it to sensor 2
; M141 P2 H2                                            ; map chamber to heater 2
; M143 H2 S130                                       ; set temperature limit for heater 2 to 80C
; M307 H2 B1 S1; Bang bang
; M307 H2 R0.5 K0.090:0.000 D30 E1.35 S0.5 B0 ; PID Parameters

; Chamber
M308 S3 P"temp2" Y"thermistor" T100000 B4138 A"Chamber T°C" ; configure sensor 4 as thermistor
; M950 H3 C"out8" T2                          ; create chamber heater output and map it to sensor 2
; M141 H3 P1                                         ; map chamber to heater 2

; Extruder Motor Temp
M308 S4 P"temp1" Y"thermistor" T100000 B4138 A"Extruder T°C" ; configure sensor 3 as thermistor

; DHT Sensor on IO4 on Duet 3 6hc
; M308 S5 P"S2.1" Y"dhthumidity" A"drybox Hum[%]" ; s11

; Fans & Pumps
; Part Fan
; M950 F0 C"out4" Q500                         ; TOOL FAN create fan 0 on pin out4 and set its frequency
; M106 P0 S0 H-1        C"Part Fan" B1         ; set fan 0 value. Thermostatic control is turned off

; Water Pump
; 4-wire PWM fan and tacho
M950 F1 C"!out4+out4.tach" Q250 ; Fan 1 uses out5, but we are using a PWM fan so the output needs to be inverted, and using out5.tach as a tacho input
; M106 P1 S1 H1 T50    C"Water Pump"                       ; set fan 1 value. Thermostatic control is turned on
; M106 P1 S1 H-1    C"Water Pump"                       ; set fan 1 value. Thermostatic control is turned on

; 4-wire radiator PWM fan and tacho
M950 F2 C"!out5+out5.tach" Q500 ; Fan 2 uses out6, but we are using a PWM fan so the output needs to be inverted, and using out5.tach as a tacho input
M106 P2 S1 H1 T50     C"Radiator Fan"                       ; set fan 1 value. Thermostatic control is turned on

; Chamber Fan
M950 F3 C"out2" Q500                         ; CHAMBER FAN create fan 2 on pin out6 and set its frequency
M106 P3 S0 H-1            C"Chamber Fan"                ; set fan 2 value. Thermostatic control is turned off

; Drybox Fan
M950 F4 C"out3" Q500                        ; Drybox FAN create fan 2 on pin out6 and set its frequency
M106 P4 S0 H-1        C"drybox fan"         ; set fan 2 value. Thermostatic control is turned off



; Flow Meter
; M950 F5 C"out9" Q500                         ; FILTER FAN create fan 2 on pin out6 and set its frequency
; M106 P5 S0 H-1         C"Flow Meter"               ; set fan 2 value. Thermostatic control is turned off


; RGB
; Duet 3 led pin
M950 E0 C"led" T1 Q3000000   ; create a RGB Neopixel LED strip on the LED port and set SPI frequency to 3MHz
M150 E0 R255 P128 S4 F1     ; set first 20 LEDs to red, half brightness, more commands for the strip follow
M150 E0 U255 P128 S4 F1     ; set first 20 LEDs to red, half brightness, more commands for the strip follow
M150 E0 R255 P128 S4 F1     ; set first 20 LEDs to red, half brightness, more commands for the strip follow
M150 E0 U255 P128 S10 F0     ; set first 20 LEDs to red, half brightness, more commands for the strip follow

; Tools
M563 P0 D0 H1 F0                             ; define tool 0
G10 P0 X0 Y0 Z0                              ; set tool 0 axis offsets
G10 P0 R0 S0                                 ; set initial tool 0 active and standby temperatures to 0C
T0 ; Select Tool 0

; Accelerometer
; M955 P0 C"spi.cs1+spi.cs0" I50 S1344 R10 ; all wires connected to temp DB connector

; Inputshaping
M593 P"zvd" F46.0 ; use ZVD input shaping to cancel ringing at X Hz


; call macros
M98 P"/macros/z_home_high" ;home bed high (at the bottom)
M98 P"/macros/startup_homing" ;ask about homing Z - make sure bed is clear
G1 X155 Y-26 ; move tool to front center



