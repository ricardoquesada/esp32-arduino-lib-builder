# ESP32 Arduino Lib Builder [![ESP32 Arduino Libs CI](https://github.com/espressif/esp32-arduino-lib-builder/actions/workflows/push.yml/badge.svg)](https://github.com/espressif/esp32-arduino-lib-builder/actions/workflows/push.yml)

This repository contains the scripts that produce the libraries included with esp32-arduino.

Tested on Ubuntu (32 and 64 bit), Raspberry Pi and MacOS.

### Build on Ubuntu and Raspberry Pi
Execute the quickSetupAws.sh script

#### When ESP32 releases a new version

1. Delete the components/arduino directory
2. Update AR_BRANCH in tools/config.sh, or pass it in as the -A options of the build script
3. Run build.sh


### Release

1. Create a branch with the name of the version you want (i.e "1.0.0" or "release/1.0.0" - both will end up with a release called "1.0.0")
2. Check out that branch on your dev box
3. Run the tools/phasedock-release.sh script and enter your login credentials.
