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
  mkdir -p ~/.local/share/themes
  cd ~/.local/share/themes
  for style in '-bluish-accent' '-darker'; do # other options: '-Polar' ''
    for suffix in '-standard-buttons-v40' '-standard-buttons'; do # other options: '-v40' ''
      if [[ ! -d Nordic${style}${suffix} ]]; then
        wget https://github.com/EliverLara/Nordic/releases/download/${NORDIC_VERSION}/Nordic${style}${suffix}.tar.xz
        tar -xf Nordic${style}${suffix}.tar.xz
        rm Nordic${style}${suffix}.tar.xz
      fi
    done
  done
  mkdir -p ~/.themes
  cd ~/.themes
  for f in $(ls ~/.local/share/themes); do
    [[ ! -L ~/.local/share/themes/$f ]] && ln -s ~/.local/share/themes/$f
  done
  gsettings set org.gnome.desktop.interface gtk-theme "Nordic-bluish-accent-standard-buttons"
  gsettings set org.gnome.desktop.wm.preferences theme "Nordic-bluish-accent-standard-buttons"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

  # Zafiro Nord Dark (grey) Icons
  echo "installing zafiro nord dark icons"
  mkdir -p ~/.zafiro
  [[ ! -d ~/.zafiro/Zafiro-Nord-Dark ]] && git clone https://github.com/zayronxio/Zafiro-Nord-Dark
  cd ~/.zafiro/Zafiro-Nord-Dark
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
  [[ ! -L Zafiro-Nord-Dark ]] && ln -s ~/.zafiro/Zafiro-Nord-Dark
  gsettings set org.gnome.desktop.interface icon-theme 'Zafiro-Nord-Dark'

  # Nordzy Cursors
  echo "installing nordzy cursors"
  mkdir -p ~/.nordzy
  [[ ! -d ~/.nordzy/cursors ]] && git clone https://github.com/alvatip/Nordzy-cursors ~/.nordzy/cursors
  cd ~/.nordzy/cursors
  git pull
  ./install.sh
  gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
fi

cd $CURRDIR
