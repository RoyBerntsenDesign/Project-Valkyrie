beta verson of logging serive interval and total print time

Place these files into the sys directory 
logPrintTime.g
logPrintTimeTotal.txt
logTotalRunningTime.txt

Place this file in the macros directory
showPrintTime.g

Open the file "place these in the config.txt", copy the code, paste it at the end of the config.g file.
   
If you run the " showPrintTime.g'  it will show you hours minutes and seconds in the console,


BtnCmd users. You can add a panel, see picture "btnCnd.jpg"
Create a Panel, the type is "Object Model Value"

Model Value Prefix	Printing hours
Model Path		global.cumulativeTime
OM Value Expression	round(##VALUE##/3600,1)
