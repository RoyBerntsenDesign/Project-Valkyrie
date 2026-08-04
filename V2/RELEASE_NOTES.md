# Valkyrie V2 - Initial Public Release

Release date: August 2026

Valkyrie V2 is a major redesign of the original Valkyrie high-temperature CoreXY platform. The V2 architecture revises the frame, enclosure, motion system, build platform, toolhead, chamber heating, material management, electronics layout, and firmware automation.

This release separates verified prototype performance from development targets. Target values should not be interpreted as guaranteed operating specifications.

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
- Drybox heater controlled by RepRapFirmware as Chamber 2.
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
- Four internal 350 mm, 24 V LED strips.
- Primary electronics located outside the heated chamber where practical.

### Firmware and automation

- RepRapFirmware with Duet Web Control.
- Input shaping and pressure advance.
- Independent three-motor Z alignment.
- Mesh-bed compensation.
- Automated nozzle-height and Z-offset measurement.
- Automated nozzle brushing.
- Automated filament loading and unloading through the external buffer.
- Configurable print-start and print-end sequences.
- Firmware temperature limits, heating timeouts, sensor-fault handling, and automatic heater shutdown.

## Verified prototype performance

| Performance | Verified |
| --- | ---: |
| Maximum print speed | 200 mm/s |
| Maximum acceleration | 10,000 mm/s² |
| Maximum volumetric flow rate | 20 mm³/s |
| Maximum travel speed | 500 mm/s |
| Chamber heat-up | 30 min to 100 °C from 25 °C ambient |
| Drybox temperature | Up to 80 °C |

## Development targets

| Performance | Target |
| --- | ---: |
| Maximum print speed | 500 mm/s |
| Maximum acceleration | 20,000 mm/s² |
| Maximum volumetric flow rate | 30 mm³/s |
| Maximum travel speed | 1,000 mm/s |
| Active chamber temperature | Up to 120 °C |

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

- [Valkyrie V2 Technical Overview v1.0](docs/Valkyrie_V2_Technical_Overview_v1.0.pdf)

The technical overview is not an assembly manual or electrical wiring guide.

## Safety notice

Valkyrie V2 uses mains-voltage heaters, high current, high temperatures, moving machinery, and liquid cooling. Electrical installation and verification must be performed by a qualified person using components appropriate for the configured input voltage and applicable regulations.

## Credits

- **Roy Berntsen** - Project lead, primary mechanical designer, and system integrator.
- **Mark Bridgewater** - Design, electronics, firmware, testing, and documentation.
- **Chris Lombardi** - ESP32 firmware.

Acknowledgements: RepRapFirmware, Duet Web Control, and Duet3D.

## Licensing

Valkyrie V2 copyright 2026 Roy Berntsen and contributors.

Unless otherwise stated, the documentation and original project media are licensed under [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/). Hardware design files and software/firmware are subject to the licence notices distributed with those files. Third-party materials remain subject to their respective licences.
