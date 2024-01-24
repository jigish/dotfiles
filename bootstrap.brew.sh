#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "bootstrapping via brew"

[[ ! -x $(which brew) ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off
brew update
brew upgrade
brew install $(cat ${SCRIPTDIR}/bootstrap.packages/osx.txt)

pip install --upgrade pip
pip install --upgrade pynvim
pip install --upgrade pyright

go install github.com/nametake/golangci-lint-langserver@latest
