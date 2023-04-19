#!/bin/bash

set -eo pipefail

NORDIC_VERSION=v2.2.0

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

if [[ "${XDG_CURRENT_DESKTOP}" = "LXQt" ]]; then
  # qt-based theme -- install kvantum
  echo
  echo "installing kvantum and nord theme for LXQt"
  sudo add-apt-repository ppa:papirus/papirus
  sudo apt update
  sudo apt install qt5-style-kvantum qt5-style-kvantum-themes
  mkdir -p ~/.config/Kvantum
  git clone https://github.com/AlyamanMas/KvAdaptaNordic ~/.config/Kvantum/KvAdaptaNordic
  echo
  echo "NOTE: please use Kvantum Manager to set theme to KvAdaptaNordic"
elif [[ "${XDG_CURRENT_DESKTOP}" == *"GNOME"* ]]; then
  # Nordic theme
  echo
  echo "installing nord theme for gnome"
  mkdir -p ~/.themes
  cd ~/.themes
  for style in '-bluish-accent' '-darker' '-Polar' ''; do
    for suffix in '-standard-buttons-v40' '-standard-buttons' '-v40' ''; do
      if [[ ! -d Nordic${style}${suffix} ]]; then
        wget https://github.com/EliverLara/Nordic/releases/download/${NORDIC_VERSION}/Nordic${style}${suffix}.tar.xz
        tar -xf Nordic${style}${suffix}.tar.xz
        rm Nordic${style}${suffix}.tar.xz
      fi
    done
  done
  gsettings set org.gnome.desktop.interface gtk-theme "Nordic-standard-buttons"
  gsettings set org.gnome.desktop.wm.preferences theme "Nordic-standard-buttons"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

  mkdir -p ~/.nordzy
  # Nordzy Icons
  [[ ! -d ~/.nordzy/icons ]] && git clone https://github.com/alvatip/Nordzy-icon ~/.nordzy/icons
  cd ~/.nordzy/icons
  git pull
  ./install.sh
  gsettings set org.gnome.desktop.interface icon-theme 'Nordzy-dark'
  # Nordzy Cursors
  [[ ! -d ~/.nordzy/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ~/.nordzy/cursors
  cd ~/.nordzy/cursors
  git pull
  ./install.sh
  gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
fi

cd $CURRDIR
