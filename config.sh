#!/bin/bash

if [[ "$TERM_PROGRAM" == "iTerm.app" ]] ; then
  printf "\n> You appear to be running this script from within iTerm.app which could\n"
  printf "  overwrite your new preferences on quit.\n"
  printf "> Please quit iTerm and run this from Terminal.app or an SSH session.\n"
  printf "  Cheers.\n\n"
  exit 3
fi

if ps wwwaux | egrep -q 'iTerm\.app' >/dev/null ; then
  printf "\n> You appear to have iTerm.app currently running. Please quit the\n"
  printf "  application so your updates won't get overridden on quit.\n\n"
  exit 4
fi

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
if [[ "$1" == "-ooyala" ]] ; then
  ln -s $CURRDIR/ooyala/bashrc.ooyala .bashrc.ooyala
fi

# Copy iTerm2 Configs
cp $CURRDIR/iterm2-config/com.googlecode.iterm2.plist ~/Library/Preferences/

cd $CURRDIR
