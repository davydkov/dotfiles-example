#!/usr/bin/env zsh
# Description: hook for tmux-fastcopy to open files, that contain like + column references, in vscode

source ~/.functions

# if first argument is EDITOR, remove it from $@
if [[ $1 == "EDITOR" ]]; then
  shift
  open_in_nano $@
else
  open_in_vscode $@
fi
