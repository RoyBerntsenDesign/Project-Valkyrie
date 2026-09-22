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


;~~~~~ pause/resume globals ~~~~~
if !exists(global.pauseFan0Speed)
    global pauseFan0Speed = 0