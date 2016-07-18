#!/usr/bin/env bash

ask_permission()
{
    local message=$1
    read -p "$message [y/n] " -n 1 reply
    echo $reply
}

ask_and_do()
{
    local message=$1
    local action=$2

    local reply=$(ask_permission "$message")
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        eval "$action"
    fi
    echo
}

ask_and_do "Link .vimrc?" "ln -sf $(pwd)/.vimrc ~/.vimrc"
