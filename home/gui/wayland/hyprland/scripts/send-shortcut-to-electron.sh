#!/usr/bin/env bash

if hyprctl activewindow | grep "$2: $3"; then
  hyprctl dispatch sendshortcut "$1", "$2:$3"
else
  active_window=$(hyprctl activewindow -j | jq -r '.address')
  hyprctl --batch "dispatch focuswindow $2:$3; dispatch sendshortcut $1, $2:$3; dispatch focuswindow address:$active_window"
fi