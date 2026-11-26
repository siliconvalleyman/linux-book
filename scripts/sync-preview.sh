#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 2 'sync-preview.sh SOURCE DESTINATION' "$@"
require rsync
[[ -d $1 && -d $2 ]] || fail 2 'Expected two directories'; rsync -ani -- "${1%/}/" "${2%/}/"
