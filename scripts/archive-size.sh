#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'archive-size.sh FILE' "$@"
require stat
readable_file "$1"; stat -c 'bytes=%s' -- "$1"
