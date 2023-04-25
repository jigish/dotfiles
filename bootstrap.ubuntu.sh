#!/bin/bash

set -eo pipefail


CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

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
sudo apt install -y $(cat $SCRIPTDIR/apt.txt)
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

#install lsd
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

# install kitty
mkdir -p ~/.local/bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
  launch=n
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
