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
check_args 2 'database-backup.sh [--dry-run] DATABASE ARCHIVE' "$@"
if [[ $preview == true ]]; then
    preview_output "$1" "$2"
    exit 0
fi
require pg_dump mktemp ln rm

[[ $1 =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || fail 2 'Expected a simple database name'; new_output "$2"; pg_dump --format=custom --file="$temporary" --dbname="$1"; ln -T -- "$temporary" "$2"
