#!/usr/bin/env bash

function install
{
  app=$1
  echo brew install --cask "$app" || true
}

echo "No longer installing apps. Here is a sample set of apps:"

install google-chrome
install docker
install slack
install iterm2
install hammerspoon
