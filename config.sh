#!/bin/bash

CURRDIR=pwd

# Make Command-T
cd vim-config/bundle/command-t/ruby/command-t
ruby extconf.rb
make

cd $CURRDIR

# Create Links
cd ~
ln -s $CURRDIR/bashrc .bashrc
ln -s $CURRDIR/gitconfig .gitconfig
ln -s $CURRDIR/git-global-ignore .git-global-ignore
ln -s $CURRDIR/tigrc .tigrc
ln -s $CURRDIR/vim-config .vim
ln -s .vim/vimrc .vimrc
ln -s .vim/gvimrc .gvimrc

cd $CURRDIR
