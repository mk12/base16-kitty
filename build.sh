#!/bin/bash

set -eufo pipefail

usage() {
    cat <<EOS
usage: $0 [-h]

Builds Base16 themes for base16-kitty, writing results to colors/.
EOS
}

die() {
    echo "$0: $*" >&2
    exit 1
}

main() {
    cd "$(dirname "$0")"
    if ! [[ -d build/schemes ]]; then
        die "build/schemes: directory not found (try './update.sh')"
    fi
    if ! command -v pybase16 &>/dev/null; then
        die "pybase16: command not found (try 'pip install pybase16-builder')"
    fi
    mkdir -p build/templates/kitty/templates
    cp templates/{config.yaml,default.mustache} build/templates/kitty/templates
    cd build
    rm -rf output
    pybase16 build -t kitty
    cd ..
    rm -rf colors
    mv build/output/kitty/colors .
}

while getopts "h" opt; do
    case $opt in
        h) usage; exit 0 ;;
        *) exit 1 ;;
    esac
done

main
