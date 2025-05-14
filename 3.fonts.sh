#!/bin/sh

fonts=`ls /usr/share/kbd/consolefonts | grep -v '\*' | grep -v 'README.*' | sed 's/\.psf\.gz$//' | awk '{print $1}'`

while true; do

    echo "Select a font (default: Lat2-Terminus16.psfu.gz, show list: list):"
    read -r font

    font=`echo "$font" | tr -d '[:space:]'`

    if [ "$font" = "list" ]; then
        echo "$fonts" | less
    elif [ -z "$font" ]; then
        font="Lat2-Terminus16.psfu.gz"
        break
    elif echo "$fonts" | grep -q "^$font$"; then
        break
    else
        echo "Invalid font. Please try again."
    fi

done

setfont "$font" || { echo "Failed to load font"; exit 1; }
echo "Font loaded successfully."
sleep 2
clear