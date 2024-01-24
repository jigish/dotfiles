#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "running fzf install script"
$(brew --prefix)/opt/fzf/install

cd $CURRDIR
