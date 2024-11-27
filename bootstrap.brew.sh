#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "bootstrapping via brew"

[[ ! -x $(which brew) ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off
brew update
brew upgrade
brew install $(cat ${SCRIPTDIR}/bootstrap.packages/osx.txt)

[[ -f ~/.bootstrap.packages.local ]] && brew install $(cat ~/.bootstrap.packages.local)

go install github.com/nametake/golangci-lint-langserver@latest
