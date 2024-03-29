#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

. ./config.sh

# symlink fonts
cd ~
ln -s ${HOME}/.local/share/fonts .fonts

# install fzf
echo
echo "bootstrapping fzf"
$SCRIPTDIR/bootstrap.fzf.sh

# apt packages
echo
echo "installing/upgrading packages via apt"
[[ -z "$(which curl)" ]] && sudo apt install -y curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
[[ ! -f /etc/apt/sources.list.d/brave-browser-release.list ]]  && sudo echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"| sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt upgrade -y
sudo apt install -y $(cat $SCRIPTDIR/bootstrap.packages/ubuntu.txt)
sudo apt autoremove -y
# add flathub remote
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install yq
YQ_VERSION=$(get_latest_release mikefarah/yq)
EXISTING_YQ_VERSION=none
if [[ -x $(which yq) ]]; then
  EXISTING_YQ_VERSION=$(yq --version | awk '{print $4}')
fi
if [[ ${YQ_VERSION} != ${EXISTING_YQ_VERSION} ]]; then
  echo
  echo "installing yq ${YQ_VERSION}"
  sudo rm -f /usr/local/bin/yq
  sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
fi

# install lsd
LSD_VERSION=$(get_latest_release lsd-rs/lsd)
EXISTING_LSD_VERSION=none
if [[ -x $(which lsd) ]]; then
  EXISTING_LSD_VERSION=$(lsd --version | awk '{print $2}')
fi
if [[ ${LSD_VERSION} != ${EXISTING_LSD_VERSION} ]]; then
  echo
  echo "installing lsd ${LSD_VERSION}"
  if [[ -x $(which lsd) ]]; then
    sudo dpkg -P lsd
  fi
  LSD_DEB=lsd_${LSD_VERSION}_amd64.deb
  sudo wget https://github.com/lsd-rs/lsd/releases/download/${LSD_VERSION}/${LSD_DEB} -O /tmp/${LSD_DEB}
  sudo dpkg -i /tmp/${LSD_DEB}
  sudo rm -f /tmp/${LSD_DEB}
fi

# npyvim is required for some neovim plugins
echo
echo "installing npyvim"
pip install --upgrade pip
pip install --upgrade pynvim
pip3 install --upgrade pip
pip3 install --upgrade pynvim

# install go
GO_VERSION=$(curl -sL 'https://go.dev/dl/' |grep 'linux-amd64' |grep -Eo 'go[0-9]+\.[0-9]+(\.[0-9]+){0,1}' |grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+){0,1}' |sort -V -u |tail -1)
cd /usr/local
sudo rm -f go
if [[ ! -d go-${GO_VERSION} ]]; then
  echo
  echo "installing go${GO_VERSION}"
  sudo curl -sLO https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
  sudo tar -xzf go${GO_VERSION}.linux-amd64.tar.gz
  sudo mv go go-${GO_VERSION}
  sudo rm -f go${GO_VERSION}.linux-amd64.tar.gz
fi
sudo ln -s go-${GO_VERSION} go

# zsh ftw
if [[ "${SHELL}" != "/bin/zsh" ]]; then
  echo
  echo "changing shell to zsh"
  chsh -s /bin/zsh
fi

# themes and such
echo
echo "installing themes"
$SCRIPTDIR/bootstrap.ubuntu.theme.sh

# make brave default browser
echo
echo "set brave as default browser"
sudo update-alternatives --config x-www-browser

# install tidal-hifi
echo
echo "installing tidal-hifi"
flatpak install -y flathub com.mastermindzh.tidal-hifi

# foot
echo "set foot as default terminal"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/foot 50
sudo update-alternatives --config x-terminal-emulator
if [[ "${XDG_CURRENT_DESKTOP}" == *"GNOME"* ]]; then
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/x-terminal-emulator
fi

mkdir -p ${HOME}/tmp
cat <<EOF >>${HOME}/tmp/bootstrap_TODO
- install and configure gnome shell extensions:
   - https://extensions.gnome.org/extension/1160/dash-to-panel/
   - https://extensions.gnome.org/extension/3193/blur-my-shell/
   - https://extensions.gnome.org/extension/4099/no-overview/
   - https://extensions.gnome.org/extension/19/user-themes/
- configure dash-to-panel to top, size 24, hide app launcher and desktop, opacity 40%
- fix ulauncher hotkey for wayland by setting in Settings > Keyboard > Customize Shortcuts > Custom Shortcuts > + cmd ulauncher-toggle
- set ulauncher theme to nord
- set up shortcuts for ulauncher
- restart gnome session to pick up flatpak
EOF
