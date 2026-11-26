#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 0 'security-audit.sh' "$@"
require id ss
id; ss -H -lntu; if command -v getenforce >/dev/null; then getenforce; fi; if [[ -r /sys/module/apparmor/parameters/enabled ]]; then read -r apparmor < /sys/module/apparmor/parameters/enabled; printf 'AppArmor=%s\n' "$apparmor"; fi
