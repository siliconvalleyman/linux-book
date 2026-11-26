#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 2 'disk-monitor.sh PATH LIMIT' "$@"
require df awk
percentage "$2"; report_usage "$1" "$2" -P
