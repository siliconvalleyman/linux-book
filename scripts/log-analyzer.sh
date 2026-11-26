#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'log-analyzer.sh FILE' "$@"
require awk

readable_file "$1"; awk '{ for (i=1;i<=NF;i++) if ($i ~ /^(INFO|WARN|ERROR)$/) { count[$i]++; break } } END {printf "INFO=%d WARN=%d ERROR=%d\n", count["INFO"], count["WARN"], count["ERROR"]}' < "$1"
