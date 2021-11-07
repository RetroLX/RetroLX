#!/bin/bash

# UI Output with dialog, default colorset
function dialogoutput()
{
    local percent="$1"
    local footer="Do not switch off your device !"
    dialog --hline "$footer" --backtitle "RetroLX" --title " Installing $2 " --mixedgauge "Please wait while installing $2 ..." 10 50 "$percent" &> /dev/tty1
}

# Preparing packages array
packages=(
retroarch
lr-mrboom
lr-prboom
lr-tyrquake
lr-beetle-pce-fast
lr-fceumm
lr-mgba
lr-nestopia
lr-gambatte
lr-genesisplusgx
lr-picodrive
lr-snes9x
lr-snes9x2010
lr-stella
devilutionx
sdlpop
)

length="${#packages[@]}"
percent=$((100 / $length))
progress=0;

/usr/bin/retrolx-pacman list
for i in "${packages[@]}"
do
    /usr/bin/pacman --config /etc/retrolx_pacman.conf --noconfirm -Sy "$i" --overwrite 'userdata/*'
    dialogoutput $progress "$i"
    /usr/bin/pacman --config /etc/retrolx_pacman.conf --noconfirm -Scc
    progress=$(($progress+$percent))
done
