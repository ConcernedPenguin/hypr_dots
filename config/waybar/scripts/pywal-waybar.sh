#!/bin/bash
# Convert Pywal colors to GTK-compatible for Waybar

SRC="$HOME/.cache/wal/colors.sh"
DEST="$HOME/.cache/wal/colors-waybar.css"

# Extract Pywal colors
source "$SRC"

# Write to Waybar CSS format
cat >"$DEST" <<EOF
@define-color background $background;
@define-color foreground $foreground;
@define-color color0 $color0;
@define-color color1 $color1;
@define-color color2 $color2;
@define-color color3 $color3;
@define-color color4 $color4;
@define-color color5 $color5;
@define-color color6 $color6;
@define-color color7 $color7;
@define-color color8 $color8;
@define-color color9 $color9;
@define-color color10 $color10;
@define-color color11 $color11;
@define-color color12 $color12;
@define-color color13 $color13;
@define-color color14 $color14;
@define-color color15 $color15;
EOF
