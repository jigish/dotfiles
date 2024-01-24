#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "installing rust"
rustup-init -y
rustup component add rust-analyzer
