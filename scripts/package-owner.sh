#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'package-owner.sh PATH' "$@"
require dpkg-query
[[ $1 == /* ]] || fail 2 'Expected an absolute path'; dpkg-query -S -- "$1"
