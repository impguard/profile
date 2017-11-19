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

function setup_vim()
{
    local command
    command="source $(pwd)/.vimrc"

    if has_been_setup "$command" ~/.vimrc vim; then
        return 0
    fi

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "$command" >> ~/.vimrc
}

function setup_bashrc()
{
    local command
    command="source $(pwd)/.bashrc"

    if has_been_setup "$command" ~/.bashrc bash; then
        return 0
    fi

    echo "$command" >> ~/.bashrc
}

function setup_autojump()
{
    local command
    command="source /etc/profile.d/autojump.bash"

    if has_been_setup "$command" ~/.bashrc autojump; then
        return 0
    fi

    sudo pacman -S autojump
    echo "$command" >> ~/.bashrc
}

function setup_screen()
{
    local command
    command="source $(pwd)/.screenrc"

    if has_been_setup "$command" ~/.screenrc screen; then
        return 0
    fi

    sudo pacman -S screen
    echo "$command" >> ~/.screenrc
}

function setup_codepath()
{
    mkdir -p $HOME/Code
}

function setup_codebin()
{
    local command
    command="export PATH=$PATH:$HOME/Code/bin"

    if has_been_setup "$command" ~/.bashrc codebin; then
        return 0
    fi

    mkdir -p $HOME/Code/bin
    echo "$command" >> ~/.bashrc
}

function setup_bake()
{
    curl https://raw.githubusercontent.com/kyleburton/bake/master/bake > $HOME/Code/bin/bake
    chmod 755 $HOME/Code/bin/bake
}

cat <<'EOM'
Current limitations

- Expects packer already installed
- Expects docker already installed
- Expects git already installed

(press ctrl-c to quit)

EOM

ask_and_do 'Update bash?' 'brew install bash' 'Updating bash to the latest version'
ask_and_do 'Link .vimrc?' "setup_vim" "Sourcing local .vimrc in ~/.vimrc"
ask_and_do 'Link .gitconfig?' "git config --global include.path $(pwd)/.gitconfig" "Including local .gitconfig in ~/.gitconfig"
ask_and_do 'Link .bashrc?' 'setup_bashrc' "Sourcing local .bashrc in ~/.bashrc"
ask_and_do 'Install shellcheck?' 'packer -S shellcheck' "Installing shellcheck with packer"
ask_and_do 'Install jump?' 'setup_autojump' "Installing autojump and sourcing in ~/.bashrc"
ask_and_do 'Install screen?' 'setup_screen' "Installing screen and sourcing local .screenrc in ~/.screenrc"

ask_and_do 'Setup local code workspace (Note: this is required for the following commands)?' 'mkdir -p $HOME/Code/bin' "Creating $HOME/Code/bin"
ask_and_do 'Setup bake?' 'setup_bake' "Loading bake into the local code bin at $HOME/Code/bin/bake"

echo 'Finished!'
