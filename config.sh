#!/bin/bash

CURRDIR=`pwd`

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

SCRIPTDIR=$(cd `dirname $0` && pwd)

# Make Command-T
cd vim-config/bundle/command-t/ruby/command-t
ruby extconf.rb
make

cd $SCRIPTDIR

# Create Links
cd ~
ln -s $SCRIPTDIR/bashrc .bashrc
ln -s $SCRIPTDIR/gitconfig .gitconfig
ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
ln -s $SCRIPTDIR/tigrc .tigrc
ln -s $SCRIPTDIR/vim-config .vim
ln -s .vim/vimrc .vimrc
ln -s .vim/gvimrc .gvimrc
if [[ "$1" == "-ooyala" ]] ; then
  ln -s $SCRIPTDIR/ooyala/bashrc.ooyala .bashrc.ooyala
fi

# Copy iTerm2 Configs
cp $SCRIPTDIR/iterm2-config/com.googlecode.iterm2.plist ~/Library/Preferences/

cd $CURRDIR
