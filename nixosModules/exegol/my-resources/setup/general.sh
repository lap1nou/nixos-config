#!/bin/bash
source /opt/my-resources/setup/functions.sh

# Apply Firefox policy
cp /opt/my-resources/setup/firefox/policies.json /usr/lib/firefox-esr/distribution/

# Create directories
mkdir -p /workspace/loot /workspace/web

install_starship || true
install_atuin || true
install_obsidian || true
install_gum || true
install_exegol-history || true
install_vulnx || true
install_yq_go || true
install_rofi || true
config_burpsuite || true

asdf reshim golang

echo "source /opt/my-resources/setup/functions.sh" >> ~/.zshrc