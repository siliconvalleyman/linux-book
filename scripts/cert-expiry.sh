#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'cert-expiry.sh FILE' "$@"
require openssl
readable_file "$1"; openssl x509 -in "$1" -noout -enddate -checkend 2592000
