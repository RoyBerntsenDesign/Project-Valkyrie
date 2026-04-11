; ===== Accumulative Print Time Logger =====
echo "end.g"
; Read stored time
if fileexists("0:/sys/logPrintTimeTotal.txt")
    var myvalue = fileread("0:/sys/logPrintTimeTotal.txt",0,12,',') 
    var oldTotal = var.myvalue[0]
    echo "service interval" ^ global.serviceInterval
    echo "old Total" ^ var.oldTotal
    ;checking to see if service interval ha been reached 
    if var.oldTotal > global.serviceInterval
        echo "service required"
        M291 R"1000 Hour Service Required" P"Do you want to continue and reset service interval" S4 T10 J2 K{"Yes", "Just continue"} F5
    if input = 0
        echo  "rest and continue"
        echo >"0:/sys/logPrintTimeTotal.txt" "0"
        echo >>"0:/sys/logTotalRunningTime.txt" "" ^ global.serviceInterval
    elif input = 1
        echo "just continue"
    elif input = -1 
        echo "no selection pressed"  ;G29 S1 ; load previous height map 
        echo input
    echo "Old Total: " ^ var.oldTotal
     ;Calculate new total
    echo "Job Duration: " ^ job.duration
    var newTotal = job.duration + var.oldTotal
    echo "New Total: " ^ var.newTotal
    set global.cumulativeTime = var.newTotal
    ;Save new total (Overwriting the file with '>' so it stays one line)
    echo >"0:/sys/logPrintTimeTotal.txt" var.newTotal
    ; Calculate H:M:S from total print seconds
    var totalSec = var.newTotal
    var hours = floor(var.totalSec / 3600)
    var minutes = floor(mod(var.totalSec, 3600) / 60)
    var seconds = mod(var.totalSec, 60)
    ; Echo the result to the console
    echo "Total Print Time: " ^ var.hours ^ "h " ^ var.minutes ^ "m " ^ var.seconds ^ "s"
else
    ; Create the file if it doesn't exist so it works next time
    echo >"0:/sys/logPrintTimeTotal.txt" "0"
    echo "Log file created. Please run again."    

