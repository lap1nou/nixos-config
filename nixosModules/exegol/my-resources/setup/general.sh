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
install_starship || true
install_atuin || true
install_obsidian || true
install_exegol-history || true
install_web-server || true
install_vulnx || true
install_yq_go || true
install_vscode || true
config_burpsuite || true

rm /workspace/.tool-versions

echo "source /opt/my-resources/setup/functions.sh" >> ~/.zshrc