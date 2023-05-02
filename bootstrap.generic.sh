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
[[ ! -L .gitconfig ]] && ln -s ${SCRIPTDIR}/gitconfig .gitconfig
[[ ! -L .git-global-ignore ]] && ln -s ${SCRIPTDIR}/git-global-ignore .git-global-ignore
[[ ! -L .p10k.zsh ]] && ln -s ${SCRIPTDIR}/p10k.${BOOTSTRAP_OS}.zsh .p10k.zsh
[[ ! -L .tmux ]] && ln -s ${SCRIPTDIR}/tmux .tmux
[[ ! -L .tmux.conf ]] && ln -s ${SCRIPTDIR}/tmux.conf .tmux.conf
[[ ! -L .zpreztorc ]] && ln -s ${SCRIPTDIR}/zpreztorc .zpreztorc
[[ ! -L .zshrc ]] && ln -s ${SCRIPTDIR}/zshrc .zshrc
[[ ! -L ".zshrc.${BOOTSTRAP_OS}" ]] && ln -s ${SCRIPTDIR}/zshrc.${BOOTSTRAP_OS} .zshrc.${BOOTSTRAP_OS}
mkdir -p .config
cd .config
[[ ! -L nvim ]] && ln -s ${SCRIPTDIR}/config/nvim nvim
[[ ! -L kitty ]] && ln -s ${SCRIPTDIR}/config/kitty kitty
[[ ! -L foot ]] && ln -s ${SCRIPTDIR}/config/foot foot
cd ~
mkdir -p .cargo
cd .cargo
[[ ! -L config.toml ]] && ln -s $SCRIPTDIR/cargo-config.toml config.toml

# create links for custom scrips
echo
echo 'symlinking custom scripts'
cd ~
mkdir -p bin
cd bin
for f in $(find ${SCRIPTDIR}/bin -maxdepth 1 -type f); do
  [[ ! -L $(basename ${f}) ]] && ln -s ${f}
done
if [[ -d ${SCRIPTDIR}/bin/${BOOTSTRAP_OS} ]]; then
  for f in $(find ${SCRIPTDIR}/bin/${BOOTSTRAP_OS} -type f); do
    [[ ! -L $(basename ${f}) ]] && ln -s ${f}
  done
fi

# run os-specific shit
echo
echo "bootstrapping ${BOOTSTRAP_OS}"
${SCRIPTDIR}/bootstrap.${BOOTSTRAP_OS}.sh

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

TMP_TODO=
if [[ -f ${HOME}/tmp/bootstrap_TODO ]]; then
  TMP_TODO=$(cat ${HOME}/tmp/bootstrap_TODO)
  rm -f ${HOME}/tmp/bootstrap_TODO
fi

echo
echo
echo
echo "bootstrap done."
echo
echo "things to do manually:"
echo
echo "- install nord brave theme:"
echo "   - https://chrome.google.com/webstore/detail/nord/abehfkkfjlplnjadfcjiflnejblfmmpj?hl=en"
echo ${TMP_TODO}
