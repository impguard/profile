#!/usr/bin/env bash

# Install dependencies
sudo apt install libevent-dev

# Download source
curl -L https://github.com/tmux/tmux/releases/download/3.1/tmux-3.1.tar.gz -o tmux-3.1.tar.gz

# Install tmux

tar -zxf tmux-*.tar.gz
# shellcheck disable=2164
cd tmux-*/
./configure --prefix "$HOME/.bin"
make && sudo make install
