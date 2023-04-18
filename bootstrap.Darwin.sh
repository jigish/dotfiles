#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

# Create Links
echo
echo "symlinking $(uname) dotfiles"
cd ~
[[ ! -L .slate.js ]] && ln -s $SCRIPTDIR/slate.js .slate.js
[[ ! -L .xvimrc ]] && ln -s $SCRIPTDIR/xvimrc .xvimrc
[[ ! -L .gvimrc ]] && ln -s .vim/gvimrc .gvimrc
mkdir -p bin
cd bin
[[ ! -L spotify ]] && ln -s $SCRIPTDIR/bin/spotify
[[ ! -L rebrew ]] && ln -s $SCRIPTDIR/bin/rebrew

# set up brew & pip
echo
echo "bootstrapping via brew"
$SCRIPTDIR/bootstrap.brew.sh

echo
echo "installing ruby"
mkdir -p ~/.rubies
[[ ! -d ~/.rubies/2.5.1 ]] && ruby-install --install-dir ${HOME}/.rubies/2.5.1 ruby 2.5.1

echo
echo "installing fonts"
cp $SCRIPTDIR/fonts/* ~/Library/Fonts/
