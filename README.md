# ESP32 Arduino Lib Builder [![ESP32 Arduino Libs CI](https://github.com/espressif/esp32-arduino-lib-builder/actions/workflows/push.yml/badge.svg)](https://github.com/espressif/esp32-arduino-lib-builder/actions/workflows/push.yml)

This repository contains the scripts that produce the libraries included with esp32-arduino.

Tested on Ubuntu (32 and 64 bit), Raspberry Pi and MacOS.

### Build on Ubuntu and Raspberry Pi
```bash
sudo apt-get install git wget curl libssl-dev libncurses-dev flex bison gperf python python-pip python-setuptools python-serial python-click python-cryptography python-future python-pyparsing python-pyelftools cmake ninja-build ccache jq
sudo pip install --upgrade pip
git clone https://github.com/espressif/esp32-arduino-lib-builder
cd esp32-arduino-lib-builder
./build.sh

### Build for Bluepad32

Copy Bluepad32 componetns.

```sh
cp -r ~/esp-idf-arduino-bluepad32-template/components/* .
```

Build it

```sh
# All targets. esp32-s2 already removed from the supported boards
./build.sh -s
```

Update:

```sh
# Already patched to copy to ~/Arduino/hardware/retro.moe/esp32-bluepad32
. ./tools/copy-to-arduino.sh
```

#### When ESP32 releases a new version

1. Download the .zip
2. Unzip it in ~/Arduino/hardware/retro.moe/...
3. rename it to esp32-bluepad32
4. create `package` folder: `mkdir esp32-bluepad32/package`

And repeat previous steps.

### Release

1. Copy `bluepad32_files/boards.txt` and `bluepad32_files/platform.txt` to `~/Arduino/hardware/retro.moe/esp32-bluepad32`
2. Upload .zip to https://github.com/ricardoquesada/esp32-arduino-lib-builder
3. Update `bluepad32_files/package_esp32_bluepad32_index.json` accordingly
