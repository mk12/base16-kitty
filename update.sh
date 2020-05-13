#!/bin/bash

set -eufo pipefail

readonly schemes_url='https://raw.githubusercontent.com/chriskempson/base16-schemes-source/master/list.yaml'

usage() {
    cat <<EOS
usage: $0 [-h]

Updates Base16 scheme repositories in ./build/schemes.
EOS
}

clone_repo() {
    local url=$1
    local name=${url##*/base16-}
    local name=${name%-scheme}
    local path="build/schemes/$name"
    echo "Cloning $url ..."
    git clone "$url" "$path" &
}

pull_repo() {
    local name=$1
    local path="build/schemes/$name"
    if [[ -z "$(git -C "$path" status -uno --porcelain)" ]]; then
        echo "Pulling $path ..."
        git -C "$path" pull &
    else
        printf "\x1b[33m%s\x1b[0m" \
            "WARNING: skipping update for $name (not clean)\n"
    fi
}

main() {
    cd "$(dirname "$0")"
    mkdir -p build/schemes

    if [[ -f "local.yaml" ]]; then
        while read -r name path; do
            name=${name%:}
            ln -sf "$path" "build/schemes/$name"
        done < "local.yaml"
    fi

    local to_clone=()
    local to_pull=()

    while read -r url; do
        local name=${url##*/base16-}
        local name=${name%-scheme}
        local path="build/schemes/$name"
        if [[ -d "$path" ]]; then
            to_pull+=("$name")
        else
            to_clone+=("$url")
        fi
    done < <(
        curl -L "$schemes_url" | awk '/^[^ ]+: https:\/\// { print $2; }'
    )

    for url in ${to_clone[@]+"${to_clone[@]}"}; do
        clone_repo "$url"
    done

    for name in ${to_pull[@]+"${to_pull[@]}"}; do
        pull_repo "$name"
    done

    wait
}

while getopts "h" opt; do
    case $opt in
        h) usage; exit 0 ;;
        *) exit 1 ;;
    esac
done

main
