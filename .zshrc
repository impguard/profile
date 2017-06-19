# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

############################################################
# HOMEBREW CHANGES
############################################################

# Homebrew path
export PATH=/usr/local/bin:$PATH

############################################################
# SETTINGS
############################################################

export EDITOR='/usr/local/bin/vim'

# Completion settings
setopt complete_aliases # Complete aliases
setopt always_to_end    # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word # allow completion from within a word/phrase
setopt correct          # spelling correction for commands
setopt list_ambiguous   # complete as much of a completion until it gets ambiguous

# Miscellaneous settings
setopt correct          # try to correct spelling of commands

unsetopt beep           # no bell on error
unsetopt list_beep      # no bell on ambiguous completion
unsetopt rm_star_silent # ask for confirmation for `rm *' or `rm path/*'

############################################################
# COMPLETIONS
############################################################

fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit

############################################################
# PROMPT
############################################################

# Prompt
PROMPT='
%{$fg[green]%}%~%{$fg_bold[red]%} $(git_prompt_info)%{$reset_color%}
%{$fg[blue]%}❯ '

ZSH_THEME_GIT_PROMPT_PREFIX="( "
ZSH_THEME_GIT_PROMPT_SUFFIX=" )"
ZSH_THEME_GIT_PROMPT_DIRTY=" ✖"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"

############################################################
# PLUGINS
############################################################

# Automatically load antigen
source ~/.scripts/antigen.zsh

# Syntax Hilighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Bundle autojump
antigen bundle robbyrussell/oh-my-zsh plugins/autojump

# A lot of autocompletions
antigen bundle zsh-users/zsh-completions src

antigen apply

############################################################
# SHIMS
############################################################

eval "$(hub alias -s)"                  # hub

function enable_pyenv() {
    if ! type pyenv >/dev/null 2>&1; then
        echo 'Install pyenv with: "brew install pyenv pyenv-virtualenv"'
        exit 1
    fi

    eval "$(pyenv init -)"                  # pyenv
    eval "$(pyenv virtualenv-init -)"       # pyenv-virtualenv
}

function enable_nvm() {
    if ! type nvm >/dev/null 2>&1; then
        echo 'Install nvm with: "brew install nvm"'
        exit 1
    fi

    export NVM_DIR=~/.nvm                   # NVM
    . $(brew --prefix nvm)/nvm.sh
}

function enable_jenv() {
    if ! type jenv >/dev/null 2>&1; then
        echo 'Install jenv with: "brew install nvm"'
        exit 1
    fi

    eval "$(jenv init -)"                   # jenv
}

############################################################
# EXPORTED SYSTEM VARIABLES
############################################################

############################################################
# UTIL ALIASES/FUNCTIONS
############################################################

# Simple way to start a static python webserver
alias makeserver="python -m SimpleHTTPServer"

# Short aliases
alias doc='docker'

# Easy function to kill and remove a docker container
function doczap() {
    docker rm -f $1
}
