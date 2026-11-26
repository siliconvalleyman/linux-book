#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'top-directories.sh PATH' "$@"
require du sort
[[ -d $1 ]] || fail 2 'Expected a directory'; du -xhd1 -- "$1" | sort -h
