#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

[[ ! -x $(which brew) ]] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew analytics off
brew update
brew upgrade
brew install $(cat ${SCRIPTDIR}/bootstrap.packages/osx.txt)

pip2 install --upgrade pip
pip2 install --upgrade pynvim
pip3 install --upgrade pip
pip3 install --upgrade pynvim
