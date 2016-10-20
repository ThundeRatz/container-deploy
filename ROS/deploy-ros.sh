#!/bin/bash
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
# sudo - run commands as superuser
debootstrap --include dbus,lsb-release,sudo jessie "$ROOT" http://httpredir.debian.org/debian/

echo ============================================================
echo "Setting up networking (will also enable forwarding on the host system)"
# Host config
echo 1 > /proc/sys/net/ipv4/ip_forward
systemctl start systemd-networkd
# Container config
echo -e "127.0.0.1\t$(hostname)" >> "$ROOT/etc/hosts"
echo nameserver 8.8.8.8 > "$ROOT/usr/lib/systemd/resolv.conf"
sudo ln -sf /usr/lib/systemd/resolv.conf "$ROOT/etc/resolv.conf"
sudo ln -sf /etc/systemd/system/multi-user.target.wants/systemd-networkd.service "$ROOT/lib/systemd/system/systemd-networkd.service"

echo ============================================================
echo Starting container
systemctl start "systemd-nspawn@$CONTAINER.service"

shell() {
    # machinectl shell "$CONTAINER" "$@" would be better (can execute on a running container)
    systemd-nspawn -M "$CONTAINER" "$@"
}
echo ============================================================
echo Running ROS install script
cp ros-install.sh $ROOT/
shell /ros-install.sh

echo ============================================================
echo Done!
echo If you need help, the man pages for systemd-nspawn, machinectl and networkctl
echo are good resources.
echo To boot this container with networking and sharing X files:
echo '"systemd-nspawn -bn --bind-ro=/tmp/.X11-unix:/tmp/.X11-unix -D /var/lib/machines/$CONTAINER"'
echo 'It can be used as service "systemd-nspawn@$CONTAINER.service"'
echo 'To allow X connections, run on the host "xhost +local:"'
