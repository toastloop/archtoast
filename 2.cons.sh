#!/bin/sh

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

keymaps=`localectl list-keymaps | grep -v '\*' | awk '{print $1}'`

while true; do

    echo "Select a keymap (default: us, show list: list):"
    read -r keymap

    keymap=`echo "$keymap" | tr '[:upper:]' '[:lower:]'`
    keymap=`echo "$keymap" | tr -d '[:space:]'`

    if [ "$keymap" = "list" ]; then
        echo "$keymaps" | less
    elif [ -z "$keymap" ]; then
        keymap="us"
        break
    elif echo "$keymaps" | grep -q "^$keymap$"; then
        break
    else
        echo "Invalid keymap. Please try again."
    fi

done

echo "Selected keymap: $keymap"
echo "Loading keymap..."
loadkeys "$keymap" || { echo "Failed to load keymap"; exit 1; }
echo "Keymap loaded successfully."
exit 0
