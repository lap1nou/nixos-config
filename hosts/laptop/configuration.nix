{
  self,
  config,
  lib,
  pkgs,
  pythonOlder,
  ...
}:
{
  shared_folder.enable = false;
  awesomewm.enable = true;
  htb-cli.enable = true;
  htop.enable = true;
  firefox.enable = true;
  wireguard.enable = true;
  optimization.enable = true;
  exegol.enable = true;
  fontsPkgs.enable = true;
  hardening.enable = true;
  localization.enable = true;
  nessus.enable = true;
  nixSettings.enable = true;
  ssh.enable = true;
  stylixConfig.enable = true;
  virtualisation.enable = true;
  alias.enable = true;

  # Pkgs
  utils.enable = true;
  nixosConfig.enable = true;
  system.enable = true;
  desktop.enable = true;
  office.enable = true;
  programming.enable = true;
  social.enable = true;
  pentesting.enable = true;
  nemo.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  home-manager = {
    users.lapinou =
      { ... }:
      {
        imports = [ ./home.nix ];
      };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.editor = false; # "Whether to allow editing the kernel command-line before boot. It is recommended to set this to false, as it allows gaining root access by passing init=/bin/sh as a kernel parameter."
    loader.efi.canTouchEfiVariables = false;
  };

  networking = {
    hostName = "pentest";
    networkmanager = {
      enable = true;
      ensureProfiles.profiles = {
        phone-wifi = {
          connection = {
            id = "Phone WiFi";
            type = "wifi";
          };

          wifi = {
            mode = "infrastructure";
            ssid = "WE-C423";
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = builtins.readFile (self.outPath + "./secrets/.phone_wifi");
          };
        };
      };
    };
  };

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

  services = {
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
  };

  programs.dconf.enable = true; # https://discourse.nixos.org/t/error-gdbus-error-org-freedesktop-dbus-error-serviceunknown-the-name-ca-desrt-dconf-was-not-provided-by-any-service-files/29111
  programs.wireshark.enable = true;

  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  system.stateVersion = "24.11";
}
