#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

. ${SCRIPTDIR}/config.sh

# allow access to /usr/local and subdirs for group wheel
if [[ ! -w /usr/local/man/man1 ]]; then
  for i in {1..8}; do
    mkdir -p /usr/local/man/man${i}
  done
  for d in $(find /usr/local -type d); do
    chown root:wheel ${d}
    chmod g+w ${d}
  done
fi

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
[[ ! -L dunst ]] && ln -s $SCRIPTDIR/config/dunst dunst
[[ ! -L fuzzel ]] && ln -s $SCRIPTDIR/config/fuzzel fuzzel
[[ ! -L mako ]] && ln -s $SCRIPTDIR/config/mako mako
[[ ! -L paru ]] && ln -s $SCRIPTDIR/config/paru paru
[[ ! -L sway ]] && ln -s $SCRIPTDIR/config/sway sway
[[ ! -L swaylock ]] && ln -s $SCRIPTDIR/config/swaylock swaylock
[[ ! -L swaynag ]] && ln -s $SCRIPTDIR/config/swaynag swaynag
[[ ! -L waybar ]] && ln -s $SCRIPTDIR/config/waybar waybar
mkdir -p systemd/user
cd systemd/user
for f in $(find ${SCRIPTDIR}/systemd/user -maxdepth 1 -type f); do
  if [[ ! -L $(basename ${f}) ]]; then
    ln -s ${f}
    systemctl --user enable --now $(basename ${f})
  fi
done

# update all the things
echo
echo "updating / installing / cleaning packages"
paru -Syu ${NOCONFIRM}
paru -S ${NOCONFIRM} --needed $(cat ${SCRIPTDIR}/bootstrap.packages/arch.* |sort -u)
paru -c ${NOCONFIRM}
paru -Scc --noconfirm # always clear caches

set +e
doas systemctl is-enabled docker.service >/dev/null
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "enabling docker.service"
  doas systemctl enable --now docker.service
  doas usermod -aG docker $USER
else
  set -e
fi

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
for f in tidal-hifi; do # brave-browser would need to be here to if we use it
  echo "-> ${f}"
  rm -f ~/.local/share/applications/${f}.desktop
  cp /usr/share/applications/${f}.desktop ~/.local/share/applications/
  sed -i -e 's/^Exec=\([^ ]*\)\(.*\)$/Exec=\1 --ozone-platform-hint=auto\2/g' ~/.local/share/applications/${f}.desktop
done
# blacklist some applications from launchers
for app in $(cat ${SCRIPTDIR}/launcher-blacklist.txt); do
  if [[ -f /usr/share/applications/${app} ]]; then
    echo "-> blacklisting ${app} from launcher"
    cp /usr/share/applications/${app} ~/.local/share/applications/${app}
    echo "NoDisplay=true" >>~/.local/share/applications/${app}
  fi
done
# fix icons
cp /usr/share/applications/org.codeberg.dnkl.foot.desktop ~/.local/share/applications/org.codeberg.dnkl.foot.desktop
sed -i -e 's/^Icon=.*$/Icon=terminal/g' ~/.local/share/applications/org.codeberg.dnkl.foot.desktop
cp /usr/share/applications/pulse.desktop ~/.local/share/applications/pulse.desktop
sed -i -e 's/^Icon=.*$/Icon=bitwarden/g' ~/.local/share/applications/pulse.desktop
cp /usr/share/applications/firefox.desktop ~/.local/share/applications/firefox.desktop
sed -i -e 's/^Icon=.*$/Icon=firefox-developer-icon/g' ~/.local/share/applications/firefox.desktop
cp /usr/share/applications/swayimg.desktop ~/.local/share/applications/swayimg.desktop
sed -i -e 's/^Icon=.*$/Icon=folder-pictures/g' ~/.local/share/applications/swayimg.desktop
# update database
update-desktop-database -v ~/.local/share/applications

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
[[ ! -L /etc/kbct/config.yml ]] && doas ln -s ${SCRIPTDIR}/kbct-config.yml /etc/kbct/config.yml
set +e
doas systemctl is-enabled kbct.service >/dev/null
if [[ "$?" != "0" ]]; then
  set -e
  echo
  echo "enabling kbct.service"
  doas modprobe -v uinput
  if [[ ! -f /etc/modules-load.d/uinput.conf ]]; then
    echo "uinput" |doas tee -a /etc/modules-load.d/uinput.conf
  fi
  doas systemctl enable --now kbct.service
else
  set -e
  doas systemctl restart kbct.service
fi

# add usbhid module
doas modprobe -v usbhid
if [[ ! -f /etc/modules-load.d/usbhid.conf ]]; then
  echo "usbhid" |doas tee -a /etc/modules-load.d/usbhid.conf
fi

# theming ----------------------------------------------------------------------------------------------------------------------------
NORDIC_DIR=${TWEAKS_DIR}/nordic
NORDZY_DIR=${TWEAKS_DIR}/nordzy
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
# Nordic firefox theme
mkdir -p ${NORDIC_DIR}
[[ ! -d "${NORDIC_DIR}/firefox-nordic-theme" ]] && \
  git clone https://github.com/EliverLara/firefox-nordic-theme ${NORDIC_DIR}/firefox-nordic-theme
cd ${NORDIC_DIR}/firefox-nordic-theme
if [[ "$(git pull 2>&1)" != "Already up to date." ]]; then
  echo
  echo "installing nordic firefox theme"
  ./scripts/install.sh
fi

# Nordzy Icons
echo
echo "installing nordzy icons"
mkdir -p ${NORDZY_DIR}
[[ ! -d ${NORDZY_DIR}/icons ]] && git clone https://github.com/alvatip/Nordzy-icon ${NORDZY_DIR}/icons
cd ${NORDZY_DIR}/icons
git pull
./install.sh
cd ${CURRDIR}

# Nordzy Cursors
echo
echo "installing nordzy cursors"
mkdir -p ${NORDZY_DIR}
[[ ! -d ${NORDZY_DIR}/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ${NORDZY_DIR}/cursors
cd ${NORDZY_DIR}/cursors
git pull
./install.sh
cd ~/.icons
[[ ! -L default ]] && ln -s Nordzy-cursors default
cd ${CURRDIR}

# Attempt to actually set theme in various ways
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme "${NORDIC_THEME}"
gsettings set org.gnome.desktop.interface icon-theme 'Nordzy-dark'
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
