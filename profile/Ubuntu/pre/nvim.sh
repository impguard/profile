#!/usr/bin/env bash

sudo apt update

sudo apt-get install --no-install-recommends -y software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/stable

sudo apt-get update

sudo apt-get install -y neovim
