#!/bin/sh

clear

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
else
    echo "Running as root"
fi

# Check if the script is run in a terminal
if [ -z "$TERM" ]; then
    echo "This script must be run in a terminal"
    exit 1
else 
    echo "Running in a terminal"
fi

# Check if the script is running from the live USB
if [ ! -d "/run/archiso/bootmnt" ]; then
    echo "This script must be run from the live USB"
    exit 1
else
    echo "Running from the live USB"
fi

echo "Press any key to continue..."
read -r _
clear