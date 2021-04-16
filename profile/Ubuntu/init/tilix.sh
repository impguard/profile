#!/usr/bin/env bash

if [ ! -d /usr/share/tilix/schemes ]; then
  echo "Tilix is not installed, not installing theme."
  exit
fi

git clone git@github.com:MichaelThessel/tilix-gruvbox.git
sudo cp tilix-gruvbox/gruvbox-* /usr/share/tilix/schemes
