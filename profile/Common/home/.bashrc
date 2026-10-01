#!/usr/bin/env bash
# Interactive settings should not affect scripts or remote commands.
[[ $- == *i* ]] || return

export CODEPATH="${CODEPATH:-$HOME/code}"
for directory in "$HOME/.local/bin" "$HOME/.bin"; do
  case ":$PATH:" in *":$directory:"*) ;; *) export PATH="$directory:$PATH" ;; esac
done
if command -v nvim >/dev/null 2>&1; then export EDITOR=nvim; fi
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# Git distributions put the prompt helper in different locations.
if ! declare -F __git_ps1 >/dev/null; then
  for helper in /usr/lib/git-core/git-sh-prompt /usr/share/git/completion/git-prompt.sh /opt/homebrew/etc/bash_completion.d/git-prompt.sh /usr/local/etc/bash_completion.d/git-prompt.sh; do
    if [[ -r $helper ]]; then
      source "$helper"
      break
    fi
  done
fi
PS1='\n\[\e[32m\]\w'
if declare -F __git_ps1 >/dev/null; then PS1+=' \[\e[91m\]$(__git_ps1 "(%s)")'; fi
PS1+='\n\[\e[94m\]❯ \[\e[0m\] '
export GIT_PS1_SHOWDIRTYSTATE=true

HISTCONTROL=ignorespace:ignoredups:erasedups
HISTSIZE=100000
HISTFILESIZE=100000
shopt -s histappend
_profile_history() { history -a; history -n; }
# Preserve both array and string forms of PROMPT_COMMAND, without duplicates.
if [[ " $(declare -p PROMPT_COMMAND 2>/dev/null) " != *'_profile_history'* ]]; then
  PROMPT_COMMAND=(_profile_history "${PROMPT_COMMAND[@]}")
fi

if [[ $(uname -s) == Darwin ]]; then alias ls='ls -G'; else alias ls='ls --color=auto'; fi
alias hr='history -a; history -n'

# Local overrides run last. Empty directories and non-files are harmless.
for file in "$HOME"/.source/* "$HOME"/.bashrc.d/*; do
  [[ -f $file && -r $file ]] && source "$file"
done
unset file helper directory
