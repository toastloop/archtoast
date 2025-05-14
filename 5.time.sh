#!/bin/sh

clear

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

while true; do

    echo "Select a timezone (default: UTC, show list: list):"
    read -r timezone

    timezone=$(echo "$timezone" | tr '[:upper:]' '[:lower:]')
    timezone=$(echo "$timezone" | tr -d '[:space:]')

    if [ "$timezone" = "list" ]; then
        timedatectl list-timezones | less
    elif [ -z "$timezone" ]; then
        timezone="UTC"
        break
    elif timedatectl list-timezones | grep -q "^$timezone$"; then
        break
    else
        echo "Invalid timezone. Please try again."
    fi

done

echo "Selected timezone: $timezone"
echo "Setting timezone..."
timedatectl set-timezone "$timezone" || { echo "Failed to set timezone"; exit 1; }
echo "Timezone set successfully."
echo "Setting hardware clock to system time..."
hwclock --systohc || { echo "Failed to set hardware clock"; exit 1; }
echo "Hardware clock set successfully."
echo "Synchronizing system time with NTP server..."
timedatectl set-ntp true || { echo "Failed to synchronize system time"; exit 1; }
echo "System time synchronized successfully."
echo "Press any key to continue..."
read -r _
clear