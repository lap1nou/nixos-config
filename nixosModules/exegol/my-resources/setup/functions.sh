LOG_FILE="/tmp/setup_log.txt"

# Root my-resources PATH
MY_ROOT_PATH="/opt/my-resources"

# Setup directory for user customization
MY_SETUP_PATH="$MY_ROOT_PATH/setup"

function install_starship() {
  echo "[*] Installing Starship"
  curl -s https://starship.rs/install.sh -o install.sh
  sh ./install.sh -f
  rm -f ./install.sh
  cp /opt/my-resources/setup/zsh/starship.toml ~/.config/starship.toml

  # Removing the Exh hook since Starship is taking care of everything
  sed -i -e 's/add-zsh-hook precmd update_prompt/#add-zsh-hook precmd update_prompt/g' ~/.zshrc
}

function install_atuin() {
  echo "[*] Installing Atuin"
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  cp /opt/my-resources/setup/atuin/config.toml ~/.config/atuin/config.toml
  /root/.atuin/bin/atuin import zsh
}

function install_obsidian() {
  echo "[*] Installing Obsidian"
  local OBSIDIAN_VERSION="1.12.7"
  wget -q https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb
  dpkg -i obsidian_${OBSIDIAN_VERSION}_amd64.deb
  rm obsidian_${OBSIDIAN_VERSION}_amd64.deb

  # Copy Obsidian template
  cp -R /opt/my-resources/setup/obsidian/notes/ /workspace/notes/

  # Copy Obsidian .desktop
  cp /opt/my-resources/setup/obsidian.desktop /usr/share/applications/
}

function config_burpsuite() {
  echo "[*] Configure Burpsuite"

  echo "[*] Install Jython"
  local JYTHON_VERSION="2.7.4"
  mkdir /opt/tools/BurpSuiteCommunity/jython
  wget -q "https://repo1.maven.org/maven2/org/python/jython-standalone/${JYTHON_VERSION}/jython-standalone-${JYTHON_VERSION}.jar" -O "/opt/tools/BurpSuiteCommunity/jython/jython-standalone.jar"

  echo "[*] Install Jruby"
  local JRUBY_VERSION="9.4.12.0"
  mkdir /opt/tools/BurpSuiteCommunity/jruby
  wget -q https://repo1.maven.org/maven2/org/jruby/jruby-complete/${JRUBY_VERSION}/jruby-complete-${JRUBY_VERSION}.jar -O "/opt/tools/BurpSuiteCommunity/jruby/jruby-standalone.jar"

  # Copy custom Burpsuite config
  [[ -f "$MY_SETUP_PATH/burpsuite/UserConfigCommunity.json" ]] && cp "$MY_SETUP_PATH/burpsuite/UserConfigCommunity.json" "/root/.BurpSuite/UserConfigCommunity.json"

  pip3 install -r "$MY_SETUP_PATH/burpsuite/requirements.txt"
  python3 "$MY_SETUP_PATH/burpsuite/generate_config.py"

  if [ -f /opt/my-resources/setup/burpsuite/prefs.xml ]; then # Burp pro license is present
    cp /opt/my-resources/setup/burpsuite/prefs.xml /root/.java/.userPrefs/burp/prefs.xml # Source: https://blog.gregscharf.com/2025/07/23/burp-suite-pro-install-in-exegol/
    cp /root/.BurpSuite/UserConfigCommunity.json ~/.BurpSuite/UserConfigPro.json
    cp -R /opt/my-resources/setup/burpsuite/BurpSuitePro/ /opt/tools/
    trust_ca_burp_pro_in_firefox
  fi
}

function trust_ca_burp_pro_in_firefox() {
  echo "Generating Burp CA and trusting in Firefox"
  if [[ -d "/opt/tools/BurpSuiteCommunity/" ]]; then
    echo 'Looking for available port'
    # Find an available port for Burp to listen
    local burp_port=8080

    echo 'Starting Burp and waiting for proxy to listen'

    local burp_pro_path="/opt/tools/BurpSuitePro"
    echo y|/usr/lib/jvm/java-21-openjdk/bin/java -Djava.awt.headless=true -jar "$burp_pro_path/burpsuite.jar" --config-file=/opt/tools/BurpSuiteCommunity/conf.json 2>&1 > /dev/null &

    # pull the latest process's ID
    local burp_pid=$!

    # Define Timeout counter
    local timeout_counter
    timeout_counter=0
    # Let time to Burp to init CA
    while [[ -z $(netstat -lnt|grep -Eo "(127.0.0.1|0.0.0.0):$burp_port") ]]
    do
      if (( $timeout_counter < 120 )); then
        sleep 0.5
        timeout_counter=$((timeout_counter+1))
      else
        kill "$burp_pid"
        rm -r "$(find /tmp/burp*.tmp -type d -printf '%T+ %p\n' | sort | head -n 1 | cut -d ' ' -f2)"  # Remove burp tmp files
        echo 'Process timed out, please trust the CA manually.'
        exit 1
      fi
    done

    # Download the CA to /tmp and update the CA path
    echo 'Retrieving CA'
    local burp_ca_path="/opt/tools/firefox/cacert.der"
    local burp_ca_name="PortSwigger CA"
    if ! wget -q "http://127.0.0.1:$burp_port/cert" -O "$burp_ca_path"; then
      kill "$burp_pid"
      rm -r "$(find /tmp/burp*.tmp -type d -printf '%T+ %p\n' | sort | head -n 1 | cut -d ' ' -f2)"  # Remove burp tmp files
      echo 'The CA cert could not be retrieved, please trust it manually'
    fi
    kill "$burp_pid"
    rm -r "$(find /tmp/burp*.tmp -type d -printf '%T+ %p\n' | sort | head -n 1 | cut -d ' ' -f2)"  # Remove burp tmp files
    echo 'CA trusted successfully'
  fi
}

function install_secator() {
  echo "[*] Installing Secator"

  pipx install secator
}

function install_unfurl() {
  echo "[*] Installing Unfurl"

  local UNFURL_VERSION="v0.4.3"
  go install github.com/tomnomnom/unfurl@$UNFURL_VERSION

  asdf reshim golang
}

function install_vulnx() {
  echo "[*] Installing Vulnx"

  local VULNX_VERSION="v2.0.1"
  asdf set golang 1.23.0

  go install github.com/projectdiscovery/vulnx/v2/cmd/vulnx@$VULNX_VERSION

  asdf reshim golang
}

function install_tlsx() {
  echo "[*] Installing Tlsx"

  local TLSX_VERSION="v1.2.2"
  asdf set golang 1.26.1

  go install github.com/projectdiscovery/tlsx/cmd/tlsx@$TLSX_VERSION

  asdf reshim golang
}

function install_urlfinder() {
  echo "[*] Installing Urlfinder"

  local URLFINDER_VERSION="v0.0.3"
  asdf set golang 1.23.0

  go install github.com/projectdiscovery/urlfinder/cmd/urlfinder@$URLFINDER_VERSION

  asdf reshim golang
}

function install_mapcidr() {
  echo "[*] Installing Mapcidr"

  asdf set golang 1.26.1

  go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

  asdf reshim golang
}

function install_yq_go() {
  echo "[*] Installing Yq-go"
  local VERSION=v4.48.1
  local PLATFORM=linux_amd64
  wget -q "https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${PLATFORM}" -O /opt/tools/bin/yq-go
  chmod +x /opt/tools/bin/yq-go
}

function install_gum() {
  echo "[*] Installing Gum"

  asdf set golang 1.23.0

  go install github.com/charmbracelet/gum@latest

  asdf reshim golang
}

function install_anew() {
  echo "[*] Installing Anew"

  local ANEW_VERSION="v0.1.1"
  go install github.com/tomnomnom/anew@$ANEW_VERSION

  asdf reshim golang
}

function install_massdns() {
    echo "[*] Installing Massdns"
    git -C /opt/tools clone --depth 1 https://github.com/blechschmidt/massdns.git
    cd /opt/tools/massdns || exit
    make
    ln -s /opt/tools/massdns/bin/massdns /opt/tools/bin/massdns
}

function install_exegol-history() {
  echo "[*] Installing Exegol-History"
  rm -rf /opt/tools/Exegol-history/
  uv tool install git+https://github.com/ThePorgs/Exegol-history@dev --force
  register-python-argcomplete exegol-history >> ~/.zshrc
  # Copy profile.sh
  wget -q https://raw.githubusercontent.com/ThePorgs/Exegol-history/refs/heads/dev/profile.sh -O /root/.local/share/uv/tool/exegol-history/lib/python3.11/site-packages/profile.sh
}

function install_web-server() {
  echo "[*] Installing Web-server"
  uv tool install git+https://github.com/lap1nou/web-server --force
}

function install_uv() {
    echo "[*] Installing uv"
    pipx install uv
}

function install_vscode() {
    echo "[*] Installing VSCode"
    wget -q "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O code.deb
    dpkg -i code.deb
    rm -f code.deb

    echo "[*] Installing VSCode extensions"
    code --no-sandbox --user-data-dir "/root" --install-extension MS-SarifVSCode.sarif-viewer
}

function install_safe-chain() {
  echo "[*] Installing safe-chain"

  curl -fsSL https://github.com/AikidoSec/safe-chain/releases/latest/download/install-safe-chain.sh | sh
}

function htb_add_dns() {
	cat <<EOF >> /etc/dnsmasq.conf
	    no-dhcp-interface=
	    server=1.1.1.1
	    server=/$DOMAIN.htb/$DC_IP
EOF

	service dnsmasq start
}

function install_agg() {
  echo "[*] Installing Agg"

  cargo install --git https://github.com/asciinema/agg
}

function install_syphoon() {
  echo "[*] Installing Syphoon"

  if [[ -d "/opt/my-resources/setup/syphoon/" ]]; then
    echo "[*] Syphoon binary present"
    cp -r "/opt/my-resources/setup/syphoon/" "/opt/tools/"
    lv -v -s "/opt/my-resources/setup/syphoon/syphoon" "/opt/tools/bin/syphoon"
  fi
}

function install_dbeaver() {
    echo "[*] Installing DBeaver"
    local VERSION="26.1.5"
    wget -q "https://github.com/dbeaver/dbeaver/releases/download/$VERSION/dbeaver-ce-$VERSION-linux-x86_64.deb" -O /tmp/dbeaver.deb
    dpkg -i /tmp/dbeaver.deb
    rm -f /tmp/dbeaver.deb
}

function config_nxc() {
  echo "[*] Configure NXC"

  sed -i "s/audit_mode =/audit_mode = */" ~/.nxc/nxc.conf
  sed -i "s/reveal_chars_of_pwd = 0/reveal_chars_of_pwd = 2/" ~/.nxc/nxc.conf
}

function install_revshell-gen() {
  echo "[*] Installing revshell-gen"

  uv tool install git+https://github.com/lap1nou/revshell-gen@master --force
}

function install_claude_code() {
  echo "[*] Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
}
