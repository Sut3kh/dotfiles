#!/usr/bin/env zsh

# exit on fail
set -e

DOTDIR=${ZDOTDIR:-$HOME}

# allow custom install path (i.e. dev)
if [[ $1 = '--local' ]]; then
  DOTFILES_INSTALLDIR="$(cd "$(dirname "$0")"; pwd -P)"
else
  DOTFILES_INSTALLDIR=${DOTFILES_INSTALLDIR:-$DOTDIR/.my-dotfiles}
fi

# work from home
cd "$DOTDIR"

# allow fail
set +e

# uninstall prezto
echo "uninstalling prezto"
setopt EXTENDED_GLOB
for rcfile in "$DOTFILES_INSTALLDIR"/prezto/runcoms/^README.md(.N); do
  f="$DOTDIR/.${rcfile:t}"
  # if exists
  if [[ -f $f ]]; then
    # if symlink
    if [[ -h $f ]]; then
      rm -v $f
    else
      echo "$f is a real boy and will not be removed."
    fi
  fi
done
