#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# Update git submodules
echo
echo 'updating'
cd $SCRIPTDIR
git pull
git submodule update --init --recursive

$SCRIPTDIR/bootstrap.generic.sh

cd $CURRDIR
echo
echo 'done.'