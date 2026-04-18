#!/usr/bin/env bash
# ~/dotfiles/install.sh
set -e
cd "$(dirname "$0")"
stow -R --no-folding */
