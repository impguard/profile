#!/usr/bin/env bash

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt update

sudo apt-get install --no-install-recommends -y \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
  libxmlsec1-dev libffi-dev liblzma-dev

sudo apt install -y \
  neovim \
  screen \
  autojump \
  shellcheck \
  silversearcher-ag \
  python3 \
  pipenv
