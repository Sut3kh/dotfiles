#!/bin/zsh

# colours are cool
autoload -U colors
colors

# exit on fail
set -e

DOTDIR=${ZDOTDIR:-$HOME}

##
# init dotfiles installation (create .my-dotfiles.env) from $DOTFILES_INSTALLDIR
##
function dotfiles_init()
{
  # create .env
  echo "installing dotfiles into $DOTFILES_INSTALLDIR"
  echo "DOTFILES_INSTALLDIR=$DOTFILES_INSTALLDIR" > "$DOTDIR/.my-dotfiles.env"
}

##
# create a symlink (if the path doesnt already exist)
##
function lnsafe()
{
  # if symlink exists but points to a directory, symlink would be added inside
  if [[ -e $2 ]]; then
    echo "$fg[magenta]WARNING:$reset_color $2 already exists"
  else
    echo "linking $2 -> $1"
    ln -s $1 $2
  fi
}

##
# Main
##

# allow local install path (i.e. for dev)
if [[ $1 = '--local' ]]; then
  DOTFILES_INSTALLDIR="$(cd "$(dirname "$0")"; pwd -P)"
  dotfiles_init
# check for existing installation
elif [[ -f "$DOTDIR/.my-dotfiles.env" ]]; then
  source "$DOTDIR/.my-dotfiles.env"
# init
else
  DOTFILES_INSTALLDIR=${DOTFILES_INSTALLDIR:-$DOTDIR/.my-dotfiles}
  dotfiles_init

  # clone if needed
  if [[ ! -d $DOTFILES_INSTALLDIR ]]; then
    git clone git@github.com:Sut3kh/dotfiles.git "$DOTFILES_INSTALLDIR"
  fi

  # ensure submodules are installed
  cd "$DOTFILES_INSTALLDIR"
  git submodule update --init --recursive
fi

# work from home
cd "$DOTDIR"

# allow fail
set +e

# install prezto
echo "installing prezto"
lnsafe "$DOTFILES_INSTALLDIR"/prezto "$DOTDIR/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "$DOTFILES_INSTALLDIR"/prezto/runcoms/^README.md(.N); do
  lnsafe "$rcfile" "$DOTDIR/.${rcfile:t}"
done

# install runcoms
echo "installing runcoms"
for rcfile in "$DOTFILES_INSTALLDIR"/links/*; do
  lnsafe "$rcfile" "$DOTDIR/.${rcfile:t}"
done

# set git config
git config --global core.excludesfile ~/.gitignore_global

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
