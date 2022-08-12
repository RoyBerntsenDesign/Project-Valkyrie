[![license-badge][]][license] ![version] [![stars][]][stargazers] ![hit-count] [![github-issues][]][issues]

# Aosong ASAIR AHT1x/AHT2x

This is an Arduino library for _Aosong ASAIR_ AHT10/AHT15/AHT20/AHT21/AHT25/AM2301**B**/AM2311**B** Digital Humidity & Temperature Sensor

- AHT1x +1.8v..+3.6v, AHT2x +2.2v..+5.5v
- AHT1x 0.25μA..320μA, AHT2x 0.25μA..980μA
- temperature range -40°C..+85°C
- humidity range 0%..100%
- typical accuracy T ±0.3°C, RH ±2% **(1)**
- typical resolution T 0.01°C, RH 0.024%
- normal operating range T -20°C..+60°C, RH 10%..80%
- maximum operating rage T -40°C..+80°C, RH 0%..100%
- I²C bus speed 100KHz..400KHz, 10KHz recommended minimum
- recommended measurement frequency 8sec..30sec **(2)**
- recommended to route VDD or GND between I²C lines to reduce crosstalk between SCL & SDA
- power supply pins must be decoupled with 100nF capacitor

Supports all sensors features:
- read humidity **(3)**
- read temperature **(3)**
- soft reset with sensor initialization
- CRC calculation for AHT2x **(3)**

Tested on:
- Arduino AVR
- Arduino ESP8266
- Arduino ESP32
- Arduino STM32

**(1)** Prolonged exposure for 60 hours at humidity > 80% can lead to a temporary drift of the signal +3%. Sensor slowly returns to the calibrated state at normal operating conditions.<br>
**(2)** High frequency measurement causes the sensor to heat up, the interval must be greater than 1 second to keep self-heating below 0.1°C.<br>
**(3)** Library returns 255 if a communication error occurs, calibration coefficient is off or CRC doesn't match (for AHT2x only).

[license-badge]: https://img.shields.io/badge/License-GPLv3-blue.svg
[license]:       https://choosealicense.com/licenses/gpl-3.0/
[version]:       https://img.shields.io/badge/Version-1.1.6-green.svg
[stars]:         https://img.shields.io/github/stars/enjoyneering/AHTxx.svg
[stargazers]:    https://github.com/enjoyneering/AHTxx/stargazers
[hit-count]:     https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fenjoyneering%2FAHTxx&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false
[github-issues]: https://img.shields.io/github/issues/enjoyneering/AHTxx.svg
[issues]:        https://github.com/enjoyneering/AHTxx/issues/
