#!/usr/bin/env bash

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

brew install \
  neovim \
  autojump \
  shellcheck \
  bash-completion@2 \
  tmux \
  || true

# Setup homebrew source
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.source/homebrew.bash
