#!/bin/bash
sleep 0.5  # Optional delay to ensure the active window is focused

number_provided=$1

x=$((number_provided * 400 - 250))
y=$((RANDOM % 701 + 150))

xdotool mousemove --sync "$x" "$y"