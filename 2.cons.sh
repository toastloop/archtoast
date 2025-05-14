#!/bin/bash

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

keymaps=`localectl list-keymaps | grep -v '\*' | awk '{print $1}'`

for keymap in $keymaps; do
    echo $keymap
done
