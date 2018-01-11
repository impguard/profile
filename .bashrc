PS1='
\[\e[32m\]\w \[\e[91m\]$(__git_ps1 "(%s)")
\[\e[94m\]❯  '

# shellcheck disable=SC2034
GIT_PS1_SHOWDIRTYSTATE=true

############################################################
# Environment variables
############################################################

export CODEPATH=$HOME/Code
export EDITOR=vim
# Allows ignoring history by typing a space before a command
export HISTCONTROL=ignorespace
# Allows screen to automatically save history
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

############################################################
# Modify the PATH
############################################################

PATH=$PATH:$HOME/Code/bin

############################################################
# Useful helper functions
############################################################

function dzap() {
    docker rm -f "$1"
}

function dprune() {
    docker system prune
}
