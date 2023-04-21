#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# create Links
cd ~
echo
echo "installing fonts"
mkdir -p ~/.fonts
mkdir -p ~/.local/share/fonts
cp $SCRIPTDIR/fonts/*.ttf ~/.fonts/
cp $SCRIPTDIR/fonts/*.otf ~/.fonts/
cp $SCRIPTDIR/fonts/*.ttf ~/.local/share/fonts/
cp $SCRIPTDIR/fonts/*.otf ~/.local/share/fonts/

# install packages
echo
echo "bootstrapping via apt"
sudo $SCRIPTDIR/bootstrap.apt.sh

# install yq
echo
echo "installing yq"
sudo rm -f /usr/local/bin/yq
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq

# npyvim is required for some neovim plugins
echo
echo "installing npyvim"
pip install --upgrade pip
pip install --upgrade pynvim
pip3 install --upgrade pip
pip3 install --upgrade pynvim

# install go
sudo $SCRIPTDIR/bootstrap.go.Linux.sh

# zsh ftw
if [[ "${SHELL}" != "/bin/zsh" ]]; then
  echo
  echo "changing shell to zsh"
  chsh -s /bin/zsh
fi

# themes and such
$SCRIPTDIR/bootstrap.theme.sh

# make brave default browser
echo
echo "set brave as default browser"
sudo update-alternatives --config x-www-browser

cd $CURRDIR
