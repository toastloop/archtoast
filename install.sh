#!/bin/sh
setfont Lat2-Terminus16
clear
echo "Welcome to the Arch Linux installation script!"
echo "This script will guide you through the installation process."
echo "Press Enter to continue..."
read -r _
clear
while true; do
    echo "Please enter your selected keyboard map (e.g., us, de, fr):"
    echo "Type 'list' to see available maps or 'exit' to quit."
    read -r keymap
    if [ "$keymap" = "list" ]; then
        localectl list-keymaps
    elif [ "$keymap" = "exit" ]; then
        echo "Exiting the script."
        exit 0
    else
        loadkeys "$keymap"
        echo "Keyboard map set to $keymap."
        break
    fi
done
