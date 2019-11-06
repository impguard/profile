#!/usr/bin/env bash

############################################################
# Source files
############################################################

if [ -n "$(ls -A "$HOME/.bashrc.d/")" ]; then
  for file in "$HOME"/.bashrc.d/*; do
    # shellcheck disable=SC1090
    source "$file"
  done
fi

for file in "$HOME"/.source/*; do
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

PATH=$HOME/.bin/:$PATH

############################################################
# Setup env tools
############################################################

export GOENV_ROOT="$HOME/.bin/goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

export PYENV_ROOT="$HOME/.bin/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

############################################################
# Useful helper functions or aliases
############################################################

alias ls="ls --color"

function enable_python
{
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
}

function enable_go
{
  eval "$(goenv init -)"
}

function tmox
{
  local session=${1:-$(basename "$(pwd)" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')}

  tmux new-session -d -s "$session"
  tmux rename-window  -t "$session:0" editor
  tmux new-window -t "$session:1" -n admin
  tmux new-window -t "$session:2" -n build
  tmux new-window -t "$session:3" -n service
  tmux new-window -t "$session:4" -n database
  tmux new-window -t "$session:5" -n playground
  tmux new-window -t "$session:6" -n playground
  tmux new-window -t "$session:7" -n playground

  tmux select-window -t "$session:1"
  tmux select-window -t "$session:0"
  tmux attach-session -t "$session"
}
