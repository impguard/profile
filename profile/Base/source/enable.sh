#!/usr/bin/env bash

function __enable_usage
{
  echo "usage: enable [-p]"
  echo
  echo "Initializes environments for specific languages. Pass no options to"
  echo "initialize all available."
  echo
  echo "Options:"
  echo "  -p Enables pyenv"
  echo "  -g Enables genv"
  echo "  -n Enables nodenv"
}


function __enable_python
{
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  echo "pyenv enabled"
}

function __enable_golang
{
  eval "$(goenv init -)"
  echo "goenv enabled"
}

function __enable_node
{
  eval "$(nodenv init -)"
  echo "nodenv enabled"
}

function en
{
  while getopts "phng" opt; do
    case "$opt" in
    h|/?)
      __enable_usage
      ;;
    p)
      __enable_python
      ;;
    g)
      __enable_golang
      ;;
    n)
      __enable_node
      ;;
    esac
  done

  if [ "$OPTIND" -eq 1 ]; then
    echo "Please pick one of node (n), golang (g), or python (p)"
  fi
}
