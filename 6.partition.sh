#!/bin/sh

clear

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

drivenames=$(lsblk -d -n -p -o NAME,SIZE,TYPE | grep disk | awk '{print $1}')
drivelist=$(lsblk -d -n -p -o NAME,SIZE,TYPE | grep disk | awk '{print "$1 $2}' | sed 's/\/dev\///')

while true; do

    echo "Select a drive to partition (default: /dev/sda, show list: list):"
    read -r drive

    drive=$(echo "$drive" | tr '[:upper:]' '[:lower:]')
    drive=$(echo "$drive" | tr -d '[:space:]')

    if [ "$drive" = "list" ]; then
        echo "$drivelist" | less
    elif [ -z "$drive" ]; then
        drive="/dev/sda"
        break
    elif echo "$drivenames" | grep -q "^$drive$"; then
        break
    else
        echo "Invalid drive. Please try again."
    fi

done