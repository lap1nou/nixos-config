#!/bin/bash
set -e

# This script will be executed on the first startup of each new container with the "my-resources" feature enabled.
# Arbitrary code can be added in this file, in order to customize Exegol (dependency installation, configuration file copy, etc).
# It is strongly advised **not** to overwrite the configuration files provided by exegol (e.g. /root/.zshrc, /opt/.exegol_aliases, ...), official updates will not be applied otherwise.

# Exegol also features a set of supported customization a user can make.
# The /opt/supported_setups.md file lists the supported configurations that can be made easily.
#JAVA_HOME=/usr/lib/jvm/java-11-openjdk neo4j start
#local_ip=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}' | tr -d '\n')
#sed -i "s#\"bind_addr\": \"127.0.0.1:1030\",#\"bind_addr\": \"$local_ip:1030\",##" /opt/tools/BloodHound-CE/bloodhound.config.json

# Install DBAssets
#pipx install git+https://github.com/lap1nou/db-assets
#
## Adding a host entry for the domain if we are in a HTB container
#if [[ ! -z "${HTB}" ]]; then
#    echo $TARGET_TMP $DOMAIN_TMP >> /etc/hosts
#    dbassets add hosts --ip $TARGET_TMP -n $DOMAIN_TMP
#    echo "export TARGET=\"$TARGET_TMP\"" >> ~/.zshrc
#    echo "export IP=\"$TARGET_TMP\"" >> ~/.zshrc
#    echo "export DOMAIN=\"$DOMAIN_TMP\"" >> ~/.zshrc
#    echo "export HTB_NAME=\"$HTB_NAME_TMP\"" >> ~/.zshrc
#fi

# Starship install
#curl -s https://starship.rs/install.sh -o install.sh
#sh ./install.sh -f
#rm -f ./install.sh
#cp /opt/my-resources/setup/zsh/starship.toml ~/.config/starship.toml
#
## Create directories (/workspace/loot /workspace/notes)
#mkdir /workspace/loot /workspace/web
#
## Copy Obsidian template
#cp -R /opt/my-resources/setup/obsidian/notes/ /workspace/notes/
#
## Install Obsidian
#OBSIDIAN_VERSION="1.7.7"
#wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb
#dpkg -i obsidian_${OBSIDIAN_VERSION}_amd64.deb
#rm obsidian_${OBSIDIAN_VERSION}_amd64.deb
#
## Install Jython
#JYTHON_VERSION="2.7.4"
#mkdir /opt/tools/jython
#wget "https://repo1.maven.org/maven2/org/python/jython-standalone/${JYTHON_VERSION}/jython-standalone-${JYTHON_VERSION}.jar" -O "/opt/tools/jython/jython-standalone.jar"
#
## Copy custom Burpsuite config
#cp /opt/my-resources/setup/burpsuite/UserConfigCommunity.json ~/.BurpSuite/
#
## Download / install Burpsuite extensions
#BURPSUITE_EXTENSIONS_PATH='/opt/tools/BurpSuiteCommunity/extensions'
#mkdir $BURPSUITE_EXTENSIONS_PATH
#wget 'https://github.com/PortSwigger/hackvertor/releases/download/latest_hackvertor_release/hackvertor-all.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/hackvertor-all.jar"
#wget 'https://github.com/PortSwigger/logger-plus-plus/releases/download/latest/LoggerPlusPlus.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/LoggerPlusPlus.jar"
#wget 'https://github.com/lap1nou/sharpener/releases/download/latest2/sharpener.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/sharpener.jar"
#wget 'https://github.com/lap1nou/piper/releases/download/latest/piper.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/piper.jar"
#wget 'https://github.com/lap1nou/jwt-editor/releases/download/latest/jwt-editor-2.5.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/jwt-editor-2.5.jar"
#
#mkdir $BURPSUITE_EXTENSIONS_PATH/autorize
#git clone https://github.com/PortSwigger/autorize.git $BURPSUITE_EXTENSIONS_PATH/autorize
#
#mkdir $BURPSUITE_EXTENSIONS_PATH/SAML
#git clone https://github.com/PortSwigger/saml-editor.git $BURPSUITE_EXTENSIONS_PATH/SAML
#
## Copy Foxyproxy configuration
#cp /opt/my-resources/setup/foxyproxy/FoxyProxy.json /workspace/
#
## Remove Firefox extensions and bookmark installed by Exegol
#rm /root/.mozilla/firefox/*.Exegol/extensions/*
#rm /root/.mozilla/firefox/*.Exegol/places.sqlite
#
## Apply Firefox policy
#cp /opt/my-resources/setup/firefox/policies.json /usr/lib/firefox-esr/distribution/