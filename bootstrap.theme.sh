#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

. ./config.sh

COLLOID_DIR=${TWEAKS_DIR}/colloid
NORDZY_DIR=${TWEAKS_DIR}/nordzy
VORTEX_DIR=${TWEAKS_DIR}/vortex
ZAFIRO_DIR=${TWEAKS_DIR}/zafiro
NORDIC_VERSION_FILE=${TWEAKS_DIR}/nordic_version

if [[ "${XDG_CURRENT_DESKTOP}" = "LXQt" ]]; then
  # qt-based theme -- install kvantum
  echo
  echo "installing kvantum and nord theme for LXQt"
  sudo add-apt-repository -y ppa:papirus/papirus
  sudo apt update
  sudo apt install -y qt5-style-kvantum qt5-style-kvantum-themes
  mkdir -p ~/.config/Kvantum
  git clone https://github.com/AlyamanMas/KvAdaptaNordic ~/.config/Kvantum/KvAdaptaNordic
  echo
  echo "NOTE: please use Kvantum Manager to set theme to KvAdaptaNordic"
  kvantummanager || true
elif [[ "${XDG_CURRENT_DESKTOP}" = "KDE" ]]; then
  echo
  echo "installing kvantum and nord theme for KDE"
  sudo add-apt-repository -y ppa:papirus/papirus
  sudo apt update
  sudo apt install -y qt5-style-kvantum qt5-style-kvantum-themes

  # Colloid theme and icons
  mkdir -p ${COLLOID_DIR}
  [[ ! -d ${COLLOID_DIR}/themes ]] && git clone https://github.com/vinceliuice/Colloid-kde ${COLLOID_DIR}/themes
  cd ${COLLOID_DIR}/themes
  git pull
  ./install.sh
  [[ ! -d ${COLLOID_DIR}/icons ]] && git clone https://github.com/vinceliuice/Colloid-icon-theme ${COLLOID_DIR}/icons
  cd ${COLLOID_DIR}/icons
  git pull
  ./install.sh --scheme nord
  # Nordzy Cursors
  mkdir -p ${NORDZY_DIR}
  [[ ! -d ${NORDZY_DIR}/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ${NORDZY_DIR}/cursors
  cd ${NORDZY_DIR}/cursors
  git pull
  ./install.sh

  echo "NOTE: please use Kvantum Manager to set theme to Monterey"
  kvantummanager || true
elif [[ "${XDG_CURRENT_DESKTOP}" == *"GNOME"* ]]; then
  # set background
  echo
  echo "setting background"
  gsettings set org.gnome.desktop.background picture-uri-dark file://${SCRIPTDIR}/backgrounds/${DESKTOP_BACKGROUND}

  echo
  echo "setting login screen background"
  cd $SCRIPTDIR
  ./ubuntu-gdm-set-background $SCRIPTDIR/backgrounds/${DESKTOP_BACKGROUND_BLURRED}

  # install gnome extrensions / tweaks, plymouth libs, and ulauncher
  echo
  echo "installing extensions, tweaks, plymouth, ulauncher"
  sudo add-apt-repository -y ppa:agornostal/ulauncher
  sudo apt update
  sudo apt install -y \
    gnome-shell-extensions gnome-tweaks chrome-gnome-shell \
    gnome-software-plugin-flatpak \
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

  # vortex plymouth theme
  echo
  echo "installing vortex plymouth theme"
  mkdir -p ${VORTEX_DIR}
  [[ ! -d ${VORTEX_DIR}/plymouth ]] && \
    git clone https://github.com/emanuele-scarsella/vortex-ubuntu-plymouth-theme ${VORTEX_DIR}/plymouth
  cd ${VORTEX_DIR}/plymouth
  git checkout .
  git pull
  chmod +x install
  sudo ./install

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
    for style in '-bluish-accent'; do # other options: '-darker' '-Polar' ''
      for suffix in '-standard-buttons-v40' '-standard-buttons'; do # other options: '-v40' ''
        rm -rf Nordic${style}${suffix}
        wget https://github.com/EliverLara/Nordic/releases/latest/download/Nordic${style}${suffix}.tar.xz
        tar -xf Nordic${style}${suffix}.tar.xz
        rm Nordic${style}${suffix}.tar.xz
      done
    done
    mkdir -p ~/.themes
    cd ~/.themes
    for f in $(ls ~/.local/share/themes); do
      [[ ! -L $f ]] && ln -s ~/.local/share/themes/$f
    done
    echo $NORDIC_VERSION >${NORDIC_VERSION_FILE}
  fi
  gsettings set org.gnome.desktop.interface gtk-theme "Nordic-bluish-accent-standard-buttons"
  gsettings set org.gnome.desktop.wm.preferences theme "Nordic-bluish-accent-standard-buttons"
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
fi

cd $CURRDIR
