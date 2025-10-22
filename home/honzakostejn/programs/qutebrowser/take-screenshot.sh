#!/usr/bin/env bash

year=$(date +%Y)
month=$(date +%m)
path="$HOME/screenshots/qutebrowser/$year/$month"

mkdir -p "$path"

unixtimestamp=$(date +%s)
tab_name=$(echo "$QUTE_TITLE" | sed 's/[^a-zA-Z0-9._-]/_/g')
full_path="$path/${unixtimestamp}_${tab_name}.png"

echo "screenshot $full_path" >> "$QUTE_FIFO"
