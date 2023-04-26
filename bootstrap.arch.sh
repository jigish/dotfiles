#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

# enable parallel downloads for pacman
set +e
grep -E '^#ParallelDownloads' /etc/pacman.conf >/dev/null
if [[ "$?" = "0" ]]; then
  set -e
  echo
  echo "enabling parallel downloads (5) for pacman"
  doas sed -i -e 's/^#ParallelDownloads .*/ParallelDownloads = 5/g'
else
  set -e
fi

# install paru
if [[ ! -x $(which paru) ]]; then
  echo
  echo "installing paru"
  doas pacman -Sy --needed base-devel rustup
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

# install virtualbox guest stuff in needed
set +e
doas dmesg |grep "Hypervisor detected"
if [[ "$?" = "0" ]]; then
  set -e
  paru -S --needed virtualbox-guest-utils-nox
else
  set -e
fi

# add user to seat if need be
set +e
id -nG ${USER} |grep -qw seat
if [[ "$?" != "0" ]]; then
  echo
  echo "adding ${USER} to seat"
  doas usermod -a -G seat ${USER}
else
  set -e
fi

# enable seatd
set +e
doas systemctl is-enabled seatd.service >/dev/null
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "enabling seatd.service"
  doas systemctl enable --now seatd.service
else
  set -e
fi

mkdir -p ${HOME}/tmp
cat <<EOF >>${HOME}/tmp/bootstrap_TODO
- logout and login to finish seatd install
EOF

cd $CURRDIR
