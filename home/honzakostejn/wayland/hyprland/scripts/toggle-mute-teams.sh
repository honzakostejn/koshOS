#!/bin/bash

# hyprland script to toggle mute in Microsoft Teams

teams_window=$(hyprctl clients -j | jq -r '.[] | select(.class == "teams-for-linux") | .address')
if [ -n "$teams_window" ]; then
  active_window=$(hyprctl activewindow -j | jq -r '.address')
  hyprctl dispatch focuswindow address:"$teams_window"
  hyprctl dispatch sendshortcut "CONTROL SHIFT, M, address:$teams_window"
  hyprctl dispatch focuswindow address:"$active_window"
else
  echo "Teams is not running"
fi