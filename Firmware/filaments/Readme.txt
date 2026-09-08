History
8/08/26  added spool weight to config file  to load on printer start up , also need to add the line below into the config file.
M98 P{"0:/Filaments/" ^ move.extruders[0].filament ^ "/config.g"}  ; will autoload the spool weight in the filament config.g file whe printer restarts