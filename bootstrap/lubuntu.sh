#!/bin/bash

set -eux

apt upgrade
apt install git

read -p "Github Name : " name
read -p "Github Email: " email

git config --global user.name "$name"
git config --global user.email "$email"

mkdir -p code/github.com/impguard
pushd code/github.com/impguard
echo git clone git@github.com:impguard/profile.git
