{
  self,
  config,
  lib,
  pkgs,
  pythonOlder,
  inputs,
  ...
}:
{
  shared_folder.enable = true;
  awesomewm.enable = true;
  htb-cli.enable = false;
  htop.enable = true;
  firefox.enable = true;
  wireguard.enable = false;
  optimization.enable = true;
  exegol.enable = true;
  fontsPkgs.enable = true;
  hardening.enable = true;
  localization.enable = true;
  nessus.enable = true;
  nixSettings.enable = true;
  ssh.enable = false;
  stylixConfig.enable = true;
  virtualisation.enable = true;
  alias.enable = true;
  phone_wifi.enable = false;

  # Pkgs
  utils.enable = true;
  nixosConfig.enable = true;
  system.enable = true;
  desktop.enable = true;
  office.enable = true;
  programming.enable = true;
  social.enable = true;
  pentesting.enable = true;
  nano.enable = true;
  nemo.enable = true;
  wireshark.enable = true;
  keepassxc.enable = true;
  bluetooth.enable = false;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  home-manager = {
    users.lapinou =
      { ... }:
      {
        imports = [ 
          ./home.nix
          #inputs.impermanence.homeManagerModules.impermanence
        ];
      };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.editor = false; # "Whether to allow editing the kernel command-line before boot. It is recommended to set this to false, as it allows gaining root access by passing init=/bin/sh as a kernel parameter."
    loader.efi.canTouchEfiVariables = false;
  };

  console = { # https://discourse.nixos.org/t/can-nixos-set-keyboard-for-grub-luks-password/29623/9
    earlySetup = true;
    useXkbConfig = true;
  };

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      hashedPassword = "$y$j9T$luaplVK4AN84DU/RvA52T1$HSLIXpC.Cjy9NMOqunUE0DgtIm0pSgFV.oT3Q8BTAzA"; # root
    };

    users.lapinou = {
      isNormalUser = true;
      #home = "/home/lapinou";
      description = "lapinou";
      hashedPassword = "$y$j9T$luaplVK4AN84DU/RvA52T1$HSLIXpC.Cjy9NMOqunUE0DgtIm0pSgFV.oT3Q8BTAzA"; # root
      extraGroups = [
        "networkmanager"
        "wheel"
        "realtime"
        "audio"
        "jackaudio"
      ];
    };
  };

  services = {
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha-lavender";
      package = pkgs.kdePackages.sddm;
    };

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
  };

  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ./variables.nix
  ];

  system.stateVersion = "24.11";
}
