{ config, lib, pkgs, home-manager, pythonOlder, ... }:

# Get AwesomeWM from Git directly as the NixOS version is really old
let
  awesome = pkgs.awesome.overrideAttrs (oa: {
    version = "0f950cbb625175134b45ea65acdf29b2cbe8c456";
    src = pkgs.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "0f950cbb625175134b45ea65acdf29b2cbe8c456";
      hash = "sha256-GIUkREl60vQ0cOalA37sCgn7Gv8j/9egfRk9emgGm/Y=";
    };

    patches = [ ];

    postPatch = ''
      patchShebangs tests/examples/_postprocess.lua
    '';
  });
in
{

  boot = {
    loader.grub = {
      enable = true;
      device = "nodev";
      # https://discourse.nixos.org/t/configure-grub-on-efi-system/2926/9, only for VM
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    loader.efi.canTouchEfiVariables = false;

    # Store "/tmp" folder in RAM
    tmp.useTmpfs = true;
  };

  networking = {
    hostName = "pentest";
    networkmanager.enable = true;
    firewall.enable = false;
    # Wireguard interface for Ludus lab
    wireguard.enable = true;
    # Reference: https://alberand.com/nixos-wireguard-vpn.html
    wireguard.interfaces = {
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [ "198.51.100.2/32" ];
        listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

        privateKeyFile = "/etc/wg_ludus.key";

        peers = [
          # For a client configuration, one peer entry for the server will suffice.

          {
            # Public key of the server (not a file path).
            publicKey = "Bd1iTeoQsdDUUFUmf0IVvEr7tQOkzuqMwxWfZMSy7B0=";

            # Forward all the traffic via VPN.
            allowedIPs = [ "10.2.0.0/16" "198.51.100.1/32" ];

            # Set this to the server IP and port.
            endpoint = "192.168.100.76:51820";

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # Enable compression on the RAM swap file
  zramSwap.enable = true;

  # Clean folders older than 30D in the ".cache" folder of users
  systemd.user.tmpfiles.rules = ["e %C - - - ABCM:30d -"]; # Type Path Mode User Group Age Argument…

  users = { 
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      hashedPassword = "$y$j9T$luaplVK4AN84DU/RvA52T1$HSLIXpC.Cjy9NMOqunUE0DgtIm0pSgFV.oT3Q8BTAzA"; # root
    };

    users.lapinou = {
      isNormalUser = true;
      home = "/home/lapinou";
      description = "lapinou";
      hashedPassword = "$y$j9T$luaplVK4AN84DU/RvA52T1$HSLIXpC.Cjy9NMOqunUE0DgtIm0pSgFV.oT3Q8BTAzA"; # root
      extraGroups = [
        "networkmanager"
        "wheel"
        "realtime"
        "audio"
        "jackaudio"
        "docker"
        "qemu"
        "libvirtd"
        "wireshark"
      ];
    };
  };

  virtualisation = {
    vmware.guest.enable = true;
    docker.enable = true;
    vmware.host.enable = true;

    # Not enabled because there is no way to check progress
    #oci-containers = {
    #  backend = "docker";
    #  containers = {
    #    test = {
    #      image = "nwodtuhs/exegol:full";
    #    };
    #  };
    #};
  };

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  # Reference: https://discourse.nixos.org/t/pull-docker-image-for-later-use/52106/6
  systemd.services.docker-preload = {
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ config.virtualisation.docker.package ];
    script = ''
      docker load -i ${pkgs.dockerTools.pullImage {
        imageName = "tenable/nessus";
        imageDigest = "sha256:1aaf1a0a7ef760412386cdec56273bdc3ec73c48cf32aacb75d5fb8d6676c30a";
        sha256 = "8FF/Mfov3MWV1OG8ZXlALTa9R7UrEEFplKztrkp7nQk=";
        finalImageName = "nessus";
        finalImageTag = "10.8.3-ubuntu";
      }}
    '';
    serviceConfig = {
      RemainAfterExit = true;
      Type = "oneshot";
    };
  };

  services = {
    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    picom = {
      enable = true;
      backend = "glx";

      fade = true;
      inactiveOpacity = 0.9;
      fadeDelta = 4;

      # Source: https://github.com/lactua/dotfiles/blob/master/dots/picom/.config/picom/picom.conf
      settings = {
        shadow = true;
        shadow-radius = 10;
        shadow-opacity = .6;
        shadow-offset-x = -8;
        shadow-offset-y = -8;
        shadow-color = "#111111";
        shadow-exclude = [
          "name *= 'rofi'"
        ];

        fade-in-step = 0.028;
        fade-out-step = 0.028;

        inactive-opacity-override = true;
        active-opacity = 0.95;
        inactive-dim = 0;

        blur-method = "dual_kawase";
        blur-strength = 5;
        blur-background = true;
        blur-background-frame = false;
        blur-background-fixed = false;
        blur-kern = "3x3box";

        detect-rounded-corners = true;
        corner-radius = 15;
        rounded-corners-exclude = [ "class_g *= 'awesome'" ];

        wintypes = {
          dock = {animation = "slide-down";};
          toolbar = {animation = "slide-down";};
        };
      };
    };

    displayManager.sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
    };

    xserver = {
      enable = true;
      xkb.layout = "ch,fr";
      excludePackages = [ pkgs.xterm ];

      windowManager.awesome = {
        enable = true;
        package = awesome;

        luaModules = with pkgs.luaPackages; [
          luarocks
          luadbi-mysql
        ];
      };
    };

    upower.enable = true;
  };

  time.timeZone = "Europe/Berlin"; # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

  # https://nixos.wiki/wiki/Storage_optimization
  nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};
  nix.optimise.automatic = true;

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.droid-sans-mono
  ];

  environment = {
    sessionVariables = rec {
      ADW_DISABLE_PORTAL = 1;
      HTB_TOKEN = (builtins.readFile ./.htb_env);
      NAUTILUS_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
      GTK_CSD = "0"; # Disable GTK CSD (Client-side decoration) such as the mini close button on Firefox (that d'oesn't go well with Awesomewm for example) 
      QT_STYLE_OVERRIDE = "adwaita-dark"; # Source: https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523
    };
    pathsToLink = [ "/share/nautilus-python/extensions" ];
  };

  nixpkgs.config.allowUnfree = true;

  stylix.enable = true;
  stylix.image = ./pkgs/awesome/themes/1/wallpaper.jpg;
  stylix.polarity = "dark";
  stylix.targets.grub.useImage = true;

  # Pkgs
  programs.zsh = { # https://nixos.wiki/wiki/Zsh
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "agnoster";
      };

      shellAliases = {
        cat = "bat -p -P";
        pcat = "bat";
        l = "eza --icons=always -algh";
        ll = "eza --icons=always -algh";
        ls = "eza --icons=always -algh";
        xclip = "xclip -selection primary";
        update = "sudo nixos-rebuild switch";
        edit-config = "sudo code --no-sandbox --user-data-dir /root/ /etc/nixos/";
        nix-shell = "nix-shell --extra-experimental-features flakes";
      };
  };
  programs.dconf.enable = true; # https://discourse.nixos.org/t/error-gdbus-error-org-freedesktop-dbus-error-serviceunknown-the-name-ca-desrt-dconf-was-not-provided-by-any-service-files/29111
  programs.starship.enable = true;
  programs.wireshark.enable = true;
  programs.ssh = {
    startAgent = true;

    # Remember SSH passphrase for Github / Gitlab
    extraConfig = ''
      Host gitlab.com
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_rsa_gitlab

      Host github.com
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_rsa_github
    '';
  };

  # Shared folder VMWare
  #fileSystems."/mount/shared" = {
  #  device = ".host:/shared";
  #  fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  #  options = ["umask=22" "uid=1000" "gid=100" "allow_other" "defaults" "auto_unmount"];
  #};

  imports = [
      ./hardware-configuration.nix
      ./pkgs/basic.nix
      ./disko-config.nix
  ];

  # Custom pkgs for all users
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  system.stateVersion = "24.11";
}
