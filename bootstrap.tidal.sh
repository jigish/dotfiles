#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

flatpak install flathub com.mastermindzh.tidal-hifi

cd $CURRDIR
