#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

# install fzf
echo
echo "bootstrapping fzf"
${SCRIPTDIR}/bootstrap.fzf.sh

# create links
cd ~
mkdir -p bin
cd bin
[[ ! -L spotify ]] && ln -s ${SCRIPTDIR}/bin/spotify
[[ ! -L rebrew ]] && ln -s ${SCRIPTDIR}/bin/rebrew

# set up brew & pip
echo
echo "bootstrapping via brew"
${SCRIPTDIR}/bootstrap.brew.sh

echo
echo "installing fonts"
for f in $(find ${SCRIPTDIR}/fonts -type f); do
  cp ${f} ~/Library/Fonts/
done

echo
echo "installing kitty"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
  launch=n
