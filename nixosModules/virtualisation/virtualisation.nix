{
  pkgs,
  lib,
  config,
  ...
}:
let
  vagrant-vmware-utility = pkgs.buildGoModule rec {
    name = "vagrant-vmware-utility";
    version = "1.0.23";

    src = pkgs.fetchFromGitHub {
      owner = "hashicorp";
      repo = "vagrant-vmware-desktop";
      rev = "utility-v${version}";
      sha256 = "sha256-D/2sNU7iyzTKD+/JlauDl2cBaKGoRrSYynlU3+iQYyo=";
    };

    patches = [ ./fix_paths.patch ];

    vendorHash = "sha256-Z/5rruRoar2HcFpeZCMo/YM6yo1pL+0oUJ4AKT4YKa0=";

    nativeBuildInputs = [ pkgs.installShellFiles ];

    # I'm using a login shell in the "ExecStart", because the patched binary is calling binary without absolute path,
    # so paths in the binary rely on $PATH env variable, if we are not using a login shell, the service can't find the binary "vmware-vmx" for example.

    postInstall = ''
      mkdir -p $out/lib/systemd/system
      cat << EOF > $out/lib/systemd/system/vagrant-vmware-utility.service
          [Unit]
          Description=vagrant-vmware-utility

          [Service]
          Type=simple
          User=root
          Group=root
          Restart=on-failure
          ExecStart=${pkgs.bash}/bin/bash -lc '$out/bin/vagrant-vmware-utility api'

          [Install]
          WantedBy=multi-user.target
      EOF
      chmod 0644 $out/lib/systemd/system/vagrant-vmware-utility.service
    '';
  };
in
{
  options = {
    virtualisation.enable = lib.mkEnableOption "enables virtualisation";
  };

  config = lib.mkIf config.virtualisation.enable {
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

    systemd.packages = [ vagrant-vmware-utility ];

    # Reference: https://www.reddit.com/r/NixOS/comments/1aszsj6/vmware_doesnt_follow_gtk_theme_in_hyprland/
    home-manager.users.lapinou.home.file = {
      ".local/share/applications/vmware-workstation.desktop" = {
        text = ''
          [Desktop Entry]
          Encoding=UTF-8
          Name=VMware Workstation
          Comment=Run and manage virtual machines
          Exec=env GTK_THEME=Adwaita-dark ${pkgs.vmware-workstation}/bin/vmware %U
          Terminal=false
          Type=Application
          Icon=vmware-workstation
          StartupNotify=true
          Categories=System;
          MimeType=application/x-vmware-vm;application/x-vmware-team;application/x-vmware-enc-vm;x-scheme-handler/vmrc;
        '';
      };
    };

    users.groups.docker.members = [ "lapinou" ];
  };
}
