#!/bin/bash
set -e

fail() {
    echo $1 >&2
    exit 1
}

if [[ "$USER" != ros ]] ; then
    fail 'Please run as user ros'
fi

if ! which nvidia-smi > /dev/null ; then
    echo "Can't find nvidia-smi, use nvidia-docker instead of docker and check host drivers installation"
elif ! nvidia-smi > /dev/null ; then
    echo "Failed to run nvidia-smi, check if host libraries are in place"
fi

if ! cd ~/ThunderTrekking/Main ; then
    fail "$HOME/ThunderTrekking not found, add it as a volume when running nvidia-docker"
fi

if [ ! -d workspace ] ; then
    echo 'ROS workspace not found, creating now'
    source /opt/ros/kinetic/setup.bash
    ./scripts/create_catkin_workspace.sh
fi

cd workspace
source devel/setup.bash
catkin_make -DCMAKE_BUILD_TYPE=Release

sudo chown ros:ros /dev/video0
roslaunch thunder_trekking trekking.launch
