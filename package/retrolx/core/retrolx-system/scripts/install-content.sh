#!/bin/bash

# UI Output with dialog, default colorset
function dialogoutput()
{
    local percent="$1"
    local footer="Do not switch off your device !"
    dialog --hline "$footer" --backtitle "RetroLX" --title " Installing $2 " --mixedgauge "Please wait while installing $2 ..." 10 50 "$percent" &> /dev/tty1
}

# Preparing packages array
IFS=$'\n' GLOBIGNORE='*' command eval 'XYZ=($(cat /home/romain/RetroLX/RetroLX/board/retrolx/content.txt))'
length="${#packages[@]}"
percent=$((100 / $length))
progress=0;

/usr/bin/retrolx-pacman list
for i in "${packages[@]}"
do
    package=`ls /boot/packages/${i}*`
    /usr/bin/pacman --config /usr/share/retrolx/scripts/install.conf --noconfirm -U "${package}" --overwrite 'userdata/*'
    dialogoutput $progress "$i"
    progress=$(($progress+$percent))
done
/usr/bin/pacman --config /etc/retrolx_pacman.conf --noconfirm -Scc
