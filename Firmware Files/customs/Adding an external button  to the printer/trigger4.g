;place  the lines from 5 to 9 in to the config  section  for external triggers



; External button
;External Buttons
M950 J1 C"PG15"                                                    ; config input pin	switch NO  connected to io and Gnd 
M581 P1 T4 C0                                                      ; T0 = emergency stop on trigger; T1 = pause print; T{N} = runs the macro "sys/trigger{N}.g", rising edge S1 falling edge S0
M582 T0 T4                                                         ; Check External Trigger






;delete this line and above  befor using~~~~~~~~~~~~~~~~~~~~~~~ 


; " Check if the printer is currently idle before attempting to print again"
var repeat_last_print = true                                 ; set to true to active feature
    if var.repeat_last_print
        if state.status != "printing"  || " processing" || " busy"                       ; checking if there is a previous file name
            if job.lastFileName != ""                        ; if there is a print file name  start the file again
                echo "Starting print again..."
                echo job.lastFileName 
                var lastFile = job.lastFileName
                echo var.lastFile
                M32 {job.lastFileName} 
            else
               echo "Error: No previous print job found."    ;  warning no print file name
        else
            echo "Print again ignored, Printer is not idle." ; Printer is active  so not possible to print again