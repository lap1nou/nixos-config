{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.stylix.enable = lib.mkEnableOption "enables stylix";
  };

  config = lib.mkIf config.homeManagerModules.stylix.enable {
    stylix.enable = true;
    stylix.polarity = "dark";
  };
}
