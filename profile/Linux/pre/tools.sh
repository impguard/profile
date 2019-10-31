#!/usr/bin/env bash

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt install \
  build-essential \
  neovim \
  screen \
  autojump \
  shellcheck \
  silversearcher-ag \
  python3
