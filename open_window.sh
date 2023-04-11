#!/bin/bash

win_title=$1
open_command=$2

if wmctrl -l | grep $win_title; then
	wmctrl -a "$1"
else
	$2
fi
