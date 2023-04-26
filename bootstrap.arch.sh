#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# install paru
if [[ ! -x $(which paru) ]]; then
  echo
  echo "installing paru"
  sudo pacman -S --needed base-devel
  mkdir -p ~/tmp
  cd ~/tmp
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ~/tmp
  rm -rf paru
  cd $CURRDIR
fi

# update all the things
echo
echo "installing / updating packages"
paru -Syu
paru -S $(cat ${SCRIPTDIR}/paru.txt)
paru -c

# add user to seat if need be
id -nG ${USER} |grep -qw seat
if [[ "$?" != "0" ]]; then
  echo
  echo "adding ${USER} to seat"
  sudo usermod -a -G seat ${USER}
fi

# enable seatd
sudo systemctl is-enabled seatd.service >/dev/null
if [[ "$?" != "0" ]]; then
  echo
  echo "enabling seatd.service"
  sudo systemctl enable --now seatd.service
fi

cd $CURRDIR
