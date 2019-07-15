#!/usr/bin/env bash

set -eux

read -rp "Github Name : " name
read -rp "Github Email: " email

git config --global user.name "$name"
git config --global user.email "$email"

git clone git@github.com:impguard/profile.git "$HOME/.profile.d"

cd "$HOME/.profile.d"
./profile.sh install
