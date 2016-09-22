#!/bin/bash
# From http://wiki.ros.org/kinetic/Installation/Debian
set -e
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
apt-get update
apt-get install -y ros-kinetic-desktop-full
rosdep init
rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
apt-get install -y python-rosinstall
