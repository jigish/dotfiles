#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "running fzf install script"
$(brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc --no-zsh --no-bash --no-fish

cd $CURRDIR
