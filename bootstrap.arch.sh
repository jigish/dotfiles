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
  doas sed -i -e 's/^#ParallelDownloads .*/ParallelDownloads = 5/g' /etc/pacman.conf
else
  set -e
fi

# install paru
set +e
type paru >/dev/null 2>&1
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "installing paru"
  # first we need to add wheel to sudoers. why base-devel needs sudo is beyond me.
  doas sed -i -e 's/^.*%wheel \(.*\)NOPASSWD\(.*\)$/%wheel \1NOPASSWD\2/g' /etc/sudoers
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
  doas pacman -Rs base-devel # base-devel requires sudo. we are using doas.
else
  set -e
fi
cd ~/config
[[ ! -L paru ]] && ln -s $SCRIPTDIR/config/paru paru
cd $CURRDIR
[[ ! -L /usr/bin/sudo ]] && ln -s $(which doas) /usr/bin/sudo

# update all the things
echo
echo "updating / installing / cleaning packages"
paru -Syu
paru -S --needed $(cat ${SCRIPTDIR}/paru.txt)
paru -c

# install virtualbox guest stuff in needed
set +e
doas dmesg |grep "Hypervisor detected" >/dev/null
if [[ "$?" = "0" ]]; then
  echo
  echo "hypervisor detected: installing virtualbox guest utils"
  set -e
  paru -S --needed virtualbox-guest-utils-nox
  set +e
  doas systemctl is-enabled vboxservice.service >/dev/null
  if [[ "$?" != "0" ]]; then
    set -e
    echo
    echo "enabling vboxservice.service"
    doas systemctl enable --now vboxservice.service
  else
    set -e
  fi
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
