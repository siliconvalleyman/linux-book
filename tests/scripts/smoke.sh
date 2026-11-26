#!/usr/bin/env bash
set -euo pipefail

# Exercise only temporary data and preview modes.
root=$(cd -- "${BASH_SOURCE[0]%/*}/../.." && pwd)
temporary=$(mktemp -d)
trap 'rm -rf -- "$temporary"' EXIT

run() {
    local name=$1
    shift
    bash "$root/scripts/$name.sh" "$@"
}

assert_status() {
    local expected=$1 status=0
    shift
    "$@" >/dev/null 2>&1 || status=$?
    if [[ $status != "$expected" ]]; then
        printf 'Expected status %s, got %s: %s\n' "$expected" "$status" "$*" >&2
        exit 1
    fi
}

for script in "$root"/scripts/*.sh; do
    bash -n "$script"
    bash "$script" --help | grep '^Usage: ' >/dev/null
    assert_status 2 bash "$script" invalid invalid invalid
done

test_data="$temporary/source data"
archive="$temporary/new archive.tar.gz"
mkdir -- "$test_data" "$temporary/restore"
printf 'fixture\n' > "$test_data/note.txt"
printf 'INFO ready\nERROR failed\nWARN retry\n' > "$temporary/app.log"

run backup --dry-run "$test_data" "$archive" >/dev/null
test ! -e "$archive"
assert_status 2 run backup "$test_data" "$test_data/inside.tar.gz"
run backup "$test_data" "$archive"
assert_status 2 run backup "$test_data" "$archive"
run backup-verify "$archive" >/dev/null
tar -xzf "$archive" -C "$temporary/restore"
cmp "$test_data/note.txt" "$temporary/restore/note.txt"
digest=$(sha256sum < "$test_data/note.txt")
run file-integrity "$test_data/note.txt" "${digest%% *}" | grep -Fx 'SHA-256 OK' >/dev/null
printf 'changed\n' >> "$test_data/note.txt"
assert_status 1 run file-integrity "$test_data/note.txt" "${digest%% *}"
test "$(run log-analyzer "$temporary/app.log")" = 'INFO=1 WARN=1 ERROR=1'
assert_status 1 run disk-monitor "$temporary" 0
assert_status 2 run disk-monitor "$temporary" 101
assert_status 2 run route-check --unknown
assert_status 2 run ssh-client-review -option
assert_status 2 run route-check 256.0.0.1
if command -v curl >/dev/null; then
    assert_status 2 run network-check 'https://operator@host.example/'
fi

run database-backup --dry-run labdb "$temporary/pg.dump" >/dev/null
test ! -e "$temporary/pg.dump"
printf 'Smoke tests passed.\n'
