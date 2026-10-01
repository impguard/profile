#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install --no-install-recommends -y tilix

if [ ! -d /usr/share/tilix/schemes ]; then
  echo "Tilix is not installed, not installing theme."
  exit
fi

git clone https://github.com/MichaelThessel/tilix-gruvbox.git
sudo cp tilix-gruvbox/gruvbox-* /usr/share/tilix/schemes
