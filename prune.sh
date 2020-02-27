#!/usr/bin/env bash

grab_version() {
    conda search -c "${CHANNEL}" --platform "${platform}" "${PKG}" 2>/dev/null | \
        grep "${CHANNEL}" | \
        awk -F '  *' '{print $2}' | \
        uniq | \
        head -n -1 | \
        xargs
}

# TODO: Write this in a proper programming language

set -eou pipefail

CHANNEL=${CHANNEL:-pytorch-nightly}
PKG=${PKG:-pytorch}
PLATFORMS=${PLATFORMS:-noarch osx-64 linux-64 win-64}

# Will grab all versions except for the latest one,
versions_to_prune=()
for platform in ${PLATFORMS}; do
    versions_to_prune+=( $(grab_version || true) )
done

declare -A unique_versions
# Only use unique versions
for version in ${versions_to_prune[@]}; do
    unique_versions["${version}"]=""
done

for version in ${!unique_versions[@]}; do
    (
        set -x
        anaconda remove --force ${CHANNEL}/${PKG}/${version}
    )
done
