#!/bin/bash

set -eo pipefail

NORDIC_VERSION=v2.2.0

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

if [[ "${DESKTOP_ENV}" = "lubuntu-desktop" ]]; then
  # qt-based theme -- install kvantum
  sudo add-apt-repository ppa:papirus/papirus
  sudo apt update
  sudo apt install qt5-style-kvantum qt5-style-kvantum-themes
  mkdir -p ~/.config/Kvantum
  git clone https://github.com/AlyamanMas/KvAdaptaNordic ~/.config/Kvantum/KvAdaptaNordic
  echo
  echo "NOTE: please use Kvantum Manager to set theme to KvAdaptaNordic"
else
  #if [[ "${DESKTOP_ENV}" = "ubuntu-desktop" ]]; then
  #  sudo apt install ubuntu-budgie-desktop
  #fi
  # probably gtk
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
fi


cd $CURRDIR