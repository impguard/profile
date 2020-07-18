#!/usr/bin/env bash

if [ -d "$HOME/.bin/tmux/bin" ]; then
  echo "Tmux already installed"
  exit 0
fi

# Install dependencies
sudo apt install libevent-dev

# Download source
curl -L https://github.com/tmux/tmux/releases/download/3.1/tmux-3.1.tar.gz -o tmux-3.1.tar.gz

# Install tmux

mkdir -p ~/.bin/tmux
tar -C ~/.bin/tmux -zxf tmux-*.tar.gz
# shellcheck disable=2164
cd ~/.bin/tmux/tmux-*/
./configure --prefix "$PWD/../"
make && sudo make install
