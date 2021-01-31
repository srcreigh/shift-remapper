#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No arguments supplied. Did you mean to specify a file?"
  echo
  echo "./install.sh FILE"
  exit 1
fi

cp "$1" ~/.config/karabiner/assets/complex_modifications
