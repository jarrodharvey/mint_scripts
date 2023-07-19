#!/bin/bash

# Find the device number based on its name
device=$(grep -l 'Generic X-Box pad' /sys/class/input/event*/device/name | awk -F'/' '{ print "/dev/input/"$5 }')

if [ -z "$device" ]; then
    echo "Device not found"
    exit 1
fi

sudo evtest "$device" | while read line
do
    if [[ $line == *"type 1 (EV_KEY), code 315 (BTN_START), value 1"* ]]; then
        echo "actions.speech.toggle(True)" | /home/jarrod/.talon/bin/repl
    elif [[ $line == *"type 1 (EV_KEY), code 315 (BTN_START), value 0"* ]]; then
        echo "actions.speech.toggle(False)" | /home/jarrod/.talon/bin/repl
    fi
done
