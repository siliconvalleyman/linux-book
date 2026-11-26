#!/usr/bin/env bash
set -euo pipefail

# Load shared argument checks and reporting functions.
# shellcheck source=scripts/lib/common.bash
source "${BASH_SOURCE[0]%/*}/lib/common.bash"
apply=false
case ${1:-} in
    --apply) apply=true; shift ;;
    --dry-run) shift ;;
esac
check_args 0 'system-update.sh [--dry-run|--apply]' "$@"
require apt-get
if [[ $apply != true ]]; then apt-get -s upgrade; exit; fi; [[ $EUID -eq 0 ]] || fail 2 'Run --apply as root'; apt-get update; apt-get upgrade
