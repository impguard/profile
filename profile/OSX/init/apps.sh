#!/usr/bin/env bash

function install
{
  app=$1
  brew install --cask "$app" || true
}

install google-chrome
install docker
install slack
install iterm2
install hammerspoon
