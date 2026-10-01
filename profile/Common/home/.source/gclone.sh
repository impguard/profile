#!/usr/bin/env bash

function gclone
{
  local repo=${1:-} proj url host user
  proj=$(basename "$repo" .git)

  if [[ "$repo" == https* ]]; then
    url=${repo#https://}
    host=$(echo "$url" | cut -d'/' -f1)
    user=$(echo "$url" | cut -d'/' -f2)

    mkdir -p "$CODEPATH/$host/$user"
    git clone "$repo" "$CODEPATH/$host/$user/$proj" || return
    cd "$CODEPATH/$host/$user/$proj" || return

  elif [[ "$repo" == git* ]]; then
    host=$(echo "$repo" | cut -d'@' -f2 | cut -d':' -f1)
    user=$(echo "$repo" | cut -d':' -f2 | cut -d'/' -f1)

    mkdir -p "$CODEPATH/$host/$user"
    git clone "$repo" "$CODEPATH/$host/$user/$proj" || return
    cd "$CODEPATH/$host/$user/$proj" || return

  else
    echo "Invalid git URL passed"
    return 1
  fi
}
