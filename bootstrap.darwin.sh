#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

# create links
mkdir -p ~/.config
cd ~/.config
[[ ! -L kitty ]] && ln -s ${SCRIPTDIR}/config/kitty kitty
[[ ! -L ghostty ]] && ln -s ${SCRIPTDIR}/config/ghostty ghostty
mkdir -p ~/bin
cd ~/bin
[[ ! -L spotify ]] && ln -s ${SCRIPTDIR}/bin/spotify
[[ ! -L rebrew ]] && ln -s ${SCRIPTDIR}/bin/rebrew

# set up brew & pip
${SCRIPTDIR}/bootstrap.brew.sh

# bootstrap fzf (install completions, etc)
${SCRIPTDIR}/bootstrap.fzf.sh

# installing rust
$SCRIPTDIR/bootstrap.darwin.rust.sh

# installing fonts
$SCRIPTDIR/bootstrap.darwin.fonts.sh

# we're trying out ghostty
#echo
#echo "installing kitty"
#curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
#  launch=n
