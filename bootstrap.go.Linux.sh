#!/bin/bash

[[ $UID == 0 ]] || { echo "run as root to install"; exit 1; }

GO_VERSION=$(curl -sL 'https://go.dev/dl/' |grep 'linux-amd64' |grep -Eo 'go[0-9]+\.[0-9]+(\.[0-9]+){0,1}' |grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+){0,1}' |sort -V -u |tail -1)

cd /usr/local
rm -f go
if [[ ! -d go-${GO_VERSION} ]]; then
  echo
  echo "installing go${GO_VERSION}"
  curl -sLO https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
  tar -xzf go${GO_VERSION}.linux-amd64.tar.gz
  mv go go-${GO_VERSION}
  rm -f go${GO_VERSION}.linux-amd64.tar.gz
fi
ln -s go-${GO_VERSION} go
