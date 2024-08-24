#!/bin/bash

# Find the device number based on its name
# device=$(grep -l 'Generic X-Box pad' /sys/class/input/event*/device/name | awk -F'/' '{ print "/dev/input/"$5 }')

device=/dev/input/event7

if [ -z "$device" ]; then
    echo "Device not found"
    exit 1
fi

sniper="xinput set-prop 'RP2040 HID Remapper UBPK Mouse' 'libinput Accel Speed'"
space="type 1 (EV_KEY), code 194 (KEY_F24), value"
escape="type 1 (EV_KEY), code 189 (KEY_F19), value"
tab="type 1 (EV_KEY), code 192 (KEY_F22), value"

sudo evtest "$device" | while read line
do
    if [[ $line == *"$escape 1"* ]]; then
        /home/jarrod/mint_scripts/talon_dictation_mode.sh
    elif [[ $line == *"$escape 0"* ]]; then
        /home/jarrod/mint_scripts/talon_sleep_mode.sh
    fi
    if [[ $line == *"$space 1"* ]]; then
        /home/jarrod/mint_scripts/talon_command_mode.sh
    elif [[ $line == *"$space 0"* ]]; then
        /home/jarrod/mint_scripts/talon_sleep_mode.sh
    fi
    if [[ $line == *"$tab 1"* ]]; then
        xinput set-prop 'RP2040 HID Remapper UBPK Mouse' 'libinput Accel Speed' -1.0
    elif [[ $line == *"$tab 0"* ]]; then
        xinput set-prop 'RP2040 HID Remapper UBPK Mouse' 'libinput Accel Speed' 1.0
    fi
done
