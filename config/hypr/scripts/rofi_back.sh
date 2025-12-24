#!/bin/bash

# -------------------------
# Config and Paths
# -------------------------
WALLPAPERS="$HOME/wallpaper"
CACHE_DIR="$HOME/.cache/wallpaper-picker"
THUMB_WIDTH="250"
THUMB_HEIGHT="141"
WAYBAR_SCRIPT="$HOME/.config/waybar/scripts/pywal-waybar.sh"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# -------------------------
# Functions
# -------------------------

# Generate thumbnail for Wofi
generate_thumbnail() {
  local input="$1"
  local output="$2"
  magick "$input" -thumbnail "${THUMB_WIDTH}x${THUMB_HEIGHT}^" \
    -gravity center -extent "${THUMB_WIDTH}x${THUMB_HEIGHT}" "$output"
}

# Generate Wofi menu items
generate_menu() {
  while IFS= read -r img; do
    [[ -f "$img" ]] || continue
    ext="${img##*.}"
    thumb="$CACHE_DIR/$(basename "${img%.*}").$ext"

    # Regenerate thumbnail if missing or outdated
    if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
      generate_thumbnail "$img" "$thumb"
    fi

    # Format for Wofi
    echo -en "img:$thumb\x00info:$(basename "$img")\x00value:$img\n"

  done < <(find "$WALLPAPERS" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort -V)
}

# -------------------------
# Run Wofi menu
# -------------------------
CHOICE=$(
  generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMB_WIDTH}x${THUMB_HEIGHT}" \
    --columns 3 \
    --allow-images \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --conf "$HOME/.config/wofi/wallpaper"
)

# Exit if no choice
[ -z "$CHOICE" ] && exit 0

SELECTED=$(echo "$CHOICE" | sed -n 's/.*value:\(.*\)/\1/p')
BASENAME=$(basename "$SELECTED")
#THEME="${BASENAME%%_*}"

# -------------------------
# Set wallpaper with swww
# -------------------------
if ! pgrep -x "swww-daemon" >/dev/null; then
  swww-daemon --rc &
  sleep 0.1
fi

swww img "$SELECTED" \
  --namespace hyprland \
  --transition-type wipe \
  --transition-duration 2.5 \
  --transition-fps 144

sleep 0.3

# -------------------------
# Update colors with pywal
# -------------------------
wal -i "$SELECTED"

# Update Waybar
[[ -x "$WAYBAR_SCRIPT" ]] && "$WAYBAR_SCRIPT"

# Update Dunst
ln -sf "$HOME/.cache/wal/dunstrc" "$HOME/.config/dunst/dunstrc"
pkill dunst
dunst &

# Notification
notify-send "Wallpaper updated!" "$(basename "$SELECTED")"
