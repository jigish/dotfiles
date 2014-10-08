#!/bin/bash

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

#sudo apt-get-repository ppa:keithw/mosh
sudo apt-get update
#sudo apt-get install -y mosh
sudo apt-get install -y perl curl wget ctags screen ngrep silversearcher-ag

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
ln -s $SCRIPTDIR/bashrc .bashrc
ln -s $SCRIPTDIR/bashrc.`uname` .bashrc.`uname`
if [[ -f .gitconfig ]]; then
  mv .gitconfig .gitconfig.old
fi
ln -s $SCRIPTDIR/gitconfig .gitconfig
ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
ln -s $SCRIPTDIR/tigrc .tigrc
ln -s $SCRIPTDIR/vim-config .vim
ln -s $SCRIPTDIR/zshrc .zshrc
ln -s $SCRIPTDIR/screenrc .screenrc
ln -s .vim/vimrc .vimrc
ln -s .vim/gvimrc .gvimrc
mkdir bin
cd bin
ln -s $SCRIPTDIR/z/z.sh

cd $CURRDIR

