# Valkyrie V2 – RepRapFirmware SD Card Files

These files contain the Valkyrie V2 RepRapFirmware configuration used on the reference machine.

The supplied `sys`, `macros` and `filaments` folders should be used as the basis for the Valkyrie V2 firmware setup.

## Included folders

- `sys`  
  Main RepRapFirmware configuration files, homing files, daemon logic, pause/resume, stop/cancel and other system files.

- `macros`  
  Valkyrie-specific macros for probing, nozzle handling, Z-offset calibration, chamber control and other printer functions.

- `filaments`  
  Material-specific filament configuration, load and unload files.

## Installation

1. Back up the existing SD card before making any changes.
2. Download the Valkyrie V2 firmware files from this repository.
3. Copy the supplied `sys`, `macros` and `filaments` folders to the Duet SD card.
4. Follow the Valkyrie firmware upgrade guide when updating RepRapFirmware or Duet firmware.
5. Restart the controller.
6. Verify the machine configuration before enabling heaters or motion.

## Firmware Upgrade Guide

For RepRapFirmware and Duet firmware upgrade procedures, use the Valkyrie firmware upgrade documentation:

[Valkyrie Firmware Upgrade Guide](https://docs.google.com/document/d/1ZG3JhbeEWcIs_WRdMjnoR0Aa20OJ4TtpdeJnv2xmSmU/edit?usp=sharing)

## Important

These files are configured specifically for the Valkyrie V2 hardware.

Before operating the machine, verify:

- motor directions
- axis limits
- sensorless homing behaviour
- heater and thermistor assignments
- fan assignments
- probe inputs
- Z-probe offsets
- mains-powered heater control
- chamber safety systems

## Input Shaping

The included input-shaping configuration was measured on the Valkyrie V2 reference machine.

Another build may have different resonance characteristics due to differences in:

- frame assembly
- belt tension
- toolhead mass
- component tolerances
- mounting
- modifications

Input shaping should therefore be measured and tuned on each machine where possible.

## Filament Profiles

The supplied filament profiles are based on the materials and settings used on the Valkyrie V2 reference machine.

Temperatures, purge lengths, drybox temperatures and other material-specific settings may need adjustment for different filament brands and formulations.

## Safety

Valkyrie is a DIY high-temperature 3D printer and includes mains-voltage heaters.

Make sure all wiring, grounding, fusing, thermal protection and heater configuration are checked before operating the machine.

Do not rely on firmware as the only safety system.