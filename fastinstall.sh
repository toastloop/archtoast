#!/bin/sh
clear
loadkeys us
setfont Lat2-Terminus16
efi=$(cat /sys/firmware/efi/fw_platform_size)
case $efi in
    64) echo "UEFI 64" ;;
    32) echo "UEFI 32" ;;
    *) echo "BIOS" ;;
esac
ping -c 1 -w 1 8.8.8.8 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "no internet"
    exit 1
fi
ping -c 1 -w 1 google.com > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "no dns"
    exit 1
fi
disk=$(lsblk -dnpo NAME,TYPE | awk '$2=="disk"{print $1; exit}'); 
scheme=$(parted "$disk" --script print 2>/dev/null | awk -F: '/^Partition Table:/ {print $2}' | tr -d ' ')
if [ -z "$scheme" ]; then
    parted "$disk" --script -- mklabel gpt
    scheme="gpt"
else
    echo "Partition scheme: $scheme"
fi
