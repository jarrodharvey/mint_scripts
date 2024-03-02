#!/bin/bash

# Variable to store the PID of the background process
pid=""

# Function to clean up background process
cleanup() {
    if [ ! -z "$pid" ]; then
        echo "Terminating background process..."
        kill $pid
        pid=""
    fi
}

# Set trap to call cleanup function on script exit
trap cleanup EXIT

# Function to start the command execution loop
execute_command_loop() {
    while true; do
        python3 click_word.py
        sleep 4    
    done
}

# Find the device number based on its name
# device=$(grep -l 'Generic X-Box pad' /sys/class/input/event*/device/name | awk -F'/' '{ print "/dev/input/"$5 }')

device=$(grep -l 'Microsoft X-Box Adaptive Controller' /sys/class/input/event*/device/name | awk -F'/' '{ print "/dev/input/"$5 }')

if [ -z "$device" ]; then
    echo "Device not found"
    exit 1
fi

# Initialize a variable to keep track of the command loop's PID
command_loop_pid=0  

# Handle script exit and interrupts to kill the command loop if it's running
trap '[[ $command_loop_pid -ne 0 ]] && kill $command_loop_pid' EXIT INT

# Grab the device exclusively, so its events don't go to the system
sudo evtest --grab "$device" | while read line
do
    if [[ $line == *"type 3 (EV_ABS), code 1 (ABS_Y), value 32767"* ]]; then
        /home/jarrod/mint_scripts/move_cursor.sh -x 300 1000 
    elif [[ $line == *"type 3 (EV_ABS), code 1 (ABS_Y), value -1"* ]]; then
        /home/jarrod/mint_scripts/move_cursor.sh 2 450 
    fi
    if [[ $line == *"type 1 (EV_KEY), code 315 (BTN_START), value 1"* ]]; then
        echo "actions.speech.toggle(True)" | /home/jarrod/.talon/bin/repl
        echo "mimic('game mode')" | /home/jarrod/.talon/bin/repl
    elif [[ $line == *"type 1 (EV_KEY), code 315 (BTN_START), value 0"* ]]; then
        echo "mimic('command mode')" | /home/jarrod/.talon/bin/repl
        echo "actions.speech.toggle(False)" | /home/jarrod/.talon/bin/repl
    fi
    if [[ $line == *"type 1 (EV_KEY), code 314 (BTN_SELECT), value 1"* ]]; then
        #xinput set-prop 'RP2040 HID Remapper QP1K Mouse' 'libinput Accel Speed' -1.0
        xinput set-prop 'RP2040 HID Remapper UBPK Mouse' 'libinput Accel Speed' -1.0
    elif [[ $line == *"type 1 (EV_KEY), code 314 (BTN_SELECT), value 0"* ]]; then
        #xinput set-prop 'RP2040 HID Remapper QP1K Mouse' 'libinput Accel Speed' 1.0
        xinput set-prop 'RP2040 HID Remapper UBPK Mouse' 'libinput Accel Speed' 1.0
    fi

    if [[ $line == *"type 1 (EV_KEY), code 305 (BTN_EAST), value 1"* ]]; then

        echo "actions.user.game_stop()" | /home/jarrod/.talon/bin/repl
        REPEAT_FILE="/home/jarrod/mint_scripts/repeat.json"
        # Extracting the 'button' and 'wait_time' values using jq
        BUTTON=$(jq -r '.button' "$REPEAT_FILE")
        WAIT_TIME=$(jq -r '.wait_time' "$REPEAT_FILE")
        echo "actions.user.hud_publish_content('Pressing $BUTTON every $WAIT_TIME seconds', 'example', 'Pressing button')" | /home/jarrod/.talon/bin/repl
        sleep 2
        # Start pressing enter every two seconds
        if [ -z "$pid" ]; then
            # Start a background process
            (
                while true; do
                    # Simulate pressing 'Enter'. Use 'xdotool' for GUI applications or 'input' for terminal
                    xdotool key $BUTTON  # For GUI applications
                    # input keyevent 66  # For terminal applications, may require root or specific permissions
                    sleep $WAIT_TIME  # Wait for 2 seconds before the next press
                done
            ) &
            # Store the PID of the background process
            pid=$!
        fi
    elif [[ $line == *"type 1 (EV_KEY), code 305 (BTN_EAST), value 0"* ]]; then
        # Stop pressing enter
        echo "actions.user.hud_disable_id('Text panel')" | /home/jarrod/.talon/bin/repl
        if [ ! -z "$pid" ]; then
            # Kill the background process
            kill $pid
            # Clear the PID variable
            pid=""
        fi
    fi

    # Check for btn_north press and release events
    if [[ $line == *"type 1 (EV_KEY), code 307 (BTN_NORTH), value 1"* ]]; then
        # Start the command execution loop in the background if not already running
        if [[ $command_loop_pid -eq 0 ]]; then
            execute_command_loop &
            command_loop_pid=$!
        fi
    elif [[ $line == *"type 1 (EV_KEY), code 307 (BTN_NORTH), value 0"* ]]; then
        # Kill the command execution loop if it's running
        if [[ $command_loop_pid -ne 0 ]]; then
            kill $command_loop_pid
            wait $command_loop_pid 2>/dev/null
            command_loop_pid=0
        fi
    fi
done
