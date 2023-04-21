#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

flatpak install -y flathub com.mastermindzh.tidal-hifi

cd $CURRDIR
