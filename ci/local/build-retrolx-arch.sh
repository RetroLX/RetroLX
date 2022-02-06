#!/bin/bash
# Builds a RetroLX image

date
printenv

if [ -d "/RetroLX" ]; then # Docker mounts the repository on this directory
  cd /RetroLX
else
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    REPOSITORY="$SCRIPT_DIR/../../"
    cd $REPOSITORY
    pwd
fi

git submodule init
git submodule update
make $1-build
date
