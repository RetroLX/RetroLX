#!/bin/bash

# Preparing content array
content=(
)

for package in $content ; do /usr/bin/retrolx-pacman install ${package} ; done

