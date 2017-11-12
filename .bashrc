PS1='
\[\e[32m\]\w \[\e[91m\]$(__git_ps1 "(%s)")
\[\e[94m\]❯  '

# shellcheck disable=SC2034
GIT_PS1_SHOWDIRTYSTATE=true

############################################################
# Useful helper functions
############################################################

function doczap() {
    docker rm -f $1
}