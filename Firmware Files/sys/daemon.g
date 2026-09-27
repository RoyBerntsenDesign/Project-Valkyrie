; daemon.g
; Runs repeatedly to update background functions and safety checks
;
; RepRapFirmware restarts daemon.g approximately every 10 seconds.
;
; Safety monitoring:
;
;   Main chamber heater = heater 2 / Chamber 0
;   Main chamber fan    = fan 1
;   Chamber fan normal speed approximately 5300 RPM
;   Chamber fan fault threshold = 2000 RPM
;
;   Drybox heater       = heater 3 / Chamber 1
;   Drybox fan          = fan 2
;   Drybox fan normal speed approximately 6500 RPM
;   Drybox fan fault threshold = 2000 RPM
;
;   Hotend heater       = heater 1 / Tool 0
;   Water pump          = fan 4
;   Pump idle speed     approximately 1200 RPM
;   Pump running speed  approximately 3200 RPM
;   Pump fault threshold = 2000 RPM
;
; Fan and pump faults must be detected on two consecutive daemon cycles
; before the associated heater is shut down.


; ---------------------------------------------------------------------------
; Logging
; ---------------------------------------------------------------------------

M98 P"/macros/logfile.g"       ; log chamber temperature and heater PWM


; ---------------------------------------------------------------------------
; Main chamber fan control and safety
; ---------------------------------------------------------------------------

; Run the chamber circulation fan whenever chamber heating is requested.
;
; The chamber ramp system may use both active and standby temperature
; targets, so both are checked here.
;
; If chamber fan RPM remains below 2000 RPM for two consecutive
; daemon cycles, the chamber heater is shut down.
;
; After a fault, chamber_ramp.g may continue commanding the fan ON
; while the chamber is above 40C for cooldown.

if heat.heaters[2].active > 0 || heat.heaters[2].standby > 0

    M106 P1 S1                 ; run chamber circulation fan at full speed

    if fans[1].rpm < 2000

        set global.chamberFanFaultCounter = global.chamberFanFaultCounter + 1

        ; Two consecutive low-RPM readings = chamber fan fault
        if global.chamberFanFaultCounter >= 2

            M141 P0 S-273.1 R0 ; disable chamber heater and clear ramp target

            M117 CHAMBER FAN FAULT - HEATER OFF

            echo "SAFETY: Chamber heater shut down - chamber fan RPM too low: " ^ fans[1].rpm ^ " RPM"

            set global.chamberFanFaultCounter = 0

    else

        ; Chamber fan RPM is normal
        set global.chamberFanFaultCounter = 0

else

    ; No chamber heating requested
    M106 P1 S0
    set global.chamberFanFaultCounter = 0


; ---------------------------------------------------------------------------
; Chamber temperature control
; ---------------------------------------------------------------------------

M98 P"/macros/chamber_ramp.g"  ; update chamber temperature ramp


; ---------------------------------------------------------------------------
; Drybox fan control and safety
; ---------------------------------------------------------------------------

; Run the drybox fan whenever heater 3 is active.
;
; Normal drybox fan speed is approximately 6500 RPM.
; Below 2000 RPM is considered abnormal.
;
; Two consecutive low-RPM readings are required before shutdown.
; At the current daemon interval this corresponds to approximately
; 10-20 seconds of persistent low RPM.
;
; The drybox heater also has an independent thermal fuse.

if heat.heaters[3].state == "active"

    M106 P2 S1                 ; run drybox fan at full speed

    if fans[2].rpm < 2000

        set global.dryboxFanFaultCounter = global.dryboxFanFaultCounter + 1

        ; Two consecutive low-RPM readings = drybox fan fault
        if global.dryboxFanFaultCounter >= 2

            M141 P1 S-273.1 R-273.1  ; disable drybox heater
            M106 P2 S0               ; stop drybox fan after fault shutdown
            
            M117 DRYBOX FAN FAULT - HEATER OFF

            echo "SAFETY: Drybox heater shut down - drybox fan RPM too low: " ^ fans[2].rpm ^ " RPM"

            set global.dryboxFanFaultCounter = 0

    else

        ; Drybox fan RPM is normal
        set global.dryboxFanFaultCounter = 0

else

    ; Drybox heater is not active
    M106 P2 S0
    set global.dryboxFanFaultCounter = 0

; ---------------------------------------------------------------------------
; Water pump / hotend cooling safety
; ---------------------------------------------------------------------------

; Water pump is fan 4 and is thermostatically controlled from hotend heater 1.
; Pump starts running at full speed above 50C.
;
; Pump speed:
;   Idle/minimum: approximately 1200 RPM
;   Normal running: approximately 3200-3800 RPM
;
; Monitoring begins above 60C to allow the pump time to reach full speed.
;
; Below 2000 RPM while the hotend is above 60C is considered a pump fault.
; Two consecutive low-RPM readings are required before triggering the fault.
;
; Once a pump fault is latched, daemon.g will not trigger the same
; fault again while the print is paused. resume.g clears the latch
; after the pump has been verified and the hotend has reheated.


if !global.waterPumpFault

    if heat.heaters[1].current > 60

        if fans[4].rpm < 2000

            set global.waterPumpFaultCounter = global.waterPumpFaultCounter + 1

            ; Two consecutive low-RPM readings = confirmed pump fault
            if global.waterPumpFaultCounter >= 2

                echo "SAFETY: Water pump RPM too low: " ^ fans[4].rpm ^ " RPM"

                ; If a print is running, save the current tool temperatures
                ; and latch the pump fault before pausing
                if state.status == "processing"

                    set global.waterPumpSavedActiveTemp = heat.heaters[1].active
                    set global.waterPumpSavedStandbyTemp = heat.heaters[1].standby
                    set global.waterPumpFault = true

                    M25

                ; Turn hotend heater off after pause state has been saved
                M568 P0 S0 R0 A0

                ; Display warning in DWC
                M117 WATER PUMP FAULT - CHECK COOLING

                echo "SAFETY: Hotend heater shut down"

                set global.waterPumpFaultCounter = 0

        else

            ; Pump RPM is normal
            set global.waterPumpFaultCounter = 0

    else

        ; Hotend is below pump monitoring temperature
        set global.waterPumpFaultCounter = 0