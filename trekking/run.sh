#!/bin/bash
set -e

cd "$(dirname "$0")"

if [ -f .trekking_dir ] ; then
    trekking="$(cat .trekking_dir)"
else
    while [ ! -d $trekking ] || [ -z $trekking ] ; do
        echo 'Enter path to ThundeRatz/ThunderTrekking repository:'
        read trekking
    done
    trekking="$(realpath "$trekking")"
    echo "Using path $trekking"
    echo $trekking > .trekking_dir
fi

if which nvidia-docker > /dev/null ; then
    DOCKER=nvidia-docker
else
    echo "nvidia-docker not found, GPU acceleration won't be supported"
    DOCKER=docker
fi

$DOCKER run --rm --privileged -v "$trekking":/home/ros/ThunderTrekking -v /dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix:ro thunderatz/trekking
