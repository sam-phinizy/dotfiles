#!/usr/bin/env bash

# For functions/aliases related to using tmux

tmux-smart-switch() {
  local SESSION
  SESSION=$1

  if [ -z "$2" ]; then
    if ! gum confirm "Switch to $SESSION"; then
      return 1
    fi
  fi
  if [ "${TERM_PROGRAM:-NOTTMUX}" = 'tmux' ]; then
    tmux switch-client -t "$SESSION"
  else
    tmux attach -t "$SESSION"
  fi

  return 0

}

tmux-picker() {
  local SESSION
  if tmux ls >/dev/null 2>&1; then
    SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
    tmux-smart-switch "$SESSION"
  else
    echo "No tmux sessions."

  fi
}
alias tswitch=tmux-picker

tmux-kill-session() {
  local SESSION
  while :; do
    if tmux ls >/dev/null 2>&1; then
      SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
      if [ "${TERM_PROGRAM:-NOTTMUX}" = 'TMUX' ]; then
        tmux kill-session -t "$SESSION"
      else
        tmux kill-session -t "$SESSION"
      fi
      echo "Killed $SESSION"
    else
      echo "No tmux sessions."
      return 0
    fi
    if ! gum confirm "Kill another"; then
      return 0
    fi
  done

}

alias tkill=tmux-kill-session

tmux-here() {
  local DIR

  if git status >/dev/null 2>&1; then
    DIR=$(git rev-parse --show-toplevel)
  else
    DIR=$(pwd)
  fi
  DIR=$(basename "$DIR")

  DIR=$(gum input --value "$DIR" --prompt "Name of session: ")

  if tmux ls | grep "$DIR"; then
    if gum confirm "$DIR already exists. Switch to it?"; then
      return "$(tmux-smart-switch "$DIR" "skip")"
    else
      return 0
    fi
  fi

  tmux new-session -d -s "$DIR"

  tmux-smart-switch "$DIR"

}

alias there=tmux-here
