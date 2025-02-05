#!/bin/bash

set -eu

run() {
    echo >&2 "$*"
    "$@"
}

if [ $# -lt 1 ]; then
    cat >&2 <<EOM
usage: $0 HOST

For example:
    $0 foo

EOM
    exit 1
fi

host="$1"

run sudo scutil --set HostName "$host.local"
run sudo scutil --set LocalHostName "$host"
run sudo scutil --set ComputerName "$host"
run dscacheutil -flushcache
