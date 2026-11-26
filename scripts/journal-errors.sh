#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'journal-errors.sh SERVICE' "$@"
require journalctl
unit_arg "$1"; journalctl -b -p err -n 30 --no-pager --unit="$1"
