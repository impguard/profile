#!/usr/bin/env bash

PATH=$HOME/.bin:$HOME/.local/bin:$PATH

function tmox
{
  local session=${1:-$(basename "$(pwd)" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')}

  tmux new-session -d -s "$session"
  tmux rename-window  -t "$session:0" editor
  tmux new-window -t "$session:1" -n admin
  tmux new-window -t "$session:2" -n build
  tmux new-window -t "$session:3" -n service
  tmux new-window -t "$session:4" -n database
  tmux new-window -t "$session:5" -n playground
  tmux new-window -t "$session:6" -n playground
  tmux new-window -t "$session:7" -n playground

  tmux select-window -t "$session:1"
  tmux select-window -t "$session:0"
  tmux attach-session -t "$session"
}
