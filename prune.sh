#!/usr/bin/env bash

# TODO: Write this in a proper programming language

set -eou pipefail

CHANNEL=${CHANNEL:-pytorch-nightly}
PKG=${PKG:-pytorch}

# TODO: Refactor this to cover all platforms we currently support
#       * osx-64
#       * linux-64
#       * win-64
# Will grab all versions except for the latest one,
versions_to_prune=$(\
    conda search -c "${CHANNEL}" "${PKG}" | \
        grep "${CHANNEL}" | \
        awk -F '  *' '{print $2}' | \
        uniq | \
        head -n -1 | \
        xargs
)

if [[ -z "${versions_to_prune}" ]]; then
    # This might a good thing or a bad thing, who knows?
    #
    # Exit gracefully though, since it could just mean there's no
    # packages up
    echo "WARNING: Could not find any versions to prune, exiting..."
    exit 0
fi

for version in ${versions_to_prune}; do
    (
        set -x
        anaconda remove --force ${CHANNEL}/${PKG}/${version}
    )
done
