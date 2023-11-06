#!/bin/bash

# Find the device number based on its name
# device=$(grep -l 'Generic X-Box pad' /sys/class/input/event*/device/name | awk -F'/' '{ print "/dev/input/"$5 }')

device=$(grep -l 'Microsoft X-Box Adaptive Controller' /sys/class/input/event*/device/name | awk -F'/' '{ print "/dev/input/"$5 }')

if [ -z "$device" ]; then
    echo "Device not found"
    exit 1
fi

sudo evtest "$device" | while read line
do
    if [[ $line == *"type 3 (EV_ABS), code 1 (ABS_Y), value 32767"* ]]; then
        /home/jarrod/mint_scripts/move_cursor.sh -x 300 1000 
    elif [[ $line == *"type 3 (EV_ABS), code 1 (ABS_Y), value -1"* ]]; then
        /home/jarrod/mint_scripts/move_cursor.sh 2 450 
    fi
    if [[ $line == *"type 1 (EV_KEY), code 315 (BTN_START), value 1"* ]]; then
        echo "actions.speech.toggle(True)" | /home/jarrod/.talon/bin/repl
    elif [[ $line == *"type 1 (EV_KEY), code 315 (BTN_START), value 0"* ]]; then
        echo "actions.speech.toggle(False)" | /home/jarrod/.talon/bin/repl
    fi
    if [[ $line == *"type 1 (EV_KEY), code 314 (BTN_SELECT), value 1"* ]]; then
        xinput set-prop 'RP2040 HID Remapper QP1K Mouse' 'libinput Accel Speed' -1.0
    elif [[ $line == *"type 1 (EV_KEY), code 314 (BTN_SELECT), value 0"* ]]; then
        xinput set-prop 'RP2040 HID Remapper QP1K Mouse' 'libinput Accel Speed' 1.0
    fi
done
