{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    utils.enable = lib.mkEnableOption "enables utils";
  };

  config = lib.mkIf config.utils.enable {
    environment.systemPackages = with pkgs; [
      ascii
      chafa
      dig
      fzf
      imhex
      jq
      keepassxc
      openvpn
      peazip
      tlrc
      traceroute
      unzip
      wget
      xclip
      yq-go
      zip
    ];

    programs.wireshark.enable = true;

    users.users.lapinou = {
      extraGroups = [
        "wireshark"
      ];
    };
  };
}
