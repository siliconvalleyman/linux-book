#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 0 'swap-report.sh' "$@"
require swapon
swapon --show=NAME,TYPE,SIZE,USED,PRIO
