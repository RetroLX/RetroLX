#!/bin/bash
/usr/bin/python \
/usr/share/emulationstation/retrolx-es-system.py \
/usr/share/emulationstation/es_systems.yml \
/usr/share/emulationstation/es_features.yml \
/userdata/system/.config \
/userdata/system/es_systems.cfg \
/userdata/system/es_features.cfg \
/usr/share/batocera/configgen/configgen-defaults.yml \
/usr/share/batocera/configgen/configgen-defaults-arch.yml \
/usr/share/emulationstation/roms \
/userdata/roms $(BATOCERA_SYSTEM_ARCH)

