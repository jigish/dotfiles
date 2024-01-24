#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

echo
echo "installing fonts"
cp -r ${SCRIPTDIR}/fonts/* ~/Library/Fonts/
