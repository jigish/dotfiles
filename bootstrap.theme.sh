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
  kvantummanager || true
elif [[ "${XDG_CURRENT_DESKTOP}" = "KDE" ]]; then
  echo
  echo "installing kvantum and nord theme for KDE"
  sudo add-apt-repository ppa:papirus/papirus
  sudo apt update
  sudo apt install qt5-style-kvantum qt5-style-kvantum-themes

  # Colloid theme and icons
  mkdir -p ~/.colloid
  [[ ! -d ~/.colloid/themes ]] && git clone https://github.com/vinceliuice/Colloid-kde ~/.colloid/themes
  cd ~/.colloid/themes
  git pull
  ./install.sh --tweaks normal --tweaks nord --tweaks rimless
  [[ ! -d ~/.colloid/icons ]] && git clone https://github.com/vinceliuice/Colloid-icon-theme ~/.colloid/icons
  cd ~/.colloid/icons
  git pull
  ./install.sh -s nord -t all
  # Nordzy Cursors
  mkdir -p ~/.nordzy
  [[ ! -d ~/.nordzy/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ~/.nordzy/cursors
  cd ~/.nordzy/cursors
  git pull
  ./install.sh

  echo "NOTE: please use Kvantum Manager to set theme to Monterey"
  kvantummanager || true
elif [[ "${XDG_CURRENT_DESKTOP}" == *"GNOME"* ]]; then
  # Colloid theme
  mkdir -p ~/.colloid
  [[ ! -d ~/.colloid/themes ]] && git clone https://github.com/vinceliuice/Colloid-gtk-theme ~/.colloid/themes
  cd ~/.colloid/themes
  git pull
  ./install.sh --tweaks -t all -l

  # Colloid icons
  [[ ! -d ~/.colloid/icons ]] && git clone https://github.com/vinceliuice/Colloid-icon-theme ~/.colloid/icons
  cd ~/.colloid/icons
  git pull
  ./install.sh -s all -t all

  mkdir -p ~/.nordzy
  # Nordzy Icons
  [[ ! -d ~/.nordzy/icons ]] && git clone https://github.com/alvatip/Nordzy-icon ~/.nordzy/icons
  cd ~/.nordzy/icons
  git pull
  ./install.sh

  # Nordzy Cursors
  [[ ! -d ~/.nordzy/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ~/.nordzy/cursors
  cd ~/.nordzy/cursors
  git pull
  ./install.sh

  gsettings set org.gnome.desktop.interface gtk-theme "Colloid"
  gsettings set org.gnome.desktop.wm.preferences theme "Colloid"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  gsettings set org.gnome.desktop.interface icon-theme 'Colloid-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
fi

cd $CURRDIR
