; probe_sensor_check.g
; verifies that nozzle probe K1 is clear before continuing

while true

    if sensors.probes[1].value[0] == 0
        break                                           ; K1 is clear

    M291 P"Probe K1 is stuck! Clear the probe and press OK to retry, or Cancel to abort." R"Probe Error" S3

echo "Success: K1 verified clear. Continuing print..."