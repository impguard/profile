#!/usr/bin/env bash

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

brew install \
  neovim \
  screen \
  autojump \
  shellcheck \
  the_silver_searcher \
  bash-completion \
  git \
  python \
  pyenv \
  || true
