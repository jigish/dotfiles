#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "bootstrapping via cargo"

[[ ! -x $(which cargo) ]] && echo "cargo not found" && exit 1
cargo install $(cat ${SCRIPTDIR}/bootstrap.packages/cargo.txt)
