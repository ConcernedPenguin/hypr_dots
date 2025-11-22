#!/usr/bin/env bash

# Start swww daemon in a dedicated namespace
swww-daemon --namespace hyprland &

#flameshot
flameshot

# Give it a moment to create the socket
sleep 0.5
