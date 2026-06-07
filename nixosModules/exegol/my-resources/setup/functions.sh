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
  OBSIDIAN_VERSION="1.9.14"
  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb
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
  JYTHON_VERSION="2.7.4"
  mkdir /opt/tools/BurpSuiteCommunity/jython
  wget "https://repo1.maven.org/maven2/org/python/jython-standalone/${JYTHON_VERSION}/jython-standalone-${JYTHON_VERSION}.jar" -O "/opt/tools/BurpSuiteCommunity/jython/jython-standalone.jar"

  echo "[*] Install Jruby"
  JRUBY_VERSION="9.4.12.0"
  mkdir /opt/tools/BurpSuiteCommunity/jruby
  wget https://repo1.maven.org/maven2/org/jruby/jruby-complete/${JRUBY_VERSION}/jruby-complete-${JRUBY_VERSION}.jar -O "/opt/tools/BurpSuiteCommunity/jruby/jruby-standalone.jar"

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
  logger_verbose "Generating Burp CA and trusting in Firefox"
  if [[ -d "/opt/tools/BurpSuiteCommunity/" ]]; then
    logger_debug 'Looking for available port'
    # Find an available port for Burp to listen
    local burp_port=8080
    # TODO : add the dynamic port finder
    # TODO : when dynamic port finder used, remove the code below that iterates on 8080++ until it finds one
    local listening_ports
    listening_ports=$(netstat -lnt|grep -Eo '(127.0.0.1|0.0.0.0):[0-9]{1,5}'|cut -d ':' -f 2)
    while [[ $listening_ports =~ .*$burp_port.* ]]
    do
      burp_port=$((burp_port+1))
    done
    # Edit configuration file to listen on the available port found
    logger_debug 'Preparing burp configuration file'
    sed -i "s/\"listener_port\":[0-9]\+/\"listener_port\":$burp_port/g" /opt/tools/BurpSuiteCommunity/conf.json
    # Start Burp with "y" to accept policy and generate CA, keep its PID to kill it when done
    logger_debug 'Starting Burp and waiting for proxy to listen'

    local $burp_pro_path="/opt/tools/BurpSuitePro"
    echo y|/usr/lib/jvm/java-21-openjdk/bin/java -Djava.awt.headless=true -jar "$burp_pro_path/BurpSuite" --config-file=/opt/tools/BurpSuiteCommunity/conf.json 2>&1 > /dev/null &

    # pull the latest process's ID
    local burp_pid=$!
    # Define Timeout counter
    # TODO: Upgrade timeout with better process
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
        logger_error 'Process timed out, please trust the CA manually.'
        exit 1
      fi
    done
    # Download the CA to /tmp and update the CA path
    logger_debug 'Retrieving CA'
    local burp_ca_path="/opt/tools/firefox/cacert.der"
    local burp_ca_name="PortSwigger CA"
    if ! wget -q "http://127.0.0.1:$burp_port/cert" -O "$burp_ca_path"; then
      kill "$burp_pid"
      rm -r "$(find /tmp/burp*.tmp -type d -printf '%T+ %p\n' | sort | head -n 1 | cut -d ' ' -f2)"  # Remove burp tmp files
      logger_error 'The CA cert could not be retrieved, please trust it manually'
    fi
    kill "$burp_pid"
    rm -r "$(find /tmp/burp*.tmp -type d -printf '%T+ %p\n' | sort | head -n 1 | cut -d ' ' -f2)"  # Remove burp tmp files
    logger_success 'CA trusted successfully'
  fi
}

function install_secator() {
  echo "[*] Installing Secator"

  pipx install secator
}

function install_unfurl() {
  echo "[*] Installing Unfurl"

  go install github.com/tomnomnom/unfurl@latest

  asdf reshim golang
}

function install_vulnx() {
  echo "[*] Installing Vulnx"

  asdf set golang 1.23.0

  go install -v github.com/projectdiscovery/cvemap/cmd/vulnx@latest

  asdf reshim golang
}

function install_tlsx() {
  echo "[*] Installing Tlsx"

  asdf set golang 1.26.1

  go install -v github.com/projectdiscovery/tlsx/cmd/tlsx@latest

  asdf reshim golang
}

function install_urlfinder() {
  echo "[*] Installing Urlfinder"

  asdf set golang 1.23.0

  go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest

  asdf reshim golang
}

function install_mapcidr() {
  echo "[*] Installing Mapcidr"

  asdf set golang 1.26.1

  go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

  asdf reshim golang
}

function install_yq_go() {
  echo "[*] Installing Yq-go"
  VERSION=v4.48.1
  PLATFORM=linux_amd64
  wget "https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${PLATFORM}" -O /opt/tools/bin/yq-go
  chmod +x /opt/tools/bin/yq-go
}

function install_gum() {
  echo "[*] Installing Gum"

  asdf set golang 1.23.0

  go install -v github.com/charmbracelet/gum@latest

  asdf reshim golang
}

function install_anew() {
  echo "[*] Installing Anew"

  go install -v github.com/tomnomnom/anew@latest

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
}

function install_web-server() {
  echo "[*] Installing Web-server"
  uv tool install git+https://github.com/lap1nou/web-server --force
}

function install_rofi() {
    echo "[*] Installing Rofi"
    mkdir ~/.config/rofi/
    cp /opt/my-resources/setup/rofi/config.rasi ~/.config/rofi/
}

function install_uv() {
    echo "[*] Installing uv"
    pipx install uv
}

function install_vscode() {
    echo "[*] Installing VSCode"
    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O code.deb
    dpkg -i code.deb
    rm -f code.deb

    echo "[*] Installing VSCode extensions"
    code --no-sandbox --user-data-dir "/root" --install-extension MS-SarifVSCode.sarif-viewer
}

function install_wscat() {
  echo "[*] Installing Wscat"

  git clone https://github.com/websockets/wscat.git
  cd ./wscat
  git checkout 2509d02c3ef9093b00356c9cf688d1aa089914e1
  rm -f .npmrc
  npm install . -g
  rm -rf /workspace/wscat
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