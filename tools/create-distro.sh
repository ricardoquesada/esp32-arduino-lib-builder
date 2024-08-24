#!/bin/bash
source ./tools/config.sh

# set up arduino distro
mkdir -p $DIST_PATH
rm -rf $DIST_PATH/*
wget https://github.com/espressif/arduino-esp32/releases/download/$AR_BRANCH/esp32-$AR_BRANCH.zip
unzip esp32-$AR_BRANCH.zip -d $DIST_PATH
mv $DIST_PATH/esp32-$AR_BRANCH $DIST_PATH/$DIST_NAME
mkdir $DIST_PATH/$DIST_NAME/package

ESP32_ARDUINO="$DIST_PATH/$DIST_NAME"

if ! [ -d "$ESP32_ARDUINO" ]; then
	echo "ERROR: Target arduino distro folder does not exist!"
	exit 1
fi

echo "Installing new libraries to $ESP32_ARDUINO"

rm -rf $ESP32_ARDUINO/tools/sdk $ESP32_ARDUINO/tools/gen_esp32part.py $ESP32_ARDUINO/tools/platformio-build-*.py $ESP32_ARDUINO/platform.txt

cp -f $AR_OUT/platform.txt $ESP32_ARDUINO/
cp -f $AR_OUT/package_esp32_index.template.json $ESP32_ARDUINO/package/package_esp32_index.template.json
cp -Rf $AR_TOOLS/sdk $ESP32_ARDUINO/tools/
cp -f $AR_TOOLS/gen_esp32part.py $ESP32_ARDUINO/tools/
cp -f $AR_TOOLS/platformio-build-*.py $ESP32_ARDUINO/tools/

cp bluepad32_files/platform.txt bluepad32_files/package.json $DIST_PATH/$DIST_NAME
cat bluepad32_files/boards.txt | grep -v esp32s2 > $DIST_PATH/$DIST_NAME/boards.txt
cp -r bluepad32_files/libraries/* $DIST_PATH/$DIST_NAME/libraries/
cp -rn components/arduino/tools/sdk/esp32/include/* $DIST_PATH/$DIST_NAME/tools/sdk/esp32/include/
cp -rn components/arduino/tools/sdk/esp32/lib/* $DIST_PATH/$DIST_NAME/tools/sdk/esp32/lib/
cp -r components/arduino/libraries/* $DIST_PATH/$DIST_NAME/libraries/
cp -r phasedock_files/libraries/* $DIST_PATH/$DIST_NAME/libraries/
cd $DIST_PATH
zip -r $DIST_NAME.zip $DIST_NAME
sha256sum $DIST_NAME.zip > $DIST_NAME.zip.checksum
echo " Size: " >> $DIST_NAME.zip.checksum
ls -la $DIST_NAME.zip | sed -e "s/^\([^ ]\+ \+\)\{4\}\([^ ]\+\).*/\2/g" >> $DIST_NAME.zip.checksum
cd -