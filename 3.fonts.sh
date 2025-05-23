#!/bin/sh

clear

# Check this script is running inside the installer
if [ "$INSIDE" != "1" ]; then
    echo "This script must be run from inside the install.sh script"
    exit 1
fi

fonts=$(
  find /usr/share/kbd/consolefonts -type f ! -name '*README*' 2>/dev/null | \
  while IFS= read -r path; do
    fname=$(basename "$path")
    fname=${fname%.cp.gz}
    fname=${fname%.psfu.gz}
    fname=${fname%.psf.gz}
    fname=${fname%.fnt.gz}
    fname=${fname%.gz}
    echo "$fname"
  done | sort -u
)

while true; do

    echo "Select a font (default: Lat2-Terminus16, show list: list):"
    read -r font

    font=$(echo "$font" | tr -d '[:space:]')

    if [ "$font" = "list" ]; then
        echo "$fonts" | less
    elif [ -z "$font" ]; then
        font="Lat2-Terminus16"
        break
    elif echo "$fonts" | grep -q "^$font$"; then
        break
    else
        echo "Invalid font. Please try again."
    fi

done

setfont "$font" || { echo "Failed to load font"; exit 1; }
echo "Font loaded successfully."
echo "Press any key to continue..."
read -r _
clear