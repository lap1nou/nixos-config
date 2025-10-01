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
  shared_folder.enable = false;
  awesomewm.enable = true;
  htb-cli.enable = false;
  htop.enable = true;
  firefox.enable = true;
  wireguard.enable = true;
  optimization.enable = true;
  exegol.enable = false;
  fontsPkgs.enable = true;
  hardening.enable = true;
  localization.enable = true;
  nessus.enable = true;
  nixSettings.enable = true;
  ssh.enable = true;
  stylixConfig.enable = true;
  virtualisation.enable = true;
  alias.enable = true;
  phone_wifi.enable = true;

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
  wireshark.enable = true;
  keepassxc.enable = true;

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
      theme = "catppuccin-mocha";
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

  #boot.initrd.systemd.enable = true;
  #boot.initrd.systemd.services.clean-btrfs = {
  #  wantedBy = [ "initrd.target" ];
  #  after = [ "systemd-cryptsetup@cryptroot.service" ];
  #  before = [ "sysroot.mount" ];
  #  unitConfig.DefaultDependencies = "no";
  #  serviceConfig.Type = "oneshot";
  #  script = ''
  #    mkdir /btrfs_tmp
  #    mount /dev/mapper/cryptroot /btrfs_tmp
  #    if [[ -e /btrfs_tmp/root ]]; then
  #        mkdir -p /btrfs_tmp/old_roots
  #        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #    fi
#
  #    delete_subvolume_recursively() {
  #        IFS=$'\n'
  #        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #            delete_subvolume_recursively "/btrfs_tmp/$i"
  #        done
  #        btrfs subvolume delete "$1"
  #    }
#
  #    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #        delete_subvolume_recursively "$i"
  #    done
#
  #    btrfs subvolume create /btrfs_tmp/root
  #    umount /btrfs_tmp
  #  '';
  #};

  #fileSystems."/persistent".neededForBoot = true;

#environment.persistence."/persistent" = {
#    enable = true;
#    hideMounts = true;
#    directories = [
#      "/var/log"
#      "/var/lib/bluetooth"
#      "/var/lib/nixos"
#      "/var/lib/systemd/coredump"
#      "/etc/NetworkManager/system-connections"
#      "/etc/nixos"
#    ];
#    files = [
#      "/etc/machine-id"
#    ];
#    users.lapinou = {
#      directories = [
#      "Downloads"
#      "Music"
#      "Pictures"
#      "Documents"
#      "Videos"
#      "Desktop"
#      ".ssh"
#      ".exegol"
#      ".mozilla"
#      ".config"
#      ".vscode"
#      ".vmware"
#      "programming"
#    ];
#    files = [
#      ".zsh_history"
#      ".zshenv"
#      ".zshrc"
#    ];
#    };
#  };

  system.stateVersion = "24.11";
}
