#!/bin/bash

echo "Updating dotfiles repository from current configs..."

#toplevel dotfiles
files=(
  .bashrc
  .zshrc
  .p10k.zsh
  .gitconfig
)

for file in "${files[@]}"; do
  if [[ -f ~/$file ]]; then
    cp ~/$file ~/hypr_dots/$file
  fi
done

#config directories
config_items=(
  btop cava dunst gtk-2.0 gtk-3.0 gtk-4.0 kitty fastfetch neofetch flameshot
  nvim obsidian pywal ranger rofi spotify htop
  spicetify Thunar wal waybar hyprshade hypr imp-settings
)

mkdir -p ~/hypr_dots/config

for item in "${config_items[@]}"; do
  if [[ -d ~/.config/$item ]]; then
    rm -rf ~/hypr_dots/config/$item #cclear old ver
    mkdir -p ~/hypr_dots/config/$item
    cp -r ~/.config/$item/* ~/hypr_dots/config/$item/
  fi
done

echo "✔ Dotfiles updated! You can now commit and push them."
