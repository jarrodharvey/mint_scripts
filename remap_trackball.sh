#!/usr/bin/env bash

mouse_name="Kensington Slimblade Trackball"

check=$(xinput | grep "$mouse_name")

if [[ ! -z "$check" ]]; then
	mouse_id=$(xinput | grep "$mouse_name" | sed 's/^.*id=\([0-9]*\)[ \t].*$/\1/')
	# swap right and back button then swap middle and back button
	xinput set-button-map $mouse_id 2 1 3 4 5 6 7 8 9
	# enable better scrolling 
	xinput set-prop $mouse_id "libinput Natural Scrolling Enabled" 1
	# disable acceliration for the ball
	xinput set-prop $mouse_id "libinput Accel Profile Enabled" 0, 1

	# allow scrolling by holding middle mouse button and using the ball to scroll ( really smooth and fast ). 
	xinput set-prop $mouse_id "libinput Scroll Method Enabled" 0, 0, 1
	# allow the remmaped middle mouse to be used for middle mouse scroll
	xinput set-prop $mouse_id "libinput Button Scrolling Button" 3
fi