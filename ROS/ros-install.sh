#!/bin/bash
# From http://wiki.ros.org/kinetic/Installation/Debian
set -ex

useradd -mG sudo ros
mkdir -p /etc/sudoers.d
echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo_nopasswd

echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
apt-key update
apt-get update
apt-get install -y ros-kinetic-desktop-full
rosdep init
sudo -u ros rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~ros/.bashrc
apt-get install -y python-rosinstall
