#!/bin/bash

# Take a screenshot
scrot /tmp/screen.png

# Use Tesseract OCR to extract text
tesseract /tmp/screen.png /tmp/output --dpi 96 -l eng

# Output the recognized text
cat /tmp/output.txt

# Cleanup
rm /tmp/screen.png /tmp/output.txt
