{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    grc.enable = lib.mkEnableOption "enables grc";
  };

  config = lib.mkIf config.grc.enable {
    environment.systemPackages = with pkgs; [
      grc
    ];
  };
}
