{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    wireshark.enable = lib.mkEnableOption "enables wireshark";
  };

  config = lib.mkIf config.wireshark.enable {
    environment.systemPackages = with pkgs; [
      wireshark
    ];

    programs.wireshark.enable = true;
    users.groups.wireshark.members = [ "lapinou" ];
  };
}
