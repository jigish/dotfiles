#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# Update git submodules
if [[ -z ${NOUPDATE} ]]; then
  echo
  echo 'updating'
  cd $SCRIPTDIR
  git pull
  git submodule update --init --recursive
fi

echo
echo 'running bootstrap'
$SCRIPTDIR/bootstrap.generic.sh $1

cd $CURRDIR
echo
echo 'done.'
