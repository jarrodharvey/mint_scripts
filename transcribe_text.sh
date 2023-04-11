#!/bin/bash

start_dir=$(pwd)

nd_dir="/home/jarrod/git_installs/nerd-dictation"

tmp_file="/tmp/transcription.txt"

cd $nd_dir

touch $tmp_file

./nerd-dictation begin --vosk-model-dir=./model &

notify-send "Transcribe now. Don't edit yet."

gedit $tmp_file

./nerd-dictation end

notify-send "Make any required edits"

vim $tmp_file

cat "$tmp_file" | xclip -selection clipboard

notify-send "Text copied to clipboard"

rm $tmp_file

cd $start_dir
