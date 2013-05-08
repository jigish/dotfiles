#!/bin/bash

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

sudo apt-get install -y curl wget python-software-properties
sudo apt-get-repository ppa:keithw/mosh
sudo apt-get update
sudo apt-get install -y mosh

# Update git submodules
cd $SCRIPTDIR
git pull
git submodule update --init
cd vim-config
git submodule update --init

# Create Links
cd ~
if [[ -f .bashrc ]]; then
  mv .bashrc .bashrc.old
fi
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/bashrc .bashrc
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/bashrc.`uname` .bashrc.`uname`
if [[ -f .gitconfig ]]; then
  mv .gitconfig .gitconfig.old
fi
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/gitconfig .gitconfig
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/tigrc .tigrc
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/vim-config .vim
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/slate.js .slate.js
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/zshrc .zshrc
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/screenrc .screenrc
[[ ! -L .bashrc ]] && ln -s .vim/vimrc .vimrc
[[ ! -L .bashrc ]] && ln -s .vim/gvimrc .gvimrc
mkdir bin
cd bin
[[ ! -L z.sh ]] && ln -s $SCRIPTDIR/z/z.sh
if [[ "$1" == "-ooyala" ]] ; then
  cd ~/dotfiles-ooyala && git pull
  cd ~
  ln -s dotfiles-ooyala/bashrc.ooyala .bashrc.ooyala
  ln -s dotfiles-ooyala/screenrc.cybertron.prod .screenrc.cybertron.prod
  ln -s dotfiles-ooyala/screenrc.cybertron.dev .screenrc.cybertron.dev
fi

cd $CURRDIR

