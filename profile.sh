#!/usr/bin/env bash

set -eu -o pipefail

PROFILE_ROOT="$HOME/.profile.d"
PROFILE_STAGING="$PROFILE_ROOT/staging"
PROFILE_INSTALL="$PROFILE_STAGING/install"
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

function perform_install
{
  local filename

  for file in "$PROFILE_STAGING/$1"/*; do
    filename=$(basename "$file")

    mkdir -p "$PROFILE_INSTALL/$filename"
    pushd "$PROFILE_INSTALL/$filename"
    log "Running pre-install: $file"
    $file
    popd
  done
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
  mkdir -p "$PROFILE_INSTALL"

  # Stage files
  stage Base
  stage "$PLATFORM"

  # Pre Install
  if [ -n "${NO_POST_INSTALL:-}" ]; then
    log "NO_INSTALL set, not running post install"
  else
    perform_install pre
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
    perform_install post
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
