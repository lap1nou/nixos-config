{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    social.enable = lib.mkEnableOption "enables social";
  };

  config = lib.mkIf config.social.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
