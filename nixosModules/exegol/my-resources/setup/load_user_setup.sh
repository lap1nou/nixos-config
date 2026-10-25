#!/bin/bash
set -e

# This script will be executed on the first startup of each new container with the "my-resources" feature enabled.
# Arbitrary code can be added in this file, in order to customize Exegol (dependency installation, configuration file copy, etc).
# It is strongly advised **not** to overwrite the configuration files provided by exegol (e.g. /root/.zshrc, /opt/.exegol_aliases, ...), official updates will not be applied otherwise.

# Exegol also features a set of supported customization a user can make.
# The /opt/supported_setups.md file lists the supported configurations that can be made easily.
/opt/my-resources/setup/general.sh

if [[ "${EXGL_PROFILE}" = "internal" ]]; then
  /opt/my-resources/setup/internal.sh
elif [[ "${EXGL_PROFILE}" = "external" ]]; then
  /opt/my-resources/setup/external.sh
fi
