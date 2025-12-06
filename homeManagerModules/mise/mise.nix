{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homeManagerModules.mise.enable = lib.mkEnableOption "enables mise";
  };

  config = lib.mkIf config.homeManagerModules.mise.enable {
    programs.mise = {
      enable = true;
      globalConfig.settings = {
        paranoid = true;
        all_compile = false;
        experimental = true;
      };
    };
  };
}
