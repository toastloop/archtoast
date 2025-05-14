#!/bin/sh
setfont Lat2-Terminus16
clear
echo "Welcome to the Arch Linux installation script!"
echo "This script will guide you through the installation process."
echo "Press Enter to continue..."
read -r _
clear
echo "Step 1: Select your keyboard layout"
echo `localectl list-keymaps`
echo "Please select your keyboard layout from the list above:"
while true; do
  read -r keymap
  if [ -z "$keymap" ]; then
    echo "No keyboard layout selected. Please try again."
  else
    break
  fi
done
loadkeys "$keymap"
echo "Keyboard layout set to $keymap."
echo "Press Enter to continue..."
read -r _
clear