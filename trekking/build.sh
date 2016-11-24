#!/bin/bash
set -e

cd "$(dirname "$0")/docker"
docker build -t thunderatz/trekking .
echo 'To start the container, use ./run.sh'
