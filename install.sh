#!/bin/zsh

# colours are cool
autoload -U colors
colors

# exit on fail
set -e

DOTDIR=${ZDOTDIR:-$HOME}

# allow custom install path (i.e. dev)
if [[ $1 = '--local' ]]; then
  DOTFILES_INSTALLDIR="$(cd "$(dirname "$0")"; pwd -P)"
else
  DOTFILES_INSTALLDIR=${DOTFILES_INSTALLDIR:-$DOTDIR/.my-dotfiles}
  git clone git@github.com:Sut3kh/dotfiles.git "$DOTFILES_INSTALLDIR"
fi

# ensure submodules are installed
cd "$DOTFILES_INSTALLDIR"
git submodule update --init --recursive

# work from home
cd "$DOTDIR"

# allow fail
set +e

# install prezto
echo "installing prezto"
setopt EXTENDED_GLOB
for rcfile in "$DOTFILES_INSTALLDIR"/prezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "$DOTDIR/.${rcfile:t}"
done

# install runcoms
echo "installing runcoms"
for rcfile in "$DOTFILES_INSTALLDIR"/links/*; do
  f="$DOTDIR/.${rcfile:t}"

  # if symlink exists but points to a directory, a symlink will be added inside
  # recursively
  if [[ -h "$f" ]]; then
    echo "$f already exists"
  else
    ln -s "$rcfile" "$f"
  fi
done

# change shell to zsh
chsh -s /bin/zsh

# osx only
if [[ $OSTYPE = darwin* ]]; then
  # run osx script (needs to be the last command as it will exit terminal)
  echo
  read "REPLY?Would you like to run the osx setup script?
$fg_bold[red]WARNING:$reset_color terminal and other applications will exit on completion! (y/n):";
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		"$DOTFILES_INSTALLDIR"/scripts/osx.sh
	fi;
fi
