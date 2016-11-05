#!/bin/bash
set -e

cd "$(dirname "$0")"
docker build -t thunderatz/trekking .
echo 'To start a shell in the container and allow USB access, run:'
echo 'nvidia-docker run --rm -v <path to Trekking directory>:/home/ros/ThunderTrekking --privileged -v /dev/bus/usb:/dev/bus/usb -ti thunderatz/trekking bash'
