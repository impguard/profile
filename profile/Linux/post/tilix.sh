#!/usr/bin/env bash

git clone git@github.com:MichaelThessel/tilix-gruvbox.git
sudo cp tilix-gruvbox/gruvbox-* /usr/share/tilix/schemes
rm -rf tilix-gruvbox
