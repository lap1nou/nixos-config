# Basic utility

{ pkgs, ... }:

{
  imports = [
    ./firefox.nix
  ];
  environment.systemPackages = with pkgs; [ 
    (writeShellScriptBin "htb-new" (builtins.readFile ../alias/htb-new.sh))
    (writeShellScriptBin "pentest-new" (builtins.readFile ../alias/pentest-new.sh))
    (writeShellScriptBin "exegol-start" (builtins.readFile ../alias/exegol-start.sh))
    (writeShellScriptBin "rofi-exegol-start" (builtins.readFile ../alias/rofi-exegol-start.sh))
    (writeShellScriptBin "change-wallpaper" (builtins.readFile ../alias/change-wallpaper.sh))
    ascii
    alsa-utils # CLI to manage sound
    # bat: installed in home.nix
    brightnessctl
    chafa
    (catppuccin-sddm.override {
      flavor = "mocha";
      font  = "Noto Sans";
      fontSize = "9";
      background = "${./awesome/themes/1/wallpaper.jpg}";
      loginBackground = true;
    })
    devbox
    dig
    discord
    efitools
    exegol
    eza
    feh # Image viewer
    file
    flameshot
    fzf
    # git: installed in home.nix
    gum
    home-manager 
    htop
    imhex
    jq
    keepassxc
    nemo # File manager
    networkmanagerapplet # GUI manage network connections
    # ncdu
    moreutils
    obsidian
    openssl
    openvpn
    pavucontrol # GUI manage sound
    peazip
    picom
    # rofi: installed in home.nix
    semgrep
    spotify
    tlrc # Man page for program, use 'tldr $COMMAND'
    traceroute
    unzip
    vlc
    wget
    wireshark
    xorg.xhost # For Exegol GUI application
    xclip
    yq-go
    zip
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        ms-python.python
        ms-azuretools.vscode-docker
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        charliermarsh.ruff
        #enkia.tokyo-night
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "sarif-viewer";
          publisher = "MS-SarifVSCode";
          version = "3.4.2";
          sha256 = "sha256-HDuDelX9kCK58Re8aTlKP+EJi4fSm5lejXsvxlMXRxM=";
        }
        {
          name = "devbox";
          publisher = "jetpack-io";
          version = "0.1.6";
          sha256 = "sha256-cPlMZzF3UNVJCz16TNPoiGknukEWXNNXnjZVMyp/Dz8=";
        }
      ];
    })
  ];

}
