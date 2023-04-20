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
  ./install.sh
  [[ ! -d ~/.colloid/icons ]] && git clone https://github.com/vinceliuice/Colloid-icon-theme ~/.colloid/icons
  cd ~/.colloid/icons
  git pull
  ./install.sh --scheme nord
  # Nordzy Cursors
  mkdir -p ~/.nordzy
  [[ ! -d ~/.nordzy/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ~/.nordzy/cursors
  cd ~/.nordzy/cursors
  git pull
  ./install.sh

  echo "NOTE: please use Kvantum Manager to set theme to Monterey"
  kvantummanager || true
elif [[ "${XDG_CURRENT_DESKTOP}" == *"GNOME"* ]]; then
  # Nordic theme
  echo
  echo "installing nordic theme for gnome"
  mkdir -p ~/.themes
  cd ~/.themes
  for style in '-bluish-accent' '-darker'; do # other options: '-Polar' ''
    for suffix in '-standard-buttons-v40' '-standard-buttons'; do # other options: '-v40' ''
      if [[ ! -d Nordic${style}${suffix} ]]; then
        wget https://github.com/EliverLara/Nordic/releases/download/${NORDIC_VERSION}/Nordic${style}${suffix}.tar.xz
        tar -xf Nordic${style}${suffix}.tar.xz
        rm Nordic${style}${suffix}.tar.xz
      fi
    done
  done
  gsettings set org.gnome.desktop.interface gtk-theme "Nordic-bluish-accent-standard-buttons"
  gsettings set org.gnome.desktop.wm.preferences theme "Nordic-bluish-accent-standard-buttons"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

  # Zafiro Nord Dark (grey) Icons
  echo "installing zafiro nord dark icons"
  mkdir -p ~/.zafiro
  [[ ! -d ~/.zafiro/icons ]] && git clone https://github.com/zayronxio/Zafiro-Nord-Dark ~/.zafiro/icons
  cd ~/.zafiro/icons
  git checkout . # remove my changes
  git pull
  echo "-> replacing green folder icons with grey"
  # TODO replace green folders with grey folders
  mkdir -p ~/.local/share/icons
  cd ~/.local/share/icons
  [[ ! -L Zafiro-Nord-Dark ]] && ln -s ~/.zafiro/icons/Zafiro-Nord-Dark Zafiro-Nord-Dark
  gsettings set org.gnome.desktop.interface icon-theme 'Zafiro-Nord-Dark'

  # Nordzy Cursors
  echo "installing nordzy cursors "
  mkdir -p ~/.nordzy
  [[ ! -d ~/.nordzy/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ~/.nordzy/cursors
  cd ~/.nordzy/cursors
  git pull
  ./install.sh
  gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
fi

cd $CURRDIR
