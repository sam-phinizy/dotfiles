#!/usr/bin/env bash

pyenv-install-version() {
  pyenv install -l | gum filter | xargs pyenv install
}

pyenv-set-local() {
  pyenv versions | gum filter | xargs pyenv local
}

pyenv-create-venv() {
  local PYTHON_VERSION
  PYTHON_VERSION=$(pyenv versions --bare | gum filter)

  local VIRTUALENV_NAME
  VIRTUALENV_NAME=$(gum input)

  pyenv virtualenv "$PYTHON_VERSION" "$VIRTUALENV_NAME"
}

source ~/.dotfiles/tmux.sh

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
