#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


SCRIPT=$(basename "$0")
YES="no"

function usage() {
    cat <<EOM
Usage: ./$SCRIPT -[hy]

This script should help setup an archlinux environment to my liking.
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

    read -p "$message [y/n] " reply
    echo $reply
}

function ask_and_do()
{
    local message=$1
    local action=$2
    local output=${3:-"$action"}

    if [ "$YES" == "yes" ]; then
        echo "$output"
        eval "$action"
        return
    else
        local reply=$(ask_permission "$message")
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            echo "$output"
            eval "$action"
        fi
    fi

    echo
}

function setup_vim()
{
    local command="source $(pwd)/.vimrc"

    if grep "$command" ~/.vimrc &>/dev/null; then
        echo 'vim already setup...skipping'
        return 0
    fi

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "$command" >> ~/.vimrc
}

function setup_bashrc()
{
    local command="source $(pwd)/.bashrc"

    if grep "$command" ~/.bashrc &>/dev/null; then
        echo 'bash already setup...skipping'
        return 0
    fi

    echo source "$(pwd)/.bashrc" >> ~/.bashrc
}

function setup_autojump()
{
    echo 'ignoring setup currently until bashrc setup finished'
    return 0
    pacman -S autojump
    echo source /etc/profile.d/autojump.bash >> ~/.bashrc
}

cat <<'EOM'
Current limitations

- Expects packer already installed
- Expects docker already installed
- Expects git already installed

(press ctrl-c to quit)

EOM

ask_and_do 'Link .vimrc?' "setup_vim" "Sourcing local .vimrc in ~/.vimrc"
ask_and_do 'Link .gitconfig?' "git config --global include.path $(pwd)/.gitconfig" "Including local .gitconfig in ~/.gitconfig"
ask_and_do 'Link .bashrc?' 'setup_bashrc' "Sourcing local .bashrc in ~/.bashrc"
ask_and_do 'Install jump?' 'setup_autojump' "Installing autojump and sourcing in ~/.bashrc"
