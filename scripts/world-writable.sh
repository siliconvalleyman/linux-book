#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'world-writable.sh DIRECTORY' "$@"
require find realpath
[[ -d $1 ]] || fail 2 'Expected a directory'; directory=$(realpath -e -- "$1"); find "$directory" -xdev -type f -perm -0002 -print
