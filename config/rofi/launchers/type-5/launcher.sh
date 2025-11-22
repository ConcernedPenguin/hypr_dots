#!/usr/bin/env bash

## Author : Concerned_Penguin
## Github : Syprozzz
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1

# Set icon theme to Zafiro before launching Rofi
export GTK_ICON_THEME=Zafiro

dir="$HOME/.config/rofi/launchers/type-5"
#style='style-1'
#default_theme="${dir}/${style}.rasi"
default_theme="/home/concerned_penguin/.config/rofi/launchers/type-5/style-1.rasi"
wal_colors="$HOME/.cache/wal/colors-rofi-dark.rasi"
#merged_theme="$HOME/.cache/wal/merged-style.rasi"

#if [[ -f "$wal_colors" ]]; then
#    cat "$wal_colors" "$default_theme" > "$merged_theme"
#    theme="$merged_theme"
#else
#    theme="$default_theme"
#fi
theme="$default_theme"
## Run
rofi \
  -show drun \
  -theme "$theme"
