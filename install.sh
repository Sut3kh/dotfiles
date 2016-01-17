#!/usr/bin/env zsh

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

# change shell to zsh
chsh -s /bin/zsh
