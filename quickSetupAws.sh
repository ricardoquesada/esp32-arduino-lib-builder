#!/bin/bash
sudo yum install git wget curl flex bison gperf python python-pip python-setuptools python-click python-cryptography python-future python-pyparsing cmake ninja-build jq libusb --allow
sudo pip install --upgrade pip
#maybe not necessary
pip install idf-component-manager -U
#maybe not necessary
python -m idf_component_manager -h
git clone https://github.com/PhaseDock/esp32-arduino-lib-builder.git
cd esp32-arduino-lib-builder/
#temporary for now, though it might be handy to have this be generated, and the branch resolve to the current branch
git checkout RAP-84_custom-board-library-setup
esp-idf/install.sh
esp-idf/export.sh
./build.sh