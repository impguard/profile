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

############################################################
# Modify the PATH
############################################################

PATH=$PATH:$HOME/Code/bin

############################################################
# Useful helper functions
############################################################
