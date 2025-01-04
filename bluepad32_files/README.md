## Build for Bluepad32

Copy Bluepad32 components.

```sh
cd components
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

1. Download the .zip from: https://github.com/espressif/arduino-esp32/releases
2. Unzip it in ~/Arduino/hardware/retro.moe/...
3. rename it to esp32-bluepad32
4. create `package` folder: `mkdir esp32-bluepad32/package`
5. copy `boards.txt` from the downloaded file to `bluepad32_files`
6. Manually remove all esp32s2 boards from `bluepad32_files/boards.txt`

And repeat the previous steps.

### Release

1. Copy `bluepad32_files/boards.txt` and `bluepad32_files/platform.txt` to `~/Arduino/hardware/retro.moe/esp32-bluepad32`
2. Copy `bluepad32_files/libraries/` to `~/Arduino/hardware/retro.moe/esp32-bluepad32/libraries/`
3. Upload .zip to https://github.com/ricardoquesada/esp32-arduino-lib-builder
4. Update `bluepad32_files/package_esp32_bluepad32_index.json` accordingly.
   Update `package_esp32_bluepad32_index.json` in `master` branch as well.


```sh
cp bluepad32_files/boards.txt bluepad32_files/platform.txt bluepad32_files/package.json ~/Arduino/hardware/retro.moe/esp32-bluepad32
cp -r bluepad32_files/libraries/* ~/Arduino/hardware/retro.moe/esp32-bluepad32/libraries/
```

### Test from CLI

```sh
arduino-cli compile --fqbn retro.moe:esp32-bluepad32:esp32thing --log --verbose
```

### Build (test)

```
./build.sh -s -t esp32,esp32s3,esp32c3,esp32c6,esp32h2 -D default -c ~/Arduino/hardware/espressif/esp32 -A idf-release/v5.3 -I release/v5.3 -e
```
