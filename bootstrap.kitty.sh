#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "installing kitty"
$SCRIPTDIR/bootstrap.kitty.$(uname).sh

cd $CURRDIR
