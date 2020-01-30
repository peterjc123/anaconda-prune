#!/usr/bin/env bash

set -euo pipefail
shopt -s globstar

# TODO: Add logic for logging in and creating a conda environment here

for channel in channels/*; do
    for pkg in $(cat "${channel}"); do
        echo "+ Attempting to prune: ${channel}/${pkg}"
        CHANNEL="$(basename "${channel}")" PKG="${pkg}" ./prune.sh
        echo
    done
done
