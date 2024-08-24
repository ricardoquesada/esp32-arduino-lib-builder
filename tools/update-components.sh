#/bin/bash

source ./tools/config.sh

CAMERA_REPO_URL="https://github.com/espressif/esp32-camera.git"
DL_REPO_URL="https://github.com/espressif/esp-dl.git"
SR_REPO_URL="https://github.com/espressif/esp-sr.git"
RMAKER_REPO_URL="https://github.com/espressif/esp-rainmaker.git"
INSIGHTS_REPO_URL="https://github.com/espressif/esp-insights.git"
DSP_REPO_URL="https://github.com/espressif/esp-dsp.git"
LITTLEFS_REPO_URL="https://github.com/joltwallet/esp_littlefs.git"
TINYUSB_REPO_URL="https://github.com/hathach/tinyusb.git"
BLUEPAD32_REPO_URL="https://github.com/ricardoquesada/esp-idf-arduino-bluepad32-template.git"

#
# CLONE/UPDATE BLUEPAD32
#
echo "Updating Bluepad32..."
if [ ! -d "bluepad32-repo" ]; then
	git clone --recursive $BLUEPAD32_REPO_URL "bluepad32-repo"
fi

if [ "$BLUEPAD32_BRANCH" ]; then
	git -C "bluepad32-repo" checkout "$BLUEPAD32_BRANCH" && \
	git -C "bluepad32-repo" fetch
fi
cp -rf bluepad32-repo/components/* "$AR_COMPS/"

#
# CLONE/UPDATE ARDUINO
#
echo "Updating ESP32 Arduino..."
if [ ! -d "$AR_COMPS/arduino" ]; then
	git clone $AR_REPO_URL "$AR_COMPS/arduino"
  if [ "$AR_BRANCH" ]; then
    git -C "$AR_COMPS/arduino" checkout "$AR_BRANCH" && \
    git -C "$AR_COMPS/arduino" fetch
  fi
fi

if [ -z $AR_BRANCH ]; then
	if [ -z $GITHUB_HEAD_REF ]; then
		current_branch=`git branch --show-current`
	else
		current_branch="$GITHUB_HEAD_REF"
	fi
	echo "Current Branch: $current_branch"
	if [[ "$current_branch" != "master" && `git_branch_exists "$AR_COMPS/arduino" "$current_branch"` == "1" ]]; then
		export AR_BRANCH="$current_branch"
	else
		if [ -z "$IDF_COMMIT" ]; then #commit was not specified at build time
			AR_BRANCH_NAME="idf-$IDF_BRANCH"
		else
			AR_BRANCH_NAME="idf-$IDF_COMMIT"
		fi
		has_ar_branch=`git_branch_exists "$AR_COMPS/arduino" "$AR_BRANCH_NAME"`
		if [ "$has_ar_branch" == "1" ]; then
			export AR_BRANCH="$AR_BRANCH_NAME"
		else
			has_ar_branch=`git_branch_exists "$AR_COMPS/arduino" "$AR_PR_TARGET_BRANCH"`
			if [ "$has_ar_branch" == "1" ]; then
				export AR_BRANCH="$AR_PR_TARGET_BRANCH"
			fi
		fi
	fi
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP32-CAMERA
#
echo "Updating ESP32 Camera..."
if [ ! -d "$AR_COMPS/esp32-camera" ]; then
	git clone $CAMERA_REPO_URL "$AR_COMPS/esp32-camera" && \
	git -C "$AR_COMPS/esp32-camera" reset --hard $ESP32_CAMERA_VERSION
else
	git -C "$AR_COMPS/esp32-camera" fetch && \
	git -C "$AR_COMPS/esp32-camera" pull --ff-only
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP-DL
#
echo "Updating ESP-DL..."
if [ ! -d "$AR_COMPS/esp-dl" ]; then
	git clone $DL_REPO_URL "$AR_COMPS/esp-dl" && \
	git -C "$AR_COMPS/esp-dl" reset --hard $ESP_DL_VERSION
	if [ $? -ne 0 ]; then exit 1; fi
fi

#
# CLONE/UPDATE ESP-LITTLEFS
#
echo "Updating ESP-LITTLEFS..."
if [ ! -d "$AR_COMPS/esp_littlefs" ]; then
	git clone $LITTLEFS_REPO_URL "$AR_COMPS/esp_littlefs" && \
  git -C "$AR_COMPS/esp_littlefs" submodule update --init --recursive
else
	git -C "$AR_COMPS/esp_littlefs" fetch && \
	git -C "$AR_COMPS/esp_littlefs" pull --ff-only && \
  git -C "$AR_COMPS/esp_littlefs" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP-DSP
#
echo "Updating ESP-DSP..."
if [ ! -d "$AR_COMPS/espressif__esp-dsp" ]; then
	git clone $DSP_REPO_URL "$AR_COMPS/espressif__esp-dsp" && \
	git -C "$AR_COMPS/espressif__esp-dsp" reset --hard $ESPRESSIF_DSP_VERSION
else
	git -C "$AR_COMPS/espressif__esp-dsp" fetch && \
	git -C "$AR_COMPS/espressif__esp-dsp" pull --ff-only
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE TINYUSB
#
echo "Updating TinyUSB..."
if [ ! -d "$AR_COMPS/arduino_tinyusb/tinyusb" ]; then
	git clone $TINYUSB_REPO_URL "$AR_COMPS/arduino_tinyusb/tinyusb" && \
	git -C "$AR_COMPS/arduino_tinyusb/tinyusb" reset --hard $TINYUSB_VERSION
else
	git -C "$AR_COMPS/arduino_tinyusb/tinyusb" fetch && \
	git -C "$AR_COMPS/arduino_tinyusb/tinyusb" pull --ff-only
fi
if [ $? -ne 0 ]; then exit 1; fi

