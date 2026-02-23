#!/bin/bash
source /opt/my-resources/setup/functions.sh

# Download Trickest resolvers.txt
wget https://raw.githubusercontent.com/trickest/resolvers/refs/heads/main/resolvers.txt -O /opt/lists/resolvers.txt

cp /opt/my-resources/setup/zsh/api_key.sh /root/api_key.sh
cp /opt/my-resources/setup/zsh/setup_api_key.sh /root/setup_api_key.sh

install_secator || true
install_unfurl || true
install_smap || true
install_tlsx || true
install_urlfinder || true
install_mapcidr || true
#install_anew || true
#install_massdns || true