#!/usr/bin/env bash

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "tmux plugins already installed"
  return 0
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
