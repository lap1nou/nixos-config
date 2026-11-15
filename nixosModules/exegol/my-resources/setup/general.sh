#!/bin/bash
source /opt/my-resources/setup/functions.sh

# Apply Firefox policy
cp /opt/my-resources/setup/firefox/policies.json /usr/lib/firefox-esr/distribution/

# Create directories
FOLDERS=("loot" "web" "output" "notes" "targets" "receipts")
for folder in "${FOLDERS[@]}"; do
  mkdir -p "/workspace/$folder"
done

NOTE_FOLDERS=("vuln" "screenshot")
for note_folder in "${NOTE_FOLDERS[@]}"; do
  mkdir -p "/workspace/notes/$note_folder"
done

TOOLS=("nxc" "nmap" "httpx" "naabu" "certipy" "nuclei" "gobuster" "bloodhound")
for tool in "${TOOLS[@]}"; do
  mkdir -p "/workspace/output/$tool"
done

# Manage Golang versions
asdf install golang 1.26.1
asdf set --home golang 1.22.2 1.23.0 1.26.1

INSTALLS=(
  install_safe-chain
  install_starship
  install_atuin
  install_obsidian
  install_uv
  install_yq_go
  install_exegol-history
  install_web-server
  install_revshell-gen
  install_vscode
  install_syphoon
  install_gum
  config_nxc
  config_burpsuite
)

FAILED=()
for fn in "${INSTALLS[@]}"; do
  "$fn" || { echo "[-] $fn failed, skipping"; }
done

rm -f /workspace/.tool-versions

echo "source /opt/my-resources/setup/functions.sh" >> ~/.zshrc
