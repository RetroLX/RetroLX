#!/bin/bash

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
lr-snes9x2010
lr-stella
devilutionx
sdlpop
)

/usr/bin/retrolx-pacman list
/usr/bin/pacman --config /etc/retrolx_pacman.conf --noconfirm -Sy ${packages[*]} --overwrite 'userdata/*'
/usr/bin/pacman --config /etc/retrolx_pacman.conf --noconfirm -Scc
