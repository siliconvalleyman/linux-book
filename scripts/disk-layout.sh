#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 0 'disk-layout.sh' "$@"
require lsblk
lsblk -o NAME,TYPE,SIZE,FSTYPE,UUID,MOUNTPOINTS
