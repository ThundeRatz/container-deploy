#!/bin/bash
set -e

cd "$(dirname "$0")/docker"
docker build -t thunderatz/trekking .
echo 'To start the container, run:'
echo 'nvidia-docker run --rm --privileged -v <path to Trekking directory>:/home/ros/ThunderTrekking -v /dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix:ro thunderatz/trekking'
