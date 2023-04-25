#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# install seatd and add ${USER} to seat group
sudo pacman -Qi seatd >/dev/null
if [[ "$?" != "0" ]]; then
  echo
  echo "installing seatd"
  sudo pacman -S seatd
  sudo systemctl enable --now seatd
fi
id -nG ${USER} |grep -qw seat
if [[ "$?" != "0" ]]; then
  echo
  echo "adding ${USER} to seat"
  sudo usermod -a -G seat ${USER}
fi
