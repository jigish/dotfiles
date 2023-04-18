#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

if [[ ! -d ~/.fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
else
  cd ~/.fzf
  git pull
fi

echo
echo "running fzf install script"
~/.fzf/install --all

cd $CURRDIR
