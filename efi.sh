#!/bin/sh

get_efi() {
    [ -d /sys/firmware/efi ]
}

if get_efi; then
    echo "EFI"
else
    echo "BIOS"
fi