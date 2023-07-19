#!/bin/bash

# If nerd dictation is already running then kill it

# Put talon to sleep

echo 'mimic("talon sleep")' | ~/.talon/bin/repl

# Start nerd dictation
notify-send "starting nerd dictation" 
cd /home/jarrod/git_installs/nerd-dictation
./nerd-dictation begin --vosk-model-dir=./model &

#  wait until the user presses any button

# Find the keyboard device ID
device_id=$(xinput list | grep -i 'keyboard' | grep -oP 'id=\K\d+')

# Function to be called when the script is interrupted
function on_exit {
    xinput test -x $device_id > /dev/null 2>&1
}

trap on_exit EXIT

# Monitor the keyboard events
while read -r line; do
    key=$(echo "$line" | grep -oP 'key press\s+\K\d+')
    if [[ "$key" == "62" ]]; then # Right Shift key code
        bash /path/to/your/script.sh
    fi
done < <(xinput test $device_id)

# end nerd dictation
notify-send "stopping nerd dictation"
./nerd-dictation end

echo 'mimic("talon wake")' | ~/.talon/bin/repl

