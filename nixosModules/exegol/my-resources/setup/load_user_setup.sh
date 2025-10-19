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

function install_starship() {
  curl -s https://starship.rs/install.sh -o install.sh
  sh ./install.sh -f
  rm -f ./install.sh
  cp /opt/my-resources/setup/zsh/starship.toml ~/.config/starship.toml
}

# Create directories (/workspace/loot /workspace/notes)
mkdir /workspace/loot /workspace/web

# Copy Obsidian template
cp -R /opt/my-resources/setup/obsidian/notes/ /workspace/notes/

function install_obsidian() {
  OBSIDIAN_VERSION="1.9.14"
  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb
  dpkg -i obsidian_${OBSIDIAN_VERSION}_amd64.deb
  rm obsidian_${OBSIDIAN_VERSION}_amd64.deb
}

function config_burpsuite() {
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
  pipx install secator
}

function install_unfurl() {
  go install github.com/tomnomnom/unfurl@latest
}

# Install smap
function install_smap() {
  mkdir -p /opt/tools/smap || exit
  cd /opt/tools/smap || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/smap/.go/bin go install -v github.com/s0md3v/smap/cmd/smap@latest
  ln -s /opt/tools/smap/.go/bin/smap /opt/tools/bin/smap
}

function install_vulnx() {
  mkdir -p /opt/tools/vulnx || exit
  cd /opt/tools/vulnx || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/vulnx/.go/bin go install -v go install github.com/projectdiscovery/cvemap/cmd/vulnx@latest
  ln -s /opt/tools/vulnx/.go/bin/vulnx /opt/tools/bin/vulnx
}

function install_tlsx() {
  mkdir -p /opt/tools/tlsx || exit
  cd /opt/tools/tlsx || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/tlsx/.go/bin go install -v github.com/projectdiscovery/tlsx/cmd/tlsx@latest
  ln -s /opt/tools/tlsx/.go/bin/tlsx /opt/tools/bin/tlsx
}

function install_urlfinder() {
  mkdir -p /opt/tools/urlfinder || exit
  cd /opt/tools/urlfinder || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/urlfinder/.go/bin go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest
  ln -s /opt/tools/gum/.go/bin/gum /opt/tools/bin/urlfinder
}

function install_yq_go() {
  VERSION=v4.2.0
  PLATFORM=linux_amd64
  wget "https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${PLATFORM}" -O /opt/tools/bin/yq-go
  chmod +x /opt/tools/bin/yq-go
}

function install_gum() {
  mkdir -p /opt/tools/gum || exit
  cd /opt/tools/gum || exit
  asdf set golang 1.23.0
  mkdir -p .go/bin
  GOBIN=/opt/tools/gum/.go/bin go install -v github.com/charmbracelet/gum@latest
  ln -s /opt/tools/gum/.go/bin/gum /opt/tools/bin/gum
}

function install_anew() {
  go install -v github.com/tomnomnom/anew@latest
}

install_starship
install_obsidian
install_secator
install_unfurl
install_smap
install_vulnx
install_tlsx
install_urlfinder
install_yq_go
install_gum
install_anew

config_burpsuite

# Download Trickest resolvers.txt
wget https://raw.githubusercontent.com/trickest/resolvers/refs/heads/main/resolvers.txt -O /opt/lists/resolvers.txt

asdf set golang 1.22.2
asdf reshim golang
