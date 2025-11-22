#!/usr/bin/env bash

WALLDIR="/home/concerned_penguin/wallpaper"
NAMESPACE="hyprland" # same as your swww-daemon namespace
FPS=60               # transition smoothness
#TYPE="random"
TYPES=("grow" "outer" "wipe" "center" "left" "right" "top" "bottom")
TYPE="${TYPES[$RANDOM % ${#TYPES[@]}]}" #random transititiontype
# pick a random wallpaper from the folder
WALL=$(find "$WALLDIR" -type f | shuf -n1)

# set it using swww
swww img "$WALL" --namespace "$NAMESPACE" \
  --transition-type "$TYPE" \
  --transition-fps "$FPS" \
  --transition-duration 2

sleep 0.3

#update pywal colors
wal -i "$WALL" -e
#waybar pywal integration
/home/concerned_penguin/.config/waybar/scripts/pywal-waybar.sh
#pkill waybar
#sleep 0.1
#waybar &
#update dunst colors
ln -sf /home/concerned_penguin/.cache/wal/dunstrc /home/concerned_penguin/.config/dunst/dunstrc
#pkill -SIGUSR1 dunst &
pkill dunst
dunst &

notify-send "Wallpaper changed and colors updated!" "$(basename "$WALL")"
