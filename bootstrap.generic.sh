#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

. ${SCRIPTDIR}/config.sh

# setup prezto
echo
echo 'setting up prezto'
cd ~
[[ ! -d .zprezto ]] && git clone --recursive https://github.com/sorin-ionescu/prezto.git "${HOME}/.zprezto"
[[ ! -L .zlogin ]] && ln -s .zprezto/runcoms/zlogin .zlogin
[[ ! -L .zlogout ]] && ln -s .zprezto/runcoms/zlogout .zlogout
[[ ! -L .zprofile ]] && ln -s .zprezto/runcoms/zprofile .zprofile
[[ ! -L .zshenv ]] && ln -s .zprezto/runcoms/zshenv .zshenv
cd .zprezto
git pull
git submodule update --init --recursive
mkdir -p contrib
cd contrib
[[ ! -d fzf-tab ]] && git clone https://github.com/Aloxaf/fzf-tab
cd fzf-tab
git pull

# create links
echo
echo 'symlinking dotfiles'
cd ~
[[ ! -L .gitconfig ]] && ln -s $SCRIPTDIR/gitconfig .gitconfig
[[ ! -L .git-global-ignore ]] && ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
[[ ! -L .p10k.zsh ]] && ln -s $SCRIPTDIR/p10k.${BOOTSTRAP_OS}.zsh .p10k.zsh
[[ ! -L .tmux ]] && ln -s $SCRIPTDIR/tmux .tmux
[[ ! -L .tmux.conf ]] && ln -s $SCRIPTDIR/tmux.conf .tmux.conf
[[ ! -L .zpreztorc ]] && ln -s $SCRIPTDIR/zpreztorc .zpreztorc
[[ ! -L .zshrc ]] && ln -s $SCRIPTDIR/zshrc .zshrc
[[ ! -L ".zshrc.${BOOTSTRAP_OS}" ]] && ln -s $SCRIPTDIR/zshrc.${BOOTSTRAP_OS} .zshrc.${BOOTSTRAP_OS}
mkdir -p .config
cd .config
[[ ! -L nvim ]] && ln -s $SCRIPTDIR/config/nvim nvim
[[ ! -L kitty ]] && ln -s $SCRIPTDIR/config/kitty kitty

# create links for custom scrips
echo
echo 'symlinking custom scripts'
cd ~
mkdir -p bin
cd bin
[[ ! -L z.sh ]] && ln -s $SCRIPTDIR/z/z.sh
[[ ! -L edit ]] && ln -s $SCRIPTDIR/bin/edit

# run os-specific shit
echo
echo "bootstrapping ${BOOTSTRAP_OS}"
$SCRIPTDIR/bootstrap.${BOOTSTRAP_OS}.sh

# make code dir
mkdir -p ~/code

# run company-specific shit
if [ "$1" = "netflix" ]; then
  echo
  echo "bootstrapping netflix"
  cd ~
  [[ ! -d dotfiles-netflix ]] && git clone ssh://git@stash.corp.netflix.com:7999/~jigishp/dotfiles.git dotfiles-netflix
  cd dotfiles-netflix
  git pull
  ./bootstrap.sh
fi

cd $CURRDIR

echo
echo
echo
echo "bootstrap done."
echo
echo "things to do manually:"
echo
echo "1. install nord brave theme:"
echo "   - https://chrome.google.com/webstore/detail/nord/abehfkkfjlplnjadfcjiflnejblfmmpj?hl=en"
if [[ "${XDG_CURRENT_DESKTOP}" == "ubuntu:GNOME" ]]; then
  echo
  echo "2. install and configure gnome shell extensions:"
  echo "   - https://extensions.gnome.org/extension/1160/dash-to-panel/"
  echo "   - https://extensions.gnome.org/extension/3193/blur-my-shell/"
  echo "   - https://extensions.gnome.org/extension/4099/no-overview/"
  echo "   - https://extensions.gnome.org/extension/19/user-themes/"
  echo
  echo "3. configure dash-to-panel to top, size 24, hide app launcher and desktop, opacity 40%"
  echo
  echo -n "4. fix ulauncher hotkey for wayland by setting in "
  echo "Settings > Keyboard > Customize Shortcuts > Custom Shortcuts > + cmd ulauncher-toggle"
  echo
  echo "5. set ulauncher theme to nord"
  echo
  echo "6. set up shortcuts for ulauncher"
  echo
  echo "7. restart gnome session to pick up flatpak"
fi
