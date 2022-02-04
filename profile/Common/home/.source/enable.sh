#!/usr/bin/env bash

function __enable_usage
{
  echo "usage: enable [p]"
  echo
  echo "Initializes environments for specific languages. Pass no options to"
  echo "initialize all available."
  echo
  echo "Options:"
  echo "  p Enables pyenv"
  echo "  g Enables genv"
  echo "  n Enables nodenv"
  echo "  j Enables jenv"
}


function __enable_python
{
  eval "$(pyenv init --path)
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

function __enable_java
{
  eval "$(jenv init -)"
  echo "jenv enabled"
}

function en
{
  while getopts "h" opt; do
    case "$opt" in
    h|/?)
      __enable_usage
      ;;
    esac
  done

  shift $((OPTIND - 1))

  case "${1:-}" in
    p|py|python)
      __enable_python
      return
      ;;
    g|go|golang)
      __enable_golang
      return
      ;;
    n|node)
      __enable_node
      return
      ;;
    j|java)
      __enable_java
      return
      ;;
  esac

  echo "Please pick one of node (n), golang (g), or python (p), or java (j)"
}
