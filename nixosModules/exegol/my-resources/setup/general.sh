#!/bin/bash
source /opt/my-resources/setup/functions.sh

# Apply Firefox policy
cp /opt/my-resources/setup/firefox/policies.json /usr/lib/firefox-esr/distribution/

# Create directories
mkdir -p /workspace/loot /workspace/web

# Manage Golang versions
asdf install golang 1.26.1
asdf set --home golang 1.22.2 1.23.0 1.26.1

install_safe-chain || exit
install_starship || exit
install_atuin || exit
install_obsidian || exit
install_uv || exit
install_yq_go || exit
install_exegol-history || exit
install_web-server || exit
install_revshell-gen || exit
install_vulnx || exit
install_vscode || exit
install_syphoon || exit
config_nxc || exit
config_burpsuite || exit

rm /workspace/.tool-versions

echo "source /opt/my-resources/setup/functions.sh" >> ~/.zshrc
