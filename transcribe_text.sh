#!/bin/bash

start_dir=$(pwd)

nd_dir="/home/jarrod/git_installs/nerd-dictation"

tmp_file="/tmp/transcription.txt"
tmp_spellchecked="/tmp/transcription_spellchecked.txt"

cd $nd_dir

touch $tmp_file

./nerd-dictation begin --vosk-model-dir=./model &

notify-send "Transcribe now. Don't edit yet."

gedit $tmp_file

./nerd-dictation end

notify-send "Making punctuation fixes..."

java -jar /snap/languagetool/38/usr/bin/languagetool-commandline.jar --apply $tmp_file > $tmp_spellchecked

notify-send "Make any required edits"

vim $tmp_spellchecked

cat "$tmp_spellchecked" | xclip -selection clipboard

notify-send "Text copied to clipboard"

rm $tmp_file
rm $tmp_spellchecked

cd $start_dir
