{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    office.enable = lib.mkEnableOption "enables office";
  };

  config = lib.mkIf config.office.enable {
    environment.systemPackages = with pkgs; [
      planify
      drawio
      flameshot
      obsidian
    ];
  };
}
