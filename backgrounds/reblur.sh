#!/bin/bash

set -eo pipefail

SCRIPTDIR=$(cd `dirname $0` && pwd)

[[ ! -x $(which convert) ]] && echo "please install imagemagick" && exit 1

for b in $(find . -name '*.png' |grep -v '.blurred.'); do
  filename=$(basename -- "$b")
  extension="${filename##*.}"
  filename="${filename%.*}"
  filename=${filename}.blurred.${extensions}
  echo "blurring $b"
  if [[ -f ${filename} ]]; then
    echo "-> skipping: $filename already exists"
  else
    echo "-> blurred: $filename"
    convert $b -channel RGBA -gaussian-blur 0x32 ${filename}
  fi
done

echo "done."
