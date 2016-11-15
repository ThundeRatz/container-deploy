#!/bin/bash
set -e

ldconfig

if [[ "$*" ]] ; then
    su - ros -c "$*"
else
    su - ros
fi
