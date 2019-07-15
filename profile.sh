#!/usr/bin/env bash

set -eu -o pipefail

PROFILE_ROOT="$HOME/.profile.d"
PROFILE_STAGING="$PROFILE_ROOT/staging"
PLATFORM=$(uname)

########################################
# Helpers
########################################

function log
{
  local message=$1
  local green='\033[0;32m'
  local clear='\033[0m'

  echo -e "$green$message$clear"
}

function stage
{
  local staging_dir="$PROFILE_ROOT/profile/$1/."
  if [ -d "$staging_dir" ]; then
    cp -vfrs "$PROFILE_ROOT/profile/$1/." "$PROFILE_STAGING"
  fi
}

function link_home
{
  log "Linking home files"
  cp -a "$PROFILE_STAGING/home/." "$HOME/"
}

function pre_install
{
  pushd "$PROFILE_STAGING"
  for file in "$PROFILE_STAGING"/pre/*; do
    log "Running pre-install: $file"
    $file
  done
  popd
}

function post_install
{
  pushd "$PROFILE_STAGING"
  for file in "$PROFILE_STAGING"/post/*; do
    log "Running post-install: $file"
    $file
  done
  popd
}

########################################
# Commands
########################################

function help
{
  echo "usage: ./profile [install|uninstall] <args>

  install
    Installs the profile based on your platform.
  "
  exit 1
}

function install
{
  echo "Installing profile"
  echo "  PROFILE_ROOT=$PROFILE_ROOT"
  echo "  PROFILE_STAGING=$PROFILE_STAGING"
  echo "  PLATFORM=$PLATFORM"

  # Ensure directories exist
  mkdir -p "$PROFILE_STAGING"

  # Stage files
  stage Base
  stage "$PLATFORM"

  # Pre Install
  if [ -n "${NO_POST_INSTALL:-}" ]; then
    log "NO_INSTALL set, not running post install"
  else
    pre_install
  fi

  # Copying home files
  if [ -n "${NO_HOME:-}" ]; then
    log "NO_HOME set, not copying to home dir"
  else
    link_home
  fi

  # Post Install
  if [ -n "${NO_POST_INSTALL:-}" ]; then
    log "NO_INSTALL set, not running post install"
  else
    post_install
  fi
}

function main
{
  local command="${1:-}"
  shift || help

  case "$command" in
    install)
      install "$@"
      ;;
    *)
      help
      ;;
  esac
}

main "$@"
