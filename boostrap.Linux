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
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/bashrc .bashrc
[[ ! -L .bashrc.`uname` ]] && ln -s $SCRIPTDIR/bashrc.`uname` .bashrc.`uname`
if [[ -f .gitconfig ]]; then
  mv .gitconfig .gitconfig.old
fi
[[ ! -L .gitconfig ]] && ln -s $SCRIPTDIR/gitconfig .gitconfig
[[ ! -L .git-global-ignore ]] && ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
[[ ! -L .tigrc ]] && ln -s $SCRIPTDIR/tigrc .tigrc
[[ ! -L .vim ]] && ln -s $SCRIPTDIR/vim-config .vim
[[ ! -L .zshrc ]] && ln -s $SCRIPTDIR/zshrc .zshrc
[[ ! -L .screenrc ]] && ln -s $SCRIPTDIR/screenrc .screenrc
[[ ! -L .vimrc ]] && ln -s .vim/vimrc .vimrc
mkdir -p bin
cd bin
[[ ! -L z.sh ]] && ln -s $SCRIPTDIR/z/z.sh

cd $CURRDIR
