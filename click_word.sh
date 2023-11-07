#!/bin/bash

# Take a screenshot
scrot /tmp/screen.png

# Use Tesseract OCR to extract text and bounding boxes (hOCR)
tesseract /tmp/screen.png /tmp/output hocr

# Parse the hOCR output to find the bounding box of the word 'Attack'
# Look for the line that contains the recognized 'Attack' word and extract its bounding box coordinates
ATTACK_COORDS=$(grep -oP 'title="bbox \K.*(?=">.*?Attack)' /tmp/output.hocr | head -1)

# Check if we found 'Attack'
if [ ! -z "$ATTACK_COORDS" ]; then
    # Break the coordinates into an array
    IFS=' ' read -r -a bbox <<< "$ATTACK_COORDS"

    # Calculate the center of the bounding box
    ATTACK_X=$(( (${bbox[0]} + ${bbox[2]}) / 2 ))
    ATTACK_Y=$(( (${bbox[1]} + ${bbox[3]}) / 2 ))

    echo "Attack found at coordinates: $ATTACK_X, $ATTACK_Y"

    # Move the mouse to the 'Attack' word and click
    xdotool mousemove $ATTACK_X $ATTACK_Y click 1
else
    echo "The word 'Attack' was not found on the screen."
fi

# Cleanup
rm /tmp/screen.png /tmp/output.hocr
