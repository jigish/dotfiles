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
  doas pacman -Sy ${NOCONFIRM} --needed rustup $(cat ${SCRIPTDIR}/base-devel.txt)
  [[ ! -L /usr/bin/sudo ]] && doas ln -s $(which doas) /usr/bin/sudo
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
else
  set -e
fi

# symlink configs
cd ~/.config
[[ ! -L paru ]] && ln -s $SCRIPTDIR/config/paru paru
#[[ ! -L sway ]] && ln -s $SCRIPTDIR/config/sway sway

# symlink sudo
cd $CURRDIR
[[ ! -L /usr/bin/sudo ]] && doas ln -s $(which doas) /usr/bin/sudo

# update all the things
echo
echo "updating / installing / cleaning packages"
paru -Syu ${NOCONFIRM}
paru -S ${NOCONFIRM} --needed $(cat ${SCRIPTDIR}/paru.txt)
paru -c ${NOCONFIRM}

# install virtualbox guest stuff in needed
set +e
doas dmesg |grep "Hypervisor detected" >/dev/null
if [[ "$?" = "0" ]]; then
  set -e

  echo
  echo "hypervisor detected: installing vmware tools"
  paru -S ${NOCONFIRM} --needed open-vm-tools gtkmm3
  set +e
  doas systemctl is-enabled vmtoolsd.service >/dev/null
  if [[ "$?" != "0" ]]; then
    set -e
    echo
    echo "enabling vmtoolsd.service"
    doas systemctl enable --now vmtoolsd.service
  else
    set -e
  fi
  set +e
  doas systemctl is-enabled vmware-vmblock-fuse.service >/dev/null
  if [[ "$?" != "0" ]]; then
    set -e
    echo
    echo "enabling vmware-vmblock-fuse.service"
    doas systemctl enable --now vmware-vmblock-fuse.service
  else
    set -e
  fi

  #echo
  #echo "hypervisor detected: installing virtualbox guest utils"
  #paru -S ${NOCONFIRM} --needed virtualbox-guest-utils-nox
  #doas systemctl is-enabled vboxservice.service >/dev/null
  #set +e
  #if [[ "$?" != "0" ]]; then
    #set -e
    #echo
    #echo "enabling vboxservice.service"
    #doas systemctl enable --now vboxservice.service
  #else
    #set -e
  #fi

  #cd ~
  #[[ ! -L .zshrc.virtualbox ]] && ln -s ${SCRIPTDIR}/zshrc.virtualbox .zshrc.virtualbox
  #cd $CURRDIR
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
