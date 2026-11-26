#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 0 'cgroup-summary.sh' "$@"
require cat
cat /proc/self/cgroup; if [[ -r /sys/fs/cgroup/cgroup.controllers ]]; then cat /sys/fs/cgroup/cgroup.controllers; fi
