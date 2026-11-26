#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 0 'memory-pressure.sh' "$@"
require cat
[[ -r /proc/pressure/memory ]] || fail 1 'Memory PSI unavailable'; cat /proc/pressure/memory
