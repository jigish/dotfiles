#!/bin/bash

set -eo pipefail

# sets desktop background and blurred version for login screen
export DESKTOP_BACKGROUND=groot.png

# directory to use to download / clone anything for easy cleanup if necessary
export TWEAKS_DIR=${HOME}/.${USER}-tweaks

# nordic theme subtype darker|Polar|bluish-accent
export NORDIC_THEME_SUBTYPE=bluish-accent

# ------------------------------------------------------------------------------------------------------------------------------------

# assume we've run ./reblur.sh and this exists
db_blurred=$(basename -- "$DESKTOP_BACKGROUND")
db_blurred_ext="${db_blurred##*.}"
db_blurred="${db_blurred%.*}"
export DESKTOP_BACKGROUND_BLURRED="${db_blurred}.blurred.${db_blurred_ext}"

# set up theme-related vars
if [[ ! -z "${NORDIC_THEME_SUBTYPE}" ]]; then
  export NORDIC_THEME_SUBTYPE="-${NORDIC_THEME_SUBTYPE}"
fi
export NORDIC_THEME="Nordic${NORDIC_THEME_SUBTYPE}-standard-buttons"

# set up os indentification vars
export BOOTSTRAP_OS=$(uname | tr '[[:upper:]]' '[[:lower:]]')
if [[ "${BOOTSTRAP_OS}" = "linux" ]]; then
  if [[ -f /etc/os-release ]]; then
    export LINUX_DISTRO=$(cat /etc/os-release |grep ID |sed -e 's/^ID=//g')
  else
    echo "you're running on some non-systemd linux distribution dude: no /etc/os-release" >&2
    exit 1
  fi
else
  echo "you're running on some bullshit os dude: ${BOOTSTRAP_OS}" >&2
  exit 1
fi
