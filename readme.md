
Installation
-------------

**NOTE:** *Existing files such as .zshrc will be left alone and will need to be
removed for installation to work properly.*

- uninstall oh-my-zsh if installed (run `uninstall_oh_my_zsh`)
- `curl https://raw.githubusercontent.com/Sut3kh/dotfiles/master/install.sh | sh`
- run `dotfiles_apm-install` to install recommended atom modules

### Custom install path

- clone repo to desired location
- run `install.sh --local`

Uninstallation
---------------

**NOTE:** *Files not replaced by install might be removed if they are symlinks.*

- run uninstall.sh

Move Installation
------------------

```
$DOTFILES_INSTALLDIR/uninstall.sh
mv $DOTFILES_INSTALLDIR /new/installation/path
/new/installation/path/install.sh --local
```
