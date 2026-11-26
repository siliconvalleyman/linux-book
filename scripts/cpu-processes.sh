#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 0 'cpu-processes.sh' "$@"
require ps awk
ps -eo pid,pcpu,comm --sort=-pcpu | awk 'NR<=11'
