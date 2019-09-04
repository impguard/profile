#!/usr/bin/env bash

set -eu -o pipefail

PROFILE_ROOT="$HOME/.profile.d"
PROFILE_STAGING="$PROFILE_ROOT/staging"
PROFILE_INSTALL="$PROFILE_STAGING/install"
PLATFORM=$(uname)

########################################
# Helpers
########################################

RED='\033[0;31m'
GREEN='\033[0;32m'
CLEAR='\033[0m'

function log
{
  local message=$1
  echo -e "$GREEN$message$CLEAR"
}

function logerror
{
  local message=$1
  echo -e "$RED$message$CLEAR"
}

function pushd
{
  command pushd "$@" > /dev/null
}

function popd
{
  command popd > /dev/null
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

  if [ ! -d "$PROFILE_STAGING/$1" ]; then
    log "Nothing to install from $PROFILE_STAGING/$1"
    return
  fi

  for file in "$PROFILE_STAGING/$1"/*; do
    filename=$(basename "$file")

    mkdir -p "$PROFILE_INSTALL/$filename"
    pushd "$PROFILE_INSTALL/$filename"
    log "Running install: $file"
    $file || logerror "Install failed: $file"
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

  # Reset directories
  rm -rf "$PROFILE_STAGING"
  mkdir -p "$PROFILE_INSTALL"

  # Stage files
  stage Base
  stage "$PLATFORM"

  # Pre Install
  if [ -n "${NO_PRE_INSTALL:-}" ]; then
    log "NO_INSTALL set, not running pre install"
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

  log "Installation complete!"
}

function main
{
  local command="${1:-}"
  shift || help

  case "$command" in
    install)
      install "$@"
      ;;
    copy)
      NO_PRE_INSTALL=1 NO_POST_INSTALL=1 install "$@"
      ;;
    *)
      help
      ;;
  esac
}

main "$@"
