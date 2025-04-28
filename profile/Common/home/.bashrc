#!/usr/bin/env bash

############################################################
# Source files
############################################################

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

# Custom FZF command
export FZF_DEFAULT_COMMAND='ag --hidden --all-text --ignore .git -g ""'

# no duplicate entries and avoid history by typing a space before a command
export HISTCONTROL=ignorespace:ignoredups:erasedups

# Big history
export HISTSIZE=100000
export HISTFILESIZE=100000

# Append to history, don't overwrite
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

############################################################
# Modify the PATH
############################################################

# Add custom tools
PATH=$HOME/.bin:$PATH

############################################################
# Setup env tools
############################################################

export GOENV_ROOT="$HOME/.bin/goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

export PYENV_ROOT="$HOME/.bin/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export NODENV_ROOT="$HOME/.bin/nodenv"
export PATH="$NODENV_ROOT/bin:$PATH"

export JENV_ROOT="$HOME/.bin/jenv"
export PATH="$JENV_ROOT/bin:$PATH"

############################################################
# Useful helper functions or aliases
############################################################

alias ls="ls --color"
alias hr="history -a; history -c; history -r"

function tmox
{
  local session=${1:-$(basename "$(pwd)" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')}

  tmux new-session -d -s "$session"
  tmux rename-window  -t "$session:0" admin
  tmux new-window -t "$session:1" -n admin
  tmux new-window -t "$session:2" -n sandbox
  tmux new-window -t "$session:3" -n sandbox
  tmux new-window -t "$session:4" -n sandbox

  tmux select-window -t "$session:1"
  tmux attach-session -t "$session"
}

############################################################
# Riot Customizations
############################################################

export GOPRIVATE=*.riotgames.com
export VAULT_ADDR=https://vault.security.riotgames.io
alias run="./Taskfile"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
