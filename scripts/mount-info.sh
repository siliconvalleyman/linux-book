#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'mount-info.sh PATH' "$@"
require findmnt
findmnt -T "$1" -o TARGET,SOURCE,FSTYPE,OPTIONS
