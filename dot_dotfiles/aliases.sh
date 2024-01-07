#!/usr/bin/env bash

quick-open() {
  local FOLDER
  local EDIT

  FOLDER=$(find "$HOME/src" -name .git -type d -prune | choose -f / 0:-2 | tr ' ' '/' | gum filter)

  echo "CD into $FOLDER"
  cd "/$FOLDER"

  EDIT=$(gum choose pycharm code nvim)

  eval "$EDIT ."
}

alias qo=quick-open
alias masked-email="op run -- masked-email"

alias brew-remove="brew list -1 | \
  fzf --multi --bind space:toggle-down \
  --header 'Press SPACE to select. Enter to run uninstall' \
  --bind q:close \
  --reverse --preview \"brew info {}\" \
  | xargs brew uninstall"
