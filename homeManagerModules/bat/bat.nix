{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.bat.enable = lib.mkEnableOption "enables bat";
  };

  config = lib.mkIf config.homeManagerModules.bat.enable {
    programs.bat.enable = true;
  };
}
