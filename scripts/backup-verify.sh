#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'backup-verify.sh ARCHIVE' "$@"
require tar gzip
readable_file "$1"; gzip -t -- "$1"; tar -tzf "$1"
