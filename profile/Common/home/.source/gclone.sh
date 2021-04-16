#!/usr/bin/env bash

function gclone
{
  repo="$1"
  proj=$(basename "$repo" .git)

  if [[ "$repo" == https* ]]; then
    url=${repo#https://}
    host=$(echo "$url" | cut -d'/' -f1)
    user=$(echo "$url" | cut -d'/' -f2)

    mkdir -p "$CODEPATH/$host/$user"
    git clone "$repo" "$CODEPATH/$host/$user/$proj"
    cd "$CODEPATH/$host/$user/$proj" || exit

  elif [[ "$repo" == git* ]]; then
    host=$(echo "$repo" | cut -d'@' -f2 | cut -d':' -f1)
    user=$(echo "$repo" | cut -d':' -f2 | cut -d'/' -f1)

    mkdir -p "$CODEPATH/$host/$user"
    git clone "$repo" "$CODEPATH/$host/$user/$proj"
    cd "$CODEPATH/$host/$user/$proj" || exit

  else
    echo "Invalid git URL passed"
  fi
}
