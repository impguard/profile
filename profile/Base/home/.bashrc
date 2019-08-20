#!/usr/bin/env bash

############################################################
# Source files
############################################################

if [ ! -z "$(ls -A "$HOME/.bashrc.d/")" ]; then
  for file in "$HOME"/.bashrc.d/*; do
    # shellcheck disable=SC1090
    source "$file"
  done
fi

for file in "$HOME"/.profile.d/staging/source/*; do
  # shellcheck disable=SC1090
  source "$file"
done

############################################################
# Environment variables
############################################################

export PS1='
\[\e[32m\]\w \[\e[91m\]$(__git_ps1 "(%s)")
\[\e[94m\]❯  '

export GIT_PS1_SHOWDIRTYSTATE=true

export CODEPATH=$HOME/code
export EDITOR=nvim

# Allows ignoring history by typing a space before a command
export HISTCONTROL=ignorespace

# Customizes what files fzf finds
export FZF_DEFAULT_COMMAND='ag -g "" --hidden --ignore "node_modules|.git"'

############################################################
# Modify the PATH
############################################################

PATH=$PATH:$HOME/bin

############################################################
# Useful helper functions or aliases
############################################################

alias ls="ls --color"

function devpy {
  eval "$(pyenv init -)"
}
