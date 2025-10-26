#!/usr/bin/env bash

# hyprland script to toggle mute in Microsoft Teams

teams_window=$(hyprctl clients -j | jq -r '.[] | select(.class == "teams-for-linux") | .address')
if [ -n "$teams_window" ]; then
  active_window=$(hyprctl activewindow -j | jq -r '.address')
  # if active window is teams
  if [ "$active_window" == "$teams_window" ]; then
    hyprctl dispatch sendshortcut CONTROL SHIFT, M, class:teams-for-linux
  else
    hyprctl dispatch focuswindow class:teams-for-linux
    hyprctl dispatch sendshortcut "CONTROL SHIFT, M, class:teams-for-linux"
    hyprctl dispatch focuswindow address:"$active_window"
  fi
fi