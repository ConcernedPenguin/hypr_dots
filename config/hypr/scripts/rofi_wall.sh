#!/bin/bash

DIR="$HOME/wallpaper"

# Pick a wallpaper
SELECTED=$(find "$DIR" -type f | rofi -dmenu -i -p "Choose Wallpaper")

# If user didn't cancel
if [ -n "$SELECTED" ]; then

  # Ensure swww daemon is running
  if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon --rc &
    sleep 0.3
  fi

  # Set wallpaper with transition
  swww img "$SELECTED" --namespace hyprland --transition-type any --transition-duration 2 --transition-fps 60

  # Let display settle
  sleep 0.1

  # Generate pywal colors
  wal -i "$SELECTED"

  # Update Waybar colors
  "$HOME/.config/waybar/scripts/pywal-waybar.sh"

  # Update Dunst theme
  ln -sf "$HOME/.cache/wal/dunstrc" "$HOME/.config/dunst/dunstrc"

  pkill dunst
  dunst &

  # Correct variable name
  notify-send "Wallpaper updated!" "$(basename "$SELECTED")"

fi
