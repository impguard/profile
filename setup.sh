#!/usr/bin/env bash

set -eux

read -p "Github Name : " name
read -p "Github Email: " email

git config --global user.name "$name"
git config --global user.email "$email"

git clone git@github.com:impguard/profile.git "$HOME/.profile.d"

cd "$HOME/.profile.d"
./profile.sh install
