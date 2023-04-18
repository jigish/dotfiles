#!/bin/bash

[[ $UID == 0 ]] || { echo "run as sudo to install"; exit 1; }

SCRIPTDIR=$(cd `dirname $0` && pwd)

# set up brave repo
[[ -z "$(which curl)" ]] && apt install -y curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
[[ ! -f /etc/apt/sources.list.d/brave-browser-release.list ]]  && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list

apt update
apt upgrade -y
apt install -y $(cat $SCRIPTDIR/apt.txt)
apt autoremove -y
