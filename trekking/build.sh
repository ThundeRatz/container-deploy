#!/bin/bash
set -e

cd "$(dirname "$0")"
docker build -t thunderatz/trekking .
echo 'Run "docker run --rm -v <path to Trekking directory>:/home/ros/ThunderTrekking -ti thunderatz/trekking bash" to start a shell in the container'
