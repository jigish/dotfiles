#!/bin/bash

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

sudo apt-get install -y curl wget python-software-properties
sudo apt-get-repository ppa:keithw/mosh
sudo apt-get update
sudo apt-get install -y mosh

# Update git submodules
cd $SCRIPTDIR
git submodule update --init
git submodule foreach checkout master
cd vim-config
git submodule update --init

# Create Links
cd ~
mv .bashrc .bashrc.old
ln -s $SCRIPTDIR/bashrc .bashrc
ln -s $SCRIPTDIR/bashrc.`uname` .bashrc.`uname`
ln -s $SCRIPTDIR/gitconfig .gitconfig
ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
ln -s $SCRIPTDIR/tigrc .tigrc
ln -s $SCRIPTDIR/vim-config .vim
ln -s $SCRIPTDIR/slate.js .slate.js
ln -s $SCRIPTDIR/zshrc .zshrc
ln -s $SCRIPTDIR/screenrc .screenrc
ln -s .vim/vimrc .vimrc
ln -s .vim/gvimrc .gvimrc
cd bin
ln -s $SCRIPTDIR/z/z.sh
if [[ "$1" == "-ooyala" ]] ; then
  git clone ssh://git@git.corp.ooyala.com/users/jigish dotfiles-ooyala
  cd ~
  ln -s dotfiles-ooyala/bashrc.ooyala .bashrc.ooyala
  ln -s dotfiles-ooyala/screenrc.cybertron.prod .screenrc.cybertron.prod
  ln -s dotfiles-ooyala/screenrc.cybertron.dev .screenrc.cybertron.dev
fi

cd $CURRDIR

