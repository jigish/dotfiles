#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

mkdir -p ~/.local/bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
cd ~/.local/bin
[[ ! -L kitty ]] && ln -s ~/.local/kitty.app/bin/kitty
[[ ! -L kitten ]] && ln -s ~/.local/kitty.app/bin/kitten

if [[ "${XDG_CURRENT_DESKTOP}" != "LXQt" ]]; then # seems LXQt already has icons nice and pretty
  mkdir -p ~/.local/share/applications
  cd ~/.local/share/applications
  # register kitty.desktop
  [[ ! -f kitty.desktop ]] && cp ~/.local/kitty.app/share/applications/kitty.desktop .
  # auto-open by kitty
  [[ ! -f kitty-open.desktop ]] && cp ~/.local/kitty.app/share/applications/kitty-open.desktop .
  # update default icon/exec paths
  sed -i "s|Icon=kitty|Icon=/home/$USER/.local/share/icons/Zafiro-Nord-Dark/apps/48/kitty.svg|g" kitty*.desktop
  sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" kitty*.desktop
fi

# copy kitty terminfo system-wide
sudo cp -a $HOME/.local/kitty.app/lib/kitty/terminfo/* /etc/terminfo/

echo
echo "set kitty as default terminal"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.local/kitty.app/bin/kitty 50
sudo update-alternatives --config x-terminal-emulator
if [[ "${XDG_CURRENT_DESKTOP}" == *"GNOME"* ]]; then
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/x-terminal-emulator
fi

cd $CURRDIR
