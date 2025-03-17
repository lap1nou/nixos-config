{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    fontsPkgs.enable = lib.mkEnableOption "enables fontsPkgs";
  };

  config = lib.mkIf config.fontsPkgs.enable {
    fonts.packages = [
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.droid-sans-mono
    ];
  };
}
