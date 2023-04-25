#!/bin/bash

set -eo pipefail


CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# create links
cd ~
echo
echo "installing fonts"
mkdir -p ~/.fonts
mkdir -p ~/.local/share/fonts
cp $SCRIPTDIR/fonts/*.ttf ~/.fonts/
cp $SCRIPTDIR/fonts/*.otf ~/.fonts/
cp $SCRIPTDIR/fonts/*.ttf ~/.local/share/fonts/
cp $SCRIPTDIR/fonts/*.otf ~/.local/share/fonts/

# distro-specific boostrap
echo
echo "bootstrapping ${LINUX_DISTRO}"
$SCRIPTDIR/bootstrap.${LINUX_DISTRO}.sh

cd $CURRDIR
