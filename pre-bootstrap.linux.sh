#!/bin/bash

set -eo pipefail

CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

if [[ -f ${SCRIPTDIR}/pre-boostrap.${LINUX_DISTRO}.sh ]]; then
  echo "running pre-bootstrap for ${LINUX_DISTRO}"
  ${SCRIPTDIR}/pre-boostrap.${LINUX_DISTRO}.sh
else
  echo "no pre-bootstrap needed for ${LINUX_DISTRO}"
fi
