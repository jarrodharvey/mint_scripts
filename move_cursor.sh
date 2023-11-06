#!/bin/bash
sleep 0.5  # Optional delay to ensure the active window is focused

# Initialize x and y with no value
x=
y=

# Process flags and arguments
while getopts ":x:" opt; do
  case $opt in
    x) # If the -x flag is provided, use its value for x-coordinate
      x=$OPTARG
      ;;
    \?) # Handle invalid options
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Discard the options and option arguments parsed by getopts
shift $((OPTIND - 1))

# Calculate x using the first parameter if -x was not used
if [ -z "$x" ]; then
  if [ -n "$1" ]; then
    # Apply the formula to calculate x
    x=$(( $1 * 400 - 250 ))
    # Shift parameters if x is calculated based on input parameter
    shift
  else
    echo "Error: No input provided for x-axis and -x flag not used."
    exit 1
  fi
fi

# Set y to the first remaining argument (if present), otherwise random
if [ -n "$1" ]; then
  y=$1
else
  y=$(( RANDOM % 701 + 150 ))
fi

# Move the mouse to the specified coordinates
xdotool mousemove --sync "$x" "$y"