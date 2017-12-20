#!/usr/bin/env bash

source base-install.sh

cat <<'EOM'
Current limitations

- Expects homebrew already installed
- Assumes git already installed
- Assumes xcode-select already setup

OSX works strange in that bash_profile is sourced instead of bashrc.

(press ctrl-c to quit)

EOM

function setup_bash()
{
    local command
    command='/usr/local/bin/bash'

    if has_been_setup "$command" /etc/shells bash; then
        return 0
    fi

    brew install bash bash-completion
    echo 'test -f /usr/local/etc/bash_completion && . /usr/local/etc/bash_completion' >> ~/.bash_profile

    sudo sh -c "echo $command >> /etc/shells"
    chsh -s /usr/local/bin/bash
}

function setup_bash_profile()
{
    local command
    command="source $(pwd)/.bashrc"

    if has_been_setup "$command" ~/.bash_profile bash_profile; then
        return 0
    fi

    echo "$command" >> ~/.bash_profile
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
    echo 'Make sure you run :PluginInstall in vim!'
}

function setup_autojump()
{
    local command
    command="test -f /usr/local/etc/profile.d/autojump.sh && . /usr/local/etc/profile.d/autojump.sh"

    if has_been_setup "$command" ~/.bash_profile autojump; then
        return 0
    fi

    brew install autojump
    echo "$command" >> ~/.bash_profile
}

function setup_screen()
{
    local command
    command="source $(pwd)/.screenrc"

    if has_been_setup "$command" ~/.screenrc screen; then
        return 0
    fi

    brew install screen
    echo "$command" >> ~/.screenrc
    echo 'If you are using iTerm go to Preferences > Profiles > Terminal'
    echo 'and disable "Save lines to scrollback when an app status bar'
    echo 'is present."'
}

function setup_bake()
{
    local command
    command="test -f /usr/local/opt/bake/bin/bake-completion.sh && . /usr/local/opt/bake/bin/bake-completion.sh"

    if has_been_setup "$command" ~/.bash_profile bake; then
        return 0
    fi

    brew tap --full github/kyleburton https://github.com/kyleburton/homebrew-kyleburton.git
    brew install kyleburton/kyleburton/bake
    echo "$command" >> ~/.bash_profile
}

function setup_bake()
{
    if [ -f "$HOME/Code/bin/bake" ]; then
        echo 'bake already installed...skipping'
        return 0
    fi

    curl https://raw.githubusercontent.com/kyleburton/bake/master/bake > "$HOME/Code/bin/bake"
    chmod 755 "$HOME/Code/bin/bake"
}

ask_and_do 'Update bash?' 'setup_bash' 'Updating to latest version of bash'
ask_and_do 'Link .bash_profile?' 'setup_bash_profile' "Sourcing local .bashrc in ~/.bash_profile"
ask_and_do 'Setup vim?' 'setup_vim' 'Linking .vimrc and setting up Vundle'
ask_and_do 'Link .gitconfig?' "git config --global include.path $(pwd)/.gitconfig" "Including local .gitconfig in ~/.gitconfig"
ask_and_do 'Install jump?' 'setup_autojump' "Installing autojump"
ask_and_do 'Install shellcheck?' 'brew install shellcheck' 'Installing shellcheck'
ask_and_do 'Install screen?' 'setup_screen' "Installing screen and sourcing local .screenrc in ~/.screenrc"

ask_and_do 'Setup local code workspace' "mkdir -p $HOME/Code/bin" "Creating $HOME/Code/bin"
ask_and_do 'Setup bake?' 'setup_bake' "Loading bake into the local code bin at $HOME/Code/bin/bake"

ask_and_do 'Install iterm?' 'brew cask install iterm2' 'Installing iterm2'
ask_and_do 'Install chrome?' 'brew cask install google-chrome' 'Installing chrome'
ask_and_do 'Install docker?' 'brew cask install docker' 'Installing docker'
ask_and_do 'Install alfred?' 'brew cask install alfred' 'Installing alfred'
