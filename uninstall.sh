#!/bin/zsh

# colours are cool
autoload -U colors
colors

##
# remove a symlink (ignore real files)
##
function rmsym
{
  # if symlink exists
  if [[ -h "$1" ]]; then
    rm -v "$1"
  elif [[ -e "$1" ]]; then
    #statements
    echo "$fg_bold[red]WARNING:$fg_no_bold[red] $1 is a real boy and will not be removed.$reset_color"
  fi
}

##
# main
##

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
rmsym "$DOTDIR/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "$DOTFILES_INSTALLDIR"/prezto/runcoms/^README.md(.N); do
  rmsym "$DOTDIR/.${rcfile:t}"
done

# uninstall runcoms
echo "uninstalling runcoms"
for rcfile in "$DOTFILES_INSTALLDIR"/links/*; do
  rmsym "$DOTDIR/.${rcfile:t}"
done
