#!/bin/bash

set -e +o posix +o nounset || exit
root=${BASH_SOURCE%/*}/../..
readarray -t profiles < "${root}/helpers/profiles.mask"
[[ -e ${root}/profiles/package.mask ]] && echo "WARNING: profiles/package.mask exists"
IFS=, eval 'exec pkgcheck scan --exit=error "--profiles=${profiles[*]/#/-}"'
