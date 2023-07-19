#!/bin/bash

placeholder_file="/home/jarrod/mint_scripts/text_file_to_copy.txt"

# Copy the content of the placeholder speech file
cat $placeholder_file | xclip -selection clipboard

# Delete the placeholder file if it already exists
rm $placeholder_file

# Open the placeholder speech file
code $placeholder_file