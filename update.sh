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

# Update git submodules
cd $SCRIPTDIR
git pull
echo "updating submodules in `pwd`"
git submodule update
cd vim-config
echo "updating submodules in `pwd`"
git submodule update

# Make Command-T
cd $SCRIPTDIR/vim-config/bundle/command-t/ruby/command-t
ruby extconf.rb
make

# Create Links
cd ~
[[ ! -L .bashrc ]] && ln -s $SCRIPTDIR/bashrc .bashrc
[[ ! -L .gitconfig ]] && ln -s $SCRIPTDIR/gitconfig .gitconfig
[[ ! -L .git-global-ignore ]] && ln -s $SCRIPTDIR/git-global-ignore .git-global-ignore
[[ ! -L .tigrc ]] && ln -s $SCRIPTDIR/tigrc .tigrc
[[ ! -L .vim ]] && ln -s $SCRIPTDIR/vim-config .vim
[[ ! -L .slate ]] && ln -s $SCRIPTDIR/slate.js .slate.js
[[ ! -L .zshrc ]] && ln -s $SCRIPTDIR/zshrc .zshrc
[[ ! -L .vimrc ]] && ln -s .vim/vimrc .vimrc
[[ ! -L .gvimrc ]] && ln -s .vim/gvimrc .gvimrc
cd bin
[[ ! -L z.sh ]] && ln -s $SCRIPTDIR/z/z.sh
if [[ "$1" == "-ooyala" ]] ; then
  cd ~/dotfiles-ooyala
  git pull
  cd ~
  [[ ! -L .bashrc.ooyala ]] && ln -s dotfiles-ooyala/bashrc.ooyala .bashrc.ooyala
fi

# Copy iTerm2 Configs
cp $SCRIPTDIR/iterm2-config/com.googlecode.iterm2.plist ~/Library/Preferences/

cd $CURRDIR
