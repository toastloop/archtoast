#!/bin/sh

clear

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1
networkCheck=$?

if [ $networkCheck -ne 0 ]; then
    echo "No internet connection detected. Please check your network settings."
    echo "Press any key to continue..."
    read -r _
    exit 1
fi

ping -c 1 -W 1 google.com > /dev/null 2>&1
dnsCheck=$?

if [ $dnsCheck -ne 0 ]; then
    echo "DNS resolution failed. Please check your DNS settings."
    echo "Press any key to continue..."
    read -r _
    exit 1
fi

echo "Internet connection and DNS resolution are working."
echo "Press any key to continue..."
read -r _
clear