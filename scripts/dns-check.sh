#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'dns-check.sh HOST' "$@"
require getent
hostname_arg "$1"; getent ahosts "$1"
