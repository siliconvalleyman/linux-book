#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
preview=false
if [[ ${1:-} == --dry-run ]]; then
    preview=true
    shift
fi
check_args 2 'backup.sh [--dry-run] SOURCE ARCHIVE' "$@"
if [[ $preview == true ]]; then
    preview_output "$1" "$2"
    exit 0
fi
require tar realpath mktemp ln rm
archive_backup "$1" "$2"
