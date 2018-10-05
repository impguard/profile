#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

SCRIPT=$(basename "$0")
YES="no"

function usage() {
    cat <<EOM
Usage: ./$SCRIPT -[hy]

This script should help setup your environment to my liking!
EOM
    exit 2
}

while getopts "hy" opt; do
    case "$opt" in
        h)
            usage
            ;;
        y)
            YES="yes"
            ;;
    esac
done


function ask_permission()
{
    local message=$1

    if [ "$YES" == "yes" ]; then
        echo "$message [y/n] y" >&2
        echo "y"
    else
        read -p "$message [y/n] " reply
        echo $reply
    fi
}

function ask_and_do()
{
    local message=$1
    local action=$2
    local output=${3:-"$action"}

    local reply
    reply=$(ask_permission "$message")

    if [[ "$reply" =~ ^[Yy]$ ]]; then
        echo "$output"
        eval "$action"
    fi

    echo
}

function has_been_setup()
{
    local string=$1
    local file=$2
    local item=$3

    if grep "$string" "$file" &>/dev/null; then
        echo "$item already setup...skipping"
        return 0
    fi

    return 1
}
