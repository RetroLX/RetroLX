#!/bin/bash
# Builds a RetroLX image

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$SCRIPT_DIR"
REPOSITORY="$SCRIPT_DIR/../../"
echo "$REPOSITORY"
echo "Architecture $1"

docker pull retrolx/build-environment-ubuntu-20.10
docker run --entrypoint /RetroLX/ci/local/build-retrolx-arch.sh -v "$REPOSITORY":/RetroLX --add-host invisible-mirror.net:1.1.1.1 --rm retrolx/build-environment-ubuntu-20.10 $1 > docker-output.log 2>&1 &
tail -f docker-output.log