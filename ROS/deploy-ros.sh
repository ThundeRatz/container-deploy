#!/bin/sh
# Useful links:
# https://wiki.archlinux.org/index.php/Systemd-networkd#Usage_with_containers
# https://wiki.archlinux.org/index.php/Systemd-nspawn
# https://www.ianweatherhogg.com/tech/2015-09-25-systemd-nspawn-archlinux-containers.html
set -e

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

CONTAINER=ros
ROOT="/var/lib/machines/$CONTAINER"

echo ============================================================
echo Creating container with debootstrap
# dbus - required for connecting additional shells to the container
# lsb-release - commonly found on debian and some programs assume it exists
debootstrap --include dbus,lsb-release jessie "$ROOT" http://httpredir.debian.org/debian/

echo ============================================================
echo "Setting up networking (will also enable forwarding on the host system)"
echo 1 > /proc/sys/net/ipv4/ip_forward
echo nameserver 8.8.8.8 > "$ROOT/usr/lib/systemd/resolv.conf"
sudo ln -sf /etc/systemd/system/multi-user.target.wants/systemd-networkd.service "$ROOT/lib/systemd/system/systemd-networkd.service"

echo ============================================================
echo Starting container and updating keyring
systemctl start systemd-nspawn@debian.service
systemd-run -M debian /usr/bin/apt-key update

echo ============================================================
echo Running ROS install script
cp ros-install.sh $ROOT/
systemd-run -M debian /ros-install.sh
rm $ROOT/ros-install.sh

echo ============================================================
echo Add ros user
shell /usr/sbin/useradd -mG sudo ros
echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' > "$ROOT/etc/sudoers.d/sudo_nopasswd"

echo ============================================================
echo Done!
echo If you need help, the man pages for systemd-nspawn, machinectl and networkctl
echo are good resources.
echo To boot this container with networking and sharing X files:
echo '"systemd-nspawn -bn --bind-ro=/tmp/.X11-unix:/tmp/.X11-unix -D /var/lib/machines/$CONTAINER"'
echo 'It can be used as service "systemd-nspawn@$CONTAINER.service"'
echo 'To allow X connections, run on the host "xhost +local:"'
