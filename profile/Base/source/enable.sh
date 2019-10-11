#!/usr/bin/env bash

function __enable_python
{
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  echo "Python enabled"
}

function enable
{
  while getopts "ph?" opt; do
    case "$opt" in
    h)
      echo "usage: enable [-p]"
      echo
      echo "Enables environments for specific languages. Pass no options to"
      echo "enable all available."
      echo
      echo "Options:"
      echo "  -p Enables pyenv"

      return 0
      ;;
    p)
      __enable_python
      ;;
    \?)
      __enable_python
      ;;
    esac
  done
}
