; globals.g
; defines global variables used by Valkyrie macros

;~~~~~ logging globals ~~~~~

if !exists(global.logCounter)
    global logCounter = 0

if !exists(global.start_uptime)
    global start_uptime = 0


;~~~~~ spool / filament globals ~~~~~

if !exists(global.spoolWeight)
    global spoolWeight = 0

if !exists(global.filamentWeight)
    global filamentWeight = 0


;~~~~~ chamber fan safety global ~~~~~

if !exists(global.chamberFanFaultCounter)
    global chamberFanFaultCounter = 0
	
;~~~~~ drybox fan safety global ~~~~~

if !exists(global.dryboxFanFaultCounter)
    global dryboxFanFaultCounter = 0

;~~~~~ chamber ramp globals ~~~~~

; if !exists(global.chamberRampActive)
    ; global chamberRampActive = false

; if !exists(global.chamberSavedBedTarget)
    ; global chamberSavedBedTarget = 0

;~~~~~ pause/resume globals ~~~~~

if !exists(global.pauseFan0Speed)
    global pauseFan0Speed = 0

;~~~~~ water pump safety globals ~~~~~

if !exists(global.waterPumpFaultCounter)
    global waterPumpFaultCounter = 0

if !exists(global.waterPumpFault)
    global waterPumpFault = false

if !exists(global.waterPumpSavedActiveTemp)
    global waterPumpSavedActiveTemp = 0.0

if !exists(global.waterPumpSavedStandbyTemp)
    global waterPumpSavedStandbyTemp = 0.0