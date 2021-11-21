#!/usr/bin/env bash

if [ -d "$HOME/.bin/tmux/bin" ]; then
  echo "Tmux already installed"
  exit 0
fi

# Install dependencies
sudo apt install -y libevent-dev

# Download source
curl -L https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz -o tmux-3.2a.tar.gz

# Install tmux

mkdir -p ~/.bin/tmux
tar -C ~/.bin/tmux -zxf tmux-*.tar.gz
# shellcheck disable=2164
cd ~/.bin/tmux/tmux-*/
./configure --prefix "$PWD/../"
make && sudo make install
