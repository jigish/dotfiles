#!/bin/bash

set -eo pipefail


CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

export TWEAKS_DIR=${HOME}/.${USER}-tweaks
mkdir -p ${TWEAKS_DIR}

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# create Links
cd ~
echo
echo "installing fonts"
mkdir -p ~/.fonts
mkdir -p ~/.local/share/fonts
cp $SCRIPTDIR/fonts/*.ttf ~/.fonts/
cp $SCRIPTDIR/fonts/*.otf ~/.fonts/
cp $SCRIPTDIR/fonts/*.ttf ~/.local/share/fonts/
cp $SCRIPTDIR/fonts/*.otf ~/.local/share/fonts/

# install packages
echo
echo "bootstrapping via apt"
sudo $SCRIPTDIR/bootstrap.apt.sh

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
sudo $SCRIPTDIR/bootstrap.go.Linux.sh

# zsh ftw
if [[ "${SHELL}" != "/bin/zsh" ]]; then
  echo
  echo "changing shell to zsh"
  chsh -s /bin/zsh
fi

# themes and such
$SCRIPTDIR/bootstrap.theme.sh

# make brave default browser
echo
echo "set brave as default browser"
sudo update-alternatives --config x-www-browser

# install tidal-hifi
$SCRIPTDIR/bootstrap.tidal.sh

cd $CURRDIR
