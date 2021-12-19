#!/bin/bash

# UI Output with dialog, default colorset
function dialogoutput()
{
    local percent="$1"
    local footer="Do not switch off your device !"
    dialog --hline "$footer" --backtitle "RetroLX" --title " Installing $2 " --mixedgauge "Please wait while installing $2 ..." 10 50 "$percent" &> /dev/tty1
}

# UI Output with dialog, default colorset
function dialogoutput2()
{
    local percent="$1"
    local footer="Do not switch off your device !"
    dialog --hline "$footer" --backtitle "RetroLX" --title " $2 " --mixedgauge "Please wait while finishing install..." 10 50 "$percent" &> /dev/tty1
}

# Preparing packages array (read from /boot/packages.txt)
IFS=$'\n' GLOBIGNORE='*' command eval 'packages=($(cat /boot/packages.txt))'
length="${#packages[@]}"
percent=$((80 / $length))
progress=0;

# List packages to init db
/usr/bin/retrolx-pacman list

# Install all packages, skip hooks
for i in "${packages[@]}"
do
    package=`ls /boot/packages/${i}*`
    /usr/bin/pacman --config /usr/share/retrolx/scripts/install.conf --noconfirm -U "${package}" --overwrite 'userdata/*'
    dialogoutput $progress "$i"
    progress=$(($progress+$percent))
done

dialogoutput2 $progress "Cleanup..."

# Cleanup DB
/usr/bin/pacman --config /etc/retrolx_pacman.conf --noconfirm -Scc

dialogoutput2 $progress "Building installed systems..."

# Now we rebuild all systems at once
/usr/bin/retrolx-rebuild-es-systems.sh
