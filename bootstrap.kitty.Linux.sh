#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

mkdir -p ~/.local/bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
cd ~/.local/bin
[[ ! -L kitty ]] && ln -s ~/.local/kitty.app/bin/kitty
[[ ! -L kitten ]] && ln -s ~/.local/kitty.app/bin/kitten

DESKTOP_ENV=$(dpkg -l '*buntu*desktop' | grep ^ii | awk '{print $2}')
if [[ "${DESKTOP_ENV}" != "lubuntu-desktop" ]]; then # seems lubuntu already has icons nice and pretty
  mkdir -p ~/.local/share/applications
  cd ~/.local/share/applications
  # register kitty.desktop
  [[ ! -f kitty.desktop ]] && cp ~/.local/kitty.app/share/applications/kitty.desktop .
  # auto-open by kitty
  [[ ! -f kitty-open.desktop ]] && cp ~/.local/kitty.app/share/applications/kitty-open.desktop .
  # update default icon/exec paths
  sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" kitty*.desktop
  sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" kitty*.desktop
fi

echo
echo "set kitty as default terminal"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.local/kitty.app/bin/kitty 50
sudo update-alternatives --config x-terminal-emulator

cd $CURRDIR
