#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer
