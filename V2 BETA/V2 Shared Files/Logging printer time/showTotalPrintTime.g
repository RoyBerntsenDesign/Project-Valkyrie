; ===== Show Total Accumulated Print Time =====
;M98 P"/sys/getTotalPrintTime.g"
if fileexists("0:/sys/logPrintTimeTotal.txt")
    var myvalue = fileread("0:/sys/logPrintTimeTotal.txt",0,12,',')
    echo var.myvalue[0]
    var totalTime = var.myvalue[0]
    set global.cumulativeTime = var.totalTime
    ; Calculate H:M:S from total print seconds
    var totalSec = var.totalTime
    var hours = floor(var.totalSec / 3600)
    var minutes = floor(mod(var.totalSec, 3600) / 60)
    var seconds = mod(var.totalSec, 60)
    ; Echo the result to the console
    echo "Total Print Time: " ^ var.hours ^ "h " ^ var.minutes ^ "m " ^ var.seconds ^ "s"