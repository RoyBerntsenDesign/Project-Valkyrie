; wait_chamber_min.g
; Wait for chamber to reach minimum temperature
; without changing the chamber target

if param.S > 0

    while heat.heaters[2].current < param.S
        G4 S1