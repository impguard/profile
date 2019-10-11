#!/usr/bin/env bash

function __init_usage
{
  echo "usage: init [-p]"
  echo
  echo "Initializes environments for specific languages. Pass no options to"
  echo "initialize all available."
  echo
  echo "Options:"
  echo "  -p Enables pyenv"
}


function __init_python
{
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  echo "Python initialized"
}

function init
{
  while getopts "ph" opt; do
    case "$opt" in
    h|/?)
      __init_usage
      ;;
    p)
      __init_python
      ;;
    esac
  done

  if [ "$OPTIND" -eq 1 ]; then
    __init_python
  fi
}
