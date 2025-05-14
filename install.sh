#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Check if the script is run in a terminal
if [ -z "$TERM" ]; then
    echo "This script must be run in a terminal"
    exit
fi

# Check if the script is running from the live USB
if [ ! -d "/run/archiso/bootmnt" ]; then
    echo "This script must be run from the live USB"
    exit
fi

echo "Installing Dependencies..."
sudo pacman -Sy
sudo pacman -S --noconfirm --needed dialog
clear

echo "Starting Application..."
echo "Please wait..."
sleep 2
clear

items=`localectl list-keymaps | awk '{print $1}'`
while true; do
    keymap=$(dialog --stdout --menu "Select Keymap" 0 0 0 $items)
    if [ $? -ne 0 ]; then
        break
    fi
    if [ -z "$keymap" ]; then
        break
    fi
    echo "Selected Keymap: $keymap"
    loadkeys $keymap
done
clear