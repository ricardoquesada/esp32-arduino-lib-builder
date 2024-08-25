#!/bin/bash
source ./tools/config.sh

# Variables
#package index location, this is the file arduino IDE pulls version info and binary location from
input_file="phasedock_files/package_phasedock_index.json"
#name of the package in the index
package_name="phasedock_esp32_robotarm"
#these fields are needed for creating the new platform instance for the new version
dist_size=$(ls -la dist/$DIST_NAME.zip | sed -e "s/^\([^ ]\+ \+\)\{4\}\([^ ]\+\).*/\2/g")
dist_checksum=$(sha256sum dist/$DIST_NAME.zip | sed -e "s/ .*//g")
current_branch=$(git branch --show-current)
#the branch that the package index is referenced from
target_branch="master"

# Read the platform entry from platform.json
new_platform=$(cat <<EOF
{
  "name": "PhaseDock Robot Arm",
  "architecture": "esp32",
  "version": "$DIST_VERSION",
  "category": "Contributed",
  "url": "https://github.com/PhaseDock/esp32-arduino-lib-builder/releases/download/1.0.0/$DIST_NAME.zip",
  "archiveFileName": "$DIST_NAME.zip",
  "checksum": "SHA-256:$dist_checksum",
  "size": "$dist_size",
  "boards": [
    {
      "name": "ESP32 Dev Board"
    }
  ],
  "toolsDependencies": [
    {
      "packager": "esp32",
      "name": "xtensa-esp32-elf-gcc",
      "version": "esp-2021r2-patch5-8.4.0"
    },
    {
      "packager": "esp32",
      "name": "xtensa-esp32s2-elf-gcc",
      "version": "esp-2021r2-patch5-8.4.0"
    },
    {
      "packager": "esp32",
      "name": "xtensa-esp32s3-elf-gcc",
      "version": "esp-2021r2-patch5-8.4.0"
    },
    {
      "packager": "esp32",
      "name": "xtensa-esp-elf-gdb",
      "version": "11.2_20220823"
    },
    {
      "packager": "esp32",
      "name": "riscv32-esp-elf-gcc",
      "version": "esp-2021r2-patch5-8.4.0"
    },
    {
      "packager": "esp32",
      "name": "riscv32-esp-elf-gdb",
      "version": "11.2_20220823"
    },
    {
      "packager": "esp32",
      "name": "openocd-esp32",
      "version": "v0.12.0-esp32-20230419"
    },
    {
      "packager": "esp32",
      "name": "esptool_py",
      "version": "4.5.1"
    },
    {
      "packager": "esp32",
      "name": "mkspiffs",
      "version": "0.2.3"
    },
    {
      "packager": "esp32",
      "name": "mklittlefs",
      "version": "3.0.0-gnu12-dc7f933"
    },
    {
      "packager": "arduino",
      "name": "dfu-util",
      "version": "0.11.0-arduino5"
    }
  ]
}
EOF
)

# tag create and upload the binaries for the release
gh auth login && \
gh repo set-default https://github.com/PhaseDock/phasedock_arduino_board.git && \
gh release create v$DIST_VERSION --title "PhaseDock Robot Arm Board Release $DIST_VERSION" --notes "Release $DIST_VERSION of the Arduino board for the PhaseDock Robot Arm" && \
gh release upload v$DIST_VERSION dist/$DIST_NAME.zip && \

# check out the main branch that hosts the package index file
git fetch && \
git checkout $target_branch && \

# Update the package index, adding or updating the platform
jq --argjson new_platform "$new_platform" --arg package_name "$package_name" --arg platform_version "$DIST_VERSION" '
  .packages |= map(
    if .name == $package_name then
      .platforms |= (
        if any(.version == $platform_version) then
          map(if .version == $platform_version then $new_platform else . end)
        else
          . + [$new_platform]
        end
      )
    else
      .
    end
  )
' "$input_file" > $input_file.tmp && \
mv $input_file.tmp $input_file && \

#commit and push the changes
git add $input_file && \
git commit -m "Updating package index for $DIST_VERSION of the Phase Dock Robot Arm Board" && \
git push

#switch back to the current branch
git checkout $current_branch
