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
if [[ -f ${SCRIPTDIR}/bootstrap.${LINUX_DISTRO}.sh ]]; then
  echo "bootstrapping ${LINUX_DISTRO}"
  ${SCRIPTDIR}/bootstrap.${LINUX_DISTRO}.sh
else
  echo "don't know how to bootstrap ${LINUX_DISTRO}: no bootstrap.${LINUX_DISTRO}.sh" >&2
  exit 1
fi

cd ${CURRDIR}