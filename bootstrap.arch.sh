#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

. ${SCRIPTDIR}/config.sh

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
  doas pacman -Sy ${NOCONFIRM} --needed rustup $(cat ${SCRIPTDIR}/bootstrap.packages/arch.base-devel.txt)
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
  cd ${CURRDIR}
else
  set -e
fi

# symlink configs
cd ~/.config
[[ ! -L fuzzel ]] && ln -s $SCRIPTDIR/config/fuzzel fuzzel
[[ ! -L mako ]] && ln -s $SCRIPTDIR/config/mako mako
[[ ! -L paru ]] && ln -s $SCRIPTDIR/config/paru paru
[[ ! -L sway ]] && ln -s $SCRIPTDIR/config/sway sway
[[ ! -L swaylock ]] && ln -s $SCRIPTDIR/config/swaylock swaylock
[[ ! -L swaynag ]] && ln -s $SCRIPTDIR/config/swaynag swaynag
[[ ! -L waybar ]] && ln -s $SCRIPTDIR/config/waybar waybar
cd ~/bin
[[ ! -L de ]] && ln -s $SCRIPTDIR/bin/de

# symlink sudo
cd ${CURRDIR}
[[ ! -L /usr/bin/sudo ]] && doas ln -s $(which doas) /usr/bin/sudo

# update all the things
echo
echo "updating / installing / cleaning packages"
paru -Syu ${NOCONFIRM}
paru -S ${NOCONFIRM} --needed $(cat ${SCRIPTDIR}/bootstrap.packages/arch.* |sort -u)
paru -c ${NOCONFIRM}
paru -Scc ${NOCONFIRM}

# install virtualbox guest stuff in needed
set +e
doas dmesg |grep "Hypervisor detected" >/dev/null
if [[ "$?" = "0" ]]; then
  set -e

  # vmware version
  #echo
  #echo "hypervisor detected: installing vmware tools"
  #paru -S ${NOCONFIRM} --needed open-vm-tools gtkmm3
  #set +e
  #doas systemctl is-enabled vmtoolsd.service >/dev/null
  #if [[ "$?" != "0" ]]; then
    #set -e
    #echo
    #echo "enabling vmtoolsd.service"
    #doas systemctl enable --now vmtoolsd.service
  #else
    #set -e
  #fi
  #set +e
  #doas systemctl is-enabled vmware-vmblock-fuse.service >/dev/null
  #if [[ "$?" != "0" ]]; then
    #set -e
    #echo
    #echo "enabling vmware-vmblock-fuse.service"
    #doas systemctl enable --now vmware-vmblock-fuse.service
  #else
    #set -e
  #fi
  #cd ${CURRDIR}

  # virtualbox version
  echo
  echo "hypervisor detected: installing virtualbox guest utils"
  paru -S ${NOCONFIRM} --needed virtualbox-guest-utils-nox
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

  cd ~
  [[ ! -L .zshrc.virtualbox ]] && ln -s ${SCRIPTDIR}/zshrc.virtualbox .zshrc.virtualbox
  cd ${CURRDIR}
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

# fixes for native wayland
echo
echo "waylandifying applications"
cd ~/.config
[[ ! -L electron-flags.conf ]] && ln -s ${SCRIPTDIR}/config/electron-flags.conf
cd ${CURRDIR}
mkdir -p ~/.local/share/applications
for f in brave-browser tidal-hifi; do
  echo "-> ${f}"
  rm -f ~/.local/share/applications/${f}.desktop
  cp /usr/share/applications/${f}.desktop ~/.local/share/applications/
  sed -i -e 's/^Exec=\([^ ]*\)\(.*\)$/Exec=\1 --ozone-platform-hint=auto\2/g' ~/.local/share/applications/${f}.desktop
done

# enable pipewire.service at boot
set +e
systemctl --user is-enabled pipewire.service >/dev/null
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "enabling pipewire.service"
  systemctl --user enable --now pipewire.service
else
  set -e
fi

# remap keys
echo
echo "remapping keys"
doas mkdir -p /etc/kbct
doas cp ${SCRIPTDIR}/kbct-config.yml /etc/kbct/config.yml
set +e
doas systemctl is-enabled kbct.service >/dev/null
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "enabling kbct.service"
  doas modprobe uinput
  echo "uinput" |doas tee -a /etc/modules-load.d/uinput.conf
  doas systemctl enable --now kbct.service
else
  set -e
  doas systemctl restart kbct.service
fi

# theming
NORDZY_DIR=${TWEAKS_DIR}/nordzy
ZAFIRO_DIR=${TWEAKS_DIR}/zafiro
NORDIC_VERSION_FILE=${TWEAKS_DIR}/nordic_version
# Nordic theme
EXISTING_NORDIC_VERSION=none
if [[ -f ${NORDIC_VERSION_FILE} ]]; then
  EXISTING_NORDIC_VERSION=$(cat ${NORDIC_VERSION_FILE})
fi
if [[ ${NORDIC_VERSION} != ${EXISTING_NORDIC_VERSION} ]]; then
  echo
  echo "installing nordic theme version ${NORDIC_VERSION}"
  mkdir -p ~/.local/share/themes
  cd ~
  [[ ! -L .themes ]] && ln -s ~/.local/share/themes .themes
  cd ~/.local/share/themes
  rm -rf ${NORDIC_THEME}
  wget https://github.com/EliverLara/Nordic/releases/latest/download/${NORDIC_THEME}.tar.xz
  tar -xf ${NORDIC_THEME}.tar.xz
  rm ${NORDIC_THEME}.tar.xz
  echo ${NORDIC_VERSION} >${NORDIC_VERSION_FILE} # do this at the end so we run through this again if we fail
fi
cd ${CURRDIR}
# Zafiro Nord Dark (grey) Icons
echo
echo "installing zafiro nord dark icons"
mkdir -p ${ZAFIRO_DIR}
cd ${ZAFIRO_DIR}
[[ ! -d ${ZAFIRO_DIR}/Zafiro-Nord-Dark ]] && git clone https://github.com/zayronxio/Zafiro-Nord-Dark
cd ${ZAFIRO_DIR}/Zafiro-Nord-Dark
git checkout .
git pull
echo "-> replacing green folder icons with grey and name to match repo"
sed -i 's/Zafiro-Nord-Black/Zafiro-Nord-Dark/g' index.theme
find ./places -type f -exec sed -i -e 's/#a3be8c/#85a8b5/g' {} \;
find ./places -type f -exec sed -i -e 's/#8daf71/#7396a3/g' {} \;
find ./places -type f -exec sed -i -e 's/#8eac75/#7396a3/g' {} \;
find ./places -type f -exec sed -i -e 's/#80a264/#637279/g' {} \;
find ./places -type f -exec sed -i -e 's/#87a7a9/#9cb4be/g' {} \;
find ./places -type f -exec sed -i -e 's/#769b9d/#6f8088/g' {} \;
mkdir -p ~/.local/share/icons
cd ~
[[ ! -L .icons ]] && ln -s ~/.local/share/icons .icons # need to do this before cursors install because they go in .icons
cd ~/.local/share/icons
[[ ! -L Zafiro-Nord-Dark ]] && ln -s ${ZAFIRO_DIR}/Zafiro-Nord-Dark
[[ ! -L default ]] && ln -s ${ZAFIRO_DIR}/Zafiro-Nord-Dark
cd ${CURRDIR}
# Nordzy Cursors
echo
echo "installing nordzy cursors"
mkdir -p ${NORDZY_DIR}
[[ ! -d ${NORDZY_DIR}/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ${NORDZY_DIR}/cursors
cd ${NORDZY_DIR}/cursors
git pull
./install.sh
# Attempt to actually set theme in various ways
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme "${NORDIC_THEME}"
gsettings set org.gnome.desktop.interface icon-theme 'Zafiro-Nord-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
gsettings set org.gnome.desktop.wm.preferences theme "${NORDIC_THEME}"
mkdir -p ~/.config/gtk-4.0
cd ~/.config/gtk-4.0
[[ ! -L settings.ini ]] && ln -s ${SCRIPTDIR}/config/gtk-4.0/settings.ini
cp -a ~/.local/share/themes/${NORDIC_THEME}/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css
cp -a ~/.local/share/themes/${NORDIC_THEME}/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
cd ~/.config
[[ ! -L gtk-3.0 ]] && ln -s ${SCRIPTDIR}/config/gtk-3.0
[[ ! -L Trolltech.conf ]] && ln -s ${SCRIPTDIR}/config/Trolltech.conf
cd ~
[[ ! -L .gtkrc-2.0 ]] && ln -s ${SCRIPTDIR}/gtkrc-2.0 .gtkrc-2.0
cd ${CURRDIR}

mkdir -p ${HOME}/tmp
cat <<EOF >>${HOME}/tmp/bootstrap_TODO
- logout and login to finish seatd install
EOF

cd ${CURRDIR}
