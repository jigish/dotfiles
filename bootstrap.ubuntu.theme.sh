#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

. ${SCRIPTDIR}/config.sh

NORDZY_DIR=${TWEAKS_DIR}/nordzy
ZAFIRO_DIR=${TWEAKS_DIR}/zafiro
NORDIC_VERSION_FILE=${TWEAKS_DIR}/nordic_version

if [[ "${XDG_CURRENT_DESKTOP}" == "ubuntu:GNOME" ]]; then
  # set background
  echo
  echo "setting background"
  gsettings set org.gnome.desktop.background picture-uri file://${SCRIPTDIR}/backgrounds/${DESKTOP_BACKGROUND}
  gsettings set org.gnome.desktop.background picture-uri-dark file://${SCRIPTDIR}/backgrounds/${DESKTOP_BACKGROUND}

  # install gnome extrensions / tweaks
  echo
  echo "installing extensions / tweaks"
  sudo apt install -y \
    gnome-shell-extensions gnome-tweaks chrome-gnome-shell \
    gnome-software-plugin-flatpak

  echo
  echo "setting login screen background"
  cd $SCRIPTDIR
  sudo ./ubuntu-gdm-set-background --image $SCRIPTDIR/backgrounds/${DESKTOP_BACKGROUND_BLURRED}
  # get rid of ubuntu logo
  [[ -f /usr/share/plymouth/ubuntu-logo.png ]] && sudo mv /usr/share/plymouth/ubuntu-logo.png /usr/share/plymouth/ubuntu-logo.png.bak
  # replace default ubuntu orange color on login screen
  for d in 'Yaru' 'Yaru-dark'; do
    if [[ -d /usr/share/gnome-shell/theme/${d} && ! -d /usr/share/gnome-shell/theme/${d}-original ]]; then
      sudo cp -a /usr/share/gnome-shell/theme/${d} /usr/share/gnome-shell/theme/${d}-original
      sudo find /usr/share/gnome-shell/theme/${d} -name '*.css' -exec sed -i -e 's/#[a-zA-Z0-9]+/#81A1C1/gi' {} \;
    fi
  done

  echo
  echo "installing plymouth & ulauncher"
  sudo add-apt-repository -y ppa:agornostal/ulauncher
  sudo apt update
  sudo apt install -y \
    plymouth libplymouth5 plymouth-label \
    ulauncher wmctrl
  systemctl --user enable --now ulauncher # enable ulauncher at startup and start it now

  # ulauncher Nord theme
  echo
  echo "installing nord ulauncher theme"
  mkdir -p ~/.config/ulauncher/user-themes
  [[ ! -d ~/.config/ulauncher/user-themes/ulauncher-nord ]] && \
    git clone https://github.com/LucianoBigliazzi/ulauncher-nord ~/.config/ulauncher/user-themes/ulauncher-nord
  cd ~/.config/ulauncher/user-themes/ulauncher-nord
  git stash || true
  git pull
  git stash pop || true

  # custom plymouth theme
  echo
  echo "installing custom plymouth theme"
  sudo cp -a ~/dotfiles/ubuntu-logosu /usr/share/plymouth/themes/
  sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
    /usr/share/plymouth/themes/ubuntu-logosu/ubuntu-logosu.plymouth 800
  sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/ubuntu-logosu/ubuntu-logosu.plymouth
  sudo update-initramfs -u

  # Nordic theme
  EXISTING_NORDIC_VERSION=none
  if [[ -f ${NORDIC_VERSION_FILE} ]]; then
    EXISTING_NORDIC_VERSION=$(cat ${NORDIC_VERSION_FILE})
  fi
  if [[ ${NORDIC_VERSION} != ${EXISTING_NORDIC_VERSION} ]]; then
    echo
    echo "installing nordic theme for gnome ${NORDIC_VERSION}"
    mkdir -p ~/.local/share/themes
    cd ~/.local/share/themes
    rm -rf ${NORDIC_THEME}
    wget https://github.com/EliverLara/Nordic/releases/latest/download/${NORDIC_THEME}.tar.xz
    tar -xf ${NORDIC_THEME}.tar.xz
    rm ${NORDIC_THEME}.tar.xz
    mkdir -p ~/.themes
    cd ~/.themes
    for f in $(ls ~/.local/share/themes); do
      [[ ! -L $f ]] && ln -s ~/.local/share/themes/$f
    done
    echo $NORDIC_VERSION >${NORDIC_VERSION_FILE}
  fi
  gsettings set org.gnome.shell.ubuntu color-scheme prefer-dark
  gsettings set org.gnome.desktop.interface gtk-theme "${NORDIC_THEME}"
  gsettings set org.gnome.desktop.wm.preferences theme "${NORDIC_THEME}"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

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
  cd ~/.local/share/icons
  [[ ! -L Zafiro-Nord-Dark ]] && ln -s ${ZAFIRO_DIR}/Zafiro-Nord-Dark
  gsettings set org.gnome.desktop.interface icon-theme 'Zafiro-Nord-Dark'

  # Nordzy Cursors
  echo
  echo "installing nordzy cursors"
  mkdir -p ${NORDZY_DIR}
  [[ ! -d ${NORDZY_DIR}/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ${NORDZY_DIR}/cursors
  cd ${NORDZY_DIR}/cursors
  git pull
  ./install.sh
  gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
else
  echo
  echo "---> not configured to theme ${XDG_CURRENT_DESKTOP} <---"
  echo
  echo "waiting 10s for that to sink in"
  sleep 10
  echo "continuing"
fi

cd $CURRDIR
