#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

export DESKTOP_ENV=$(dpkg -l '*buntu*desktop' | grep ^ii | awk '{print $2}')

# create Links
cd ~
echo
echo "installing fonts"
[[ ! -L .fonts ]] && ln -s $SCRIPTDIR/fonts .fonts

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

# install kitty
$SCRIPTDIR/bootstrap.kitty.sh

cd $CURRDIR
