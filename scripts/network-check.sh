#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'network-check.sh URL' "$@"
require curl
http_url "$1"
curl --disable --proto '=http,https' --globoff --fail --silent --show-error \
    --max-time 10 --output /dev/null --write-out 'http=%{http_code} total=%{time_total}s\n' -- "$1"
