#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'fd-usage.sh PID' "$@"
require find wc
[[ $1 =~ ^[1-9][0-9]*$ ]] || fail 2 'Expected a positive PID'; [[ -d /proc/$1/fd ]] || fail 1 'Process unavailable'; find "/proc/$1/fd" -mindepth 1 -maxdepth 1 -printf . | wc -c
