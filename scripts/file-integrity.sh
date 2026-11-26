#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 2 'file-integrity.sh FILE HASH' "$@"
require sha256sum

readable_file "$1"; [[ $2 =~ ^[[:xdigit:]]{64}$ ]] || fail 2 'Expected a SHA-256 digest'; actual=$(sha256sum < "$1"); [[ ${actual%% *} == "${2,,}" ]] || fail 1 'Checksum mismatch'; printf 'SHA-256 OK\n'
