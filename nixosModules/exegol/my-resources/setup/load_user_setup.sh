#!/bin/bash
set -e

# This script will be executed on the first startup of each new container with the "my-resources" feature enabled.
# Arbitrary code can be added in this file, in order to customize Exegol (dependency installation, configuration file copy, etc).
# It is strongly advised **not** to overwrite the configuration files provided by exegol (e.g. /root/.zshrc, /opt/.exegol_aliases, ...), official updates will not be applied otherwise.

# Exegol also features a set of supported customization a user can make.
# The /opt/supported_setups.md file lists the supported configurations that can be made easily.

# Adding a host entry for the domain if we are in a HTB container
#if [[ ! -z "${HTB}" ]]; then
#    echo $TARGET_TMP $DOMAIN_TMP >> /etc/hosts
#    dbassets add hosts --ip $TARGET_TMP -n $DOMAIN_TMP
#    echo "export TARGET=\"$TARGET_TMP\"" >> ~/.zshrc
#    echo "export IP=\"$TARGET_TMP\"" >> ~/.zshrc
#    echo "export DOMAIN=\"$DOMAIN_TMP\"" >> ~/.zshrc
#    echo "export HTB_NAME=\"$HTB_NAME_TMP\"" >> ~/.zshrc
#fi

cp /opt/my-resources/setup/zsh/api_key.sh /root/api_key.sh
cp /opt/my-resources/setup/zsh/setup_api_key.sh /root/setup_api_key.sh

# Removing the Exh hook since Starship is taking care of everything
sed -i -e 's/add-zsh-hook precmd update_prompt/#add-zsh-hook precmd update_prompt/g' ~/.zshrc

LOG_FILE="/tmp/setup_log.txt"

# Create directories (/workspace/loot /workspace/notes)
mkdir -p /workspace/loot /workspace/web

# Copy Obsidian template
cp -R /opt/my-resources/setup/obsidian/notes/ /workspace/notes/

function install_starship() {
  echo "[*] Installing Starship" >> ${LOG_FILE}
  curl -s https://starship.rs/install.sh -o install.sh
  sh ./install.sh -f
  rm -f ./install.sh
  cp /opt/my-resources/setup/zsh/starship.toml ~/.config/starship.toml
}

function install_atuin() {
  echo "[*] Installing Atuin" >> ${LOG_FILE}
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  cp /opt/my-resources/setup/atuin/config.toml ~/.config/atuin/config.toml
}

function install_obsidian() {
  echo "[*] Installing Obsidian" >> ${LOG_FILE}
  OBSIDIAN_VERSION="1.9.14"
  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb
  dpkg -i obsidian_${OBSIDIAN_VERSION}_amd64.deb
  rm obsidian_${OBSIDIAN_VERSION}_amd64.deb
}

function config_burpsuite() {
  echo "[*] Configure Burpsuite" > ${LOG_FILE}
  # Install Jython
  JYTHON_VERSION="2.7.4"
  mkdir /opt/tools/jython
  wget "https://repo1.maven.org/maven2/org/python/jython-standalone/${JYTHON_VERSION}/jython-standalone-${JYTHON_VERSION}.jar" -O "/opt/tools/jython/jython-standalone.jar"

  # Copy custom Burpsuite config
  cp /opt/my-resources/setup/burpsuite/UserConfigCommunity.json ~/.BurpSuite/

  # Download / install Burpsuite extensions
  BURPSUITE_EXTENSIONS_PATH='/opt/tools/BurpSuiteCommunity/extensions'
  mkdir $BURPSUITE_EXTENSIONS_PATH
  wget 'https://github.com/PortSwigger/hackvertor/releases/download/latest_hackvertor_release/hackvertor-all.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/hackvertor-all.jar"
  wget 'https://github.com/PortSwigger/logger-plus-plus/releases/download/latest/LoggerPlusPlus.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/LoggerPlusPlus.jar"
  wget 'https://github.com/lap1nou/sharpener/releases/download/latest2/sharpener.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/sharpener.jar"
  wget 'https://github.com/lap1nou/piper/releases/download/latest/piper.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/piper.jar"
  wget 'https://github.com/lap1nou/jwt-editor/releases/download/latest/jwt-editor-2.5.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/jwt-editor-2.5.jar"

  mkdir $BURPSUITE_EXTENSIONS_PATH/autorize
  git clone https://github.com/PortSwigger/autorize.git $BURPSUITE_EXTENSIONS_PATH/autorize

  mkdir $BURPSUITE_EXTENSIONS_PATH/SAML
  git clone https://github.com/PortSwigger/saml-editor.git $BURPSUITE_EXTENSIONS_PATH/SAML
}

# Apply Firefox policy
cp /opt/my-resources/setup/firefox/policies.json /usr/lib/firefox-esr/distribution/

function install_secator() {
  echo "[*] Installing Secator" >> ${LOG_FILE}
  pipx install secator
}

function install_unfurl() {
  echo "[*] Installing Unfurl" >> ${LOG_FILE}
  go install github.com/tomnomnom/unfurl@latest
}

# Install smap
function install_smap() {
  echo "[*] Installing Smap" >> ${LOG_FILE}
  mkdir -p /opt/tools/smap || exit
  cd /opt/tools/smap || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/smap/.go/bin go install -v github.com/s0md3v/smap/cmd/smap@latest
  ln -s /opt/tools/smap/.go/bin/smap /opt/tools/bin/smap
}

function install_vulnx() {
  echo "[*] Installing Vulnx" >> ${LOG_FILE}
  mkdir -p /opt/tools/vulnx || exit
  cd /opt/tools/vulnx || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/vulnx/.go/bin go install -v github.com/projectdiscovery/cvemap/cmd/vulnx@latest
  ln -s /opt/tools/vulnx/.go/bin/vulnx /opt/tools/bin/vulnx
}

function install_tlsx() {
  echo "[*] Installing Tlsx" >> ${LOG_FILE}
  mkdir -p /opt/tools/tlsx || exit
  cd /opt/tools/tlsx || exit
  asdf set golang 1.24.1
  mkdir -p .go/bin
  GOBIN=/opt/tools/tlsx/.go/bin go install -v github.com/projectdiscovery/tlsx/cmd/tlsx@latest
  ln -s /opt/tools/tlsx/.go/bin/tlsx /opt/tools/bin/tlsx
}

function install_urlfinder() {
  echo "[*] Installing Urlfinder" >> ${LOG_FILE}
  mkdir -p /opt/tools/urlfinder || exit
  cd /opt/tools/urlfinder || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/urlfinder/.go/bin go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest
  ln -s /opt/tools/urlfinder/.go/bin/urlfinder /opt/tools/bin/urlfinder
}

function install_mapcidr() {
  echo "[*] Installing Mapcidr" >> ${LOG_FILE}
  mkdir -p /opt/tools/mapcidr || exit
  cd /opt/tools/mapcidr || exit
  asdf set golang 1.24.1
  mkdir -p .go/bin
  GOBIN=/opt/tools/mapcidr/.go/bin go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
  ln -s /opt/tools/mapcidr/.go/bin/mapcidr /opt/tools/bin/mapcidr
}

function install_yq_go() {
  echo "[*] Installing Yq-go" >> ${LOG_FILE}
  VERSION=v4.48.1
  PLATFORM=linux_amd64
  wget "https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${PLATFORM}" -O /opt/tools/bin/yq-go
  chmod +x /opt/tools/bin/yq-go
}

function install_gum() {
  echo "[*] Installing Gum" >> ${LOG_FILE}
  mkdir -p /opt/tools/gum || exit
  cd /opt/tools/gum || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/gum/.go/bin go install -v github.com/charmbracelet/gum@latest
  ln -s /opt/tools/gum/.go/bin/gum /opt/tools/bin/gum
}

function install_massdns() {
    echo "[*] Installing Massdns" >> ${LOG_FILE}
    git -C /opt/tools clone --depth 1 https://github.com/blechschmidt/massdns.git
    cd /opt/tools/massdns || exit
    make
    ln -s /opt/tools/massdns/bin/massdns /opt/tools/bin/massdns
}

function install_exegol-history() {
  echo "[*] Installing Exegol-History" >> ${LOG_FILE}
  rm -rf /opt/tools/Exegol-history/
  git -C /opt/tools/ clone -b dev https://github.com/ThePorgs/Exegol-history
  cd /opt/tools/Exegol-history || exit
  pipx install --force --system-site-packages /opt/tools/Exegol-history
}

install_starship
install_atuin
install_obsidian
install_secator
install_unfurl
install_smap
install_vulnx
install_tlsx
install_urlfinder
install_mapcidr
install_yq_go
install_gum
install_massdns
install_exegol-history

asdf reshim golang

atuin import zsh

# Download Trickest resolvers.txt
wget https://raw.githubusercontent.com/trickest/resolvers/refs/heads/main/resolvers.txt -O /opt/lists/resolvers.txt

config_burpsuite
