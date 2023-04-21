#!/bin/bash

set -eo pipefail

# sets desktop background and blurred version for login screen
export DESKTOP_BACKGROUND=groot.png

# directory to use to download / clone anything for easy cleanup if necessary
export TWEAKS_DIR=${HOME}/.${USER}-tweaks

# ------------------------------------------------------------------------------------------------------------------------------------

# assume we've run ./reblur.sh and this exists
db_blurred=$(basename -- "$DESKTOP_BACKGROUND")
db_blurred_ext="${db_blurred##*.}"
db_blurred="${db_blurred%.*}"
export DESKTOP_BACKGROUND_BLURRED=${db_blurred}.blurred.${db_blurred_ext}
