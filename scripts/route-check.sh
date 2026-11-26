#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
check_args 1 'route-check.sh IPV4' "$@"
[[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || fail 2 'Expected an IPv4 address'
IFS=. read -r -a octets <<< "$1"
for octet in "${octets[@]}"; do
    (( 10#$octet <= 255 )) || fail 2 'IPv4 octet exceeds 255'
done
require ip
ip route get "$1"
