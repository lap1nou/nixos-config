LOG_FILE="/tmp/setup_log.txt"

# Root my-resources PATH
MY_ROOT_PATH="/opt/my-resources"

# Setup directory for user customization
MY_SETUP_PATH="$MY_ROOT_PATH/setup"

# file, hash
function check_hash() {
  if [[ "$(sha256sum $1 | cut -d ' ' -f 1)" != "$2" ]]; then
    echo '[-] Hash verification failed !'
    return 1
  fi
}

function install_starship() {
  echo "[*] Installing Starship"
  local VERSION="1.27.0"
  local HASH="10c8eb4cb3b761d9bf59ea828444c2dab36c900b7d69a69e08814b286969df89"

  wget -q "https://github.com/starship/starship/releases/download/v${VERSION}/starship-x86_64-unknown-linux-musl.tar.gz" -O "/tmp/starship.tar.gz"
  check_hash "/tmp/starship.tar.gz" "$HASH" || { rm "/tmp/starship.tar.gz"; return 1; }
  tar -zxf "/tmp/starship.tar.gz" --directory "/tmp/"
  mv "/tmp/starship" "/opt/tools/bin/"
  rm -rf "/tmp/starship.tar.gz"

  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  cp /opt/my-resources/setup/zsh/starship.toml ~/.config/starship.toml
  # Removing the Exh hook since Starship is taking care of everything
  sed -i -e 's/add-zsh-hook precmd update_prompt/#add-zsh-hook precmd update_prompt/g' ~/.zshrc
}

function install_atuin() {
  echo "[*] Installing Atuin"
  local VERSION="18.24.8"
  local HASH="f8dfc3f9d27cadc2e2c9d489394ef7c568291e2382a4d184865701bf1a4ac30a"

  wget -q "https://github.com/atuinsh/atuin/releases/download/v${VERSION}/atuin-x86_64-unknown-linux-musl.tar.gz" -O "/tmp/atuin.tar.gz"
  check_hash "/tmp/atuin.tar.gz" "$HASH" || { rm "/tmp/atuin.tar.gz"; return 1; }
  tar -zxf "/tmp/atuin.tar.gz" --directory "/tmp/"
  mv "/tmp/atuin-x86_64-unknown-linux-musl/atuin" "/opt/tools/bin/"
  rm -rf "/tmp/atuin.tar.gz" "/tmp/atuin-x86_64-unknown-linux-musl/"

  echo 'eval "$(atuin init zsh)"' >> ~/.zshrc
  cp /opt/my-resources/setup/atuin/config.toml ~/.config/atuin/config.toml
  atuin import zsh
}

function install_obsidian() {
  echo "[*] Installing Obsidian"
  local VERSION="1.15.1"
  local HASH="f77b6dfc8c040214f2febad2b1b9b051b6a838a47b0f4fb90a31cfcb79b8fcec"
  local ARTIFACT_PATH="/tmp/obsidian.deb"

  wget -q "https://github.com/obsidianmd/obsidian-releases/releases/download/v${VERSION}/obsidian_${VERSION}_amd64.deb" -O "$ARTIFACT_PATH"
  check_hash "$ARTIFACT_PATH" "$HASH" || { rm "$ARTIFACT_PATH"; return 1; }
  dpkg -i "$ARTIFACT_PATH"
  rm "$ARTIFACT_PATH"

  # Copy Obsidian template
  cp -R /opt/my-resources/setup/obsidian/notes/ /workspace/notes/
}

function config_burpsuite() {
  echo "[*] Configure Burpsuite"
  local JYTHON_VERSION="2.7.4"
  local JRUBY_VERSION="9.4.12.0"
  local JYTHON_HASH="1fba1769effcc8b19f5e10436bc8274a158ce988559f257927c24c73bb137f3c"
  local JRUBY_HASH="afb903dc9d38843fed4961cdb63489a78d1b1783f5766acb5bc89f5fc720ed21"

  echo "[*] Install Jython"
  mkdir /opt/tools/BurpSuiteCommunity/jython
  wget -q "https://repo1.maven.org/maven2/org/python/jython-standalone/${JYTHON_VERSION}/jython-standalone-${JYTHON_VERSION}.jar" -O "/opt/tools/BurpSuiteCommunity/jython/jython-standalone.jar"
  check_hash "/opt/tools/BurpSuiteCommunity/jython/jython-standalone.jar" "$JYTHON_HASH" || { rm "/opt/tools/BurpSuiteCommunity/jython/jython-standalone.jar"; return 1; }

  echo "[*] Install Jruby"
  mkdir /opt/tools/BurpSuiteCommunity/jruby
  wget -q https://repo1.maven.org/maven2/org/jruby/jruby-complete/${JRUBY_VERSION}/jruby-complete-${JRUBY_VERSION}.jar -O "/opt/tools/BurpSuiteCommunity/jruby/jruby-standalone.jar"
  check_hash "/opt/tools/BurpSuiteCommunity/jruby/jruby-standalone.jar" "$JRUBY_HASH" || { rm "/opt/tools/BurpSuiteCommunity/jruby/jruby-standalone.jar"; return 1; }

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
  local HASH="8f10d050f1b0be12e505053da174f3f39e8eed74"

  go install github.com/tomnomnom/unfurl@$HASH

  asdf reshim golang
}

function install_yq_go() {
  echo "[*] Installing Yq-go"
  local VERSION=v4.53.6
  local PLATFORM=linux_amd64
  wget -q "https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${PLATFORM}" -O /opt/tools/bin/yq-go
  chmod +x /opt/tools/bin/yq-go
}

function install_exegol-history() {
  echo "[*] Installing Exegol-History"
  rm -rf /opt/tools/Exegol-history/
  uv tool install git+https://github.com/ThePorgs/Exegol-history@dev --force
  register-python-argcomplete exegol-history >> ~/.zshrc
  # Copy profile.sh
  wget -q https://raw.githubusercontent.com/ThePorgs/Exegol-history/refs/heads/dev/profile.sh -O /root/.local/share/uv/tools/exegol-history/lib/python3.11/site-packages/profile.sh

  # Copy config and enable nxc sync
  mkdir -p ~/.exegol_history/
  wget -q https://raw.githubusercontent.com/ThePorgs/Exegol-history/refs/heads/dev/exegol_history/config/config.toml -O ~/.exegol_history/config.toml
  yq-go -i '.sync.netexec.enabled = true' ~/.exegol_history/config.toml
}

function genpass(){
  # Reference: https://unix.stackexchange.com/a/230676
  tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 13; echo
}

function install_web-server() {
  echo "[*] Installing Web-server"
  uv tool install git+https://github.com/lap1nou/web-server --force
  # Config
  mkdir "~/.webserver_tui/"
  cp "/opt/my-resources/setup/web-server/config.toml" ~/.webserver_tui/
  yq-go -i ".profiles.updog_workspace.password = \"`genpass`\"" ~/.webserver_tui/config.toml
  yq-go -i ".profiles.updog_resources.password = \"`genpass`\"" ~/.webserver_tui/config.toml
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
  local VERSION="1.5.29"
  local HASH="e9bfa05430bca0efcf26e5a0f06d09b9da8cc21de2e0ffab03f512dde649ebbe"
  local ARTIFACT_PATH="/tmp/install-safe-chain.sh"

  wget -q "https://github.com/AikidoSec/safe-chain/releases/download/${VERSION}/install-safe-chain.sh" -O "$ARTIFACT_PATH"
  check_hash "$ARTIFACT_PATH" "$HASH" || { rm "$ARTIFACT_PATH"; return 1; }
  chmod +x "$ARTIFACT_PATH"
  "$ARTIFACT_PATH"
  rm -f "$ARTIFACT_PATH"
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
  local HASH="b27111e78b17e7c6eb4f7af89fecef25e3fa6841"

  cargo install --git https://github.com/asciinema/agg --rev "$HASH"
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
    local HASH="f6ea1137724fe80d5b27f4b4900df055c6cac4274a9f41e4e4005bd7ddd1dd4c"
    local ARTIFACT_PATH="/tmp/dbeaver.deb"

    wget -q "https://github.com/dbeaver/dbeaver/releases/download/$VERSION/dbeaver-ce-$VERSION-linux-x86_64.deb" -O "$ARTIFACT_PATH"
    check_hash "$ARTIFACT_PATH" "$HASH" || { rm "$ARTIFACT_PATH"; return 1; }
    dpkg -i "$ARTIFACT_PATH"
    rm -f "$ARTIFACT_PATH"
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
  local VERSION="2.1.325"
  local HASH="0dc4f4a9a165fc60746d7ae8489712e5fc352f1e7ad4eb22e7141bd0812eb0cf"
  local ARTIFACT_PATH="/tmp/claude"

  wget -q "https://downloads.claude.ai/claude-code-releases/$VERSION/linux-x64/claude" -O "$ARTIFACT_PATH"
  check_hash "$ARTIFACT_PATH" "$HASH" || { rm "$ARTIFACT_PATH"; return 1; }
  chmod +x "$ARTIFACT_PATH"
  "$ARTIFACT_PATH"
  rm -f "$ARTIFACT_PATH"
}

function install_nfs_tools {
	echo "[*] Installing NFS tool (https://github.com/hvs-consulting/nfs-security-tooling)"
	apt install pkg-config libfuse3-dev python3-dev
	pipx install git+https://github.com/hvs-consulting/nfs-security-tooling.git
}

function install_nfsshell-ng {
  echo "[*] Installing nfsshell-ng"
  git -C /tmp clone --depth 1 https://github.com/lap1nou/nfsshell.git
  cd /tmp/nfsshell || exit
  make -j
  mv nfsshell /opt/tools/bin/nfsshell-ng
}

function install_ilspy {
  echo "[*] Installing ILSpy"
  local VERSION="11.1.0.9782"
  local VERSION2="11.1"
  local HASH="726696d5a62146daf627d06d255fa3c18253f633b8615f48b31382ae88ef5141"
  local ARTIFACT_PATH="/tmp/ilspy.deb"

  wget -q "https://github.com/icsharpcode/ILSpy/releases/download/v$VERSION2/ilspy_$VERSION-1_amd64.deb" -O "$ARTIFACT_PATH"
  check_hash "$ARTIFACT_PATH" "$HASH" || { rm "$ARTIFACT_PATH"; return 1; }
  dpkg -i "$ARTIFACT_PATH"
  rm -f "$ARTIFACT_PATH"
}

function install_ilspy_cmd {
  echo "[*] Installing ILSpycmd"
  local VERSION="11.2.0.10050"

  # Installing .NET 10.0 SDK
  wget -O /tmp/dotnet-install.sh https://dot.net/v1/dotnet-install.sh
  chmod +x /tmp/dotnet-install.sh
  /tmp/dotnet-install.sh --channel 10.0
  dotnet tool install --global ilspycmd --version "$VERSION"
  rm -f /tmp/dotnet-install.sh
}

function flip-foxyproxy {
	local actual_value=$(yq-go '.policies.3rdparty.Extensions."foxyproxy@eric.h.jung".data[0].active' /usr/lib/firefox-esr/distribution/policies.json)

	if [ "$actual_value" = "true" ]; then
		echo "Disabling BurpSuite proxy."
	else
		echo "Enabling BurpSuite proxy."
	fi

	yq-go '.policies.3rdparty.Extensions."foxyproxy@eric.h.jung".data[0].active = (.policies.3rdparty.Extensions."foxyproxy@eric.h.jung".data[0].active | not)' /usr/lib/firefox-esr/distribution/policies.json -i
}

function install_azurehound {
  echo "[*] Installing AzureHound"
  local VERSION="v3.1.3"
  wget -O /tmp/azurehound.zip "https://github.com/SpecterOps/AzureHound/releases/download/${VERSION}/AzureHound_${VERSION}_linux_amd64.zip"
  unzip /tmp/azurehound.zip -d /opt/tools/bin/
  rm -f /tmp/azurehound.zip
}

function install_pytune {
  echo "[*] Installing Pytune"
  local GIT_COMMIT="214760beab6fae8ae3d6ebfbad7d958196e2e631"
  git -C /opt/tools/ clone --depth 1 https://github.com/secureworks/pytune.git
  cd /opt/tools/pytune/ || exit
  git checkout "${GIT_COMMIT}"
  sed -i 's/colr//g' requirements.txt # Remove useless package
  python3 -m venv --system-site-packages ./venv
  source ./venv/bin/activate
  pip3 install -r requirements.txt
  deactivate
}

function install_findmeaccess {
  echo "[*] Installing FindMeAccess"
  local GIT_COMMIT="d14cf1bdd397a251ae3694870530840f1a738162"
  git -C /opt/tools/ clone --depth 1 https://github.com/absolomb/FindMeAccess.git
  cd /opt/tools/FindMeAccess/ || exit
  git checkout "${GIT_COMMIT}"
  python3 -m venv --system-site-packages ./venv
  source ./venv/bin/activate
  pip3 install -r requirements.txt
  deactivate
}

function install_WinSCPPasswdExtractor {
	echo "[*] Installing WinSCPPasswdExtractor"
	pipx install WinSCPPasswdExtractor
}

function install_gum {
  echo "[*] Installing Gum"
  local VERSION="2.0.2"
  wget -O /tmp/gum.deb https://github.com/charmbracelet/gum/releases/download/v${VERSION}/gum_${VERSION}_amd64.deb
  dpkg -i /tmp/gum.deb
  rm -f /tmp/gum.deb
}

function company-wordlist() {
  if ! command -v gum >/dev/null 2>&1; then
    echo "This script needs gum: https://github.com/charmbracelet/gum"
    exit 1
  fi

  RULE_PATH="/opt/my-resources/setup/hashcat/company.rule"
  ACCENT=212
  ERROR=196

  # Header
  gum style \
    --border double --border-foreground "$ACCENT" \
    --padding "1 4" --margin "1 0" --align center --bold \
    "🏢  Company wordlist generator" "Fill in the details below"

  # Company name (required)
  company=""
  while [[ -z "${company// /}" ]]; do
    company=$(gum input \
      --header "Company name (required)" --header.foreground "$ACCENT" \
      --placeholder "Acme Inc.") || exit 1
    if [[ -z "${company// /}" ]]; then
      gum style --foreground "$ERROR" "  Company name can't be empty."
    fi
  done

  # Skip checkbox
  skip=$(gum choose --no-limit \
    --header "Options (space to tick, enter to continue)" \
    --header.foreground "$ACCENT" \
    "Skip everything except the company name") || true

  street=""
  country=""
  notes=""

  if [[ -z "$skip" ]]; then
    street=$(gum input \
      --header "Street" --header.foreground "$ACCENT" \
      --placeholder "Streetname 12") || true

    country=$(gum input \
      --header "Country" --header.foreground "$ACCENT" \
      --placeholder "Germany") || true

    notes=$(gum write \
      --header "Notes (optional, Ctrl+D to finish, Esc to skip)" \
      --header.foreground "$ACCENT" \
      --placeholder "Anything else worth noting..." \
      --width 60 --height 8) || true
  fi

  # Output file
  slug=$(printf '%s' "$company" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//; s/-$//')
  outfile="${slug:-company}.txt"

  {
    echo "$company"
    if [[ -n "$street" ]];  then echo "$street";  fi
    if [[ -n "$country" ]]; then echo "$country"; fi
    if [[ -n "$notes" ]];   then printf '%s\n' "$notes"; fi
  } > "$outfile"

  gum spin --spinner dot --title "Saving..." -- sleep 0.6

  # Summary
  gum style \
    --border rounded --border-foreground "$ACCENT" \
    --padding "1 2" --margin "1 0" \
    "$(cat "$outfile")"

  gum style --foreground 42 --bold "✔ Saved to $outfile"

  hashcat --force $outfile -r ${RULE_PATH} --stdout > company_wordlist.txt
  realpath "company_wordlist.txt" | tr -d '\n' | xclip
  rm "$outfile"
}

function install_mise {
	echo "[*] Installing Mise"
	local VERSION="v2026.11.1"
	wget -q "https://github.com/jdx/mise/releases/download/$VERSION/mise-$VERSION-linux-x64" -O /opt/tools/bin/mise
	echo 'eval "$(/opt/tools/bin/mise activate zsh)"' >> "$HOME/.zshrc"
	source "$HOME/.zshrc"
}
