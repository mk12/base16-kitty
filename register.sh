#!/bin/bash

set -eufo pipefail

usage() {
    cat <<EOS
usage: $0 PATH [NAME]

Registers PATH as a local Base16 scheme repository. It can infer the scheme name
if the directory is of the form base16-X-scheme. Otherwise, you can provide the
name explicitly.
EOS
}

main() {
    # Get the absolute path.
    local path=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
    local name
    if [[ $# -eq 2 ]]; then
        name=$2
    else
        name=${path##*/base16-}
        name=${name%/}
        name=${name%-scheme}
    fi
    cd "$(dirname "$0")"
    if [[ -f "local.yaml" ]]; then
        if grep -q "^$name:" "local.yaml"; then
            echo "warning: overwrite existing entry"
            sed -i '' "/^$name:/d" "local.yaml"
        fi
    fi
    echo "$name: $path" >> "local.yaml"
}

while getopts "h" opt; do
    case $opt in
        h) usage; exit 0 ;;
        *) exit 1 ;;
    esac
done
shift $((OPTIND-1))
if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage >&2
    exit 1
fi

main "$@"
