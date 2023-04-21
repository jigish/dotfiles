#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo apt update
sudo apt install -y kodi

cd $CURRDIR
