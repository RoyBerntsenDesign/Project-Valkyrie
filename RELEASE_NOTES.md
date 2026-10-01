# Valkyrie V2.0.0-rc.1 - Release Candidate 1

Release date: October 2026

Valkyrie V2.0.0-rc.1 is the first release candidate for the V2 platform. It builds on the V2.0.0 beta releases with additional firmware safety monitoring, improved fault recovery, revised print-start heating behaviour, documentation cleanup, and release-structure improvements.

Recommended operating values are separated from verified prototype results. Verified values represent demonstrated results on the Valkyrie V2 reference machine and should not be interpreted as required operating settings for every build.

## Changes since V2.0.0-beta.2

### Firmware safety and fault recovery

- Added tachometer monitoring for the main chamber circulation fan, drybox fan, and water-cooling pump.
- The chamber heater is automatically shut down if chamber-fan RPM remains below the configured safety threshold for two consecutive daemon cycles.
- The drybox heater is automatically shut down if drybox-fan RPM remains below the configured safety threshold for two consecutive daemon cycles.
- Water-pump monitoring becomes active once the hotend exceeds 60 °C.
- A confirmed water-pump fault during a print automatically pauses the print and shuts down the hotend heater.
- Pump-fault resume handling verifies pump RPM before reheating, restores the saved hotend temperature, waits for the hotend to recover, performs a final pump check, and only then resumes the print.
- Stop and cancel handling clears stored water-pump fault and recovery state.
- Chamber and drybox fan monitoring retain independent firmware fault handling in addition to the machine's physical thermal protection.

### Print-start and thermal behaviour

- Added a minimum-chamber-temperature wait routine for print start.
- Bed and chamber heating can now begin before the hotend is heated, reducing unnecessary hotend dwell time during long chamber preheats.
- Hotend firmware temperature limit aligned with the 500 °C rated Valkyrie hotend configuration.

### Repository and documentation

- Firmware files are organised directly under `Firmware Files/sys`, `Firmware Files/macros`, and `Firmware Files/filaments`.
- Removed obsolete SD-card-folder references and stale backup/archive files from the public `sys` and `macros` structure.
- Documentation now distinguishes recommended operating values from verified prototype performance.
- Corrected RepRapFirmware chamber numbering: the heated chamber is Chamber 0 and the drybox is Chamber 1.

### Hardware files and drawings

- Updated the Valkyrie V2 build guide/BOM.
- Updated the Z idler tower A/B printable parts.
- Updated the Z-probe docking part.
- Updated the Duet cover printable part.
- Updated the LED Front Buddy printable part and added the corresponding LED Buddy drawing.
- Removed duplicate Tool Sensor and Tool Sensor Probe STL files.

### Licensing

- V2.0.0-rc.1 marks the transition of Project Valkyrie to an open-source/open-hardware licensing structure.
- Hardware design files are licensed under CERN-OHL-S-2.0.
- Original Valkyrie firmware, macros, and configuration are licensed under GPL-3.0-or-later.
- Original documentation and project media are licensed under CC-BY-4.0.
- Earlier tagged releases remain under the licence terms under which they were originally published.

## Release highlights

### Frame and enclosure

- Increased frame rigidity using M6 blind joints.
- Relocated upper rear extrusion for improved sealing, panel installation, cable routing, and service access.
- Added centre-rear Z extrusion for additional stiffness and support.
- Revised top-frame structure for top-mounted linear rails.
- Redesigned overhead door that lifts vertically instead of swinging outward.
- New reinforced door brackets, 625ZZ pivot bearings, shoulder bolts, and linked side mechanisms.
- Improved separation between the heated chamber and temperature-sensitive components.

### CoreXY motion system

- External 2.5 A NEMA 17 long-shaft A/B motors with upper shaft supports.
- Drive pulley reduction from 20T to 16T GT2.
- F606ZZ flanged CoreXY idlers.
- High-temperature all-metal MGN12 linear rails.
- Redesigned A/B and Y motion components for improved rigidity, belt alignment, and serviceability.

### Z motion system

- Three independently driven Z motors.
- Z reduction increased from 4:1 to 5:1 using 16T GT2 pulleys.
- New top-mounted Z idler brackets.
- Redesigned Z carriers and belt-clamping interfaces.
- Automatic three-point Z alignment through independent motor control.

### Build platform and calibration

- 350 × 350 × 8 mm cast aluminium 5083 bed plate.
- 330 × 330 mm removable build sheet.
- Three-point Maxwell kinematic mounting system using 10 mm bearing balls.
- Integrated SmCo build-sheet retention magnets.
- Locating pins for repeatable build-sheet positioning.
- Revised bed wiring, strain relief, and integrated thermal fuse.
- Bed-mounted nozzle and Z-offset reference sensor.
- Automatic Z-offset measurement, nozzle-height calibration, and mesh-bed compensation.

### Toolhead

- Water-cooled BTT V2X extruder with 7:1 gearing and 73.5 N (7.5 kgf) rated extrusion force.
- Custom water-cooled Valkyrie hotend rated for nozzle temperatures up to 500 °C.
- Integrated toolplate mounting interface.
- Revised toolhead cable chimney and side cable channel.
- SmCo magnetic probe system and docking station.
- Integrated nozzle-brushing station.

### Thermal management

- Closed-loop toolhead cooling using a P67D pump, reservoir, and external 120 mm radiator.
- 750 W PTC chamber heater positioned at the rear of the build chamber.
- 750 W heated bed used as a secondary chamber heat source.
- 120 CFM chamber-air recirculation fan.
- Nozzle-level chamber-temperature sensing.
- Independent 150 °C thermal switch and firmware heater limits.
- External ROBO part-cooling blower that recirculates heated chamber air through a CPAP hose and toolhead duct.

### Material management

- Integrated drybox with a 300 W PTC heater.
- Drybox heater controlled by RepRapFirmware as Chamber 1.
- Drybox operation up to 80 °C.
- Integrated desiccant container.
- ESP32 monitoring of a DHT22 temperature/humidity sensor and filament load cell.
- 625ZZ-bearing filament carousel.
- External filament buffer with automatic filament loading and unloading.

### Electronics and controls

- Duet 3 6HC controller with all six onboard stepper-driver channels in use.
- No Duet expansion board or CAN-connected toolhead electronics.
- Primary 24 V, 350 W power supply and secondary 12 V supply.
- TS35 DIN-rail mains and 12 V distribution.
- Three 24 V-controlled solid-state relays for the bed, chamber, and drybox heaters.
- GX20 toolhead interfaces positioned outside the heated chamber.
- High-temperature HDC chamber interfaces.
- Three internal 350 mm, 24 V LED strips.
- Primary electronics located outside the heated chamber where practical.

### Firmware and automation

- RepRapFirmware with Duet Web Control.
- Tested Valkyrie V2 `sys`, `macros`, and `filaments` configuration supplied in the repository.
- Input shaping measured and configured on the reference machine.
- Pressure advance support.
- Independent three-motor Z alignment.
- Mesh-bed compensation.
- Automated probe pickup and return.
- Automated nozzle-height and Z-offset measurement.
- Automated nozzle brushing.
- Material-specific filament loading and unloading through Duet Web Control and the external filament buffer.
- Tested print-start, pause/resume, cancel, and normal print-finish workflows.
- Chamber temperature ramping for controlled heat-up.
- Delayed hotend heating until the configured minimum chamber temperature is reached.
- Chamber recirculation-fan tach monitoring with automatic chamber-heater shutdown on fan fault.
- Drybox-fan tach monitoring with automatic drybox-heater shutdown on fan fault.
- Water-pump tach monitoring with automatic print pause and hotend-heater shutdown on cooling fault.
- Pump-fault recovery sequence that verifies cooling before reheating and resuming.
- Firmware temperature limits, heating timeouts, sensor-fault handling, and automatic heater shutdown.

The RC.1 firmware configuration is based on the tested reference machine. Machine-specific values such as input shaping, probe offsets, filament profiles, and other tuning parameters may require adjustment on individual builds.

## Recommended and verified performance

| Performance | Recommended | Verified |
| --- | ---: | ---: |
| Print speed | Up to 500 mm/s | 1,000 mm/s |
| Acceleration | Up to 10,000 mm/s² | 10,000 mm/s² |
| Volumetric flow rate | Material-dependent | 45 mm³/s |
| Chamber temperature | Material-dependent, up to 110 °C | 110 °C sustained for 60 min |
| Drybox temperature | Material-dependent, up to 80 °C | 80 °C |
| Maximum travel speed | Up to 500 mm/s | 1,000 mm/s |
| Chamber heat-up | — | 30 min to 100 °C from 25 °C ambient |

Recommended values are intended as practical operating limits for the Valkyrie V2 reference configuration. Actual print settings depend on material, nozzle size, layer height, toolhead configuration, cooling, firmware tuning, and operating temperature.

Verified values represent results demonstrated on the Valkyrie V2 reference machine.

## Electrical configurations

The standard configuration uses 220-240 VAC and a 10 A mains fuse. An optional 110-120 VAC configuration requires appropriately rated heaters, power supplies, switching devices, wiring, connectors, and circuit protection.

The 110-120 VAC option is not a direct component-for-component conversion of the standard configuration.

## Validation status

The following materials have been validated on the current prototype:

- PLA
- PETG
- ABS
- ASA
- PA and PA-CF
- PC, PC-CF, and PC blend CF
- PPS, PPS-CF, and PPS-GF

PSU, PPSU, PEI (Ultem), and PEKK remain to be verified.

## Documentation

- [Valkyrie V2 Technical Overview v1.1](docs/Valkyrie_V2_Technical_Overview_v1.1.pdf)
- [Valkyrie V2 Firmware Files](Firmware%20Files)
- [Valkyrie Firmware Upgrade Guide](https://docs.google.com/document/d/1ZG3JhbeEWcIs_WRdMjnoR0Aa20OJ4TtpdeJnv2xmSmU/edit?usp=sharing)

The technical overview is not an assembly manual or electrical wiring guide.

## Safety notice

Valkyrie V2 uses mains-voltage heaters, high current, high temperatures, moving machinery, and liquid cooling. Electrical installation and verification must be performed by a qualified person using components appropriate for the configured input voltage and applicable regulations.

## Credits

- **Roy Berntsen** - Project lead, primary mechanical designer, and system integrator.
- **Mark Bridgewater** - Design, electronics, firmware, testing, and documentation.
- **Chris Lombardi** - ESP32 firmware.

Acknowledgements: RepRapFirmware, Duet Web Control, Duet3D, and BIQU.

## Licensing

Beginning with V2.0.0-rc.1:

- hardware design files are licensed under **CERN-OHL-S-2.0**
- original Valkyrie firmware, macros, and configuration are licensed under **GPL-3.0-or-later**
- original documentation and project media are licensed under **CC-BY-4.0**

Earlier tagged releases remain under their original licence terms. See [License.md](License.md) for the complete project licensing structure.
