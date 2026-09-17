# Valkyrie V2 – RepRapFirmware SD Card Files

These files contain the Valkyrie V2-specific RepRapFirmware configuration.

This is **not a complete Duet SD card image**.

Start with a normal/current RepRapFirmware SD card installation, then copy the Valkyrie folders onto the card.

## Included folders

- `sys`  
  Main RepRapFirmware configuration files, homing files, daemon logic, pause/resume, stop/cancel and other system files.

- `macros`  
  Valkyrie-specific macros for probing, nozzle handling, Z-offset calibration, chamber control and other printer functions.

- `filaments`  
  Filament profiles with material-specific load, unload and configuration files.

## Installation

1. Back up the existing SD card before making any changes.
2. Install a normal/current RepRapFirmware SD card structure.
3. Copy the Valkyrie `sys`, `macros` and `filaments` folders to the SD card.
4. Restart the controller.
5. Check the configuration carefully before enabling heaters or motion.

## Important

These files are configured for the Valkyrie V2 hardware and should not be used unchanged on another printer.

Before operating the machine, verify:

- motor directions
- axis limits
- endstop / StallGuard behaviour
- heater and thermistor assignments
- fan assignments
- probe inputs
- Z-probe offsets
- mains-powered heater control
- chamber safety systems

## Input Shaping

The included input-shaping configuration was measured on the reference Valkyrie V2 build.

Another build may have different resonance characteristics due to differences in:

- frame assembly
- belt tension
- toolhead mass
- component tolerances
- mounting
- modifications

Input shaping should therefore be measured and tuned on each machine where possible.

## Filament Profiles

The supplied filament profiles are examples based on the materials used on the Valkyrie development machine.

Temperatures, purge lengths, drybox temperatures and other material-specific settings may need adjustment for different filament brands and formulations.

## Safety

Valkyrie is a DIY high-temperature 3D printer and includes mains-voltage heaters.

Make sure all wiring, grounding, fusing, thermal protection and heater configuration are checked before operating the machine.

Do not rely on firmware as the only safety system.