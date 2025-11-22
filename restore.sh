#!/bin/bash

echo "Restoring dotfiles from hypr_dots..."

BACKUP_DIR=~/dotfiles_backup_$(date +%Y-%m-%d_%H-%M-%S)
mkdir -p "$BACKUP_DIR"

echo "Backup directory: $BACKUP_DIR"
echo

# ---------------------------------------------
# 1. Restore top-level dotfiles (.zshrc, .gitconfig, etc.)
# ---------------------------------------------
files=(
  .bashrc
  .zshrc
  .p10k.zsh
  .gitconfig
)

for file in "${files[@]}"; do
  if [[ -f ~/hypr_dots/$file ]]; then
    echo "Restoring $file"
    if [[ -f ~/$file ]]; then
      mv ~/$file "$BACKUP_DIR/"
    fi
    cp ~/hypr_dots/$file ~/
  fi
done

# ---------------------------------------------
# 2. Restore ~/.config items
# ---------------------------------------------
config_items=(
  btop cava dunst gtk-2.0 gtk-3.0 gtk-4.0 kitty fastfetch neofetch flameshot
  nvim obsidian pywal ranger rofi spotify htop
  spicetify Thunar wal waybar hyprshade hypr imp-settings
)

for item in "${config_items[@]}"; do
  if [[ -d ~/hypr_dots/config/$item ]]; then
    echo "Restoring ~/.config/$item"

    # Backup existing config
    if [[ -d ~/.config/$item ]]; then
      mkdir -p "$BACKUP_DIR/config"
      mv ~/.config/$item "$BACKUP_DIR/config/"
    fi

    # Restore new config
    mkdir -p ~/.config/$item
    cp -r ~/hypr_dots/config/$item/* ~/.config/$item/
  fi
done

echo
echo "✔ Restore complete!"
echo "All previous configs backed up at: $BACKUP_DIR"
