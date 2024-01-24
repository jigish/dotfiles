#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

# create links
mkdir -p ~/.config
cd ~/.config
[[ ! -L kitty ]] && ln -s ${SCRIPTDIR}/config/kitty kitty
mkdir -p ~/bin
cd ~/bin
[[ ! -L spotify ]] && ln -s ${SCRIPTDIR}/bin/spotify
[[ ! -L rebrew ]] && ln -s ${SCRIPTDIR}/bin/rebrew

# set up brew & pip
echo
echo "bootstrapping via brew"
${SCRIPTDIR}/bootstrap.brew.sh

# bootstrap fzf (install completions, etc)
echo
echo "bootstrapping fzf"
${SCRIPTDIR}/bootstrap.fzf.sh

# installing fonts
$SCRIPTDIR/bootstrap.darwin.fonts.sh

echo
echo "installing kitty"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
  launch=n
