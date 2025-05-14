#!/bin/sh

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

# Check if the script is run as root
if [ "`id -u`" -ne 0 ]; then
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