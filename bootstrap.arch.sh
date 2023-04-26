#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# install paru
if [[ ! -x $(which paru) ]]; then
  echo
  echo "installing paru"
  sudo pacman -Sy --needed base-devel rustup
  rustup default stable
  mkdir -p ~/tmp
  cd ~/tmp
  rm -rf paru
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ~/tmp
  rm -rf paru
  cd $CURRDIR
fi

# update all the things
echo
echo "updating / installing / cleaning packages"
paru -Syu
paru -S --needed $(cat ${SCRIPTDIR}/paru.txt)
paru -c

# add user to seat if need be
set +e
id -nG ${USER} |grep -qw seat
if [[ "$?" != "0" ]]; then
  echo
  echo "adding ${USER} to seat"
  sudo usermod -a -G seat ${USER}
else
  set -e
fi

# enable seatd
set +e
sudo systemctl is-enabled seatd.service >/dev/null
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "enabling seatd.service"
  sudo systemctl enable --now seatd.service
else
  set -e
fi

cd $CURRDIR
