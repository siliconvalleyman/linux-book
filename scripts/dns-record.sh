#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 2 'dns-record.sh HOST TYPE' "$@"
require dig

hostname_arg "$1"; [[ $2 =~ ^(A|AAAA|MX|TXT|NS|SOA)$ ]] || fail 2 'Unsupported record type'; dig +time=3 +tries=1 -q "$1" -t "$2"
