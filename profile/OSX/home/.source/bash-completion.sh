#!/usr/bin/env bash

# bash completions
if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then
  source "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

# git completions
if [ -d /opt/homebrew/etc/bash_completion.d ]; then
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
  source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
fi

# tmux completion
if [ -d /opt/homebrew/etc/bash_completion.d ]; then
  source /opt/homebrew/etc/bash_completion.d/tmux
fi

# docker completion
if [ -d /opt/homebrew/etc/bash_completion.d ]; then
  source /opt/homebrew/etc/bash_completion.d/docker
  # source /opt/homebrew/etc/bash_completion.d/docker-compose
fi

# Homebrew
if [ -d /opt/homebrew/etc/bash_completion.d ]; then
  source /opt/homebrew/etc/bash_completion.d/brew
fi
