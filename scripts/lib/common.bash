#!/usr/bin/env bash

# Shared helpers for entry points in scripts/.
fail() {
    local status=$1
    shift
    printf '%s\n' "$*" >&2
    exit "$status"
}

check_args() {
    local count=$1 usage=$2
    shift 2
    if [[ ${1:-} == --help && $# -eq 1 ]]; then
        printf 'Usage: %s\n' "$usage"
        exit 0
    fi
    [[ $# -eq $count ]] || fail 2 "Usage: $usage"
}

require() {
    local program
    for program in "$@"; do
        command -v "$program" >/dev/null || fail 127 "Missing dependency: $program"
    done
}

readable_file() {
    [[ -f $1 && -r $1 ]] || fail 2 "Expected a readable regular file: $1"
}

hostname_arg() {
    [[ $1 =~ ^[[:alnum:]][[:alnum:].-]*$ ]] || fail 2 'Expected a DNS hostname'
}

http_url() {
    [[ $1 =~ ^https?://[^/@?#[:space:]]+([/?#][^[:space:]]*)?$ ]] ||
        fail 2 'Expected an HTTP(S) URL without embedded credentials'
}

unit_arg() {
    [[ $1 =~ ^[a-zA-Z0-9_.@:-]+\.service$ ]] || fail 2 'Expected a .service unit'
}

percentage() {
    [[ $1 =~ ^(100|[1-9]?[0-9])$ ]] || fail 2 'Expected a limit from 0 to 100'
}

report_usage() {
    local path=$1 limit=$2 fields=$3 value
    value=$(LC_ALL=C df "$fields" -- "$path" | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
    [[ $value =~ ^[0-9]+$ ]] || fail 1 'Usage unavailable'
    printf '%s%% used (limit %s%%)\n' "$value" "$limit"
    (( value < limit ))
}

preview_output() {
    printf 'Source: %s\nNew output: %s\n' "$1" "$2"
}

cleanup_output() {
    rm -f -- "$temporary"
}

new_output() {
    local target=$1 directory=.
    if [[ $target == */* ]]; then
        directory=${target%/*}
        directory=${directory:-/}
    fi
    [[ -d $directory && ! -e $target && ! -L $target ]] || fail 2 'Output must be a new file in an existing directory'
    umask 077
    temporary=$(mktemp -- "$directory/.handbook-backup.XXXXXXXX") || fail 1 'Cannot stage backup'
    trap cleanup_output EXIT
}

archive_backup() {
    local source=$1 target=$2 source_path target_path
    [[ -d $source ]] || fail 2 'Expected a source directory'
    source_path=$(realpath -e -- "$source") || fail 1 'Cannot resolve source'
    target_path=$(realpath -m -- "$target") || fail 1 'Cannot resolve archive path'
    [[ $source_path != / && $target_path != "$source_path" && $target_path != "$source_path/"* ]] ||
        fail 2 'Keep the archive outside the source tree'
    new_output "$target"
    tar -czf "$temporary" -C "$source_path" .
    ln -T -- "$temporary" "$target"
}
