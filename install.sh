#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

function usage() {
    cat <<'EOM'
Usage: ./install.sh

This script should install a variety of packages to set up a typical OSX
environment.
EOM
    exit 2
}

while getopts "h" opt; do
    case "$opt" in
        h)
            usage
            ;;
    esac
done

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
        echo "$action"
        eval "$action"
    fi
    echo
}

ask_and_do 'Install homebrew?'             '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
ask_and_do 'Upgrade zsh?'                  'brew install zsh zsh-completions'
ask_and_do 'Install oh-my-zsh?'            'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
ask_and_do 'Change to zsh?'                'chsh -s $(which zsh)'
ask_and_do 'Link .vimrc?'                  'ln -sf $(pwd)/.vimrc ~/.vimrc'
ask_and_do 'Link .zshrc?'                  'ln -sf $(pwd)/.zshrc ~/.zshrc'
ask_and_do 'Install docker?'               'brew cask install docker'
ask_and_do 'Install docker-compose?'       'brew install docker-compose'
ask_and_do 'Install git?'                  'brew install git'
ask_and_do 'Install hub?'                  'brew install hub'
ask_and_do 'Install hub completions?'      'mkdir ~/.zsh/completions && curl https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion > ~/.zsh/completions/'
